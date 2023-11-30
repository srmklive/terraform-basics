#!/bin/bash

sudo apt-get update

sudo DEBIAN_FRONTEND=noninteractive NEEDRESTART_SUSPEND=1 apt-get -y upgrade

sudo DEBIAN_FRONTEND=noninteractive NEEDRESTART_SUSPEND=1 apt-get -y dist-upgrade