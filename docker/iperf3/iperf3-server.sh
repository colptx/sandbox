#!/bin/bash

docker build -t taseals/iperf3:latest -t taseals/iperf3:latest .\Dockerfile
docker run  -d --name=iperf3-srv -p 5201:5201 taseals/iperf3:latest -s