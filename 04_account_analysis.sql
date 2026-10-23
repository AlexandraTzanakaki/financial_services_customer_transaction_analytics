-- Account overview

SELECT
    COUNT(*) AS account_count,
    COUNT(DISTINCT district_id) AS district_count,
    COUNT(DISTINCT frequency) AS frequency_count
FROM account;
-- Account openings by year

SELECT
    EXTRACT(YEAR FROM TO_DATE(date::TEXT, 'YYMMDD')) AS account_open_year,
    COUNT(*) AS account_count
FROM account
GROUP BY account_open_year
ORDER BY account_open_year;
-- Account distribution by frequency

SELECT
    frequency,
    COUNT(*) AS account_count,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS account_share_pct
FROM account
GROUP BY frequency
ORDER BY account_count DESC;
-- Account structure by number of customer associations

SELECT
    customer_count,
    COUNT(*) AS account_count,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS account_share_pct
FROM (
    SELECT
        account_id,
        COUNT(*) AS customer_count
    FROM disp
    GROUP BY account_id
) AS account_relationships
GROUP BY customer_count
ORDER BY customer_count;
-- Account distribution by district

SELECT
    d.district_id,
    d.district_name,
    d.region,
    COUNT(a.account_id) AS account_count
FROM account a
JOIN district d
    ON a.district_id = d.district_id
GROUP BY
    d.district_id,
    d.district_name,
    d.region
ORDER BY account_count DESC;
-- Top 10 districts by account count

SELECT
    d.district_id,
    d.district_name,
    d.region,
    COUNT(a.account_id) AS account_count
FROM account a
JOIN district d
    ON a.district_id = d.district_id
GROUP BY
    d.district_id,
    d.district_name,
    d.region
ORDER BY account_count DESC
LIMIT 10;
-- Account representation per 1,000 residents

SELECT
    d.district_id,
    d.district_name,
    d.region,
    d.population,
    COUNT(a.account_id) AS account_count,
    ROUND(
        COUNT(a.account_id) * 1000.0 / d.population,
        2
    ) AS accounts_per_1000_residents
FROM account a
JOIN district d
    ON a.district_id = d.district_id
GROUP BY
    d.district_id,
    d.district_name,
    d.region,
    d.population
ORDER BY accounts_per_1000_residents DESC;
-- Account activity by account frequency

SELECT
    a.frequency,
    COUNT(DISTINCT a.account_id) AS account_count,
    COUNT(t.trans_id) AS transaction_count,
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
-- Transaction value by account frequency

SELECT
    a.frequency,
    COUNT(DISTINCT a.account_id) AS account_count,
    ROUND(
        SUM(t.amount)::numeric
        / COUNT(DISTINCT a.account_id),
        2
    ) AS average_total_transaction_value_per_account,
    ROUND(
        AVG(t.amount)::numeric,
        2
    ) AS average_transaction_value
FROM account a
JOIN trans t
    ON a.account_id = t.account_id
GROUP BY a.frequency
ORDER BY average_total_transaction_value_per_account DESC;
-- Top 10 accounts by transaction count

SELECT
    account_id,
    COUNT(*) AS transaction_count,
    SUM(amount) AS total_transaction_value,
    ROUND(AVG(amount)::numeric, 2) AS average_transaction_value
FROM trans
GROUP BY account_id
ORDER BY transaction_count DESC
LIMIT 10;
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
-- Number of owned accounts per customer

SELECT
    client_id,
    COUNT(DISTINCT account_id) AS owned_account_count
FROM disp
WHERE type = 'OWNER'
GROUP BY client_id
ORDER BY owned_account_count DESC;
-- Distribution of customers by number of owned accounts

SELECT
    owned_account_count,
    COUNT(*) AS customer_count,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS customer_share_pct
FROM (
    SELECT
        client_id,
        COUNT(DISTINCT account_id) AS owned_account_count
    FROM disp
    WHERE type = 'OWNER'
    GROUP BY client_id
) AS customer_accounts
GROUP BY owned_account_count
ORDER BY owned_account_count;
-- Summary statistics for owned accounts per customer

SELECT
    COUNT(*) AS customer_count,
    MIN(owned_account_count) AS min_owned_accounts,
    MAX(owned_account_count) AS max_owned_accounts,
    ROUND(AVG(owned_account_count)::numeric, 2) AS average_owned_accounts,
    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY owned_account_count)::numeric,
        2
    ) AS median_owned_accounts
FROM (
    SELECT
        client_id,
        COUNT(DISTINCT account_id) AS owned_account_count
    FROM disp
    WHERE type = 'OWNER'
    GROUP BY client_id
) AS customer_accounts;
-- Customers with multiple owned accounts

SELECT
    client_id,
    COUNT(DISTINCT account_id) AS owned_account_count
