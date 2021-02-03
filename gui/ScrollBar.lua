ScrollBar = GuiElement:extend("ScrollBar")

function ScrollBar:init(parent, name)
	GuiElement.init(self, parent, name, 0, 0);
	self.hovered = false;
	self.scrolling = false;

	self.scroll_box_uuid = math.uuid();

	self.scrolled_x = 0;
	self.scrolled_y = 0;

	self.w = 100;
	self.h = 16;
end

function ScrollBar:draw()
	OLITHEN_GUI.color("default");
	love.graphics.rectangle("fill", self:full_box());

	OLITHEN_GUI.stencil_stack:pop();
	OLITHEN_GUI.stencil_stack:push(self:stencil_scroll_box());

	OLITHEN_GUI.color("highlight")
	love.graphics.rectangle("fill", self:scroll_box());
end

function ScrollBar:mousemoved(x, y, dx, dy)
	self.hovered = OLITHEN_GUI.is_inside_stencil({uuid=self.scroll_box_uuid}, x, y);

	if self.scrolling then
		self.scrolled_x = math.clamp(0, (x - self.x) - self.mox, self.w-16);
		self.scrolled_y = math.clamp(0, (y - self.y) - self.moy, self.h-16);
	end
end

function ScrollBar:mousepressed(x, y, b)
	--if is_hovered_raw(x, y, self:scroll_box()) and b == 1 then
	if OLITHEN_GUI.is_inside_stencil({uuid=self.scroll_box_uuid}, x, y) and b == 1 then
		self.scrolling = true;

		print(x, y, self.x, self.y);
		self.mox = x - (self.x+self.scrolled_x);
		self.moy = y - (self.y+self.scrolled_y);
	end
end

function ScrollBar:mousereleased(x, y, b)
	self.scrolling = false;
end

function ScrollBar:origin_posititon_change(ox, oy)
	self.origin_x = ox;
	self.origin_y = oy;
end

function ScrollBar:full_box()
	return self.x, self.y, self.w, self.h
end

function ScrollBar:stencil_box()
	return self.x, self.y, self.w, self.h, self.uuid
end

function ScrollBar:scroll_box()
	return self.x+self.scrolled_x, self.y+self.scrolled_y, 16, 16
end

function ScrollBar:stencil_scroll_box()
	return self.x+self.scrolled_x, self.y+self.scrolled_y, 16, 16, self.scroll_box_uuid
end

function ScrollBar:setDimensions(w, h)
	self.w = w;
	self.h = h or 16;
	return self;
end