<h2 align="center">
DEPF: Reliable Identification and Interpretation of Single-cell Molecular Heterogeneity and Transcriptional Regulation using Dynamic Ensemble Pruning
</h2>

<p align="center">
  <a href="https://github.com/fanyi21/DEPF">
    <img src="https://img.shields.io/badge/DEPF-R&MATLAB&Cpp-orange">
  </a>
  <a href='https://rbp-package.readthedocs.io/en/latest/?badge=latest'>
    <img src='https://readthedocs.org/projects/rbp-package/badge/?version=latest' alt='Documentation Status' />
  </a>
  <a href="https://github.com/fanyi21/DEPF/stargazers">
    <img src="https://img.shields.io/github/stars/fanyi21/DEPF">
  </a>
  <a href="https://github.com/fanyi21/DEPF/network/members">
    <img src="https://img.shields.io/github/forks/fanyi21/DEPF">
  </a>
  <a href="https://github.com/fanyi21/DEPF/issues">
    <img src="https://img.shields.io/github/issues/fanyi21/DEPF">
  </a>
  <a href="https://github.com/fanyi21/DEPF/blob/main/LICENSE">
    <img src="https://img.shields.io/github/license/fanyi21/DEPF">
  </a>
  <a href="https://github.com/fanyi21/DEPF/graphs/traffic">
    <img src="https://visitor-badge.glitch.me/badge?page_id=fanyi21.DEPF">
  </a>
  <!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
<a href="https://github.com/fanyi21/DEPF#contributors-"><img src="https://img.shields.io/badge/all_contributors-2-orange.svg"></a>
<!-- ALL-CONTRIBUTORS-BADGE:END -->
</p>


**Release: 
  <a href="https://github.com/fanyi21/DEPF/tree/main/DEPF">Source</a> |
  <a href=""> Changelog </a>  
  Links:
  <a href="https://github.com/fanyi21/DEPF#Modularity of DEPF">Getting Started</a> |
  <a href="https://rbp-package.readthedocs.io/">API Reference</a> |
  <a href="https://rbp-package.readthedocs.io/en/latest/basic_usage.html">Examples</a>**
  



***DEPF:*** a **dynamic ensemble pruning framework (DEPF)** is proposed to identify and interpret single-cell molecular heterogeneity. In particular, a **silhouette coefficient-based indicator** is developed and evaluated to determine the optimization direction of the bi-objective function. In addition, a **hierarchical autoencoder** is employed to project the high-dimensional scRNA-seq data onto multiple low-dimensional latent space sets, and then a **clustering ensemble** is produced in the latent space by the basic clustering algorithm. Following that, a **bi-objective fruit fly optimization algorithm** is designed to prune dynamically the low-quality basic clustering in the ensemble. 


