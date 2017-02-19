from PIL import Image
import os

for item in os.listdir("origin"):
    if(not item.endswith("png")): continue
    image = Image.open("origin/{}".format(item)).resize((70, 77))
    image.save("image2/{}".format(item))
