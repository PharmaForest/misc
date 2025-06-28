/*** HELP START ***//*

`%xpt2sas` is a macro to convert xpt files into sas7bdat files.

### Parameters
	- `indir` : full path for directory with xpt files

	- `outdir` : full path for directory where sas7bdat files will be output

### Sample code

~~~sas
%xpt2sas(
	indir=C:\place\for\xpts,
	outdir=C:\place\for\sas7bdat
)
~~~

### Notes
- All of xpt files are converted to sas7bdat files

*//*** HELP END ***/

%macro xpt2sas(indir=, outdir=) ;

/*check --- start*/
%if %length(&indir.) = 0 %then %do;
    %put ERROR: You must specify the indir (in directory) with xpt files.;
    %return;
%end;
%if %length(&outdir.) = 0 %then %do;
    %put ERROR: You must specify the outdir (out directory) for sas7bdat files to be created.;
    %return;
%end;

filename xpt_dir "&indir." ;
filename sas_dir "&outdir." ;

data _null_ ;
	did = dopen("xpt_dir") ;
	call symputx('in_did', did) ;
	rc = dclose(did) ;
run ;
%if &in_did. = 0 %then %do ;
	%put ERROR: The directory specified in indir does not exist: &inddir. ;
	%return;
%end;
data _null_ ;
	did = dopen("sas_dir") ;
	call symputx('out_did', did) ;
	rc = dclose(did) ;
run ;
%if &out_did. = 0 %then %do ;
	%put ERROR: The directory specified in outdir does not exist: &outdir. ;
	%return;
%end;

/*check --- end*/

data work._tmp01 ;
	length  VAR  $400 ;
    *** open directory ;
    did = dopen("xpt_dir") ;
	call symput("did", did) ; /*to stop macro*/
	if did ne 0 then do ;
	   *** store all file and folder names into variables ;
	    do i = 1 to dnum( did ) ;/*dnum=number of files and folders*/
	        VAR = dread( did , i ) ;/*dread=reading files and folders*/
	        output ;
	    end;
	end ;
	rc = dclose(did) ;
run;
%if &did. = 0 %then %do ;
	%put ERROR: Cannot open directory &indir. ;
	%return ;
%end ;

data work._tmp02 ;
	set work._tmp01 ;
	aa=length(VAR) ;
	if length(VAR) > 4 and lowcase(scan(VAR, -1, '.')) = "xpt" then flag=1 ; /*last 4 letters=".xpt"*/
	if flag=1 then VARNM=substr(trim(left(VAR)),1,aa-4) ; /*file name(wo extension)*/
	if flag=1 ;/*subset to xpt files*/
run ;
proc sql noprint;
  select count(*) into :maxn from work._tmp02; /*number of xpt files*/
quit;

/*copy xpt files to sas7bdat files*/

libname sas_out "&outdir." ;
%do i=1 %to &maxn. ;
	data _null_ ;
		set work._tmp02 ;
		if _N_=&i. ;
		call symput("file_name",trim(left(VARNM))) ;
	run ;

	libname xpt_in xport "&indir.\&file_name..xpt" ;

	proc copy in=xpt_in out=sas_out ;
	run ;
	libname xpt_in clear ;
%end ;
libname sas_out clear ;

proc datasets library=work nolist ;
	delete _tmp01 _tmp02 ;
run ; quit ;

%put NOTE: Completed xpt to sas7bdat ;

%mend ;
