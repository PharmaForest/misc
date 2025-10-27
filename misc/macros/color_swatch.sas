/*** HELP START ***//*

Program:     color_swatch.sas
Macro:       %color_swatch
Description:
This macro retrieves SAS color definitions from the system registry
(COLORNAMES section) and generates a visual color swatch table using
PROC REPORT. Each row displays the color name, its hexadecimal code,
and a cell shaded with the corresponding color.
Purpose:
- Extract color name and hex values from SAS registry
- Display each color with its background for visual reference
- Useful for selecting and verifying colors for reports and graphics
Input:
- None ()
Output:
- A report with three columns:
1. Color name
2. HEX code
3. A dummy column colored with the respective color
Usage:
%color_swatch();
Author:      [Yutaka Morioka]
License: MIT

*//*** HELP END ***/

%macro color_swatch();
filename tempf temp;
proc registry list export= tempf
usesashelp
startat='COLORNAMES' ;
run;
data __color_list;
infile tempf truncover;
input text $ 1-100 ;
color=compress(scan(text,1,"="),'"');
hex=scan(text,2,"=");
if _N_>=8;
dummy="";
keep color hex dummy;
run;
proc report data=__color_list nowd;
column color hex dummy;
compute dummy;
call define(_col_,'style','style={background='||color||'}');
endcomp;
run;
filename tempf clear;
%mend;
