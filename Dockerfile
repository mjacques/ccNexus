FROM alpine:latest

# On installe les outils nécessaires
RUN apk add --no-cache curl tar ca-certificates libc6-compat

WORKDIR /app

# ÉTAPE CRUCIALE : On télécharge le binaire compilé par l'auteur
# On utilise la version Linux AMD64
RUN curl -L https://github.com/lich0821/ccNexus/releases/latest/download/ccNexus-linux-amd64.tar.gz -o ccnexus.tar.gz \
    && tar -xzf ccnexus.tar.gz \
    && rm ccnexus.tar.gz \
    && chmod +x ccNexus

# On crée les répertoires de travail
RUN mkdir -p resource config

# On expose le port
EXPOSE 3000

# Lancement
CMD ["./ccNexus"]
