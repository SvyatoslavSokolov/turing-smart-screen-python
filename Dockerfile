# Use the official Ubuntu base image
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

# Install system dependencies including NVIDIA drivers and Python
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-dev \
    libusb-1.0-0 \
    libudev-dev \
    build-essential \
    git \
    wget \
    curl \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements first for better caching
COPY requirements.txt .

# Install Python dependencies
RUN pip3 install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Create necessary directories
RUN mkdir -p /app/res/fonts \
    /app/res/backgrounds \
    /app/res/themes \
    /app/library \
    /app/tools \
    /app/external \
    /app/tests

# Set permissions for execution
RUN chmod +x main.py simple-program.py theme-editor.py configure.py

# Expose any needed ports (none needed for this application)
EXPOSE 8080

# Define the command to run the application
CMD ["python3", "main.py"]
