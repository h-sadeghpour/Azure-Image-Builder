#Variables
    $resourceGroupName = "rg-avdaib-prd-we-03"
    $imageTemplateName = "avd10ImageTemplate03"
    
    Install-Module Az.ImageBuilder -force
    Import-Module Az.ImageBuilder

#Build image
    Start-AzImageBuilderTemplate -ResourceGroupName $resourceGroupName -Name $imageTemplateName -NoWait

#Get build status
    $buildStatus=$(Get-AzImageBuilderTemplate -ResourceGroupName $resourceGroupName -Name $imageTemplateName)
    $buildStatus | Format-List -Property *
    $buildStatus.LastRunStatusRunState 
    $buildStatus.LastRunStatusRunSubState