FROM disp
WHERE type = 'OWNER'
GROUP BY client_id
HAVING COUNT(DISTINCT account_id) > 1
ORDER BY owned_account_count DESC, client_id;
-- Customer transaction activity through owned accounts

SELECT
    d.client_id,
    COUNT(t.trans_id) AS transaction_count,
    SUM(t.amount) AS total_transaction_value,
    ROUND(AVG(t.amount)::numeric, 2) AS average_transaction_value
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
-- Customer transaction activity by district

SELECT
    d.district_id,
    d.district_name,
    d.region,
    COUNT(DISTINCT ca.client_id) AS customer_count,
    ROUND(AVG(ca.transaction_count)::numeric, 2) AS average_transactions_per_customer,
    ROUND(AVG(ca.total_transaction_value)::numeric, 2) AS average_total_transaction_value_per_customer
FROM (
    SELECT
        d.client_id,
        d.account_id,
        COUNT(t.trans_id) AS transaction_count,
        SUM(t.amount) AS total_transaction_value
    FROM disp d
    JOIN trans t
        ON d.account_id = t.account_id
    WHERE d.type = 'OWNER'
    GROUP BY
        d.client_id,
        d.account_id
) AS ca
JOIN client c
    ON ca.client_id = c.client_id
JOIN district d
    ON c.district_id = d.district_id
GROUP BY
    d.district_id,
    d.district_name,
    d.region
ORDER BY average_transactions_per_customer DESC;
-- Customer transaction activity by region

SELECT
    d.region,
    COUNT(DISTINCT ca.client_id) AS customer_count,
    ROUND(
        AVG(ca.transaction_count)::numeric,
        2
    ) AS average_transactions_per_customer,
    ROUND(
        AVG(ca.total_transaction_value)::numeric,
        2
    ) AS average_total_transaction_value_per_customer
FROM (
    SELECT
        d.client_id,
        d.account_id,
        COUNT(t.trans_id) AS transaction_count,
        SUM(t.amount) AS total_transaction_value
    FROM disp d
    JOIN trans t
        ON d.account_id = t.account_id
    WHERE d.type = 'OWNER'
    GROUP BY
        d.client_id,
        d.account_id
) AS ca
JOIN client c
    ON ca.client_id = c.client_id
JOIN district d
    ON c.district_id = d.district_id
GROUP BY d.region
ORDER BY average_transactions_per_customer DESC;
-- Customer transaction activity by age group

SELECT
    age_group,
    COUNT(*) AS customer_count,
    ROUND(
        AVG(transaction_count)::numeric,
        2
    ) AS average_transactions_per_customer,
    ROUND(
        AVG(total_transaction_value)::numeric,
        2
    ) AS average_total_transaction_value_per_customer
FROM (
    SELECT
        c.client_id,

        CASE
            WHEN age_at_reference < 18 THEN 'Under 18'
            WHEN age_at_reference BETWEEN 18 AND 24 THEN '18-24'
            WHEN age_at_reference BETWEEN 25 AND 34 THEN '25-34'
            WHEN age_at_reference BETWEEN 35 AND 44 THEN '35-44'
            WHEN age_at_reference BETWEEN 45 AND 54 THEN '45-54'
            WHEN age_at_reference BETWEEN 55 AND 64 THEN '55-64'
            ELSE '65+'
        END AS age_group,

        COUNT(t.trans_id) AS transaction_count,
        SUM(t.amount) AS total_transaction_value

    FROM (
        SELECT
            client_id,
            birth_number,
            1998
            - (1900 + (birth_number / 10000))
            - CASE
                WHEN
                    (
                        ((birth_number / 100) % 100)
                        - CASE
                            WHEN ((birth_number / 100) % 100) > 50
                                THEN 50
                            ELSE 0
                          END
                    ) > 12
                    OR (
                        (
                            ((birth_number / 100) % 100)
                            - CASE
                                WHEN ((birth_number / 100) % 100) > 50
                                    THEN 50
                                ELSE 0
                              END
                        ) = 12
                        AND (birth_number % 100) > 31
                    )
                THEN 1
                ELSE 0
              END AS age_at_reference
        FROM client
    ) AS c

    JOIN disp d
        ON c.client_id = d.client_id

    JOIN trans t
        ON d.account_id = t.account_id

    WHERE d.type = 'OWNER'

    GROUP BY
        c.client_id,
        c.age_at_reference
) AS customer_activity

GROUP BY age_group

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
    -- Customer transaction activity by gender

