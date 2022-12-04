MLSP Project - How to run
The best way to run and vary options/parameters is section by section. Some are necessary to run, other’s you can run one of options.

Step 1: Load spreadsheet info
Run Section 1 for this
Can run this once to load all spreed sheet info, and add paths

Step 2: Load images

Options: run one of these two section

Section 2a: load in a single deck image by specifying ‘lc num’ and a scale parameter if processing the images resized (ie scale = 3 scales the im dimension 1/3). The scale var is used throughout the file. Also loads marks into struct and marks mages

Section 2b: load all the images into a 24x8 cell array. Each column corresponds to the 24 T-Slices of an LC person. Also takes the scale param and return all the marks and marked images


Step 3: process training and test data

Run section 4 to separate the images into features for training data/labels and test features
Options: process data unmasked or masked by switching which functions to use
(ie computeTrainingData vs computeTrainingDataMask).
When changing parameters you just need to re run this section.
num_zero_ims: parameter to specify the number of images in training to use for the zeros labels (non marked data)

Masked (use this): uses a function to establish a binary mask around the main area of interest then only processes those points. This yields a smaller amount of data for training and test. Can specify larger num_zero_ims

Options: 
Section 3a: Train with 23 T-Slices from 1 LC person and use 24th as test
Section 3b: Train with 23 T-Slices from each LC person (8 total LCs) and choose from the 24th image of any LC person for testing


Step 4: run ML classification 
Options
Section 4a: KNN - can vary number of nearest neighbors
Section 4b: Random Forest - can vary num trees (learners) (works the best currently)
Section 4c: SVM - can change kernels (doesn’t work well right now)

Each section will handle the labels and then show both marked images
