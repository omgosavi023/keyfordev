echo "enter dir name"
read dir
mkdir $dir
cd $dir
clear
pwd
mkdir docker-compose-python-demo
cd docker-compose-python-demo
echo "print('hello')" > helloworld.py
cat helloworld.py

# 1. Corrected Dockerfile content
echo "
FROM python:3.9-slim-buster
WORKDIR /app
COPY helloworld.py .
CMD [\"python\",\"helloworld.py\"]
" > Dockerfile

# 2. Corrected docker-compose.yml content
echo "
version: '3.8'
services:
  python-hello-world:
    build: .
    container_name: hello-docker-compose
    command: [\"python\",\"helloworld.py\"]
" > docker-compose.yml

docker compose up