SELECT
    CASE
        WHEN ((c.birth_number / 100) % 100) > 50
            THEN 'Female'
        ELSE 'Male'
    END AS gender,
    COUNT(DISTINCT c.client_id) AS customer_count,
    ROUND(
        AVG(ca.transaction_count)::numeric,
        2
    ) AS average_transactions_per_customer,
    ROUND(
        AVG(ca.total_transaction_value)::numeric,
        2
    ) AS average_total_transaction_value_per_customer,
    ROUND(
        AVG(ca.average_transaction_value)::numeric,
        2
    ) AS average_transaction_value
FROM (
    SELECT
        d.client_id,
        COUNT(t.trans_id) AS transaction_count,
        SUM(t.amount) AS total_transaction_value,
        AVG(t.amount) AS average_transaction_value
    FROM disp d
    JOIN trans t
        ON d.account_id = t.account_id
    JOIN client c
        ON d.client_id = c.client_id
    WHERE d.type = 'OWNER'
    GROUP BY d.client_id
) AS ca
JOIN client c
    ON ca.client_id = c.client_id
GROUP BY gender
ORDER BY gender;
-- Customers with owner-associated loans

SELECT
    COUNT(DISTINCT d.client_id) AS customers_with_loans
FROM disp d
JOIN loan l
    ON d.account_id = l.account_id
WHERE d.type = 'OWNER';
-- Customers with owner-associated cards

SELECT
    COUNT(DISTINCT d.client_id) AS customers_with_cards
FROM disp d
JOIN card c
    ON d.disp_id = c.disp_id
WHERE d.type = 'OWNER';
-- Card associations by customer relationship type

SELECT
    d.type AS relationship_type,
    COUNT(DISTINCT d.client_id) AS customer_count,
    COUNT(c.card_id) AS card_count
FROM disp d
JOIN card c
    ON d.disp_id = c.disp_id
GROUP BY d.type
ORDER BY d.type;
-- Customer product profile: Loan, Card, Both, or Neither

WITH customer_products AS (
    SELECT
        c.client_id,

        CASE
            WHEN EXISTS (
                SELECT 1
                FROM disp d
                JOIN loan l
                    ON d.account_id = l.account_id
                WHERE d.client_id = c.client_id
                  AND d.type = 'OWNER'
            )
            THEN TRUE
            ELSE FALSE
        END AS has_loan,

        CASE
            WHEN EXISTS (
                SELECT 1
                FROM disp d
                JOIN card ca
                    ON d.disp_id = ca.disp_id
                WHERE d.client_id = c.client_id
                  AND d.type = 'OWNER'
            )
            THEN TRUE
            ELSE FALSE
        END AS has_card

    FROM client c
)

SELECT
    CASE
        WHEN has_loan = TRUE AND has_card = TRUE
            THEN 'Loan + Card'
        WHEN has_loan = TRUE AND has_card = FALSE
            THEN 'Loan Only'
        WHEN has_loan = FALSE AND has_card = TRUE
            THEN 'Card Only'
        ELSE 'Neither'
    END AS product_profile,
    COUNT(*) AS customer_count,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS customer_share_pct
FROM customer_products
GROUP BY product_profile
ORDER BY customer_count DESC;
-- Customer product profile by age group

