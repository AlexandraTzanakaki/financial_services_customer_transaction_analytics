-- Advanced SQL Analysis
-- Financial Services Customer & Transaction Analytics
-- Rank accounts by total transaction value

SELECT
    account_id,
    COUNT(*) AS transaction_count,
    ROUND(
        SUM(amount)::numeric,
        2
    ) AS total_transaction_value,
    RANK() OVER (
        ORDER BY SUM(amount) DESC
    ) AS transaction_value_rank
FROM trans
GROUP BY account_id
ORDER BY transaction_value_rank;
-- Rank accounts by transaction value within each district

SELECT
    a.district_id,
    a.account_id,
    COUNT(t.trans_id) AS transaction_count,
    ROUND(
        SUM(t.amount)::numeric,
        2
    ) AS total_transaction_value,
    RANK() OVER (
        PARTITION BY a.district_id
        ORDER BY SUM(t.amount) DESC
    ) AS district_transaction_value_rank
FROM account a
JOIN trans t
    ON a.account_id = t.account_id
GROUP BY
    a.district_id,
    a.account_id
ORDER BY
    a.district_id,
    district_transaction_value_rank;
    -- Top 3 accounts by transaction value within each district

SELECT
    district_id,
    account_id,
    transaction_count,
    total_transaction_value,
    district_transaction_value_rank
FROM (
    SELECT
        a.district_id,
        a.account_id,
        COUNT(t.trans_id) AS transaction_count,
        ROUND(
            SUM(t.amount)::numeric,
            2
        ) AS total_transaction_value,
        RANK() OVER (
            PARTITION BY a.district_id
            ORDER BY SUM(t.amount) DESC
        ) AS district_transaction_value_rank
    FROM account a
    JOIN trans t
        ON a.account_id = t.account_id
    GROUP BY
        a.district_id,
        a.account_id
) AS ranked_accounts
WHERE district_transaction_value_rank <= 3
ORDER BY
    district_id,
    district_transaction_value_rank;
    -- Rank customers by total transaction value

SELECT
    d.client_id,
    COUNT(t.trans_id) AS transaction_count,
    ROUND(
        SUM(t.amount)::numeric,
        2
    ) AS total_transaction_value,
    RANK() OVER (
        ORDER BY SUM(t.amount) DESC
    ) AS customer_transaction_value_rank
FROM disp d
JOIN trans t
    ON d.account_id = t.account_id
WHERE d.type = 'OWNER'
GROUP BY d.client_id
ORDER BY customer_transaction_value_rank;
-- Top 3 customers by transaction value within each district

SELECT
    district_id,
    client_id,
    transaction_count,
    total_transaction_value,
    district_transaction_value_rank
FROM (
    SELECT
        c.district_id,
        d.client_id,
        COUNT(t.trans_id) AS transaction_count,
        ROUND(
            SUM(t.amount)::numeric,
            2
        ) AS total_transaction_value,
        RANK() OVER (
            PARTITION BY c.district_id
            ORDER BY SUM(t.amount) DESC
        ) AS district_transaction_value_rank
    FROM client c
    JOIN disp d
        ON c.client_id = d.client_id
    JOIN trans t
        ON d.account_id = t.account_id
    WHERE d.type = 'OWNER'
    GROUP BY
        c.district_id,
        d.client_id
) AS ranked_customers
WHERE district_transaction_value_rank <= 3
ORDER BY
    district_id,
    district_transaction_value_rank;
    -- Customer transaction activity and district characteristics

SELECT
    c.district_id,
    d.district_name,
    d.region,
    d.average_salary,
    d.unemployment_rate_1996,
    COUNT(DISTINCT c.client_id) AS customer_count,
    COUNT(t.trans_id) AS transaction_count,
    ROUND(
        SUM(t.amount)::numeric,
        2
    ) AS total_transaction_value,
    ROUND(
        AVG(t.amount)::numeric,
        2
    ) AS average_transaction_amount
FROM client c
JOIN district d
    ON c.district_id = d.district_id
JOIN disp dp
    ON c.client_id = dp.client_id
JOIN trans t
    ON dp.account_id = t.account_id
WHERE dp.type = 'OWNER'
GROUP BY
    c.district_id,
    d.district_name,
    d.region,
    d.average_salary,
    d.unemployment_rate_1996
ORDER BY
    total_transaction_value DESC;
    -- Rank districts by total customer transaction value

SELECT
    district_id,
    district_name,
    region,
    customer_count,
    transaction_count,
    total_transaction_value,
    average_transaction_amount,
    DENSE_RANK() OVER (
        ORDER BY total_transaction_value DESC
    ) AS district_transaction_value_rank
FROM (
    SELECT
        c.district_id,
        d.district_name,
        d.region,
        COUNT(DISTINCT c.client_id) AS customer_count,
        COUNT(t.trans_id) AS transaction_count,
        ROUND(
            SUM(t.amount)::numeric,
            2
        ) AS total_transaction_value,
        ROUND(
            AVG(t.amount)::numeric,
            2
        ) AS average_transaction_amount
    FROM client c
    JOIN district d
        ON c.district_id = d.district_id
    JOIN disp dp
        ON c.client_id = dp.client_id
    JOIN trans t
        ON dp.account_id = t.account_id
    WHERE dp.type = 'OWNER'
    GROUP BY
        c.district_id,
        d.district_name,
        d.region
) AS district_activity
ORDER BY
    district_transaction_value_rank;
    -- Rank districts by average transaction value per customer

SELECT
    district_id,
    district_name,
    region,
    customer_count,
    total_transaction_value,
    ROUND(
        total_transaction_value / customer_count,
        2
    ) AS average_transaction_value_per_customer,
    DENSE_RANK() OVER (
        ORDER BY total_transaction_value / customer_count DESC
    ) AS district_rank
FROM (
    SELECT
        c.district_id,
        d.district_name,
        d.region,
        COUNT(DISTINCT c.client_id) AS customer_count,
        SUM(t.amount)::numeric AS total_transaction_value
    FROM client c
    JOIN district d
        ON c.district_id = d.district_id
    JOIN disp dp
        ON c.client_id = dp.client_id
    JOIN trans t
        ON dp.account_id = t.account_id
    WHERE dp.type = 'OWNER'
    GROUP BY
        c.district_id,
        d.district_name,
        d.region
) AS district_activity
ORDER BY
    district_rank;
    -- Compare district transaction activity with average salary

SELECT
    district_id,
    district_name,
    region,
    average_salary,
    customer_count,
    ROUND(
        total_transaction_value / customer_count,
        2
    ) AS average_transaction_value_per_customer
FROM (
    SELECT
        c.district_id,
        d.district_name,
        d.region,
        d.average_salary,
        COUNT(DISTINCT c.client_id) AS customer_count,
        SUM(t.amount)::numeric AS total_transaction_value
    FROM client c
    JOIN district d
        ON c.district_id = d.district_id
    JOIN disp dp
        ON c.client_id = dp.client_id
    JOIN trans t
        ON dp.account_id = t.account_id
    WHERE dp.type = 'OWNER'
    GROUP BY
        c.district_id,
        d.district_name,
        d.region,
        d.average_salary
) AS district_activity
ORDER BY
    average_transaction_value_per_customer DESC;
    -- Correlation between district average salary and
-- average transaction value per customer

SELECT
    ROUND(
        CORR(
            average_salary,
            average_transaction_value_per_customer
        )::numeric,
        3
    ) AS salary_transaction_value_correlation
FROM (
    SELECT
        d.district_id,
        d.average_salary,
        SUM(t.amount)::numeric
            / COUNT(DISTINCT c.client_id)
            AS average_transaction_value_per_customer
    FROM client c
    JOIN district d
        ON c.district_id = d.district_id
    JOIN disp dp
        ON c.client_id = dp.client_id
    JOIN trans t
        ON dp.account_id = t.account_id
    WHERE dp.type = 'OWNER'
    GROUP BY
        d.district_id,
        d.average_salary
) AS district_activity;
-- Correlation between district unemployment rate and
-- average transaction value per customer

SELECT
    ROUND(
        CORR(
            unemployment_rate_1996,
            average_transaction_value_per_customer
        )::numeric,
        3
    ) AS unemployment_transaction_value_correlation
FROM (
    SELECT
        d.district_id,
        d.unemployment_rate_1996,
        SUM(t.amount)::numeric
            / COUNT(DISTINCT c.client_id)
            AS average_transaction_value_per_customer
    FROM client c
    JOIN district d
        ON c.district_id = d.district_id
    JOIN disp dp
        ON c.client_id = dp.client_id
    JOIN trans t
        ON dp.account_id = t.account_id
    WHERE dp.type = 'OWNER'
      AND d.unemployment_rate_1996 IS NOT NULL
    GROUP BY
        d.district_id,
        d.unemployment_rate_1996
) AS district_activity;
-- Customer transaction activity by gender

