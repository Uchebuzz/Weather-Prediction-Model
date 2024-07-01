# Weather Prediction Model

This is my masters Project predicting the weather using machine learning models. In this project, several models were evaluated to determine the accuracy of the model and each model were tested using 10 days of data from June 1st 2024 - June 10th 2024

## Models Evaluated
1. Decision Tree
2. Random Forest'
3. Rigid Regression
4. Linear Regression
5. ARIMA

## Repository structure
`Merging`: This contains the merging of the 24 datasets 

`Evalation` : This contains my entire process, from pre-processing to model evaluation

`Deploy`: This contains the R scripts used in deploying my artifact



## Instructions
To reproduce the results of this project, follow these steps:

Clone the repository:

git clone https://github.com/Uchebuzz/Weather-Prediction-Model
Install the required libraries:

For Python libraries, run:
pip install -r requirements.txt
For R libraries, run:
source("install_packages.R")
Run the web scraping scripts:
Ensure you have R installed on your machine, and run the following scripts in order:

Rscript myscraping.R
Rscript secondscrape.R
Rscript pmatchlogs.R
