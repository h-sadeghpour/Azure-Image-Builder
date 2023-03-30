# Set the storage account name and container name
$storageAccountName = "your-storage-account-name"
$containerName = "your-container-name"

# Set the key vault name and secret name where the storage account key is stored
$keyVaultName = "your-keyvault-name"
$secretName = "your-secret-name"

# Get the storage account key from key vault
$storageAccountKey = (Get-AzKeyVaultSecret -VaultName $keyVaultName -Name $secretName).SecretValueText

# Set the local folder to download the .exe files to
$downloadFolder = "C:\temp"

# Set the list of .exe file names to download
$fileNames = @("file1.exe", "file2.exe", "file3.exe", "file4.exe", "file5.exe", "file6.exe")

# Loop through the list of .exe files and download them from the storage account blob
foreach ($fileName in $fileNames) {
    # Set the source blob URL
    $sourceBlobUrl = "https://$storageAccountName.blob.core.windows.net/$containerName/$fileName"

    # Set the destination file path
    $destinationFilePath = Join-Path $downloadFolder $fileName

    # Download the blob
    $context = New-AzStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageAccountKey
    Get-AzStorageBlobContent -Blob $fileName -Container $containerName -Context $context -Destination $destinationFilePath

    # Install the .exe file silently
    Start-Process $destinationFilePath -ArgumentList "/S" -Wait
}
