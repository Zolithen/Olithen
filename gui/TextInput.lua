TextInput = GuiElement:extend("TextInput");

-- TODO : Add text scrolling

function TextInput:init(parent, name)
	Node.init(self, parent, name, 0, 0);
	self.text = {}; -- array of chars that represents an string
	self.cursor = 1; -- position of writing cursor
	self.cursor_switch = Switch(); -- for the blinking cursor
	self.h = 16;
	self.render_text = love.graphics.newText(love.graphics.getFont(), ""); -- text used for rendering

	self.focus = false; -- if the text field is focused

	--[[if type(x) == "number" then
		Node.init(self, parent, name, x, y);
		self.w = w
	else
		self.w = y;
		self.pos = x;
		self.pos.xoff = -self.w/2;
		self.pos.yoff = -8;
		Node.init(self, parent, name, self.pos:get_pixel_space(parent.w, parent.h));
	end]]
end

function TextInput:update(dt)
	--self.render_text_offset = math.max(0, (self.cursor*sk_getc_width("w"))-200);
	if self.focus and self.parent.timers[0.75]:check() then self.cursor_switch:switch() end
end

function TextInput:draw()
	-- Setup the stencil
	--self:stencil();
    --love.graphics.setStencilTest("greater", 0);

		if self.focus then
			sk_set_color("highlight");
		else
			sk_set_color("default");
		end
		love.graphics.rectangle("fill", 
			self.x, 
			self.y, 
			self.w, 
			16
		);
	
		sk_set_color("font");
		if OLITHEN_GUI.is_inside_stencil(self.x+1, self.y+1) then
			love.graphics.draw(self.render_text, self.x+self:get_offset(), self.y);
		end

		if -self.cursor_switch and self.focus then
			love.graphics.rectangle("fill", self.x+sk_getc_width(self:get_text(self.cursor-1))+self:get_offset(), self.y, 3, 16);
		end
end

function TextInput:get_offset()
	local st = sk_getc_width("putoputo")
	return self.w-st-math.max(
    		self.w-st,
    		sk_getc_width(self:get_text(self.cursor-1))
    	)
end

function TextInput:stencil()
	love.graphics.stencil(function()
    	love.graphics.rectangle("fill", self:main_box());
    end, "replace", 1)
end

function TextInput:textinput(t)
	if self.focus then
		table.insert(self.text, self.cursor, t);
		self.cursor = self.cursor + 1;
		self:update_render_text();
	end
end

function TextInput:keypressed(k)
	if self.focus then
		if k == "backspace" then
			self.cursor = self.cursor - 1
			table.remove(self.text, self.cursor)
			self.cursor = math.max(self.cursor, 1);
		elseif k == "delete" then
			self.cursor = math.min(self.cursor, #self.text);
			table.remove(self.text, self.cursor);
		elseif k == "left" then
			self.cursor = math.max(1, self.cursor-1);
		elseif k == "right" then
			self.cursor = math.min(#self.text+1, self.cursor+1);
		end

		self:update_render_text();
	end
end

function TextInput:mousepressed(x, y, b)
	self.focus = is_hovered_raw(x, y, self:main_box()) and b == 1;
end

function TextInput:get_text(untill)
	local ret = "";
	if untill ~= 0 then
		for i, v in ipairs(self.text) do
			ret = ret .. v;
			if i == untill then break; end
		end
	end
	return ret;
end

function TextInput:update_render_text(untill)
	local s = self:get_text(untill or nil);
	self.render_text = love.graphics.newText(love.graphics.getFont(), s);
end

-- Defines some areas in the text box
function TextInput:main_box()
	return self.x, self.y, self.w, 16
end

function TextInput:update_pos()
	self.x, self.y = self.pos:get_pixel_space(self.parent.w, self.parent.h);
end

TextInput.full_box = TextInput.main_box

------------------------------------
-- API FUNCTIONS
------------------------------------
function TextInput:setWidth(w)
	self.w = w;
	return self;
end