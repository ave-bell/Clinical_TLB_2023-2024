def median_curve(self, filter_col, temp_col, median_column):
    """
Thermogram utility function that finds the median curve for a specified category (cancer type, progression).

Function calculates the median values for each temperature of a given class. It returns a dataframe with the median and 95% quantile values.

Parameters:
    self (pandas dataframe): pandas df with thermogram results in long format
    filter_col (str): Column that contains grouping parameter to find median values.
    temp_col (str): name of column that contains temperatures.
    median_column (str): specific excess heat capacity column to find median values.
    ...

Returns:Description
    return_type:  pandas df with median and quantile columns
    
Raises:
    ExceptionType: none
    ...

Examples:
    Provide example usage of the function or module.
    
    >>> df = thermogram_utilities.median_curve(df_long, 'CancerType', 'temp', 'dsp')
    Output: Dataframe with median results for specified groups/
    
Notes:
Thermogram utility functions to reduce "by hand" coding.
"""
    # import modules
    import pandas as pd
    import numpy as np

    # create median df
    median_df = pd.DataFrame(columns=['temperature', 'median', 'type', 'upper_q', 'lower_q'])

    # get all unique values in filter_col
        # get the column index of the filter column
    #filter_col_index = self.columns.get_loc(filter_col)

        # get unique values from filter column
    filter_vals = self[filter_col].unique()

    # get all unique temps
        # get column index of temperature column
    # temp_col_index = self.columns.get_loc(temp_col)

        # get unique values from filter column
    temp_vals = self[temp_col].unique()

    # loop through filter values
    for i in filter_vals:

        # filter df for current filter val
        current_df = self[self[filter_col] == i]

        #print(current_df[filter_col].unique())

        # loop through each temperature
        for t in temp_vals:

            # filter to keep only current temperature
            current_temp_df = current_df[current_df[temp_col] == t]

            #print(current_temp_df[temp_col].unique)

            # calculate median for current temp/category
            median = current_temp_df[median_column].median()

            # calculate upper quantile
            lower_bound = np.percentile(current_temp_df[median_column], 2.5)

            # calculate lower quantile
            upper_bound = np.percentile(current_temp_df[median_column], 97.5)

            # append the new rows to the median df
            median_df.loc[len(median_df.index)] = [t, median, i, upper_bound, lower_bound] 

    return median_df