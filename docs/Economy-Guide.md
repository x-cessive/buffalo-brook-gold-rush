# Economy Guide

Understanding the economic systems in Buffalo Brook Gold Rush: prices, trading, market dynamics, and wealth building strategies.

## Table of Contents

- [Overview](#overview)
- [Gold Value System](#gold-value-system)
- [Market Dynamics](#market-dynamics)
- [Shop System](#shop-system)
- [Economic Strategy](#economic-strategy)
- [Wealth Building](#wealth-building)

---

## Overview

Buffalo Brook Gold Rush features a dynamic economy that simulates real market forces. Understanding these systems helps you maximize profits and build wealth efficiently.

### Economic Principles

**Supply and Demand** - Prices fluctuate based on market conditions
**Market Trends** - Long-term patterns affect values
**Strategic Timing** - When you sell matters
**Investment** - Spending money to make money

---

## Gold Value System

### Base Gold Value

**Standard Pricing:**
- Base value: 10 currency per gold piece
- This is the reference point for all calculations
- Actual prices fluctuate around this base

### Price Fluctuation

**Fluctuation Range:**
- Minimum: 7 currency (30% below base)
- Maximum: 15 currency (50% above base)
- Average: 10 currency (base value)

**Fluctuation Formula:**
```gdscript
current_price = base_price × (1.0 + (randf_range(-0.3, 0.5)))
```

### Market State

**Market Conditions:**

| State | Price Range | Frequency | Duration |
|-------|------------|-----------|----------|
| **Crash** | 7-8 currency | Rare (5%) | 2-4 hours |
| **Bear** | 8-9 currency | Common (25%) | 4-8 hours |
| **Stable** | 9-11 currency | Very Common (40%) | 8-12 hours |
| **Bull** | 11-13 currency | Common (25%) | 4-8 hours |
| **Boom** | 13-15 currency | Rare (5%) | 2-4 hours |

### Price Indicators

**Visual Cues:**
- 🔴 Red: Crash/Bear (sell if desperate)
- 🟡 Yellow: Stable (reasonable to sell)
- 🟢 Green: Bull/Boom (excellent time to sell)

**Price Trends:**
- ⬇️ Downward: Prices decreasing
- ➡️ Stable: Prices holding
- ⬆️ Upward: Prices increasing

---

## Market Dynamics

### Time-Based Changes

**Update Frequency:**
- Market updates every 30 game minutes
- Real-time: ~5 minutes per update
- Allows strategic timing

**Daily Patterns:**
- Morning: Usually lower prices
- Afternoon: Peak trading time
- Evening: Moderate prices
- Night: Reduced activity

### Supply Effect

**Your Impact:**
```gdscript
supply_effect = player_gold_sold / 1000
price_reduction = base_price × supply_effect × 0.1
```

**Interpretation:**
- Selling large amounts depresses prices
- Effect temporary (recovers over time)
- Encourages selling in moderation
- Simulates market saturation

### Demand Cycles

**Demand Factors:**
- Time of year (seasonal)
- In-game events
- NPC buying activity
- Market news

**High Demand Periods:**
- Spring: +10% prices
- Festival events: +15% prices
- Shortage periods: +20% prices

**Low Demand Periods:**
- Winter: -10% prices
- Surplus periods: -15% prices

---

## Shop System

### Shop Types

#### **General Store**
**Services:**
- Buy/sell tools
- Purchase supplies
- Repair equipment
- Basic transactions

**Prices:**
- Standard retail
- No negotiation
- Reliable availability

#### **Black Market** (Unlockable)
**Services:**
- Better sell prices (+10%)
- Riskier transactions
- Unique items
- Bulk discounts

**Requirements:**
- Unlock at 500 total gold
- Reputation system
- Risk of theft

#### **Auction House** (Future Feature)
**Services:**
- Player-to-player trading
- Dynamic bidding
- Rare items
- Market speculation

---

### Buying and Selling

**Selling Gold:**
1. Visit shop
2. Check current price
3. Choose amount to sell
4. Confirm transaction
5. Receive currency

**Sell Strategy:**
- Check price indicator
- Wait for green (bull/boom)
- Sell in moderate amounts
- Don't flood market

**Buying Tools:**
1. Browse shop inventory
2. Compare stats
3. Check funds
4. Purchase if appropriate

**Buy Strategy:**
- Save for major purchases
- Don't buy impulsively
- Calculate ROI
- Consider repair costs

---

## Economic Strategy

### Early Game Strategy (0-200 gold)

**Focus:**
- Accumulate gold quickly
- Use Basic Pan efficiently
- Sell frequently (don't hoard)
- Save for first upgrade

**Tips:**
- Don't worry about timing early
- Focus on learning mechanics
- Sell when convenient
- Prioritize Gold Pan purchase

### Mid Game Strategy (200-500 gold)

**Focus:**
- Time your sales better
- Invest in tools
- Build reserves
- Plan major purchases

**Tips:**
- Wait for bull markets
- Don't sell in crashes
- Buy tools on schedule
- Keep emergency funds

### Late Game Strategy (500-1000 gold)

**Focus:**
- Maximize profit margins
- Optimize all aspects
- Invest heavily
- Build wealth

**Tips:**
- Only sell in bull/boom
- Buy tools strategically
- Upgrade everything
- Stockpile gold

### End Game Strategy (1000+ gold)

**Focus:**
- Market manipulation
- Helping economy
- Perfect optimization
- Challenge runs

**Tips:**
- Create market opportunities
- Share wealth (multiplayer)
- Experiment with strategies
- Set challenges

---

## Wealth Building

### Income Sources

**Primary:**
- Gold panning (main income)
- Average: 5-10 gold per attempt
- Improved with better tools

**Secondary:**
- Selling old tools
- Finding rare items
- Quest rewards (future)

### Expense Management

**Fixed Costs:**
- Tool repairs
- Supply purchases
- Travel costs
- Shop fees

**Variable Costs:**
- Upgrade purchases
- New tools
- Optional items

**Cost Reduction:**
- Use appropriate tools
- Maintain equipment
- Plan efficiently
- Avoid waste

### Profit Maximization

**Formula:**
```
Profit = (Gold Found × Sell Price) - (Tool Costs + Repairs + Supplies)
```

**Optimization Factors:**
1. Find more gold (better tools, skills)
2. Sell at higher prices (timing)
3. Reduce tool costs (maintenance)
4. Minimize repairs (technique)
5. Buy supplies strategically

### Investment Strategy

**Tool Investment:**
```
ROI = (Increased Income × Tool Life) / Tool Cost
```

**Good Investment:**
- ROI > 100%
- Pays for itself
- Increases earning potential

**Bad Investment:**
- ROI < 50%
- Takes too long to pay off
- Marginal improvement

**Recommended Investments:**
1. Gold Pan (immediate improvement)
2. Professional Pan (solid mid-game)
3. Tool upgrades (incremental gains)
4. Sluice Box (endgame power)

---

## Advanced Economics

### Market Timing

**Bull Market Indicators:**
- Price trending upward
- Multiple green updates
- High demand messages
- Festival announcements

**Sell Signal:**
- Price > 12 currency
- Upward trend continuing
- Have significant gold (50+)

**Hold Signal:**
- Price < 9 currency
- Downward trend
- Recent crash
- Supply glut

### Arbitrage Opportunities

**Location Price Differences:**
- Some locations pay more
- Travel cost vs. profit
- Time value considerations

**Example:**
- Buffalo Brook: 10 currency/gold
- Rich River: 11 currency/gold
- Travel cost: 5 currency
- Break-even: 5 gold minimum

### Risk Management

**Diversification:**
- Don't put all funds in one tool
- Keep emergency reserves
- Multiple income sources

**Insurance:**
- Backup tool (security)
- Emergency repair kit
- Saved gold (cushion)

**Risk Levels:**

| Strategy | Risk | Reward | Best For |
|----------|------|--------|----------|
| Conservative | Low | Low | Beginners |
| Balanced | Medium | Medium | Most players |
| Aggressive | High | High | Experts |
| Speculative | Very High | Very High | End-game |

---

## Economic Events

### Random Events

**Positive Events:**
- **Gold Rush:** Prices +20% for 1 hour
- **Demand Spike:** Prices +15% for 2 hours
- **Festival:** All prices +10% for 4 hours

**Negative Events:**
- **Market Crash:** Prices -20% for 1 hour
- **Oversupply:** Prices -15% for 2 hours
- **Recession:** Prices -10% for 4 hours

### Player-Triggered Events

**Mass Selling:**
- If you sell 100+ gold at once
- Market floods
- Temporary price drop
- Recovers in 1-2 hours

**Hoarding:**
- Don't sell for extended period
- Demand increases
- Better prices later
- Risk: missing opportunities

---

## Tips and Strategies

### General Tips

✅ **DO:**
- Check prices before selling
- Wait for favorable markets
- Plan major purchases
- Track your expenses

❌ **DON'T:**
- Sell large amounts at once
- Buy impulsively
- Ignore market trends
- Waste gold on frivolous items

### Beginner Economics

**First 100 Gold:**
1. Sell frequently (build funds)
2. Don't worry about timing much
3. Save for Gold Pan (primary goal)
4. Learn by doing

**100-500 Gold:**
1. Start timing sales
2. Invest in tools
3. Build reserves
4. Plan ahead

### Expert Economics

**Advanced Techniques:**
- **Price Cycling:** Track full price cycles
- **Optimal Timing:** Math-based sell points
- **Market Making:** Create opportunities
- **Efficiency Max:** Perfect every aspect

**Market Mastery:**
- Predict price movements
- Exploit arbitrage
- Minimize all costs
- Maximize all income

---

## Economic Challenges

### Challenge Runs

**Frugal Run:**
- Beat game spending <500 gold total
- Forces efficiency
- Teaches resource management

**Speed Run:**
- Reach 1000 gold as fast as possible
- Ignore fancy strategies
- Pure efficiency

**Perfectionist:**
- Never sell below 11 currency
- Maximum profit only
- Patience required

---

## Summary

**Key Economic Principles:**
1. Gold value fluctuates (7-15 currency)
2. Timing sales increases profit
3. Tool investment pays off
4. Market trends are predictable
5. Strategy beats impulse

**Success Formula:**
```
Wealth = (Gold Found × Optimal Price) - Minimized Costs + Smart Investments
```

---

[← Back: Tool System](Tool-System.md) | [Next: Development Guide →](Development-Guide.md)
