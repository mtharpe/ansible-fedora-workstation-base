#!/bin/bash

# Install Nativefier, Electron, and if in gnome the Calendar app and then hide it

nativefier --icon ~/Pictures/icons/gcal.png --name 'Google Calendar' --maximize  --user-agent "Mozilla/5.0 (X11; Linux x86_64; rv:88.0) Gecko/20100101 Firefox/88.0"  --single-instance  --verbose https://calendar.google.com

nativefier --icon ~/Pictures/icons/gmail.png --name 'Google Mail' --maximize --single-instance  --verbose https://mail.google.com

nativefier --icon ~/Pictures/icons/pandora.png --name 'Pandora' --maximize --single-instance --wildvine --inject no-scroll.css--verbose https://pandora.com
