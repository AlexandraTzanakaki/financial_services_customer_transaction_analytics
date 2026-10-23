-- Data quality checks
SELECT 'client' AS table_name, COUNT(*) AS row_count
FROM client

UNION ALL

SELECT 'account', COUNT(*)
FROM account

UNION ALL

SELECT 'disp', COUNT(*)
FROM disp

UNION ALL

SELECT 'district', COUNT(*)
FROM district

UNION ALL

SELECT 'loan', COUNT(*)
FROM loan

UNION ALL

SELECT 'card', COUNT(*)
FROM card

UNION ALL

SELECT 'order', COUNT(*)
FROM "order"

UNION ALL

SELECT 'trans', COUNT(*)
FROM trans;
-- Check for duplicate client IDs

SELECT
    client_id,
    COUNT(*) AS duplicate_count
FROM client
GROUP BY client_id
HAVING COUNT(*) > 1;
-- Check for duplicate account IDs

SELECT
    account_id,
    COUNT(*) AS duplicate_count
FROM account
GROUP BY account_id
HAVING COUNT(*) > 1;
-- Check for duplicate disposition IDs

SELECT
    disp_id,
    COUNT(*) AS duplicate_count
FROM disp
GROUP BY disp_id
HAVING COUNT(*) > 1;
-- Check for duplicate district IDs

SELECT
    district_id,
    COUNT(*) AS duplicate_count
FROM district
GROUP BY district_id
HAVING COUNT(*) > 1;
-- Check for duplicate loan IDs

SELECT
    loan_id,
    COUNT(*) AS duplicate_count
FROM loan
GROUP BY loan_id
HAVING COUNT(*) > 1;
-- Check for duplicate card IDs

SELECT
    card_id,
    COUNT(*) AS duplicate_count
FROM card
GROUP BY card_id
HAVING COUNT(*) > 1;
-- Check for duplicate order IDs

SELECT
    order_id,
    COUNT(*) AS duplicate_count
FROM "order"
GROUP BY order_id
HAVING COUNT(*) > 1;
-- Check for duplicate transaction IDs

SELECT
    trans_id,
    COUNT(*) AS duplicate_count
FROM trans
GROUP BY trans_id
HAVING COUNT(*) > 1;
-- Check missing values in the client table

SELECT
    COUNT(*) AS total_rows,
    COUNT(client_id) AS client_id_present,
    COUNT(birth_number) AS birth_number_present,
    COUNT(district_id) AS district_id_present
FROM client;
-- Check missing values in the account table

SELECT
    COUNT(*) AS total_rows,
    COUNT(account_id) AS account_id_present,
    COUNT(district_id) AS district_id_present,
    COUNT(frequency) AS frequency_present,
    COUNT(date) AS date_present
FROM account;
-- Check missing values in the disp table

SELECT
    COUNT(*) AS total_rows,
    COUNT(disp_id) AS disp_id_present,
    COUNT(client_id) AS client_id_present,
    COUNT(account_id) AS account_id_present,
    COUNT(type) AS type_present
FROM disp;
-- Check missing values in the district table

SELECT
    COUNT(*) AS total_rows,
    COUNT(district_id) AS district_id_present,
    COUNT(district_name) AS district_name_present,
    COUNT(region) AS region_present,
    COUNT(population) AS population_present,
    COUNT(average_salary) AS average_salary_present,
    COUNT(unemployment_rate_1995) AS unemployment_1995_present,
    COUNT(unemployment_rate_1996) AS unemployment_1996_present,
    COUNT(entrepreneurs_per_1000) AS entrepreneurs_present
FROM district;
-- Identify the district with missing 1995 unemployment data

SELECT
    district_id,
    district_name,
    region,
    unemployment_rate_1995
FROM district
WHERE unemployment_rate_1995 IS NULL;
-- Check missing values in the loan table

SELECT
    COUNT(*) AS total_rows,
    COUNT(loan_id) AS loan_id_present,
    COUNT(account_id) AS account_id_present,
    COUNT(date) AS date_present,
    COUNT(amount) AS amount_present,
    COUNT(duration) AS duration_present,
    COUNT(payments) AS payments_present,
    COUNT(status) AS status_present
FROM loan;
-- Check missing values in the card table

SELECT
    COUNT(*) AS total_rows,
    COUNT(card_id) AS card_id_present,
    COUNT(disp_id) AS disp_id_present,
    COUNT(type) AS type_present,
    COUNT(issued) AS issued_present
FROM card;
-- Check missing values in the order table

SELECT
    COUNT(*) AS total_rows,
    COUNT(order_id) AS order_id_present,
    COUNT(account_id) AS account_id_present,
    COUNT(bank_to) AS bank_to_present,
    COUNT(account_to) AS account_to_present,
    COUNT(amount) AS amount_present,
    COUNT(k_symbol) AS k_symbol_present
FROM "order";
-- Check missing values in the transaction table

SELECT
    COUNT(*) AS total_rows,
    COUNT(trans_id) AS trans_id_present,
    COUNT(account_id) AS account_id_present,
    COUNT(date) AS date_present,
    COUNT(type) AS type_present,
    COUNT(operation) AS operation_present,
    COUNT(amount) AS amount_present,
    COUNT(balance) AS balance_present,
    COUNT(k_symbol) AS k_symbol_present,
    COUNT(bank) AS bank_present,
    COUNT(partner_account) AS partner_account_present
