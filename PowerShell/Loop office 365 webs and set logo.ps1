[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client")
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Runtime")

Function Get-SPOCredentials([string]$UserName,[string]$Password)
{
   $SecurePassword = $Password | ConvertTo-SecureString -AsPlainText -Force
   return New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($UserName, $SecurePassword)
}

Function Web-SetLogo([string]$Url)
{
 
    $context = New-Object Microsoft.SharePoint.Client.ClientContext($Url)
    $context.Credentials = Get-SPOCredentials -UserName $UserName -Password $Password
    $web = $context.Web
    $context.Load($web)
    $context.Load($web.Webs)
    $context.Web.SiteLogoUrl = $SiteLogoUrl
    $context.Web.Update()
    $context.ExecuteQuery()
    Write-Host 'Web Url:' $web.Url 
    foreach($web in $web.Webs)
    {
      Web-SetLogo -Url $web.Url
       
    }

}

$UserName = "george@norberg.com"
$Password = Read-Host -Prompt "Enter the password"    
$Url = "https://cap.sharepoint.com"
$SiteLogoUrl = "https://cap.sharepoint.com/url"

Write-Host 'Start'


Web-SetLogo -Url $Url 
Write-Host 'Done'