WITH customer_products AS (
    SELECT
        c.client_id,

        CASE
            WHEN
                1998 - (1900 + (c.birth_number / 10000))
                - CASE
                    WHEN (
                        ((c.birth_number / 100) % 100)
                        - CASE
                            WHEN ((c.birth_number / 100) % 100) > 50
                                THEN 50
                            ELSE 0
                          END
                    ) > 12
                    OR (
                        (
                            ((c.birth_number / 100) % 100)
                            - CASE
                                WHEN ((c.birth_number / 100) % 100) > 50
                                    THEN 50
                                ELSE 0
                              END
                        ) = 12
                        AND (c.birth_number % 100) > 31
                    )
                    THEN 1
                    ELSE 0
                  END < 18
                THEN 'Under 18'

            WHEN
                1998 - (1900 + (c.birth_number / 10000))
                - CASE
                    WHEN (
                        ((c.birth_number / 100) % 100)
                        - CASE
                            WHEN ((c.birth_number / 100) % 100) > 50
                                THEN 50
                            ELSE 0
                          END
                    ) > 12
                    OR (
                        (
                            ((c.birth_number / 100) % 100)
                            - CASE
                                WHEN ((c.birth_number / 100) % 100) > 50
                                    THEN 50
                                ELSE 0
                              END
                        ) = 12
                        AND (c.birth_number % 100) > 31
                    )
                    THEN 1
                    ELSE 0
                  END BETWEEN 18 AND 24
                THEN '18-24'

            WHEN
                1998 - (1900 + (c.birth_number / 10000))
                - CASE
                    WHEN (
                        ((c.birth_number / 100) % 100)
                        - CASE
                            WHEN ((c.birth_number / 100) % 100) > 50
                                THEN 50
                            ELSE 0
                          END
                    ) > 12
                    OR (
                        (
                            ((c.birth_number / 100) % 100)
                            - CASE
                                WHEN ((c.birth_number / 100) % 100) > 50
                                    THEN 50
                                ELSE 0
                              END
                        ) = 12
                        AND (c.birth_number % 100) > 31
                    )
                    THEN 1
                    ELSE 0
                  END BETWEEN 25 AND 34
                THEN '25-34'

            WHEN
                1998 - (1900 + (c.birth_number / 10000))
                - CASE
                    WHEN (
                        ((c.birth_number / 100) % 100)
                        - CASE
                            WHEN ((c.birth_number / 100) % 100) > 50
                                THEN 50
                            ELSE 0
                          END
                    ) > 12
                    OR (
                        (
                            ((c.birth_number / 100) % 100)
                            - CASE
                                WHEN ((c.birth_number / 100) % 100) > 50
                                    THEN 50
                                ELSE 0
                              END
                        ) = 12
                        AND (c.birth_number % 100) > 31
                    )
                    THEN 1
                    ELSE 0
                  END BETWEEN 35 AND 44
                THEN '35-44'

            WHEN
                1998 - (1900 + (c.birth_number / 10000))
                - CASE
                    WHEN (
                        ((c.birth_number / 100) % 100)
                        - CASE
                            WHEN ((c.birth_number / 100) % 100) > 50
                                THEN 50
                            ELSE 0
                          END
                    ) > 12
                    OR (
                        (
                            ((c.birth_number / 100) % 100)
                            - CASE
                                WHEN ((c.birth_number / 100) % 100) > 50
                                    THEN 50
                                ELSE 0
                              END
                        ) = 12
                        AND (c.birth_number % 100) > 31
                    )
                    THEN 1
                    ELSE 0
                  END BETWEEN 45 AND 54
                THEN '45-54'

            WHEN
                1998 - (1900 + (c.birth_number / 10000))
                - CASE
                    WHEN (
                        ((c.birth_number / 100) % 100)
                        - CASE
                            WHEN ((c.birth_number / 100) % 100) > 50
                                THEN 50
                            ELSE 0
                          END
                    ) > 12
                    OR (
                        (
                            ((c.birth_number / 100) % 100)
                            - CASE
                                WHEN ((c.birth_number / 100) % 100) > 50
                                    THEN 50
                                ELSE 0
                              END
                        ) = 12
                        AND (c.birth_number % 100) > 31
                    )
                    THEN 1
                    ELSE 0
                  END BETWEEN 55 AND 64
                THEN '55-64'

            ELSE '65+'
        END AS age_group,

        CASE
            WHEN EXISTS (
                SELECT 1
                FROM disp d
                JOIN loan l
                    ON d.account_id = l.account_id
                WHERE d.client_id = c.client_id
                  AND d.type = 'OWNER'
            )
            THEN TRUE
            ELSE FALSE
        END AS has_loan,

        CASE
            WHEN EXISTS (
                SELECT 1
                FROM disp d
                JOIN card ca
                    ON d.disp_id = ca.disp_id
                WHERE d.client_id = c.client_id
                  AND d.type = 'OWNER'
            )
            THEN TRUE
            ELSE FALSE
        END AS has_card

    FROM client c
)

SELECT
    age_group,
    CASE
        WHEN has_loan AND has_card THEN 'Loan + Card'
        WHEN has_loan AND NOT has_card THEN 'Loan Only'
        WHEN NOT has_loan AND has_card THEN 'Card Only'
        ELSE 'Neither'
    END AS product_profile,
    COUNT(*) AS customer_count
FROM customer_products
GROUP BY
    age_group,
    product_profile
ORDER BY
    age_group,
    product_profile;
    -- Customer product profile percentages by age group

