local pd <const> = playdate
local gfx <const> = pd.graphics
local geo <const> = pd.geometry
local poly <const> = geo.polygon

size = {
    small = 1,
    medium = 2,
    large = 3
}
species = {
    human = 1,
    dog = 2,
    cat = 3
}

-- Cache assets
asset = {}

asset.eye = {}
asset.eye[1] = {} -- small eyes
asset.eye[2] = {} -- medium eyes
asset.eye[3] = {} -- large eyes
local paths = pd.file.listFiles("assets/face/eyes/medium")
for i=1,#paths do
	asset.eye[1][i] = gfx.image.new("assets/face/eyes/small/eyeS"..i)
	asset.eye[2][i] = gfx.image.new("assets/face/eyes/medium/eyeM"..i)
	asset.eye[3][i] = gfx.image.new("assets/face/eyes/large/eyeL"..i)
end

asset.nose = {}
asset.nose[1] = {} -- small noses
asset.nose[2] = {} -- medium noses
asset.nose[3] = {} -- large noses
paths = pd.file.listFiles("assets/face/nose/medium")
local noseNum = #paths
for i=1,noseNum do
	asset.nose[1][i] = gfx.image.new("assets/face/nose/small/noseS"..i)
	asset.nose[2][i] = gfx.image.new("assets/face/nose/medium/noseM"..i)
	asset.nose[3][i] = gfx.image.new("assets/face/nose/large/noseL"..i)
end

asset.mouth = {}
asset.mouth[1] = {} -- small mouths
asset.mouth[2] = {} -- medium mouths
asset.mouth[3] = {} -- large mouths
paths = pd.file.listFiles("assets/face/mouth/medium")
local mouthNum = #paths
for i=1,mouthNum do
	asset.mouth[1][i] = gfx.image.new("assets/face/mouth/small/mouthS"..i)
	asset.mouth[2][i] = gfx.image.new("assets/face/mouth/medium/mouthM"..i)
	asset.mouth[3][i] = gfx.image.new("assets/face/mouth/large/mouthL"..i)
end

-- Define the way features are drawn

