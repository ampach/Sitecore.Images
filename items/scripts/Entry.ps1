function Wait-Url ($url) {
    $maxRetries = 15
    $retryDelay = 10 # in seconds

    

    $statusCode = $null
    for ($i = 1; $i -le $maxRetries; $i++) {
        $webRequest = [System.Net.WebRequest]::Create($url)
        try {
            $response = $webRequest.GetResponse()
            $statusCode = $response.StatusCode.value__
            if ($statusCode -eq 200) {
                break
            }
        }
        catch {
            Write-Host "Failed attempt."
            Write-Host $_
        }
        Start-Sleep -Seconds $retryDelay
    }

    if ($statusCode -eq 200) {
        Write-Host "Success! HTTP 200 returned."
        return $true;
    }
    else {
        Write-Host "Failed to get HTTP 200 status code after $maxRetries attempts."
        return $false;
    }
}

function SyncContent($idHost, $cmHost, $clientSecret, $clientName) {    
    try {
        # Add nuget source & install Sitecore CLI
        Write-Host "Installing Sitecore CLI"
        
        dotnet nuget add source https://sitecore.myget.org/F/sc-packages/api/v3/index.json --name "Sitecore-Public-Nuget-Feed"
        dotnet tool install -g sitecore.cli --version 5.1.25 --add-source https://sitecore.myget.org/F/sc-packages/api/v3/index.json

        dotnet tool restore

        # Login to ID Server
        Write-Host "Logging into ID Server"
        dotnet sitecore login --client-credentials true --auth $idHost --cm $cmHost --allow-write true --client-id $clientName --client-secret $clientSecret --insecure

        # Deserialize Content
        Write-Host "Push Content"
        dotnet sitecore ser push

    }
    catch {
        Write-Host "Failed to install content"
        Write-Host $_
    }
}

$cmHost = Get-ChildItem -Path Env:\CM_HOST;

if (Wait-Url $cmHost.Value) {

    $idHost = Get-ChildItem -Path Env:\ID_HOST;    
    $clientSecret = Get-ChildItem -Path Env:\ID_CLIENT_SECRET;
    $clientName = Get-ChildItem -Path Env:\ID_CLIENT_NAME;

    SyncContent $idHost.Value $cmHost.Value $clientSecret.Value $clientName.Value

    Write-Output "Serialization is done."

    #while ($true) {
    #    Start-Sleep -s 600
    #}
	
	Start-Sleep -s 120
}
else {
    Write-Output "Something goes wrong."
}