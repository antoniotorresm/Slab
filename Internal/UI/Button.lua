--[[

MIT License

Copyright (c) 2019 Mitchell Davis <coding.jackalope@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

--]]

local Cursor = require(SLAB_PATH .. '.Internal.Core.Cursor')
local DrawCommands = require(SLAB_PATH .. '.Internal.Core.DrawCommands')
local Layout = require(SLAB_PATH .. '.Internal.UI.Layout')
local Mouse = require(SLAB_PATH .. '.Internal.Input.Mouse')
local Style = require(SLAB_PATH .. '.Style')
local Tooltip = require(SLAB_PATH .. '.Internal.UI.Tooltip')
local Window = require(SLAB_PATH .. '.Internal.UI.Window')

local Button = {}

local Pad = 10.0
local MinWidth = 75.0

function Button.Begin(Label, Options)
	Options = Options == nil and {} or Options
	Options.Tooltip = Options.Tooltip == nil and "" or Options.Tooltip
	Options.AlignRight = Options.AlignRight == nil and false or Options.AlignRight

	local Id = Window.GetItemId(Label)
	local FontHeight = Style.Font:getHeight()
	local X, Y = Cursor.GetPosition()
	local LabelW = Style.Font:getWidth(Label)
	local W = math.max(LabelW, MinWidth) + Pad * 2.0
	local H = FontHeight + Pad * 0.5

	if Options.AlignRight then
		X = Layout.AlignRight(W)
	end

	local Result = false
	local Color = Style.ButtonColor

	local MouseX, MouseY = Window.GetMousePosition()
	if not Window.IsObstructedAtMouse() and X <= MouseX and MouseX <= X + W and Y <= MouseY and MouseY <= Y + H then
		Color = Style.ButtonHoveredColor
		Tooltip.Begin(Options.Tooltip)
		Window.SetHotItem(Id)

		if Mouse.IsPressed(1) then
			Color = Style.ButtonPressedColor
		elseif Mouse.IsReleased(1) then
			Result = true
		end
	end

	local LabelX = X + (W * 0.5) - (LabelW * 0.5)

	DrawCommands.Rectangle('fill', X, Y, W, H, Color)
	DrawCommands.Print(Label, math.floor(LabelX), Y + math.floor(H * 0.5) - math.floor(FontHeight * 0.5))

	Cursor.SetItemBounds(X, Y, W, H)
	Cursor.AdvanceY(H)

	Window.AddItem(X, Y, W, H, Id)

	return Result
end

return Button
