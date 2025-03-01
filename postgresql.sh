#!/bin/bash


# Function to check if PostgreSQL is installed
is_postgresql_installed() {
    if command -v psql >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}


# Function to install PostgreSQL on Ubuntu
install_postgresql() {
    echo "PostgreSQL is not installed. Installing now..."
    sudo apt update
    sudo apt install -y postgresql postgresql-contrib
    sudo systemctl enable postgresql
    sudo systemctl start postgresql
    echo "PostgreSQL installation completed successfully."
}


# Main Script Execution
echo "Checking if PostgreSQL is installed..."


if is_postgresql_installed; then
    echo "PostgreSQL is already installed."
    psql --version
else
    install_postgresql
fi
