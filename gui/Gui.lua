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
	end
}

require "gui/GuiElement"
require "gui/Window"
require "gui/Label"
require "gui/TextInput"
require "gui/Button"
require "gui/Panel"