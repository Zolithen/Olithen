Window = Node:extend("Window")
WindowController = Node:extend("WindowController")

function WindowController:init(parent)
	WindowController.super.init(self, parent, "winc", 0, 0);
end

function WindowController:focus(u)
	local window_to_focus = self.children[u];
	table.remove(self.children, u);
	table.insert(self.children, 1, window_to_focus);

	for i, v in ipairs(self.children) do
		v.child_index = i;
		v.focus = false;
	end
	self.children[1].focus = true
end

function WindowController:ensure_order()
	for i, v in ipairs(self.children) do
		if v ~= nil then
			v.child_index = i;
		end
	end
end

function WindowController:is_on_window(x, y)
	for i, v in ipairs(self.children) do
		if v.minimized then
			if is_hovered_raw(x, y, v:title_box()) then
				return i;
			end
		else
			if is_hovered_raw(x, y, v:full_box()) then
				return i;
			end
		end
	end
	return -1;
end

function Window:init(parent, name)
	Window.super.init(self, parent, name, 0, 0);
	self.w = 640;
	self.h = 480;

	-- window state
	self.focus = false;
	self.inner_canvas = love.graphics.newCanvas(1920, 1080); -- TODO: change to screen resolution
	self.timers = {}
	self.timers[0.75] = ClockTimer(0.75);
	self.minimized = false;
	self.translate_x = 0;
	self.translate_y = 16;

	-- vars for moving the windows
	self.moving = false;
	self.mox = 0; --mouse offset x
	self.moy = 0; --mouse offset y

	-- vars for resizing the window
	self.expanding = false;
	self.expanding_switch = Switch();

	-- window options
	self.expandable = true;
	self.movable = true;
	self.focusable = true;
	self.evisible = true;
	self.title_bar = true;
	self.closable = true;
	self.minimizable = true;

	self.title_bar_height = 16; -- only used for calculations (not for drawing the title bar) 
	self.uuid = math.uuid();
end

-- TODO : Optimize this from "propagate_event(name)" to designed functions for each event that needs something special
function Window:propagate_event(name, ...)
	if self[name] then self[name](self, ...) end
	if name ~= "mousepressed" and name ~= "mousemoved" and name ~= "mousereleased" and self.child_index == 1 and not self.minimized then
		for i, v in ipairs(self.children) do
			v:propagate_event(name, ...);
		end
	end
end

function Window:propagate_origin_change(x, y)
	--if name ~= "mousepressed" and name ~= "mousemoved" and name ~= "mousereleased" and self.child_index == 1 and not self.minimized then
	for i, v in ipairs(self.children) do
		if v.propagate_origin_change then
			v:propagate_origin_change(x-self.x, y-self.y)
		else
			v:propagate_event("origin_posititon_change", x-self.x, y-self.y);
		end
	end
end

function Window:propagate_event_reverse(name, ...)
	if self[name] then self[name](self, ...) end
	if name ~= "draw" and self.child_index == 1 and not self.minimized then
		for i, v in ipairs(self.children) do
			v:propagate_event(name, ...);
		end
	end
end

function Window:draw()
	-- Draw the focus outline
	if self.focus then
		OLITHEN_GUI.color("focused");
	else
		OLITHEN_GUI.color("unfocused");
	end
	if self.minimized then
		love.graphics.rectangle("fill", self:outline_title_box());
	else
		love.graphics.rectangle("fill", self:outline_box());
	end

	-- Setup the stencil

	-- Draw the main box
	if not self.minimized then
		OLITHEN_GUI.stencil_stack:push(self:stencil_box());

		OLITHEN_GUI.color("background");
		love.graphics.rectangle("fill", self:full_box());

		OLITHEN_GUI.stencil_stack:pop();

		OLITHEN_GUI.stencil_stack:push(0, 0, self.w-2, self.h-2, self.uuid);

		-- draw all the window's elements
		love.graphics.push();
			love.graphics.translate(self.x, self.y+self.translate_y);
			self:draw_elements();
		love.graphics.pop();

		OLITHEN_GUI.stencil_stack:pop();
	end

	OLITHEN_GUI.stencil_stack:push(self:stencil_box());

	-- Draw the title bar
	self:draw_title();

	-- Draw the expand box
	OLITHEN_GUI.color("highlight")
	if self.expandable and not self.minimized then
		love.graphics.rectangle("fill", self:expand_box());
	end

	-- Draw the closing box
	if self.closable then
		love.graphics.rectangle("fill", self:close_box());
	end

	-- Draw the minimize box
	if self.minimizable then
		love.graphics.rectangle("fill", self:minimize_box());
	end

	OLITHEN_GUI.stencil_stack:clear();

	love.graphics.setStencilTest()
end

--[[
	=====================================================================
	DRAW FUNCTIONS
	=====================================================================
]]

