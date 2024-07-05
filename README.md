 # Weather Prediction Model ☀️🌧️  ⛅❄️
This is my master's project on predicting the weather using machine learning models. In this project, several models were evaluated to determine their accuracy. Each model was tested using data from a 10-day period, specifically from June 1st to June 10th, 2024.


## Models Evaluated
1. [Decision Tree](https://scikit-learn.org/stable/modules/generated/sklearn.ensemble.RandomForestClassifier.html)
2. [Random Forest](https://scikit-learn.org/stable/modules/tree.html)
3. [Rigid Regression](https://scikit-learn.org/stable/modules/generated/sklearn.linear_model.Ridge.html)
4. [Linear Regression](https://scikit-learn.org/stable/modules/generated/sklearn.linear_model.LinearRegression.html)
5. [ARIMA](https://towardsdatascience.com/machine-learning-part-19-time-series-and-autoregressive-integrated-moving-average-model-arima-c1005347b0d7)

## Python Libraries

- `numpy`

- `pandas`

- `scikit-learn`

- `matplotlib`

- `seaborn`

- `matplotlib`

- `datetime`

- `statsmodels`



## Repository structure
`Merging`: This contains the merging of the 24 datasets 

`Evalation` : This contains my entire process, from pre-processing to model evaluation

`Deployed`: This contains the R scripts used in deploying the model



# Process Overview

### 1. Data Collection:
   
   The data was gotten from [Visual Crossing](https://www.visualcrossing.com/weather-history/Wolverhampton/us/2000-01-01). It was wolverhampton, Uk data from 01-01-2000 to 16-04-2024

### 2. Data Merging: 
   
   The data was merged `merging` shows a detailed working of my process to achieve this

### 3. Data Cleaning

   The data was carefully cleaned, and dealing with missing values. The coreect pre-processing methods were carefully carried out

### 4. EDA and Machine Learning Development
   Data exploration adn evaluation of models were carefully carried out, the process was detailed - `Evaluation`


## Instructions
To reproduce the results of this project, follow these steps:

Clone the repository:

**git clone** `https://github.com/Uchebuzz/Weather-Prediction-Model/tree/main`

Install the required libraries:

### For Python: 
You have to install all the [Python Libraries](#PythonLibraries)

### For R

Ensure you have R installed on your machine, and install the follow:

`shiny`

`shinythemes`

`e1071`

`caret`

`zoo`
