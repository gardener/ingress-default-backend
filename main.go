// SPDX-FileCopyrightText: 2024 SAP SE or an SAP affiliate company and Gardener contributors
//
// SPDX-License-Identifier: Apache-2.0

package main

import (
	"fmt"
	"html/template"
	"log"
	"net/http"
	"os"
	"os/signal"
	"syscall"

	"github.com/gorilla/mux"
)

var templates = template.Must(template.ParseGlob("routes/*.html"))

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	router := mux.NewRouter()

	// routes
	router.HandleFunc("/", indexHandler).Methods("GET")
	router.HandleFunc("/healthy", healthyHandler).Methods("GET")

	// Serve static files from the "public" directory
	router.PathPrefix("/public/").Handler(http.StripPrefix("/public/", http.FileServer(http.Dir("public"))))
	router.Path("/public").Handler(http.StripPrefix("/public", http.FileServer(http.Dir("public"))))

	// error handler
	router.NotFoundHandler = http.HandlerFunc(notFoundHandler)

	server := &http.Server{
		Addr:    ":" + port,
		Handler: router,
	}

	fmt.Printf("Kubernetes backend started on port %s...\n", port)

	// handle SIGTERM signal for graceful shutdown
	sigCh := make(chan os.Signal, 1)
	signal.Notify(sigCh, os.Interrupt, syscall.SIGTERM)
	go func() {
		<-sigCh
		fmt.Println("Closing on SIGTERM...")
		err := server.Close()
		if err != nil {
			log.Fatal("Error closing server:", err)
		}
		fmt.Println("Server closed.")
	}()

	err := server.ListenAndServe()
	if err != nil && err != http.ErrServerClosed {
		log.Fatal("Error starting server:", err)
	}
}

func indexHandler(w http.ResponseWriter, r *http.Request) {
	renderTemplate(w, "index", http.StatusNotFound)
}

func healthyHandler(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	fmt.Fprint(w, "ok")
}

func notFoundHandler(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusNotFound)
	fmt.Fprint(w, "Not Found")
}

func renderTemplate(w http.ResponseWriter, tmpl string, status int) {
	w.WriteHeader(status)
	err := templates.ExecuteTemplate(w, tmpl+".html", nil)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}