SELECT
    CASE
        WHEN ((birth_number / 100) % 100) >= 50
            THEN 'Female'
        ELSE 'Male'
    END AS gender,
    COUNT(DISTINCT c.client_id) AS customer_count,
    COUNT(t.trans_id) AS transaction_count,
    ROUND(
        SUM(t.amount)::numeric,
        2
    ) AS total_transaction_value,
    ROUND(
        AVG(t.amount)::numeric,
        2
    ) AS average_transaction_amount
FROM client c
JOIN disp dp
    ON c.client_id = dp.client_id
JOIN trans t
    ON dp.account_id = t.account_id
WHERE dp.type = 'OWNER'
GROUP BY
    CASE
        WHEN ((birth_number / 100) % 100) >= 50
            THEN 'Female'
        ELSE 'Male'
    END
ORDER BY
    gender;
    -- Customer transaction activity by age group

SELECT
    CASE
        WHEN age < 18 THEN 'Under 18'
        WHEN age BETWEEN 18 AND 24 THEN '18-24'
        WHEN age BETWEEN 25 AND 34 THEN '25-34'
        WHEN age BETWEEN 35 AND 44 THEN '35-44'
        WHEN age BETWEEN 45 AND 54 THEN '45-54'
        WHEN age BETWEEN 55 AND 64 THEN '55-64'
        ELSE '65+'
    END AS age_group,
    COUNT(DISTINCT client_id) AS customer_count,
    COUNT(trans_id) AS transaction_count,
    ROUND(
        SUM(amount)::numeric,
        2
    ) AS total_transaction_value,
    ROUND(
        AVG(amount)::numeric,
        2
    ) AS average_transaction_amount
FROM (
    SELECT
        c.client_id,
        t.trans_id,
        t.amount,
        EXTRACT(
            YEAR FROM DATE '1998-12-31'
        ) -
        CASE
            WHEN
                SUBSTRING(LPAD(c.birth_number::text, 6, '0'), 3, 2)::integer >= 50
            THEN
                1900 + SUBSTRING(
                    LPAD(c.birth_number::text, 6, '0'),
                    1,
                    2
                )::integer
            ELSE
                1900 + SUBSTRING(
                    LPAD(c.birth_number::text, 6, '0'),
                    1,
                    2
                )::integer
        END AS age
    FROM client c
    JOIN disp dp
        ON c.client_id = dp.client_id
    JOIN trans t
        ON dp.account_id = t.account_id
    WHERE dp.type = 'OWNER'
) AS customer_transactions
GROUP BY
    CASE
        WHEN age < 18 THEN 'Under 18'
        WHEN age BETWEEN 18 AND 24 THEN '18-24'
        WHEN age BETWEEN 25 AND 34 THEN '25-34'
        WHEN age BETWEEN 35 AND 44 THEN '35-44'
        WHEN age BETWEEN 45 AND 54 THEN '45-54'
        WHEN age BETWEEN 55 AND 64 THEN '55-64'
        ELSE '65+'
    END
ORDER BY
    CASE
        WHEN age_group = 'Under 18' THEN 1
        WHEN age_group = '18-24' THEN 2
        WHEN age_group = '25-34' THEN 3
        WHEN age_group = '35-44' THEN 4
        WHEN age_group = '45-54' THEN 5
        WHEN age_group = '55-64' THEN 6
        ELSE 7
    END;
    -- Customer transaction activity by age group

SELECT
    age_group,
    COUNT(DISTINCT client_id) AS customer_count,
    COUNT(trans_id) AS transaction_count,
    ROUND(
        SUM(amount)::numeric,
        2
    ) AS total_transaction_value,
    ROUND(
        AVG(amount)::numeric,
        2
    ) AS average_transaction_amount
FROM (
    SELECT
        c.client_id,
        t.trans_id,
        t.amount,
        CASE
            WHEN
                (
                    EXTRACT(
                        YEAR FROM DATE '1998-12-31'
                    ) -
                    (
                        1900 +
                        SUBSTRING(
                            LPAD(c.birth_number::text, 6, '0'),
                            1,
                            2
                        )::integer
                    )
                ) < 18
                THEN 'Under 18'

            WHEN
                (
                    EXTRACT(
                        YEAR FROM DATE '1998-12-31'
                    ) -
                    (
                        1900 +
                        SUBSTRING(
                            LPAD(c.birth_number::text, 6, '0'),
                            1,
                            2
                        )::integer
                    )
                ) BETWEEN 18 AND 24
                THEN '18-24'

            WHEN
                (
                    EXTRACT(
                        YEAR FROM DATE '1998-12-31'
                    ) -
                    (
                        1900 +
                        SUBSTRING(
                            LPAD(c.birth_number::text, 6, '0'),
                            1,
                            2
                        )::integer
                    )
                ) BETWEEN 25 AND 34
                THEN '25-34'

            WHEN
                (
                    EXTRACT(
                        YEAR FROM DATE '1998-12-31'
                    ) -
                    (
                        1900 +
                        SUBSTRING(
                            LPAD(c.birth_number::text, 6, '0'),
                            1,
                            2
                        )::integer
                    )
                ) BETWEEN 35 AND 44
                THEN '35-44'

            WHEN
                (
                    EXTRACT(
                        YEAR FROM DATE '1998-12-31'
                    ) -
                    (
                        1900 +
                        SUBSTRING(
                            LPAD(c.birth_number::text, 6, '0'),
                            1,
                            2
                        )::integer
                    )
                ) BETWEEN 45 AND 54
                THEN '45-54'

            WHEN
                (
                    EXTRACT(
                        YEAR FROM DATE '1998-12-31'
                    ) -
                    (
                        1900 +
                        SUBSTRING(
                            LPAD(c.birth_number::text, 6, '0'),
                            1,
                            2
                        )::integer
                    )
                ) BETWEEN 55 AND 64
                THEN '55-64'

            ELSE '65+'
        END AS age_group
    FROM client c
    JOIN disp dp
        ON c.client_id = dp.client_id
    JOIN trans t
        ON dp.account_id = t.account_id
    WHERE dp.type = 'OWNER'
) AS customer_transactions
GROUP BY
    age_group
ORDER BY
    CASE age_group
        WHEN 'Under 18' THEN 1
        WHEN '18-24' THEN 2
        WHEN '25-34' THEN 3
        WHEN '35-44' THEN 4
        WHEN '45-54' THEN 5
        WHEN '55-64' THEN 6
        WHEN '65+' THEN 7
    END;
    -- Rank customer age groups by total transaction value

SELECT
    age_group,
    customer_count,
    transaction_count,
    total_transaction_value,
    average_transaction_amount,
    DENSE_RANK() OVER (
        ORDER BY total_transaction_value DESC
    ) AS age_group_transaction_value_rank
FROM (
    SELECT
        age_group,
        COUNT(DISTINCT client_id) AS customer_count,
        COUNT(trans_id) AS transaction_count,
        ROUND(
            SUM(amount)::numeric,
            2
        ) AS total_transaction_value,
        ROUND(
            AVG(amount)::numeric,
            2
        ) AS average_transaction_amount
    FROM (
        SELECT
            c.client_id,
            t.trans_id,
            t.amount,
            CASE
                WHEN
                    (
                        EXTRACT(
                            YEAR FROM DATE '1998-12-31'
                        ) -
                        (
                            1900 +
                            SUBSTRING(
                                LPAD(c.birth_number::text, 6, '0'),
                                1,
                                2
                            )::integer
                        )
                    ) < 18
                    THEN 'Under 18'

                WHEN
                    (
                        EXTRACT(
                            YEAR FROM DATE '1998-12-31'
                        ) -
                        (
                            1900 +
                            SUBSTRING(
                                LPAD(c.birth_number::text, 6, '0'),
                                1,
                                2
                            )::integer
                        )
                    ) BETWEEN 18 AND 24
                    THEN '18-24'

                WHEN
                    (
                        EXTRACT(
                            YEAR FROM DATE '1998-12-31'
                        ) -
                        (
                            1900 +
                            SUBSTRING(
                                LPAD(c.birth_number::text, 6, '0'),
                                1,
                                2
                            )::integer
                        )
                    ) BETWEEN 25 AND 34
                    THEN '25-34'

                WHEN
                    (
                        EXTRACT(
                            YEAR FROM DATE '1998-12-31'
                        ) -
                        (
                            1900 +
                            SUBSTRING(
                                LPAD(c.birth_number::text, 6, '0'),
                                1,
                                2
                            )::integer
                        )
                    ) BETWEEN 35 AND 44
                    THEN '35-44'

                WHEN
                    (
                        EXTRACT(
                            YEAR FROM DATE '1998-12-31'
                        ) -
                        (
                            1900 +
                            SUBSTRING(
                                LPAD(c.birth_number::text, 6, '0'),
                                1,
                                2
                            )::integer
                        )
                    ) BETWEEN 45 AND 54
                    THEN '45-54'

                WHEN
                    (
                        EXTRACT(
                            YEAR FROM DATE '1998-12-31'
                        ) -
                        (
                            1900 +
                            SUBSTRING(
                                LPAD(c.birth_number::text, 6, '0'),
                                1,
                                2
                            )::integer
                        )
                    ) BETWEEN 55 AND 64
                    THEN '55-64'

                ELSE '65+'
            END AS age_group
        FROM client c
        JOIN disp dp
            ON c.client_id = dp.client_id
        JOIN trans t
            ON dp.account_id = t.account_id
        WHERE dp.type = 'OWNER'
    ) AS customer_transactions
    GROUP BY
        age_group
) AS age_group_activity
ORDER BY
    age_group_transaction_value_rank;
    -- Rank districts by average transaction amount

