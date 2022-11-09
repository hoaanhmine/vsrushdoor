stage = 'rushsilly'
stopped = false
speed = 1
endingsection = false
local shadowLimit = 5

--[[
    the visuals side of things...
]]

function onCreatePost()
    if lowQuality then
        shadowLimit = 3
    end
    precacheImage('silly stuff')
    addHaxeLibrary('Application', 'lime.app')

    if shadersEnabled == false then
        runHaxeCode([[
            Application.current.window.alert('hey bro enable shaders in the settings or \nthis song may not work (:', "Attention!!");
        ]])
    end
    makeLuaSprite('bg', 'rush_stageOFF', -650, -300)
    scaleObject('bg', 1, 1)
    addLuaSprite('bg')

    makeLuaSprite('yourluasprite', 'rush_walkingstage', -100, -300)
    setScrollFactor('yourluasprite', 0, 0)
    addLuaSprite('yourluasprite')

    makeLuaSprite('yourluafloor', 'rush_walkingstage_floor', -100, getProperty('yourluasprite.y') + (getProperty('yourluasprite.height') - 10))
    setScrollFactor('yourluafloor', 0, 0)
    addLuaSprite('yourluafloor')

    setProperty('yourluasprite.visible', false)
    setProperty('yourluafloor.visible', false)

    initLuaShader("scroll")
     
    setSpriteShader('yourluasprite',"scroll")
    setSpriteShader('yourluafloor',"scroll")

    makeLuaSprite('overlay2', nil, -600, -300)
    makeGraphic('overlay2', 3000, 2000, '1F0000')
    addLuaSprite('overlay2', true)
    setProperty('overlay2.alpha', 0.6)
    setBlendMode('overlay2', 'divide')

end


local shadowTag = 'shadow'
local shadowCount = 0
local shadowAlpha = 1
function createShadow(char, strong)
	char = getCharacter(char)
	
	if (shadowCount > shadowLimit) then 
        shadowCount = 0
        for i in int(shadowLimit / 2) do
            removeLuaSprite(shadowTag .. char .. i, true)
        end
    end
	local tag = shadowTag .. char .. shadowCount
	
	local props = getProperties(char, {
		x = 'x',
		y = 'y',
        visible = 'visible'
	})
	
	makeLuaSprite(tag, 'silly stuff', props.x + 70, props.y + 200)
	scaleObject(tag, 1.5, 1.5, false)
	setProperty(tag .. '.alpha', shadowAlpha)
    setProperty(tag .. '.visible', props.visible)
	setProperty(tag .. '.color', getColorFromHex('000000'))
    setBlendMode(tag, 'divide')
	
	addLuaSprite(tag, false)
	setObjectOrder(tag, getObjectOrder(char .. 'Group') - 1)
	
	doTweenY('YAx' .. tag, tag, props.y + 200 - (250 * (getRandomFloat(-1, 1))), 1, 'quadOut')
    doTweenX('YAY' .. tag, tag, props.x + 70 - (300 * (getRandomFloat(-0.5, 0.5))), 1, 'quadOut')
	doTweenAlpha('Ang' .. tag, tag, 0, 1.3, 'quadIn')
	
	shadowCount = shadowCount + 1


end

function getProperties(par, props)
	local t = {}
	for i, v in pairs(props) do
		local ind = type(i) == 'string' and i or v
		t[ind] = getProperty(par .. '.' .. v)
	end
	return t
end

function getCharacter(char)
	if (type(char) ~= 'string') then return 'dad' end; char = char:lower()
	if (char:sub(1, 2) == 'bf' or char:sub(1, 3) == 'boy') then return 'boyfriend'
	elseif (char:sub(1, 2) == 'gf' or char:sub(1, 4) == 'girl') then return 'gf' end
	return 'dad'
end

