# misc
A SAS package to place miscellaneous macros, functions, etc.  
![misc](./misc_logo_small.png)   

The repo will be collaborative work.  

## %xpt2sas  
Purpose:     This macro converts xpt files into sas7bdat files.  

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