SELECT
    district_id,
    district_name,
    region,
    customer_count,
    transaction_count,
    total_transaction_value,
    average_transaction_amount,
    DENSE_RANK() OVER (
        ORDER BY average_transaction_amount DESC
    ) AS district_average_transaction_rank
FROM (
    SELECT
        a.district_id,
        d.district_name,
        d.region,
        COUNT(DISTINCT dp.client_id) AS customer_count,
        COUNT(t.trans_id) AS transaction_count,
        ROUND(
            SUM(t.amount)::numeric,
            2
        ) AS total_transaction_value,
        ROUND(
            AVG(t.amount)::numeric,
            2
        ) AS average_transaction_amount
    FROM account a
    JOIN district d
        ON a.district_id = d.district_id
    JOIN disp dp
        ON a.account_id = dp.account_id
    JOIN trans t
        ON a.account_id = t.account_id
    WHERE dp.type = 'OWNER'
    GROUP BY
        a.district_id,
        d.district_name,
        d.region
) AS district_activity
ORDER BY
    district_average_transaction_rank;
    -- Compare key district transaction metrics

SELECT
    a.district_id,
    d.district_name,
    d.region,
    COUNT(DISTINCT dp.client_id) AS customer_count,
    COUNT(t.trans_id) AS transaction_count,
    ROUND(
        SUM(t.amount)::numeric,
        2
    ) AS total_transaction_value,
    ROUND(
        (
            SUM(t.amount)::numeric
            / COUNT(DISTINCT dp.client_id)
        ),
        2
    ) AS transaction_value_per_customer,
    ROUND(
        AVG(t.amount)::numeric,
        2
    ) AS average_transaction_amount
FROM account a
JOIN district d
    ON a.district_id = d.district_id
JOIN disp dp
    ON a.account_id = dp.account_id
JOIN trans t
    ON a.account_id = t.account_id
WHERE dp.type = 'OWNER'
GROUP BY
    a.district_id,
    d.district_name,
    d.region
ORDER BY
    total_transaction_value DESC;
    -- Identify districts with above-average transaction value per customer

WITH district_activity AS (
    SELECT
        c.district_id,
        d.district_name,
        d.region,
        COUNT(DISTINCT c.client_id) AS customer_count,
        SUM(t.amount)::numeric
            / COUNT(DISTINCT c.client_id)
            AS transaction_value_per_customer
    FROM client c
    JOIN district d
        ON c.district_id = d.district_id
    JOIN disp dp
        ON c.client_id = dp.client_id
    JOIN trans t
        ON dp.account_id = t.account_id
    WHERE dp.type = 'OWNER'
    GROUP BY
        c.district_id,
        d.district_name,
        d.region
),
district_average AS (
    SELECT
        AVG(transaction_value_per_customer) AS overall_district_average
    FROM district_activity
)
SELECT
    da.district_id,
    da.district_name,
    da.region,
    da.customer_count,
    ROUND(
        da.transaction_value_per_customer,
        2
    ) AS transaction_value_per_customer,
    ROUND(
        d_avg.overall_district_average,
        2
    ) AS overall_district_average,
    ROUND(
        (
            da.transaction_value_per_customer
            - d_avg.overall_district_average
        ),
        2
    ) AS difference_from_average
FROM district_activity da
CROSS JOIN district_average d_avg
WHERE da.transaction_value_per_customer
      > d_avg.overall_district_average
ORDER BY
    da.transaction_value_per_customer DESC;
    -- Calculate each district's share of total transaction value

WITH district_activity AS (
    SELECT
        c.district_id,
        d.district_name,
        d.region,
        SUM(t.amount)::numeric AS district_transaction_value
    FROM client c
    JOIN district d
        ON c.district_id = d.district_id
    JOIN disp dp
        ON c.client_id = dp.client_id
    JOIN trans t
        ON dp.account_id = t.account_id
    WHERE dp.type = 'OWNER'
    GROUP BY
        c.district_id,
        d.district_name,
        d.region
)
SELECT
    district_id,
    district_name,
    region,
    ROUND(
        district_transaction_value,
        2
    ) AS district_transaction_value,
    ROUND(
        district_transaction_value * 100.0
        / SUM(district_transaction_value) OVER (),
        2
    ) AS share_of_total_transaction_value_pct
FROM district_activity
ORDER BY
    share_of_total_transaction_value_pct DESC;
    -- Calculate cumulative district contribution to total transaction value

WITH district_activity AS (
    SELECT
        c.district_id,
        d.district_name,
        d.region,
        SUM(t.amount)::numeric AS district_transaction_value
    FROM client c
    JOIN district d
        ON c.district_id = d.district_id
    JOIN disp dp
        ON c.client_id = dp.client_id
    JOIN trans t
        ON dp.account_id = t.account_id
    WHERE dp.type = 'OWNER'
    GROUP BY
        c.district_id,
        d.district_name,
        d.region
),
district_contribution AS (
    SELECT
        district_id,
        district_name,
        region,
        district_transaction_value,
        district_transaction_value * 100.0
        / SUM(district_transaction_value) OVER ()
        AS contribution_pct
    FROM district_activity
)
SELECT
    district_id,
    district_name,
    region,
    ROUND(
        district_transaction_value,
        2
    ) AS district_transaction_value,
    ROUND(
        contribution_pct,
        2
    ) AS contribution_pct,
    ROUND(
        SUM(contribution_pct) OVER (
            ORDER BY district_transaction_value DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ),
        2
    ) AS cumulative_contribution_pct
FROM district_contribution
ORDER BY
    district_transaction_value DESC;
    -- Identify the number of districts needed to reach
-- 50% and 80% of total transaction value

WITH district_activity AS (
    SELECT
        c.district_id,
        SUM(t.amount)::numeric AS district_transaction_value
    FROM client c
    JOIN disp dp
        ON c.client_id = dp.client_id
    JOIN trans t
        ON dp.account_id = t.account_id
    WHERE dp.type = 'OWNER'
    GROUP BY
        c.district_id
),
district_contribution AS (
    SELECT
        district_id,
        district_transaction_value,
        SUM(district_transaction_value) OVER (
            ORDER BY district_transaction_value DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) * 100.0
        / SUM(district_transaction_value) OVER ()
        AS cumulative_contribution_pct
    FROM district_activity
)
SELECT
    MIN(
        CASE
            WHEN cumulative_contribution_pct >= 50
            THEN district_rank
        END
    ) AS districts_needed_for_50_pct,
    MIN(
        CASE
            WHEN cumulative_contribution_pct >= 80
            THEN district_rank
        END
    ) AS districts_needed_for_80_pct
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (
            ORDER BY district_transaction_value DESC
        ) AS district_rank
    FROM district_contribution
) AS ranked_districts;
-- Identify the number of customers needed to reach
-- 50% and 80% of total transaction value

