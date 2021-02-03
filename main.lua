math.randomseed(os.time());

love.graphics.setDefaultFilter("nearest", "nearest");

require "tree"



require "gui/Gui"

lk = love.keyboard

local scene = Node(nil, "scene", 0, 0)

winc = WindowController(scene);
--[[m = Window(winc, "Main Menu"):setPos(0, 0):setDimensions(300, 500);
--m.expandable = false;
m.closable = false;

Button(m, "new_project"):setPos(0, 0.9):setText("New Project"):onClick(function(self)
	local newp = Window(winc, "Untitled")
end)

Button(m, "bu1"):setPos(0, 0.5):setText("Open Window"):onClick(function(self)
	
end)]]
--Label(m, "labT", 0, 0, "Saved");

function love.load()
	love.keyboard.setKeyRepeat(true);
end

function love.update(dt)
	scene:propagate_event_reverse("update", dt)
end

DB_X = 0;
DB_Y = 0;

function love.draw()
	DB_RECTS = {}
	scene:propagate_event_reverse("draw")
	--love.graphics.clear()
	for i, v in ipairs(DB_RECTS) do
		DB_COLOR();
		--print(i, v.x, v.y, v.w, v.h);
		--love.graphics.rectangle("fill", v.x, v.y, v.w, v.h);
	end
	DB_COLOR();
	if OLITHEN_GUI.stencil_stack.res_rect.tx then
		--love.graphics.circle("fill", DB_X, DB_Y, 100);
	end
	DB_INDEX = 1
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

function love.mousemoved(mx, my, dx, dy)
	scene:propagate_event("mousemoved", mx, my, dx, dy);
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
