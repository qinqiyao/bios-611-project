library(tidyverse)
library(MASS)
library(caret)
library(dplyr)
library(ranger)
library(lime)
library(ROSE)
#setwd("/Users/qinqiyao/Desktop/611/HR/midterm")
dat <- read.csv("train.csv")
dat <- data.frame(dat,number=1:nrow(dat))
dat <- na.omit(dat)
dat <- dat[dat$education%in%c("Bachelor's","Below Secondary","Master's & above"),]
dat$education <- as.factor(dat$education)
dat$department <- as.factor(dat$department)
dat$gender <- as.factor(dat$gender)
dat$recruitment_channel <- as.factor(dat$recruitment_channel)
dat$awards_won.[dat$awards_won.==0] <- "No"
dat$awards_won.[dat$awards_won.==1] <- "Yes"
dat$awards_won. <- as.factor(dat$awards_won.)
dat$is_promoted[dat$is_promoted==0] <- "Non-Promotion"
dat$is_promoted[dat$is_promoted==1] <- "Promotion"
dat$is_promoted <- factor(dat$is_promoted,levels=c("Promotion","Non-Promotion"))
summary(dat)
set.seed(0)
train_index = caret::createDataPartition(dat$employee_id, times = 1, p = 0.7, list = FALSE)
dat_train0 = dat[dat$employee_id%in%train_index[,1],]
dat_train0 <- dat_train0[,c(-1,-3,-14)]
write.csv(dat_train,"train_dat.csv")
# Oversampling
dat_train <- ovun.sample(is_promoted~.,data=dat_train0,method="both",p=0.5,N=19352*2,seed=0)$data
#table(dat_train$is_promoted)
dat_test = dat[-train_index[,1],]
dat_test <- dat_test[,c(-1,-3,-14)]
formu = as.factor(is_promoted) ~ .
rm(dat)
fit_rf = ranger(formu, data = dat_train, num.trees = 500, mtry = NULL)
plot(importance(fit_rf))

explanation <- lime(dat_train,fit_rf)
png(filename = "figures/lime.png")
e <- lime::explain(dat_test[1,],explanation,n_labels = 1,n_features=5)
plot_features(e)
dev.off()

pred_rf = predict(fit_rf, dat_test)
library("pROC")
png(filename = "figures/roc.png")
a <- vector()
a[pred_rf$predictions=="Non-Promotion"] <- 0
a[pred_rf$predictions=="Promotion"] <- 1
b <- vector()
b[dat_test$is_promoted=="Non-Promotion"] <- 0
b[dat_test$is_promoted=="Promotion"] <- 1
roc(a, b, plot=TRUE, print.thres=TRUE, print.auc=TRUE)
dev.off()
confusionMatrix(factor(pred_rf$predictions,levels=c("Promotion","Non-Promotion")),as.factor(dat_test$is_promoted))
#confusionMatrix(pred_rf$predictions,as.factor(dat_test$is_promoted))

saveRDS(fit_rf, file = "model/randomforest.rds")
