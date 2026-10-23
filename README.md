# Financial Services Customer & Transaction Analytics
### An End-to-End Data Analytics Portfolio Project

---

## Overview

This project presents an end-to-end data analytics solution using the PKDD '99 Czech Bank Dataset, a historical banking dataset from the Czech Republic covering the period from 1993 to 1998.

The project explores customer demographics, account ownership, banking transactions, loan performance, payment orders, card usage, and potential risk indicators. It demonstrates how raw relational data can be transformed into structured insights that support business reporting, customer analysis, portfolio monitoring, and risk assessment.

The analytical workflow combines Python, PostgreSQL, Excel, Tableau, and Power BI. It covers data exploration, quality assessment, data preparation, relational modeling, SQL analysis, feature engineering, KPI development, visualization, and business recommendations.

The purpose is to demonstrate practical data analytics skills through a financial-services project that connects technical analysis with business-oriented questions.
<img width="1202" height="672" alt="image" src="https://github.com/user-attachments/assets/c2bbaa21-1b6f-4aa0-b90d-45be0a269bcd" />
<img width="1202" height="678" alt="image" src="https://github.com/user-attachments/assets/7d2a0fdd-38ca-4374-960a-fb6ab130411b" />
<img width="1203" height="677" alt="image" src="https://github.com/user-attachments/assets/f54ba7f9-ce15-464f-a6ed-98feee4d00ab" />

## Business Context

Financial institutions generate and manage large volumes of customer, account, transaction, and lending data. When analyzed effectively, these data can help organizations understand customer characteristics, monitor product usage, evaluate portfolio performance, and identify patterns that deserve further investigation.

However, the usefulness of an analysis depends on more than the volume of data. Data quality, the relationships between tables, the definition of business metrics, and the interpretation of analytical results are equally important.

This project addresses these considerations by examining historical banking activity from multiple perspectives and presenting the results through interactive business intelligence dashboards.

The analysis is exploratory and educational. It does not represent a live banking monitoring system, a credit-scoring model, or a validated fraud detection solution.

## Project Objectives

The main objectives of this project are to:

- Explore customer demographics and geographical distribution.
- Examine account characteristics, opening patterns, and statement frequencies.
- Understand the relationships between customers, accounts, and account dispositions.
- Analyze transaction volumes, values, types, and historical trends.
- Investigate loan characteristics and repayment-status distributions.
- Examine card ownership across different card types.
- Develop indicators to flag transactions for further analytical review.
- Build consistent KPIs and interactive dashboards.
- Compare findings across customer, account, transaction, and product dimensions.
- Translate analytical results into practical business recommendations.
- Demonstrate an end-to-end workflow using several commonly used data analytics and business intelligence tools.

## Dataset Overview

The project uses the PKDD '99 Czech Bank Dataset, which contains historical information about banking customers, accounts, transactions, loans, cards, standing orders, and district-level demographic and economic characteristics.

The dataset consists of eight related tables.

| Table | Records | Description |
|---|---:|---|
| Client | 5,369 | Customer identifiers, birth numbers, and district references |
| Account | 4,500 | Account identifiers, district references, statement frequency, and opening dates |
| Disposition | 5,369 | Relationships between customers and accounts, including relationship types |
| Transaction | 1,056,320 | Transaction dates, types, operations, amounts, balances, and related attributes |
| Loan | 682 | Loan dates, amounts, durations, payments, and repayment statuses |
| Card | 892 | Card identifiers, card types, and issue dates |
| Order | 6,471 | Standing orders and payment instructions |
| District | 77 | District-level demographic, employment, and economic indicators |

The tables provide complementary information that can be combined to investigate customer behavior, account activity, product usage, and portfolio characteristics.

The transaction table is the largest component of the dataset, containing more than one million records. This makes it particularly useful for exploring transaction patterns and historical activity.

Because the dataset is historical, its results should be interpreted within the context of the original observation period rather than as a description of current banking conditions.

## Tools and Technologies

**Python**
- Data loading and initial exploration.
- Data cleaning and quality checks.
- Missing-value and duplicate analysis.
- Date processing and feature engineering.
- Exploratory analysis and validation of analytical results.

**PostgreSQL**
- Relational data storage and querying.
- Joins across related tables.
- Aggregations and grouped analysis.
- SQL-based calculation of business metrics.
- Validation of relationships and analytical outputs.

**Excel**
- Data inspection and supplementary calculations.
- Cross-checking selected results.
- Supporting data review and analysis.

**Tableau**
- Interactive visualizations.
- Customer and account analysis.
- Transaction and product dashboards.
- Visual exploration of trends and portfolio characteristics.

**Power BI**
- KPI reporting.
- Interactive dashboard development.
- Customer, account, transaction, and product analysis.
- Presentation of findings in a business intelligence environment.

## Project Workflow

The project follows a structured end-to-end workflow.

### 1. Data Exploration

The initial stage involves examining the eight source tables, understanding their columns, checking data types, reviewing the number of records, and identifying the purpose of each table.

This stage establishes the analytical context before data preparation begins.

### 2. Data Quality Assessment

Data quality checks examine missing values, duplicate records, unique identifiers, date ranges, categorical values, and consistency between related tables.

Particular attention is given to missing transaction attributes and the consistency of customer, account, and disposition relationships.

### 3. Data Preparation

The preparation stage focuses on making the data suitable for analysis while preserving the meaning of the original records.

Activities include date conversion, standardization of categorical values, handling of missing information, validation of identifiers, and preparation of analytical variables.

Missing values are not automatically treated as errors because some fields may legitimately be absent for particular transaction types.

### 4. Relational Data Modeling

The source tables are connected through their identifiers and relationship keys.

The model supports analysis across customer demographics, accounts, transactions, loans, cards, standing orders, and district characteristics.

The relationships are designed carefully to avoid ambiguous filtering paths and incorrect aggregation.

### 5. Feature Engineering

Additional analytical variables are created where useful, such as customer age groups, account-opening years, transaction time periods, and indicators for selected transaction characteristics.

Derived variables are intended to make comparisons more meaningful and to support consistent analysis across tools.

### 6. SQL Analysis

SQL is used to combine tables, aggregate transaction activity, examine portfolio distributions, calculate metrics, and investigate patterns across different dimensions.

Selected results can be compared with the Python analysis to validate calculations.

### 7. KPI Development

Business metrics are defined consistently before being used in dashboards.

Examples include customer counts, account counts, transaction counts, total transaction value, loan counts, card counts, and selected risk indicators.

The definition of each KPI matters because transaction amounts, loan amounts, account balances, and customer counts measure different things and should not be used interchangeably.

### 8. Visualization and Reporting

Tableau and Power BI dashboards present the analytical results through KPIs, charts, comparisons, and historical trends.

The dashboards are organized around major business questions rather than simply reproducing the source tables.

### 9. Interpretation and Recommendations

The final stage interprets the results, acknowledges the limitations of the dataset, and proposes practical actions that could be considered by a financial-services organization.

## Data Model and Relationships

The eight tables represent different entities and activities within the historical banking environment.

The main relationships include:

