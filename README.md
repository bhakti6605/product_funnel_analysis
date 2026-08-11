# Product Funnel & Conversion Analysis

## Project Overview
This project analyzes user behavior through an e-commerce
conversion funnel using PostgreSQL.

The funnel consists of:

Page View → Add to Cart → Checkout → Payment Info → Purchase

## Objectives

- Analyze users at each funnel stage
- Calculate stage-to-stage conversion rates
- Compare funnel performance by traffic source
- Analyze revenue and purchasing behavior
- Calculate time to conversion

## Tools

- PostgreSQL
- SQL
- GitHub

## Analysis Performed

### 1. Funnel Stage Analysis

Calculated unique users at each stage using COUNT(DISTINCT user_id).

### 2. Funnel Conversion Analysis

Calculated conversion rates between:

- Page View → Add to Cart
- Add to Cart → Checkout
- Checkout → Payment Info
- Payment Info → Purchase

### 3. Traffic Source Analysis

Compared funnel performance across different traffic sources.

### 4. Revenue Analysis

Calculated:

- Total Visitors
- Total Buyers
- Total Revenue
- Total Orders
- Revenue per Buyer
- Average Order Value

### 5. Time-to-Conversion Analysis

Calculated the time between a user's first page view
and first purchase using event timestamps.

## Key Insights



## Files
