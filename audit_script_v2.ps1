
$content = Get-Content 'c:\Users\SGM\Desktop\Vs1\life_safety\lib\utils\app_content.dart'
$mismatches = @()
$currentBlock = @()
for ($i = 0; $i -lt $content.Count; $i++) {
    $line = $content[$i]
    $currentBlock += $line
    if ($line -match "\s*\);") {
        $blockText = $currentBlock -join " "
        if ($blockText -match "ChoiceResult") {
            # Extract Level
            $level = ""
            if ($blockText -match "level: RiskLevel\.(\w+)") {
                $level = $Matches[1]
            }
            
            # Extract Prefix (OLUMLU, KRİTİK RİSK, UYARI, BİLİNMİYOR, BİLGİ)
            $prefix = ""
            if ($blockText -match "reportText:\s*['\"].*?(OLUMLU|KRİTİK RİSK|UYARI|BİLİNMİYOR|BİLGİ):") {
                $prefix = $Matches[1]
            }
            
            if ($level -ne "" -and $prefix -ne "") {
                $isMismatch = $false
                if ($prefix -eq "OLUMLU" -and ($level -eq "warning" -or $level -eq "critical")) { $isMismatch = $true }
                elseif ($prefix -eq "KRİTİK RİSK" -and ($level -ne "critical")) { $isMismatch = $true }
                elseif ($prefix -eq "UYARI" -and ($level -ne "warning")) { $isMismatch = $true }
                elseif ($prefix -eq "BİLİNMİYOR" -and $level -ne "unknown") { $isMismatch = $true }
                elseif ($prefix -eq "BİLGİ" -and ($level -ne "info" -and $level -ne "positive")) { $isMismatch = $true }
                
                if ($isMismatch) {
                    $mismatches += "Block ending at line $($i+1): Prefix $prefix but level $level"
                }
            }
        }
        $currentBlock = @()
    }
}
$mismatches | Out-File -FilePath 'c:\Users\SGM\Desktop\Vs1\life_safety\mismatch_results_v2.txt'
