#!/bin/bash

# Dockerコンテナを起動
CONTAINER_ID=$(docker run -d -p 8888:8888 \
  --name jupyter_server \
  -v $(pwd)/app/notebooks:/app/notebooks \
  -e NB_UID=$(id -u) \
  -e NB_GID=$(id -g) \
  jupyter-notebook-svg)

# URLが表示されるまで待機（最大30秒）
echo "Waiting for Jupyter to start..."
for i in {1..30}; do
    JUPYTER_URL=$(docker logs jupyter_server 2>&1 | grep -o "http://127.0.0.1:[0-9]*/.*token=[a-z0-9]*" | tail -n 1)
    if [ ! -z "$JUPYTER_URL" ]; then
        break
    fi
    sleep 1
done

if [ -z "$JUPYTER_URL" ]; then
    echo "Error: Could not get Jupyter URL"
    echo "Container logs:"
    docker logs jupyter_server
    exit 1
fi

# 取得したURLを表示
echo "Jupyter URL: $JUPYTER_URL"

# ブラウザを起動
brave-browser $JUPYTER_URL

# 以下は必要に応じて使用
# コンテナを停止する関数
cleanup() {
    echo "Stopping container..."
    docker stop jupyter_server > /dev/null
}
