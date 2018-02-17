#!/bin/bash

sudo find / -name '*' -newermt '-300 seconds' | grep -v "/proc/" | grep -v "/sys/"
