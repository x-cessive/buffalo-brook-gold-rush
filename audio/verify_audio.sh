#!/bin/bash
# Buffalo Brook Gold Rush - Sound Verification Script

# This script helps verify that all required audio files have been downloaded
# Run this after downloading all sounds to check completeness

AUDIO_DIR="/home/director/homelab/GameDev/Buffalo Brook Gold Rush/audio"

echo "Verifying audio files for Buffalo Brook Gold Rush..."
echo "Expected audio directory: $AUDIO_DIR"
echo

# Check if main audio directory exists
if [ ! -d "$AUDIO_DIR" ]; then
    echo "ERROR: Audio directory does not exist!"
    echo "Path: $AUDIO_DIR"
    exit 1
fi

echo "Audio directory found."
echo

# Function to check files in a subdirectory
check_directory() {
    local dir_path="$1"
    local expected_files=("${@:2}")
    local missing_files=()
    
    echo "Checking directory: $dir_path"
    
    if [ ! -d "$dir_path" ]; then
        echo "  WARNING: Directory does not exist"
        return
    fi
    
    for file in "${expected_files[@]}"; do
        if [ ! -f "$dir_path/$file" ]; then
            missing_files+=("$file")
        else
            # Check if file is not empty (or has minimum size)
            if [ -s "$dir_path/$file" ]; then
                echo "  ✓ $file (OK)"
            else
                missing_files+=("$file (empty file)")
            fi
        fi
    done
    
    if [ ${#missing_files[@]} -eq 0 ]; then
        echo "  All files present"
    else
        echo "  MISSING FILES:"
        for file in "${missing_files[@]}"; do
            echo "    - $file"
        done
    fi
    echo
}

# Define expected files for each category
PANNING_WATER_FILES=(
    "pan_water_slosh_01.wav"
    "pan_water_slosh_02.wav"
    "pan_water_slosh_03.wav"
    "pan_swirl_01.wav"
    "pan_tilt_01.wav"
    "pan_tilt_02.wav"
)

PANNING_PARTICLES_FILES=(
    "sediment_wash_01.wav"
    "sediment_wash_02.wav"
    "particles_shake_01.wav"
    "particles_settle_01.wav"
)

PANNING_SUCCESS_FILES=(
    "gold_clink_01.wav"
    "gold_clink_02.wav"
    "gold_discovery_01.wav"
    "gold_discovery_02.wav"
    "nugget_drop_01.wav"
    "pan_empty_01.wav"
    "pan_empty_02.wav"
)

ENVIRONMENT_WATER_LOOPS_FILES=(
    "brook_stream_loop_01.wav"
    "brook_stream_loop_02.wav"
    "brook_stream_loop_03.wav"
    "waterfall_small_loop_01.wav"
)

ENVIRONMENT_WILDLIFE_FILES=(
    "bird_willow_titmouse_01.wav"
    "bird_willow_titmouse_02.wav"
    "bird_song_sparrow_01.wav"
    "wood_pecker_tapping_01.wav"
    "wood_pecker_tapping_02.wav"
    "insect_cicada_01.wav"
    "insect_cricket_01.wav"
    "insect_cricket_02.wav"
    "frog_pacific_chorus_01.wav"
    "frog_pacific_chorus_02.wav"
)

FOOTSTEPS_SURFACES_FILES=(
    "footstep_gravel_01.wav"
    "footstep_gravel_02.wav"
    "footstep_gravel_03.wav"
    "footstep_gravel_04.wav"
    "footstep_dirt_01.wav"
    "footstep_dirt_02.wav"
    "footstep_leaves_01.wav"
    "footstep_leaves_02.wav"
    "footstep_grass_01.wav"
    "footstep_grass_02.wav"
    "footstep_mud_01.wav"
    "footstep_mud_02.wav"
    "footstep_water_puddle_01.wav"
    "footstep_water_puddle_02.wav"
    "footstep_stone_01.wav"
    "footstep_stone_02.wav"
    "footstep_sand_01.wav"
    "footstep_sand_02.wav"
)

TOOLS_PAN_FILES=(
    "pan_metal_clank_01.wav"
    "pan_metal_clank_02.wav"
    "pan_scrape_stone_01.wav"
    "pan_scrape_stone_02.wav"
    "pan_drop_01.wav"
    "pan_lift_01.wav"
    "pan_tap_edge_01.wav"
    "pan_tap_edge_02.wav"
)

# Run checks for each directory
check_directory "$AUDIO_DIR/panning/water" "${PANNING_WATER_FILES[@]}"
check_directory "$AUDIO_DIR/panning/particles" "${PANNING_PARTICLES_FILES[@]}"
check_directory "$AUDIO_DIR/panning/success" "${PANNING_SUCCESS_FILES[@]}"
check_directory "$AUDIO_DIR/environment/water_loops" "${ENVIRONMENT_WATER_LOOPS_FILES[@]}"
check_directory "$AUDIO_DIR/environment/wildlife" "${ENVIRONMENT_WILDLIFE_FILES[@]}"
check_directory "$AUDIO_DIR/footsteps/surfaces" "${FOOTSTEPS_SURFACES_FILES[@]}"
check_directory "$AUDIO_DIR/tools/pan" "${TOOLS_PAN_FILES[@]}"

echo "Verification complete!"
echo
echo "If you see missing files, follow the instructions in download_instructions.md"
echo "to obtain the required audio files from free sources."