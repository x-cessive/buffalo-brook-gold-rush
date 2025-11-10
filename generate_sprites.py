import numpy as np
from PIL import Image
import os

def create_maple_tree_sprite(season="summer", size=(32, 48)):
    """
    Create a pixel art maple tree sprite with seasonal colors
    """
    width, height = size
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    pixels = np.array(img)
    
    # Define seasonal colors
    if season == "spring":
        trunk_color = (139, 69, 19, 255)  # Saddle brown
        leaf_colors = [(144, 238, 144, 255), (124, 252, 0, 255), (173, 255, 47, 255)]  # Light green shades
    elif season == "summer":
        trunk_color = (139, 69, 19, 255)  # Saddle brown
        leaf_colors = [(34, 139, 34, 255), (50, 205, 50, 255), (46, 139, 87, 255)]  # Forest green shades
    elif season == "autumn":
        trunk_color = (139, 69, 19, 255)  # Saddle brown
        leaf_colors = [(220, 20, 60, 255), (178, 34, 34, 255), (139, 0, 0, 255), (255, 215, 0, 255), (255, 165, 0, 255)]  # Red and gold shades
    else:  # winter
        trunk_color = (139, 69, 19, 255)  # Saddle brown
        leaf_colors = [(105, 105, 105, 255), (128, 128, 128, 255), (169, 169, 169, 255)]  # Gray shades for bare branches
    
    # Draw trunk
    trunk_width = max(2, width // 8)
    trunk_start_x = width // 2 - trunk_width // 2
    trunk_height = height * 2 // 3
    trunk_start_y = height - trunk_height
    
    for y in range(trunk_start_y, height):
        for x in range(trunk_start_x, trunk_start_x + trunk_width):
            if 0 <= x < width and 0 <= y < height:
                pixels[y, x] = trunk_color
    
    # Draw leaves/branches
    leaf_start_y = trunk_start_y - height // 4
    leaf_center_x = width // 2
    
    # Create maple leaf shape
    for y in range(leaf_start_y, trunk_start_y):
        for x in range(max(0, leaf_center_x - width//2), min(width, leaf_center_x + width//2)):
            # Calculate distance from center to create rounded leaf shape
            dy = y - leaf_start_y
            dx = abs(x - leaf_center_x)
            
            # Create a more organic maple leaf shape
            max_dist = width // 2 - (dy * (width // 4)) // (trunk_start_y - leaf_start_y)
            if dx <= max_dist:
                # Add some randomness for organic look
                import random
                if random.random() > 0.2:  # Reduce density slightly
                    color_idx = min(len(leaf_colors)-1, max(0, int((dx + dy) % len(leaf_colors))))
                    pixels[y, x] = leaf_colors[color_idx]
    
    # Convert back to image
    return Image.fromarray(pixels, 'RGBA')

def create_birch_tree_sprite(season="summer", size=(24, 48)):
    """
    Create a pixel art birch tree sprite with seasonal colors
    """
    width, height = size
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    pixels = np.array(img)
    
    # Define seasonal colors
    if season == "winter":
        trunk_color = (210, 210, 210, 255)  # Light gray/white bark
        leaf_colors = [(105, 105, 105, 255), (128, 128, 128, 255)]  # Gray for bare branches
    else:
        trunk_color = (210, 210, 210, 255)  # Light gray/white bark
        if season == "spring":
            leaf_colors = [(144, 238, 144, 255), (124, 252, 0, 255)]  # Light green shades
        elif season == "summer":
            leaf_colors = [(34, 139, 34, 255), (50, 205, 50, 255)]  # Forest green shades
        else:  # autumn
            leaf_colors = [(255, 215, 0, 255), (255, 165, 0, 255), (210, 180, 140, 255)]  # Gold/yellow shades
    
    # Draw trunk with distinctive birch bark pattern
    trunk_width = max(2, width // 6)
    trunk_start_x = width // 2 - trunk_width // 2
    trunk_height = height
    trunk_start_y = 0
    
    for y in range(trunk_start_y, trunk_start_y + trunk_height):
        for x in range(trunk_start_x, trunk_start_x + trunk_width):
            if 0 <= x < width and 0 <= y < height:
                # Add some variation to the bark for birch texture
                import random
                variation = random.randint(-10, 10)
                pixels[y, x] = (
                    min(255, max(0, trunk_color[0] + variation)),
                    min(255, max(0, trunk_color[1] + variation)),
                    min(255, max(0, trunk_color[2] + variation)),
                    trunk_color[3]
                )
    
    # Draw leaves/branches
    leaf_start_y = 0
    leaf_center_x = width // 2
    
    # Create birch leaf shape
    for y in range(leaf_start_y, height // 2):
        for x in range(max(0, leaf_center_x - width//2), min(width, leaf_center_x + width//2)):
            # Calculate distance from center to create rounded leaf shape
            dy = y - leaf_start_y
            dx = abs(x - leaf_center_x)
            
            # Create a more organic birch leaf shape
            max_dist = width // 3 - (dy * (width // 6)) // (height // 2)
            if dx <= max_dist:
                # Add some randomness for organic look
                import random
                if random.random() > 0.3:  # Reduce density slightly
                    color_idx = min(len(leaf_colors)-1, max(0, int((dx + dy) % len(leaf_colors))))
                    pixels[y, x] = leaf_colors[color_idx]
    
    # Convert back to image
    return Image.fromarray(pixels, 'RGBA')

def create_rock_sprite(rock_type="granite", size=(16, 16)):
    """
    Create a pixel art rock sprite with granite or schist texture
    """
    width, height = size
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    pixels = np.array(img)
    
    # Define rock colors
    if rock_type == "granite":
        base_colors = [
            (139, 139, 139, 255),  # Dark gray
            (169, 169, 169, 255),  # Medium gray
            (192, 192, 192, 255),  # Light gray
            (105, 105, 105, 255),  # Dim gray
        ]
    else:  # schist
        base_colors = [
            (112, 128, 144, 255),  # Slate gray
            (140, 140, 140, 255),  # Medium gray
            (70, 70, 70, 255),     # Dark gray
            (175, 175, 175, 255),  # Light slate
        ]
    
    # Draw rock with random fill using base colors
    for y in range(height):
        for x in range(width):
            # Calculate distance from center to form a rock shape
            center_x, center_y = width // 2, height // 2
            dist = ((x - center_x) ** 2 + (y - center_y) ** 2) ** 0.5
            
            # Only draw if within the rock shape
            max_radius = min(width, height) // 2
            if dist <= max_radius * 0.8:  # Make it slightly smaller than possible
                import random
                color_idx = random.randint(0, len(base_colors) - 1)
                pixels[y, x] = base_colors[color_idx]
    
    # Convert back to image
    return Image.fromarray(pixels, 'RGBA')

def create_gold_sprite(gold_type="flake", size=(8, 8)):
    """
    Create a pixel art gold sprite (flake, nugget)
    """
    width, height = size
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    pixels = np.array(img)
    
    gold_colors = [
        (255, 215, 0, 255),    # Gold
        (255, 235, 64, 255),   # Light gold
        (238, 203, 21, 255),   # Golden
        (255, 165, 0, 255),    # Orange
    ]
    
    if gold_type == "flake":
        # Create a small gold flake
        for y in range(height):
            for x in range(width):
                # Calculate distance from center to make a small irregular shape
                center_x, center_y = width // 2, height // 2
                dist = ((x - center_x) ** 2 + (y - center_y) ** 2) ** 0.5
                
                # Draw if within flake shape
                if dist <= width // 2.5 and np.random.random() > 0.3:
                    import random
                    color_idx = random.randint(0, len(gold_colors) - 1)
                    pixels[y, x] = gold_colors[color_idx]
    elif gold_type == "nugget":
        # Create a larger gold nugget
        for y in range(height):
            for x in range(width):
                # Calculate distance from center to make an irregular nugget shape
                center_x, center_y = width // 2, height // 2
                dist = ((x - center_x) ** 2 + (y - center_y) ** 2) ** 0.5
                
                # Draw if within nugget shape (more filled than flake)
                if dist <= width // 2.2:
                    import random
                    color_idx = random.randint(0, len(gold_colors) - 1)
                    pixels[y, x] = gold_colors[color_idx]
                    
                    # Add a slight shine effect
                    if x == center_x and y == center_y:
                        pixels[y, x] = (255, 255, 200, 255)  # Bright highlight
    
    # Convert back to image
    return Image.fromarray(pixels, 'RGBA')

def create_pan_sprite(size=(32, 16)):
    """
    Create a pixel art gold panning tool
    """
    width, height = size
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    pixels = np.array(img)
    
    # Pan colors (metallic)
    pan_colors = [
        (192, 192, 192, 255),  # Silver
        (169, 169, 169, 255),  # Dark gray
        (200, 200, 200, 255),  # Light gray
        (128, 128, 128, 255),  # Gray
    ]
    
    # Create pan shape - oval-like
    center_x, center_y = width // 2, height // 2
    for y in range(height):
        for x in range(width):
            # Calculate normalized distance for oval shape
            dx = (x - center_x) / (width / 2)
            dy = (y - center_y) / (height / 1.5)
            dist = (dx**2 + dy**2)**0.5
            
            if dist <= 1.0:
                import random
                color_idx = random.randint(0, len(pan_colors) - 1)
                
                # Add some texture variation
                if abs(x - center_x) < width // 4 and abs(y - center_y) < height // 4:
                    # Brighter in center to simulate light reflecting
                    pixels[y, x] = (
                        min(255, pan_colors[color_idx][0] + 20),
                        min(255, pan_colors[color_idx][1] + 20),
                        min(255, pan_colors[color_idx][2] + 20),
                        pan_colors[color_idx][3]
                    )
                else:
                    pixels[y, x] = pan_colors[color_idx]
    
    # Convert back to image
    return Image.fromarray(pixels, 'RGBA')

def create_water_sprite(size=(16, 16)):
    """
    Create a pixel art water sprite with seasonal colors
    """
    width, height = size
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    pixels = np.array(img)
    
    # Base water colors (using summer colors from art guide)
    water_base_colors = [
        (47, 133, 214, 255),   # Summer stream blue
        (74, 144, 226, 255),   # Bright blue
        (93, 173, 236, 255),   # Light blue
    ]
    
    # Draw water with some wave patterns
    for y in range(height):
        for x in range(width):
            import random
            # Add some wave-like patterns
            wave_offset = int(2 * np.sin(x * 0.5 + y * 0.3))
            color_idx = (x + y + wave_offset) % len(water_base_colors)
            pixels[y, x] = water_base_colors[color_idx]
            
            # Add some brightness variation
            if random.random() > 0.7:
                # Add a highlight
                pixels[y, x] = (min(255, water_base_colors[color_idx][0] + 30),
                                min(255, water_base_colors[color_idx][1] + 30),
                                min(255, water_base_colors[color_idx][2] + 50),
                                water_base_colors[color_idx][3])
    
    # Convert back to image
    return Image.fromarray(pixels, 'RGBA')

def create_chipmunk_sprite(size=(16, 16)):
    """
    Create a pixel art chipmunk sprite
    """
    width, height = size
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    pixels = np.array(img)
    
    # Chipmunk colors
    body_color = (188, 143, 143, 255)  # Rosy brown
    belly_color = (255, 250, 250, 255)  # Floral white
    stripe_color = (139, 69, 19, 255)  # Saddle brown
    eye_color = (0, 0, 0, 255)  # Black
    
    # Draw body (simple oval shape)
    center_x, center_y = width // 2, height // 2
    for y in range(height):
        for x in range(width):
            dx = (x - center_x) / (width / 2.5)
            dy = (y - center_y) / (height / 2)
            dist = (dx**2 + dy**2)**0.5
            
            if dist <= 1.0:
                pixels[y, x] = body_color
                # Add belly (lighter area on bottom)
                if y > center_y + height // 6:
                    pixels[y, x] = belly_color
    
    # Draw stripes
    for y in range(height // 4, height * 3 // 4):
        for x in range(width // 4, width * 3 // 4):
            if abs(x - center_x) < width // 8:
                pixels[y, x] = stripe_color
    
    # Draw eye
    if width > 4 and height > 4:
        eye_x, eye_y = width * 3 // 4, height // 3
        pixels[eye_y, eye_x] = eye_color
    
    # Convert back to image
    return Image.fromarray(pixels, 'RGBA')

def create_fish_sprite(size=(16, 12)):
    """
    Create a pixel art fish sprite
    """
    width, height = size
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    pixels = np.array(img)
    
    # Fish colors
    body_color = (70, 130, 180, 255)  # Steel blue
    fin_color = (100, 149, 237, 255)  # Cornflower blue
    eye_color = (0, 0, 0, 255)  # Black
    
    # Draw fish body (tear drop shape)
    center_x, center_y = width // 2, height // 2
    for y in range(height):
        for x in range(width):
            # Create fish shape (wider in middle, narrower at tail)
            dx = (x - center_x) / (width / 2.5)
            dy = (y - center_y) / (height / 3)
            # Modify to look like a fish body
            dist = ((dx * 0.8)**2 + dy**2)**0.5
            
            if dist <= 0.8 and x < width * 4 // 5:  # More like a fish shape
                pixels[y, x] = body_color
    
    # Draw tail
    for y in range(height // 4, height * 3 // 4):
        for x in range(0, width // 4):
            # Create triangular tail
            if x < (width // 4) * (1 - abs(y - center_y) / (height / 2)):
                pixels[y, x] = fin_color
    
    # Draw fins
    for y in range(height // 3, height * 2 // 3):
        for x in range(width // 2, width * 3 // 4):
            if x == width // 2 and abs(y - center_y) < height // 6:
                pixels[y, x] = fin_color
    
    # Draw eye
    eye_x, eye_y = width * 3 // 4, center_y
    pixels[eye_y, eye_x] = eye_color
    
    # Convert back to image
    return Image.fromarray(pixels, 'RGBA')

def create_ui_element(element_type="button", size=(32, 16)):
    """
    Create a UI element sprite
    """
    width, height = size
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    pixels = np.array(img)
    
    # Use colors from UI theme in art guide
    if element_type == "button":
        base_color = (222, 184, 135, 255)  # Burlywood
        border_color = (139, 69, 19, 255)  # Saddle brown
        text_color = (47, 79, 79, 255)     # Dark slate gray
    elif element_type == "background":
        base_color = (210, 180, 140, 255)  # Tan
        border_color = (139, 69, 19, 255)  # Saddle brown
        text_color = (255, 215, 0, 255)    # Gold
    else:  # gold counter
        base_color = (255, 215, 0, 255)    # Gold
        border_color = (139, 69, 19, 255)  # Saddle brown
        text_color = (47, 79, 79, 255)     # Dark slate gray
    
    # Draw base
    for y in range(height):
        for x in range(width):
            pixels[y, x] = base_color
    
    # Draw border
    for y in [0, height-1]:
        for x in range(width):
            pixels[y, x] = border_color
    for x in [0, width-1]:
        for y in range(height):
            pixels[y, x] = border_color
    
    # Add simple pattern to button
    if element_type == "button":
        for y in range(2, height-2):
            for x in range(width//4, 3*width//4):
                if (x + y) % 4 == 0:  # Checkerboard pattern
                    pixels[y, x] = (
                        min(255, base_color[0] + 20),
                        min(255, base_color[1] + 20),
                        min(255, base_color[2] + 20),
                        base_color[3]
                    )
    
    # Convert back to image
    return Image.fromarray(pixels, 'RGBA')

def create_sediment_sprite(size=(8, 8)):
    """
    Create a particle sprite for sediment
    """
    width, height = size
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    pixels = np.array(img)
    
    # Sediment colors (earth tones)
    sediment_colors = [
        (160, 82, 45, 255),   # Sienna
        (139, 69, 19, 255),   # Saddle brown
        (205, 133, 63, 255),  # Peru
        (101, 67, 33, 255),   # Dark brown
    ]
    
    for y in range(height):
        for x in range(width):
            import random
            if random.random() > 0.4:  # Sparse particles
                color_idx = random.randint(0, len(sediment_colors) - 1)
                pixels[y, x] = sediment_colors[color_idx]
    
    # Convert back to image
    return Image.fromarray(pixels, 'RGBA')

def save_sprite(sprite, filepath):
    """Save the sprite to the specified filepath"""
    os.makedirs(os.path.dirname(filepath), exist_ok=True)
    sprite.save(filepath)
    print(f"Saved sprite: {filepath}")

def generate_all_sprites():
    """Generate all required sprites for the game"""
    # Create seasonal trees
    seasons = ["spring", "summer", "autumn", "winter"]
    for season in seasons:
        # Maple trees
        maple = create_maple_tree_sprite(season)
        save_sprite(maple, f"assets/sprites/environment/trees/maple_{season}.png")
        
        # Birch trees
        birch = create_birch_tree_sprite(season)
        save_sprite(birch, f"assets/sprites/environment/trees/birch_{season}.png")
    
    # Create rocks
    rock_types = ["granite", "schist"]
    for rock_type in rock_types:
        # Create different sizes
        for size_factor in [1, 1.5, 2]:
            rock_size = (int(16 * size_factor), int(16 * size_factor))
            rock = create_rock_sprite(rock_type, rock_size)
            save_sprite(rock, f"assets/sprites/environment/rocks/{rock_type}_{int(size_factor * 16)}x{int(size_factor * 16)}.png")
    
    # Create gold items
    gold_types = ["flake", "nugget"]
    for gold_type in gold_types:
        for size_factor in [1, 2, 3]:
            gold_size = (int(8 * size_factor), int(8 * size_factor))
            gold_sprite = create_gold_sprite(gold_type, gold_size)
            save_sprite(gold_sprite, f"assets/sprites/items/gold/{gold_type}_{int(size_factor * 8)}x{int(size_factor * 8)}.png")
    
    # Create panning tools
    pan = create_pan_sprite()
    save_sprite(pan, "assets/sprites/tools/pans/basic_pan.png")
    
    # Create water sprites
    water = create_water_sprite()
    save_sprite(water, "assets/sprites/environment/streams/water_still.png")
    
    # Create wildlife
    chipmunk = create_chipmunk_sprite()
    save_sprite(chipmunk, "assets/sprites/environment/wildlife/chipmunk.png")
    
    fish = create_fish_sprite()
    save_sprite(fish, "assets/sprites/environment/wildlife/fish.png")
    
    # Create UI elements
    button = create_ui_element("button")
    save_sprite(button, "assets/sprites/ui/buttons/basic_button.png")
    
    background = create_ui_element("background")
    save_sprite(background, "assets/sprites/ui/backgrounds/panel_background.png")
    
    gold_counter = create_ui_element("gold_counter")
    save_sprite(gold_counter, "assets/sprites/ui/icons/gold_counter.png")
    
    # Create particles
    sediment = create_sediment_sprite()
    save_sprite(sediment, "assets/sprites/environment/effects/sediment_particle.png")

if __name__ == "__main__":
    generate_all_sprites()