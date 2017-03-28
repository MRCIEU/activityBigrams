

# Activity bigrams 

Activity bigrams are a set of variables derived from accelerometer data, that describe how a person's activity changes
from one moment to the next.

This repository accompanies the paper:

Millard LAC, Tilling K, Lawlor DA, Flach PA, Gaunt TR. Physical activity phenotyping with activity bigrams, and their association with BMI. bioRxiv 2017.

The code in this repository generates activity bigrams and analyses their association with BMI, using the ALSPAC cohort (at age 11).


## General requirements

Analysis was performed with matlab-r2015a and stata14.

To run on blue crystal use:

```bash
module add apps/matlab-r2015a
module add apps/stata14
```

The code assumes there is a data folder in the parent directory of this git directory that contains the following structure and contents:

```bash
../data
../data/original/F11_activity_renamed/*.DAT
../data/original/alspac/b_4d.dta  
../data/original/alspac/c_7d.dta  
../data/original/alspac/f11_4b.dta  
../data/original/alspac/kz_5b.dta
../data/derived/
../data/derived/activityBigrams/
../data/derived/activityBigrams/accel/
../data/derived/activityBigrams/accel/F11-processed/
../data/derived/activityBigrams/alspac/
```

`*.DAT` refers to all accelerometer data files from the Focus at age 11 ALSPAC clinic.

The code outputs generated results files to the directory `out` in this directory.
This needs to be created if it doesn't exist:

```bash
mkdir out
```

## 1. Preprocessing

### 1a. Preprocess accelerometer data

We perform the following preprocessing:

1. Remove the header of the accelerometer data files

    ```bash
    cd accelDataProcessing/
    sh dat-file-preprocessing.sh
    ```

2. Prepare the accelerometer data
    1. Combine the accelerometer data into a single file
    2. Recode sequences of >=60 consecutive zeros to missing (value -1)
    3. Discretise activity levels to categories: sedentary=0, low=1, moderate=2, vigorous=3

    ```bash 
    cd accelDataProcessing/
    matlab -r combineParticipantsRecodeMissing
    ```

Optional: plot a participant's discretised sequence:

```bash
cd accelDataProcessing/
matlab -r plotPersonsAccelerometerData
```

### 1b. Collate necessary data from ALSPAC data files

ALSPAC data is stored as Stata dta files. We process this to extract the required variables
and do some basic processing to prepare variables, e.g. recoding as missing.

This script creates a file called alspac-variables.csv in `../data/derived/activityBigrams/alspac/`.

```bash
cd alspacDataProcessing/
stata -b prepare-alspac-variables.do nolog
```


## 2) Generate physical activity (PA) phenotypes

The following variables are generated:

1. mCPM: average counts per minute
2. mSD: standard deviation of counts per minute
3. countMissing, countSed, countLow, countMod, countVig: the frequency of each activity category
4. Activity bigrams: the frequency of each activity bigram
5. numValidDays: the number of valid days, defined as having at least 8 hours wear time (i.e. not recoded as missing)

```bash
cd generateActivityVariables/
qsub j-gen-vars.sh
```

## 3) Combine these with other traits from ALSPAC (i.e. BMI and confounding factors)

We make a single dataset with our derived PA variables, and other ALSPAC variables that we need for our analysis.

The file that's created in `../../data/derived/activityBigrams/` is called `main-dataset.csv`.

```bash
cd generateActivityVariables/
matlab -r combineDatasets
```

## 4) Tests of confounding factors for those in sample vs those not in sample

We create a dataset to perform the confounder analysis. This is different from the main dataset because it
contains all the participants that came to the F11 clinic, with an indicator variable `insample` denoting
whether each person is in our sample.

```bash
cd confounderAnalysis/
matlab -r getDataWithInSampleIndicator
```

Perform the confounder associations:

```bash
cd confounderAnalysis/
stata -b do confounderAssociations.do nolog
```
Results are output to `confounder-assoc.log`.

## 5) Tests of state priors vs BMI

Runs tests of association of unigrams (sedentary, low, moderate, vigorous categories) on BMI. See paper for analysis details.

Results are stored in `unigram-assoc.csv` and as a figure (`figure-unigram-assoc.pdf`).


```bash
cd basicAssociations/
matlab -r priorAssociationsFinal
```

## 6) Tests of mCPM and sdCPM with BMI

Runs tests of association of mCPM and mSD with BMI. See paper for analysis details.

Results are stored in `mCPM-sdCPM-assoc.csv` and as a figure (`figure-mCPM-sdCPM.pdf`).

```bash
cd basicAssociations/
matlab -r associationsmCPM
```

## 7) Tests of bigrams with BMI

Runs tests of association of bigrams with BMI. See paper for analysis details.

Results	are stored in `bigram-assoc.csv` and one figure for the results with each bigram as the baseline (`figure-bigram-assoc*.pdf`).

```bash
cd bigramAssociations/
matlab -r bigramAssociationsFinal
```

## 8) Tests of unordered bigrams (u-bigrams) with BMI

Runs tests of association of u-bigrams with BMI. See paper for analysis details.

Results are stored in `ubigram-assoc.csv` and one figure for the results with each u-bigram as the baseline (`figure-ubigram-assoc*.pdf`).

```bash
cd bigramAssociations/
matlab -r ubigramsAssociationsFinal
```

We also looked at associations in terms of a standard deviation change of the baseline bigram, where the
SD of the baseline < SD of the comparison bigram. 


```bash
cd bigramAssociations/
matlab -r ubigramsAssociationsSDFinal
```

Results are stored in `ubigram-assoc-SD.csv` and one figure for the results with each u-bigram as the baseline (`figure-ubigram-assoc-SD*.pdf`).


## 9) Plot bigram distibutions (histograms)

```bash
cd postAnalysis/
matlab -r plotDistributions
```

## 10) Plot relationship between the frequency of bigrams vs the frequency of unigrams

```bash
cd postAnalysis/
matlab -r compareBigramsUnigrams
```

Generates 1 figure for each unigram: `figure-sedentary-bigram-unigram-comp.pdf`, `figure-low-bigram-unigram-comp.pdf`, `figure-moderate-bigram-unigram-comp.pdf` and `figure-vigorous-bigram-unigram-comp.pdf`.

## U-bigram standard deviations

```bash
cd postAnalysis/
matlab -r ubigramSD
```

Output is stored in `ubigram-sd.csv`.


## 11) Sensitivity analysis

In the analysis above we use all days, including those with <8 hours wear time.

In this sensitivity analysis we repeat the bigram tests of association, including only valid days (>=8 hours wear time).

Generate activity variables, including only valid days:
```bash
cd generateActivityVariables/
qsub j-gen-varsVD.sh
```

Combine VD activity data with core ALSPAC variables:
```bash
cd generateActivityVariables/
matlab -r combineDatasetsValidDaysOnly
```

Test associations of bigrams with BMI:
```bash
cd bigramAssociations/
matlab -r bigramAssociationsFinalValidDaysOnly
```

Results are stored in `bigram-assocValidDaysOnly.csv` and one figure for the results with each bigram as the baseline (`figure-bigram-assoc*-ValidDaysOnly.pdf`).

Test associations of ubigrams with BMI:
```bash
cd bigramAssociations/
matlab -r ubigramAssociationsFinalValidDaysOnly
```

Results are stored in `ubigram-assocValidDaysOnly.csv` and one figure for the results with each bigram as the baseline (`figure-ubigram-assoc*-ValidDaysOnly.pdf`).



