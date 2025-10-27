/*** HELP START ***//*

Macro Name:     view_swatch
  Purpose:
    Display a comprehensive list of SAS DICTIONARY tables and corresponding SASHELP views, along with short descriptions for each.  
    This macro serves as a quick reference or lookup guide to understand the relationship  between SQL-accessible DICTIONARY tables and their SASHELP counterparts.

  Usage Example:
    %view_swatch();

  Author:          Yutaka Morioka
  Created:         2025-10-27

*//*** HELP END ***/

%macro view_swatch();
data view_swatch;
length Dictionary SASHELP $40. DESC $1000.;
Dictionary='TABLES';SASHELP='VTABLE';DESC='SAS Tables and Table-specific Information.';output;
Dictionary='COLUMNS';SASHELP='VCOLUMN';DESC='Columns from All Tables.';output;
Dictionary='XATTRS';SASHELP='VXATTR';DESC='Extended Attributes.';output;
Dictionary='TITLES';SASHELP='VTITLE';DESC='Information about Defined Titles.';output;
Dictionary='EXTFILES';SASHELP='VEXTFL';DESC='Implicitly-defined File Definitions and Files Defined in FILENAME statements.';output;
Dictionary='LIBNAMES';SASHELP='VLIBNAM';DESC='Information related to SAS Data Libraries.';output;
Dictionary='MACROS';SASHELP='VMACRO';DESC='Information about Defined Macros.';output;
Dictionary='CATALOGS';SASHELP='VCATALG';DESC='SAS Catalogs and Catalog-specific Information.';output;
Dictionary='CHECK_CONSTRAINTS';SASHELP='VCHKCON';DESC='Check Constraints information.';output;
Dictionary='CONSTRAINT_COLUMN_USAGE';SASHELP='VCNCOLU';DESC='Constraint Column Usage.';output;
Dictionary='CONSTRAINT_TABLE_USAGE';SASHELP='VCNTABU';DESC='Constraint Table Usage.';output;
Dictionary='DATAITEMS';SASHELP='VDATAIT';DESC='Information Map Data Items.';output;
Dictionary='DESTINATIONS';SASHELP='VDEST';DESC='Open ODS Destinations.';output;
Dictionary='DICTIONARIES';SASHELP='VDCTNRY';DESC='DICTIONARY Tables and their Columns.';output;
Dictionary='ENGINES';SASHELP='VENGINE';DESC='Available Engines.';output;
Dictionary='FILTERS';SASHELP='VFILTER';DESC='Information Map Filters.';output;
Dictionary='FORMATS';SASHELP='VFORMAT';DESC='Available SAS and User-defined Formats and Informats.';output;
Dictionary='FUNCTIONS';SASHELP='VFUNC';DESC='Available Functions.';output;
Dictionary='GOPTIONS';SASHELP='VGOPT';DESC='SAS/GRAPH Software Graphics Options.';output;
Dictionary='INDEXES';SASHELP='VINDEX';DESC='Information related to Defined Indexes.';output;
Dictionary='INFOMAPS';SASHELP='VINFOMP';DESC='Information Maps.';output;
Dictionary='LOCALES';SASHELP='VLOCALE';DESC='Available Locales, Regions, Languages and Currency Symbols.';output;
Dictionary='MEMBERS';SASHELP='VMEMBER';DESC='Information about SAS Defined Tables, Catalogs and Views.';output;
Dictionary='OPTIONS';SASHELP='VOPTION';DESC='Information about SAS Default System Options.';output;
Dictionary='PROMPTS';SASHELP='VPROMPT';DESC='Information about Information Map Prompts.';output;
Dictionary='PROMPTSXML';SASHELP='VPRMXML';DESC='Information Map Prompts XML.';output;
Dictionary='REFERENTIAL_CONSTRAINTS';SASHELP='VREFCON';DESC='Information about Referential Constraints.';output;
Dictionary='REMEMBER';SASHELP='VREMEMB';DESC='All Remembered Information.';output;
Dictionary='STYLES';SASHELP='VSTYLE';DESC='Information about All Styles.';output;
Dictionary='TABLE_CONSTRAINTS';SASHELP='VTABCON';DESC='Information about Table Constraints.';output;
Dictionary='VIEWS';SASHELP='VVIEW';DESC='Views and View-specific Information.';output;
Dictionary='VIEW_SOURCES';SASHELP='VSVIEW';DESC='Sources Referenced by View.';output;
Dictionary='';SASHELP='VALLOPT';DESC='/*Options and Goptions*/#select *#from DICTIONARY.OPTIONS#union#select *#from DICTIONARY.GOPTIONS;#';output;
Dictionary='';SASHELP='VCFORMAT';DESC='/*Character Formats*/#select fmtname#from DICTIONARY.FORMATS#where source = "C"#';output;
Dictionary='';SASHELP='VSACCESS';DESC='/*SAS ACCESS Views*/# select libname, memname# from DICTIONARY.MEMBERS#where memtype = "ACCESS"# order by libname asc, memname asc;#';output;
Dictionary='';SASHELP='VSCATALOG';DESC='/*SAS CATALOGS*/#select libname, memname#from DICTIONARY.MEMBERS#where memtype = "CATALOG"#order by libname asc, memname asc;#';output;
Dictionary='';SASHELP='VSLIB';DESC='/*SAS Libraries*/# select distinct libname, path# from DICTIONARY.MEMBERS# order by libname asc;#';output;
Dictionary='';SASHELP='VSTABLE';DESC='/*SAS Data Tables*/#select libname, memname#from DICTIONARY.MEMBERS#where memtype = "DATA"#order by libname asc, memname asc;#';output;
Dictionary='';SASHELP='VSTABVW';DESC='/*SAS Data Tables and Views*/#select libname, memname, memtype#from DICTIONARY.MEMBERS#where (memtype = "VIEW") or (memtype = "DATA")#order by libname asc, memname asc;#';output;
Dictionary='';SASHELP='VSVIEW';DESC='/*SAS Data Views*/#select libname, memname#from DICTIONARY.MEMBERS#where memtype = "VIEW"#order by libname asc, memname asc;#';output;
run;

proc odstable data=View_swatch;
column Dictionary SASHELP DESC;
define header hDictionary; start=Dictionary;end=Dictionary;just=left;text"DICTIONARY Table(SQL)";end;
define header hSASHELP; start=SASHELP;end=SASHELP;just=left;text"SASHELP.XX View";end;
define header hDESC; start=DESC;end=DESC;just=left; jtext"Description";end;
define Dictionary; print_headers=off; just=left;  text_split="#"; end;
define SASHELP; print_headers=off; just=left;  text_split="#"; end;
define DESC; print_headers=off; just=left;  text_split="#"; end;
run;
%mend;
