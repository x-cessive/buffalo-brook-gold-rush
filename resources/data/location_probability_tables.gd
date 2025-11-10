## Probability tables for location difficulty in Buffalo Brook Gold Rush
## These tables define how location difficulty affects gold discovery rates

# Location Difficulty Types
enum LocationDifficulty {
	VERY_EASY = 0,    # Abundant gold, beginner-friendly
	EASY = 1,         # Good gold density, suitable for intermediate
	MODERATE = 2,     # Average gold density, standard challenge
	DIFFICULT = 3,    # Lower gold density, requires skill
	VERY_DIFFICULT = 4 # Rare gold, maximum challenge
}

# Gold discovery probability multipliers by location difficulty
# These values modify the base gold discovery chance
const LOCATION_PROBABILITY_TABLE = {
	LocationDifficulty.VERY_EASY: 1.8,     # 180% of base chance
	LocationDifficulty.EASY: 1.4,          # 140% of base chance
	LocationDifficulty.MODERATE: 1.0,      # 100% of base chance (reference)
	LocationDifficulty.DIFFICULT: 0.6,     # 60% of base chance
	LocationDifficulty.VERY_DIFFICULT: 0.3 # 30% of base chance
}

# Base gold amounts by location difficulty (min, max)
const LOCATION_GOLD_RANGE_TABLE = {
	LocationDifficulty.VERY_EASY: {"min": 5, "max": 10},
	LocationDifficulty.EASY: {"min": 3, "max": 7},
	LocationDifficulty.MODERATE: {"min": 2, "max": 5},
	LocationDifficulty.DIFFICULT: {"min": 1, "max": 3},
	LocationDifficulty.VERY_DIFFICULT: {"min": 0, "max": 2}
}

# Sediment density multipliers (affects how much sediment to separate)
const LOCATION_SEDIMENT_DENSITY_TABLE = {
	LocationDifficulty.VERY_EASY: 0.7,     # Less sediment to dig through
	LocationDifficulty.EASY: 0.85,         # Moderate sediment
	LocationDifficulty.MODERATE: 1.0,      # Standard sediment amount
	LocationDifficulty.DIFFICULT: 1.2,     # More sediment to work through
	LocationDifficulty.VERY_DIFFICULT: 1.5 # Maximum sediment density
}

# Panning time modifiers (how long panning takes)
const LOCATION_TIME_MODIFIER_TABLE = {
	LocationDifficulty.VERY_EASY: 0.8,     # Faster panning
	LocationDifficulty.EASY: 0.9,          # Slightly faster
	LocationDifficulty.MODERATE: 1.0,      # Standard time
	LocationDifficulty.DIFFICULT: 1.1,     # Slightly longer
	LocationDifficulty.VERY_DIFFICULT: 1.3 # Much longer panning
}

# Special find probability (gems, artifacts) by location difficulty
const LOCATION_SPECIAL_FIND_TABLE = {
	LocationDifficulty.VERY_EASY: 0.05,    # 5% chance of special finds
	LocationDifficulty.EASY: 0.1,          # 10% chance
	LocationDifficulty.MODERATE: 0.15,     # 15% chance
	LocationDifficulty.DIFFICULT: 0.25,    # 25% chance
	LocationDifficulty.VERY_DIFFICULT: 0.35 # 35% chance of special finds
}

# Example usage in code:
# var discovery_multiplier = LOCATION_PROBABILITY_TABLE[current_location_difficulty]
# var gold_range = LOCATION_GOLD_RANGE_TABLE[current_location_difficulty]