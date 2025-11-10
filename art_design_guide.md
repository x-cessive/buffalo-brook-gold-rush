# Buffalo Brook Gold Rush - Art Design Guide

## Table of Contents
1. [Pixel-Art Style References](#pixel-art-style-references)
2. [Seasonal Color Palettes](#seasonal-color-palettes)
3. [Water Shimmer Effects](#water-shimmer-effects)
4. [UI Themes](#ui-themes)
5. [Environmental Sounds](#environmental-sounds)

## Pixel-Art Style References

### Influential Games with Similar Aesthetics
1. **Stardew Valley** - Features a charming, detailed pixel art style with beautiful natural environments
   - Soft, pastel colors that create a peaceful atmosphere
   - Detailed water animation with gentle movement
   - Seasonal environment changes that feel authentic

2. **A Short Hike** - Woodland environment with crisp, clean pixel art
   - Clear, distinct sprites that work at small scales
   - Excellent use of light and shadow for depth
   - Nature-focused art that feels immersive

3. **Oxygen Not Included** - Detailed environmental simulation with pleasant colors
   - Great water and liquid animations
   - Layered backgrounds that create depth
   - Consistent art style across all elements

4. **Forager** - Adventure and exploration game with charming pixel art
   - Bright, saturated colors that still feel natural
   - Simple but detailed sprites
   - Good use of animation for environmental elements

### Art Style Characteristics for Vermont Setting
- **Sprite Resolution**: 16x16 or 32x32 base resolution for characters and objects; larger for environmental features
- **Lighting Style**: Soft directional lighting with gentle shadows to create a peaceful, natural atmosphere
- **Detail Level**: Medium detail - enough to be recognizable but not overly complex to maintain the relaxing feel
- **Animation Frame Rate**: 8-12 FPS for natural movement like water, leaves, and wildlife
- **Outline Style**: Minimal outlines to keep a natural, organic feel rather than cartoony

### Specific Environmental Elements
- **Trees**: Maple and birch trees with seasonally-appropriate colors and shapes
- **Rocks**: Detailed granite and schist formations with appropriate textures
- **Water**: Crystal clear with visible sediment and gentle animated flow
- **Ground Cover**: Moss, ferns, and wildflowers at the stream edges
- **Wildlife**: Sparingly used, small animals like chipmunks, birds, or fish visible in water

## Seasonal Color Palettes

### Spring Palette
- **Water**: #87CEEB (Sky Blue), #7EC8E3 (Light Sky Blue), #63B4D1 (Powder Blue)
- **Sky**: #B0E0E6 (Powder Blue), #C2E9FB (Light Blue), #E0F6FF (Alice Blue)
- **Rocks**: #8C8C8C (Gray), #A9A9A9 (Dark Gray), #B8B8B8 (Medium Gray)
- **New Growth**: #90EE90 (Light Green), #7CFC00 (Lawn Green), #ADFF2F (Green Yellow)
- **Soil/Sediment**: #A0522D (Sienna), #8B4513 (Saddle Brown), #CD853F (Peru)
- **Details**: #FFD700 (Gold), #F5DEB3 (Wheat), #F0E68C (Khaki)

### Summer Palette
- **Water**: #2F85D6 (Summer Stream Blue), #4A90E2 (Bright Blue), #5DADEC (Light Blue)
- **Sky**: #87CEEB (Sky Blue), #B0E2FF (Light Sky Blue), #CAE1FF (Light Blue)
- **Foliage**: #228B22 (Forest Green), #32CD32 (Lime Green), #2E8B57 (Sea Green)
- **Rocks**: #708090 (Slate Gray), #808080 (Gray), #A9A9A9 (Dark Gray)
- **Sunlight**: #FFFACD (Lemon Chiffon), #FFF8DC (Cornsilk), #F5FFFA (Mint Cream)
- **Accents**: #FFD700 (Gold), #FF8C00 (Dark Orange), #FFA500 (Orange)

### Autumn Palette
- **Water**: #5F8F9D (Autumn Stream), #6B9FB0 (Muted Blue), #7A9EAD (Dusty Blue)
- **Sky**: #B0E0E6 (Powder Blue), #C2E9FB (Light Blue), #D6EAF8 (Light Blue)
- **Maple Leaves**: #DC143C (Crimson), #B22222 (Fire Brick), #8B0000 (Dark Red)
- **Birch/Yellow Leaves**: #FFD700 (Gold), #FFA500 (Orange), #FF8C00 (Dark Orange)
- **Ground Cover**: #CD853F (Peru), #D2691E (Chocolate), #8B4513 (Saddle Brown)
- **Atmosphere**: #F4A460 (Sandy Brown), #DEB887 (Burlywood), #D2B48C (Tan)

### Winter Palette
- **Water**: #87CEEB (Sky Blue), #B0E0E6 (Powder Blue), #B6D7E8 (Pale Blue)
- **Snow**: #FFFFFF (White), #F8F8FF (Ghost White), #F0F8FF (Alice Blue)
- **Ice**: #E0F6FF (Light Blue), #D1E8FF (Pale Blue), #C2E1FF (Very Light Blue)
- **Bare Trees**: #696969 (Dim Gray), #808080 (Gray), #A9A9A9 (Dark Gray)
- **Rocks**: #708090 (Slate Gray), #778899 (Light Slate Gray), #A9A9A9 (Dark Gray)
- **Accents**: #2F4F4F (Dark Slate Gray), #696969 (Dim Gray), #000080 (Navy)

### Year-Round Elements Palette
- **Gold (in pan)**: #FFD700 (Gold), #FFA500 (Orange), #FFE442 (Yellow-Gold)
- **Pan Tool**: #C0C0C0 (Silver), #A9A9A9 (Dark Gray), #808080 (Gray)
- **UI Elements**: #DEB887 (Burlywood), #8B4513 (Saddle Brown), #D2B48C (Tan)
- **Text Colors**: #2F4F4F (Dark Slate Gray), #000000 (Black), #FFFFFF (White)

## Water Shimmer Effects for Pixel Art

### Animation Techniques
1. **Subtle Wave Animation**
   - Single-pixel shifts in water surface patterns
   - 4-frame animation cycle for gentle ripples
   - Use 2-3 colors from your seasonal palette that are 10-15% brighter than base water color
   - Example: For summer #2F85D6, animate with #4A90E2 and #5DADEC

2. **Sunlight Reflection Effects**
   - Small 2x2 or 3x3 pixel bright spots that move slowly across water surface
   - Use your accent gold colors (#FFD700, #FFA500) at 30-50% opacity
   - Move reflections at different speeds for depth effect
   - Add occasional larger reflection patches that appear and fade

3. **Particle-Based Shimmer**
   - Tiny bright pixels (sparkles) that appear randomly on water surface
   - Use colors #FFFFFF, #F0F8FF, #E0F6FF for general shimmer
   - Add occasional gold-colored sparkles (#FFD700) when gold particles are in the water
   - Particles should appear for 2-3 frames and fade out

4. **Sediment Flow Animation**
   - Lighter colored particles that flow with the water current
   - Use colors from your soil palette (#A0522D, #CD853F) at 40-60% opacity
   - Animate flowing downstream to show water movement
   - Creates the realistic effect of sediment in Vermont streams

### Visual Effects for Panning Process
1. **Pan Water Movement**
   - When panning, show concentric circle ripples spreading from the pan
   - Use your water palette colors with 70% opacity
   - Animate outward from center over 6-8 frames

2. **Separation Effects**
   - Show lighter sediments washing out from the pan to the sides
   - Use your sediment colors (#A0522D, #8B4513) fading to transparency
   - Animate from center to edges over 10-12 frames

3. **Gold Particle Highlight**
   - When gold is in the pan, make it gently shimmer with #FFD700
   - Use pulsing opacity to create a catching-light effect
   - Animate subtle movement to simulate particles settling

## UI Themes for Outdoorsy Aesthetic

### Overall UI Design Philosophy
- **Natural Materials**: UI elements that mimic wood, stone, and canvas textures
- **Subtle Integration**: UI that feels like it belongs in the environment rather than overlays
- **Minimalist Approach**: Clean, uncluttered interfaces that don't distract from the nature experience
- **Hand-Drawn Elements**: Slight irregularities to give a crafted, artisanal feel

### Main UI Color Scheme
- **Primary Background**: #DEB887 (Burlywood) - Warm, natural wood tone
- **Secondary Background**: #D2B48C (Tan) - Lighter wood tone for panels
- **Accent Color**: #8B4513 (Saddle Brown) - For borders and important elements
- **Text Color**: #2F4F4F (Dark Slate Gray) - Clear but not harsh
- **Highlight Color**: #FFD700 (Gold) - For important information and gold-related elements
- **Seasonal UI Colors**: Adapt UI colors to match the current season's palette

### UI Components

#### Inventory UI
- **Background**: Canvas texture with wooden frame (#DEB887 with wood grain)
- **Slot Borders**: Subtle #8B4513 outline with rounded corners
- **Gold Counter**: Prominent display using #FFD700 with #8B4513 outline
- **Item Icons**: Simple 16x16 pixel icons with consistent art style
- **Seasonal Adaptation**: Frame colors change to match seasonal palette

#### Tool Status UI
- **Pan Condition**: Visual bar using wood texture (#DEB887 to #8B4513) that shows wear
- **Stamina Indicator**: River rock-like appearance using stone colors
- **Skill Meter**: Graduated scale using Vermont granite gray (#708090)

#### Seasonal Calendar
- **Background**: Weathered wood (#DEB887 with aged texture)
- **Current Day**: Highlighted with #FFD700 or seasonal accent color
- **Month Names**: Hand-lettered style using #2F4F4F
- **Seasonal Transitions**: Visual indicators using seasonal palette colors

#### Market Prices Display
- **Background**: Paper-like texture with slight yellowing (#F5DEB3)
- **Gold Price**: Prominent display using #FFD700 with shadow
- **Trend Indicators**: Simple arrows in #8B4513 showing price direction

### HUD Elements
- **Gold Counter**: Gold coin icon with #FFD700 number display
- **Location Name**: Subtle text using #2F4F4F in a readable but natural font
- **Weather Icon**: Small pixel art icon in corner showing current conditions
- **Season Indicator**: Discrete icon showing current season

## Environmental Sound Design

### Core Water Sounds
- **Stream Flow**: Gentle, consistent babbling water with varying intensity based on location
- **Panning Sounds**: Water swishing in the pan, sediment shifting and separating
- **Rain on Water**: Different texture when it's raining - more pitter-patter sounds
- **Ice Formation**: In winter - occasional crackling and settling sounds

### Seasonal Wildlife Sounds

**Spring**:
- Bird songs: Hermit thrush, wood thrush, and song sparrow calls
- Distant woodpecker drumming
- Occasional frog croaking near pools
- Running water sounds more intense due to snowmelt

**Summer**:
- Woodland birds: Red-winged blackbird, common yellowthroat
- Insect buzzes in the background (not too prominent)
- Occasional loon call if near a larger water body
- More general wildlife activity

**Autumn**:
- Fewer bird songs, but still present
- Rustling leaves falling into water
- Acorns dropping occasionally
- Geese flying overhead (distant honking)

**Winter**:
- Minimal bird sounds (perhaps a raven or winter wren)
- Wind through bare trees
- Ice crackling sounds
- Snow crunching if player moves on snow banks

### Atmospheric Ambiences
- **Wind**: Gentle breeze through trees, intensity varying with weather
- **Tree Sounds**: Subtle creaking in wind, leaves rustling in summer
- **Distant Sounds**: Occasional farm equipment, logging, or outdoor sounds
- **Seasonal Transitions**: Gradual changes in the audio mix as seasons transition

### Interactive Sounds
- **Step Sounds**: Different based on terrain (gravel, leaves, snow, mud)
- **Pan Handling**: Subtle metal-on-metal sounds when adjusting the pan
- **Scooping Sediment**: Water and material sounds when filling the pan
- **Finding Gold**: Special satisfying chime or shimmer sound for gold discoveries
- **Equipment Upgrades**: Positive sounds when purchasing new gear

### Audio Implementation Recommendations
- **Looping Ambiences**: 30-60 second seamless loops with variations
- **One-Shot Sounds**: Short sound effects under 2 seconds
- **Sample Rate**: 44.1kHz for high quality
- **Format**: OGG for good compression in game engines
- **Volume Levels**: Carefully balanced so no single sound dominates

### Dynamic Audio Features
- **Distance Attenuation**: Sounds fade naturally with distance
- **Obstruction Effects**: Sounds muffled when behind trees or rocks
- **Time of Day**: Softer, fewer sounds at dawn/dusk; more active during midday
- **Layering**: Multiple audio layers that blend based on location and activity
- **Spatial Positioning**: 2D panning to match the visual direction of sounds

## Implementation Notes for Godot

### Visual Effects
- Use AnimatedSprite2D for seasonal tree animations
- Apply shaders for water shimmer effects
- Implement ColorRect nodes with seasonal palettes for dynamic UI
- Use tilemaps with seasonal variations

### Audio System
- Implement AudioStreamPlayer nodes for different sound categories
- Use audio buses for environmental sound control
- Create seasonal audio managers that swap between seasonal sound sets
- Implement 2D audio positioning for directional sound effects

### Seasonal Transitions
- Create a SeasonManager that handles both visual and audio transitions
- Use Lerp functions for smooth color transitions
- Animate sprite swaps with fade effects to avoid jarring changes
- Gradually shift audio palettes over time periods rather than instantly