/*** HELP START ***//*

Swap numeric arrays (must have the same dimension)

*//*** HELP END ***/

subroutine swapn_vec(x[*], y[*]);
    outargs x, y;
    if dim(x) ne dim(y) then do;
      put "ERROR: swapn_vec: array sizes differ." ;
      return;
    end;
    do i = 1 to dim(x);
      tmp = x[i];
      x[i] = y[i];
      y[i] = tmp;
    end;
  endsub;
