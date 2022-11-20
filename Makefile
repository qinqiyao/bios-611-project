.PHONY: clean
SHELL: /bin/bash

clean:
	rm -f figures/*
	rm -f data_train/*
	rm -f model/*
	rm -f Report.pdf


visualization figures/promotion_sex.png figures/promotion_department.png figures/promotion_education.png figures/promotion_recruitment_channel.png figures/promotion_awards.png figures/promotion_age.png figures/promotion_avg_training_score.png figures/promotion_previous_year_rating.png figures/promotion_no_of_trainings.png: plot.R data_original/train.csv
	Rscript plot.R

data_train/train_dat.csv figures/roc.png figures/lime.png model/randomforest.rds: model.R data_original/train.csv
	Rscript model.R

Report.pdf: Report.Rmd model/randomforest.rds data_train/train_dat.csv data_original/train.csv
	Rscript -e 'rmarkdown::render("Report.Rmd")'

shiny: app.R model/randomforest.rds data_train/train_dat.csv
	Rscript app.R
