Assignment 2 -- Effects of color channel on short-term recall (Donald Lyons & Nicole Sullivan)
=====

Introduction
===

Our intent with the present study is to analyze the ways in which coding categorical data through the “color” channel may impact interpretation and recall of graphical data. The present study follows from the findings of Bateman, Mandryk, Gutwin, Genest, McDine, & Brooks (2010) wherein it was observed that additional visual imagery on charts, as opposed to the sparse nature of most charts, improves long-term recall of content. We presume that the addition of validity allows the mind to better streamline memory of design and content together, and thus want to test if increasing relevance to the meaning of the data while holding the design stable otherwise (unlike the design in the Bateman paper, in which the different designs were radically different) would meaningfully impact retrieval of content. Thus, we ask this: does a making a visualization more directly relatable render it more retrievable, and if so does making a visualization more directly relatable by misleading render it less retrievable than if it does not resemble reality at all?

Methods
===

Following the cue of Heer & Bostock (2010), we are using MTurk to collect responses of 60 people. In our survey (see attached in the /materials folder), we asked people to first answer a question regarding their favorite color of bell pepper (between red, green, yellow, and orange). The data from this question was not involved in analysis. Then, participants were told that they could see the results of the survey, but were actually shown a graph reflecting their random assignment. Regardless of random assignment, in the graph Green, Orange, Red, and Yellow were presented in that order, with Red being the highest, Orange the second highest, Yellow the second lowest, and Green the lowest. Participants in group 1 were shown a graph with non-relevant colors (see materials/control), participants in group 2 were shown a graph where the colors of the bars corresponded to the pepper colors they represented (see materials/correct), and participants in group 3 were shown a graph where the colors of the bars corresponded to the pepper colors but were assigned to the wrong pepper color (see materials/stroop). Then, all participants were asked to recall (1) the pepper color most favored, (2) the pepper color least favored, and (3) the pepper color second least favored. These were then coded as hit/miss, with 0 representing an incorrect answer and 1 a correct answer. We then ran 3 separate chi-square tests with assignment group as IV and accuracy (incorrect or correct) for each question as three unique DVs to see how low relevance, high relevance, and high relevance with high confusion map onto basic recall.

####Graph shown in condition 1:

![alt text](https://github.com/dalyons3/dataviz/blob/master/submissions/lyons_donald/assignment2/materials/control.jpg)


###Results

As the difference between the highest bar and any other bar was greater than the difference between any other bars (see figures used in experiment in ~/materials folder), it was surmised that the highest bar would be most salient, while the second lowest bar would be the least salient of the three bars that participants were asked to recall.  Differences in accuracy on recalling the second lowest bar were of particular interest to the authors, though intention was to explore differences inaccuracy in recalling all three bars.  For this reason, the authors chose not to pool the accuracy for the three questions into a single value, and instead perform three unique Pearson’s chi-squares, one with the accuracy in recalling the highest bar as the DV, one with accuracy in recalling the lowest bar as the DV, and one with accuracy in recalling the second lowest bar as the DV.  Accuracy was coded as a factor with levels 0 (incorrect) or 1 (correct).  Results in all three tests were highly non-significant for all three conditions (see Figs. 1-3).  Therefore, preliminary results suggest that color does neither detracts nor enhances short-term recall of results displayed in a graph.  
Moreover, an exploratory chi-square using question as predictor, regardless of condition, found that there were significant differences in accuracy across questions (Figs. 4-5);  χ2 = 15.7, p < 0.0005.  Though coefficients in a logistic regression could not be properly interpreted, the sign for each question was of interest to the authors; therefore, a binomial logistic regression was performed, similarly using question as the predictor and accuracy as the DV.  The regression revealed that probability of correctly answering the question decreased significantly when question concerned either the second highest or second lowest bar (compared to the highest bar; β = -2.206, p < 0.05 and β = -3.066, p < 0.005 for the second highest and second lowest bar, respectively; see Fig. 5).  Therefore, the highest bar in the bar graphs used was significantly more salient than the others (resulting in significantly greater probability of answering this question correctly

###Discussion

While sample size was moderately large (n = 60, 20 per group), it should be noted that demographics of participants involved in the study were not collected; therefore, current findings are discussed with the qualification that they may not be generalizable to the U.S. population at large, and that further replication is desirable.
Intriguingly, results found no significant differences in short-term recall of subjects, despite  intentionally-misassigned colors in the graph of the Counterintuitive condition.  Subjects were unaware that they would be asked to recall any facts about the graph, and were instead led to believe that it was the results of the survey question asked at the beginning of the study, indicating that even when attention is not primed, subjects can correctly recall general interpretations of bar graphs.  Therefore, it is posited that using the color channel merely for aesthetics, rather than to encode any additional information (such as in a legend) in bar graph, neither distracts the viewer nor enhances their interpretations.  Furthermore, in bar graphs where heights of the bars are quite distinct (as in the current study), the highest bar tends to be most salient, with 100% accuracy in recalling this bar, regardless of color (and triviality of subject matter; see Fig. 6).  Thus, it is recommended that, in conveying results via bar graph, it may be most beneficial (if possible) to transform results so that the category of interest is the highest bar (for instance, in this study, had the authors wished to point out the bar which renders lowest accuracy, utilize percentage of subjects with the incorrect response, rather than correct response).
Parsing apart the mechanics of these results (either the difference in heights of bars or the absolute height of bars could be responsible for the difference in accuracy) will require further studies investigating the phenomenon.  Moreover, studies drawing on larger sample sizes with documented variation in demographics, in addition to using a greater number of graphs delineated on finer points than those used in this study are needed to show that color does not, indeed, increase or decrease accuracy of interpretations (even when used in a counter-intuitive manner) in graphs where it is used merely aesthetically.
	
####Figure 1:  Pearson’s χ2 with accuracy recalling highest bar as DV



####Figure 2:  Pearson’s χ2 with accuracy recalling lowest bar as DV

####Figure 3:  Pearson’s χ2 with accuracy recalling second-lowest bar as DV

####Figure 4:  Pearson’s χ2 with question as predictor

####Figure 5:  Binomial logistic regression with question as predictor


####Figure 6
 
