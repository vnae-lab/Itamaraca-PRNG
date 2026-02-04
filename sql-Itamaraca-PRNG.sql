/* ITAMARACÁ (ITA) PRNG - SQL Implementation
   Generates 10,000 pseudo-random numbers using Recursive CTE.
   Formula: FRNS = ABS(N - (ABS(S2 - S0) * lambda))
*/

WITH RECURSIVE itamaraca_sequence AS (
    -- 1. Anchor Member: Define initial seeds and starting parameters
    SELECT 
        1 AS idx,
        800.0 AS s0,           -- Seed 0
        25.0 AS s1,            -- Seed 1
        3005.0 AS s2,          -- Seed 2 (The starting value for the sequence)
        10000.0 AS max_range,  -- N value
        1.97 AS lambda         -- Lambda constant
    
    UNION ALL
    
    -- 2. Recursive Member: Calculate next value based on the previous state
    SELECT 
        idx + 1,
        s1,                    -- New S0 is old S1
        s2,                    -- New S1 is old S2
        -- Pn = ABS(S2 - S0) -> FRNS = ABS(N - (Pn * lambda))
        ABS(max_range - (ABS(s2 - s0) * lambda)) AS s2,
        max_range,
        lambda
    FROM itamaraca_sequence
    WHERE idx < 10000          -- Stop after 10,000 iterations
)
-- 3. Final Selection: Export results for Bar/Line chart analysis
SELECT 
    idx AS iteration_index,
    s2 AS generated_value
FROM itamaraca_sequence;
