require "utility/Math"
require "utility/Switch"
require "utility/Timer"
require "utility/RelativePosition"
require "utility/StencilStack"

OLITHEN_GUI = {
	relative_position = true,
	stencil_stack = StencilStack(),
	is_inside_stencil = function(x, y)
		return math.pboverlapraw(x, y,
			OLITHEN_GUI.stencil_stack.res_rect.x, OLITHEN_GUI.stencil_stack.res_rect.y, OLITHEN_GUI.stencil_stack.res_rect.w, OLITHEN_GUI.stencil_stack.res_rect.h) 
	end,
	skfont = love.graphics.getFont(),
	skcolors = {
		font = {1,1,1,1},

		highlight = {0.5, 0.5, 0.5, 1},
		default = {0.3, 0.3, 0.3, 1},
		background = {0.2, 0.2, 0.2, 1},

		focused = {0, 1, 0, 1},
		unfocused = {1, 0, 0, 1},

		t_focused = {0.4, 0.4, 1, 1},
		t_unfocused = {0.5, 0.5, 1, 1}
	},
	color = function(m)
		love.graphics.setColor(OLITHEN_GUI.skcolors[m]);
	end,
	text = {
		width = function(a)
			return OLITHEN_GUI.skfont:getWidth(a);
		end
	}

}

require "gui/GuiElement"
require "gui/Window"
require "gui/Label"
require "gui/TextInput"
require "gui/Button"
require "gui/Panel"
require "gui/ScrollBar"