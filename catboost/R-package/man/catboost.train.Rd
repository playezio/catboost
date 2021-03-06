% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/catboost.R
\name{catboost.train}
\alias{catboost.train}
\title{Train the model}
\usage{
catboost.train(learn_pool, test_pool = NULL, params = list())
}
\arguments{
\item{learn_pool}{The dataset used for training the model.

Default value: Required argument}

\item{test_pool}{The dataset used for testing the quality of the model.

Default value: NULL (not used)}

\item{params}{The list of parameters to start training with.

If omitted, default values are used (see The list of parameters).

If set, the passed list of parameters overrides the default values.

Default value: Required argument}
}
\description{
Train the model using a CatBoost dataset.
}
\details{
The list of parameters

\itemize{
  \item Common parameters
  \itemize{
    \item fold_permutation_block_size

Objects in the dataset are grouped in blocks before the random permutations.
      This parameter defines the size of the blocks.
      The smaller is the value, the slower is the training.
      Large values may result in quality degradation.

Default value:

Default value differs depending on the dataset size and ranges from 1 to 256 inclusively
    \item ignored_features

Identifiers of features to exclude from training.
      The non-negative indices that do not match any features are successfully ignored.
      For example, if five features are defined for the objects in the dataset and this parameter
      is set to “42”, the corresponding non-existing feature is successfully ignored.

The identifier corresponds to the feature's index.
      Feature indices used in train and feature importance are numbered from 0 to featureCount – 1.
      If a file is used as input data then any non-feature column types are ignored when calculating these
      indices. For example, each row in the input file contains data in the following order:
      categorical feature<\code{\t}>target value<\code{\t}> numerical feature. So for the row rock<\code{\t}>0 <\code{\t}>42,
      the identifier for the “rock” feature is 0, and for the “42” feature it's 1.

The identifiers of features to exclude should be enumerated at vector.

For example, if training should exclude features with the identifiers
      1, 2, 7, 42, 43, 44, 45, the value of this parameter should be set to c(1,2,7,42,43,44,45).

Default value:

None (use all features)
    \item use_best_model

If this parameter is set, the number of trees that are saved in the resulting model is defined as follows:

Build the number of trees defined by the training parameters.
      \itemize{
        \item Identify the iteration with the optimal loss function value.
        \item No trees are saved after this iteration.
      }

This option requires a test dataset to be provided.

Default value:

FALSE (not used)
    \item loss_function

The loss function (see \url{https://tech.yandex.com/catboost/doc/dg/concepts/loss-functions-docpage/#loss-functions})
      to use in training. The specified value also determines the machine learning problem to solve.

Format:

<Loss function 1>[:<parameter 1>=<value>:..<parameter N>=<value>:]

Supported loss functions:
      \itemize{
        \item 'Logloss'
        \item 'CrossEntropy'
        \item 'RMSE'
        \item 'MAE'
        \item 'Quantile'
        \item 'LogLinQuantile'
        \item 'MAPE'
        \item 'Poisson'
        \item 'QueryRMSE'
        \item 'MultiClass'
        \item 'MultiClassOneVsAll'
        \item 'PairLogit'
      }

Supported parameters:
      \itemize{
        \item alpha - The coefficient used in quantile-based losses ('Quantile' and 'LogLinQuantile'). The default value is 0.5.

For example, if you need to calculate the value of Quantile with the coefficient \eqn{\alpha = 0.1}, use the following construction:

'Quantile:alpha=0.1'
      }

Default value:

'RMSE'
    \item custom_loss

Loss function (see \url{https://tech.yandex.com/catboost/doc/dg/concepts/loss-functions-docpage/#loss-functions})
      values to output during training.
      These functions are not optimized and are displayed for informational purposes only.

Format:

c(<Loss function 1>[:<parameter>=<value>],<Loss function 2>[:<parameter>=<value>],...,<Loss function N>[:<parameter>=<value>])

Supported loss functions:
      \itemize{
        \item 'Logloss'
        \item 'CrossEntropy'
        \item 'RMSE'
        \item 'MAE'
        \item 'Quantile'
        \item 'LogLinQuantile'
        \item 'MAPE'
        \item 'Poisson'
        \item 'QueryRMSE'
        \item 'MultiClass'
        \item 'MultiClassOneVsAll'
        \item 'PairLogit'
        \item 'R2'
        \item 'AUC'
        \item 'Accuracy'
        \item 'Precision'
        \item 'Recall'
        \item 'F1'
        \item 'TotalF1'
        \item 'MCC'
        \item 'PairAccuracy'
      }

Supported parameters:
      \itemize{
        \item alpha - The coefficient used in quantile-based losses ('Quantile' and 'LogLinQuantile'). The default value is 0.5.
      }

For example, if you need to calculate the value of CrossEntropy and Quantile with the coefficient \eqn{\alpha = 0.1}, use the following construction:

c('CrossEntropy') or simply 'CrossEntropy'.

Values of all custom loss functions for learning and test datasets are saved to the Loss function
      (see \url{https://tech.yandex.com/catboost/doc/dg/concepts/output-data_error-functions-docpage/#output-data_error-functions})
      output files (learn_error.tsv and test_error.tsv respectively). The catalog for these files is specified in the train-dir (train_dir) parameter.

Default value:

None (use one of the loss functions supported by the library)
    \item eval_metric

The loss function used for overfitting detection (if enabled) and best model selection (if enabled).

Supported loss functions:
      \itemize{
        \item 'Logloss'
        \item 'CrossEntropy'
        \item 'RMSE'
        \item 'MAE'
        \item 'Quantile'
        \item 'LogLinQuantile'
        \item 'MAPE'
        \item 'Poisson'
        \item 'QueryRMSE'
        \item 'MultiClass'
        \item 'MultiClassOneVsAll'
        \item 'PairLogit'
        \item 'R2'
        \item 'AUC'
        \item 'Accuracy'
        \item 'Precision'
        \item 'Recall'
        \item 'F1'
        \item 'TotalF1'
        \item 'MCC'
        \item 'PairAccuracy'
      }

Format:

metric_name:param=Value

Examples:

\code{'R2'}

\code{'Quantile:alpha=0.3'}

Default value:

Optimized objective is used

\item iterations

The maximum number of trees that can be built when solving machine learning problems.

When using other parameters that limit the number of iterations, the final number of trees may be less
      than the number specified in this parameter.

Default value:

500

\item border

The target border. If the value is strictly greater than this threshold,
      it is considered a positive class. Otherwise it is considered a negative class.

The parameter is obligatory if the Logloss function is used, since it uses borders to transform
      any given target to a binary target.

Used in binary classification.

Default value:

0.5

\item leaf_estimation_iterations

The number of gradient steps when calculating the values in leaves.

Default value:

1

\item depth

Depth of the tree.

The value can be any integer up to 32. It is recommended to use values in the range [1; 10].

Default value:

6
    \item learning_rate

The learning rate.

Used for reducing the gradient step.

Default value:

0.03

\item rsm

Random subspace method. The percentage of features to use at each iteration of building trees. At each iteration, features are selected over again at random.

The value must be in the range [0;1].

Default value:

1

\item random_seed

The random seed used for training.

Default value:

A new random value is selected on each run

\item nan_mode

Way to process nan-values.

Possible values:
      \itemize{
        \item \code{'Min'}
        \item \code{'Max'}
        \item \code{'Forbidden'}
      }

Default value:

\code{'Min'}

\item od_pval

Use the Overfitting detector (see \url{https://tech.yandex.com/catboost/doc/dg/concepts/overfitting-detector-docpage/#overfitting-detector})
      to stop training when the threshold is reached.
      Requires that a test dataset was input.

For best results, it is recommended to set a value in the range [10^-10; 10^-2].

The larger the value, the earlier overfitting is detected.

Default value:

The overfitting detection is turned off

\item od_type

The method used to calculate the values in leaves.

Possible values:
      \itemize{
        \item IncToDec
        \item Iter
      }

Restriction.
      Do not specify the overfitting detector threshold when using the Iter type.

Default value:

'IncToDec'

\item od_wait

The number of iterations to continue the training after the iteration with the optimal loss function value.
      The purpose of this parameter differs depending on the selected overfitting detector type:
      \itemize{
        \item IncToDec — Ignore the overfitting detector when the threshold is reached and continue learning for the specified number of iterations after the iteration with the optimal loss function value.
        \item Iter — Consider the model overfitted and stop training after the specified number of iterations since the iteration with the optimal loss function value.
      }

Default value:

20

\item leaf_estimation_method

The method used to calculate the values in leaves.

Possible values:
      \itemize{
        \item Newton
        \item Gradient
      }

Default value:

Default value depends on the selected loss function

\item l2_leaf_reg

L2 regularization coefficient. Used for leaf value calculation.

Any positive values are allowed.

Default value:

3

\item model_size_reg

Model size regularization coefficient. The influence coefficient of the model size for choosing tree structure.
      To get a smaller model size - increase this coefficient.

Any positive values are allowed.

Default value:

0.5

\item has_time

Use the order of objects in the input data (do not perform random permutations during the
      Transforming categorical features to numerical features (see \url{https://tech.yandex.com/catboost/doc/dg/concepts/algorithm-main-stages_cat-to-numberic-docpage/#algorithm-main-stages_cat-to-numberic})
      and Choosing the tree structure (see \url{https://tech.yandex.com/catboost/doc/dg/concepts/algorithm-main-stages_choose-tree-structure-docpage/#algorithm-main-stages_choose-tree-structure}) stages).

Default value:

FALSE (not used; generate random permutations)

\item name

The experiment name to display in visualization tools (see \url{https://tech.yandex.com/catboost/doc/dg/concepts/visualization-docpage/#visualization}).

Default value:

experiment

\item prediction_type

The format for displaying approximated values in output data.

Possible values:
      \itemize{
        \item 'Probability'
        \item 'Class'
        \item 'RawFormulaVal'
      }

Default value:

\code{'RawFormulaVal'}

\item fold_len_multiplier

Coefficient for changing the length of folds.

The value must be greater than 1. The best validation result is achieved with minimum values.

With values close to 1 (for example, \eqn{1 + \epsilon}), each iteration takes a quadratic amount of memory and time
      for the number of objects in the iteration. Thus, low values are possible only when there is a small number of objects.

Default value:

2

\item class_weights

Classes weights. The values are used as multipliers for the object weights.

Classes are indexed from 0 to classes count – 1. For example, in case of binary classification the classes are indexed 0 and 1.

For examples:

\code{c(0.85, 1.2, 1)}

Default value:

None (the weight for all classes is set to 1)

\item classes_count

The upper limit for the numeric class label. Defines the number of classes for multiclassification.

Only non-negative integers can be specified. The given integer should be greater than any of the target
      values.

If this parameter is specified the labels for all classes in the input dataset should be smaller
      than the given value.

Default value:

maximum class label + 1

\item one_hot_max_size

Convert the feature to float if the number of different values that it takes exceeds the specified value. Ctrs are not calculated for such features.

The one-vs.-all delimiter is used for the resulting float features.

Default value:

FALSE

Do not convert features to float based on the number of different values

\item random_strength

Score standard deviation multiplier.

Default value:

1

\item bagging_temperature

Controls intensity of Bayesian bagging. The higher the temperature the more aggressive bagging is.

Typical values are in the range \eqn{[0, 1]} (0 is for no bagging).

Possible values are in the range \eqn{[0, +\infty)}.

Default value:

1
  }
  \item CTR settings
  \itemize{
    \item ctr_description

Binarization settings for categorical features (see \url{https://tech.yandex.com/catboost/doc/dg/concepts/algorithm-main-stages_cat-to-numberic-docpage/#algorithm-main-stages_cat-to-numberic}).

Format:

\code{c(<CTR type 1>:[<number of borders 1>:<Binarization type 1>],...,<CTR type N>:[<number of borders N>:<Binarization type N>])}

Components:
      \itemize{
        \item CTR types:
        \itemize{
          \item \code{'Borders'}
          \item \code{'Buckets'}
          \item \code{'BinarizedTargetMeanValue'}
          \item \code{'Counter'}
        }
        \item The number of borders for target binarization. (see \url{https://tech.yandex.com/catboost/doc/dg/concepts/binarization-docpage/#binarization})
        Only used for regression problems. Allowed values are integers from 1 to 255 inclusively. The default value is 1.
        \item The binarization (see \url{https://tech.yandex.com/catboost/doc/dg/concepts/binarization-docpage/#binarization})
        type for the target. Only used for regression problems.

Possible values:
        \itemize{
          \item \code{'Median'}
          \item \code{'Uniform'}
          \item \code{'UniformAndQuantiles'}
          \item \code{'MaxLogSum'}
          \item \code{'MinEntropy'}
          \item \code{'GreedyLogSum'}
        }
        By default, \code{'MinEntropy'}
      }

Default value:

\item counter_calc_method

The method for calculating the Counter CTR type for the test dataset.

Possible values:
        \itemize{
          \item \code{'Full'}
          \item \code{'FullTest'}
          \item \code{'PrefixTest'}
          \item \code{'SkipTest'}
        }

Default value: \code{'PrefixTest'}
    \item ctr_border_count

The number of splits for categorical features.

Allowed values are integers from 1 to 255 inclusively.

Default value:

50

\item max_ctr_complexity

The maximum number of categorical features that can be combined.

Default value:

4

\item ctr_leaf_count_limit

The maximum number of leafs with categorical features.
      If the quantity exceeds the specified value a part of leafs is discarded.

The leafs to be discarded are selected as follows:
      \enumerate{
        \item The leafs are sorted by the frequency of the values.
        \item The top N leafs are selected, where N is the value specified in the parameter.
        \item All leafs starting from N+1 are discarded.
      }

This option reduces the resulting model size and the amount of memory required for training.
      Note that the resulting quality of the model can be affected.

Default value:

None (The number of leafs with categorical features is not limited)

\item store_all_simple_ctr

Ignore categorical features, which are not used in feature combinations,
      when choosing candidates for exclusion.

Use this parameter with ctr-leaf-count-limit only.

Default value:

FALSE (Both simple features and feature combinations are taken in account when limiting the number of leafs with categorical features)

}
  \item Binarization settings
  \itemize{
    \item  border_count

The number of splits for numerical features. Allowed values are integers from 1 to 255 inclusively.

Default value:

32
    \item feature_border_type

The binarization mode (see \url{https://tech.yandex.com/catboost/doc/dg/concepts/binarization-docpage/#binarization})
      for numerical features.

Possible values:
      \itemize{
        \item \code{'Median'}
        \item \code{'Uniform'}
        \item \code{'UniformAndQuantiles'}
        \item \code{'MaxLogSum'}
        \item \code{'MinEntropy'}
        \item \code{'GreedyLogSum'}
      }

Default value:

\code{'MinEntropy'}
  }
  \item Performance settings
  \itemize{
    \item thread_count

The number of threads to use when applying the model.

Allows you to optimize the speed of execution. This parameter doesn't affect results.

Default value:

Min(number of processor cores, 8)
  }
  \item Output settings
  \itemize{
    \item logging_level

Possible values:
      \itemize{
        \item \code{'Silent'}
        \item \code{'Verbose'}
        \item \code{'Info'}
        \item \code{'Debug'}
      }

Default value:

'Silent'

\item metric_period

The frequency of iterations to print the information to stdout. The value should be a positive integer.

Default value:

1

\item train_dir

The directory for storing the files generated during training.

Default value:

None (current catalog)

\item save_snapshot

Enable snapshotting for restoring the training progress after an interruption.

Default value:

None

\item snapshot_file

Settings for recovering training after an interruption (see
      \url{https://tech.yandex.com/catboost/doc/dg/concepts/snapshots-docpage/#snapshots}).

Depending on whether the file specified exists in the file system:
      \itemize{
        \item Missing – write information about training progress to the specified file.
        \item Exists – load data from the specified file and continue training from where it left off.
      }

Default value:

File can't be generated or read. If the value is omitted, the file name is experiment.cbsnapshot.

\item allow_writing_files

If this flag is set to FALSE, no files with different diagnostic info will be created during training.
      With this flag set to FALSE no snapshotting can be done. Plus visualisation will not
      work, because visualisation uses files that are created and updated during training.

Default value:

TRUE

\item approx_on_full_history

If this flag is set to TRUE, each approximated value is calculated using all the preceeding rows in the fold (slower, more accurate).
      If this flag is set to FALSE, each approximated value is calculated using only the beginning 1/fold_len_multiplier fraction of the fold (faster, slightly less accurate).

Default value:

FALSE

\item boosting_type

Boosting scheme.
     Possible values:
         - 'Dynamic' - Gives better quality, but may slow down the training.
         - 'Plain' - The classic gradient boosting scheme. May result in quality degradation, but does not slow down the training.

Default value:

'Dynamic'
  }
}
}
\examples{
fit_params <- list(iterations = 100,
    thread_count = 10,
    loss_function = 'Logloss',
    ignored_features = c(4,9),
    border_count = 32,
    depth = 5,
    learning_rate = 0.03,
    l2_leaf_reg = 3.5,
    border = 0.5,
    train_dir = 'train_dir')
model <- catboost.train(pool, test_pool, fit_params)
}
\seealso{
\url{https://tech.yandex.com/catboost/doc/dg/concepts/r-reference_catboost-train-docpage/}
}
