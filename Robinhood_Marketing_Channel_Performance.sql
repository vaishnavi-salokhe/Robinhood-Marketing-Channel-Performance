CREATE DATABASE IF NOT EXISTS robinhood_marketing;

USE robinhood_marketing;

DROP TABLE IF EXISTS ad_spend;
DROP TABLE IF EXISTS signups;

CREATE TABLE ad_spend (
    date DATE,
    channel VARCHAR(50),
    campaign VARCHAR(100),
    impressions INT,
    clicks INT,
    spend DECIMAL(12,2)
);

CREATE TABLE signups (
    user_id INT,
    signup_date VARCHAR(20),
    channel VARCHAR(50),
    campaign VARCHAR(100),
    subscription_start_date VARCHAR(20),
    plan VARCHAR(50),
    revenue_first_90_days DECIMAL(12,2)
);

USE robinhood_marketing;

SHOW TABLES;

LOAD DATA LOCAL INFILE 'C:/Users/Vaishnavi Salokhe/OneDrive/Desktop/data analysis/Projects/marketing-channel-performance-datasets/marketing-channel-performance/ad_spend.csv'
INTO TABLE ad_spend
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(date, channel, campaign, impressions, clicks, spend);

SELECT COUNT(*) AS ad_spend_rows
FROM ad_spend;

LOAD DATA LOCAL INFILE 'C:/Users/Vaishnavi Salokhe/OneDrive/Desktop/data analysis/Projects/marketing-channel-performance-datasets/marketing-channel-performance/signups.csv'
INTO TABLE signups
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(user_id, signup_date, channel, campaign, subscription_start_date, plan, revenue_first_90_days);

SELECT COUNT(*) AS signup_rows
FROM signups;

USE robinhood_marketing;

SELECT
    COUNT(*) AS total_signups,
    COUNT(DISTINCT user_id) AS unique_users,
    COUNT(*) - COUNT(DISTINCT user_id) AS duplicate_users
FROM signups;

SELECT
    channel,
    COUNT(*) AS signups
FROM signups
GROUP BY channel
ORDER BY signups DESC;

SELECT
    channel,
    COUNT(*) AS advertising_records,
    SUM(impressions) AS impressions,
    SUM(clicks) AS clicks,
    ROUND(SUM(spend), 2) AS spend
FROM ad_spend
GROUP BY channel
ORDER BY spend DESC;

WITH signup_analysis AS (
    SELECT
        LOWER(channel) AS channel,
        COALESCE(campaign, 'organic_or_referral') AS campaign,
        COUNT(*) AS signups,
        SUM(
            CASE
                WHEN subscription_start_date IS NOT NULL
                THEN 1
                ELSE 0
            END
        ) AS paying_customers,
        SUM(revenue_first_90_days) AS revenue_90_days
    FROM signups
    GROUP BY
        LOWER(channel),
        COALESCE(campaign, 'organic_or_referral')
),

advertising_analysis AS (
    SELECT
        LOWER(REPLACE(channel, ' ', '_')) AS channel,
        campaign,
        SUM(impressions) AS impressions,
        SUM(clicks) AS clicks,
        SUM(spend) AS spend
    FROM ad_spend
    GROUP BY
        LOWER(REPLACE(channel, ' ', '_')),
        campaign
)

SELECT
    s.channel,
    s.campaign,
    s.signups,
    s.paying_customers,
    ROUND(s.revenue_90_days, 2) AS revenue_90_days,
    COALESCE(a.impressions, 0) AS impressions,
    COALESCE(a.clicks, 0) AS clicks,
    ROUND(COALESCE(a.spend, 0), 2) AS spend,

    ROUND(
        COALESCE(a.clicks, 0) /
        NULLIF(a.impressions, 0) * 100,
        2
    ) AS ctr_percent,

    ROUND(
        COALESCE(a.spend, 0) /
        NULLIF(a.clicks, 0),
        2
    ) AS cpc,

    ROUND(
        COALESCE(a.spend, 0) /
        NULLIF(s.paying_customers, 0),
        2
    ) AS cac,

    ROUND(
        s.paying_customers /
        NULLIF(s.signups, 0) * 100,
        2
    ) AS paying_conversion_percent,

    ROUND(
        s.revenue_90_days /
        NULLIF(a.spend, 0),
        2
    ) AS roas

