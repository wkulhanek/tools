#!/bin/bash
# @author: Wolfgang Kulhanek
# @email: WolfgangKulhanek@gmail.com
#
# Update a list of Docker Images
# ------------------------------
#
# First update all Images that came from the RedHat registry (registry.access.redhat.com)
#   to the 'latest' tag excluding OpenShift Container Platform core images
#   (images with "ose" in the name). These get updated automatically by OCP (or the oc
#   client utility when using 'oc cluster up').
# Second update all images listed in the variable EXTRA_IMAGES.
# Third clean/delete all images that now have '<none>' as the tag.
# Finally print the current list of local images.

EXTRA_IMAGES="sonatype/nexus3:latest rocketchat/rocket.chat centos:7"

bold=$(tput bold)
normal=$(tput sgr0)

# Check that Docker is running
docker info 2>/dev/null >/dev/null
if [ "$?" == "0" ]; then
  # Update Red Hat OpenShift Images with the same tag from the Red Hat Registry
  printf "\n${bold}*** Checking Red Hat Images:${normal}"
  for image in $(docker images|grep registry|awk '{print $1}'); do
    imagetag=$(docker images|grep "$image"|awk '{print $2}'|head -n 1)
    printf "\n${bold}Checking Image: $image:$imagetag...${normal}\n"
    docker pull $image:$imagetag
  done
   
  # Update individual images
  printf "\n${bold}*** Checking extra Images:${normal}\n"
  for image in $EXTRA_IMAGES; do
    printf "\n${bold}Checking Image: $image...${normal}\n"
    docker pull $image
  done

  # Cleanup Images with <none> tag
   printf "\n${bold}*** Cleaning up Images:${normal}\n"
   for image_id in $(docker images|grep \<none\>|awk '{print $3}'); do
    printf "\n${bold}Cleaning up Image: $image_id...${normal}\n"
    docker rmi $image_id
  done

  printf "\n${bold}*** Finished. Here are your images:${normal}\n"
  docker images
else
  printf "\nDocker is not running.\n\n"
fi
