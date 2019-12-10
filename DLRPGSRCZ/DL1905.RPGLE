     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*S*D ***RPGBASE*******************************************************                       CAAA02
/*STD *  RPGBASEMOD                                                   *                       CAAA02
/*EXI *  TEXT('Midas DL FRA book positions enquiry')                  *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Module
      *                                                               *
      * DL1905  - FRA BOOK POSITIONS ENQUIRY                          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD051554           Date 28Sep18               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD047993           Date 23Sep17               *
      *                 MD035545           Date 11Sep15               *      
      *                 245692             Date 09Dec13               *
      *                 AR318276           Date 01Oct12               *
      *                 CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 247544             Date 16May07               *
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG7952            Date 22Jul05               *
      *                 CIR013             Date 25Apr05               *
      *                 TDA035             Date 02Apr04               *
      *                 CAAA03             Date 29Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAAA02             Date 16Jul03               *
      *  Converted to ILE and code-stripped                           *
      *                 217684             Date 12May03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP056             Date 13Mar02               *
      *                 CIR008             Date 13Mar02               *
      *                 CAS001             Date 23Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CPK014             Date 04Oct01               *
      *                 182370             Date 05Jun01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CIR004             Date 20Jan00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 139971             Date 03Aug98               *
      *                 CEU012             Date 16Feb98               *
      *                 126426             Date 29Dec97               *
      *                 061426             Date 30Sep93               *
      *                 046114             Date 09Jul93               *
      *                 E42616             DATE 11NOV92               *
      *                 S01117             DATE 25MAR92               *
      *                  E30373                 DATE 24OCT91          *
      *                  E28496                 DATE 17SEP91          *
      *                  E28440                 DATE 17SEP91          *
      *                  S01269                 DATE 25JUN91          *
      *                  E23419                 DATE 11NOV90          *
      *                  E23420                 DATE 02OCT90          *
      *                  E23194                 DATE 16AUG90          *
      *                  E23342                 DATE 16AUG90          *
      *                  E23183                 DATE 07AUG90          *
      *                  E22658                 DATE 12JUL90          *
      *                  E20774                 DATE 15MAR90          *
      *                  S01199/E22695          DATE 12FEB90          *
      *                  S01117                 DATE 12FEB90          *
      *                  S01194                 DATE 12FEB90          *
      *                  S01157                 DATE 28/11/88         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD051554 - Leap Year Fix for interest calculation basis to   *
      *             be used for 1st Jan should not be present in      *
      *             FRA/IRS module                                    *
      *  MD046248 - Finastra Rebranding                               *
      *  MD047993 - Modified MD035545. Removed dependency on Accrue   *
      *             on Last Day indicator.                            *
      *  MD035545 - LE: Interest Calculation in Leap year. Consider   *
      *             Accrue on Last Day Indicator for method 6.        *      
      *  245692 - Incorrect validation of rates when the decimal se-  *
      *           parator in the Dealing ICD was defined as "," ins-  *
      *           tead of ".".                                        *
      *         - Applied for MD23981.                                *
      *  AR318276 - FRA/IRS incorrect mapping of interest by IRS deal.*
      *             Recompile over the changes in /COPY ZCBDYSZ1LE    *
      *             (Recompile)                                       *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  247544 - Increase definition of W@NLP2 to match w/ ZINTDYZ2  *
      *           processing as amended by 242286.  (Recompile)       *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG7952 - Recompile due ot changes in ZSRSRC,ZCBDYSZ1LE     *
      *  CIR013 - Additional Calculation Method for FRA/IRS/CCF       *
      *           Recompile over ZDLINT, ZCBDYS & ZNPV.               *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  CAAA03 - Webfacing Changes (recompile).                      *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAAA02 - Remove use of INVITE keyword to enable WebFacing    *
      *           to process screens.                                 *
      *           JavaScript in the DDS will cause the Web Page to    *
      *           redisplay frequently and this program will          *
      *           accumulate the total elapsed time and exit          *
      *           when this matches the time from the OVRDSPF         *
      *           Some ZSRSRC SRs replaced by modules.                *
      *  217684 - Authorisation User Malfunction (Recompile)          *
      *  CAP056 - Automatic Authorisation of Interface deals          *
      *           (Recompile)                                         *
      *  CIR008 - FRA/IRS Deals Authorisation (Recompile)             *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *  CPK014 - Release 4 packaging.  Rename of field which is too  *
      *           long for OPM program.                               *
      *  182370 - Incorrect calculation of number of days for calcu-  *
      *           lation basis 6. Amended /COPY such that for calcu-  *
      *           lation basis 6, the number of days per year is      *
      *           equal to 366 when the year in question is a leap    *
      *           year, and 365 days/year for non-leap years. Calcu-  *
      *           lation was made so that processing would be in-line *
      *           with that of /COPY ZINTDY.                          *
      *  CIR004 - Dealing Calculation Method Change (Recompiled due   *
      *           change in ZCBDYSZ1)                                 *
     F*  139971 - Enquiry of Consolidated Euro currency records for a *
      *           specific book in FRA Daily Deals and FRA Book Posi- *
      *           tion also show records for other books.             *
      *  CEU012 - EMU Position/Risk Enquiries                         *
      *  126426 - If Date Format flag is 'M', convert the date to     *
      *           American date format after calling SR/ZDATE8.       *
      *  061426 - Recompile after ZDATE9 correction                   *
      *  046114 - FRA book position enquiry - F12 takes you to        *
      *           another enquiry screen.                             *
      *  E42616 - The Enquiry on FRA Book Positions asks for the date *
      *           to be input in format MMMDDYY instead of MMDDYY.    *
      *           This does not meet the standards for the rest of    *
      *           the Midas system.                                   *
      *   S01117 - RECOMPILE FOR FT CHANGE TO MUSERDD                 *
      *   E30373 -  Revalue up until Value Date - not Rate Fix Date,  *
      *             as before.                                        *
      *   E28496 -   Recompile for SDFAISPD changes (BQHEOC - Hedged  *
      *              Events on Cashflow removed).                     *
      *   E28440 - FRA/IRS Revaluations : Open P/L changed to use FRA *
      *            Rate off new Rates Table; Open P/L discounted to   *
      *            Spot; Closed P/L discounted to Spot.               *
      *   S01269 - RECOMPILE FOR TRADE AUTHORISATION CHANGE TO        *
      *            MUSERDD                                            *
      *   E23419  -  Tidied up American date formats and ensured no   *
      *              embedded blank in date if MMMDDYY ie. changed    *
      *              'MAR 890' to MAR0890'                            *
      *   E23420  -  When ICD has date format 'M' (American- MMMDDYY) *
      *              Value date and Run date still remain in UK       *
      *              format (ie DDMMMYY).                             *
      *   E23194  -  DATE FIELD ALLOWS NON-NUMERICS FOR DAY NUMBER    *
      *              FIELD                                            *
      *   E23342  -  CHECK MULTIBRANCH IND. BEFORE BRANCH VALIDATION  *
      *              ROUTINE. CHANGE E22695 TO ALLOW DEFAULT VALUES   *
      *              TO APPEAR.                                       *
      *              (NO NEED TO CHANGE TO CHANGE E22695 SINCE S01199 *
      *              DID NOT APPLY FIX IN THE SAME WAY!)              *
      *   E23183  -  SUBROUTINE ZVLDT ALTERED TO ACCEPT DATE IN       *
      *              CORRECT FORMAT ONLY - PROGRAM RECOMPILED.        *
      *   E22658  -  THE DECIMAL PLACES FOR THE WORK FIELD HAS BEEN   *
      *              CHANGED FROM 8 TO 6 IN ORDER TO HANDLE LARGE     *
      *              NUMBERS.                                         *
      *   E20774  -  REPLACE QCAEXEC WITH QCMDEXC                     *
      *   S01199/E22695  -  HELP SYSTEM.  (E22695 WAS APPLIED FOR *
      *                     R2 TO THIS FILE AT THE SAME TIME AS       *
      *                     S01199 WAS APPLIED FOR R10 - THEREFORE    *
      *                     THEY MAY NOT BE INDENTICAL CHANGES -      *
      *                     FOR INSTANCE, S01199 SAW NO NEED TO ADD   *
      *                     FORMAT DL1905C2).                         *
      *   S01117 - MULTI-BRANCHING CHANGES                            *
      *   S01194 - NEW STANDING DATA CHANGES                          *
      *   S01157 - NEW PROGRAM WRITTEN FOR FRA/IRS                    *
      *****************************************************************
      /EJECT
      * ID  F  C  H  L    FUNCTION OF INDICATORS
      *****************************************************************
      *                                                               *
      * INDICATORS TO BE RECEIVED FROM THE SCREEN - COMMANDS          *
      *                                                               *
      *     03   -  EXIT PROGRAM                                      *
      *     05   -  REFRESH SCREEN                                    *
      *     12   -  FURTHER SUMMARY SCREEN                            *
      *     18   -  IF OFF, MMMDDYY -> MMDDYY; ON, MMDDYY -> MMMDDYY  *
      *     25   -  ROLLUP REQUESTED                                  *
      *     26   -  ROLLDOWN REQUESTED                                *
      *                                                               *
      *     27   -  INHIBIT ROLL/REFRESH/SELECT KEYS & TEXT/ENQ.TITLES*
      *     28   -  ACTIVATE THE OVRDTA KEYWORD FOR KEYS/TEXT & TITLES*
      *     29   -  ACTIVATE THE OVRATR KEYWORD FOR THE SELECT FIELDS *
      *     24   -  ACTIVATE THE OVRDTA KEYWORD FOR THE SELECT FIELDS *
      *                                                               *
      * INDICATORS TO CONTROL THE ENQUIRY SUBFILE                     *
      *                                                               *
      *     30   -  ACTIVATE SUBFILE END                              *
      *     35   -  ACTIVATE SUBFILE DISPLAY                          *
      *     36   -  ACTIVATE SUBFILE DISPLAY CONTROL                  *
      *     (N35N36   -  ACTIVATE SUBFILE CLEAR)                      *
      *     50   -  'MBIN' = 'N'; NON-DISPLAY PROMPT FOR BRANCH       *
      *                                                               *
      * INDICATORS TO CONTROL THE MESSAGE SUBFILE                     *
      *                                                               *
      *     40   -  ACTIVATE SUBFILE END                              *
      *     46   -  ACTIVATE SUBFILE DISPLAY CONTROL                  *
      *                                                               *
      * INDICATORS TO REPORT ERRORS ON VALIDATION OF PROMPT SCREEN    *
      *                                                               *
      *     60   -  ERROR ON CURRENCY SELECTED                        *
      *     61   -  ERROR ON BRANCH CODE SELECTED                     *
      *     62   -  ERROR ON VALUE DATE SELECTED                      *
      *     63   -  ERROR ON BOOK CODE SELECTED                       *
      *     68   -  NO RECORD ON FILE FOR CCY/BRANCH AND GE VALUE DATE*
      *     69   -  GENERAL ERROR ON VALIDATION OF PROMPT SCREEN      *
      *                                                               *
      * INDICATORS TO REPORT ERRORS ON FILE READS                     *
      *                                                               *
      *     70   -  END OF SUBFILE - DL1905S1                         *
      *     71   -  END OF RELEVANT DATA ON DEALS FILE                *
      *     73   -  ERROR ON READ OF ENQUIRY SUBFILE CONTROL FORMAT   *
      *                                                               *
      *     82   -  DATABASE ERROR ON BASE RATE FILE - DLDSMBL        *
      *             AND BEGINNING OF RELEVANT DATA ON DEALS FILE      *
      *     85   -  DATABASE ERROR ON MUSER                           *
      *     86   -  DATABASE ERROR ON FDMNTHLL                        *
      *                                                               *
      *     98   -  INDICATOR USED IN ZDATE8                          *
      *     99   -  INDICATOR USED IN ZDATE1                          *
      *     08   -  INDICATOR TO PREVENT LOOPING WITHIN *PSSR         *
      *                                                               *
      *****************************************************************
      *
     FDLFRARL4  IF   E           K DISK
     FDLINTRL2  IF   E           K DISK
     FDLMMDFL1  IF   E           K DISK
     FDLDSMBL   IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     FDLDSBEL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
      *
      ** FRA Daily Daily Summary by Branch/Book (EMU)
      *
     FFDMNTHLL  IF   E             DISK    INFSR(*PSSR)
     F                                     USROPN
     F*
     FMUSER     IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F*
     F*
     FDL1905DF  CF   E             WORKSTN INFSR(*PSSR)
     F                                     USROPN
     F                                     SFILE(DL1905S1:RRN)
     F                                     MAXDEV(*FILE)
     F*
     F*****************************************************************
     D*
     D @DYN            S              2    DIM(31) CTDATA PERRCD(31)
     D** Compile-time array for valid day-in-month numbers
     D @MON            S              2    DIM(12) CTDATA PERRCD(12)
     D** Compile-time array for valid month numbers
     D @YR             S              1    DIM(10) CTDATA PERRCD(10)
     D** Compile-time array for valid year digits
     D*
      ***/COPY ZSRSRC,ZDATE8Z1                                                  CAAA02
      /COPY ZSRSRC,ZDATE8Z1LE                                                   CAAA02
     D*
     D @A              S              1    DIM(20)
     D** ARRAY USED TO EDIT AMOUNT FOR DISPLAY
     D*
     D @OVR            S             36    DIM(1) CTDATA PERRCD(1)
     D** ARRAY TO SET UP PARAMETER FOR CALL TO QCMDEXC
     D*
     D***/COPY ZSRSRC,ZDATE9Z1                                                  CAAA02
     D/COPY ZSRSRC,ZDATE9Z1LE                                                   CAAA02
     D* WORK ARRAYS USED IN #BDA
     D ZS2             S              1    DIM(21)
     D*
     D** ZDATE2 needs ZDATE2Z1 to run.  However, this program already
     D** uses ZDATE8 which uses 2 identical arrays - ZYDY and ZMDY.
     D** But, ZDATE2 uses an extra array, ZMNM, so this is hard-coded.
     D ZMNM            S              3    DIM(12) CTDATA PERRCD(12)
     D*
     D @KRCRD          DS            32
     D*
     D** DATA STRUCTURE FOR KEY FIELDS
     D*
     D  @KBKCD                 1      2
     D  @KCCCY                 3      5
     D  @KBRCA                 6      8
     D  @KFVDT                 9     15
     D  @KCVDT                16     20  0
     D  @KCMDT                21     25  0
     D  @KCBSD                26     30
     D  @KSSNB                31     32  0
     D*
     D*
     D @PRMUP          DS            19
     D*
     D** DATA STRUCTURE FOR PROMPT FIELDS FOR PROGRAM UP IN STACK
     D*
     D  @UPBKC                 1      2
     D  @UPCCY                 3      5
     D  @UPBCH                 6      8
     D  @UPDAT                 9     13
     D  @UPCDP                14     14  0
     D  @UPDIC                15     15  0
     D  @UPSPT                16     18P 0
     D  @UPINC                19     19
     D*
     D @PRMDN          DS            35
     D*
     D** DATA STRUCTURE FOR PROMPT FIELDS FOR PROGRAM DOWN IN STACK
     D*
     D  @DDCCY                 1      3
     D  @DBRKR                 4      7
     D  @DBKCD                 8      9
     D  @DBRNH                10     12
     D  @DVDAT                13     19
     D  @DMSDT                20     24  0
     D  @DCDP                 28     28  0
     D  @DDICM                29     29  0
     D  @DNSPT                30     32P 0
     D  @DSSNB                33     34  0
     D  @DNINC                35     35
     D*
     D*
     D @SRCRD          DS            15
     D*
     D** DATA STRUCTURE FOR SCREEN PROMPT FIELDS
     D*
     D  @SBKCD                 1      2
     D  @SCRCY                 3      5
     D  @SBRCA                 6      8
     D  @SVLDT                 9     14
     D  @SMT                   9     11
     D  @DY                    9     10
     D  @MDY                  12     13
     D  @SVLMY                11     14
     D*
     D*
     D DLRCRD          DS            32
     D*
     D** DATA STRUCTURE FOR DAILY SUMMARY FILE FIELDS
     D*
     D  KCBOKC                 1      2
     D  KCCCY                  3      5
     D  KCBRCA                 6      8
     D  FILLER                 9     15
     D  KCVDAT                16     20  0
     D  KCMDAT                21     25  0
     D  KCBSRD                26     30
     D  KCSSNB                31     32  0
     D*
     D @@WRK           DS
     D*                                          22
     D** Data structure to move parameter string to
     D*
     D  @@WORK                 1     20
     D  CDP                   21     21  0
     D  DICM                  22     22  0
     D  SPOT                  23     25P 0
     D  WSSNB                 26     27  0
     D  WINCY                 28     28
     D*
     D* DATA STRUCTURE TO EDIT OPEN & CLOSED P/L FIELDS
     D*
     D EDIT            DS
     D  @DEDIT                 1     25
     D  @EDIT3                17     24
     D  @EDIT2                16     23
     D  @EDIT1                15     22
     D  @EDIT0                14     21
     D*
     D** Data structure to edit net position amount
     D*
     D NETP            DS
     D  DDNETP                 1      9
     D  @DNETP                 1      8
     D*
     D @DAT7           DS             7
     D*
     D** DATA STRUCTURE TO CONVERT UK DATE TO US DATE FORMAT
     D** (IE DDMMMYY --> MMMDDYY)
     D  @DAT5                  1      5
     D  @DAY                   1      2
     D  @DDY                   1      2  0
     D  @MMT                   3      5
     D*
     D PSDS           SDS
     D*
     D** PROGRAM STATUS DS TO OBTAIN WORKSTATION ID AND USER
     D  @JOB                 244    253
     D  @USER                254    263
     D*
     D*
     D DLMMDF          DS            16
     D** DATA STRUCTURE FOR DISCOUNT FACTORS REBUILD CONTROL
     D  RADA                   1      5  0
     D*
     D @OVRID          DS            36
     D*
     D*   DATA STRUCTURE FOR COMMAND IN ARRAY @OVR
     D*
     D  @WAIT                 32     35  0
     D*
     D* DATA STRUCTURE USED IN #BDA
     D                 DS
     D  ZWRK15                 1     15  0
     D  ZS1                    1     15  0
     D                                     DIM(15)
     D*
      *
      ** Dummy data structures used by access programs
      ** (DSSDY only used if file records over 150 chars long)
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D*
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D*
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D** RECORD FORMATS FOR ACCESS TO BANK DETAILS
     D*
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
     D** RECORD FORMATS FOR ACCESS TO MIDAS MODULES DETAILS
     D*
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D** RECORD FORMATS FOR ACCESS TO CURRENCY DETAILS
     D*
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D** RECORD FORMATS FOR ACCESS TO BRANCH CODES
     D*
     D SDBOOK        E DS                  EXTNAME(SDBOOKPD)
     D** RECORD FORMATS FOR ACCESS TO BOOK DETAILS
     D*
     D SDFAIS        E DS                  EXTNAME(SDFAISPD)
     D** RECORD FORMATS FOR FWD RATE AGMT/INT RATE SWAP DETAILS
     D*
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** General ledger details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      **  Switchable Features File
      *
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)                                  245692
     D QQACC1        E                     EXTFLD(QQACCD)                                     245692
      ** Data Structure to retrieve DEALING ICD details                                       245692
                                                                                              245692
     D LDA           E DS           256    EXTNAME(LDA)
      *  Data Structure for LDA
     D/COPY WNCPYSRC,DL1905I001
     D ZMUSER          DS            17
     D* DATA STRUCTURE IN QTEMP - USER DETAILS
     D  @BKLVL                17     17
     D*
     D***/COPY ZSRSRC,ZDATE9Z2                                                  CAAA02
     D/COPY ZSRSRC,ZDATE9Z2LE                                                   CAAA02
      *
      ** Data structure for subroutine ZCBDYS
     D                 DS
     D  ZZDAT1                 1      8  0
     D  ZZYYA                  1      4  0
     D  ZZMMA                  5      6  0
     D  ZZDDA                  7      8  0
      *
     D                 DS
     D  ZZDAT2                 1      8  0
     D  ZZYYB                  1      4  0
     D  ZZMMB                  5      6  0
     D  ZZDDB                  7      8  0
                                                                                CAAA02
     D ZErrorFlag      s              1a                                        CAAA02
      * Flag used to return error condition from Z* modules                     CAAA02
                                                                                CAAA02
      * WaitTime is the time from WRITE to READ                                 CAAA02
     d WaitTime        s              5p 0                                      CAAA02
     d MaxWaitTime     s              5p 0                                      CAAA02
                                                                                CAAA02
      * Now1Time is the time before the READ and Now2Time the time after        CAAA02
     d Now1Time        s               t                                        CAAA02
     d Now2Time        s               t                                        CAAA02
     D WPARML          C                   CONST('LECalcBasis6LeapYear')                    MD035545
                                                                                CAAA02
      ***/COPY ZSRSRC,ZDAYSZ1                                                   CAAA02
      ***/COPY ZSRSRC,ZRATE2Z1                                                  CAAA02
      ***/COPY ZSRSRC,ZAMTEZ1                                                   CAAA02
      /COPY ZSRSRC,ZDAYSZ1LE                                                    CAAA02
      /COPY ZSRSRC,ZRATE2Z1LE                                                   CAAA02
      /COPY ZSRSRC,ZAMTEZ1LE                                                    CAAA02
      * ZAMTEZ2LE moved to BEFORE FDINTRP0 reference as it contains D specs     CAAA02
      /COPY ZSRSRC,ZAMTEZ2LE                                                    CAAA02
      *
     IFDINTRP0
     I              HWTMESTMP                   HWTMST
     I*
      ***/COPY ZSRSRC,ZVLDTZ2                                                   CAAA02
      ***/COPY ZSRSRC,ZAMTEZ2                                                   CAAA02
      ***/COPY ZSRSRC,ZDAT10Z1                                                  CAAA02
      /COPY ZSRSRC,ZVLDTZ2LE                                                    CAAA02
      * ZAMTEZ2LE moved to BEFORE FDINTRP0 reference as it contains D specs     CAAA02
      *
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* MAIN     - Main controlling routine                           *
     C*                                                               *
     C* CALLS      #A      -  INITIAL PROCESSING                      *
     C*            #B      -  MAIN PROCESSING                         *
     C*            #C      -  TERMINATION PROCESSING                  *
     C*                                                               *
     C* CALLED BY         -                                           *
     C*                                                               *
     C* FLDS USED                                                     *
     C*                                                               *
     C*****************************************************************
     C*
     C                   EXSR      #A
     C*
     C** PROCESS UNTIL FAST OR SLOW EXIT REQUIRED
     C*
     C     *IN03         DOWEQ     '0'
     C     *IN12         ANDEQ     '0'
     C                   EXSR      #B
     C                   END
     C*
     C                   EXSR      #C
     C*
     C*****************************************************************
     C* SUBROUTINES USED                                              *
     C*                                                               *
     C*  01  #A      - INITIAL PROCESSING                             *
     C*  02  #B      - MAIN PROCESSING                                *
     C*  03  #AB     - SET UP PROMPT FIELDS - DEFAULTS IF NECESSARY   *
     C*  04  #BA     - ROLLUP ENQUIRY SUBFILE                         *
     C*  05  #BB     - ROLLDOWN ENQUIRY SUBFILE                       *
     C*  06  #BC     - ENTER NEW PROMPT DATA                          *
     C*  07  #BCA    - VALIDATE PROMPT DATA                           *
     C*  08  #BCB    - SET UP NEW SCREEN HEADINGS                     *
     C*  09  #BCC    - DETERMINE FILE AND KEY TO BE USED WITH PROMPTS *
     C*  10  #BD     - EDIT ENQUIRY SUBFILE DATA                      *
     C*      CALCPL  - Calculate Open (Revalued) P/L                  *
     C*      GETRAT  - Get FRA Market Rate                            *
     C*  11  ZDATE8  - EDIT DATE USING MONTH SHORTNAMES FROM FILE     *
     C*  12  ZVLDT   - EDIT VALUE DATE                                *
     C*  14  ZRATE2  - CONVERT RATE TO DISPLAY                        *
     C*      ZDLINT  - DL Calculate Interest between Two Dates        *
     C*      ZNPV    - Net Present Value a Future Amount              *
     C*      ZCBDYS  - Calculate Number of Days between two Dates     *
     C*      ZDATE2  - Convert Day Number to Date Format              *
     C*      ZDAT10  - Convert YYYYMMDD to Midas Day Number           *
     C*  16  #BDA    - CONVERT NUMERIC FIELD TO DISPLAY               *
     C*  17  #AA     - OPEN FILES AND SET UP DEFAULT PROMPT DATA      *
     C*  18  #AC     - SET UP AUTO REFRESH PROCESSING                 *
     C*  19  #C      - TERMINATION PROCESSING                         *
     C*  20  #ZA     - RESET ERROR INDICATORS AND CLEAR MESSAGE QUEUE *
     C*  21  #AAA    - READ INSTALLATION FILE - FDICDRLL              *
     C*  24  *PSSR   - DATABASE ERROR HANDLING                        *
     C*  25  #AD     - SET UP KLISTS - NEVER CALLED                   *
     C*                                                               *
     C* EXTERNAL PROGRAMS CALLED                                      *
     C*                                                               *
     C*  01  ZA0240  - ADD MESSAGE TO PROGRAM MESSAGE QUEUE           *
     C*  02  ZA0250  - CLEAR PROGRAM MESSAGE QUEUE                    *
     C*  04  CA1000  - CALCULATE FORWARD BORROW AND LEND RATE         *
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #A       - INITIAL PROCESSING                                 *
     C*                                                               *
     C* CALLS      #AA     - OPEN FILES AND SET UP DEFAULT PROMPT DATA*
     C*            #AB     - SET UP PROMPT FIELDS - DEFAULTS PERHAPS  *
     C*                                                               *
     C* CALLED BY  MAIN CONTROLLING ROUTINE                           *
     C*                                                               *
     C* FLDS USED  @@TERM     - TERMINATION PARAMETER                 *
     C*            @CALL1     - FIRST TIME PROGRAM CALLED - Y OR N    *
     C*            @STRNG     - PARAMETER CONTAINING PROMPTS          *
     C*            @KRCRD     - DATA STRUCTURE CONTAINING KEY FIELDS  *
     C*            @FROM      - WHERE ENQUIRY CAME FROM - MENU (M),   *
     C*                           STACK (S) OR PROGRAM LOOP (L)       *
     C*                                                               *
     C*****************************************************************
     C*
     C     #A            BEGSR
     C*
     C** INITIALISE SCREEN MESSAGE QUEUE
     C*
     C                   MOVEL     '*'           DDPGMQ
     C*
     C** MOVE PROGRAM NAME INTO LDA FIELD
     C*
     C     *DTAARA       DEFINE                  LDA
      *
      ** Initialise LDA
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'DL1905'      DBPGM
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   Z-ADD     *ZEROS        DBASE
     C                   OUT       LDA
     C*
     C** RECEIVE INPUT PARAMETERS
     C*
     C     *ENTRY        PLIST
     C                   PARM                    @@TERM            1
     C                   PARM                    @STRNG          256
     C*
     C** MOVE PARAMETER STRING INTO KEY FIELDS IN DATA STRUCTURE VIA
     C** A WORK FIELD SO AS NOT TO GET DECIMAL DATA ERRORS ON @K FIELDS
     C** NOT SENT. SET PARAMETER STRING TO BLANKS.
     C*
     C                   MOVEL     @STRNG        @@WRK
     C*
     C** Also, need to move no. of d.p's for currency; it is kept in
     C** position 21 of parameter string.
     C*
     C                   Z-ADD     CDP           ZDECS
     C                   MOVEL     @@WORK        @KRCRD
      *
      ** If program called from stack, get  Sort Seqn
      ** number and 'In' ccy field fro passed parameter
      *
     C                   MOVE      WSSNB         @KRCRD
     C                   MOVE      WINCY         @WINCY            1
     C                   MOVE      *BLANKS       @STRNG
      **********                                                                   MD035545 MD051554
      ***Retrieve*system*value*setting************************                     MD035545 MD051554
      **********                                                                   MD035545 MD051554
     C**********         MOVEL     WPARML        P@OP01                            MD035545 MD051554
     C**********         CALL      'AOSVALR0'                                      MD035545 MD051554
     C**********         PARM      *BLANKS       W0RTCD            7               MD035545 MD051554
     C**********         PARM                    P@OP01           20               MD035545 MD051554
     C**********         PARM                    P@VL01          200               MD035545 MD051554
     C**********         PARM                    P@OP02           20               MD035545 MD051554
     C**********         PARM                    P@VL02          200               MD035545 MD051554
     C**********         PARM                    P@OP03           20               MD035545 MD051554
     C**********         PARM                    P@VL03          200               MD035545 MD051554
     C**********         PARM                    P@OP04           20               MD035545 MD051554
     C**********         PARM                    P@VL04          200               MD035545 MD051554
     C**********         PARM                    P@OP05           20               MD035545 MD051554
     C**********         PARM                    P@VL05          200               MD035545 MD051554
     C**********         PARM                    P@OP06           20               MD035545 MD051554
     C**********         PARM                    P@VL06          200               MD035545 MD051554
     C**********         PARM                    P@OP07           20               MD035545 MD051554
     C**********         PARM                    P@VL07          200               MD035545 MD051554
     C**********         PARM                    P@OP08           20               MD035545 MD051554
     C**********         PARM                    P@VL08          200               MD035545 MD051554
     C**********         PARM                    P@OP09           20               MD035545 MD051554
     C**********         PARM                    P@VL09          200               MD035545 MD051554
     C**********         PARM                    P@OP10           20               MD035545 MD051554
     C**********         PARM                    P@VL10          200               MD035545 MD051554
      **********                                                                   MD035545 MD051554
      ***If*system value is not found then default value to 'N'                    MD035545 MD051554
      **********                                                                   MD035545 MD051554
     C*****W0RTCD        IFNE      '       '                                       MD035545 MD051554
     C**********         MOVE      'N'           WCALC6                            MD035545 MD051554
     C**********         ELSE                                                      MD035545 MD051554
     C**********         MOVEL     P@VL01        WCALC6                            MD035545 MD051554
     C*****WCALC6        IFEQ      'Y'                                             MD035545 MD047993
     C*****BKALDI        ANDEQ     'Y'                                             MD035545 MD047993
     C**********         MOVE      'Y'           WCALC6                            MD035545 MD047993
     C**********         ELSE                                                      MD035545 MD047993
     C**********         MOVE      'N'           WCALC6                            MD035545 MD047993
     C**********         ENDIF                                                     MD035545 MD047993
     C**********         ENDIF                                                     MD035545 MD051554
     C*
     C** IF THIS IS FIRST CALL OF PROGRAM - COULD BE FROM MENU OR FROM
     C** STACK - CALCULATE DEFAULT VALUES FOR FUTURE REFERENCE
     C** AND SET UP THE RUN DATE FOR THE SCREEN HEADING
     C*
     C     @CALL1        IFNE      'N'                                          B1
     C                   EXSR      #AA                                          *1
     C*
     C** SET UP AUTO-REFRESH PROCESSING
     C*
     C                   EXSR      #AC                                          *1
     C                   END                                                    E1
     C*
     C** SET AN INDICATOR TO SHOW FROM WHERE ENQUIRY HAS COME -
     C** 'M' FOR MENU; 'S' FOR STACK; AND 'L' FOR LOOPING IN ITSELF
     C** (FROM MENU IF PARAMETER STRING SENT IS ENTIRELY BLANK)
     C*
     C     @@WORK        IFEQ      *BLANKS                                      B1
     C                   MOVE      'M'           @FROM             1            *1
     C                   ELSE                                                   X1
     C                   MOVE      'S'           @FROM                          *1
     C                   END                                                    E1
     C*
     C** SET OFF ALL INDICATORS
     C*
     C                   MOVE      '0'           *IN(03)
     C*
     C** INHIBIT ROLL AND REFRESH KEYS AND TEXT - ASSUME PROMPT
     C** SCREEN GOING TO BE DISPLAYED - IE. COMING FROM MENU
     C*
     C                   MOVE      '1'           *IN27
     C*
     C** SET ON END OF MESSAGE AND ENQUIRY SUBFILE INDICATORS
     C*
     C                   MOVE      '1'           *IN40
     C                   MOVE      '1'           *IN30
     C*
     C** RETRIEVE THE TIME AND WORKSTATION ID. WRITE OUT THE HEADER
     C*
     C                   TIME                    @TTIME
     C                   MOVEL     @JOB          @TWID
     C*
     C** ACTIVATE THE OVRDTA KEYWORD FOR THE SUBTITLES SO THAT IF
     C** PROGRAM HAS BEEN CALLED BEFORE THE ROLL/REFRESH/SELECT TEXT
     C** AND ENQUIRY TITLES WILL BE REMOVED UNTIL A VALID ENQUIRY
     C** SUBFILE IS OUTPUT. WRITE COMMAND KEY TEXT TOO.
     C*
     C                   MOVE      '1'           *IN28
     C*
     C                   WRITE     DL1905F0
     C                   WRITE     DL1905F1
     C*
     C** CLEAR THE SUBFILE BY SETTING OFF THE SUBFILE DISPLAY AND
     C** THE SUBFILE DISPLAY CONTROL INDICATORS AND THEN WRITING
     C** THE ENQUIRY SUBFILE CONTROL FORMAT
     C*
     C                   MOVE      '0'           *IN35
     C                   MOVE      '0'           *IN36
     C                   WRITE     DL1905C1
     C*
     C** MOVE ALL FIELDS RECEIVED IN PARAMETER TO PROMPT FIELDS AND
     C** WHERE NEEDED SET UP DEFAULT VALUES FOR BLANK VALUES RECEIVED
     C*
     C                   EXSR      #AB
     C*
     C** IF FROM MENU THEN WRITE THE PROMPT SCREEN BY SETTING ON THE
     C** SUBFILE DISPLAY CONTROL INDICATOR - WAIT FOR A RESPONSE
     C*
     C     @FROM         IFEQ      'M'                                          B1
     C*
     C                   MOVE      '1'           *IN36                          *1
     C                   EXFMT     DL1905C1                                     *1
     C*
     C                   END                                                    E1
     C*
     C** ACTIVATE THE OVRDTA FOR SELECT FIELDS INCASE SCREEN IS ALREADY
     C** ON WHEN PROGRAM CALLED IE. RECALL AFTER SELECTION MADE AND
     C** NEW PROMPTS TO DISPLAY. AND SET OFF THE OVRDTA KEYWORD FOR
     C** THE ROLL/REFRESH/SELECT TEXT AND ENQUIRY TITLES
     C*
     C                   MOVE      '1'           *IN24
     C                   MOVE      '0'           *IN28
     C*
     C/COPY WNCPYSRC,DL1905C006
     C     #A9           ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #B       - MAIN PROCESSING                                    *
     C*                                                               *
     C* CALLS      #BA       - ROLLUP ENQUIRY SUBFILE                 *
     C*            #BB       - ROLLDOWN ENQUIRY SUBFILE               *
     C*            #BC       - ENTER NEW PROMPT DATA                  *
     C*            #KA       - DETERMINE FILE - SETLL WITH ROLL KEY   *
     C*            #KB       - DETERMINE FILE - SETGT WITH ROLL KEY   *
     C*            SRREAD    - Detemine file to read                  *
     C*                                                               *
     C* CALLED BY  MAIN CONTROLLING ROUTINE                           *
     C*                                                               *
     C* FLDS USED  @TOPRD     - FIRST RECORD CURRENTLY ON SCREEN      *
     C*            @BOTRD     - LAST RECORD CURRENTLY ON SCREEN       *
     C*            SSSLCT     - SELECT FIELD FROM SCREEN              *
     C*            @@SLCT     - SELECTION-PROCESSED INDICATOR - Y/N   *
     C*            @@ERMS     - ERROR MESSAGE TO DISPLAY - Y OR N     *
     C*            @@TERM     - TERMINATION PARAMETER                 *
     C*            @KROL1     - KEY USED FOR ROLLING                  *
     C*            @DDCCY     - CURRENCY                              *
     C*            @DBRKR     - BROKER                                *
     C*            @DBKCD     - BOOK CODE                             *
     C*            @DBRNH     - BRANCH                                *
     C*            @DVDAT     - VALUE DATE                            *
     C*            @DMSDT     - MATURITY DATE                         *
     C*            @STRNG     - PARAMETER STRING                      *
     C*                                                               *
     C*****************************************************************
     C*
     C     #B            BEGSR
     C*
     C** SET OFF THE SELECTION-PROCESSED INDICATOR
     C*
     C                   MOVE      'N'           @@SLCT            1
     C*
     C** CLEAR THE MESSAGE QUEUE OF ANY OLD MESSAGES AND RESET ANY
     C** ERROR INDICATORS
     C*
     C                   EXSR      #ZA
     C*
      ** F7 - Toggle between 'Display Euro Equivalent' and
      ** 'Display Ccy Amount' is pressed (available only
      ** when Position/Risk Enquiries & Reports feature is on)
      *
     C     CEU012        IFEQ      'Y'
     C     @WINCY        ANDEQ     'Y'
     C                   WRITE     DL1905F1
     C                   ENDIF
      *
     C     CEU012        IFEQ      'Y'
     C     *IN07         ANDEQ     *ON
      *
     C     @SCRCY        IFEQ      BKEUCP
     C     *IN32         IFEQ      *ON
     C                   MOVE      *OFF          *IN32
     C                   ELSE
     C                   MOVE      *ON           *IN32
     C                   ENDIF
     C                   ENDIF
      *
     C     @SCRCY        IFNE      BKEUCP
     C     *IN32         IFEQ      *OFF
     C                   MOVE      *ON           *IN32
     C                   ELSE
     C                   MOVE      *OFF          *IN32
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C** IF REFRESH (CMD 5) HAS BEEN REQUESTED SET UP KEY FROM
     C** FIRST RECORD CURRENTLY ON SCREEN AND POSITION ON FILE (#KA).
     C** PROCESS AS FOR A ROLLUP
     C*
     C     *IN05         IFEQ      '1'                                          B1
     C                   MOVEL     @TOPRD        @KRCRD                         *1
      *
     C     CEU012        IFEQ      'Y'
      *
     C     @SCRCY        IFEQ      BKEUCP
     C     *LOVAL        SETLL     DLDSBEL1
     C                   ELSE
     C     @KRLE1        SETLL     DLDSBEL1
     C                   ENDIF
      *
     C                   ELSE
     C     @KROL1        SETLL     DLDSMBL                                      *1
     C                   ENDIF
     C                   EXSR      #BA                                          *1
     C                   MOVE      '0'           *IN05                          *1
     C*
     C** IF NOT CMD 5 THEN MUST BE <ENTER>, ROLLUP OR ROLLDOWN -
     C** IN THIS CASE SELECTION TAKES PRIORITY IE. IF A SELECTION
     C** HAS BEEN MADE THEN <ENTER>, ROLLUP AND ROLLDOWN ALL
     C** BEHAVE AS <ENTER> AND THE SELECTION IS PROCESSED OVER AND
     C** ABOVE ANY PROMPTS THAT MIGHT HAVE BEEN ENTERED.
     C*
     C                   ELSE                                                   X1
     C*
     C** IF NO SUBFILE WRITTEN YET IE.STILL ON PROMPT SCREEN THEN
     C** CANNOT READ SUBFILE
     C*
     C     *IN27         IFNE      '1'                                          B*2
     C*
     C** DO UNTIL EITHER A SELECTION IS FOUND ON THE SUBFILE OR
     C** THE END OF THE SUBFILE IS REACHED
     C*
     C     @@SLCT        DOUEQ     'Y'                                          B**3
     C     *IN70         OREQ      '1'                                          ***3
     C*
     C** READ THE SUBFILE FOR THE FIRST CHANGED RECORD
     C*
     C                   READC     DL1905S1                               70    ***3
     C*
     C***IF*RECORD*FOUND*AND SELECT FIELD NOT BLANK RETURN TO
     C** IF RECORD FOUND AND SELECT FIELD EQUALS '1' THEN RETURN TO
     C** CONTROLLING PROGRAM WITH PARAMETERS SET UP AS DATA OF
     C** RECORD SELECTED FROM SUBFILE
     C*
     C     *IN70         IFNE      '1'                                          B***4
     C     SSSLCT        ANDNE     ' '                                          ****4
      *
     C     SSSLCT        IFNE      '1'
      *
      ** Set up parameter for ZA0240 and call the program to add
      ** another message to the program message queue
     C                   MOVEL     'FIS0031'     @MSGID
     C                   CALL      'ZA0240'
     C                   PARM                    @MSGID
     C                   MOVE      'Y'           @@ERMS
      *
     C                   ELSE
     C*
     C                   MOVE      'D'           @@TERM                         ****4
     C*
     C** MOVE RELEVANT DATA FROM RECORD READ INTO PARAMETER FOR PROGRAM
     C** BELOW IN STACK
     C*
     C                   MOVE      @TCRCY        @DDCCY                         ****4
     C                   MOVE      *BLANK        @DBRKR                         ****4
     C                   MOVE      @TBKCD        @DBKCD                         ****4
     C                   MOVE      @TBRCH        @DBRNH                         ****4
     C                   MOVE      DDVLDT        @DVDAT                         ****4
     C                   Z-ADD     DDMSDT        @DMSDT                         ****4
     C                   Z-ADD     @TCDP         @DCDP                          ****4
     C                   Z-ADD     @@DICM        @DDICM                         ****4
     C                   Z-ADD     WSPOT         @DNSPT
     C*
      ** Move  Ccy Sort Seqn number and 'In' ccy indicator
      ** to parameters for program below in stack (DL1902)
      *
     C     CEU012        IFEQ      'Y'
     C                   MOVE      KCSSNB        @DSSNB
     C                   MOVE      @WINCY        @DNINC
     C                   ENDIF
     C                   MOVEL     @PRMDN        @STRNG                         ****4
     C*
     C** SET THE SELECT FIELD FOR THE RECORD JUST PROCESSED TO BLANK
     C** AND UPDATE SUBFILE.
     C** SET ON THE SELECTION-PROCESSED INDICATOR FOR WHEN THIS
     C** PROGRAM IS RECALLED
     C*
     C                   MOVE      ' '           SSSLCT                         ****4
     C                   UPDATE    DL1905S1                                     ****4
     C*
     C                   MOVE      'Y'           @@SLCT                         ****4
     C*
     C** SET OFF INDICATORS 25/26 (ROLL UP/DOWN) SO THAT IF PROGRAM IS
     C** RECALLED A ROLL WILL NOT BE PROCESSED
     C*
     C                   MOVE      '0'           *IN25                          ****4
     C                   MOVE      '0'           *IN26                          ****4
     C*
     C                   RETURN                                                 ****4
      *
     C                   END
     C*
     C                   END                                                    E***4
     C*
     C                   END                                                    E**3
     C*
     C                   END                                                    E*2
     C*
     C** IF NO SELECTION HAS BEEN FOUND IN THE SUBFILE THEN THE
     C** <ENTER>, ROLLUP OR ROLLDOWN MUST REFER TO THE SUBFILE
     C*  (IF A SELECTION HAS BEEN FOUND/PROCESSED THEN PROGRAM WILL
     C*  NOT GET THIS FAR)
     C*
     C** IF <ENTER> HAS BEEN PRESSED IE. NOT ROLLUP OR ROLLDOWN
     C** PROCESS AN <ENTER>
     C*
     C     *IN25         IFNE      '1'                                          B*2
     C     *IN26         ANDNE     '1'                                          **2
     C*
     C                   EXSR      #BC                                          **2
     C*
     C                   END                                                    E*2
     C*
     C** IF ROLLUP HAS BEEN PRESSED SET UP KEY FROM LAST RECORD
     C** CURRENTLY ON THE SCREEN, POSITION JUST AFTER ON THE FILE
     C**  AND PROCESS A ROLLUP.
     C*
     C     *IN25         IFEQ      '1'                                          B*2
     C*
     C                   MOVEL     @BOTRD        @KRCRD                         **2
      *
     C     CEU012        IFEQ      'Y'
      *
     C     @SCRCY        IFEQ      BKEUCP
     C     *HIVAL        SETGT     DLDSBEL1
     C                   ELSE
     C     @KRLE1        SETGT     DLDSBEL1
     C                   ENDIF
      *
     C                   ELSE
     C     @KROL1        SETGT     DLDSMBL
     C                   ENDIF
     C                   EXSR      #BA                                          **2
     C*
     C                   END                                                    E*2
     C*
     C** IF ROLLDOWN HAS BEEN PRESSED SET UP KEY FROM FIRST RECORD
     C** CURRENTLY ON THE SCREEN, POSITION JUST BEFORE ON THE FILE
     C** AND PROCESS A ROLLDOWN.
     C*
     C     *IN26         IFEQ      '1'                                          B*2
     C*
     C                   MOVEL     @TOPRD        @KRCRD                         **2
     C* SETLL ON ENQUIRY FILE
     C*
     C     CEU012        IFEQ      'Y'
      *
     C     @SCRCY        IFEQ      BKEUCP
     C     *LOVAL        SETLL     DLDSBEL1
     C                   ELSE
     C     @KRLE1        SETLL     DLDSBEL1
     C                   ENDIF
      *
     C                   ELSE
     C     @KROL1        SETLL     DLDSMBL
     C                   ENDIF
     C*
     C*
     C                   EXSR      #BB                                          **2
     C*
     C                   END                                                    E*2
     C*
     C                   END                                                    E1
     C*
     C** IF THERE IS NO ERROR ON THE PROMPT DATA OR ROLLKEYS
     C*
     C     @@ERMS        IFEQ      'N'                                          B1
     C*
     C** IF THE SUBFILE INDICATOR HAS NOT ALREADY BEEN SET ON
     C** CHECK FOR THE END OF FILE AND SET THE SFLEND INDICATOR
     C** ACCORDINGLY
     C*
     C     *IN30         IFNE      '1'                                          B*2
     C*
     C                   MOVEL     @BOTRD        @KRCRD                         **2
      *
     C     CEU012        IFEQ      'Y'
     C     @SCRCY        IFEQ      BKEUCP
     C     *HIVAL        SETGT     DLDSBEL1
     C                   ELSE
     C     @KRLE1        SETGT     DLDSBEL1
     C                   ENDIF
     C                   EXSR      SRREAD
     C                   MOVE      KCINCY        @WINCY
     C                   ELSE
      *
     C     @KROL1        SETGT     DLDSMBL                                      **2
     C     @KPRT2        READE     DLDSMBL                                82    **2
     C                   ENDIF
      *
     C     *IN82         IFEQ      '1'                                          B**3
     C                   MOVE      '1'           *IN30                          ***3
     C                   ELSE                                                   X**3
     C                   MOVE      '0'           *IN30                          ***3
     C                   END                                                    E**3
     C*
     C                   END                                                    E*2
     C*
     C** IF THE ROLL/REFRESH KEYS ARE STILL INHIBITED (IE. COME FROM
     C** THE PROMPT SCREEN) THEN SET OFF THE INHIBIT INDICATOR
     C** FOR THE ROLL/REFRESH/EXIT/SELECT/HELP KEYS AND TEXT.
     C** WRITE THE FOOTER FOR THE COMMAND KEYS TEXT.
     C*
     C     *IN27         IFEQ      '1'                                          B*2
     C                   MOVE      '0'           *IN27                          **2
     C*
     C                   WRITE     DL1905F1                                     **2
     C*
     C** ACTIVATE THE OVRDTA INDICATOR FOR THE SUBTITLES - THESE
     C** ARE ONLY WANTED ONCE THERE IS A SUBFILE AND SHOULD REMAIN ON
     C** THE SCREEN UNTIL THE NEXT NEW SUBFILE - SO TURN OFF AFTER
     C** REWRITING TITLES AND SUBFILE CONTROL
     C*
     C                   MOVE      '1'           *IN28                          **2
     C                   END                                                    E*2
     C*
     C** RESET THE TIME AND OUTPUT THE HEADER
     C*
     C                   TIME                    @TTIME                         *1
     C                   WRITE     DL1905F0                                     *1
     C*
     C** IF NO ERRORS THEN THE NEW SUBFILE IS DISPLAYED ELSE (ERROR)
     C** OVERRIDE DATA ATTRIBUTES OF SELECT FIELDS IN ERROR AND DO NOT
     C** REDISPLAY THE SUBFILE - THE PREVIOUS ONE IS LEFT ON THE SCREEN
     C*
     C                   MOVE      '1'           *IN35                          *1
     C*
     C                   ELSE                                                   X1
     C*
     C** IF ERROR ON PROMPT DATA FROM STACK - ABOVE OR BELOW - AND NOT
     C** THE FIRST TIME PROGRAM HAS BEEN CALLED THEN SET ON *IN35 TO
     C** REMOVE SUBFILE LEFT ON SCREEN FROM PREVIOUS CALL AND *IN28
     C** TO REMOVE SELECT TEXT LEFT FROM PREVIOUS CALL
     C*
     C     @FROM         IFEQ      'S'                                          B*2
     C     @CALL1        ANDEQ     'N'                                          **2
     C                   MOVE      '1'           *IN35                          **2
     C                   MOVE      '1'           *IN28                          **2
     C                   ELSE                                                   X*2
     C                   MOVE      '0'           *IN35                          **2
     C                   END                                                    E*2
     C*
     C                   END                                                    E1
      *
      ** F7 - Toggle between 'Display Euro Equivalent' and
      ** 'Display Ccy Amount' is pressed (available only
      ** when Position/Risk Enquiries & Reports feature is on)
      *
     C     CEU012        IFEQ      'Y'
     C     @WINCY        IFEQ      'Y'
     C     *IN68         ANDEQ     '0'
     C     @SCRCY        ANDNE     BKEUCP
     C                   MOVE      *ON           *IN31
     C                   ELSE
     C                   MOVE      *OFF          *IN31
     C                   ENDIF
      *
     C     @SCRCY        IFEQ      BKEUCP
     C     *IN68         ANDEQ     '0'
     C                   MOVE      *ON           *IN31
     C                   ENDIF
     C                   WRITE     DL1905F1
     C                   ENDIF
     C*
     C** WRITE THE MESSAGE SUBFILE - IF THERE IS AN ERROR THERE
     C** WILL BE A MESSAGE TO DISPLAY OTHERWISE IT WILL REMOVE ANY
     C** PREVIOUS ERROR MESSAGES ON THE SCREEN
     C*
     C                   MOVE      '1'           *IN46
     C                   WRITE     DL1905C0
     C*
     C** Initialise the message-processed-already fields for next enq.
     C                   MOVE      'N'           @ALR56
     C                   MOVE      'N'           @ALR57
     C                   MOVE      *BLANKS       @ALR58
     C                   MOVE      'N'           @ALR59
     C*
     C** WRITE THE ENQUIRY SUBFILE CONTROL; 'INVITE' WILL BE ACTIVATED
     C*
     C                   MOVE      '1'           *IN36
     C                   WRITE     DL1905C1
     C                   MOVE      '0'           *IN28
     C*
     C** DE-ACTIVATE THE OVRDTA INDICATOR FOR THE SELECT FIELDS IN
     C** CASE IT WAS ON IE. PROGRAM HAS BEEN RE-CALLED WITH NEW PROMPTS
     C** TO DISPLAY - DO NOT WANT TO KEEP WRITING THEM
     C*
     C                   MOVE      '0'           *IN24
     C*
     C** READ THE DISPLAY FILE FOR ROLLS/REFRESH/PROMPTS - IF HELP THEN
     C** DO 'HELP' AND RE-READ FILE; IF REFRESH ON THE PROMPT SCREEN
     C** (*IN27 AND *IN05 ON) THEN, SINCE REFRESH CANNOT BE DONE HERE,
     C** RE-READ THE DISPLAY FILE; IF REFRESH ON SUBFILE SCREEN THEN
     C** EXIT DO-LOOP.
     C*
     C     *IN27         DOUEQ     '0'                                          B1
     C     *IN10         ANDEQ     '0'                                          *1
     C     *IN05         OREQ      '0'                                          *1
     C     *IN10         ANDEQ     '0'                                          *1
     C*
     C                   MOVE      '0'           *IN10                          *1
     C                   MOVE      '0'           *IN05                          *1
     C************       READ      DL1905DF                             0573    CAAA02
      /free
         Now1Time = %time();                                                  //CAAA02
                                                                              //CAAA02
         read DL1905C1;                                                       //CAAA02
         if %eof;                                                             //CAAA02
            *in73='1';                                                        //CAAA02
         endif;                                                               //CAAA02
                                                                              //CAAA02
         Now2Time = %time();                                                  //CAAA02
                                                                              //CAAA02
         WaitTime = %diff(Now2Time:Now1Time:*SECONDS);                        //CAAA02
         if WaitTime >= MaxWaitTime;                                          //CAAA02
            *in05 = '1';                                                      //CAAA02
         endif;                                                               //CAAA02
      /end-free
     C*
     C                   END                                                    E1
     C*
     C** SET INDICATOR TO SHOW FROM WHERE ENQUIRY HAS COME TO 'L'
     C** FOR LOOPING INCASE ANOTHER ENQUIRY IS MADE FROM THIS PROGRAM
     C*
     C                   MOVE      'L'           @FROM
     C*
     C     @CALL1        IFNE      'N'                                          B1
     C                   MOVE      'N'           @CALL1            1            *1
     C                   END                                                    E1
     C*
     C     #B9           ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #AB      - SET UP PROMPT FIELDS - WITH DEFAULTS IF NECESSARY  *
     C*                                                               *
     C* CALLS      *PSSR   -  DATABASE ERROR HANDLING                 *
     C*                                                               *
     C* CALLED BY  #A      -  INITIAL PROCESSING                      *
     C*                                                               *
     C* FLDS USED  @KCCCY  -  CURRENCY       )    STRING SENT IN      *
     C*            @KBRCA  -  BRANCH CODE    )    PARAMETERS          *
     C*            @KCVDT  -  VALUE DATE     )                        *
     C*                                                               *
     C*            @SCRCY  -  CURRENCY       )  SET UP IN PROMPTS     *
     C*            @SBRCA  -  BRANCH CODE    )                        *
     C*            @SVLDT  -  VALUE DATE     )                        *
     C*            @SVLDY  -  VALUE DAY NO   )                        *
     C*            @FBRCA  -  DEFAULT BRANCH CODE                     *
     C*            @FVLDT  -  DEFAULT VALUE DATE                      *
     C*            @FROM   -  WHERE PROG CALLED FROM                  *
     C*
     C     #AB           BEGSR
     C*
     C** IF FROM MENU SET UP ALL KEY FIELDS WITH DEFAULT VALUES WHERE
     C** REQUIRED. IF FROM STACK AND BLANK THEN SET TO DEFAULT VALUE
     C** ONLY IF BLANK DOES NOT MEAN 'ALL'.
     C*
     C** LEAVE CURRENCY AS IT COMES - IF FROM MENU THEN BLANK AS NO
     C** DEFAULT GIVEN OR VALID FROM STACK
     C*
     C                   MOVE      @KCCCY        @SCRCY
     C*
     C** IF FROM MENU THEN SET UP BRANCH WITH DEFAULT VALUE ELSE
     C** (FROM STACK) IF NOT BLANK CONVERT TO MIDAS FORMAT AND STORE
     C** BOTH ELSE (FROM STACK AND BLANK) SET BOTH TO BLANK.
     C*
     C     @FROM         IFEQ      'M'                                          B1
     C     @KBRCA        OREQ      *BLANK
     C                   MOVE      @FBRCA        @SBRCA
     C                   ELSE                                                   X1
     C*
     C                   MOVE      @KBRCA        @SBRCA
     C*
     C                   END                                                    E1
     C*
     C** IF VALUE DATE BLANK THEN SET UP VALUE DATE WITH TODAYS
     C** DATE FROM THE INSTALLATION FILE
     C*
     C     @KFVDT        IFEQ      *BLANK                                       B1
     C*
     C**  Move date to ZADATE which is 7 chars long to be converted to
     C**  6 chars long (MMMDDYY/DDMMMYY to MMDDYY/DDMMYY)
     C*
     C                   MOVE      @FVLDT        ZADATE
     C                   MOVE      '0'           *IN18
     C                   EXSR      CVDT
     C                   MOVE      ZDATE         @SVLDT
     C                   ELSE                                                   X1
     C*
     C**  Move date to ZADATE which is 7 chars long to be converted to
     C**  6 chars long (MMMDDYY/DDMMMYY to MMDDYY/DDMMYY)
     C*
     C                   MOVE      @KFVDT        ZADATE
     C                   MOVE      '0'           *IN18
     C                   EXSR      CVDT
     C                   MOVE      ZDATE         @SVLDT
     C                   END                                                    E1
     C*
     C** IF FROM MENU OR BLANK SET UP BOOK CODE WITH DEFAULT VALUE ELSE
     C** (NOT BLANK) SET UP AS FROM PARAMETER STRING
     C*
     C     @FROM         IFEQ      'M'                                          B1
     C     @KBKCD        OREQ      *BLANK                                       *1
     C                   MOVE      @FBKCD        @SBKCD                         *1
     C                   ELSE                                                   X1
     C*
     C                   MOVE      @KBKCD        @SBKCD                         *1
     C*
     C                   END                                                    E1
     C*
     C*
     C     #AB9          ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #BA      - ROLLUP ENQUIRY SUBFILE                             *
     C*                                                               *
     C* CALLS    - ZA0240  -  ADD A MESSAGE TO PROGRAM MESSAGE QUEUE  *
     C*            #BD     -  EDIT ENQUIRY SUBFILE DATA               *
     C*            SRREAD  -  Determine file to read                  *
     C*                                                               *
     C* CALLED BY  #B      -  MAIN PROCESSING                         *
     C*            #BB     -  ROLLDOWN ENQUIRY SUBFILE                *
     C*                                                               *
     C* FLDS USED  RRN     -  COUNT FOR ROLLING UP AND DOWN           *
     C*            @@ERMS  -  ERROR-MESSAGE-TO-DISPLAY INDICATOR - Y/N*
     C*            @TOPRD  -  FIRST RECORD CURRENTLY ON SUBFILE       *
     C*            @BOTRD  -  LAST RECORD CURRENTLY ON SUBFILE        *
     C*            DLRCRD  -  RECORD DATA OFF DEALS FILE (DATA STRUCT)*
     C*            @MSGID -   ERROR MESSAGE NUMBER TO SEND TO ZA0240  *
     C*                                                               *
     C*****************************************************************
     C*
     C     #BA           BEGSR
     C*
     C*
     C** DO FOR AS MANY RECORDS AS THERE ARE IN THE SUBFILE PAGE
     C*
     C                   Z-ADD     1             RRN               2 0
     C*
     C     RRN           DOUEQ     17                                           B1
     C*
     C** READ THE DEALS FILE
     C*
     C     CEU012        IFEQ      'Y'
     C                   EXSR      SRREAD
     C                   MOVE      KCINCY        @WINCY
     C                   ELSE
     C     @KPRT2        READE     DLDSMBL                                82    *1
     C                   ENDIF
     C*
     C     *IN82         IFEQ      '1'                                          B*2
     C*
     C     RRN           IFEQ      1                                            B**3
     C*
     C* IF ROUTINE HAS BEEN CALLED BY REFRESH;THEN DEAL DETAILS
     C* HAVE BEEN DELETED
     C*
     C     *IN05         IFEQ      '1'                                          B***4
     C                   MOVEL     'FIS0014'     @MSGID                         ****4
     C                   WRITE     DCLEAR                                       ****4
     C*
     C                   ELSE                                                   X***4
     C*
     C** IF END OF FILE AND HAVEN'T WRITTEN ONE RECORD TO SUBFILE
     C** OUTPUT A 'NO RECORDS TO ROLLUP' MESSAGE AND RESET THE
     C** ERROR-MESSAGE-TO-DISPLAY INDICATOR
     C*
     C                   MOVEL     'FIS0004'     @MSGID                         ****4
     C*
     C                   END                                                    E***4
     C*
     C                   CALL      'ZA0240'                                     ***3
     C                   PARM                    @MSGID                         ***3
     C                   MOVE      'Y'           @@ERMS                         ***3
     C*
     C                   END                                                    E**3
     C*
     C** RESET THE COUNTER TO 17 TO END DO LOOP AND SET THE
     C** SUBFILE END INDICATOR ON
     C*
     C                   Z-ADD     17            RRN                            **2
     C                   MOVE      '1'           *IN30                          **2
     C*
     C** ELSE IF IT IS NOT THE END OF FILE THEN CLEAR THE SUBFILE,
     C** SET OFF THE SUBFILE END INDICATOR AND STORE THE RECORD THE
     C** FIRST TIME ROUND.
     C*
     C                   ELSE                                                   X*2
     C*
     C** THE FIRST TIME ROUND CLEAR THE SUBFILE, SET OFF THE SUBFILE
     C** END INDICATOR AND STORE THE FIRST RECORD IN THE SUBFILE
     C*
     C     RRN           IFEQ      1                                            B**3
     C*
     C** CLEAR THE SUBFILE BY SETTING OFF THE SUBFILE DISPLAY AND
     C** THE SUBFILE DISPLAY CONTROL INDICATORS AND THEN WRITING
     C** THE ENQUIRY SUBFILE CONTROL FORMAT
     C*
     C                   MOVE      '0'           *IN35                          ***3
     C                   MOVE      '0'           *IN36                          ***3
     C                   WRITE     DL1905C1                                     ***3
     C*
     C                   MOVE      '0'           *IN30                          ***3
     C                   MOVE      DLRCRD        @TOPRD           32
     C*
     C                   END                                                    E**3
     C*
     C** STORE THE RECORD AS THE LAST ONE IN CASE THERE ARE NO MORE
     C*
     C                   MOVE      DLRCRD        @BOTRD           32
     C*
     C** EDIT THE FIELDS AND THEN WRITE THE RECORD TO THE SUBFILE
     C*
     C                   EXSR      #BD                                          **2
     C                   WRITE     DL1905S1                                     **2
     C                   ADD       1             RRN                            **2
     C*
     C                   END                                                    E*2
     C*
     C                   END                                                    E1
     C*
     C     #BA9          ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #BB      - ROLLDOWN ENQUIRY SUBFILE                           *
     C*                                                               *
     C* CALLS    - ZA0240  -  ADD A MESSAGE TO PROGRAM MESSAGE QUEUE  *
     C*            #BD     -  EDIT ENQUIRY SUBFILE DATA               *
     C*                                                               *
     C* CALLED BY  #B      -  MAIN PROCESSING                         *
     C*                                                               *
     C* FLDS USED  RRN     -  COUNT FOR ROLLING UP AND DOWN           *
     C*            @@ERMS  -  ERROR-MESSAGE-TO-DISPLAY INDICATOR - Y/N*
     C*            @TOPRD  -  FIRST RECORD CURRENTLY ON SUBFILE       *
     C*            @BOTRD  -  LAST RECORD CURRENTLY ON SUBFILE        *
     C*            DLRCRD  -  RECORD DATA OFF DEALS FILE (DATA STRUCT)*
     C*            @MSGID -   ERROR MESSAGE NUMBER TO SEND TO ZA0240  *
     C*            @KCCCY -   CURRENCY                                *
     C*            @KBRCA -   BRANCH                                  *
     C*                                                               *
     C*****************************************************************
     C*
     C     #BB           BEGSR
     C*
     C** READ THE DEALS FILE BACKWARDS AND FILL THE SUBFILE SIMILARLY
     C** DO FOR AS MANY RECORDS AS THERE ARE IN THE SUBFILE PAGE
     C** (STARTING AT THE BOTTOM)
     C*
     C                   Z-ADD     16            RRN
     C*
     C     RRN           DOUEQ     0                                            B1
     C*
     C** READ THE PREVIOUS RECORD
     C*
     C     CEU012        IFEQ      'Y'
     C                   READP     DLDSBEL1                               82
     C                   ELSE
     C                   READP     DLDSMBL                                82    *1
     C                   ENDIF
     C*
     C* CHECK RECORD READ MATCHES PROMPT FIELDS
     C*
     C     KCCCY         IFNE      @KCCCY                                       B*2
     C     KCBRCA        ORNE      @KBRCA
     C     KCBOKC        ORNE      @KBKCD                                       **2
     C     CEU012        OREQ      'Y'
     C     @SCRCY        ANDNE     BKEUCP
     C     @SCRCY        ANDNE     KCCCY
     C     CEU012        OREQ      'Y'
     C     @SCRCY        ANDEQ     BKEUCP
     C     KCINCY        ANDEQ     'N'
     C     KCCCY         ANDNE     BKEURO
     C                   MOVE      '1'           *IN82                          **2
     C                   END                                                    E*2
     C*
     C*
     C     *IN82         IFEQ      '1'                                          B*2
     C*
     C     RRN           IFEQ      16                                           B**3
     C*
     C** IF BEGINNING OF FILE OR BEGINNING OF RELEVANT DATA ON FILE
     C** AND HAVEN'T WRITTEN ONE RECORD TO THE SUBFILE THEN OUTPUT
     C** A 'NO RECORDS TO ROLLDOWN' MESSAGE AND RESET THE
     C** ERROR-MESSAGE-TO-DISPLAY INDICATOR
     C*
     C                   MOVEL     'FIS0004'     @MSGID                         ***3
     C                   CALL      'ZA0240'                                     ***3
     C                   PARM                    @MSGID                         ***3
     C                   MOVE      'Y'           @@ERMS                         ***3
     C*
     C** ELSE THERE ARE RECORDS TO ROLLDOWN BUT BEGINNING OF FILE OR
     C** RELEVANT DATA REACHED BEFORE SUBFILE FULL - POSITION AT THE
     C** BEGINNING OF FILE OR DATA - PROCESS AS FOR A ROLLUP
     C*
     C                   ELSE                                                   X**3
     C*
     C                   MOVE      '1'           *IN15                          ***3
      *
     C     CEU012        IFEQ      'Y'
      *
     C     @SCRCY        IFEQ      BKEUCP
     C     *LOVAL        SETLL     DLDSBEL1
     C                   ELSE
     C     @KPRE2        SETLL     DLDSBEL1
     C                   ENDIF
      *
     C                   ELSE
     C     @KPRT2        SETLL     DLDSMBL
     C                   ENDIF
     C                   EXSR      #BA                                          ***3
     C*
     C                   END                                                    E**3
     C*
     C** RESET THE COUNTER TO 0 TO END DO LOOP
     C*
     C                   Z-ADD     0             RRN                            **2
     C*
     C** ELSE IF IT IS NOT THE BEGINNING OF THE FILE
     C*
     C                   ELSE                                                   X*2
     C*
     C** THE FIRST TIME ROUND CLEAR THE SUBFILE, SET OFF THE SUBFILE
     C** END INDICATOR AND STORE THE LAST RECORD IN THE SUBFILE
     C*
     C     RRN           IFEQ      16                                           B**3
     C*
     C** CLEAR THE SUBFILE BY SETTING OFF THE SUBFILE DISPLAY AND
     C** THE SUBFILE DISPLAY CONTROL INDICATORS AND THEN WRITING
     C** THE ENQUIRY SUBFILE CONTROL FORMAT
     C*
     C                   MOVE      '0'           *IN35                          ***3
     C                   MOVE      '0'           *IN36                          ***3
     C                   WRITE     DL1905C1                                     ***3
     C*
     C                   MOVE      '0'           *IN30                          ***3
     C                   MOVE      DLRCRD        @BOTRD                         ***3
     C*
     C                   END                                                    E**3
     C*
     C** STORE THE RECORD AS THE FIRST ONE IN CASE IT IS
     C*
     C                   MOVE      DLRCRD        @TOPRD                         **2
     C*
     C** EDIT THE FIELDS AND THEN WRITE THE RECORD TO THE SUBFILE
     C*
     C                   EXSR      #BD                                          **2
     C                   WRITE     DL1905S1                                     **2
     C                   SUB       1             RRN                            **2
     C*
     C                   END                                                    E*2
     C*
     C                   END                                                    E1
     C*
     C     #BB9          ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #BC      - ENTER NEW PROMPT DATA                              *
     C*                                                               *
     C* CALLS      #BCB    -  SET UP NEW SCREEN HEADINGS              *
     C*            #BCC    -  DETERMINE FILE AND KEY TO BE USED       *
     C*            #BD     -  EDIT ENQUIRY SUBFILE DATA               *
     C*            SRREAD  -  Determine file to read                  *
     C*            #KD     -  DETERMINE FILE - SETLL WITH PROMPT KEY  *
     C*            ZA0240  -  ADD MESSAGE TO PROGRAM MESSAGE QUEUE    *
     C*            *PSSR   -  DATABASE ERROR HANDLING                 *
     C*                                                               *
     C* CALLED BY  #B      -  MAIN PROCESSING                         *
     C*                                                               *
     C* FLDS USED  @@ERMS  -  ERROR-MESSAGE-TO-DISPLAY INDICATOR - Y/N*
     C*            DLRCRD  -  RECORD DATA OFF DEALS FILE (DATA STRUCT)*
     C*            @KRCRD  -  RECORD DATA OF KEYS                     *
     C*            @KPRMT  -  KEY USED FOR NEW PROMPT DATA            *
     C*                                                               *
     C*****************************************************************
     C*
     C     #BC           BEGSR
     C*
     C** IF NEW PROMPTS ON SCREEN (IE. NOT FROM STACK) THEN
     C** VALIDATE THE DATA ENTERED IN THE PROMPTS. ELSE FROM STACK
     C** TRANSLATE (AND VALIDATE) VALUE DATE TO MIDAS FORMAT.
     C*
     C     @FROM         IFNE      'S'                                          B1
     C                   EXSR      #BCA                                         *1
     C                   ELSE                                                   X1
     C*
     C     @SVLDT        IFNE      @FVLDT                                       B*2
     C*
     C** Convert date format from MMDDYY/DDMMYY to MMMDDYY/DDMMMYY
     C*
     C                   MOVE      @SVLDT        ZDATE
     C                   MOVE      '1'           *IN18
     C                   EXSR      CVDT
     C*
     C*
     C**  Set up value date key field.
     C*
     C                   MOVE      ZADATE        @@VLDT
     C                   EXSR      ZVLDT                                        **2
     C*
     C     @@RTN         IFEQ      '1'                                          B**3
     C                   Z-ADD     1             DBASE                          ***************
     C*                    EXSR *PSSR                      * DBERROR 001 *
     C                   ELSE                                                   X**3***********
     C                   Z-ADD     @@DAYN        @KCVDT                         ***3
     C                   END                                                    E**3
     C*
     C                   ELSE                                                   X*2
     C                   Z-ADD     @FVLDY        @KCVDT                         **2
     C                   END                                                    E*2
     C*
     C                   END                                                    E1
     C*
     C** IF THERE ARE NO ERRORS
     C*
     C     @@ERMS        IFNE      'Y'                                          B1
     C*
     C*
     C*
     C                   MOVEL     @SRCRD        @KRCRD                         *1
      *
     C     CEU012        IFEQ      'Y'
     C     @FROM         IFEQ      'S'
     C                   MOVE      WSSNB         @KRCRD
     C                   MOVE      WSSNB         DLRCRD
     C                   ELSE
     C                   MOVE      KCSSNB        @KRCRD
     C                   ENDIF
      *
     C     @SCRCY        IFEQ      BKEUCP
     C     *LOVAL        SETLL     DLDSBEL1
     C                   ELSE
     C     @KPRE1        SETLL     DLDSBEL1
     C                   ENDIF
      *
     C                   ELSE
     C     @KPRT1        SETLL     DLDSMBL                                      *1
     C                   ENDIF
     C*
     C** DO FOR AS MANY RECORDS AS THERE ARE IN THE SUBFILE PAGE
     C*
     C                   Z-ADD     1             RRN               2 0          *1
     C*
     C     RRN           DOUEQ     17                                           B*2
     C*
     C** READ THE DEALS FILE
     C*
     C     CEU012        IFEQ      'Y'
     C                   EXSR      SRREAD
     C                   MOVE      KCINCY        @WINCY
     C                   ELSE
     C     @KPRT2        READE     DLDSMBL                                82    **2
     C                   ENDIF
     C*
     C     *IN82         IFEQ      '1'                                          B**3
     C*
     C     RRN           IFEQ      1                                            B***4
     C*
     C** IF NOT ONE RECORD ON FILE FOR THESE PROMPTS THEN SEND MESSAGE
     C*
     C                   MOVE      '1'           *IN68                          ****4
     C*
     C** SET UP PARAMETER FOR ZA0240 AND CALL THE PROGRAM TO ADD
     C** ANOTHER MESSAGE TO THE PROGRAM MESSAGE QUEUE
     C*
     C                   MOVEL     'FIS0003'     @MSGID                         ****4
     C                   CALL      'ZA0240'                                     ****4
     C                   PARM                    @MSGID                         ****4
     C*
     C** SET ON ERROR-ON-VALIDATION INDICATOR, ERROR-MESSAGE-TO-DISPLAY
     C** INDICATOR AND ACTIVATE THE OVRATR KEYWORD ON THE ENQUIRY
     C** SUBFILE CONTROL TO REVERSE IMAGE THE FIELD AND POSITION THE
     C** CURSOR
     C*
     C                   MOVE      '1'           *IN69                          ****4
     C                   MOVE      'Y'           @@ERMS                         ****4
     C                   MOVE      '1'           *IN29                          ****4
     C*
     C                   END                                                    E***4
     C*
     C** RESET THE COUNTER TO 17 TO END DO LOOP AND SET THE
     C** SUBFILE END INDICATOR ON
     C*
     C                   Z-ADD     17            RRN                            ***3
     C                   MOVE      '1'           *IN30                          ***3
     C*
     C** ELSE IF THERE ARE RECORDS ON FILE THEN THE FIRST TIME ROUND
     C** CLEAR THE SUBFILE, SET OFF THE SUBFILE END INDICATOR,
     C** STORE THE RECORD AND SET UP NEW SCREEN HEADINGS
     C*
     C                   ELSE                                                   X**3
     C*
     C     RRN           IFEQ      1                                            B***4
     C*
     C** CLEAR THE SUBFILE BY SETTING OFF THE SUBFILE DISPLAY AND
     C** THE SUBFILE DISPLAY CONTROL INDICATORS AND THEN WRITING
     C** THE ENQUIRY SUBFILE CONTROL FORMAT
     C*
     C                   MOVE      '0'           *IN35                          ****4
     C                   MOVE      '0'           *IN36                          ****4
     C                   WRITE     DL1905C1                                     ****4
     C*
     C                   MOVE      '0'           *IN30                          ****4
     C                   MOVE      DLRCRD        @TOPRD                         ****4
     C*
     C** SET UP NEW SCREEN HEADINGS
     C*
     C                   EXSR      #BCB                                         ****4
     C*
     C                   END                                                    E***4
     C*
     C** STORE THE RECORD AS THE LAST ONE IN CASE THERE ARE NO MORE
     C*
     C                   MOVE      DLRCRD        @BOTRD                         ***3
     C*
     C** CALC AND EDIT THE FIELDS,THEN WRITE THE RECORD TO THE SUBFILE
     C*
     C                   EXSR      #BD                                          ***3
     C                   WRITE     DL1905S1                                     ***3
     C                   ADD       1             RRN                            ***3
     C*
     C                   END                                                    E**3
     C                   END                                                    E*2
     C                   END                                                    E1
     C*
     C     #BC9          ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #BCA     - VALIDATE PROMPT DATA                               *
     C*                                                               *
     C* CALLS      ZA0240 - ADD A MESSAGE TO THE PROGRAM MESSAGE QUEUE*
     C*                                                               *
     C* CALLED BY  #BC - ENTER NEW PROMPT DATA                        *
     C*                                                               *
     C* FLDS USED  @SCRCY  -  CURRENCY SELECTED IN PROMPTS            *
     C*            @SBRCA  -  BRANCH SELECTED IN PROMPTS              *
     C*            @SVLDT  -  VALUE DATE SELECTED IN PROMPTS          *
     C*            @@ERMS - ERROR-MESSAGE-TO-DISPLAY INDICATOR - Y/N  *
     C*            @MSGID - ERROR MESSAGE NUMBER TO SEND TO ZA0240    *
     C*                                                               *
     C*****************************************************************
     C*
     C     #BCA          BEGSR
     C*
     C** VALIDATE THE CURRENCY
     C** - CURRENCY MUST BE ENTERED AND EXIST ON CURRENCY FILE
     C*
     C     @SCRCY        IFEQ      *BLANK                                       B1
     C*
     C** SET UP PARAMETER FOR ZA0240 AND CALL THE PROGRAM TO ADD
     C** ANOTHER MESSAGE TO THE PROGRAM MESSAGE QUEUE
     C*
     C                   MOVEL     'FIS0005'     @MSGID           10            *1
     C                   CALL      'ZA0240'                                     *1
     C                   PARM                    @MSGID                         *1
     C*
     C** SET ON ERROR-ON-CURRENCY AND ERROR-ON-VALIDATION INDICATORS
     C*
     C                   MOVE      '1'           *IN69                          *1
     C                   MOVE      '1'           *IN60                          *1
     C*
     C                   ELSE                                                   X1
      *
      ** Call Access Program for Currency Details to check
      **      Currency exists.
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      @SCRCY        @CCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
     C*
      *
      ** If currency not found ....
     C     @RTCD         IFNE      *BLANKS
     C*
     C     CEU012        IFEQ      'N'
     C     @SCRCY        ANDNE     BKEUCP
     C** SET UP PARAMETER FOR ZA0240 AND CALL THE PROGRAM TO ADD
     C** ANOTHER MESSAGE TO THE PROGRAM MESSAGE QUEUE
     C*
     C                   MOVEL     'FIS0001'     @MSGID           10            **2
     C                   CALL      'ZA0240'                                     **2
     C                   PARM                    @MSGID                         **2
     C*
     C** SET ON ERROR-ON-VALIDATION INDICATOR
     C*
     C                   MOVE      '1'           *IN69                          **2
     C                   MOVE      '1'           *IN60                          **2
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Move validated currency code to screen field and
      **      set up *in24 to update screen fields
     C                   MOVEL     A6CYCD        @SCRCY
     C                   MOVE      '1'           *IN24
      *
      ** If currency found, set up currency decimal places and
      **    default interest calculation basis.
     C                   MOVE      A6NBDP        CDP
     C                   MOVE      A6DICB        DICM
                                                                                CAAA02
     C************       Z-ADD     A6MMSD        ZZDTIN                         CAAA02
      * Subroutine replaced by external module                                  CAAA02
     C************       EXSR      ZDAT10                                       CAAA02
     c                   callb     'ZDATE10'                                    CAAA02
     c                   parm                    A6MMSD                         CAAA02
     c                   parm                    SPOT                           CAAA02
     C************       Z-ADD     ZZMDNO        SPOT                           CAAA02
                                                                                CAAA02
      *
      ** Store Sort Sequence number and 'In' ccy indicator
      ** to key and work field respectively, for later use.
      *
     C     CEU012        IFEQ      'Y'
     C                   MOVE      A6SSNB        KCSSNB
     C                   MOVE      A6INCY        @WINCY
     C                   ENDIF
     C*
     C                   END                                                    E*2
     C*
     C                   END                                                    E1
      *
      ** Validate the FRA trading book code
      *
      ** If screen field is blank, set to default
     C     @SBKCD        IFEQ      *BLANKS
     C                   MOVE      @FBKCD        @SBKCD
     C                   END
      *
      ** Call Access Program for Book Details to check book code
     C                   CALL      'AOBOOKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      @SBKCD        @BOKC             2
     C     SDBOOK        PARM      SDBOOK        DSFDY
      *
      ** If book code not found process error
     C     @RTCD         IFNE      *BLANK
     C*
     C*  SET UP PARAMETER FOR ZA0240 AND CALL THE PROGRAM TO ADD
     C*  ANOTHER MESSAGE TO THE PROGRAM MESSAGE QUEUE
     C*
     C                   MOVEL     'FIS0009'     @MSGID                         ***3
     C                   CALL      'ZA0240'                                     ***3
     C                   PARM                    @MSGID                         ***3
     C*
     C***SET*ON*ERROR-ON-VALIDATION INDICATOR (ERROR-ON-BOOK-CODE
     C***INDICATOR*ON*ALREADY)
     C** SET ON ERROR-ON-BOOK-CODE AND ERROR-ON-VALIDATION INDICATORS
     C*
     C                   MOVE      '1'           *IN63
     C                   MOVE      '1'           *IN69                          ***3
     C                   ELSE
      *
      ** If book code found, set up screen book code and
      **    set up *in24 so screen fields are updated
     C                   MOVE      BDBKCD        @SBKCD
     C                   MOVE      '1'           *IN24
     C*
     C                   END                                                    E**3
     C*
     C*
     C** VALIDATE THE VALUE DATE
      * If field is blank use run date (default)
     C     @SVLDT        IFEQ      *BLANK                                       B1
     C*
     C** Convert date from MMMDDYY/DDMMMYY to MMDDYY/DDMMYY
     C*
     C                   MOVE      @FVLDT        ZADATE
     C                   MOVE      '0'           *IN18
     C                   EXSR      CVDT
     C                   MOVE      ZDATE         @SVLDT
     C                   END
     C*
     C*
     C** IF NOT RUN DATE (DEFAULT) THEN VALIDATE THE DATE
     C*
     C*
     C** Convert date from MMMDDYY/DDMMMYY to MMDDYY/DDMMYY format
     C*
     C                   MOVE      @FVLDT        ZADATE
     C                   MOVE      '0'           *IN18
     C                   EXSR      CVDT
     C                   MOVE      ZDATE         ZDATE6            6
     C     @SVLDT        IFNE      ZDATE6
     C*
     C**  If @SVLDT is not blank, check input date if it conforms
     C**  with the valid month numbers listed in array @MON and the
     C**  year in array @YR. Check also if day input is valid, i.e.
     C*   ranging from 01 to 31.
     C                   MOVEL     @SVLDT        @DDMM             4
     C                   MOVEL     @DDMM         @DN               2
     C                   MOVEL     @DN           @D1               1
     C     @D1           IFEQ      *BLANKS
     C                   MOVEL     '0'           @DN
     C                   MOVEL     '0'           @SVLDT
     C                   END
     C                   MOVE      @DDMM         @MN               2
     C                   MOVE      @SVLDT        @YN               2
     C                   MOVEL     @YN           @Y1               1
     C                   MOVE      @YN           @Y2               1
     C     @DN           LOOKUP    @DYN                                   90
     C     *IN90         IFEQ      '1'
     C     @MN           LOOKUP    @MON                                   90
     C                   END
     C     *IN90         IFEQ      '1'
     C     @Y1           LOOKUP    @YR                                    90
     C                   END
     C     *IN90         IFEQ      '1'
     C     @Y2           LOOKUP    @YR                                    90
     C                   END
     C*
     C**  If entered date has invalid character/s, set *IN99 on for
     C**  error message.
     C*
     C     *IN90         IFNE      '1'
     C                   MOVE      '1'           *IN99
     C*
     C**  If entered date is numeric, validate date entered. *IN99 is
     C**  set on if error in validation, if successful store no. of
     C**  days.
     C*
     C                   ELSE
                                                                                CAAA02
     C************       MOVE      @SVLDT        ZDATE                          CAAA02
      * Subroutine replaced by external module                                  CAAA02
     C************       EXSR      ZDATE1                                       CAAA02
     c                   callb     'ZDATE1'                                     CAAA02
     c                   parm                    @SVLDT                         CAAA02
     c                   parm                    @@DAYN                         CAAA02
     c                   parm                    BJDFIN                         CAAA02
     c                   parm                    ZErrorFlag                     CAAA02
     C************       MOVE      ZDAYNO        @@DAYN                         CAAA02
     c                   if        ZErrorFlag = 'Y'                             CAAA02
     c                   eval      *in99 = '1'                                  CAAA02
     c                   endif                                                  CAAA02
                                                                                CAAA02
     C                   END
     C*
     C     *IN99         IFEQ      '1'
     C*
     C** SET UP PARAMETER FOR ZA0240 AND CALL THE PROGRAM TO ADD
     C** ANOTHER MESSAGE TO THE PROGRAM MESSAGE QUEUE
     C*
     C                   MOVEL     'FIS0022'     @MSGID           10            ***3
     C                   CALL      'ZA0240'                                     ***3
     C                   PARM                    @MSGID                         ***3
     C*
     C** SET ON ERROR-ON-VALUE-DATE AND ERROR-ON-VALIDATION INDICATORS
     C*
     C                   MOVE      '1'           *IN62                          ***3
     C                   MOVE      '1'           *IN69                          ***3
     C*
     C                   ELSE                                                   X**3
     C*
     C**  Ensure that value date field does not have embedded blanks
     C*
     C                   MOVE      @SVLDT        ZDATE             6 0
     C                   MOVE      ZDATE         @SVLDT
     C                   MOVE      '1'           *IN24
     C                   MOVEL     @SVLDT        @D1
     C     @D1           IFEQ      '0'
     C                   MOVEL     ' '           @SVLDT
     C                   END
     C*                                                                   E23419
     C** VALUE DATE MUST NOT BE BEFORE RUN DATE
     C*
     C     @@DAYN        IFLT      BJRDNB
     C                   CALL      'ZA0240'                                     ****4
     C                   PARM      'FIS0020'     @MSGID                         ****4
     C                   MOVE      '1'           *IN62                          ****4
     C                   MOVE      '1'           *IN69                          ****4
     C*
     C* ELSE MOVE MIDAS DAY NO. TO KEY FIELD
     C                   ELSE                                                   X***4
     C                   Z-ADD     @@DAYN        @KCVDT                         ****4
     C*
     C                   END                                                    E***4
     C                   END                                                    E**3
     C*
     C* ELSE IF RUN DATE SET UP KEY WITH DEFAULT MIDAS DAY NO.
     C*
     C                   ELSE                                                   X*2
     C                   Z-ADD     @FVLDY        @KCVDT
     C*
     C                   END                                                    E*2
     C*
      *
      ** Validate the Branch Code
      *
      ** If system is multibranching
     C     BGMBIN        IFEQ      'Y'
      *
      ** If screen field is blank, set to default
     C     @SBRCA        IFEQ      *BLANKS
     C                   MOVE      @FBRCA        @SBRCA
     C                   END
      *
      ** If screen branch code is 'ALL'
     C     @SBRCA        IFEQ      'ALL'
      *
      ** Set up parameter for ZA0240 and call the program to add
      **     another message to the program message queue
     C                   MOVEL     'FIS0028'     @MSGID
     C                   CALL      'ZA0240'
     C                   PARM                    @MSGID
      *
      ** Set on error-on-validation indicator
     C                   MOVE      '1'           *IN69
     C                   MOVE      '1'           *IN61
      *
     C                   ELSE
      *
      ** Call access program for branch codes to check branch exists
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      @SBRCA        WBRCA             3
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      *
      ** Booking branch code not found, process error
     C     @RTCD         IFNE      *BLANK
      *
      ** Set up parameter for ZA0240 and call the program to add
      **     another message to the program message queue
     C                   MOVEL     'FIS0002'     @MSGID
     C                   CALL      'ZA0240'
     C                   PARM                    @MSGID
      *
      ** Set on error-on-validation indicator
     C                   MOVE      '1'           *IN69
     C                   MOVE      '1'           *IN61
      *
     C                   ELSE
      *
      ** If branch code found
      *
      ** Move validated branch code to screen field and
      **    set up *in24 so screen fields are updated
      **      rewrite onto screen
     C                   MOVE      A8BRCD        @SBRCA
     C                   MOVE      '1'           *IN24
      *
      ** Check user authorised to branch by calling ZVBBU
     C                   CALL      'ZVBBU'
     C                   PARM      @SBRCA        @BRCA             3
     C                   PARM                    ERR               1 0
      *
      ** If no valid branches for this user
     C     ERR           IFEQ      1
     C                   MOVEL     'FIS0025'     @MSGID
     C                   CALL      'ZA0240'
     C                   PARM                    @MSGID
     C                   MOVE      '1'           *IN69
     C                   MOVE      '1'           *IN61
     C                   END
      *
      ** If branch not valid for this user
     C     ERR           IFEQ      2
     C                   MOVEL     'FIS0026'     @MSGID
     C                   CALL      'ZA0240'
     C                   PARM                    @MSGID
     C                   MOVE      '1'           *IN61
     C                   MOVE      '1'           *IN69
     C                   END
      *
     C                   END
     C                   END
     C                   END
      *
     C*
     C** IF ERROR IN VALIDATION THEN SET ON ERROR-MESSAGE-TO-DISPLAY
     C** INDICATOR AND ACTIVATE THE OVRATR KEYWORD ON THE ENQUIRY
     C** SUBFILE CONTROL TO REVERSE IMAGE THE FIELD AND POSITION THE
     C** CURSOR
     C*
     C     *IN69         IFEQ      '1'                                          B1
     C                   MOVE      'Y'           @@ERMS                         *1
     C                   MOVE      '1'           *IN29                          *1
     C                   END                                                    E1
     C*
     C     #BCA9         ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*
     C*  #BD - CALC SCREEN VALUES
     C*
     C*  CALLED BY   - #BC
     C*
     C*  CALLS       - ZDATE8 - FORMAT DATE
     C*                CALCPL - Calculate Open (Revalued) P/L
     C*                ZNPV   - Net Present Value a Future Amount
     C*                ZRATE2 - CONVERT AMOUNT TO DISPLAY
     C*                #BDA   - CONVERT AMOUNT TO DISPLAY
     C*
     C*
     C*  FLDS USED   - @@PERD - PERIOD
     C*                @@PERL - PERIOD
     C*                @@VDAT - VAL DATE
     C*                @@VDTT - VAL DATE
     C*                @@CCY  - CURRENCY
     C*                @@INPR - WORK FIELD FOR ZRATE2
     C*                @@AVER - FORMATED AV. PRICE
     C*                @DMRKT - FORMATED MARKET RATE
     C*****************************************************************
     C*
     C     #BD           BEGSR
     C*
     C* CALC TENOR
     C     KCMDAT        SUB       KCVDAT        DDTENR
     C*
     C* CONVERT MATURITY DATE TO DSP FORMAT
     C*
     C                   Z-ADD     KCMDAT        ZDAYNO
     C                   EXSR      ZDATE8
     C                   MOVE      *BLANK        DDMDAT
     C                   MOVE      ZADATE        DDMDAT
     C     BJDFIN        IFEQ      'M'
     C                   MOVEL     DDMDAT        WRK5              5
     C                   MOVEL     WRK5          WRK3              3
     C                   MOVE      WRK5          WRK2              2
     C                   MOVEL     WRK2          WRK5
     C                   MOVE      WRK3          WRK5
     C                   MOVEL     WRK5          DDMDAT
     C                   END
     C*
     C* CONVERT VALUE DATE TO DSP FORMAT
     C*
     C                   Z-ADD     KCVDAT        ZDAYNO
     C                   EXSR      ZDATE8
     C*
     C* STORE DATE (DDMMMYY) IN HIDDEN FIELD SO THAT WHEN SELECTION IS
     C* MADE ON ANY BUT THE FIRST RECORD FOR A GIVEN DATE (FOR WHICH
     C* THE VALUE DATE IS NOT DISPLAYED AND THEREFORE NOT READ) THE
     C* DATE IS AVAILABLE TO BE SENT AS A PARAMETER
     C*
     C                   MOVE      *BLANK        DDVLDT
     C                   MOVE      ZADATE        DDVLDT
     C*
     C* STORE MIDAS DATE IN HIDDEN FIELD
     C*
     C                   Z-ADD     KCVDAT        DDMSDT
     C*
     C* DISPLAY DATE IF CHANGED FROM PREV RECORD OR FIRST RECORD
     C*
     C                   MOVE      *BLANK        DDVDAT
     C     KCVDAT        IFNE      @@VDAT                                        B*1
     C     RRN           OREQ      1                                              *1
     C                   MOVE      ZADATE        DDVDAT                           *1
     C     BJDFIN        IFEQ      'M'
     C                   MOVEL     DDVDAT        WRK5              5
     C                   MOVEL     WRK5          WRK3              3
     C                   MOVE      WRK5          WRK2              2
     C                   MOVEL     WRK2          WRK5
     C                   MOVE      WRK3          WRK5
     C                   MOVEL     WRK5          DDVDAT
     C                   END
     C                   END                                                     E*1
     C*
     C* CALC PERIOD
     C*
     C     DDTENR        IFLE      100                                           B*1
     C                   MOVE      ' 3M'         @@PERD            3              *1
     C                   END                                                     E*1
     C*
     C     DDTENR        IFGE      101                                           B*1
     C     DDTENR        ANDLE     190                                            *1
     C                   MOVE      ' 6M'         @@PERD                           *1
     C                   END                                                     E*1
     C*
     C     DDTENR        IFGE      191                                           B*1
     C     DDTENR        ANDLE     285                                            *1
     C                   MOVE      ' 9M'         @@PERD                           *1
     C                   END                                                     E*1
     C*
     C     DDTENR        IFGE      286                                           B*1
     C     DDTENR        ANDLE     375                                            *1
     C                   MOVE      '12M'         @@PERD                           *1
     C                   END                                                     E*1
     C*
     C     DDTENR        IFGE      376                                           B*1
     C                   MOVE      'REM'         @@PERD                           *1
     C                   END                                                     E*1
     C*
     C                   MOVE      *BLANK        DDPERD
     C*
     C     @@PERD        IFNE      @@PERL                                        B*1
     C     KCVDAT        ORNE      @@VDAT                                         *1
     C     RRN           OREQ      1                                              *1
     C                   MOVE      @@PERD        DDPERD                           *1
     C                   END                                                     E*1
     C*
     C                   MOVE      @@PERD        @@PERL            3
     C                   Z-ADD     KCVDAT        @@VDAT            5 0
     C* If the Interest Rates have been amended since the last rebuild
     C* of the Discount Factors, (RADA <> 0) then send a message.
     C     @ALR59        IFNE      'Y'
     C                   MOVE      'Y'           @ALR59            1
     C     *DTAARA       DEFINE                  DLMMDF
     C                   IN        DLMMDF
     C     RADA          IFNE      0
     C                   MOVEL     'FIS0059'     @MSGID
     C                   CALL      'ZA0240'
     C                   PARM                    @MSGID
     C                   END
     C                   END
     C*
     C* Set the Average Price, Market Rate, Open P/L and Closed P/L
     C* to blanks
     C                   MOVE      *BLANKS       DDAVER
     C                   MOVE      *BLANKS       DDMRKT
     C                   MOVE      *BLANKS       DDOPEN
     C                   MOVE      *BLANKS       DDCLSD
     C** If Value Date not yet reached, then calculate the
     C** Average Price, Market Price, Open P/L and the Closed P/L.
     C     KCVDAT        IFGT      BJRDNB
     C*
     C** CALCULATE THE OPEN (REVALUED) P/L
     C                   EXSR      CALCPL
     C*
     C** If no FRA Rates for Currency/Base Rate then send message
     C** (ensure that message only sent once)
     C     *IN21         IFEQ      '1'
     C     @ALR56        IFNE      'Y'
     C                   MOVE      'Y'           @ALR56            1
     C                   MOVEL     @@CCY         WFIVE             5
     C                   MOVE      WBSRD         WFIVE
     C                   MOVEL     WFIVE         WDATA
     C                   MOVEL     'FIS0056'     @MSGID
     C                   CALL      'ZA0440'
     C                   PARM                    @MSGID
     C                   PARM                    WDATA
     C                   END
     C                   MOVEL     '   *.*'      DDMRKT
     C                   MOVE      '* '          DDOPEN
     C                   ELSE
     C                   Z-ADD     WFRART        @@INPR
     C                   EXSR      ZRATE2
     C                   MOVEL     @@OUTR        @DMRKT            9
     C                   MOVEL     @DMRKT        DDMRKT
     C*
     C** If no MM Interest Rates/Discount Factors for Currency then
     C** send message (ensure that message only sent once)
     C     *IN20         IFEQ      '1'
     C     @ALR57        IFNE      'Y'
     C                   MOVE      'Y'           @ALR57            1
     C                   MOVEL     @@CCY         WDATA
     C                   MOVEL     'FIS0057'     @MSGID
     C                   CALL      'ZA0440'
     C                   PARM                    @MSGID
     C                   PARM                    WDATA
     C                   END
     C                   MOVE      '* '          DDOPEN
     C                   ELSE
     C*
     C** else, all rates exist, so edit Open P/L for output
      *
      ** Convert amount to Euro equivalent for 'In' ccy
      ** when F7 is pressed for Euro Equivalent (*IN32=*ON)
      *
     C                   MOVE      'N'           SCHCK             1
     C     @SCRCY        IFEQ      BKEUCP
     C     *IN32         IFEQ      '0'
     C                   MOVE      'Y'           SCHCK
     C                   ENDIF
     C                   ENDIF
      *
     C     CEU012        IFEQ      'Y'
     C     SCHCK         IFEQ      'N'
     C     KCINCY        IFEQ      'Y'
     C     *IN32         ANDEQ     *ON
     C     @SCRCY        OREQ      BKEUCP
     C     KCCCY         ANDNE     BKEURO
     C                   MOVE      *BLANKS       PRTCD
     C                   Z-ADD     WPLNPV        PFRAM
     C                   MOVE      KCCCY         PFRCY
     C                   MOVE      BKEURO        PTOCY
     C                   Z-ADD     0             POUTA
     C                   Z-ADD     0             PINTA
     C                   Z-ADD     0             PEXRT
     C                   MOVE      *BLANKS       PMDIN
      *
     C                   CALL      'EU0200'                             1111
     C                   PARM                    PRTCD             7
     C                   PARM                    PFRAM            18 3
     C                   PARM                    PFRCY             3
     C                   PARM                    PTOCY             3
     C                   PARM                    POUTA            15 0
     C                   PARM                    PINTA            18 3
     C                   PARM                    PEXRT            15 9
     C                   PARM                    PMDIN             1
      *
     C     PRTCD         IFEQ      *BLANKS
     C                   Z-ADD     POUTA         WPLNPV
     C                   ELSE
     C                   MOVEL     '*CALL   '    DBFILE
     C                   MOVEL     'EU0200  '    DBKEY                           ************
     C                   Z-ADD     2             DBASE                           * DBERR 02 *
     C                   EXSR      *PSSR                                         ************
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   Z-ADD     WPLNPV        ZFLD15
     C                   MOVE      CDP           ZDECS
     C                   EXSR      #BDA
     C                   MOVE      ZOUT21        DDOPEN
     C                   END
     C                   END
     C*
     C** CALCALATE the Net Present Value of the Closed P/L then edit
     C                   Z-ADD     SPOT          ZNPSDT
     C                   Z-ADD     KCMDAT        ZNPFDT
     C                   Z-ADD     KCCDPL        ZNPAMT
     C                   MOVE      @@CCY         ZNPCCY
     C     KCNTPS        IFLT      0
     C                   MOVE      'B'           ZNPBOF
     C                   ELSE
     C                   MOVE      'O'           ZNPBOF
     C                   END
     C                   MOVE      @@DICM        ZCBCBS
     C/COPY WNCPYSRC,DL1905C003
     C                   EXSR      ZNPV
     C/COPY WNCPYSRC,DL1905C004
     C*
     C** If no MM Interest Rates for Currency/Base Rate then send
     C** message (ensure that message only sent once)
     C     *IN93         IFEQ      '1'
     C     @ALR57        IFNE      'Y'
     C                   MOVE      'Y'           @ALR57
     C                   MOVEL     @@CCY         WDATA
     C                   MOVEL     'FIS0057'     @MSGID
     C                   CALL      'ZA0440'
     C                   PARM                    @MSGID
     C                   PARM                    WDATA
     C                   END
     C                   MOVE      '* '          DDCLSD
     C                   ELSE
     C*
     C** else, rates exist, so edit Closed P/L for output
     C                   Z-ADD     ZNPOUT        ZFLD15
     C                   MOVE      CDP           ZDECS
     C                   EXSR      #BDA
     C                   MOVE      ZOUT21        DDCLSD
     C                   END
     C*
     C* EDIT AVERAGE PRICE
     C*
     C                   Z-ADD     KCAVEP        @@INPR
     C                   EXSR      ZRATE2
     C                   MOVEL     @@OUTR        @@AVER            9
     C                   MOVE      @@AVER        DDAVER
     C*
     C** Else, Rate Fix Date has been reached : move asterisks into
     C** Average Price, Market Price, Open P/L and the Closed P/L. Send
     C** explanatory message, if not already sent for this Value Date.
     C                   ELSE
     C*
     C                   MOVEL     '  *.*'       DDAVER
     C                   MOVEL     '   *.*'      DDMRKT
     C                   MOVE      '* '          DDOPEN
     C                   MOVE      '* '          DDCLSD
     C     @ALR58        IFNE      DDVLDT
     C                   MOVE      DDVLDT        @ALR58            7
     C                   MOVEL     DDVLDT        WDATA
     C                   MOVEL     'FIS0058'     @MSGID
     C                   CALL      'ZA0440'
     C                   PARM                    @MSGID
     C                   PARM                    WDATA            45
     C                   END
     C*
     C                   END
     C*
     C* EDIT NET POSITION
     C*
     C     KCNETP        MULT      KCNTPS        @KCNET           13 0
     C                   MOVE      @TCRCY        @@CCY
     C                   Z-ADD     CDP           @@CDP
     C                   Z-ADD     @KCNET        @@IAMT
      *
      ** Convert amount to Euro equivalent for 'In' ccy
      ** when F7 is pressed for Euro Equivalent (*IN32=*ON)
      *
     C                   MOVE      'N'           SCHCK             1
     C     @SCRCY        IFEQ      BKEUCP
     C     *IN32         IFEQ      '0'
     C                   MOVE      'Y'           SCHCK
     C                   ENDIF
     C                   ENDIF
      *
     C     CEU012        IFEQ      'Y'
     C     SCHCK         IFEQ      'N'
     C     KCINCY        IFEQ      'Y'
     C     *IN32         ANDEQ     *ON
     C     @SCRCY        OREQ      BKEUCP
     C     KCCCY         ANDNE     BKEURO
     C                   MOVE      *BLANKS       PRTCD
     C                   Z-ADD     @@IAMT        PFRAM
     C                   MOVE      KCCCY         PFRCY
     C                   MOVE      BKEURO        PTOCY
     C                   Z-ADD     0             POUTA
     C                   Z-ADD     0             PINTA
     C                   Z-ADD     0             PEXRT
     C                   MOVE      *BLANKS       PMDIN
      *
     C                   CALL      'EU0200'                             1111
     C                   PARM                    PRTCD             7
     C                   PARM                    PFRAM            18 3
     C                   PARM                    PFRCY             3
     C                   PARM                    PTOCY             3
     C                   PARM                    POUTA            15 0
     C                   PARM                    PINTA            18 3
     C                   PARM                    PEXRT            15 9
     C                   PARM                    PMDIN             1
      *
     C     PRTCD         IFEQ      *BLANKS
     C                   Z-ADD     POUTA         @@IAMT
     C                   ELSE
     C                   MOVEL     '*CALL   '    DBFILE
     C                   MOVEL     'EU0200  '    DBKEY                           ************
     C                   Z-ADD     3             DBASE                           * DBERR 03 *
     C                   EXSR      *PSSR                                         ************
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   EXSR      ZAMTE
     C                   MOVE      @@AMNT        @DNETP
     C*
     C** Suffix '+', '-' or blank to net position depending if +ve, -ve
     C** or zero
     C*
     C     @KCNET        IFGT      *ZEROS
     C                   MOVE      '+'           DDNETP
     C                   ELSE
     C     @KCNET        IFLT      *ZEROS
     C                   MOVE      '-'           DDNETP
     C                   ELSE
     C                   MOVE      ' '           DDNETP
     C                   END
     C                   END
     C**
     C*
     C*EDIT BASE RATE CODE
     C*
     C                   MOVE      KCBSRD        DDBASE
     C*
     C     #BD9          ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRREAD - Determine file to read when Position/Risk           *
      *           Enquiries and reports feature is on.                *
      *                                                               *
      *  Called By: #B  - Main Processing                             *
      *             #BA - Rollup Enquiry Subfile                      *
      *             #BC - Enter New Prompt Data                       *
      *                                                               *
      *  Returns  : *IN82 - End of file                               *
      *                                                               *
      *****************************************************************
      *
     C     SRREAD        BEGSR                                                  *** SRREAD ***
      *
     C     @SCRCY        IFEQ      BKEUCP
      *
     C     *IN82         DOWEQ     '0'
     C                   READ      DLDSBEL1                               82
     C     *IN82         IFEQ      '0'
     C     KCBOKC        ANDEQ     @KBKCD
     C     KCBRCA        ANDEQ     @KBRCA
     C     KCINCY        IFEQ      'Y'
     C     KCCCY         OREQ      BKEURO
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C                   ELSE
     C     @KPRE2        READE     DLDSBEL1                               82
     C                   ENDIF
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CALCPL - Subroutine to Calculate the Profit or Loss.         *
      *                                                               *
      *  Called By: #BD - Calculate Screen Values                     *
      *  Calls: GETRAT - Get the FRA Market Rate.                     *
      *         ZDLINT - DL Calculate Interest between Two Dates      *
      *         ZNPV   - Net Present Value a Future Amount            *
      *                                                               *
      *  Returns  : WPL    (Profit/Loss)                              *
      *             WPLNPV (Net Present Value of Profit/Loss)         *
      *             *IN20  (No MM Rates for Currency)                 *
      *             *IN21  (No FRA Rate for Currency)                 *
      *                                                               *
      *****************************************************************
      *
     C     CALCPL        BEGSR                                                  *** CALCPL ***
      *
      ***  Initialise Fields.
     C                   Z-ADD     0             WPL              15 0
     C                   Z-ADD     0             WPLNPV           15 0
     C                   SETOFF                                       2021
      *
      ***  The Rate used in the calculation of Profit is the difference
      ***  of the Current Market Rate and the Average Price.
      *
      ***  Get the FRA Market Rate.
     C                   EXSR      GETRAT
      *
      ***  If no FRA Rate for Currency, set on *IN21 and exit SR.
     C     *IN73         IFEQ      '1'
     C                   SETON                                        21
     C                   GOTO      CALEND
     C                   END
      *
      ***  Calculate the differential Rate for SR/ZDLINT.
     C     WFRART        SUB       KCAVEP        ZDLRAT
      *
      ***  Calculate the Interest.
     C                   Z-ADD     KCNETP        ZDLAMT
     C                   Z-ADD     KCVDAT        ZCBSDT
     C                   Z-ADD     KCMDAT        ZCBEDT
     C                   MOVE      @@DICM        ZCBCBS
     C                   EXSR      ZDLINT
     C                   Z-ADD     ZDLOUT        WPL
      *
      ***  If Net Position negative (ie. Sold), then correct the sign.
     C     KCNTPS        IFLT      0
     C                   Z-SUB     WPL           WPL
     C                   END
     C/COPY WNCPYSRC,DL1905C008
      *
      ***  Net Present Value the Profit/Loss to Spot Date.
      ***  Note: The MM Rates assume the use of the Calculation Basis
      ***  on the Currency, therefore this must be used for Net Present
      ***  Valuing, and not the Calculation Basis of the Deal.
     C                   Z-ADD     SPOT          ZNPSDT
     C                   Z-ADD     KCMDAT        ZNPFDT
     C                   Z-ADD     WPL           ZNPAMT
     C/COPY WNCPYSRC,DL1905C009
     C                   MOVE      @@CCY         ZNPCCY
      *
      ***  Loss means paying out, therefore use Bid/Borrow Rate.
      ***  Profit means receiving, therefore use Offer/Lend Rate.
     C     WPL           IFLT      0
     C                   MOVE      'B'           ZNPBOF
     C                   ELSE
     C                   MOVE      'O'           ZNPBOF
     C                   END
      *
     C                   MOVE      @@DICM        ZCBCBS
     C/COPY WNCPYSRC,DL1905C001
     C                   EXSR      ZNPV
     C/COPY WNCPYSRC,DL1905C005
      *
      ***  Check for no Rates for Currency.
     C     *IN93         IFEQ      '1'
     C                   SETON                                        20
     C                   GOTO      CALEND
     C                   END
      *
     C                   Z-ADD     ZNPOUT        WPLNPV
      *
     C     CALEND        TAG                                                    *** CALEND ***
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GETRAT - Subroutine to Obtain the FRA Market Rate.           *
      *                                                               *
      *  Called By: CALCPL                                            *
      ***Calls:*ZINTPL*-*Straight*Line*Interpolation*******************
      *  Calls: ZAINTPL - Straight Line Interpolation                 *
      *                                                               *
      *  Returns  : WFRART (FRA Market Rate)                          *
      *             *IN73  (Set on if Currency/Base Rate not on File) *
      *                                                               *
      *****************************************************************
      *
     C     GETRAT        BEGSR                                                  *** GETRAT ***
      *
      ***  Initialise Fields and set Base Rate key field
     C                   Z-ADD     0             WFRART           11 7
     C                   SETOFF                                       717273
     C                   MOVE      KCBSRD        WBSRD             2 0
      *
      ***  First set Lower Limits using Currency/Base Rate/Value Date.
      *
     C     KFRAR1        SETLL     DLFRARL4                           71
      *
      ***  If not EOF, Read Equal the next record of the Currency/Base
      ***  Rate.
      *
     C     *IN71         IFEQ      '0'
     C     KFRAR2        READE     DLFRARL4                               72
      *
      ***  If a record was read and is the correct date, set up the FRA
      ***  Rate and exit.
      *
     C     *IN72         IFEQ      '0'
     C     FRVMDN        ANDEQ     KCVDAT
     C                   Z-ADD     FRRATE        WFRART
     C                   GOTO      RATEND
     C                   END
      *
     C                   END
      *
      ***  If a record has not yet been retrieved, reposition the file
      ***  and read the last record of the Currency/Base Rate.
      *
     C     *IN71         IFEQ      '1'
     C     *IN72         OREQ      '1'
     C     KFRAR1        SETGT     DLFRARL4
      *
      ***  If Record found then set up the FRA Rate, else the Currency/
      ***  Base Rate is not on File (*IN73 returned).
      *
     C     KFRAR2        READPE    DLFRARL4                               73
     C     *IN73         IFEQ      '0'
     C                   Z-ADD     FRRATE        WFRART
     C                   END
     C                   GOTO      RATEND
      *
     C                   END
      *
      ***  If this point has been reached, a record has been found with
      ***  a date greater than the one we want and it will probably be
      ***  necessary to use interpolation, so set up Far Date and Far
      ** Rate fields (for PGM/ZAINTPL).
      *
     C                   Z-ADD     FRVMDN        ZIFDAT
     C                   Z-ADD     FRRATE        ZIFRAT
      *
      ***  Read the Previous record to get the Near Rate. If not found,
      ***  (*IN71), then the record already retrieved is the first for
      ***  this Currency/Base Rate and that FRA Rate should be used.
      *
     C     KFRAR2        READPE    DLFRARL4                               71
      *
     C     *IN71         IFEQ      '1'
     C                   Z-ADD     ZIFRAT        WFRART
     C                   ELSE
      *
      ***  Else set up Near Date, Near Rate and Broken Date and then
      ***  interpolate the Rate.
      *
     C                   Z-ADD     FRVMDN        ZINDAT
     C                   Z-ADD     FRRATE        ZINRAT
     C                   Z-ADD     KCVDAT        ZIBDAT
     C                   Z-ADD     0             ZIBRAT
     C                   CALL      'ZAINTPL'
     C                   PARM                    ZINDAT            5 0
     C                   PARM                    ZIBDAT            5 0
     C                   PARM                    ZIFDAT            5 0
     C                   PARM                    ZINRAT           13 9
     C                   PARM                    ZIFRAT           13 9
     C                   PARM                    ZIBRAT           13 9
     C                   Z-ADD     ZIBRAT        WFRART
     C                   END
      *
     C     RATEND        TAG                                                    *** RATEND ***
      *
     C/COPY WNCPYSRC,DL1905C007
     C                   ENDSR
      *
      *****************************************************************
     C/EJECT
     C*****************************************************************
     C***/COPY ZSRSRC,ZAMTEZ3                                                   CAAA02
     C/COPY ZSRSRC,ZAMTEZ3LE                                                    CAAA02
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #BCB     - SET UP NEW SCREEN HEADINGS                         *
     C*                                                               *
     C* CALLS                                                         *
     C*                                                               *
     C* CALLED BY  #BC    - ENTER NEW PROMPT DATA                     *
     C*                                                               *
     C* FLDS USED  @FBKCD - BROKER CODE - DEFAULT VALUE               *
     C*                                                               *
     C*            @TBKCD - BOOK CODE  )                              *
     C*            @TCRCY - CURRENCY   )  VALUES FOR NEW SCREEN       *
     C*            @TBRCH - BRANCH     )  HEADINGS                    *
     C*            @TVLMY - VALUE DATE - NOT DISPLAYED ON SCREEN      *
     C*            @TCDP  - CCY DEC PLACES - NOT DISPLAYED ON SCREEN  *
     C*            @@DICM - DFLT INT CALC METH NOT DISPLAYED ON SCREEN*
     C*            @@CCY  - WORK FIELD FOR CURRENCY                   *
     C*                                                               *
     C*            @SBKCD - BOOK CODE  )                              *
     C*            @SCRCY - CURRENCY   )                              *
     C*            @SBRCA - BRANCH     )  VALID ENTRIES RECEIVED      *
     C*            @SVLDT - VALUE DATE )  FROM PROMPTS                *
     C*                                                               *
     C*            @@ERMS - ERROR-MESSAGE-TO-DISPLAY INDICATOR - Y/N  *
     C*            @MSGID - ERROR MESSAGE NUMBER TO SEND TO ZA0240    *
     C*                                                               *
     C*****************************************************************
     C*
     C     #BCB          BEGSR
     C*
     C*
     C*
     C** SET UP HEADING FOR CURRENCY
     C** - THE SAME AS THE VALID PROMPT ENTRY
     C*
     C                   MOVE      @SCRCY        @TCRCY
     C*
     C** ALTHOUGH NOT OUTPUT ON SCREEN STORE DECIMAL PLACES FOR THIS
     C** CURRENCY USED IN ZFRPED (LATER SENT UP OR DOWN IN STACK);
     C** STORE DEFAULT INTEREST CALC METHOD; AND STORE CURRENCY FOR
     C** INTEREST CALC METHOD;
     C*
     C                   MOVE      CDP           @TCDP             1 0
     C                   Z-ADD     DICM          @@DICM            1 0
     C                   Z-ADD     SPOT          WSPOT             5 0
     C                   MOVE      @TCRCY        @@CCY             3
     C*
     C** SET UP HEADING FOR BRANCH
     C** - IF BLANK WAS ENTERED THEN WILL HAVE BEEN SETUP WITH DEFAULT
     C*
     C                   MOVE      @SBRCA        @TBRCH
     C*
     C** SET UP HEADING FOR BOOK CODE
     C*
     C                   MOVE      @SBKCD        @TBKCD
     C*
     C** SET UP VALUE DATE NOT TO BE DISPLAYED IN TITLES BUT TO BE SENT
     C** UP IN THE STACK IF NEEDED
     C*
     C** Convert date from MMYY to MMMYY. '01' is used as 'dummy day'.
     C*
     C                   MOVEL     '01'          ZDATE
     C                   MOVE      @SVLMY        ZDATE
     C                   MOVE      '1'           *IN18
     C                   EXSR      CVDT
     C                   MOVE      ZADATE        @TVLMY            5
     C*
     C** If US format (ie MMDDYY)
     C     BJDFIN        IFEQ      'M'
     C                   MOVEL     @SMT          @TVLMY
     C                   END
     C*
     C     #BCB9         ENDSR
     C*****************************************************************
     C/EJECT
     C********************************************************************
     C**                                                                 *
     C**   #BDA -  subroutine to insert a sign into a                    *
     C**            numeric field and to blank out leading zeros         *
     C**   Input fields:   ZFLD15 15/0                                   *
     C**                   ZDECS  1/0                                    *
     C**   Arrays:         ZS1    15/1/0                                 *
     C**                   ZS2    21/1/                                  *
     C**                                                                 *
     C**   Output fields:  ZOUT21 21                                     *
     C*****************************************************************
     C     #BDA          BEGSR                                                               *
     C*
     C* Define/Clear fields
     C*
     C                   Z-ADD     ZFLD15        ZFLD15           15 0
     C                   Z-ADD     ZDECS         ZDECS             1 0
     C                   MOVE      *BLANKS       ZOUT21           21
     C*
     C*       SET UP WORK FIELDS
     C*
     C                   Z-ADD     0             ZS1
     C                   MOVE      ' '           ZS2
     C*
     C                   Z-ADD     15            Z1                2 0
     C                   Z-ADD     20            Z2                2 0
     C*
     C     15            SUB       ZDECS         ZINTS             2 0
     C*
     C* Check if numeric field is negative and move minus sign to end
     C* position; if greater than zero, move plus sign, otherwise
     C* leave as zero
     C*
     C     ZFLD15        IFLT      *ZEROS                                            B*1
     C                   MOVE      '-'           ZS2(21)                              *1
     C                   Z-SUB     ZFLD15        ZFLD15                               *1
     C                   ELSE                                                        X*1
     C     ZFLD15        IFGT      *ZEROS                                            B**2
     C                   MOVE      '+'           ZS2(21)                              **2
     C                   END                                                         E**2
     C                   END                                                         E*1
     C*
     C                   Z-ADD     ZFLD15        ZWRK15
     C*
     C*
     C** ROUND UP FIGURES TO NEAREST INTEGER & REMOVE DEC PLACES
     C*
     C     ZDECS         IFEQ      1                                            B1
     C                   ADD       5             ZWRK15                         *1
     C                   MOVEL     ZWRK15        @ZWK14           14 0          *1
     C                   Z-ADD     @ZWK14        ZWRK15                         *1
     C                   END                                                    E1
     C*
     C     ZDECS         IFEQ      2                                            B1
     C                   ADD       50            ZWRK15                         *1
     C                   MOVEL     ZWRK15        @ZWK13           13 0          *1
     C                   Z-ADD     @ZWK13        ZWRK15                         *1
     C                   END                                                    E1
     C*
     C     ZDECS         IFEQ      3                                            B1
     C                   ADD       500           ZWRK15                         *1
     C                   MOVEL     ZWRK15        @ZWK12           12 0          *1
     C                   Z-ADD     @ZWK12        ZWRK15                         *1
     C                   END                                                    E1
     C*
     C*
     C*       SET UP INTEGERS
     C*
     C                   Z-ADD     *ZEROS        CNT3              1 0
     C     Z1            DOUEQ     *ZEROS                                         B*1
     C                   MOVE      ZS1(Z1)       ZS2(Z2)                           *1
     C                   SUB       1             Z1                                *1
     C                   SUB       1             Z2                                *1
     C*
     C*
     C                   END                                                      E*1
     C*
     C*       PUT IN LEADING BLANKS
     C*
     C                   Z-ADD     1             Z2
     C     ZS2(Z2)       DOWEQ     '0'                                            B*1
     C     ZS2(Z2)       OREQ      ' '                                             *1
     C                   MOVE      ' '           ZS2(Z2)                           *1
     C                   ADD       1             Z2                                *1
     C     Z2            CABEQ     21            ZS20                              *1
     C                   END                                                      E*1
     C*
     C*       IF NO INTEGERS PUT IN LEADING ZERO
     C*
     C     ZS20          TAG                                                    ** ZS20 TAG **
     C*
     C     Z2            IFEQ      21                                             B*1
     C                   SUB       1             Z2                                *1
     C                   MOVE      '0'           ZS2(Z2)                           *1
     C                   END                                                      E*1
     C*
     C*       SET UP OUTPUT FIELD
     C                   MOVEA     ZS2           ZOUT21
     C*
     C     #BDA9         ENDSR
     C*
     C********************************************************************
     C/COPY WNCPYSRC,DL1905C010
     C/EJECT
     C*****************************************************************
      ***/COPY ZSRSRC,ZDATE8Z3                                                  CAAA02
      /COPY ZSRSRC,ZDATE8Z3LE                                                   CAAA02
     C*****************************************************************
     C/EJECT
     C*****************************************************************
      ***/COPY ZSRSRC,ZVLDTZ3                                                   CAAA02
      /COPY ZSRSRC,ZVLDTZ3LE                                                    CAAA02
     C*****************************************************************
     C*****************************************************************
      /EJECT
     C***/COPY ZSRSRC,ZDLINTZ1                                                  CAAA02
     C/COPY ZSRSRC,ZDLINTZ1LE                                                   CAAA02
      /EJECT
     C***/COPY ZSRSRC,ZNPVZ1                                                    CAAA02
     C/COPY ZSRSRC,ZNPVZ1LE                                                     CAAA02
      /EJECT
     C***/COPY ZSRSRC,ZCBDYSZ1                                                  CAAA02
     C/COPY ZSRSRC,ZCBDYSZ1LE                                                   CAAA02
      /EJECT
     C***/COPY ZSRSRC,ZDATE2Z2                                                  CAAA02
     C/COPY ZSRSRC,ZDATE2Z2LE                                                   CAAA02
      /EJECT
     C***/COPY ZSRSRC,ZDAT10Z2                                                  CAAA02
     C/EJECT
     C*****************************************************************
      ***/COPY ZSRSRC,ZRATE2Z2                                                  CAAA02
      *COPY*ZSRSRC,ZRATE2Z2LE***                                                       CAAA02 245692
      /COPY ZSRSRC,ZRATE2Z3LE                                                                 245692
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C***/COPY ZSRSRC,ZDATE1Z2                                                  CAAA02
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #AA      - CALCULATE DEFAULT PROMPT DATA                      *
     C*                                                               *
     C* CALLS      #AAA    -  READ INSTALLATION FILE                  *
     C*            *PSSR   -  DATABASE ERROR HANDLING                 *
     C*                                                               *
     C* CALLED BY  #A      -  INITIAL PROCESSING                      *
     C*                                                               *
     C* FLDS USED  @KYBCH  -  KEY FOR BRANCH FILE                     *
     C*            @K1BCH  -  PART OF KEY FOR BRANCH FILE             *
     C*            @K2BCH  -  PART OF KEY FOR BRANCH FILE             *
     C*            @FBRCA  -  DEFAULT BRANCH CODE                     *
     C*                                                               *
     C*****************************************************************
     C*
     C     #AA           BEGSR
     C*
     C** OPEN ALL FILES
     C*
     C                   OPEN      FDMNTHLL
     C                   OPEN      MUSER
     C*
     C** EXSR #AAA TO READ INSTALLATION FILE
     C*
     C                   EXSR      #AAA
      *
     C     CEU012        IFEQ      'Y'
     C                   OPEN      DLDSBEL1
     C                   ELSE
     C                   OPEN      DLDSMBL
     C                   ENDIF
     C*
     C** SET UP THE RUN DATE FOR THE SCREEN HEADING
     C                   MOVE      BJMRDT        @TDATE
     C*
     C*
     C** SET UP VALUE DATE WITH TODAYS DATE FROM THE INSTALLATION FILE
     C                   MOVE      BJMRDT        @FVLDT            7
     C                   Z-ADD     BJRDNB        @FVLDY            5 0
     C*
     C** Store the date format used later in call to ZVLDT
     C                   MOVE      BJDFIN        @@DFMT
     C*
     C** Store the date format, as *IN98, used later in call to ZDATE8.   S23420
     C** If Date format is 'M'(American), change date format from
     C** UK(DDMMMYY) to US(MMMDDYY). Also set up Screen Run date
     C** and Screen Value date.
     C     BJDFIN        IFEQ      'M'                                          B1
     C                   MOVE      '1'           *IN98                          *1
     C                   MOVE      BJMRDT        @DAT7                          *1
     C*                                                    *1
     C** If day is before 10th, insert leading zero        *1
     C     @DDY          IFLT      10                                           *1
     C     @DDY          ANDGT     0                                            *1
     C                   MOVEL     '0'           @DAY                           *1
     C                   END                                                    *1
     C*                                                    *1
     C                   MOVE      @DAY          @WRK5             5            *1
     C                   MOVEL     @MMT          @WRK5                          *1
     C*                                                    *1
     C                   MOVEL     @WRK5         @TDATE                         *1
     C                   MOVEL     @WRK5         @FVLDT                         *1
     C                   END                                                    E1
     C*
     C** READ MONTH SHORTNAMES FILE USED IN ZDATE8 AND ZVLDT
     C*
     C     1             CHAIN     FDMNTHLL                           86
     C*
     C     *IN86         IFEQ      '1'                                          B1
     C*                                                    ***************
     C                   MOVEL     'FDMNTHLL'    DBFILE                         *             *
     C                   MOVE      *BLANKS       DBKEY                          * DBERROR 010 *
     C                   Z-ADD     10            DBASE
     C*                                                    ***************
     C                   EXSR      *PSSR                                        *1
     C                   END                                                    E1
     C*
     C*
     C** CALCULATE DEFAULT VALUES FOR ALL NECESSARY FIELDS
     C*
      *
      ** Set up book code with FRA Book Code from SDFAISPD
     C                   MOVE      BQFTBC        @FBKCD            2
      *
      ** Set up branch code with FRA Enquiry Branch Code
      **     from SDFAISPD
     C                   MOVE      BQFIDB        @FBRCA            3
      *
     C     #AA9          ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #AC      - SET UP AUTO REFRESH PROCESSING                     *
     C*                                                               *
     C* NOTE: LAST 'WRITE' MUST BE SUBFILE CONTROL (IE. FORMAT ON     *
     C*       WHICH 'INVITE' IS SPECIFIED) FOLLOWED BY 'READ' OF FILE *
     C*       FOR AUTO-REFRESH TO WORK (HAVE TO READ FILE NOT FORMAT  *
     C*       FOR INVITE TO WORK).                                    *
     C*                                                               *
     C* CALLS                                                         *
     C*                                                               *
     C* CALLED BY  @A         - INITIAL PROCESSING                    *
     C*                                                               *
     C* FLDS USED  @USER      - USER - 1O ALPHA                       *
     C*            @OVR       - ARRAY TO HOLD CL COMMAND FOR QCMDEXC  *
     C*            @OVRID     - DATA STRUCURE TO SET UP CL COMMAND    *
     C*            @WAIT      - FIELD OF DS @OVRID TO SET WAIT TIME   *
     C*            QCALEN     - LENGTH OF CL COMMAND FOR QCMDEXC      *
     C*            USREF      - REFRESH INDICATOR - Y/N - OFF FILE    *
     C*            USRFPD     - REFRESH PERIOD OFF FILE               *
     C*                                                               *
     C*****************************************************************
     C*
     C     #AC           BEGSR
     C*
     C     @USER         CHAIN     MUSER                              85
     C*
     C     *IN85         IFEQ      '1'                                          B1
     C*
     C                   MOVEL     'MUSER'       DBFILE                         ***************
     C                   Z-ADD     9             DBASE
     C                   MOVEL     @USER         DBKEY                          * DBERROR 009 *
     C*                                                    *             *
     C                   EXSR      *PSSR                                        ***************
     C*
     C                   END                                                    E1
     C*******************                                                       CAAA02
     C***OVERRIDE*TO*FILE AND THEN OPEN                                         CAAA02
     C*******************                                                       CAAA02
     C*****AURF**********IFEQ      'Y'                                          CAAA02
     C*******************MOVEL     @OVR(1)       @OVRID                         CAAA02
     C*******************Z-ADD     REFP          @WAIT                          CAAA02
     C*******************Z-ADD     36            QCALEN           15 5          CAAA02
     C*******************CALL      'QCMDEXC'                                    CAAA02
     C*******************PARM                    @OVRID                         CAAA02
     C*******************PARM                    QCALEN                         CAAA02
     C*******************END                                                    CAAA02
                                                                                CAAA02
      * If a value is specified on the MUSER record set the maximum             CAAA02
      *  wait time to else, else use a default                                  CAAA02
     c                   if        AURF = 'Y'                                   CAAA02
     c                   eval      MaxWaitTime = REFP                           CAAA02
     c                   else                                                   CAAA02
     c                   eval      MaxWaitTime = 32767                          CAAA02
     c                   end                                                    CAAA02
                                                                                CAAA02
     C*
     C                   OPEN      DL1905DF
     C*
     C     #AC9          ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #C       - TERMINATION PROCESSING                             *
     C*                                                               *
     C* CALLS                                                         *
     C*                                                               *
     C* CALLED BY  MAIN CONTROLLING ROUTINE                           *
     C*                                                               *
     C* FLDS USED  @@TERM - TERMINATION PARAMETER                     *
     C*            @TOPRD - FIRST RECORD CURRENTLY ON SUBFILE         *
     C*            @KRCRD - ALL KEY FIELDS (DATA STRUCTURE)           *
     C*            @STRNG - PARAMETER STRING                          *
     C*            @PRMUP - PARAMETERS FOR PROGRAM UP IN STACK        *
     C*            @KCCCY - CURRENCY                                  *
     C*            @KBRCA - BRANCH                                    *
     C*            @TVLMY - LAST VALID PROMPT DATE STORED EARLIER     *
     C*                                                               *
     C*****************************************************************
     C*
     C     #C            BEGSR
     C*
     C     @@TERM        IFEQ      'E'                                             B*1
     C                   MOVE      '1'           *INLR                              *1
     C                   ELSE                                                      X*1
     C*
     C** IF FAST EXIT HAS BEEN REQUESTED - CMD 1 EXIT IMMEDIATELY
     C*
     C     *IN03         IFEQ      '1'                                          B2
     C                   MOVE      'Q'           @@TERM                         *2
     C                   MOVE      '1'           *INLR                          *2
     C*
     C** Else F12 has been requested for further summary screen.
     C*
     C                   ELSE                                                   X2
     C                   MOVE      'U'           @@TERM                         *2
     C*
     C** MOVE RELEVANT DATA FROM TOP RECORD INTO PROMPTS FOR PROGRAM
     C** ABOVE IN STACK.
     C*
     C                   MOVEL     @TOPRD        @KRCRD                         *2
     C                   MOVE      @KBKCD        @UPBKC                         *2
      *
     C     CEU012        IFEQ      'Y'
     C                   MOVE      @SCRCY        @UPCCY
     C                   MOVE      @WINCY        @UPINC
     C                   ELSE
     C                   MOVE      @KCCCY        @UPCCY                         *2
     C                   ENDIF
      *
     C                   MOVE      @KBRCA        @UPBCH
     C*
     C** VALUE DATE NEEDS TO BE SENT BUT IS NOT STORED IN TOP RECORD
     C** SINCE NOT FROM FILE THEREFORE MUST BE SET UP FROM LAST VALID
     C** PROMPT DATE STORED EARLIER
     C*
     C                   MOVE      @TVLMY        @UPDAT                         *2
     C*
     C** Need to send currency decimal places in case different from
     C** original prompts passed from above
     C*
     C                   Z-ADD     @TCDP         @UPCDP                         *2
     C                   Z-ADD     @@DICM        @UPDIC                         *2
     C                   Z-ADD     WSPOT         @UPSPT
     C*
     C*
     C** MOVE PROMPTS INTO PARAMETER STRING
     C*
     C                   MOVEL     @PRMUP        @STRNG                         *2
     C*
     C** TURN OFF INDICATOR *IN12 SO THAT IF PROGRAM IS RECALLED SLOW
     C** EXIT WILL NOT BE PROCESSED
     C*
     C                   MOVE      '0'           *IN12                          *2
     C*
     C                   END                                                    E2
     C*
     C                   END                                                      E*1
     C*
     C                   RETURN
     C*
     C     #C9           ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #ZA      - RESET ERROR INDICATORS AND CLEAR MESSAGE QUEUE     *
     C*                                                               *
     C* CALLS    - ZA0250  -  CLEAR PROGRAM SUBFILE MESSAGE QUEUE     *
     C*                                                               *
     C* CALLED BY  #B      -  MAIN PROCESSING                         *
     C*                                                               *
     C* FLDS USED  @@ERMS  - ERROR-MESSAGE-TO-DISPLAY INDICATOR       *
     C*                                                               *
     C*****************************************************************
     C*
     C     #ZA           BEGSR
     C*
     C** RESET ALL FIELD ERROR INDICATORS.
     C*
     C                   MOVE      '0'           *IN60
     C                   MOVE      '0'           *IN61
     C                   MOVE      '0'           *IN62
     C                   MOVE      '0'           *IN63
     C                   MOVE      '0'           *IN68
      *
      ** Reset file error indicators.
      *
     C                   MOVE      '0'           *IN82
     C*
     C** IF THERE WAS AN ERROR IN THE SCREEN JUST PROCESSED LEAVE THE
     C** ACTIVATE-OVRATR-KEYWORD INDICATOR ON SO AS TO REMOVE THE
     C** CHANGED DISPLAY ATTRIBUTES EG. REVERSE IMAGE NEXT TIME THE
     C** ENQUIRY SUBFILE CONTROL FORMAT IS DISPLAYED.  IF, HOWEVER,
     C** THERE WAS NO ERROR THEN TURN OFF THE ACTIVATE-OVRATR-KEYWORD.
     C*
     C     *IN69         IFEQ      '0'                                          B1
     C                   MOVE      '0'           *IN29                          *1
     C                   END                                                    E1
     C*
     C** RESET THE GENERAL-ERROR-IN-VALIDATION INDICATOR
     C*
     C                   MOVE      '0'           *IN69
     C*
     C** RESET THE ERROR-MESSAGE-TO-DISPLAY INDICATOR
     C*
     C                   MOVE      'N'           @@ERMS            1
     C*
     C** CLEAR SCREEN MESSAGE QUEUE.
     C*
     C                   CALL      'ZA0250'
     C*
     C     #ZA9          ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #AAA     - READ INSTALLATION FILES                            *
     C*                                                               *
     C* CALLS    -                                                    *
     C*                                                               *
     C* CALLED BY  #AA    - OPEN FILES AND SET UP DEFAULT PROMPT DATA *
     C*                                                               *
     C* FLDS USED                                                     *
     C*                                                               *
     C*****************************************************************
     C*
     C     #AAA          BEGSR
     C*
      *
      ** Access I.C.D. record
      *
      ** Call Access Program for Bank Details
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Call Access Program for FAIS Details
     C                   CALL      'AOFAISR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDFAIS        PARM      SDFAIS        DSFDY
     C*
     C** Call Access Program for Midas Modules Details
     C                   CALL      'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *                                                                                       245692
      ** Call Access Program for DEALING ICD Details                                          245692
      *                                                                                       245692
     C                   CALL      'AODEALR1'                                                 245692
     C                   PARM      '*DBERR '     @RTCD             7                          245692
     C                   PARM      '*FIRST '     @OPTN             7                          245692
     C     SDDEAL        PARM      SDDEAL        DSFDY                                        245692
      *
      ** Check if Position/Risk Enquiries & Reports switchable
      ** feature is on.
      *
     C                   MOVE      'N'           CEU012            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU012'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CEU012
     C                   END
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
      *
      ** Call to program ended in error
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'CEU012'      DBKEY                          ************
     C                   MOVE      'SCSARDPD'    DBFILE                         * DBERR 04 *
     C                   Z-ADD     4             DBASE                          ************
     C                   MOVEL     'DL1905'      DBPGM
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Retrieve general ledger details
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDGELR        PARM      SDGELR        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDGELRPD'    DBFILE                         ************
     C                   Z-ADD     5             DBASE                          * DBERR 05 *
     C                   MOVEL     '*FIRST'      DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
     C*
     C**  Get ZMUSER to access Default Branch
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
     C*
     C     BGMBIN        IFEQ      'N'                                          B*2
     C                   MOVE      '1'           *IN50                           *2
     C                   END                                                    E*2
     C*
     C*
     C/COPY WNCPYSRC,DL1905C002
     C*
     C     #AAA9         ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* CVDT     - CONVERTS DATE FORMAT FROM MMMDDYY/DDMMMYY TO       *
     C*            MMDDYY/DDMMYY OR VICE VERSA.                       *
     C*                                                               *
     C* CALLS                                                         *
     C*                                                               *
     C* CALLED IF DATE FORMAT IS TO BE CONVERTED TO ANOTHER DATE      *
     C*        FORMAT IF DATE IS VALID.                               *
     C*                                                               *
     C* FLDS USED  ZADATE  -  CONTAINS THE 7 CHAR DATE FORMAT         *
     C*            ZDATE   -  CONTAINS THE 6 NUMERIC DATE FORMAT      *
     C*            @@WRK1  -  WORKING STORAGE FOR 7 CHAR DATE FORMAT  *
     C*            ZWRK4   -  WORKING STORAGE FOR 6 NUMERIC DATE FMT  *
     C*                                                               *
     C*****************************************************************
     C*
     C     CVDT          BEGSR
     C*
     C**  If *IN18 is off, convert MMMDDYY/DDMMMYY to MMDDYY/DDMMYY
     C*
     C     *IN18         IFEQ      '0'
     C*
     C**  Define the input field and clear output field
     C*
     C                   MOVE      *ZEROS        ZDATE             6 0
     C                   MOVE      *ZEROS        ZWRK4             4 0
     C                   MOVE      ZADATE        ZADATE            7
     C*
     C**  Move the date into its various components - DD, MMM and YY
     C*
     C                   MOVE      ZADATE        ZDATE
     C                   MOVEL     ZADATE        @@WRK1            5
     C*
     C**  If *IN98 is on, date format is 'M' (MMMDDYY)
     C*
     C     *IN98         IFEQ      '1'
     C                   MOVE      @@WRK1        ZWRK4
     C                   MOVEL     @@WRK1        @@MMM             3
     C*
     C**  Else *IN98 is off, date format is 'D' (DDMMMYY)
     C*
     C                   ELSE
     C                   MOVE      @@WRK1        @@MMM
     C                   MOVEL     @@WRK1        ZWRK4
     C                   END
     C*
     C**  Look up month shortnames array - store month number to @@MM
     C*
     C                   Z-ADD     1             @@MM              2 0
     C     @@MMM         LOOKUP    @MT(@@MM)                              90
     C*
     C**  Set up field for DD and MM
     C*
     C     *IN98         IFEQ      '1'
     C                   MOVEL     @@MM          ZWRK4
     C                   ELSE
     C                   MOVE      @@MM          ZWRK4
     C                   END
     C*
     C**  Set up output field for MMDDYY/DDMMYY
     C*
     C                   MOVEL     ZWRK4         ZDATE
     C*
     C**  If *IN18 on, convert MMDDYY/DDMMYY to MMMDDYY/DDMMMYY
     C*
     C                   ELSE
     C*
     C**  Define the input field and clear output field
     C*
     C                   MOVE      *BLANKS       ZADATE            7
     C                   MOVE      *BLANKS       @@WRK1            5
     C                   MOVE      ZDATE         ZDATE             6 0
     C*
     C**  Move the date into its various components - DD, MM and YY
     C*
     C                   MOVE      ZDATE         ZADATE
     C                   MOVEL     ZDATE         ZWRK4             4 0
     C*
     C**  If *IN98 is on, date format is 'M' (MMDDYY)
     C*
     C     *IN98         IFEQ      '1'
     C                   MOVEL     ZWRK4         @@MM              2 0
     C                   MOVE      ZWRK4         @@WRK1
     C*
     C**  Else *IN98 is off, date format is 'D' (DDMMYY)
     C*
     C                   ELSE
     C                   MOVE      ZWRK4         @@MM
     C                   MOVEL     ZWRK4         @@WRK1
     C                   END
     C*
     C**  Get the corresponding month shortname of the month number
     C**  in the month shortnames array.
     C*
     C                   MOVEA     @MT(@@MM)     @@MMM             3
     C*
     C     *IN98         IFEQ      '1'
     C                   MOVEL     @@MMM         @@WRK1
     C                   ELSE
     C                   MOVE      @@MMM         @@WRK1
     C                   END
     C*
     C**  Set up output field for MMMDDYY/DDMMMYY
     C*
     C                   MOVEL     @@WRK1        ZADATE
     C*
     C                   END
     C*
     C     CVDT9         ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* *PSSR    - DATABASE ERROR SUBROUTINE                          *
     C*                                                               *
     C* CALLS    -                                                    *
     C*                                                               *
     C* CALLED IF ANY PROGRAM OR FILE ERRORS                          *
     C*                                                               *
     C* FLDS USED                                                     *
     C*            DBPGM    -  HOLDS PGM NAME IN LDA                  *
     C*            @LDA     -  VARIABLE TO SET UP LDA WITH DB ERRORS  *
     C*                                                               *
     C*****************************************************************
     C*
     C     *PSSR         BEGSR
     C*
     C*
     C* SET *IN08 IF FIRST TIME THROUGH *PSSR TO PREVENT  LOOPING
     C*
     C     *IN08         IFEQ      '0'                                           B*1
     C                   MOVE      '1'           *IN08                            *1
     C*
     C*
     C** SET UP TERMINATION PARAMETER, TURN ON ERROR SWITCHES,
     C** SET ON LR, DUMP AND RETURN
     C*
     C                   MOVE      'E'           @@TERM                           *1
     C                   MOVE      '1'           *INU7                            *1
     C                   MOVE      '1'           *INU8                            *1
     C                   MOVE      '1'           *INLR                            *1
     C                   DUMP                                                     *1
     C                   RETURN                                                   *1
     C*
     C                   ELSE                                                    X*1
     C                   MOVE      '1'           *INLR                            *1
     C                   RETURN                                                   *1
     C                   END                                                     E*1
     C*
     C                   ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #AD      - SET UP KLISTS - NEVER CALLED                       *
     C*                                                               *
     C*                                                               *
     C* CALLS                                                         *
     C*                                                               *
     C* CALLED BY                                                     *
     C*                                                               *
     C* FLDS USED  @KCCCY     - CURRENCY       )                      *
     C*            @KMBCH     - BRANCH CODE    )  KEYS FOR DAILY      *
     C*            @KVLDY     - VALUE DAY NO   )  SUMMARY FILE        *
     C*            @KMTDY     - MATURITY DAY NO)                      *
     C*            @KBSRT     - BASE RATE      )                      *
     C*                                                               *
     C*            @KROL1     - KLIST FOR ROLLING                     *
     C*            @KPRT1     - KLIST FOR NEW PROMPTS                 *
     C*            @KPRT2     - KLIST FOR LOADING SUBFILE             *
     C*            KFRAR1     - FRA Rates File - Full Key             *
     C*            KFRAR2     - FRA Rates File - Partial Key          *
     C*                                                               *
     C*****************************************************************
     C*
     C     #AD           BEGSR
     C*
     C** KEY USED TO SETLL/SETGT WHEN ROLLING
     C*
     C     @KROL1        KLIST
     C                   KFLD                    @KBKCD
     C                   KFLD                    @KCCCY
     C                   KFLD                    @KBRCA
     C                   KFLD                    @KCVDT
     C                   KFLD                    @KCMDT
     C                   KFLD                    @KCBSD
     C*
     C** KEY USED TO SETLL/SETGT WHEN NEW PROMPTS
     C*
     C     @KPRT1        KLIST
     C                   KFLD                    @KBKCD
     C                   KFLD                    @KCCCY
     C                   KFLD                    @KBRCA
     C                   KFLD                    @KCVDT
      *
      ** Key used to SETLL/SETGT when rolling
      *
     C     @KRLE1        KLIST
     C                   KFLD                    @KSSNB
     C                   KFLD                    @KBKCD
     C                   KFLD                    @KCCCY
     C                   KFLD                    @KBRCA
     C                   KFLD                    @KCVDT
     C                   KFLD                    @KCMDT
     C                   KFLD                    @KCBSD
      *
      ** Key used to SETLL/SETGT when new prompts
      *
     C     @KPRE1        KLIST
     C                   KFLD                    @KSSNB
     C                   KFLD                    @KBKCD
     C                   KFLD                    @KCCCY
     C                   KFLD                    @KBRCA
     C                   KFLD                    @KCVDT
      *
      ** Key to read for loading subfile
      *
     C     @KPRE2        KLIST
     C                   KFLD                    @KSSNB
     C                   KFLD                    @KBKCD
     C                   KFLD                    @KCCCY
     C                   KFLD                    @KBRCA
     C*
     C* KEY TO READ FOR LOADING SUBFILE
     C*
     C     @KPRT2        KLIST
     C                   KFLD                    @KBKCD
     C                   KFLD                    @KCCCY
     C                   KFLD                    @KBRCA
      *
      ***  FRA Rates File: Key1 - Full Key.
     C     KFRAR1        KLIST
     C                   KFLD                    @@CCY
     C                   KFLD                    WBSRD
     C                   KFLD                    KCVDAT
      *
      ***  FRA Rates File: Key2 - Partial Key.
     C     KFRAR2        KLIST
     C                   KFLD                    @@CCY
     C                   KFLD                    WBSRD
     C*
     C*
     C     #AD9          ENDSR
     C*****************************************************************
**  @DYN - VALID DAY-IN-MONTH NUMBER
01020304050607080910111213141516171819202122232425262728293031
**  @MON - VALID MONTH NUMBERS
010203040506070809101112
**  @YR - VALID YEAR DIGITS
0123456789
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
** @OVR  CL COMMAND FOR CALL TO QCMDEXC
OVRDSPF FILE(DL1905DF) WAITRCD(    )
** @YD  USED BY SR. ZDATE9 - YEARS, IN DAYS, CUMULATIVE IN 4 YEAR SPAN
00366007310109601461
** @MD  USED BY SR. ZDATE9 - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
00000000310005900090001200015100181002120024300273003040033400365
**   ZMNM - MONTHS S ORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
**   ZF29 DAY NOS OF FEB 29 TO 2096 (INCLUDING 2000)
0006001521029820444305904073650882610287117481320914670161311759219053
2051421975234362489726358278192928030741322023366335124365853804639507
40968424294389045351
