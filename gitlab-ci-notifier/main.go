package main

import (
	"bytes"
	"encoding/json"
	"flag"
	"fmt"
	"io"
	"net/http"
	"os"
)

type Users map[string]string

func readUserData(filename string) (Users, error) {
	file, err := os.Open(filename)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	byteValue, err := io.ReadAll(file)
	if err != nil {
		return nil, err
	}

	var users Users
	err = json.Unmarshal(byteValue, &users)
	if err != nil {
		return nil, err
	}

	return users, nil
}

func main() {

	messageFlag := flag.String("message", "", "Mensaje de notificación para Discord")
	userDataFileFlag := flag.String("user_data", "user_data.json", "Ruta al archivo JSON con los usuarios")

	flag.Parse()

	users, err := readUserData(*userDataFileFlag)

	if err != nil {
		fmt.Printf("Error al leer el archivo JSON: %v\n", err)
		return
	}

	gitlabUser := os.Getenv("GITLAB_USER_LOGIN")
	webhookURL := os.Getenv("DISCORD_WEBHOOK_URL")

	if webhookURL == "" {
		fmt.Println("Error: DISCORD_WEBHOOK_URL no está definido.")
		return
	}

	userID, exists := users[gitlabUser]

	if !exists {
		fmt.Println("Error: Usuario no encontrado en la lista.")
		return
	}

	message := fmt.Sprintf("%s <@%s>", *messageFlag, userID)

	payload := map[string]string{"content": message}

	jsonData, err := json.Marshal(payload)

	if err != nil {
		fmt.Println("Error al generar JSON:", err)
		return
	}

	resp, err := http.Post(webhookURL, "application/json", bytes.NewBuffer(jsonData))

	if err != nil {
		fmt.Println("Error al enviar mensaje a Discord:", err)
		return
	}

	defer resp.Body.Close()

	fmt.Println("Notificación enviada con éxito a Discord!")
}
