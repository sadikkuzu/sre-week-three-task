#!/bin/bash

# Define variables
# Name of the namespace
NAMESPACE="sre"
# Name of the deployment
DEPLOYMENT_NAME="swype-app"
# Maximum number of restarts before scaling down
MAX_RESTARTS=3

# Infinite loop for monitoring
while true; do

  # Get pod restarts
  RESTARTS=$(kubectl get pods -n "$NAMESPACE" -l app="$DEPLOYMENT_NAME" -o jsonpath="{.items[0].status.containerStatuses[0].restartCount}")

  # Print current restart count
  CURRENT_TIME=$(date)
  echo "$CURRENT_TIME | Swype pod restarts: $RESTARTS"

  # Check restart limit
  if [[ $RESTARTS -gt $MAX_RESTARTS ]]; then
    echo "Swype pod exceeded restart limit. Scaling down deployment..."

    # Scale down deployment to zero replicas
    kubectl scale deployment -n "$NAMESPACE" "$DEPLOYMENT_NAME" --replicas=0

    # Exit the loop
    break
  fi

  # Pause for 60 seconds before next check
  sleep 60

done

echo "Swype pod watcher script stopped."
