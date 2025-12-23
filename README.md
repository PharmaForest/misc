# misc (latest version 0.0.7 on 23December2025)
A SAS package to place miscellaneous macros, functions, etc.  
<img src="./misc_logo_small.png" width="250"/>


The repo will be collaborative work.  

## %xpt2sas() macro  
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

## %minimize_charlen() macro
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

## %roundsig(), %rounddec() macro
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

## %color_swatch() macro
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

## swapn(x, y) routine
Swap numeric scalars
~~~sas
data _null_;
  a = 1; b = 2;
  put 'Before: ' a= b=;
  call swapn(a, b);
  put 'After : ' a= b=;
run;
~~~
<img width="160" height="48" alt="Image" src="https://github.com/user-attachments/assets/ff92d936-5a78-4f42-87cb-70e966cfe891" />  

## swapc(x, y) routine
Swap character scalars
~~~sas
data _null_;
  length s t $10;
  s = 'foo'; t = 'bar';
  put 'Before: ' s= t=;
  call swapc(s, t);
  put 'After : ' s= t=;
run;
~~~
<img width="188" height="42" alt="Image" src="https://github.com/user-attachments/assets/76977286-af43-4cdc-a45e-9f77f871a2bd" />

Author: Yutaka Morioka  
Date: 2025-08-26  
Version: 0.1  

## swapn_vec(x, y) routine
Swap numeric arrays (must have the same dimension)
~~~sas
data _null_;
  array x[3] x1-x3 (1 2 3);
  array y[3] y1-y3 (10 20 30);
  put 'Before X: ' x1= x2= x3= / 'Before Y: ' y1= y2= y3=;
  call swapn_vec(x, y);
  put 'After  X: ' x1= x2= x3= / 'After  Y: ' y1= y2= y3=;
run;
~~~
<img width="262" height="80" alt="Image" src="https://github.com/user-attachments/assets/5470d644-fecc-48d3-9180-6852e1a48cf7" />

Author: Yutaka Morioka  
Date: 2025-08-26  
Version: 0.1  

## swapc_vec(x, y) routine
Swap character arrays (must have the same dimension)
~~~sas
data _null_;
  length a1-a3 b1-b3 $10;
  array a[3] a1-a3 ('AAA' 'BBB' 'CCC');
  array b[3] b1-b3 ('XXX' 'YYY' 'ZZZ');
  put 'Before A: ' a1= a2= a3= / 'Before B: ' b1= b2= b3=;
  call swapc_vec(a, b);
  put 'After  A: ' a1= a2= a3= / 'After  B: ' b1= b2= b3=;
run;
~~~
<img width="286" height="80" alt="Image" src="https://github.com/user-attachments/assets/6d3f230e-b693-4478-94ac-5b1d124d74d8" />

Author: Yutaka Morioka  
Date: 2025-08-26  
Version: 0.1  

## `%view_swatch()` macro 
  Purpose:  
    Display a comprehensive list of SAS DICTIONARY tables and corresponding SASHELP views, along with short descriptions for each.    
    This macro serves as a quick reference or lookup guide to understand the relationship  between SQL-accessible DICTIONARY tables and their SASHELP counterparts.  

  Usage Example:  
  ~~~sas
    %view_swatch();
  ~~~

<img width="484" height="396" alt="Image" src="https://github.com/user-attachments/assets/7607ee5a-067b-43ce-949c-7dc126b496e7" />

Author: Yutaka Morioka  
Date: 2025-10-27  
Version: 0.1  
  
---

 
## `%line_swatch()` macro 
Purpose:  
    Generate a visual swatch of line patterns available in SAS (pattern numbers 1 - 46).  

  Usage Example:  
  ~~~sas
    %line_swatch();
  ~~~
<img width="391" height="290" alt="Image" src="https://github.com/user-attachments/assets/fbb0e2d9-4c2b-45cf-8fae-069a2f28093a" />  
  
<img width="389" height="292" alt="Image" src="https://github.com/user-attachments/assets/d17a834a-43f2-4938-9eb0-6f43602c4efb" />  

Author: Yutaka Morioka  
Date: 2025-10-27  
Version: 0.1  
  
---

## `%symbol_swatch()` macro <a name="symbolswatch-macros-10"></a> ######
  Purpose:  
    Generate a visual swatch of marker symbol patterns available in SAS  

  Usage Example:  
  ~~~sas
    %symbol_swatch();
 ~~~

<img width="391" height="295" alt="Image" src="https://github.com/user-attachments/assets/cab35215-5c3e-4a26-9c66-83929ec69d96" />

Author: Yutaka Morioka  
Date: 2025-10-27  
Version: 0.1  

