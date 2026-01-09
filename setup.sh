#!/bin/bash

set -e

# Get OS and Architecture name
OS_NAME=$(uname -s)
ARCH_NAME=$(uname -m)

# Install directory
BIN_DIR="$HOME/.local/bin"
INSTALL_DIR="$HOME/.local/share/tools/lsp"
mkdir -p $INSTALL_DIR

# Create temp directory
mkdir -p lsp
pushd lsp

# Helper functions
if_not_exist() {
    local cmd=$1
    local prefix_msg=$2

    echo "Installing $prefix_msg..."
    if command -v $cmd >/dev/null 2>&1; then
        echo "$prefix_msg already installed. Skip"
    else
        "$3" && echo "Successfully installed $prefix_msg"
    fi
}

install_jdtls() {
    mkdir jdtls \
        && pushd jdtls \
        && curl -fLo jdtls.tar.gz https://www.eclipse.org/downloads/download.php?file=/jdtls/milestones/1.9.0/jdt-language-server-1.9.0-202203031534.tar.gz \
        && tar zxvf jdtls.tar.gz \
        && rm jdtls.tar.gz \
        && popd \
        && mv jdtls $INSTALL_DIR \
        && ln -s $INSTALL_DIR/jdtls/bin/jdtls $BIN_DIR/jdtls
}

install_kotlinls() {
    curl -fLo server.zip https://github.com/fwcd/kotlin-language-server/releases/download/1.3.13/server.zip \
        && unzip server.zip \
        && mv server $INSTALL_DIR/kotlinls \
        && ln -s $INSTALL_DIR/kotlinls/bin/kotlin-language-server $BIN_DIR/kotlin-language-server \
        && rm server.zip
}

install_elp() {
    if [ "$OS_NAME" = "Linux" ]; then
        os=linux
        os_1="linux-gnu"
    else
        os=macos
        os_1="apple-darwin"
    fi

    server_url="https://github.com/WhatsApp/erlang-language-platform/releases/download/2025-12-12/elp-${os}-${ARCH_NAME}-unknown-${os_1}-otp-26.2.tar.gz"
    curl -fLo elp.tar.gz $server_url \
        && tar zxvf elp.tar.gz \
        && mkdir -p $INSTALL_DIR/erlangls \
        && mv elp $INSTALL_DIR/erlangls \
        && ln -s $INSTALL_DIR/erlangls/elp $BIN_DIR/elp \
        && rm elp.tar.gz
}

install_gopls() {
    go install golang.org/x/tools/gopls@latest
}

install_goimports() {
    go install golang.org/x/tools/cmd/goimports@latest
}

# Install java language server
if_not_exist "jdtls" "Java language server" install_jdtls

# Install kotlin language server
if_not_exist "kotlin-language-server" "Kotlin language server" install_kotlinls

# Install erlang language server
if_not_exist "elp" "Erlang language server" install_elp

# Install golang language server
if_not_exist "gopls" "Go language server" install_gopls

# Install goimports
if_not_exist "goimports" "goimports" install_goimports

popd && rm -rf lsp
