## Variables
 
$emailReceiverName = "emailreceiver"
$emailAddress = "stephanschiller@gmx.net"
$actionGroupName = "email-ag"
$actionGroupShortName = $actionGroupName
$rgName = "PowershellTest"
$tagName = "Environment"
$tagValue = "Demo"
$time = Get-Date -UFormat "%A %m/%d/%Y %R"
$foregroundColor1 = "Red"
$writeEmptyLine = "`n"
$writeSeperator = " - "
$allResources = @()
$subscriptions=Get-AzureRMSubscription

# For backwards compatibility
#Enable-AzureRmAlias
# Login-Az Account
#Connect-AzAccount 

## Create a new Action Group Email receiver
 
$emailReceiver = New-AzActionGroupReceiver -Name $emailReceiverName -EmailReceiver -EmailAddress $emailAddress
 
Write-Host ($writeEmptyLine + "# Action Group Receiver $emailReceiverName saved in memory" + $writeSeperator + $time)`
#-foregroundcolor $foregroundColor1 $writeEmptyLine

## Create a new Action Group
 
$tag = New-Object "System.Collections.Generic.Dictionary``2[System.String,System.String]"
$tag.Add($tagName,$tagValue)
 
Set-AzActionGroup -Name $actionGroupName -ResourceGroup $rgName -ShortName $actionGroupShortName -Receiver $emailReceiver -Tag $tag
 
Write-Host ($writeEmptyLine + "# Action Group $actionGroupName created" + $writeSeperator + $time)`
-foregroundcolor $foregroundColor1 $writeEmptyLine
$actiongroup = Get-AzActionGroup -Name $actionGroupName -ResourceGroup $rgName -WarningAction Ignore

#For Loop through all Azure subscriptions
ForEach ($vsub in $subscriptions){
Select-AzSubscription $vsub.SubscriptionID

Write-Host “Working on “ $vsub


$params = @{
    activityLogAlertName = "TamOps Azure Service Notification" + $vsub.Name
    actionGroupResourceId = $actiongroup.id
}
 
New-AzResourceGroupDeployment `
    -Name "Azure-Service-Notification" `
    -ResourceGroupName "tamops" `
    -TemplateFile "C:\ServiceHealthAlert/ServiceHealthAlert.json" `
    -TemplateParameterObject $params
}