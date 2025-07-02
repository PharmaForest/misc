# misc
A SAS package to place miscellaneous macros, functions, etc.  
<img src="./misc_logo_small.png" width="250"/>


The repo will be collaborative work.  

## %xpt2sas  
Purpose:     This macro converts xpt files in the folder into sas7bdat files.  

Sample code:  

~~~sas  
%xpt2sas(
	indir=C:\place\for\xpt,   /* Directory with xpt files */
	outdir=C:\place\for\sas7bdat   /* Directory for sas7bdat files */
 )
~~~  

Author: Ryo Nakaya  
Date: 2025-06-28  
Version: 0.1  

## %minimize_charlen.sas
Purpose:     The macro analyzes all character variables in the dataset,  determines the maximum length actually used, and alters the table to adjust each variable's length accordingly.

Sample code:  

~~~sas
%minimize_charlen(dm)
~~~
~~~sas
%minimize_charlen(class, inlib=sashelp, outlib=work)
~~~

Author: Yutaka Morioka  
Date: 2025-07-02  
Version: 0.1  

## Version history
0.0.2(02July2025)	: Add %minimize_charlen.sas  
0.0.1(28June2025)	: Initial version 　<br>


## What is SAS Packages?
Misc is built on top of **SAS Packages framework(SPF)** developed by Bartosz Jablonski.  
For more information about SAS Packages framework, see [SAS_PACKAGES](https://github.com/yabwon/SAS_PACKAGES).  
You can also find more SAS Packages(SASPACs) in [SASPAC](https://github.com/SASPAC).
