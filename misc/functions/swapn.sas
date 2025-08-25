/*** HELP START ***//*

Swap numeric scalars

*//*** HELP END ***/

subroutine swapn(x, y);
    outargs x, y;
    t = x; 
    x = y; 
    y = t;
  endsub;
