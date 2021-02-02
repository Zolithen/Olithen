function math.get_rectangle_intersection(r1, r2, fallback)
	if type(r1) ~= "table" or type(r2) ~= "table" then return false end;
  --print(r1.x, r1.y, r1.w, r1.h, r2.x, r2.y, r2.w, r2.h);
	--if math.pboverlapraw(r2.x, r2.y, r1.x, r1.y, r1.w, r1.h) then
  --print("overlap detected uwu");
	local rect = {};
	rect.x = math.max(r1.x, r2.x);
	rect.y = math.max(r1.y, r2.y);
	rect.w = math.min(r1.x+r1.w,r2.x+r2.w) - rect.x;
	rect.h = math.min(r1.y+r1.h,r2.y+r2.h) - rect.y;
  if rect.w >= 0 and rect.h >= 0 then
	 return rect;
	elseif not fallback then
		return math.get_rectangle_intersection(r2, r1, true)
	end

	return false;
end

function math.pboverlapraw(x1, y1, x2, y2, w, h) 
  return (
    (x1 > x2) and
    (x1 < x2 + w) and
    (y1 > y2) and
    (y1 < y2 + h)
  )
end

function is_hovered(...)
  return math.pboverlapraw(
      love.mouse.getX(), love.mouse.getY(),
      ...
    )
end

function is_hovered_raw(x, y, ...)
  return math.pboverlapraw(
      x, y,
      ...
    )
end