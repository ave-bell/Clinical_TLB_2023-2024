Thermal liquid biopsy (TLB) is a growing field of biochemistry that holds potential to be used as a tool to diagnose and monitor disease. Thermograms, which are the results of TLB, differ based on the health status of a patient, and can be used to train classification models to identify an illness. This report details the work that has been done with Lung Cancer (LC) Thermograms during the Fall 2023 semester. The goal of this work was to use machine learning to train classification models to identify LC diagnosis and stage using TLB. First, feature selection was used to identify any bias in the thermograms, then random forests were cross-validated to train classification models to identify cancer type and stage. Table 1 shows the LC types and frequencies included in the dataset.

Figure 1 shows the median thermogram for each LC type. It can be seen that the median curves present differently for each type of LC. Despite the differences in the median curves, variation in individual samples is high. Figure 2 shows the median thermogram curve, as well as the 5th and 95th quantiles observed. The variation of individual samples within each group suggests that classification using thermograms will be difficult.

## Results of Pairwise Classifications
For all LC types with 10 or more thermograms, pairwise classifications were conducted. 1,000 iterations of bootstrap cross-validation (BSCV) was utilized to evaluate random forest model performance. For each bootstrapped sample, a grid of hyper parameter combinations was searched to find the best version. The parameters that were evaluated were the number of trees, the number of features, and tree depth. The hyper parameter states were grouped together, and the combination with the highest balanced accuracy was selected as the final model for each combination. Table 2 shows the results of each cancer type combination that were classified. 

Balanced accuracy was used as the primary metric for evaluating performance because it accounts for class imbalance. The balanced accuracy ranges from 0.51 - 0.67. The poor model performance for each cancer pair is not surprising given that the visualizations for each pair (Figures 3-8) have a large amount of overlap.

## Results of Stage Prediction
Thermograms were also used to predict lung cancer stage. Early vs late stages were predicted for each cancer type with 10 or more samples. Table 3 shows the groups and counts for each stage. Figure 2 shows the median thermograms for each cancer and stage. Due to limited sample sizes, cancer types with thermograms that are particularly distinct, such as Large Cell, were not included in classification pairs.


The results indicate that thermograms cannot be used to predict early vs late stage within individual cancer types, and also cannot be used to predict early vs late across all groups. Again, this is not surprising given how similar each cancer stage is to the other.

Finally, a multiclassifier was used to predict stages 1-4. BSCV was utilized to evaluate model performance, and a grid search for hyper parameters was used to find the optimal model. Table 4 shows the sample size for each group and stage.

Table 5 shows that LC thermograms are not useful in classification problems with respect to stage. With balanced accuracies between 0.329 and 0.367, the models did not perform well predicting cancer stages. 

Classifiers were trained on lung cancer thermograms to identify cancer type, early/late stage, and stages 1-4 for each cancer type. None of the models performed well, indicating that LC thermograms are not distinct enough to be using in classification problems.
