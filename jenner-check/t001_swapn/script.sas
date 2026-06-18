/* Bundle: t001_swapn
 * Source: misc/functions/swapn.sas  (PharmaForest/misc)
 * Exercises the swapn() FCMP subroutine - swaps two numeric scalars in place
 * via OUTARGS. The subroutine definition below is the package's swapn.sas
 * verbatim; the DATA _null_ caller is the README's documented usage example.
 */

proc fcmp outlib=work.funcs.misc;
  subroutine swapn(x, y);
    outargs x, y;
    t = x;
    x = y;
    y = t;
  endsub;
run;

options cmplib=work.funcs;

data _null_;
  a = 1; b = 2;
  put 'Before: ' a= b=;
  call swapn(a, b);
  put 'After : ' a= b=;
run;
