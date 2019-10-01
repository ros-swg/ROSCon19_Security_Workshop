#!/bin/bash

jekyll build
cd ..
cp -a src/_site/. .
