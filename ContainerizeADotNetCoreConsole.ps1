#ref : https://docs.microsoft.com/en-us/dotnet/core/docker/build-container

# Initilise Folder for the project
$folderpath="projectfolder"

#Clean up from previous runs
docker rmi myimage
Remove-Item $folderpath -Recurse -ErrorAction Ignore
Remove-Item "Dockerfile" -Recurse -ErrorAction Ignore

Test-Path -Path $folderpath

If(!(test-path $folderpath))
{
      New-Item -ItemType Directory -Force -Path $folderpath
}

Push-Location $folderpath

dotnet new console -o app -n myapp
Push-Location app
dotnet publish -c Release
dir bin\Release\netcoreapp3.1\publish
Pop-Location
New-Item "Dockerfile"

Set-Content "Dockerfile" 'FROM mcr.microsoft.com/dotnet/core/runtime:3.1'
docker build -t myimage -f Dockerfile .
docker images

Add-Content -Path .\Dockerfile -Value 'COPY app/bin/Release/netcoreapp3.1/publish/ app/'
Add-Content -Path .\Dockerfile -Value 'ENTRYPOINT ["dotnet", "app/myapp.dll"]'

docker build -t myimage -f Dockerfile . 

Write-Host "docker images"
docker images

Write-Host "docker create myimage"
$containerId=docker create myimage

Write-Host "docker start $containerId"
docker start $containerId

# Write-Host "docker stop $containerId"
# docker stop $containerId

# Write-Host "docker start $containerId"
# docker start $containerId

Write-Host "docker attach --sig-proxy=false $containerId"
docker attach --sig-proxy=false $containerId

Write-Host "docker stop $containerId"
docker stop $containerId

docker run -it --rm myimage

docker run -it --rm --entrypoint "bash" myimage
ls app
# docker rm $containerId

# come back to where we started initially
Pop-Location

docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
# docker rmi myimage
docker rmi -f $(docker images -a -q)

#Clean up from previous runs
docker rmi myimage
Remove-Item $folderpath -Recurse -ErrorAction Ignore
Remove-Item "Dockerfile" -Recurse -ErrorAction Ignore