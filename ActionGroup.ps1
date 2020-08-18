## Variables
$actionGroupName = "SHTest"
$actionGroupShortName = $actionGroupName
$rgName = "ServiceHealthTest"
$location = "northeurope"
$tagName = "Environment"
$tagValue = "Demo"
$subscriptions=Get-AzureRMSubscription
$email1 = New-Object  Microsoft.Azure.Commands.Insights.OutputClasses.PSEmailReceiver
$email1.EmailAddress = "maxmustermann@gmx.net"
$email1.Name = "Stephan"
$receivers = @($email1)
$tag = New-Object "System.Collections.Generic.Dictionary``2[System.String,System.String]" 
$tag.Add($tagName,$tagValue)


#For Loop through all Azure subscriptions
ForEach ($vsub in $subscriptions){
Select-AzSubscription $vsub.SubscriptionID

Write-Host “Working on “ $vsub
#Create resource group
New-AzResourceGroup -Name $rgName -Location $location
#Create action group
Set-AzureRmActionGroup -Name $actionGroupName -ResourceGroup $rgName -ShortName $actionGroupShortName -Receiver $receivers -Tag $tag
#Get Azure Resource Manager ID
$actiongroup = Get-AzureRmActionGroup -Name $actionGroupName -ResourceGroup $rgName 
$params = @{
    activityLogAlertName = "TamOps Azure Service Notification" + $vsub.Name
    actionGroupResourceId = $actiongroup.id
}
 
New-AzResourceGroupDeployment `
    -Name "Azure-Service-Notification" `
    -ResourceGroupName $rgName `
    -TemplateFile "ServiceHealthAlert.json" `
    -TemplateParameterObject $params
}
