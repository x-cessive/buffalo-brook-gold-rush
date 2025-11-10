import numpy as np
from PIL import Image
import os

def create_water_frame(frame_num, season="summer", size=(16, 16)):
    """
    Create a single frame of animated water with seasonal colors
    """
    width, height = size
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    pixels = np.array(img)
    
    # Define seasonal water colors
    if season == "spring":
        base_colors = [(135, 206, 235, 255), (126, 200, 227, 255), (99, 180, 209, 255)]  # Sky blue variations
    elif season == "summer":
        base_colors = [(47, 133, 214, 255), (74, 144, 226, 255), (93, 173, 236, 255)]  # Summer blues
    elif season == "autumn":
        base_colors = [(95, 143, 157, 255), (107, 159, 176, 255), (122, 158, 173, 255)]  # Muted blues
    else:  # winter
        base_colors = [(135, 206, 235, 255), (176, 230, 248, 255), (182, 215, 232, 255)]  # Pale blues
    
    # Create animated water pattern
    for y in range(height):
        for x in range(width):
            # Create wave-like patterns that move over time
            wave1 = int(5 * np.sin((x + frame_num) * 0.5))
            wave2 = int(3 * np.cos((y + frame_num) * 0.3))
            wave3 = int(2 * np.sin((x + y + frame_num) * 0.4))
            
            # Combine wave patterns for organic movement
            color_idx = (x + y + frame_num + wave1 + wave2 + wave3) % len(base_colors)
            pixels[y, x] = base_colors[color_idx]
            
            # Add occasional shimmer effects
            if (x + y + frame_num) % 10 == 0:
                shimmer_value = 30 + int(20 * np.sin(frame_num * 0.5))
                pixels[y, x] = (
                    min(255, base_colors[color_idx][0] + shimmer_value),
                    min(255, base_colors[color_idx][1] + shimmer_value),
                    min(255, base_colors[color_idx][2] + shimmer_value),
                    base_colors[color_idx][3]
                )
    
    # Convert back to image
    return Image.fromarray(pixels, 'RGBA')

def create_water_ripple(center_x, center_y, frame_num, size=(16, 16)):
    """
    Create a water ripple effect centered at a specific point
    """
    width, height = size
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    pixels = np.array(img)
    
    # Water colors for ripple
    water_colors = [
        (47, 133, 214, 255),   # Summer stream blue
        (74, 144, 226, 255),   # Bright blue
        (93, 173, 236, 255),   # Light blue
        (255, 255, 255, 100),  # Translucent white for highlight
    ]
    
    for y in range(height):
        for x in range(width):
            dist = np.sqrt((x - center_x)**2 + (y - center_y)**2)
            ripple_radius = 2 + (frame_num % 6)  # Animate ripple expanding
            
            # Create ripple effect
            if abs(dist - ripple_radius) < 1.5:  # Within ripple ring
                pixels[y, x] = water_colors[3]  # Highlight color
            elif dist < ripple_radius:
                # Within the ripple, make it more transparent
                base_color = water_colors[frame_num % 3]
                alpha_factor = 0.7 if dist > ripple_radius - 2 else 1.0
                pixels[y, x] = (
                    base_color[0],
                    base_color[1],
                    base_color[2],
                    int(base_color[3] * alpha_factor)
                )
            else:
                pixels[y, x] = (47, 133, 214, 255)  # Base water color
    
    # Convert back to image
    return Image.fromarray(pixels, 'RGBA')

def create_stream_tile(season="summer", size=(32, 32)):
    """
    Create a tileable stream sprite
    """
    width, height = size
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    pixels = np.array(img)
    
    # Define seasonal water colors
    if season == "spring":
        base_colors = [(135, 206, 235, 255), (126, 200, 227, 255), (99, 180, 209, 255)]
    elif season == "summer":
        base_colors = [(47, 133, 214, 255), (74, 144, 226, 255), (93, 173, 236, 255)]
    elif season == "autumn":
        base_colors = [(95, 143, 157, 255), (107, 159, 176, 255), (122, 158, 173, 255)]
    else:  # winter
        base_colors = [(135, 206, 235, 255), (176, 230, 248, 255), (182, 215, 232, 255)]
    
    # Create flowing water pattern
    for y in range(height):
        for x in range(width):
            # Create flow effect moving from top to bottom
            flow_offset = int(3 * np.sin((x + y * 0.5) * 0.2))
            
            # Use base color with flow pattern
            color_idx = (x + y + flow_offset) % len(base_colors)
            pixels[y, x] = base_colors[color_idx]
            
            # Add some variation for natural water look
            if (x + y) % 7 == 0:
                pixels[y, x] = (
                    min(255, base_colors[color_idx][0] + 20),
                    min(255, base_colors[color_idx][1] + 20),
                    min(255, base_colors[color_idx][2] + 30),
                    base_colors[color_idx][3]
                )
    
    # Convert back to image
    return Image.fromarray(pixels, 'RGBA')

def create_ice_sprite(season="winter", size=(32, 32)):
    """
    Create an ice sprite for winter season
    """
    width, height = size
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    pixels = np.array(img)
    
    # Ice colors
    ice_colors = [
        (240, 248, 255, 200),  # Ghost white with transparency
        (224, 246, 255, 180),  # Light blue with transparency
        (198, 225, 255, 160),  # Pale blue with transparency
        (255, 255, 255, 100),  # White with transparency
    ]
    
    # Create ice pattern
    for y in range(height):
        for x in range(width):
            # Crackle pattern for ice
            if (x * y + x + y) % 5 == 0:
                pixels[y, x] = ice_colors[3]  # More opaque white for ice cracks
            else:
                color_idx = (x + y) % (len(ice_colors) - 1)
                pixels[y, x] = ice_colors[color_idx]
                
            # Add some random variation
            import random
            if random.random() > 0.8:
                pixels[y, x] = (
                    max(0, ice_colors[0][0] - 20),
                    max(0, ice_colors[0][1] - 20),
                    max(0, ice_colors[0][2] - 20),
                    min(255, ice_colors[0][3] + 50)
                )
    
    # Convert back to image
    return Image.fromarray(pixels, 'RGBA')

def save_sprite(sprite, filepath):
    """Save the sprite to the specified filepath"""
    os.makedirs(os.path.dirname(filepath), exist_ok=True)
    sprite.save(filepath)
    print(f"Saved sprite: {filepath}")

def generate_water_sprites():
    """Generate water animation sprites"""
    seasons = ["spring", "summer", "autumn", "winter"]
    
    # Create animated water frames for each season
    for season in seasons:
        for frame in range(4):  # 4 frames for animation
            water_frame = create_water_frame(frame, season)
            save_sprite(water_frame, f"assets/sprites/environment/streams/{season}_water_frame_{frame}.png")
        
        # Create stream tile for each season
        stream_tile = create_stream_tile(season)
        save_sprite(stream_tile, f"assets/sprites/environment/streams/{season}_stream_tile.png")
    
    # Create ripple effects
    for frame in range(6):  # 6 frames for ripple animation
        ripple = create_water_ripple(8, 8, frame)
        save_sprite(ripple, f"assets/sprites/environment/streams/water_ripple_frame_{frame}.png")
    
    # Create winter ice
    ice = create_ice_sprite()
    save_sprite(ice, "assets/sprites/environment/streams/winter_ice.png")

if __name__ == "__main__":
    generate_water_sprites()