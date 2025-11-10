import numpy as np
from PIL import Image
import os

def create_water_particle(size=(4, 4)):
    """
    Create a water particle sprite for effects
    """
    width, height = size
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    pixels = np.array(img)
    
    # Water colors with transparency
    water_colors = [
        (47, 133, 214, 180),   # Summer stream blue (semi-transparent)
        (74, 144, 226, 150),   # Bright blue (more transparent)
        (93, 173, 236, 120),   # Light blue (very transparent)
        (255, 255, 255, 100),  # White highlight (translucent)
    ]
    
    # Fill with random water-colored pixels
    import random
    for y in range(height):
        for x in range(width):
            if random.random() > 0.2:  # Sparse particles
                color_idx = random.randint(0, len(water_colors) - 1)
                pixels[y, x] = water_colors[color_idx]
    
    # Convert back to image
    return Image.fromarray(pixels, 'RGBA')

def create_sediment_particle(size=(3, 3)):
    """
    Create a sediment particle sprite
    """
    width, height = size
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    pixels = np.array(img)
    
    # Sediment colors (earth tones)
    sediment_colors = [
        (160, 82, 45, 200),   # Sienna
        (139, 69, 19, 180),   # Saddle brown
        (205, 133, 63, 160),  # Peru
        (101, 67, 33, 140),   # Dark brown
    ]
    
    import random
    for y in range(height):
        for x in range(width):
            if random.random() > 0.3:  # Sparse particles
                color_idx = random.randint(0, len(sediment_colors) - 1)
                pixels[y, x] = sediment_colors[color_idx]
    
    # Convert back to image
    return Image.fromarray(pixels, 'RGBA')

def create_gold_shimmer_particle(size=(4, 4)):
    """
    Create a gold shimmer particle for special effects
    """
    width, height = size
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    pixels = np.array(img)
    
    # Gold shimmer colors
    gold_colors = [
        (255, 255, 200, 180),  # Bright gold shimmer
        (255, 215, 0, 150),    # Gold (transparent)
        (255, 235, 64, 120),   # Light gold (very transparent)
    ]
    
    import random
    for y in range(height):
        for x in range(width):
            if random.random() > 0.4:  # Sparse shimmer
                color_idx = random.randint(0, len(gold_colors) - 1)
                pixels[y, x] = gold_colors[color_idx]
    
    # Convert back to image
    return Image.fromarray(pixels, 'RGBA')

def create_bubble_particle(size=(6, 6)):
    """
    Create a bubble particle for underwater effect
    """
    width, height = size
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    pixels = np.array(img)
    
    center_x, center_y = width // 2, height // 2
    
    # Bubble colors (translucent blue/white)
    bubble_colors = [
        (200, 230, 255, 80),   # Light blue translucent
        (220, 240, 255, 60),   # Very light blue
        (255, 255, 255, 40),   # White translucent
    ]
    
    for y in range(height):
        for x in range(width):
            dist = ((x - center_x) ** 2 + (y - center_y) ** 2) ** 0.5
            # Create hollow bubble effect
            if width // 4 <= dist <= width // 2:
                import random
                color_idx = random.randint(0, len(bubble_colors) - 1)
                pixels[y, x] = bubble_colors[color_idx]
            # Add highlight
            elif dist <= width // 6:
                pixels[y, x] = (255, 255, 255, 100)
    
    # Convert back to image
    return Image.fromarray(pixels, 'RGBA')

def create_mist_particle(size=(8, 8)):
    """
    Create a mist particle for atmospheric effects
    """
    width, height = size
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    pixels = np.array(img)
    
    # Mist colors (very translucent whites/grays)
    mist_colors = [
        (240, 248, 255, 40),   # Ghost white very translucent
        (230, 240, 250, 30),   # Alice blue very translucent
        (255, 255, 255, 25),   # White very translucent
    ]
    
    import random
    for y in range(height):
        for x in range(width):
            # Create organic mist pattern
            if random.random() > 0.6:  # Very sparse
                color_idx = random.randint(0, len(mist_colors) - 1)
                pixels[y, x] = mist_colors[color_idx]
    
    # Convert back to image
    return Image.fromarray(pixels, 'RGBA')

def create_leaf_particle(size=(6, 6)):
    """
    Create a falling leaf particle for seasonal effects
    """
    width, height = size
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    pixels = np.array(img)
    
    # Seasonal leaf colors
    spring_colors = [(144, 238, 144, 180)]  # Light green
    summer_colors = [(34, 139, 34, 180)]    # Forest green
    autumn_colors = [
        (220, 20, 60, 180),  # Crimson
        (255, 165, 0, 180),  # Orange
        (255, 215, 0, 180),  # Gold
    ]
    winter_colors = [(105, 105, 105, 180)]  # Gray
    
    # Use autumn colors by default
    leaf_colors = autumn_colors
    
    # Create a leaf shape
    center_x, center_y = width // 2, height // 2
    for y in range(height):
        for x in range(width):
            # Create a simple leaf-like shape
            dx = abs(x - center_x) / (width / 3)
            dy = (y - center_y) / (height / 2)
            dist = (dx**2 + dy**2)**0.5
            
            if dist <= 0.8 and abs(dx) <= 0.7:
                import random
                color_idx = random.randint(0, len(leaf_colors) - 1)
                pixels[y, x] = leaf_colors[color_idx]
    
    # Convert back to image
    return Image.fromarray(pixels, 'RGBA')

