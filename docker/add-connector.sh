#!/usr/bin/env bash

function push_config {
    # wait until local connect's REST API comes up
    until $(curl --output /dev/null --silent --head --fail --request GET http://localhost:8083/connectors); do
        printf '.'
        sleep 5
    done
    echo "Pushing connector config..."
    sleep 5
    # cat $APP_PROPERTIES_FILE
    JSON_OUTPUT=$(curl --header "Content-Type: application/json" \
     --request POST \
     --data '{   "name": "feed-item-connector",   "config": {     "connector.class": "io.confluent.connect.elasticsearch.ElasticsearchSinkConnector",     "tasks.max": "1",     "topics": "feed-item-complete",     "key.ignore": "true",     "schema.ignore": "true",     "connection.url": "http://0.0.0.0:9200",     "type.name": "feed-item-type",     "name": "feed-item-connector"   } }' \
     http://localhost:8083/connectors &)

    if [[ $JSON_OUTPUT = *"feed-item-connector"* ]]; then
        echo "**********************************************************************************"
        echo "*************************** All configs are fine ! :) ****************************"
        echo "**********************************************************************************"   
    else
        echo "Unable to create feed-item-connector. Check kafka-connect container logs."
    fi
}

push_config 

# EOF