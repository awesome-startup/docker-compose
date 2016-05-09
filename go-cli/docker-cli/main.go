package main

import (
	log "github.com/Sirupsen/logrus"
	"github.com/codegangsta/cli"
	"github.com/samalba/dockerclient"
	"os"
	"time"
)

// Callback used to listen to Docker's events
func eventCallback(event *dockerclient.Event, ec chan error, args ...interface{}) {
	log.Printf("Received event: %#v\n", *event)
}

func main() {
	app := cli.NewApp()
	app.Name = "docker-cli"
	app.Usage = "docker cli to deploy symfony project"
	app.Version = "0.1.1"
	app.Author = "Paul"
	app.Email = "paul@wizmacau.com"

	// Init the client
	docker, _ := dockerclient.NewDockerClient("unix:///var/run/docker.sock", nil)

	var host string
	app.Flags = []cli.Flag{
		cli.StringFlag{
			Name:        "host, o",
			Value:       "",
			Usage:       "virtual host name for symfony project",
			Destination: &host,
		},
	}

	app.Action = func(c *cli.Context) {
		println("Start Deploy!")
		if c.NArg() > 0 {
		}
		if host == "" {
			println("Please specify host name! --host")
		} else {
			println(host)
		}
	}

	if err := app.Run(os.Args); err != nil {
		log.Fatal(err)
	}

	// Get only running containers
	containers, err := docker.ListContainers(false, false, "")
	if err != nil {
		log.Fatal(err)
	}
	for _, c := range containers {
		log.Println(c.Id, c.Names)
	}

	// Inspect the first container returned
	if len(containers) > 0 {
		id := containers[0].Id
		info, _ := docker.InspectContainer(id)
		log.Println(info)
	}

	// Build a docker image
	// some.tar contains the build context (Dockerfile any any files it needs to add/copy)
	dockerBuildContext, err := os.Open("some.tar")
	defer dockerBuildContext.Close()
	buildImageConfig := &dockerclient.BuildImage{
		Context:        dockerBuildContext,
		RepoName:       "your_image_name",
		SuppressOutput: false,
	}
	reader, err := docker.BuildImage(buildImageConfig)
	if err != nil {
		log.Fatal(err)
	}
    println(reader)

	// Create a container
	containerConfig := &dockerclient.ContainerConfig{
		Image:       "ubuntu:14.04",
		Cmd:         []string{"bash"},
		AttachStdin: true,
		Tty:         true}
	containerId, err := docker.CreateContainer(containerConfig, "foobar", nil)
	if err != nil {
		log.Fatal(err)
	}

	// Start the container
	hostConfig := &dockerclient.HostConfig{}
	err = docker.StartContainer(containerId, hostConfig)
	if err != nil {
		log.Fatal(err)
	}

	// Stop the container (with 5 seconds timeout)
	docker.StopContainer(containerId, 5)

	// Listen to events
	docker.StartMonitorEvents(eventCallback, nil)

	// Hold the execution to look at the events coming
	time.Sleep(3600 * time.Second)

}
