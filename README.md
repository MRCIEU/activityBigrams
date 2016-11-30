

# Activity bigrams 

This code accompanies the paper:

Millard, L.A.C, et al, Physical activity phenotyping with activity bigrams, and their association with BMI, submitted 2016


## General requirements

Analysis was performed with matlab-r2015a and stata14.

To run on blue crystal use:

```bash
module add apps/matlab-r2015a
module add apps/stata14
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
../data/derived/accel/F11-processed/
../data/derived/alspac/
```

`*.DAT` refers to all accelerometer data files from the Focus at age 11 ALSPAC clinic.


## 1. Preprocessing

### 1a. Preprocess accelerometer data

We perform the following preprocessing:

1. Remove the header of the accelerometer data files

	```bash
	cd accelDataProcessing/
	sh dat-file-preprocessing.sh
	```

2. Combine the accelerometer data into a single file
3. Recode sequences of >=60 consecutive zeros to missing (value -1)
4. Discretise activity levels to categories: sedentary=0, low=1, moderate=2, vigorous=3

```bash 
cd accelDataProcessing/
matlab -r combineParticipantsRecodeMissing
```

Optional: plot a participants discretised sequence

```bash
cd accelDataProcessing/
matlab -r plotPersonsAccelerometerData
```

### 1b. Collate necessary data from ALSPAC data files

Create a file called myvars-for-bigramsV2.csv in `../../data/derived/alspac/`.

```bash
cd alspacDataProcessing/
stata -b prepare-alspac-variables.do nolog
```


## 2) Generate physical activity (PA) phenotypes

The following variables are generated:

1. mCPM: average counts per minute
2. mSD: standard deviation of counts per minute
3. countMissing, countSed, countLow, countMod, countVig: the frequency of each activity category
4. activity bigrams: the frequency

```bash
cd generateActivityVariables/
qsub j-gen-vars.sh
```

## 3) Combine these with other traits from ALSPAC (i.e. BMI and confounding factors)

Make a single dataset with our derived PA variables, and other ALSPAC variables that we need for our analysis.

The file that's created in the data folder is called main-dataset.csv

```bash
cd generateActivityVariables/
matlab -r combineDatasets
```

## 4) Tests of confounding factors for those in sample vs those not in sample

We create a dataset to perform the confounder analysis. This is different from the main dataset because it
contains all the participants that came to the F11 clinic.

```bash
cd confounderAnalysis/
matlab -r getDataWithInSampleIndicator
```

Perform the confounder associations:

```bash
cd confounderAnalysis/
stata -b do confounderAssociations.do nolog
```

## 5) Tests of state priors vs BMI

Runs tests of association of unigrams (sedentary, low, moderate, vigorous categories) on BMI. See paper for analysis details.

Results are stored in unigram-assoc.csv and as a figure (figure-unigram-assoc.pdf).


```bash
cd basicAssociations/
matlab -r priorAssociationsFinal
```

## 6) Tests of mCPM and mSD with BMI

Runs tests of association of mCPM and mSD with BMI. See paper for analysis details.

Results are stored in mCPM-mSD-assoc.csv and as a figure (figure-mCPM-vCPM.pdf).

```bash
cd basicAssociations/
matlab -r associationsmCPM
```

## 7) Tests of bigrams with BMI

Runs tests of association of bigrams with BMI. See paper for analysis details.

Results	are stored in bigram-assoc.csv and as a figure (figure-bigram-assoc.pdf).

```bash
cd bigramAssociations/
matlab -r bigramAssociationsFinal
```

## 8) Tests of unordered bigrams (u-bigrams) with BMI

Runs tests of association of u-bigrams with BMI. See paper for analysis details.

Results are stored in ubigram-assoc.csv and as a figure (figure-ubigram-assoc.pdf).

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