WITH customer_products AS (
    SELECT
        c.client_id,

        CASE
            WHEN age_at_reference < 18 THEN 'Under 18'
            WHEN age_at_reference BETWEEN 18 AND 24 THEN '18-24'
            WHEN age_at_reference BETWEEN 25 AND 34 THEN '25-34'
            WHEN age_at_reference BETWEEN 35 AND 44 THEN '35-44'
            WHEN age_at_reference BETWEEN 45 AND 54 THEN '45-54'
            WHEN age_at_reference BETWEEN 55 AND 64 THEN '55-64'
            ELSE '65+'
        END AS age_group,

        CASE
            WHEN EXISTS (
                SELECT 1
                FROM disp d
                JOIN loan l
                    ON d.account_id = l.account_id
                WHERE d.client_id = c.client_id
                  AND d.type = 'OWNER'
            )
            THEN TRUE
            ELSE FALSE
        END AS has_loan,

        CASE
            WHEN EXISTS (
                SELECT 1
                FROM disp d
                JOIN card ca
                    ON d.disp_id = ca.disp_id
                WHERE d.client_id = c.client_id
                  AND d.type = 'OWNER'
            )
            THEN TRUE
            ELSE FALSE
        END AS has_card

    FROM (
        SELECT
            client_id,
            birth_number,
            1998
            - (1900 + (birth_number / 10000))
            - CASE
                WHEN (
                    ((birth_number / 100) % 100)
                    - CASE
                        WHEN ((birth_number / 100) % 100) > 50
                            THEN 50
                        ELSE 0
                      END
                ) > 12
                OR (
                    (
                        ((birth_number / 100) % 100)
                        - CASE
                            WHEN ((birth_number / 100) % 100) > 50
                                THEN 50
                            ELSE 0
                          END
                    ) = 12
                    AND (birth_number % 100) > 31
                )
                THEN 1
                ELSE 0
              END AS age_at_reference
        FROM client
    ) AS c
)

SELECT
    age_group,
    CASE
        WHEN has_loan AND has_card THEN 'Loan + Card'
        WHEN has_loan AND NOT has_card THEN 'Loan Only'
        WHEN NOT has_loan AND has_card THEN 'Card Only'
        ELSE 'Neither'
    END AS product_profile,
    COUNT(*) AS customer_count,
    ROUND(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER (PARTITION BY age_group),
        2
    ) AS percentage_within_age_group
FROM customer_products
GROUP BY
    age_group,
    product_profile
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
    product_profile;
    -- Customer product profile by gender

WITH customer_products AS (
    SELECT
        c.client_id,

        CASE
            WHEN ((c.birth_number / 100) % 100) > 50
                THEN 'Female'
            ELSE 'Male'
        END AS gender,

        CASE
            WHEN EXISTS (
                SELECT 1
                FROM disp d
                JOIN loan l
                    ON d.account_id = l.account_id
                WHERE d.client_id = c.client_id
                  AND d.type = 'OWNER'
            )
            THEN TRUE
            ELSE FALSE
        END AS has_loan,

        CASE
            WHEN EXISTS (
                SELECT 1
                FROM disp d
                JOIN card ca
                    ON d.disp_id = ca.disp_id
                WHERE d.client_id = c.client_id
                  AND d.type = 'OWNER'
            )
            THEN TRUE
            ELSE FALSE
        END AS has_card

    FROM client c
)

SELECT
    gender,
    CASE
        WHEN has_loan AND has_card THEN 'Loan + Card'
        WHEN has_loan AND NOT has_card THEN 'Loan Only'
        WHEN NOT has_loan AND has_card THEN 'Card Only'
        ELSE 'Neither'
    END AS product_profile,
    COUNT(*) AS customer_count,
    ROUND(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER (PARTITION BY gender),
        2
    ) AS percentage_within_gender
FROM customer_products
GROUP BY
    gender,
    product_profile
ORDER BY
    gender,
    product_profile;
    -- Loan portfolio by status

SELECT
    status,
    COUNT(*) AS loan_count,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS loan_share_pct,
    ROUND(
        SUM(amount)::numeric,
        2
    ) AS total_loan_amount,
    ROUND(
        AVG(amount)::numeric,
        2
    ) AS average_loan_amount
FROM loan
GROUP BY status
ORDER BY loan_count DESC;
-- Descriptive loan risk indicator

SELECT
    CASE
        WHEN status IN ('B', 'D') THEN 'Risk Indicator'
        ELSE 'No Risk Indicator'
    END AS risk_indicator,
    COUNT(*) AS loan_count,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS loan_share_pct,
    ROUND(
        SUM(amount)::numeric,
        2
    ) AS total_loan_amount,
    ROUND(
        AVG(amount)::numeric,
        2
    ) AS average_loan_amount
FROM loan
GROUP BY
    risk_indicator
ORDER BY
    loan_count DESC;
    -- Transaction activity by loan risk indicator

SELECT
    CASE
        WHEN l.status IN ('B', 'D') THEN 'Risk Indicator'
        ELSE 'No Risk Indicator'
    END AS risk_indicator,
    COUNT(DISTINCT l.loan_id) AS loan_count,
    COUNT(DISTINCT l.account_id) AS account_count,
    COUNT(t.trans_id) AS transaction_count,
    ROUND(
        COUNT(t.trans_id)::numeric
        / COUNT(DISTINCT l.account_id),
        2
    ) AS average_transactions_per_account,
    ROUND(
        SUM(t.amount)::numeric
        / COUNT(DISTINCT l.account_id),
        2
    ) AS average_total_transaction_value_per_account
FROM loan l
JOIN trans t
    ON l.account_id = t.account_id
