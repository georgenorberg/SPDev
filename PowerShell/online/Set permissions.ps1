function update-SPOnlineSitePermissions {
  #variables that needs to be set before starting the script
  $webURL = "https://spfire.sharepoint.com/sites/BlogDemo/MyFirstWeb"
  $adminUrl = "https://spfire-admin.sharepoint.com"
  $userName = "mpadmin@spfire.onmicrosoft.com"
  $members = "i:0#.f|membership|mpadmin@spfire.onmicrosoft.com"</pre>
# Let the user fill in their password in the PowerShell window
$password = Read-Host "Please enter the password for $($userName)" -AsSecureString
 
# set SharePoint Online credentials
$SPOCredentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($userName, $password)
 
# Creating client context object
$context = New-Object Microsoft.SharePoint.Client.ClientContext($webURL)
$context.credentials = $SPOCredentials
$web = $context.web
$context.load($web)
 
$web.breakroleinheritance($false, $false)
$web.update()
#send the request containing all operations to the server
try{
$context.executeQuery()
write-host "info: Broken inheritance for $($web.title)" -foregroundcolor green
}
catch{
write-host "info: $($_.Exception.Message)" -foregroundcolor red
}
 
#Create new groups
$siteGroups = "$($web.title) visitors", "$($web.title) members", "$($web.title) owners"
foreach ($siteGroup in $siteGroups){
if ($siteGroup -like "*visitors")
{
$gci = New-Object Microsoft.SharePoint.Client.GroupCreationInformation
$gci.Title = $siteGroup
$siteGroup = $Context.Web.SiteGroups.Add($gci)
$PermissionLevel = $Context.Web.RoleDefinitions.GetByName("Read")
 
#Bind Permission Level to Group
$RoleDefBind = New-Object Microsoft.SharePoint.Client.RoleDefinitionBindingCollection($Context)
$RoleDefBind.Add($PermissionLevel)
$Assignments = $Context.Web.RoleAssignments
$RoleAssignOneNote = $Assignments.Add($siteGroup,$RoleDefBind)
$Context.Load($siteGroup)
#send the request containing all operations to the server
try{
$context.executeQuery()
write-host "info: Added visitors group" -foregroundcolor green
}
catch{
write-host "info: $($_.Exception.Message)" -foregroundcolor red
}
}
 
if ($siteGroup -like "*members")
{
$gci = New-Object Microsoft.SharePoint.Client.GroupCreationInformation
$gci.Title = $siteGroup
$siteGroup = $Context.Web.SiteGroups.Add($gci)
$PermissionLevel = $Context.Web.RoleDefinitions.GetByName("Edit")
 
#Bind Permission Level to Group
$RoleDefBind = New-Object Microsoft.SharePoint.Client.RoleDefinitionBindingCollection($Context)
$RoleDefBind.Add($PermissionLevel)
$Assignments = $Context.Web.RoleAssignments
$RoleAssignOneNote = $Assignments.Add($siteGroup,$RoleDefBind)
$Context.Load($siteGroup)
#send the request containing all operations to the server
try{
$context.executeQuery()
write-host "info: Added members group" -foregroundcolor green
}
catch{
write-host "info: $($_.Exception.Message)" -foregroundcolor red
}
}
 
if ($siteGroup -like "*owners")
{
$gci = New-Object Microsoft.SharePoint.Client.GroupCreationInformation
$gci.Title = $siteGroup
$siteGroup = $Context.Web.SiteGroups.Add($gci)
$PermissionLevel = $Context.Web.RoleDefinitions.GetByName("Full Control")
 
#Bind Permission Level to Group
$RoleDefBind = New-Object Microsoft.SharePoint.Client.RoleDefinitionBindingCollection($Context)
$RoleDefBind.Add($PermissionLevel)
$Assignments = $Context.Web.RoleAssignments
$RoleAssignOneNote = $Assignments.Add($siteGroup,$RoleDefBind)
$Context.Load($siteGroup)
#send the request containing all operations to the server
try{
$context.executeQuery()
write-host "info: Added owners group" -foregroundcolor green
}
catch{
write-host "info: $($_.Exception.Message)" -foregroundcolor red
}
}
}
 
#add user to group
$spGroups = $Web.SiteGroups
$context.Load($spGroups)
$spGroup=$spGroups.GetByName("$($web.title) members")
 
$spUser = $context.Web.EnsureUser($members)
$context.Load($spUser)
$spUserToAdd=$spGroup.Users.AddUser($spUser)
$context.Load($spUserToAdd)
try{
$context.executeQuery()
write-host "info: Added user to members group" -foregroundcolor green
}
catch{
write-host "info: $($_.Exception.Message)" -foregroundcolor red
}
}
update-SPOnlineSitePermissions