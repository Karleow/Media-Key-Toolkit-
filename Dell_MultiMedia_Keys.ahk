#Requires AutoHotkey v2.0
#SingleInstance Force ; 确保脚本只有一个实例在运行


if (0){
    ; 在任务栏右下角找到脚本的图标，右键点击它。
    ; 选择 Open，打开脚本的主窗口。在主窗口菜单栏，选择 View -> Key history and script info。
    ; 按下你的“邮件”或“浏览器”等特殊按键。点击 Key History 窗口里的刷新按钮（或按 F5）
    global ih := InputHook("V")
    ih.OnKeyDown := KeyDownHandler
    ih.Start()
}

; Dell keyboard MultiMedia Keys, from left to right on the keyboard(skip volume nob).
Browser_Back::{
}
Browser_Forward::{
}
Browser_Stop::{
	ExitApp
}
Browser_Refresh::{
}
Browser_Home::{
	Run(A_ScriptDir "\QuickSleep.bat")
}
Launch_Mail::{
	Run("notepad.exe")
}
Launch_App1::{
	Run("cmd.exe")
}
Launch_App2::{
	Run("calc.exe")
}
Volume_Mute::{
	SetDefaultAudioDevice("Headphone")
}
Media_Stop::{
}
Media_Prev::{
}
Media_Next::{
}
Media_Play_Pause::{
}
Launch_Media::{
	SetDefaultAudioDevice("Speaker")
}

KeyDownHandler(hook, vk, sc)
{
    ; Check debug log to read which key is down.
}

keywords := ["SONY", "Realtek"] ; 优先匹配关键词（按顺序）

Switch_AudioDevice()
{
    devices := GetAudioDevices()
    current := GetDefaultAudioDevice()

    if !current {
        ToolTip("无法获取当前设备")
        SetTimer(RemoveToolTip, -3000)
        return
    }

    if (SubStr(current, 1, 7) = "Speaker") {
        ; 当前是 Speaker → 切换到 Headphone
        target := FindMatchingDevice(devices, "Headphone", keywords)
        if target {
            SetDefaultAudioDevice(target)
            ToolTip("找到 Headphone 设备: " target)
            ToggleMute()
        }else
            ToolTip("未找到可用的 Headphone 设备")
    }
    else if (SubStr(current, 1, 9) = "Headphone") {
        ; 当前是 Headphone → 切换到 Speaker
        target := FindMatchingDevice(devices, "Speaker", keywords)
        if target {
            SetDefaultAudioDevice(target)
            ToolTip("找到 Speaker 设备: " target)
            ToggleMute()
        }else
            ToolTip("未找到可用的 Speaker 设备")
    }
    else {
        ; 特殊设备 → 执行静音/取消静音
        ToggleMute()
        ToolTip("当前为特殊设备，执行静音/取消静音")
    }

    SetTimer(RemoveToolTip, -2000)
    return -1
}

GetAudioDevices() {
    ; 需要确保已以管理员身份运行 "Install-Module -Name AudioDeviceCmdlets -Force"

    psCmd := "Get-AudioDevice -List | Where-Object { $_.Type -eq 'Playback' } | Select-Object -ExpandProperty Name | Out-String -Stream"
    shell := ComObject("WScript.Shell")
    exec := shell.Exec('powershell -NoProfile -WindowStyle Hidden -Command "' psCmd '"')
    out := exec.StdOut.ReadAll()
    devices := StrSplit(Trim(out), "`r`n")

    if (0)
    {
        debugMsg := "🎧 检测到的播放设备：`n"
        for index, device in devices {
            trimmedDevice := Trim(device)
            if (trimmedDevice != "") {
                debugMsg .= index ". " trimmedDevice "`n"
            }
        }

        ToolTip(debugMsg)
        ; SetTimer(RemoveToolTip, -3000)
    }
    return devices
}

GetDefaultAudioDevice() {
    shell := ComObject("WScript.Shell")
    psCmd := "(Get-AudioDevice -List | Where-Object { $_.Type -eq 'Playback' -and $_.Default -eq $true }).Name"
    exec := shell.Exec('powershell -NoProfile -WindowStyle Hidden -Command "' psCmd '"')
    out := exec.StdOut.ReadAll()
    return Trim(out)
}

SetDefaultAudioDevice(name) {
    shell := ComObject("WScript.Shell")
    psCmd := "Get-AudioDevice -List | Where-Object { $_.Name -like '*" name "*' } | Set-AudioDevice"
    exec := shell.Exec('powershell -NoProfile -WindowStyle Hidden -Command "' psCmd '"')
    out := exec.StdOut.ReadAll()
    ToolTip("切换到: " name)
    SetTimer(RemoveToolTip, -3000)
}

FindMatchingDevice(devices, prefix, keywords) {
    for device in devices {
        if (InStr(device, prefix) = 1) { ; 名称以 prefix 开头
            for kw in keywords {
                if InStr(device, kw) {
                    return device
                }
            }
        }
    }
    return ""
}

ToggleMute() {
    SoundSetMute(-1) ; -1 = 切换当前静音状态
}

RemoveToolTip() {
    ToolTip()
}

; ==========================================================
; 🔹 AutoHotkey 修饰键符号对照表
; ==========================================================
; 符号   对应按键      示例           含义
; ----------------------------------------------------------
; ^      Ctrl          ^A             Ctrl + A
; !      Alt           !A             Alt + A
; +      Shift         +A             Shift + A
; #      Win (Windows) #A             Win + A
; ----------------------------------------------------------

; 按下 Ctrl + Alt + F12 退出脚本

;^!F12::
;{
;	ExitApp
;}