GROUP BY risk_indicator
ORDER BY risk_indicator;
-- Card portfolio by card type

SELECT
    type AS card_type,
    COUNT(*) AS card_count,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS card_share_pct
FROM card
GROUP BY type
ORDER BY card_count DESC;
-- Transaction activity by card type

SELECT
    c.type AS card_type,
    COUNT(DISTINCT c.card_id) AS card_count,
    COUNT(t.trans_id) AS transaction_count,
    ROUND(
        COUNT(t.trans_id)::numeric
        / COUNT(DISTINCT c.card_id),
        2
    ) AS average_transactions_per_card,
    ROUND(
        SUM(t.amount)::numeric
        / COUNT(DISTINCT c.card_id),
        2
    ) AS average_total_transaction_value_per_card
FROM card c
JOIN disp d
    ON c.disp_id = d.disp_id
JOIN trans t
    ON d.account_id = t.account_id
GROUP BY c.type
ORDER BY average_transactions_per_card DESC;
-- Card issuance by year

SELECT
    EXTRACT(YEAR FROM issued) AS issue_year,
    COUNT(*) AS card_count
FROM card
GROUP BY issue_year
ORDER BY issue_year;
-- Card issuance by year and card type

SELECT
    EXTRACT(YEAR FROM issued) AS issue_year,
    type AS card_type,
    COUNT(*) AS card_count,
    ROUND(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER (PARTITION BY EXTRACT(YEAR FROM issued)),
        2
    ) AS percentage_of_yearly_issuance
FROM card
GROUP BY
    issue_year,
    card_type
ORDER BY
    issue_year,
    card_count DESC;
    -- Card distribution by customer age group

WITH customer_cards AS (
    SELECT
        d.client_id,
        c.type AS card_type
    FROM disp d
    JOIN card c
        ON d.disp_id = c.disp_id
    WHERE d.type = 'OWNER'
),

customer_ages AS (
    SELECT
        client_id,
        CASE
            WHEN (
                1998
                - (1900 + birth_number / 10000)
                - CASE
                    WHEN (
                        ((birth_number / 100) % 100)
                        - CASE
                            WHEN ((birth_number / 100) % 100) > 50
                            THEN 50
                            ELSE 0
                        END
                    ) > 12
                    OR (
                        ((birth_number / 100) % 100)
                        - CASE
                            WHEN ((birth_number / 100) % 100) > 50
                            THEN 50
                            ELSE 0
                        END
                    ) = 12
                    AND (birth_number % 100) > 31
                THEN 1
                ELSE 0
                END
            ) < 18
                THEN 'Under 18'
            WHEN (
                1998
                - (1900 + birth_number / 10000)
            ) < 25
                THEN '18–24'
            WHEN (
                1998
                - (1900 + birth_number / 10000)
            ) < 35
                THEN '25–34'
            WHEN (
                1998
                - (1900 + birth_number / 10000)
            ) < 45
                THEN '35–44'
            WHEN (
                1998
                - (1900 + birth_number / 10000)
            ) < 55
                THEN '45–54'
            WHEN (
                1998
                - (1900 + birth_number / 10000)
            ) < 65
                THEN '55–64'
            ELSE '65+'
        END AS age_group
    FROM client
)

SELECT
    ca.age_group,
    cc.card_type,
    COUNT(*) AS card_count,
    ROUND(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER (PARTITION BY ca.age_group),
        2
    ) AS percentage_within_age_group
FROM customer_cards cc
JOIN customer_ages ca
    ON cc.client_id = ca.client_id
GROUP BY
    ca.age_group,
    cc.card_type
ORDER BY
    ca.age_group,
    card_count DESC;
 -- Payment order distribution by type

SELECT
    COALESCE(NULLIF(TRIM(k_symbol), ''), 'Unspecified') AS order_type,
    COUNT(*) AS order_count,
    ROUND(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER (),
        2
    ) AS order_share_pct,
    ROUND(
        SUM(amount)::numeric,
        2
    ) AS total_order_value,
    ROUND(
        AVG(amount)::numeric,
        2
    ) AS average_order_value
FROM "order"
GROUP BY
    COALESCE(NULLIF(TRIM(k_symbol), ''), 'Unspecified')
ORDER BY order_count DESC;
-- Payment order value by type

SELECT
    COALESCE(NULLIF(TRIM(k_symbol), ''), 'Unspecified') AS order_type,
    COUNT(*) AS order_count,
    ROUND(
        SUM(amount)::numeric,
        2
    ) AS total_order_value,
    ROUND(
        AVG(amount)::numeric,
        2
    ) AS average_order_value,
    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY amount)::numeric,
        2
    ) AS median_order_value
FROM "order"
GROUP BY
    COALESCE(NULLIF(TRIM(k_symbol), ''), 'Unspecified')
