azure_url=$1
azure_key=$2

docker run -d -p 5500:3000 \
   --restart=always \
   -e AZURE_URL=$1/openai/deployments/gpt-4o \
   -e AZURE_API_KEY=$2 \
   -e AZURE_API_VERSION=2024-05-01-preview \
   -e CUSTOM_MODELS=-all,+gpt-4o \
   yidadaa/chatgpt-next-web
