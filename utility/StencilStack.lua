-- only supports rectangles for now

StencilStack = class("StencilStack")

function StencilStack:init()
	self.stack = {}
	self.res_rect = {x = 0, y = 0, w = 0, h = 0};
end

-- TODO : FIX THIS HSIT
function StencilStack:push(x, y, w, h)
	--print("Added rectangle: ", x, y, w, h);
	--x, y = love.graphics.inverseTransformPoint(x, y);
	--local xx, yy
	--if self.stack[1] then -- TODO: this may not be suitable for panels
	--	local dx, dy = self:getDeviation();
		--local dx, dy = 0, 0;
	--	xx = x + dx;
	--	yy = y + dy;
	--	table.insert(self.stack, {x=xx, y=yy, w=w, h=h});
	--else
	print("Pushing: ", x, y, w, h);
		table.insert(self.stack, {x=x, y=y, w=w, h=h});
	--end	
	self:apply();
end

function StencilStack:getDeviation(A)
	local xx, yy = 0, 0
	for i = 2, A do
		xx = xx + self.stack[i].x
		yy = yy + self.stack[i].y
	end
	return xx, yy
end

function StencilStack:pop()
	--print("uwu");
	--self.stack[#self.stack] = nil;
	table.remove(self.stack, #self.stack)
	--self:apply();
end

function StencilStack:clear()
	self.stack = {};
end

DB_COLORS = {}
for i = 1, 1000 do
	DB_COLORS[i] = {math.random(), math.random(), math.random(), 0.5}
end
DB_INDEX = 1

function DB_COLOR()
	DB_INDEX = DB_INDEX + 1;
	love.graphics.setColor(DB_COLORS[DB_INDEX]);
end

DB_RECTS = {}


function StencilStack:apply()
	local res_rect = nil;

	if #self.stack > 1 then
		for i, v in ipairs(self.stack) do
			if res_rect == nil then
				res_rect = v;
			else
				
				local r = table.copy(v);
				local xx, yy = self:getDeviation(i-1);

				--r.x, r.y = v.x+xx, v.y+yy
				--print(i, r.x, r.y);
				if type(res_rect) == "table" then
					res_rect.x = 0;
					res_rect.y = 0;
				end

				res_rect = math.get_rectangle_intersection(res_rect, r);
			end

			
		end
	elseif #self.stack == 1 then
		res_rect = self.stack[1];
	end

	if type(res_rect) == "table" then
		table.insert(DB_RECTS, res_rect);
	end

	if res_rect == nil then res_rect = {x=0,y=0,w=1920,h=1080}; end
	if type(res_rect) == "table" then
		--[[if #self.stack > 1 then
			local dx, dy = self:getDeviation();
			res_rect.x = res_rect.x + dx;
			res_rect.y = res_rect.y + dy;
		end]]
		love.graphics.setStencilTest();

			--table.insert(DB_RECTS, res_rect);
		--print("Applying stencil at: ", res_rect.x, res_rect.y, res_rect.w, res_rect.h);
		love.graphics.stencil(function()
    		love.graphics.rectangle("fill", res_rect.x, res_rect.y, res_rect.w, res_rect.h);
    	end, "replace", 1)
    	love.graphics.setStencilTest("greater", 0);
    	self.res_rect = res_rect;
	end
end