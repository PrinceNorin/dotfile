#!/bin/bash

# Exit on any error
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'


# Logging functions
log_info() {
  echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warn() {
  echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
  echo -e "${RED}[ERROR]${NC} $1"
}


# Function to check if command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}


# Function to install asdf
install_asdf() {
  log_info "Installing asdf..."

  if [ -d "$HOME/.asdf" ]; then
    log_warn "asdf is already installed"
    return 0
  fi

  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0

  # Add asdf to shell configuration
  if [ -n "$ZSH_VERSION" ]; then
    SHELL_RC="$HOME/.zshrc"
  else
    SHELL_RC="$HOME/.bashrc"
  fi

  if ! grep -q "asdf.sh" "$SHELL_RC"; then
    echo -e "\n# asdf version manager" >> "$SHELL_RC"
    echo ". $HOME/.asdf/asdf.sh" >> "$SHELL_RC"
    echo "fpath=(${ASDF_DIR}/completions $fpath)" >> "$SHELL_RC"
    log_success "asdf added to $SHELL_RC"
  fi

  # Source asdf for current session
  . "$HOME/.asdf/asdf.sh"

  log_success "asdf installed successfully"
}


# Function to install Node.js using asdf
install_nodejs() {
  log_info "Installing Node.js..."

  if asdf list nodejs | grep -E '[0-9]+\.[0-9]+\.[0-9]+' | grep '\*'; then
    log_warn "Node.js already installed"
    return 0
  fi

  if ! asdf plugin list | grep -q "nodejs"; then
    asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
    log_success "Node.js plugin added to asdf"
  else
    log_warn "Node.js plugin already exists in asdf"
  fi

  # Install latest LTS version of Node.js
  NODE_VERSION=$(asdf list all nodejs | grep -E '[0-9]+\.[0-9]+\.[0-9]+' | grep '^18\.' | tail -1)
  asdf install nodejs "$NODE_VERSION"
  asdf global nodejs "$NODE_VERSION"
  log_success "Node.js $NODE_VERSION installed and set as global"

  # Verify installation
  if command_exists node && command_exists npm; then
    log_success "Node.js setup completed: $(node --version), npm $(npm --version)"
  else
    log_error "Node.js installation verification failed"
    return 1
  fi
}


# Function to install Go using asdf
install_golang() {
  log_info "Installing Go..."

  if asdf list nodejs | grep -E '[0-9]+\.[0-9]+\.[0-9]+' | grep '\*'; then
    log_warn "Go already installed"
    return 0
  fi

  if ! asdf plugin list | grep -q "golang"; then
    asdf plugin add golang https://github.com/asdf-community/asdf-golang.git
    log_success "Go plugin added to asdf"
  else
    log_warn "Go plugin already exists in asdf"
  fi

  # Install latest stable version of Go
  GO_VERSION=$(asdf list all golang | grep -E '[0-9]+\.[0-9]+\.[0-9]+' | grep -v 'rc\|beta' | tail -1)
  if ! asdf list golang | grep -q "$GO_VERSION"; then
    asdf install golang "$GO_VERSION"
    asdf global golang "$GO_VERSION"
    log_success "Go $GO_VERSION installed and set as global"
  else
    log_warn "Go $GO_VERSION is already installed"
  fi

  # Verify installation
  if command_exists go; then
    log_success "Go setup completed: $(go version)"
  else
    log_error "Go installation verification failed"
    return 1
  fi
}


# Function to setup vim with plugins
setup_vim() {
  if ! command_exists vim; then
    log_info "Installing vim..."
    if command_exists apt-get; then
      sudo apt-get update && sudo apt-get install -y vim
    elif command_exists yum; then
      sudo yum install -y vim
    elif command_exists brew; then
      brew install vim
    else
      log_error "Cannot install vim automatically. Please install it manually."
      return 1
    fi
  fi

  # Create vim directory structure
  mkdir -p ~/.vim/autoload ~/.vim/plugged ~/.vim/backups ~/.vim/swaps ~/.vim/undo

  # Install vim-plug if not exists
  if [ ! -f ~/.vim/autoload/plug.vim ]; then
    log_info "Installing vim-plug..."
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    log_success "vim-plug installed"
  else
    log_warn "vim-plug already installed"
  fi

  if [ ! -f ~/.vimrc ]; then
    log_info "Initialiing $HOME/.vimrc file..."
    curl -fLo ~/.vimrc \
      https://raw.githubusercontent.com/PrinceNorin/dotfile/refs/heads/v0.1/vim/vimrc
    log_success "Completed populating $HOME/.vimrc file!"
  fi
}


# Main execution
main() {
  log_info "Starting development environment setup..."

  # if command_exists apt-get; then
  #   log_info "Updating package lists..."
  #   sudo apt-get update
  # fi

  install_asdf

  if [ -f "$HOME/.asdf/asdf.sh" ]; then
    . "$HOME/.asdf/asdf.sh"
  fi

  install_nodejs
  install_golang

  setup_vim

  log_success "Development environment setup completed successfully!"
  log_info "You may need to restart your terminal or run: source ~/.bashrc (or ~/.zshrc)"

  echo
  log_info "Installed versions:"
  if command_exists node; then
    echo " Node.js: $(node --version)"
  fi

  if command_exists npm; then
    echo " npm: $(npm --version)"
  fi

  if command_exists go; then
    echo " Go: $(go version)"
  fi
}

# Run main function
main "$@"
