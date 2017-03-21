/**********************************************************************************

PROGRAM:      C:\MEPS\SAS\PROG\EXERCISE7.SAS

DESCRIPTION:  THIS PROGRAM ILLUSTRATES HOW TO CONSTRUCT INSURANCE STATUS VARIABLES FROM
              MONTHLY INSURANCE VARIABLES (see below) IN THE PERSON-LEVEL DATA 

TRImm14X   Covered by TRICARE/CHAMPVA in mm (Ed)
MCRmm14    Covered by Medicare in mm
MCRmm14X   Covered by Medicare in mm (Ed)
MCDmm14    Covered by Medicaid or SCHIP in mm            
MCDmm14X   Covered by Medicaid or SCHIP in mm  (Ed)
OPAmm14    Covered by Other Public A Ins in mm 
OPBmm14    Covered by Other Public B Ins in mm 
PUBmm14X   Covered by Any Public Ins in mm (Ed)
PEGmm14    Covered by Empl Union Ins in mm 
PDKmm14    Coverer by Priv Ins (Source Unknown) in mm 
PNGmm14    Covered by Nongroup Ins in mm 
POGmm14    Covered by Other Group Ins in mm 
PRSmm14    Covered by Self-Emp Ins in mm 
POUmm14    Covered by Holder Outside of RU in mm 
PRImm14    Covered by Private Ins in mm                       

where mm = JA-DE  (January - December)   

INPUT FILE:   C:\MEPS\SAS\DATA\H171.SAS7BDAT (2014 FY PUF DATA)

*********************************************************************************/;
OPTIONS LS=160 PS=65 NODATE;

*LIBNAME CDATA 'C:\MEPS\SAS\DATA';
LIBNAME CDATA "\\programs.ahrq.local\programs\meps\AHRQ4_CY2\B_CFACT\BJ001DVK\Workshop_2017\SAS\Data"; 

%LET YR=14;

TITLE1 '2017 AHRQ MEPS DATA USERS WORKSHOP';
TITLE2 "EXERCISE7.SAS: HOW TO CONSTRUCT INSURANCE STATUS VARIABLES, USING FY &YR DATA";

PROC FORMAT;
VALUE RACETHX  
  1 = '1 HISPANIC'
  2 = '2 WHITE'
  3 = '3 BLACK'
  4 = '4 ASIAN'
  5 = '5 OTHER RACE'
  ;
RUN;


/*1) COUNT # OF MONTHS WITH INSURANCE*/

DATA FY1;
  SET CDATA.H171;

ARRAY PEG (12) PEGJA&YR PEGFE&YR PEGMA&YR PEGAP&YR PEGMY&YR PEGJU&YR PEGJL&YR PEGAU&YR PEGSE&YR PEGOC&YR PEGNO&YR PEGDE&YR;
ARRAY POU (12) POUJA&YR POUFE&YR POUMA&YR POUAP&YR POUMY&YR POUJU&YR POUJL&YR POUAU&YR POUSE&YR POUOC&YR POUNO&YR POUDE&YR;
ARRAY PDK (12) PDKJA&YR PDKFE&YR PDKMA&YR PDKAP&YR PDKMY&YR PDKJU&YR PDKJL&YR PDKAU&YR PDKSE&YR PDKOC&YR PDKNO&YR PDKDE&YR;
ARRAY PNG (12) PNGJA&YR PNGFE&YR PNGMA&YR PNGAP&YR PNGMY&YR PNGJU&YR PNGJL&YR PNGAU&YR PNGSE&YR PNGOC&YR PNGNO&YR PNGDE&YR;
ARRAY POG (12) POGJA&YR POGFE&YR POGMA&YR POGAP&YR POGMY&YR POGJU&YR POGJL&YR POGAU&YR POGSE&YR POGOC&YR POGNO&YR POGDE&YR;
ARRAY PRS (12) PRSJA&YR PRSFE&YR PRSMA&YR PRSAP&YR PRSMY&YR PRSJU&YR PRSJL&YR PRSAU&YR PRSSE&YR PRSOC&YR PRSNO&YR PRSDE&YR;

ARRAY PRI (12) PRIJA&YR PRIFE&YR PRIMA&YR PRIAP&YR PRIMY&YR PRIJU&YR PRIJL&YR PRIAU&YR PRISE&YR PRIOC&YR PRINO&YR PRIDE&YR;
ARRAY INS (12) INSJA&YR.X INSFE&YR.X INSMA&YR.X INSAP&YR.X INSMY&YR.X INSJU&YR.X INSJL&YR.X INSAU&YR.X INSSE&YR.X INSOC&YR.X INSNO&YR.X INSDE&YR.X;
ARRAY MCD (12) MCDJA&YR.X MCDFE&YR.X MCDMA&YR.X MCDAP&YR.X MCDMY&YR.X MCDJU&YR.X MCDJL&YR.X MCDAU&YR.X MCDSE&YR.X MCDOC&YR.X MCDNO&YR.X MCDDE&YR.X;
ARRAY MCR (12) MCRJA&YR.X MCRFE&YR.X MCRMA&YR.X MCRAP&YR.X MCRMY&YR.X MCRJU&YR.X MCRJL&YR.X MCRAU&YR.X MCRSE&YR.X MCROC&YR.X MCRNO&YR.X MCRDE&YR.X;
ARRAY TRI (12) TRIJA&YR.X TRIFE&YR.X TRIMA&YR.X TRIAP&YR.X TRIMY&YR.X TRIJU&YR.X TRIJL&YR.X TRIAU&YR.X TRISE&YR.X TRIOC&YR.X TRINO&YR.X TRIDE&YR.X;

