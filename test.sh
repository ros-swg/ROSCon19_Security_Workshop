#!/usr/bin/env bash

docker run -it --rm \
  --volume `pwd`:/srv/jekyll \
  --net=host \
  jekyll/builder \
  jekyll serve -w
