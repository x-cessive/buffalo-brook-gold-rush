import numpy as np
from PIL import Image
import os

def create_bird_sprite(bird_type="sparrow", size=(12, 10)):
    """
    Create a pixel art bird sprite
    """
    width, height = size
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    pixels = np.array(img)
    
    # Bird colors based on Vermont birds mentioned in art guide
    if bird_type == "hermit_thrush":
        body_color = (188, 156, 106, 255)  # Warm brown
        head_color = (139, 115, 85, 255)   # Darker brown
        wing_color = (101, 81, 61, 255)    # Dark brown
        eye_color = (0, 0, 0, 255)         # Black
    elif bird_type == "wood_thrush":
        body_color = (190, 170, 120, 255)  # Buff brown
        head_color = (140, 110, 70, 255)   # Rich brown
        wing_color = (100, 80, 50, 255)    # Dark brown
        eye_color = (0, 0, 0, 255)         # Black
    elif bird_type == "song_sparrow":
        body_color = (160, 140, 100, 255)  # Streaky brown
        head_color = (120, 100, 70, 255)   # Darker brown
        wing_color = (80, 60, 40, 255)     # Very dark brown
        eye_color = (0, 0, 0, 255)         # Black
    else:  # generic bird
        body_color = (170, 170, 170, 255)  # Gray
        head_color = (140, 140, 140, 255)  # Darker gray
        wing_color = (100, 100, 100, 255)  # Dark gray
        eye_color = (0, 0, 0, 255)         # Black
    
    center_x, center_y = width // 2, height // 2
    
    # Draw body (simple oval)
    for y in range(height):
        for x in range(width):
            dx = (x - center_x) / (width / 2.5)
            dy = (y - center_y) / (height / 2)
            dist = (dx**2 + dy**2)**0.5
            
            if dist <= 0.8:
                pixels[y, x] = body_color
    
    # Draw head (slightly larger circle at top)
    head_radius = height // 3
    head_center_y = height // 4
    for y in range(max(0, head_center_y - head_radius), min(height, head_center_y + head_radius)):
        for x in range(max(0, center_x - head_radius), min(width, center_x + head_radius)):
            dy = y - head_center_y
            dx = x - center_x
            dist = (dx**2 + dy**2)**0.5
            if dist <= head_radius:
                pixels[y, x] = head_color
    
    # Draw wing
    wing_start_x = center_x - width // 4
    wing_start_y = center_y
    wing_width = width // 3
    wing_height = height // 2
    for y in range(wing_start_y, min(height, wing_start_y + wing_height)):
        for x in range(wing_start_x, min(width, wing_start_x + wing_width)):
            pixels[y, x] = wing_color
    
    # Draw eye
    eye_x, eye_y = center_x + width // 4, head_center_y
    if 0 <= eye_x < width and 0 <= eye_y < height:
        pixels[eye_y, eye_x] = eye_color
    
    # Convert back to image
    return Image.fromarray(pixels, 'RGBA')

