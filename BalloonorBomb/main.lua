-----------------------------------------------------------------------------------------
--
-- Falling balloon and bomb game
-- Written by Gary Sims altered by Michael Cassens
--
-----------------------------------------------------------------------------------------

-- Start the physics engine
local physics = require( "physics" )
physics.start()

-- Calculate half the screen width and height
halfW = display.contentWidth*0.5
halfH = display.contentHeight*0.5

-- Set the background
local bkg = display.newImage( "background.png", halfW, halfH )

-- Score
score = 0
scoreText = display.newText(("Score: " .. score),halfW, 10)

local function balloonListener( event, object)
    if(object ~= nil) then
	    if(object.setLinearVelocity ~= nil) then
		object:setLinearVelocity(0,50)
		end
	end
end
 --
     local balloonMovement = function(balloon)
         return function(event)
             balloonListener(event,balloon)
         end
     end
	

-- Called when the balloon is tapped by the player
-- Increase score by 1
local function balloonTouched(event)
    if ( event.phase == "began" ) then
		Runtime:removeEventListener( "enterFrame", balloonFunction)
		event.target:removeSelf()
        score = score + 1
        scoreText.text = ("Score: " .. score)
    end
end

-- Called when the bomb is tapped by the player
-- Half the score as a penalty
local function bombTouched(event)
    if ( event.phase == "began" ) then
        Runtime:removeEventListener( "enterFrame", bombFunction )
		event.target:removeSelf()
        score = math.floor(score * 0.5)
        scoreText.text = ("Score: " .. score)
    end
end

-- Delete objects which has fallen off the bottom of the screen
local function offscreen(self, event)
    if(self.y == nil) then
        return
    end
    if(self.y > display.contentHeight + 50) then
        Runtime:removeEventListener( "enterFrame", self )
        self:removeSelf()
    end
end

 
	local function bombListener( event, object)
    --print ( tostring(event.time/1000) .. " seconds since app started." )
	if(object ~= nil) then 
		if(object.setLinearVelocity ~= nil) then
			object:setLinearVelocity(0,50)
		end
	end
	
end
 --
     local bombMovement = function(bomb)
         return function(event)
             bombListener(event,bomb)
         end
     end
local balloonFunction
local bombFunction

-- Add a new falling balloon or bomb
local function addNewBalloonOrBomb()
    
	local startX = math.random(display.contentWidth*0.1,display.contentWidth*0.9)
	local randomNumber = math.random(1,5)
    if(randomNumber==1 or randomNumber == 3) then
        -- BOMB!
        local bomb = display.newImage( "bomb.png", startX, -300)
        
		physics.addBody( bomb )
        bomb:setLinearVelocity(-10,-10)
		bomb.enterFrame = offscreen
		bombFunction = bombMovement(bomb)
        Runtime:addEventListener( "enterFrame",  bombFunction)
        bomb:addEventListener( "touch", bombTouched )
    else
        -- Balloon
        local balloon = display.newImage( "balloon.png", startX, -300)
        
		physics.addBody( balloon )
    	
		balloon.enterFrame = offscreen
    	balloonFunction = balloonMovement(balloon)
		Runtime:addEventListener( "enterFrame", balloonFunction)
        
		balloon:addEventListener( "touch", balloonTouched )
    end
end

-- Add a new balloon or bomb now
addNewBalloonOrBomb()

local balloonListener = function( event )
        balloon:setLinearVelocity(0,0)	
end

-- Keep adding a new balloon or bomb every 1 second
timer.performWithDelay( 1000, addNewBalloonOrBomb, 0 )

-- 1. change the speed of the balloons and bombs
-- 2. add more bombs
-- 3. change the time in between when the bombs or balloons appear
-- 4. change levels after a certain point
-- 5. make the bombs and balloons rotate as they fall