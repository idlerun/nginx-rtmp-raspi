---
page: https://idle.run/nginx-rtmp-raspi
title: "Nginx build with RTMP module for Raspberry Pi"
tags: nginx raspberry pi
date: 2018-11-10
---

## Overview

Builds nginx from source in a Docker container for running RTMP server with HLS

## Usage

Build image with `build.sh`

Run Docker container with image `nginx-rtmp-raspi` and ports 8080 and 1935 published.

```
docker run -d --name nginx-rtmp -P 8080:8080 -P 1935:1935 nginx-rtmp-raspi
```

Run the `ffmpeg` service on the host to forward video to nginx. Currently in as an upstart service, but easy to update for systemd or other process manager.

## Refs

- https://github.com/DeTeam/webcam-stream/blob/master/Tutorial.md
