Button = GuiElement:extend("Button");

function Button:init(parent, name)
	GuiElement.init(self, parent, name, 0, 0);
	self:update_text("");
	--[[if type(x) == "number" then
		Node.init(self, parent, name, x, y);
		self:update_text(text);
	else
		text = y;
		self.pos = x;
		self:update_text(text);
		self.pos.xoff = -self.render_text:getWidth()/2;
		self.pos.yoff = -self.render_text:getHeight()/2;
		Node.init(self, parent, name, self.pos:get_pixel_space(parent.w, parent.h));
	end]]

	self.hovered = false;
	self.padding = 5;
end

function Button:draw()
	if self.hovered then
		OLITHEN_GUI.color("highlight")
	else
		OLITHEN_GUI.color("default")		
	end
	love.graphics.rectangle("fill", self:full_box());
	OLITHEN_GUI.color("font");
	love.graphics.print(self.text, self.x+self.padding, self.y+self.padding);
end

function Button:stencil()
	love.graphics.stencil(function()
    	love.graphics.rectangle("fill", self:full_box());
    end, "replace", 1)

    love.graphics.setStencilTest("greater", 0);
end

function Button:full_box()
	return self.x, self.y, self.render_text:getWidth()+self.padding*2, self.render_text:getHeight()+self.padding*2
end

function Button:update_text(t)
	self.text = t;
	self.render_text = love.graphics.newText(love.graphics.getFont(), t); 
end

function Button:mousepressed(x, y, b)

end

function Button:mousereleased(x, y, b)
	if is_hovered_raw(x, y, self:full_box()) and b == 1 then
		if self.on_click then
			self:on_click();
		end
	end
end

function Button:mousemoved(x, y)
	self.hovered = is_hovered_raw(x, y, self:full_box());
end

function Button:update_pos()
	--[[self.pos.xoff = -self.render_text:getWidth()/2;
	self.pos.yoff = -self.render_text:getHeight()/2;]]
	self.x, self.y = self.pos:get_pixel_space(self.parent.w, self.parent.h);
end


------------------------------------
-- API FUNCTIONS
------------------------------------
function Button:setText(t)
	self:update_text(t);
	aihujstgfasg, doijksgsdogds, self.w, self.h = self:full_box()
	return self;
end

function Button:onClick(f)
	self.on_click = f;
	return self;
end