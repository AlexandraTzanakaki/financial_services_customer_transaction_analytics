-- Risk & Anomaly Analysis
-- Financial Services Customer & Transaction Analytics
-- Negative balance overview

SELECT
    COUNT(*) AS negative_balance_transactions,
    ROUND(
        COUNT(*) * 100.0
        / (SELECT COUNT(*) FROM trans),
        2
    ) AS percentage_of_transactions
FROM trans
WHERE balance < 0;
-- Accounts affected by negative balances

SELECT
    COUNT(*) AS affected_accounts,
    MIN(negative_balance_count) AS minimum_negative_balance_count,
    MAX(negative_balance_count) AS maximum_negative_balance_count,
    ROUND(
        AVG(negative_balance_count)::numeric,
        2
    ) AS average_negative_balance_count,
    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY negative_balance_count)::numeric,
        2
    ) AS median_negative_balance_count
FROM (
    SELECT
        account_id,
        COUNT(*) AS negative_balance_count
    FROM trans
    WHERE balance < 0
    GROUP BY account_id
) AS account_negative_balances;
-- Negative balance rate by account

SELECT
    account_id,
    negative_balance_count,
    total_transaction_count,
    ROUND(
        negative_balance_count * 100.0
        / total_transaction_count,
        2
    ) AS negative_balance_rate_pct
FROM (
    SELECT
        account_id,
        COUNT(*) FILTER (WHERE balance < 0) AS negative_balance_count,
        COUNT(*) AS total_transaction_count
    FROM trans
    GROUP BY account_id
) AS account_activity
WHERE negative_balance_count > 0
ORDER BY negative_balance_rate_pct DESC;
-- Transactions above the 99th percentile

SELECT
    COUNT(*) AS large_transaction_count,
    ROUND(
        COUNT(*) * 100.0
        / (SELECT COUNT(*) FROM trans),
        2
    ) AS percentage_of_transactions,
    ROUND(
        (
            SELECT
                PERCENTILE_CONT(0.99)
                WITHIN GROUP (ORDER BY amount)
            FROM trans
        )::numeric,
        2
    ) AS percentile_99_threshold
FROM trans
WHERE amount > (
    SELECT
        PERCENTILE_CONT(0.99)
        WITHIN GROUP (ORDER BY amount)
    FROM trans
);
-- Validate the 99th percentile transaction threshold

SELECT
    ROUND(
        PERCENTILE_CONT(0.99)
        WITHIN GROUP (ORDER BY amount)::numeric,
        2
    ) AS percentile_99_threshold,
    COUNT(*) AS large_transaction_count,
    ROUND(
        COUNT(*) * 100.0
        / (SELECT COUNT(*) FROM trans),
        2
    ) AS percentage_of_transactions
FROM trans
WHERE amount > (
    SELECT
        PERCENTILE_CONT(0.99)
        WITHIN GROUP (ORDER BY amount)
    FROM trans
);
-- Validate the 99th percentile transaction threshold

SELECT
    ROUND(
        percentile_data.threshold::numeric,
        2
    ) AS percentile_99_threshold,
    COUNT(*) AS large_transaction_count,
    ROUND(
        COUNT(*) * 100.0
        / (SELECT COUNT(*) FROM trans),
        2
    ) AS percentage_of_transactions
FROM trans AS t
CROSS JOIN (
    SELECT
        PERCENTILE_CONT(0.99)
        WITHIN GROUP (ORDER BY amount) AS threshold
    FROM trans
) AS percentile_data
WHERE t.amount > percentile_data.threshold
GROUP BY percentile_data.threshold;
-- Accounts with both anomaly indicators

SELECT
    COUNT(*) AS accounts_with_both_indicators
FROM (
    SELECT
        t.account_id
    FROM trans AS t
    GROUP BY t.account_id
    HAVING
        COUNT(*) FILTER (
            WHERE t.balance < 0
        ) > 0
        AND
        COUNT(*) FILTER (
            WHERE t.amount > (
                SELECT
                    PERCENTILE_CONT(0.99)
                    WITHIN GROUP (ORDER BY amount)
                FROM trans
            )
        ) > 0
) AS accounts_with_indicators;
-- Activity profile of accounts with both anomaly indicators

SELECT
    account_id,
    negative_balance_count,
    total_transaction_count,
    ROUND(
        negative_balance_count * 100.0
        / total_transaction_count,
        2
    ) AS negative_balance_rate_pct,
    large_transaction_count
FROM (
    SELECT
        t.account_id,
        COUNT(*) FILTER (
            WHERE t.balance < 0
        ) AS negative_balance_count,
        COUNT(*) AS total_transaction_count,
        COUNT(*) FILTER (
            WHERE t.amount > (
                SELECT
                    PERCENTILE_CONT(0.99)
                    WITHIN GROUP (ORDER BY amount)
                FROM trans
            )
        ) AS large_transaction_count
    FROM trans AS t
    GROUP BY t.account_id
) AS account_metrics
WHERE negative_balance_count > 0
  AND large_transaction_count > 0
ORDER BY negative_balance_rate_pct DESC;
-- Large transactions with negative recorded balances

SELECT
    COUNT(*) AS large_negative_balance_transactions,
    ROUND(
        COUNT(*) * 100.0
        / (SELECT COUNT(*) FROM trans),
        2
    ) AS percentage_of_transactions
FROM trans AS t
WHERE t.balance < 0
  AND t.amount > (
      SELECT
          PERCENTILE_CONT(0.99)
          WITHIN GROUP (ORDER BY amount)
      FROM trans
  );
  -- Large transactions with negative recorded balances

SELECT
    trans_id,
    account_id,
    date,
    type,
    operation,
    amount,
    balance
FROM trans AS t
WHERE t.balance < 0
  AND t.amount > (
      SELECT
          PERCENTILE_CONT(0.99)
          WITHIN GROUP (ORDER BY amount)
      FROM trans
  )
ORDER BY amount DESC;