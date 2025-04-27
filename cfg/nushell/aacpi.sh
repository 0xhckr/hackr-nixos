#!/usr/bin/env bash

# check if azure artifacts credprovider is installed in ~/.nuget/plugins/
if [ ! -d ~/.nuget/plugins/ ] || [ ! -d ~/.nuget/plugins/netcore/CredentialProvider.Microsoft ]; then
    echo "Azure Artifacts CredProvider is not installed"
    echo "Installing Azure Artifacts CredProvider..."
    wget -qO- https://aka.ms/install-artifacts-credprovider.sh | bash
fi