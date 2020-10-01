
$L = Import-Csv -Path .\assets\scripts\sticker-list.csv | Sort-Object -Property Title

Write-Output "** <noscript>"
$L | ForEach-Object {
    $File = $_.File
    $Title = $_.Title

    Write-Output "        <img class='noscript-card' src='./$File' alt='$Title'/>"
}


Write-Output "** images[]"
$L | ForEach-Object {
    $File = $_.File
    $Title = $_.Title

    Write-Output "          [ './$File', '$Title'], "
}


Write-Output "** <sitemap>"
$L | ForEach-Object {
    $File = $_.File
    $Title = $_.Title

    Write-Output "    <image:image>"
    Write-Output "      <image:loc>https://condaluna.com/$File</image:loc>"
    Write-Output "      <image:title>$Title</image:title>"
    Write-Output "    </image:image>"
}