FROM trans;
-- Inspect partner account values

SELECT
    partner_account,
    COUNT(*) AS transaction_count
FROM trans
GROUP BY partner_account
ORDER BY transaction_count DESC
LIMIT 10;
-- Verify partner account completeness

SELECT
    COUNT(*) AS total_transactions,
    COUNT(partner_account) AS partner_account_present,
    COUNT(*) - COUNT(partner_account) AS partner_account_missing
FROM trans;
-- Check missing values in the transaction table

SELECT
    COUNT(*) AS total_transactions,
    COUNT(trans_id) AS trans_id_present,
    COUNT(account_id) AS account_id_present,
    COUNT(date) AS date_present,
    COUNT(type) AS type_present,
    COUNT(operation) AS operation_present,
    COUNT(amount) AS amount_present,
    COUNT(balance) AS balance_present,
    COUNT(k_symbol) AS k_symbol_present,
    COUNT(bank) AS bank_present,
    COUNT(partner_account) AS partner_account_present
FROM trans;
-- Check transaction-to-account relationships

SELECT
    COUNT(*) AS invalid_account_links
FROM trans t
LEFT JOIN account a
    ON t.account_id = a.account_id
WHERE a.account_id IS NULL;
-- Check loan-to-account relationships

SELECT
    COUNT(*) AS invalid_account_links
FROM loan l
LEFT JOIN account a
    ON l.account_id = a.account_id
WHERE a.account_id IS NULL;
-- Check payment order-to-account relationships

SELECT
    COUNT(*) AS invalid_account_links
FROM "order" o
LEFT JOIN account a
    ON o.account_id = a.account_id
WHERE a.account_id IS NULL;
-- Check card-to-disposition relationships

SELECT
    COUNT(*) AS invalid_disp_links
FROM card c
LEFT JOIN disp d
    ON c.disp_id = d.disp_id
WHERE d.disp_id IS NULL;
-- Check client-to-district relationships

SELECT
    COUNT(*) AS invalid_district_links
FROM client c
LEFT JOIN district d
    ON c.district_id = d.district_id
WHERE d.district_id IS NULL;
-- Check account-to-district relationships

SELECT
    COUNT(*) AS invalid_district_links
FROM account a
LEFT JOIN district d
    ON a.district_id = d.district_id
WHERE d.district_id IS NULL;
-- Check disposition-to-client relationships

SELECT
    COUNT(*) AS invalid_client_links
FROM disp d
LEFT JOIN client c
    ON d.client_id = c.client_id
WHERE c.client_id IS NULL;
-- Check the number of owners per account

SELECT
    account_id,
    COUNT(*) AS owner_count
FROM disp
WHERE type = 'OWNER'
GROUP BY account_id
HAVING COUNT(*) <> 1;
-- Check the number of additional account users

SELECT
    account_id,
    COUNT(*) AS disponent_count
FROM disp
WHERE type = 'DISPONENT'
GROUP BY account_id
HAVING COUNT(*) > 1;
-- Check accounts with multiple customer associations

SELECT
    account_id,
    COUNT(*) AS customer_count
FROM disp
GROUP BY account_id
HAVING COUNT(*) > 1;
-- Count accounts with multiple customer associations

SELECT
    COUNT(*) AS shared_account_count
FROM (
    SELECT
        account_id
    FROM disp
    GROUP BY account_id
    HAVING COUNT(*) > 1
) AS shared_accounts;
-- Verify the structure of shared accounts

SELECT
    d.account_id,
    COUNT(*) FILTER (WHERE d.type = 'OWNER') AS owner_count,
    COUNT(*) FILTER (WHERE d.type = 'DISPONENT') AS disponent_count
FROM disp d
GROUP BY d.account_id
HAVING COUNT(*) > 1
   AND (
       COUNT(*) FILTER (WHERE d.type = 'OWNER') <> 1
       OR COUNT(*) FILTER (WHERE d.type = 'DISPONENT') <> 1
   );
   -- Check for negative transaction amounts

SELECT
    COUNT(*) AS negative_amount_transactions
FROM trans
WHERE amount < 0;
-- Check for zero-value transactions

SELECT
    COUNT(*) AS zero_amount_transactions
FROM trans
WHERE amount = 0;
-- Check for invalid transaction types

SELECT
    type,
    COUNT(*) AS transaction_count
FROM trans
GROUP BY type
ORDER BY type;
-- Check for invalid loan statuses

SELECT
    status,
    COUNT(*) AS loan_count
FROM loan
GROUP BY status
ORDER BY status;
-- Check for invalid customer-account relationship types

SELECT
    type,
    COUNT(*) AS relationship_count
FROM disp
GROUP BY type
ORDER BY type;
-- Check account frequency categories

SELECT
    frequency,
    COUNT(*) AS account_count
FROM account
GROUP BY frequency
ORDER BY frequency;
-- Check transaction date range

SELECT
    MIN(date) AS earliest_transaction_date,
    MAX(date) AS latest_transaction_date
FROM trans;
-- Check negative recorded balances

SELECT
    COUNT(*) AS negative_balance_transactions
FROM trans
WHERE balance < 0;
-- Check for invalid negative loan amounts

SELECT
    COUNT(*) AS negative_loan_amounts
FROM loan
WHERE amount < 0;