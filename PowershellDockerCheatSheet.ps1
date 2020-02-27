# Rich set : Docker for Windows cheat sheet
docker ps -q | % { docker stop $_ }

docker images -q | % { docker rmi $_ }