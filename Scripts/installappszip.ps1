# Set the storage account name and container name
$storageAccountName = "storageAccountName"
$containerName = "containerName"

# Set the key vault name and secret name where the storage account key is stored
$keyVaultName = "keyVaultName"
$secretName = "secretName"

# Get the storage account key from key vault
$storageAccountKey = (Get-AzKeyVaultSecret -VaultName $keyVaultName -Name $secretName).SecretValueText

# Set the local folder to download the .zip files to
$downloadFolder = "C:\temp"

# Create an array of zip file names to install
$zipFiles = @("zipFile1.zip", "zipFile2.zip", "zipFile3.zip")

# Loop through the list of zip files and and download them from the storage account blob
foreach ($zipFile in $zipFiles) {
    # Set the source blob URL
    $sourceBlobUrl = "https://$storageAccountName.blob.core.windows.net/$containerName/$zipFile"

    # Set the destination file path
    $destinationFilePath = Join-Path $downloadFolder $zipFile    
    
    # Get the zip file from Azure storage
    $context = New-AzureStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageAccountKey
    $zipFileUrl = (Get-AzureStorageBlob -Container $containerName -Blob $zipFile -Context $context).ICloudBlob.Uri.AbsoluteUri
    Invoke-WebRequest -Uri $zipFileUrl -OutFile $zipFile

    # Extract the contents of the zip file
    Expand-Archive -Path $zipFile -DestinationPath .

    # Download the blob
    $context = New-AzStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageAccountKey
    Get-AzStorageBlobContent -Blob $zipFile -Container $containerName -Context $context -Destination $destinationFilePath

    # Run the installation script
    & $downloadFolder

    # Clean up the extracted files
    Remove-Item -Path * -Recurse -Force
}
