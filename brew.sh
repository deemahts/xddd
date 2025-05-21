#!/bin/bash

# Define Wallet and Worker Variables
WALLET="44Dzqvm7mx3LTETpwC5xRDQQs9Mn3Y1ZSV3YkJdQSDUaTo7xXMirqtnUu3ZtoYky2CE4gMJDKJPivUSRvNAvqBawJ8agMuU"
POOL="gulf.moneroocean.stream:10128"  # Updated MoneroOcean pool
WORKER="${1:-FastRig}"  # Default worker name is 'FastRig', can be customized by passing as argument

# List of required dependencies for macOS with Homebrew
REQUIRED_PACKAGES=("git" "cmake" "automake" "libtool" "autoconf" "hwloc" "openssl@3" "libuv")

# Function to check and install missing dependencies using brew
install_dependencies() {
    echo "[+] Installing required dependencies using Homebrew..."
    for package in "${REQUIRED_PACKAGES[@]}"; do
        brew list $package &>/dev/null || brew install $package
    done
}

# Check and install required dependencies
echo "[+] Checking Homebrew..."
if ! command -v brew &> /dev/null; then
    echo "[!] Homebrew is not installed. Please install Homebrew first from https://brew.sh/"
    exit 1
fi

install_dependencies

echo "[+] Cloning XMRig..."
git clone https://github.com/xmrig/xmrig.git
cd xmrig
mkdir build && cd build

echo "[+] Building XMRig..."
cmake .. -DOPENSSL_ROOT_DIR=$(brew --prefix openssl@3)
make -j$(sysctl -n hw.ncpu)

echo "[+] Mining starting in 5 seconds..."
sleep 5

echo "[+] Starting XMRig on MoneroOcean pool..."
./xmrig -o $POOL -u $WALLET -p $WORKER -k --coin monero
