/*** HELP START ***//*

Macro Name:     line_swatch

  Purpose:
    Generate a visual swatch of line patterns available in SAS (pattern numbers 1?46).

  Usage Example:
    %line_swatch();

  Author:          Yutaka Morioka
  Created:         2025-10-27

*//*** HELP END ***/

%macro line_swatch();
data line_swatch;
length pattern_no 8.  pattern_name $200.;
do pattern_no = 1 to 46;
 select(pattern_no);
  when(1) pattern_name="Solid" ; 
  when(2) pattern_name="ShortDash" ; 
  when(4) pattern_name="MediumDash"; 
  when(5) pattern_name="LongDash"; 
  when(8) pattern_name="MediumDashShortDash"; 
  when(14) pattern_name="DashDashDot"; 
  when(15) pattern_name="DashDotDot"; 
  when(20) pattern_name="Dash"; 
  when(26) pattern_name="LongDashShortDash"; 
  when(34) pattern_name="Dot"; 
  when(35) pattern_name="ThinDot"; 
  when(41) pattern_name="ShortDashDot"; 
  when(42) pattern_name="MediumDashDotDot"; 
  otherwise call missing(pattern_name);
  end;
 pattern_name = catx(" , ",pattern_no,pattern_name);
 x=1;
 output;
 call missing(pattern_name);
 x=0;
 output;
end;
run;

ods graphics / attrpriority=none;
proc sgplot data=line_swatch noautolegend;
where pattern_no in (1:23);
styleattrs datalinepatterns=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23);
series x=x y=pattern_no /datalabelattrs=(size=12) datalabelpos=right lineattrs=(color=black thickness=2) group=pattern_no datalabel=pattern_name;
xaxis display=none offsetmax=0.35;
yaxis display=none reverse ;
run;
proc sgplot data=line_swatch noautolegend;
where pattern_no in (24:46);
styleattrs datalinepatterns=(24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46);
series x=x y=pattern_no /datalabelattrs=(size=12) datalabelpos=right lineattrs=(color=black thickness=2) group=pattern_no datalabel=pattern_name;
xaxis display=none offsetmax=0.35;
yaxis display=none reverse ;
run;
ods graphics  /  reset=all;
%mend;
