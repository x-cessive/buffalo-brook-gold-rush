# Buffalo Brook Gold Rush - Gameplay Design Document

## Overview
Buffalo Brook Gold Rush is a 2D gold panning simulation game set in authentic Vermont streams. Players experience the meditative and skill-based activity of gold panning while adapting to seasonal changes and weather conditions that affect gameplay.

## Core Gameplay Loop

### Primary Panning Cycle
1. **Select Location** - Choose where to pan in the stream (different spots have varying gold densities)
2. **Gather Sediment** - Use the pan to scoop up water, sand, and sediment from the stream bed
3. **Wash & Separate** - Tilt and rotate the pan to wash away lighter materials, keeping heavier particles (including potential gold)
4. **Inspect Findings** - Examine what remains in the pan (gold flakes, nuggets, gems, or debris)
5. **Collect Rewards** - Add any found gold/gems to inventory and sell at market prices
6. **Refine Equipment** - Use earnings to purchase better pans, sieves, or tools for more efficient panning

### Secondary Loops
- Seasonal Preparation - Prepare for weather changes that affect panning conditions
- Equipment Upgrades - Invest in better tools to improve success rates
- Location Exploration - Discover new stream locations with better gold potential
- Market Engagement - Sell findings and monitor fluctuating gold prices

### Skill-Based Mechanics
- Timing and rhythm of water flow to separate materials effectively
- Tilt angles and rotation patterns to keep heavier gold particles in the pan
- Recognition skills to identify valuable finds among debris
- Understanding of geology to predict where gold deposits might be

## World Feel: Vermont Stream Environment

### Visual Aesthetics
- Lush maple, birch, and pine forests surrounding the waterways
- Rocky stream beds: Natural granite and schist formations, worn smooth by centuries of flowing water
- Clear water: Crystalline streams with visible underwater sediment and pebbles
- Seasonal color shifts: Maple leaves turning brilliant reds and golds in autumn, snow-dusted banks in winter

### Environmental Details
- Authentic soundscape: Gentle babbling of water over rocks, birdsong (hermit thrush, wood thrush), occasional rustling of small animals
- Atmospheric lighting: Dappled sunlight filtering through tree canopies, mist rising from cold water in early morning
- Weather effects: Occasional drizzle, fog rolling through valleys, sunlight creating dancing patterns on water surface
- Fauna elements: Trout jumping, beaver dams visible upstream, deer tracks in muddy banks

### Vermont-Specific Features
- Historical context: Abandoned mining equipment, remnants of 19th century gold rush, old prospector cabins
- Geological sites: Locations based on real Vermont gold-bearing areas (e.g., areas around Woodstock, Plymouth)
- Local flora: Mountain laurel, wildflowers, ferns growing along stream banks
- Topographical elements: Mountain streams cascading down granite slopes, quiet pools between rapids

### Immersive Elements
- Particle effects: Sunlight glinting off gold flakes, sediment swirling in pans, morning mist
- Environmental responses: Animals fleeing as player approaches, leaves falling into water, water ripples
- Day/night cycle: Morning mist, golden hour lighting, evening fireflies, star reflections on calm water

## Player Motivation Systems

### Progression & Achievement
- Skill Mastery: Unlock advanced panning techniques and sensitivity to gold detection as player improves
- Collection Goals: Complete sets of rare finds (different types of gems, unique mineral specimens)
- Achievement Badges: "First Gold Flake", "Seasonal Explorer", "Equipment Collector", "Market Mogul"
- Character Development: Improve stats like "Gold Sense" (finding probability), "Stamina" (panning duration), and "Efficiency" (sediment processing speed)

### Economic Incentives
- Market Fluctuations: Gold prices that vary based on historical data and in-game events
- Equipment Upgrades: Better pans, sluice boxes, and metal detectors that improve success rates
- Investment Opportunities: Purchase land claims or mining rights to exclusive areas
- Trading System: Exchange rare finds with other prospectors or collectors

### Discovery & Exploration
- Hidden Locations: Secret spots with higher gold density, discovered through exploration
- Historical Mysteries: Solve clues about historical gold rushes and famous finds in Vermont
- Geological Learning: Educational elements about gold formation and Vermont geology
- Photography Mode: Capture and share beautiful scenes with notable finds

