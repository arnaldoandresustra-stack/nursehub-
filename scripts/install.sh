#!/usr/bin/env bash
# Hermes Agent Installer for Linux/macOS
# Equivalent to scripts/install.ps1 for Windows

set -euo pipefail

# ─── Config ──────────────────────────────────────────────────────────────────
HERMES_HOME="${HERMES_HOME:-$HOME/.local/share/hermes}"
HERMES_REPO_SSH="git@github.com:NousResearch/hermes-agent.git"
HERMES_REPO_HTTPS="https://github.com/NousResearch/hermes-agent.git"
HERMES_REPO_ZIP="https://github.com/NousResearch/hermes-agent/archive/refs/heads/main.zip"
PYTHON_VERSION="3.11"
UV_INSTALL_URL="https://astral.sh/uv/install.sh"
NODE_VERSION="20"

# Terminal colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Flags
BUILD_DESKTOP=0
SKIP_NODE=0
SKIP_OPTIONAL=0

# ─── Logging helpers ─────────────────────────────────────────────────────────
info()    { echo -e "${CYAN}[hermes]${NC} $*"; }
success() { echo -e "${GREEN}[hermes]${NC} $*"; }
warn()    { echo -e "${YELLOW}[hermes] WARN:${NC} $*"; }
die()     { echo -e "${RED}[hermes] ERROR:${NC} $*" >&2; exit 1; }

require_cmd() {
    command -v "$1" >/dev/null 2>&1 || die "Required command '$1' not found. $2"
}

# ─── Argument parsing ────────────────────────────────────────────────────────
usage() {
    cat <<EOF
Usage: $0 [OPTIONS]

Options:
  --build-desktop    Build the Electron desktop application after install
  --skip-node        Skip Node.js installation
  --skip-optional    Skip optional tools (ripgrep, ffmpeg)
  --hermes-home DIR  Install Hermes to DIR (default: ~/.local/share/hermes)
  -h, --help         Show this help message
EOF
    exit 0
}

for arg in "$@"; do
    case "$arg" in
        --build-desktop)       BUILD_DESKTOP=1 ;;
        --skip-node)           SKIP_NODE=1 ;;
        --skip-optional)       SKIP_OPTIONAL=1 ;;
        --hermes-home=*)       HERMES_HOME="${arg#*=}" ;;
        -h|--help)             usage ;;
        *) warn "Unknown argument: $arg" ;;
    esac
done

# ─── Architecture detection ──────────────────────────────────────────────────
detect_arch() {
    local machine
    machine="$(uname -m)"
    case "$machine" in
        aarch64|arm64) echo "arm64" ;;
        x86_64|amd64)  echo "x64"   ;;
        i386|i686)     echo "x86"   ;;
        *) die "Unsupported architecture: $machine" ;;
    esac
}

OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(detect_arch)"

# Detect WoW64 emulation on macOS ARM running x86 binaries
if [[ "$OS" == "darwin" && "$ARCH" == "arm64" ]]; then
    if [[ "$(sysctl -n sysctl.proc_translated 2>/dev/null)" == "1" ]]; then
        ARCH="x64"
        warn "Running under Rosetta 2 — using x64 binaries."
    fi
fi

# ─── Git ─────────────────────────────────────────────────────────────────────
install_git() {
    if command -v git >/dev/null 2>&1; then
        info "Git found: $(git --version)"
        return
    fi
    info "Installing git..."
    if [[ "$OS" == "linux" ]]; then
        if command -v apt-get >/dev/null 2>&1; then
            sudo apt-get install -y git
        elif command -v dnf >/dev/null 2>&1; then
            sudo dnf install -y git
        elif command -v pacman >/dev/null 2>&1; then
            sudo pacman -Sy --noconfirm git
        elif command -v zypper >/dev/null 2>&1; then
            sudo zypper install -y git
        else
            die "Cannot auto-install git. Install it manually then re-run this script."
        fi
    elif [[ "$OS" == "darwin" ]]; then
        if command -v brew >/dev/null 2>&1; then
            brew install git
        else
            die "Install Homebrew (https://brew.sh) or Xcode Command Line Tools, then re-run."
        fi
    else
        die "Unsupported OS: $OS"
    fi
    success "Git installed."
}

