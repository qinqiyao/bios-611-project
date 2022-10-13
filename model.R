library(tidyverse)
library(MASS)
library(caret)
library(dplyr)
library(ranger)

dat <- read.csv("train.csv")
dat <- data.frame(dat,number=1:nrow(dat))
dat <- na.omit(dat)
dat <- dat[dat$education%in%c("Bachelor's","Below Secondary","Master's & above"),]
dat$education <- as.factor(dat$education)
dat$department <- as.factor(dat$department)
dat$gender <- as.factor(dat$gender)
dat$recruitment_channel <- as.factor(dat$recruitment_channel)
summary(dat)
set.seed(0)
train_index = caret::createDataPartition(dat$employee_id, times = 1, p = 0.7, list = FALSE)
dat_train = dat[dat$employee_id%in%train_index[,1],]
dat_train <- dat_train[,c(-1,-3)]
dat_test = dat[-train_index[,1],]
dat_test <- dat_test[,c(-1,-3)]
formu = as.factor(is_promoted) ~ .
rm(dat)
fit_rf = ranger(formu, data = dat_train, num.trees = 500, mtry = NULL)

pred_rf = predict(fit_rf, dat_test)
library("pROC")
png(filename = "figures/roc.png")
roc(pred_rf$predictions, dat_test$is_promoted, plot=TRUE, print.thres=TRUE, print.auc=TRUE)
dev.off()
#confusionMatrix(pred_rf$predictions,as.factor(dat_test$is_promoted))
confusionMatrix(pred_rf$predictions,as.factor(dat_test$is_promoted))

saveRDS(fit_rf, file = "model/randomforest.rds")
