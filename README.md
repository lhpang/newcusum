# newcusum

`newcusum` is an R package for drawing CUSUM plots to monitor a medical center's performance. CUSUM (CUmulative SUMmation) is a real-time monitor for CUmulative SUMmation of risk-adjusted survival outcomes. We provide O-E CUSUM and one-sided CUSUM plots. Users can tell the signal points indicating the center's performance is "better than expected" or "worse than expected" from the resulting plots.


# Introduction
In order to continuously monitor a medical center's performance, a real-time monitor that we term O-E CUSUM, for CUmulative SUMmation of risk-adjusted Observed-Expected (O-E) number of events, is developed based on the sequential probability ratio test (SPRT). The O-E CUSUM plots show the facilities' risk adjusted O-E with monitoring bands over time, and a center's performance and the two-way flagging results can be read from this simple plot. Simultaneous use of two one-sided CUSUMs can also achieve the same goal but with awkward interpretation. 

Current versions of mortality CUSUM don't have user-friendly interpretations. As a result, users may not be clear about the interpretation of the plot and what kind of plot to choose for their goals. We improve this by providing detailed interpretations of different types of CUSUM. And we provide detailed information regarding with the restart option and risk-adjust option to help them customize the plot.

Another problem of the current CUSUM package is that it only includes tabular one-sided CUSUM or O-E CUSUM. Users may suffer from switching between different packages. As a result, the pattern of the plots are not consistent and may cause confusion when further presented. To fix this problem, we include both of them in the package. Users can choose between them based on their needs.

## Models:
<table>
    <tr>
        <th>Model</th>
        <th>Description</th>
        <th>Example</th>
    </tr>
    <tr>
        <td>mortality CUSUM</td>
        <td>
        CUSUM monitor in mortality setting <a href="#references">[1]</a>.
        </td>
        <td><a href="https://um-kevinhe.github.io/surtvep/articles/surtvep.html#model-fitting">tutorial</a></td>
    </tr>
      <tr>
        <td>binary CUSUM</td>
        <td>
        CUSUM monitor in binary setting <a href="#references">[2]</a>.
        </td>
        <td><a href="https://um-kevinhe.github.io/surtvep/articles/surtvep.html#model-fitting">tutorial</a></td>
    </tr>
</table>

## Methods:

<table>
    <tr>
        <th>Method</th>
        <th>Description</th>
        <th>Example</th>
    </tr>
    <tr>
        <td>O-E CUSUM</td>
        <td>
        drawing O-E CUSUM plots for center performance monitor <a href="#references">[1]</a>.
        </td>
        <td><a href="https://um-kevinhe.github.io/surtvep/articles/surtvep.html#model-fitting">tutorial</a></td>
    </tr>
      <tr>
        <td>tabular one-sided CUSUM</td>
        <td>
        drawing one-sided CUSUM plots for center performance monitor <a href="#references">[2]</a>.
        </td>
        <td><a href="https://um-kevinhe.github.io/surtvep/articles/surtvep.html#model-fitting">tutorial</a></td>
    </tr>
</table>

## detailed plots customization options:
<table>
    <tr>
        <th>Method</th>
        <th>Description</th>
        <th>Example</th>
    </tr>
    <tr>
        <td>interpret</td>
        <td>
        An option providing users with different kinds of interpretations  <a href="#references">[1]</a>.
        </td>
        <td><a href="https://um-kevinhe.github.io/surtvep/articles/surtvep.html#model-fitting">tutorial</a></td>
    </tr>
    <tr>
        <td>restart</td>
        <td>
        An option providing users with different kinds of restart after signal   <a href="#references">[1]</a>.
        </td>
        <td><a href="https://um-kevinhe.github.io/surtvep/articles/surtvep.html#model-fitting">tutorial</a></td>
    </tr>
    <tr>
        <td>risk-adjust</td>
        <td>
        An option for users to customize the risk-adjusted score  <a href="#references">[1]</a>.
        </td>
        <td><a href="https://um-kevinhe.github.io/surtvep/articles/surtvep.html#model-fitting">tutorial</a></td>
    </tr>
</table>


## Usage:

Here, we are using the Simulation study included in our packages as an example

    library(newcusum)

    #Load Simulation study
    data = sim_data
    limit = sim_limit
    
    #Fit the model(create the O-E CUSUM plot or one-sided CUSUM plot)

    fit <- mortality.CUSUM(style="O_E.CUSUM", limit=limit, restart="reset",interpret="plain",data=data)
    plot(fit)

# Datasets
The SUPPORT dataset is available in the "mortality.CUSUM" package. The following code will load the dataset in the form of a dataframe

    data("example")

## Simulated Datasets:

<table>
    <tr>
        <th>Dataset</th>
        <th>Size</th>
        <th>Dataset</th>
        <!-- <th>Data source</th> -->
    </tr>
    <tr>
        <td>in control</td>
        <td>2000</td>
        <td>
        A simulated data set simulating an in control case (year mortality rate 0.1).
        </td>
        <!-- <td><a href="https://github.com/havakv/pycox/blob/master/pycox/simulations/relative_risk.py">simulN2kOP2Continuous</a> -->
    </tr>
    <tr>
        <td>out of control</td>
        <td>2000</td>
        <td>
        A simulated data set simulating an out of control case (year mortality rate 0.3).
        </td>
        <!-- <td><a href="https://github.com/havakv/pycox/tree/master/pycox/simulations/discrete_logit_hazard.py">simulN2kOP2Binary</a> -->
    </tr>
</table>


## Real Datasets:
<table>
    <tr>
        <th>Dataset</th>
        <th>Size</th>
        <th>Dataset</th>
        <th>Data source</th>
    </tr>
    <tr>
        <td> SEER Colon Cancer Data</td>
        <td></td>
        <td>
        Patients diagnosed at 66 years of age or older between 1994 and 2005 with colon cancer and comorbidity scores for stage III colon cancer who had surgery from the SEER 13 registries (except Alaska) and the state of California. 
        <a href="https://um-kevinhe.github.io/surtvep/articles/surtvep.html#model-fitting">tutorial</a></td> for preprocessing.
        </td>
        <td><a href="https://biostat.app.vumc.org/wiki/Main/SupportDesc">source</a>
    </tr>
</table>


## Installation

You can install the development version of mypackage from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("lhpang/newcusum")
```
# Detailed tutorial
# Getting Help
# References
