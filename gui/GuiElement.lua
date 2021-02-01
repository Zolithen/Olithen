GuiElement = Node:extend("GuiElement");

function GuiElement:setPos(x, y)
	self.pos = RelativePos(x, y)
	self:update_pos();
	return self;
end

function GuiElement:setPosOffsetToCenter()
	self.pos.xoff = -self.w/2;
	self.pos.yoff = -self.h/2;
	return self;
end