function onTweenCompleted(t)
	if (t:sub(3, 1 + #shadowTag) == shadowTag) then
		local spr = t:sub(4, #t)
		removeLuaSprite(spr, true)
	end
end

function onUpdate()
    if stopped == false then
        setShaderFloat("yourluasprite", "iTime", os.clock() / 1.1 * speed)
        setShaderFloat('yourluafloor', "iTime", os.clock() * 1.2 * speed)
    end
end

function onMoveCamera(focus)
    if stage == 'rushsilly' then
        if focus == 'dad' then
            setProperty('defaultCamZoom', 0.9)
        else
            setProperty('defaultCamZoom', 1)
        end
    end
end
function onStepHit()
    if stage == 'rushsilly' and getProperty('dad.visible') == true then
        createShadow('dad', true)
    end
end
function onBeatHit()


    if curBeat == 152 then
        stage = 'scrollin'
        setProperty('defaultCamZoom', 1)
        setProperty('bg.visible', false)
        triggerEvent('Change Character', 'boyfriend', 'bf-walkin')
        setProperty('boyfriend.flipX', false)
        triggerEvent('Camera Follow Pos', getProperty('boyfriend.x') + 200, getProperty('boyfriend.y') + 100)
        setProperty('sily.visible', false)
        setProperty('dad.visible', false)
        setProperty('iconP2.visible', false)
        setProperty('yourluasprite.visible', true)
        setProperty('yourluafloor.visible', true)
        stopped = false

        makeAnimatedLuaSprite('sillybeing', 'screech_assets', getProperty('boyfriend.x') + 360, getProperty('boyfriend.y') - 60)
        addLuaSprite('sillybeing', true)
        addAnimationByPrefix('sillybeing', 'dosilly', 'screech_scream', 24, false)
        addAnimationByPrefix('sillybeing', 'dosilly2', 'screech_leave', 24, false)
        objectPlayAnimation('sillybeing', 'dosilly', true)
        setProperty('sillybeing.alpha', 0)
    end

    if boyfriendName == 'bf-walkin' and stopped == false and not endingsection then
        setProperty('boyfriend.y', getProperty('boyfriend.y') + 25)
        doTweenY('boyfriendtween' .. curBeat, 'boyfriend', getProperty('boyfriend.y') - 25, 0.2, 'sineOut')
    end

    if curBeat == 200 then
        stopped = true
    end

    if curBeat == 206 then
        setProperty('sillybeing.alpha', 1)
        objectPlayAnimation('sillybeing', 'dosilly', true)
    end

    if curBeat == 208 then
        objectPlayAnimation('sillybeing', 'dosilly2', true)
    end

    if curBeat == 220 then
        triggerEvent('Change Character', 'boyfriend', 'closet')
        setProperty('dad.visible', true)
        setProperty('iconP2.visible', true)
        stage = 'rushsilly'
        setProperty('bg.visible', true)
        setProperty('yourluasprite.visible', false)
        setProperty('yourluafloor.visible', false)
    end

    if curBeat == 352 then
        stage = 'scrollin'
        setProperty('defaultCamZoom', 1.2)
        setProperty('bg.visible', false)
        triggerEvent('Change Character', 'boyfriend', 'bf-walkin')
        setProperty('boyfriend.flipX', false)
        triggerEvent('Camera Follow Pos', getProperty('boyfriend.x') + 200, getProperty('boyfriend.y') + 100)
        setProperty('dad.visible', false)
        setProperty('iconP2.visible', false)
        setProperty('yourluasprite.visible', true)
        setProperty('yourluafloor.visible', true)
        setProperty('sily.visible', false)
        speed = 2
        stopped = false
        endingsection = true

        makeLuaSprite('overlay', nil, -600, -300)
        makeGraphic('overlay', 3000, 2000, '000000')
        addLuaSprite('overlay', true)
        setProperty('overlay.alpha', 0.6)
        setBlendMode('overlay', 'screen')

        cameraFlash('other', '000000', 1)
    end

    if curBeat == 384 then
        cameraFlash('other', '000000', 0.5)
    end
end

function opponentNoteHit()
    if getProperty('health') >= 0.016 then
        setProperty('health', getProperty('health') - 0.016)
    end
end