#!/bin/bash
echo "The current working directory is: $(pwd)"
bash "$(pwd)/moodle-docker-brew/moodle-docker" "$@"
