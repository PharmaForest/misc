/*** HELP START ***//*

* MACRO NAME: rounrdDec
*
* PURPOSE:
*   
*   Rounds a numeric variable to the specified number of decimal places and 
*   converts it to a character variable.
*
* PARAMETERS:
*   trgVal     : (Required) The target variable.
*   dec        : (Required) Number of decimal places. 
*
* USAGE:
*   %rounrdDec(trgVal=RES,dec=1);
*
* NOTES:
*   - Only integer values can be assigned to the "dec" parameter. 
*   - For example, if set to "3", "1.234" convert to "1.23".

*//*** HELP END ***/

%macro roundDec(trgVal=,dec=);
  putn(round(&trgVal.,input(cats("1e-",&dec.),best.)),catt("16.",&dec.," -L"))
%mend  roundDec;


