Add-PSSnapin Microsoft.Sharepoint.Powershell

$site = Get-SPSite -Identity "http://My_SharePoint_Site/"
$web = $site.RootWeb
$list = $web.Lists["<MY LIST>"]
$list.EventReceivers | Select assembly, name, type