bodies = {
    { -- trapezoid
        poly = function (x, y)
            local bodyPoly
            local x1, y1 = x-bodyWidth/2, y-bodyHeight/2
            local x2, y2 = x+bodyWidth/2, y+bodyHeight/2
            local tx1, tx2 = x-bodyWidth/3, x+bodyWidth/3
            bodyPoly = poly.new(tx1, y1, tx2, y1, x2, y2, x1, y2)
            bodyPoly:close()
            return bodyPoly
        end
    },
    { -- rectangle
        poly = function (x, y)
            local bodyPoly
            local x1, y1 = x-bodyWidth/2, y-bodyHeight/2
            local x2, y2 = x+bodyWidth/2, y+bodyHeight/2
            bodyPoly = poly.new(x1, y1, x2, y1, x2, y2, x1, y2)
            bodyPoly:close()
            return bodyPoly
        end
    },
    { -- ellipse
        poly = function (x, y)
            local steps = 20
            local step = 360/steps -- the amount to step in degrees
            local pos = 0
            local bodyPoly = poly.new(steps)
            for i=1,steps do
                pos = i*step
                local pointX = math.floor(x + headWidth/2*math.cos(math.rad(pos)))
                local pointY = math.floor(y + headHeight/2*math.sin(math.rad(pos)))
                bodyPoly:setPointAt(i, pointX, pointY)
            end
            bodyPoly:close()
            return bodyPoly
        end
    },
    { -- hourglass
        poly = function (x, y)
            local bodyPoly
            local x1, y1 = x-bodyWidth/2, y-bodyHeight/2
            local x2, y2 = x+bodyWidth/2, y+bodyHeight/2
            local mx1, mx2 = x-bodyWidth/3, x+bodyWidth/3
            bodyPoly = poly.new(x1, y1, x2, y1, mx2, y, x2, y2, x1, y2, mx1, y)
            bodyPoly:close()
            return bodyPoly
        end
    }
}
heads = {
    { -- ellipse
        species = species.human,
        poly = function(x, y)
            local steps = 20
            local step = 360/steps -- the amount to step in degrees
            local pos = 0

            local headPoly = poly.new(steps)
            for i=1,steps do
                pos = i*step
                local pointX = math.floor(x + headWidth/2*math.cos(math.rad(pos)))
                local pointY = math.floor(y + headHeight/2*math.sin(math.rad(pos)))
                headPoly:setPointAt(i, pointX, pointY)
            end

            headPoly:close()
            return headPoly
        end
    },
    { -- pointed
        species = species.human,
        poly = function(x, y)
            local steps = 20
            local step = 360/steps -- the amount to step in degrees
            local pos = 0

            local headPoly = poly.new(steps)
            for i=1,steps do
                pos = i*step
                local pointX = math.floor(x + headWidth/2*math.cos(math.rad(pos)))
                local pointY = math.floor(y + headHeight/2*math.sin(math.rad(pos)))
                
                if i == 1 then
                    headPoly:setPointAt(i, x + headWidth/2 - 1, pointY)
                elseif i == 2 then
                    headPoly:setPointAt(i, x + headWidth/2 - 4, pointY+1)
                elseif i == 3 then
                    headPoly:setPointAt(i, x + headWidth/2 - 8, pointY+2)
                elseif i == 4 then
                    headPoly:setPointAt(i, x + headWidth/2 - 13, pointY+3)
                elseif i == 5 then
                    headPoly:setPointAt(i, x, y+headHeight/2+4)
                elseif i == 6 then
                    headPoly:setPointAt(i, x - headWidth/2 + 12, pointY+3)
                elseif i == 7 then
                    headPoly:setPointAt(i, x - headWidth/2 + 7, pointY+2)
                elseif i == 8 then
                    headPoly:setPointAt(i, x - headWidth/2 + 3, pointY+1)
                elseif i == 9 then
                    headPoly:setPointAt(i, x - headWidth/2 + 0, pointY)
                else
                    headPoly:setPointAt(i, pointX, pointY)
                end
            end

            headPoly:close()
            return headPoly
        end
    },
    { -- pointed wide
        species = species.human,
        poly = function(x, y)
            local steps = 20
            local step = 360/steps -- the amount to step in degrees
            local pos = 0

            local headPoly = poly.new(steps)
            for i=1,steps do
                pos = i*step
                local pointX = math.floor(x + headWidth/2*math.cos(math.rad(pos)))
                local pointY = math.floor(y + headHeight/2*math.sin(math.rad(pos)))
                
                if i == 2 then
                    headPoly:setPointAt(i, x + headWidth/2 - 2, pointY)
                elseif i == 3 then
                    headPoly:setPointAt(i, x + headWidth/2 - 5, pointY)
                elseif i == 4 then
                    headPoly:setPointAt(i, x + headWidth/2 - 14, pointY)
                elseif i == 5 then
                    headPoly:setPointAt(i, x, y+headHeight/2)
                elseif i == 6 then
                    headPoly:setPointAt(i, x - headWidth/2 + 13, pointY)
                elseif i == 7 then
                    headPoly:setPointAt(i, x - headWidth/2 + 4, pointY)
                elseif i == 8 then
                    headPoly:setPointAt(i, x - headWidth/2 + 1, pointY)
                else
                    headPoly:setPointAt(i, pointX, pointY)
                end
            end

            headPoly:close()
            return headPoly
        end
    },
    { -- cat
        species = species.cat,
        poly = function(x, y)
            local steps = 20
            local step = 360/steps -- the amount to step in degrees
            local pos = 0
            local muzzleLength = 2
            local fluffLength = 4

            local headPoly = poly.new(steps)
            for i=1,steps do
                pos = i*step
                local pointX = math.floor(x + headWidth/2*math.cos(math.rad(pos)))
                local pointY = math.floor(y + headHeight/2*math.sin(math.rad(pos)))
                
                if i == 8 then
                    headPoly:setPointAt(i, x - headWidth/2-muzzleLength, pointY)
                elseif i == 7 then
                    headPoly:setPointAt(i, x - headWidth/2-muzzleLength+3, y + headHeight/2)
                elseif i == 6 then
                    headPoly:setPointAt(i, pointX, y + headHeight/2)
                elseif i == 1 or i == 3 then
                    headPoly:setPointAt(i, pointX+fluffLength, pointY)
                else
                    headPoly:setPointAt(i, pointX, pointY)
                end
            end

            headPoly:close()
            return headPoly
        end
    },
    { -- dog
        species = species.dog,
        poly = function(x, y)
            local steps = 20
            local step = 360/steps -- the amount to step in degrees
            local pos = 0
            local muzzleLength = 4
            local fluffLength = 4

            local headPoly = poly.new(steps)
            for i=1,steps do
                pos = i*step
                local pointX = math.floor(x + headWidth/2*math.cos(math.rad(pos)))
                local pointY = math.floor(y + headHeight/2*math.sin(math.rad(pos)))
                
                if i == 8 then
                    headPoly:setPointAt(i, x - headWidth/2-muzzleLength, pointY)
                elseif i == 7 then
                    headPoly:setPointAt(i, x - headWidth/2-muzzleLength+3, y + headHeight/2)
                elseif i == 6 then
                    headPoly:setPointAt(i, pointX, y + headHeight/2)
                elseif i == 1 or i == 3 then
                    headPoly:setPointAt(i, pointX+fluffLength, pointY)
                else
                    headPoly:setPointAt(i, pointX, pointY)
                end
            end

            headPoly:close()
            return headPoly
        end
    }
}
eyes = {
	{
		left = 1, -- the index of the sprite from asset.eye to use
		right = 1, -- the index of the sprite from asset.eye to use
		mirrorLeft = false
	},
	{
		left = 2,
		right = 2,
		mirrorLeft = false
	},
	{
		left = 3,
		right = 3,
		mirrorLeft = false
	},
	{
		left = 5,
		right = 4,
		mirrorLeft = false
	},
    {
        left = 6,
        right = 6,
        mirrorLeft = false
    },
    {
        left = 7,
        right = 7,
        mirrorLeft = false
    },
    {
        left = 8,
        right = 8,
        mirrorLeft = false
    },
    {
        left = 10,
        right = 9,
        mirrorLeft = false
    },
    {
        left = 12,
        right = 11,
        mirrorLeft = false
    },
    {
        left = 14,
        right = 13,
        mirrorLeft = false
    },
    {
        left = 15,
        right = 15,
        mirrorLeft = false
    },
    {
        left = 16,
        right = 16,
        mirrorLeft = false
    },
    {
        left = 17,
        right = 17,
        mirrorLeft = false
    },
    {
        left = 18,
        right = 18,
        mirrorLeft = true
    }
}


