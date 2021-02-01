Switch = class("Switch");

function Switch:init()
	self.a = false;
	local ccc = getmetatable(self);
	ccc.__unm = function(slf)
		return slf.a
	end
	setmetatable(self, ccc);
end

function Switch:switch()
	self.a = not self.a;
end