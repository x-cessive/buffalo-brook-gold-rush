#!/bin/bash

# Buffalo Brook Gold Rush - Game Launcher with Monitoring
# Launches the game and monitors FPS and errors in console output

# Default paths and settings
GAME_NAME="Buffalo Brook Gold Rush"
DEFAULT_GAME_PATH="./buffalo_brook_gold_rush.x86_64"
LOG_DIR="./logs"
FPS_LOG_FILE=""
ERROR_LOG_FILE=""
MONITOR_INTERVAL=1  # Interval in seconds for checking performance

# Performance thresholds
MIN_ACCEPTABLE_FPS=30
MAX_ERROR_COUNT=5
CPU_THRESHOLD=85    # Percentage CPU usage considered high
MEMORY_THRESHOLD=80 # Percentage memory usage considered high

# Flags
DEBUG_MODE=false
VERBOSE_MODE=false
FPS_MONITORING=true
ERROR_MONITORING=true
PERFORMANCE_MONITORING=true
AUTO_RESTART=false

# Variables for monitoring
FPS_SAMPLE_COUNT=0
FPS_TOTAL_SUM=0
FPS_MIN=999
FPS_MAX=0
ERROR_COUNT=0
PERFORMANCE_WARNINGS=0

# Usage function
usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  -h, --help             Show this help message"
    echo "  -g, --game-path PATH   Path to the game executable (default: $DEFAULT_GAME_PATH)"
    echo "  -d, --debug            Enable debug mode"
    echo "  -v, --verbose          Enable verbose output"
    echo "  -l, --log-dir DIR      Directory for log files (default: $LOG_DIR)"
    echo "  -f, --fps-monitor      Enable FPS monitoring (default: true)"
    echo "  -e, --error-monitor    Enable error monitoring (default: true)"
    echo "  -p, --perf-monitor     Enable performance monitoring (default: true)"
    echo "  -r, --auto-restart     Auto-restart if too many errors detected"
    echo "  -i, --interval SEC     Monitor interval in seconds (default: $MONITOR_INTERVAL)"
    echo "  --min-fps NUM          Minimum acceptable FPS (default: $MIN_ACCEPTABLE_FPS)"
    echo "  --cpu-threshold PERC   CPU usage threshold for warnings (default: $CPU_THRESHOLD%)"
    echo "  --mem-threshold PERC   Memory usage threshold for warnings (default: $MEMORY_THRESHOLD%)"
    echo ""
    echo "Examples:"
    echo "  $0                                    # Launch with defaults"
    echo "  $0 -g /path/to/game.x86_64          # Specify game path"
    echo "  $0 -d -v --min-fps 45               # Debug mode with higher FPS target"
    echo "  $0 --cpu-threshold 80 --mem-threshold 75  # Custom thresholds"
    exit 1
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            ;;
        -g|--game-path)
            GAME_PATH="$2"
            shift 2
            ;;
        -d|--debug)
            DEBUG_MODE=true
            VERBOSE_MODE=true
            shift
            ;;
        -v|--verbose)
            VERBOSE_MODE=true
            shift
            ;;
        -l|--log-dir)
            LOG_DIR="$2"
            shift 2
            ;;
        -f|--fps-monitor)
            FPS_MONITORING=true
            shift
            ;;
        -e|--error-monitor)
            ERROR_MONITORING=true
            shift
            ;;
        -p|--perf-monitor)
            PERFORMANCE_MONITORING=true
            shift
            ;;
        -r|--auto-restart)
            AUTO_RESTART=true
            shift
            ;;
        -i|--interval)
            MONITOR_INTERVAL="$2"
            shift 2
            ;;
        --min-fps)
            MIN_ACCEPTABLE_FPS="$2"
            shift 2
            ;;
        --cpu-threshold)
            CPU_THRESHOLD="$2"
            shift 2
            ;;
        --mem-threshold)
            MEMORY_THRESHOLD="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
done

# Use default GAME_PATH if not set
if [ -z "$GAME_PATH" ]; then
    GAME_PATH="$DEFAULT_GAME_PATH"
