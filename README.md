# Movie Data Analysis Project

## Overview
This project involves analyzing movie data to gain insights into various aspects, such as budget, gross earnings, ratings, and genre distribution. The analysis is performed using SQL and Python (with Jupyter Notebook), leveraging libraries such as Pandas and Seaborn for data manipulation and visualization.

## SQL Code

### Description
The SQL code is structured to perform the following tasks:

1. **Data Inspection**: Retrieve initial data from the `movies_info` and `movies_budget` tables to understand their structure.
2. **Data Cleaning**: 
   - Remove unnecessary columns (`orig_lang`, `orig_title`) from the `movies_info` table.
   - Add a new column (`country`) to the `movies_budget` table.
   - Implement triggers to ensure data integrity during insertions.
   - Update the `country` column based on information from the `movies_info` table.
   - Enforce NOT NULL constraints on specific columns to ensure data quality.
3. **Data Analysis**: 
   - Join tables to gather comprehensive data on movies.
   - Calculate averages, count specific genres, and group data by seasons.
4. **Reporting**: Generate insights such as the top movies by budget and the average score and budget by country.

### Code
The SQL code can be found in the `sql_code.sql` file. It includes comments to explain each section for clarity.

## Jupyter Notebook Code

### Description
The Jupyter Notebook code performs the following:

1. **Data Import**: Load the movie data from a CSV file into a Pandas DataFrame.
2. **Data Cleaning**:
   - Identify and handle missing values, replacing them with the mean for numerical columns and dropping rows for categorical columns with missing values.
   - Convert relevant columns to appropriate data types.
3. **Exploratory Data Analysis (EDA)**:
   - Analyze the correlation between budget, gross earnings, and other numeric features.
   - Visualize relationships using scatter plots and regression plots.
   - Create a heatmap to display the correlation matrix for numeric features.
4. **Final DataFrame Preparation**: Sort and reset the index of the DataFrame for easier access.

### Code
The Jupyter Notebook code is available in the `movie_analysis.ipynb` file. It includes inline comments to explain each step of the analysis.

## Requirements
- Python 3.x
- Pandas
- NumPy
- Matplotlib
- Seaborn

## How to Run
1. Clone the repository or download the files.
2. Ensure you have the required libraries installed.
3. For SQL:
   - Run the SQL script in your SQL environment.
4. For Jupyter Notebook:
   - Open the Jupyter Notebook and run the cells to perform the analysis.

## Conclusion
This project showcases the ability to clean, manipulate, and analyze movie data using SQL and Python. The insights derived can be useful for understanding trends in the movie industry.
