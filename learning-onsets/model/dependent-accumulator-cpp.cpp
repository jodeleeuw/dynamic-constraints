#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
int mapToIndex(NumericVector v, int maxFinishTime){
  int sum = 0;
  int n = v.size();
  for(int i=0; i<n; i++){
    int val = v[i];
    val--; // make 0 indexed
    if(val > maxFinishTime){
      val = maxFinishTime;
    }
    sum += val * pow(maxFinishTime+1,n-i-1);
  }
  return sum;
}

// [[Rcpp::export]]
NumericVector dependentAccumulators(int n, double p, int end, double boost) {
  NumericVector accumulators(n);
  NumericVector finishTimes(n);
  int finishedCount = 0;
  int t = 0;
  double pSample = p;
  while(finishedCount < n){
    t++;
    accumulators = accumulators + rbinom(n, end, pSample);
    for(int i=0; i<finishTimes.size(); i++){
      if(finishTimes[i] == 0 && accumulators[i] >= end){
        finishTimes[i] = t;
        finishedCount++;
        pSample = 1 - pow(1 - p, 1 + boost * finishedCount);
      }
    }
  }
  std::sort(finishTimes.begin(), finishTimes.end());
  return(finishTimes);
}

// [[Rcpp::export]]
NumericVector dependentAccumulatorsNoSort(int n, double p, int end, double boost) {
  NumericVector accumulators(n);
  NumericVector finishTimes(n);
  int finishedCount = 0;
  int t = 0;
  double pSample = p;
  while(finishedCount < n){
    t++;
    accumulators = accumulators + rbinom(n, end, pSample);
    for(int i=0; i<finishTimes.size(); i++){
      if(finishTimes[i] == 0 && accumulators[i] >= end){
        finishTimes[i] = t;
        finishedCount++;
        pSample = 1 - pow(1 - p, 1 + boost * finishedCount);
      }
    }
  }
  return(finishTimes);
}

// [[Rcpp::export]]
NumericVector dependentAccumulatorsPreKnowledge(int n, double p, int end, double boost, NumericVector accumulators) {
  // NumericVector accumulators(n);
  NumericVector finishTimes(n);
  int finishedCount = 0;
  int t = 0;
  double pSample = p;
  while(finishedCount < n){
    t++;
    accumulators = accumulators + rbinom(n, end, pSample);
    for(int i=0; i<finishTimes.size(); i++){
      if(finishTimes[i] == 0 && accumulators[i] >= end){
        finishTimes[i] = t;
        finishedCount++;
        pSample = 1 - pow(1 - p, 1 + boost * finishedCount);
      }
    }
  }
  return(finishTimes);
}

// [[Rcpp::export]]
NumericVector dependentAccumulatorsWithBoundary(int n, double p, int end, double boost, NumericVector accumulators, int maxTime) {
  // NumericVector accumulators(n);
  NumericVector finishTimes(n);
  int finishedCount = 0;
  int t = 0;
  double pSample = p;
  while(finishedCount < n && t <= maxTime){
    t++;
    accumulators = accumulators + rbinom(n, end, pSample);
    for(int i=0; i<finishTimes.size(); i++){
      if(finishTimes[i] == 0 && accumulators[i] >= end){
        finishTimes[i] = t;
        finishedCount++;
        pSample = 1 - pow(1 - p, 1 + boost * finishedCount);
      }
    }
  }
  return(finishTimes);
}

// [[Rcpp::export]]
NumericVector empiricalLikelihood(int n, double p, int end, double boost, int reps, int maxFinishTime){
  int vectorlen = pow(maxFinishTime+1, n);
  NumericVector finishDistribution(vectorlen);
  for(int i=0; i<reps; i++){
    NumericVector r = dependentAccumulators(n,p,end,boost);
    int idx = mapToIndex(r, maxFinishTime);
    finishDistribution[idx]++;
  }
  //finishDistribution = finishDistribution / reps;
  return finishDistribution;
}




// You can include R code blocks in C++ files processed with sourceCpp
// (useful for testing and development). The R code will be automatically 
// run after the compilation.
//

/*** R

*/
