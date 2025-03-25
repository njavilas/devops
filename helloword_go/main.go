package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"os"
)

var serverName string

type Response struct {
	Message string `json:"message"`
	Server  string `json:"server"`
}

func helloHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("X-Server-Name", serverName)

	response := Response{
		Message: "Hello World",
		Server:  serverName,
	}

	json.NewEncoder(w).Encode(response)
}

func main() {
	serverName = os.Getenv("SERVER_NAME")

	if serverName == "" {
		serverName = "DefaultServer"
	}

	http.HandleFunc("/", helloHandler)

	port := "8080"

	fmt.Printf("Server running on port %s with name %s\n", port, serverName)

	http.ListenAndServe(":"+port, nil)
}
