
$Dir = get-childitem .\assets\wallpapers\
$List = $Dir | where {$_.extension -eq ".png"}
$List | ForEach-Object {
    $File = $_.Name
    $image = [System.Drawing.Image]::FromFile('.\assets\wallpapers\'+$File)
    Write-Output( $File + ':          ' + $image.Width + ', ' + $image.Height )
}

$Dir = get-childitem .\assets\gifs\
$List = $Dir | where {$_.extension -eq ".gif"}
$List | ForEach-Object {
    $File = $_.Name
    $image = [System.Drawing.Image]::FromFile('.\assets\gifs\'+$File)
    Write-Output( $File + ':          ' + $image.Width + ', ' + $image.Height )
}
