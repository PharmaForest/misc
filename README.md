# misc (latest version 0.0.4 on 23July2025)
A SAS package to place miscellaneous macros, functions, etc.  
<img src="./misc_logo_small.png" width="250"/>


The repo will be collaborative work.  

## %xpt2sas  
Purpose:     This macro converts xpt files in the folder into sas7bdat files.  

Sample code:  

~~~sas  
%xpt2sas(
	indir=C:\place\for\xpt,		/* Directory with xpt files */
	outdir=C:\place\for\sas7bdat	/* Directory for sas7bdat files */
 )
~~~  

Author: Ryo Nakaya  
Date: 2025-06-28  
Version: 0.1  

## %minimize_charlen
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

## %roundsig, %rounddec
Purpose:     roundsig:This macro performs rounding based on the specified number of significant digits.. rounddec:Rounds a numeric variable to the specified number of decimal places and converts it to a character variable.


~~~sas
%roundSig(trgVal=RES,Sig=3);

/*Only integer values can be assigned to the "Sig" parameter.
For example, if set to "3",
"1.234" becomes "1.23", 
"12.34" becomes "12.3", 
"12.34" becomes "12.3", 
"123.4" becomes "123", 
"1234"  becomes "1230".*/
~~~
~~~sas
%roundDec(trgVal=RES,dec=1);
~~~

Author: Hiroki Yamanobe  
Date: 2025-07-03  
Version: 0.3  

## %color_swatch
 Description:
     This macro retrieves SAS color definitions from the system registry 
     (COLORNAMES section) and generates a visual color swatch table using 
     PROC REPORT. Each row displays the color name, its hexadecimal code, 
     and a cell shaded with the corresponding color.

 Purpose:
     - Extract color name and hex values from SAS registry
     - Display each color with its background for visual reference
     - Useful for selecting and verifying colors for reports and graphics  

Note: The color sample will not be displayed unless ODS HTML is turned on.　　
     
Sample code:  
~~~sas
%color_swatch()
~~~
<img width="220" height="377" alt="Image" src="https://github.com/user-attachments/assets/e886674b-ce4e-404b-aaef-940deda8b950" />  


Author: Yutaka Morioka  
Date: 2025-07-23  
Version: 0.1  

## Version history
0.0.4(23July2025)	: Add %color_swatch   
0.0.3(03July2025)	: Add %rounddec, roundsig  
0.0.2(02July2025)	: Add %minimize_charlen  
0.0.1(28June2025)	: Initial version 　<br>


## What is SAS Packages?
The package is built on top of **SAS Packages framework(SPF)** developed by Bartosz Jablonski.  
For more information about SAS Packages framework, see [SAS_PACKAGES](https://github.com/yabwon/SAS_PACKAGES).  
You can also find more SAS Packages(SASPACs) in [SASPAC](https://github.com/SASPAC).

## How to use SAS Packages? (quick start)
### 1. Set-up SPF(SAS Packages Framework)
Firstly, create directory for your packages and assign a fileref to it.
~~~sas      
filename packages "\path\to\your\packages";
~~~
Secondly, enable the SAS Packages Framework.  
(If you don't have SAS Packages Framework installed, follow the instruction in [SPF documentation](https://github.com/yabwon/SAS_PACKAGES/tree/main/SPF/Documentation) to install SAS Packages Framework.)  
~~~sas      
%include packages(SPFinit.sas)
~~~  
### 2. Install SAS package  
Install SAS package you want to use using %installPackage() in SPFinit.sas.
~~~sas      
%installPackage(packagename, sourcePath=\github\path\for\packagename)
~~~
(e.g. %installPackage(ABC, sourcePath=https://github.com/XXXXX/ABC/raw/main/))  
### 3. Load SAS package  
Load SAS package you want to use using %loadPackage() in SPFinit.sas.
~~~sas      
%loadPackage(packagename)
~~~
### Enjoy😁
---