- **District to Client:** Connects customers to their district-level characteristics.
- **Client to Disposition:** Identifies the accounts associated with each customer.
- **Account to Disposition:** Identifies the customers and relationship types associated with each account.
- **Disposition to Card:** Connects cards to the relevant disposition.
- **Account to Transaction:** Connects each transaction to its account.
- **Account to Loan:** Connects loans to the relevant account.
- **Account to Order:** Connects standing orders to the relevant account.

The disposition table is essential because it connects customers and accounts and distinguishes between relationship types such as OWNER and DISPONENT.

An account can be associated with more than one customer. Therefore, account-level transactions should not automatically be interpreted as transactions made exclusively by one individual.

This distinction is important when calculating customer-level activity, comparing customer segments, or interpreting financial behavior.

The data model also requires careful handling of one-to-many relationships. Joining multiple tables without checking their cardinality can duplicate records and inflate counts or monetary totals.

## Key Analytical Areas

### Customer Analytics

Customer analysis examines the demographic characteristics of the available customer base.

Key areas include:

- Distribution by gender.
- Distribution by age group.
- Geographical distribution by district.
- Comparison of customer counts across demographic categories.
- Exploration of the demographic characteristics represented in the dataset.

Age-group calculations use a defined reference date, which should be stated when reporting the results.

### Account Analytics

Account analysis focuses on the characteristics and development of the account portfolio.

Key areas include:

- Account openings over time.
- Distribution by statement frequency.
- Ownership and disposition types.
- Account-level characteristics.
- Relationships between customers and accounts.

These analyses help describe the structure of the available account portfolio and how it developed during the observation period.

### Transaction Analytics

Transaction analysis examines the scale, composition, and historical development of banking activity.

Key areas include:

- Total transaction volume.
- Total transaction value.
- Distribution by transaction type.
- Transaction activity by year and other time periods.
- Transaction amounts and account balances.
- Operation and transaction-category patterns.
- Comparison of transaction activity across accounts and time periods.

The analysis distinguishes transaction counts from transaction values. A category with the highest number of records does not necessarily have the highest total monetary value.

### Loan Analytics

Loan analysis examines the available lending portfolio and its recorded repayment statuses.

Key areas include:

- Number of loans by status.
- Loan amount distribution.
- Loan duration and payment characteristics.
- Comparison of loan portfolio categories.
- Exploration of recorded repayment outcomes.

The four status categories and their original codes must be retained accurately. The original status wording should not be replaced with a simplified label unless that transformation is explicitly documented.

### Card Analytics

Card analysis examines the distribution of cards across the recorded card types.

The dataset contains Classic, Junior, and Gold cards. Comparing these categories helps describe the composition of the recorded card portfolio.

These results describe the cards in the dataset and should not automatically be interpreted as measures of profitability, customer preference, or current product demand.

### Risk Indicator Analysis

The project uses transparent analytical rules to flag transactions for further examination.

The indicators include:

- Transactions associated with negative balances.
- Transactions above a selected high-value threshold.
- Transactions meeting both screening criteria.

The large-transaction threshold is based on the 99th percentile of transaction amounts, approximately 45,454.81 in the dataset's original monetary units.

These indicators support exploratory screening. They are not a validated fraud detection model, and flagged transactions should not be classified as fraudulent without additional evidence.

## Key Findings

The analysis produced several notable findings.

### Customer Demographics

The dataset contains 5,369 customers:

- Male customers: 2,724.
- Female customers: 2,645.

The distribution is nearly balanced between the two recorded gender categories.

Age-group analysis provides an additional perspective on the composition of the customer base. These results describe the customers included in the dataset and do not necessarily represent the wider population of banking customers.

### Account Portfolio

The dataset contains 4,500 accounts. Account-opening dates and statement frequencies allow the portfolio to be examined across time and by account characteristics.

The account-opening pattern varies by year, providing a historical view of how the recorded account portfolio developed.

### Transaction Activity

The transaction table contains 1,056,320 records.

The recorded transaction types include withdrawals, credits, and cash withdrawals. Examining these categories by both count and value helps distinguish the frequency of activity from its monetary contribution.

The total transaction value is approximately 6.26 billion in the dataset's original monetary units.

Transaction activity also changes across the historical observation period, allowing year-by-year comparisons of the recorded banking activity.

### Loan Portfolio

The dataset contains 682 loans with four recorded status categories. Their distribution provides a descriptive view of the loan portfolio and its recorded repayment outcomes.

Loan statuses should be interpreted according to their original definitions. In particular, the distinction between a completed loan, a completed loan not paid, a loan that is running successfully, and a running loan associated with debt is important for accurate reporting.

### Card Portfolio

The dataset contains 892 cards across three types:

- Classic: 659.
- Junior: 145.
- Gold: 88.

These counts describe the composition of the recorded card portfolio.

### Risk Screening

Negative-balance transactions and large transactions can be flagged for additional review. The overlap between screening criteria can also be examined to understand how many transactions meet more than one condition.

A flag indicates that a transaction meets a predefined analytical rule. It does not establish the reason for the transaction or prove misconduct.

## Dashboards and Reporting

The project includes three dashboard themes developed to support different levels of analysis.

### Financial Services Analytics Overview

This dashboard provides a high-level summary of the dataset through key performance indicators and an overview of customer, account, transaction, and product activity.

Its purpose is to help users understand the scale and main characteristics of the available data before exploring individual areas in greater detail.

### Customer & Account Insights

This dashboard focuses on customer demographics, geographical distribution, account-opening patterns, statement frequency, and account relationships.

It provides a structured view of the customer base and account portfolio.

### Transaction, Product & Risk Analysis

This dashboard focuses on transaction activity, transaction values, loan and card portfolios, and selected risk indicators.

It helps users explore transaction patterns and understand which records meet the analytical screening criteria.

The dashboards are designed to support exploration, comparison, and interpretation. They complement the underlying data analysis rather than replacing it.

## Risk Indicators, Limitations, and Data Interpretation

The project has several important limitations.

**Historical data:** The dataset represents banking activity from 1993 to 1998. Its findings should not be treated as a description of current banking conditions.

**Incomplete information:** Some transaction attributes contain missing values. Their absence must be interpreted in context rather than automatically treated as a data error.

**Shared accounts:** More than one customer may be associated with an account. Customer-level transaction attribution therefore requires care.

**Risk indicators:** Negative balances and large transaction amounts can occur for legitimate reasons. Neither indicator proves fraud.

**High-value threshold:** The selected threshold is a statistical screening rule. It does not represent a universal definition of an unusual or suspicious transaction.

**Loan status interpretation:** The original status codes and definitions should be preserved to prevent incorrect classification of loan outcomes.

**Aggregation:** One-to-many joins can duplicate records. Transaction counts and monetary values must be validated after joins to ensure that they are not overstated.

**Business recommendations:** Recommendations are derived from exploratory analysis. Further validation, contextual information, and domain expertise would be needed before applying them in a real financial institution.

## Business Recommendations

The analytical approach suggests several areas that a financial-services organization could consider.

### Improve Transaction Monitoring

