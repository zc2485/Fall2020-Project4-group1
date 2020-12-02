# Project 4: Causal Inference Algorithms Evaluation

### [Project Description](doc/project4_desc.md)

Term: Fall 2020

+ Team 1
+ Projec title: Causal Inference 
+ Team members
	+ Zihan Chen
	+ Depeng Kong
	+ Yiran Lin
	+ Wannian Lou
	+ Henan Xu
+ Project summary: Causal inference refers to the process of drawing a conclusion about a causal connection based on the conditions of the occurrence of an effect. Our group calculate ATE using Propensity Matching,  Inverse Propensity Weighting and Doubly Robust Estimation along with L2 propensity score estimations.
	
**Contribution statement**: All team members contributed equally in all stages of this project. All team members approve our work presented in this GitHub repository including this contributions statement.
+ Zihan Chen implemented matching part of Propensity Matching algorithm,  
+ Depeng Kong calculated propensity score based on L2 penalized logistic regression for every model.
+ Yiran Lin studied and implemented Doubly Robust Estimation algorithm with PS based on L2 penalized logistic regression, wrote the description for DRE algorithm.
+ Wannian Lou
+ Henan Xu studied and implemented Inverse Propensity Weighting algorithm with PS based on L2 penalized logistic regression, wrote the description for IPW algorithm.

Following [suggestions](http://nicercode.github.io/blog/2013-04-05-projects/) by [RICH FITZJOHN](http://nicercode.github.io/about/#Team) (@richfitz). This folder is orgarnized as follows.

```
proj/
├── lib/
├── data/
├── doc/
├── figs/
└── output/
```

Please see each subfolder for a README file.
