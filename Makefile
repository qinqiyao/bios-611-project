.PHONY: clean
SHELL: /bin/bash

clean:
	rm -f figure/*

figures/promotion_sex.png figures/promotion_department.png figures/promotion_education.png figures/promotion_recruitment_channel.png figures/promotion_awards.png figures/promotion_age.png figures/promotion_avg_training_score.png figures/promotion_previous_year_rating.png figures/promotion_no_of_trainings.png: plot.R train.csv
	Rscript plot.R

figures/roc.png model/randomforest.rds: model.R train.csv
	Rscript model.R

eport.pdf: Report.Rmd figures/promotion_sex.png
	Rscript -e "rmarkdown::render('report.Rmd')"
