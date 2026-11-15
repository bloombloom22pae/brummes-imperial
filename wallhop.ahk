Gui, Show , w250 h230, Wallhop AHK

Gui, Font, s10
Gui, Add, Text, x5 y10 w240 Center, Script made by Riot.
Gui, Font, s12
Gui, Add, Text, x10 y60 w120 Center,Activate macro.
Gui, Add, Button, x150 y62 w90 h60 vActivate gActivateThingy,Activate
Gui, Add, Text, x10 y150 w120 Center,Deactivate macro.
Gui, Add, Button, x150 y155 w90 h60 vDeactivate gDeactivateThingy,Deactivate
return

ActivateThingy:
Hotkey, Xbutton2, MyLabel, On
Return

DeactivateThingy:
Hotkey, Xbutton2, , Off
Return

MyLabel:
MouseGetPos, x, y
MouseMove, x+4, y, 0
MouseMove, x-4, y, 0
return

GuiClose:
ExitApp

Numpad4::
ExitApp