FROM signup_analysis s

LEFT JOIN advertising_analysis a
    ON s.channel = a.channel
    AND s.campaign = a.campaign

ORDER BY roas DESC;

WITH signup_analysis AS (
    SELECT
        LOWER(channel) AS channel,
        COALESCE(NULLIF(campaign, ''), 'organic_or_referral') AS campaign,
        COUNT(*) AS signups,

        SUM(
            CASE
                WHEN NULLIF(subscription_start_date, '') IS NOT NULL
                THEN 1
                ELSE 0
            END
        ) AS paying_customers,

        SUM(revenue_first_90_days) AS revenue_90_days

    FROM signups

    GROUP BY
        LOWER(channel),
        COALESCE(NULLIF(campaign, ''), 'organic_or_referral')
),

advertising_analysis AS (
    SELECT
        LOWER(REPLACE(channel, ' ', '_')) AS channel,
        campaign,
        SUM(impressions) AS impressions,
        SUM(clicks) AS clicks,
        SUM(spend) AS spend

    FROM ad_spend

    GROUP BY
        LOWER(REPLACE(channel, ' ', '_')),
        campaign
)

SELECT
    s.channel,
    s.campaign,
    s.signups,
    s.paying_customers,

    ROUND(s.revenue_90_days, 2) AS revenue_90_days,

    COALESCE(a.impressions, 0) AS impressions,
    COALESCE(a.clicks, 0) AS clicks,
    ROUND(COALESCE(a.spend, 0), 2) AS spend,

    ROUND(
        COALESCE(a.clicks, 0) /
        NULLIF(a.impressions, 0) * 100,
        2
    ) AS ctr_percent,

    ROUND(
        COALESCE(a.spend, 0) /
        NULLIF(a.clicks, 0),
        2
    ) AS cpc,

    ROUND(
        COALESCE(a.spend, 0) /
        NULLIF(s.paying_customers, 0),
        2
    ) AS cac,

    ROUND(
        s.paying_customers /
        NULLIF(s.signups, 0) * 100,
        2
    ) AS paying_conversion_percent,

    ROUND(
        s.revenue_90_days /
        NULLIF(a.spend, 0),
        2
    ) AS roas

FROM signup_analysis s

LEFT JOIN advertising_analysis a
    ON s.channel = a.channel
    AND s.campaign = a.campaign

ORDER BY roas DESC;

SELECT
    LEFT(signup_date, 7) AS month,
    COUNT(*) AS signups,
    SUM(
        CASE
            WHEN NULLIF(subscription_start_date, '') IS NOT NULL
            THEN 1
            ELSE 0
        END
    ) AS paying_customers,
    ROUND(SUM(revenue_first_90_days), 2) AS revenue_90_days
FROM signups
GROUP BY LEFT(signup_date, 7)
ORDER BY month;

SELECT
    CASE
        WHEN LOWER(channel) IN ('paid_search', 'paid_social', 'display')
        THEN 'Paid'
        ELSE 'Non-Paid'
    END AS acquisition_type,

    COUNT(*) AS signups,

    SUM(
        CASE
            WHEN NULLIF(subscription_start_date, '') IS NOT NULL
            THEN 1
            ELSE 0
        END
    ) AS paying_customers,

    ROUND(SUM(revenue_first_90_days), 2) AS revenue_90_days,

    ROUND(
        SUM(
            CASE
                WHEN NULLIF(subscription_start_date, '') IS NOT NULL
                THEN 1
                ELSE 0
            END
        ) / COUNT(*) * 100,
        2
    ) AS conversion_percent

FROM signups

GROUP BY acquisition_type;