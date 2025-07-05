DOT_FILES = .zshrc .zsh .vimrc .vim .tmux.conf .tmux .dir_colors .gitconfig .gitignore .gvimrc
CURRENTDIR = $(shell pwd)
BACKUPDIR = $(HOME)/.dotfiles.bk

all: backup clean install
install: starship tmux-plugins zsh vim tmux git dircolors

backup: make-backup-dir $(foreach f, $(DOT_FILES), backup-dot-files-$(f))

restore: clean $(foreach f, $(DOT_FILES), restore-dot-files-$(f))

remove: restore  $(foreach f, $(DOT_FILES), remove-dot-files-$(f))

clean: $(foreach f, $(DOT_FILES), unlink-dot-file-$(f))

zsh: $(foreach f, $(filter .zsh%, $(DOT_FILES)), link-dot-file-$(f))

vim: $(foreach f, $(filter .vim%, $(DOT_FILES)), link-dot-file-$(f)) vim-dependency gvim

gvim: $(foreach f, $(filter .gvim%, $(DOT_FILES)), link-dot-file-$(f))

tmux: $(foreach f, $(filter .tmux%, $(DOT_FILES)), link-dot-file-$(f))

git: $(foreach f, $(filter .git%, $(DOT_FILES)), link-dot-file-$(f))

dircolors: $(foreach f, $(filter .dir_colors%, $(DOT_FILES)), link-dot-file-$(f))

starship: zsh/bin/Darwin/starship zsh/bin/Linux/x86_64/starship

zsh/bin/Darwin/starship:
	@echo "Downloading Starship for macOS..."
	@curl -fsSL https://github.com/starship/starship/releases/latest/download/starship-aarch64-apple-darwin.tar.gz | tar -xzC zsh/bin/Darwin

zsh/bin/Linux/x86_64/starship:
	@echo "Downloading Starship for Linux..."
	@curl -fsSL https://github.com/starship/starship/releases/latest/download/starship-x86_64-unknown-linux-musl.tar.gz | tar -xzC zsh/bin/Linux/x86_64/starship

tmux-plugins: tmux/plugins/tpm

tmux/plugins/tpm:
	@echo "Installing TPM (Tmux Plugin Manager)..."
	@git clone https://github.com/tmux-plugins/tpm tmux/plugins/tpm
	@mkdir -p tmux/log
	@echo "TPM installed. Run 'prefix + I' in tmux to install plugins."

make-backup-dir:
	mkdir -p $(BACKUPDIR)

make-dotdir-%: %
	@echo "Create Directory => $(HOME)/$<"
	@mkdir -p $(HOME)/$<

vim-dependency:
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	vim +PlugInstall +qal

link-dot-file-%: %
	@echo "Create Symlink $(shell echo $< | sed "s/^.//") => $(HOME)/$<"
	@ln -snf $(CURRENTDIR)/$(shell echo $< | sed "s/^.//") $(HOME)/$<

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

.PHONY: clean $(DOT_FILES)
