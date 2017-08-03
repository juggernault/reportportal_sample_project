#!/bin/sh
# run_test.sh <container_name> <image_id> <features>
(
    CONTAINER_NAME=$1
    IMAGE_ID=$2
    echo "cont: " $CONTAINER_NAME;
    echo "image: " $IMAGE_ID;
    echo "args: " ${@:3};

    docker run --shm-size 2G --cap-add sys_admin  -v /dev/shm:/dev/shm -i -e BROWSER -e TEST_ENV -e TEST_BRAND -e LISTING_API_DOMAIN -e BASE_URL -e AGENT_LEAD_API_DOMAIN  -e HEADER_NAVIGATION_API_DOMAIN -e BETA_SIGNUP_URL -e SOLR_DOMAIN -e SOLR_OVERSEAS_DOMAIN -e LIVE_HOMEPAGE_URL -e MOBILE_URL -e LIVE_MOBILE_URL -e RUNNING_COSTS_API_DOMAIN -e POI_API_DOMAIN -e DEVICE_NAME --name $CONTAINER_NAME $IMAGE_ID cucumber -f junit -o output -f pretty ${@:3};

    exit_code=$(docker inspect -f "{{ .State.ExitCode }}" $CONTAINER_NAME)
    if [ "$exit_code" -eq 2 ]; then
        echo "Rerun container because of exit: 2 ";
        docker cp $CONTAINER_NAME:/code/output .;
        docker rm $CONTAINER_NAME;
        docker run --cap-add sys_admin  -v /dev/shm:/dev/shm -i -e BROWSER -e TEST_ENV -e TEST_BRAND -e LISTING_API_DOMAIN -e BASE_URL -e AGENT_LEAD_API_DOMAIN -e HEADER_NAVIGATION_API_DOMAIN -e BETA_SIGNUP_URL -e SOLR_DOMAIN -e SOLR_OVERSEAS_DOMAIN -e LIVE_HOMEPAGE_URL -e MOBILE_URL -e LIVE_MOBILE_URL -e RUNNING_COSTS_API_DOMAIN -e POI_API_DOMAIN -e DEVICE_NAME --name $CONTAINER_NAME $IMAGE_ID cucumber -f junit -o output -f pretty ${@:3};

        docker cp $CONTAINER_NAME:/code/output .;
        docker rm $CONTAINER_NAME;
        echo "exit:" $exit_code
        exit $exit_code
    else
    docker cp $CONTAINER_NAME:/code/output .;
    docker rm $CONTAINER_NAME;
    echo "exit:" $exit_code
    exit $exit_code
    fi

)
