#!/bin/sh
# run_test.sh <container_name> <image_id> <features>
(
    CONTAINER_NAME=$1
    IMAGE_ID=$2
    RAKE_CMD=$3
    echo "cont: " $CONTAINER_NAME;
    echo "image: " $IMAGE_ID;
    echo "rake: " $RAKE_CMD;
    docker run --cap-add sys_admin  -v /dev/shm:/dev/shm -i  -e BROWSER -e TEST_ENV -e TEST_BRAND --name $CONTAINER_NAME $IMAGE_ID rake $RAKE_CMD --trace;
    exit_code=$(docker inspect -f "{{ .State.ExitCode }}" $CONTAINER_NAME)
    docker cp $CONTAINER_NAME:/code/output .;
    echo "exit:" $exit_code
    exit $exit_code
)