WITH customer_activity AS (
    SELECT
        dp.client_id,
        SUM(t.amount)::numeric AS customer_transaction_value
    FROM disp dp
    JOIN trans t
        ON dp.account_id = t.account_id
    WHERE dp.type = 'OWNER'
    GROUP BY
        dp.client_id
),
customer_contribution AS (
    SELECT
        client_id,
        customer_transaction_value,
        SUM(customer_transaction_value) OVER (
            ORDER BY customer_transaction_value DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) * 100.0
        / SUM(customer_transaction_value) OVER ()
        AS cumulative_contribution_pct
    FROM customer_activity
)
SELECT
    MIN(
        CASE
            WHEN cumulative_contribution_pct >= 50
            THEN customer_rank
        END
    ) AS customers_needed_for_50_pct,
    MIN(
        CASE
            WHEN cumulative_contribution_pct >= 80
            THEN customer_rank
        END
    ) AS customers_needed_for_80_pct
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (
            ORDER BY customer_transaction_value DESC
        ) AS customer_rank
    FROM customer_contribution
) AS ranked_customers;
-- Identify customers in the top 10% by transaction value

WITH customer_activity AS (
    SELECT
        dp.client_id,
        COUNT(t.trans_id) AS transaction_count,
        SUM(t.amount)::numeric AS total_transaction_value
    FROM disp dp
    JOIN trans t
        ON dp.account_id = t.account_id
    WHERE dp.type = 'OWNER'
    GROUP BY
        dp.client_id
),
customer_percentiles AS (
    SELECT
        *,
        NTILE(10) OVER (
            ORDER BY total_transaction_value DESC
        ) AS customer_decile
    FROM customer_activity
)
SELECT
    client_id,
    transaction_count,
    ROUND(
        total_transaction_value,
        2
    ) AS total_transaction_value,
    customer_decile
FROM customer_percentiles
WHERE customer_decile = 1
ORDER BY
    total_transaction_value DESC;
    -- Compare transaction activity across customer value deciles

WITH customer_activity AS (
    SELECT
        dp.client_id,
        COUNT(t.trans_id) AS transaction_count,
        SUM(t.amount)::numeric AS total_transaction_value
    FROM disp dp
    JOIN trans t
        ON dp.account_id = t.account_id
    WHERE dp.type = 'OWNER'
    GROUP BY
        dp.client_id
),
customer_deciles AS (
    SELECT
        *,
        NTILE(10) OVER (
            ORDER BY total_transaction_value DESC
        ) AS customer_decile
    FROM customer_activity
)
SELECT
    customer_decile,
    COUNT(*) AS customer_count,
    ROUND(
        AVG(transaction_count)::numeric,
        2
    ) AS average_transaction_count,
    ROUND(
        AVG(total_transaction_value)::numeric,
        2
    ) AS average_transaction_value,
    ROUND(
        SUM(total_transaction_value)::numeric,
        2
    ) AS decile_transaction_value
FROM customer_deciles
GROUP BY
    customer_decile
ORDER BY
    customer_decile;
    -- Calculate each customer decile's share of total transaction value

WITH customer_activity AS (
    SELECT
        dp.client_id,
        SUM(t.amount)::numeric AS total_transaction_value
    FROM disp dp
    JOIN trans t
        ON dp.account_id = t.account_id
    WHERE dp.type = 'OWNER'
    GROUP BY
        dp.client_id
),
customer_deciles AS (
    SELECT
        *,
        NTILE(10) OVER (
            ORDER BY total_transaction_value DESC
        ) AS customer_decile
    FROM customer_activity
),
decile_totals AS (
    SELECT
        customer_decile,
        SUM(total_transaction_value)::numeric
            AS decile_transaction_value
    FROM customer_deciles
    GROUP BY
        customer_decile
)
SELECT
    customer_decile,
    ROUND(
        decile_transaction_value,
        2
    ) AS decile_transaction_value,
    ROUND(
        decile_transaction_value * 100.0
        / SUM(decile_transaction_value) OVER (),
        2
    ) AS transaction_value_share_pct
FROM decile_totals
ORDER BY
    customer_decile;
    -- Identify customers with both loans and cards

SELECT
    dp.client_id,
    COUNT(DISTINCT l.loan_id) AS loan_count,
    COUNT(DISTINCT ca.card_id) AS card_count
FROM disp dp
LEFT JOIN loan l
    ON dp.account_id = l.account_id
LEFT JOIN card ca
    ON dp.disp_id = ca.disp_id
WHERE dp.type = 'OWNER'
GROUP BY
    dp.client_id
HAVING
    COUNT(DISTINCT l.loan_id) > 0
    AND COUNT(DISTINCT ca.card_id) > 0
ORDER BY
    dp.client_id;
    -- Segment customers by loan and card ownership

WITH customer_products AS (
    SELECT
        c.client_id,
        COUNT(DISTINCT l.loan_id) AS loan_count,
        COUNT(DISTINCT ca.card_id) AS card_count
    FROM client c
    LEFT JOIN disp dp
        ON c.client_id = dp.client_id
       AND dp.type = 'OWNER'
    LEFT JOIN loan l
        ON dp.account_id = l.account_id
    LEFT JOIN card ca
        ON dp.disp_id = ca.disp_id
    GROUP BY
        c.client_id
)
SELECT
    CASE
        WHEN loan_count > 0 AND card_count > 0
            THEN 'Loan + Card'
        WHEN loan_count > 0
            THEN 'Loan Only'
        WHEN card_count > 0
            THEN 'Card Only'
        ELSE 'Neither'
    END AS product_profile,
    COUNT(*) AS customer_count,
    ROUND(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER (),
        2
    ) AS customer_share_pct
FROM customer_products
GROUP BY
    CASE
        WHEN loan_count > 0 AND card_count > 0
            THEN 'Loan + Card'
        WHEN loan_count > 0
            THEN 'Loan Only'
        WHEN card_count > 0
            THEN 'Card Only'
        ELSE 'Neither'
    END
ORDER BY
    customer_count DESC;
    -- Compare customer product profiles across age groups

WITH customer_base AS (
    SELECT
        c.client_id,
        CASE
            WHEN (
                1998 -
                (1900 + SUBSTRING(
                    LPAD(c.birth_number::text, 6, '0'),
                    1, 2
                )::integer)
            ) < 18
                THEN 'Under 18'
            WHEN (
                1998 -
                (1900 + SUBSTRING(
                    LPAD(c.birth_number::text, 6, '0'),
                    1, 2
                )::integer)
            ) BETWEEN 18 AND 24
                THEN '18-24'
            WHEN (
                1998 -
                (1900 + SUBSTRING(
                    LPAD(c.birth_number::text, 6, '0'),
                    1, 2
                )::integer)
            ) BETWEEN 25 AND 34
                THEN '25-34'
            WHEN (
                1998 -
                (1900 + SUBSTRING(
                    LPAD(c.birth_number::text, 6, '0'),
                    1, 2
                )::integer)
            ) BETWEEN 35 AND 44
                THEN '35-44'
            WHEN (
                1998 -
                (1900 + SUBSTRING(
                    LPAD(c.birth_number::text, 6, '0'),
                    1, 2
                )::integer)
            ) BETWEEN 45 AND 54
                THEN '45-54'
            WHEN (
                1998 -
                (1900 + SUBSTRING(
                    LPAD(c.birth_number::text, 6, '0'),
                    1, 2
                )::integer)
            ) BETWEEN 55 AND 64
                THEN '55-64'
            ELSE '65+'
        END AS age_group,
        l.loan_id,
        ca.card_id
    FROM client c
    LEFT JOIN disp dp
        ON c.client_id = dp.client_id
       AND dp.type = 'OWNER'
    LEFT JOIN loan l
        ON dp.account_id = l.account_id
    LEFT JOIN card ca
        ON dp.disp_id = ca.disp_id
),
customer_products AS (
    SELECT
        client_id,
        age_group,
        COUNT(DISTINCT loan_id) AS loan_count,
        COUNT(DISTINCT card_id) AS card_count
    FROM customer_base
    GROUP BY
        client_id,
        age_group
)
SELECT
    age_group,
    CASE
        WHEN loan_count > 0 AND card_count > 0
            THEN 'Loan + Card'
        WHEN loan_count > 0
            THEN 'Loan Only'
        WHEN card_count > 0
            THEN 'Card Only'
        ELSE 'Neither'
    END AS product_profile,
    COUNT(*) AS customer_count,
    ROUND(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER (
            PARTITION BY age_group
        ),
        2
    ) AS age_group_share_pct
FROM customer_products
GROUP BY
    age_group,
    CASE
        WHEN loan_count > 0 AND card_count > 0
            THEN 'Loan + Card'
        WHEN loan_count > 0
            THEN 'Loan Only'
        WHEN card_count > 0
            THEN 'Card Only'
        ELSE 'Neither'
    END
ORDER BY
    CASE age_group
        WHEN 'Under 18' THEN 1
        WHEN '18-24' THEN 2
        WHEN '25-34' THEN 3
        WHEN '35-44' THEN 4
        WHEN '45-54' THEN 5
        WHEN '55-64' THEN 6
        WHEN '65+' THEN 7
    END,
    customer_count DESC;
    -- Compare customer product profiles across gender groups

