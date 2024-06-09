token=$1
docker run -idt --restart=always --name cloudflared  cloudflare/cloudflared:latest tunnel --no-autoupdate run --token $1
