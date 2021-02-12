# Used to create a light image to be layed on top of the screen using a shader
# To create your own light image copy and paste a map in the same folder as this file,
# call it "Map.png", and then run it.


# Adapted from https://www.youtube.com/watch?v=XgdAkqg7eKs

from PIL import Image
import math

with Image.open("Map.png") as im:
    px = im.load()
width, height = im.size
light_values = [[]]
tiles = [[]]
solid_tiles = [ # used for calculating drop off distances for lights (solid tiles block lights better than air)
    (36, 113, 18, 255) # grass tile
]


# Creating a new light image
light_image = Image.new("RGBA", (width, height))
light_image.save("LightImage.png")
light_image = Image.open("LightImage.png")


def within_bounds(x, y):
    if x < width:
        if x >= 0:
            if y < height:
                if y >= 0:
                    return True
    return False


# Function for calculating light levels
def light_block(x, y, intensity, iteration):
    if iteration >= 8:
        return
    light_values[x][y] = intensity
    if tiles[x][y] == -1:
        dropoff = 0.9
    else:
        dropoff = 0.3

    for nx in range(x-1, x+2): # 3x3 area around the block to light
        for ny in range(y-1, y+2):
            if nx != x or ny != y: # checks if block is not self
                distance = math.sqrt( (nx -x) * (nx-x) + (ny-y) * (ny-y)) 
                target_intensity = intensity * (dropoff ** distance)
                if within_bounds(nx, ny) and light_values[nx][ny] < target_intensity: # otherwise there are glitchy lights and list index errors
                    light_block(nx, ny, target_intensity, iteration + 1) # recursion

                    
# Creates a 2D dict the size of the map
def append_dict():
    print("Appending dict")        
    for x in range(0, width):
        light_values.append([])
        tiles.append([])
        for y in range(0, height):
            light_values[x].append(0)
            tiles[x].append(0)
            if px[x, y] not in solid_tiles:
                tiles[x][y] = -1
            else:
                tiles[x][y] = 0

        
def set_block_lights():
    print("Setting block lights")
    for x in range(0, len(light_values)):
        for y in range(0, len(light_values[x])):
            if tiles[x][y] == -1:
                light_block(x, y, 1, 0)


def create_image():
    print("Creating image")
    for x in range(0, len(light_values)):
        for y in range(0, len(light_values[x])):
            light_image.putpixel((x, y), (int(light_values[x][y]*255), int(light_values[x][y]*255), int(light_values[x][y]*255), 255))


def save_image():
    light_image.save("LightImage.png")
    light_image.show()


append_dict()
set_block_lights()
create_image()
save_image()
print("Finished")