WITH customer_products AS (
    SELECT
        c.client_id,
        CASE
            WHEN ((c.birth_number / 100) % 100) >= 50
                THEN 'Female'
            ELSE 'Male'
        END AS gender,
        COUNT(DISTINCT l.loan_id) AS loan_count,
        COUNT(DISTINCT ca.card_id) AS card_count
    FROM client c
    LEFT JOIN disp dp
        ON c.client_id = dp.client_id
       AND dp.type = 'OWNER'
    LEFT JOIN loan l
        ON dp.account_id = l.account_id
    LEFT JOIN card ca
        ON dp.disp_id = ca.disp_id
    GROUP BY
        c.client_id,
        CASE
            WHEN ((c.birth_number / 100) % 100) >= 50
                THEN 'Female'
            ELSE 'Male'
        END
)
SELECT
    gender,
    CASE
        WHEN loan_count > 0 AND card_count > 0
            THEN 'Loan + Card'
        WHEN loan_count > 0
            THEN 'Loan Only'
        WHEN card_count > 0
            THEN 'Card Only'
        ELSE 'Neither'
    END AS product_profile,
    COUNT(*) AS customer_count,
    ROUND(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER (
            PARTITION BY gender
        ),
        2
    ) AS gender_share_pct
FROM customer_products
GROUP BY
    gender,
    CASE
        WHEN loan_count > 0 AND card_count > 0
            THEN 'Loan + Card'
        WHEN loan_count > 0
            THEN 'Loan Only'
        WHEN card_count > 0
            THEN 'Card Only'
        ELSE 'Neither'
    END
ORDER BY
    gender,
    customer_count DESC;
    -- Compare loan portfolio characteristics by risk indicator

SELECT
    CASE
        WHEN status IN ('B', 'D')
            THEN 'Risk Indicator'
        ELSE 'No Risk Indicator'
    END AS risk_group,
    COUNT(*) AS loan_count,
    ROUND(
        AVG(amount)::numeric,
        2
    ) AS average_loan_amount,
    ROUND(
        AVG(duration)::numeric,
        2
    ) AS average_duration,
    ROUND(
        AVG(payments)::numeric,
        2
    ) AS average_monthly_payment,
    ROUND(
        SUM(amount)::numeric,
        2
    ) AS total_loan_amount
FROM loan
GROUP BY
    CASE
        WHEN status IN ('B', 'D')
            THEN 'Risk Indicator'
        ELSE 'No Risk Indicator'
    END
ORDER BY
    risk_group;
 -- Analyze loan risk indicators across loan amount bands

SELECT
    loan_amount_band,
    loan_count,
    risk_indicator_count,
    risk_indicator_rate_pct,
    average_loan_amount
FROM (
    SELECT
        CASE
            WHEN amount < 50000
                THEN 'Under 50K'
            WHEN amount < 100000
                THEN '50K-99K'
            WHEN amount < 200000
                THEN '100K-199K'
            WHEN amount < 300000
                THEN '200K-299K'
            ELSE '300K+'
        END AS loan_amount_band,
        COUNT(*) AS loan_count,
        COUNT(*) FILTER (
            WHERE status IN ('B', 'D')
        ) AS risk_indicator_count,
        ROUND(
            COUNT(*) FILTER (
                WHERE status IN ('B', 'D')
            ) * 100.0
            / COUNT(*),
            2
        ) AS risk_indicator_rate_pct,
        ROUND(
            AVG(amount)::numeric,
            2
        ) AS average_loan_amount
    FROM loan
    GROUP BY
        CASE
            WHEN amount < 50000
                THEN 'Under 50K'
            WHEN amount < 100000
                THEN '50K-99K'
            WHEN amount < 200000
                THEN '100K-199K'
            WHEN amount < 300000
                THEN '200K-299K'
            ELSE '300K+'
        END
) AS loan_bands
ORDER BY
    CASE loan_amount_band
        WHEN 'Under 50K' THEN 1
        WHEN '50K-99K' THEN 2
        WHEN '100K-199K' THEN 3
        WHEN '200K-299K' THEN 4
        WHEN '300K+' THEN 5
    END;
-- Analyze customer transaction-value concentration

WITH customer_activity AS (
    SELECT
        dp.client_id,
        SUM(t.amount)::numeric AS total_transaction_value
    FROM disp dp
    JOIN trans t
        ON dp.account_id = t.account_id
    WHERE dp.type = 'OWNER'
    GROUP BY
        dp.client_id
),
customer_segments AS (
    SELECT
        client_id,
        total_transaction_value,
        NTILE(10) OVER (
            ORDER BY total_transaction_value DESC
        ) AS customer_decile
    FROM customer_activity
),
segment_summary AS (
    SELECT
        CASE
            WHEN customer_decile = 1
                THEN 'Top 10%'
            WHEN customer_decile BETWEEN 2 AND 5
                THEN 'Middle 40%'
            ELSE 'Bottom 50%'
        END AS customer_segment,
        COUNT(*) AS customer_count,
        ROUND(
            SUM(total_transaction_value)::numeric,
            2
        ) AS transaction_value,
        ROUND(
            SUM(total_transaction_value) * 100.0
            / SUM(SUM(total_transaction_value)) OVER (),
            2
        ) AS transaction_value_share_pct,
        ROUND(
            AVG(total_transaction_value)::numeric,
            2
        ) AS average_customer_transaction_value
    FROM customer_segments
    GROUP BY
        CASE
            WHEN customer_decile = 1
                THEN 'Top 10%'
            WHEN customer_decile BETWEEN 2 AND 5
                THEN 'Middle 40%'
            ELSE 'Bottom 50%'
        END
)
SELECT
    customer_segment,
    customer_count,
    transaction_value,
    transaction_value_share_pct,
    average_customer_transaction_value
FROM segment_summary
ORDER BY
    CASE
        WHEN customer_segment = 'Top 10%' THEN 1
        WHEN customer_segment = 'Middle 40%' THEN 2
        ELSE 3
    END;
    -- Compare transaction activity across customer product profiles

WITH customer_products AS (
    SELECT
        c.client_id,
        COUNT(DISTINCT l.loan_id) AS loan_count,
        COUNT(DISTINCT ca.card_id) AS card_count
    FROM client c
    LEFT JOIN disp dp
        ON c.client_id = dp.client_id
       AND dp.type = 'OWNER'
    LEFT JOIN loan l
        ON dp.account_id = l.account_id
    LEFT JOIN card ca
        ON dp.disp_id = ca.disp_id
    GROUP BY
        c.client_id
),
customer_activity AS (
    SELECT
        dp.client_id,
        COUNT(t.trans_id) AS transaction_count,
        SUM(t.amount)::numeric AS total_transaction_value
    FROM disp dp
    JOIN trans t
        ON dp.account_id = t.account_id
    WHERE dp.type = 'OWNER'
    GROUP BY
        dp.client_id
),
customer_profile_activity AS (
    SELECT
        cp.client_id,
        CASE
            WHEN cp.loan_count > 0
                 AND cp.card_count > 0
                THEN 'Loan + Card'
            WHEN cp.loan_count > 0
                THEN 'Loan Only'
            WHEN cp.card_count > 0
                THEN 'Card Only'
            ELSE 'Neither'
        END AS product_profile,
        COALESCE(ca.transaction_count, 0) AS transaction_count,
        COALESCE(ca.total_transaction_value, 0) AS total_transaction_value
    FROM customer_products cp
    LEFT JOIN customer_activity ca
        ON cp.client_id = ca.client_id
)
SELECT
    product_profile,
    COUNT(*) AS customer_count,
    ROUND(
        AVG(transaction_count)::numeric,
        2
    ) AS average_transaction_count,
    ROUND(
        AVG(total_transaction_value)::numeric,
        2
    ) AS average_transaction_value,
    ROUND(
        SUM(total_transaction_value)::numeric,
        2
    ) AS total_transaction_value
FROM customer_profile_activity
GROUP BY
    product_profile
ORDER BY
    customer_count DESC;
    -- Analyze transaction-value concentration within customer product profiles