ARRAY OPA (12) OPAJA&YR OPAFE&YR OPAMA&YR OPAAP&YR OPAMY&YR OPAJU&YR OPAJL&YR OPAAU&YR OPASE&YR OPAOC&YR OPANO&YR OPADE&YR; 
ARRAY OPB (12) OPBJA&YR OPBFE&YR OPBMA&YR OPBAP&YR OPBMY&YR OPBJU&YR OPBJL&YR OPBAU&YR OPBSE&YR OPBOC&YR OPBNO&YR OPBDE&YR; 

  PRI_N=0;
  INS_N=0;
  UNINS_N=0;
  MCD_N=0;
  MCR_N=0;
  TRI_N=0;
  OPAB_N=0;
  GRP_N=0;
  NG_N=0; 
  PUB_N=0; 
  REF_N=0;

  DO I=1 TO 12;
    IF PRI(I)=1 THEN PRI_N+1;
    IF INS(I)=1 THEN INS_N+1;
    IF INS(I)=2 THEN UNINS_N+1;
    IF MCD(I)=1 THEN MCD_N+1;
    IF MCR(I)=1 THEN MCR_N+1;
    IF TRI(I)=1 THEN TRI_N+1;
    IF OPA(I)=1 OR OPB(I)=1 THEN OPAB_N+1;
    IF PEG(I)=1 OR TRI(I)=1 OR POU(I)=1 OR PDK(I)=1 THEN GRP_N + 1;
    IF PNG(I)=1 OR POG(I)=1 OR PRS(I)=1 THEN NG_N + 1;
    IF MCR(I)=1 OR MCD(I)=1 OR OPA(I)=1 OR OPB(I)=1 THEN PUB_N + 1;
    IF INS(I)>0 THEN REF_N+1;
  END;
  DROP I;

LABEL
  PRI_N  ="# OF MONTHS COV BY PRIVATE INSU"  
  INS_N  ="# OF MONTHS COV BY ANY INSU"  
  UNINS_N="# OF MONTHS WITHOUT INSU"
  MCD_N  ="# OF MONTHS COV BY MEDICAID"  
  MCR_N  ="# OF MONTHS COV BY MEDICARE"  
  TRI_N  ="# OF MONTHS COV BY TRICARE"  
  OPAB_N ="# OF MONTHS COV BY OTHER PUBLIC A OR B INSU"  
  GRP_N  ="# OF MONTHS COV BY PRIVATE GROUP INSU"  
  NG_N   ="# OF MONTHS COV BY PRIVATE NON-GROUP INSU"  
  PUB_N  ="# OF MONTHS COV BY PUBLIC INSU"  
  REF_N  ="# OF MONTHS IN MEPS SURVEY" ;
RUN;

TITLE3 "CREATE COUNT VARIABLES FOR # OF MONTHS WITH INSURANCE";
PROC FREQ DATA=FY1;
  TABLES  PRI_N INS_N UNINS_N MCD_N MCR_N TRI_N OPAB_N GRP_N NG_N PUB_N REF_N /LIST MISSING;
RUN;

TITLE3 'SAMPLE DUMP TO CHECK THE COUNT VARIABLES (USING PRI_N AS EXMAPLE)';
PROC PRINT DATA=FY1 (OBS=30) NOOBS;
VAR DUPERSID PRIJA&YR PRIFE&YR PRIMA&YR PRIAP&YR PRIMY&YR PRIJU&YR PRIJL&YR PRIAU&YR PRISE&YR PRIOC&YR PRINO&YR PRIDE&YR PRI_N;
RUN;

/*2) CREATE FLAGS FOR VARIOUS TYPES OF INSU*/

DATA FY2;
  SET FY1;
  LABEL
  FULL_INSU='INSURED FOR FULL YEAR'
  GROUP_INS1='EVER INSURED BY PRIVATE GROUP'
  GROUP_INS2='INSURED BY PRIVATE GROUP FOR FULL YEAR'
  NG_INS='EVER INSURED BY PRIVATE NON-GROUP';

  FULL_INSU=0;
  GROUP_INS1=0;
  GROUP_INS2=0;
  NG_INS=0;

  IF UNINS_N=0 THEN FULL_INSU=1;
  IF GRP_N>0 THEN GROUP_INS1=1;
  IF GRP_N>0 AND GRP_N=REF_N THEN GROUP_INS2=1;
  IF NG_N>0 THEN NG_INS=1;
RUN;

TITLE3 "SUPPORTING CROSSTABS TO VERIFY THE CREATION OF THE FLAGS";
PROC FREQ DATA=FY2;
  TABLES FULL_INSU FULL_INSU*UNINS_N FULL_INSU*INS_N*REF_N
         GROUP_INS1 GROUP_INS1*GRP_N
         GROUP_INS2 GROUP_INS2*GRP_N*REF_N
         NG_INS NG_INS*NG_N/LIST MISSING;
RUN;


/*3) CALCULATE % OF PERSONS COVERED BY INSU*/

TITLE3 "% AND POPULATION WITH INSU";
PROC SURVEYMEANS DATA=FY2 NOBS SUMWGT SUM STD MEAN STDERR;
	STRATA  VARSTR;
	CLUSTER VARPSU;
	WEIGHT PERWT14F;
	VAR  FULL_INSU GROUP_INS1 GROUP_INS2 NG_INS;
	DOMAIN RACETHX;
  FORMAT RACETHX RACETHX.;
RUN;
