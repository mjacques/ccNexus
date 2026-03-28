# Étape 1 : Build du binaire Go
FROM golang:1.22-alpine AS builder
RUN apk add --no-cache git
WORKDIR /app
COPY . .
RUN go mod download
# On compile le binaire (le point d'entrée est souvent dans cmd/ ou main.go)
RUN go build -o ccnexus ./cmd/server/main.go

# Étape 2 : Image finale légère
FROM alpine:latest
RUN apk add --no-cache ca-certificates
WORKDIR /app

# On récupère le binaire
COPY --from=builder /app/ccnexus .

# IMPORTANT : On copie les fichiers de configuration et les assets statiques
# Si le repo a des dossiers 'config', 'public' ou 'web', il faut les inclure
COPY --from=builder /app/config ./config 
COPY --from=builder /app/resource ./resource

# Port par défaut de ccNexus
EXPOSE 3000

# Commande de lancement
CMD ["./ccnexus"]
