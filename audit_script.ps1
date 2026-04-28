
$content = Get-Content 'c:\Users\SGM\Desktop\Vs1\life_safety\lib\utils\app_content.dart'
$mismatches = @()
for ($i = 0; $i -lt $content.Count; $i++) {
    if ($content[$i] -match "level: RiskLevel\.warning") {
        for ($j = $i - 1; $j -ge ($i - 10); $j--) {
            if ($j -ge 0 -and $content[$j] -match "OLUMLU:") {
                $mismatches += "Line $($i+1): level warning but text OLUMLU at $($j+1)"
                break
            }
        }
    }
    if ($content[$i] -match "level: RiskLevel\.positive") {
        for ($j = $i - 1; $j -ge ($i - 10); $j--) {
            if ($j -ge 0 -and ($content[$j] -match "KRİTİK RİSK:" -or $content[$j] -match "UYARI:")) {
                $mismatches += "Line $($i+1): level positive but text negative at $($j+1)"
                break
            }
        }
    }
    if ($content[$i] -match "level: RiskLevel\.critical") {
        for ($j = $i - 1; $j -ge ($i - 10); $j--) {
            if ($j -ge 0 -and ($content[$j] -match "OLUMLU:" -or $content[$j] -match "UYGUN:")) {
                $mismatches += "Line $($i+1): level critical but text positive at $($j+1)"
                break
            }
        }
    }
}
$mismatches | Out-File -FilePath 'c:\Users\SGM\Desktop\Vs1\life_safety\mismatch_results.txt'
