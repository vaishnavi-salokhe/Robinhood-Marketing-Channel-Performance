# Robinhood Marketing Channel Performance Analysis

## Project Overview

This project analyzes marketing channel and campaign performance to understand customer acquisition, conversion, revenue generation, and advertising efficiency.

Using SQL, Excel, and Power BI, the project evaluates which marketing campaigns attract signups, convert users into paying customers, and generate revenue relative to advertising spend.

## Business Objectives

- Analyze signups across acquisition channels.
- Identify campaigns generating the highest revenue.
- Compare paying customer conversion rates across campaigns.
- Evaluate advertising efficiency using Cost Per Click (CPC), Customer Acquisition Cost (CAC), and Return on Ad Spend (ROAS).
- Compare paid and non-paid acquisition channels.
- Identify opportunities to improve marketing budget allocation.

## Tools and Technologies

- **SQL (MySQL):** Data validation, aggregation, joins, and marketing performance analysis.
- **Microsoft Excel:** KPI calculations, charts, and dashboard creation.
- **Power BI:** Interactive dashboard and performance visualization.

## Dataset

The project uses two datasets:

1. **Ad Spend:** Advertising date, channel, campaign, impressions, clicks, and spend.
2. **Signups:** User ID, signup date, acquisition channel, campaign, subscription start date, plan, and first-90-day revenue.

The datasets contain 1,046 advertising records and 18,840 signup records.

## Key Performance Indicators

- Total Signups
- Paying Customers
- Revenue (First 90 Days)
- Advertising Spend
- Click-Through Rate (CTR)
- Cost Per Click (CPC)
- Customer Acquisition Cost (CAC)
- Paying Customer Conversion Rate
- Return on Ad Spend (ROAS)

## SQL Analysis

The SQL analysis includes:

- Table validation and data quality checks.
- Signup distribution by channel.
- Advertising performance by channel.
- Campaign-level marketing performance.
- Monthly signup and paying customer trends.
- Paid versus non-paid acquisition performance.

## Key Findings

- **Brand Search:** Reported ROAS of 1.90, the highest among the listed paid campaigns.
- **Retargeting:** Reported ROAS of 1.33.
- **Prospecting Video:** Generated a high volume of signups but had a lower paying customer conversion rate of approximately 3.29%.
- **Organic and Referral:** Generated signups and revenue without recorded paid advertising spend in the dataset.
- **Campaign comparison:** Signup volume alone does not determine campaign quality; paying customer conversion and revenue efficiency are also important.

## Dashboards

### Excel Dashboard
Includes KPI summaries, signups by channel, and revenue by campaign.

### Power BI Dashboard
Includes KPI cards and visual comparisons of signup volume, campaign revenue, and ROAS.

## Business Recommendations

1. Investigate the performance of Brand Search and Retargeting before reallocating additional budget.
2. Review Prospecting Video targeting and landing-page performance to improve conversion.
3. Evaluate campaigns using revenue, conversion rate, CAC, and ROAS rather than signup volume alone.
4. Continue monitoring Organic and Referral channels as non-paid acquisition sources.
5. Validate campaign-level spend and revenue calculations before making budget decisions.

## Project Structure

```text
Robinhood-Marketing-Channel-Performance/
├── Robinhood_Marketing_Channel_Performance.sql
├── Robinhood_Marketing_Channel_Performance.xlsx
├── Robinhood_Marketing_Channel_Performance.pbix
├── 07_channel_campaign_performance.csv
├── 08_monthly_performance.csv
├── 09_paid_vs_nonpaid.csv
└── README.md
```

## Conclusion

This project demonstrates how SQL, Excel, and Power BI can be used together to transform marketing data into actionable business insights. It combines data validation, KPI analysis, campaign performance measurement, and dashboard reporting to support data-driven marketing decisions.

*Note: Validate the Power BI advertising spend total against the SQL/Excel result before publishing the final dashboard or using the figures for business decisions.*
