module add apps/matlab-r2015a


# 1) generate physical activity phenotypes

j-gen-vars.sh


# 2) combine these with other traits from ALSPAC (i.e. BMI and confounding factors)

matlab -r combinedatasets


# 3) tests of confounding factors for those in sample vs those not in sample

matlab -r getDataWithInSampleTag.m

confounderAssociations.do

# 4) tests of state priors vs BMI

matlab -r priorAssociationsFinal.m

# 5) tests of mCPM vs BMI

matlab -r associations-mcpm.m

# 6) tests of bigrams vs BMI

matlab -r bigramAssociationsFinal.m

# 7) tests of u-bigrams vs BMI

matlab -r consecutiveAssociationsFinal.m

# 8) bigram distibutions (histograms)

matlab -r plotDistributions.m

# 9) bigram vs unigram plots

matlab -r compareBigramsUnigrams2.m
