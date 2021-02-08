
OLITHEN_GUI.relative_position = false;

local ww = Window(winc, "Test"):setPos(0, 0);
--Label(ww, "it_namel"):setText("Project Name: "):setPos(0, 0);
--TextInput(ww, "it_name"):setWidth(100):setPos(OLITHEN_GUI.text.width("Project Name: "), 0);


ScrollBar(ww, "uwu"):setDimensions(16, 500):setPos(484, 200):callOnChange(function(s)
	--p.translate_y = -s.scrolled_y;
	for i, v in ipairs(p.children) do
		v.y = v.oy -s.scrolled_y
	end
end);

p = Panel(ww, "it_name"):setPos(0, 200):setDimensions(500, 500);

Label(ww, "wu"):setText("Project Name: "):setPos(20, 75);

Button(p, "new_project"):setPos(0, 100):setText("New Project"):onClick(function(self)
	local newp = Window(winc, "Untitled")
end)

ScrollBar(p, "uwu"):setDimensions(100, 100):setPos(0, 0);

--ScrollBar(ww, "uwu"):setDimensions(100, 100):setPos(0, 0);

TextInput(p, "soajfas"):setPos(100, 0):setWidth(100);

--local pp = Panel(p, "uwas"):setPos(100, 100):setDimensions(300, 300);

--TextInput(pp, "soajfas"):setPos(100, 0):setWidth(100);

--OLITHEN_GUI.relative_position = true;