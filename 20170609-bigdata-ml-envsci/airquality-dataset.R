data("airquality")
library(GGally)
ggpairs(airquality)
summary(airquality)

# ref: https://www.gpo.gov/fdsys/pkg/FR-2015-10-26/pdf/2015-26594.pdf
who2000_threshold = 60

sum(airquality$Ozone > who2000_threshold, na.rm = TRUE) / nrow(airquality)

aq_complete <- airquality[complete.cases(airquality),]
#aq_complete <- airquality[!is.na(airquality$Ozone),]
ggpairs(aq_complete)

library(caret)
library(rpart.plot)
contaminado <- aq_complete$Ozone > who2000_threshold
aq_complete$estado <- as.factor(ifelse(contaminado, "contaminado", "limpio"))
set.seed(12345)
train_index <- createDataPartition(aq_complete$estado, p = 0.75, list = FALSE)
data_train <- aq_complete[train_index, -c(1,7)]
data_test <- aq_complete[-train_index, -c(1,7)]
o3model <- train(data_train, aq_complete[train_index, 7], method = "rpart")
o3model
rpart.plot(o3model$finalModel, type = 0, extra = 102)
o3pred <- predict(o3model, data_test)
confusionMatrix(o3pred, aq_complete[-train_index, 7], positive = "limpio")
