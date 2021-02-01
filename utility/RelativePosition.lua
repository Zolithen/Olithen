RelativePos = class("RelativePos");

function RelativePos:init(x, y, xoff, yoff)
	self.x = x;
	self.y = y;
	self.xoff = xoff or 0;
	self.yoff = yoff or 0;
end	

function RelativePos:get_pixel_space(w, h)
	return (self.x*w)+self.xoff,(self.y*h)+self.yoff
end