$ErrorActionPreference = "Stop"

function Get-RandomDate([datetime]$start, [datetime]$end) {
  $range = [int]($end - $start).TotalSeconds
  $offset = Get-Random -Minimum 0 -Maximum ($range + 1)
  return $start.AddSeconds($offset)
}

function Get-Message {
  $verbs = @("Refine","Polish","Improve","Adjust","Update","Clean up","Simplify","Optimize","Stabilize","Tweak","Revise","Harden")
  $areas = @("project setup","app flow","UI layout","navigation","state handling","error handling","startup","auth","routing","loading states","assets","docs","test coverage","build config","platform files")
  $outcomes = @("for clarity","for stability","for consistency","for smoother UX","and fix edge cases","and reduce friction","for better readability","to prevent regressions","for cleaner behavior","for reliability","for maintainability","for responsiveness")
  return "$(($verbs | Get-Random)) $(($areas | Get-Random)) $(($outcomes | Get-Random))"
}

function Commit-RepoChanges {
  param(
    [string]$Repo,
    [int]$ChunkSize,
    [string[]]$ExcludeTopDirs
  )

  Set-Location $Repo

  $lines = git -C $Repo status --porcelain=v1 --untracked-files=all
  if (-not $lines) {
    Write-Output "REPO=$Repo NO_CHANGES"
    return 0
  }

  $paths = @()
  foreach ($line in $lines) {
    if ($line.Length -lt 4) { continue }
    $path = $line.Substring(3)
    if ($path.Contains(" -> ")) {
      $parts = $path -split " -> "
      $path = $parts[$parts.Length - 1]
    }

    $norm = $path.Replace("\\", "/")
    $top = if ($norm.Contains("/")) { $norm.Split("/")[0] } else { $norm }
    if ($ExcludeTopDirs -contains $top) { continue }

    $paths += $norm
  }

  $paths = $paths | Select-Object -Unique
  if (-not $paths -or $paths.Count -eq 0) {
    Write-Output "REPO=$Repo ONLY_EXCLUDED_CHANGES"
    return 0
  }

  $start = Get-Date "2025-01-01T00:00:00"
  $end = Get-Date "2026-03-31T23:59:59"

  $commitCount = 0
  for ($i = 0; $i -lt $paths.Count; $i += $ChunkSize) {
    $chunk = $paths[$i..([Math]::Min($i + $ChunkSize - 1, $paths.Count - 1))]

    foreach ($p in $chunk) {
      git -C $Repo add -A -- "$p" | Out-Null
    }

    $dt = Get-RandomDate -start $start -end $end
    $env:GIT_AUTHOR_DATE = $dt.ToString("yyyy-MM-ddTHH:mm:ss")
    $env:GIT_COMMITTER_DATE = $env:GIT_AUTHOR_DATE

    $msg = Get-Message
    git -C $Repo -c commit.gpgsign=false commit --no-gpg-sign -m $msg | Out-Null

    if ($LASTEXITCODE -ne 0) {
      throw "Commit failed in $Repo"
    }

    $commitCount++
  }

  Remove-Item Env:GIT_AUTHOR_DATE -ErrorAction SilentlyContinue
  Remove-Item Env:GIT_COMMITTER_DATE -ErrorAction SilentlyContinue

  Write-Output "REPO=$Repo COMMITS_CREATED=$commitCount"
  return $commitCount
}

$total = 0

$total += Commit-RepoChanges -Repo "C:\Users\HP\Documents\programming\flutter" -ChunkSize 12 -ExcludeTopDirs @("Flutter-mobile-programming-course-25-26","demo-facebook-mobile-programming-course-25-26","gebeya_now","test_app")
$total += Commit-RepoChanges -Repo "C:\Users\HP\Documents\programming\flutter\demo-facebook-mobile-programming-course-25-26" -ChunkSize 6 -ExcludeTopDirs @()
$total += Commit-RepoChanges -Repo "C:\Users\HP\Documents\programming\flutter\Flutter-mobile-programming-course-25-26" -ChunkSize 6 -ExcludeTopDirs @()
$total += Commit-RepoChanges -Repo "C:\Users\HP\Documents\programming\flutter\gebeya_now" -ChunkSize 6 -ExcludeTopDirs @()
$total += Commit-RepoChanges -Repo "C:\Users\HP\Documents\programming\flutter\test_app" -ChunkSize 10 -ExcludeTopDirs @()

Write-Output "TOTAL_COMMITS_CREATED=$total"