ORDER BY total_order_value DESC;
-- Payment order activity per account

SELECT
    COUNT(DISTINCT account_id) AS accounts_with_orders,
    COUNT(*) AS total_orders,
    ROUND(
        COUNT(*)::numeric
        / COUNT(DISTINCT account_id),
        2
    ) AS average_orders_per_account,
    MIN(order_count) AS minimum_orders_per_account,
    MAX(order_count) AS maximum_orders_per_account
FROM (
    SELECT
        account_id,
        COUNT(*) AS order_count
    FROM "order"
    GROUP BY account_id
) AS account_orders;
-- Payment order account coverage

SELECT
    COUNT(DISTINCT o.account_id) AS accounts_with_orders,
    COUNT(a.account_id) AS total_accounts,
    ROUND(
        COUNT(DISTINCT o.account_id) * 100.0
        / COUNT(a.account_id),
        2
    ) AS account_coverage_pct
FROM account a
LEFT JOIN "order" o
    ON a.account_id = o.account_id;
    -- Validate payment order account coverage

SELECT
    COUNT(*) AS total_accounts,
    COUNT(DISTINCT o.account_id) AS accounts_with_orders,
    COUNT(*) - COUNT(DISTINCT o.account_id) AS accounts_without_orders,
    ROUND(
        COUNT(DISTINCT o.account_id) * 100.0
        / COUNT(*),
        2
    ) AS account_coverage_pct
FROM account a
LEFT JOIN "order" o
    ON a.account_id = o.account_id;
    -- Payment order account coverage

SELECT
    COUNT(*) AS total_accounts,
    COUNT(o.account_id) AS accounts_with_orders,
    COUNT(*) - COUNT(o.account_id) AS accounts_without_orders,
    ROUND(
        COUNT(o.account_id) * 100.0
        / COUNT(*),
        2
    ) AS account_coverage_pct
FROM account a
LEFT JOIN (
    SELECT DISTINCT account_id
    FROM "order"
) o
    ON a.account_id = o.account_id;
    -- Distribution of accounts by number of payment orders

SELECT
    order_count,
    COUNT(*) AS account_count,
    ROUND(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER (),
        2
    ) AS account_share_pct
FROM (
    SELECT
        account_id,
        COUNT(*) AS order_count
    FROM "order"
    GROUP BY account_id
) AS account_orders
GROUP BY order_count
ORDER BY order_count;
-- Transactions with negative recorded balances

SELECT
    COUNT(*) AS negative_balance_transactions,
    ROUND(
        COUNT(*) * 100.0
        / (SELECT COUNT(*) FROM trans),
        2
    ) AS percentage_of_transactions
FROM trans
WHERE balance < 0;
-- Accounts with repeated negative balance observations

SELECT
    account_id,
    COUNT(*) AS negative_balance_count
FROM trans
WHERE balance < 0
GROUP BY account_id
ORDER BY negative_balance_count DESC;
-- Summary of negative balance observations per affected account

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
) AS affected_accounts;
-- Top accounts by negative balance frequency

SELECT
    account_id,
    COUNT(*) AS negative_balance_count
FROM trans
WHERE balance < 0
GROUP BY account_id
ORDER BY negative_balance_count DESC
LIMIT 10;
-- Negative balance rate by account

SELECT
    account_id,
    COUNT(*) FILTER (WHERE balance < 0) AS negative_balance_count,
    COUNT(*) AS total_transaction_count,
    ROUND(
        COUNT(*) FILTER (WHERE balance < 0) * 100.0
        / COUNT(*),
        2
    ) AS negative_balance_rate_pct
FROM trans
GROUP BY account_id
HAVING COUNT(*) FILTER (WHERE balance < 0) > 0
ORDER BY negative_balance_rate_pct DESC;
-- Top accounts by negative balance rate

SELECT
    account_id,
    COUNT(*) FILTER (WHERE balance < 0) AS negative_balance_count,
    COUNT(*) AS total_transaction_count,
    ROUND(
        COUNT(*) FILTER (WHERE balance < 0) * 100.0
        / COUNT(*),
        2
    ) AS negative_balance_rate_pct
FROM trans
GROUP BY account_id
HAVING COUNT(*) FILTER (WHERE balance < 0) > 0
ORDER BY negative_balance_rate_pct DESC
LIMIT 15;
-- Transactions above the 99th percentile

WITH percentile_threshold AS (
    SELECT
        PERCENTILE_CONT(0.99)
        WITHIN GROUP (ORDER BY amount) AS threshold
    FROM trans
)

SELECT
    COUNT(*) AS large_transaction_count,
    ROUND(
        COUNT(*) * 100.0
        / (SELECT COUNT(*) FROM trans),
        2
    ) AS percentage_of_transactions,
    ROUND(
        (SELECT threshold FROM percentile_threshold)::numeric,
        2
    ) AS percentile_99_threshold
