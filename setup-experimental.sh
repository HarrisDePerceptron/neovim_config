#!/usr/bin/env bash
# End-to-end LazyVim setup for Ubuntu/Debian
# Installs:
# - Neovim (latest tarball)
# - UbuntuMono Nerd Font
# - fzf, ripgrep, fd
# - Node via nvm
# - LazyVim starter config

set -euo pipefail

msg() { printf "\n\033[1;32m%s\033[0m\n" "$*"; }
warn() { printf "\n\033[1;33m%s\033[0m\n" "$*"; }
need_cmd() { command -v "$1" >/dev/null 2>&1; }

SUDO="sudo"
[ "$EUID" -eq 0 ] && SUDO=""

# ---------- Prerequisites ----------
msg "Updating apt and installing prerequisites..."
$SUDO apt-get update -y
$SUDO apt-get install -y curl ca-certificates unzip git software-properties-common

# ---------- Install Neovim (latest tarball) ----------
if need_cmd nvim; then
  msg "Neovim already installed: $(nvim --version | head -n1)"
else
  msg "Installing latest Neovim from GitHub..."
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
  $SUDO rm -rf /opt/nvim
  $SUDO tar -C /opt -xzf nvim-linux-x86_64.tar.gz
  rm -f nvim-linux-x86_64.tar.gz
  if ! grep -q '/opt/nvim/bin' <<<"$PATH"; then
    warn "Add Neovim to your PATH (e.g., echo 'export PATH=\"/opt/nvim/bin:\$PATH\"' >> ~/.bashrc)"
  fi
fi

# ---------- Install dependencies ----------
msg "Installing fzf, ripgrep, fd..."
$SUDO apt-get install -y fzf ripgrep fd-find
if ! need_cmd fd && need_cmd fdfind; then
  $SUDO ln -sf "$(command -v fdfind)" /usr/local/bin/fd
fi

# ---------- Install Nerd Font ----------
FONT_DIR="${HOME}/.local/share/fonts"
NF_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/UbuntuMono.zip"
TMP_ZIP="/tmp/UbuntuMono.zip"

msg "Installing UbuntuMono Nerd Font..."
mkdir -p "${FONT_DIR}"
curl -L -o "${TMP_ZIP}" "${NF_URL}"
unzip -oq "${TMP_ZIP}" -d "${FONT_DIR}/UbuntuMonoNerd"
rm -f "${TMP_ZIP}"
if need_cmd fc-cache; then
  fc-cache -fv "${FONT_DIR}" >/dev/null || true
fi

# ---------- Install Node via nvm ----------
if [ ! -d "${HOME}/.nvm" ]; then
  msg "Installing nvm..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

if need_cmd nvm; then
  msg "Installing latest LTS Node..."
  nvm install --lts
  nvm alias default 'lts/*'
  nvm use default
fi

# ---------- Setup LazyVim ----------
NVIM_CFG="${HOME}/.config/nvim"
if [ -d "${NVIM_CFG}" ]; then
  BACKUP="${NVIM_CFG}.backup.$(date +%s)"
  warn "Backing up existing Neovim config to ${BACKUP}"
  mv "${NVIM_CFG}" "${BACKUP}"
fi

msg "Cloning LazyVim starter..."
git clone --depth=1 https://github.com/LazyVim/starter "${NVIM_CFG}"
rm -rf "${NVIM_CFG}/.git"

msg "Running LazyVim first sync..."
/opt/nvim/bin/nvim --headless "+Lazy! sync" +qa || true

# ---------- Done ----------
msg "LazyVim setup complete!"
echo "Restart your terminal or add Neovim to PATH:"
echo "  export PATH=\"/opt/nvim/bin:\$PATH\""
