<#
.SYNOPSIS
    Ativa a permissão automática de geolocalização no WebView2.

.DESCRIPTION
    Aplica a política DefaultGeolocationSetting = 1 (Permitir) no registro
    do Windows, garantindo que o WebView2 conceda acesso à localização
    sem exibir o popup, independentemente da decisão salva no perfil.

    Requer execução como Administrador.

.NOTES
    Autor: Suporte Técnico
    Data: 2025
#>

# ============================================================
# VERIFICAÇÃO DE PRIVILÉGIOS
# ============================================================

$currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
$isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "[ERRO] Este script precisa ser executado como Administrador." -ForegroundColor Red
    Write-Host "       Clique com o botão direito e escolha 'Executar como administrador'." -ForegroundColor Yellow
    Pause
    Exit 1
}

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " ZoryaGerador - Ativação de Geolocalização no WebView2" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# ============================================================
# APLICAÇÃO DA POLÍTICA
# ============================================================

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Edge\WebView2"
$regName = "DefaultGeolocationSetting"
$regValue = 1  # 1 = Permitir

Write-Host "[INFO] Aplicando política de geolocalização..." -ForegroundColor Yellow

try {
    # Cria a chave de política se não existir
    if (-not (Test-Path $regPath)) {
        New-Item -Path $regPath -Force | Out-Null
        Write-Host "[DEBUG] Chave de registro criada: $regPath" -ForegroundColor Gray
    }

    # Define o valor
    Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Type DWord -Force

    Write-Host "[OK] Política aplicada com sucesso!" -ForegroundColor Green
    Write-Host "      $regName = $regValue (Permitir)" -ForegroundColor Green

    # Exibe o valor atual para confirmação
    $valorAtual = (Get-ItemProperty -Path $regPath -Name $regName).$regName
    Write-Host "[DEBUG] Valor atual no registro: $valorAtual" -ForegroundColor Gray

} catch {
    Write-Host "[ERRO] Falha ao aplicar a política: $_" -ForegroundColor Red
    Pause
    Exit 1
}

Write-Host ""
Write-Host "[INFO] Reinicie o ZoryaGerador para que a alteração tenha efeito." -ForegroundColor Yellow
Write-Host ""

Pause