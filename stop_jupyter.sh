#!/bin/bash

# コンテナを停止する
echo "Stopping container..."
docker stop jupyter_server
docker rm jupyter_server
