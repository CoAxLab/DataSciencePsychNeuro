##Basic R data structures
a <- c(1,2,3)
b <- c(4,5,6)
a * b

c <- c("one", "two", "three")
data <- data.frame(cbind(a,c))

###set wd and read data
setwd('/Users/charleswu/Google Drive/CMUacademics/DataScienceforPsychology/TA/RecitationPreps/Rec2')
library('tidyverse')
d <- read.csv('YoutubeVideos.csv')

####show basic data info, see any abnormalities? 
summary(d)
head(d, 5)

####get rid of missing values and extreme values
d %>%
  na.omit() %>%
  subset(dislikes > 0) -> d

###Use this new data set without the last 4 columns
d1 <- d[, -16:-12]
####Exercise 1
####short to long
d1 %>%
  gather(metrics, values , views:comment_count) -> d2
###long to short
d2 %>%
  spread(metrics, values) ->d3

###Add new metric
d %>%
  mutate(z = (likes - mean(likes))/sd(likes)) ->d_centered
###summarise the mean
d %>% 
  mutate(z = (likes - mean(likes))/sd(likes)) %>%
  summarise(mean = mean(z))
####filter and select data
d %>%
  filter(channel_title == 'Saturday Night Live') %>%
  select(likes) %>%
  summary()
###Exercise 2
d %>%
  mutate(difference = (likes - dislikes)) %>%
  filter(channel_title == 'Ed Sheeran') %>%
  select(difference) %>%
  summarise(mean = mean(difference),
            sd = sd(difference)) -> diff

####Group by and summarise
d %>%
  group_by(channel_title, title) %>%
  summarise(mean_likes = mean(likes),
            mean_dislikes = mean(dislikes), 
            avg_comments = mean(comment_count)) -> sum

####sort the matrix
sum %>%
  arrange(channel_title, mean_likes) -> ordered

#####compare and contrast these z_all and z_group, What's the differences? 
d %>% 
  mutate(z_all = (comment_count - mean(comment_count))/sd(comment_count)) %>%
  group_by(channel_title) %>%
  mutate(z_group = (comment_count - mean(comment_count))/sd(comment_count)) -> exercise2

####Fit linear regression models and extract coefficients
model.fit <- lm(views ~ comment_count, data = d)
str(model.fit)
summary(model.fit)
model.fit$coefficients

####fit the model for each subgroup by building customized functions using map
d%>%
  group_by(channel_title) %>%
  nest(-channel_title) %>%
  mutate(model_fit = map(data, function(data){lm(views~comment_count, data = data)}),
         coef = map(model_fit, function(fit){data.frame(names = names(fit$coefficients), 
                                                        beta = fit$coefficients)})) %>%
  unnest(coef)

select(d, likes)