fi

# Validate game path
if [ ! -f "$GAME_PATH" ]; then
    echo "Error: Game executable not found at $GAME_PATH"
    echo "Please make sure the game file exists or specify the correct path with -g/--game-path"
    exit 1
fi

# Validate game executable permissions
if [ ! -x "$GAME_PATH" ]; then
    echo "Warning: Game executable may not have execute permissions, attempting to set execute permission..."
    chmod +x "$GAME_PATH"
    if [ $? -ne 0 ]; then
        echo "Error: Cannot set execute permissions for the game executable"
        exit 1
    fi
fi

# Create log directory
mkdir -p "$LOG_DIR"

# Generate unique log filenames
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
FPS_LOG_FILE="$LOG_DIR/fps_log_${TIMESTAMP}.txt"
ERROR_LOG_FILE="$LOG_DIR/error_log_${TIMESTAMP}.txt"
PERFORMANCE_LOG_FILE="$LOG_DIR/performance_log_${TIMESTAMP}.txt"
MONITOR_LOG_FILE="$LOG_DIR/monitor_log_${TIMESTAMP}.txt"

# Write log header
{
    echo "# Buffalo Brook Gold Rush - Performance Log"
    echo "# Start Time: $(date)"
    echo "# Game Path: $GAME_PATH"
    echo "# Minimum Acceptable FPS: $MIN_ACCEPTABLE_FPS"
    echo "# CPU Threshold: $CPU_THRESHOLD%"
    echo "# Memory Threshold: $MEMORY_THRESHOLD%"
    echo "# Monitoring FPS: $FPS_MONITORING"
    echo "# Monitoring Errors: $ERROR_MONITORING"
    echo "# Monitoring Performance: $PERFORMANCE_MONITORING"
    echo "# Monitor Interval: $MONITOR_INTERVAL seconds"
    echo ""
} > "$MONITOR_LOG_FILE"

echo "Starting Buffalo Brook Gold Rush Monitor..."
echo "========================================"
echo "Game: $GAME_NAME"
echo "Executable: $GAME_PATH"
echo "Log directory: $LOG_DIR"
echo "FPS log: $FPS_LOG_FILE"
echo "Error log: $ERROR_LOG_FILE"
echo "Performance log: $PERFORMANCE_LOG_FILE"
echo ""

# Function to detect error patterns in output
detect_error_patterns() {
    local line="$1"

    # Array of error patterns to match
    local error_patterns=(
        "ERROR:"
        "error:"
        "Error:"
        "ERROR -"
        "CRITICAL"
        "critical"
        "CRASH"
        "crash"
        "FATAL"
        "assertion failed"
        "Failed to load"
        "missing resource"
        "Invalid resource"
        "shader compilation error"
        "Failed to initialize"
        "out of memory"
        "stack trace"
        "Segmentation fault"
        "exception"
    )

    for pattern in "${error_patterns[@]}"; do
        if [[ "$line" =~ $pattern ]]; then
            echo "$line" >> "$ERROR_LOG_FILE"
            echo "$(date '+%Y-%m-%d %H:%M:%S') - ERROR DETECTED: $line" >> "$MONITOR_LOG_FILE"
            return 0
        fi
    done
    return 1
}

