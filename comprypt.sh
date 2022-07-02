check_zip() {
    if (ls /bin | grep "zip" >/dev/null); then
        echo "Good, zip is installed lets's move on to the next step"
        echo
    else
        read -p "zip is not installed, would you like to install it? [y/n] " install_zip
        if [ "$install_zip" = "y" ]; then
            sudo apt-get install zip
        elif [ "$install_zip" = "n" ]; then
            echo "Please install zip and try again"
            exit 1
        else
            echo "Invalid input, Please enter y or n"
            check_zip
        fi
    fi
}
check_zip

name=$1
# echo $name 

# --------------------------- compress & decompress -------------------------- #
copmpress(){
    # read -p "Enter the name or full path of the file/folder you would like to compress: " compress_file
    echo
    if [ -f "$name" ] || [ -d "$name" ]; then
        echo "Good, $name do exists, lets compress it"
        echo
        zip -r "$name.zip" "$name" >/dev/null
        clear
        sleep 1
        echo "The file/folder has been compressed"
    else
        echo "The file/folder does not exist"
        exit 1 
    fi
}

decompress() {
    # read -p "Enter the name or full path of the file you would like to decompress: " decompress_file
    echo
    if [ -f "$name" ]; then
        echo "Good, $name do exists, lets compress it"
        unzip "$name" >/dev/null
        sleep 1
        clear
        echo "The file has been decompressed"
    else
        echo "The file does not exist"
    fi
}
# --------------------------- compress & decompress -------------------------- #

# ----------------------------- encrypt & decrypt ---------------------------- #
encrypt(){
    # read -p "Enter the name or full path of the file/folder you would like to encrypt: " encrypt_file
    echo
    if [ -f "$name" ]; then
        echo "Good, $name do exists, lets encrypt it"
        echo
        gpg -c "$name" >/dev/null
        sleep 1
        clear
        echo "The file has been encrypted"
    else
        echo "The file does not exist"
        exit 1 
    fi
}

decrypt(){
    # read -p "Enter the name or full path of the file/folder you would like to encrypt: " encrypt_file
    echo
    if [ -f "$name" ]; then
        echo "Good, $name do exists, lets decrypt it"
        echo
        gpg -d "$name.gpg" > $name
        sleep 1
        clear
        echo "The file has been encrypted"
    else
        echo "The file does not exist"
        exit 1 
    fi
}
# ----------------------------- encrypt & decrypt ---------------------------- #

choose() {
    read -p """Which of the following tasks would you like to achieve
                    
    1- Compress Files or Folder
    2- Decompress Files or Folder
    3- Encrypt Files or Folder
    4- Decrypt Files or Folder
    
    (1),(2),(3),(4): """ confirm

    if [ "$confirm" = "1" ]; then
        copmpress
    elif [ "$confirm" = "2" ]; then
        decompress
    elif [ "$confirm" = "3" ]; then
        encrypt
    elif [ "$confirm" = "4" ]; then
        decrypt
    else
        echo "Invalid input, Please enter 1,2,3 or 4"
        echo
        choose
    fi
}

# check if any parameters were passed
if [ -z "$1" ]; then
    read -p "please enter the name or full path of the file/folder: " name
    choose
else
    choose
fi