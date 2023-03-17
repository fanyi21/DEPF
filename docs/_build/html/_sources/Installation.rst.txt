Installation
=============

It is recommended to use **git** for installation.  

.. code-block:: sh
    
    # create a virtual environment named DEPF
    conda create -n DEPF    
    # activate the environment       
    conda activate DEPF   
    # install R enviroment
    conda install -c conda-forge r-base=4.1.3
    conda install -c conda-forge r-devtools
    conda install -c conda-forge r-seurat
    conda install python=3.9
    pip install leidenalg
    # install MATLAB according to the official website tutorial
    # clone DEPF repository                  
    git clone https://github.com/fanyi21/DEPF.git
    # # install the dependencies
    cd DEPF/DEPF/HierarchicalAutoencoder/
    Rscript RequirePackage.R