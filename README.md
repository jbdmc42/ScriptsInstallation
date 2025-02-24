# ScriptsInstallation
openVSC42 and compCS42 download and install

# HOW TO USE AND INSTALL: openVSC42 compCS42

# 1. Access  and use git clone on the terminal to get the files

# 2. On Visual Studio Code, download the 42 HEADER (LONG) extension

# 3. Use the Makefile to install the scripts.
↳ Do "make install" on the folder where you have the Makefile
↳ Do "export PATH=$HOME/bin:$PATH" 
+ "source ~/.zshrc" or "source ~/.bashrc" depending on the type of terminal you're using

# 4. Install xdotool.
↳ In Home directory, do "mkdir -p ~/local" 
+ "cd ~/local" 
+ "git clone https://github.com/jordansissel/xdotool.git" 
+ "cd xdotool" 
+ "make" 
+ "make install PREFIX=$HOME/.local" 
+ "export PATH=$HOME/.local/bin:$PATH" 
+ "echo 'export PATH=$HOME/.local/bin:$PATH' > ~/.zshrc" (or ~/.bashrc)
+ "source ~/.zshrc" (or ~/.bashrc)

# 5. Install code.
↳ Do "echo $PATH" and look for /snap/bin
↳ If you don't find it, do "export PATH=/snap/bin:$PATH"
+ echo 'export PATH=/snap/bin:$PATH' > ~/.zshrc" (or ~/.bashrc)
↳ Do "wget https://update.code.visualstudio.com/latest/linux-x64/stable -O vscode.tar.gz"
+ "mkdir -p ~/vscode"
+ "tar -xvzf vscode.tar.gz -C ~/vscode --strip-components=1"
↳ Do "export PATH="$HOME/vscode/bin:$PATH"
+ "source ~/.zshrc" (or ~/.bashrc)
↳ To verify use "code --version"

# 6. To use openVSC42, do "openVSC42 file_name.c --with-header" to open the file on Visual Studio Code and generate a header automatically (remember that you need the 42 HEADER (LONG) extension to generate the header)

# 7. To use compCS42, do "compCS42 filename.c"

# 8. For more info, do "openVSC42" or "compCS42"

I WILL MAKE A FILE EXPLAINING MY CODE IN THE FUTURE. I HOPE YOU ENJOY MY WORK ;D
