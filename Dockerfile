# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    sudo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir notebook svgwrite ipython

# Create a non-root user, we'll change UID and GID at runtime
RUN useradd -m jupyter

# Create notebook directory
RUN mkdir -p /app/notebooks && chown jupyter:jupyter /app/notebooks

# Copy the entrypoint script
COPY jupyter-entrypoint.sh /usr/local/bin/jupyter-entrypoint.sh
RUN chmod +x /usr/local/bin/jupyter-entrypoint.sh

# Make port 8888 available to the world outside this container
EXPOSE 8888

# Set the working directory to /app/notebooks
WORKDIR /app/notebooks

# Use the entrypoint script to launch Jupyter
ENTRYPOINT ["/usr/local/bin/jupyter-entrypoint.sh"]
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser"]
