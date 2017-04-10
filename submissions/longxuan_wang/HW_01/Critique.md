Critique
================
Longxuan Wang
April 10, 2017

Visualization critique
----------------------

### Basic info

The graph that I want to discuss comes from The Upshot column in the New York Times. You can find that graph [here](https://www.nytimes.com/interactive/2017/03/30/upshot/good-schools-affordable-homes-suburban-sweet-spots.html?rref=collection%2Fsectioncollection%2Fupshot). The article is titled “Good Schools, Affordable Homes: Finding Suburban Sweet Spots”. So it is clear from the title that the graph is about the qualities of schools and home prices. We all know from various anecdotal evidence that houses in a good school district can command insanely high prices. This graph, however, is trying to find if there are good school districts with cheap homes.

Each dot on the graph represents a school district. The size of the dot corresponds to the total population residing in that district. Each dot is also color-coded to reflect the average time of commutes to work by residents of that area. A green dot denotes that the average commute takes less than 30 minutes and a pink dot denotes more than 30 minutes. On the y-axis of the graph is the average home price within that school district, and on the x-axis is the school quality. School quality is measured by student test scores. All the dots are also connected with lines to a central point with no obvious explanations.

### Is it truthful?

In terms of data sources, I believe the raw data are trustworthy. Price data comes from Redfin whose online database is very comprehensive. As a web-based real estate brokerage, the website faces a lot of competition from similar websites such as Zillow. So it is reasonable to believe that in face of this competition Redfin has a strong incentive to maintain good data. Test scores come from the Stanford Education Data Archive, a very reputable institution. Commuting time comes from the Census Bureau surveys. Though there are all kinds of problem associated with survey data, this is as good as it gets. The data source for population data is not specified, but I believe good quality population data are not hard to find since agencies such as the Census Bureau should have maintained a good and publicly available population database.

In terms of presentation, both the x-axis and the y-axis are not distorted. They all reflect the original data with fixed step-size. Using size to represent population is also quite common. The 30 minute break point for color coding might be a little arbitrary, but as we can see from the graph that there are a lot of dots for each color, so we can assume that 30 minutes is not some extreme value and it does a good job of separating different dots. Furthermore, if you hover your mouse on top of each dot, it will show you the exact commuting time for that school district.

One issue with truthfulness is that data sources as well as important footnotes are not put together with the graph. Data source for prices and school qualities are introduced in the third paragraph below the graph. The data source and definition of commuting time are in the footnote at the very bottom of the page. Data source for population is never discussed. Though a careful reader might be able to verify the truthfulness by thoroughly reading the article, the graph alone is not very good at lending credibility to itself.

### Is it functional?

In terms of functionality, I believe this graph has its pros and cons. First of all, it does a very good job of presenting a lot of variables on one single graph, and it is relatively easy to read. The main purpose of this graph is to help the reader identify school districts with good schools and low prices. I believe this graph does a good job fulfilling this promise. It is obvious from the graph that school districts on the bottom right corner are those of good values and those on the top left are of the worst values in terms of school-price tradeoff.

On the other hand, the graph fails in providing the readers with a good measure of commuting time. I will start with a minor point. First of all, if we look at the exact data, we see that the average commuting time mostly falls within 25 to 35 minutes, so the differences are actually not too extreme.

However, the commuting time statistics have a far more serious issue. The commuting time, as explained in the footnote at the bottom of the page, is measure as the average time taken by local residents. This measure fails miserably in providing useful information for anyone who is thinking about moving in from other areas in the city. People living in different areas very likely go to different parts of the city for work, and a person who wants to move in but also keep his or her old job will very likely encounter far longer commuting times. This is a hard problem to solve though. The author has indeed made some effort, but the result by itself is not satisfying. My suggestion is to have a slide down menu where the reader can pick their workplace area and then the graph updates with commuting time to that workplace. I am not sure if there is a google map API where we can extract such data.

### Is it beautiful?

The graph looks ok aesthetically. However, I do not understand why the dots are connected with a line to a seemingly arbitrary center point. It is mentioned casually at one point in the article that “the flatter lines suggest that families face a much less severe trade-off”. This explanation makes sense mathematically, but it adds little to the value of the graph. A reader can easily see which district is of good value simply by observing its position on the graph without relying on whatever lines. The lines make this graph messy and obscure some of the smaller dots. I can only guess that the author is trying to give the graph a feeling of wholeness so that the dots do not seem to be dispersed here and there. Anyway, I believe the lines are distracting and not useful at all.

### Is it insightful?

I believe the graph provides very good insight into the relationship between school quality and home prices. The relationship, as shown in the graph, is not so simple a strict upward line as we would expect. There are a lot of exceptions and a reader should be able to use this graph to find his or her own sweet spot in this school-price trade-off.

### Is it enlightening?

Too use enlightening to describe the graph will be too strong a word. It does a decent job achieving its main goals. While it shows that some homes can have both low prices and be within good school district, not too much further information are presented. For readers who are serious considering moving, issues such as safety and local amenities are all important. The so-called good value districts might very well be those with higher crime rate or poorly maintained public facilities. Without those information, the graph itself provides a good start point for home search but I won’t say it is particularly enlightening.
