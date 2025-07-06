# ========================================
# dotfiles Makefile
# ========================================
# 機能別に設定を適用できるシンプルなMakefile
# ansibleとの重複は実用性を優先して許容
# ========================================

# 設定ファイル定義
DOT_FILES = zshrc zsh vimrc vim tmux.conf tmux dir_colors gitconfig gitignore gvimrc
CONFIG_FILES = config/starship.toml config/mise/config.toml

# 基本設定
CURRENTDIR = $(shell pwd)
BACKUPDIR = $(HOME)/.dotfiles.bk
OS = $(shell uname)

# ========================================
# メインターゲット
# ========================================

# 完全セットアップ
all: backup clean install

# 設定適用
install: prepare zsh vim tmux git dircolors config

prepare: starship tmux-plugins

# ========================================
# 機能別設定
# ========================================

zsh: $(foreach f, $(filter zsh%, $(DOT_FILES)), link-dot-file-$(f))

vim: $(foreach f, $(filter vim%, $(DOT_FILES)), link-dot-file-$(f)) vim-dependency gvim

gvim: $(foreach f, $(filter gvim%, $(DOT_FILES)), link-dot-file-$(f))

tmux: $(foreach f, $(filter tmux%, $(DOT_FILES)), link-dot-file-$(f))

git: $(foreach f, $(filter git%, $(DOT_FILES)), link-dot-file-$(f))

dircolors: $(foreach f, $(filter dir_colors%, $(DOT_FILES)), link-dot-file-$(f))

# config設定（OS固有処理含む）
config: starship-config mise-config

starship-config:
	@echo "Setting up starship config..."
	@mkdir -p $(HOME)/.config
	@ln -snf $(CURRENTDIR)/config/starship.toml $(HOME)/.config/starship.toml

mise-config:
	@if [ "$(OS)" = "Darwin" ]; then \
		echo "Setting up mise config (macOS only)..."; \
		mkdir -p $(HOME)/.config/mise; \
		ln -snf $(CURRENTDIR)/config/mise/config.toml $(HOME)/.config/mise/config.toml; \
	fi

# ========================================
# 環境準備
# ========================================

# Starshipバイナリ準備
starship: zsh/bin/Darwin/starship zsh/bin/Linux/x86_64/starship

zsh/bin/Darwin/starship:
	@echo "Downloading Starship for macOS..."
	@mkdir -p zsh/bin/Darwin
	@curl -fsSL https://github.com/starship/starship/releases/latest/download/starship-aarch64-apple-darwin.tar.gz | tar -xzC zsh/bin/Darwin

zsh/bin/Linux/x86_64/starship:
	@echo "Downloading Starship for Linux..."
	@mkdir -p zsh/bin/Linux/x86_64
	@curl -fsSL https://github.com/starship/starship/releases/latest/download/starship-x86_64-unknown-linux-musl.tar.gz | tar -xzC zsh/bin/Linux/x86_64

# Tmuxプラグインマネージャー
tmux-plugins: tmux/plugins/tpm

tmux/plugins/tpm:
	@echo "Installing TPM (Tmux Plugin Manager)..."
	@git clone https://github.com/tmux-plugins/tpm tmux/plugins/tpm
	@mkdir -p tmux/log
	@echo "TPM installed. Run 'prefix + I' in tmux to install plugins."

# ========================================
# メンテナンス
# ========================================

# バックアップ
backup: make-backup-dir $(foreach f, $(DOT_FILES), backup-dot-files-$(f)) backup-config-files

backup-config-files:
	@echo "Backing up config files..."
	@if [ -f $(HOME)/.config/starship.toml -a ! -L $(HOME)/.config/starship.toml ]; then \
		mkdir -p $(BACKUPDIR)/config; \
		cp $(HOME)/.config/starship.toml $(BACKUPDIR)/config/; \
	fi
	@if [ -f $(HOME)/.config/mise/config.toml -a ! -L $(HOME)/.config/mise/config.toml ]; then \
		mkdir -p $(BACKUPDIR)/config/mise; \
		cp $(HOME)/.config/mise/config.toml $(BACKUPDIR)/config/mise/; \
	fi

