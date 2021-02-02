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
end

function Window:propagate_event(name, ...)
	if self[name] then self[name](self, ...) end
	if name ~= "mousepressed" and name ~= "mousemoved" and name ~= "mousereleased" and self.child_index == 1 and not self.minimized then
		for i, v in ipairs(self.children) do
			v:propagate_event(name, ...);
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
		love.graphics.setColor(0, 1, 0, 1);
	else
		love.graphics.setColor(1, 0, 0, 1);
	end
	if self.minimized then
		love.graphics.rectangle("fill", self:outline_title_box());
	else
		love.graphics.rectangle("fill", self:outline_box());
	end

	-- Setup the stencil
	--self:resetStencil();

	OLITHEN_GUI.stencil_stack:push(self:full_box());

	-- Draw the main box
	if not self.minimized then
		love.graphics.setColor(0.2, 0.2, 0.2, 1);
		love.graphics.rectangle("fill", self:full_box());

		-- draw all the window's elements
		self:draw_elements();
	end

	OLITHEN_GUI.stencil_stack:pop();
	--self:resetStencil();

	OLITHEN_GUI.stencil_stack:push(self:full_box());

	-- Draw the title bar
	self:draw_title();

	-- Draw the expand box
	love.graphics.setColor(0.5, 0.5, 0.5, 1);
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

	OLITHEN_GUI.stencil_stack:pop();

	love.graphics.setStencilTest()
end

--[[
	=====================================================================
	DRAW FUNCTIONS
	=====================================================================
]]

function Window:draw_elements()
	--love.graphics.setCanvas({self.inner_canvas,stencil=true});

		--love.graphics.clear();

	love.graphics.push()
		love.graphics.translate(self.x, self.y+16);
		for i, v in r_ipairs(self.children) do
			OLITHEN_GUI.stencil_stack:push(v:full_box());	
			v:propagate_event_reverse("draw");
			OLITHEN_GUI.stencil_stack:pop();
		end
	love.graphics.pop()

	--love.graphics.setCanvas();

	--love.graphics.draw(self.inner_canvas, self.x, self.y+16);
end

function Window:draw_title()
	if self.title_bar then
		if self.focus then
			love.graphics.setColor(0.4, 0.4, 1, 1);
		else
			love.graphics.setColor(0.5, 0.5, 1, 1);
		end
		love.graphics.rectangle("fill", self:title_box());
		sk_set_color("font");
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
		self.x = love.mouse.getX() - self.mox;
		self.y = love.mouse.getY() - self.moy;
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
	if is_hovered(self:title_box()) and self.movable and self.parent:is_on_window(x, y) == self.child_index then
		self.moving = true;
		local xx, yy = self:title_box();
		self.mox = x - xx;
		self.moy = y - yy;

	elseif is_hovered(self:expand_box()) and self.expandable and self.parent:is_on_window(x, y) == self.child_index and not self.minimized then
		self.expanding = true;
		local xx, yy = self:expand_box();
		self.mox = 20 - (x - xx);
		self.moy = 20 - (y - yy);
		self.expanding_switch:switch();

	elseif is_hovered(self:full_box()) and self.focusable and self.parent:is_on_window(x, y) == self.child_index and not self.minimized then
		self.parent:focus(self.child_index);
	end

	-- update children
	if self.child_index == 1 and not self.minimized then
		for i, v in ipairs(self.children) do
			v:propagate_event("mousepressed", x-self.x, y-self.y-16, b);
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

	if is_hovered(self:close_box()) and self.closable and self.parent:is_on_window(x, y) == self.child_index then
		table.remove(self.parent.children, self.child_index)
		self.parent:ensure_order();
	elseif is_hovered(self:minimize_box()) and self.minimizable and self.parent:is_on_window(x, y) == self.child_index then
		self.minimized  = not self.minimized;
	elseif self.child_index == 1 and not self.minimized then
		for i, v in ipairs(self.children) do
			v:propagate_event("mousereleased", x-self.x, y-self.y-16, b);
		end
	end
end

function Window:mousemoved(x, y)
	if self.child_index == 1 then
		for i, v in ipairs(self.children) do
			v:propagate_event("mousemoved", x-self.x, y-self.y-16);
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

--------------------------------
-- API FUNCTIONS
--------------------------------

function Window:setPos(x, y)
	self.x = x;
	self.y = y;
	return self;
end

function Window:setDimensions(w, h)
	self.w = w;
	self.h = h;
	return self;
end
