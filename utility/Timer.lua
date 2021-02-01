Timer = class("Timer");
ClockTimer = Timer:extend("ClockTimer");

function ClockTimer:init(s)
	self.time = s; -- state
	self.trigger_time = s; -- stores the desired time for next activation
	self.should_trigger = false; -- true if the timer has completed an iteration
	self.should_deactivate = false; -- true if the timer should set should_trigger to false at the end of the update
end

function ClockTimer:update(dt)
	self.time = self.time - dt;
	if self.time <= 0 then
		self.time = self.trigger_time;
		self.should_trigger = true;
	end
	if self.should_deactivate then
		self.should_deactivate = false;
		self.should_trigger = false;
	end
end

function ClockTimer:check()
	if self.should_trigger then
		self.should_deactivate = true;
		return true;
	end
	return false;
end