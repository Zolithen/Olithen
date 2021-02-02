Panel = GuiElement:extend("Panel");

Panel.propagate_event = Window.propagate_event
Panel.propagate_event_reverse = Window.propagate_event_reverse
Panel.draw_elements = Window.draw_elements
--GuiElement.draw = Window.draw

function Panel:init(parent, name)
	GuiElement.init(self, parent, name, 0, 0);

	self.w = 300;
	self.h = 100;

	self.inner_canvas = love.graphics.newCanvas(1920, 1080);
end

function Panel:draw()
	self:stencil()
	love.graphics.setColor(0, 1, 0, 1);
	love.graphics.rectangle("fill", self:outline_box());
	love.graphics.setColor(0.2, 0.2, 0.2, 1);
	love.graphics.rectangle("fill", self:full_box());

	self:draw_elements();

	--self:resetStencil();

end

function Panel:stencil()
	love.graphics.stencil(function()
    	love.graphics.rectangle("fill", self:outline_box());
    end, "replace", 1)

    love.graphics.setStencilTest("greater", 0);
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