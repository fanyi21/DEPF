Installation
=============

Prerequisites
-------------

The following packages are requirements:

- ``r-base=4.1.3``
- ``python=3.9``
- ``MATLAB2019b``


Enviroments
------------

- It is recommended to use **conda** for installation.  

::

    # create a virtual environment named DEPF
    conda create -n DEPF   
    # activate the environment       
    conda activate DEPF   

- **python** enviroment:

::

    conda install python=3.9
    pip install leidenalg

- **R** enviroment:

::

    conda install -c conda-forge r-base=4.1.3
    conda install -c conda-forge r-devtools
    conda install -c conda-forge r-seurat

- **MATLAB** enviroment:

::

    Following the official website tutorial: https://ww2.mathworks.cn/downloads/.

- **DEPF** dependencies:
  
::

    # clone DEPF repository                  
    git clone https://github.com/fanyi21/DEPF.git
    # # install the dependencies
    cd DEPF/DEPF/HierarchicalAutoencoder/
    Rscript RequirePackage.R