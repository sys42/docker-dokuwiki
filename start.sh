#!/bin/sh
docker run -ti --rm -p 30000:80 $(cat REPO_AND_VERSION) bash

