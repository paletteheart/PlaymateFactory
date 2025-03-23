
-- Define constants
local pd <const> = playdate
local gfx <const> = pd.graphics
local geo <const> = pd.geometry
local poly <const> = geo.polygon


-- Define functions

function getBody(x, y, rot)
	
	local bodyPoly = bodies[body.type].poly(x, y)
	local bodyRot = geo.affineTransform.new()
	bodyRot:rotate(rot, x, y)
	bodyPoly = bodyPoly*bodyRot
	
	return bodyPoly
end

function getHead(x, y, rot)
	
    local headPoly = heads[head.type].poly(x, y)

	local trans = geo.affineTransform.new()
	trans:rotate(rot, x, y)
	headPoly = headPoly*trans

	return headPoly
end

function getHand(x, y)
	local steps = 10
	local step = 360/steps -- the amount to step in degrees

	local bodySize = (body.width+body.height)*0.2+0.6 -- a number between 0.6 and 1

	local handPoly = poly.new(steps)
	for i=1,steps do
		pos = i*step
		local pointX = math.floor(x + handRadius*bodySize*math.cos(math.rad(pos))) -- circle
		local pointY = math.floor(y + handRadius*bodySize*math.sin(math.rad(pos)))
		
		handPoly:setPointAt(i, pointX, pointY)
	end
	
	handPoly:close()

	return handPoly
end

function getFoot(x, y, rot)
	local steps = 10
	local step = 360/steps -- the amount to step in degrees
	local pos = 0

	local bodySize = (body.width+body.height)/4+0.5 -- a number between 0.5 and 1

	local footPoly = poly.new(steps)
	for i=1,steps do
		pos = i*step
		local pointX = math.floor(x + (footWidth/2)*bodySize*math.cos(math.rad(pos)))
		local pointY = math.floor(y + (footHeight/2)*bodySize*math.sin(math.rad(pos)))

		footPoly:setPointAt(i, pointX, pointY)
	end
	
	footPoly:close()

    local trans = geo.affineTransform.new()
	trans:rotate(rot, x, y)
	footPoly = footPoly*trans

	return footPoly
end

