import numpy as np
from PIL import Image
import os

def create_ui_button(button_type="basic", size=(64, 32)):
    """
    Create a UI button sprite with wood/granite texture
    """
    width, height = size
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    pixels = np.array(img)
    
    # UI colors from art design guide
    if button_type == "gold":
        base_color = (222, 184, 135, 255)  # Burlywood
        border_color = (139, 69, 19, 255)  # Saddle brown
        accent_color = (255, 215, 0, 255)  # Gold
    elif button_type == "wooden":
        base_color = (210, 180, 140, 255)  # Tan
        border_color = (139, 69, 19, 255)  # Saddle brown
        accent_color = (47, 79, 79, 255)   # Dark slate gray
    else:  # basic
        base_color = (222, 184, 135, 255)  # Burlywood
        border_color = (139, 69, 19, 255)  # Saddle brown
        accent_color = (47, 79, 79, 255)   # Dark slate gray
    
    # Draw base button
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
    
    # Add wood grain texture
    for y in range(2, height-2):
        for x in range(2, width-2):
            if (x + y) % 8 == 0:  # Diagonal lines for wood grain
                pixels[y, x] = (
                    max(0, base_color[0] - 20),
                    max(0, base_color[1] - 20),
                    max(0, base_color[2] - 20),
                    base_color[3]
                )
    
    # Add symbol or text area
    symbol_width = width // 3
    symbol_height = height // 2
    symbol_x = width // 2 - symbol_width // 2
    symbol_y = height // 2 - symbol_height // 2
    
    for y in range(symbol_y, symbol_y + symbol_height):
        for x in range(symbol_x, symbol_x + symbol_width):
            if (x - symbol_x + y - symbol_y) % 4 == 0:  # Pattern for symbol
                pixels[y, x] = accent_color
    
    # Convert back to image
    return Image.fromarray(pixels, 'RGBA')

