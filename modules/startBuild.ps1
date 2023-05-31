### Variables
    $resourceGroupName = "rg-avdaib-prd-we-03"
    $imageTemplateName = "avd10ImageTemplate03"
    $galleryName = "acg_avdcomputegallary_prd_we_03"
    $imageDefinitionName = "wind10avd22h2"
    $imageversion = Get-AzGalleryImageVersion -ResourceGroupName rg-avdaib-prd-we-03 -GalleryName acg_avdcomputegallary_prd_we_03 -GalleryImageDefinitionName wind10avd22h2 | Sort-Object -Bottom 1;
    $region1 = @{Name='West Europe';ReplicaCount=1}
    $region2 = @{Name='southeastasia';ReplicaCount=1}
    $regions = @($region1,$region2)
    
    
    Install-Module Az.ImageBuilder -force
    Import-Module Az.ImageBuilder

### Build image
    Start-AzImageBuilderTemplate -ResourceGroupName $resourceGroupName -Name $imageTemplateName -NoWait

### Get build status
    $buildStatus=$(Get-AzImageBuilderTemplate -ResourceGroupName $resourceGroupName -Name $imageTemplateName)
    $buildStatus | Format-List -Property *
    $buildStatus.LastRunStatusRunState 
    $buildStatus.LastRunStatusRunSubState
    
    ### Wait Here until the new Image Version Created
    
    Start-Sleep -Seconds 10000
    
    ### Add New Regional Replication Option to the Image
    
    Update-AzGalleryImageVersion -ResourceGroupName $resourceGroupName -GalleryName $galleryName -GalleryImageDefinitionName $imageDefinitionName -Name $imageversion.Name -ReplicaCount 1 -TargetRegion $regions
    
    Write-Host "Image Version Created and Replicated to all necessary regions!"
    
    
