#!/bin/bash

# Quick deploy with notification
./deploy.sh && osascript -e 'display notification "Deploy complete! Refresh your browser." with title "PORTALshop"'
