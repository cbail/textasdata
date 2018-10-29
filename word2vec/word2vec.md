
<style>
.reveal section p {
  color: black;
  font-size: .7em;
  font-family: 'Helvetica'; #this is the font/color of text in slides
}


.section .reveal .state-background {
    background: white;}
.section .reveal h1,
.section .reveal p {
    color: black;
    position: relative;
    top: 4%;}



</style>


Introduction to Word2Vec
========================================================
author: Chris Bail 
date: Duke University
autosize: true
transition: fade  
  website: https://www.chrisbail.net  
  github: https://github.com/cbail  
  Twitter: https://www.twitter.com/chris_bail

========================================================

# **What is word2vec?**

What is word2vec?
========================================================

<img src="word2vec_simple_vizual.png" height="400" />


What is word2vec?
========================================================

<img src="skip_gram_mikolov.png" height="400" />

========================================================

# **Using the Skip-Gram Model**

Installation
========================================================

We will be using the library `keras`

`keras` uses the TensorFlow backend, so installing this package requires a few more steps than the typical package on CRAN

The following code installs the `keras` package, which comes with a function that will install the TensorFlow dependencies


```r
install.packages("keras")
library(keras)
```

Installation
========================================================

To finish the installation process,


```r
install_keras()
```

Depending on what version of Python you have, this may give you an error. You may need to open your terminal and run the following lines of code:

*Note: If you have to run this code in the terminal, copying and pasting both at the same time will give you an error. You need to run them one by one, as the first line will prompt you to enter your computer user's password*
```
sudo /usr/bin/easy_install pip
sudo /usr/local/bin/pip install --upgrade virtualenv
```

Other packages we need for this example
========================================================

 (You may need to use `install.packages("package")` on some of these first)

```r
library(reticulate)
library(purrr)
library(text2vec) # note that this is a beta version of the package. code/names offuntions that comes from this package may change in future versions
library(dplyr)
library(Rtsne)
library(ggplot2)
library(plotly)
```


Preprocessing
========================================================


```r
load(url("https://cbail.github.io/Elected_Official_Tweets.Rdata"))
     
elected_no_retweets <- elected_official_tweets %>%
  filter(is_retweet == F) %>%
  select(c("screen_name", "text"))

tokenizer <- text_tokenizer(num_words = 20000)
tokenizer %>% fit_text_tokenizer(elected_no_retweets$text)
```


