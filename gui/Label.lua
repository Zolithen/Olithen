Label = GuiElement:extend("Label");

function Label:init(parent, name)
	GuiElement.init(self, parent, name, 0, 0);
	self:update_text("");
	--[[if type(x) == "number" then
		self:update_text(text);
	else -- assuming it's a relative posititon
		text = y;
		self.pos = x;
		self:update_text(text)
		self.pos.xoff = -self.render_text:getWidth()/2;
		self.pos.yoff = -self.render_text:getHeight()/2;
		Node.init(self, parent, name, self.pos:get_pixel_space(parent.w, parent.h));
	end]]
end

function Label:draw()
	--print("Drawing label at: ", self:full_box());
	OLITHEN_GUI.color("font");
	love.graphics.print(self.text, self.x, self.y);
end

function Label:full_box()
	return self.x, self.y, self.render_text:getWidth(), self.render_text:getHeight()
end

function Label:stencil_box()
	return self.x, self.y, self.render_text:getWidth(), self.render_text:getHeight(), self.uuid
end

function Label:update_text(t)
	self.text = t;
	self.render_text = love.graphics.newText(love.graphics.getFont(), t); 
end

function Label:update_pos()
	--[[self.pos.xoff = -self.render_text:getWidth()/2;
	self.pos.yoff = -self.render_text:getHeight()/2;]]
	self.x, self.y = self.pos:get_pixel_space(self.parent.w, self.parent.h);
end

------------------------------------
-- API FUNCTIONS
------------------------------------
function Label:setText(t)
	self:update_text(t);
	aihujstgfasg, doijksgsdogds, self.w, self.h = self:full_box()
	return self;
end