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

# name=$1

# echo $name 
comp_decomp_encr_decr() {

        # do you want to do another task?
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

    # --------------------------- compress & decompress -------------------------- #
    copmpress(){
        # read -p "Enter the name or full path of the file/folder you would like to compress: " compress_file
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

        # create var with the name of the file with the extension exist
        elif [ -f "$compress_with_extens"] || [ -d "$compress_with_extens" ]; then
            compress_with_extens=$(echo "$name".*)
            echo "Good, $compress_with_extens do exists, lets compress it"
            echo
            zip -r "$compress_with_extens.zip" "$compress_with_extens" >/dev/null
            clear
                echo "The file/folder has been compressed"
            echo
            echo "Now lets delete the original file"
            rm "$compress_with_extens"
            
            name=$(echo "$compress_with_extens.zip")
            another_task
        else
            echo "Sorry, $name do not exists"
            echo
            another_task
        fi
    }

    decompress() {
        # read -p "Enter the name or full path of the file you would like to decompress: " decompress_file
        name_with_extension=$(echo "$name".*)
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

        elif [ -f "$name_with_extension" ]; then
            name_with_extension=$(echo "$name".*)
            echo "Good, $name_with_extension do exists, lets decompress it"
            unzip "$name_with_extension" >/dev/null
            clear
            echo "The file has been decompressed"
            echo
            echo "Now lets delete the compressed file"
            rm "$name_with_extension"
            
            name=$(basename "$name_with_extension" .zip)
            another_task
        else
            echo "$name".*
            echo $name_with_extension
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

    decrypt(){
        # read -p "Enter the name or full path of the file/folder you would like to encrypt: " encrypt_file
        echo
        name_without_extension=$(basename "$name" .gpg)
        if [ -f "$name" ] && [ "${name##*.}" = "gpg" ]; then
            echo "Good, '$name' do exists, lets decrypt it"
            gpg -d "$name" > $name_without_extension
            echo
            echo "Now lets delete the encrypted file"
            rm -f "$name"
            
            name=$(basename "$name" .gpg)
            another_task

        name_with_extension=$(echo "$name.gpg")
        elif [ -f "$name_with_extension" ] && [ "${name_with_extension##*.}" = "gpg" ]; then
            echo "Good, '$name_with_extension' do exists, lets decrypt it"
            gpg -d "$name_with_extension" > $name
            echo
            echo "Now lets delete the encrypted file"
            rm -f "$name_with_extension"

            name=$(basename "$name_with_extension" .gpg)
            another_task
        else
            echo "Sorry, $name do not exists or is not a gpg file"
        fi
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