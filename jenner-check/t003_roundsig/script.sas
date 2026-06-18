/* Bundle: t003_roundsig
 * Source: misc/macros/roundsig.sas  (PharmaForest/misc)
 * Exercises the %roundSig() expression macro, which rounds a value to a given
 * number of significant digits. The macro definition below is the package's
 * roundsig.sas verbatim. The four input values are the exact examples
 * documented in the package README (1.234 -> 1.23, 12.34 -> 12.3,
 * 123.4 -> 123, 1234 -> 1230 at Sig=3).
 */

%macro roundSig(trgVal=,Sig=3);
round(&trgVal., 10**(floor(log10(abs(&trgVal.))) - (&Sig.-1)))
%mend roundSig;

data sig;
  input raw;
  res = %roundSig(trgVal=raw, Sig=3);
  put raw= res=;
  datalines;
1.234
12.34
123.4
1234
;
run;

proc print data=sig; run;
