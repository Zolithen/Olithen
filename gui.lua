
local ww = Window(winc, "Test", 0, 0, 100, 100);
Label(ww, "it_namel"):setText("Project Name: "):setPos(0, 0);
TextInput(ww, "it_name"):setWidth(100):setPos(0.07, 0);

Label(ww, "it_countl"):setText("Count: "):setPos(0.0, 0.05);
TextInput(ww, "it_count"):setWidth(100):setPos(0.07, 0.05);

Label(ww, "it_cnamel"):setText("Custom Name: "):setPos(0, 0.1);