# Function to monitor performance metrics
monitor_performance() {
    local pid=$1
    local cpu_usage=0
    local mem_usage=0
    local vmem_total=0
    local vmem_used=0
    
    if [[ -d "/proc/$pid" ]]; then
        # Get CPU usage
        # Note: Precise CPU calculation would require samples over time
        cpu_usage=$(ps -p "$pid" -o %cpu= 2>/dev/null | sed 's/^[ \t]*//' || echo "0")
        # Sometimes ps returns a value with leading spaces or non-numeric chars
        cpu_usage=$(echo "$cpu_usage" | sed 's/[^0-9.]//g' | head -c 5)
        
        if [[ ! "$cpu_usage" =~ ^[0-9]+\.?[0-9]*$ ]]; then
            cpu_usage=0
        fi
        
        # Get memory usage
        mem_usage=$(ps -p "$pid" -o %mem= 2>/dev/null | sed 's/^[ \t]*//' || echo "0")
        mem_usage=$(echo "$mem_usage" | sed 's/[^0-9.]//g' | head -c 5)
        
        if [[ ! "$mem_usage" =~ ^[0-9]+\.?[0-9]*$ ]]; then
            mem_usage=0
        fi
        
        # Get virtual memory (VmSize) in KB from /proc
        if [[ -f "/proc/$pid/status" ]]; then
            vmem_kb=$(grep VmSize /proc/$pid/status | awk '{print $2}')
            if [[ "$vmem_kb" =~ ^[0-9]+$ ]]; then
                vmem_mb=$((vmem_kb / 1024))
            else
                vmem_mb=0
            fi
        else
            vmem_mb=0
        fi
        
        # Log performance metrics
        echo "$(date '+%Y-%m-%d %H:%M:%S') - CPU: ${cpu_usage}% | MEM: ${mem_usage}% | VMEM: ${vmem_mb}MB" >> "$PERFORMANCE_LOG_FILE"
        
        # Check if performance is outside acceptable ranges
        local issue_detected=false
        local issue_msg="Performance Alert -"
        
        if (( $(echo "$cpu_usage > $CPU_THRESHOLD" | bc -l 2>/dev/null || echo 0) )); then
            issue_detected=true
            issue_msg="${issue_msg} CPU HIGH (${cpu_usage}% > ${CPU_THRESHOLD}%)"
        fi
        
        if (( $(echo "$mem_usage > $MEMORY_THRESHOLD" | bc -l 2>/dev/null || echo 0) )); then
            if $issue_detected; then
                issue_msg="${issue_msg},"
            fi
            issue_msg="${issue_msg} MEM HIGH (${mem_usage}% > ${MEMORY_THRESHOLD}%)"
        fi
        
        if $issue_detected; then
            echo "$issue_msg" >> "$MONITOR_LOG_FILE"
            PERFORMANCE_WARNINGS=$((PERFORMANCE_WARNINGS + 1))
            
            if $VERBOSE_MODE; then
                echo "Performance Warning: $issue_msg"
            fi
        fi
        
        if $DEBUG_MODE; then
            echo "Debug: CPU=${cpu_usage}%, MEM=${mem_usage}%, VMEM=${vmem_mb}MB"
        fi
    fi
}

# Temporary file to capture game output
TEMP_OUTPUT=$(mktemp)

# Start monitoring the game
echo "Starting game with monitoring..."
echo "=================================="

# Launch the game in the background and redirect output to temp file
{
    "$GAME_PATH" 2>&1 | tee "$TEMP_OUTPUT" &
    GAME_PID=$!
} &

echo "Game started with PID: $GAME_PID"
echo "Monitoring started..."

# Start monitoring FPS and errors
SAMPLE_COUNT=0
TOTAL_FPS_ACCUM=0

