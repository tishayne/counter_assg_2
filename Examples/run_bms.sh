#!/bin/bash
# =============================================================================
# Benchmark Shell Script
# Partly created with claude ai to ensure pretty output
# =============================================================================

SRC_DIR="."
BIN_DIR="./bin"
N=10000000
THREAD_COUNTS=(2 4 8 16)
CLASSES=("Counter" "CounterAtomic" "CounterBakery" "CounterFilter" "CounterLock" "CounterMonitor")

# ---- Setup ------------------------------------------------------------------
mkdir -p "$BIN_DIR"

echo "============================================================"
echo "  Start "
echo "  N = $N   T in {${THREAD_COUNTS[*]}}"
echo "============================================================"
echo ""

# ---- Compile ----------------------------------------------------------------
echo "[1/2] Compiling sources..."
javac -d "$BIN_DIR" "$SRC_DIR"/*.java
if [ $? -ne 0 ]; then
    echo "ERROR: Compilation failed. Aborting."
    exit 1
fi
echo "      Done."
echo ""

echo "[2/2] Running benchmarks..."
echo ""

# Table
printf "%-20s %6s %12s %12s\n" "Implementation" "T" "Result" "Time (ms)"
printf "%-20s %6s %12s %12s\n" "--------------------" "------" "------------" "----------"

{
    echo "N = $N,  T in {${THREAD_COUNTS[*]}}"
    echo "Run on: $(date)"
    echo ""
    printf "%-20s %6s %12s %12s\n" "Implementation" "T" "Result" "Time (ms)"
    printf "%-20s %6s %12s %12s\n" "--------------------" "------" "------------" "----------"
}

for CLASS in "${CLASSES[@]}"; do
    for T in "${THREAD_COUNTS[@]}"; do

        OUTPUT=$(java -cp "$BIN_DIR" "counters.Examples.$CLASS" "$T" "$N" 2>&1)

         FINISHED_LINE=$(echo "$OUTPUT" | grep "Finished")

        # Extract final counter value: everything after "total of", take first token
        RESULT=$(echo "$FINISHED_LINE" | sed 's/.*total of //' | sed 's/ .*//')


        TIME_MS=$(echo "$FINISHED_LINE" | sed 's/.* in //' | sed 's/ ms.*//')

        [ -z "$TIME_MS" ] && TIME_MS="ERR"
        [ -z "$RESULT"  ] && RESULT="ERR"

        printf "%-20s %6s %12s %12s\n" "$CLASS" "$T" "$RESULT" "$TIME_MS"
    done
    echo ""
done


