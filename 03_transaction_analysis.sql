-- Transaction count by transaction type

SELECT
    type,
    COUNT(*) AS transaction_count
FROM trans
GROUP BY type
ORDER BY transaction_count DESC;
-- Total transaction value by transaction type

SELECT
    type,
    COUNT(*) AS transaction_count,
    SUM(amount) AS total_transaction_value,
    AVG(amount) AS average_transaction_value
FROM trans
GROUP BY type
ORDER BY total_transaction_value DESC;
-- Transaction activity by year

SELECT
    EXTRACT(YEAR FROM TO_DATE(date::TEXT, 'YYMMDD')) AS transaction_year,
    COUNT(*) AS transaction_count,
    SUM(amount) AS total_transaction_value,
    AVG(amount) AS average_transaction_value
FROM trans
GROUP BY transaction_year
ORDER BY transaction_year;
-- Transaction activity by year and transaction type

SELECT
    EXTRACT(YEAR FROM TO_DATE(date::TEXT, 'YYMMDD')) AS transaction_year,
    type,
    COUNT(*) AS transaction_count,
    SUM(amount) AS total_transaction_value,
    AVG(amount) AS average_transaction_value
FROM trans
GROUP BY transaction_year, type
ORDER BY transaction_year, type;
-- Monthly transaction activity

SELECT
    EXTRACT(YEAR FROM TO_DATE(date::TEXT, 'YYMMDD')) AS transaction_year,
    EXTRACT(MONTH FROM TO_DATE(date::TEXT, 'YYMMDD')) AS transaction_month,
    COUNT(*) AS transaction_count,
    SUM(amount) AS total_transaction_value,
    AVG(amount) AS average_transaction_value
FROM trans
GROUP BY transaction_year, transaction_month
ORDER BY transaction_year, transaction_month;
-- Transaction activity by calendar month

SELECT
    EXTRACT(MONTH FROM TO_DATE(date::TEXT, 'YYMMDD')) AS transaction_month,
    COUNT(*) AS transaction_count,
    SUM(amount) AS total_transaction_value,
    AVG(amount) AS average_transaction_value
FROM trans
GROUP BY transaction_month
ORDER BY transaction_month;
-- Monthly transaction share

SELECT
    EXTRACT(MONTH FROM TO_DATE(date::TEXT, 'YYMMDD')) AS transaction_month,
    COUNT(*) AS transaction_count,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS transaction_share_pct,
    SUM(amount) AS total_transaction_value
FROM trans
GROUP BY transaction_month
ORDER BY transaction_month;
-- Transaction count per account

SELECT
    account_id,
    COUNT(*) AS transaction_count
FROM trans
GROUP BY account_id
ORDER BY transaction_count DESC;
-- Total transaction value per account

SELECT
    account_id,
    COUNT(*) AS transaction_count,
    SUM(amount) AS total_transaction_value,
    AVG(amount) AS average_transaction_value
FROM trans
GROUP BY account_id
ORDER BY total_transaction_value DESC;
-- Summary statistics for account transaction activity

-- Summary statistics for account transaction activity

SELECT
    COUNT(*) AS account_count,
    MIN(transaction_count) AS min_transaction_count,
    MAX(transaction_count) AS max_transaction_count,
    ROUND(AVG(transaction_count)::numeric, 2) AS average_transaction_count,
    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY transaction_count)::numeric,
        2
    ) AS median_transaction_count,
    ROUND(AVG(total_transaction_value)::numeric, 2) AS average_total_transaction_value,
    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY total_transaction_value)::numeric,
        2
    ) AS median_total_transaction_value
FROM (
    SELECT
        account_id,
        COUNT(*) AS transaction_count,
        SUM(amount) AS total_transaction_value
    FROM trans
    GROUP BY account_id
) AS account_activity;
-- Transaction activity by account frequency

SELECT
    a.frequency,
    COUNT(DISTINCT a.account_id) AS account_count,
    COUNT(t.trans_id) AS transaction_count,
    ROUND(AVG(t.amount)::numeric, 2) AS average_transaction_value,
    ROUND(SUM(t.amount)::numeric, 2) AS total_transaction_value
FROM account a
JOIN trans t
    ON a.account_id = t.account_id
GROUP BY a.frequency
ORDER BY total_transaction_value DESC;
-- Average transaction activity per account frequency

SELECT
    a.frequency,
    COUNT(DISTINCT a.account_id) AS account_count,
    ROUND(
        COUNT(t.trans_id)::numeric
        / COUNT(DISTINCT a.account_id),
        2
    ) AS average_transactions_per_account,
    ROUND(
        SUM(t.amount)::numeric
        / COUNT(DISTINCT a.account_id),
        2
    ) AS average_total_transaction_value_per_account
FROM account a
JOIN trans t
    ON a.account_id = t.account_id
GROUP BY a.frequency
ORDER BY average_transactions_per_account DESC;
-- Transaction activity by customer owner

SELECT
    d.client_id,
    COUNT(t.trans_id) AS transaction_count,
    SUM(t.amount) AS total_transaction_value,
    AVG(t.amount) AS average_transaction_value
FROM disp d
JOIN trans t
    ON d.account_id = t.account_id
WHERE d.type = 'OWNER'
GROUP BY d.client_id
ORDER BY transaction_count DESC;
-- Summary statistics for customer transaction activity

SELECT
    COUNT(*) AS customer_count,
    MIN(transaction_count) AS min_transaction_count,
    MAX(transaction_count) AS max_transaction_count,
    ROUND(AVG(transaction_count)::numeric, 2) AS average_transaction_count,
    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY transaction_count)::numeric,
        2
    ) AS median_transaction_count,
    ROUND(AVG(total_transaction_value)::numeric, 2) AS average_total_transaction_value,
    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY total_transaction_value)::numeric,
        2
    ) AS median_total_transaction_value
FROM (
    SELECT
        d.client_id,
        COUNT(t.trans_id) AS transaction_count,
        SUM(t.amount) AS total_transaction_value
    FROM disp d
    JOIN trans t
        ON d.account_id = t.account_id
    WHERE d.type = 'OWNER'
    GROUP BY d.client_id
) AS customer_activity;
-- Account coverage by transaction type

SELECT
    type,
    COUNT(DISTINCT account_id) AS account_count,
    COUNT(*) AS transaction_count,
    SUM(amount) AS total_transaction_value,
    ROUND(AVG(amount)::numeric, 2) AS average_transaction_value
FROM trans
GROUP BY type
ORDER BY transaction_count DESC;
-- Top 10 accounts by total transaction value

SELECT
    account_id,
    COUNT(*) AS transaction_count,
    SUM(amount) AS total_transaction_value,
    ROUND(AVG(amount)::numeric, 2) AS average_transaction_value
FROM trans
GROUP BY account_id
ORDER BY total_transaction_value DESC
LIMIT 10;