# Tool System

Complete guide to tools, upgrades, durability mechanics, and equipment management in Buffalo Brook Gold Rush.

## Table of Contents

- [Overview](#overview)
- [Tool Types](#tool-types)
- [Tool Statistics](#tool-statistics)
- [Durability System](#durability-system)
- [Upgrades and Progression](#upgrades-and-progression)
- [Tool Management](#tool-management)
- [Strategic Guide](#strategic-guide)

---

## Overview

Tools are essential equipment for gold panning. Each tool has unique characteristics that affect your gold-finding success, durability, and efficiency.

### Key Concepts

**Effectiveness** - Primary stat affecting gold yield
**Durability** - How long the tool lasts before breaking
**Cost** - Purchase price and repair expenses
**Upgrades** - Improvements that enhance tool performance

---

## Tool Types

### Basic Pan
**The Starter Tool**

![Basic Pan Icon]

**Description:** A simple wooden pan for basic gold panning. Every prospector starts with this humble tool.

**Stats:**
- Effectiveness: 1.0x (100%)
- Max Durability: 100
- Cost: Free (starting equipment)
- Repair Cost: 5 gold per 10 durability

**Pros:**
- Free to start
- Cheap repairs
- Good for learning
- Reliable performance

**Cons:**
- No effectiveness bonus
- Wears quickly
- Limited capacity

**Best Use:**
- Learning the game
- Poor mining locations
- When low on funds
- Practice sessions

---

### Gold Pan
**The Improved Tool**

![Gold Pan Icon]

**Description:** A metal pan with better design for more efficient gold separation. The first real upgrade.

**Stats:**
- Effectiveness: 1.3x (130%)
- Max Durability: 150
- Cost: 100 gold
- Repair Cost: 10 gold per 10 durability

**Pros:**
- 30% effectiveness increase
- More durable
- Better capacity
- Worth the investment

**Cons:**
- Significant initial cost
- Higher repair costs
- Still not the best

**Best Use:**
- Average locations
- When you have funds
- Regular gameplay
- Good balance of cost/performance

**Unlock Requirement:** Collect 50 total gold

---

### Professional Pan
**The Expert's Choice**

![Professional Pan Icon]

**Description:** A precision-engineered pan used by professional prospectors. Superior design and materials.

**Stats:**
- Effectiveness: 1.6x (160%)
- Max Durability: 200
- Cost: 250 gold
- Repair Cost: 15 gold per 10 durability

**Pros:**
- 60% effectiveness increase
- Very durable
- Excellent capacity
- Professional results

**Cons:**
- Expensive purchase
- Costly repairs
- Requires skill to maximize

**Best Use:**
- Rich locations
- Experienced players
- When durability matters
- Serious gold hunting

**Unlock Requirement:** Collect 200 total gold, own Gold Pan

---

### Sluice Box
**The Ultimate Equipment**

![Sluice Box Icon]

**Description:** A stationary system that processes large amounts of sediment. The gold standard of equipment.

**Stats:**
- Effectiveness: 2.0x (200%)
- Max Durability: 300
- Cost: 500 gold
- Repair Cost: 25 gold per 10 durability
- Setup Time: 30 seconds

**Pros:**
- Double effectiveness
- Extremely durable
- Highest capacity
- Best overall tool

**Cons:**
- Very expensive
- High repair costs
- Requires setup
- Not portable

**Best Use:**
- Very rich locations
- Extended sessions
- Endgame content
- Maximizing profits

**Unlock Requirement:** Collect 500 total gold, own Professional Pan

---

## Tool Statistics

### Comparative Chart

| Tool | Effectiveness | Durability | Cost | Repair/10 | Gold/Durability |
|------|--------------|------------|------|-----------|-----------------|
| Basic Pan | 1.0x | 100 | Free | 5g | ~0.5g |
| Gold Pan | 1.3x | 150 | 100g | 10g | ~0.65g |
| Professional Pan | 1.6x | 200 | 250g | 15g | ~0.8g |
| Sluice Box | 2.0x | 300 | 500g | 25g | ~1.0g |

### Effectiveness Explained

**Effectiveness Multiplier:**
```gdscript
gold_found = base_gold × tool_effectiveness × location_richness × random_factor
```

**Example Calculation:**
- Location base: 3 gold
- Basic Pan (1.0x): 3 gold average
- Gold Pan (1.3x): 3.9 gold average
- Professional Pan (1.6x): 4.8 gold average
- Sluice Box (2.0x): 6 gold average

### Durability Mechanics

**Usage:**
- Each panning attempt costs durability
- Amount varies: 1-5 points per attempt
- Depends on technique and conditions

**Degradation Factors:**
- Aggressive shaking: Higher wear
- Poor conditions: Increased degradation
- Long sessions: Faster wear
- Tool quality: Better tools last longer

**Durability States:**
| State | Durability | Effect | Visual |
|-------|------------|--------|--------|
| Perfect | 90-100% | No penalties | Green |
| Good | 70-89% | -5% effectiveness | Yellow |
| Worn | 40-69% | -15% effectiveness | Orange |
| Damaged | 10-39% | -30% effectiveness | Red |
| Broken | 0-9% | -50% effectiveness | Flashing Red |

---

## Durability System

### How Durability Works

**Durability Loss:**
```gdscript
durability_loss = base_loss × technique_modifier × weather_modifier
```

**Base Loss:** 2-4 points per attempt

**Technique Modifier:**
- Gentle: 0.5x
- Normal: 1.0x
- Aggressive: 1.5x

**Weather Modifier:**
- Clear: 1.0x
- Rain: 1.2x
- Storm: 1.5x

### Repairing Tools

**Repair Options:**

1. **Full Repair**
   - Restores to 100% durability
   - Cost: (max_durability - current) × repair_rate
   - Available at shop

2. **Partial Repair**
   - Restore specific amount
   - Cost: amount × repair_rate
   - Flexible option

3. **Field Repair**
   - Emergency temporary fix
   - Restores 20 durability
   - Uses repair kit item

**Repair Costs:**
```
Basic Pan: 0.5 gold per durability point
Gold Pan: 0.67 gold per durability point
Professional Pan: 0.75 gold per durability point
Sluice Box: 0.83 gold per durability point
```

### Tool Maintenance

**Best Practices:**
- Repair before durability drops below 70%
- Don't let tools break (expensive to fix from 0)
- Keep backup tool for emergencies
- Use appropriate tool for location value

**Maintenance Schedule:**
- Check durability after every 5 pans
- Repair at 60-70% durability
- Full repair before rich locations
- Emergency kit for remote areas

---

## Upgrades and Progression

### Upgrade Path

```
Basic Pan (Free)
    ↓ (100 gold)
Gold Pan (1.3x)
    ↓ (250 gold)
Professional Pan (1.6x)
    ↓ (500 gold)
Sluice Box (2.0x)
```

### Tool Enhancements

**Available Upgrades:**

1. **Reinforced Edges**
   - +20 max durability
   - Cost: 50 gold
   - Available: Gold Pan+

2. **Non-Stick Coating**
   - -20% durability loss
   - Cost: 75 gold
   - Available: Professional Pan+

3. **Gold Attractor**
   - +10% effectiveness
   - Cost: 100 gold
   - Available: Professional Pan+

4. **Automatic Sifter**
   - +5% detection chance
   - Cost: 150 gold
   - Available: Sluice Box only

### Progression Strategy

**Early Game (0-100 gold):**
- Use Basic Pan efficiently
- Learn mechanics
- Save for Gold Pan
- Don't waste durability

**Mid Game (100-500 gold):**
- Purchase Gold Pan
- Start upgrading
- Focus on good locations
- Build savings

**Late Game (500+ gold):**
- Purchase Professional Pan
- Max out upgrades
- Save for Sluice Box
- Optimize everything

**End Game (1000+ gold):**
- Own Sluice Box
- All upgrades
- Maximize profits
- Help other players

---

## Tool Management

### Inventory Management

**Tool Slots:**
- Primary: Currently equipped tool
- Secondary: Quick-swap backup
- Storage: Additional tools (up to 10)

**Switching Tools:**
- Open inventory (I key)
- Select tool
- Confirm switch
- Previous tool stored

### Multiple Tool Strategy

**Why Own Multiple Tools:**
- Different tools for different situations
- Backup when primary breaks
- Cost optimization
- Flexibility

**Recommended Loadout:**
- Primary: Best tool you own
- Secondary: One tier lower
- Storage: Basic Pan (backup)

### Cost-Benefit Analysis

**Tool ROI (Return on Investment):**

```
Basic Pan:
- Cost: 0
- Avg gold/durability: 0.5
- Lifetime value: 50 gold
- ROI: Infinite (free)

Gold Pan:
- Cost: 100 gold
- Avg gold/durability: 0.65
- Lifetime value: 97.5 gold
- Break-even: ~103 pans
- ROI: 97.5% at full durability

Professional Pan:
- Cost: 250 gold
- Avg gold/durability: 0.8
- Lifetime value: 160 gold
- Break-even: ~190 pans
- ROI: 64% at full durability

Sluice Box:
- Cost: 500 gold
- Avg gold/durability: 1.0
- Lifetime value: 300 gold
- Break-even: ~250 pans
- ROI: 60% at full durability
```

**Optimal Purchase Timing:**
- Gold Pan: When you have 150-200 gold
- Professional Pan: When you have 350-400 gold
- Sluice Box: When you have 700-800 gold

---

## Strategic Guide

### Tool Selection Matrix

**Choose Based On:**

| Situation | Recommended Tool | Reasoning |
|-----------|-----------------|-----------|
| Learning | Basic Pan | Free, no pressure |
| Poor Location | Basic Pan | Don't waste good tools |
| Average Location | Gold Pan | Good balance |
| Rich Location | Professional Pan | Worth the durability |
| Very Rich Location | Sluice Box | Maximum yield |
| Low Funds | Basic Pan | Conserve resources |
| High Durability | Any | Use what you have |
| Low Durability | Basic Pan | Save better tools |
| Storm Weather | Basic Pan | High wear conditions |
| Perfect Weather | Best Available | Optimize conditions |

### Advanced Strategies

**Tool Rotation:**
1. Use best tool for rich locations
2. Switch to mid-tier for average spots
3. Basic Pan for poor locations or practice
4. Repair all tools at once for economy

**Durability Optimization:**
1. Track durability closely
2. Plan repairs around shopping trips
3. Don't repair too early (waste money)
4. Don't wait until broken (penalties)

**Economic Optimization:**
1. Calculate gold per durability point
2. Match tool cost to location value
3. Minimize repair frequency
4. Maximize profit margins

---

## Tips and Tricks

### Tool Care

✅ **DO:**
- Repair at 60-70% durability
- Use appropriate tool for location
- Keep backup tools
- Track durability actively

❌ **DON'T:**
- Let tools break completely
- Use expensive tools on poor locations
- Over-repair (waste money)
- Neglect maintenance

### Upgrade Priority

1. **First:** Get Gold Pan (biggest initial improvement)
2. **Second:** Save for Professional Pan
3. **Third:** Add Reinforced Edges upgrade
4. **Fourth:** Get Sluice Box
5. **Fifth:** All remaining upgrades

### Common Questions

**Q: Should I repair or buy new?**
A: Repair until cost exceeds 70% of new tool price.

**Q: Best tool for beginners?**
A: Basic Pan to learn, then Gold Pan ASAP.

**Q: Is Sluice Box worth it?**
A: Yes, but only for endgame rich locations.

**Q: How many tools should I own?**
A: Minimum 2 (primary + backup), ideal 3-4.

---

[← Back: Game Mechanics](Game-Mechanics.md) | [Next: Economy Guide →](Economy-Guide.md)
