#!/bin/bash

INTERFACES=$(wg show interfaces)
CURRENT_TIME=$(date +%s)
echo "Current time: $CURRENT_TIME"
for INTERFACE in $INTERFACES; do
    LAST_HANDSHAKE=$(wg show $INTERFACE latest-handshakes | awk '{print $2}')

    if [ "$LAST_HANDSHAKE" -eq 0 ]; then
        echo "No valid handshake data for $INTERFACE."
        continue
    fi

    TIME_DIFF=$((CURRENT_TIME - LAST_HANDSHAKE))

    if [ $TIME_DIFF -gt 1200 ]; then
        echo "Last handshake for $INTERFACE was more than 20 minutes ago. Restarting $INTERFACE."
        wg-quick down $INTERFACE
        sleep 5
        wg-quick up $INTERFACE
    fi
done
