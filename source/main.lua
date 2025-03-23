
import "CoreLibs/graphics"
import "CoreLibs/sprites"

import "data"
import "rendering"

-- Define constants
local pd <const> = playdate
local gfx <const> = pd.graphics

local screenWidth <const> = 400
local screenHeight <const> = 240
local screenCenterX <const> = screenWidth/2
local screenCenterY <const> = screenHeight/2



function playdate.update()
	head.height = math.min(1, math.max(0, head.height+pd.getCrankChange()/450))
	if pd.buttonJustPressed(pd.kButtonA) then face.eyes.invert = not face.eyes.invert end
	if pd.buttonJustPressed(pd.kButtonB) then head.type = (head.type%limit.head.type)+1 end
	if pd.buttonJustPressed(pd.kButtonRight) then face.mouth.type += 1 end
	if pd.buttonJustPressed(pd.kButtonLeft) then face.mouth.type -= 1 end
	if pd.buttonJustPressed(pd.kButtonUp) then face.mouth.size += 1 end
	if pd.buttonJustPressed(pd.kButtonDown) then face.mouth.size -= 1 end

	face.mouth.type = math.min(limit.face.mouth.type, math.max(1, face.mouth.type))
	face.mouth.size = math.min(3, math.max(1, face.mouth.size))

	bodyWidth = body.width*(limit.body.width.max-limit.body.width.min)+limit.body.width.min
	bodyHeight = body.height*(limit.body.height.max-limit.body.height.min)+limit.body.height.min

	headWidth = 0.5*(limit.head.height.max-limit.head.height.min)+limit.head.height.min
	headHeight = head.height*(limit.head.height.max-limit.head.height.min)+limit.head.height.min

	draw()

end


function draw()
	gfx.clear()
	
	local padding = 5
	local rotation = 5
	local anchor = {x = screenCenterX, y = screenCenterY+60}
	local legLengthAdjusted = (body.height/2+0.5)*legLength
	local bodyY = anchor.y-legLengthAdjusted-bodyHeight/2

	gfx.setLineWidth(2)

	-- Draw the left hand
	local leftHandPoly = getHand(anchor.x-bodyWidth/2-padding, bodyY+bodyHeight/2+handRadius-padding)
	drawOutlinedPoly(leftHandPoly, skin)

	-- Draw the feet
	local leftFootPoly = getFoot(anchor.x-bodyWidth/2, anchor.y, 0)
	drawOutlinedPoly(leftFootPoly, skin)
	local rightFootPoly = getFoot(anchor.x+bodyWidth/2, anchor.y, 0)
	drawOutlinedPoly(rightFootPoly, skin)

	-- Draw the body
	local bodyPoly = getBody(anchor.x, bodyY, rotation)
	drawOutlinedPoly(bodyPoly)

	-- Draw the head
	local distanceFromBody = padding+bodyHeight/2+limit.head.height.min/2
	local headX, headY = anchor.x+distanceFromBody*math.cos(math.rad(rotation-90)), bodyY+distanceFromBody*math.sin(math.rad(rotation-90))
	local headPoly = getHead(headX, headY, rotation)
	drawOutlinedPoly(headPoly, skin)

	-- Draw the face
	local faceImage = getFace()
	faceImage:draw(headX-24-rotation/2, headY-24)
	-- gfx.drawRect(headX-22, headY-20, 40, 40)

	-- Draw the right hand
	local rightHandPoly = getHand(anchor.x+bodyWidth/2+padding, bodyY+bodyHeight/2+handRadius-padding)
	drawOutlinedPoly(rightHandPoly, skin)

	pd.drawFPS()
end