function Window:draw_elements()
	for i, v in r_ipairs(self.children) do
		OLITHEN_GUI.stencil_stack:push(v:stencil_box());	
		v:propagate_event_reverse("draw");
		OLITHEN_GUI.stencil_stack:pop();
	end

	--[[print("STARTING STENCIL THINGY \n ");

	for i, v in pairs(OLITHEN_GUI.stencil_stack.stencils) do
		print(i, v.x, v.y, v.w, v.h);
	end

	print("\nENDING STENCIL THINGY");]]
end

function Window:draw_title()
	if self.title_bar then
		if self.focus then
			OLITHEN_GUI.color("t_focused")
		else
			OLITHEN_GUI.color("t_unfocused")
		end
		love.graphics.rectangle("fill", self:title_box());
		OLITHEN_GUI.color("font");
		love.graphics.print(self.name, self.x, self.y);
	end
end

--[[
	=====================================================================
	END DRAW FUNCTIONS
	=====================================================================
]]

function Window:update(dt)
	for i, v in pairs(self.timers) do
		v:update(dt);
	end

	if self.moving then
		self:setPos(love.mouse.getX() - self.mox, love.mouse.getY() - self.moy);
		if not self.focus then
			self.parent:focus(self.child_index);
		end
	end
	if self.expanding then
		self.w = math.max(love.mouse.getX() + self.mox - self.x, 20);
		self.h = math.max(love.mouse.getY() + self.moy - self.y - 16 , 20);
	end

	if -self.expanding_switch then
		self.parent:focus(self.child_index);
		self.expanding_switch:switch();
	end

	self.mlx = love.mouse.getX();
	self.mly = love.mouse.getY();
end

function Window:mousepressed(x, y, b)
	if self.movable and is_hovered(self:title_box()) and self.parent:is_on_window(x, y) == self.child_index then
		self.moving = true;
		local xx, yy = self:title_box();
		self.mox = x - xx;
		self.moy = y - yy;

	elseif self.expandable and is_hovered(self:expand_box()) and self.parent:is_on_window(x, y) == self.child_index and not self.minimized then
		self.expanding = true;
		local xx, yy = self:expand_box();
		self.mox = 20 - (x - xx);
		self.moy = 20 - (y - yy);
		self.expanding_switch:switch();

	elseif self.focusable and is_hovered(self:full_box()) and self.parent:is_on_window(x, y) == self.child_index and not self.minimized then
		self.parent:focus(self.child_index);
	end

	-- update children
	if self.child_index == 1 and not self.minimized then
		for i, v in ipairs(self.children) do
			v:propagate_event("mousepressed", x-self.x, y-self.y-self.title_bar_height, b);
		end
	end
end

function Window:mousereleased(x, y, b)
	if self.expanding then
		for i, v in ipairs(self.children) do
			if v.pos then
				v:update_pos();
			end
		end
	end
	self.moving = false;
	self.expanding = false;

	if self.closable and is_hovered(self:close_box()) and self.parent:is_on_window(x, y) == self.child_index then
		table.remove(self.parent.children, self.child_index)
		self.parent:ensure_order();
	elseif self.minimizable and is_hovered(self:minimize_box()) and self.parent:is_on_window(x, y) == self.child_index then
		self.minimized  = not self.minimized;
	elseif self.child_index == 1 and not self.minimized then
		for i, v in ipairs(self.children) do
			v:propagate_event("mousereleased", x-self.x, y-self.y-self.title_bar_height, b);
		end
	end
end

function Window:mousemoved(x, y, dx, dy)
	if self.child_index == 1 then
		for i, v in ipairs(self.children) do
			v:propagate_event("mousemoved", x-self.x, y-self.y-self.title_bar_height, dx, dy);
		end
	end
end

function Window:stencil()
	love.graphics.stencil(function()
    	love.graphics.rectangle("fill", self:full_box());
    end, "replace", 1)
end

function Window:resetStencil()
	self:stencil();
    love.graphics.setStencilTest("greater", 0);
end

-- Defines some areas in the window
function Window:main_box()
	return self.x, self.y+16, self.w, self.h
end

function Window:title_box()
	return self.x, self.y, self.w, 16
end

function Window:expand_box()
	return self.x+self.w-20, self.y+self.h-20+16, 20, 20
end

function Window:minimize_box()
	return self.x+self.w-32, self.y, 16, 16
end

function Window:close_box()
	return self.x+self.w-16, self.y, 16, 16
end

function Window:full_box()
	return self.x, self.y, self.w, self.h+16
end

function Window:outline_box()
	return self.x-2, self.y-2, self.w+4, self.h+20
end

function Window:outline_title_box()
	return self.x-2, self.y-2, self.w+4, 20
end

function Window:stencil_box()
	return self.x, self.y, self.w, self.h+16, self.uuid
end

--------------------------------
-- API FUNCTIONS
--------------------------------

function Window:setPos(x, y)
	self.x = x;
	self.y = y;

	self:propagate_origin_change(self.x*2, self.y*2);

	return self;
end

function Window:setDimensions(w, h)
	self.w = w;
	self.h = h;
	return self;
end