# ─── uv — Python provisioning & package manager ──────────────────────────────
install_uv() {
    if command -v uv >/dev/null 2>&1; then
        info "uv found: $(uv --version)"
        return
    fi
    info "Installing uv..."
    if ! curl -LsSf "$UV_INSTALL_URL" | sh; then
        die "uv installation failed. Visit https://docs.astral.sh/uv/getting-started/installation/"
    fi
    # Reload PATH for the current process
    export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$PATH"
    command -v uv >/dev/null 2>&1 || \
        die "uv installed but not found in PATH. Add ~/.local/bin to your PATH and re-run."
    success "uv installed: $(uv --version)"
}

# ─── Python ──────────────────────────────────────────────────────────────────
setup_python() {
    info "Ensuring Python $PYTHON_VERSION..."
    if ! uv python find "$PYTHON_VERSION" >/dev/null 2>&1; then
        uv python install "$PYTHON_VERSION" \
            || die "Failed to install Python $PYTHON_VERSION via uv."
    fi
    success "Python $PYTHON_VERSION ready."
}

# ─── Node.js ─────────────────────────────────────────────────────────────────
install_node() {
    if [[ "$SKIP_NODE" -eq 1 ]]; then
        info "Skipping Node.js (--skip-node)."
        return
    fi
    if command -v node >/dev/null 2>&1; then
        info "Node.js found: $(node --version)"
        return
    fi
    info "Installing Node.js $NODE_VERSION..."

    # Prefer version managers for better isolation
    if command -v fnm >/dev/null 2>&1; then
        fnm install "$NODE_VERSION" && fnm use "$NODE_VERSION"
        return
    fi
    if command -v nvm >/dev/null 2>&1; then
        # nvm is a shell function; source it first
        # shellcheck disable=SC1090
        source "${NVM_DIR:-$HOME/.nvm}/nvm.sh" 2>/dev/null || true
        nvm install "$NODE_VERSION" && nvm use "$NODE_VERSION"
        return
    fi

    # System package managers
    if [[ "$OS" == "linux" ]]; then
        if command -v apt-get >/dev/null 2>&1; then
            curl -fsSL "https://deb.nodesource.com/setup_${NODE_VERSION}.x" | sudo -E bash -
            sudo apt-get install -y nodejs
        elif command -v dnf >/dev/null 2>&1; then
            sudo dnf module install -y nodejs:"$NODE_VERSION"
        elif command -v pacman >/dev/null 2>&1; then
            sudo pacman -Sy --noconfirm nodejs npm
        else
            warn "Cannot auto-install Node.js. Install it manually from https://nodejs.org"
            return
        fi
    elif [[ "$OS" == "darwin" ]]; then
        if command -v brew >/dev/null 2>&1; then
            brew install "node@$NODE_VERSION"
            brew link --overwrite "node@$NODE_VERSION" 2>/dev/null || true
        else
            warn "Cannot auto-install Node.js. Install Homebrew or download from https://nodejs.org"
            return
        fi
    fi
    success "Node.js installed: $(node --version 2>/dev/null || echo 'restart shell to activate')"
}

# ─── Optional system tools (ripgrep, ffmpeg) ─────────────────────────────────
install_optional_tools() {
    if [[ "$SKIP_OPTIONAL" -eq 1 ]]; then
        info "Skipping optional tools (--skip-optional)."
        return
    fi

    install_tool() {
        local cmd="$1" pkg="$2"
        command -v "$cmd" >/dev/null 2>&1 && return
        info "Installing optional tool: $pkg..."
        if [[ "$OS" == "linux" ]]; then
            if command -v apt-get >/dev/null 2>&1; then
                sudo apt-get install -y "$pkg" 2>/dev/null || warn "Could not install $pkg"
            elif command -v dnf >/dev/null 2>&1; then
                sudo dnf install -y "$pkg" 2>/dev/null || warn "Could not install $pkg"
            elif command -v pacman >/dev/null 2>&1; then
                sudo pacman -Sy --noconfirm "$pkg" 2>/dev/null || warn "Could not install $pkg"
            fi
        elif [[ "$OS" == "darwin" ]] && command -v brew >/dev/null 2>&1; then
            brew install "$pkg" 2>/dev/null || warn "Could not install $pkg"
        fi
    }

    install_tool rg  ripgrep
    install_tool ffmpeg ffmpeg
}

