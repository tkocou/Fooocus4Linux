#!/usr/bin/bash
## This script is derived from a script written by ParisNeo
## It is used with the permission of ParisNeo (https://github.com/ParisNeo/lollms-webui)

if ping -q -c 1 google.com >/dev/null 2>&1; then
    echo -e "\e[32mInternet Connection working fine\e[0m"
    # Install git
    echo -n "Checking for Git..."
    if command -v git > /dev/null 2>&1; then
      echo "is installed"
    else
      read -p "Git is not installed. Would you like to install Git? [Y/N] " choice
      if [ "$choice" = "Y" ] || [ "$choice" = "y" ]; then
        echo "Installing Git..."
        sudo apt update
        sudo apt install -y git
      else
        echo "Please install Git and try again."
        exit 1
      fi
    fi

    # Check if repository exists 
    if [[ -d .git ]] ;then
    echo Pulling latest changes for Fooocus
    git pull origin main
    else
      if [[ -d Fooocus ]] ;then
        cd Fooocus
        echo Pulling latest version for Fooocus
        git pull
      else
        echo Cloning repository...
        git clone https://github.com/lllyasviel/Fooocus.git ./Fooocus
        cd Fooocus
      fi
    fi

    # Install Python 3.10 and pip
    echo -n "Checking for python3.10..."
    if command -v python3.10 > /dev/null 2>&1; then
      echo "is installed"
    else
      read -p "Python3.10 is not installed. Would you like to install Python3.10? [Y/N] " choice
      if [ "$choice" = "Y" ] || [ "$choice" = "y" ]; then
        echo "Installing Python3.10..."
        sudo apt update
        sudo apt install -y python3.10 python3.10-venv
      else
        echo "Please install Python3.10 and try again."
        exit 1
      fi
    fi

    # Install venv module
    echo -n "Checking for venv module..."
    if python3.10 -m venv fooocus_env > /dev/null 2>&1; then
      echo "is installed"
    else
      read -p "venv module is not available. Would you like to install it? [Y/N] " choice
      if [ "$choice" = "Y" ] || [ "$choice" = "y" ]; then
        echo "Installing venv module..."
        sudo apt update
        sudo apt install -y python3.10-venv
      else
        echo "Please install venv module and try again."
        exit 1
      fi
    fi

    # Create a new virtual environment
    echo -n "Creating virtual environment..."
    python3.10 -m venv fooocus_env
    if [ $? -ne 0 ]; then
      echo "Failed to create virtual environment. Please check your Python installation and try again."
      exit 1
    else
      echo "is created"
    fi
fi


# Activate the virtual environment
echo -n "Activating virtual environment..."
source fooocus_env/bin/activate
echo "is active"

# Install the required packages
echo "Installing requirements..."
python3.10 -m pip install pip --upgrade
python3.10 -m pip install pygit2==1.12.2
python3.10 -m pip install --upgrade -r requirements_versions.txt

if [ $? -ne 0 ]; then
  echo "Failed to install required packages. Please check your internet connection and try again."
  exit 1
fi



# Launch the Python application
echo "Starting Fooocus interface..."
echo
python entry_with_update.py
