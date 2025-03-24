# Maven-Cafe-Rewards-Offers

### By Gary Yan
### Last Updated: March 24, 2025

[Link to Tableau dashboard](https://public.tableau.com/views/MavenRewards_17428486968610/Dashboard1?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

## Background

Maven Cafe is a cafe that is testing new promotional offers for its rewards program. This project seeks to analyze trends following the implementation of these offers to uncover critical insights that will improve Maven's commercial success.

We will be exploring how the various offer types were used by different segments of customers based on age, income level, and visit frequency. In particular, we will be seeing how these segments differ in:

* Revenue generation
* Offer completion rates


We will also be analyzing the effectiveness of sending promotions through various media:

* Website
* Email
* Text message
* Social media

An interactive Tableau dashboard can be found [here](https://public.tableau.com/views/MavenRewards_17428486968610/Dashboard1?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

SQL queries to inspect and perform quality checks [here](https://github.com/GaryYan28/Maven-Cafe-Rewards-Offers/blob/main/Checks.sql)

Targeted SQL queries to find info [here](https://github.com/GaryYan28/Maven-Cafe-Rewards-Offers/blob/main/Insights.sql)

## Data Structure

The database structure as seen below consists of three tables: customers, events, and offers with a total row count of 323 544 records.

![ERD](https://github.com/user-attachments/assets/335cd06a-4cc6-4d49-81f4-cdc82e24936f)

SQL queries utilized to familiarize myself with the database as well as performing quality checks can be found [here](https://github.com/GaryYan28/Maven-Cafe-Rewards-Offers/blob/main/Checks.sql).

## Executive Summary

Below is a quick profile of customers based on their income and a recommendation for how to better direct offers at each segment.

* **Low income members** ($50 000 or below) 
    * On average make 2-3 visits per week, spend $7 per visit, and will complete 1 offer every 6 visits. 
    * Evenly spread throughout all age groups.
    * Lower rates of completion on offers with higher minimum spending.
    * Offers are most visible to this group if they appear on social media.
    * Accounts for about 15% of revenue but makes up about 27% of customers.
    * **Recommendation: More offers that require either $7 or $10 minimum spending with high durations.**
    
* **Medium income members** ($50 001 - $90 000)
    * About 2 visits per week, spends $15 per visit, and completes an offer every 4 visits.
    * Majority are over 45, some between 30-45, and few between 19-30.
    * Slightly lower completion rates on offers with $20 minimum spend.
    * Social media and email very important in this segment.
    * Segment makes up about 57% of customers and accounts for 60% of revenue.
    * **Recommendation: More frequent, short duration offers sent through emails and social media.**
    
* **High income members** (Greater than $90 000)
    * About 1.5 visits per week, spends $30 per visit, and completes an offer every 2 visits.
    * Almost all are over 45, youngest is 36.
    * Unaffected by minimum spend on offers.
    * Social media is still the most viewed channel but all important in this segment.
    * Makes up about 15% of customers but accounts for nearly 23% of revenue.
    * **Recommendation: More frequent offers with high minimum spending broadcasted on all channels.**

## Insights

#### **Spending Habits**
* Low income members make more frequent visits, spend less per visit, and are less likely to complete an offer on their purchase.
* High income members make less frequent visits but spend more when they do make a visit. They're also a lot more likely to complete an offer when they make a visit.
* Medium income members are in the middle of these metrics so we can assume that the trend is linked to income.

![spending habits](https://github.com/user-attachments/assets/c30e813e-ae30-4aee-b21f-87f6eee41a34)
![average spent](https://github.com/user-attachments/assets/971778c2-8551-4f6e-92b3-1343eca71cb7)

* Medium income members make up the majority of our revenue but they also make up the majority of the population.
* High income members account for the next largest slice of revenue despite having half as many members as the low income bin.
* Low incomee members still account for sizeable share of revenue.

#### **Offer Difficulty**

* Offer difficulty is the minimum amount that needs to be spent to complete an offer. Offers require either $5, $7, $10, or $20 spent to complete the offer.
* High income members have a higher completion rate and do not seem to be affected by higher difficulty.
* Low income members significantly less likely to complete highest difficulty offers and noticeable drop-off from $5 difficulty to $10.
* Medium income members do not see drop-off from $5 to $10 but do see one for the $20 difficulty.

![all income completion rate vs difficulty](https://github.com/user-attachments/assets/299ba163-3e89-4242-895e-e0d1a5b097cb) All income

![low income completion rate vs difficulty](https://github.com/user-attachments/assets/d87a5ed1-ee19-4a43-ad3c-1da53612c2a5) Low income ($50 000 and below)

![medium income completion rate vs difficulty](https://github.com/user-attachments/assets/6f0804d2-ffad-4e81-b137-1846ceef51f1) Medium income ($50 001 - $90 000)

![high income completion rate vs difficulty](https://github.com/user-attachments/assets/58396f96-e4b9-4fbc-bed7-55152d246a35) High income ($90 001+)

#### Offer Rewards
* No strong trend between reward and completion rate.
* Some lower reward offers have higher completion rate but likely explained by lower difficulty of offers.

![all income completion rate vs reward](https://github.com/user-attachments/assets/b74377a1-d339-4e68-844c-6a1053fd6bd9) All income

#### **Age**

* Age appears to correlate with completion rate but we can see 46-64 and 65+ brackets have similar rates.
* Those brackets also have incredibly similar income distributions.
* Trend is likely just explained by income rather than age.
* High income members are almost exclusively older.
    * Most of them are over 45.
    * None under 30.
* Medium income skews older but have significant number of younger members as well.
* Low income comprised of equal representation from all ages.

![age completion + income distribution](https://github.com/user-attachments/assets/a3ad98c9-721c-4fe0-afea-e1d6b9859814)

#### **Visibility**

* Some media generate more views than others.
* Some or all web views are not counted in the stats.
    * Small drop off in views when offers aren't distributed through web.
    * Some offers that were distributed on web have greater completion counts than view count.
* Social media is the most effective medium for generating views.

![view conversion](https://github.com/user-attachments/assets/3008eb43-89f2-4614-af55-f7718498d508) All income

##### High Income
* Noticeable drop off in views when offer isn't available on the web.
    * Could be web views are counted or these members see offer on web first and check other locations.
* Very significant drop in views when offer isn't on social media.
* Mobile accounts for similar amount of views as web in this bracket.

![high income offer views](https://github.com/user-attachments/assets/b44be62a-bc47-479f-97d7-265218035430) High income

##### Medium Income

* Small drop off in views when offer isn't available on web.
* Social media makes up significant amount of views.
* Still viewed a lot when offers are only communicated on web and email.
    * Email accounts for a significant amount of views in this bracket.

![medium income offer views](https://github.com/user-attachments/assets/855dad5d-e0e6-4c59-8bad-2ed4bba42161) Medium income

##### Low Income
* No drop in views when offer is not on web.
* Not having an offer on social media means less than 40% of members in this bracket will see the offer.
* Email and mobile combined make up about a third of views.

![low income offer views](https://github.com/user-attachments/assets/5a687c29-9c05-41ea-91ce-4ac33069f307) Low income

## Recommendations

#### Recommendation 1: Ensure all offers are visible on social media
* Across all income brackets and ages, social media offers the greatest visibility.
* Effect is particularly strong among younger demographics.

#### Recommendation 2: Direct high difficulty offers towards high income members
* High income members are not dissuaded by high difficulty but all other income brackets see significantly lower completion rates.
* High difficulty does not require high rewards for completion. 
* These offers should be broadcasted across all channels as high income members don't have a strong preference for any particular channel.

#### Recommendation 3: Have more $7 and $10 difficulty offers 
* Average spent per visit among low income members are just under $7, customers may spend a bit more to reach these levels.
* Higher income members are likely to complete an offer when they complete an order, offering them more offers may entice them to make more visits.
    * Almost half of all orders are accompanied by an offer by high income members.
    * Over a quarter of orders are accompanied by offers among medium income members.
* Social media and email are important for these offers to be viewed, web and mobile are less important channels.