function getFace()
	local faceSize = 48
	local midpoint = faceSize/2
	local faceImage = gfx.image.new(faceSize, faceSize)

	local l = limit.face
	gfx.pushContext(faceImage)
		-- draw mouth
		local mouthW
		local mouthH
        if face.mouth.size == 1 then mouthW = 6 mouthH = 5 elseif face.mouth.size == 2 then mouthW = 10 mouthH = 7 else mouthW = 14 mouthH = 10 end
        if face.mouth.invert == true then gfx.setImageDrawMode(gfx.kDrawModeInverted) end
		local mouthY = face.mouth.y*(l.mouth.y.max-l.mouth.y.min)+l.mouth.y.min
		local mirrorMouth = gfx.kImageUnflipped
		if face.mouth.mirror then mirrorMouth = gfx.kImageFlippedX end
		local mouthAdjustment = 0
		if heads[head.type].species == species.dog then mouthAdjustment = 2 end
		asset.mouth[face.mouth.size][face.mouth.type]:draw(midpoint-mouthW/2-mouthAdjustment, midpoint+mouthY+12-mouthH/2, mirrorMouth)
        gfx.setImageDrawMode(gfx.kDrawModeCopy)

        -- draw left eye
        local eyeSize
        if face.eyes.sizeL == 1 then eyeSize = 6 elseif face.eyes.sizeL == 2 then eyeSize = 10 else eyeSize = 14 end
        if face.eyes.invert == true then gfx.setImageDrawMode(gfx.kDrawModeInverted) end
		local eyeX = face.eyes.x*(l.eyes.x.max-l.eyes.x.min)+l.eyes.x.min
		local eyeY = face.eyes.y*(l.eyes.y.max-l.eyes.y.min)+l.eyes.y.min-2
		local mirrorLeft = gfx.kImageUnflipped
		if eyes[face.eyes.typeL].mirrorLeft then mirrorLeft = gfx.kImageFlippedX end
		asset.eye[face.eyes.sizeL][eyes[face.eyes.typeL].left]:draw(midpoint-eyeX-eyeSize/2, midpoint+eyeY-eyeSize/2, mirrorLeft)
        gfx.setImageDrawMode(gfx.kDrawModeCopy)

        -- draw nose
        local noseSize
        if face.nose.size == 1 then noseSize = 6 elseif face.nose.size == 2 then noseSize = 10 else noseSize = 14 end
        local noseY = face.nose.y*(l.nose.y.max-l.nose.y.min)+l.nose.y.min-2

		-- do a bunch of shit to properly render the skin tone on the nose while allowing for inverting the outline
		local getMaskFromThis = gfx.image.new(noseSize, noseSize)
		gfx.pushContext(getMaskFromThis)
			gfx.setImageDrawMode(gfx.kDrawModeBlackTransparent)
			asset.nose[face.nose.size][face.nose.type]:draw(0, 0)
		gfx.popContext()
        gfx.setImageDrawMode(gfx.kDrawModeCopy)
		local skinMask = getMaskFromThis:getMaskImage()
		local skinImage = gfx.image.new(noseSize, noseSize)
		gfx.pushContext(skinImage)
			getMaskFromThis:draw(0, 0)
			gfx.setColor(gfx.kColorBlack)
			gfx.setDitherPattern(skin)
			gfx.fillRect(0, 0, noseSize, noseSize)
		gfx.popContext()
		skinImage:setMaskImage(skinMask)

        if face.nose.invert == true then gfx.setImageDrawMode(gfx.kDrawModeInverted) end
		local noseX, newNoseY
        if heads[head.type].species == species.human then
            noseX, newNoseY = midpoint-noseSize/2-5, midpoint+noseY-noseSize/2+5
        elseif heads[head.type].species == species.cat then
            noseX, newNoseY = midpoint-11-noseSize/2, midpoint+6+3*head.height-noseSize/2
        elseif heads[head.type].species == species.dog then
            noseX, newNoseY = midpoint-13-noseSize/2, midpoint+6+3*head.height-noseSize/2
        end
		asset.nose[face.nose.size][face.nose.type]:draw(noseX, newNoseY)
        gfx.setImageDrawMode(gfx.kDrawModeCopy)
		skinImage:draw(noseX, newNoseY)

        -- draw right eye
        if face.eyes.sizeR == 1 then eyeSize = 6 elseif face.eyes.sizeR == 2 then eyeSize = 10 else eyeSize = 14 end
        if face.eyes.invert == true then gfx.setImageDrawMode(gfx.kDrawModeInverted) end
		asset.eye[face.eyes.sizeR][eyes[face.eyes.typeR].right]:draw(midpoint+eyeX-eyeSize/2, midpoint+eyeY-eyeSize/2) -- right eye
        gfx.setImageDrawMode(gfx.kDrawModeCopy)



	gfx.popContext()

	return faceImage
end



function drawOutlinedPoly(p, innerDither, lineWidth)
    -- Draw the polygon filled. If it's pure white or pure black don't bother with drawing the dither layer.
    if innerDither == 0 then gfx.setColor(gfx.kColorBlack) else gfx.setColor(gfx.kColorWhite) end
    gfx.fillPolygon(p)
	if innerDither ~= nil and innerDither ~= 0 and innerDither ~= 1 then
		gfx.setColor(gfx.kColorBlack)
		gfx.setDitherPattern(innerDither)
        gfx.fillPolygon(p)
	end
	gfx.setLineCapStyle(gfx.kLineCapStyleRound)
	if lineWidth ~= nil then gfx.setLineWidth(lineWidth) end
	gfx.setColor(gfx.kColorBlack)
	gfx.drawPolygon(p)
end