Monitor transaction patterns over time and compare activity across transaction categories, accounts, and relevant customer segments. Investigate unusual changes using additional contextual information rather than relying on transaction size alone.

### Strengthen Account Monitoring

Review accounts with repeated negative balances to understand whether the pattern reflects timing, account usage, or potential financial difficulties. Any follow-up should consider the wider account history.

### Improve Portfolio Reporting

Use consistent definitions for transaction counts, transaction values, account balances, and loan amounts. This helps prevent misleading comparisons and supports more reliable reporting.

### Support Customer Segmentation

Combine demographic and account characteristics to describe customer segments. Any resulting segmentation should be evaluated carefully and should not be interpreted as evidence of individual behavior without sufficient supporting data.

### Monitor Loan Performance

Review loan status distributions alongside loan amounts, durations, and payment characteristics. This can support descriptive portfolio monitoring and help identify areas where more detailed analysis may be useful.

### Use Dashboards for Decision Support

Provide stakeholders with access to clearly defined KPIs, historical trends, and interactive filters. Consistent reporting can help users identify patterns and investigate questions more efficiently.

### Validate Risk Indicators

Before using screening indicators operationally, validate them against additional information and documented investigation outcomes. This is necessary to assess whether the indicators are useful and to avoid treating legitimate transactions as confirmed incidents.

These recommendations are proposed applications of the analysis rather than claims that the dataset proves specific customer misconduct, fraud, or financial loss.

## How to Explore the Project

The project materials allow readers to follow the analytical process from the source data through preparation, querying, metric calculation, and dashboard development.

Readers can examine how the tables are connected, how analytical variables are defined, how findings are calculated, and how the results are presented visually.

The project demonstrates how Python, SQL, Excel, Tableau, and Power BI can be combined to transform relational banking data into structured analysis and business-oriented reporting.

## Repository Contents and Availability

To keep the repository within practical storage limits, the original raw dataset and the processed data files are not included. The original dataset can be accessed through the links in the Dataset Attribution section.

The repository includes the analytical notebooks, SQL scripts, and methodology documentation. Excel charts and the Tableau and Power BI dashboards are provided as screenshots for visual reference; the editable Excel chart files and interactive Tableau and Power BI project files are not included.

## Skills Demonstrated

This project demonstrates practical skills in:

- Data loading, cleaning, and validation.
- Exploratory data analysis.
- Relational database concepts and data modeling.
- SQL joins, aggregations, and analytical queries.
- Feature engineering and date processing.
- KPI definition and calculation.
- Financial and transaction analytics.
- Customer and account analysis.
- Loan and card portfolio analysis.
- Exploratory risk indicator development.
- Data visualization and dashboard design.
- Business interpretation and recommendation development.
- Analytical reporting and communication.
- Cross-validation of results across analytical tools.

## Dataset Attribution

This project uses the PKDD '99 Czech Bank Dataset for educational, analytical, and portfolio demonstration purposes.

