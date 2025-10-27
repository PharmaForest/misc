/*** HELP START ***//*

Macro Name:     symbol_swatch

  Purpose:
    Generate a visual swatch of marker symbol patterns available in SAS

  Usage Example:
    %symbol_swatch();

  Author:          Yutaka Morioka
  Created:         2025-10-27

*//*** HELP END ***/

%macro symbol_swatch();
data symbol_swatch;
length pattern_no 8.  pattern_name $200.;
do pattern_no = 1 to 31;
pattern_name = choosec(pattern_no
,"ArrowDown"
,"Asterisk"
,"Circle"
,"CircleFilled"
,"Diamond"
,"DiamondFilled"
,"GreaterThan"
,"Hash"
,"HomeDown"
,"HomeDownFilled"
,"IBeam"
,"LessThan"
,"Plus"
,"Square"
,"SquareFilled"
,"Star"
,"StarFilled"
,"Tack"
,"Tilde"
,"Triangle"
,"TriangleFilled"
,"TriangleDown"
,"TriangleDownFilled"
,"TriangleLeft"
,"TriangleLeftFilled"
,"TriangleRight"
,"TriangleRightFilled"
,"Union"
,"X"
,"Y"
,"Z"
);
if mod(pattern_no,2)=1 then  x=1;
else x =2;
 output;
end;
run;

ods graphics / attrpriority=none;
proc sgplot data=symbol_swatch noautolegend;
styleattrs datasymbols=(
ArrowDown
Asterisk
Circle
CircleFilled
Diamond
DiamondFilled
GreaterThan
Hash
HomeDown
HomeDownFilled
IBeam
LessThan
Plus
Square
SquareFilled
Star
StarFilled
Tack
Tilde
Triangle
TriangleFilled
TriangleDown
TriangleDownFilled
TriangleLeft
TriangleLeftFilled
TriangleRight
TriangleRightFilled
Union
X
Y
Z
);
scatter x=x y=pattern_no /datalabelattrs=(size=12) datalabelpos=right markerattrs=(color=black size=15) group=pattern_no datalabel=pattern_name;
xaxis display=none offsetmax=0.35;
yaxis display=none reverse ;
run;
ods graphics  /  reset=all;

%mend;
