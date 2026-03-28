# On part d'une base Linux ultra-légère
FROM alpine:latest

# On installe curl pour télécharger le binaire
RUN apk add --no-cache curl tar ca-certificates

WORKDIR /app

# On télécharge la version Linux x64 de ccNexus (version stable 2026)
# NOTE : Remplace 'v1.x.x' par la version actuelle sur le GitHub si besoin
RUN curl -L https://github.com/lich0821/ccNexus/releases/latest/download/ccNexus-linux-amd64.tar.gz -o ccnexus.tar.gz \
    && tar -xzf ccnexus.tar.gz \
    && rm ccnexus.tar.gz \
    && chmod +x ccNexus

# On crée les dossiers nécessaires pour éviter les erreurs au démarrage
RUN mkdir -p config resource

# Port Railway
EXPOSE 3000

# On lance le binaire directement
CMD ["./ccNexus"]
