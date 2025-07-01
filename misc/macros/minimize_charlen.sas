/*** HELP START ***/
/*
`%minimize_charlen` is a macro to minimize the length of character variables 
based on actual data values.

### Parameters
  - `ds` : dataset name (without libref; defaults to `WORK` if no libref specified)
  - `inlib =` : input library name (default: `WORK`)
  - `outlib = ` : output library name (default: `WORK`)

### Sample code

~~~sas
%minimize_charlen(dm)
~~~
~~~sas
%minimize_charlen(class, inlib=sashelp, outlib=work)
~~~

### Notes
- The macro analyzes all character variables in the specified dataset,
  determines the maximum length actually used, and alters the table to adjust
  each variable's length accordingly.
- If `inlib` and `outlib` are different, the input dataset is copied before adjustment.
- If the dataset has 0 observations, the macro will print a warning and do nothing.

*//*** HELP END ***/
%macro minimize_charlen(ds,inlib=WORK,outlib=WORK);
 data _null_;
    if 0 then set &inlib..&ds nobs=nobs;
    call symputx('n', nobs,"L");
    stop;
  run;

  %if &n = 0 %then %do;
    %put WARNING: The dataset &ds. has 0 observations. Length adjustment based on actual values cannot be performed.;
    %return;
  %end;
  %else %do; 
  	data _null_;
  	length var $200. maxlength 8.;
  	set &inlib..&ds. end=eof;
  	array cha _character_;
  	if _N_ = 1 then do;
  	 call missing(var,maxlength);
  	 declare hash h1();
  	  h1.definekey('var');
  	  h1.definedata('var','maxlength');
  	  h1.definedone();
  	 do over cha;
  	  var = vname(cha);
  	  maxlength = 0;
  	  h1.add();
  	 end;
  	end;
  	do over cha;
  	  var = vname(cha);
  	  if h1.find() = 0 & length(cha) > maxlength then do;
  	   maxlength=length(cha);
  	   h1.replace();
  	  end;
  	 end;
  	if eof then do;
  	 h1.remove(key:'var');
  	 h1.output(dataset:'__len');
  	end;
  	run;

    %if &inlib ne &outlib %then %do;
        proc copy inlib = &inlib outlib =  &outlib;
          select &ds;
        run;
    %end;

  	data _null_;
  	  set __len end=eof;
  	  if _N_=1 then call execute("proc sql;alter table &outlib..&ds. modify");
  	  code=catx(" ",var,cats("char(",maxlength,")"));
  	  if ^eof then code=cats(code,",");
  	  call execute(code);
  	  if eof then call execute(";quit;");
  	run;

    proc delete data=__len;
    run;
  %end;
%mend ;
