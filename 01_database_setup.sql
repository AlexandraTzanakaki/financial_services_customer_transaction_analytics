-- Database setup

CREATE TABLE client (
    client_id INTEGER PRIMARY KEY,
    birth_number INTEGER,
    district_id INTEGER
);

CREATE TABLE account (
    account_id INTEGER PRIMARY KEY,
    district_id INTEGER,
    frequency VARCHAR(50),
    date INTEGER
);

CREATE TABLE disp (
    disp_id INTEGER PRIMARY KEY,
    client_id INTEGER,
    account_id INTEGER,
    type VARCHAR(20)
);

CREATE TABLE district (
    district_id INTEGER PRIMARY KEY,
    district_name VARCHAR(100),
    region VARCHAR(100),
    population INTEGER,
    municipalities_under_2000 INTEGER,
    municipalities_2000_9999 INTEGER,
    municipalities_10000_99999 INTEGER,
    municipalities_over_100000 INTEGER,
    number_of_cities INTEGER,
    urban_population_pct NUMERIC,
    average_salary NUMERIC,
    unemployment_rate_1995 NUMERIC,
    unemployment_rate_1996 NUMERIC,
    entrepreneurs_per_1000 NUMERIC,
    crimes_1995 INTEGER,
    crimes_1996 INTEGER
);

CREATE TABLE trans (
    trans_id INTEGER PRIMARY KEY,
    account_id INTEGER,
    date INTEGER,
    type VARCHAR(20),
    operation VARCHAR(50),
    amount NUMERIC,
    balance NUMERIC,
    k_symbol VARCHAR(50),
    bank VARCHAR(20),
    partner_account BIGINT
);

CREATE TABLE loan (
    loan_id INTEGER PRIMARY KEY,
    account_id INTEGER,
    date INTEGER,
    amount NUMERIC,
    duration INTEGER,
    payments NUMERIC,
    status VARCHAR(10)
);

CREATE TABLE card (
    card_id INTEGER PRIMARY KEY,
    disp_id INTEGER,
    type VARCHAR(20),
    issued TIMESTAMP
);

CREATE TABLE "order" (
    order_id INTEGER PRIMARY KEY,
    account_id INTEGER,
    bank_to VARCHAR(20),
    account_to BIGINT,
    amount NUMERIC,
    k_symbol VARCHAR(50)
);