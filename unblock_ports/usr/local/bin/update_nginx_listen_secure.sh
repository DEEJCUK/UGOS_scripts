#!/bin/bash

# The file that needs to be monitored
CONFIG_FILE="/etc/nginx/ugreen_ssl_redirect.conf"

# The IPv4 config that needs to be replaced
SEARCH_LISTEN="listen 443 ssl;"
REPLACE_LISTEN="listen 8443 ssl;"

# The IPv6 config that needs to be replaced
SEARCH_LISTEN_IPV6="listen \[::\]:443 ssl;"
REPLACE_LISTEN_IPV6="listen \[::\]:8443 ssl;"

# Directory and command for restarting Docker Compose
DOCKER_COMPOSE_DIR="/volume1/docker_compose/traefik"
DOCKER_COMPOSE_CMD="sudo docker compose restart"

# Function to update listen directives
update_listen_directives() {
    local changed=false

    if grep -q "$SEARCH_LISTEN" "$CONFIG_FILE"; then
        echo "Updating IPv4 config..."
        sed -i "s/$SEARCH_LISTEN/$REPLACE_LISTEN/" "$CONFIG_FILE"
        changed=true
    fi

    if grep -q "$SEARCH_LISTEN_IPV6" "$CONFIG_FILE"; then
        echo "Updating IPv6 config..."
        sed -i "s/$SEARCH_LISTEN_IPV6/$REPLACE_LISTEN_IPV6/" "$CONFIG_FILE"
        changed=true
    fi

    if [ "$changed" = true ]; then
        echo "Changes detected."

        echo "Reloading nginx..."
        sudo systemctl reload nginx

        echo "Waiting for nginx to reload..."
        sleep 3

        echo "Restarting traefik..."
        (cd "$DOCKER_COMPOSE_DIR" && $DOCKER_COMPOSE_CMD)
    fi
}

# Initial update
update_listen_directives

# Listen to file changes
while inotifywait -e close_write "$CONFIG_FILE"; do
    echo "Detected changes in $CONFIG_FILE, updating listen directives..."
    update_listen_directives
done
