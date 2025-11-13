!/bin/bash

echo "perform docker login before this script [cmd : Docker login]"

echo "Enter image name you want to create"
printf "1.Python \n2.Java \n3.C \n4.SQL \n5.BASH\n"
read img

function dockerpush() {
echo "Do you want to push it to docker hub"
read choice

if [[ $choice == 'y' ]];then
docker login
echo "Enter username"
read uname
docker tag  $1 $uname/$1:1.0
docker push $uname/$1:1.0
else 
echo "exiting..."
fi
}

function python() {
echo "Provide a directory name"
read dt
mkdir $dt
cd $dt
pwd
echo "print ('Hello')" > hello.py
echo "
FROM python:3.9-slim-buster
WORKDIR /app
COPY hello.py .
CMD [\"python\",\"hello.py\"]
" > Dockerfile
echo "give name of image"
read imgname
clear
echo "creating image... "
sudo docker build -t $imgname .
#echo "to run enter [docker run -dit <imagename>]"
sudo docker run -it $imgname
dockerpush $imgname
}

function java() {
echo "Provide a directory name"
read dt
mkdir $dt
cd $dt
pwd
echo "creating java file"
echo "
public class HelloWorld {
    public static void main(String[] args) {
        System.out.println(\"Hello, World! from Java\");
    }
}
" > HelloWorld.java
echo "creating java docker"
echo "
FROM eclipse-temurin:17-jdk-focal AS build
WORKDIR /src
COPY HelloWorld.java .
RUN javac HelloWorld.java

FROM eclipse-temurin:17-jre-focal
WORKDIR /app
COPY --from=build /src/HelloWorld.class .
CMD [\"java\", \"HelloWorld\"]
" > Dockerfile

echo "Enter a image name"
read imgname
clear
echo "creating image..."
sudo docker build -t $imgname .
echo "running image..."
sudo docker run -it $imgname
dockerpush $imgname
}
function c() {
echo "Enter a directory name "
read dirname
mkdir $dirname
cd  $dirname
pwd
echo "
#include<stdio.h>
int main() {
printf(\"Hello from C\");
}
" > hello.c

echo "
FROM gcc:latest AS build
WORKDIR  /app
COPY hello.c .
RUN gcc hello.c -o hello
CMD [\"./hello\"]
" > Dockerfile
echo "Enter image name"
read imgname
clear
echo "creating image..."
sudo docker build -t $imgname .
echo "running image..."
sudo docker run -it $imgname
dockerpush $imgname
}

function sql(){
echo "Enter a directory name"
read dirname
mkdir $dirname
cd $dirname
pwd
echo "Provide a sql root password"
read rootpass
echo "Provide a database name"
read dbname
echo "Provide a container name"
read cname
sudo docker run -d --name $cname -e MYSQL_ROOT_PASSWORD=$rootpass -e MYSQL_DATABASE=$dbname -v mysql-data:/var/lib/mysql -p 3306:3306 mysql:8
sudo docker exec -it $cname mysql -uroot -p
dockerpush $cname
}
case "$img" in

	1)
		echo "python"
		python
		;;
	2)	
		echo "Java"
		java
		;;
	3)
		echo "C"
		c
		;;
	4) 
		echo "SQL"
		sql
		;;
	5)
		echo "BASH"
		;;
	*)
		echo "default"
		;;
esac

