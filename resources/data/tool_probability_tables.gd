## Probability tables for tool types in Buffalo Brook Gold Rush
## These tables define how different tools affect gold discovery rates

# Tool Types
enum ToolType {
	BASIC_PAN = 0,      # Basic metal pan (starting tool)
	WOODEN_PAN = 1,     # Traditional wooden pan
	PROFESSIONAL_PAN = 2, # Refined metal pan with better design
	SLUICE_BOX = 3,     # Advanced tool for processing more sediment
	GOLD_MINE_KIT = 4   # Premium professional equipment
}

# Gold discovery probability multipliers by tool type
# These values modify the base gold discovery chance
const TOOL_PROBABILITY_TABLE = {
	ToolType.BASIC_PAN: 1.0,         # 100% of base chance (reference)
	ToolType.WOODEN_PAN: 1.2,        # 120% of base chance
	ToolType.PROFESSIONAL_PAN: 1.5,  # 150% of base chance
	ToolType.SLUICE_BOX: 2.0,        # 200% of base chance (processes more material)
	ToolType.GOLD_MINE_KIT: 2.5      # 250% of base chance (premium tool)
}

# Efficiency multipliers (affects how fast particles separate)
const TOOL_EFFICIENCY_TABLE = {
	ToolType.BASIC_PAN: 1.0,         # Standard efficiency
	ToolType.WOODEN_PAN: 1.1,        # Slightly more efficient
	ToolType.PROFESSIONAL_PAN: 1.3,  # More efficient separation
	ToolType.SLUICE_BOX: 1.8,        # Highly efficient (processes more material)
	ToolType.GOLD_MINE_KIT: 2.2      # Maximum efficiency
}

# Durability modifiers (how quickly tool degrades)
const TOOL_DURABILITY_TABLE = {
	ToolType.BASIC_PAN: 1.0,         # Standard durability
	ToolType.WOODEN_PAN: 0.8,        # Less durable (can break)
	ToolType.PROFESSIONAL_PAN: 1.2,  # More durable
	ToolType.SLUICE_BOX: 0.7,        # Less portable, more fragile
	ToolType.GOLD_MINE_KIT: 1.5      # Premium durability
}

# Gold quality multipliers (affects value of gold found)
const TOOL_QUALITY_TABLE = {
	ToolType.BASIC_PAN: 1.0,         # Standard gold quality
	ToolType.WOODEN_PAN: 1.0,        # Same quality as basic
	ToolType.PROFESSIONAL_PAN: 1.1,  # Slightly higher quality finds
	ToolType.SLUICE_BOX: 1.0,        # Same quality, more quantity
	ToolType.GOLD_MINE_KIT: 1.3      # Higher quality gold finds
}

# Special find probability by tool type (chance to find gems/artifacts)
const TOOL_SPECIAL_FIND_TABLE = {
	ToolType.BASIC_PAN: 0.05,        # 5% chance of special finds
	ToolType.WOODEN_PAN: 0.08,       # 8% chance
	ToolType.PROFESSIONAL_PAN: 0.12, # 12% chance
	ToolType.SLUICE_BOX: 0.15,       # 15% chance (processes more material)
	ToolType.GOLD_MINE_KIT: 0.25     # 25% chance (premium detection)
}

# Panning technique bonus (how much player technique affects results)
const TOOL_TECHNIQUE_BONUS_TABLE = {
	ToolType.BASIC_PAN: 0.3,         # Technique has moderate effect
	ToolType.WOODEN_PAN: 0.4,        # Technique has moderate effect
	ToolType.PROFESSIONAL_PAN: 0.6,  # Technique has higher effect
	ToolType.SLUICE_BOX: 0.2,        # Technique has lesser effect (tool does more work)
	ToolType.GOLD_MINE_KIT: 0.4      # Technique still has moderate effect (precision needed)
}

# Example usage in code:
# var tool_multiplier = TOOL_PROBABILITY_TABLE[current_tool_type]
# var efficiency = TOOL_EFFICIENCY_TABLE[current_tool_type]