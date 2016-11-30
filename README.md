

# Activity bigrams 

This code accompanies the paper:

Millard, L.A.C, et al, Physical activity phenotyping with activity bigrams, and their association with BMI, submitted 2016


## General requirements

Analysis was performed with matlab-r2015a.

To run on blue crystal use:

```bash
module add apps/matlab-r2015a
```

The code assumes there is a data folder in the parent directory of this git dir that contains the following structure and contents:

```bash
../data
../data/original/F11_activity_renamed/*.DAT
../data/original/alspac/b_4d.dta  
../data/original/alspac/c_7d.dta  
../data/original/alspac/f11_4b.dta  
../data/original/alspac/kz_5b.dta
../data/derived/
../data/derived/accel/
../data/derived/alspac/
```

`*.DAT` refers to all accelerometer data files from the Focus at age 11 ALSPAC clinic.


## 1. Preprocessing

### 1a. Preprocess accelerometer data

We perform the following preprocessing:

1. Remove the header of the accelerometer data files

```bash
sh accelDataProcessing/dat-file-preprocessing.sh
```

2. Combine the accelerometer data into a single file
3. Recode sequences of >=60 consecutive zeros to missing (value -1)
4. Discretise activity levels to categories: sedentary=0, low=1, moderate=2, vigorous=3

```bash 
matlab -r "accelDataProcessing/combineParticipantsRecodeMissing"
```

Optional: plot a participants discretised sequence

```bash
matlab -r "accelDataProcessing/plot-persons-accelerometer-data"
```

### 1b. Collate necessary data from ALSPAC data files

```bash
stata -b prepare-alspac-variables.do
```

We also create a dataset version containing all people who attended the age 11 clinic - we use this for comparing differences (in confounders)
between those in our sample, and those who attended the age 11 clinic but are not in our sample.

```bash
stata -b prepare-alspac-variables-allN.do
```

## 


## 2) Generate physical activity (PA) phenotypes

The following variables are generated:

1. mCPM: average counts per minute
2. mSD: standard deviation of counts per minute
3. countMissing, countSed, countLow, countMod, countVig: the frequency of each activity category
4. activity bigrams: the frequency

```bash
qsub generateActivityVariables/j-gen-vars.sh
```

## 3) Combine these with other traits from ALSPAC (i.e. BMI and confounding factors)

Make a single dataset with our derived PA variables, and other ALSPAC variables that we need for our analysis.

The file that's created in the data folder is called main-dataset.csv

```bash
matlab -r combinedatasets
```

## 4) Tests of confounding factors for those in sample vs those not in sample

We create a dataset to perform the confounder analysis. This is different from the main dataset because it
contains all the participants that came to the F11 clinic.

matlab -r getDataWithInSampleTag.m

Perform the confounder associations:

```bash
stata -b do confounderAssociations.do
```

## 5) Tests of state priors vs BMI

Runs tests of association of unigrams (sedentary, low, moderate, vigorous categories) on BMI. See paper for analysis details.

Results are stored in unigram-assoc.csv and as a figure (figure-unigram-assoc.pdf).


```bash
matlab -r basicAssociations/priorAssociationsFinal.m
```

## 5) Tests of mCPM and mSD with BMI

Runs tests of association of mCPM and mSD with BMI. See paper for analysis details.

Results are stored in mCPM-mSD-assoc.csv and as a figure (figure-mCPM-vCPM.pdf).

```bash
matlab -r basicAssociations/associations-mcpm.m
```

## 6) Tests of bigrams with BMI

Runs tests of association of bigrams with BMI. See paper for analysis details.

Results	are stored in bigram-assoc.csv and as a figure (figure-bigram-assoc.pdf).

```bash
matlab -r bigramAssociations/bigramAssociationsFinal.m
```

## 7) Tests of unordered bigrams (u-bigrams) with BMI

Runs tests of association of u-bigrams with BMI. See paper for analysis details.

Results are stored in ubigram-assoc.csv and as a figure (figure-ubigram-assoc.pdf).

```bash
matlab -r bigramAssociations/consecutiveAssociationsFinal.m
```

## 8) Plot bigram distibutions (histograms)

```bash
matlab -r postAnalysis/plotDistributions.m
```

## 9) Plot relationship between the frequency of bigrams vs the frequency of unigrams


```bash
matlab -r postAnalysis/compareBigramsUnigrams2.m
```


