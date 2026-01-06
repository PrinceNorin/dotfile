#!/bin/bash

set -e

# Install directory
BIN_DIR="$HOME/.local/bin"
INSTALL_DIR="$HOME/.local/share/tools/lsp"
mkdir -p $INSTALL_DIR

# Create temp directory
mkdir lsp && pushd lsp

# Install java language server
echo "Installing java language server..."
if command -v jdtls >/dev/null 2>&1; then
    echo "Java language server already installed. Skip"
else
    mkdir jdtls \
        && pushd jdtls \
        && curl -fLo jdtls.tar.gz https://www.eclipse.org/downloads/download.php?file=/jdtls/milestones/1.9.0/jdt-language-server-1.9.0-202203031534.tar.gz \
        && tar zxvf jdtls.tar.gz \
        && rm jdtls.tar.gz \
        && popd \
        && mv jdtls $INSTALL_DIR \
        && ln -s $INSTALL_DIR/jdtls/bin/jdtls $BIN_DIR/jdtls
    echo "Successfully installed java language server!"
fi

# Install kotlin language server
echo "Installing kotlin language server..."
if command -v kotlin-language-server >/dev/null 2&>1; then
    echo "Kotlin language server already installed. Skip"
else
    curl -fLo server.zip https://github.com/fwcd/kotlin-language-server/releases/download/1.3.13/server.zip \
        && unzip server.zip \
        && mv server $INSTALL_DIR/kotlinls \
        && ln -s $INSTALL_DIR/kotlinls/bin/kotlin-language-server $BIN_DIR/kotlin-language-server \
        && rm server.zip
    echo "Successfully installed kotlin language server!"
fi

popd && rm -rf lsp
