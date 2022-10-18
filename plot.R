library(tidyverse)
library(MASS)
library(dplyr)
library(ggplot2)
library(RColorBrewer)
library(viridis)
library(ggridges)

dat <- read.csv("data_original/train.csv")
dat <- data.frame(dat,number=1:nrow(dat))
dat <- na.omit(dat)
dat <- dat[dat$education%in%c("Bachelor's","Below Secondary","Master's & above"),]
dat$education <- as.factor(dat$education)
dat$department <- as.factor(dat$department)
dat$gender <- as.factor(dat$gender)
dat$recruitment_channel <- as.factor(dat$recruitment_channel)
summary(dat)
a2 <- data.frame(summarise(group_by(dat,is_promoted,gender),length(gender)))
x <- as.table(matrix(a2[,3],nrow = 2, byrow = TRUE))
dimnames(x) <- list(c("Promotion", "Non-Promotion"),c("Female","Male"))
names(dimnames(x)) <- c( "Promotion","Sex")
png(filename = "figures/promotion_sex.png")
fourfoldplot(x,color=brewer.pal(5,"Blues"))
dev.off()

dat$is_promoted[dat$is_promoted==1] <- "Promotion"
dat$is_promoted[dat$is_promoted==0] <- "Non-Promotion"
Promotion <- factor(dat$is_promoted)
#table(dat$is_promoted)
p1 <- ggplot(data=dat,aes(x=department,fill=Promotion))
p1 <- p1 + geom_bar(position='fill')+ coord_flip()+theme(panel.border = element_blank(),panel.grid.major = element_blank(), panel.grid.minor = element_blank(),axis.line = element_line(colour = "black"))+ theme_classic()+scale_fill_brewer(palette="Blues")+xlab("Department")+ylab("Frequency")
ggsave(p1,filename = "figures/promotion_department.png")

p1 <- ggplot(data=dat,aes(x=as.factor(education),fill=Promotion))
p1 <- p1 + geom_bar(position='fill')+ coord_flip()+theme(panel.border = element_blank(),panel.grid.major = element_blank(), panel.grid.minor = element_blank(),axis.line = element_line(colour = "black"))+ theme_classic()+scale_fill_brewer(palette="Blues")+xlab("Education")+ylab("Frequency")
ggsave(p1,filename = "figures/promotion_education.png")

p1 <- ggplot(data=dat,aes(x=recruitment_channel,fill=Promotion))
p1 <- p1 + geom_bar(position='fill')+ coord_flip()+theme(panel.border = element_blank(),panel.grid.major = element_blank(), panel.grid.minor = element_blank(),axis.line = element_line(colour = "black"))+ theme_classic()+scale_fill_brewer(palette="Blues")+xlab("Recruitment Channel")+ylab("Frequency")
ggsave(p1,filename = "figures/promotion_recruitment_channel.png")

png(filename = "figures/promotion_awards.png")
dat$awards_won. [dat$awards_won. ==1] <- "Yes"
dat$awards_won. [dat$awards_won. ==0] <- "No"
dat$awards_won. <- as.factor(dat$awards_won.)
mosaicplot(~is_promoted+awards_won.,data=dat,color=brewer.pal(5,"Blues"),main ='',xlab="Promotion",ylab="If won awards")
dev.off()

p1 <- ggplot(dat, aes(age, y = is_promoted, fill = ..x..)) +
  geom_density_ridges_gradient(scale = 1, rel_min_height = 0.01) +theme_ridges(font_size = 13, grid = TRUE) +theme(legend.position = 'right') +scale_y_discrete(name = 'Promotion', expand = c(0.01, 0)) +scale_x_continuous(name = 'Age', expand = c(0.01, 0)) +scale_fill_viridis(name = "", option = "G")
ggsave(p1,filename = "figures/promotion_age.png")

p1 <- ggplot(data=dat, varwidth=T,aes(x=Promotion,y=avg_training_score,group=Promotion)) + geom_boxplot(col='sky blue',fill='light blue',varwidth=T)+ theme_bw() + theme(panel.border = element_blank(),panel.grid.major = element_blank(), panel.grid.minor = element_blank(),axis.line = element_line(colour = "black"))+xlab("Promotion")+ylab("Average Training Score")
ggsave(p1,filename = "figures/promotion_avg_training_score.png")

p1 <- ggplot(data=dat,aes(x=previous_year_rating,fill=Promotion))
p1 <- p1 + geom_bar(position='fill')+ coord_flip()+theme(panel.border = element_blank(),panel.grid.major = element_blank(), panel.grid.minor = element_blank(),axis.line = element_line(colour = "black"))+ theme_classic()+scale_fill_brewer(palette="Blues")+xlab("Previous Year Rating")+ylab("Frequency")
ggsave(p1,filename = "figures/promotion_previous_year_rating.png")

p1 <- ggplot(data=dat,aes(x=no_of_trainings,fill=Promotion))
p1 <- p1 + geom_bar(position='fill')+ coord_flip()+theme(panel.border = element_blank(),panel.grid.major = element_blank(), panel.grid.minor = element_blank(),axis.line = element_line(colour = "black"))+ theme_classic()+scale_fill_brewer(palette="Blues")+xlab("Number of Trainings")+ylab("Frequency")
ggsave(p1,filename = "figures/promotion_no_of_trainings.png")

