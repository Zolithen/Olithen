GuiElement = Node:extend("GuiElement");

function GuiElement:init(parent, name, x, y)
	Node.init(self, parent, name, x, y);

	self.relative_pos = OLITHEN_GUI.relative_position;
end

function GuiElement:setPos(x, y)
	if self.relative_pos then
		self.pos = RelativePos(x, y)
		self:update_pos();
	else
		self.x = x;
		self.y = y;
		self.pos = nil;
	end
	return self;
end

function GuiElement:relativePositioning()
	self.relative_pos = true;
end

function GuiElement:absolutePositioning()
	self.relative_pos = false;
end

function GuiElement:setPosOffsetToCenter()
	self.pos.xoff = -self.w/2;
	self.pos.yoff = -self.h/2;
	return self;
end