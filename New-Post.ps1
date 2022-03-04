param (
    [Parameter(Mandatory = $true)]
    [string]
    $title
)

$folderPath = $(Join-Path ".\input\posts" -ChildPath $(Get-Date -Format yyyy))

if (!(Test-Path $folderPath)) {
    New-Item $folderPath -ItemType Directory | Out-Null
}

$fileName = "$(Get-Date -UFormat "%F")-$($title.ToLower().Replace(" ", "-")).md"

$filePath = Join-Path $folderPath -ChildPath $fileName

$content = @"
Title: $($title)
Published: $(Get-Date -UFormat "%F" )
Tags:

- blog

---

TODO

<!--more-->

TODO
"@

Set-Content -Path $filePath -Value $content