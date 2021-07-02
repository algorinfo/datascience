# :satellite: Datascience stack

This repo has as objective reduce the startup time for a prototype or EDA analysis. 

Some common libraries installed:

- Jupyter Lab
- Bokeh 
- gensim
- scikit-learn
- Pandas
- Dask
- S3 support with fsspect or boto3 library.

For more details look at [pyproject.toml](pyproject.toml) or [requirements.txt](requirements.txt)


## FAQ

### How to use

This project could be used as least in two ways:

1. download and run the docker image from [nuxion/datascience](https://hub.docker.com/repository/docker/nuxion/python)

```
docker run --rm -p 127.0.0.1:8888:8889 nuxion/datascience
```

Mounting a dir to keep state:

```
docker run --rm -p 127.0.0.1:8888:8889 -v <your_dir>:/app/notebooks nuxion/datascience
```


2. clone/fork this repo and run by your own.

The entrypoint of the project is the jupyter lab environment but some batch task could run, dask and papermill are provided as dependencies for that purpose. Also, dask could be used inside the jupyter lab environment if some dataset is to big.

Be warned that is not secure to expose this service to the world, so be carefull. By default if you use `make run`, docker only will be listening in your localhost interface. 


### What is the password for Jupyter lab and how could I change that?

The password by default is `changeme`, you can change that from [jupyter_conf](conf/jupyter_lab_config.py):

```python
#  To generate, type in a python/IPython shell:
# 
#    from jupyter_server.auth import passwd; passwd()
# 
#  The string should be of the form type:salt:hashed-password.
#  Default: ''
c.ServerApp.password = 'argon2:$argon2id$v=19$m=10240,t=10,p=8$IzweiP2xT1dI2D65ElHBDw$q52+kB/xVzK5F4/j4ZunBw'
```

Please, read the instructions 

### Other ways to be used ?

You can also clone or download from releases the code and install manually the depencies using [poetry](https://python-poetry.org/) or pip if docker is not your use case. 

In Windows a [conda environment](https://docs.conda.io/en/latest/) could be a better approach.

### Interoperability and compability

The data stack world of python move fast. Deprecation warnings are allways attended by me when possible. Part of the intention of this image is to be sure of the dependencies. Some features like dask, depends on each node version of the libs installed there if not dask will not work. And other libraries like pandas, deprecate ways of do some things like: groupby and so forth. 

Related to the python version:
As a rule thumb I stay two versions behind of the last release. The last python version is `~3.10`, then I use `~3.8`

Pandas pinned to version 1.2.5 [(june 22, 2021)](https://pandas.pydata.org/pandas-docs/stable/whatsnew/v1.2.5.html).

### Why warning are raised when I run docker build

Because all the python dependencies are installed in a intermediate image as root and then the packages downloaded or built in that image are copied to the final image with the correct user permissions, but `pip` warns about this first install as root. 

In this way if I change some code without adding or removing dependencies, then when I rebuilt the image I will not compile again each dependecy.

Look at [use mult-stage build](https://docs.docker.com/develop/develop-images/multistage-build/) for more information. 

## Some random features

- spacy small spanish corpus download inside of the docker image, look at `Dockerfile`, more models could be added.

## TODO

- Evaluates [Intake project](https://github.com/intake/intake) for datasources or a custom solution using smartopen or fsspec (used by Intake and Kedro projects)
- Add are easy way to get models like fastext.
