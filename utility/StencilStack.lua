-- only supports rectangles for now

StencilStack = class("StencilStack")

-- fix stencil
function StencilStack:init()
	self.stack = {}
	self.res_rect = {x = 0, y = 0, w = 0, h = 0, uuid = ""};
	self.stencils = {};
end

function StencilStack:push(x, y, w, h, uuid, tx, ty)
	table.insert(self.stack, {x=x, y=y, w=w, h=h, uuid=uuid, tx=tx, ty=ty});
	self:apply();
end

function StencilStack:pop()
	table.remove(self.stack, #self.stack)
	self:apply();
end

function StencilStack:clear()
	self.stack = {};
end

--[[DB_COLORS = {}
for i = 1, 1000 do
	DB_COLORS[i] = {math.random(), math.random(), math.random(), 0.5}
end
DB_INDEX = 1

function DB_COLOR()
	DB_INDEX = DB_INDEX + 1;
	love.graphics.setColor(DB_COLORS[DB_INDEX]);
end

DB_RECTS = {}]]

-- find way so stencils get nested down so sub panels WORK
function StencilStack:apply()
	local res_rect = nil;
	--local tx, ty = 0, 0;
	local uuid = ""

	if #self.stack > 1 then
		for i, v in ipairs(self.stack) do
			if res_rect == nil then
				res_rect = table.copy(v);
			else
				
				local r = table.copy(v);

				uuid = r.uuid
				if type(res_rect) == "table" then

					--[[if res_rect.tx then
						res_rect.x = res_rect.tx;
						res_rect.y = res_rect.ty;
					end]]

					res_rect.x = 0;
					res_rect.y = 0;

				end

				res_rect = math.get_rectangle_intersection(res_rect, r);
				res_rect.uuid = uuid;
			end

			
		end
	elseif #self.stack == 1 then
		res_rect = self.stack[1];
	end

	if type(res_rect) == "table" then
		--table.insert(DB_RECTS, res_rect);
		--res_rect.tx = tx;
		--res_rect.ty = ty;
	end

	if res_rect == nil then res_rect = {x=0,y=0,w=1920,h=1080,tx=0,ty=0}; end
	if type(res_rect) == "table" then
		love.graphics.setStencilTest();

		love.graphics.stencil(function()
    		love.graphics.rectangle("fill", res_rect.x, res_rect.y, res_rect.w, res_rect.h);
    	end, "replace", 1)
    	love.graphics.setStencilTest("greater", 0);


    	self.res_rect = res_rect;
    	if uuid then
    		self.stencils[uuid] = table.copy(res_rect);
    	end
	end
end