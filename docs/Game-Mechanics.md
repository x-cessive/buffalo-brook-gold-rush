# Game Mechanics

This guide explains the core gameplay systems in Buffalo Brook Gold Rush, including panning mechanics, physics simulation, and success factors.

## Table of Contents

- [Overview](#overview)
- [Gold Panning Process](#gold-panning-process)
- [Physics Simulation](#physics-simulation)
- [Success Factors](#success-factors)
- [Environmental Effects](#environmental-effects)
- [Advanced Techniques](#advanced-techniques)

---

## Overview

Buffalo Brook Gold Rush simulates realistic gold panning mechanics based on the actual physical properties of gold and sediment. Understanding these mechanics is key to maximizing your success.

### Core Concepts

**Density-Based Separation**
- Gold is significantly denser than sediment (19.3 g/cm³ vs ~2.5 g/cm³)
- Heavier particles sink while lighter materials wash away
- Water facilitates particle movement and separation

**Player Skill**
- Success depends on technique and timing
- Different situations require different approaches
- Experience improves results over time

---

## Gold Panning Process

### Phase 1: Starting a Panning Session

**Initiating Panning:**
1. Position near water source
2. Press `E` to interact
3. Minigame begins automatically

**Initial State:**
- Pan fills with sediment and potential gold
- Sediment amount varies by location and weather
- Gold presence determined by location richness

### Phase 2: Sediment Separation

**Control Mechanics:**

| Action | Control | Effect |
|--------|---------|--------|
| Tilt Left | J | Pan tilts left, sediment slides out left side |
| Tilt Right | K | Pan tilts right, sediment slides out right side |
| Shake | Space | Agitates contents, separates light materials |
| Add Water | Q | Increases water level (auto-managed) |
| Remove Water | E | Decreases water level (auto-managed) |

**Separation Process:**
1. Water sloshes and moves particles
2. Tilt angle affects sediment flow direction
3. Shake intensity increases separation rate
4. Gold settles at the bottom due to weight
5. Lighter sediment washes out

### Phase 3: Gold Detection

**Detection Algorithm:**
```
detection_chance = separation_factor × location_richness
```

Where:
- `separation_factor`: 0.0 to 1.0 based on technique effectiveness
- `location_richness`: 0.5 to 2.0 based on mining location

**Gold Visibility:**
- Gold becomes visible as sediment reduces
- More effective separation = higher detection chance
- Final amount determined by random factor within range

### Phase 4: Collection

**Completion:**
- Minigame ends when sediment threshold reached
- Success rate calculated based on gold-to-sediment ratio
- Gold added to inventory if successful
- Tool durability decreased

---

## Physics Simulation

### Particle System

**Sediment Particles:**
- Represented as individual entities in the pan
- Affected by tilt angle and shake intensity
- Gradually removed through washing action

**Gold Particles:**
- Heavier than sediment (simulated weight)
- Resist being washed out
- Concentrate at pan bottom

### Water Mechanics

**Water Amount:**
- Range: 50 to 150 units
- Optimal range: 80-120 units
- Too little: Difficult separation
- Too much: Risk of losing gold

**Water Effects:**
- Facilitates particle movement
- Increases separation effectiveness
- Affects pan tilt responsiveness

### Tilt Physics

**Pan Angle:**
- Range: -45° to +45°
- Controlled by J/K keys
- Affects sediment flow direction
- Steeper angles = faster sediment removal

**Tilt Response:**
```gdscript
sediment_flow = tilt_angle × water_amount × 0.1
```

### Shake Mechanics

**Shake Intensity:**
- Range: 0.0 to 1.0
- Builds with repeated Space presses
- Decays over time if not maintained
- Affects separation effectiveness

**Shake Effect:**
```gdscript
separation_boost = shake_intensity × 0.2
sediment_removal = base_removal + separation_boost
```

---

## Success Factors

### Location Richness

**Richness Levels:**
- **Poor** (0.5x): Low gold presence
- **Average** (1.0x): Standard gold amounts
- **Rich** (1.5x): Above-average gold
- **Very Rich** (2.0x): High gold concentration

**Location Examples:**
- Buffalo Brook: 1.0x (Average)
- Rich River: 1.5x (Rich)
- Gold Mountain: 2.0x (Very Rich)
- Muddy Creek: 0.5x (Poor)

### Tool Effectiveness

**Tool Modifiers:**
- Basic Pan: 1.0x
- Gold Pan: 1.3x
- Professional Pan: 1.6x
- Sluice Box: 2.0x

**Impact on Results:**
```gdscript
final_gold = base_gold × tool_effectiveness × location_richness
```

### Player Technique

**Skill Factors:**
- Timing of tilts
- Shake rhythm
- Water management
- Patience and control

**Technique Rating:**
- Novice: 0.6-0.8x
- Intermediate: 0.8-1.0x
- Expert: 1.0-1.2x

### Random Variation

**Randomness:**
- Adds unpredictability and realism
- Range: 0.5x to 1.5x
- Prevents guaranteed outcomes
- Simulates natural variation

---

## Environmental Effects

### Weather System

**Weather Types:**

| Weather | Sediment Modifier | Description |
|---------|------------------|-------------|
| Clear | 1.0x | Standard conditions |
| Overcast | 1.1x | Slightly more sediment |
| Rain | 1.3x | Muddy water, extra sediment |
| Storm | 1.5x | Heavy sediment, difficult panning |

**Impact:**
- More sediment = longer panning time
- Harder to see gold
- Requires more effort

### Time of Day

**Time Effects:**
- Morning: Standard conditions
- Afternoon: Optimal visibility
- Evening: Reduced visibility
- Night: Minimal visibility (if allowed)

**Visibility Impact:**
```gdscript
visibility_modifier = 1.0 - (darkness × 0.5)
detection_chance *= visibility_modifier
```

### Season (Future Feature)

**Planned Seasonal Effects:**
- Spring: Higher water levels, more sediment
- Summer: Optimal conditions
- Fall: Lower water, concentrated gold
- Winter: Frozen conditions, limited access

---

## Advanced Techniques

### The Gentle Swirl

**Method:**
1. Start with minimal tilt (15-20°)
2. Alternate J and K in rhythm
3. Add occasional gentle shakes
4. Monitor sediment levels

**Best For:**
- High-sediment situations
- Precision gold preservation
- Learning basic mechanics

**Pros:**
- Low risk of losing gold
- Steady, predictable results
- Easy to master

**Cons:**
- Slower than aggressive methods
- Requires patience

### The Aggressive Shake

**Method:**
1. Rapid Space presses
2. Maintain high shake intensity
3. Quick tilts to remove sediment
4. Fast completion

**Best For:**
- Time pressure scenarios
- Low-sediment situations
- Experienced players

**Pros:**
- Fast completion time
- Efficient sediment removal
- Higher throughput

**Cons:**
- Risk of losing gold
- Requires practice
- Less consistent

### The Balanced Approach

**Method:**
1. Assess initial sediment amount
2. Start with controlled tilts
3. Add shakes when sediment >50%
4. Slow down when gold visible
5. Finish with gentle technique

**Best For:**
- Most situations
- Consistent results
- Optimal gold yield

**Pros:**
- Balanced risk/reward
- Adapts to conditions
- Consistent performance

**Cons:**
- Requires judgment
- More complex than simple methods

### The Patience Method

**Method:**
1. Minimal movement
2. Let gravity do the work
3. Occasional gentle tilts
4. No rushing

**Best For:**
- Very rich locations
- When tool durability is low
- Maximum gold preservation

**Pros:**
- Highest gold retention
- Lowest risk
- Preserves tool durability

**Cons:**
- Very slow
- Lower throughput
- Can be boring

---

## Tips and Strategies

### Maximizing Gold Yield

1. **Match technique to conditions**
   - High sediment = gentler approach
   - Low sediment = can be more aggressive

2. **Watch for visual cues**
   - Gold glints when visible
   - Sediment color lightens as it reduces

3. **Timing matters**
   - Don't rush the process
   - But don't over-work the pan

4. **Water management**
   - Keep water in optimal range
   - Add water if too low
   - Remove if too high

### Efficiency Tips

1. **Chain panning sessions**
   - Multiple quick pans > one slow pan
   - Build rhythm and muscle memory

2. **Use appropriate tools**
   - Don't waste good tools on poor locations
   - Save best tools for richest spots

3. **Consider weather**
   - Avoid panning in storms if possible
   - Best results in clear weather

4. **Learn location patterns**
   - Some spots consistently better
   - Return to proven locations

---

## Common Mistakes

### Beginner Errors

❌ **Over-tilting**
- Loses gold particles
- Too aggressive

✅ **Solution**: Start with gentle tilts, increase gradually

❌ **Too much shaking**
- Wastes time
- Can lose gold

✅ **Solution**: Use shakes strategically, not constantly

❌ **Impatience**
- Rushes through process
- Misses gold

✅ **Solution**: Take time to do it right

❌ **Ignoring water level**
- Too low or too high
- Affects results

✅ **Solution**: Monitor and adjust water

### Advanced Mistakes

❌ **Wrong technique for conditions**
- Using same method always
- Not adapting

✅ **Solution**: Assess conditions, choose appropriate technique

❌ **Tool mismanagement**
- Using expensive tools wastefully
- Not maintaining durability

✅ **Solution**: Match tool to situation, repair regularly

---

## Practice Scenarios

### Scenario 1: High Sediment

**Conditions:**
- Sediment: 80 units
- Gold: 3 particles
- Weather: Rainy

**Recommended Approach:**
- Use Gentle Swirl technique
- Allow extra time
- Focus on preservation

### Scenario 2: Low Sediment

**Conditions:**
- Sediment: 30 units
- Gold: 2 particles
- Weather: Clear

**Recommended Approach:**
- Use Aggressive Shake
- Quick completion
- Maximize efficiency

### Scenario 3: Rich Location

**Conditions:**
- Sediment: 50 units
- Gold: 8 particles
- Weather: Clear

**Recommended Approach:**
- Use Balanced Approach
- Take your time
- Optimize yield

---

## Mechanics Summary

**Key Takeaways:**
- Gold panning is skill-based but has randomness
- Multiple factors affect success
- Different techniques suit different situations
- Practice improves results
- Environmental conditions matter

**Success Formula:**
```
Success = (Base Chance × Tool × Location × Technique × Random) - Environmental Penalties
```

---

[← Back to Wiki Home](Home.md) | [Next: Tool System →](Tool-System.md)
