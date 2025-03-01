function Fit {
    param (
        [string]$file,
        [string]$function,
        [string]$download = $null
    )

    $url = "http://192.92.147.107:8142/fit"
    $form = @{
        "file"     = Get-Item -Path $file
        "function" = $function
        "logx"     = "no"
        "autox"    = "no"
        "autoy"    = "no"
    }

    if ($download) {
        $form["download"] = $download
    }

    Invoke-RestMethod -Uri $url -Method Post -Form $form
}

function Fit-LogX {
    param (
        [string]$file,
        [string]$function,
        [string]$download = $null
    )

    $url = "http://192.92.147.107:8142/fit"
    $form = @{
        "file"     = Get-Item -Path $file
        "function" = $function
        "logx"     = "yes"
        "autox"    = "no"
        "autoy"    = "no"
    }

    if ($download) {
        $form["download"] = $download
    }

    Invoke-RestMethod -Uri $url -Method Post -Form $form
}

function Fit-Exp-LogX {
    param (
        [string]$file,
        [string]$download = $null
    )

    $url = "http://192.92.147.107:8142/fit"
    $form = @{
        "file"     = Get-Item -Path $file
        "function" = "a: one exponential"
        "logx"     = "yes"
        "autox"    = "no"
        "autoy"    = "no"
    }

    if ($download) {
        $form["download"] = $download
    }

    Invoke-RestMethod -Uri $url -Method Post -Form $form
}

function AFit {
    param (
        [string]$file,
        [string]$function,
        [string]$download = $null
    )

    $url = "http://192.92.147.107:8142/fit"
    $form = @{
        "file"     = Get-Item -Path $file
        "function" = $function
        "logx"     = "no"
        "autox"    = "yes"
        "autoy"    = "yes"
    }

    if ($download) {
        $form["download"] = $download
    }

    Invoke-RestMethod -Uri $url -Method Post -Form $form
}

function AFit-LogX {
    param (
        [string]$file,
        [string]$function,
        [string]$download = $null
    )

    $url = "http://192.92.147.107:8142/fit"
    $form = @{
        "file"     = Get-Item -Path $file
        "function" = $function
        "logx"     = "yes"
        "autox"    = "yes"
        "autoy"    = "yes"
    }

    if ($download) {
        $form["download"] = $download
    }

    Invoke-RestMethod -Uri $url -Method Post -Form $form
}

function AFit-Exp-LogX {
    param (
        [string]$file,
        [string]$download = $null
    )

    $url = "http://192.92.147.107:8142/fit"
    $form = @{
        "file"     = Get-Item -Path $file
        "function" = "a: one exponential"
        "logx"     = "yes"
        "autox"    = "yes"
        "autoy"    = "yes"
    }

    if ($download) {
        $form["download"] = $download
    }

    Invoke-RestMethod -Uri $url -Method Post -Form $form
}