WITH customer_products AS (
    SELECT
        c.client_id,
        CASE
            WHEN COUNT(DISTINCT l.loan_id) > 0
                 AND COUNT(DISTINCT ca.card_id) > 0
                THEN 'Loan + Card'
            WHEN COUNT(DISTINCT l.loan_id) > 0
                THEN 'Loan Only'
            WHEN COUNT(DISTINCT ca.card_id) > 0
                THEN 'Card Only'
            ELSE 'Neither'
        END AS product_profile
    FROM client c
    LEFT JOIN disp dp
        ON c.client_id = dp.client_id
       AND dp.type = 'OWNER'
    LEFT JOIN loan l
        ON dp.account_id = l.account_id
    LEFT JOIN card ca
        ON dp.disp_id = ca.disp_id
    GROUP BY
        c.client_id
),
customer_activity AS (
    SELECT
        dp.client_id,
        SUM(t.amount)::numeric AS total_transaction_value
    FROM disp dp
    JOIN trans t
        ON dp.account_id = t.account_id
    WHERE dp.type = 'OWNER'
    GROUP BY
        dp.client_id
),
profile_activity AS (
    SELECT
        cp.client_id,
        cp.product_profile,
        COALESCE(
            ca.total_transaction_value,
            0
        ) AS total_transaction_value
    FROM customer_products cp
    LEFT JOIN customer_activity ca
        ON cp.client_id = ca.client_id
),
ranked_customers AS (
    SELECT
        *,
        PERCENT_RANK() OVER (
            PARTITION BY product_profile
            ORDER BY total_transaction_value DESC
        ) AS value_percentile
    FROM profile_activity
)
SELECT
    product_profile,
    COUNT(*) AS customer_count,
    ROUND(
        AVG(total_transaction_value)::numeric,
        2
    ) AS average_transaction_value,
    ROUND(
        MAX(total_transaction_value)::numeric,
        2
    ) AS highest_transaction_value,
    ROUND(
        AVG(
            CASE
                WHEN value_percentile <= 0.10
                    THEN total_transaction_value
            END
        )::numeric,
        2
    ) AS average_top_10pct_transaction_value
FROM ranked_customers
GROUP BY
    product_profile
ORDER BY
    customer_count DESC;
    -- Analyze transaction activity by account frequency and year

SELECT
    EXTRACT(
        YEAR FROM TO_DATE(
            t.date::text,
            'YYMMDD'
        )
    ) AS transaction_year,
    a.frequency,
    COUNT(t.trans_id) AS transaction_count,
    ROUND(
        SUM(t.amount)::numeric,
        2
    ) AS total_transaction_value,
    ROUND(
        AVG(t.amount)::numeric,
        2
    ) AS average_transaction_amount
FROM account a
JOIN trans t
    ON a.account_id = t.account_id
GROUP BY
    EXTRACT(
        YEAR FROM TO_DATE(
            t.date::text,
            'YYMMDD'
        )
    ),
    a.frequency
ORDER BY
    transaction_year,
    a.frequency;
    -- Rank account frequency groups by transaction value within each year

WITH yearly_frequency_activity AS (
    SELECT
        EXTRACT(
            YEAR FROM TO_DATE(
                t.date::text,
                'YYMMDD'
            )
        ) AS transaction_year,
        a.frequency,
        COUNT(t.trans_id) AS transaction_count,
        ROUND(
            SUM(t.amount)::numeric,
            2
        ) AS total_transaction_value,
        ROUND(
            AVG(t.amount)::numeric,
            2
        ) AS average_transaction_amount
    FROM account a
    JOIN trans t
        ON a.account_id = t.account_id
    GROUP BY
        EXTRACT(
            YEAR FROM TO_DATE(
                t.date::text,
                'YYMMDD'
            )
        ),
        a.frequency
)
SELECT
    transaction_year,
    frequency,
    transaction_count,
    total_transaction_value,
    average_transaction_amount,
    RANK() OVER (
        PARTITION BY transaction_year
        ORDER BY total_transaction_value DESC
    ) AS yearly_transaction_value_rank
FROM yearly_frequency_activity
ORDER BY
    transaction_year,
    yearly_transaction_value_rank;
    -- Analyze monthly transaction activity by transaction type

SELECT
    DATE_TRUNC(
        'month',
        TO_DATE(
            t.date::text,
            'YYMMDD'
        )
    ) AS transaction_month,
    t.type AS transaction_type,
    COUNT(*) AS transaction_count,
    ROUND(
        SUM(t.amount)::numeric,
        2
    ) AS total_transaction_value,
    ROUND(
        AVG(t.amount)::numeric,
        2
    ) AS average_transaction_amount
FROM trans t
GROUP BY
    DATE_TRUNC(
        'month',
        TO_DATE(
            t.date::text,
            'YYMMDD'
        )
    ),
    t.type
ORDER BY
    transaction_month,
    transaction_type;
    -- Analyze monthly transaction-type share

WITH monthly_type_activity AS (
    SELECT
        DATE_TRUNC(
            'month',
            TO_DATE(
                t.date::text,
                'YYMMDD'
            )
        ) AS transaction_month,
        t.type AS transaction_type,
        COUNT(*) AS transaction_count,
        SUM(t.amount)::numeric AS total_transaction_value
    FROM trans t
    GROUP BY
        DATE_TRUNC(
            'month',
            TO_DATE(
                t.date::text,
                'YYMMDD'
            )
        ),
        t.type
)
SELECT
    transaction_month,
    transaction_type,
    transaction_count,
    ROUND(
        transaction_count * 100.0
        / SUM(transaction_count) OVER (
            PARTITION BY transaction_month
        ),
        2
    ) AS transaction_count_share_pct,
    ROUND(
        total_transaction_value,
        2
    ) AS total_transaction_value,
    ROUND(
        total_transaction_value * 100.0
        / SUM(total_transaction_value) OVER (
            PARTITION BY transaction_month
        ),
        2
    ) AS transaction_value_share_pct
FROM monthly_type_activity
ORDER BY
    transaction_month,
    transaction_type;
    -- Analyze cumulative transaction-value contribution by district

WITH district_activity AS (
    SELECT
        c.district_id,
        d.district_name,
        d.region,
        SUM(t.amount)::numeric AS district_transaction_value
    FROM client c
    JOIN district d
        ON c.district_id = d.district_id
    JOIN disp dp
        ON c.client_id = dp.client_id
    JOIN trans t
        ON dp.account_id = t.account_id
    WHERE dp.type = 'OWNER'
    GROUP BY
        c.district_id,
        d.district_name,
        d.region
),
district_contribution AS (
    SELECT
        district_id,
        district_name,
        region,
        district_transaction_value,
        district_transaction_value * 100.0
        / SUM(district_transaction_value) OVER () AS contribution_pct
    FROM district_activity
),
ranked_districts AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            ORDER BY district_transaction_value DESC
        ) AS district_rank
    FROM district_contribution
)
SELECT
    district_rank,
    district_id,
    district_name,
    region,
    ROUND(
        district_transaction_value,
        2
    ) AS district_transaction_value,
    ROUND(
        contribution_pct,
        2
    ) AS contribution_pct,
    ROUND(
        SUM(contribution_pct) OVER (
            ORDER BY district_rank
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ),
        2
    ) AS cumulative_contribution_pct
FROM ranked_districts
ORDER BY
    district_rank;
    -- Analyze transaction activity by region

WITH region_activity AS (
    SELECT
        c.district_id,
        d.region,
        c.client_id,
        t.trans_id,
        t.amount
    FROM client c
    JOIN district d
        ON c.district_id = d.district_id
    JOIN disp dp
        ON c.client_id = dp.client_id
       AND dp.type = 'OWNER'
    JOIN trans t
        ON dp.account_id = t.account_id
),
region_summary AS (
    SELECT
        region,
        COUNT(DISTINCT district_id) AS district_count,
        COUNT(DISTINCT client_id) AS customer_count,
        COUNT(trans_id) AS transaction_count,
        SUM(amount)::numeric AS total_transaction_value
    FROM region_activity
    GROUP BY
        region
)
SELECT
    region,
    district_count,
    customer_count,
    transaction_count,
    ROUND(
        total_transaction_value,
        2
    ) AS total_transaction_value,
    ROUND(
        total_transaction_value
        / customer_count,
        2
    ) AS average_transaction_value_per_customer,
    ROUND(
        total_transaction_value * 100.0
        / SUM(total_transaction_value) OVER (),
        2
    ) AS transaction_value_share_pct
FROM region_summary
ORDER BY
    total_transaction_value DESC;
    -- Compare customer transaction value by gender

