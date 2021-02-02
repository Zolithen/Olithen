-- only supports rectangles for now

StencilStack = class("StencilStack")

function StencilStack:init()
	self.stack = {}
	self.res_rect = {x = 0, y = 0, w = 0, h = 0};
end

function StencilStack:push(x, y, w, h)
	--print("Added rectangle: ", x, y, w, h);
	--x, y = love.graphics.inverseTransformPoint(x, y);
	local xx, yy
	if self.stack[1] then -- TODO: this may not be suitable for panels
		xx = x + self.stack[1].x;
		yy = y + self.stack[1].y;
		print(xx, yy, w, h);
		table.insert(self.stack, {x=xx, y=yy, w=w, h=h});
	else
		table.insert(self.stack, {x=x, y=y, w=w, h=h});
	end	
	self:apply();
end

function StencilStack:pop()
	--self.stack[#self.stack] = nil;
	print("before", #self.stack)
	table.remove(self.stack, #self.stack)
	print("after", #self.stack)
	self:apply();
end

function StencilStack:clear()
	self.stack = {};
end

function StencilStack:apply()
	local res_rect = nil;

	if #self.stack > 1 then
		for i, v in ipairs(self.stack) do
			if res_rect == nil then
				res_rect = v;
			else
				res_rect = math.get_rectangle_intersection(res_rect, v);
			end
		end
	elseif #self.stack == 1 then
		res_rect = self.stack[1];
	end

	if res_rect == nil then res_rect = {x=0,y=0,w=1920,h=1080}; end
	if type(res_rect) == "table" then
		if #self.stack > 1 then
			res_rect.x = res_rect.x - self.stack[1].x;
			res_rect.y = res_rect.y - self.stack[1].y;
		end
		love.graphics.stencil(function()
    		love.graphics.rectangle("fill", res_rect.x, res_rect.y, res_rect.w, res_rect.h);
    	end, "replace", 1)
    	love.graphics.setStencilTest("greater", 0);
    	self.res_rect = res_rect;
	end
end

--[[
function Window:stencil()
	love.graphics.stencil(function()
    	love.graphics.rectangle("fill", self:full_box());
    end, "replace", 1)
end
]]
--[[

rect = {
  left: x1,
  right: x1 + x2,
  top: y1,
  bottom: y1 + y2,
}


x_overlap = Math.max(0, Math.min(rect1.right, rect2.right) - Math.max(rect1.left, rect2.left));
y_overlap = Math.max(0, Math.min(rect1.bottom, rect2.bottom) - Math.max(rect1.top, rect2.top));
overlapArea = x_overlap * y_overlap;
]]