-- Define parameters and their limits
limit = {}

body = {}
body.type = 1
body.width = 0.5
body.height = 0.5
limit.body = {
	width = {
		max = 45,
		min = 12
	},
	height = {
		max = 40,
		min = 20
	},
	type = #bodies
}

head = {}
head.type = 1
head.height = 0.5
limit.head = {
	height = {
		max = 35,
		min = 30
	},
    type = #heads
}

face = {
	eyes = {
		typeR = 1,
        typeL = 1,
		x = 0.5,
		y = 0.5,
        sizeR = size.medium,
        sizeL = size.medium,
		invert = false
	},
	brows = {
		typeR = 1,
        typeL = 1,
		x = 0.5,
		y = 0.5,
        sizeR = size.medium,
        sizeL = size.medium,
		invert = false
	},
	nose = {
		type = 1,
		y = 0.5,
        size = size.medium,
		invert = true
	},
	mouth = {
		type = 1,
		y = 1,
        size = size.medium,
        mirror = true,
		invert = true
	},

}
limit.face = {
	eyes = {
		type = #eyes,
		x = {
			min = 5,
			max = 10
		},
		y = {
			min = -2,
			max = 2
		}
	},
	brows = {
		type = 1,
		x = {
			min = 5,
			max = 10
		},
		y = {
			min = -3,
			max = 3
		}
	},
	nose = {
		type = noseNum,
		y = {
			min = -5,
			max = 5
		}
	},
	mouth = {
		type = mouthNum,
		y = {
			min = -3,
			max = 3
		}
	}
}

skin = 0.5 -- 1 is pure white, 0 is pitch black

handRadius = 6 -- gets modified by average body size
footWidth = 20 -- gets modified by average body size
footHeight = 10 -- gets modified by average body size
legLength = 40 -- gets modified by body height