# Monitor the game while it's running
while kill -0 "$GAME_PID" 2>/dev/null; do
    # Sleep for the specified interval
    sleep "$MONITOR_INTERVAL"
    
    # Monitor performance if enabled
    if $PERFORMANCE_MONITORING; then
        monitor_performance "$GAME_PID"
    fi
    
    # Get process information for basic monitoring
    if [[ -f "/proc/$GAME_PID/stat" ]]; then
        # Log that we are actively monitoring
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Monitoring game process (PID: $GAME_PID)" >> "$MONITOR_LOG_FILE"
    fi
    
    # Check for new errors in output
    if $ERROR_MONITORING; then
        # Process new output lines looking for errors
        recent_lines=$(tail -n 10 "$TEMP_OUTPUT" 2>/dev/null || echo "")
        while IFS= read -r line; do
            if [ -n "$line" ]; then
                detect_error_patterns "$line"
                
                # Also check if line contains FPS information (if the game outputs it)
                if [[ "$line" =~ "FPS:" ]] || [[ "$line" =~ "fps" ]]; then
                    # Extract FPS value - could be in various formats like "FPS: 60", "Current FPS: 59.5", etc.
                    fps_value=$(echo "$line" | grep -oE '[0-9]+\.?[0-9]*' | head -1 2>/dev/null || echo 0)
                    if [ "$fps_value" -gt 0 ] && [ "$fps_value" -lt 300 ]; then  # Reasonable upper bound
                        echo "$fps_value" >> "$FPS_LOG_FILE"
                        
                        # Update FPS statistics
                        TOTAL_FPS_ACCUM=$(echo "$TOTAL_FPS_ACCUM + $fps_value" | bc -l 2>/dev/null || echo $fps_value)
                        SAMPLE_COUNT=$((SAMPLE_COUNT + 1))
                        
                        if [ "$fps_value" -lt "$FPS_MIN" ]; then
                            FPS_MIN="$fps_value"
                        fi
                        if [ "$fps_value" -gt "$FPS_MAX" ]; then
                            FPS_MAX="$fps_value"
                        fi
                        
                        # Log FPS to monitor log
                        echo "$(date '+%Y-%m-%d %H:%M:%S') - FPS: $fps_value" >> "$MONITOR_LOG_FILE"
                        
                        if $VERBOSE_MODE; then
                            echo "FPS Reading: $fps_value"
                        fi
                        
                        # Check if FPS is below acceptable threshold
                        if [ "$fps_value" -lt "$MIN_ACCEPTABLE_FPS" ]; then
                            echo "$(date '+%Y-%m-%d %H:%M:%S') - WARNING: FPS below threshold: $fps_value < $MIN_ACCEPTABLE_FPS" >> "$MONITOR_LOG_FILE"
                            if $VERBOSE_MODE; then
                                echo "FPS Warning: $fps_value FPS < $MIN_ACCEPTABLE_FPS FPS threshold"
                            fi
                        fi
                    fi
                fi
            fi
        done <<< "$recent_lines"
    fi
done

# Get exit code from the game
wait $GAME_PID
GAME_EXIT_CODE=$?

echo "Game exited with code: $GAME_EXIT_CODE"

# Process final output for any remaining errors/FPS data
if $ERROR_MONITORING && [ -f "$TEMP_OUTPUT" ]; then
    while IFS= read -r line; do
        if [ -n "$line" ]; then
            detect_error_patterns "$line"
            
            # Check for FPS data in final output
            if [[ "$line" =~ "FPS:" ]] || [[ "$line" =~ "fps" ]]; then
                fps_value=$(echo "$line" | grep -oE '[0-9]+\.?[0-9]*' | head -1 2>/dev/null || echo 0)
                if [ "$fps_value" -gt 0 ] && [ "$fps_value" -lt 300 ]; then
                    echo "$fps_value" >> "$FPS_LOG_FILE"
                    
                    # Update FPS statistics
                    TOTAL_FPS_ACCUM=$(echo "$TOTAL_FPS_ACCUM + $fps_value" | bc -l 2>/dev/null || echo $fps_value)
                    SAMPLE_COUNT=$((SAMPLE_COUNT + 1))
                    
                    if [ "$fps_value" -lt "$FPS_MIN" ]; then
                        FPS_MIN="$fps_value"
                    fi
                    if [ "$fps_value" -gt "$FPS_MAX" ]; then
                        FPS_MAX="$fps_value"
                    fi
                    
                    # Log FPS to monitor log
                    echo "$(date '+%Y-%m-%d %H:%M:%S') - FPS: $fps_value" >> "$MONITOR_LOG_FILE"
                fi
            fi
        fi
    done < "$TEMP_OUTPUT"
fi

# Final reporting with summary log
SUMMARY_LOG_FILE="$LOG_DIR/summary_${TIMESTAMP}.txt"

