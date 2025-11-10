import numpy as np
from PIL import Image
import os
import glob

def create_sprite_sheet():
    """
    Create a sprite sheet combining various sprites for the game
    """
    # Define all the sprite directories to include in the sheet
    sprite_dirs = [
        "assets/sprites/environment/trees/",
        "assets/sprites/environment/rocks/",
        "assets/sprites/items/gold/",
        "assets/sprites/tools/pans/",
        "assets/sprites/environment/wildlife/",
        "assets/sprites/ui/icons/"
    ]
    
    # Collect all sprite files
    all_sprites = []
    
    for sprite_dir in sprite_dirs:
        if os.path.exists(sprite_dir):
            sprite_files = glob.glob(os.path.join(sprite_dir, "*.png"))
            for sprite_file in sprite_files:
                sprite_name = os.path.basename(sprite_file)
                # Only include representative sprites to avoid an overly large sprite sheet
                if any(keyword in sprite_name for keyword in 
                      ["summer", "basic", "gold", "flake", "bird", "icon", "spring", "winter"]):
                    all_sprites.append((sprite_file, sprite_dir.split('/')[-2]))
    
    print(f"Found {len(all_sprites)} sprites to include in sprite sheet")
    
    # Create sprite sheet - we'll arrange sprites in a grid
    # For this example, I'll just use a few representative sprites
    representative_sprites = []
    
    # Add one of each type of important sprite
    sprite_types = {
        "tree": None,
        "rock": None,
        "gold": None,
        "pan": None,
        "wildlife": None,
        "ui_icon": None
    }
    
    for sprite_path, sprite_category in all_sprites:
        if sprite_category == "trees" and sprite_types["tree"] is None:
            sprite_types["tree"] = sprite_path
        elif sprite_category == "rocks" and sprite_types["rock"] is None:
            sprite_types["rock"] = sprite_path
        elif sprite_category == "gold" and sprite_types["gold"] is None:
            sprite_types["gold"] = sprite_path
        elif sprite_category == "pans" and sprite_types["pan"] is None:
            sprite_types["pan"] = sprite_path
        elif sprite_category == "wildlife" and sprite_types["wildlife"] is None:
            sprite_types["wildlife"] = sprite_path
        elif sprite_category == "icons" and sprite_types["ui_icon"] is None:
            sprite_types["ui_icon"] = sprite_path
    
    # Load and measure the sprites we'll use
    loaded_sprites = {}
    max_width = 0
    max_height = 0
    
    for sprite_type, sprite_path in sprite_types.items():
        if sprite_path and os.path.exists(sprite_path):
            img = Image.open(sprite_path).convert("RGBA")
            loaded_sprites[sprite_type] = img
            max_width = max(max_width, img.width)
            max_height = max(max_height, img.height)
    
    print(f"Max sprite dimensions: {max_width}x{max_height}")
    
    # Create the sprite sheet (3x2 grid for 6 sprites)
    sheet_cols = 3
    sheet_rows = 2
    padding = 2  # pixels between sprites
    
    sheet_width = sheet_cols * (max_width + padding) + padding
    sheet_height = sheet_rows * (max_height + padding) + padding
    
    sprite_sheet = Image.new('RGBA', (sheet_width, sheet_height), (0, 0, 0, 0))
    
    # Place sprites in the sheet
    sprite_list = list(loaded_sprites.keys())
    for i, sprite_type in enumerate(sprite_list):
        if i >= sheet_cols * sheet_rows:  # Don't exceed our grid
            break
            
        sprite_img = loaded_sprites[sprite_type]
        
        # Calculate position
        col = i % sheet_cols
        row = i // sheet_cols
        
        x = col * (max_width + padding) + padding
        y = row * (max_height + padding) + padding
        
        # Paste the sprite
        sprite_sheet.paste(sprite_img, (x, y))
        
        print(f"Added {sprite_type} sprite at position ({x}, {y})")
    
    # Save the sprite sheet
    os.makedirs("assets/sprites/sheets", exist_ok=True)
    sprite_sheet.save("assets/sprites/sheets/game_spritesheet.png")
    print("Created sprite sheet: assets/sprites/sheets/game_spritesheet.png")
    
    # Also create a simple seasonal sprite sheet
    create_seasonal_sprite_sheet()

def create_seasonal_sprite_sheet():
    """
    Create a sprite sheet with seasonal variations of the same elements
    """
    # Create a sprite sheet showing seasonal changes for trees
    seasons = ["spring", "summer", "autumn", "winter"]
    elements = ["tree", "water"]  # For this example, just trees
    
    max_width, max_height = 0, 0
    all_seasonal_sprites = {}
    
    # Load seasonal tree sprites
    for season in seasons:
        tree_path = f"assets/sprites/environment/trees/maple_{season}.png"
        if os.path.exists(tree_path):
            img = Image.open(tree_path).convert("RGBA")
            all_seasonal_sprites[f"maple_{season}"] = img
            max_width = max(max_width, img.width)
            max_height = max(max_height, img.height)
    
    # Create seasonal sprite sheet (4 seasons in a row)
    padding = 2
    sheet_width = len(seasons) * (max_width + padding) + padding
    sheet_height = max_height + 2 * padding
    
    seasonal_sheet = Image.new('RGBA', (sheet_width, sheet_height), (0, 0, 0, 0))
    
    for i, season in enumerate(seasons):
        sprite_key = f"maple_{season}"
        if sprite_key in all_seasonal_sprites:
            sprite_img = all_seasonal_sprites[sprite_key]
            
            x = i * (max_width + padding) + padding
            y = padding
            
            seasonal_sheet.paste(sprite_img, (x, y))
    
    seasonal_sheet.save("assets/sprites/sheets/seasonal_spritesheet.png")
    print("Created seasonal sprite sheet: assets/sprites/sheets/seasonal_spritesheet.png")

if __name__ == "__main__":
    create_sprite_sheet()