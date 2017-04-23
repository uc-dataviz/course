#---
# April 28, 2017
# Draw graphs for MTurk experiment -- general trend
#---
library(tidyr)
library(tidyverse)
library(graphics)
set.seed(428)

# Generate a random N-item data frame, with x and y are normal distributed continuous variables,
# class is a categorical variable with 4 categories, while each category has nearly equal number of items
N <- 50
rData <- data.frame(x = rnorm(N), y = rnorm(N), class = c(1:N) %% 4)
rData$class <- factor(as.factor(rData$class), labels = c("A", "B", "C", "D"))

# General trend by color
# Positive association
rData$x <- rnorm(N)
rData$y <- rnorm(N)
rData$y <- ifelse(rData$class == "A", 0.6*rData$x + 0.3*rData$y, rData$y)
ggplot(rData) +
  geom_point(aes(x = x, y = y, color = class), size = 4) +
  labs(x = "x", y = "y", title = "For class A, how will y change when x increases?") +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL)
png(filename = "submissions/Liu_Guangyu/assignment2/graphs/color_slope_1.png")
plot(color_slope_1)
dev.off()

# Negative association
rData$x <- rnorm(N)
rData$y <- rnorm(N)
rData$y <- ifelse(rData$class == "B", -0.6*rData$x + 0.3*rData$y, rData$y)
color_slope_2 <- ggplot(rData) +
  geom_point(aes(x = x, y = y, color = class), size = 4) +
  labs(x = "x", y = "y", title = "For class B, how will y change when x increases?") +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL)
png(filename = "submissions/Liu_Guangyu/assignment2/graphs/color_slope_2.png")
plot(color_slope_2)
dev.off()

# None association
rData$x <- rnorm(N)
rData$y <- rnorm(N)
rData$y <- ifelse(rData$class == "C", 0.3*rData$y, rData$y)
color_slope_3 <- ggplot(rData) +
  geom_point(aes(x = x, y = y, color = class), size = 4) +
  labs(x = "x", y = "y", title = "For class C, how will y change when x increases?") +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL)
png(filename = "submissions/Liu_Guangyu/assignment2/graphs/color_slope_3.png")
plot(color_slope_3)
dev.off()

# General trend by shape
# Positive association
rData$x <- rnorm(N)
rData$y <- rnorm(N)
rData$y <- ifelse(rData$class == "D", 0.6*rData$x + 0.3*rData$y, rData$y)

shape_slope_1 <- ggplot(rData) +
  geom_point(aes(x = x, y = y, shape = class), size = 4) +
  labs(x = "x", y = "y", title = "For class D, how will y change when x increases?") +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL)
png(filename = "submissions/Liu_Guangyu/assignment2/graphs/shape_slope_1.png")
plot(shape_slope_1)
dev.off()

# Negative Association
rData$x <- rnorm(N)
rData$y <- rnorm(N)
rData$y <- ifelse(rData$class == "A", -0.6*rData$x + 0.3*rData$y, rData$y)
shape_slope_2 <- ggplot(rData) +
  geom_point(aes(x = x, y = y, shape = class), size = 4) +
  labs(x = "x", y = "y", title = "For class A, how will y change when x increases?") +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL)
png(filename = "submissions/Liu_Guangyu/assignment2/graphs/shape_slope_2.png")
plot(shape_slope_2)
dev.off()

# None association
rData$x <- rnorm(N)
rData$y <- rnorm(N)
rData$y <- ifelse(rData$class == "B", 0.3*rData$y, rData$y)
shape_slope_3 <- ggplot(rData) +
  geom_point(aes(x = x, y = y, shape = class), size = 4) +
  labs(x = "x", y = "y", title = "For class B, how will y change when x increases?") +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL)
png(filename = "submissions/Liu_Guangyu/assignment2/graphs/shape_slope_3.png")
plot(shape_slope_3)
dev.off()

# General trend by size
# Positive association
rData$x <- rnorm(N)
rData$y <- rnorm(N)
rData$y <- ifelse(rData$class == "C", 0.6*rData$x + 0.3*rData$y, rData_1$y)

size_slope_1 <- ggplot(rData) +
  geom_point(aes(x = x, y = y, size = class)) +
  labs(x = "x", y = "y", title = "For class C, how will y change when x increases?") +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL)
png(filename = "submissions/Liu_Guangyu/assignment2/graphs/size_slope_1.png")
plot(size_slope_1)
dev.off()

# Negative association
rData$x <- rnorm(N)
rData$y <- rnorm(N)
rData$y <- ifelse(rData$class == "D", -0.6*rData$x + 0.3*rData$y, rData$y)
size_slope_2 <- ggplot(rData) +
  geom_point(aes(x = x, y = y, size = class)) +
  labs(x = "x", y = "y", title = "For class D, how will y change when x increases?") +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL)
png(filename = "submissions/Liu_Guangyu/assignment2/graphs/size_slope_2.png")
plot(size_slope_2)
dev.off()

# None association
rData$x <- rnorm(N)
rData$y <- rnorm(N)
rData$y <- ifelse(rData$class == "A", 0.3*rData$y, rData$y)
size_slope_3 <- ggplot(rData) +
  geom_point(aes(x = x, y = y, size = class)) +
  labs(x = "x", y = "y", title = "For class A, how will y change when x increases?") +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL)
png(filename = "submissions/Liu_Guangyu/assignment2/graphs/size_slope_3.png")
plot(size_slope_3)
dev.off()

# General trend by shade
# Positive association
rData$x <- rnorm(N)
rData$y <- rnorm(N)
rData$y <- ifelse(rData$class == "B", 0.6*rData$x + 0.3*rData$y, rData$y)

shade_slope_1 <- ggplot(rData) +
  geom_point(aes(x = x, y = y, color = class), size = 4) +
  labs(x = "", y = "", title = "For class B, how will y change when x increases?") +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL) +
  scale_color_brewer(palette = "Blues")
png(filename = "submissions/Liu_Guangyu/assignment2/graphs/shade_slope_1.png")
plot(shade_slope_1)
dev.off()

# Negative association
rData$x <- rnorm(N)
rData$y <- rnorm(N)
rData$y <- ifelse(rData$class == "C", -0.6*rData$x + 0.3*rData$y, rData$y)
shade_slope_2 <- ggplot(rData) +
  geom_point(aes(x = x, y = y, color = class), size = 4) +
  labs(x = "", y = "", title = "For class C, how will y change when x increases?") +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL) +
  scale_color_brewer(palette = "Blues")
png(filename = "submissions/Liu_Guangyu/assignment2/graphs/shade_slope_2.png")
plot(shade_slope_2)
dev.off()

# None association
rData$x <- rnorm(N)
rData$y <- rnorm(N)
rData$y <- ifelse(rData$class == "D", 0.3*rData$y, rData$y)
shade_slope_3 <- ggplot(rData) +
  geom_point(aes(x = x, y = y, color = class), size = 4) +
  labs(x = "", y = "", title = "For class D, how will y change when x increases?") +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL) +
  scale_color_brewer(palette = "Blues")
png(filename = "submissions/Liu_Guangyu/assignment2/graphs/shade_slope_3.png")
plot(shade_slope_3)
dev.off()
