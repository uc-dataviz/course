data = mpg

?mpg

bar1 <- ggplot(mpg, aes(class)) +
  geom_bar(fill = "skyblue") +
  labs(title = "Most Common Types of Cars", x = "Type of Car", 
       y = "Percent of Americans Who Own Each Vehicle")
bar1

bar2 <- ggplot(mpg, aes(class, fill = class)) +
  geom_bar() + 
  labs(title = "Most Common Types of Cars", x = "Type of Car", 
       y = "Percent of Americans Who Own Each Vehicle") + 
  theme(legend.position = "none") + 
  scale_fill_brewer(palette = "Blues")
bar2
