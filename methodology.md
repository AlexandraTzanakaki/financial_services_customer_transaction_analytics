## SQL Analysis

The SQL analysis was conducted in PostgreSQL using DBeaver and focused on customer, account, transaction, product, geographic, and risk-oriented analysis.

### Transaction Analysis

The analysis examined transaction volume, transaction value, average transaction amount, transaction trends over time, transaction activity by account frequency, and transaction activity by customer characteristics.

### Customer Analysis

Customer-level analysis included transaction activity, transaction-value rankings, customer concentration, customer deciles, activity tiers, age groups, gender groups, and customer activity consistency across years.

### Account Analysis

Account-level analysis included account frequency, transaction activity, geographic distribution, shared-account relationships, transaction-value rankings, and payment-order activity.

### Product Analysis

Financial product analysis covered loan and card ownership, customer product profiles, product penetration by age, gender, and region, loan portfolio characteristics, loan status indicators, and card portfolio activity.

### Geographic Analysis

District and regional analysis examined customer activity, transaction value, transaction value per customer, district contribution to total transaction value, regional product penetration, and relationships between transaction activity and district characteristics.

### Risk and Anomaly Analysis

Risk-oriented analysis used descriptive indicators rather than confirmed fraud labels. The analysis examined negative recorded balances, unusually large transactions based on the 99th percentile, accounts exhibiting both indicators, and high-value customers associated with accounts containing multiple anomaly indicators.

These indicators identify activity that may warrant further investigation; they do not establish fraudulent behaviour or customer default.

### Advanced SQL Techniques

The project demonstrates the use of:

- Common Table Expressions (CTEs)
- Subqueries
- Window functions
- `RANK()` and `DENSE_RANK()`
- `NTILE()`
- `PERCENT_RANK()`
- Conditional aggregation
- `FILTER`
- `COUNT(DISTINCT ...)`
- Date transformation and aggregation
- Customer and account-level segmentation
- Concentration and contribution analysis