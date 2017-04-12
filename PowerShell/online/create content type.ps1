http://www.sharepointfire.com/2016/01/create-new-content-type-sharepoint-online-powershell/

function new-SPOnlineContentType {
    #variables that needs to be set before starting the script
    $siteURL = "https://spfire.sharepoint.com/sites/blogdemo"
    $adminUrl = "https://spfire-admin.sharepoint.com"
    $userName = "mpadmin@spfire.onmicrosoft.com"
    $contentTypeGroup = "My Content Types"
    $contentTypeName = "Blog Content Type"
    $columns = "BlogNumber", "BlogText", "BlogUser"
    $parentContentTypeID = "0x0101"
     
    # Let the user fill in their password in the PowerShell window
    $password = Read-Host "Please enter the password for $($userName)" -AsSecureString
     
    # set SharePoint Online credentials
    $SPOCredentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($userName, $password)
         
    # Creating client context object
    $context = New-Object Microsoft.SharePoint.Client.ClientContext($siteURL)
    $context.credentials = $SPOCredentials
    $fields = $context.web.fields
    $contentTypes = $context.web.contenttypes
    $context.load($fields)
    $context.load($contentTypes)
     
    # send the request containing all operations to the server
    try{
        $context.executeQuery()
        write-host "info: Loaded Fields and Content Types" -foregroundcolor green
    }
    catch{
        write-host "info: $($_.Exception.Message)" -foregroundcolor red
    }
         
    # Loop through all content types to verify it doesn't exist
    foreach ($contentType in $contentTypes){
        if ($contentType.name -eq $contentTypeName){
            write-host "Info: The content type $($contentTypeName) already exists." -foregroundcolor red
            $contentTypeExists = $true
        }
        else{
            $contentTypeExists = $false
        }
    }
         
    # create content type if it doesnt exist based on specified Content Type ID
    if($contentTypeExists -eq $false){
        # load parent content type
        $parentContentType = $contentTypes.GetByID($parentContentTypeID)
        $context.load($parentContentType)
         
        # send the request containing all operations to the server
        try{
            $context.executeQuery()
            write-host "info: loaded parent Content Type" -foregroundcolor green
        }
        catch{
            write-host "info: $($_.Exception.Message)" -foregroundcolor red
        }
         
        # create Content Type using ContentTypeCreationInformation object (ctci)
        $ctci = new-object Microsoft.SharePoint.Client.ContentTypeCreationInformation
        $ctci.name = $contentTypeName
        $ctci.ParentContentType = $parentContentType
        $ctci.group = $contentTypeGroup
        $ctci = $contentTypes.add($ctci)
        $context.load($ctci)
         
        # send the request containing all operations to the server
        try{
            $context.executeQuery()
            write-host "info: Created content type" -foregroundcolor green
        }
        catch{
            write-host "info: $($_.Exception.Message)" -foregroundcolor red
        }
         
        # get the new content type object
        $newContentType = $context.web.contenttypes.getbyid($ctci.id)
         
        # loop through all the columns that needs to be added
        foreach ($column in $columns){
            $field = $fields.GetByInternalNameOrTitle($column)
            #create FieldLinkCreationInformation object (flci)
            $flci = new-object Microsoft.SharePoint.Client.FieldLinkCreationInformation
            $flci.Field = $field
            $addContentType = $newContentType.FieldLinks.Add($flci)
   write-host "info: added $($column) to array" -foregroundcolor green
        }        
        $newContentType.Update($true)
         
        # send the request containing all operations to the server
        try{
            $context.executeQuery()
            write-host "info: Added columns to content type" -foregroundcolor green
        }
        catch{
            write-host "info: $($_.Exception.Message)" -foregroundcolor red
        }
    }
}
new-SPOnlineContentType