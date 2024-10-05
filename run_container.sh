docker run -p 8888:8888 \
  -v $(pwd)/app/notebooks:/app/notebooks \
  -e NB_UID=$(id -u) \
  -e NB_GID=$(id -g) \
  jupyter-notebook-svg