WITH customer_activity AS (
    SELECT
        c.client_id,
        CASE
            WHEN ((c.birth_number / 100) % 100) >= 50
                THEN 'Female'
            ELSE 'Male'
        END AS gender,
        COUNT(t.trans_id) AS transaction_count,
        SUM(t.amount)::numeric AS total_transaction_value
    FROM client c
    JOIN disp dp
        ON c.client_id = dp.client_id
       AND dp.type = 'OWNER'
    JOIN trans t
        ON dp.account_id = t.account_id
    GROUP BY
        c.client_id,
        CASE
            WHEN ((c.birth_number / 100) % 100) >= 50
                THEN 'Female'
            ELSE 'Male'
        END
),
gender_summary AS (
    SELECT
        gender,
        COUNT(*) AS customer_count,
        SUM(transaction_count) AS transaction_count,
        SUM(total_transaction_value)::numeric AS total_transaction_value
    FROM customer_activity
    GROUP BY
        gender
)
SELECT
    gender,
    customer_count,
    transaction_count,
    ROUND(
        total_transaction_value,
        2
    ) AS total_transaction_value,
    ROUND(
        total_transaction_value
        / customer_count,
        2
    ) AS average_transaction_value_per_customer,
    ROUND(
        total_transaction_value * 100.0
        / SUM(total_transaction_value) OVER (),
        2
    ) AS transaction_value_share_pct
FROM gender_summary
ORDER BY
    gender;
    -- Compare customer transaction value by age group

WITH customer_activity AS (
    SELECT
        c.client_id,
        CASE
            WHEN (
                1998 -
                (
                    1900 +
                    SUBSTRING(
                        LPAD(c.birth_number::text, 6, '0'),
                        1,
                        2
                    )::integer
                )
            ) < 18
                THEN 'Under 18'
            WHEN (
                1998 -
                (
                    1900 +
                    SUBSTRING(
                        LPAD(c.birth_number::text, 6, '0'),
                        1,
                        2
                    )::integer
                )
            ) BETWEEN 18 AND 24
                THEN '18-24'
            WHEN (
                1998 -
                (
                    1900 +
                    SUBSTRING(
                        LPAD(c.birth_number::text, 6, '0'),
                        1,
                        2
                    )::integer
                )
            ) BETWEEN 25 AND 34
                THEN '25-34'
            WHEN (
                1998 -
                (
                    1900 +
                    SUBSTRING(
                        LPAD(c.birth_number::text, 6, '0'),
                        1,
                        2
                    )::integer
                )
            ) BETWEEN 35 AND 44
                THEN '35-44'
            WHEN (
                1998 -
                (
                    1900 +
                    SUBSTRING(
                        LPAD(c.birth_number::text, 6, '0'),
                        1,
                        2
                    )::integer
                )
            ) BETWEEN 45 AND 54
                THEN '45-54'
            WHEN (
                1998 -
                (
                    1900 +
                    SUBSTRING(
                        LPAD(c.birth_number::text, 6, '0'),
                        1,
                        2
                    )::integer
                )
            ) BETWEEN 55 AND 64
                THEN '55-64'
            ELSE '65+'
        END AS age_group,
        COUNT(t.trans_id) AS transaction_count,
        SUM(t.amount)::numeric AS total_transaction_value
    FROM client c
    JOIN disp dp
        ON c.client_id = dp.client_id
       AND dp.type = 'OWNER'
    JOIN trans t
        ON dp.account_id = t.account_id
    GROUP BY
        c.client_id,
        CASE
            WHEN (
                1998 -
                (
                    1900 +
                    SUBSTRING(
                        LPAD(c.birth_number::text, 6, '0'),
                        1,
                        2
                    )::integer
                )
            ) < 18
                THEN 'Under 18'
            WHEN (
                1998 -
                (
                    1900 +
                    SUBSTRING(
                        LPAD(c.birth_number::text, 6, '0'),
                        1,
                        2
                    )::integer
                )
            ) BETWEEN 18 AND 24
                THEN '18-24'
            WHEN (
                1998 -
                (
                    1900 +
                    SUBSTRING(
                        LPAD(c.birth_number::text, 6, '0'),
                        1,
                        2
                    )::integer
                )
            ) BETWEEN 25 AND 34
                THEN '25-34'
            WHEN (
                1998 -
                (
                    1900 +
                    SUBSTRING(
                        LPAD(c.birth_number::text, 6, '0'),
                        1,
                        2
                    )::integer
                )
            ) BETWEEN 35 AND 44
                THEN '35-44'
            WHEN (
                1998 -
                (
                    1900 +
                    SUBSTRING(
                        LPAD(c.birth_number::text, 6, '0'),
                        1,
                        2
                    )::integer
                )
            ) BETWEEN 45 AND 54
                THEN '45-54'
            WHEN (
                1998 -
                (
                    1900 +
                    SUBSTRING(
                        LPAD(c.birth_number::text, 6, '0'),
                        1,
                        2
                    )::integer
                )
            ) BETWEEN 55 AND 64
                THEN '55-64'
            ELSE '65+'
        END
),
age_summary AS (
    SELECT
        age_group,
        COUNT(*) AS customer_count,
        SUM(transaction_count) AS transaction_count,
        SUM(total_transaction_value)::numeric AS total_transaction_value
    FROM customer_activity
    GROUP BY
        age_group
)
SELECT
    age_group,
    customer_count,
    transaction_count,
    ROUND(
        total_transaction_value,
        2
    ) AS total_transaction_value,
    ROUND(
        total_transaction_value
        / customer_count,
        2
    ) AS average_transaction_value_per_customer,
    ROUND(
        total_transaction_value * 100.0
        / SUM(total_transaction_value) OVER (),
        2
    ) AS transaction_value_share_pct
FROM age_summary
ORDER BY
    CASE age_group
        WHEN 'Under 18' THEN 1
        WHEN '18-24' THEN 2
        WHEN '25-34' THEN 3
        WHEN '35-44' THEN 4
        WHEN '45-54' THEN 5
        WHEN '55-64' THEN 6
        WHEN '65+' THEN 7
    END;
    -- Analyze financial product penetration by region

WITH customer_products AS (
    SELECT
        c.client_id,
        d.region,
        COUNT(DISTINCT l.loan_id) AS loan_count,
        COUNT(DISTINCT ca.card_id) AS card_count
    FROM client c
    JOIN district d
        ON c.district_id = d.district_id
    LEFT JOIN disp dp
        ON c.client_id = dp.client_id
       AND dp.type = 'OWNER'
    LEFT JOIN loan l
        ON dp.account_id = l.account_id
    LEFT JOIN card ca
        ON dp.disp_id = ca.disp_id
    GROUP BY
        c.client_id,
        d.region
),
region_products AS (
    SELECT
        region,
        COUNT(*) AS customer_count,
        COUNT(*) FILTER (
            WHERE loan_count > 0
        ) AS customers_with_loan,
        COUNT(*) FILTER (
            WHERE card_count > 0
        ) AS customers_with_card,
        COUNT(*) FILTER (
            WHERE loan_count > 0
              AND card_count > 0
        ) AS customers_with_both
    FROM customer_products
    GROUP BY
        region
)
SELECT
    region,
    customer_count,
    customers_with_loan,
    customers_with_card,
    customers_with_both,
    ROUND(
        customers_with_loan * 100.0
        / customer_count,
        2
    ) AS loan_penetration_pct,
    ROUND(
        customers_with_card * 100.0
        / customer_count,
        2
    ) AS card_penetration_pct,
    ROUND(
        customers_with_both * 100.0
        / customer_count,
        2
    ) AS combined_product_penetration_pct
FROM region_products
ORDER BY
    customer_count DESC;
    -- Analyze payment-order activity by customer

WITH customer_orders AS (
    SELECT
        dp.client_id,
        COUNT(o.order_id) AS order_count,
        SUM(o.amount)::numeric AS total_order_value
    FROM disp dp
    JOIN "order" o
        ON dp.account_id = o.account_id
    WHERE dp.type = 'OWNER'
    GROUP BY
        dp.client_id
)
SELECT
    COUNT(*) AS customers_with_orders,
    SUM(order_count) AS total_order_count,
    ROUND(
        SUM(total_order_value)::numeric,
        2
    ) AS total_order_value,
    ROUND(
        AVG(order_count)::numeric,
        2
    ) AS average_orders_per_customer,
    ROUND(
        AVG(total_order_value)::numeric,
        2
    ) AS average_order_value_per_customer
FROM customer_orders;
-- Analyze payment-order mix by customer

SELECT
    CASE
        WHEN TRIM(o.k_symbol) = ''
            THEN 'Unspecified'
        ELSE o.k_symbol
    END AS order_type,
    COUNT(o.order_id) AS order_count,
    COUNT(DISTINCT dp.client_id) AS customer_count,
    ROUND(
        SUM(o.amount)::numeric,
        2
    ) AS total_order_value,
    ROUND(
        AVG(o.amount)::numeric,
        2
    ) AS average_order_value,
    ROUND(
        COUNT(o.order_id) * 100.0
        / SUM(COUNT(o.order_id)) OVER (),
        2
    ) AS order_count_share_pct,
    ROUND(
        SUM(o.amount) * 100.0
        / SUM(SUM(o.amount)) OVER (),
        2
    ) AS order_value_share_pct
