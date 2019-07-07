Local $hWnd

Local $searchWidth = 25
Local $color = 0x535353
Local $backColor = 0xF7F7F7

_Main()

Func _Main()
   _Init()
   _Run()
EndFunc

Func _Init()
   HotKeySet('{END}', '_Exit')
   AutoItSetOption('PixelCoordMode', 2)

   _Window_Attach()
EndFunc

Func _Run()
   Send('{UP}')
   AdlibRegister('_Event_Fire_OnAccelerate', 2500)
   AdlibRegister('_Event_Fire_OnFrameTick', 250)
   AdlibRegister('_Event_Fire_OnGameTick', 500)

   While True
	  PixelSearch(500, 208, 500 + $searchWidth, 235, $color, 100, 1, $hWnd)

	  If Not @error Then
		 Send('{UP down}')

		 While True
			PixelSearch(465, 220, 472, 237, $color, 100, 1, $hWnd)

			If Not @error Then
			   Send('{UP up}')

			   ExitLoop
			EndIf
		 WEnd
	  EndIf
   WEnd
EndFunc

Func _Event_Fire_OnAccelerate()
   $searchWidth += 1
EndFunc

Func _Event_Fire_OnFrameTick()
   Local Static $timer = 0

   If TimerDiff($timer) > 1000 And $backColor <> PixelGetColor(400, 120, $hWnd) Then
	  ConsoleWrite('Background color changed')

	  $backColor = $backColor = 0xF7F7F7 ? 0x000000 : 0xF7F7F7
	  $color = $color = 0x535353 ? 0xACACAC : 0x535353
	  $timer = TimerInit()
   EndIf
EndFunc

Func _Event_Fire_OnGameTick()
   If PixelGetColor(598, 151, $hWnd) = 0x535353 Then
	  ConsoleWrite('Game ended' & @CRLF)

	  $searchWidth = 25

	  Send('{UP}')
   EndIf
EndFunc

Func _Window_Attach()
   $hWnd = WinWait('https', '', 5)

   If @error Then
	  MsgBox(0, 'ERROR', 'Could not locate window', 5)
	  _Exit()
   EndIf

   WinActivate($hWnd)

   If Not WinWaitActive($hWnd, '', 5) Then
	  MsgBox(0, 'ERROR', 'Could not activate window')
	  _Exit()
   EndIf
EndFunc

Func _Exit()
   Exit
EndFunc