# リストア
restore: clean $(foreach f, $(DOT_FILES), restore-dot-files-$(f)) restore-config-files

restore-config-files:
	@echo "Restoring config files..."
	@if [ -f $(BACKUPDIR)/config/starship.toml ]; then \
		mkdir -p $(HOME)/.config; \
		cp $(BACKUPDIR)/config/starship.toml $(HOME)/.config/; \
	fi
	@if [ -f $(BACKUPDIR)/config/mise/config.toml ]; then \
		mkdir -p $(HOME)/.config/mise; \
		cp $(BACKUPDIR)/config/mise/config.toml $(HOME)/.config/mise/; \
	fi

# 削除
remove: restore $(foreach f, $(DOT_FILES), remove-dot-files-$(f)) remove-config-files

remove-config-files:
	@echo "Removing config files..."
	@rm -f $(HOME)/.config/starship.toml
	@if [ "$(OS)" = "Darwin" ]; then \
		rm -f $(HOME)/.config/mise/config.toml; \
	fi

# クリーン
clean: $(foreach f, $(DOT_FILES), unlink-dot-file-$(f)) clean-config-files

clean-config-files:
	@echo "Cleaning config files..."
	@rm -f $(HOME)/.config/starship.toml
	@rm -f $(HOME)/.config/mise/config.toml

# ========================================
# 依存関係
# ========================================

vim-dependency:
	@echo "Installing vim-plug and plugins..."
	@curl -fLo vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	@vim +PlugInstall +qall

# ========================================
# ヘルパー関数
# ========================================

make-backup-dir:
	@mkdir -p $(BACKUPDIR)

link-dot-file-%:
	@echo "Create Symlink $* => $(HOME)/.$*"
	@ln -snf $(CURRENTDIR)/$* $(HOME)/.$*

unlink-dot-file-%:
	@echo "Remove Symlink $(HOME)/.$*"
	@$(RM) $(HOME)/.$*

restore-dot-files-%:
	@if [ -f $(BACKUPDIR)/.$* -o -d $(BACKUPDIR)/.$* ]; then \
		echo "Restore $(BACKUPDIR)/.$* => $(HOME)/.$*";\
		cp -rp $(BACKUPDIR)/.$* $(HOME)/;\
	fi

backup-dot-files-%:
	@if [ \( -f $(HOME)/.$* -o -d $(HOME)/.$* \) -a ! -L $(HOME)/.$* ]; then \
		echo "Create Backup $(HOME)/.$* => $(BACKUPDIR)/.$*";\
		cp -rp $(HOME)/.$* $(BACKUPDIR)/;\
	fi

remove-dot-files-%:
	@if [ -f $(HOME)/.$* -o -d $(HOME)/.$* ]; then \
		echo "Remove $(HOME)/.$*";\
		rm -rf $(HOME)/.$* ;\
	fi

# ========================================
# ヘルプ
# ========================================

help:
	@echo "dotfiles Makefile"
	@echo ""
	@echo "Main targets:"
	@echo "  make all     - Complete setup (backup + clean + install)"
	@echo "  make install - Install all configurations"
	@echo ""
	@echo "Individual configurations:"
	@echo "  make zsh       - ZSH configuration"
	@echo "  make vim       - Vim configuration (includes plugins)"
	@echo "  make tmux      - Tmux configuration"
	@echo "  make git       - Git configuration"
	@echo "  make config    - Config files (starship, mise)"
	@echo ""
	@echo "Environment setup:"
	@echo "  make starship     - Download starship binaries"
	@echo "  make tmux-plugins - Install tmux plugin manager"
	@echo ""
	@echo "Maintenance:"
	@echo "  make backup  - Backup existing configurations"
	@echo "  make restore - Restore from backup"
	@echo "  make remove  - Remove all configurations"
	@echo "  make clean   - Clean symlinks only"

.PHONY: all install prepare zsh vim gvim tmux git dircolors config starship-config mise-config
.PHONY: starship tmux-plugins backup restore remove clean backup-config-files restore-config-files
.PHONY: remove-config-files clean-config-files vim-dependency make-backup-dir help
