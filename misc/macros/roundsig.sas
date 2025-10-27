/*** HELP START ***//*

* MACRO NAME: roundSig
*
* PURPOSE:
*   This macro performs rounding based on the specified number of
*   significant digits.
*
* PARAMETERS:
*   trgVal     : (Required) The target Value.
*   SIG        : (Required) Number of significant digits.
*
* USAGE:
*   %roundSig(trgVal=RES,Sig=3);
*
* NOTES:
*   - Only integer values can be assigned to the "Sig" parameter.
*   - For example, if set to "3",
*     "1.234" becomes "1.23",
*     "12.34" becomes "12.3",
*     "12.34" becomes "12.3",
*     "123.4" becomes "123",
*     "1234"  becomes "1230".
*

*//*** HELP END ***/

%macro roundSig(trgVal=,Sig=3);
round(&trgVal., 10**(floor(log10(abs(&trgVal.))) - (&Sig.-1)))
%mend roundSig;
