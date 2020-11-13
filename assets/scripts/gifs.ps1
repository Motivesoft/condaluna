[void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

# Read the CSV file of file and title values
# Sort it by file name
$L = Import-Csv -Path .\assets\scripts\gifs-list.csv | Sort-Object -Property File

# Write the list of image array entries for stickers.html
$imagesList=""
Write-Output "--Entries"
$L | ForEach-Object {
    $File = $_.File
    $Title = $_.Title

    $image = [System.Drawing.Image]::FromFile('./'+$File)
    $imagesList = $imagesList + "`r`n        <div class='card'>"
    $imagesList = $imagesList + "`r`n          <img src='./$File' title='$Title' alt='$Title' width='"+$image.Width+"' height='"+$image.Height+"' onclick='copySourceUrl(event)'/>"
    $imagesList = $imagesList + "`r`n        </div>"
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
$updateTimestamp = Get-Date -Format "f"
$content = [IO.File]::ReadAllText( '.\gifs.html' )
$content = ($content -replace "<p id='timestamp'>.*?</p>", "<p id='timestamp'>Updated $updateTimestamp</p>")
$content = ($content -replace "(?ms)^\s+<!--list-start-->.*?<!--list-end-->", "      <!--list-start-->$imagesList`r`n      <!--list-end-->")
[IO.File]::WriteAllText('.\gifs.html',$content)

# Sitemap.xml
$date = Get-Date -Format "yyyy-MM-dd"
$pagePrefix="    <loc>https://condaluna.com/gifs.html</loc>"+
"`r`n    <lastmod>$date</lastmod>"+
"`r`n    <changefreq>weekly</changefreq>"+
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
$content = ($content -replace "(?ms)^\s+<loc>https://condaluna.com/gifs.html</loc>.*?</url>", "$pagePrefix$pageEntries$pageSuffix")
[IO.File]::WriteAllText('.\sitemap.xml',$content)