## `%symbol_swatch()` macro <a name="symbolswatch-macros-10"></a> ######
This macro is based on the SAS macros referenced from Saikrishnareddy Yengannagari’s sdtm-epoch repository
(https://github.com/kusy2009/sdtm-epoch).  
The original repository provides SDTM EPOCH derivation implementations in three languages: SAS, R, and Python.
For full details and the complete implementations, please refer to the original repository.  

  Purpose:    This macro derives the EPOCH variable for SDTM datasets by analyzing  
              subject event records from the SE (Subject Elements) domain. It handles  
              ISO 8601 date/datetime formats with varying precision and supports  
              edge case handling for dates falling outside the SE date ranges.  

  Parameters:    
  ~~~text
 @param[in]   sdtm_in     Input SDTM dataset (required)
 @param[out]  sdtm_out    Output dataset name (required)
 @param[in]   ref_var     Reference date/datetime variable in sdtm_in (required).
                          Should be ISO 8601 format (e.g., RFSTDTC, AESTDTC)
 @param[in]   handle_edge Handle dates outside SE range (default: N)
                          - Y: assign first/last epoch for out-of-range dates
                              (Use with caution - SDTM IG recommends null for pre-study records)
                          - N: leave EPOCH missing for out-of-range dates (SDTM IG compliant)
  ~~~~
 @note        This macro expects the SE (Subject Elements) dataset to be present
              in the SDTM library as sdtm.se before calling this macro.  
 @note        SE domain must contain: USUBJID, SESTDY, SEENDY, SESTDTC, SEENDTC,
              EPOCH, TAETORD  
 @note        Missing SEENDTC on non-terminal records is imputed from next SESTDTC  
 @note        Datetime comparison uses full precision when time component exists  
 @note        Boundary overlap handling: When a date falls on the boundary between two epochs  
              (e.g., SEENDTC of one epoch equals SESTDTC of next), the later epoch is assigned based on the tightest SESTDTC match)  
 @note        Per SDTM IG: For Findings, use --DTC as ref_var; for Interventions/Events, use --STDTC  
 @note        Per SDTM IG: Pre-study records (before subject participation) should have null EPOCH.  
              Use handle_edge=N (default) to comply with this guidance.  
   
  ~~~sas
   // Derive EPOCH for AE domain using AESTDTC (Interventions/Events use --STDTC)
   %derive_epoch(
       sdtm_in   = sdtm.ae,
       sdtm_out  = ae_with_epoch,
       ref_var   = aestdtc
   );

   // Derive EPOCH for VS domain using VSDTC (Findings use --DTC)
   %derive_epoch(
       sdtm_in    = sdtm.vs,
       sdtm_out   = vs_with_epoch,
       ref_var    = vsdtc
   );

   // With edge case handling enabled (use with caution)
   %derive_epoch(
       sdtm_in     = sdtm.lb,
       sdtm_out    = lb_with_epoch,
       ref_var     = lbdtc,
       handle_edge = Y
   );
 ~~~


Author: Saikrishnareddy Yengannagari  
Date: 2025-12-23  
Version: 1.0  



## Version history
0.0.6(27October2025) : Add view_swatch, line_swatch, symbol_swatch   
0.0.5(26August2025) : Add swapn routine, swapc routine, swapn_vec routine, swapc_vec routine   
0.0.4(23July2025)	: Add %color_swatch   
0.0.3(03July2025)	: Add %rounddec, roundsig  
0.0.2(02July2025)	: Add %minimize_charlen  
0.0.1(28June2025)	: Initial version 　<br>


---

## What is SAS Packages?

The package is built on top of **SAS Packages Framework(SPF)** developed by Bartosz Jablonski.

For more information about the framework, see [SAS Packages Framework](https://github.com/yabwon/SAS_PACKAGES).

You can also find more SAS Packages (SASPacs) in the [SAS Packages Archive(SASPAC)](https://github.com/SASPAC).

## How to use SAS Packages? (quick start)

### 1. Set-up SAS Packages Framework

First, create a directory for your packages and assign a `packages` fileref to it.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sas
filename packages "\path\to\your\packages";
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Secondly, enable the SAS Packages Framework.
(If you don't have SAS Packages Framework installed, follow the instruction in 
[SPF documentation](https://github.com/yabwon/SAS_PACKAGES/tree/main/SPF/Documentation) 
to install SAS Packages Framework.)

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sas
%include packages(SPFinit.sas)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


### 2. Install SAS package

Install SAS package you want to use with the SPF's `%installPackage()` macro.

- For packages located in **SAS Packages Archive(SASPAC)** run:
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sas
  %installPackage(packageName)
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- For packages located in **PharmaForest** run:
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sas
  %installPackage(packageName, mirror=PharmaForest)
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- For packages located at some network location run:
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sas
  %installPackage(packageName, sourcePath=https://some/internet/location/for/packages)
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  (e.g. `%installPackage(ABC, sourcePath=https://github.com/SomeRepo/ABC/raw/main/)`)


### 3. Load SAS package

Load SAS package you want to use with the SPF's `%loadPackage()` macro.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sas
%loadPackage(packageName)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


### Enjoy!

---