**Dataset files:** [Access the PKDD '99 Czech Bank Dataset files on GitHub](https://github.com/jlacko/berka-dataset) (public mirror of the original dataset).  
**Dataset description:** [PKDD '99 Financial Dataset](https://relational.fel.cvut.cz/dataset/Financial).

The analysis is based on the available historical records and the methods applied within the project. The findings should be interpreted within the dataset's scope and limitations.

---

# Ανάλυση Πελατών και Συναλλαγών Χρηματοοικονομικών Υπηρεσιών
### Ένα Ολοκληρωμένο Έργο Ανάλυσης Δεδομένων για Επαγγελματικό Portfolio

---

## Επισκόπηση Έργου

Το έργο παρουσιάζει μια ολοκληρωμένη λύση ανάλυσης δεδομένων από την αρχή έως το τέλος, χρησιμοποιώντας το PKDD '99 Czech Bank Dataset, ένα ιστορικό σύνολο τραπεζικών δεδομένων από την Τσεχία για την περίοδο 1993–1998.

Εξετάζονται τα δημογραφικά χαρακτηριστικά των πελατών, η ιδιοκτησία λογαριασμών, οι τραπεζικές συναλλαγές, η απόδοση των δανείων, οι πάγιες εντολές πληρωμών, η χρήση καρτών και πιθανοί δείκτες κινδύνου. Το έργο παρουσιάζει πώς τα ακατέργαστα σχεσιακά δεδομένα μπορούν να μετατραπούν σε οργανωμένα ευρήματα που υποστηρίζουν την επιχειρηματική αναφορά, την ανάλυση πελατών, την παρακολούθηση χαρτοφυλακίων και την αξιολόγηση κινδύνου.

Η αναλυτική διαδικασία συνδυάζει Python, PostgreSQL, Excel, Tableau και Power BI. Καλύπτει την εξερεύνηση και την αξιολόγηση της ποιότητας των δεδομένων, την προετοιμασία και τη μοντελοποίηση, την ανάλυση SQL, τη δημιουργία νέων χαρακτηριστικών, τον υπολογισμό KPIs, την οπτικοποίηση και τη διαμόρφωση επιχειρηματικών προτάσεων.

Σκοπός είναι να αναδειχθούν πρακτικές δεξιότητες ανάλυσης δεδομένων μέσα από ένα έργο χρηματοοικονομικών υπηρεσιών που συνδέει την τεχνική ανάλυση με πραγματικά επιχειρηματικά ερωτήματα.

## Επιχειρηματικό Πλαίσιο

Τα χρηματοπιστωτικά ιδρύματα δημιουργούν και διαχειρίζονται μεγάλους όγκους δεδομένων σχετικά με πελάτες, λογαριασμούς, συναλλαγές και δανεισμό. Όταν τα δεδομένα αυτά αναλύονται αποτελεσματικά, μπορούν να βοηθήσουν στην κατανόηση των χαρακτηριστικών των πελατών, στην παρακολούθηση της χρήσης προϊόντων, στην αξιολόγηση της απόδοσης χαρτοφυλακίων και στον εντοπισμό μοτίβων που απαιτούν περαιτέρω διερεύνηση.

Ωστόσο, η χρησιμότητα μιας ανάλυσης δεν εξαρτάται μόνο από τον όγκο των δεδομένων. Εξίσου σημαντικά είναι η ποιότητα των δεδομένων, οι σχέσεις μεταξύ των πινάκων, ο ορισμός των επιχειρηματικών δεικτών και η ορθή ερμηνεία των αποτελεσμάτων.

Το έργο εξετάζει αυτές τις παραμέτρους μέσα από διαφορετικές οπτικές της ιστορικής τραπεζικής δραστηριότητας και παρουσιάζει τα αποτελέσματα μέσω διαδραστικών dashboards επιχειρηματικής ευφυΐας.

Η ανάλυση έχει διερευνητικό και εκπαιδευτικό χαρακτήρα. Δεν αποτελεί σύστημα ζωντανής τραπεζικής παρακολούθησης, μοντέλο πιστοληπτικής αξιολόγησης ή επικυρωμένη λύση ανίχνευσης απάτης.

## Στόχοι του Έργου

Οι βασικοί στόχοι είναι:

- Η διερεύνηση των δημογραφικών χαρακτηριστικών και της γεωγραφικής κατανομής των πελατών.
- Η εξέταση των χαρακτηριστικών των λογαριασμών, των ημερομηνιών ανοίγματος και της συχνότητας έκδοσης καταστάσεων.
- Η κατανόηση των σχέσεων μεταξύ πελατών, λογαριασμών και dispositions.
- Η ανάλυση του όγκου, της αξίας, των τύπων και των ιστορικών τάσεων των συναλλαγών.
- Η διερεύνηση των χαρακτηριστικών των δανείων και της κατανομής των καταστάσεων αποπληρωμής.
- Η εξέταση της κατοχής καρτών ανά τύπο.
- Η ανάπτυξη δεικτών που επισημαίνουν συναλλαγές για περαιτέρω αναλυτικό έλεγχο.
- Η δημιουργία συνεπών KPIs και διαδραστικών dashboards.
- Η σύγκριση ευρημάτων μεταξύ πελατών, λογαριασμών, συναλλαγών και προϊόντων.
- Η μετατροπή των αποτελεσμάτων σε πρακτικές επιχειρηματικές προτάσεις.
- Η επίδειξη μιας ολοκληρωμένης αναλυτικής διαδικασίας με εργαλεία ανάλυσης δεδομένων και επιχειρηματικής ευφυΐας.

## Επισκόπηση Συνόλου Δεδομένων

Το έργο χρησιμοποιεί το PKDD '99 Czech Bank Dataset, το οποίο περιλαμβάνει ιστορικές πληροφορίες για τραπεζικούς πελάτες, λογαριασμούς, συναλλαγές, δάνεια, κάρτες, πάγιες εντολές και δημογραφικά και οικονομικά χαρακτηριστικά σε επίπεδο περιφέρειας.

Το σύνολο δεδομένων αποτελείται από οκτώ σχετιζόμενους πίνακες.

| Πίνακας | Εγγραφές | Περιγραφή |
|---|---:|---|
| Client | 5.369 | Αναγνωριστικά πελατών, αριθμοί γέννησης και αναφορές περιφέρειας |
| Account | 4.500 | Αναγνωριστικά λογαριασμών, περιφέρειες, συχνότητα καταστάσεων και ημερομηνίες ανοίγματος |
| Disposition | 5.369 | Σχέσεις πελατών και λογαριασμών, συμπεριλαμβανομένων των τύπων σχέσης |
| Transaction | 1.056.320 | Ημερομηνίες και τύποι συναλλαγών, λειτουργίες, ποσά, υπόλοιπα και σχετικά χαρακτηριστικά |
| Loan | 682 | Ημερομηνίες, ποσά, διάρκειες, δόσεις και καταστάσεις αποπληρωμής δανείων |
| Card | 892 | Αναγνωριστικά καρτών, τύποι καρτών και ημερομηνίες έκδοσης |
| Order | 6.471 | Πάγιες εντολές και οδηγίες πληρωμών |
| District | 77 | Δημογραφικοί, εργασιακοί και οικονομικοί δείκτες ανά περιφέρεια |

Οι πίνακες παρέχουν συμπληρωματικές πληροφορίες που μπορούν να συνδυαστούν για τη διερεύνηση της συμπεριφοράς των πελατών, της δραστηριότητας των λογαριασμών, της χρήσης προϊόντων και των χαρακτηριστικών των χαρτοφυλακίων.

Ο πίνακας συναλλαγών αποτελεί το μεγαλύτερο τμήμα του συνόλου δεδομένων, με περισσότερες από ένα εκατομμύριο εγγραφές. Αυτό τον καθιστά ιδιαίτερα χρήσιμο για τη διερεύνηση συναλλακτικών προτύπων και ιστορικής δραστηριότητας.

Επειδή το σύνολο δεδομένων είναι ιστορικό, τα αποτελέσματα πρέπει να ερμηνεύονται στο πλαίσιο της αρχικής περιόδου παρατήρησης και όχι ως περιγραφή των σημερινών τραπεζικών συνθηκών.

## Εργαλεία και Τεχνολογίες

**Python**
- Φόρτωση και αρχική εξερεύνηση δεδομένων.
- Καθαρισμός και έλεγχοι ποιότητας.
- Ανάλυση ελλιπών τιμών και διπλότυπων εγγραφών.
- Επεξεργασία ημερομηνιών και δημιουργία νέων χαρακτηριστικών.
- Διερευνητική ανάλυση και επικύρωση αποτελεσμάτων.

**PostgreSQL**
- Αποθήκευση και αναζήτηση σχεσιακών δεδομένων.
- Συνδέσεις μεταξύ σχετιζόμενων πινάκων.
- Ομαδοποιήσεις και συγκεντρωτική ανάλυση.
- Υπολογισμός επιχειρηματικών δεικτών με SQL.
- Επικύρωση σχέσεων και αναλυτικών αποτελεσμάτων.

**Excel**
- Επιθεώρηση δεδομένων και συμπληρωματικοί υπολογισμοί.
- Διασταύρωση επιλεγμένων αποτελεσμάτων.
- Υποστήριξη ελέγχου και ανάλυσης δεδομένων.

**Tableau**
- Διαδραστικές οπτικοποιήσεις.
- Ανάλυση πελατών και λογαριασμών.
- Dashboards συναλλαγών και προϊόντων.
- Οπτική διερεύνηση τάσεων και χαρακτηριστικών χαρτοφυλακίων.

**Power BI**
- Αναφορά KPIs.
- Ανάπτυξη διαδραστικών dashboards.
- Ανάλυση πελατών, λογαριασμών, συναλλαγών και προϊόντων.
- Παρουσίαση ευρημάτων σε περιβάλλον επιχειρηματικής ευφυΐας.

## Ροή Εργασίας του Έργου

Το έργο ακολουθεί μια δομημένη, ολοκληρωμένη αναλυτική διαδικασία.

### 1. Εξερεύνηση Δεδομένων

Το αρχικό στάδιο περιλαμβάνει την εξέταση των οκτώ πινάκων, την κατανόηση των στηλών τους, τον έλεγχο των τύπων δεδομένων, την καταγραφή του πλήθους εγγραφών και τον προσδιορισμό του σκοπού κάθε πίνακα.

Το στάδιο αυτό δημιουργεί το απαραίτητο αναλυτικό πλαίσιο πριν ξεκινήσει η προετοιμασία των δεδομένων.

### 2. Αξιολόγηση Ποιότητας Δεδομένων

Οι έλεγχοι ποιότητας εξετάζουν ελλιπείς τιμές, διπλότυπες εγγραφές, μοναδικά αναγνωριστικά, χρονικά εύρη, κατηγορικές τιμές και τη συνέπεια μεταξύ σχετιζόμενων πινάκων.

Ιδιαίτερη προσοχή δίνεται στα ελλιπή χαρακτηριστικά συναλλαγών και στη συνέπεια των σχέσεων πελατών, λογαριασμών και dispositions.

### 3. Προετοιμασία Δεδομένων

Η προετοιμασία αποσκοπεί στο να καταστήσει τα δεδομένα κατάλληλα για ανάλυση, διατηρώντας παράλληλα τη σημασία των αρχικών εγγραφών.

Οι εργασίες περιλαμβάνουν μετατροπή ημερομηνιών, τυποποίηση κατηγορικών τιμών, διαχείριση ελλιπών πληροφοριών, επικύρωση αναγνωριστικών και δημιουργία αναλυτικών μεταβλητών.

Οι ελλιπείς τιμές δεν αντιμετωπίζονται αυτόματα ως σφάλματα, καθώς ορισμένα πεδία μπορεί να απουσιάζουν νόμιμα σε συγκεκριμένους τύπους συναλλαγών.

### 4. Σχεσιακή Μοντελοποίηση Δεδομένων

Οι αρχικοί πίνακες συνδέονται μέσω των αναγνωριστικών και των κλειδιών σχέσεων.

Το μοντέλο υποστηρίζει ανάλυση δημογραφικών πελατών, λογαριασμών, συναλλαγών, δανείων, καρτών, πάγιων εντολών και χαρακτηριστικών περιφερειών.

Οι σχέσεις σχεδιάζονται με προσοχή, ώστε να αποφεύγονται αμφίσημες διαδρομές φιλτραρίσματος και λανθασμένες συγκεντρώσεις δεδομένων.

### 5. Δημιουργία Νέων Χαρακτηριστικών

Δημιουργούνται πρόσθετες αναλυτικές μεταβλητές όπου χρειάζεται, όπως ηλικιακές ομάδες, έτη ανοίγματος λογαριασμών, χρονικές περίοδοι συναλλαγών και δείκτες επιλεγμένων χαρακτηριστικών συναλλαγών.

Οι νέες μεταβλητές διευκολύνουν τις ουσιαστικές συγκρίσεις και υποστηρίζουν συνεπή ανάλυση μεταξύ διαφορετικών εργαλείων.

### 6. Ανάλυση με SQL

Η SQL χρησιμοποιείται για τη σύνδεση πινάκων, τη συγκέντρωση συναλλακτικής δραστηριότητας, την εξέταση κατανομών χαρτοφυλακίων, τον υπολογισμό δεικτών και τη διερεύνηση προτύπων σε διαφορετικές διαστάσεις.

Επιλεγμένα αποτελέσματα μπορούν να συγκρίνονται με την ανάλυση Python για την επικύρωση των υπολογισμών.

### 7. Ανάπτυξη KPIs

Οι επιχειρηματικοί δείκτες ορίζονται με συνέπεια πριν χρησιμοποιηθούν στα dashboards.

Παραδείγματα περιλαμβάνουν αριθμό πελατών, αριθμό λογαριασμών, πλήθος συναλλαγών, συνολική αξία συναλλαγών, πλήθος δανείων, πλήθος καρτών και επιλεγμένους δείκτες κινδύνου.

Ο ορισμός κάθε KPI έχει σημασία, καθώς τα ποσά συναλλαγών, τα ποσά δανείων, τα υπόλοιπα λογαριασμών και οι αριθμοί πελατών μετρούν διαφορετικά πράγματα και δεν πρέπει να χρησιμοποιούνται εναλλακτικά.

### 8. Οπτικοποίηση και Αναφορά

Τα dashboards σε Tableau και Power BI παρουσιάζουν τα αναλυτικά αποτελέσματα μέσω KPIs, γραφημάτων, συγκρίσεων και ιστορικών τάσεων.

Η οργάνωση γίνεται γύρω από βασικά επιχειρηματικά ερωτήματα και όχι απλώς με αναπαραγωγή των αρχικών πινάκων.

### 9. Ερμηνεία και Προτάσεις

Το τελικό στάδιο ερμηνεύει τα αποτελέσματα, αναγνωρίζει τους περιορισμούς του συνόλου δεδομένων και προτείνει πρακτικές ενέργειες που θα μπορούσε να εξετάσει ένας οργανισμός χρηματοοικονομικών υπηρεσιών.

## Μοντέλο Δεδομένων και Σχέσεις

Οι οκτώ πίνακες αντιπροσωπεύουν διαφορετικές οντότητες και δραστηριότητες στο ιστορικό τραπεζικό περιβάλλον.

Οι βασικές σχέσεις περιλαμβάνουν:

- **District προς Client:** Συνδέει τους πελάτες με τα χαρακτηριστικά της περιφέρειάς τους.
- **Client προς Disposition:** Προσδιορίζει τους λογαριασμούς που σχετίζονται με κάθε πελάτη.
- **Account προς Disposition:** Προσδιορίζει τους πελάτες και τους τύπους σχέσης που συνδέονται με κάθε λογαριασμό.
- **Disposition προς Card:** Συνδέει τις κάρτες με το αντίστοιχο disposition.
- **Account προς Transaction:** Συνδέει κάθε συναλλαγή με τον λογαριασμό της.
- **Account προς Loan:** Συνδέει τα δάνεια με τον αντίστοιχο λογαριασμό.
- **Account προς Order:** Συνδέει τις πάγιες εντολές με τον αντίστοιχο λογαριασμό.

Ο πίνακας disposition είναι καθοριστικός, επειδή συνδέει πελάτες και λογαριασμούς και διακρίνει τους τύπους σχέσης, όπως OWNER και DISPONENT.

Ένας λογαριασμός μπορεί να συνδέεται με περισσότερους από έναν πελάτες. Επομένως, οι συναλλαγές ενός λογαριασμού δεν πρέπει να ερμηνεύονται αυτόματα ως συναλλαγές που πραγματοποιήθηκαν αποκλειστικά από ένα άτομο.

Η διάκριση αυτή είναι σημαντική κατά τον υπολογισμό της δραστηριότητας σε επίπεδο πελάτη, τη σύγκριση τμημάτων πελατών και την ερμηνεία χρηματοοικονομικής συμπεριφοράς.

Το μοντέλο απαιτεί επίσης προσεκτική διαχείριση των σχέσεων ένα-προς-πολλά. Η σύνδεση πολλών πινάκων χωρίς έλεγχο της πληθικότητας μπορεί να δημιουργήσει διπλότυπες εγγραφές και να αυξήσει τεχνητά τα πλήθη ή τα χρηματικά σύνολα.

## Βασικοί Τομείς Ανάλυσης

### Ανάλυση Πελατών

Η ανάλυση πελατών εξετάζει τα δημογραφικά χαρακτηριστικά της διαθέσιμης πελατειακής βάσης.

Οι βασικοί τομείς περιλαμβάνουν:

- Κατανομή ανά φύλο.
- Κατανομή ανά ηλικιακή ομάδα.
- Γεωγραφική κατανομή ανά περιφέρεια.
- Σύγκριση πλήθους πελατών μεταξύ δημογραφικών κατηγοριών.
- Εξέταση των δημογραφικών χαρακτηριστικών που αντιπροσωπεύονται στο σύνολο δεδομένων.

Οι υπολογισμοί ηλικιακών ομάδων βασίζονται σε συγκεκριμένη ημερομηνία αναφοράς, η οποία πρέπει να αναφέρεται όταν παρουσιάζονται τα αποτελέσματα.

### Ανάλυση Λογαριασμών

Η ανάλυση λογαριασμών εστιάζει στα χαρακτηριστικά και την εξέλιξη του χαρτοφυλακίου.

Οι βασικοί τομείς περιλαμβάνουν:

- Ανοίγματα λογαριασμών διαχρονικά.
- Κατανομή ανά συχνότητα καταστάσεων λογαριασμού.
- Τύπους ιδιοκτησίας και disposition.
- Χαρακτηριστικά σε επίπεδο λογαριασμού.
- Σχέσεις μεταξύ πελατών και λογαριασμών.

Οι αναλύσεις αυτές περιγράφουν τη δομή του διαθέσιμου χαρτοφυλακίου και την εξέλιξή του κατά την περίοδο παρατήρησης.

### Ανάλυση Συναλλαγών

Η ανάλυση συναλλαγών εξετάζει την κλίμακα, τη σύνθεση και την ιστορική εξέλιξη της τραπεζικής δραστηριότητας.

Οι βασικοί τομείς περιλαμβάνουν:

- Συνολικό πλήθος συναλλαγών.
- Συνολική αξία συναλλαγών.
- Κατανομή ανά τύπο συναλλαγής.
- Συναλλακτική δραστηριότητα ανά έτος και άλλες χρονικές περιόδους.
- Ποσά συναλλαγών και υπόλοιπα λογαριασμών.
- Πρότυπα λειτουργιών και κατηγοριών συναλλαγών.
- Σύγκριση συναλλακτικής δραστηριότητας μεταξύ λογαριασμών και χρονικών περιόδων.

Η ανάλυση διακρίνει το πλήθος συναλλαγών από τη συνολική αξία τους. Μια κατηγορία με το μεγαλύτερο πλήθος εγγραφών δεν έχει απαραίτητα και τη μεγαλύτερη συνολική χρηματική αξία.

### Ανάλυση Δανείων

Η ανάλυση δανείων εξετάζει το διαθέσιμο χαρτοφυλάκιο δανεισμού και τις καταγεγραμμένες καταστάσεις αποπληρωμής.

Οι βασικοί τομείς περιλαμβάνουν:

- Πλήθος δανείων ανά κατάσταση.
- Κατανομή ποσών δανείων.
- Χαρακτηριστικά διάρκειας και πληρωμών.
- Σύγκριση κατηγοριών χαρτοφυλακίου δανείων.
- Εξέταση των καταγεγραμμένων αποτελεσμάτων αποπληρωμής.

Οι τέσσερις κατηγορίες καταστάσεων και οι αρχικοί κωδικοί τους πρέπει να διατηρούνται με ακρίβεια. Η αρχική διατύπωση των καταστάσεων δεν πρέπει να αντικαθίσταται από απλουστευμένη ονομασία χωρίς να τεκμηριώνεται η μετατροπή.

### Ανάλυση Καρτών

Η ανάλυση καρτών εξετάζει την κατανομή των καρτών στους καταγεγραμμένους τύπους.

Το σύνολο δεδομένων περιλαμβάνει κάρτες Classic, Junior και Gold. Η σύγκριση αυτών των κατηγοριών περιγράφει τη σύνθεση του διαθέσιμου χαρτοφυλακίου καρτών.

Τα αποτελέσματα περιγράφουν τις κάρτες του συνόλου δεδομένων και δεν πρέπει να ερμηνεύονται αυτόματα ως μέτρα κερδοφορίας, προτίμησης πελατών ή σημερινής ζήτησης προϊόντων.

### Ανάλυση Δεικτών Κινδύνου

Το έργο χρησιμοποιεί διαφανείς αναλυτικούς κανόνες για την επισήμανση συναλλαγών που ενδέχεται να χρειάζονται περαιτέρω εξέταση.

Οι δείκτες περιλαμβάνουν:

- Συναλλαγές που συνδέονται με αρνητικά υπόλοιπα.
- Συναλλαγές πάνω από επιλεγμένο όριο υψηλής αξίας.
- Συναλλαγές που πληρούν και τα δύο κριτήρια ελέγχου.

Το όριο μεγάλων συναλλαγών βασίζεται στο 99ο εκατοστημόριο των ποσών συναλλαγών και είναι περίπου 45.454,81 στις αρχικές νομισματικές μονάδες του συνόλου δεδομένων.

Οι δείκτες υποστηρίζουν διερευνητικό έλεγχο. Δεν αποτελούν επικυρωμένο μοντέλο ανίχνευσης απάτης και οι συναλλαγές που επισημαίνονται δεν πρέπει να χαρακτηρίζονται ως απάτες χωρίς πρόσθετα στοιχεία.

## Βασικά Ευρήματα

Η ανάλυση ανέδειξε αρκετά σημαντικά ευρήματα.

### Δημογραφικά Πελατών

Το σύνολο δεδομένων περιλαμβάνει 5.369 πελάτες:

- Άνδρες: 2.724.
- Γυναίκες: 2.645.

Η κατανομή είναι σχεδόν ισορροπημένη μεταξύ των δύο καταγεγραμμένων κατηγοριών φύλου.

Η ανάλυση ηλικιακών ομάδων παρέχει επιπλέον εικόνα για τη σύνθεση της πελατειακής βάσης. Τα αποτελέσματα αφορούν τους πελάτες του συγκεκριμένου συνόλου δεδομένων και δεν αντιπροσωπεύουν απαραίτητα το σύνολο των τραπεζικών πελατών.

### Χαρτοφυλάκιο Λογαριασμών

Το σύνολο δεδομένων περιλαμβάνει 4.500 λογαριασμούς. Οι ημερομηνίες ανοίγματος και η συχνότητα καταστάσεων επιτρέπουν την εξέταση του χαρτοφυλακίου διαχρονικά και ανά χαρακτηριστικό λογαριασμού.

Το μοτίβο ανοίγματος λογαριασμών διαφέρει ανά έτος, προσφέροντας ιστορική εικόνα για την εξέλιξη του καταγεγραμμένου χαρτοφυλακίου.

### Συναλλακτική Δραστηριότητα

Ο πίνακας συναλλαγών περιλαμβάνει 1.056.320 εγγραφές.

Οι καταγεγραμμένοι τύποι συναλλαγών περιλαμβάνουν αναλήψεις, πιστώσεις και αναλήψεις μετρητών. Η εξέταση αυτών των κατηγοριών τόσο με βάση το πλήθος όσο και με βάση την αξία βοηθά να διαχωριστεί η συχνότητα δραστηριότητας από τη χρηματική της συνεισφορά.

Η συνολική αξία συναλλαγών ανέρχεται σε περίπου 6,26 δισεκατομμύρια στις αρχικές νομισματικές μονάδες του συνόλου δεδομένων.

Η συναλλακτική δραστηριότητα μεταβάλλεται επίσης κατά την ιστορική περίοδο παρατήρησης, επιτρέποντας συγκρίσεις της καταγεγραμμένης τραπεζικής δραστηριότητας ανά έτος.

### Χαρτοφυλάκιο Δανείων

Το σύνολο δεδομένων περιλαμβάνει 682 δάνεια με τέσσερις καταγεγραμμένες καταστάσεις. Η κατανομή τους προσφέρει περιγραφική εικόνα του χαρτοφυλακίου και των καταγεγραμμένων αποτελεσμάτων αποπληρωμής.

Οι καταστάσεις δανείων πρέπει να ερμηνεύονται σύμφωνα με τους αρχικούς ορισμούς τους. Ειδικότερα, είναι σημαντική η διάκριση μεταξύ ολοκληρωμένου δανείου, ολοκληρωμένου δανείου που δεν εξοφλήθηκε, δανείου που εξυπηρετείται κανονικά και ενεργού δανείου που συνδέεται με οφειλή.

### Χαρτοφυλάκιο Καρτών

Το σύνολο δεδομένων περιλαμβάνει 892 κάρτες σε τρεις τύπους:

- Classic: 659.
- Junior: 145.
- Gold: 88.

Οι αριθμοί αυτοί περιγράφουν τη σύνθεση του καταγεγραμμένου χαρτοφυλακίου καρτών.

### Έλεγχος Κινδύνου

Οι συναλλαγές με αρνητικά υπόλοιπα και οι συναλλαγές μεγάλου ποσού μπορούν να επισημανθούν για πρόσθετο έλεγχο. Μπορεί επίσης να εξεταστεί η επικάλυψη των κριτηρίων, ώστε να προσδιοριστεί πόσες συναλλαγές πληρούν περισσότερες από μία προϋποθέσεις.

Η επισήμανση σημαίνει ότι μια συναλλαγή πληροί έναν προκαθορισμένο αναλυτικό κανόνα. Δεν προσδιορίζει από μόνη της τον λόγο της συναλλαγής ούτε αποδεικνύει παραβατική συμπεριφορά.

## Dashboards και Αναφορές

Το έργο περιλαμβάνει τρεις θεματικές ενότητες dashboards που υποστηρίζουν διαφορετικά επίπεδα ανάλυσης.

### Financial Services Analytics Overview

Το dashboard παρέχει συνοπτική εικόνα του συνόλου δεδομένων μέσω βασικών δεικτών απόδοσης και επισκόπησης της δραστηριότητας πελατών, λογαριασμών, συναλλαγών και προϊόντων.

Σκοπός του είναι να βοηθήσει τον χρήστη να κατανοήσει την κλίμακα και τα κύρια χαρακτηριστικά των διαθέσιμων δεδομένων πριν εξετάσει συγκεκριμένους τομείς με περισσότερες λεπτομέρειες.

### Customer & Account Insights

Το dashboard εστιάζει στα δημογραφικά πελατών, στη γεωγραφική κατανομή, στα πρότυπα ανοίγματος λογαριασμών, στη συχνότητα καταστάσεων και στις σχέσεις λογαριασμών.

Παρέχει οργανωμένη εικόνα της πελατειακής βάσης και του χαρτοφυλακίου λογαριασμών.

### Transaction, Product & Risk Analysis

Το dashboard εστιάζει στη συναλλακτική δραστηριότητα, στις αξίες συναλλαγών, στα χαρτοφυλάκια δανείων και καρτών και στους επιλεγμένους δείκτες κινδύνου.

Βοηθά τον χρήστη να διερευνήσει τα συναλλακτικά πρότυπα και να κατανοήσει ποιες εγγραφές πληρούν τα αναλυτικά κριτήρια ελέγχου.

Τα dashboards έχουν σχεδιαστεί για να υποστηρίζουν την εξερεύνηση, τη σύγκριση και την ερμηνεία. Συμπληρώνουν την ανάλυση των δεδομένων αντί να την αντικαθιστούν.

## Δείκτες Κινδύνου, Περιορισμοί και Ερμηνεία Δεδομένων

Το έργο έχει αρκετούς σημαντικούς περιορισμούς.

**Ιστορικά δεδομένα:** Το σύνολο δεδομένων αφορά τραπεζική δραστηριότητα από το 1993 έως το 1998. Τα ευρήματα δεν πρέπει να θεωρούνται περιγραφή των σημερινών τραπεζικών συνθηκών.

**Ελλιπείς πληροφορίες:** Ορισμένα χαρακτηριστικά συναλλαγών περιέχουν ελλιπείς τιμές. Η απουσία τους πρέπει να ερμηνεύεται στο κατάλληλο πλαίσιο και όχι να θεωρείται αυτόματα σφάλμα.

**Κοινόχρηστοι λογαριασμοί:** Περισσότεροι από ένας πελάτες μπορεί να συνδέονται με τον ίδιο λογαριασμό. Η απόδοση συναλλαγών σε επίπεδο πελάτη απαιτεί επομένως προσοχή.

**Δείκτες κινδύνου:** Τα αρνητικά υπόλοιπα και τα μεγάλα ποσά συναλλαγών μπορεί να προκύπτουν για νόμιμους λόγους. Κανένας από τους δύο δείκτες δεν αποδεικνύει απάτη.

**Όριο υψηλής αξίας:** Το επιλεγμένο όριο είναι ένας στατιστικός κανόνας ελέγχου. Δεν αποτελεί καθολικό ορισμό ασυνήθιστης ή ύποπτης συναλλαγής.

**Ερμηνεία κατάστασης δανείου:** Οι αρχικοί κωδικοί και οι ορισμοί πρέπει να διατηρούνται, ώστε να αποφεύγεται η λανθασμένη ταξινόμηση των αποτελεσμάτων αποπληρωμής.

**Συγκεντρώσεις δεδομένων:** Οι σχέσεις ένα-προς-πολλά μπορεί να δημιουργήσουν διπλότυπες εγγραφές. Τα πλήθη συναλλαγών και τα χρηματικά σύνολα πρέπει να επικυρώνονται μετά τις συνδέσεις πινάκων, ώστε να μην υπερεκτιμώνται.

**Επιχειρηματικές προτάσεις:** Οι προτάσεις προκύπτουν από διερευνητική ανάλυση. Για την εφαρμογή τους σε πραγματικό χρηματοπιστωτικό ίδρυμα θα απαιτούνταν πρόσθετη επικύρωση, συμπληρωματικές πληροφορίες και εξειδικευμένη γνώση.

## Επιχειρηματικές Προτάσεις

Η αναλυτική προσέγγιση υποδεικνύει αρκετές ενέργειες που θα μπορούσε να εξετάσει ένας οργανισμός χρηματοοικονομικών υπηρεσιών.

### Βελτίωση Παρακολούθησης Συναλλαγών

Παρακολούθηση των συναλλακτικών προτύπων διαχρονικά και σύγκριση της δραστηριότητας μεταξύ κατηγοριών συναλλαγών, λογαριασμών και σχετικών τμημάτων πελατών. Οι ασυνήθιστες μεταβολές πρέπει να διερευνώνται με πρόσθετες πληροφορίες και όχι αποκλειστικά με βάση το μέγεθος μιας συναλλαγής.

### Ενίσχυση Παρακολούθησης Λογαριασμών

Εξέταση λογαριασμών με επαναλαμβανόμενα αρνητικά υπόλοιπα, ώστε να κατανοηθεί αν το μοτίβο σχετίζεται με τον χρονισμό, τη χρήση του λογαριασμού ή πιθανές οικονομικές δυσκολίες. Κάθε περαιτέρω αξιολόγηση πρέπει να λαμβάνει υπόψη το συνολικό ιστορικό του λογαριασμού.

### Βελτίωση Αναφορών Χαρτοφυλακίου

Χρήση συνεπών ορισμών για το πλήθος συναλλαγών, την αξία συναλλαγών, τα υπόλοιπα λογαριασμών και τα ποσά δανείων. Έτσι αποφεύγονται παραπλανητικές συγκρίσεις και ενισχύεται η αξιοπιστία των αναφορών.

### Υποστήριξη Τμηματοποίησης Πελατών

Συνδυασμός δημογραφικών και χαρακτηριστικών λογαριασμών για την περιγραφή τμημάτων πελατών. Κάθε τμηματοποίηση πρέπει να αξιολογείται προσεκτικά και δεν πρέπει να ερμηνεύεται ως απόδειξη ατομικής συμπεριφοράς χωρίς επαρκή τεκμηρίωση.

### Παρακολούθηση Απόδοσης Δανείων

Εξέταση της κατανομής των καταστάσεων δανείων σε συνδυασμό με τα ποσά, τις διάρκειες και τα χαρακτηριστικά πληρωμών. Η προσέγγιση αυτή μπορεί να υποστηρίξει την περιγραφική παρακολούθηση χαρτοφυλακίων και να αναδείξει τομείς όπου χρειάζεται λεπτομερέστερη ανάλυση.

### Χρήση Dashboards για Υποστήριξη Αποφάσεων

Παροχή πρόσβασης σε σαφώς ορισμένα KPIs, ιστορικές τάσεις και διαδραστικά φίλτρα. Η συνεπής αναφορά μπορεί να βοηθήσει τους χρήστες να εντοπίζουν πρότυπα και να διερευνούν ερωτήματα πιο αποτελεσματικά.

### Επικύρωση Δεικτών Κινδύνου

Πριν από την επιχειρησιακή χρήση των δεικτών, απαιτείται επικύρωση με πρόσθετες πληροφορίες και τεκμηριωμένα αποτελέσματα διερεύνησης. Αυτό είναι απαραίτητο για να αξιολογηθεί η χρησιμότητά τους και να αποφευχθεί η αντιμετώπιση νόμιμων συναλλαγών ως επιβεβαιωμένων περιστατικών.

Οι προτάσεις αποτελούν πιθανές εφαρμογές της ανάλυσης και όχι ισχυρισμούς ότι το σύνολο δεδομένων αποδεικνύει συγκεκριμένη παραβατική συμπεριφορά πελατών, απάτη ή οικονομική ζημία.

## Πώς να Εξερευνήσετε το Έργο

Το υλικό του έργου επιτρέπει στον αναγνώστη να παρακολουθήσει την αναλυτική διαδικασία από τα αρχικά δεδομένα έως την προετοιμασία, τα ερωτήματα, τον υπολογισμό δεικτών και την ανάπτυξη dashboards.

Ο αναγνώστης μπορεί να εξετάσει πώς συνδέονται οι πίνακες, πώς ορίζονται οι αναλυτικές μεταβλητές, πώς υπολογίζονται τα ευρήματα και πώς παρουσιάζονται οπτικά τα αποτελέσματα.

Το έργο αναδεικνύει πώς μπορούν να συνδυαστούν Python, SQL, Excel, Tableau και Power BI για τη μετατροπή σχεσιακών τραπεζικών δεδομένων σε οργανωμένη ανάλυση και επιχειρηματική αναφορά.

## Περιεχόμενα και Διαθεσιμότητα Αρχείων

Για να διατηρηθεί το αποθετήριο εντός πρακτικών ορίων αποθήκευσης, δεν περιλαμβάνονται τα αρχικά ακατέργαστα δεδομένα ούτε τα επεξεργασμένα αρχεία δεδομένων. Το αρχικό σύνολο δεδομένων είναι διαθέσιμο μέσω των συνδέσμων στην ενότητα «Αναφορά Πηγής Δεδομένων».

Στο αποθετήριο περιλαμβάνονται τα αναλυτικά notebooks, τα SQL scripts και η τεκμηρίωση της μεθοδολογίας. Τα γραφήματα του Excel και τα dashboards του Tableau και του Power BI παρουσιάζονται μόνο μέσω screenshots για οπτική αναφορά· δεν περιλαμβάνονται τα επεξεργάσιμα αρχεία γραφημάτων του Excel ούτε τα διαδραστικά αρχεία έργου του Tableau και του Power BI.

## Δεξιότητες που Αναδεικνύονται

Το έργο αναδεικνύει πρακτικές δεξιότητες στους ακόλουθους τομείς:

- Φόρτωση, καθαρισμός και επικύρωση δεδομένων.
- Διερευνητική ανάλυση δεδομένων.
- Σχεσιακές βάσεις δεδομένων και μοντελοποίηση δεδομένων.
- Συνδέσεις, συγκεντρώσεις και αναλυτικά ερωτήματα SQL.
- Δημιουργία νέων χαρακτηριστικών και επεξεργασία ημερομηνιών.
- Ορισμός και υπολογισμός KPIs.
- Χρηματοοικονομική ανάλυση και ανάλυση συναλλαγών.
- Ανάλυση πελατών και λογαριασμών.
- Ανάλυση χαρτοφυλακίων δανείων και καρτών.
- Διερευνητική ανάπτυξη δεικτών κινδύνου.
- Οπτικοποίηση δεδομένων και σχεδιασμός dashboards.
- Επιχειρηματική ερμηνεία και ανάπτυξη προτάσεων.
- Αναλυτική αναφορά και επικοινωνία.
- Διασταύρωση αποτελεσμάτων μεταξύ διαφορετικών εργαλείων ανάλυσης.

## Αναφορά Πηγής Δεδομένων

Το έργο χρησιμοποιεί το PKDD '99 Czech Bank Dataset για εκπαιδευτικούς, αναλυτικούς και σκοπούς παρουσίασης επαγγελματικού portfolio.

**Αρχεία δεδομένων:** [Πρόσβαση στα αρχεία του PKDD '99 Czech Bank Dataset στο GitHub](https://github.com/jlacko/berka-dataset) (δημόσιο αντίγραφο του αρχικού συνόλου δεδομένων).  
**Περιγραφή συνόλου δεδομένων:** [PKDD '99 Financial Dataset](https://relational.fel.cvut.cz/dataset/Financial).

Η ανάλυση βασίζεται στις διαθέσιμες ιστορικές εγγραφές και στις μεθόδους που εφαρμόστηκαν στο έργο. Τα ευρήματα πρέπει να ερμηνεύονται εντός του πεδίου εφαρμογής και των περιορισμών του συνόλου δεδομένων.
