import numpy as np
from PIL import Image
import os

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

def create_sluice_box_sprite(size=(48, 24)):
    """
    Create a pixel art sluice box tool
    """
    width, height = size
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    pixels = np.array(img)
    
    # Wood colors for sluice box
    wood_colors = [
        (160, 120, 60, 255),   # Wood color
        (139, 69, 19, 255),   # Saddle brown
        (101, 67, 33, 255),   # Dark brown
        (190, 150, 90, 255),  # Light wood
    ]
    
    # Draw rectangular base of sluice box
    for y in range(height):
        for x in range(width):
            # Main rectangular shape with a slight trapezoid to show depth
            pixels[y, x] = wood_colors[(x + y) % len(wood_colors)]
    
    # Add some details - riffles (the bars that catch gold)
    for y in range(2, height-2, 4):  # Horizontal lines for riffles
        for x in range(5, width-5):
            pixels[y, x] = (139, 69, 19, 255)  # Darker brown for riffles
    
    # Convert back to image
    return Image.fromarray(pixels, 'RGBA')

def create_metal_detector_sprite(size=(24, 32)):
    """
    Create a pixel art metal detector
    """
    width, height = size
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    pixels = np.array(img)
    
    # Metal detector colors
    metal_colors = [
        (192, 192, 192, 255),  # Silver
        (128, 128, 128, 255),  # Gray
        (169, 169, 169, 255),  # Dark gray
    ]
    plastic_colors = [
        (70, 130, 180, 255),   # Steel blue
        (100, 149, 237, 255), # Cornflower blue
    ]
    
    # Draw handle (vertical)
    handle_width = width // 3
    handle_start_x = width // 2 - handle_width // 2
    handle_height = height * 3 // 4
    for y in range(height // 4, height // 4 + handle_height):
        for x in range(handle_start_x, handle_start_x + handle_width):
            pixels[y, x] = plastic_colors[0]
    
    # Draw main body (rectangular part)
    body_width = width * 4 // 5
    body_height = height // 4
    body_start_x = width // 2 - body_width // 2
    body_start_y = height // 3
    for y in range(body_start_y, body_start_y + body_height):
        for x in range(body_start_x, body_start_x + body_width):
            pixels[y, x] = metal_colors[y % len(metal_colors)]
    
    # Draw search coil (circular part at bottom)
    coil_radius = width // 3
    coil_center_x, coil_center_y = width // 2, height - coil_radius // 2
    for y in range(max(0, coil_center_y - coil_radius), min(height, coil_center_y + coil_radius)):
        for x in range(max(0, coil_center_x - coil_radius), min(width, coil_center_x + coil_radius)):
            dy = y - coil_center_y
            dx = x - coil_center_x
            dist = (dx**2 + dy**2)**0.5
            if dist <= coil_radius:
                pixels[y, x] = metal_colors[0]
    
    # Convert back to image
    return Image.fromarray(pixels, 'RGBA')

def create_pickaxe_sprite(size=(16, 24)):
    """
    Create a pixel art pickaxe
    """
    width, height = size
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    pixels = np.array(img)
    
    # Pickaxe colors
    metal_color = (105, 105, 105, 255)  # Dim gray
    handle_color = (139, 69, 19, 255)   # Saddle brown
    
    # Draw handle (wooden part)
    handle_width = width // 4
    handle_start_x = width // 2 - handle_width // 2
    for y in range(height):
        for x in range(handle_start_x, handle_start_x + handle_width):
            pixels[y, x] = handle_color
    
    # Draw metal head (pickaxe part)
    head_height = height // 3
    for y in range(height - head_height, height):
        for x in range(width):
            # Create the distinctive pickaxe shape
            if (abs(x - width//2) <= width//3 - (y - (height - head_height)) * (width//6) // head_height):
                pixels[y, x] = metal_color
    
    # Convert back to image
    return Image.fromarray(pixels, 'RGBA')

def create_sieve_sprite(size=(20, 20)):
    """
    Create a pixel art sieve/mesh tool
    """
    width, height = size
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    pixels = np.array(img)
    
    # Sieve colors
    frame_color = (169, 169, 169, 255)  # Dark gray
    mesh_color = (192, 192, 192, 255)  # Silver
    
    # Draw outer frame (circular)
    center_x, center_y = width // 2, height // 2
    outer_radius = min(width, height) // 2 - 1
    inner_radius = outer_radius - 2
    
    for y in range(height):
        for x in range(width):
            dist = ((x - center_x) ** 2 + (y - center_y) ** 2) ** 0.5
            if inner_radius <= dist <= outer_radius:
                pixels[y, x] = frame_color
    
    # Draw mesh pattern (grid)
    mesh_spacing = 3
    for y in range(height):
        for x in range(width):
            dist = ((x - center_x) ** 2 + (y - center_y) ** 2) ** 0.5
            if dist <= inner_radius:
                # Create grid pattern
                if x % mesh_spacing == 0 or y % mesh_spacing == 0:
                    pixels[y, x] = mesh_color
    
    # Convert back to image
    return Image.fromarray(pixels, 'RGBA')

def save_sprite(sprite, filepath):
    """Save the sprite to the specified filepath"""
    os.makedirs(os.path.dirname(filepath), exist_ok=True)
    sprite.save(filepath)
    print(f"Saved sprite: {filepath}")

def generate_tool_sprites():
    """Generate additional panning tool sprites"""
    # Create various panning tools
    basic_pan = create_pan_sprite()
    save_sprite(basic_pan, "assets/sprites/tools/pans/basic_pan.png")
    
    improved_pan = create_pan_sprite((40, 20))  # Larger pan
    save_sprite(improved_pan, "assets/sprites/tools/pans/improved_pan.png")
    
    sluice_box = create_sluice_box_sprite()
    save_sprite(sluice_box, "assets/sprites/tools/accessories/sluice_box.png")
    
    metal_detector = create_metal_detector_sprite()
    save_sprite(metal_detector, "assets/sprites/tools/accessories/metal_detector.png")
    
    pickaxe = create_pickaxe_sprite()
    save_sprite(pickaxe, "assets/sprites/tools/accessories/pickaxe.png")
    
    sieve = create_sieve_sprite()
    save_sprite(sieve, "assets/sprites/tools/accessories/sieve.png")

if __name__ == "__main__":
    generate_tool_sprites()