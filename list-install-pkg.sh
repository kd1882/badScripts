#!/bin/bash
# What I said it did.

dpkg -l | awk '{print $2}' > installed_packages.txt

