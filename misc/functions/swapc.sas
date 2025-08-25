/*** HELP START ***//*

Swap character scalars

*//*** HELP END ***/

subroutine swapc(x $, y $);
    outargs x, y;
    length t $32767;
    t = x; 
    x = y; 
    y = t;
  endsub;