def create_deer_sprite(size=(20, 24)):
    """
    Create a pixel art deer sprite (showing tracks or a small deer)
    """
    width, height = size
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    pixels = np.array(img)
    
    # Deer colors
    body_color = (180, 140, 100, 255)  # Tan brown
    head_color = (150, 110, 70, 255)   # Darker brown
    spot_color = (120, 80, 40, 255)    # Dark brown spots
    eye_color = (0, 0, 0, 255)         # Black
    
    center_x, center_y = width // 2, height // 2
    
    # Draw body (larger oval)
    for y in range(height):
        for x in range(width):
            dx = (x - center_x) / (width / 2.2)
            dy = (y - center_y) / (height / 2.5)
            dist = (dx**2 + dy**2)**0.5
            
            if dist <= 0.9:
                pixels[y, x] = body_color
                
                # Add some spots for natural look
                if (x + y) % 7 == 0 and y > center_y:
                    pixels[y, x] = spot_color
    
    # Draw head (circle at top)
    head_radius = width // 4
    head_center_y = height // 5
    for y in range(max(0, head_center_y - head_radius), min(height, head_center_y + head_radius)):
        for x in range(max(0, center_x - head_radius), min(width, center_x + head_radius)):
            dy = y - head_center_y
            dx = x - center_x
            dist = (dx**2 + dy**2)**0.5
            if dist <= head_radius:
                pixels[y, x] = head_color
    
    # Draw ears
    for ear_x in [center_x - width // 5, center_x + width // 5]:
        for y in range(head_center_y - head_radius // 2, head_center_y):
            if 0 <= ear_x < width and 0 <= y < height:
                pixels[y, ear_x] = head_color
    
    # Draw eye
    eye_x, eye_y = center_x + width // 6, head_center_y
    if 0 <= eye_x < width and 0 <= eye_y < height:
        pixels[eye_y, eye_x] = eye_color
    
    # Convert back to image
    return Image.fromarray(pixels, 'RGBA')

def create_frog_sprite(size=(10, 8)):
    """
    Create a pixel art frog sprite
    """
    width, height = size
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    pixels = np.array(img)
    
    # Frog colors
    body_color = (80, 150, 80, 255)    # Green
    belly_color = (200, 230, 200, 255) # Light green
    eye_color = (0, 0, 0, 255)         # Black
    iris_color = (255, 255, 0, 255)    # Yellow eye
    
    center_x, center_y = width // 2, height // 2
    
    # Draw body (oval shape)
    for y in range(height):
        for x in range(width):
            dx = (x - center_x) / (width / 2.5)
            dy = (y - center_y) / (height / 2)
            dist = (dx**2 + dy**2)**0.5
            
            if dist <= 0.9:
                # Belly area (bottom part)
                if y > center_y:
                    pixels[y, x] = belly_color
                else:
                    pixels[y, x] = body_color
    
    # Draw eyes (on top)
    for eye_offset in [-width // 4, width // 4]:
        eye_x = center_x + eye_offset
        eye_y = 1
        if 0 <= eye_x < width and 0 <= eye_y < height:
            pixels[eye_y, eye_x] = iris_color
            # Add pupil
            if 0 <= eye_x + 1 < width and 0 <= eye_y < height:
                pixels[eye_y, eye_x + 1] = eye_color
    
    # Convert back to image
    return Image.fromarray(pixels, 'RGBA')

def create_butterfly_sprite(size=(12, 10)):
    """
    Create a pixel art butterfly sprite
    """
    width, height = size
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    pixels = np.array(img)
    
    # Butterfly colors
    wing_color1 = (255, 223, 0, 255)    # Gold
    wing_color2 = (138, 43, 226, 255)   # Blue violet
    body_color = (0, 0, 0, 255)         # Black
    accent_color = (255, 255, 255, 255) # White (spots)
    
    center_x, center_y = width // 2, height // 2
    
    # Draw body (vertical line)
    body_width = 1
    for y in range(height):
        for x in range(center_x - body_width // 2, center_x + body_width // 2 + 1):
            if 0 <= x < width and 0 <= y < height:
                pixels[y, x] = body_color
    
    # Draw wings - top wings
    for y in range(height // 3):
        for x in range(width):
            # Create wing shape (wider at center, narrower at edges)
            wing_width_at_y = width // 2 - (y * width // 6) // (height // 3)
            if abs(x - center_x) <= wing_width_at_y:
                pixels[y, x] = wing_color1 if x < center_x else wing_color2
                
                # Add pattern spots
                if (x + y) % 4 == 0:
                    pixels[y, x] = accent_color
    
    # Draw wings - bottom wings
    for y in range(height // 3, 2 * height // 3):
        for x in range(width):
            # Create wing shape (narrower than top wings)
            wing_width_at_y = width // 3 - ((y - height // 3) * width // 9) // (height // 3)
            if abs(x - center_x) <= wing_width_at_y:
                pixels[y, x] = wing_color2 if x < center_x else wing_color1
                
                # Add pattern spots
                if (x + y) % 4 == 1:
                    pixels[y, x] = accent_color
    
    # Convert back to image
    return Image.fromarray(pixels, 'RGBA')

def create_duck_sprite(size=(16, 12)):
    """
    Create a pixel art duck sprite
    """
    width, height = size
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    pixels = np.array(img)
    
    # Duck colors (male mallard-like)
    head_color = (0, 0, 139, 255)      # Dark blue
    body_color = (139, 69, 19, 255)    # Saddle brown
    wing_color = (0, 100, 0, 255)      # Dark green
    bill_color = (255, 165, 0, 255)    # Orange
    eye_color = (255, 255, 255, 255)   # White
    pupil_color = (0, 0, 0, 255)       # Black
    
    center_x, center_y = width // 2, height // 2
    
    # Draw body (oval)
    for y in range(height):
        for x in range(width):
            dx = (x - center_x) / (width / 2.3)
            dy = (y - center_y) / (height / 2)
            dist = (dx**2 + dy**2)**0.5
            
            if dist <= 0.85:
                # Back part (wings) is different color
                if x < center_x and y < center_y:
                    pixels[y, x] = wing_color
                else:
                    pixels[y, x] = body_color
    
    # Draw head (circle at left)
    head_radius = width // 4
    head_center_x = width // 4
    head_center_y = height // 3
    for y in range(max(0, head_center_y - head_radius), min(height, head_center_y + head_radius)):
        for x in range(max(0, head_center_x - head_radius), min(width, head_center_x + head_radius)):
            dy = y - head_center_y
            dx = x - head_center_x
            dist = (dx**2 + dy**2)**0.5
            if dist <= head_radius:
                pixels[y, x] = head_color
    
    # Draw bill
    bill_width = width // 6
    bill_height = height // 5
    bill_start_x = head_center_x + head_radius - 1
    bill_start_y = head_center_y
    for y in range(bill_start_y, min(height, bill_start_y + bill_height)):
        for x in range(bill_start_x, min(width, bill_start_x + bill_width)):
            pixels[y, x] = bill_color
    
    # Draw eye
    eye_x, eye_y = head_center_x + head_radius // 2, head_center_y - head_radius // 3
    if 0 <= eye_x < width and 0 <= eye_y < height:
        pixels[eye_y, eye_x] = eye_color
        # Add pupil
        if 0 <= eye_x + 1 < width and 0 <= eye_y < height:
            pixels[eye_y, eye_x + 1] = pupil_color
    
    # Convert back to image
    return Image.fromarray(pixels, 'RGBA')

def create_trail_track_sprite(animal_type="deer", size=(16, 8)):
    """
    Create a track/trail sprite (animal footprints in mud)
    """
    width, height = size
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    pixels = np.array(img)
    
    # Track colors (muddy brown)
    track_color = (101, 67, 33, 180)  # Dark brown with transparency (muddy)
    background_color = (139, 69, 19, 100)  # Slightly lighter brown
    
    # Fill with background color
    for y in range(height):
        for x in range(width):
            pixels[y, x] = background_color
    
    if animal_type == "deer":
        # Draw deer track (heart-shaped)
        center_x, center_y = width // 2, height // 2
        track_width = width // 3
        track_height = height // 2
        
        for y in range(max(0, center_y - track_height // 2), min(height, center_y + track_height // 2)):
            for x in range(max(0, center_x - track_width // 2), min(width, center_x + track_width // 2)):
                # Create a heart/shoe-shaped deer track
                rel_x = abs(x - center_x) / (track_width / 2)
                rel_y = (y - center_y + track_height // 2) / track_height
                
                # Deer track shape
                if rel_y <= 1.0 and rel_x <= 0.7:
                    if rel_y < 0.3 or (rel_x < 0.5 and rel_y < 0.7) or (rel_x < 0.3 and rel_y < 1.0):
                        pixels[y, x] = track_color
    else:  # generic track
        # Draw simple oval track
        center_x, center_y = width // 2, height // 2
        for y in range(height):
            for x in range(width):
                dx = (x - center_x) / (width / 4)
                dy = (y - center_y) / (height / 3)
                dist = (dx**2 + dy**2)**0.5
                
                if dist <= 1.0:
                    pixels[y, x] = track_color
    
    # Convert back to image
    return Image.fromarray(pixels, 'RGBA')

def save_sprite(sprite, filepath):
    """Save the sprite to the specified filepath"""
    os.makedirs(os.path.dirname(filepath), exist_ok=True)
    sprite.save(filepath)
    print(f"Saved sprite: {filepath}")

def generate_wildlife_sprites():
    """Generate various wildlife sprites"""
    # Birds
    sparrow = create_bird_sprite("sparrow")
    save_sprite(sparrow, "assets/sprites/environment/wildlife/sparrow.png")
    
    hermit_thrush = create_bird_sprite("hermit_thrush")
    save_sprite(hermit_thrush, "assets/sprites/environment/wildlife/hermit_thrush.png")
    
    wood_thrush = create_bird_sprite("wood_thrush")
    save_sprite(wood_thrush, "assets/sprites/environment/wildlife/wood_thrush.png")
    
    song_sparrow = create_bird_sprite("song_sparrow")
    save_sprite(song_sparrow, "assets/sprites/environment/wildlife/song_sparrow.png")
    
    # Other animals
    deer = create_deer_sprite()
    save_sprite(deer, "assets/sprites/environment/wildlife/deer.png")
    
    frog = create_frog_sprite()
    save_sprite(frog, "assets/sprites/environment/wildlife/frog.png")
    
    butterfly = create_butterfly_sprite()
    save_sprite(butterfly, "assets/sprites/environment/wildlife/butterfly.png")
    
    duck = create_duck_sprite()
    save_sprite(duck, "assets/sprites/environment/wildlife/duck.png")
    
    # Animal tracks (muddy banks)
    deer_track = create_trail_track_sprite("deer")
    save_sprite(deer_track, "assets/sprites/environment/wildlife/deer_track.png")
    
    generic_track = create_trail_track_sprite("generic")
    save_sprite(generic_track, "assets/sprites/environment/wildlife/animal_track.png")

if __name__ == "__main__":
    generate_wildlife_sprites()