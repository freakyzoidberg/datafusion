-- Every query reads this view, so rows are generated inside the timed query.
-- The % keeps the optimizer from proving any column but seq sorted, so only q07
-- takes the pre-ordered path.
CREATE VIEW first_last AS
SELECT
  -- interleaved: rows / 10 groups, consecutive rows hit different groups
  value % (${FIRST_LAST_ROWS:-50000000} / 10) AS g,
  -- 1000 interleaved groups
  value % 1000 AS g1k,
  -- sorted, as range() declares
  value AS seq,
  -- unique and unsorted: a pseudo-random bucket, then the row number
  (value * value % 1009) * ${FIRST_LAST_ROWS:-50000000} + value AS k,
  (value * value % 1013) * ${FIRST_LAST_ROWS:-50000000} + value AS x
FROM range(${FIRST_LAST_ROWS:-50000000});
