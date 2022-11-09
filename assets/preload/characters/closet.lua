directione = {'left', 'down', 'up', 'right'}
local isHere = false

function onCreatePost()
    if boyfriendName == 'closet' then
        makeAnimatedLuaSprite('sily', 'characters/BF_popupcloset', getProperty('boyfriend.x') + 360, getProperty('boyfriend.y') + 190)
        setScrollFactor('sily', 1.2, 1.1)
        addAnimationByPrefix('sily', 'appear', 'popup_bf_appear', 24, false)
        addAnimationByPrefix('sily', 'down', 'popup_bf_down', 24, false)
        addAnimationByPrefix('sily', 'up', 'popup_bf_up', 24, false)
        addAnimationByPrefix('sily', 'left', 'popup_bf_left', 24, false)
        addAnimationByPrefix('sily', 'right', 'popup_bf_right', 24, false)
        addAnimationByPrefix('sily', 'idle', 'popup_bf_idle', 24, false)
        addLuaSprite('sily', true)
        setProperty('sily.visible', false)
        setObjectOrder('sily', getObjectOrder('overlay2') - 1)
    end
end

-- Note miss/hit
function goodNoteHit(id, direction, noteType, isSustainNote)
    if boyfriendName == 'closet' then
        objectPlayAnimation('sily', directione[direction + 1], true)
    end
end

function onBeatHit()
    if boyfriendName == 'closet' then
        if getProperty('sily.animation.curAnim.finished') then
            
            objectPlayAnimation('sily', 'idle', true)
        end
    end
end


function onMoveCamera(focus)
    if boyfriendName == 'closet' then
	    if focus == 'boyfriend' and not isHere then
	    	isHere = true
            setProperty('sily.visible', true)
            objectPlayAnimation('sily', 'appear', true)
	    elseif focus == 'dad' then
	    	isHere = false
            setProperty('sily.visible', false)
	    end
    end
end