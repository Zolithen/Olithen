
OLITHEN_GUI.relative_position = false;

local ww = Window(winc, "Test", 0, 0, 100, 100):setPos(200, 200);
Label(ww, "it_namel"):setText("Project Name: "):setPos(0, 0);
TextInput(ww, "it_name"):setWidth(100):setPos(sk_getc_width("Project Name: "), 0);

--[[local p = Panel(ww, "it_name"):setPos(0, 100);

Label(p, "wu"):setText("Project Name: "):setPos(0, 75);]]

OLITHEN_GUI.relative_position = true;