***DEPF*** is constructed based on multiple [RNA-RBP binding semantic models](https://figshare.com/articles/software/LM_for_RBP_package/21383187) (RBPBERT, FastText, GloVe, Word2Vec, Doc2Vec) developed by ourselves. It provides four **advanced features**:
- &#x1F34E; Unified, easy-to-use APIs, detailed [documentation](https://rbp-package.readthedocs.io/) and [examples](https://rbp-package.readthedocs.io/en/latest/basic_usage.html).
- &#x1F34E; Capable for out-of-the-box ***RNA-RBP binding event*** characterization and downstream experiments.
- &#x1F34E; Powerful, customizable performance and feature analysis visualizer.
- &#x1F34E; Full compatibility with other popular packages like [scikit-learn](https://scikit-learn.org/stable/) and [yellowbrick](https://www.scikit-yb.org/en/latest/index.html).

## Getting Started
<img src="https://github.com/fanyi21/DEPF/blob/main/ModularityOfDEPF.png" alt = "DEPF" style="zoom:20%" align = center />




## Generating features using PyRBP with 7 Lines of Code:




```python
# Generate RNA physicochemical properties
from PyRBP.Features import generateBPFeatures
from PyRBP.featureSelection import cife
from PyRBP.metricsPlot import shap_interaction_scatter
bp_features = generateBPFeatures(sequences, PGKM=True)

# Filter the original features
refined_features = cife(bp_features, label, num_features=10)

# Performance visualization of SVM using PyRBP
clf = SVC(probability=True)
shap_interaction_scatter(refined_features, label, clf=clf, sample_size=(0, 100), feature_size=(0, 10), image_path='./')
```

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Installation](#installation)
- [Highlights](#highlights)
- [List of implemented methods](#list-of-implemented-methods)


## Installation

It is recommended to use **git** for installation.  
```shell
$ conda create -n PyRBP python=3.7.6            # create a virtual environment named PyRBP
$ conda activate PyRBP                          # activate the environment  
$ git clone https://github.com/no-banana/PyRBP.git # clone this repository
$ cd PyRBP
$ pip install -r requirement.txt               # install the dependencies of PyRBP
```
After this, the torch also needs to be installed separately according to the cuda version of your device, e.g. CUDA 10.2 can be used with the following command.
```shell
$ pip install torch==1.8.1+cu102 torchvision==0.9.1+cu102 torchaudio==0.8.1 -f https://download.pytorch.org/whl/torch_stable.html
```
scikit-feature can be installed in a virtual environment with the following command 
```shell
git clone https://github.com/jundongl/scikit-feature.git
cd scikit-feature
python setup.py install
```

The language models used in PyRBP can be downloaded from [figshare](https://figshare.com/articles/software/LM_for_RBP_package/21383187)

Note for OSX users: due to its use of OpenMP, glove-python-binary does not compile under Clang. To install it, you will need a reasonably recent version of `gcc` (from Homebrew for instance). This should be picked up by `setup.py`.
```shell
git clone https://github.com/maciejkula/glove-python.git
cd glove-python
python setup.py install
```


PyRBP requires following dependencies:

- [Python](https://www.python.org/) (>=3.6)
- [gensim](https://radimrehurek.com/gensim/index.html) (>=3.8.3)
- [GloVe](https://pypi.org/project/glove-python-binary/) (>=0.2.0)
- [numpy](https://numpy.org/) (>=1.19.5)
- [pandas](https://pandas.pydata.org/) (>=1.3.5)
- [scipy](https://www.scipy.org/) (>=0.19.1)
- [joblib](https://pypi.org/project/joblib/) (>=0.11)
- [scikit-learn](https://scikit-learn.org/stable/) (>=0.24.2)
- [matplotlib](https://matplotlib.org/) (>=3.5.3)
- [seaborn](https://seaborn.pydata.org/) (>=0.11.2)
- [shap](https://shap.readthedocs.io/en/latest/index.html) (>=0.41.0)
- [skfeature](https://jundongl.github.io/scikit-feature/index.html) (>=1.0.0)
- [tensorflow-gpu](https://tensorflow.google.cn/) (>=2.4.0)
- [torch](https://pytorch.org/) (>=1.8.1)
- [transformers](https://huggingface.co/docs/transformers/index) (4.12.5)
- [yellowbrick](https://www.scikit-yb.org/en/latest/index.html) (>=1.3)
- [tqdm](https://tqdm.github.io/) (>=4.64.0)

## Highlights

- &#x1F34E; ***Unified, easy-to-use APIs***  
The functions in each module in PyRBP have individual unified APIs. 
- &#x1F34E; ***Extended functionalities, wider application scenarios.***  
*PyRBP provides interfaces for conducting downstream **RNA-RBP binding event** experiments,* including feature selection, model cross validation, feature and performance analysis visualization. 
- &#x1F34E; ***Detailed training log, quick intuitive visualization.***   
We provide additional parameters in characterization functions for users to control the window to capture information of different views they want to monitor during the sequence encoding. We also implement an [`metricsPlot`](https://rbp-package.readthedocs.io/en/latest/analysis_plots.html) to quickly visualize the results of feature analysis or model evaluation for providing further information/conducting comparison. See an example [here](https://rbp-package.readthedocs.io/en/latest/plotAnalysis_examples.html).
- &#x1F34E; ***Wide compatiblilty.***   
IMBENS is designed to be compatible with [scikit-learn](https://scikit-learn.org/stable/) (sklearn) and also other projects like [yellowbrick](https://www.scikit-yb.org/en/latest/index.html). Therefore, users can take advantage of various utilities from the sklearn community for cross validation or result visualization, etc.

## List of implemented methods

**Currently (v0.1.0, 2023/03), *13* RNA-RBP binding event characterization methods were implemented:  
(Click to jump to the document page)**

- **RNA-RBP binding semantic based**
  - *[Dynamic global semantic information](https://rbp-package.readthedocs.io/en/latest/RNA_features.html#PyRBP.Features.generateDynamicLMFeatures)*
  - *[Static local semantic information](https://rbp-package.readthedocs.io/en/latest/RNA_features.html#PyRBP.Features.generateStaticLMFeatures)*
    1. **[`FastText`]**
    2. **[`GloVe`]**
    3. **[`Word2Vec`]**
    4. **[`Doc2Vec`]**
- **RNA secondary structure based**
  - *[Secondary structure information](https://rbp-package.readthedocs.io/en/latest/RNA_features.html#PyRBP.Features.generateStructureFeatures)*
- **RNA physicochemical properties**
  - *[pseudoKNC](https://rbp-package.readthedocs.io/en/latest/RNA_features.html#PyRBP.Features.generateBPFeatures)*
  - *[zigzag coding](https://rbp-package.readthedocs.io/en/latest/RNA_features.html#PyRBP.Features.generateBPFeatures)*
  - *[Guanine cytosine Quantity](https://rbp-package.readthedocs.io/en/latest/RNA_features.html#PyRBP.Features.generateBPFeatures)*
  - *[Nucleotides tilt](https://rbp-package.readthedocs.io/en/latest/RNA_features.html#PyRBP.Features.generateBPFeatures)*
  - *[Percentage of bases](https://rbp-package.readthedocs.io/en/latest/RNA_features.html#PyRBP.Features.generateBPFeatures)*
  - *[Positional gapped k-m-tuple pairs](https://rbp-package.readthedocs.io/en/latest/RNA_features.html#PyRBP.Features.generateBPFeatures)*
  - *[DPCP](https://rbp-package.readthedocs.io/en/latest/RNA_features.html#PyRBP.Features.generateBPFeatures)*

> **Note: `PyRBP` is still under development, please see [API reference](https://rbp-package.readthedocs.io/en/latest/index.html) for the latest list.**

## Contact:
Thank you for using PyRBP! Any questions, suggestions or advices are welcome.

email address:[lixt314@jlu.edu.cn](lixt314@jlu.edu.cn), [wys21@mails.jlu.edu.cn](wys21@mails.jlu.edu.cn)

