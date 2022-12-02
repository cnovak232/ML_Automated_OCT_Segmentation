MLSP Project - How to run
The best way to run and vary options/parameters is section by section. Some are necessary to run, other’s you can run one of options.

Step 1: Load spreadsheet info
Run Section 1 for this
Can run this once to load all spreed sheet info, and add paths

Step 2: Load images

Options: run one of these two section

Section 2: load in a single deck image by specifying ‘lc num’ and a scale parameter if processing the images resized (ie scale = 3 scales the im dimension 1/3). The scale var is used throughout the file. Also loads marks into struct and marks mages

Section 3: load all the images into a 24x8 cell array. Each column corresponds to the 24 T-Slices of an LC person. Also takes the scale param and return all the marks and marked images


Step 3: process training and test data

Run section 4 to separate the images into features for training data/labels and test features
Options: process data unmasked or masked by switching which functions to use
(ie computeTrainingData vs computeTrainingDataMask).
When changing parameters you just need to re run this section.
num_zero_ims: parameter to specify the number of images in training to use for the zeros labels (non marked data)

Unmasked: Processes most of the image for both training and testing - using num_zero_ims = 1 is best for a smaller amount of data

Masked: uses a function to establish a binary mask around the main area of interest then only processes those points. This yields a smaller amount of data for training and test. Can specify larger num_zero_ims

Step 4: run ML classification 

Run section 5,6 or 7 of algorithm you want
Option 1: KNN - can vary number of nearest neighbors
Option 2: SVM - can change kernels (doesn’t work well right now)
Option 3: Random Forest - can vary num trees (learners) (works the best currently)
Each section will handle the labels and then show both marked images
