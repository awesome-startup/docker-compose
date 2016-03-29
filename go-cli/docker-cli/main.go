package main

import (
  "os"
  "github.com/codegangsta/cli"
)

func main() {
  app := cli.NewApp()
  app.Name = "docker-cli"
  app.Usage = "docker cli to deploy symfony project"
  app.Version = "0.1.1"
  var host string
  
  app.Flags = []cli.Flag {
      cli.StringFlag {
        Name: "host, o",
        Value: "",
        Usage: "virtual host name for symfony project",
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

  app.Run(os.Args)
}