FROM trans
WHERE amount > (
    SELECT threshold
    FROM percentile_threshold
);
-- Transactions above the 99th percentile

WITH percentile_threshold AS (
    SELECT
        PERCENTILE_CONT(0.99)
        WITHIN GROUP (ORDER BY amount) AS threshold
    FROM trans
)

SELECT
    COUNT(*) AS large_transaction_count,
    ROUND(
        COUNT(*) * 100.0
        / (SELECT COUNT(*) FROM trans),
        2
    ) AS percentage_of_transactions,
    ROUND(
        MAX(threshold)::numeric,
        2
    ) AS percentile_99_threshold
FROM trans
CROSS JOIN percentile_threshold
WHERE amount > threshold;
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
            SELECT PERCENTILE_CONT(0.99)
            WITHIN GROUP (ORDER BY amount)
            FROM trans
        )::numeric,
        2
    ) AS percentile_99_threshold
FROM trans
WHERE amount > (
    SELECT PERCENTILE_CONT(0.99)
    WITHIN GROUP (ORDER BY amount)
    FROM trans
);
-- Accounts with both negative balances and unusually large transactions

SELECT
    COUNT(*) AS accounts_with_both_indicators
FROM (
    SELECT
        account_id
    FROM trans
    GROUP BY account_id
    HAVING
        COUNT(*) FILTER (WHERE balance < 0) > 0
        AND
        COUNT(*) FILTER (
            WHERE amount > (
                SELECT PERCENTILE_CONT(0.99)
                WITHIN GROUP (ORDER BY amount)
                FROM trans
            )
        ) > 0
) AS flagged_accounts;
-- Activity profile of accounts with both anomaly indicators

SELECT
    account_id,
    COUNT(*) FILTER (WHERE balance < 0) AS negative_balance_count,
    COUNT(*) AS total_transaction_count,
    ROUND(
        COUNT(*) FILTER (WHERE balance < 0) * 100.0
        / COUNT(*),
        2
    ) AS negative_balance_rate_pct,
    COUNT(*) FILTER (
        WHERE amount > (
            SELECT PERCENTILE_CONT(0.99)
            WITHIN GROUP (ORDER BY amount)
            FROM trans
        )
    ) AS large_transaction_count
FROM trans
GROUP BY account_id
HAVING
    COUNT(*) FILTER (WHERE balance < 0) > 0
    AND
    COUNT(*) FILTER (
        WHERE amount > (
            SELECT PERCENTILE_CONT(0.99)
            WITHIN GROUP (ORDER BY amount)
            FROM trans
        )
    ) > 0
ORDER BY negative_balance_rate_pct DESC;
-- Activity profile of accounts with both anomaly indicators

SELECT
    account_id,
    COUNT(*) FILTER (WHERE balance < 0) AS negative_balance_count,
    COUNT(*) AS total_transaction_count,
    ROUND(
        COUNT(*) FILTER (WHERE balance < 0) * 100.0
        / COUNT(*),
        2
    ) AS negative_balance_rate_pct,
    COUNT(*) FILTER (
        WHERE amount > (
            SELECT
                PERCENTILE_CONT(0.99)
                WITHIN GROUP (ORDER BY amount)
            FROM trans
        )
    ) AS large_transaction_count
FROM trans
GROUP BY account_id
HAVING
    COUNT(*) FILTER (WHERE balance < 0) > 0
    AND
    COUNT(*) FILTER (
        WHERE amount > (
            SELECT
                PERCENTILE_CONT(0.99)
                WITHIN GROUP (ORDER BY amount)
            FROM trans
        )
    ) > 0
ORDER BY negative_balance_rate_pct DESC;
-- Activity profile of accounts with both anomaly indicators

SELECT
    account_id,
    negative_balance_count,
    total_transaction_count,
    negative_balance_rate_pct,
    large_transaction_count
FROM (
    SELECT
        account_id,
        COUNT(*) FILTER (WHERE balance < 0) AS negative_balance_count,
        COUNT(*) AS total_transaction_count,
        ROUND(
            COUNT(*) FILTER (WHERE balance < 0) * 100.0
            / COUNT(*),
            2
        ) AS negative_balance_rate_pct,
        COUNT(*) FILTER (
            WHERE amount > (
                SELECT
                    PERCENTILE_CONT(0.99)
                    WITHIN GROUP (ORDER BY amount)
                FROM trans
            )
        ) AS large_transaction_count
    FROM trans
    GROUP BY account_id
) AS account_metrics
WHERE negative_balance_count > 0
  AND large_transaction_count > 0
ORDER BY negative_balance_rate_pct DESC;