package main

import (
	"github.com/gin-gonic/gin"
	"net/http"
	"log"
	"io/ioutil"
)

func main() {
	router := gin.Default()
	router.Use(gin.Logger())

	router.POST("/api/sentry", func(c *gin.Context) {

		body, err := ioutil.ReadAll(c.Request.Body)

		if err != nil {
			panic(err)
		}

		log.Print(string(body))

		c.JSON(http.StatusOK, gin.H{
			"status": true,
			"message": "ok",
		})
	})

	router.HEAD("/", func(c *gin.Context) {
		body, err := ioutil.ReadAll(c.Request.Body)

		if err != nil {
			panic(err)
		}

		log.Print(string(body))
	})

	router.Run("0.0.0.0:18080")
}