# ─── Clone / update repository ───────────────────────────────────────────────
clone_or_update() {
    mkdir -p "$(dirname "$HERMES_HOME")"

    if [[ -d "$HERMES_HOME/.git" ]]; then
        info "Updating existing installation at $HERMES_HOME..."
        if ! git -C "$HERMES_HOME" pull --ff-only 2>/dev/null; then
            warn "Fast-forward failed — resetting to origin/main."
            git -C "$HERMES_HOME" fetch origin
            git -C "$HERMES_HOME" reset --hard origin/main
        fi
        return
    fi

    info "Cloning Hermes Agent repository..."

    # 1) Try SSH (preferred for contributors)
    if git clone --depth 1 "$HERMES_REPO_SSH" "$HERMES_HOME" 2>/dev/null; then
        success "Cloned via SSH."
        return
    fi

    # 2) Try HTTPS
    if git clone --depth 1 "$HERMES_REPO_HTTPS" "$HERMES_HOME" 2>/dev/null; then
        success "Cloned via HTTPS."
        return
    fi

    # 3) Fall back to ZIP download (handles strict firewalls / TLS issues)
    warn "Git clone failed — trying ZIP download fallback..."
    local tmp_zip tmp_dir
    tmp_zip="$(mktemp --suffix=.zip)"
    tmp_dir="$(mktemp -d)"

    if curl -LsSf --retry 3 --retry-delay 2 "$HERMES_REPO_ZIP" -o "$tmp_zip"; then
        unzip -q "$tmp_zip" -d "$tmp_dir"
        local extracted
        extracted="$(ls -d "$tmp_dir"/hermes-agent-* 2>/dev/null | head -1)"
        [[ -n "$extracted" ]] || die "ZIP extraction failed: unexpected archive structure."
        mv "$extracted" "$HERMES_HOME"
        rm -rf "$tmp_zip" "$tmp_dir"
        success "Extracted from ZIP archive."
        return
    fi

    rm -f "$tmp_zip"
    rm -rf "$tmp_dir"
    die "All download methods failed. Check your internet connection and TLS certificates."
}

# ─── Python virtual environment + dependencies ───────────────────────────────
setup_venv() {
    local venv_dir="$HERMES_HOME/.venv"
    info "Creating virtual environment at $venv_dir..."
    uv venv --python "$PYTHON_VERSION" "$venv_dir" \
        || die "Failed to create virtual environment."

    local python="$venv_dir/bin/python"
    info "Installing Python dependencies..."

    # Try install methods in order: pyproject.toml → requirements.txt → requirements-dev.txt
    if [[ -f "$HERMES_HOME/pyproject.toml" ]]; then
        uv pip install --python "$python" -e "$HERMES_HOME" \
            && success "Dependencies installed from pyproject.toml." && return
    fi

    for req in requirements.txt requirements-dev.txt; do
        if [[ -f "$HERMES_HOME/$req" ]]; then
            uv pip install --python "$python" -r "$HERMES_HOME/$req" \
                && success "Dependencies installed from $req." && return
        fi
    done

    die "No requirements file found in $HERMES_HOME. The repository may be incomplete."
}

