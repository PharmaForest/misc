/*** HELP START ***//*

@file        derive_epoch.sas
 @brief       Derives the EPOCH variable for SDTM datasets using SE domain
 
 @details     This macro derives the EPOCH variable for SDTM datasets by analyzing
              subject event records from the SE (Subject Elements) domain. It handles
              ISO 8601 date/datetime formats with varying precision and supports
              edge case handling for dates falling outside the SE date ranges.
 
 @param[in]   sdtm_in     Input SDTM dataset (required)
 @param[out]  sdtm_out    Output dataset name (required)
 @param[in]   ref_var     Reference date/datetime variable in sdtm_in (required).
                          Should be ISO 8601 format (e.g., RFSTDTC, AESTDTC)
 @param[in]   handle_edge Handle dates outside SE range (default: N)
                          - Y: assign first/last epoch for out-of-range dates
                              (Use with caution - SDTM IG recommends null for pre-study records)
                          - N: leave EPOCH missing for out-of-range dates (SDTM IG compliant)
 
 @note        This macro expects the SE (Subject Elements) dataset to be present
              in the SDTM library as sdtm.se before calling this macro.
 @note        SE domain must contain: USUBJID, SESTDY, SEENDY, SESTDTC, SEENDTC,
              EPOCH, TAETORD
 @note        Missing SEENDTC on non-terminal records is imputed from next SESTDTC
 @note        Datetime comparison uses full precision when time component exists
 @note        Boundary overlap handling: When a date falls on the boundary between two epochs
              (e.g., SEENDTC of one epoch equals SESTDTC of next), the later epoch is assigned
              based on the tightest SESTDTC match
 @note        Per SDTM IG: For Findings, use --DTC as ref_var; for Interventions/Events, use --STDTC
 @note        Per SDTM IG: Pre-study records (before subject participation) should have null EPOCH.
              Use handle_edge=N (default) to comply with this guidance.
 
 @author      Saikrishnareddy Yengannagari
 @date        20 December 2025
 @version     1.0
 
 @example
 @code
   // Derive EPOCH for AE domain using AESTDTC (Interventions/Events use --STDTC)
   %derive_epoch(
       sdtm_in   = sdtm.ae,
       sdtm_out  = ae_with_epoch,
       ref_var   = aestdtc
   );

   // Derive EPOCH for VS domain using VSDTC (Findings use --DTC)
   %derive_epoch(
       sdtm_in    = sdtm.vs,
       sdtm_out   = vs_with_epoch,
       ref_var    = vsdtc
   );

   // With edge case handling enabled (use with caution)
   %derive_epoch(
       sdtm_in     = sdtm.lb,
       sdtm_out    = lb_with_epoch,
       ref_var     = lbdtc,
       handle_edge = Y
   );
  @endcode
  
  @see         CDISC SDTM Implementation Guide - SE Domain

*//*** HELP END ***/

