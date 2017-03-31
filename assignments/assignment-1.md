
Assignment 1
============

Part 1: Visualization critique (5 points)
-----------------------------------------

Select a data visualization and write a (roughly) 1000 word critique of the visualization based on the five qualities of great visualizations:[1]

-   Is it truthful?
-   Is it functional?
-   Is it beautiful?
-   Is it insightful?
-   Is it enlightening?

Remember that to critique something does not mean to tear it down or find all the flaws. Critiques should include both positive and negative aspects - what did the author do well? What are the weaknesses of the visualization? How could the truthfulness of the visualization be improved?

#### Finding a visualization

Some good resources for finding visualizations to critique:

-   Academic journals/books in your field which include graphs or charts (you don't have to find some super-duper high tech interactive graph on the web)
-   [r/dataisbeautiful](https://www.reddit.com/r/dataisbeautiful/)
-   Nathan Yau's [Flowing Data blog](http://flowingdata.com/)
-   [FiveThirtyEight](https://fivethirtyeight.com/) or [The Upshot](https://www.nytimes.com/section/upshot) - or really any other data journalism site

#### Submission details

Be sure to include a link to the original visualization in your critique. Submit your critique as a [Markdown](http://daringfireball.net/projects/markdown/basics) formatted document that can be read directly in the repo on GitHub. Write either in the original `.md` file or write it as an [R Markdown](http://rmarkdown.rstudio.com/) document rendered using the `github_output` format.

Part 2: `ggplot2` and the grammar of graphics (10 points)
---------------------------------------------------------

![Former Vice-President Joseph Biden](https://s3.amazonaws.com/media.thecrimson.com/photos/2014/10/02/103651_1299339.jpg)

`biden.csv` contains a selection of variables from the [2008 American National Election Studies survey](http://www.electionstudies.org/) that allow you to test competing factors that may influence attitudes towards Joe Biden. The variables are coded as follows:

-   `biden` - feeling thermometer ranging from 0-100[2]
-   `female` - 1 if respondent is female, 0 if respondent is male
-   `age` - age of respondent in years
-   `dem` - 1 if respondent is a Democrat, 0 otherwise
-   `rep` - 1 if respondent is a Republican, 0 otherwise
-   `educ` - number of years of formal education completed by respondent
    -   `17` - 17+ years (aka first year of graduate school and up)

Your assignment is to design a static visualization (i.e. a single image) that effectively communicates the data and provide a written explanation (approximately 750-1000 words) describing your design. You should use the given data as provided, but you can transform it as you see fit or incorporate external data into the visualization. The visualization should be interpretable without reference to your written explanation, so be sure to include all the necessary components (e.g. title, axis labels, legends).

Your visualization will be evaluated using the same criteria as for part 1:

-   Is it truthful?
-   Is it functional?
-   Is it beautiful?
-   Is it insightful?
-   Is it enlightening?

In your written explanation, be sure to rigorously defend your design choices. This includes (but is not limited to):

-   What is the story?
-   Why did you select this graphical form?
-   Why did you use these specific channels to encode the data (e.g. spatial position, size, color, scale)?
-   Why did you make any other data transformations?
-   How do these decisions facilitate effective communication?

> This assignment is deceptively difficult. Not only do you need to correctly implement the grammar of graphics using `ggplot2`, but you also need to think critically about your design choices. You will go through several (if not many) drafts of your visualization. **Use Git to track changes to your graphic.**

#### Submission details

Submit your graph and written explanation as a single R Markdown document rendered using the `github_document` output format.

[1] Drawn from chapter 2 of *The Truthful Art: Data, charts, and maps for communication* by Alberto Cairo.

[2] Feeling thermometers are a common metric in survey research used to gauge attitudes or feelings of warmth towards individuals and institutions. They range from 0-100, with 0 indicating extreme coldness and 100 indicating extreme warmth.
