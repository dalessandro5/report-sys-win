# Obtener información del sistema
$os = Get-CimInstance Win32_OperatingSystem
$cs = Get-CimInstance Win32_ComputerSystem
$bios = Get-CimInstance Win32_BIOS
$disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
$net = Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -notmatch "Loopback"}
$battery = Get-CimInstance Win32_Battery
$uptime = (Get-Date) - $os.LastBootUpTime

# Mostrar información formateada
Write-Host "============================" -ForegroundColor Cyan
Write-Host "   INFORMACIÓN DEL SISTEMA" -ForegroundColor Cyan
Write-Host "============================" -ForegroundColor Cyan

Write-Host "`n🖥️ Equipo: $($cs.Name)"
Write-Host "👤 Usuario activo: $($cs.UserName)"
Write-Host "💻 Fabricante: $($cs.Manufacturer)"
Write-Host "📦 Modelo: $($cs.Model)"
Write-Host "🔐 BIOS: $($bios.SMBIOSBIOSVersion)"

Write-Host "`n🪟 Sistema Operativo: $($os.Caption) ($($os.OSArchitecture))"
Write-Host "🧩 Versión: $($os.Version)"
Write-Host "🕒 Tiempo encendido: $([math]::Floor($uptime.TotalHours)) horas, $([math]::Floor($uptime.Minutes)) minutos"

Write-Host "`n💾 Disco principal (C:):"
Write-Host "   Total: $([math]::Round($disk.Size / 1GB, 2)) GB"
Write-Host "   Libre: $([math]::Round($disk.FreeSpace / 1GB, 2)) GB"

Write-Host "`n🧠 Memoria RAM:"
Write-Host "   Total: $([math]::Round($cs.TotalPhysicalMemory / 1GB, 2)) GB"
Write-Host "   En uso: $([math]::Round(($cs.TotalPhysicalMemory - $os.FreePhysicalMemory * 1024) / 1GB, 2)) GB"

if ($battery) {
    Write-Host "`n🔋 Batería: $($battery.EstimatedChargeRemaining)% restante"
} else {
    Write-Host "`n🔌 Batería: No se detecta batería (posible equipo de escritorio)"
}

Write-Host "`n🌐 IP local:"
$net | ForEach-Object {
    Write-Host "   - $($_.InterfaceAlias): $($_.IPAddress)"
}

Write-Host "`n✅ Fin del reporte.`n" -ForegroundColor Green