# ─── Configuration initialisation ────────────────────────────────────────────
init_config() {
    local config_dir="$HERMES_HOME/config"
    mkdir -p "$config_dir" "$HERMES_HOME/data"

    # Materialise template configs (don't overwrite existing user configs)
    for tmpl in "$HERMES_HOME"/config.template.*; do
        [[ -f "$tmpl" ]] || continue
        local dest="${tmpl/.template/}"
        if [[ ! -f "$dest" ]]; then
            cp "$tmpl" "$dest"
            info "Initialised config: $(basename "$dest")"
        fi
    done

    # Sync bundled skills without overwriting user customisations
    local skills_src="$HERMES_HOME/skills"
    local skills_dst="$HERMES_HOME/data/skills"
    if [[ -d "$skills_src" ]]; then
        mkdir -p "$skills_dst"
        # rsync preferred; cp -n fallback
        if command -v rsync >/dev/null 2>&1; then
            rsync -a --ignore-existing "$skills_src/" "$skills_dst/"
        else
            cp -rn "$skills_src/." "$skills_dst/" 2>/dev/null || true
        fi
        info "Skills synced to $skills_dst."
    fi
}

# ─── Persist environment variables ───────────────────────────────────────────
setup_env() {
    local venv_bin="$HERMES_HOME/.venv/bin"
    local hermes_bin="$HERMES_HOME/bin"
    local block
    block="$(printf '\n# Hermes Agent\nexport HERMES_HOME="%s"\nexport PATH="%s:%s:$PATH"\n' \
        "$HERMES_HOME" "$venv_bin" "$hermes_bin")"

    local updated=0
    for rc in "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.profile"; do
        [[ -f "$rc" ]] || continue
        if ! grep -q "HERMES_HOME" "$rc" 2>/dev/null; then
            printf '%s' "$block" >> "$rc"
            info "Added Hermes to PATH in $rc"
            updated=1
        fi
    done

    if [[ "$updated" -eq 0 ]]; then
        info "Hermes environment already configured in shell rc file."
    fi

    # Apply to the current process immediately
    export HERMES_HOME="$HERMES_HOME"
    export PATH="$venv_bin:$hermes_bin:$PATH"
}

# ─── Optional: build Electron desktop app ────────────────────────────────────
build_desktop() {
    [[ "$BUILD_DESKTOP" -eq 1 ]] || return

    require_cmd node "Install Node.js or re-run without --build-desktop."
    require_cmd npm  "npm is required to build the desktop app."

    local desktop_dir="$HERMES_HOME/desktop"
    [[ -d "$desktop_dir" ]] || die "Desktop source not found at $desktop_dir."

    info "Building Electron desktop application..."
    (
        cd "$desktop_dir"
        npm install || die "npm install failed. Check your Node.js installation."
        npm run build || die "Desktop build failed."
    )
    touch "$HERMES_HOME/.desktop-built"
    success "Desktop app built."
}

# ─── Entry point ─────────────────────────────────────────────────────────────
main() {
    echo ""
    echo -e "${BOLD}  ██╗  ██╗███████╗██████╗ ███╗   ███╗███████╗███████╗${NC}"
    echo -e "${BOLD}  ██║  ██║██╔════╝██╔══██╗████╗ ████║██╔════╝██╔════╝${NC}"
    echo -e "${BOLD}  ███████║█████╗  ██████╔╝██╔████╔██║█████╗  ███████╗${NC}"
    echo -e "${BOLD}  ██╔══██║██╔══╝  ██╔══██╗██║╚██╔╝██║██╔══╝  ╚════██║${NC}"
    echo -e "${BOLD}  ██║  ██║███████╗██║  ██║██║ ╚═╝ ██║███████╗███████║${NC}"
    echo -e "${BOLD}  ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝╚══════╝${NC}"
    echo ""
    echo -e "  Agent Installer  ${CYAN}Linux/macOS${NC}"
    echo ""

    info "OS: $OS | Arch: $ARCH"
    info "Install directory: $HERMES_HOME"
    echo ""

    install_git
    install_uv
    setup_python
    install_node
    install_optional_tools
    clone_or_update
    setup_venv
    init_config
    setup_env
    build_desktop

    echo ""
    success "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    success "  Hermes Agent installed at: $HERMES_HOME"
    success "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    info "Next steps:"
    info "  1. Restart your shell or run: source ~/.bashrc"
    info "  2. Run: hermes"
    echo ""
}

main "$@"
