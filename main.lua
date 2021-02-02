love.graphics.setDefaultFilter("nearest", "nearest");

require "tree"

skcolors = {
	font = {1,1,1,1},
	highlight = {0.5, 0.5, 0.5, 1},
	default = {0.3, 0.3, 0.3, 1}

}
skfont = love.graphics.getFont();

function sk_set_color(n)
	love.graphics.setColor(skcolors[n]);
end

function sk_getc_width(a)
	return skfont:getWidth(a);
end

require "gui/Gui"

lk = love.keyboard

local scene = Node(nil, "scene", 0, 0)

winc = WindowController(scene);
m = Window(winc, "Main Menu"):setPos(0, 0):setDimensions(300, 500);
--m.expandable = false;
m.closable = false;

Button(m, "new_project"):setPos(0, 0.9):setText("New Project"):onClick(function(self)
	local newp = Window(winc, "Untitled")
end)

Button(m, "bu1"):setPos(0, 0.5):setText("Open Window"):onClick(function(self)
	
end)
--Label(m, "labT", 0, 0, "Saved");

function love.load()
	love.keyboard.setKeyRepeat(true);
end

function love.update(dt)
	--l.text = tostring(m.timers[0.75].should_trigger)
	scene:propagate_event_reverse("update", dt)
end

function love.draw()
	scene:propagate_event_reverse("draw")
end

function love.keypressed(k)
	if k == "f4" then
		local aaaaa = loadstring(get_file("gui.lua"))
		aaaaa(winc);
	end
	scene:propagate_event("keypressed", k);
end

function love.mousepressed(mx, my, b)
	scene:propagate_event("mousepressed", mx, my, b);
end

function love.mousereleased(mx, my, b)
	scene:propagate_event("mousereleased", mx, my, b);
end

function love.mousemoved(mx, my)
	scene:propagate_event("mousemoved", mx, my);
end

function love.textinput(t)
	scene:propagate_event("textinput", t);
end


function get_file(file)
    local f = assert(io.open(file, "rb"))
    local content = f:read("*all")
    f:close()
    return content
end
