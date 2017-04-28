Assignment 2
================
Dana Westley
Due April 28

Double-Encoding of Visual Information Appears to Reduce Accuracy & Interpretation
=================================================================================

Research Question
-----------------

I wondered if providing more information, i.e. using a second channel to encode information in a visualizaiton, would improve or hinder the processing of information. My original hypothesis was that using a second channel would help people to accurately process the information in the visual more easily and quickly. My thinking was that with two layers of information However, those in the Tufte school of thought may consider this to be superfluous, or unnecessary "noise" that wouldactually hinder people's processing of the information conveyed.

In order to test this idea, I created a simple bar graph since perceptually, we are extremely accurate at comparing height of lines from a common base line. I used the mpg dataset to create a count of each type of car in the dataset. However, the information was presented as "percent of Americans who own each type of car" for a realistic feel. One version of the graph had bars of all one color, making up the control condition. For the test condition, the bars in the graph varied on a color gradient, getting darker as their height got longer. For the control group, the information was only conveyed in one channel: bar height. For the test group, the information was encoded via two channels: bar height *and* color gradient.

![Control](https://github.com/DanaWestley/dataviz/blob/master/submissions/Westley_Dana/Assignment2/Assignment2_files/Onecolor.png?raw=true)

![Treatment](https://github.com/DanaWestley/dataviz/blob/master/submissions/Westley_Dana/Assignment2/Assignment2_files/Shaded.png?raw=true)

The Survey - Methodology
------------------------

Participants were recruited using Amazon Mechanical Turk which provided them a link to complete a Qualtrics survey. Participants were informed that this survey was for class purposes only and that it should take no more than 2-3 minutes. Age, Race, and Gender information was collected for each particpant. A total of 52 people responded to the survey. 5 individuals were eliminated from some statistical analyses for not answering, or answering in non-numeric fashion when asked to estimate the difference between two bar heights. The final sample comprised of 16 females and 31 males. The majority of the respondents were in the 25-34 age bracket.

The participants were randomly assigned to a condition using the randomization feature of the Qualtrics survey site. Each group was asked to answer the same three questions about their image. They had to identify the largest bar "most popular car", the smallest bar "car owned by smallest percentage of Americans" and the difference between two bar heights "the difference between percentage of Americans who own compacts and subcompacts". Responses for thefirst two questions were coded as either accurate or innaccurate. Respsonses to the third question were converted to an accuracy percentile compared to the whole sample.

The survey can be found here: (<http://ssd.az1.qualtrics.com/jfe/form/SV_9WXJPrZegpU2FmZ>)

Results & Discussion
--------------------

To compare accuracy between the control group and the testgroup, I ran a series of logitstic regressions and a t-test. Additionally, a correlation was performed to explore the relationship between time taken to complete the survey and bar height estimation accuracy. Of these tests, only two showed significant findings: the regression analysis for the task of identifying the shortest bar and the correlation between survey length and accuracy. A summary of the analyses can be found in the table below:

<table>
<colgroup>
<col width="33%" />
<col width="25%" />
<col width="41%" />
</colgroup>
<thead>
<tr class="header">
<th>Analysis</th>
<th>Test</th>
<th>Result</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><p>Q1 Accuracy by group</p></td>
<td><p>Logistic Regression</p></td>
<td><p>β = -0.2697, p = .714</p></td>
</tr>
<tr class="even">
<td><p>Q2 Accuracy by group</p></td>
<td><p>Logistic Regression</p></td>
<td><p>β = -2.1910, p = .0026 **</p></td>
</tr>
<tr class="odd">
<td><p>Q3 Accuracy by group</p></td>
<td><p>T-test</p></td>
<td><p>t = 1.1143, df = 38.917, p = .272</p></td>
</tr>
<tr class="even">
<td><p>Q3 Accuracy &amp; Duration</p></td>
<td><p>Correlation</p></td>
<td><p>R<sup>2</sup> = .317, p = 0.029 .</p></td>
</tr>
</tbody>
</table>

Other tests using race, age, and gender were conducted but did not yeild any significant findings.

### Question 1 Accuracy

For the first task of identifying the tallest bar, or "most popular car,"" was fairly easy for the majority of both groups. There was no effect of bar coloring on participants' ability to correctly identify the highest bar.

### Question 2 Accuracy

For the second task of identifying the shortest bar, or "car owned by smallest percentage" the regression showed that people in the color gradient group performed much worse than those in the control group, (β = -2.1910, p = .0026). The exponentiated coefficient (β = .1118) indicated that the treatment group was only 11% as likely to be accurate when compared to the control group.

![](Assignment2_files/figure-markdown_github/unnamed-chunk-1-1.png) It seems that the color gradient may have had an inhibiting effect when determining shortest bar height. It also may be that this question wording took a little more mental effort that the "most popular" question and we might be seeing an interaction between double encoding of information and question difficulty. Further analysis would need to be conducted to piece out why we are seeing this effect.

### Question 3 Accuracy

For the third task of estimating the difference in height between two bars, a two sample t-test indicated there was no significant difference between the groups. However, a density plot shows that there was much less variance in the control condition as opposed to the treatment condition. It's possible a larger sample may have been more powerful. Furthermore, the most common answer among the whole sample was "10" with the next frequent response being the real answer, "12". This could indicate a preference for rounding, and so the method of determining accuracy might be modified in further studies.

![](Assignment2_files/figure-markdown_github/unnamed-chunk-2-1.png)

### Survey Duration and Height Difference Accuracy

Finally, out of exploratory interest (and because Qualtrics automatically records survey duration), I conducted a correlation between the duration of survey and the accuracy score for difference in height estimation. There was a moderately significant result (r<sup>2</sup> = .32, p &lt; .05) indicating a positive relationship between the two. This is as to be expected since the more time and attention spent interpreting the visualization, we should expect to see an accuracy pay-off.

![](Assignment2_files/figure-markdown_github/unnamed-chunk-3-1.png)

Conclusion
----------

Overall, the main finding lied in the results when participants were asked to identify the shortest bar height. The double-encoding using both a color gradiant and bar length to convey information seemingly had a negative effect on people's accuracy. This would support Tufte's preference for minimalistic visualizations and the claim that any non-essential feature only detracts from the information being conveyed. However, there are alternative possible explanations. It could be that this question phrasing, requiring more thinking, interfered with the working memory currently being used to interpret the visual features of the graph. This would be consistent since a similar task of identifying the tallest bar, but asked more simply, did not find a signficant difference between the two groups. It would be interesting to see a replication conducted varying question difficulty for double-encoded information.
