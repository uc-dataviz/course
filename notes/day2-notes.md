Day 2 - Principles of data visualization
================

-   [Objectives](#objectives)
-   [Basic data structures](#basic-data-structures)
    -   [Data types](#data-types)
    -   [Dataset types](#dataset-types)
        -   [Tables](#tables)
        -   [Networks](#networks)
        -   [Fields](#fields)
        -   [Geometry](#geometry)
    -   [Attribute types](#attribute-types)
    -   [Semantics](#semantics)
-   [Why visualize your data](#why-visualize-your-data)
-   [Encoding data in visualizations](#encoding-data-in-visualizations)
-   [Identifying appropriate graphical forms](#identifying-appropriate-graphical-forms)
    -   [Cairo's *Truthful Art* suggested approach](#cairos-truthful-art-suggested-approach)
    -   [What is the story?](#what-is-the-story)
-   [Basic charts](#basic-charts)
    -   [Distribution](#distribution)
        -   [Histogram](#histogram)
        -   [Density plot](#density-plot)
        -   [Box-and-whisker plot](#box-and-whisker-plot)
    -   [Comparisons](#comparisons)
        -   [Bar chart](#bar-chart)
        -   [Box plot](#box-plot)
    -   [Relationships](#relationships)
        -   [Scatterplot](#scatterplot)
        -   [Line graph](#line-graph)
        -   [Network diagram](#network-diagram)
        -   [Heatmap](#heatmap)
    -   [Proportions](#proportions)
        -   [Stacked bar chart](#stacked-bar-chart)
        -   [Bubble chart](#bubble-chart)
        -   [Proportional area chart](#proportional-area-chart)
    -   [Part-to-a-whole](#part-to-a-whole)
        -   [Pie chart](#pie-chart)
        -   [Donut chart](#donut-chart)
-   [Session Info](#session-info)

``` r
library(tidyverse)
library(knitr)
library(stringr)
library(broom)
library(forcats)
library(plotly)
library(readxl)
library(gapminder)
library(network)
library(sna)
library(GGally)
library(geomnet)
library(ggnetwork)
library(igraph)
library(lubridate)

set.seed(1234)
theme_set(theme_minimal())
```

Objectives
==========

-   Define data structures
-   Identify why you should visualize your data using Anscombe's Quartet
-   Define marks and channels
-   Discuss how to identify appropriate graphical forms given the communication goal
-   Demonstrate different types of basic charts and identify their use case

Basic data structures
=====================

Before determining the type of visualization to draw, one must first consider the type of data and information to visualize.[1] First we identify major types of **data**, then identify how they can be combined to generate a **dataset**.

Data types
----------

![Source: Visualization Analysis and Design. Tamara Munzner, with illustrations by Eamonn Maguire. A K Peters Visualization Series, CRC Press, 2014.](images/fig2.1a.png)

There are five major types of data:

1.  **Attribute** - some specific property that can be measured, observed, or logged
    -   Also known as a **variable** or **dimension**

2.  **Item** - an individual entity that is discrete, such as a row in a table or a node in a network
    -   Can think of this as the **unit of analysis** - what is being measured?

3.  **Link** - a relationship between items, typically within a network
4.  **Grid** - specifies the strategy for sampling continuous data in terms of both geometric and topological relationships between cells
5.  **Position** - spatial data identifying location in two-dimensional (2D) or three-dimensional (3D) space

Dataset types
-------------

Different types of **datasets** will contain different types of **data**.

![Source: Visualization Analysis and Design. Tamara Munzner, with illustrations by Eamonn Maguire. A K Peters Visualization Series, CRC Press, 2014.](images/fig2.1b.png)

![Source: Visualization Analysis and Design. Tamara Munzner, with illustrations by Eamonn Maguire. A K Peters Visualization Series, CRC Press, 2014.](images/fig2.1c_alt.png)

### Tables

**Tables** are the standard dataset type in social science. They resemble spreadsheets, and store data in either a **flat** or **multidimensional** table.

A **flat table** stores data in rows and columns.

-   Each row is an item
-   Each column is an attribute
-   Each cell is a value fully specified by the combination of row and column

A **multidimensional table** uses multiple keys to uniquely identify each item. For example, longitudinal data (repeated observations of items) may still be stored in a flat table but use two columns (attributes) to uniquely identify each item. Alternatively, data can be stored in a multidimensional array that preserves the multidimensional structure.

### Networks

**Networks** are used to specify relationships between two or more items.

![A small example network with eight vertices and ten edges. Source: [Wikipedia](https://en.wikipedia.org/wiki/Network_theory)](images/small_network.png)

-   **Item** ≡ **Node**
    -   Also known as a **vertex**
-   **Link** - relationship between nodes
    -   Also known as an **edge**
-   Nodes can have associated attributes
-   Links can also (independently) have attributes

#### Trees

![Organization, mission, and functions manual: Civil Rights Division. Source: [U.S. Department of Justice](https://www.justice.gov/jmd/organization-mission-and-functions-manual-civil-rights-division)](images/crt.gif)

A **tree** is a network with a hierarchical structure - each child node has only one parent node pointing to it.

### Fields

**Fields** contain attribute values associated with cells. **Cells** contain measurements or calculations from a **continuous** domain: theoretically there are an infinite number of values you could measure, so you select a discrete interval from which to sample.

![Source: [NASA Earth Observatory](https://earthobservatory.nasa.gov/Features/GISSTemperature//giss_temperature3.php)](images/us_stations_urban_map.gif)

For instance, measuring climate change is serious stuff. In order to accurately measure climate change, where do you place your measurement stations?

-   Pavement artificially increases the measured temperature on the surface of the Earth, so you cannot place the station too close to paved surfaces
-   Urban regions generate more man-made heat, so stations located near urban regions should report warmer temperatures than rural regions
-   Data collection methods in developing countries could be unreliable, so should we trust those measurements?

### Geometry

**Geometry** datasets specify information about the shape of items with explicit spatial positions. These could be maps, but also include any item like points, one-dimensional lines and curves, two-dimensional surfaces or regions, or three-dimensional volumes. Aside from maps, these types of datasets frequently appear in the physical sciences, but less so in the social sciences.

Attribute types
---------------

![Source: Visualization Analysis and Design. Tamara Munzner, with illustrations by Eamonn Maguire. A K Peters Visualization Series, CRC Press, 2014.](images/fig2.4.png)

**Attribute types** (or **variable types**) define the different types of data encoded in attributes, and will generally be important to determining how to visually depict these attributes.

Semantics
---------

**Semantics** define the real-world meaning of data. Data **type** defines its structural or mathematical interpretation. For instance, numbers are stored in R as **integer** or **doubles**. That is the data's type. However these numbers can have any number of semantic meanings. Are they days of the month? A person's age? A zip code?

A **key** attribute acts as an index that is used to look up the **value** attributes, so the key must uniquely identify each item. Sometimes a single attribute acts as the key, whereas in higher-dimensional data multiple attributes in combination form the key attributes. In the most basic table, the row number acts as the key attribute.

> Munzner defines key attributes as **independent variables**, while value attributes are **dependent variables**. I don't particularly like this definition because depending on the research question, an attribute may serve as a dependent variable or as an independent variable (in statistical terms).

Why visualize your data
=======================

Research methods classes in graduate school generally teach important skills such as probability and statistical theory, regression, analysis of variance (ANOVA), maximum likelihood estimation (MLE), etc. While these are important methods for analyzing data and assessing research questions, sometimes drawing a picture (aka **visualization**) can be more precise than conventional statistical computations.[2]

Consider the following data sets:

\[1\] "Table: Dataset 1" "" " x y"
\[4\] "--- ------" " 10 8.04" " 8 6.95"
\[7\] " 13 7.58" " 9 8.81" " 11 8.33"
\[10\] " 14 9.96" " 6 7.24" " 4 4.26"
\[13\] " 12 10.84" " 7 4.82" " 5 5.68"
attr(,"format") \[1\] "pandoc" attr(,"class") \[1\] "knit\_asis" attr(,"knit\_cacheable") \[1\] NA \[1\] "Table: Dataset 2" "" " x y"
\[4\] "--- -----" " 10 9.14" " 8 8.14"
\[7\] " 13 8.74" " 9 8.77" " 11 9.26"
\[10\] " 14 8.10" " 6 6.13" " 4 3.10"
\[13\] " 12 9.13" " 7 7.26" " 5 4.74"
attr(,"format") \[1\] "pandoc" attr(,"class") \[1\] "knit\_asis" attr(,"knit\_cacheable") \[1\] NA \[1\] "Table: Dataset 3" "" " x y"
\[4\] "--- ------" " 10 7.46" " 8 6.77"
\[7\] " 13 12.74" " 9 7.11" " 11 7.81"
\[10\] " 14 8.84" " 6 6.08" " 4 5.39"
\[13\] " 12 8.15" " 7 6.42" " 5 5.73"
attr(,"format") \[1\] "pandoc" attr(,"class") \[1\] "knit\_asis" attr(,"knit\_cacheable") \[1\] NA \[1\] "Table: Dataset 4" "" " x y"
\[4\] "--- ------" " 8 6.58" " 8 5.76"
\[7\] " 8 7.71" " 8 8.84" " 8 8.47"
\[10\] " 8 7.04" " 8 5.25" " 19 12.50"
\[13\] " 8 5.56" " 8 7.91" " 8 6.89"
attr(,"format") \[1\] "pandoc" attr(,"class") \[1\] "knit\_asis" attr(,"knit\_cacheable") \[1\] NA

What are the corresponding relationships between *X* and *Y*? Using traditional metrics, the relationships appear identical across the samples:

\[1\] "Table: Dataset 1"
\[2\] ""
\[3\] " *N* $\\\\bar{X}$ $\\\\bar{Y}$ *R*<sup>2</sup>" \[4\] "---- ---------- ---------- ----------"
\[5\] " 11 9 7.500909 0.8164205"
attr(,"format") \[1\] "pandoc" attr(,"class") \[1\] "knit\_asis" attr(,"knit\_cacheable") \[1\] NA \[1\] "Table: Dataset 2"
\[2\] ""
\[3\] " *N* $\\\\bar{X}$ $\\\\bar{Y}$ *R*<sup>2</sup>" \[4\] "---- ---------- ---------- ----------"
\[5\] " 11 9 7.500909 0.8162365"
attr(,"format") \[1\] "pandoc" attr(,"class") \[1\] "knit\_asis" attr(,"knit\_cacheable") \[1\] NA \[1\] "Table: Dataset 3"
\[2\] ""
\[3\] " *N* $\\\\bar{X}$ $\\\\bar{Y}$ *R*<sup>2</sup>" \[4\] "---- ---------- ---------- ----------"
\[5\] " 11 9 7.5 0.8162867"
attr(,"format") \[1\] "pandoc" attr(,"class") \[1\] "knit\_asis" attr(,"knit\_cacheable") \[1\] NA \[1\] "Table: Dataset 4"
\[2\] ""
\[3\] " *N* $\\\\bar{X}$ $\\\\bar{Y}$ *R*<sup>2</sup>" \[4\] "---- ---------- ---------- ----------"
\[5\] " 11 9 7.500909 0.8165214"
attr(,"format") \[1\] "pandoc" attr(,"class") \[1\] "knit\_asis" attr(,"knit\_cacheable") \[1\] NA

If we estimated linear regression models for each dataset, we would obtain virtually identical coefficients (again suggesting the relationships are identical):

\[1\] "
<table class="\&quot;kable_wrapper\&quot;">
<caption>
Dataset 1
</caption>
<tbody>
<tr>
<td>
Estimate Standard Error *T*-statistic p-value------------ ---------- --------------- -------------- ----------(Intercept) 3.0000909 1.1247468 2.667348 0.02573410.5000909 0.1179055 4.241455 0.0021696
</td>
</tr>
</tbody>
</table>
" attr(,"format") \[1\] "pandoc" attr(,"class") \[1\] "knit\_asis" attr(,"knit\_cacheable") \[1\] NA \[1\] "
<table class="\&quot;kable_wrapper\&quot;">
<caption>
Dataset 2
</caption>
<tbody>
<tr>
<td>
Estimate Standard Error *T*-statistic p-value------------ --------- --------------- -------------- ----------(Intercept) 3.000909 1.1253024 2.666758 0.02575890.500000 0.1179637 4.238590 0.0021788
</td>
</tr>
</tbody>
</table>
" attr(,"format") \[1\] "pandoc" attr(,"class") \[1\] "knit\_asis" attr(,"knit\_cacheable") \[1\] NA \[1\] "
<table class="\&quot;kable_wrapper\&quot;">
<caption>
Dataset 3
</caption>
<tbody>
<tr>
<td>
Estimate Standard Error *T*-statistic p-value------------ ---------- --------------- -------------- ----------(Intercept) 3.0024545 1.1244812 2.670080 0.02561910.4997273 0.1178777 4.239372 0.0021763
</td>
</tr>
</tbody>
</table>
" attr(,"format") \[1\] "pandoc" attr(,"class") \[1\] "knit\_asis" attr(,"knit\_cacheable") \[1\] NA \[1\] "
<table class="\&quot;kable_wrapper\&quot;">
<caption>
Dataset 4
</caption>
<tbody>
<tr>
<td>
Estimate Standard Error *T*-statistic p-value------------ ---------- --------------- -------------- ----------(Intercept) 3.0017273 1.1239211 2.670763 0.02559040.4999091 0.1178189 4.243028 0.0021646
</td>
</tr>
</tbody>
</table>
" attr(,"format") \[1\] "pandoc" attr(,"class") \[1\] "knit\_asis" attr(,"knit\_cacheable") \[1\] NA

But what happens if we draw a picture?

![](day2-notes_files/figure-markdown_github/mislead_plot-1.png)

A good picture tells the reader much more than any table or text can provide.

Encoding data in visualizations
===============================

Visualizations are the process of visually encoding data. There are several different models that define this process, one of which is based on **marks** and **channels**. A mark is a basic graphical element in an image, and is quite primitive.

![Source: Visualization Analysis and Design. Tamara Munzner, with illustrations by Eamonn Maguire. A K Peters Visualization Series, CRC Press, 2014.](images/fig5.2.png)

-   A zero-dimensional mark is a **point**
-   A one-dimensional mark is a **line**
-   A two-dimensional mark is an **area**
-   A three-dimensional mark is a **volume**

Visual **channels** control the appearance of marks, independent of the dimensionality of the mark itself. However the dimensionality of the mark can in part determine the types of channels that can be used.

![Source: Visualization Analysis and Design. Tamara Munzner, with illustrations by Eamonn Maguire. A K Peters Visualization Series, CRC Press, 2014.](images/fig5.3.png)

Channels can be added or combined to encode additional attributes (or variables) inside the graphic. In this first graph, we encode engine displacement size using data from the `mpg` dataset. There is a single continuous attribute to encode, so a histogram is an appropriate chart. In truth, we actually encode two attributes. Histograms bin data into a set number of intervals of equal size and count the frequency of items (or observations) occuring in each interval, so the graph uses a line mark with vertical spatial position channel for the quantitative variable (frequency) and a horizontal spatial position channel for the categorical attribute.

``` r
ggplot(mpg, aes(x = displ)) +
  geom_histogram() +
  labs(title = "mpg")
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](day2-notes_files/figure-markdown_github/mpg-1-1.png)

Now we encode a second attribute, highway mileage. Because we have two quantitative attributes to encode, a histogram is no longer an appropriate choice; instead, we encode these two attributes using a scatterplot with spatial position to distinguish items from one another. Here, we use point marks with horizontal and vertical spatial position channels.

``` r
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  labs(title = "mpg")
```

![](day2-notes_files/figure-markdown_github/mpg-2-1.png)

We can encode a third categorical attribute (type of car, or `class`) by using a color channel to distinguish each type of car.

``` r
ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point() +
  labs(title = "mpg")
```

![](day2-notes_files/figure-markdown_github/mpg-3a-1.png)

> Alternatively, we could have used a shape channel to distinguish each category. However notice that the graph generates a warning message. What does this mean?

``` r
ggplot(mpg, aes(x = displ, y = hwy, shape = class)) +
  geom_point() +
  labs(title = "mpg")
```

    ## Warning: The shape palette can deal with a maximum of 6 discrete values
    ## because more than 6 becomes difficult to discriminate; you have 7.
    ## Consider specifying shapes manually if you must have them.

    ## Warning: Removed 62 rows containing missing values (geom_point).

![](day2-notes_files/figure-markdown_github/mpg-3b-1.png)

Finally, we can encode a fourth attribute (number of cylinders) by making use of a size channel.

``` r
ggplot(mpg, aes(x = displ, y = hwy, color = class, size = cyl)) +
  geom_point() +
  labs(title = "mpg")
```

![](day2-notes_files/figure-markdown_github/mpg-4-1.png)

The important thing to remember is that once a channel has been used to encode information, it cannot be used again in the same visualization. We can combine multiple channels together to encode additional information, but not reuse the same channel. For instance, what if I wanted to encode both car type and number of cylinders using the color channel? This would not work.

Likewise, different marks have inherent constraints on how attributes can be encoded. For instance, a line mark encodes a quantitative attribute using length in a single (usually vertical) direction. We could encode additional information by adjusting the width of the line (the horizontal direction), but not adjusting the height of the line. If we did this, then the original information would be lost.

Different channel types convey information with varying levels of accuracy and perceptivity. Later in the term we will consider in much greater detail why this occurs and how to determine optimal channels for conveying attributes in your own visualizations.

Identifying appropriate graphical forms
=======================================

Once we learn more about elementary perceptual tasks and why some channels are better than others, choosing appropriate graphical forms will become more complex as we more carefully consider the specific marks and channels used to communicate our data. Here, we will identify at a high-level some suggestions to follow when determining an appropriate graphical form and consider several basic types of charts and their appropriate use cases.

Cairo's *Truthful Art* suggested approach
-----------------------------------------

1.  Think about the task or tasks you want to enable
2.  Try different graphic forms
3.  Arrange the components of the graphic
4.  Test the outcomes

These suggestions are a bit vague, but I really like the last one: **test the outcomes**.[3] Something that appears intuitive to you may not appear the same way to a different audience. Especially in the context of statistical graphics and presenting academic results, you become steeped in the data so much that you assume everyone else has lots of background knowledge about your dataset. However they do not possess this knowledge: that's why they're reading your visualization.

What is the story?
------------------

Another of Cairo's suggestions is really useful: what is the story you want to tell?

![Source: The Truthful Art: Data, charts, and maps for communication. Alberto Cairo. New Riders, 2016.](images/ta_piketty.jpeg)

Consider the bottom two graphs: which is the better graph? Well, it depends. If our goal is the same as Piketty's, then we want to compare Europe to the rest of the continents. The stacked area chart accomplishes this goal just fine by placing Europe on the bottom, sitting at the baseline. However if the goal is to compare all continents with one another, then this graph does not do a good job. Making comparisons with Africa and America are difficult because their baselines are dependent on Europe's GDP percentage. Instead, we'd rather all continents start at the same baseline to enable easy comparisons, which is what the non-stacked grouped line chart accomplishes. Depending on your story, you want to choose a graph/chart type that best tells that story.

Basic charts
============

Your graphical form should be selected based on the purpose of your visual communication. Severino Ribecca's [Data Visualization Catalogue](http://www.datavizcatalogue.com/) groups different types of charts based on what you want to show. This could include things like:

-   Comparisons
-   Proportions
-   Relationships
-   Location
-   Distribution
-   Patterns

Many charts can be used to show more than one story, so there is substantial overlap. Let's examine a few of the most common graphical forms and the types of stories they communicate.

Distribution
------------

**Distribution** graphs visualize frequency, how data is spread out over an interval, or how data is grouped.

### Histogram

``` r
infant <- read_csv("data/infant.csv") %>%
  # remove non-countries
  filter(is.na(`Value Footnotes`) | `Value Footnotes` != 1) %>%
  select(`Country or Area`, Year, Value) %>%
  rename(country = `Country or Area`,
         year = Year,
         mortal = Value)
```

    ## Parsed with column specification:
    ## cols(
    ##   `Country or Area` = col_character(),
    ##   Subgroup = col_character(),
    ##   Year = col_integer(),
    ##   Source = col_character(),
    ##   Unit = col_character(),
    ##   Value = col_integer(),
    ##   `Value Footnotes` = col_integer()
    ## )

``` r
ggplot(infant, aes(mortal)) +
  geom_histogram(bins = 10, boundary = 0) +
  labs(title = "Histogram of infant mortality rate for 195 nations",
       subtitle = "10 bins, origin = 0",
       x = "Infant mortality rate (per 1,000)",
       y = "Frequency")
```

![](day2-notes_files/figure-markdown_github/infant-hist-1.png)

``` r
ggplot(infant, aes(mortal)) +
  geom_histogram(bins = 10, boundary = -5) +
  labs(title = "Histogram of infant mortality rate for 195 nations",
       subtitle = "10 bins, origin = -5",
       x = "Infant mortality rate (per 1,000)",
       y = "Frequency")
```

![](day2-notes_files/figure-markdown_github/infant-hist-2.png)

``` r
ggplot(infant, aes(mortal)) +
  geom_histogram(bins = 20, boundary = -5) +
  labs(title = "Histogram of infant mortality rate for 195 nations",
       subtitle = "20 bins, origin = -5",
       x = "Infant mortality rate (per 1,000)",
       y = "Frequency")
```

![](day2-notes_files/figure-markdown_github/infant-hist-3.png)

A **histogram** visualizes the distribution of a continuous quantitative attribute by binning the observations into equal-width intervals and using line marks to denote the frequency of observations appearing in each bin. The sum of the height of all the bars is equal to the number of observations/items in the dataset. The shape of a histogram is determined by the **origin** (the starting point of the graph) and the **binwidth** (the width of each interval). Selecting optimal origins and binwidth is somewhat trial-and-error, though there are more complex options to try and optimize these values.

Histograms help estimate where values are concentrated, whether there are usual values (outliers), and establish the general distribution of the variable (attribute).

### Density plot

``` r
ggplot(infant, aes(mortal)) +
  geom_density(kernel = "rectangular") +
  labs(title = "Naive density estimator of infant mortality rate for 195 nations",
       x = "Infant mortality rate (per 1,000)",
       y = "Density")
```

![](day2-notes_files/figure-markdown_github/infant-density-1.png)

``` r
ggplot(infant, aes(mortal)) +
  geom_density(kernel = "gaussian") +
  labs(title = "Gaussian density estimator of infant mortality rate for 195 nations",
       x = "Infant mortality rate (per 1,000)",
       y = "Density")
```

![](day2-notes_files/figure-markdown_github/infant-density-2.png)

``` r
ggplot(infant, aes(mortal)) +
  geom_density(aes(color = "Gaussian"), kernel = "gaussian") +
  geom_density(aes(color = "Epanechnikov"), kernel = "epanechnikov") +
  geom_density(aes(color = "Rectangular"), kernel = "rectangular") +
  geom_density(aes(color = "Triangular"), kernel = "triangular") +
  geom_density(aes(color = "Biweight"), kernel = "biweight") +
  labs(title = "Density estimators of infant mortality rate for 195 nations",
       x = "Infant mortality rate (per 1,000)",
       y = "Density",
       color = "Kernel") +
  theme(legend.position = c(0.96, 1),
        legend.justification = c(1, 1),
        legend.background = element_rect(fill = "white"))
```

![](day2-notes_files/figure-markdown_github/infant-density-3.png)

Alternatively, **density plots** visualize the distribution of data over a continuous interval by using [kernel smoothing](http://cfss.uchicago.edu/persp010_nonparametric.html#density_estimation) to plot values. This method's advantage over histograms is that density plots are not effected by the number of bins used to draw the plot, as it is a continuous function.

### Box-and-whisker plot

``` r
ggplot(diamonds, aes(1, carat)) +
  geom_boxplot() +
  labs(title = "Diamonds data",
       x = NULL,
       y = "Carat size") +
  theme(axis.text.x = element_blank())
```

![](day2-notes_files/figure-markdown_github/boxplot-1.png)

``` r
ggplot(diamonds, aes(carat)) +
  geom_histogram() +
  labs(title = "Diamonds data",
       x = NULL,
       y = "Carat size")
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](day2-notes_files/figure-markdown_github/boxplot-2.png)

A **box-and-whisker plot** (or simply a **box plot**) visualizes the distribution of a variable through its **quartiles**. The middle bar identifies the median value of the variable, and the box extends to the 25th and 75th percentiles (or lower and upper quartiles). The lower and upper extremes are defined by the interquartile range (IQR), whereby the whiskers (or lines) extend up to 1.5 x IQR. Outliers are defined as values outside of the range defined by the whiskers and are plotted using point marks.

As a standalone graph depicting the distribution of a single variable, it generally provides less information than a comparable histogram or density plot. It does provide some useful information, such as:

-   The key values (median, 25th percentile, 75th percentile, etc.)
-   If any outliers are present
-   Is the data symmetrical
-   Is the data skewed

The main benefit to a box plot is that it is much more compact than a histogram, so if we want to compare the distribution of a variable between groups, then a box plot will take up much less space.

Comparisons
-----------

### Bar chart

``` r
ggplot(diamonds, aes(cut)) +
  geom_bar() +
  labs(title = "Diamonds data",
       x = "Cut of diamond",
       y = "Frequency count")
```

![](day2-notes_files/figure-markdown_github/bar-1.png)

``` r
ggplot(diamonds, aes(fct_rev(cut))) +
  geom_bar() +
  coord_flip() +
  labs(title = "Diamonds data",
       x = "Cut of diamond",
       y = "Frequency count")
```

![](day2-notes_files/figure-markdown_github/bar-2.png)

A **bar chart** uses either vertical or horizontal bars (line marks) to show discrete, quantitative comparisons across categories. The height of the line indicates the number of items, and separate lines are drawn for each category. Bar charts are distinguished from histograms because they do not display continuous attributes over an interval, but instead visualize discrete categories.

#### Grouped bar chart

``` r
ggplot(diamonds, aes(cut, fill = color)) +
  geom_bar(position = "dodge") +
  labs(title = "Diamonds data",
       x = "Cut of diamond",
       y = "Frequency count",
       color = "Color")
```

![](day2-notes_files/figure-markdown_github/bar-group-1.png)

**Grouped** or **clustered bar charts** are a variation of a bar chart that encode information on an additional channel by drawing separate bars for categories defined by a second attribute. Color is typically used as the channel to distinguish the new categories. This chart allows comparisons between or across the newly defined groups, or to compare the mini histogram-like distributions to each other, so each bar in the group would repreent the significant intervals of the variable. The downside to this graphical form is that as the number of groups increases, the harder the bars become to read and compare.

### Box plot

``` r
ggplot(diamonds, aes(cut, carat)) +
  geom_boxplot() +
  labs(title = "Diamonds data",
       x = "Cut",
       y = "Carat size")
```

![](day2-notes_files/figure-markdown_github/boxplot-group-1.png)

``` r
ggplot(diamonds, aes(carat, fill = cut)) +
  geom_histogram(alpha = .5, position = "identity") +
  labs(title = "Diamonds data",
       x = "Carat size",
       y = "Frequency count",
       color = "Cut")
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](day2-notes_files/figure-markdown_github/boxplot-group-2.png)

``` r
ggplot(diamonds, aes(carat, color = cut)) +
  geom_density() +
  labs(title = "Diamonds data",
       x = "Carat size",
       y = "Frequency count",
       color = "Cut")
```

![](day2-notes_files/figure-markdown_github/boxplot-group-3.png)

Now the advantages of the box plot come into view. Try comparing the distribution of diamonds' carat size between the different cuts. Which is the easiest to discern any differences?

#### Violin plot

``` r
ggplot(diamonds, aes(cut, carat)) +
  geom_violin() +
  labs(title = "Diamonds data",
       x = "Cut",
       y = "Carat size")
```

![](day2-notes_files/figure-markdown_github/violin-1.png)

``` r
ggplot(diamonds, aes(cut, carat)) +
  geom_violin() +
  geom_boxplot(width = .1, outlier.shape = NA) +
  labs(title = "Diamonds data",
       subtitle = "With overlayed box plot",
       x = "Cut",
       y = "Carat size")
```

![](day2-notes_files/figure-markdown_github/violin-2.png)

**Violin plots** visualize the distribution of the data and its probability density. They are essentially a cross between a box plot and a density plot. The density plot is rotated 90 degrees and mirrored to show the distributional shape of the variable. Violin plots can provide more information about the shape of the distribution of the data, but are also more noisy than a box plot. This is why you might combine the two by overlaying a boxplot on top of the violin plot (omitting the outliers).

Relationships
-------------

### Scatterplot

``` r
ggplot(diamonds, aes(carat, price)) +
  geom_point(alpha = .2) +
  scale_y_continuous(labels = scales::dollar) +
  labs(title = "Diamonds data",
       x = "Carat size",
       y = "Price")
```

![](day2-notes_files/figure-markdown_github/scatter-1.png)

**Scatterplots** use a collection of points on the Cartesian coordinate plane to display two quantitative variables. These are good for detecting correlations and relationships between two variables.[4] Especially with a large number of items (observations), overlaying the plot with a best-fit or trend line is a common method to aid in analysis.

``` r
ggplot(diamonds, aes(carat, price)) +
  geom_point(alpha = .2) +
  geom_smooth(se = FALSE) +
  scale_y_continuous(labels = scales::dollar) +
  labs(title = "Diamonds data",
       x = "Carat size",
       y = "Price")
```

    ## `geom_smooth()` using method = 'gam'

![](day2-notes_files/figure-markdown_github/scatter-best-fit-1.png)

### Line graph

``` r
state <- read_excel("data/state_ideo.xlsx")
```

``` r
state %>%
  group_by(year) %>%
  summarize(ideo = mean(citi6013, na.rm = TRUE)) %>%
  ggplot(aes(year, ideo, group = 1)) +
  geom_line() +
  labs(title = "US state-level ideology",
       x = "Year",
       y = "Citizen ideology\n(Conservative - Liberal)")
```

    ## Warning: Removed 1 rows containing missing values (geom_path).

![](day2-notes_files/figure-markdown_github/line-1.png)

**Line graphs** are used to display quantitative attributes over a continuous interval or time span. First the attributes are plotted on a Cartesian coordinate plane using points, then each point is connected using a line between the points. Line charts are preferable in this context because they visually "connect the dots" and encourage the reading of trends and patterns over time. Compare this to a scatterplot or bar chart approach:

``` r
state %>%
  group_by(year) %>%
  summarize(ideo = mean(citi6013, na.rm = TRUE)) %>%
  ggplot(aes(year, ideo, group = 1)) +
  geom_point() +
  labs(title = "US state-level ideology",
       x = "Year",
       y = "Citizen ideology\n(Conservative - Liberal)")
```

    ## Warning: Removed 1 rows containing missing values (geom_point).

![](day2-notes_files/figure-markdown_github/line-alt-1.png)

``` r
state %>%
  group_by(year) %>%
  summarize(ideo = mean(citi6013, na.rm = TRUE)) %>%
  ggplot(aes(year, ideo, group = 1)) +
  geom_col() +
  labs(title = "US state-level ideology",
       x = "Year",
       y = "Citizen ideology\n(Conservative - Liberal)")
```

    ## Warning: Removed 1 rows containing missing values (position_stack).

![](day2-notes_files/figure-markdown_github/line-alt-2.png)

Neither of these does as good of a job as indicating a change over time.

#### Grouped line charts

We can also make comparisons between groups by drawing separate lines on the same graph:

``` r
gapminder %>%
  group_by(year) %>%
  summarize(lifeExp = mean(lifeExp, na.rm = TRUE)) %>%
  ggplot(aes(year, lifeExp, group = 1)) +
  geom_line() +
  labs(title = "Gapminder quality of life measures",
       subtitle = "Global average",
       x = "Year",
       y = "Life expectancy (in years)")
```

![](day2-notes_files/figure-markdown_github/line-group-1.png)

``` r
gapminder %>%
  group_by(continent, year) %>%
  summarize(lifeExp = mean(lifeExp, na.rm = TRUE)) %>%
  ggplot(aes(year, lifeExp, color = continent)) +
  geom_line() +
  labs(title = "Gapminder quality of life measures",
       subtitle = "By continent",
       x = "Year",
       y = "Life expectancy (in years)",
       color = "Continent")
```

![](day2-notes_files/figure-markdown_github/line-group-2.png)

``` r
gapminder %>%
  group_by(continent, year) %>%
  summarize(lifeExp = mean(lifeExp, na.rm = TRUE)) %>%
  ggplot(aes(year, lifeExp, linetype = continent)) +
  geom_line() +
  labs(title = "Gapminder quality of life measures",
       subtitle = "By continent",
       x = "Year",
       y = "Life expectancy (in years)",
       linetype = "Continent")
```

![](day2-notes_files/figure-markdown_github/line-group-3.png)

### Network diagram

``` r
# make data accessible
data(blood, package = "geomnet")

# plot with ggnet2 (Figure 2a)
set.seed(12252016)
ggnet2(network::network(blood$edges[, 1:2], directed=TRUE), 
       mode = "circle", size = 15, label = TRUE, 
       arrow.size = 10, arrow.gap = 0.05, vjust = 0.5,
       node.color = "darkred", label.color = "grey80") +
  labs(title = "Blood type donation")
```

    ## Warning: Removed 8 rows containing missing values (geom_segment).

![](day2-notes_files/figure-markdown_github/network-1.png)

``` r
#make data accessible
data(football, package = 'geomnet')
rownames(football$vertices) <-
  football$vertices$label
# create network 
fb.net <- network::network(football$edges[, 1:2],
                  directed = TRUE)
# create node attribute (what conference is team in?)
fb.net %v% "conf" <-
  football$vertices[
    network.vertex.names(fb.net), "value"
    ]
# create edge attribute (between teams in same conference?)
network::set.edge.attribute(
  fb.net, "same.conf",
  football$edges$same.conf)
set.seed(5232011)
ggnet2(fb.net, mode = "fruchtermanreingold",
       color = "conf",  palette = "Paired",
       color.legend = "Conference",
       edge.color = c("color", "grey75")) +
  labs(title = "Network of Division I college football teams",
       subtitle = "2000 season")
```

![](day2-notes_files/figure-markdown_github/network-2.png)

**Network diagrams** (also known as **network graphs**) show how items (nodes) are connected through links.[5] Nodes are represented as dots and links connect the nodes based on their relationships to one another. Networks can be **directed** (like the blood type example) or **undirected** (the football example). Directed graphs contain directionality between the nodes, whereas undirected graphs only show relationships. Additional information can be incorportated through different channels, such as color, node size, and link width. Network graphs are good for interpreting the structure of a network, though as the nodes and network complexity increases they become more difficult to interpret.

### Heatmap

``` r
flights <- read_csv("data/flights-departed.csv") %>%
  mutate(year = year(date),
         month = month(date, label = TRUE),
         day = day(date),
         weekday = wday(date, label = TRUE),
         week = week(date),
         yday = yday(date)) %>%
  group_by(year) %>%
  mutate(yday = yday + wday(date)[1] - 2,
         week = floor(yday / 7)) %>%
  group_by(year, month) %>%
  mutate(week_month = week - min(week) + 1)
```

    ## Parsed with column specification:
    ## cols(
    ##   date = col_date(format = ""),
    ##   value = col_integer()
    ## )

``` r
ggplot(flights, aes(date, value)) +
  geom_line() +
  labs(title = "Domestic commercial flight activity",
       x = "Date",
       y = "Number of departing flights in the United States")
```

![](day2-notes_files/figure-markdown_github/heatmap-prep-1.png)

``` r
ggplot(flights, aes(weekday, week_month, fill = value)) +
  facet_grid(year ~ month) +
  geom_tile(color = "black") +
  scale_fill_continuous(low = "red", high = "green") +
  scale_x_discrete(labels = NULL) +
  scale_y_reverse(labels = NULL) +
  labs(title = "Domestic commercial flight activity",
       x = NULL,
       y = NULL,
       fill = "Number of departing flights") +
  theme_void() +
  theme(legend.position = "bottom")
```

![](day2-notes_files/figure-markdown_github/heatmap-1.png)

**Heatmaps** visualize data through variations in color.[6] They can be useful for detecting patterns and variance across multiple variables. Depending on the story you wish to communicate, alternative chart types can be useful (compare the line graph to the heatmap above). Heatmaps are good at providing a general overview of the data, as opposed to identifying attributes for specific items.

Proportions
-----------

Proportional graphs use size or area to show differences and similarities between values.

### Stacked bar chart

``` r
ggplot(diamonds, aes(cut, fill = color)) +
  geom_bar() +
  labs(title = "Diamonds data",
       subtitle = "Stacked bar chart",
       x = "Cut of diamond",
       y = "Frequency count",
       color = "Color")
```

![](day2-notes_files/figure-markdown_github/stack-bar-1.png)

``` r
ggplot(diamonds, aes(cut, fill = color)) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = scales::percent) +
  labs(title = "Diamonds data",
       subtitle = "Proportional bar chart",
       x = "Cut of diamond",
       y = "Frequency count",
       color = "Color")
```

![](day2-notes_files/figure-markdown_github/stack-bar-2.png)

**Stacked bar charts** display bars stacked on top of one another, as opposed to side by side. A plain stacked bar chart still reports the raw frequency count, whereas a proportional stacked bar chart converts the frequencies into percentages of the whole group. Comparison across groups as identified on the *X*-axis are easier under the proportional method because each set of bars sums to the same total (1 or 100%).

### Bubble chart

> [The Wealth & Health of Nations](https://bost.ocks.org/mike/nations/)

**Bubble charts** are similar to scatterplots, and add a third channel based on size to communicate another attribute.

### Proportional area chart

``` r
ggplot(diamonds, aes(cut, color)) +
  geom_count() +
  scale_size_continuous(range = c(1, 10)) +
  labs(title = "Diamonds dataset",
       x = "Cut",
       y = "Color",
       size = "Count")
```

![](day2-notes_files/figure-markdown_github/prop-area-chart-1.png)

``` r
ggplot(diamonds, aes(cut, color)) +
  geom_count(shape = 15) +
  scale_size_continuous(range = c(1, 10)) +
  labs(title = "Diamonds dataset",
       x = "Cut",
       y = "Color",
       size = "Count")
```

![](day2-notes_files/figure-markdown_github/prop-area-chart-2.png)

**Proportional area charts** compare values and proportions to give a quick overview of the relative sizes of the data. These charts are typically drawn with squares or circles. Comparisons are made relative to the **area** of the shape, not the width or radius.

Part-to-a-whole
---------------

### Pie chart

``` r
pie <- read_csv("age,population
<5,2704659
5-13,4499890
14-17,2159981
18-24,3853788
25-44,14106543
45-64,8819342
≥65,612463") %>%
  mutate(age = factor(age))
```

``` r
plot_ly(pie, labels = ~age, values = ~population, type = 'pie', sort = FALSE) %>%
  layout(xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
         yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
```

<!--html_preserve-->

<script type="application/json" data-for="htmlwidget-36cc4acd9bbbf7b977e5">{"x":{"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"xaxis":{"domain":[0,1],"showgrid":false,"zeroline":false,"showticklabels":false},"yaxis":{"domain":[0,1],"showgrid":false,"zeroline":false,"showticklabels":false}},"source":"A","config":{"modeBarButtonsToAdd":[{"name":"Collaborate","icon":{"width":1000,"ascent":500,"descent":-50,"path":"M487 375c7-10 9-23 5-36l-79-259c-3-12-11-23-22-31-11-8-22-12-35-12l-263 0c-15 0-29 5-43 15-13 10-23 23-28 37-5 13-5 25-1 37 0 0 0 3 1 7 1 5 1 8 1 11 0 2 0 4-1 6 0 3-1 5-1 6 1 2 2 4 3 6 1 2 2 4 4 6 2 3 4 5 5 7 5 7 9 16 13 26 4 10 7 19 9 26 0 2 0 5 0 9-1 4-1 6 0 8 0 2 2 5 4 8 3 3 5 5 5 7 4 6 8 15 12 26 4 11 7 19 7 26 1 1 0 4 0 9-1 4-1 7 0 8 1 2 3 5 6 8 4 4 6 6 6 7 4 5 8 13 13 24 4 11 7 20 7 28 1 1 0 4 0 7-1 3-1 6-1 7 0 2 1 4 3 6 1 1 3 4 5 6 2 3 3 5 5 6 1 2 3 5 4 9 2 3 3 7 5 10 1 3 2 6 4 10 2 4 4 7 6 9 2 3 4 5 7 7 3 2 7 3 11 3 3 0 8 0 13-1l0-1c7 2 12 2 14 2l218 0c14 0 25-5 32-16 8-10 10-23 6-37l-79-259c-7-22-13-37-20-43-7-7-19-10-37-10l-248 0c-5 0-9-2-11-5-2-3-2-7 0-12 4-13 18-20 41-20l264 0c5 0 10 2 16 5 5 3 8 6 10 11l85 282c2 5 2 10 2 17 7-3 13-7 17-13z m-304 0c-1-3-1-5 0-7 1-1 3-2 6-2l174 0c2 0 4 1 7 2 2 2 4 4 5 7l6 18c0 3 0 5-1 7-1 1-3 2-6 2l-173 0c-3 0-5-1-8-2-2-2-4-4-4-7z m-24-73c-1-3-1-5 0-7 2-2 3-2 6-2l174 0c2 0 5 0 7 2 3 2 4 4 5 7l6 18c1 2 0 5-1 6-1 2-3 3-5 3l-174 0c-3 0-5-1-7-3-3-1-4-4-5-6z"},"click":"function(gd) { \n        // is this being viewed in RStudio?\n        if (location.search == '?viewer_pane=1') {\n          alert('To learn about plotly for collaboration, visit:\\n https://cpsievert.github.io/plotly_book/plot-ly-for-collaboration.html');\n        } else {\n          window.open('https://cpsievert.github.io/plotly_book/plot-ly-for-collaboration.html', '_blank');\n        }\n      }"}],"modeBarButtonsToRemove":["sendDataToCloud"]},"data":[{"labels":["<5","5-13","14-17","18-24","25-44","45-64","≥65"],"values":[2704659,4499890,2159981,3853788,14106543,8819342,612463],"sort":false,"type":"pie","marker":{"fillcolor":"rgba(31,119,180,1)","color":"rgba(31,119,180,1)","line":{"color":"transparent"}}}],"base_url":"https://plot.ly"},"evals":["config.modeBarButtonsToAdd.0.click"],"jsHooks":[]}</script>
<!--/html_preserve-->
Ahh, the lovely **pie chart**. Pie charts appear extensively in corporate and government communication, much less so in academic work. They help to show proportions and percentages between categories. Each segment of the circle is proportional to the size of the attribute, and all segments' arc lengths should sum to 100%. There are specific instances where pie charts may be useful and we will examine those use cases later in the term, but typically pie charts are avoided in academic visualizations.

### Donut chart

``` r
plot_ly(pie, labels = ~age, values = ~population, sort = FALSE) %>%
  add_pie(hole = .6) %>%
  layout(xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
         yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
```

<!--html_preserve-->

<script type="application/json" data-for="htmlwidget-588bfc3089262f9c8966">{"x":{"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"xaxis":{"domain":[0,1],"showgrid":false,"zeroline":false,"showticklabels":false},"yaxis":{"domain":[0,1],"showgrid":false,"zeroline":false,"showticklabels":false}},"source":"A","config":{"modeBarButtonsToAdd":[{"name":"Collaborate","icon":{"width":1000,"ascent":500,"descent":-50,"path":"M487 375c7-10 9-23 5-36l-79-259c-3-12-11-23-22-31-11-8-22-12-35-12l-263 0c-15 0-29 5-43 15-13 10-23 23-28 37-5 13-5 25-1 37 0 0 0 3 1 7 1 5 1 8 1 11 0 2 0 4-1 6 0 3-1 5-1 6 1 2 2 4 3 6 1 2 2 4 4 6 2 3 4 5 5 7 5 7 9 16 13 26 4 10 7 19 9 26 0 2 0 5 0 9-1 4-1 6 0 8 0 2 2 5 4 8 3 3 5 5 5 7 4 6 8 15 12 26 4 11 7 19 7 26 1 1 0 4 0 9-1 4-1 7 0 8 1 2 3 5 6 8 4 4 6 6 6 7 4 5 8 13 13 24 4 11 7 20 7 28 1 1 0 4 0 7-1 3-1 6-1 7 0 2 1 4 3 6 1 1 3 4 5 6 2 3 3 5 5 6 1 2 3 5 4 9 2 3 3 7 5 10 1 3 2 6 4 10 2 4 4 7 6 9 2 3 4 5 7 7 3 2 7 3 11 3 3 0 8 0 13-1l0-1c7 2 12 2 14 2l218 0c14 0 25-5 32-16 8-10 10-23 6-37l-79-259c-7-22-13-37-20-43-7-7-19-10-37-10l-248 0c-5 0-9-2-11-5-2-3-2-7 0-12 4-13 18-20 41-20l264 0c5 0 10 2 16 5 5 3 8 6 10 11l85 282c2 5 2 10 2 17 7-3 13-7 17-13z m-304 0c-1-3-1-5 0-7 1-1 3-2 6-2l174 0c2 0 4 1 7 2 2 2 4 4 5 7l6 18c0 3 0 5-1 7-1 1-3 2-6 2l-173 0c-3 0-5-1-8-2-2-2-4-4-4-7z m-24-73c-1-3-1-5 0-7 2-2 3-2 6-2l174 0c2 0 5 0 7 2 3 2 4 4 5 7l6 18c1 2 0 5-1 6-1 2-3 3-5 3l-174 0c-3 0-5-1-7-3-3-1-4-4-5-6z"},"click":"function(gd) { \n        // is this being viewed in RStudio?\n        if (location.search == '?viewer_pane=1') {\n          alert('To learn about plotly for collaboration, visit:\\n https://cpsievert.github.io/plotly_book/plot-ly-for-collaboration.html');\n        } else {\n          window.open('https://cpsievert.github.io/plotly_book/plot-ly-for-collaboration.html', '_blank');\n        }\n      }"}],"modeBarButtonsToRemove":["sendDataToCloud"]},"data":[{"labels":["<5","5-13","14-17","18-24","25-44","45-64","≥65"],"values":[2704659,4499890,2159981,3853788,14106543,8819342,612463],"sort":false,"type":"pie","hole":0.6,"marker":{"fillcolor":"rgba(31,119,180,1)","color":"rgba(31,119,180,1)","line":{"color":"transparent"}}}],"base_url":"https://plot.ly"},"evals":["config.modeBarButtonsToAdd.0.click"],"jsHooks":[]}</script>
<!--/html_preserve-->
A **donut chart** is a variant on the pie chart which removes the central portion of the pie. This deemphasizes attention to the area of each segment, instead focusing on the length of the arcs.

Session Info
============

``` r
devtools::session_info()
```

    ## Session info --------------------------------------------------------------

    ##  setting  value                       
    ##  version  R version 3.3.3 (2017-03-06)
    ##  system   x86_64, darwin13.4.0        
    ##  ui       RStudio (1.0.136)           
    ##  language (EN)                        
    ##  collate  en_US.UTF-8                 
    ##  tz       America/Chicago             
    ##  date     2017-03-29

    ## Packages ------------------------------------------------------------------

    ##  package        * version date       source                            
    ##  assertthat       0.1     2013-12-06 CRAN (R 3.3.0)                    
    ##  backports        1.0.5   2017-01-18 CRAN (R 3.3.2)                    
    ##  base64enc        0.1-3   2015-07-28 CRAN (R 3.3.0)                    
    ##  broom          * 0.4.2   2017-02-13 CRAN (R 3.3.2)                    
    ##  codetools        0.2-15  2016-10-05 CRAN (R 3.3.3)                    
    ##  colorspace       1.3-2   2016-12-14 CRAN (R 3.3.2)                    
    ##  DBI              0.6     2017-03-09 CRAN (R 3.3.3)                    
    ##  devtools         1.12.0  2016-06-24 CRAN (R 3.3.0)                    
    ##  digest           0.6.12  2017-01-27 CRAN (R 3.3.2)                    
    ##  dplyr          * 0.5.0   2016-06-24 CRAN (R 3.3.0)                    
    ##  evaluate         0.10    2016-10-11 CRAN (R 3.3.0)                    
    ##  forcats        * 0.2.0   2017-01-23 CRAN (R 3.3.2)                    
    ##  foreign          0.8-67  2016-09-13 CRAN (R 3.3.3)                    
    ##  gapminder      * 0.2.0   2015-12-31 CRAN (R 3.3.0)                    
    ##  geomnet        * 0.2.0   2016-12-08 CRAN (R 3.3.2)                    
    ##  GGally         * 1.3.0   2016-11-13 CRAN (R 3.3.2)                    
    ##  ggnetwork      * 0.5.1   2017-03-29 Github (briatte/ggnetwork@c1b1bae)
    ##  ggplot2        * 2.2.1   2016-12-30 CRAN (R 3.3.2)                    
    ##  ggrepel          0.6.5   2016-11-24 CRAN (R 3.3.2)                    
    ##  gridExtra        2.2.1   2016-02-29 cran (@2.2.1)                     
    ##  gtable           0.2.0   2016-02-26 CRAN (R 3.3.0)                    
    ##  haven            1.0.0   2016-09-23 cran (@1.0.0)                     
    ##  highr            0.6     2016-05-09 CRAN (R 3.3.0)                    
    ##  hms              0.3     2016-11-22 CRAN (R 3.3.2)                    
    ##  htmltools        0.3.5   2016-03-21 CRAN (R 3.3.0)                    
    ##  htmlwidgets      0.8     2016-11-09 CRAN (R 3.3.1)                    
    ##  httr             1.2.1   2016-07-03 CRAN (R 3.3.0)                    
    ##  igraph         * 1.0.1   2015-06-26 CRAN (R 3.3.0)                    
    ##  jsonlite       * 1.3     2017-02-28 CRAN (R 3.3.2)                    
    ##  knitr          * 1.15.1  2016-11-22 cran (@1.15.1)                    
    ##  labeling         0.3     2014-08-23 CRAN (R 3.3.0)                    
    ##  lattice          0.20-34 2016-09-06 CRAN (R 3.3.3)                    
    ##  lazyeval         0.2.0   2016-06-12 CRAN (R 3.3.0)                    
    ##  lubridate      * 1.6.0   2016-09-13 CRAN (R 3.3.0)                    
    ##  magrittr         1.5     2014-11-22 CRAN (R 3.3.0)                    
    ##  MASS             7.3-45  2016-04-21 CRAN (R 3.3.3)                    
    ##  Matrix           1.2-8   2017-01-20 CRAN (R 3.3.3)                    
    ##  memoise          1.0.0   2016-01-29 CRAN (R 3.3.0)                    
    ##  mgcv             1.8-17  2017-02-08 CRAN (R 3.3.3)                    
    ##  mnormt           1.5-5   2016-10-15 CRAN (R 3.3.0)                    
    ##  modelr           0.1.0   2016-08-31 CRAN (R 3.3.0)                    
    ##  munsell          0.4.3   2016-02-13 CRAN (R 3.3.0)                    
    ##  network        * 1.13.0  2015-09-19 cran (@1.13.0)                    
    ##  nlme             3.1-131 2017-02-06 CRAN (R 3.3.3)                    
    ##  plotly         * 4.5.6   2016-11-12 CRAN (R 3.3.2)                    
    ##  plyr             1.8.4   2016-06-08 CRAN (R 3.3.0)                    
    ##  psych            1.6.12  2017-01-08 CRAN (R 3.3.2)                    
    ##  purrr          * 0.2.2   2016-06-18 CRAN (R 3.3.0)                    
    ##  R6               2.2.0   2016-10-05 CRAN (R 3.3.0)                    
    ##  rcfss            0.1.4   2017-02-28 local                             
    ##  RColorBrewer     1.1-2   2014-12-07 CRAN (R 3.3.0)                    
    ##  Rcpp             0.12.10 2017-03-19 cran (@0.12.10)                   
    ##  readr          * 1.1.0   2017-03-22 cran (@1.1.0)                     
    ##  readxl         * 0.1.1   2016-03-28 CRAN (R 3.3.0)                    
    ##  reshape          0.8.6   2016-10-21 CRAN (R 3.3.0)                    
    ##  reshape2         1.4.2   2016-10-22 CRAN (R 3.3.0)                    
    ##  rmarkdown        1.3     2016-12-21 CRAN (R 3.3.2)                    
    ##  rprojroot        1.2     2017-01-16 CRAN (R 3.3.2)                    
    ##  rsconnect        0.7     2016-12-21 CRAN (R 3.3.2)                    
    ##  rstudioapi       0.6     2016-06-27 CRAN (R 3.3.0)                    
    ##  rvest            0.3.2   2016-06-17 CRAN (R 3.3.0)                    
    ##  scales         * 0.4.1   2016-11-09 CRAN (R 3.3.1)                    
    ##  sna            * 2.4     2016-08-08 cran (@2.4)                       
    ##  statnet.common * 3.3.0   2015-10-24 cran (@3.3.0)                     
    ##  stringi          1.1.2   2016-10-01 CRAN (R 3.3.0)                    
    ##  stringr        * 1.2.0   2017-02-18 CRAN (R 3.3.2)                    
    ##  tibble         * 1.2     2016-08-26 cran (@1.2)                       
    ##  tidyr          * 0.6.1   2017-01-10 CRAN (R 3.3.2)                    
    ##  tidyverse      * 1.1.1   2017-01-27 CRAN (R 3.3.2)                    
    ##  viridisLite      0.1.3   2016-03-12 cran (@0.1.3)                     
    ##  withr            1.0.2   2016-06-20 CRAN (R 3.3.0)                    
    ##  xml2             1.1.1   2017-01-24 CRAN (R 3.3.2)                    
    ##  yaml             2.1.14  2016-11-12 cran (@2.1.14)

[1] Munzner Ch 2

[2] Example drawn from [*The Visual Display of Quantitative Information* by Edward Tufte](https://www.edwardtufte.com/tufte/books_vdqi)

[3] TA Ch 5

[4] But remember, [correlation is not causation!](https://xkcd.com/552/)

[5] Above examples from [Network Visualization Examples with the `ggplot2` Package](https://cran.r-project.org/web/packages/ggCompNet/vignettes/examples-from-paper.html).

[6] Source for data from chart above: [U.S. Commercial Flights, 1995-2008](http://mbostock.github.io/d3/talk/20111018/calendar.html).
