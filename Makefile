# ========================================
# dotfiles Makefile
# ========================================
# Mac（ラップトップ）: 開発環境準備 + 設定適用
# Linux（サーバー）: ansibleで転送後、設定リンクのみ
# ========================================

# 設定ファイル定義
COMMON_FILES = .zshrc .zsh .vimrc .vim .tmux.conf .tmux .dir_colors .gitconfig .gitignore .gvimrc config/starship.toml
MAC_FILES = $(COMMON_FILES) config/mise/config.toml
LINUX_FILES = $(COMMON_FILES)

# 基本設定
CURRENTDIR = $(shell pwd)
BACKUPDIR = $(HOME)/.dotfiles.bk

# ========================================
# メインターゲット
# ========================================

# Mac: 完全セットアップ（準備 + 適用）
mac: prepare-mac install-mac

# Linux: 設定リンクのみ（転送後に実行）
linux: install-linux

# 従来互換（Mac向け）
all: mac

# ========================================
# Mac専用: 開発環境準備
# ========================================

prepare-mac: starship tmux-plugins

# Starshipバイナリダウンロード
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
# 設定適用（Mac/Linux共通）
# ========================================

# Mac設定適用
install-mac: DOT_FILES=$(MAC_FILES)
install-mac: backup-mac clean-mac link-mac post-install-mac

# Linux設定適用
install-linux: DOT_FILES=$(LINUX_FILES)
install-linux: backup-linux clean-linux link-linux post-install-linux

# ========================================
# リンク処理
# ========================================

link-mac: $(foreach f, $(MAC_FILES), link-dot-file-$(f)) mise-link
link-linux: $(foreach f, $(LINUX_FILES), link-dot-file-$(f))

# mise設定の特別処理（ディレクトリ作成）
mise-link:
	@echo "Setting up mise config directory..."
	@mkdir -p $(HOME)/.config/mise
	@ln -snf $(CURRENTDIR)/config/mise/config.toml $(HOME)/.config/mise/config.toml

# ========================================
# ポストインストール処理
# ========================================

post-install-mac: vim-dependency
	@echo "Mac setup completed!"
	@echo "Next steps:"
	@echo "  1. Run 'brew bundle install' to install Homebrew packages"
	@echo "  2. Run 'mise install' to install development tools"
	@echo "  3. Run 'prefix + I' in tmux to install plugins"

post-install-linux:
	@echo "Linux setup completed!"
	@echo "Note: Starship and tmux plugins were prepared on Mac"

vim-dependency:
	@echo "Installing vim-plug and plugins..."
	@curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	@vim +PlugInstall +qal

# ========================================
# バックアップ・クリーン処理
# ========================================

backup-mac: DOT_FILES=$(MAC_FILES)
backup-mac: make-backup-dir $(foreach f, $(MAC_FILES), backup-dot-files-$(f))

backup-linux: DOT_FILES=$(LINUX_FILES)
backup-linux: make-backup-dir $(foreach f, $(LINUX_FILES), backup-dot-files-$(f))

clean-mac: $(foreach f, $(MAC_FILES), unlink-dot-file-$(f))
clean-linux: $(foreach f, $(LINUX_FILES), unlink-dot-file-$(f))

# ========================================
# リストア・削除
# ========================================

restore-mac: DOT_FILES=$(MAC_FILES)
restore-mac: clean-mac $(foreach f, $(MAC_FILES), restore-dot-files-$(f))

restore-linux: DOT_FILES=$(LINUX_FILES)
restore-linux: clean-linux $(foreach f, $(LINUX_FILES), restore-dot-files-$(f))

remove-mac: restore-mac $(foreach f, $(MAC_FILES), remove-dot-files-$(f))
remove-linux: restore-linux $(foreach f, $(LINUX_FILES), remove-dot-files-$(f))

# ========================================
# ヘルパー関数
# ========================================

make-backup-dir:
	@mkdir -p $(BACKUPDIR)

link-dot-file-%: %
	@echo "Create Symlink $(shell echo $< | sed "s/^\.//") => $(HOME)/$<"
	@mkdir -p $(HOME)/$(shell dirname $<)
	@ln -snf $(CURRENTDIR)/$< $(HOME)/$<

unlink-dot-file-%: %
	@echo "Remove Symlink $(HOME)/$<"
	@$(RM) $(HOME)/$<

restore-dot-files-%: %
	@if [ -f $(BACKUPDIR)/$< -o -d $(BACKUPDIR)/$< ]; then \
		echo "Restore $(BACKUPDIR)/$< => $(HOME)/$<";\
		cp -rp $(BACKUPDIR)/$< $(HOME)/;\
	fi

backup-dot-files-%: %
	@if [ \( -f $(HOME)/$< -o -d $(HOME)/$< \) -a ! -L $(HOME)/$< ]; then \
		echo "Create Backup $(HOME)/$< => $(BACKUPDIR)/$<";\
		cp -rp $(HOME)/$< $(BACKUPDIR)/;\
	fi

remove-dot-files-%: %
	@if [ -f $(HOME)/$< -o -d $(HOME)/$< ]; then \
		echo "Remove $(HOME)/$<";\
		rm -rf $(HOME)/$< ;\
	fi

# ========================================
# ヘルプ
# ========================================

help:
	@echo "dotfiles Makefile"
	@echo ""
	@echo "Usage:"
	@echo "  make mac     - Mac complete setup (prepare + install)"
	@echo "  make linux   - Linux setup (link configs only, after ansible transfer)"
	@echo ""
	@echo "Mac-specific:"
	@echo "  make prepare-mac   - Download binaries and setup plugins"
	@echo "  make install-mac   - Apply Mac configurations"
	@echo ""
	@echo "Linux-specific:"
	@echo "  make install-linux - Apply Linux configurations"
	@echo ""
	@echo "Maintenance:"
	@echo "  make restore-mac   - Restore from backup (Mac)"
	@echo "  make restore-linux - Restore from backup (Linux)"
	@echo "  make remove-mac    - Remove all configurations (Mac)"
	@echo "  make remove-linux  - Remove all configurations (Linux)"

.PHONY: mac linux all prepare-mac install-mac install-linux link-mac link-linux
.PHONY: backup-mac backup-linux clean-mac clean-linux restore-mac restore-linux
.PHONY: remove-mac remove-linux starship tmux-plugins post-install-mac post-install-linux
.PHONY: help mise-link vim-dependency make-backup-dir