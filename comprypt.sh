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

comp_decomp_encr_decr() {

    another_task() {
        echo
        read -p "Do you want to do another task? [y/n] " another_task
        if [ "$another_task" = "y" ]; then
            clear
            echo "Ok, lets do another task"
            echo
            ls
            echo
            comp_decomp_encr_decr
        elif [ "$another_task" = "n" ]; then
            clear
            echo "Ok, bye bye"
            echo
        else
            echo "Invalid input, Please enter y or n"
            echo
            another_task
        fi
    }

    # --------------------------- Compress & Decompress -------------------------- #
    # ------------- Compress ------------- #
    copmpress(){
        echo
        if [ -f "$name" ] || [ -d "$name" ]; then
            echo "Good, $name do exists, lets compress it"
            echo
            zip -r "$name.zip" "$name" >/dev/null
            clear
            echo "The file/folder has been compressed"
            echo
            echo "Now lets delete the original file"
            rm "$name"

            name=$(echo "$name.zip")

            another_task
        else
            echo "The file/folder does not exist" 
        fi
    }
    # ------------- Compress ------------- #

    # ------------- Decompress ------------- #
    decompress() {
        echo
        if [ -f "$name" ]; then
            echo "Good, $name do exists, lets compress it"
            unzip "$name" >/dev/null
            clear
            echo "The file has been decompressed"
            echo
            echo "Now lets delete the compressed file"
            rm "$name"
            
            name=$(basename "$name" .zip)
            
            another_task
        else
            echo "The file does not exist"
        fi
    }
    # ------------- Decompress ------------- #
    # --------------------------- Compress & Decompress -------------------------- #

    # ----------------------------- Encrypt & Decrypt ---------------------------- #
    # ------------- Encrypt ------------- #
    encrypt(){
        # read -p "Enter the name or full path of the file/folder you would like to encrypt: " encrypt_file
        echo
        if [ -f "$name" ]; then
            echo "Good, $name do exists, lets encrypt it"
            echo
            gpg -c "$name" >/dev/null
            clear
            echo "The file has been encrypted"
            echo
            echo "Now lets delete the original file"
            rm "$name"

            name=$(echo "$name.gpg")

            another_task
        else
            echo "The file does not exist"
        fi
    }
    # ------------- Encrypt ------------- #

    # ------------- Decrypt ------------- #
    decrypt(){
        # read -p "Enter the name or full path of the file/folder you would like to encrypt: " encrypt_file
        echo
        name_without_extension=$(basename "$name" .gpg)
        name_with_extension=$(echo "$name.gpg")

        if [ -f "$name" ] && [ "${name##*.}" = "gpg" ]; then
            echo "Good, '$name' do exists, lets decrypt it"
            gpg -d "$name" > $name_without_extension
            echo
            echo "Now lets delete the encrypted file"
            rm -f "$name"
            
            name=$(basename "$name" .gpg)
            another_task

        else
            echo "Sorry, $name do not exists or is not a gpg file"
        fi
    # ------------- Decrypt ------------- #
    }
    # ----------------------------- encrypt & decrypt ---------------------------- #

    choose() {
        read -p """Which of the following tasks would you like to achieve
                        
        1- Compress $name
        2- Decompress $name
        3- Encrypt $name
        4- Decrypt $name
        
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
    choose
}

# check if any parameters were passed
if [ -z "$1" ]; then
    read -p "please enter the name or full path of the file/folder: " name
    comp_decomp_encr_decr
else
    name=$1
    comp_decomp_encr_decr
fi