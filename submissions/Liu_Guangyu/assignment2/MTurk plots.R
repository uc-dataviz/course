#---
# April 22, 2017
# Draw graphs for MTurk experiment -- count points
#---

library(tidyr)
library(tidyverse)
set.seed(428)
# Generate two random N-item data frames, with x and y are normal distributed continuous variables,
# z is a categorical variable with 4 categories, while each category has nearly equal number of items
N1 <- 46
N2 <- 50
rData_1 <- data.frame(x = abs(rnorm(N1)), y = abs(rnorm(N1)), z = c(1:N1) %% 4)
rData_2 <- data.frame(x = abs(rnorm(N2)), y = abs(rnorm(N2)), z = c(1:N2) %% 4)
rData_1$z <- factor(as.factor(rData_1$z), labels = c("A", "B", "C", "D"))
rData_2$z <- factor(as.factor(rData_2$z), labels = c("A", "B", "C", "D"))

rData_1 %>% 
  group_by(z) %>% 
  count()
rData_2 %>% 
  group_by(z) %>% 
  count()

# Differentiate by color (saturation)
color_1 <- ggplot(rData_1) +
  geom_point(aes(x = x, y = y, color = z), size = 4) +
  labs(x = "", y = "", title = "", color = "") +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL)
png(filename = "submissions/Liu_Guangyu/assignment2/graphs/color_1.png")
plot(color_1)
dev.off()

color_2 <- ggplot(rData_2) +
  geom_point(aes(x = x, y = y, color = z), size = 4) +
  labs(x = "", y = "", title = "", color = "") +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL)
png(filename = "submissions/Liu_Guangyu/assignment2/graphs/color_2.png")
plot(color_2)
dev.off()

# Differentiation by shape
rData_1$x <- abs(rnorm(N1))
rData_1$y <- abs(rnorm(N1))
rData_2$x <- abs(rnorm(N2))
rData_2$y <- abs(rnorm(N2))

shape_1 <- ggplot(rData_1) +
  geom_point(aes(x = x, y = y, shape = z), size = 4) +
  labs(x = "", y = "", title  = "" ,shape = "") +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL)
png(filename = "submissions/Liu_Guangyu/assignment2/graphs/shape_1.png")
plot(shape_1)
dev.off()

shape_2 <- ggplot(rData_2) +
  geom_point(aes(x = x, y = y, shape = z), size = 4) +
  labs(x = "", y = "", title  = "", shape = "") +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL)
png(filename = "submissions/Liu_Guangyu/assignment2/graphs/shape_2.png")
plot(shape_2)
dev.off()

# Differentiation by size
rData_1$x <- abs(rnorm(N1))
rData_1$y <- abs(rnorm(N1))
rData_2$x <- abs(rnorm(N2))
rData_2$y <- abs(rnorm(N2))

size_1 <- ggplot(rData_1) +
  geom_point(aes(x = x, y = y, size = z)) +
  labs(x = "", y = "", title = "", size = "") +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL) +
  coord_flip()
png(filename = "submissions/Liu_Guangyu/assignment2/graphs/size_1.png")
plot(size_1)
dev.off()

size_2 <- ggplot(rData_2) +
  geom_point(aes(x = x, y = y, size = z)) +
  labs(x = "", y = "", title = "", size = "") +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL) +
  coord_flip()
png(filename = "submissions/Liu_Guangyu/assignment2/graphs/size_2.png")
plot(size_2)
dev.off()

# Differentiate by shade
rData_1$x <- abs(rnorm(N1))
rData_1$y <- abs(rnorm(N1))
rData_2$x <- abs(rnorm(N2))
rData_2$y <- abs(rnorm(N2))

shade_1 <- ggplot(rData_1) +
  geom_point(aes(x = x, y = y, color = z), size = 4) +
  labs(x = "", y = "", title = "", color = "") +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL) +
  scale_color_brewer(palette = "Blues")
png(filename = "submissions/Liu_Guangyu/assignment2/graphs/shade_1.png")
plot(shade_1)
dev.off()

shade_2 <- ggplot(rData_2) +
  geom_point(aes(x = x, y = y, color = z), size = 4) +
  labs(x = "", y = "", title = "", color = "") +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL) +
  scale_color_brewer(palette = "Blues")
png(filename = "submissions/Liu_Guangyu/assignment2/graphs/shade_2.png")
plot(shade_2)
dev.off()

# Double the sample size and differentiate by color
N1 <- 92
N2 <- 100

rData_1 <- data.frame(x = abs(rnorm(N1)), y = abs(rnorm(N1)), z = c(1:N1) %% 8)
rData_2 <- data.frame(x = abs(rnorm(N2)), y = abs(rnorm(N2)), z = c(1:N2) %% 8)
rData_1$z <- factor(as.factor(rData_1$z), labels = c("A", "B", "C", "D", "E", "F", "G", "H"))
rData_2$z <- factor(as.factor(rData_2$z), labels = c("A", "B", "C", "D", "E", "F", "G", "H"))

double_1 <- ggplot(rData_1) +
  geom_point(aes(x = x, y = y, color = z), size = 4) +
  labs(x = "", y = "", title = "How many points are 'B'?", color = "") +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL)
png(filename = "submissions/Liu_Guangyu/assignment2/graphs/double_1.png")
plot(double_1)
dev.off()

double_2 <- ggplot(rData_2) +
  geom_point(aes(x = x, y = y, color = z), size = 4) +
  labs(x = "", y = "", title = "How many points are 'B'?", color = "") +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL)
png(filename = "submissions/Liu_Guangyu/assignment2/graphs/double_2.png")
plot(double_2)
dev.off()

# Emphasize F and grey others
rData_1$x <- abs(rnorm(N1))
rData_1$y <- abs(rnorm(N1))
rData_2$x <- abs(rnorm(N2))
rData_2$y <- abs(rnorm(N2))

emphasize_1 <- ggplot() +
  geom_point(data = rData_1, mapping = aes(x = x, y = y, color = z), size = 4) +
  labs(x = "", y = "", title = "How many points are 'F'?", color = "") +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL) +
  scale_color_manual(values = c("A" = "grey", "B" = "grey", "C" = "grey", "D" = "grey", "E" = "grey", 
                                "F" = "red", "G" = "grey", "H" = "grey"))
png(filename = "submissions/Liu_Guangyu/assignment2/graphs/emphasize_1.png")
plot(emphasize_1)
dev.off()

emphasize_2 <- ggplot() +
  geom_point(data = rData_2, mapping = aes(x = x, y = y, color = z), size = 4) +
  labs(x = "", y = "", title = "How many points are 'F'?", color = "") +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL) +
  scale_color_manual(values = c("A" = "grey", "B" = "grey", "C" = "grey", "D" = "grey", "E" = "grey", 
                                "F" = "red", "G" = "grey", "H" = "grey"))
png(filename = "submissions/Liu_Guangyu/assignment2/graphs/emphasize_2.png")
plot(emphasize_2)
dev.off()