### Social Elements
- Leaderboards: Compare gold collected by season, total career earnings, or rarest finds
- Community Challenges: Seasonal events with special conditions or bonus rewards
- Gift Economy: Share gold flakes or rare finds with other players
- Knowledge Sharing: Tips and locations discovered by other players

### Emotional Rewards
- Relaxation Factor: Calming nature sounds, peaceful environment, meditative panning rhythm
- Discovery Thrill: Visual and audio feedback for significant finds (golden sparkles, special sounds)
- Environmental Stewardship: Positive reinforcement for choosing sustainable panning methods
- Seasonal Accomplishment: Recognition for adapting to and thriving in different weather conditions

## Seasonal Weather Mechanics

### Spring (March-May)
- Thaw Conditions: Snow melt increases water flow, potentially exposing new gold deposits
- Increased Sediment: More material to pan due to runoff, but gold dispersed over wider area
- Equipment Challenges: Higher water levels make some spots inaccessible; better pans needed
- Weather Events: Occasional spring showers, rapidly changing temperatures
- Gameplay Adjustments: More debris in pans, lower gold density, wider search areas needed

### Summer (June-August)
- Low Water Conditions: Shallow streams expose more of the stream bed and potential gold deposits
- Optimal Panning: Best conditions for gold panning - clear, low, calm water
- Heat Effects: Player stamina decreases faster during extended panning sessions
- Wildlife Activity: More animals visible, more scenic beauty, ideal for photography
- Gameplay Adjustments: Higher gold visibility, longer panning sessions possible, increased stamina drain

### Autumn (September-November)
- Changing Environment: Beautiful fall foliage creates a scenic game environment
- Moderate Water Levels: Good conditions similar to but slightly less optimal than summer
- Frost Effects: Early morning ice on pans, requiring time to melt before panning
- Preparation Phase: Time to prepare equipment and storage for winter
- Gameplay Adjustments: Moderate gold visibility, morning delays due to frost, seasonal rewards for preparation

### Winter (December-February)
- Challenging Conditions: Ice, cold, reduced water flow, limited access to streams
- Special Equipment: Insulated pans, ice-breaking tools, cold-resistant clothing required
- Reduced Activity: Most difficult season for gold panning but rare finds possible
- Indoor Activities: Equipment maintenance, planning for next year, studying geological maps
- Gameplay Adjustments: Limited panning time, special winter finds possible, equipment durability affected by cold

### Dynamic Weather System
- Daily Weather: Random weather events that affect panning conditions (fog, rain, wind)
- Weather Prediction: Players can learn to read signs for better planning
- Severe Weather Events: Occasional storms that temporarily block access to certain areas
- Seasonal Transitions: Gradual changes between seasons with mixed conditions
- Microclimates: Different locations may have slightly different weather patterns

### Weather Impact on Gameplay
- Visibility: Rain increases sediment, fog reduces visibility of gold particles
- Water Temperature: Affects player stamina and equipment function
- Stream Flow: High flow disperses gold, low flow concentrates it in specific areas
- Accessibility: Some locations become accessible or inaccessible based on weather/season

## Technical Implementation Notes for Godot 4

### Scene Architecture
- Main world scene with tilemap for terrain
- Stream/river nodes with animated water
- Player-controlled panning tool with physics-based controls
- UI system for inventory, equipment, and market
- Weather and season management system

### Key Scripts
- GoldPanning.gd: Handles the core panning mechanics and sediment separation
- SeasonManager.gd: Controls seasonal and weather transitions
- GoldDetection.gd: Skill-based gold detection algorithm
- EquipmentManager.gd: Manages player's inventory and tool upgrades
- LocationManager.gd: Handles different stream locations and their properties

### Visual Elements
- Animated 2D sprites for panning motion and sediment separation
- Particle systems for water effects and gold sparkles
- Dynamic lighting that changes with time of day and weather
- Seasonal texture swapping for environment assets

### UI Components
- Inventory system showing collected gold and gems
- Equipment upgrade interface
- Market prices display
- Seasonal calendar
- Skill progression tracker