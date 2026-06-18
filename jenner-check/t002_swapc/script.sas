/* Bundle: t002_swapc
 * Source: misc/functions/swapc.sas  (PharmaForest/misc)
 * Exercises the swapc() FCMP subroutine - swaps two character scalars in place
 * via OUTARGS. The subroutine definition below is the package's swapc.sas
 * verbatim; the DATA _null_ caller is the README's documented usage example.
 */

proc fcmp outlib=work.funcs.misc;
  subroutine swapc(x $, y $);
    outargs x, y;
    length t $32767;
    t = x;
    x = y;
    y = t;
  endsub;
run;

options cmplib=work.funcs;

data _null_;
  length s t $10;
  s = 'foo'; t = 'bar';
  put 'Before: ' s= t=;
  call swapc(s, t);
  put 'After : ' s= t=;
run;
