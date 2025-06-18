# Start from Python base
FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    libssl-dev \
    pkg-config \
    libudev-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Rust (needed for Foundry)
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Install Foundry
RUN cargo install --locked --git https://github.com/foundry-rs/foundry --tag v0.2.0 forge

# Set working directory
WORKDIR /app

# Copy Python requirements and install
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of your project (assumes foundry.toml + lib/ already exist)
COPY . .

# Pre-install foundry dependencies (Uniswap & OZ)
RUN forge install \
    uniswap/v4-core \
    uniswap/v4-periphery \
    uniswap/permit2 \
    uniswap/universal-router \
    uniswap/v3-core \
    uniswap/v2-core \
    OpenZeppelin/openzeppelin-contracts

# Optional: build contracts (if needed)
RUN forge build

# Expose Python app port
EXPOSE 5000

# Run the Python app
CMD ["python", "app.py"]