FROM "order" o
JOIN disp dp
    ON o.account_id = dp.account_id
   AND dp.type = 'OWNER'
GROUP BY
    CASE
        WHEN TRIM(o.k_symbol) = ''
            THEN 'Unspecified'
        ELSE o.k_symbol
    END
ORDER BY
    total_order_value DESC;
    -- Analyze transaction activity by region and customer product profile

WITH customer_products AS (
    SELECT
        c.client_id,
        d.region,
        CASE
            WHEN COUNT(DISTINCT l.loan_id) > 0
                 AND COUNT(DISTINCT ca.card_id) > 0
                THEN 'Loan + Card'
            WHEN COUNT(DISTINCT l.loan_id) > 0
                THEN 'Loan Only'
            WHEN COUNT(DISTINCT ca.card_id) > 0
                THEN 'Card Only'
            ELSE 'Neither'
        END AS product_profile
    FROM client c
    JOIN district d
        ON c.district_id = d.district_id
    LEFT JOIN disp dp
        ON c.client_id = dp.client_id
       AND dp.type = 'OWNER'
    LEFT JOIN loan l
        ON dp.account_id = l.account_id
    LEFT JOIN card ca
        ON dp.disp_id = ca.disp_id
    GROUP BY
        c.client_id,
        d.region
),
customer_activity AS (
    SELECT
        dp.client_id,
        COUNT(t.trans_id) AS transaction_count,
        SUM(t.amount)::numeric AS total_transaction_value
    FROM disp dp
    JOIN trans t
        ON dp.account_id = t.account_id
    WHERE dp.type = 'OWNER'
    GROUP BY
        dp.client_id
),
region_profile_activity AS (
    SELECT
        cp.region,
        cp.product_profile,
        cp.client_id,
        COALESCE(
            ca.transaction_count,
            0
        ) AS transaction_count,
        COALESCE(
            ca.total_transaction_value,
            0
        ) AS total_transaction_value
    FROM customer_products cp
    LEFT JOIN customer_activity ca
        ON cp.client_id = ca.client_id
)
SELECT
    region,
    product_profile,
    COUNT(*) AS customer_count,
    ROUND(
        AVG(transaction_count)::numeric,
        2
    ) AS average_transaction_count,
    ROUND(
        AVG(total_transaction_value)::numeric,
        2
    ) AS average_transaction_value_per_customer,
    ROUND(
        SUM(total_transaction_value)::numeric,
        2
    ) AS total_transaction_value
FROM region_profile_activity
GROUP BY
    region,
    product_profile
ORDER BY
    region,
    total_transaction_value DESC;
    -- Identify high-value customers associated with multiple anomaly indicators

WITH customer_activity AS (
    SELECT
        dp.client_id,
        SUM(t.amount)::numeric AS total_transaction_value
    FROM disp dp
    JOIN trans t
        ON dp.account_id = t.account_id
    WHERE dp.type = 'OWNER'
    GROUP BY
        dp.client_id
),
customer_deciles AS (
    SELECT
        client_id,
        total_transaction_value,
        NTILE(10) OVER (
            ORDER BY total_transaction_value DESC
        ) AS customer_decile
    FROM customer_activity
),
account_anomaly_indicators AS (
    SELECT
        t.account_id,
        COUNT(*) FILTER (
            WHERE t.balance < 0
        ) AS negative_balance_count,
        COUNT(*) FILTER (
            WHERE t.amount > (
                SELECT PERCENTILE_CONT(0.99)
                WITHIN GROUP (ORDER BY amount)
                FROM trans
            )
        ) AS large_transaction_count
    FROM trans t
    GROUP BY
        t.account_id
),
customers_with_anomalies AS (
    SELECT
        dp.client_id,
        COUNT(DISTINCT dp.account_id) AS affected_account_count
    FROM disp dp
    JOIN account_anomaly_indicators aai
        ON dp.account_id = aai.account_id
    WHERE dp.type = 'OWNER'
      AND aai.negative_balance_count > 0
      AND aai.large_transaction_count > 0
    GROUP BY
        dp.client_id
)
SELECT
    cd.client_id,
    ROUND(
        cd.total_transaction_value,
        2
    ) AS total_transaction_value,
    cd.customer_decile,
    COALESCE(
        cwa.affected_account_count,
        0
    ) AS affected_account_count
FROM customer_deciles cd
LEFT JOIN customers_with_anomalies cwa
    ON cd.client_id = cwa.client_id
WHERE cd.customer_decile = 1
  AND cwa.client_id IS NOT NULL
ORDER BY
    cd.total_transaction_value DESC;
    -- Analyze customer activity consistency across years

WITH customer_yearly_activity AS (
    SELECT
        dp.client_id,
        EXTRACT(
            YEAR FROM TO_DATE(
                t.date::text,
                'YYMMDD'
            )
        ) AS transaction_year,
        COUNT(t.trans_id) AS transaction_count,
        SUM(t.amount)::numeric AS transaction_value
    FROM disp dp
    JOIN trans t
        ON dp.account_id = t.account_id
    WHERE dp.type = 'OWNER'
    GROUP BY
        dp.client_id,
        EXTRACT(
            YEAR FROM TO_DATE(
                t.date::text,
                'YYMMDD'
            )
        )
),
customer_activity_summary AS (
    SELECT
        client_id,
        COUNT(*) AS active_year_count,
        SUM(transaction_count) AS total_transaction_count,
        SUM(transaction_value)::numeric AS total_transaction_value
    FROM customer_yearly_activity
    GROUP BY
        client_id
)
SELECT
    active_year_count,
    COUNT(*) AS customer_count,
    ROUND(
        AVG(total_transaction_count)::numeric,
        2
    ) AS average_transaction_count,
    ROUND(
        AVG(total_transaction_value)::numeric,
        2
    ) AS average_transaction_value,
    ROUND(
        AVG(
            total_transaction_value
            / active_year_count
        )::numeric,
        2
    ) AS average_annual_transaction_value
FROM customer_activity_summary
GROUP BY
    active_year_count
ORDER BY
    active_year_count;
    -- Create customer activity tiers based on transaction value

WITH customer_activity AS (
    SELECT
        dp.client_id,
        COUNT(t.trans_id) AS transaction_count,
        SUM(t.amount)::numeric AS total_transaction_value
    FROM disp dp
    JOIN trans t
        ON dp.account_id = t.account_id
    WHERE dp.type = 'OWNER'
    GROUP BY
        dp.client_id
),
customer_segments AS (
    SELECT
        client_id,
        transaction_count,
        total_transaction_value,
        NTILE(10) OVER (
            ORDER BY total_transaction_value DESC
        ) AS customer_decile
    FROM customer_activity
)
SELECT
    CASE
        WHEN customer_decile = 1
            THEN 'High Value'
        WHEN customer_decile BETWEEN 2 AND 5
            THEN 'Medium Value'
        ELSE 'Lower Value'
    END AS activity_tier,
    COUNT(*) AS customer_count,
    ROUND(
        AVG(transaction_count)::numeric,
        2
    ) AS average_transaction_count,
    ROUND(
        AVG(total_transaction_value)::numeric,
        2
    ) AS average_transaction_value,
    ROUND(
        SUM(total_transaction_value)::numeric,
        2
    ) AS total_transaction_value,
    ROUND(
        SUM(total_transaction_value) * 100.0
        / SUM(SUM(total_transaction_value)) OVER (),
        2
    ) AS transaction_value_share_pct
FROM customer_segments
GROUP BY
    CASE
        WHEN customer_decile = 1
            THEN 'High Value'
        WHEN customer_decile BETWEEN 2 AND 5
            THEN 'Medium Value'
        ELSE 'Lower Value'
    END
ORDER BY
    CASE
        WHEN (
            CASE
                WHEN customer_decile = 1
                    THEN 'High Value'
                WHEN customer_decile BETWEEN 2 AND 5
                    THEN 'Medium Value'
                ELSE 'Lower Value'
            END
        ) = 'High Value'
            THEN 1
        WHEN (
            CASE
                WHEN customer_decile = 1
                    THEN 'High Value'
                WHEN customer_decile BETWEEN 2 AND 5
                    THEN 'Medium Value'
                ELSE 'Lower Value'
            END
        ) = 'Medium Value'
            THEN 2
        ELSE 3
    END;