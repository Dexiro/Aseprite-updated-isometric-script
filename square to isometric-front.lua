--right side(front)
--the pixels will go up diagonally

local originPoint

-- bail if there's no active sprite
local sprite = app.sprite
local currentCel = app.cel
if not sprite then 
    print("No sprite")
    return 
end

-- bail if nothing's selected
local selection = sprite.selection
if selection.isEmpty then 
    print("Missing selection")
    return 
end

if selection.bounds.width % 2 ~= 0 then
    print("The width must be an even number")
end

function CopyImage(fromImage, rect, colorMode)
  local pixelsFromSelection = fromImage:pixels(rect)
  local selectedImage = Image(rect.width, rect.height + rect.width/2, colorMode)
  local yStartOffset = rect.width / 2
  local yOffset = yStartOffset
  
  for it in pixelsFromSelection do
    local pixelValue = it()
    local newX = it.x - rect.x
    local newY = it.y - rect.y
    if(newX % 2 == 0) then
      yOffset = yOffset - 1
    end

    if(newX == 0) then
      yOffset = yStartOffset
    end
    selectedImage:putPixel(newX, newY + yOffset, pixelValue)
  end
  return selectedImage
end

local colorMode = sprite.colorMode

originPoint = selection.origin
local currentImage = Image(sprite.width, sprite.height, colorMode)
currentImage:drawSprite(sprite, currentCel.frameNumber)
local selectedImage = CopyImage(currentImage, selection.bounds, colorMode)

local outputLayer = sprite:newLayer()
outputLayer.name = "IsometricFront"
local outputSprite = outputLayer.sprite
local cel = sprite:newCel(outputLayer, currentCel.frameNumber)
local backToOriginImage = Image(outputSprite.width,outputSprite.height, colorMode)
--backToOriginImage:drawImage(newIso, originPoint)
backToOriginImage:drawImage(selectedImage, originPoint)
cel.image = backToOriginImage