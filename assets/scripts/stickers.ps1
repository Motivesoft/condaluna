[void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

# Read the CSV file of file and title values
# Sort it by file name
$L = Import-Csv -Path .\assets\scripts\sticker-list.csv | Sort-Object -Property File

# Write the list of image array entries for stickers.html
$imagesArray=""
Write-Output "--Image array"
$L | ForEach-Object {
    $File = $_.File
    $Title = $_.Title
    $Background = $_.Background

    $image = [System.Drawing.Image]::FromFile('./'+$File)
    $imagesArray = $imagesArray + "`r`n          [ './$File', '$Title', '$Background', " + $image.Width + ", " + $image.Height + " ],"
}

# Write the list of img values for the no-script scenario in stickers.html
$imagesNoscript=""
Write-Output "--Noscript entries"
$L | ForEach-Object {
    $File = $_.File
    $Title = $_.Title
    $Background = $_.Background

    $image = [System.Drawing.Image]::FromFile('./'+$File)
    $imagesNoscript = $imagesNoscript + "`r`n        <img class='noscript-card' style='background: $Background;' src='./$File' title='$Title' alt='$Title' width='"+$image.Width+"' height='"+$image.Height+"'/>"
}

# Write the list of image values for the stickers.html section in sitemap.xml
$pageEntries=""
Write-Output "--Sitemap entries"
$L | ForEach-Object {
    $File = $_.File
    $Title = $_.Title

    $pageEntries = $pageEntries + "`r`n    <image:image>"
    $pageEntries = $pageEntries + "`r`n      <image:loc>https://condaluna.com/$File</image:loc>"
    $pageEntries = $pageEntries + "`r`n      <image:title>$Title</image:title>"
    $pageEntries = $pageEntries + "`r`n    </image:image>"
}

# Stickers.html
$updateTimestamp = Get-Date -Format "F"
$content = [IO.File]::ReadAllText( '.\stickers.html' )
$content = ($content -replace "(?ms)<p>Images last updated:[ 0-9a-zA-Z]* </p>", "<p>Images last updated: $updateTimestamp</p>")
$content = ($content -replace "(?ms)^\s+let images=\[.*?\];", "        let images=[$imagesArray`r`n        ];")
$content = ($content -replace "(?ms)^\s+<noscript id='stickers'>.*?</noscript>", "      <noscript id='stickers'>$imagesNoscript`r`n      </noscript>")
[IO.File]::WriteAllText('.\stickers.html',$content)

# Sitemap.xml
$date = Get-Date -Format "yyyy-MM-dd"
$pagePrefix="    <loc>https://condaluna.com/stickers.html</loc>"+
"`r`n    <lastmod>$date</lastmod>"+
"`r`n    <changefreq>daily</changefreq>"+
"`r`n    <image:image>"+
"`r`n      <image:loc>https://condaluna.com/logo.png</image:loc>"+
"`r`n      <image:title>@condaluna.com logo</image:title>"+
"`r`n    </image:image>"+
"`r`n    <image:image>"+
"`r`n      <image:loc>https://condaluna.com/assets/social/instagram-round.png</image:loc>"+
"`r`n      <image:title>catherinebrown666 on Instagram</image:title>"+
"`r`n    </image:image>"+
"`r`n    <image:image>"+
"`r`n      <image:loc>https://condaluna.com/assets/social/facebook-round.png</image:loc>"+
"`r`n      <image:title>CondalunaArt on Facebook</image:title>"+
"`r`n    </image:image>"+
"`r`n    <image:image>"+
"`r`n      <image:loc>https://condaluna.com/assets/social/twitter-round.png</image:loc>"+
"`r`n      <image:title>CatCondaluna on Twitter</image:title>"+
"`r`n    </image:image>"
$pageSuffix="`r`n  </url>"
$content = [IO.File]::ReadAllText( '.\sitemap.xml' )
$content = ($content -replace "(?ms)^\s+<loc>https://condaluna.com/stickers.html</loc>.*</url>", "$pagePrefix$pageEntries$pageSuffix")
[IO.File]::WriteAllText('.\sitemap.xml',$content)
