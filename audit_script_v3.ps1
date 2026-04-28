
$path = 'c:\Users\SGM\Desktop\Vs1\life_safety\lib\utils\app_content.dart'
$content = Get-Content $path
for ($i = 0; $i -lt $content.Count; $i++) {
    $line = $content[$i]
    $prefix = ""
    if ($line -match "(OLUMLU|KRİTİK RİSK|UYARI|BİLİNMİYOR|BİLGİ):") {
        $prefix = $Matches[1]
        for ($j = $i + 1; $j -lt $i + 15 -and $j -lt $content.Count; $j++) {
            if ($content[$j] -match "level: RiskLevel\.(\w+)") {
                $level = $Matches[1]
                $isMismatch = $false
                if ($prefix -eq "OLUMLU" -and $level -ne "positive") { $isMismatch = $true }
                if ($prefix -eq "KRİTİK RİSK" -and $level -ne "critical") { $isMismatch = $true }
                if ($prefix -eq "UYARI" -and $level -ne "warning") { $isMismatch = $true }
                if ($prefix -eq "BİLİNMİYOR" -and $level -ne "unknown") { $isMismatch = $true }
                
                if ($isMismatch) {
                    Write-Output "Mismatch: Prefix $prefix (line $($i+1)) with Level $level (line $($j+1))"
                }
                break
            }
            if ($content[$j] -match "\s*\);") { break }
        }
    }
}