def create_ui_icon(icon_type="gold", size=(24, 24)):
    """
    Create a UI icon sprite
    """
    width, height = size
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    pixels = np.array(img)
    
    center_x, center_y = width // 2, height // 2
    
    if icon_type == "gold":
        # Gold coin icon
        for y in range(height):
            for x in range(width):
                dist = ((x - center_x) ** 2 + (y - center_y) ** 2) ** 0.5
                if dist <= width // 2 - 1:
                    pixels[y, x] = (255, 215, 0, 255)  # Gold
                elif dist <= width // 2:
                    pixels[y, x] = (139, 69, 19, 255)  # Saddle brown border
    elif icon_type == "pan":
        # Pan tool icon
        for y in range(height):
            for x in range(width):
                # Create pan shape - oval
                dx = (x - center_x) / (width / 2.5)
                dy = (y - center_y) / (height / 2)
                dist = (dx**2 + dy**2)**0.5
                
                if dist <= 0.9:
                    pixels[y, x] = (192, 192, 192, 255)  # Silver
    elif icon_type == "tree":
        # Tree icon
        # Trunk
        trunk_width = width // 6
        trunk_height = height // 2
        trunk_start_x = width // 2 - trunk_width // 2
        trunk_start_y = height // 2
        
        for y in range(trunk_start_y, trunk_start_y + trunk_height):
            for x in range(trunk_start_x, trunk_start_x + trunk_width):
                if 0 <= x < width and 0 <= y < height:
                    pixels[y, x] = (139, 69, 19, 255)  # Saddle brown
        
        # Leaves (circles for simplicity)
        leaf_radius = width // 2 - 2
        for y in range(max(0, trunk_start_y - leaf_radius), min(height, trunk_start_y)):
            for x in range(max(0, center_x - leaf_radius), min(width, center_x + leaf_radius)):
                dist = ((x - center_x) ** 2 + (y - (trunk_start_y - leaf_radius//2)) ** 2) ** 0.5
                if dist <= leaf_radius:
                    pixels[y, x] = (34, 139, 34, 255)  # Forest green
    elif icon_type == "location":
        # Location marker
        # Triangle shape
        for y in range(height):
            for x in range(width):
                # Create an upward triangle
                if y > (height * 2 // 3) - (abs(x - center_x) * (height * 2 // 3)) // (width // 2):
                    pixels[y, x] = (139, 69, 19, 255)  # Saddle brown
    elif icon_type == "weather":
        # Weather icon (sunny)
        for y in range(height):
            for x in range(width):
                dist = ((x - center_x) ** 2 + (y - center_y) ** 2) ** 0.5
                if dist <= width // 4:
                    pixels[y, x] = (255, 255, 0, 255)  # Yellow sun
                # Add rays
                elif (x == center_x or y == center_y or abs(x - center_x) == abs(y - center_y)) and dist > width // 3 and dist < width // 2:
                    if (x + y) % 3 == 0:
                        pixels[y, x] = (255, 255, 0, 255)  # Yellow ray
    elif icon_type == "calendar":
        # Calendar icon
        # Main rectangle
        cal_width = width * 3 // 4
        cal_height = height * 3 // 4
        cal_start_x = width // 2 - cal_width // 2
        cal_start_y = height // 2 - cal_height // 2
        
        for y in range(cal_start_y, cal_start_y + cal_height):
            for x in range(cal_start_x, cal_start_x + cal_width):
                pixels[y, x] = (210, 180, 140, 255)  # Tan
        
        # Border
        for y in [cal_start_y, cal_start_y + cal_height - 1]:
            for x in range(cal_start_x, cal_start_x + cal_width):
                pixels[y, x] = (139, 69, 19, 255)  # Saddle brown
        for x in [cal_start_x, cal_start_x + cal_width - 1]:
            for y in range(cal_start_y, cal_start_y + cal_height):
                pixels[y, x] = (139, 69, 19, 255)  # Saddle brown
        
        # Draw a date number
        if cal_start_y + 3 < cal_start_y + cal_height and cal_start_x + 3 < cal_start_x + cal_width:
            pixels[cal_start_y + 3, cal_start_x + 3] = (47, 79, 79, 255)  # Dark slate gray
    
    # Convert back to image
    return Image.fromarray(pixels, 'RGBA')

def create_ui_panel(panel_type="inventory", size=(128, 128)):
    """
    Create a UI panel background
    """
    width, height = size
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    pixels = np.array(img)
    
    # Panel colors
    if panel_type == "inventory":
        base_color = (210, 180, 140, 255)  # Tan
        border_color = (139, 69, 19, 255)  # Saddle brown
        accent_color = (255, 215, 0, 255)  # Gold
    elif panel_type == "shop":
        base_color = (222, 184, 135, 255)  # Burlywood
        border_color = (139, 69, 19, 255)  # Saddle brown
        accent_color = (47, 79, 79, 255)   # Dark slate gray
    else:  # generic
        base_color = (210, 180, 140, 255)  # Tan
        border_color = (139, 69, 19, 255)  # Saddle brown
        accent_color = (255, 215, 0, 255)  # Gold
    
    # Draw base
    for y in range(height):
        for x in range(width):
            # Add wood grain pattern
            if (x + y) % 10 < 2:
                pixels[y, x] = (
                    max(0, base_color[0] - 30),
                    max(0, base_color[1] - 30),
                    max(0, base_color[2] - 30),
                    base_color[3]
                )
            else:
                pixels[y, x] = base_color
    
    # Draw border
    border_width = 2
    for y in range(height):
        for x in range(width):
            if x < border_width or x >= width - border_width or y < border_width or y >= height - border_width:
                pixels[y, x] = border_color
    
    # Add texture details
    for i in range(0, width, 15):
        for j in range(0, height, 15):
            # Add some knots or texture details
            if np.random.random() > 0.7:
                knot_size = 3
                knot_x = min(width - knot_size - 1, max(knot_size, i + np.random.randint(-5, 5)))
                knot_y = min(height - knot_size - 1, max(knot_size, j + np.random.randint(-5, 5)))
                
                for y in range(knot_y - knot_size, knot_y + knot_size):
                    for x in range(knot_x - knot_size, knot_x + knot_size):
                        if 0 <= x < width and 0 <= y < height:
                            dist = ((x - knot_x) ** 2 + (y - knot_y) ** 2) ** 0.5
                            if dist <= knot_size:
                                pixels[y, x] = (
                                    min(255, base_color[0] + 30),
                                    min(255, base_color[1] + 30),
                                    min(255, base_color[2] + 30),
                                    base_color[3]
                                )
    
    # Convert back to image
    return Image.fromarray(pixels, 'RGBA')

def create_progress_bar_sprite(fill_percent=75, size=(100, 16)):
    """
    Create a progress bar sprite (e.g., for stamina, pan condition)
    """
    width, height = size
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    pixels = np.array(img)
    
    # Colors
    bg_color = (139, 69, 19, 255)      # Saddle brown (background)
    fill_color = (34, 139, 34, 255)    # Forest green (filled portion)
    empty_color = (101, 67, 33, 255)   # Dark brown (unfilled)
    
    # Draw background
    for y in range(height):
        for x in range(width):
            pixels[y, x] = bg_color
    
    # Draw inner border (to show content area)
    for y in range(2, height-2):
        for x in range(2, width-2):
            pixels[y, x] = empty_color
    
    # Draw filled portion
    fill_width = int((fill_percent / 100) * (width - 4))
    for y in range(2, height-2):
        for x in range(2, 2 + fill_width):
            pixels[y, x] = fill_color
    
    # Convert back to image
    return Image.fromarray(pixels, 'RGBA')

def create_season_icon(season="summer", size=(32, 32)):
    """
    Create a seasonal icon
    """
    width, height = size
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    pixels = np.array(img)
    
    center_x, center_y = width // 2, height // 2
    
    # Based on seasonal palettes from art design guide
    if season == "spring":
        # Green sprout
        for y in range(height):
            for x in range(width):
                dist = ((x - center_x) ** 2 + (y - center_y) ** 2) ** 0.5
                if dist <= width // 4:
                    pixels[y, x] = (144, 238, 144, 255)  # Light green
                # Add stem
                elif abs(x - center_x) < 2 and y > center_y:
                    pixels[y, x] = (34, 139, 34, 255)  # Forest green
    elif season == "summer":
        # Sun
        for y in range(height):
            for x in range(width):
                dist = ((x - center_x) ** 2 + (y - center_y) ** 2) ** 0.5
                if dist <= width // 4:
                    pixels[y, x] = (255, 255, 0, 255)  # Yellow
                # Add rays
                elif (abs(x - center_x) <= 1 or abs(y - center_y) <= 1) and dist > width // 3 and dist < width // 2:
                    if (x + y) % 3 == 0:
                        pixels[y, x] = (255, 255, 0, 255)  # Yellow ray
    elif season == "autumn":
        # Maple leaf
        # More complex shape for maple leaf
        for y in range(height):
            for x in range(width):
                # Create a rough maple leaf shape
                rel_x = abs(x - center_x) / (width / 4)
                rel_y = abs(y - center_y) / (height / 4)
                
                # Multi-pointed leaf pattern
                if rel_x < 1.0 and rel_y < 1.2:
                    # Add some points to make it look more like a maple leaf
                    if (x + y) % 4 == 0 or (x % 3 == 0 and y % 3 == 0):
                        pixels[y, x] = (220, 20, 60, 255)  # Crimson
                    else:
                        pixels[y, x] = (255, 165, 0, 255)  # Orange
    else:  # winter
        # Snowflake
        for y in range(height):
            for x in range(width):
                # Simple snowflake pattern
                if (abs(x - center_x) <= 1 and abs(y - center_y) <= height // 3) or \
                   (abs(y - center_y) <= 1 and abs(x - center_x) <= width // 3) or \
                   (abs(x - center_x) == abs(y - center_y) and abs(x - center_x) <= width // 4):
                    pixels[y, x] = (255, 255, 255, 255)  # White
                # Add some details
                elif abs(x - center_x) <= 2 and abs(y - center_y) <= 2:
                    pixels[y, x] = (240, 248, 255, 255)  # Alice blue
    
    # Convert back to image
    return Image.fromarray(pixels, 'RGBA')

def save_sprite(sprite, filepath):
    """Save the sprite to the specified filepath"""
    os.makedirs(os.path.dirname(filepath), exist_ok=True)
    sprite.save(filepath)
    print(f"Saved sprite: {filepath}")

def generate_ui_sprites():
    """Generate UI element sprites"""
    # Create different types of buttons
    basic_button = create_ui_button("basic")
    save_sprite(basic_button, "assets/sprites/ui/buttons/basic_button.png")
    
    gold_button = create_ui_button("gold")
    save_sprite(gold_button, "assets/sprites/ui/buttons/gold_button.png")
    
    wooden_button = create_ui_button("wooden")
    save_sprite(wooden_button, "assets/sprites/ui/buttons/wooden_button.png")
    
    # Create various icons
    gold_icon = create_ui_icon("gold")
    save_sprite(gold_icon, "assets/sprites/ui/icons/gold_icon.png")
    
    pan_icon = create_ui_icon("pan")
    save_sprite(pan_icon, "assets/sprites/ui/icons/pan_icon.png")
    
    tree_icon = create_ui_icon("tree")
    save_sprite(tree_icon, "assets/sprites/ui/icons/tree_icon.png")
    
    location_icon = create_ui_icon("location")
    save_sprite(location_icon, "assets/sprites/ui/icons/location_icon.png")
    
    weather_icon = create_ui_icon("weather")
    save_sprite(weather_icon, "assets/sprites/ui/icons/weather_icon.png")
    
    calendar_icon = create_ui_icon("calendar")
    save_sprite(calendar_icon, "assets/sprites/ui/icons/calendar_icon.png")
    
    # Create UI panels
    inventory_panel = create_ui_panel("inventory")
    save_sprite(inventory_panel, "assets/sprites/ui/backgrounds/inventory_panel.png")
    
    shop_panel = create_ui_panel("shop")
    save_sprite(shop_panel, "assets/sprites/ui/backgrounds/shop_panel.png")
    
    generic_panel = create_ui_panel("generic")
    save_sprite(generic_panel, "assets/sprites/ui/backgrounds/generic_panel.png")
    
    # Create progress bars
    stamina_bar = create_progress_bar_sprite(75)
    save_sprite(stamina_bar, "assets/sprites/ui/icons/stamina_bar.png")
    
    pan_condition = create_progress_bar_sprite(90)
    save_sprite(pan_condition, "assets/sprites/ui/icons/pan_condition.png")
    
    # Create seasonal icons
    for season in ["spring", "summer", "autumn", "winter"]:
        season_icon = create_season_icon(season)
        save_sprite(season_icon, f"assets/sprites/ui/icons/{season}_icon.png")

if __name__ == "__main__":
    generate_ui_sprites()