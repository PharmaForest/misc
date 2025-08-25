/*** HELP START ***//*

Swap character arrays (must have the same dimension)

*//*** HELP END ***/

subroutine swapc_vec(x[*] $, y[*] $);
    outargs x, y;
    if dim(x) ne dim(y) then do;
      put "ERROR: swapc_vec: array sizes differ.";
      return;
    end;
    length tmp $32767;
    do i = 1 to dim(x);
      tmp = x[i];
      x[i] = y[i];
      y[i] = tmp;
    end;
  endsub;
