# --- Étape 1 : Build ---
FROM golang:1.22-alpine AS builder
# On installe les outils de compilation de base
RUN apk add --no-cache git gcc musl-dev
WORKDIR /app
COPY . .
# On télécharge les dépendances
RUN go mod download
# ON COMPILE SANS SE TROMPER DE CHEMIN
# Si cmd/server/main.go existe, il le prendra, sinon il cherchera ailleurs
RUN go build -o ccnexus ./cmd/server/main.go || go build -o ccnexus ./main.go || go build -o ccnexus .

# --- Étape 2 : Runtime ---
FROM alpine:latest
RUN apk add --no-cache ca-certificates tzdata
WORKDIR /app

# On récupère UNIQUEMENT le binaire pour l'instant
COPY --from=builder /app/ccnexus .

# ON COPIE TOUT LE RESTE DU REPO (pour être sûr de ne rien oublier : config, resource, etc.)
COPY --from=builder /app/ .

# Port Railway
EXPOSE 3000

# On lance
CMD ["./ccnexus"]
