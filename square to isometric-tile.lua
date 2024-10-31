-- recept
-- dra ut plus en på alla sidor
-- rotera 45 grader
-- dra ihop ifrån toppen typ 48%
-- Markeringen skall vara tre pixlar över om det är 16x16
-- Markeringen skall vara 6 pixlar över om det är 32x32

function CopyImage(fromImage, rect, newImageSize, colorMode)
  local pixelsFromSelection = fromImage:pixels(rect)
  local imageCopy = Image(newImageSize.x, newImageSize.y, colorMode)
  
  for it in pixelsFromSelection do
    local pixelValue = it()
    imageCopy:drawPixel(it.x - rect.x, it.y - rect.y, pixelValue)
  end
  return imageCopy
end

--loop through x texture coords
function ToIso(fromImage, rect, newImageSize, colorMode)
  local pixelsFromSelection = fromImage:pixels(rect)
  local selectedImage = Image(newImageSize.x, newImageSize.y, colorMode)

  for it in pixelsFromSelection do
    local pixelValue = it()
    
    local newx = (newImageSize.x/2-2)+it.x*2-it.y*2
    local newy = it.x+it.y
    local stopx = newx+3
    for tempx=newx,stopx,1 do
      --add one to y axis so the resize would work
      selectedImage:putPixel(tempx, newy+1, pixelValue)
    end
  end

  selectedImage:putPixel(newImageSize.x - 1, newImageSize.y - 1, redPixel)
  return selectedImage
end


---------------------------------------------
-- check that the sprite selection is valid
local sprite = app.sprite
if not sprite then 
    print("No sprite")
    return 
end
local selection = sprite.selection
if selection.isEmpty then 
    print("Missing selection")
    return 
end
if selection.bounds.width % 2 ~= 0 then
  print("The width must be an even number")
  return
end
if selection.bounds.width ~= selection.bounds.height then
  print("The selection must be a square")
  return
end
---------------------------------------------
local selectWidth = selection.bounds.width
local selectHeight = selection.bounds.height
local originPoint = selection.origin
local currentCel = app.cel
local colorMode = sprite.colorMode
---------------------------------------------

local currentImage = Image(sprite.width, sprite.height, colorMode)
currentImage:drawSprite(sprite, currentCel.frameNumber)

local selectedImage = CopyImage(currentImage, selection.bounds, Point(selectWidth, selectHeight), colorMode)

local isometricTile = ToIso(selectedImage, Rectangle(0,0,selectWidth,selectHeight), Point(selectWidth * 4,selectHeight * 2), colorMode)
isometricTile:resize{width=(selectWidth*2),height=selectHeight}
isometricTile = CopyImage(isometricTile, Rectangle(0,1,selectWidth*2,selectHeight), Point(selectWidth*2,selectHeight), colorMode)

local outputLayer = sprite:newLayer()
outputLayer.name = "IsometricTile"
local outputSprite = outputLayer.sprite
local cel = sprite:newCel(outputLayer, currentCel.frameNumber)
local backToOriginImage = Image(outputSprite.width,outputSprite.height, colorMode)
--backToOriginImage:drawImage(newIso, originPoint)
backToOriginImage:drawImage(isometricTile, originPoint)
cel.image = backToOriginImage