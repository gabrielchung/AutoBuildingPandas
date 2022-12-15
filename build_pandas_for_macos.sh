#!/bin/sh

# This is a script to automate the process for building the Python package pandas from source using Docker

#
# ======================================================================
#

#
# Step 1, 2
#
# Prepare the directory
# Change the current directory to the created one
#
NEW_DIR_NAME="pandas-dev-folder"
mkdir $NEW_DIR_NAME
cd $NEW_DIR_NAME

#
# Step 3
#

SOURCE_CODE_URL="https://github.com/pandas-dev/pandas/archive/refs/heads/main.zip"
DOWNLOAD_DEST_PATH="./main.zip"
curl -L $SOURCE_CODE_URL -o $DOWNLOAD_DEST_PATH

#
# Step 4
#

TMP_SOURCE_DIR_PATH="."
unzip $DOWNLOAD_DEST_PATH -d $TMP_SOURCE_DIR_PATH

#
# Step 5
#

PANDAS_DIR_NAME_IN_SRC_ZIP_FILE="pandas-main"
cd $PANDAS_DIR_NAME_IN_SRC_ZIP_FILE

#
# Step 6
#
#
# Build the Docker image
#

DOCKER_IMAGE_NAME="pandas-dev"
docker build -t $DOCKER_IMAGE_NAME .

#
# Step 7
#
#
# Run the Docker image
#

MY_DOCKER_CONTAINER_NAME="my-pandas-dev-container"
docker run -d --name $MY_DOCKER_CONTAINER_NAME pandas-dev sleep infinity

#
# Step 8
#
#
# Execute script inside the container
#

docker cp ../../script_to_be_run_inside_the_container.sh my-pandas-dev-container:/home/pandas/script_to_be_run_inside_the_container.sh
docker exec -it -w /home/pandas my-pandas-dev-container sh script_to_be_run_inside_the_container.sh

#
# ======================================================================
#

# Go back one level up (cd $PANDAS_DIR_NAME_IN_SRC_ZIP_FILE)
cd ..

# Go back one level up (cd $NEW_DIR_NAME)
cd ..