# Write summary to file
{
    echo "BUFFALO BROOK GOLD RUSH - MONITORING SUMMARY"
    echo "==========================================="
    echo "Start Time: $(stat -c '%y' "$MONITOR_LOG_FILE")"
    echo "End Time: $(date)"
    echo "Game Executable: $GAME_PATH"
    echo "Game Exit Code: $GAME_EXIT_CODE"
    echo ""
    
    if [ -f "$ERROR_LOG_FILE" ]; then
        ERROR_COUNT=$(wc -l < "$ERROR_LOG_FILE")
        echo "ERROR ANALYSIS"
        echo "------------"
        echo "Errors Detected: $ERROR_COUNT"
        if [ "$ERROR_COUNT" -gt 0 ]; then
            # Show top errors
            echo "Most Common Error Types:"
            grep -i "error\|critical\|crash\|fatal" "$ERROR_LOG_FILE" | \
            grep -oE "[Ee][Rr][Rr][Oo][Rr]:|[Cc][Rr][Ii][Tt][Ii][Cc][Aa][Ll]|[Cc][Rr][Aa][Ss][Hh]|[Ff][Aa][Tt][Aa][Ll]" | \
            sort | uniq -c | sort -nr | head -5
        fi
        echo ""
    fi
    
    if [ "$PERFORMANCE_WARNINGS" -gt 0 ]; then
        echo "PERFORMANCE ANALYSIS"
        echo "------------------"
        echo "Performance Warnings: $PERFORMANCE_WARNINGS"
        echo ""
    else
        echo "PERFORMANCE ANALYSIS"
        echo "------------------"
        echo "Performance Warnings: 0"
        echo ""
    fi
    
    if $FPS_MONITORING && [ -f "$FPS_LOG_FILE" ] && [ -s "$FPS_LOG_FILE" ]; then
        TOTAL_SAMPLES=$(wc -l < "$FPS_LOG_FILE")
        if [ "$TOTAL_SAMPLES" -gt 0 ]; then
            AVG_FPS=$(awk '{ sum += $1; n++ } END { if (n > 0) print sum / n; else print 0 }' "$FPS_LOG_FILE" 2>/dev/null)
            MIN_FPS=$(sort -n "$FPS_LOG_FILE" 2>/dev/null | head -n1)
            MAX_FPS=$(sort -nr "$FPS_LOG_FILE" 2>/dev/null | head -n1)
            
            echo "FPS STATISTICS"
            echo "------------"
            echo "Total Samples: $TOTAL_SAMPLES"
            echo "Average FPS: ${AVG_FPS:-0}"
            echo "Min FPS: ${MIN_FPS:-0}"
            echo "Max FPS: ${MAX_FPS:-0}"
            echo "Target Min FPS: $MIN_ACCEPTABLE_FPS"
            
            if [[ "$AVG_FPS" =~ ^[0-9]+\.?[0-9]*$ ]] && [ "$(echo "$AVG_FPS < $MIN_ACCEPTABLE_FPS" | bc -l 2>/dev/null)" = "1" ]; then
                echo "Status: BELOW TARGET PERFORMANCE"
                echo "Issue: Average FPS ($AVG_FPS) is below target ($MIN_ACCEPTABLE_FPS)"
            elif [ "$AVG_FPS" != "0" ]; then
                echo "Status: MEETING PERFORMANCE TARGETS"
            fi
        else
            echo "FPS STATISTICS"
            echo "------------"
            echo "No FPS data captured (game may not output FPS to console)"
        fi
        echo ""
    else
        echo "FPS STATISTICS"
        echo "------------"
        echo "Monitoring: Disabled or no FPS data captured"
        echo ""
    fi
    
    if [ -f "$PERFORMANCE_LOG_FILE" ]; then
        echo "SYSTEM RESOURCE USAGE"
        echo "-------------------"
        # Calculate average CPU/MEM usage from performance log
        if [ -s "$PERFORMANCE_LOG_FILE" ]; then
            # Extract CPU usage values (third field after timestamp)
            cpu_values=$(awk -F'[ :%,]' '{for(i=1;i<=NF;i++) if($i ~ /^[0-9]+$/ && $(i+1)=="CPU") print $(i+2)}' "$PERFORMANCE_LOG_FILE" 2>/dev/null)
            if [ -n "$cpu_values" ]; then
                avg_cpu=$(echo "$cpu_values" | awk '{sum += $1; n++} END {if(n > 0) printf "%.2f", sum / n}')
                max_cpu=$(echo "$cpu_values" | sort -nr | head -n1)
                echo "Avg CPU Usage: ${avg_cpu:-0}%"
                echo "Max CPU Usage: ${max_cpu:-0}%"
            fi
            
            # Extract MEM usage values (fifth field after timestamp)
            mem_values=$(awk -F'[ :%,]' '{for(i=1;i<=NF;i++) if($i ~ /^[0-9]+$/ && $(i+1)=="MEM") print $(i+2)}' "$PERFORMANCE_LOG_FILE" 2>/dev/null)
            if [ -n "$mem_values" ]; then
                avg_mem=$(echo "$mem_values" | awk '{sum += $1; n++} END {if(n > 0) printf "%.2f", sum / n}')
                max_mem=$(echo "$mem_values" | sort -nr | head -n1)
                echo "Avg MEM Usage: ${avg_mem:-0}%"
                echo "Max MEM Usage: ${max_mem:-0}%"
            fi
        else
            echo "No performance data captured"
        fi
        echo ""
    fi
    
    echo "RECOMMENDATIONS"
    echo "-------------"
    if [[ "$AVG_FPS" =~ ^[0-9]+\.?[0-9]*$ ]] && [ "$(echo "$AVG_FPS < $MIN_ACCEPTABLE_FPS" | bc -l 2>/dev/null)" = "1" ]; then
        echo "- Performance optimization needed: Current FPS is below target"
        echo "- Consider lowering graphics settings or optimizing asset loading"
    fi
    
    if [ "$ERROR_COUNT" -gt 0 ]; then
        echo "- Check error log for specific issues that need addressing"
    fi
    
    if [ "$avg_cpu" ] && (( $(echo "$avg_cpu > $CPU_THRESHOLD" | bc -l 2>/dev/null || echo 0) )); then
        echo "- High CPU usage detected: Consider optimization or hardware upgrade"
    fi
    
    if [ "$avg_mem" ] && (( $(echo "$avg_mem > $MEMORY_THRESHOLD" | bc -l 2>/dev/null || echo 0) )); then
        echo "- High memory usage detected: Monitor for memory leaks"
    fi
    
    echo ""
    echo "LOG FILES LOCATION"
    echo "------------------"
    echo "All logs saved to: $LOG_DIR/"
    echo "- Main log: $(basename "$MONITOR_LOG_FILE")"
    if [ -f "$FPS_LOG_FILE" ]; then
        echo "- FPS log: $(basename "$FPS_LOG_FILE")"
    fi
    if [ -s "$ERROR_LOG_FILE" ]; then
        echo "- Error log: $(basename "$ERROR_LOG_FILE")"
        echo "  Errors found: $ERROR_COUNT"
    fi
    if [ -f "$PERFORMANCE_LOG_FILE" ]; then
        echo "- Performance log: $(basename "$PERFORMANCE_LOG_FILE")"
    fi
    echo "- Summary: $(basename "$SUMMARY_LOG_FILE")"
    
    echo ""
    echo "Generated on: $(date)"
} > "$SUMMARY_LOG_FILE"

# Print summary to console
echo ""
echo "=================================="
echo "MONITORING SUMMARY"
echo "=================================="
cat "$SUMMARY_LOG_FILE" | head -n 10  # Show first part of summary

echo ""
echo "Full summary available in: $SUMMARY_LOG_FILE"
echo "Complete logs available in: $LOG_DIR/"

# Cleanup temporary file
rm -f "$TEMP_OUTPUT"

echo ""
echo "Monitoring completed. Exiting."

# Exit with the game's exit code
exit $GAME_EXIT_CODE