%macro derive_epoch(
    sdtm_in     = ,
    sdtm_out    = ,
    ref_var     = ,
    handle_edge = N
);

    /*--------------------------------------------------------------------------
    * PARAMETER VALIDATION
    *--------------------------------------------------------------------------*/
    
    %let ref_var = %upcase(%sysfunc(strip(&ref_var.)));
    %let handle_edge = %upcase(%sysfunc(strip(&handle_edge.)));
    
    %if %length(&sdtm_in.) = 0 %then %do;
        %put %str(ER)ROR: [derive_epoch] Parameter SDTM_IN is required.;
        %return;
    %end;
    
    %if %length(&sdtm_out.) = 0 %then %do;
        %put %str(ER)ROR: [derive_epoch] Parameter SDTM_OUT is required.;
        %return;
    %end;
    
    %if %length(&ref_var.) = 0 %then %do;
        %put %str(ER)ROR: [derive_epoch] Parameter REF_VAR is required.;
        %return;
    %end;

    /*--------------------------------------------------------------------------
    * PROCESS SE (SUBJECT ELEMENTS) DOMAIN
    *--------------------------------------------------------------------------*/
    
    /* Sort SE domain by subject and study day ranges */
    proc sort data=sdtm.se out=_se_sorted;
        by usubjid sestdy seendy;
    run;
    
    /* Identify terminal records and flag missing end dates */
    data _se_flagged;
        set _se_sorted;
        by usubjid sestdy seendy;
        
        length _is_last_record $1;
        
        if last.usubjid then _is_last_record = 'Y';
        else _is_last_record = '';
        
        /* Warn about missing SEENDTC on non-terminal records */
        if _is_last_record ne 'Y' and missing(seendtc) then do;
            put "WAR" "NING: [derive_epoch] Missing SEENDTC for subject '" 
                usubjid +(-1) "' with SESTDTC=" sestdtc +(-1) ".";
        end;
    run;
    
    /* Impute missing SEENDTC using next period's start date to avoid gaps */
    data _se_imputed;
        merge _se_flagged 
              _se_flagged(firstobs=2 
                          keep=usubjid sestdtc 
                          rename=(usubjid=_next_subj sestdtc=_next_sestdtc));
        
        if missing(seendtc) then do;
            if usubjid = _next_subj and not missing(_next_sestdtc) then 
                seendtc = _next_sestdtc;
            else 
                seendtc = sestdtc;
        end;
        
        drop _next_subj _next_sestdtc _is_last_record;
    run;
    
    /*--------------------------------------------------------------------------
    * CONVERT TO DATETIME VALUES FOR COMPARISON
    *--------------------------------------------------------------------------*/
    
    /* Convert SE dates to datetime values */
    data _se_datetime;
        set _se_imputed;
        
        format _sestdtm _seendtm datetime20.;
        length _dtc_len 8;
        
        /* SESTDTC: use beginning of day for date-only */
        _dtc_len = length(strip(sestdtc));
        if missing(sestdtc) then _sestdtm = .;
        else if _dtc_len = 10 then 
            _sestdtm = input(compress(sestdtc || "T00:00:00"), is8601dt.);
        else if _dtc_len = 16 then 
            _sestdtm = input(compress(sestdtc || ":00"), is8601dt.);
        else if _dtc_len >= 19 then 
            _sestdtm = input(strip(sestdtc), is8601dt.);
        else _sestdtm = .;
        
        /* SEENDTC: use end of day for date-only */
        /* Note: Overlap handling is done via comparison logic using SESTDTC priority */
        _dtc_len = length(strip(seendtc));
        if missing(seendtc) then _seendtm = .;
        else if _dtc_len = 10 then 
            _seendtm = input(compress(seendtc || "T23:59:59"), is8601dt.);
        else if _dtc_len = 16 then 
            _seendtm = input(compress(seendtc || ":59"), is8601dt.);
        else if _dtc_len >= 19 then 
            _seendtm = input(strip(seendtc), is8601dt.);
        else _seendtm = .;
        
        drop _dtc_len;
        keep usubjid epoch taetord _sestdtm _seendtm;
    run;
    
    /* Add sequence number to preserve original record order and convert ref_var */
    data _sdtm_in_work;
        set &sdtm_in.;
        
        format _refdtm datetime20.;
        length _dtc_len 8;
        _original_order = _n_;
        
        /* Reference variable: use beginning of day for date-only */
        _dtc_len = length(strip(&ref_var.));
        if missing(&ref_var.) then _refdtm = .;
        else if _dtc_len = 10 then 
            _refdtm = input(compress(&ref_var. || "T00:00:00"), is8601dt.);
        else if _dtc_len = 16 then 
            _refdtm = input(compress(&ref_var. || ":00"), is8601dt.);
        else if _dtc_len >= 19 then 
            _refdtm = input(strip(&ref_var.), is8601dt.);
        else _refdtm = .;
        
        drop _dtc_len;
    run;

    /*--------------------------------------------------------------------------
    * MERGE AND DERIVE EPOCH
    *--------------------------------------------------------------------------*/
    
    /* Join input dataset with SE domain and filter by datetime range */
    /* When multiple epochs match (boundary overlap), SESTDTC is used as tie-breaker */
    proc sql noprint;
        create table _epoch_matched as
        select a.*, 
               b.epoch as _epoch_derived,
               b.taetord as _taetord,
               b._sestdtm as _matched_sestdtm
        from _sdtm_in_work as a 
        left join _se_datetime as b
            on a.usubjid = b.usubjid 
            and not missing(a._refdtm)
            and not missing(b._sestdtm)
            and not missing(b._seendtm)
            and b._sestdtm <= a._refdtm <= b._seendtm
        order by a.usubjid, a._original_order, b._sestdtm desc, b.taetord;
    quit;
    
    /*--------------------------------------------------------------------------
    * CONFLICT RESOLUTION
    *--------------------------------------------------------------------------*/
    
    /* When multiple epochs match (boundary overlap), select based on:
       1. Latest SESTDTM (tightest lower bound - handles overlap at boundaries)
       2. Then apply epoch_rule for remaining ties */
    data _epoch_resolved;
        set _epoch_matched;
        by usubjid _original_order descending _matched_sestdtm _taetord;
        
        /* Keep first record - this has the latest SESTDTM (best match for boundary cases) */
        if first._original_order;
        
        drop _taetord _matched_sestdtm;
    run;

    /*--------------------------------------------------------------------------
    * HANDLE EDGE CASES (DATES OUTSIDE SE RANGE)
    *--------------------------------------------------------------------------*/
    
    %if &handle_edge. = Y %then %do;
        
        /* Get first and last epoch boundaries per subject */
        proc sort data=_se_datetime out=_se_boundaries;
            by usubjid taetord;
        run;
        
        data _se_first(keep=usubjid _sestdtm epoch 
                       rename=(_sestdtm=_first_sestdtm epoch=_first_epoch))
             _se_last(keep=usubjid _seendtm epoch 
                      rename=(_seendtm=_last_seendtm epoch=_last_epoch));
            set _se_boundaries;
            by usubjid taetord;
            if first.usubjid then output _se_first;
            if last.usubjid then output _se_last;
        run;
        
        data _se_boundaries_merged;
            merge _se_first _se_last;
            by usubjid;
        run;
        
        /* Apply edge case logic */
        proc sort data=_epoch_resolved;
            by usubjid;
        run;
        
        data _epoch_resolved;
            merge _epoch_resolved(in=a) _se_boundaries_merged(in=b);
            by usubjid;
            if a;
            
            /* Assign epoch for dates outside SE range */
            if missing(_epoch_derived) and not missing(_refdtm) then do;
                if not missing(_last_seendtm) and _refdtm > _last_seendtm then 
                    _epoch_derived = _last_epoch;
                else if not missing(_first_sestdtm) and _refdtm < _first_sestdtm then 
                    _epoch_derived = _first_epoch;
            end;
            
            drop _first_sestdtm _first_epoch _last_seendtm _last_epoch;
        run;
        
    %end;

    /*--------------------------------------------------------------------------
    * FINALIZE OUTPUT DATASET
    *--------------------------------------------------------------------------*/
    
    /* Create final output with EPOCH variable */
    proc sort data=_epoch_resolved out=_epoch_final;
        by _original_order;
    run;
    
    data &sdtm_out.;
        set _epoch_final;
        
        /* Rename derived epoch to EPOCH */
        length epoch $200;
        epoch = _epoch_derived;
        
        drop _original_order _refdtm _epoch_derived;
    run;
    
    /*--------------------------------------------------------------------------
    * SUMMARY STATISTICS
    *--------------------------------------------------------------------------*/
    
    proc sql noprint;
        select count(*) into :_total_recs trimmed from &sdtm_out.;
        select count(*) into :_with_epoch trimmed from &sdtm_out. 
            where not missing(epoch);
        select count(*) into :_missing_refvar trimmed from &sdtm_in.
            where missing(&ref_var.);
    quit;
    
    %let _without_epoch = %eval(&_total_recs. - &_with_epoch.);
    
    %put NOTE: [derive_epoch] Processing complete.;
    %put NOTE: [derive_epoch] Total records: &_total_recs.;
    %put NOTE: [derive_epoch] Records with EPOCH: &_with_epoch.;
    
    %if &_missing_refvar. > 0 %then %do;
        %put NOTE: [derive_epoch] Records with missing &ref_var.: &_missing_refvar. (EPOCH not derived for these records);
    %end;
    
    %if &handle_edge. = N and &_without_epoch. > &_missing_refvar. %then %do;
        %let _outside_range = %eval(&_without_epoch. - &_missing_refvar.);
        %put NOTE: [derive_epoch] Records outside SE date range: &_outside_range. (HANDLE_EDGE=N, EPOCH not assigned);
    %end;
    
    /*--------------------------------------------------------------------------
    * CLEANUP TEMPORARY DATASETS
    *--------------------------------------------------------------------------*/
    
    proc datasets library=work nolist nowarn;
        delete _se_sorted _se_flagged _se_imputed _se_datetime 
               _sdtm_in_work _epoch_matched _epoch_resolved _epoch_final
               _se_boundaries _se_first _se_last _se_boundaries_merged;
    quit;

%mend derive_epoch;
