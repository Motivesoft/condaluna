# Read the CSV file of file and title values
# Sort it by file name
$L = Import-Csv -Path .\assets\scripts\sticker-list.csv | Sort-Object -Property File

# Write the list of image array entries for stickers.html
$imagesArray=""
Write-Output "** images[]"
Write-Output "        let images=["
$L | ForEach-Object {
    $File = $_.File
    $Title = $_.Title
    $Background = $_.Background

    #Write-Output "          [ './$File', '$Title', '$Background' ],"
    $imagesArray = $imagesArray + "`r`n          [ './$File', '$Title', '$Background' ],"
}
Write-Output "        ];"

# Write the list of img values for the no-script scenario in stickers.html
$imagesNoscript=""
Write-Output "** <noscript>"
$L | ForEach-Object {
    $File = $_.File
    $Title = $_.Title
    $Background = $_.Background

    #Write-Output "        <img class='noscript-card' loading='auto' style='background: $Background;' src='./$File' title='$Title' alt='$Title'/>"
    $imagesNoscript = $imagesNoscript + "`r`n        <img class='noscript-card' loading='auto' style='background: $Background;' src='./$File' title='$Title' alt='$Title'/>"
}

# Write the list of image values for the stickers.html section in sitemap.xml
Write-Output "** <sitemap>"
$L | ForEach-Object {
    $File = $_.File
    $Title = $_.Title

    Write-Output "    <image:image>"
    Write-Output "      <image:loc>https://condaluna.com/$File</image:loc>"
    Write-Output "      <image:title>$Title</image:title>"
    Write-Output "    </image:image>"
}

#$x = "`r`n          ['x','#1'],`r`n          ['x','#1'],`r`n          ['x','#1'],`r`n          ['x','#1'],`r`n          ['x','#1'],"
#$y = "`r`n        <img class='noscript-card'/>`r`n        <img class='noscript-card'/>`r`n        <img class='noscript-card'/>`r`n        <img class='noscript-card'/>"

$content = [IO.File]::ReadAllText( '.\stickers.html' )

$content = ($content -replace "(?ms)^\s+let images=\[.*\];", "        let images=[$imagesArray`r`n        ];")
$content = ($content -replace "(?ms)^\s+<noscript id='stickers'>.*</noscript>", "      <noscript id='stickers'>$imagesNoscript`r`n      </noscript>")

[IO.File]::WriteAllText('.\stickers.html',$content)