def create_snow_particle(size=(4, 4)):
    """
    Create a snow particle for winter effects
    """
    width, height = size
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    pixels = np.array(img)
    
    # Snow colors (white/translucent)
    snow_colors = [
        (255, 255, 255, 180),  # White
        (240, 248, 255, 150),  # Ghost white
        (230, 230, 250, 120),  # Lavender (slightly blue-white)
    ]
    
    import random
    for y in range(height):
        for x in range(width):
            if random.random() > 0.2:  # Fairly dense snow
                color_idx = random.randint(0, len(snow_colors) - 1)
                pixels[y, x] = snow_colors[color_idx]
    
    # Convert back to image
    return Image.fromarray(pixels, 'RGBA')

def create_rain_particle(size=(2, 6)):
    """
    Create a rain drop particle
    """
    width, height = size
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    pixels = np.array(img)
    
    # Rain colors (blue/translucent)
    rain_colors = [
        (176, 224, 230, 200),  # Powder blue
        (175, 238, 238, 180),  # Pale turquoise
        (200, 230, 255, 160),  # Light blue
    ]
    
    # Create raindrop shape (elongated teardrop)
    center_x = width // 2
    for y in range(height):
        for x in range(width):
            # Teardrop shape
            if abs(x - center_x) <= 1:  # Narrow vertical shape
                import random
                color_idx = random.randint(0, len(rain_colors) - 1)
                pixels[y, x] = rain_colors[color_idx]
    
    # Convert back to image
    return Image.fromarray(pixels, 'RGBA')

def create_sparkle_particle(size=(5, 5)):
    """
    Create a sparkle particle for special effects
    """
    width, height = size
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    pixels = np.array(img)
    
    # Sparkle colors
    sparkle_colors = [
        (255, 255, 200, 200),  # Bright yellow-white
        (255, 255, 255, 180),  # White
        (230, 240, 255, 150),  # Light blue-white
    ]
    
    center_x, center_y = width // 2, height // 2
    
    for y in range(height):
        for x in range(width):
            # Create star/sparkle shape
            if x == center_x or y == center_y or abs(x - center_x) == abs(y - center_y):
                import random
                color_idx = random.randint(0, len(sparkle_colors) - 1)
                pixels[y, x] = sparkle_colors[color_idx]
    
    # Convert back to image
    return Image.fromarray(pixels, 'RGBA')

def save_sprite(sprite, filepath):
    """Save the sprite to the specified filepath"""
    os.makedirs(os.path.dirname(filepath), exist_ok=True)
    sprite.save(filepath)
    print(f"Saved sprite: {filepath}")

def generate_particle_sprites():
    """Generate particle sprites for water effects and sediment"""
    # Create multiple sizes of each particle
    sizes = {
        "small": (3, 3),
        "medium": (6, 6),
        "large": (9, 9)
    }
    
    # Water particles
    for name, size in sizes.items():
        water = create_water_particle(size)
        save_sprite(water, f"assets/sprites/environment/effects/water_particle_{name}.png")
    
    # Sediment particles
    for name, size in sizes.items():
        sediment = create_sediment_particle(size)
        save_sprite(sediment, f"assets/sprites/environment/effects/sediment_particle_{name}.png")
    
    # Gold shimmer particles
    for name, size in sizes.items():
        gold_shimmer = create_gold_shimmer_particle(size)
        save_sprite(gold_shimmer, f"assets/sprites/environment/effects/gold_shimmer_{name}.png")
    
    # Create specific particle types
    bubble = create_bubble_particle()
    save_sprite(bubble, "assets/sprites/environment/effects/bubble_particle.png")
    
    mist = create_mist_particle()
    save_sprite(mist, "assets/sprites/environment/effects/mist_particle.png")
    
    leaf = create_leaf_particle()
    save_sprite(leaf, "assets/sprites/environment/effects/leaf_particle.png")
    
    snow = create_snow_particle()
    save_sprite(snow, "assets/sprites/environment/effects/snow_particle.png")
    
    rain = create_rain_particle()
    save_sprite(rain, "assets/sprites/environment/effects/rain_particle.png")
    
    sparkle = create_sparkle_particle()
    save_sprite(sparkle, "assets/sprites/environment/effects/sparkle_particle.png")

if __name__ == "__main__":
    generate_particle_sprites()