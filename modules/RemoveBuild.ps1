#Variables
    $resourceGroupName = "rg-avdaib-prd-we-03"
    $imageTemplateName = "avd10ImageTemplate03"
    
    Install-Module Az.ImageBuilder -force
    Import-Module Az.ImageBuilder
    
#Verify the previous Template

    $Template = Get-AzImageBuilderTemplate
    If ($Template.Name -like "avd10ImageTemplate03"){
    
        Remove-AzImageBuilderTemplate -Name $Template.Name -ResourceGroupName $Template.ResourceGroupName
    }Else {
    
        Write-Host "Template does not exist and will be created." 
    }
    
    Start-Sleep -Seconds 300
