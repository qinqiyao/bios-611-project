.PHONY: clean
SHELL: /bin/bash

clean:
	rm -f figures/*
	rm -f data_split/*
	rm -f model/*
	rm -f report.pdf


figures/promotion_sex.png figures/promotion_department.png figures/promotion_education.png figures/promotion_recruitment_channel.png figures/promotion_awards.png figures/promotion_age.png figures/promotion_avg_training_score.png figures/promotion_previous_year_rating.png figures/promotion_no_of_trainings.png: plot.R data_original/train.csv
	Rscript plot.R

train_dat.csv figures/roc.png figures/lime.png model/randomforest.rds: model.R data_original/train.csv
	Rscript model.R

report.pdf: Report.Rmd figures/promotion_sex.png
	Rscript -e "rmarkdown::render('Report.Rmd')"

shiny: app.R model/randomforest.rds data_split/train_dat.csv
	Rscript -e 'library(methods); shiny::runApp("app.R", launch.browser = TRUE)'
