Panel = GuiElement:extend("Panel");

-- TODO : this doesn't propagate events properly cus this is a panel. or maybe it does. idk
Panel.propagate_event = Window.propagate_event
Panel.propagate_event_reverse = Window.propagate_event_reverse
Panel.draw_elements = Window.draw_elements
Panel.mousemoved = Window.mousemoved
Panel.mousepressed = Window.mousepressed
Panel.mousereleased = Window.mousereleased
--GuiElement.draw = Window.draw

function Panel:init(parent, name)
	GuiElement.init(self, parent, name, 0, 0);

	self.w = 300;
	self.h = 100;

	self.child_index = 1; -- this variable right here is to just mimic window state when able to propagate events

	--self.inner_canvas = love.graphics.newCanvas(1920, 1080);
end

function Panel:draw()
	
	OLITHEN_GUI.stencil_stack:pop();
	OLITHEN_GUI.stencil_stack:push(self:outline_box());

	love.graphics.setColor(0, 1, 0, 1);
	love.graphics.rectangle("fill", self:outline_box());
	love.graphics.setColor(0.2, 0.2, 0.2, 1);
	love.graphics.rectangle("fill", self:full_box());

	self:draw_elements();

	--self:resetStencil();

end

function Panel:main_box()
	return self.x, self.y, self.w, self.h
end

function Panel:minimize_box()
	return self.x+self.w-16, self.y, 16, 16
end

function Panel:full_box()
	return self.x, self.y, self.w, self.h
end

function Panel:outline_box()
	return self.x-2, self.y-2, self.w+4, self.h+4
end

------------------------------------
-- API FUNCTIONS
------------------------------------
function Panel:setDimensions()

end