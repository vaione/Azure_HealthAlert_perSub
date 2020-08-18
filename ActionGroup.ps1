## Variables
 
$emailReceiverName = "emailreceiver"
$emailAddress = "stephanschiller@gmx.net"
$actionGroupName = "SHTest"
$actionGroupShortName = $actionGroupName
$rgName = "ServiceHealthTest"
$tagName = "Environment"
$tagValue = "Demo"
$time = Get-Date -UFormat "%A %m/%d/%Y %R"
$foregroundColor1 = "Red"
$writeEmptyLine = "`n"
$writeSeperator = " - "
$allResources = @()
$subscriptions=Get-AzureRMSubscription

# For backwards compatibility
Enable-AzureRmAlias
# Login-Az Account
#Connect-AzAccount 
$email1 = New-Object  Microsoft.Azure.Commands.Insights.OutputClasses.PSEmailReceiver
$email1.EmailAddress = "stephanschiller@gmx.net"
$email1.Name = "Stephan"
$recievers = @($email1)

$tag = New-Object "System.Collections.Generic.Dictionary``2[System.String,System.String]" 
$tag.Add($tagName,$tagValue)

#For Loop through all Azure subscriptions
ForEach ($vsub in $subscriptions){
Select-AzSubscription $vsub.SubscriptionID

Write-Host “Working on “ $vsub
Set-AzureRmActionGroup -Name $actionGroupName -ResourceGroup $rgName -ShortName $actionGroupShortName -Receiver $recievers -Tag $tag
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
