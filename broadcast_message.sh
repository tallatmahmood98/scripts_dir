#!/bin/bash

POD_NAME=$(kubectl get pods -l "geodds.component=api" -o jsonpath='{.items[0].metadata.name}')
USER_TOKEN=$(echo "User-token: 53af49a4-5948-11ee-8c99-0242ac120002:1234")
for POD_IP in $(kubectl get endpoints dev-api -o jsonpath="{.subsets[*].addresses[*].ip}")
do
	kubectl exec -it ${POD_NAME} -- bash -c "curl -X POST -H \"${USER_TOKEN}\" http://${POD_IP}/datasets"
done