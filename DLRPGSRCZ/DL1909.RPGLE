     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*S*D ***RPGBASE*******************************************************                       CAAA02
/*STD *  RPGBASEMOD                                                   *                       CAAA02
/*EXI *  TEXT('Midas DL FRA monthly summary enquiry')                 *
     F*****************************************************************
     F*                                                               *
     F*  Midas - FRA/IRS Module
     F*                                                               *
     F* DL1909  - FRA MONTHLY SUMMARY ENQUIRY                         *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL028             Date 07Feb05               *
      *                 TDA035             Date 02Apr04               *
      *                 CAAA03             Date 29Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAAA02             Date 16Jul03               *
      *  Converted to ILE and code-stripped                           *
      *                 217684             Date 12May03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP056             Date 13Mar02               *
      *                 CIR008             Date 13Mar02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 139780             Date 30Jul98               *
      *                 134832             Date 15Jun98               *
     F*                 134878             Date 01May98               *
     F*                 CEU012             Date 16Feb98               *
     F*                 133857             Date 21Apr98               *
     F*                 126426             Date 29Dec97               *
     F*                 110523             Date 20Jan97               *
     F*                 061426             Date 30Sep93               *
     F*                 E42616            DATE 13NOV92                *
     F*                 S01117            DATE 25MAR92                *
     F*                  E29042                 DATE 13JAN92          *
     F*                  E28496                 DATE 17SEP91          *
     F*                  E28440                 DATE 17SEP91          *
     F*                  S01269                 DATE 25JUN91          *
     F*                  E23430                 DATE 01OCT90          *
     F*                  E23342                 DATE 16AUG90          *
     F*                  E23183                 DATE 07AUG90          *
     F*                  E20774                 DATE 15MAR90          *
     F*                  S01199/E22855          DATE 01FEB90          *
     F*                  S01117                 DATE 01FEB90          *
     F*                  S01194                 DATE 31JAN90          *
     F*                  S01157                 DATE 28/11/88         *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  CAAA03 - Webfacing Changes (recompiled).                     *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAAA02 - Remove use of INVITE keyword to enable WebFacing    *
      *           to process screens.                                 *
      *           JavaScript in the DDS will cause the Web Page to    *
      *           redisplay frequently and this program will          *
      *           accumulate the total elapsed time and exit          *
      *           when this matches the time from the OVRDSPF         *
      *           Some ZSRSRC SRs replaced by modules.                *
      *  CAP056 - Automatic Authorisation of Interface deals          *
      *           (Recompile)                                         *
      *  CIR008 - FRA/IRS Deals Authorisation (Recompile)             *
     F*  139780 - EMU: Consolidated Euro currency amounts are being   *
     F*           shown with zero decimal positions in FRA Monthly    *
     F*           summary.                                            *
     F*  134832 - FRA-option FRMS does not work.  User is thrown back *
     F*           to previous menu after entering details for enquiry.*
     F*           This is because an array index error occured due to *
     F*           the subscript value of @@MM (0) which is less than  *
     F*           the lower bound (1) of array @MT.                   *
     F*  134878 - If Date Format flag is 'D' the system will have     *
     F*           an invalid index array.                             *
     F*  CEU012 - EMU Position/Risk Enquiries                         *
     F*  133857 - Recompiled over changed DL1909DF                    *
     F*  126426 - If Date Format flag is 'M', convert the date to     *
     F*           American date format after calling SR/ZDATE8.       *
     F*  110523 - TO CORRECT DISPLAY ORDER OF MTHLY SUMMARY REPORTS   *
     F*           AND DIFFERENTIATE BETWEEN RECORDS BEFORE AND AFTER  *
     F*           YEAR 2000                                           *
     F*  061426 - Recompile after ZDATE9 correction                   *
     F*  E42616 - The Enquiry on FRA Monthly Summary asks for the     *
     F*           date to be input in format MMMYY instead of MMYY.   *
     F*           this does not meet the standards for the rest of    *
     F*           the MIDAS system.                                   *
     F*   S01117 - RECOMPILE FOR FT CHANGE TO MUSERDD                 *
     F*   E29042 -   Processing a select request with new prompts     *
     F*              - should only process select on previous prompts *
     F*              ie. currently displayed data.                    *
     F*   E28496 -   Recompile for SDFAISPD changes (BQHEOC - Hedged  *
     F*              Events on Cashflow removed).                     *
     F*   E28440 -   DL1905 needs Spot Date for Ccy - add this to the *
     F*              parameters passed (converted to Midas Day No).   *
     F*   S01269 - RECOMPILE FOR TRADE AUTHORISATION CHANGE TO        *
     F*            MUSERDD                                            *
     F*   E23430  -  When ICD has date format 'M' (American- MMMDDYY) *
     F*              Value date and Run date still remain in UK       *
     F*              format (ie DDMMMYY).                             *
     F*   E23342  -  CHANGE E22855 TO ALLOW DEFAULT VALUES TO APPEAR  *
     F*              (NO NEED TO CHANGE E22855 SINCE S01199 DID NOT   *
     F*              APPLY FIX IN THE SAME WAY!)                      *
     F*   E23183  -  SUBROUTINE ZVLDT ALTERED TO ACCEPT DATE IN       *
     F*              CORRECT FORMAT ONLY - PROGRAM RECOMPILED         *
     F*   E20774  -  REPLACE QCAEXEC WITH QCMDEXC                     *
     F*   S01199/E22855  -  HELP SYSTEM.  (E22855 WAS APPLIED FOR *
     F*                     R2 TO THIS FILE AT THE SAME TIME AS       *
     F*                     S01199 WAS APPLIED FOR R10 - THEREFORE    *
     F*                     THEY MAY NOT BE INDENTICAL CHANGES -      *
     F*                     FOR INSTANCE, S01199 SAW NO NEED TO ADD   *
     F*                     FORMAT DL1909C2).                         *
     F*   S01117 - MULTI-BRANCHING CHANGES                            *
     F*   S01194 - NEW STANDING DATA CHANGES                          *
     F*   S01157 - NEW PROGRAM WRITTEN FOR FRA/IRS                    *
     F*****************************************************************
     F*                                                               *
     F*  C R E A T I O N     P A R A M E T E R S                      *
     F*                                                               *
     F*                                                               *
     F*****************************************************************
     F*
     F/EJECT
     F* ID  F  C  H  L    FUNCTION OF INDICATORS
     F*****************************************************************
     F*                                                               *
     F* INDICATORS TO BE RECEIVED FROM THE SCREEN - COMMANDS          *
     F*                                                               *
     F*     03   -  EXIT PROGRAM                                      *
     F*     05   -  REFRESH SCREEN                                    *
     F*     18   -  IF OFF, MMMDDYY -> MMDDYY; ON, MMDDYY -> MMMDDYY  *
     F*     24   -  ACTIVATE THE OVRDTA KEYWORD FOR THE SELECT FIELDS *
     F*     25   -  ROLLUP REQUESTED                                  *
     F*     26   -  ROLLDOWN REQUESTED                                *
     F*     27   -  INHIBIT ROLL/REFRESH/SELECT KEYS & TEXT/ENQ.TITLES*
     F*     28   -  ACTIVATE THE OVRDTA KEYWORD FOR KEYS/TEXT & TITLES*
     F*     29   -  ACTIVATE THE OVRATR KEYWORD FOR THE SELECT FIELDS *
     F*                                                               *
     F* INDICATORS TO CONTROL THE ENQUIRY SUBFILE                     *
     F*                                                               *
     F*     30   -  ACTIVATE SUBFILE END                              *
     F*     35   -  ACTIVATE SUBFILE DISPLAY                          *
     F*     36   -  ACTIVATE SUBFILE DISPLAY CONTROL                  *
     F*     (N35N36   -  ACTIVATE SUBFILE CLEAR)                      *
     F*     50   -  'MBIN' = 'N'; NON-DISPLAY PROMPT FOR BRANCH       *
     F*                                                               *
     F* INDICATORS TO CONTROL THE MESSAGE SUBFILE                     *
     F*                                                               *
     F*     40   -  ACTIVATE SUBFILE END                              *
     F*     46   -  ACTIVATE SUBFILE DISPLAY CONTROL                  *
     F*                                                               *
     F* INDICATORS TO REPORT ERRORS ON VALIDATION OF PROMPT SCREEN    *
     F*                                                               *
     F*     60   -  ERROR ON CURRENCY SELECTED                        *
     F*     61   -  ERROR ON BRANCH CODE SELECTED                     *
     F*     62   -  ERROR ON VALUE DATE SELECTED                      *
     F*     63   -  INVALID BOOK CODE SELECTED (CHAIN FAIL ON BOOKD)  *
     F*     64   -  ERROR ON BOOK CODE SELECTED                       *
     F*     68   -  NO RECORD ON FILE FOR CCY/BRANCH AND GE VALUE DATE*
     F*     69   -  GENERAL ERROR ON VALIDATION OF PROMPT SCREEN      *
     F*                                                               *
     F* INDICATORS TO REPORT ERRORS ON FILE READS                     *
     F*                                                               *
     F*     70   -  END OF SUBFILE - DL1909S1                         *
     F*     71   -  END OF RELEVANT DATA ON SUMMARY FILE              *
     F*     72   -  BEGINNING OF RELEVANT DATA ON SUMMARY FILE        *
     F*     73   -  ERROR ON READ OF ENQUIRY SUBFILE CONTROL FORMAT   *
     F*     75   -  CHAIN FAIL ON TOTALS FILE DLMSM2L                 *
     F*     76   -  CHAIN FAIL ON TOTALS FILE DLMSB2L                 *
     F*     77   -  END OF RELEVANT DATA ON DEALS FILE                *
     F*                                                               *
     F*     86   -  DATABASE ERROR ON FDMNTHLL                        *
     F*                                                               *
     F*     98   -  INDICATOR USED IN ZDATE8                          *
     F*                                                               *
     F* INDICATORS TO TERMINATE PROGRAM                               *
     F*                                                               *
     F*     U7   -  ERROR SWITCH (SET ON BY *PSSR)                    *
     F*     U8   -  ERROR SWITCH (SET ON BY *PSSR)                    *
     F*     LR   -  LAST RECORD INDICATOR TO TERMINATE PGM CLEANLY    *
     F*                                                               *
     F*****************************************************************
     F*
     FFDMNTHLL  IF   E             DISK    INFSR(*PSSR)
     F                                     USROPN
     F*
     F*
     FMUSER     IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F*
     FDLMSY1L   IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F*
     FDLMSY2L   IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F*
     FDLMSY3L   IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(DLMSY1P0:DLMSY3P0)
     F*
     FDLMSY4L   IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(DLMSY2P0:DLMSY4P0)
     F*
     FDLMST1L   IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F*
     FDLMST2L   IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F*
     FDLMST3L   IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(DLMST1P0:DLMST3P0)
     F*
     FDLMST4L   IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(DLMST2P0:DLMST4P0)
     F*
     FDLDLDGL5  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(DEALSDGF:FMT5)
     F*
     FDLDLDGL6  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(DEALSDGF:FMT6)
     F*
     FDLDLDGL7  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(DEALSDGF:FMT7)
     F*
     FDLDLDGL8  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(DEALSDGF:FMT8)
     F*
     FDL1909DF  CF   E             WORKSTN INFSR(*PSSR)
     F                                     USROPN
     F                                     SFILE(DL1909S1:RRN)
     F                                     MAXDEV(*FILE)
     F*
     F*****************************************************************
     D @MON            S              2    DIM(12) CTDATA PERRCD(12)
     D*  Compile-time array for valid month numbers
     D @YR             S              1    DIM(10) CTDATA PERRCD(10)
     D*  Compile-time array for valid year digits
     D*
     D***/COPY ZSRSRC,ZDATE8Z1                                                  CAAA02
     D***/COPY ZSRSRC,ZAMTEZ1                                                   CAAA02
     D***/COPY ZSRSRC,ZDATE9Z1                                                  CAAA02
     D/COPY ZSRSRC,ZDATE8Z1LE                                                   CAAA02
     D/COPY ZSRSRC,ZAMTEZ1LE                                                    CAAA02
     D/COPY ZSRSRC,ZDATE9Z1LE                                                   CAAA02
     D*
     D @I              S              1    DIM(10)
     D** ARRAY USED TO EDIT MONTHLY TOTALS AMOUNT FOR DISPLAY
     D*
     D @OVR            S             36    DIM(1) CTDATA PERRCD(1)
     D** ARRAY TO SET UP PARAMETER FOR CALL TO QCMDEXC
     D*
     D***/COPY ZSRSRC,ZDATE8Z2                                                  CAAA02
     D***/COPY ZSRSRC,ZAMTEZ2                                                   CAAA02
     D***/COPY ZSRSRC,ZDAT10Z1                                                  CAAA02
      * ZDATE8Z2LE moved to AFTER the other D specs as it contains I specs      CAAA02
     D/COPY ZSRSRC,ZAMTEZ2LE                                                    CAAA02
     D*
     D @KRCRD          DS            28
     D*
     D** DATA STRUCTURE FOR KEY FIELDS
     D*
     D  @KBKCD                 1      2
     D  @KCRCY                 3      5
     D  @KBRCA                 6      8
     D  @KMMYY                 9     13
     D  @KCENT                14     14  0
     D*
     D  @KVLDT                15     19  0
     D  @KYMNO                15     18  0
     D  @KDDNO                19     19  0
     D  @KVLDY                23     28  0
     D*
     D @PRMDN          DS            28
     D*
     D** DATA STRUCTURE FOR PROMPT FIELDS FOR PROGRAM DOWN IN STACK
     D*
     D  @DNBKC                 1      2
     D  @DNCCY                 3      5
     D  @DNBRC                 6      8
     D  @DNDAT                 9     15
     D  @DCDP                 21     21  0
     D  @DDICM                22     22  0
     D  @DNSPT                23     25P 0
     D  @DSEQN                26     27  0
     D  @DINCY                28     28
     D*
     D @PRMJP          DS            42
     D*
     D** DATA STRUCTURE FOR PROMPT FIELDS FOR PROGRAM JUMP IN STACK
     D*
     D  @JPCCY                 1      3
     D  @JPBRK                 4      7
     D  @JPBKC                 8      9
     D  @JPBRC                10     12
     D  @JPVDT                13     19
     D  @JPVDY                20     24  0
     D  @JPCDP                28     28  0
     D  @JPDIC                29     29  0
     D  @JPSPT                30     32P 0
     D  @JPSEQ                33     34  0
     D  @JPICY                35     35
     D*
     D @WRK            DS            19
     D*
     D** Data structure to move parameter string to
     D*
     D  @@CCY                  3      5
     D  @@WORK                 1     13
     D  CDP                   14     14  0
     D  DICM                  15     15  0
     D  SPOT                  16     18P 0
     D  WINCY                 19     19
     D*
     D DRCRD2          DS            19
     D*
     D**DATA STRUCTURE FOR KEY TO MONTHLY SUMMARY TOTALS - ALL BRANCHESS
     D*
     D  KEBOKC                 1      2
     D  KECCY                  3      5
     D  FILLER                 6      8
     D  @DCON2                 9     13
     D  KECENT                14     14  0
     D  KEVDTP                15     19  0
     D*
     D DRCRD1          DS            19
     D*
     D** DATA STRUCTURE FOR KEY TO MONTHLY SUMMARY TOTALS - BY BRANCH
     D*
     D  KDBOKC                 1      2
     D  KDCCY                  3      5
     D  KDBRCA                 6      8
     D  @DCON1                 9     13
     D  KDCENT                14     14  0
     D  KDVDTP                15     19  0
     D*
     D*
     D @DAT7           DS             7
     D*
     D** DATA STRUCTURE TO CONVERT UK DATE TO US DATE FORMAT
     D** (IE DDMMMYY --> MMMDDYY)
     D  @DAT5                  1      5
     D  @DAY                   1      2
     D  @MMM                   1      3
     D  @DDY                   1      2  0
     D  @MMT                   3      5
     D  @YY                    6      7
     D*
     D PSDS           SDS
     D*
     D** PROGRAM STATUS DS TO OBTAIN WORKSTATION ID AND USER
     D  @JOB                 244    253
     D  @USER                254    263
     D*
     D DBERR           DS           256
     D*
     D** DATA STRUCTURE FOR DATABASE ERROR HANDLING
     D*
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183
     D*
     D @WBOOK          DS             3
     D*
     D** DATA STRUCTURE FOR WORK BOOK FIELD
     D*
     D  @WBKP1                 1      1
     D  @WBKP3                 3      3
     D  @WBKC1                 1      2
     D  @WBKC2                 2      3
     D*
     D @OVRID          DS            36
     D*
     D*   DATA STRUCTURE FOR COMMAND IN ARRAY @OVR
     D*
     D  @WAIT                 32     35  0
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
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** General ledger details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      **  Switchable Features File
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D** RECORD FORMATS FOR ACCESS TO BRANCH CODES
     D*
     D SDBOOK        E DS                  EXTNAME(SDBOOKPD)
     D** RECORD FORMATS FOR ACCESS TO BOOK DETAILS
     D*
     D SDFAIS        E DS                  EXTNAME(SDFAISPD)
     D** RECORD FORMATS FOR FWD RATE AGMT/INT RATE SWAP DETAILS
     D*
     D ZMUSER          DS            17
     D* DATA STRUCTURE IN QTEMP - USER DETAILS
     D  @BKLVL                17     17
                                                                                CAAA02
      * WaitTime is the time from WRITE to READ                                 CAAA02
     d WaitTime        s              5p 0                                      CAAA02
     d MaxWaitTime     s              5p 0                                      CAAA02
                                                                                CAAA02
      * Now1Time is the time before the READ and Now2Time the time after        CAAA02
     d Now1Time        s               t                                        CAAA02
     d Now2Time        s               t                                        CAAA02
                                                                                CAAA02
      * ZDATE8Z2LE moved to AFTER the other D specs as it contains I specs      CAAA02
     D/COPY ZSRSRC,ZDATE8Z2LE                                                   CAAA02
     I*
     C*****************************************************************
     C/EJECT
      *
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
     C** Process until EXIT is required
     C*
     C     *IN03         DOWEQ     '0'
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
     C*  03  #KA     - DETERMINE FILE - SETLL WITH ROLL KEY           *
     C*  04  #KB     - DETERMINE FILE - SETGT WITH ROLL KEY           *
     C*  05  #KC     - DETERMINE FILE - READE WITH PROMPT KEY         *
     C*  06  #KD     - DETERMINE FILE - SETLL WITH PROMPT KEY         *
     C*  07  #KE     - DETERMINE FILE - READP RECORD                  *
     C*  08  #KF     - DETERMINE FILE - SETUP SCREEN DISPLAY FIELDS   *
     C*  09  #KG     - DETERMINE FILE - READE WHEN NEW PROMPTS        *
     C*  10  #AB     - SET UP PROMPT FIELDS - DEFAULTS IF NECESSARY   *
     C*  11  #BA     - ROLLUP ENQUIRY SUBFILE                         *
     C*  12  #BB     - ROLLDOWN ENQUIRY SUBFILE                       *
     C*  13  #BC     - ENTER NEW PROMPT DATA                          *
     C*  14  #BCA    - VALIDATE PROMPT DATA                           *
     C*  15  #BCB    - SET UP NEW SCREEN HEADINGS                     *
     C*  16  #BD     - EDIT ENQUIRY SUBFILE DATA -1ST LINE            *
     C*  17  #BE     - EDIT ENQUIRY SUBFILE DATA -2ND LINE            *
     C*  18  #BF     - EDIT ENQUIRY SUBFILE DATA -3RD LINE            *
     C*  19  #BG     - PREPARE PARAMETERS                             *
     C*  20  ZDATE8  - EDIT DATE USING MONTH SHORTNAMES FROM FILE     *
     C*  21  ZVLDT   - EDIT DATE USING MONTH SHORTNAMES FROM FILE     *
     C*  22  ZAMTE   - EDIT AMOUNTS INTO ROUND THOUSANDS              *
     C*  23  #AA     - OPEN FILES AND SET UP DEFAULT PROMPT DATA      *
     C*  24  #AC     - SET UP AUTO REFRESH PROCESSING                 *
     C*  25  #C      - TERMINATION PROCESSING                         *
     C*  26  #ZA     - RESET ERROR INDICATORS AND CLEAR MESSAGE QUEUE *
     C*  27  #AAA    - READ INSTALLATION FILES                        *
     C*  28  *PSSR   - DATABASE ERROR HANDLING                        *
     C*  29  #AD     - SET UP KLISTS - NEVER CALLED                   *
     C*                                                               *
     C* EXTERNAL PROGRAMS CALLED                                      *
     C*                                                               *
     C*  01  ZA0240  - ADD MESSAGE TO PROGRAM MESSAGE QUEUE           *
     C*  02  ZA0250  - CLEAR PROGRAM MESSAGE QUEUE                    *
     C*                                                               *
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #A       - INITIAL PROCESSING                                 *
    4C*                                                               *
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
     C*            @@WORK     - WORK FIELD TO PREVENT DEC DATA ERRORS *
     C*            @@TIME     - SCREEN HEADER FIELD TO DISPLAY TIME   *
     C*            @@TWID     - SCREEN HEADER FIELD TO DISPLAY WKSTN  *
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
     C                   MOVEL     'DL1909'      DBPGM
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
     C                   MOVEL     @STRNG        @WRK
     C*
     C** Also, need to move no. of d.p's for currency; it is kept in
     C** position 14 of parameter string.
     C*
     C                   Z-ADD     CDP           @@CDP
     C                   MOVEL     @@WORK        @KRCRD
     C                   MOVE      *BLANKS       @STRNG
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
     C                   WRITE     DL1909F0
     C                   WRITE     DL1909F1
     C*
     C** CLEAR THE SUBFILE BY SETTING OFF THE SUBFILE DISPLAY AND
     C** THE SUBFILE DISPLAY CONTROL INDICATORS AND THEN WRITING
     C** THE ENQUIRY SUBFILE CONTROL FORMAT
     C*
     C                   MOVE      '0'           *IN35
     C                   MOVE      '0'           *IN36
     C                   WRITE     DL1909C1
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
     C                   EXFMT     DL1909C1                                     *1
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
     C*            #BG       - PREPARE PARAMETERS                     *
     C*            #KA       - DETERMINE FILE - SETLL WITH ROLL KEY   *
     C*            #KB       - DETERMINE FILE - SETGT WITH ROLL KEY   *
     C*            #KC       - DETERMINE FILE - READE WITH PROMPT KEY *
     C*            #KF       - DETERMINE FILE - SETUP SCREEN DISPLAY  *
     C*                        FIELDS                                 *
     C*            #ZA       - RESET ERROR INDICATORS AND CLEAR       *
     C*                        MESSAGE QUEUE                          *
     C*                                                               *
     C* CALLED BY  MAIN CONTROLLING ROUTINE                           *
     C*                                                               *
     C* FLDS USED  @TOPRD     - FIRST RECORD CURRENTLY ON SCREEN      *
     C*            @BOTRD     - LAST RECORD CURRENTLY ON SCREEN       *
     C*            SSSLC1     - SELECT FIELD FROM SCREEN (LINE 1)     *
     C*            SSSLC2     - SELECT FIELD FROM SCREEN (LINE 2)     *
     C*            @@SLCT     - SELECTION-PROCESSED INDICATOR - Y/N   *
     C*            @@ERMS     - ERROR MESSAGE TO DISPLAY - Y OR N     *
     C*            @@TERM     - TERMINATION PARAMETER                 *
     C*            @KREQ      - KEY USED FOR ROLLING                  *
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
     C** IF REFRESH (CMD 5) HAS BEEN REQUESTED (IF ON PROMPT SCREEN
     C** STILL THEN MANUAL REFRESH INHIBITED AND AUTO REFRESH CAUGHT
     C** IMMEDIATELY AFTER READ) SET UP KEY FROM FIRST RECORD CURRENTLY
     C** ON SCREEN AND POSITION ON FILE (#KA). PROCESS AS FOR A ROLLUP
     C*
     C     *IN05         IFEQ      '1'                                          B1
     C                   MOVEL     @TOPRD        @KRCRD                         *1
     C                   EXSR      #KA                                          *1
     C                   EXSR      #BA                                          *1
     C                   MOVE      '0'           *IN05
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
     C                   READC     DL1909S1                               70    ***3
     C*
      *
      ** If after READC to screen there is no error
     C     *IN70         IFNE      '1'
      *
      ** Process subroutine to prepare paramaters if selection
      **     is not blank
     C     SSSLC1        IFNE      *BLANK
     C     SSSLC2        ORNE      *BLANK
     C                   EXSR      #BG
     C                   END
      *
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
     C** (#KB) AND PROCESS A ROLLUP.
     C*
     C     *IN25         IFEQ      '1'                                          B*2
     C*
     C                   MOVEL     @BOTRD        @KRCRD                         **2
     C                   EXSR      #KB                                          **2
     C                   EXSR      #BA                                          **2
     C*
     C                   END                                                    E*2
     C*
     C** IF ROLLDOWN HAS BEEN PRESSED SET UP KEY FROM FIRST RECORD
     C** CURRENTLY ON THE SCREEN, POSITION JUST BEFORE ON THE FILE
     C** (#KA) AND PROCESS A ROLLDOWN.
     C*
     C     *IN26         IFEQ      '1'                                          B*2
     C*
     C                   MOVEL     @TOPRD        @KRCRD                         **2
     C                   EXSR      #KA                                          **2
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
     C** CHECK FOR THE END OF FILE (#KB AND #KC) AND SET THE SFLEND
     C** INDICATOR ACCORDINGLY
     C*
     C     *IN30         IFNE      '1'                                          B*2
     C*
     C                   MOVEL     @BOTRD        @KRCRD                         **2
     C                   EXSR      #KB                                          **2
     C                   EXSR      #KC                                          **2
     C     *IN71         IFEQ      '1'                                          B**3
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
     C                   WRITE     DL1909F1                                     **2
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
     C                   WRITE     DL1909F0                                     *1
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
      ** If SAR CEU0012 is *ON cmd F7 will be able to toggle
      ** the Euro equivalent amount and Ccy equivalent amount.
      *
     C     CEU012        IFEQ      'Y'
     C     WINCY         IFEQ      'Y'
     C     *IN69         ANDEQ     '0'
     C                   MOVE      '1'           *IN31
     C                   ELSE
     C                   MOVE      '0'           *IN31
     C                   ENDIF
     C                   WRITE     DL1909F1
     C                   ENDIF
      *
     C*
     C** Write the message subfile - if there is an error there
     C** will be a message to display otherwise it will remove any
     C** previous error messages on the screen
     C*
     C                   MOVE      '1'           *IN46
     C                   WRITE     DL1909C0
     C*
     C** Write the Book Totals format only if the subfile is being
     C** displayed
     C*
     C     *IN35         IFEQ      '1'                                          B1
     C                   EXSR      #KF                                          *1
     C                   WRITE     DL1909F2                                     *1
     C                   END                                                    E1
     C*
     C** Write the Enquiry Subfile Control; 'INVITE' will be activated
     C*
     C                   MOVE      '1'           *IN36
     C                   WRITE     DL1909C1
     C*
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
     C     *IN05         OREQ      '0'                                          *1
     C*
     C                   MOVE      '0'           *IN05                          *1
     C************       READ      DL1909DF                             0573    CAAA02
      /free
         Now1Time = %time();                                                  //CAAA02
                                                                              //CAAA02
         read DL1909C1;                                                       //CAAA02
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
     C*
     C                   END                                                    E1
      *
     C     CEU012        IFEQ      'Y'
     C     *IN07         ANDEQ     '1'
      *
     C     *IN32         IFEQ      '0'
     C                   MOVE      '1'           *IN32
     C                   ELSE
     C                   MOVE      '0'           *IN32
     C                   ENDIF
      *
     C                   WRITE     DL1909F1
      *
     C                   ENDIF
     C*
     C** SET INDICATOR TO SHOW FROM WHERE ENQUIRY HAS COME TO 'L'
     C** FOR LOOPING INCASE ANOTHER ENQUIRY IS MADE FROM THIS PROGRAM
     C*
     C                   MOVE      'L'           @FROM
     C** IF THIS HAS BEEN THE FIRST CALL OF THE PGM, NOW SET OFF
     C** FIRST CALL INDICATOR
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
     C* #KA      - DETERMINE FILE - SETLL WITH ROLL KEY               *
     C*                                                               *
     C* CALLS                                                         *
     C*                                                               *
     C* CALLED BY  #B   -  MAIN PROCESSING                            *
     C*                                                               *
     C**FLDS*USED**@KPRT1*TO*@KPRT2*- KLIST FOR ROLLING ONE FOR EACH  *
     C* FLDS USED  @KPRT1 TO @KPRT4 - KLIST FOR ROLLING ONE FOR EACH  *
     C*                               POSSIBLE SUMMARY FILE           *
     C*                                                               *
     C*            @@FILE - FILE TO BE USED FLAG                      *
     C*              @@FILE = 1  -  ONE BRANCH / ONE BOOK             *
     C*              @@FILE = 2  -  ALL BRANCH / ONE BOOK             *
     C*              @@FILE = 3  -  ONE BRANCH / ALL BOOK             *
     C*              @@FILE = 4  -  ALL BRANCH / ALL BOOK             *
     C*                                                               *
     C*****************************************************************
     C*
     C     #KA           BEGSR
     C*
     C** USE THE APPROPRIATE KEY TO SET LOWER LIMITS ON THE FILE
     C*
     C     @@FILE        IFEQ      '1'                                          B1
     C     @KPRT1        SETLL     DLMSY1L                                      *1
     C                   GOTO      #KA9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '2'                                          B1
     C     @KPRT2        SETLL     DLMSY2L                                      *1
     C                   GOTO      #KA9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '3'
     C     @KPRT3        SETLL     DLMSY3L
     C                   END
     C*
     C     @@FILE        IFEQ      '4'
     C     @KPRT4        SETLL     DLMSY4L
     C                   END
     C*
     C     #KA9          ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #KB      - DETERMINE FILE - SETGT WITH ROLL KEY               *
     C*                                                               *
     C* CALLS                                                         *
     C*                                                               *
     C* CALLED BY  #B   -  MAIN PROCESSING                            *
     C*                                                               *
     C* FLDS USED  @KPRT1 TO @KPRT4 - KLIST FOR ROLLING ONE FOR EACH  *
     C*                               POSSIBLE SUMMARY FILE           *
     C*                                                               *
     C*            @@FILE - FILE TO BE USED FLAG                      *
     C*              @@FILE = 1  -  ONE BRANCH / ONE BOOK             *
     C*              @@FILE = 2  -  ALL BRANCH / ONE BOOK             *
     C*              @@FILE = 3  -  ONE BRANCH / ALL BOOK             *
     C*              @@FILE = 4  -  ALL BRANCH / ALL BOOK             *
     C*                                                               *
     C*****************************************************************
     C*
     C     #KB           BEGSR
     C*
     C** USE THE APPROPRIATE KEY TO SET GREATER LIMITS ON THE FILE
     C*
     C     @@FILE        IFEQ      '1'                                          B1
     C     @KPRT1        SETGT     DLMSY1L                                      *1
     C                   GOTO      #KB9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '2'                                          B1
     C     @KPRT2        SETGT     DLMSY2L                                      *1
     C                   GOTO      #KB9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '3'
     C     @KPRT3        SETGT     DLMSY3L
     C                   END
     C*
     C     @@FILE        IFEQ      '4'
     C     @KPRT4        SETGT     DLMSY4L
     C                   END
     C*
     C     #KB9          ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #KC      - DETERMINE FILE - READE WITH PROMPT KEY             *
     C*                                                               *
     C* CALLS                                                         *
     C*                                                               *
     C* CALLED BY  #B     - MAIN PROCESSING                           *
     C*            #BA    - ROLLUP ENQUIRY SUBFILE                    *
     C*            #BC    - ENTER NEW PROMPT DATA                     *
     C*                                                               *
     C* FLDS USED  DRCRD1 OR DRCRD2 - DATA STRUCTURE FOR HOLDING      *
     C*                               RELEVANT FILE FIELDS            *
     C*                                                               *
     C*            @DCON1 & @DCON2 - CONVERTED DATE FIELD: ONE FOR    *
     C*                              EACH POSSIBLE FILE               *
     C*                                                               *
     C*            @@FILE - FILE TO BE USED FLAG                      *
     C*              @@FILE = 1  -  ONE BRANCH / ONE BOOK             *
     C*              @@FILE = 2  -  ALL BRANCH / ONE BOOK             *
     C*              @@FILE = 3  -  ONE BRANCH / ALL BOOK             *
     C*              @@FILE = 4  -  ALL BRANCH / ALL BOOK             *
     C*                                                               *
     C*****************************************************************
     C*
     C     #KC           BEGSR
     C*
     C** USE THE APPROPRIATE KEY TO READ ON THE FILE AND SET UP DATA
     C** STRUCTURE TO HOLD RECORD (USED IN ROLLUP/DOWN LATER)
     C*
     C** Set up array index, used for moving shortname of month into
     C** field for display on screen
     C** Also set up field @DAYCH to check that correct half of month
     C** has been read
     C*
     C     @@FILE        IFEQ      '1'                                          B1
     C     @KREQ1        READE     DLMSY1L                                71    *1
     C*
     C     *IN71         IFNE      '1'                                          B*2
     C*
     C                   MOVE      KDVDTP        @DAYCH            1            **2
     C                   MOVE      KDVDTP        @MONCH            3            **2
     C                   MOVEL     @MONCH        @M                2 0          **2
     C                   MOVE      KDCENT        @KCENT
     C*
     C** Ensure month is valid (between 1 & 12) - if not, set
     C** on DATABASE ERROR and return
     C*
     C     @M            IFLT      1                                            B**3
     C     @M            ORGT      12                                           ***3
     C*                                                    ***************
     C                   MOVEL     'DLMSY1L '    DBFILE                         *             *
     C                   MOVEL     @KBKCD        DBKEY                          *             *
     C                   MOVEL     @KCRCY        @KEY1             6            *             *
     C                   MOVE      @KBRCA        @KEY1                          * DBERROR 001 *
     C                   MOVE      @KEY1         DBKEY                          *             *
     C                   MOVE      '001'         DBASE                          *             *
     C*                                                    ***************
     C                   EXSR      *PSSR                                        ***3
     C                   END                                                    E**3
     C*
     C** Otherwise, move month name and 2 digit year into datastructure
     C** field, ready for display
     C*
     C                   MOVEL     KDVDTP        @YEARX            2            **2         2 *
     C                   MOVE      @YEARX        @DCON1                         **2         2 *
     C                   MOVEL     @MT(@M)       @DCON1                         **2         2 *
     C*
     C                   MOVEL     DRCRD1        DLRCRD           19            **2
     C                   GOTO      #KC9                                         **2
     C                   END                                                    E*2
     C*
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '2'                                          B1
     C     @KREQ2        READE     DLMSY2L                                71    *1
     C*
     C     *IN71         IFNE      '1'                                          B*2
     C*
     C                   MOVE      KECENT        @KCENT
     C                   MOVE      KEVDTP        @DAYCH            1            **2
     C                   MOVE      KEVDTP        @MONCH            3            **2
     C                   MOVEL     @MONCH        @M                2 0          **2
     C*
     C** Ensure month is valid (between 1 & 12) - if not, set
     C** on DATABASE ERROR and return
     C*
     C     @M            IFLT      1                                            B**3
     C     @M            ORGT      12                                           ***3
     C*                                                    ***************
     C                   MOVEL     'DLMSY2L '    DBFILE                         *             *
     C                   MOVEL     @KBKCD        DBKEY                          * DBERROR 002 *
     C                   MOVE      @KCRCY        DBKEY                          *             *
     C                   MOVE      '002'         DBASE                          *             *
     C*                                                    ***************
     C                   EXSR      *PSSR                                        ***3
     C                   END                                                    E**3
     C*
     C                   MOVEL     KEVDTP        @YEARX            2            **2         2 *
     C                   MOVE      @YEARX        @DCON2                         **2         2 *
     C                   MOVEL     @MT(@M)       @DCON2                         **2         2 *
     C*
     C                   MOVEL     DRCRD2        DLRCRD                         **2
     C                   GOTO      #KC9                                         **2
     C                   END                                                    E*2
     C*
     C                   END                                                    E1
     C*
      **
      ** Set up key of currency and branch to read DLMSY3L
     C     @@FILE        IFEQ      '3'
     C     @KREQ3        READE     DLMSY3L                                71
      *
     C     *IN71         IFNE      '1'
     C                   MOVE      KDCENT        @KCENT
     C                   MOVE      KDVDTP        @DAYCH            1
     C                   MOVE      KDVDTP        @MONCH            3
     C                   MOVEL     @MONCH        @M                2 0
      *
      ** Ensure month is valid (between 1 & 12) - if not, set
      ** on DATABASE ERROR and return
     C     @M            IFLT      1
     C     @M            ORGT      12
      *
     C                   MOVEL     'DLMSY3L '    DBFILE                         ***************
     C                   MOVE      @KCRCY        @DBKEY                         *             *
     C                   MOVEL     @DBKEY        DBKEY                          * DBERROR 025 *
     C                   MOVE      @KBRCA        DBKEY                          *             *
     C                   MOVE      '025'         DBASE                          ***************
      *
     C                   EXSR      *PSSR
     C                   END
      *
      ** Otherwise, move month name and 2 digit year into datastructure
      ** field, ready for display
     C                   MOVEL     KDVDTP        @YEARX            2
     C                   MOVE      @YEARX        @DCON1
     C                   MOVEL     @MT(@M)       @DCON1
      *
     C                   MOVEL     DRCRD1        DLRCRD           19
     C                   END
     C*
     C                   END
      *
      **
      ** Set up key of currency to read DLMSY4L
     C     @@FILE        IFEQ      '4'
     C     @KREQ4        READE     DLMSY4L                                71
      *
     C     *IN71         IFNE      '1'
     C                   MOVE      KECENT        @KCENT
     C                   MOVE      KEVDTP        @DAYCH            1
     C                   MOVE      KEVDTP        @MONCH            3
     C                   MOVEL     @MONCH        @M                2 0
      *
      ** Ensure month is valid (between 1 & 12) - if not, set
      ** on DATABASE ERROR and return
     C     @M            IFLT      1
     C     @M            ORGT      12
      *                                                    ***************
     C                   MOVEL     'DLMSY4L '    DBFILE                         *             *
     C                   MOVE      @KCRCY        DBKEY                          * DBERROR 026 *
     C                   MOVE      '026'         DBASE                          *             *
      *                                                    ***************
     C                   EXSR      *PSSR
     C                   END
      *
     C                   MOVEL     KEVDTP        @YEARX            2
     C                   MOVE      @YEARX        @DCON2
     C                   MOVEL     @MT(@M)       @DCON2
      *
     C                   MOVEL     DRCRD2        DLRCRD
     C                   END
      *
     C                   END
      *
      *
     C     #KC9          ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #KD      - DETERMINE FILE - SETLL WITH PROMPT KEY             *
     C*                                                               *
     C* CALLS                                                         *
     C*                                                               *
     C* CALLED BY  #BB    - ROLLDOWN ENQUIRY SUBFILE                  *
     C*                                                               *
     C* FLDS USED: @KREQ1 & @KREQ4 -  KLIST FOR ROLLING DOWN WHEN TOP *
     C*                               RECORD ENCOUNTERED BEFORE SUBFLE*
     C*                               FULL                            *
     C*                                                               *
     C*            @@FILE - FILE TO BE USED FLAG                      *
     C*              @@FILE = 1  -  ONE BRANCH / ONE BOOK             *
     C*              @@FILE = 2  -  ALL BRANCH / ONE BOOK             *
     C*              @@FILE = 3  -  ONE BRANCH / ALL BOOK             *
     C*              @@FILE = 4  -  ALL BRANCH / ALL BOOK             *
     C*                                                               *
     C*****************************************************************
     C*
     C     #KD           BEGSR
     C*
     C** USE THE APPROPRIATE KEY TO SET LOWER LIMITS ON THE FILE
     C*
     C     @@FILE        IFEQ      '1'                                          B1
     C     @KREQ1        SETLL     DLMSY1L                                      *1
     C                   GOTO      #KD9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '2'                                          B1
     C     @KREQ2        SETLL     DLMSY2L                                      *1
     C                   GOTO      #KD9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '3'
     C     @KREQ3        SETLL     DLMSY3L
     C                   END
     C*
     C     @@FILE        IFEQ      '4'
     C     @KREQ4        SETLL     DLMSY4L
     C                   END
     C*
     C     #KD9          ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #KE      - DETERMINE FILE - READ PREVIOUS RECORD              *
     C*                                                               *
     C* CALLS                                                         *
     C*                                                               *
     C* CALLED BY  #BB    - ROLLDOWN ENQUIRY SUBFILE                  *
     C*                                                               *
     C* FLDS USED  @SCRCY     - CURRENCY       )                      *
     C*            @SBRCA     - BRANCH CODE    ) FROM PROMPTS         *
     C*            @SMMYY     - MONTH/YEAR     )                      *
     C*                                                               *
     C*           KECCY/KDCCY  -CURRENCY       }  FIELDS FROM FILE -  *
     C*           KDBRCA       -DRS BRANCH CODE}  MUST CORRESPOND     *
     C*                                                               *
     C*            @DCON1 & @DCON2 -  CONVERTED DATE FIELD: ONE FOR   *
     C*                               EACH POSSIBLE SUMMARY FILE      *
     C*                                                               *
     C*            @@FILE - FILE TO BE USED FLAG                      *
     C*              @@FILE = 1  -  ONE BRANCH / ONE BOOK             *
     C*              @@FILE = 2  -  ALL BRANCH / ONE BOOK             *
     C*              @@FILE = 3  -  ONE BRANCH / ALL BOOK             *
     C*              @@FILE = 4  -  ALL BRANCH / ALL BOOK             *
     C*                                                               *
     C*****************************************************************
     C*
     C     #KE           BEGSR
     C*
     C** USE THE APPROPRIATE KEY TO READ THE PREVIOUS RECORD AND STORE
     C** IT IN THE DATASTRUCTURE USED FOR ROLLING UP/DOWN
     C*
     C     @@FILE        IFEQ      '1'                                          B1
     C                   READP     DLMSY1L                                72    *1
     C*
     C     *IN72         IFNE      '1'                                          B*2
     C*
     C** RECORD READ MUST MATCH FIELDS ENTERED IN PROMPTS
     C*
     C     KDBOKC        IFNE      @KBKCD                                       B**3
     C     KDCCY         ORNE      @KCRCY                                       ***3
     C     KDBRCA        ORNE      @KBRCA                                       ***3
     C                   MOVE      '1'           *IN72                          ***3
     C                   GOTO      #KE9                                         ***3
     C                   END                                                    E**3
     C*
     C** Set up array index, used for moving shortname of month into
     C** field for display on screen
     C*
     C                   MOVE      KDVDTP        @MONCH                         **2
     C                   MOVEL     @MONCH        @M                             **2
     C*
     C** Ensure month is valid (between 1 & 12) - if not, set
     C** on DATABASE ERROR and return
     C*
     C     @M            IFLT      1                                            B**3
     C     @M            ORGT      12                                           ***3
     C*                                                    ***************
     C                   MOVEL     'DLMSY1L '    DBFILE                         *             *
     C                   MOVEL     @KBKCD        DBKEY                          *             *
     C                   MOVEL     @KCRCY        @KEY1             6            *             *
     C                   MOVE      @KBRCA        @KEY1                          * DBERROR 003 *
     C                   MOVE      @KEY1         DBKEY                          *             *
     C                   MOVE      '003'         DBASE                          *             *
     C*                                                    ***************
     C                   EXSR      *PSSR                                        ***3
     C                   END                                                    E**3
     C*
     C** Otherwise, move month name and 2 digit year into datastructure
     C** field, ready for display
     C*
     C                   MOVEL     KDVDTP        @YEARX            2            **2         2 *
     C                   MOVE      @YEARX        @DCON1                         **2         2 *
     C                   MOVEL     @MT(@M)       @DCON1                         **2         2 *
     C*
     C                   MOVE      DRCRD1        DLRCRD                         **2
     C*
     C                   GOTO      #KE9                                         **2
     C                   END                                                    E*2
     C*
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '2'                                          B1
     C                   READP     DLMSY2L                                72    *1
     C*
     C     *IN72         IFNE      '1'                                          B*2
     C*
     C** RECORD READ MUST MATCH FIELDS ENTERED IN PROMPTS
     C*
     C     KEBOKC        IFNE      @KBKCD                                       B**3
     C     KECCY         ORNE      @KCRCY                                       ***3
     C                   MOVE      '1'           *IN72                          ***3
     C                   GOTO      #KE9                                         ***3
     C                   END                                                    E**3
     C*
     C** Set up array index, used for moving shortname of month into
     C** field for display on screen
     C*
     C                   MOVE      KEVDTP        @MONCH                         **2
     C                   MOVEL     @MONCH        @M                             **2
     C*
     C** Ensure month is valid (between 1 & 12) - if not, set
     C** on DATABASE ERROR and return
     C*
     C     @M            IFLT      1                                            B**3
     C     @M            ORGT      12                                           ***3
     C*                                                    ***************
     C                   MOVEL     'DLMSY2L '    DBFILE                         *             *
     C                   MOVEL     @KBKCD        DBKEY                          *             *
     C                   MOVEL     @KCRCY        @KEY1             6            *             *
     C                   MOVE      @KBRCA        @KEY1                          * DBERROR 004 *
     C                   MOVE      @KEY1         DBKEY                          *             *
     C                   MOVE      '004'         DBASE                          *             *
     C*                                                    ***************
     C                   EXSR      *PSSR                                        ***3
     C                   END                                                    E**3
     C*
     C** Otherwise, move month name and 2 digit year into datastructure
     C** field, ready for display
     C*
     C                   MOVEL     KDVDTP        @YEARX            2            **2         2 *
     C                   MOVE      @YEARX        @DCON2                         **2         2 *
     C                   MOVEL     @MT(@M)       @DCON2                         **2         2 *
     C*
     C                   MOVEL     DRCRD2        DLRCRD                         **2
     C*
     C                   GOTO      #KE9                                         **2
     C                   END                                                    E*2
     C*
     C                   END                                                    E1
      *
      **
      **
     C     @@FILE        IFEQ      '3'
     C                   READP     DLMSY3L                                72
      *
     C     *IN72         IFNE      '1'
      *
      ** RECORD READ MUST MATCH FIELDS ENTERED IN PROMPTS
     C*
     C     KDCCY         IFNE      @KCRCY
     C     KDBRCA        ORNE      @KBRCA
     C     KDVDTP        ORNE      @KVLDT
     C                   MOVE      '1'           *IN72
     C                   GOTO      #KE9
     C                   END
      *
      ** Set up array index, used for moving shortname of month into
      ** field for display on screen
      *
     C                   MOVE      KDVDTP        @MONCH
     C                   MOVEL     @MONCH        @M
      *
      ** Ensure month is valid (between 1 & 12) - if not, set
      ** on DATABASE ERROR and return
      *
     C     @M            IFLT      1
     C     @M            ORGT      12
      *
     C                   MOVEL     'DLMSY3L '    DBFILE                         ***************
     C                   MOVE      @KCRCY        @DBKEY                         *             *
     C                   MOVEL     @DBKEY        DBKEY                          * DBERROR 027 *
     C                   MOVE      @KBRCA        DBKEY                          *             *
     C                   MOVE      '027'         DBASE                          ***************
      *
     C                   EXSR      *PSSR
     C                   END
      *
      ** Otherwise, move month name and 2 digit year into datastructure
      ** field, ready for display
      *
     C                   MOVEL     KDVDTP        @YEARX            2
     C                   MOVE      @YEARX        @DCON1
     C                   MOVEL     @MT(@M)       @DCON1
      *
     C                   MOVE      DRCRD1        DLRCRD
      *
     C                   GOTO      #KE9
     C                   END
      *
     C                   END
      *
      **
      **
     C     @@FILE        IFEQ      '4'
     C                   READP     DLMSY4L                                72
      *
     C     *IN72         IFNE      '1'
      *
      ** RECORD READ MUST MATCH FIELDS ENTERED IN PROMPTS
     C*
     C     KECCY         IFNE      @KCRCY
     C     KEVDTP        ORNE      @KVLDT
     C                   MOVE      '1'           *IN72
     C                   GOTO      #KE9
     C                   END
      *
      ** Set up array index, used for moving shortname of month into
      ** field for display on screen
      *
     C                   MOVE      KEVDTP        @MONCH
     C                   MOVEL     @MONCH        @M
      *
      ** Ensure month is valid (between 1 & 12) - if not, set
      ** on DATABASE ERROR and return
      *
     C     @M            IFLT      1
     C     @M            ORGT      12
      *                                                    ***************
     C                   MOVEL     'DLMSY4L '    DBFILE                         *             *
     C                   MOVE      @KCRCY        DBKEY                          * DBERROR 028 *
     C                   MOVE      '028'         DBASE                          *             *
      *                                                    ***************
     C                   EXSR      *PSSR
     C                   END
      *
      ** Otherwise, move month name and 2 digit year into datastructure
      ** field, ready for display
      *
     C                   MOVEL     KEVDTP        @YEARX            2
     C                   MOVE      @YEARX        @DCON2
     C                   MOVEL     @MT(@M)       @DCON2
      *
     C                   MOVEL     DRCRD2        DLRCRD
      *
     C                   GOTO      #KE9
     C                   END
      *
     C                   END
      *
     C     #KE9          ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #KF      - DETERMINE FILE - ACCESS WITH CURRENCY CODE AND     *
     C*            SET UP SCREEN DISPLAY FIELDS (BOOK TOTALS)         *
     C*                                                               *
     C* CALLS    - ZAMTE (ROUNDING AMOUNTS INTO THOUSANDS)            *
     C*                                                               *
     C* CALLED BY  #B     - MAIN PROCESSING                           *
     C*                                                               *
     C* FLDS USED  @KREQ1 - KEY FIELD FOR ACCESSING 1-BRANCH FILE     *
     C*            @KREQ2 - KEY FIELD FOR ACCESSING ALL-BRANCH FILE   *
     C*            @KREQ3 - KEY FIELD FOR ALL-BOOK + 1-BRANCH FILE    *
     C*            @KREQ4 - KEY FIELD FOR ALL-BOOK + ALL-BRANCH FILE  *
     C*            @KCRCY - CURRENCY CODE                             *
     C*            @KBRCA - BRANCH CODE                               *
     C*                                                               *
     C*            @@FILE - FILE TO BE USED FLAG                      *
     C*              @@FILE = 1  -  ONE BRANCH / ONE BOOK             *
     C*              @@FILE = 2  -  ALL BRANCH / ONE BOOK             *
     C*              @@FILE = 3  -  ONE BRANCH / ALL BOOK             *
     C*              @@FILE = 4  -  ALL BRANCH / ALL BOOK             *
     C*                                                               *
     C*            DD3MS ETC - SCREEN DISPLAY FIELDS                  *
     C*                                                               *
     C*****************************************************************
     C*
     C     #KF           BEGSR
     C*
     C** CHAIN TO RELEVANT FILE
     C*
     C**Set*up*key*of*Book*and Currency to read DLMSM2L
     C* Set up key of Book and Currency to read DLMST2L
     C*
     C     @@FILE        IFEQ      '2'                                          B1
     C     @KREQ2        CHAIN     DLMST2L                            75        *1
     C*
     C     *IN75         IFEQ      '1'                                          B*2
     C*                                                    ***************
     C                   MOVEL     'DLMST2L '    DBFILE                         *             *
     C                   MOVEL     @KBKCD        DBKEY                          * DBERROR 005 *
     C                   MOVE      @KCRCY        DBKEY                          *             *
     C                   MOVE      '005'         DBASE                          *             *
     C*                                                    ***************
     C                   EXSR      *PSSR                                        **2
     C                   END                                                    E*2
     C*
     C** Set up the edit sign for each field to be displayed
     C** ('-' sign for sold, and '+' sign for bought amounts)
     C** Only set up sign if value is > 0.
     C*
     C     KFSP03        IFEQ      0                                            B1
     C                   MOVE      ' '           DD3MS                          *1
     C                   ELSE                                                   X1
     C                   MOVE      '-'           DD3MS                          *1            *
     C                   END                                                    E1
     C*
     C     KFSP06        IFEQ      0                                            B1
     C                   MOVE      ' '           DD6MS                          *1
     C                   ELSE                                                   X1
     C                   MOVE      '-'           DD6MS                          *1            *
     C                   END                                                    E1
     C*
     C     KFSP09        IFEQ      0                                            B1
     C                   MOVE      ' '           DD9MS                          *1
     C                   ELSE                                                   X1
     C                   MOVE      '-'           DD9MS                          *1            *
     C                   END                                                    E1
     C*
     C     KFSP12        IFEQ      0                                            B1
     C                   MOVE      ' '           DD12MS                         *1
     C                   ELSE                                                   X1
     C                   MOVE      '-'           DD12MS                         *1            *
     C                   END                                                    E1
     C*
     C     KFSPRR        IFEQ      0                                            B1
     C                   MOVE      ' '           DDREMS                         *1
     C                   ELSE                                                   X1
     C                   MOVE      '-'           DDREMS                         *1            *
     C                   END                                                    E1
     C*
     C*
     C     KFBP03        IFEQ      0                                            B1
     C                   MOVE      ' '           DD3MP                          *1
     C                   ELSE                                                   X1
     C                   MOVE      '+'           DD3MP                          *1            *
     C                   END                                                    E1
     C*
     C     KFBP06        IFEQ      0                                            B1
     C                   MOVE      ' '           DD6MP                          *1
     C                   ELSE                                                   X1
     C                   MOVE      '+'           DD6MP                          *1            *
     C                   END                                                    E1
     C*
     C     KFBP09        IFEQ      0                                            B1
     C                   MOVE      ' '           DD9MP                          *1
     C                   ELSE                                                   X1
     C                   MOVE      '+'           DD9MP                          *1            *
     C                   END                                                    E1
     C*
     C     KFBP12        IFEQ      0                                            B1
     C                   MOVE      ' '           DD12MP                         *1
     C                   ELSE                                                   X1
     C                   MOVE      '+'           DD12MP                         *1            *
     C                   END                                                    E1
     C*
     C     KFBPRR        IFEQ      0                                            B1
     C                   MOVE      ' '           DDREMP                         *1
     C                   ELSE                                                   X1
     C                   MOVE      '+'           DDREMP                         *1            *
     C                   END                                                    E1
     C*
     C*
     C* Set up screen display fields with amounts edited into round
     C* thousands by subroutine ZAMTE for all Branches
     C*
     C* ----SOLD AMOUNTS
     C                   Z-ADD     KFSP03        @@IAMT                         *1            *
      *
     C                   MOVEL     '072'         WDBASE            3
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE                                        *1
     C                   MOVEL     @@AMNT        DD3MS                          *1            *
     C                   Z-ADD     KFSP06        @@IAMT                         *1            *
      *
     C                   MOVEL     '073'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE                                        *1
     C                   MOVEL     @@AMNT        DD6MS                          *1            *
     C                   Z-ADD     KFSP09        @@IAMT                         *1            *
      *
     C                   MOVEL     '074'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE                                        *1
     C                   MOVEL     @@AMNT        DD9MS                          *1            *
     C                   Z-ADD     KFSP12        @@IAMT                         *1            *
      *
     C                   MOVEL     '075'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE                                        *1
     C                   MOVEL     @@AMNT        DD12MS                         *1            *
     C                   Z-ADD     KFSPRR        @@IAMT                         *1            *
      *
     C                   MOVEL     '076'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE                                        *1
     C                   MOVEL     @@AMNT        DDREMS                         *1            *
     C*
     C* ----BOUGHT AMOUNTS
     C                   Z-ADD     KFBP03        @@IAMT                         *1            *
      *
     C                   MOVEL     '077'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE                                        *1
     C                   MOVEL     @@AMNT        DD3MP                          *1            *
     C                   Z-ADD     KFBP06        @@IAMT                         *1            *
      *
     C                   MOVEL     '078'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE                                        *1
     C                   MOVEL     @@AMNT        DD6MP                          *1            *
     C                   Z-ADD     KFBP09        @@IAMT                         *1            *
      *
     C                   MOVEL     '079'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE                                        *1
     C                   MOVEL     @@AMNT        DD9MP                          *1            *
     C                   Z-ADD     KFBP12        @@IAMT                         *1            *
      *
     C                   MOVEL     '080'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE                                        *1
     C                   MOVEL     @@AMNT        DD12MP                         *1            *
     C                   Z-ADD     KFBPRR        @@IAMT                         *1            *
      *
     C                   MOVEL     '081'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE                                        *1
     C                   MOVEL     @@AMNT        DDREMP                         *1            *
     C*
     C                   GOTO      #KF9                                         *1
     C                   END                                                    E1
     C*
     C* Set up key of Book, Currency and Branch to read DLMST1L
     C*
     C     @@FILE        IFEQ      '1'                                          B1
     C     @KREQ1        CHAIN     DLMST1L                            76        *1
     C     *IN76         IFEQ      '1'                                          B*2
     C*                                                    ***************
     C                   MOVEL     'DLMST1L '    DBFILE                         *             *
     C                   MOVEL     @KBKCD        @DBKEY            5            *             *
     C                   MOVE      @KCRCY        @DBKEY                         *             *
     C                   MOVEL     @DBKEY        DBKEY                          * DBERROR 006 *
     C                   MOVE      @KBRCA        DBKEY                          *             *
     C                   MOVE      '006'         DBASE                          *             *
     C*                                                    ***************
     C                   EXSR      *PSSR                                        **2
     C                   END                                                    E*2
     C*
     C** Set up the edit sign for each field to be displayed
     C** ('-' sign for sold, and '+' sign for bought amounts)
     C** Only set up sign if value is > 0.
     C*
     C     KHSP03        IFEQ      0                                            B1
     C                   MOVE      ' '           DD3MS                          *1
     C                   ELSE                                                   X1
     C                   MOVE      '-'           DD3MS                          *1            *
     C                   END                                                    E1
     C*
     C     KHSP06        IFEQ      0                                            B1
     C                   MOVE      ' '           DD6MS                          *1
     C                   ELSE                                                   X1
     C                   MOVE      '-'           DD6MS                          *1            *
     C                   END                                                    E1
     C*
     C     KHSP09        IFEQ      0                                            B1
     C                   MOVE      ' '           DD9MS                          *1
     C                   ELSE                                                   X1
     C                   MOVE      '-'           DD9MS                          *1            *
     C                   END                                                    E1
     C*
     C     KHSP12        IFEQ      0                                            B1
     C                   MOVE      ' '           DD12MS                         *1
     C                   ELSE                                                   X1
     C                   MOVE      '-'           DD12MS                         *1            *
     C                   END                                                    E1
     C*
     C     KHSPRR        IFEQ      0                                            B1
     C                   MOVE      ' '           DDREMS                         *1
     C                   ELSE                                                   X1
     C                   MOVE      '-'           DDREMS                         *1            *
     C                   END                                                    E1
     C*
     C*
     C     KHBP03        IFEQ      0                                            B1
     C                   MOVE      ' '           DD3MP                          *1
     C                   ELSE                                                   X1
     C                   MOVE      '+'           DD3MP                          *1            *
     C                   END                                                    E1
     C*
     C     KHBP06        IFEQ      0                                            B1
     C                   MOVE      ' '           DD6MP                          *1
     C                   ELSE                                                   X1
     C                   MOVE      '+'           DD6MP                          *1            *
     C                   END                                                    E1
     C*
     C     KHBP09        IFEQ      0                                            B1
     C                   MOVE      ' '           DD9MP                          *1
     C                   ELSE                                                   X1
     C                   MOVE      '+'           DD9MP                          *1            *
     C                   END                                                    E1
     C*
     C     KHBP12        IFEQ      0                                            B1
     C                   MOVE      ' '           DD12MP                         *1
     C                   ELSE                                                   X1
     C                   MOVE      '+'           DD12MP                         *1            *
     C                   END                                                    E1
     C*
     C     KHBPRR        IFEQ      0                                            B1
     C                   MOVE      ' '           DDREMP                         *1
     C                   ELSE                                                   X1
     C                   MOVE      '+'           DDREMP                         *1            *
     C                   END                                                    E1
     C*
     C* Set up screen display fields with amounts edited into round
     C* thousands by subroutine ZAMTE by Branch
     C*
     C* ----SOLD AMOUNTS
     C*
     C                   Z-ADD     KHSP03        @@IAMT                         *1            *
      *
     C                   MOVEL     '082'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE                                        *1
     C                   MOVEL     @@AMNT        DD3MS                          *1            *
     C                   Z-ADD     KHSP06        @@IAMT                         *1            *
      *
     C                   MOVEL     '083'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE                                        *1
     C                   MOVEL     @@AMNT        DD6MS                          *1            *
     C                   Z-ADD     KHSP09        @@IAMT                         *1            *
      *
     C                   MOVEL     '084'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE                                        *1
     C                   MOVEL     @@AMNT        DD9MS                          *1            *
     C                   Z-ADD     KHSP12        @@IAMT                         *1            *
      *
     C                   MOVEL     '085'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE                                        *1
     C                   MOVEL     @@AMNT        DD12MS                         *1            *
     C                   Z-ADD     KHSPRR        @@IAMT                         *1            *
      *
     C                   MOVEL     '086'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE                                        *1
     C                   MOVEL     @@AMNT        DDREMS                         *1            *
     C*
     C* ----BOUGHT AMOUNTS
     C                   Z-ADD     KHBP03        @@IAMT                         *1            *
      *
     C                   MOVEL     '087'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE                                        *1
     C                   MOVEL     @@AMNT        DD3MP                          *1            *
     C                   Z-ADD     KHBP06        @@IAMT                         *1            *
      *
     C                   MOVEL     '088'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE                                        *1
     C                   MOVEL     @@AMNT        DD6MP                          *1            *
     C                   Z-ADD     KHBP09        @@IAMT                         *1            *
      *
     C                   MOVEL     '089'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE                                        *1
     C                   MOVEL     @@AMNT        DD9MP                          *1            *
     C                   Z-ADD     KHBP12        @@IAMT                         *1            *
      *
     C                   MOVEL     '090'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE                                        *1
     C                   MOVEL     @@AMNT        DD12MP                         *1            *
     C                   Z-ADD     KHBPRR        @@IAMT                         *1            *
      *
     C                   MOVEL     '091'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE                                        *1
     C                   MOVEL     @@AMNT        DDREMP                         *1            *
     C*
     C                   GOTO      #KF9                                         *1
     C                   END                                                    E1
     C*
      *
      ** Set up key of currency and branch to read DLMST3L
      *
     C     @@FILE        IFEQ      '3'
      *
      ** Initialise total fields
     C                   Z-ADD     0             @TBP03           15 0
     C                   Z-ADD     0             @TBP06           15 0
     C                   Z-ADD     0             @TBP09           15 0
     C                   Z-ADD     0             @TBP12           15 0
     C                   Z-ADD     0             @TBPRR           15 0
     C                   Z-ADD     0             @TSP03           15 0
     C                   Z-ADD     0             @TSP06           15 0
     C                   Z-ADD     0             @TSP09           15 0
     C                   Z-ADD     0             @TSP12           15 0
     C                   Z-ADD     0             @TSPRR           15 0
      *
      ** Chain to DLMST3L using @KREQ3 (by currency and branch)
     C     @KREQ3        CHAIN     DLMST3L                            77
      *
      ** If record not found, process database error
     C     *IN77         IFEQ      '1'
      *
     C                   MOVEL     'DLMST3L '    DBFILE                         ***************
     C                   MOVE      @KCRCY        @DBKEY                         *             *
     C                   MOVEL     @DBKEY        DBKEY                          * DBERROR 029 *
     C                   MOVE      @KBRCA        DBKEY                          *             *
     C                   MOVE      '029'         DBASE                          ***************
      *
     C                   EXSR      *PSSR
     C                   END
      *
      ** Do until end of file DLMST3L
      **    or currency not same as selected
      **    or branch   not same as selected
     C     *IN77         DOUEQ     '1'
     C     KHCCY         ORNE      @KCRCY
     C     KHBRCA        ORNE      @KBRCA
      *
      ** Add file fields to the total fields
     C                   ADD       KHBP03        @TBP03
     C                   ADD       KHBP06        @TBP06
     C                   ADD       KHBP09        @TBP09
     C                   ADD       KHBP12        @TBP12
     C                   ADD       KHBPRR        @TBPRR
     C                   ADD       KHSP03        @TSP03
     C                   ADD       KHSP06        @TSP06
     C                   ADD       KHSP09        @TSP09
     C                   ADD       KHSP12        @TSP12
     C                   ADD       KHSPRR        @TSPRR
      *
      ** Read file DLMST3L
     C                   READ      DLMST3L                                77
     C                   END
      *
      ** Edit total fields
      *
      ** Set up the edit sign for each field to be displayed
      ** ('-' sign for sold, and '+' sign for bought amounts)
      ** Only set up sign if value is > 0.
      *
     C     @TSP03        IFEQ      0
     C                   MOVE      ' '           DD3MS
     C                   ELSE
     C                   MOVE      '-'           DD3MS
     C                   END
      *
     C     @TSP06        IFEQ      0
     C                   MOVE      ' '           DD6MS
     C                   ELSE
     C                   MOVE      '-'           DD6MS
     C                   END
      *
     C     @TSP09        IFEQ      0
     C                   MOVE      ' '           DD9MS
     C                   ELSE
     C                   MOVE      '-'           DD9MS
     C                   END
      *
     C     @TSP12        IFEQ      0
     C                   MOVE      ' '           DD12MS
     C                   ELSE
     C                   MOVE      '-'           DD12MS
     C                   END
      *
     C     @TSPRR        IFEQ      0
     C                   MOVE      ' '           DDREMS
     C                   ELSE
     C                   MOVE      '-'           DDREMS
     C                   END
      *
      *
     C     @TBP03        IFEQ      0
     C                   MOVE      ' '           DD3MP
     C                   ELSE
     C                   MOVE      '+'           DD3MP
     C                   END
      *
     C     @TBP06        IFEQ      0
     C                   MOVE      ' '           DD6MP
     C                   ELSE
     C                   MOVE      '+'           DD6MP
     C                   END
      *
     C     @TBP09        IFEQ      0
     C                   MOVE      ' '           DD9MP
     C                   ELSE
     C                   MOVE      '+'           DD9MP
     C                   END
      *
     C     @TBP12        IFEQ      0
     C                   MOVE      ' '           DD12MP
     C                   ELSE
     C                   MOVE      '+'           DD12MP
     C                   END
      *
     C     @TBPRR        IFEQ      0
     C                   MOVE      ' '           DDREMP
     C                   ELSE
     C                   MOVE      '+'           DDREMP
     C                   END
      *
      * Set up screen display fields with amounts edited into round
      * thousands by subroutine ZAMTE by Branch
      *
      * ----SOLD AMOUNTS
     C                   Z-ADD     @TSP03        @@IAMT
      *
     C                   MOVEL     '092'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE
     C                   MOVEL     @@AMNT        DD3MS
     C                   Z-ADD     @TSP06        @@IAMT
      *
     C                   MOVEL     '093'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE
     C                   MOVEL     @@AMNT        DD6MS
     C                   Z-ADD     @TSP09        @@IAMT
      *
     C                   MOVEL     '094'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE
     C                   MOVEL     @@AMNT        DD9MS
     C                   Z-ADD     @TSP12        @@IAMT
      *
     C                   MOVEL     '095'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE
     C                   MOVEL     @@AMNT        DD12MS
     C                   Z-ADD     @TSPRR        @@IAMT
      *
     C                   MOVEL     '096'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE
     C                   MOVEL     @@AMNT        DDREMS
      *
      * ----BOUGHT AMOUNTS
     C                   Z-ADD     @TBP03        @@IAMT
      *
     C                   MOVEL     '097'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE
     C                   MOVEL     @@AMNT        DD3MP
     C                   Z-ADD     @TBP06        @@IAMT
      *
     C                   MOVEL     '098'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE
     C                   MOVEL     @@AMNT        DD6MP
     C                   Z-ADD     @TBP09        @@IAMT
      *
     C                   MOVEL     '099'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE
     C                   MOVEL     @@AMNT        DD9MP
     C                   Z-ADD     @TBP12        @@IAMT
      *
     C                   MOVEL     '100'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE
     C                   MOVEL     @@AMNT        DD12MP
     C                   Z-ADD     @TBPRR        @@IAMT
      *
     C                   MOVEL     '101'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE
     C                   MOVEL     @@AMNT        DDREMP
      *
     C                   END
      *
      *
      ** Set up key of currency to read DLMST4L
      *
     C     @@FILE        IFEQ      '4'
      *
      ** Initialise total fields
     C                   Z-ADD     0             #TBP03           15 0
     C                   Z-ADD     0             #TBP06           15 0
     C                   Z-ADD     0             #TBP09           15 0
     C                   Z-ADD     0             #TBP12           15 0
     C                   Z-ADD     0             #TBPRR           15 0
     C                   Z-ADD     0             #TSP03           15 0
     C                   Z-ADD     0             #TSP06           15 0
     C                   Z-ADD     0             #TSP09           15 0
     C                   Z-ADD     0             #TSP12           15 0
     C                   Z-ADD     0             #TSPRR           15 0
      *
      ** Chain to DLMST4L using @KREQ4 (by currency)
     C     @KREQ4        CHAIN     DLMST4L                            78
      *
      ** If record not found, process database error
     C     *IN78         IFEQ      '1'
      *                                                    ***************
     C                   MOVEL     'DLMST4L '    DBFILE                         *             *
     C                   MOVE      @KCRCY        DBKEY                          * DBERROR 030 *
     C                   MOVE      '030'         DBASE                          *             *
      *                                                    ***************
     C                   EXSR      *PSSR
     C                   END
      *
      ** Do until end of file DLMST4L
      **    or currency not same as selected
     C     *IN78         DOUEQ     '1'
     C     KFCCY         ORNE      @KCRCY
      *
      ** Add file fields to the total fields
     C                   ADD       KFBP03        #TBP03
     C                   ADD       KFBP06        #TBP06
     C                   ADD       KFBP09        #TBP09
     C                   ADD       KFBP12        #TBP12
     C                   ADD       KFBPRR        #TBPRR
     C                   ADD       KFSP03        #TSP03
     C                   ADD       KFSP06        #TSP06
     C                   ADD       KFSP09        #TSP09
     C                   ADD       KFSP12        #TSP12
     C                   ADD       KFSPRR        #TSPRR
      *
      ** Read file DLMST4L
     C                   READ      DLMST4L                                78
     C                   END
      *
      ** Edit total fields
      *
      ** Set up the edit sign for each field to be displayed
      ** ('-' sign for sold, and '+' sign for bought amounts)
      ** Only set up sign if value is > 0.
      *
     C     #TSP03        IFEQ      0
     C                   MOVE      ' '           DD3MS
     C                   ELSE
     C                   MOVE      '-'           DD3MS
     C                   END
      *
     C     #TSP06        IFEQ      0
     C                   MOVE      ' '           DD6MS
     C                   ELSE
     C                   MOVE      '-'           DD6MS
     C                   END
      *
     C     #TSP09        IFEQ      0
     C                   MOVE      ' '           DD9MS
     C                   ELSE
     C                   MOVE      '-'           DD9MS
     C                   END
      *
     C     #TSP12        IFEQ      0
     C                   MOVE      ' '           DD12MS
     C                   ELSE
     C                   MOVE      '-'           DD12MS
     C                   END
      *
     C     #TSPRR        IFEQ      0
     C                   MOVE      ' '           DDREMS
     C                   ELSE
     C                   MOVE      '-'           DDREMS
     C                   END
      *
      *
     C     #TBP03        IFEQ      0
     C                   MOVE      ' '           DD3MP
     C                   ELSE
     C                   MOVE      '+'           DD3MP
     C                   END
      *
     C     #TBP06        IFEQ      0
     C                   MOVE      ' '           DD6MP
     C                   ELSE
     C                   MOVE      '+'           DD6MP
     C                   END
      *
     C     #TBP09        IFEQ      0
     C                   MOVE      ' '           DD9MP
     C                   ELSE
     C                   MOVE      '+'           DD9MP
     C                   END
      *
     C     #TBP12        IFEQ      0
     C                   MOVE      ' '           DD12MP
     C                   ELSE
     C                   MOVE      '+'           DD12MP
     C                   END
      *
     C     #TBPRR        IFEQ      0
     C                   MOVE      ' '           DDREMP
     C                   ELSE
     C                   MOVE      '+'           DDREMP
     C                   END
      *
      * Set up screen display fields with amounts edited into round
      * thousands by subroutine ZAMTE by Branch
      *
      * ----SOLD AMOUNTS
     C                   Z-ADD     #TSP03        @@IAMT
      *
     C                   MOVEL     '102'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE
     C                   MOVEL     @@AMNT        DD3MS
     C                   Z-ADD     #TSP06        @@IAMT
      *
     C                   MOVEL     '103'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE
     C                   MOVEL     @@AMNT        DD6MS
     C                   Z-ADD     #TSP09        @@IAMT
      *
     C                   MOVEL     '104'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE
     C                   MOVEL     @@AMNT        DD9MS
     C                   Z-ADD     #TSP12        @@IAMT
      *
     C                   MOVEL     '105'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE
     C                   MOVEL     @@AMNT        DD12MS
     C                   Z-ADD     #TSPRR        @@IAMT
      *
     C                   MOVEL     '106'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE
     C                   MOVEL     @@AMNT        DDREMS
      *
      * ----BOUGHT AMOUNTS
     C                   Z-ADD     #TBP03        @@IAMT
      *
     C                   MOVEL     '107'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE
     C                   MOVEL     @@AMNT        DD3MP
     C                   Z-ADD     #TBP06        @@IAMT
      *
     C                   MOVEL     '108'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE
     C                   MOVEL     @@AMNT        DD6MP
     C                   Z-ADD     #TBP09        @@IAMT
      *
     C                   MOVEL     '109'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE
     C                   MOVEL     @@AMNT        DD9MP
     C                   Z-ADD     #TBP12        @@IAMT
      *
     C                   MOVEL     '110'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE
     C                   MOVEL     @@AMNT        DD12MP
     C                   Z-ADD     #TBPRR        @@IAMT
      *
     C                   MOVEL     '111'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE
     C                   MOVEL     @@AMNT        DDREMP
      *
     C                   END
      *
      *
     C     #KF9          ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #KG      - DETERMINE FILE - READE WHEN NEW PROMPTS            *
     C*                                                               *
     C* CALLS                                                         *
     C*                                                               *
     C* CALLED BY  #BA    - ROLLUP ENQUIRY SUBFILE                    *
     C*            #BC    - ENTER NEW PROMPT DATA                     *
     C*                                                               *
     C* FLDS USED  DRCRD1 OR DRCRD2 - DATA STRUCTURE FOR HOLDING      *
     C*                               RELEVANT FILE FIELDS            *
     C*                                                               *
     C*            @DCON1 & @DCON2  - CONVERTED DATE FIELD: ONE FOR   *
     C*                               EACH POSSIBLE FILE              *
     C*                                                               *
     C*            @@FILE           - FILE TO BE USED FLAG            *
     C*              @@FILE = 3  -  ONE BRANCH / ALL BOOK             *
     C*              @@FILE = 4  -  ALL BRANCH / ALL BOOK             *
     C*                                                               *
     C*****************************************************************
      *
     C     #KG           BEGSR
      *
      ** Set up array index, used for moving shortname of month into
      **     field for display on screen
      ** Also set up field @DAYCH to check that correct half of month
      **     has been read
      *
      **
      ** Set up key of currency, branch and value date period
      **   to read file DLMSY3L
     C     @@FILE        IFEQ      '3'
     C     @KPRT3        READE     DLMSY3L                                71
      *
     C     *IN71         IFNE      '1'
     C                   MOVE      KDCENT        @KCENT
     C                   MOVE      KDVDTP        @DAYCH            1
     C                   MOVE      KDVDTP        @MONCH            3
     C                   MOVEL     @MONCH        @M                2 0
      *
      ** Ensure month is valid (between 1 & 12) - if not, set
      ** on DATABASE ERROR and return
     C     @M            IFLT      1
     C     @M            ORGT      12
      *
     C                   MOVEL     'DLMSY3L '    DBFILE                         ***************
     C                   MOVE      @KCRCY        @DBKEY                         *             *
     C                   MOVEL     @DBKEY        DBKEY                          * DBERROR 031 *
     C                   MOVE      @KBRCA        DBKEY                          *             *
     C                   MOVE      '031'         DBASE                          ***************
      *
     C                   EXSR      *PSSR
     C                   END
      *
      ** Otherwise, move month name and 2 digit year into datastructure
      ** field, ready for display
     C                   MOVEL     KDVDTP        @YEARX            2
     C                   MOVE      @YEARX        @DCON1
     C                   MOVEL     @MT(@M)       @DCON1
      *
     C                   MOVEL     DRCRD1        DLRCRD           19
     C                   END
      *
     C                   END
      *
      **
      ** Set up key of currency and value date period to read DLMSY4L
     C     @@FILE        IFEQ      '4'
     C     @KPRT4        READE     DLMSY4L                                71
      *
     C     *IN71         IFNE      '1'
     C                   MOVE      KECENT        @KCENT
     C                   MOVE      KEVDTP        @DAYCH            1
     C                   MOVE      KEVDTP        @MONCH            3
     C                   MOVEL     @MONCH        @M                2 0
      *
      ** Ensure month is valid (between 1 & 12) - if not, set
      ** on DATABASE ERROR and return
     C     @M            IFLT      1
     C     @M            ORGT      12
      *                                                    ***************
     C                   MOVEL     'DLMSY4L '    DBFILE                         *             *
     C                   MOVE      @KCRCY        DBKEY                          * DBERROR 032 *
     C                   MOVE      '032'         DBASE                          *             *
      *                                                    ***************
     C                   EXSR      *PSSR
     C                   END
      *
      ** Otherwise, move month name and 2 digit year into datastructure
      ** field, ready for display
     C                   MOVEL     KEVDTP        @YEARX            2
     C                   MOVE      @YEARX        @DCON2
     C                   MOVEL     @MT(@M)       @DCON2
      *
     C                   MOVEL     DRCRD2        DLRCRD
     C                   END
      *
     C                   END
      *
      *
     C                   ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #AB      - SET UP PROMPT FIELDS - WITH DEFAULTS IF NECESSARY  *
     C*                                                               *
     C* CALLS                                                         *
     C*                                                               *
     C* CALLED BY  #A      -  INITIAL PROCESSING                      *
     C*                                                               *
     C* FLDS USED  @KBKCD  -  BOOK CODE      }                        *
     C*            @KCRCY  -  CURRENCY       }                        *
     C*            @KBRCA  -  BRANCH CODE    } FROM PARAMETER STRING  *
     C*            @KMMYY  -  MONTH/YEAR FMT }                        *
     C*                                                               *
     C*            @SBOOK  -  BOOK CODE      }                        *
     C*            @SCRCY  -  CURRENCY       }                        *
     C*            @SBRCA  -  BRANCH CODE    } SET UP IN PROMPTS      *
     C*            @SMMYY  -  MONTH/YEAR FMT }                        *
     C*                                                               *
     C*            @FBRCA  -  DEFAULT BRANCH CODE                     *
     C*            @FBKCD  -  DEFAULT BOOK CODE                       *
     C*            @FMMYY  -  DEFAULT MONTH/YEAR OF RUN DATE          *
     C*                                                               *
     C*****************************************************************
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
     C                   MOVE      @KCRCY        @SCRCY
      *
      ** If from menu, set screen fields to default values
     C     @FROM         IFEQ      'M'
     C                   MOVE      @FBRCA        @SBRCA
     C                   MOVE      @FBKCD        @SBOOK
     C                   END
      *
      ** If from stack
     C     @FROM         IFEQ      'S'
      *
      ** If passed branch is blank, set screen branch to 'ALL'
     C     @KBRCA        IFEQ      *BLANKS
     C                   MOVE      'ALL'         @SBRCA
     C                   ELSE
      *
      ** Else set screen branch as passed
     C                   MOVE      @KBRCA        @SBRCA
     C                   END
      *
      ** Blank out screen book field screen book to 'ALL'
     C                   MOVE      *BLANKS       @SBOOK
      *
      ** If passed book is blank, set screen book to 'ALL'
     C     @KBKCD        IFEQ      *BLANKS
     C                   MOVE      'ALL'         @SBOOK
     C                   ELSE
      *
      ** Else set screen book as passed
     C                   MOVE      @KBKCD        @SBOOK
     C                   END
      *
     C                   END
     C*
     C** IF MONTH/YEAR BLANK THEN SET UP THIS WITH TODAYS MONTH/YEAR
     C** DATE FROM THE INSTALLATION FILE (FIELD BJMRDT)
     C*
     C     @KMMYY        IFEQ      *BLANKS                                      B1
     C*
     C**  Convert date from format MMMYY to MMYY ( '01' is used as
     C**  'dummy' day )
     C*
     C                   MOVE      @FMMYY        @SMMYY                         1
     C                   MOVEL     @FMMYY        TST3              3
     C                   ELSE
     C                   MOVE      @KMMYY        @SMMYY
     C                   MOVEL     @KMMYY        TST3              3
     C                   END
     C*
     C*  TO DIFFERENTIATE BEFORE AND AFTER YEAR 2000 RECORDS
     C*  IF **CENT IS 2 THEN THE RECORDS ARE FOR YEAR 2000 AND
     C*  ONWARDS. IF **CENT IS 1 THEN RECORDS ARE FROM BEFORE
     C*  THE YEAR 2000
     C                   MOVE      @SMMYY        @YY1              2 0
     C     @YY1          IFLT      72
     C                   MOVE      '2'           @KCENT
     C                   MOVE      '2'           @KCENT
     C                   ELSE
     C                   MOVE      '1'           @KCENT
     C                   MOVE      '1'           @KCENT
     C                   ENDIF
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
     C*            #KC     -  DETERMINE FILE - READE WITH PROMPT KEY  *
     C*                                                               *
     C* CALLED BY  #B      -  MAIN PROCESSING                         *
     C*            #BB     -  ROLLDOWN ENQUIRY SUBFILE                *
     C*                                                               *
     C* FLDS USED  RRN     -  COUNT FOR ROLLING UP AND DOWN           *
     C*            @@ERMS  -  ERROR-MESSAGE-TO-DISPLAY INDICATOR - Y/N*
     C*            @TOPRD  -  FIRST RECORD CURRENTLY ON SUBFILE       *
     C*            @BOTRD  -  LAST RECORD CURRENTLY ON SUBFILE        *
     C*            @SRCRD  -  RECORD DATA OFF SUMMARY FILE (DATA STRT)*
     C*            @MSGID -   ERROR MESSAGE NUMBER TO SEND TO ZA0240  *
     C*                                                               *
     C*****************************************************************
     C*
     C     #BA           BEGSR
     C*
     C** DO FOR AS MANY RECORDS AS THERE ARE IN THE SUBFILE PAGE
     C*
     C                   Z-ADD     1             RRN               1 0
     C*
     C     RRN           DOUEQ     5                                            B1
      *
      ** Setup file key
      **       if not first time round
      **       or not refresh process
      **       and rollup not called from subroutine rolldown (because
      **       file pointer already at first record)
     C     RRN           IFNE      1
     C     *IN05         ORNE      '1'
     C     *IN26         ANDNE     '1'
      *
      ** If only book is 'ALL'
      **    set greater than limits on file DLMSY3L (ie. next value
      **    date period) then read the next record on the file DLMSY3L.
     C     @@FILE        IFEQ      '3'
     C                   EXSR      #KB
     C                   READ      DLMSY3L                                71
      *
      ** If no error on read and the file values equal the key values,
      **    use the value date period to setup the key,
      **    set lower limits on DLMSY3L with new key.
     C     *IN71         IFNE      '1'
     C     KDCCY         ANDEQ     @KCRCY
     C     KDBRCA        ANDEQ     @KBRCA
     C                   MOVE      KDVDTP        @KVLDT
     C                   MOVE      KDCENT        @KCENT
     C                   EXSR      #KA
     C                   END
     C                   END
      *
      ** If both book and branch are 'ALL'
      **    set greater than limits on file DLMSY4L (ie. next value
      **    date period) then read the next record on the file DLMSY4L.
     C     @@FILE        IFEQ      '4'
     C                   EXSR      #KB
     C                   READ      DLMSY4L                                71
      *
      ** If no error on read and the file values equal the key values,
      **    use the value date period to setup the key,
      **    set lower limits on DLMSY4L with new key.
     C     *IN71         IFNE      '1'
     C     KECCY         ANDEQ     @KCRCY
     C                   MOVE      KEVDTP        @KVLDT
     C                   MOVE      KECENT        @KCENT
     C                   EXSR      #KA
     C                   END
     C                   END
      *
     C                   END
     C*
     C** IF NOT END-FILE ...
     C** READ THE SUMMARY FILE
     C*
     C     *IN71         IFNE      '1'
      *
     C     @@FILE        IFEQ      '1'
     C     @@FILE        OREQ      '2'
     C                   EXSR      #KC                                          *1
     C                   ELSE
     C                   EXSR      #KG
     C                   END
      *
     C                   END
     C*
     C** If record found by READE, check that the first half of the
     C** month has been read, not second half
     C*
     C     *IN71         IFNE      '1'                                          B*2
     C     @DAYCH        ANDNE     '1'                                          **2
     C*                                                                  *
      *
     C     @@FILE        IFEQ      '1'                                          ***************
     C                   MOVEL     'DLMSY1L'     DBFILE                         *             *
     C                   MOVEL     DLRCRD        DBKEY                          * DBERROR 008 *
     C                   MOVE      '008'         DBASE                          *             *
     C                   END                                                    ***************
      *
     C     @@FILE        IFEQ      '2'                                          ***************
     C                   MOVEL     'DLMSY2L'     DBFILE                         *             *
     C                   MOVEL     DLRCRD        DBKEY                          * DBERROR 009 *
     C                   MOVE      '009'         DBASE                          *             *
     C                   END                                                    ***************
      *
     C     @@FILE        IFEQ      '3'                                          ***************
     C                   MOVEL     'DLMSY3L'     DBFILE                         *             *
     C                   MOVEL     DLRCRD        DBKEY                          * DBERROR 033 *
     C                   MOVE      '033'         DBASE                          *             *
     C                   END                                                    ***************
      *
     C     @@FILE        IFEQ      '4'                                          ***************
     C                   MOVEL     'DLMSY4L'     DBFILE                         *             *
     C                   MOVEL     DLRCRD        DBKEY                          * DBERROR 034 *
     C                   MOVE      '034'         DBASE                          *             *
     C                   END                                                    ***************
      *
     C*
     C                   EXSR      *PSSR                                        **2
     C*
     C                   ELSE                                                   X*2
     C*
     C     *IN71         IFEQ      '1'                                          B**3
     C*
     C     RRN           IFEQ      1                                            B***4
     C*
     C* IF ROUTINE HAS BEEN CALLED BY REFRESH;THEN DEAL DETAILS
     C* HAVE BEEN DELETED
     C*
     C     *IN05         IFEQ      '1'
     C                   MOVEL     'FIS0014'     @MSGID
     C                   WRITE     DCLEAR
     C*
     C                   ELSE
     C*
     C** IF END OF FILE AND HAVEN'T WRITTEN ONE RECORD TO SUBFILE
     C** OUTPUT A 'NO RECORDS TO ROLLUP' MESSAGE AND RESET THE
     C** ERROR-MESSAGE-TO-DISPLAY INDICATOR
     C*
     C                   MOVEL     'FIS0004'     @MSGID                         ****4
     C*
     C                   END
     C*
     C                   CALL      'ZA0240'                                     ****4
     C                   PARM                    @MSGID                         ****4
     C                   MOVE      'Y'           @@ERMS                         ****4
     C*
     C                   END                                                    E***4
     C*
     C** RESET THE COUNTER TO 5 TO END DO LOOP AND SET THE
     C** SUBFILE END INDICATOR ON
     C*
     C                   Z-ADD     5             RRN                            ***3
     C                   MOVE      '1'           *IN30                          ***3
     C*
     C** ELSE IF IT IS NOT THE END OF FILE THEN CLEAR THE SUBFILE,
     C** SET OFF THE SUBFILE END INDICATOR AND STORE THE RECORD THE
     C** FIRST TIME ROUND.
     C*
     C                   ELSE                                                   X**3
     C*
     C** THE FIRST TIME ROUND CLEAR THE SUBFILE, SET OFF THE SUBFILE
     C** END INDICATOR AND STORE THE FIRST RECORD IN THE SUBFILE
     C*
     C     RRN           IFEQ      1                                            B***4
     C*
     C** CLEAR THE SUBFILE BY SETTING OFF THE SUBFILE DISPLAY AND
     C** THE SUBFILE DISPLAY CONTROL INDICATORS AND THEN WRITING
     C** THE ENQUIRY SUBFILE CONTROL FORMAT
     C*
     C                   MOVE      '0'           *IN35                          ****4
     C                   MOVE      '0'           *IN36                          ****4
     C                   WRITE     DL1909C1                                     ****4
     C*
     C                   MOVE      '0'           *IN30                          ****4
     C                   MOVE      DLRCRD        @TOPRD           19            ****4
     C*
     C                   END                                                    E***4
     C*
      ** If book is 'ALL' and branch is not,
     C     @@FILE        IFEQ      '3'
      *
      ** Initialise total field values for 1st half of month
     C                   Z-ADD     KDNP03        @1NP03
     C                   Z-ADD     KDNP06        @1NP06
     C                   Z-ADD     KDNP09        @1NP09
     C                   Z-ADD     KDNP12        @1NP12
     C                   Z-ADD     KDNPRR        @1NPRR
      *
      ** Set count1 to one
     C                   Z-ADD     1             COUNT1            4 0
     C                   END
      *
      ** If book and branch are 'ALL'
     C     @@FILE        IFEQ      '4'
      *
      ** Initialise total field values for 1st half of month
     C                   Z-ADD     KENP03        @1NP03
     C                   Z-ADD     KENP06        @1NP06
     C                   Z-ADD     KENP09        @1NP09
     C                   Z-ADD     KENP12        @1NP12
     C                   Z-ADD     KENPRR        @1NPRR
      *
      ** Set count1 to one
     C                   Z-ADD     1             COUNT1
     C                   END
      *
      ** If book is 'ALL'
     C     @@FILE        IFEQ      '3'
     C     @@FILE        OREQ      '4'
      *
      ** If book is 'ALL' and branch is not,
     C     @@FILE        IFEQ      '3'
      *
      ** Do while record with the same ccy/branch/value date period found
     C     *IN71         DOUEQ     '1'
      *
      ** READE on file DLMSY3L (to get 1st half of month)
     C                   EXSR      #KG
      *
      ** If record found
     C     *IN71         IFNE      '1'
      *
      ** Add file field values to the totals for 1st half of month
     C                   ADD       KDNP03        @1NP03
     C                   ADD       KDNP06        @1NP06
     C                   ADD       KDNP09        @1NP09
     C                   ADD       KDNP12        @1NP12
     C                   ADD       KDNPRR        @1NPRR
      *
      ** Add 1 to count1
     C                   ADD       1             COUNT1
      *
     C                   END
     C                   END
      *
      ** Change the value date period saved in key field to 2nd period
     C                   MOVE      '2'           @KVLDT
      *
      ** Setup file to first record of 2nd periods
     C                   EXSR      #KA
      *
      ** Initialise totals for 2nd half of month
     C                   Z-ADD     0             @2NP03
     C                   Z-ADD     0             @2NP06
     C                   Z-ADD     0             @2NP09
     C                   Z-ADD     0             @2NP12
     C                   Z-ADD     0             @2NPRR
      *
      ** Set count2 to zero
     C                   MOVE      0             COUNT2            4 0
      *
      ** Set *IN71 to zero
     C                   MOVE      0             *IN71
      *
      ** Do while record with the same ccy/branch/value date period found
     C     *IN71         DOUEQ     '1'
      *
      ** READE on file DLMSY3L (to get 2nd half of month)
     C                   EXSR      #KG
      *
      ** If record found
     C     *IN71         IFNE      '1'
      *
      ** Add file field values to the totals for 2nd half of month
     C                   ADD       KDNP03        @2NP03
     C                   ADD       KDNP06        @2NP06
     C                   ADD       KDNP09        @2NP09
     C                   ADD       KDNP12        @2NP12
     C                   ADD       KDNPRR        @2NPRR
      *
      ** Add 1 to count2
     C                   ADD       1             COUNT2
      *
      ** Store the record as the last one in case there are no more
     C                   MOVE      DLRCRD        @BOTRD
      *
     C                   END
     C                   END
      *
      ** Set *IN71 to zero
     C                   MOVE      0             *IN71
      *
      ** If counts are not equal, this means that the number of records
      *     for the first period do not match the number of records for
      *     the second period. Therefore process database error.
     C     COUNT1        IFNE      COUNT2
      *                                                    ***************
     C                   MOVEL     'DLMSY3L'     DBFILE                         *             *
     C                   MOVEL     DLRCRD        DBKEY                          * DBERROR 035 *
     C                   MOVE      '035'         DBASE                          *             *
      *                                                    ***************
     C                   EXSR      *PSSR
      *
     C                   END
      *
      ** Move total fields for 1st half of month back to original
      **      file fields because they are used by subroutine #BD
     C                   Z-ADD     @1NP03        KDNP03
     C                   Z-ADD     @1NP06        KDNP06
     C                   Z-ADD     @1NP09        KDNP09
     C                   Z-ADD     @1NP12        KDNP12
     C                   Z-ADD     @1NPRR        KDNPRR
      *
      ** Edit first subfile line
     C                   EXSR      #BD
      *
      ** Move total fields for 2nd half of month back to original
      **      file fields because they are used by subroutine #BE
     C                   Z-ADD     @2NP03        KDNP03
     C                   Z-ADD     @2NP06        KDNP06
     C                   Z-ADD     @2NP09        KDNP09
     C                   Z-ADD     @2NP12        KDNP12
     C                   Z-ADD     @2NPRR        KDNPRR
      *
      ** Edit second subfile line
     C                   EXSR      #BE
      *
     C                   END
      *
      ** If book and branch are 'ALL'
     C     @@FILE        IFEQ      '4'
      *
      ** Do while record with the same ccy/value date period found
     C     *IN71         DOUEQ     '1'
      *
      ** READE on file DLMSY4L (to get 1st half of month)
     C                   EXSR      #KG
      *
      ** If record found
     C     *IN71         IFNE      '1'
      *
      ** Add file field values to the totals for 1st half of month
     C                   ADD       KENP03        @1NP03
     C                   ADD       KENP06        @1NP06
     C                   ADD       KENP09        @1NP09
     C                   ADD       KENP12        @1NP12
     C                   ADD       KENPRR        @1NPRR
      *
      ** Add 1 to count1
     C                   ADD       1             COUNT1
      *
     C                   END
     C                   END
      *
      ** Change the value date period saved in key field to 2nd period
     C                   MOVE      '2'           @KVLDT
      *
      ** Setup file to first record of 2nd periods
     C                   EXSR      #KA
      *
      ** Initialise totals for 2nd half of month
     C                   Z-ADD     0             @2NP03
     C                   Z-ADD     0             @2NP06
     C                   Z-ADD     0             @2NP09
     C                   Z-ADD     0             @2NP12
     C                   Z-ADD     0             @2NPRR
      *
      ** Set count2 to zero
     C                   MOVE      0             COUNT2
      *
      ** Set *IN71 to zero
     C                   MOVE      0             *IN71
      *
      ** Do while record with the same ccy/value date period found
     C     *IN71         DOUEQ     '1'
      *
      ** READE on file DLMSY4L (to get 2nd half of month)
     C                   EXSR      #KG
      *
      ** If record found
     C     *IN71         IFNE      '1'
      *
      ** Add file field values to the totals for 2nd half of month
     C                   ADD       KENP03        @2NP03
     C                   ADD       KENP06        @2NP06
     C                   ADD       KENP09        @2NP09
     C                   ADD       KENP12        @2NP12
     C                   ADD       KENPRR        @2NPRR
      *
      ** Add 1 to count2
     C                   ADD       1             COUNT2
      *
      ** Store the record as the last one in case there are no more
     C                   MOVE      DLRCRD        @BOTRD
      *
     C                   END
     C                   END
      *
      ** Set *IN71 to zero
     C                   MOVE      0             *IN71
      *
      ** If counts are not equal, this means that the number of records
      *     for the first period do not match the number of records for
      *     the second period. Therefor process database error.
     C     COUNT1        IFNE      COUNT2
      *                                                    ***************
     C                   MOVEL     'DLMSY4L'     DBFILE                         *             *
     C                   MOVEL     DLRCRD        DBKEY                          * DBERROR 036 *
     C                   MOVE      '036'         DBASE                          *             *
      *                                                    ***************
     C                   EXSR      *PSSR
      *
     C                   END
      *
      ** Move total fields for 1st half of month back to original
      **      file fields because they are used by subroutine #BD
     C                   MOVE      @1NP03        KENP03
     C                   MOVE      @1NP06        KENP06
     C                   MOVE      @1NP09        KENP09
     C                   MOVE      @1NP12        KENP12
     C                   MOVE      @1NPRR        KENPRR
      *
      ** Edit first subfile line
     C                   EXSR      #BD
      *
      ** Move total fields for 2nd half of month back to original
      **      file fields because they are used by subroutine #BE
     C                   MOVE      @2NP03        KENP03
     C                   MOVE      @2NP06        KENP06
     C                   MOVE      @2NP09        KENP09
     C                   MOVE      @2NP12        KENP12
     C                   MOVE      @2NPRR        KENPRR
      *
      ** Edit second subfile line
     C                   EXSR      #BE
      *
     C                   END
     C                   ELSE
      *
      ** Else book is not 'ALL'
      *
     C** EDIT THE FIELDS AND THEN WRITE THE RECORD TO THE SUBFILE
     C*
     C                   EXSR      #BD                                          ***3
     C*
     C** READE Summary File for 2nd line of subfile format
     C*
     C                   EXSR      #KC                                          ***3
     C*
     C** If error occurs, output Database Error, since rec should exist
     C*
     C     *IN71         IFEQ      '1'                                          B***4
     C*
     C     @@FILE        IFEQ      '1'                                          B****5
     C*                                                    ***************
     C                   MOVEL     'DLMSY1L'     DBFILE                         *             *
     C                   MOVEL     DLRCRD        DBKEY                          * DBERROR 010 *
     C                   MOVE      '010'         DBASE                          *             *
     C*                                                    ***************
     C                   ELSE                                                   X****5
     C*                                                    ***************
     C                   MOVEL     'DLMSY2L'     DBFILE                         *
     C                   MOVEL     DLRCRD        DBKEY                          * DBERROR 011 *
     C                   MOVE      '011'         DBASE                          *             *
     C*                                                    ***************
     C                   END                                                    E****5
     C*
     C                   EXSR      *PSSR                                        ****4
     C*
     C                   END                                                    E***4
     C*
     C** STORE THE RECORD AS THE LAST ONE IN CASE THERE ARE NO MORE
     C*
     C                   MOVE      DLRCRD        @BOTRD           19            ***3
     C*
     C**  If READE successful, edit the fields prior to displaying them
     C*
     C                   EXSR      #BE                                          ***3
      *
     C                   END
     C*
     C**  Now move the edited amounts (which are 11 char signed format)
     C**  into numeric format, add them together and produce the totals
     C**  which are displayed on line 3 of the subfile display
     C*
     C                   EXSR      #BF                                          ***3
     C*
     C                   WRITE     DL1909S1                                     ***3
     C                   ADD       1             RRN                            ***3
     C*
     C                   END                                                    E**3
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
     C*            @SRCRD  -  RECORD DATA OFF SUMMARY FILE (DATA STRT)*
     C*            @MSGID -   ERROR MESSAGE NUMBER TO SEND TO ZA0240  *
     C*                                                               *
     C*****************************************************************
     C*
     C     #BB           BEGSR
     C*
     C** READ THE SUMMARY FILE BACKWARDS AND FILL THE SUBFILE SIMILARLY
     C** DO FOR AS MANY RECORDS AS THERE ARE IN THE SUBFILE PAGE
     C** (STARTING AT THE BOTTOM)
     C*
     C                   Z-ADD     4             RRN
     C*
     C     RRN           DOUEQ     0                                            B1
      *
      ** If only book is 'ALL'
      **    set lower limits on file DLMSY3L
      **    then read the previous record on the file DLMSY3L.
     C     @@FILE        IFEQ      '3'
     C                   EXSR      #KA
     C                   READP     DLMSY3L                                72
      *
      ** If no error on read and the file values equal the key values,
      **    use the value date period to setup the key,
      **    set greater than limits on DLMSY3L with new key.
     C     *IN72         IFNE      '1'
     C     KDCCY         ANDEQ     @KCRCY
     C     KDBRCA        ANDEQ     @KBRCA
     C                   MOVE      KDVDTP        @KVLDT
     C                   MOVE      KDCENT        @KCENT
     C                   EXSR      #KB
     C                   END
     C                   END
      *
      ** If both book and branch are 'ALL'
      **    set lower limits on file DLMSY4L
      **    then read the previous record on the file DLMSY4L.
     C     @@FILE        IFEQ      '4'
     C                   EXSR      #KA
     C                   READP     DLMSY4L                                72
      *
      ** If no error on read and the file values equal the key values,
      **    use the value date period to setup the key,
      **    set greater than limits on DLMSY3L with new key.
     C     *IN72         IFNE      '1'
     C     KECCY         ANDEQ     @KCRCY
     C                   MOVE      KEVDTP        @KVLDT
     C                   MOVE      KECENT        @KCENT
     C                   EXSR      #KB
     C                   END
     C                   END
     C*
     C** READ THE PREVIOUS RECORD
     C*
     C     *IN72         IFNE      '1'
     C                   EXSR      #KE                                          *1
     C                   END
     C*
     C     *IN72         IFEQ      '1'                                          B*2
     C*
     C     RRN           IFEQ      4                                            B**3
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
     C** RELEVANT DATA REACHED BEFORE SUBFILE FULL - SO POSITION AT THE
     C** TOP OF FILE (OR START OF DATA) USING #KD SUBR.  THEN PROCESS
     C** AS FOR A ROLLUP, UNTIL SUBFILE IS FULL.
     C*
     C                   ELSE                                                   X**3
     C*
     C                   EXSR      #KD                                          ***3
     C                   EXSR      #BA                                          ***3
     C*
     C                   END                                                    E**3
     C*
     C** RESET THE COUNTER TO 0 TO END DO LOOP
     C*
     C                   Z-ADD     0             RRN                            **2
     C*
     C** ELSE IF BEGINNING OF SUBFILE NOT REACHED
     C*
     C                   ELSE                                                   X*2
     C*
     C** THE FIRST TIME ROUND CLEAR THE SUBFILE, SET OFF THE SUBFILE
     C** END INDICATOR AND STORE THE LAST RECORD IN THE SUBFILE
     C*
     C     RRN           IFEQ      4                                            B**3
     C*
     C** CLEAR THE SUBFILE BY SETTING OFF THE SUBFILE DISPLAY AND
     C** THE SUBFILE DISPLAY CONTROL INDICATORS AND THEN WRITING
     C** THE ENQUIRY SUBFILE CONTROL FORMAT
     C*
     C                   MOVE      '0'           *IN35                          ***3
     C                   MOVE      '0'           *IN36                          ***3
     C                   WRITE     DL1909C1                                     ***3
     C*
     C                   MOVE      '0'           *IN30                          ***3
     C                   MOVE      DLRCRD        @BOTRD                         ***3
     C*
     C                   END                                                    E**3
      *
      ** If book is 'ALL' and branch is not,
     C     @@FILE        IFEQ      '3'
      *
      ** Initialise total field values for 2nd half of month
     C                   Z-ADD     KDNP03        @2NP03
     C                   Z-ADD     KDNP06        @2NP06
     C                   Z-ADD     KDNP09        @2NP09
     C                   Z-ADD     KDNP12        @2NP12
     C                   Z-ADD     KDNPRR        @2NPRR
      *
      ** Set count2 to one
     C                   Z-ADD     1             COUNT2
     C                   END
      *
      ** If book and branch are 'ALL'
     C     @@FILE        IFEQ      '4'
      *
      ** Initialise total field values for 2nd half of month
     C                   Z-ADD     KENP03        @2NP03
     C                   Z-ADD     KENP06        @2NP06
     C                   Z-ADD     KENP09        @2NP09
     C                   Z-ADD     KENP12        @2NP12
     C                   Z-ADD     KENPRR        @2NPRR
      *
      ** Set count2 to one
     C                   Z-ADD     1             COUNT2
     C                   END
      *
      ** If book is 'ALL'
     C     @@FILE        IFEQ      '3'
     C     @@FILE        OREQ      '4'
      *
      ** If book is 'ALL' and branch is not,
     C     @@FILE        IFEQ      '3'
      *
      ** Do while record with the same ccy/branch/value date period found
     C     *IN72         DOUEQ     '1'
      *
      ** READP on file DLMSY3L (to get 2nd half of month)
     C                   EXSR      #KE
      *
      ** If record found
     C     *IN72         IFNE      '1'
      *
      ** Add file field values to the totals for 2nd half of month
     C                   ADD       KDNP03        @2NP03
     C                   ADD       KDNP06        @2NP06
     C                   ADD       KDNP09        @2NP09
     C                   ADD       KDNP12        @2NP12
     C                   ADD       KDNPRR        @2NPRR
      *
      ** Add 1 to count2
     C                   ADD       1             COUNT2
      *
     C                   END
     C                   END
      *
      ** Change the value date period saved in key field to 1st period
     C                   MOVE      '1'           @KVLDT
      *
      ** Setup file to last record of 1st periods
     C                   EXSR      #KB
      *
      ** Initialise totals for 1st half of month
     C                   Z-ADD     0             @1NP03
     C                   Z-ADD     0             @1NP06
     C                   Z-ADD     0             @1NP09
     C                   Z-ADD     0             @1NP12
     C                   Z-ADD     0             @1NPRR
      *
      ** Set count1 to zero
     C                   MOVE      0             COUNT1
      *
      ** Set *IN72 to zero
     C                   MOVE      0             *IN72
      *
      ** Do while record with the same ccy/branch/value date period found
     C     *IN72         DOUEQ     '1'
      *
      ** READP on file DLMSY3L (to get 1st half of month)
     C                   EXSR      #KE
      *
      ** If record found
     C     *IN72         IFNE      '1'
      *
      ** Add file field values to the totals for 1st half of month
     C                   ADD       KDNP03        @1NP03
     C                   ADD       KDNP06        @1NP06
     C                   ADD       KDNP09        @1NP09
     C                   ADD       KDNP12        @1NP12
     C                   ADD       KDNPRR        @1NPRR
      *
      ** Add 1 to count1
     C                   ADD       1             COUNT1
      *
      ** Store the record as the first one in case there are no more
     C                   MOVE      DLRCRD        @TOPRD
      *
     C                   END
     C                   END
      *
      ** Set *IN72 to zero
     C                   MOVE      0             *IN72
      *
      ** If counts are not equal, this means that the number of records
      *     for the first period do not match the number of records for
      *     the second period. Therefore process database error.
     C     COUNT1        IFNE      COUNT2
      *                                                    ***************
     C                   MOVEL     'DLMSY3L'     DBFILE                         *             *
     C                   MOVEL     DLRCRD        DBKEY                          * DBERROR 037 *
     C                   MOVE      '037'         DBASE                          *             *
      *                                                    ***************
     C                   EXSR      *PSSR
      *
     C                   END
      *
      ** Move total fields for 2nd half of month back to original
      **      file fields because they are used by subroutine #BE
     C                   Z-ADD     @2NP03        KDNP03
     C                   Z-ADD     @2NP06        KDNP06
     C                   Z-ADD     @2NP09        KDNP09
     C                   Z-ADD     @2NP12        KDNP12
     C                   Z-ADD     @2NPRR        KDNPRR
      *
      ** Edit second subfile line
     C                   EXSR      #BE
      *
      ** Move total fields for 1st half of month back to original
      **      file fields because they are used by subroutine #BD
     C                   Z-ADD     @1NP03        KDNP03
     C                   Z-ADD     @1NP06        KDNP06
     C                   Z-ADD     @1NP09        KDNP09
     C                   Z-ADD     @1NP12        KDNP12
     C                   Z-ADD     @1NPRR        KDNPRR
      *
      ** Edit first subfile line
     C                   EXSR      #BD
      *
     C                   END
      *
      ** If book and branch are 'ALL'
     C     @@FILE        IFEQ      '4'
      *
      ** Do while record with the same ccy/value date period found
     C     *IN72         DOUEQ     '1'
      *
      ** READP on file DLMSY4L (to get 2nd half of month)
     C                   EXSR      #KE
      *
      ** If record found
     C     *IN72         IFNE      '1'
      *
      ** Add file field values to the totals for 2nd half of month
     C                   ADD       KENP03        @2NP03
     C                   ADD       KENP06        @2NP06
     C                   ADD       KENP09        @2NP09
     C                   ADD       KENP12        @2NP12
     C                   ADD       KENPRR        @2NPRR
      *
      ** Add 1 to count2
     C                   ADD       1             COUNT2
      *
     C                   END
     C                   END
      *
      ** Change the value date period saved in key field to 1st period
     C                   MOVE      '1'           @KVLDT
      *
      ** Setup file to last record of 1st periods
     C                   EXSR      #KB
      *
      ** Initialise totals for 1st half of month
     C                   Z-ADD     0             @1NP03
     C                   Z-ADD     0             @1NP06
     C                   Z-ADD     0             @1NP09
     C                   Z-ADD     0             @1NP12
     C                   Z-ADD     0             @1NPRR
      *
      ** Set count1 to zero
     C                   MOVE      0             COUNT1
      *
      ** Set *IN72 to zero
     C                   MOVE      0             *IN72
      *
      ** Do while record with the same ccy/value date period found
     C     *IN72         DOUEQ     '1'
      *
      ** READP on file DLMSY4L (to get 1st half of month)
     C                   EXSR      #KE
      *
      ** If record found
     C     *IN72         IFNE      '1'
      *
      ** Add file field values to the totals for 1st half of month
     C                   ADD       KENP03        @1NP03
     C                   ADD       KENP06        @1NP06
     C                   ADD       KENP09        @1NP09
     C                   ADD       KENP12        @1NP12
     C                   ADD       KENPRR        @1NPRR
      *
      ** Add 1 to count1
     C                   ADD       1             COUNT1
      *
      ** Store the record as the first one in case there are no more
     C                   MOVE      DLRCRD        @TOPRD
      *
     C                   END
     C                   END
      *
      ** Set *IN72 to zero
     C                   MOVE      0             *IN72
      *
      ** If counts are not equal, this means that the number of records
      *     for the first period do not match the number of records for
      *     the second period. Therefor process database error.
     C     COUNT1        IFNE      COUNT2
      *                                                    ***************
     C                   MOVEL     'DLMSY4L'     DBFILE                         *             *
     C                   MOVEL     DLRCRD        DBKEY                          * DBERROR 038 *
     C                   MOVE      '038'         DBASE                          *             *
      *                                                    ***************
     C                   EXSR      *PSSR
      *
     C                   END
      *
      ** Move total fields for 2nd half of month back to original
      **      file fields because they are used by subroutine #BE
     C                   MOVE      @2NP03        KENP03
     C                   MOVE      @2NP06        KENP06
     C                   MOVE      @2NP09        KENP09
     C                   MOVE      @2NP12        KENP12
     C                   MOVE      @2NPRR        KENPRR
      *
      ** Edit second subfile line
     C                   EXSR      #BE
      *
      ** Move total fields for 1st half of month back to original
      **      file fields because they are used by subroutine #BD
     C                   MOVE      @1NP03        KENP03
     C                   MOVE      @1NP06        KENP06
     C                   MOVE      @1NP09        KENP09
     C                   MOVE      @1NP12        KENP12
     C                   MOVE      @1NPRR        KENPRR
      *
      ** Edit first subfile line
     C                   EXSR      #BD
      *
     C                   END
     C                   ELSE
      *
      ** Else book is not 'ALL'
      *
     C*
     C*  EDIT THE FIELDS IN THE SECOND LINE OF THE SUBFILE
     C*
     C                   EXSR      #BE                                          **2
     C*
     C** Set up pointer to READP Summary File for 1st line of Subfile
     C*
     C                   Z-ADD     1             @KDDNO                         **2
     C*
     C** READP Summary File
     C*
     C                   EXSR      #KE                                          **2
     C*
     C** If error occurs, output Database Error, since rec should exist
     C*
     C     *IN72         IFEQ      '1'                                          B**3
     C*
     C     @@FILE        IFEQ      '1'                                          B***4
     C*                                                    ***************
     C                   MOVEL     'DLMSY1L'     DBFILE                         *             *
     C                   MOVEL     *BLANKS       DBKEY                          * DBERROR 012 *
     C                   MOVE      '012'         DBASE                          *             *
     C*                                                    ***************
     C                   ELSE                                                   X***4
     C*                                                    ***************
     C                   MOVEL     'DLMSY2L'     DBFILE                         *             *
     C                   MOVEL     *BLANKS       DBKEY                          * DBERROR 013 *
     C                   MOVE      '013'         DBASE                          *             *
     C*                                                    ***************
     C                   END                                                    E***4
     C*
     C                   EXSR      *PSSR                                        ***3
     C*
     C                   END                                                    E**3
     C*
     C** STORE THE RECORD AS THE FIRST ONE IN CASE IT IS
     C*
     C                   MOVE      DLRCRD        @TOPRD                         **2
     C*
     C**  If READP successful, edit the fields prior to displaying them
     C*
     C                   EXSR      #BD                                          **2
      *
     C                   END
     C*
     C**  Now move the edited amounts (which are 11 char signed format)
     C**  into numeric format, add them together and produce the totals
     C**  which are displayed on line 3 of the subfile display
     C*
     C                   EXSR      #BF                                          **2
     C*
     C                   WRITE     DL1909S1                                     **2
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
     C*            #BD     -  EDIT ENQUIRY SUBFILE DATA               *
     C*            #KC     -  DETERMINE FILE - READE WITH PROMPT KEY  *
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
     C** VALIDATE THE DATA ENTERED IN THE PROMPTS
     C*
     C     @FROM         IFNE      'S'                                          B1
     C                   EXSR      #BCA                                         *1
     C*
     C** If error occurs in #BCA set on error-msg-to-display indicator
     C** and activate the ovratr keyword on the enquiry subfile control
     C** to reverse image the field and position the cursor.
     C*
     C     *IN69         IFEQ      '1'                                          B*2
     C                   MOVE      'Y'           @@ERMS                         **2
     C                   MOVE      '1'           *IN29                          **2
     C                   END                                                    E*2
     C*
     C                   ELSE                                                   X1
     C*
     C** AND (IF FROM STACK) CONVERT DATE TO MIDAS
     C*
     C                   MOVE      'D'           @@DFMT                         *1
     C*
     C**  Convert date from format MMYY to MMMYY ( '01' is used as
     C**  'dummy' day giving 01MMYY ).
     C*
     C                   MOVEL     @SMMYY        @TMMM             3
      *
      **  Look up month shortnames array - store month number to @TMM
      *
     C                   Z-ADD     1             @TMM              2 0
     C     @TMMM         LOOKUP    @MT(@TMM)                              90
      *
      **  Set up field for MMYY
      *
     C                   MOVE      @SMMYY        @TYY              2 0
     C                   MOVE      @TYY          @TMMYY            4 0
     C                   MOVEL     @TMM          @TMMYY
     C                   MOVE      @TMMYY        ZDATE             6 0
      *
      **  Move a 'dummy' day giving 01MMYY
      *
     C                   MOVEL     '01'          ZDATE
      *
     C                   MOVEL     '01'          ZADAT
     C                   MOVE      @SMMYY        ZADAT
      *
     C                   MOVEL     @SMMYY        WMON              3
     C     WMON          LOOKUP    @MT                                    11
     C     *IN11         IFEQ      '1'
     C                   MOVE      '0'           *IN18
     C                   ELSE
     C                   MOVE      '1'           *IN18
     C                   ENDIF
      *
     C                   EXSR      CVDT
     C                   MOVE      ZDATE         @@VLDT
     C                   EXSR      ZVLDT                                        *1
     C*
     C     @@RTN         IFEQ      '1'                                          B*2
     C                   MOVE      '024'         DBASE                          ***************
     C*                    EXSR *PSSR                      * DBERROR 024 *
     C                   ELSE                                                   X*2************
     C*
     C** Create file pointer by converting start date @@DATE from subr
     C** ZVLDT to format YYMM1 in order to find 1st rec EQ to or GT
     C** this value in relevant file. The field set up thus is
     C** @KVLDT, defined in the @KRCRD data structure.
     C*
     C                   MOVEL     @@YY          @@YMF             4 0          **2
     C                   MOVE      @@MM          @@YMF                          **2
     C                   Z-ADD     @@YMF         @KYMNO                         **2
     C                   Z-ADD     1             @KDDNO                         **2
     C                   END                                                    E*2
     C*
     C                   END                                                    E1
      *
      ** If branch and book are not equal to 'ALL',
      **    set file to '1'
     C     @SBRCA        IFNE      'ALL'
     C     @SBOOK        ANDNE     'ALL'
     C                   MOVE      '1'           @@FILE            1
     C                   END
      *
      ** If branch is 'ALL' and book is not,
      **    set file to '2'
     C     @SBRCA        IFEQ      'ALL'
     C     @SBOOK        ANDNE     'ALL'
     C                   MOVE      '2'           @@FILE
     C                   END
      *
      ** If book is 'ALL' and branch is not,
      **    set file to '3'
     C     @SBRCA        IFNE      'ALL'
     C     @SBOOK        ANDEQ     'ALL'
     C                   MOVE      '3'           @@FILE
     C                   END
      *
      ** If branch and book are both 'ALL',
      **    set file to '4'
     C     @SBRCA        IFEQ      'ALL'
     C     @SBOOK        ANDEQ     'ALL'
     C                   MOVE      '4'           @@FILE
     C                   END
      *
      *
      ** if there are no errors, set up key fields
     C     @@ERMS        IFNE      'Y'
      *
      * Set up branch key field
     C     @SBRCA        IFEQ      'ALL'
     C                   MOVE      *BLANKS       @KBRCA
     C                   ELSE
     C                   MOVE      @SBRCA        @KBRCA
     C                   END
      *
      * Set up book key field
     C     @SBOOK        IFEQ      'ALL'
     C                   MOVE      *BLANKS       @KBKCD
     C                   ELSE
     C                   MOVE      @SBOOK        @KBKCD
     C                   END
      *
      * Set up currency key field
     C                   MOVE      @SCRCY        @KCRCY
      *
      * Set up date key field
     C*
     C**  Convert date from format MMYY to MMMYY.
     C*
     C                   MOVE      @SMMYY        @KMMYY
     C*
     C*
     C*  TO DIFFERENTIATE BEFORE AND AFTER YEAR 2000 RECORDS
     C*  IF **CENT IS 2 THEN THE RECORDS ARE FOR YEAR 2000 AND
     C*  ONWARDS. IF **CENT IS 1 THEN RECORDS ARE FROM BEFORE
     C*  THE YEAR 2000
     C                   MOVE      @SMMYY        @YY1              2 0
     C     @YY1          IFLT      72
     C                   MOVE      '2'           @KCENT
     C                   MOVE      '2'           @KCENT
     C                   ELSE
     C                   MOVE      '1'           @KCENT
     C                   MOVE      '1'           @KCENT
     C                   ENDIF
     C*
      *
      ** Set lowers limit on appropriate file
     C                   EXSR      #KA                                          *1
      *
      ** If book is 'ALL' and branch is not,
      **    read the next record on the file DLMSY3L,
     C     @@FILE        IFEQ      '3'
     C                   READ      DLMSY3L                                71
      *
      ** If no error on read
     C     *IN71         IFNE      '1'
      *
      ** If prompt currency and branch do not match those read,
      **    set the value date period for the key to '99999' so that
      **    the file pointer is positioned correctly,
      ** Else use the value date period read to setup the key.
     C     KDCCY         IFNE      @SCRCY
     C     KDBRCA        ORNE      @SBRCA
     C                   MOVE      99999         @KVLDT
     C                   ELSE
     C                   MOVE      KDVDTP        @KVLDT
     C                   MOVE      KDCENT        @KCENT
     C                   END
      *
      ** Set lower limits on DLMSY3L with new key.
     C                   EXSR      #KA
     C                   END
     C                   END
      *
      ** If book and branch are 'ALL',
      **    read the next record on the file DLMSY4L,
     C     @@FILE        IFEQ      '4'
     C                   READ      DLMSY4L                                71
      *
      ** If no error on read
     C     *IN71         IFNE      '1'
      *
      ** If prompt currency does not match the file currency
      **    set the value date period for the key to '99999' so that
      **    the file pointer is positioned correctly,
      ** Else use the value date period read to setup the key.
     C     KECCY         IFNE      @SCRCY
     C                   MOVE      99999         @KVLDT
     C                   ELSE
     C                   MOVE      KEVDTP        @KVLDT
     C                   MOVE      KECENT        @KCENT
     C                   END
      *
      ** Set lower limits on DLMSY4L with new key.
     C                   EXSR      #KA
     C                   END
     C                   END
     C*
     C** DO FOR AS MANY RECORDS AS THERE ARE IN THE SUBFILE PAGE
     C*
     C                   Z-ADD     1             RRN               1 0          *1
     C*
     C     RRN           DOUEQ     5                                            B*2
      *
      ** If only book is 'ALL' and not first time round,
      **    set greater than limits on file DLMSY3L (ie. next value
      **    date period) then read the next record on the file DLMSY3L.
     C     @@FILE        IFEQ      '3'
     C     RRN           ANDNE     1
     C                   EXSR      #KB
     C                   READ      DLMSY3L                                71
      *
      ** If no error on read and the file values equal the key values,
      **    use the value date period to setup the key,
      **    set lower limits on DLMSY3L with new key.
     C     *IN71         IFNE      '1'
     C     KDCCY         ANDEQ     @KCRCY
     C     KDBRCA        ANDEQ     @KBRCA
     C                   MOVE      KDVDTP        @KVLDT
     C                   MOVE      KDCENT        @KCENT
     C                   EXSR      #KA
     C                   END
     C                   END
      *
      ** If both book and branch are 'ALL' and not first time round,
      **    set greater than limits on file DLMSY4L (ie. next value
      **    date period) then read the next record on the file DLMSY4L.
     C     @@FILE        IFEQ      '4'
     C     RRN           ANDNE     1
     C                   EXSR      #KB
     C                   READ      DLMSY4L                                71
      *
      ** If no error on read and the file values equal the key values,
      **    use the value date period to setup the key,
      **    set lower limits on DLMSY4L with new key.
     C     *IN71         IFNE      '1'
     C     KECCY         ANDEQ     @KCRCY
     C                   MOVE      KEVDTP        @KVLDT
     C                   MOVE      KECENT        @KCENT
     C                   EXSR      #KA
     C                   END
     C                   END
     C*
     C** READ THE SUMMARY FILE
     C*
     C     @@FILE        IFEQ      '1'
     C     @@FILE        OREQ      '2'
     C                   EXSR      #KC                                          **2
     C                   ELSE
     C                   EXSR      #KG
     C                   END
     C*
     C     *IN71         IFEQ      '1'                                          B**3
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
     C** RESET THE COUNTER TO 5 TO END DO LOOP AND SET THE
     C** SUBFILE END INDICATOR ON
     C*
     C                   Z-ADD     5             RRN                            ***3
     C                   MOVE      '1'           *IN30                          ***3
     C*
     C*
     C** ELSE IF THERE ARE RECORDS ON FILE AND IT IS FIRST TIME ROUND
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
     C                   WRITE     DL1909C1                                     ****4
     C*
     C                   MOVE      '0'           *IN30                          ****4
     C                   MOVE      DLRCRD        @TOPRD                         ****4
     C*
     C** SET UP NEW SCREEN HEADINGS
     C*
     C                   EXSR      #BCB                                         ****4
     C*
     C                   END                                                    E***4
      *
      ** If book is 'ALL' and branch is not,
     C     @@FILE        IFEQ      '3'
      *
      ** Initialise total field values for 1st half of month
     C                   Z-ADD     KDNP03        @1NP03           15 0
     C                   Z-ADD     KDNP06        @1NP06           15 0
     C                   Z-ADD     KDNP09        @1NP09           15 0
     C                   Z-ADD     KDNP12        @1NP12           15 0
     C                   Z-ADD     KDNPRR        @1NPRR           15 0
      *
      ** Set count1 to one
     C                   Z-ADD     1             COUNT1            4 0
     C                   END
      *
      ** If book and branch are 'ALL'
     C     @@FILE        IFEQ      '4'
      *
      ** Initialise total field values for 1st half of month
     C                   Z-ADD     KENP03        @1NP03
     C                   Z-ADD     KENP06        @1NP06
     C                   Z-ADD     KENP09        @1NP09
     C                   Z-ADD     KENP12        @1NP12
     C                   Z-ADD     KENPRR        @1NPRR
      *
      ** Set count1 to one
     C                   Z-ADD     1             COUNT1
     C                   END
      *
      ** If book is 'ALL'
     C     @@FILE        IFEQ      '3'
     C     @@FILE        OREQ      '4'
      *
      ** If book is 'ALL' and branch is not,
     C     @@FILE        IFEQ      '3'
      *
      ** Do while record with the same ccy/branch/value date period found
     C     *IN71         DOUEQ     '1'
      *
      ** READE on file DLMSY3L (to get 1st half of month)
     C                   EXSR      #KG
      *
      ** If record found
     C     *IN71         IFNE      '1'
      *
      ** Add file field values to the totals for 1st half of month
     C                   ADD       KDNP03        @1NP03
     C                   ADD       KDNP06        @1NP06
     C                   ADD       KDNP09        @1NP09
     C                   ADD       KDNP12        @1NP12
     C                   ADD       KDNPRR        @1NPRR
      *
      ** Add 1 to count1
     C                   ADD       1             COUNT1
      *
     C                   END
     C                   END
      *
      ** Change the value date period saved in key field to 2nd period
     C                   MOVE      '2'           @KVLDT
      *
      ** Setup file to first record of 2nd periods
     C                   EXSR      #KA
      *
      ** Initialise totals for 2nd half of month
     C                   Z-ADD     0             @2NP03           15 0
     C                   Z-ADD     0             @2NP06           15 0
     C                   Z-ADD     0             @2NP09           15 0
     C                   Z-ADD     0             @2NP12           15 0
     C                   Z-ADD     0             @2NPRR           15 0
      *
      ** Set count2 to zero
     C                   Z-ADD     0             COUNT2            4 0
      *
      ** Set *IN71 to zero
     C                   MOVE      '0'           *IN71
      *
      ** Do while record with the same ccy/branch/value date period found
     C     *IN71         DOUEQ     '1'
      *
      ** READE on file DLMSY3L (to get 2nd half of month)
     C                   EXSR      #KG
      *
      ** If record found
     C     *IN71         IFNE      '1'
      *
      ** Add file field values to the totals for 2nd half of month
     C                   ADD       KDNP03        @2NP03
     C                   ADD       KDNP06        @2NP06
     C                   ADD       KDNP09        @2NP09
     C                   ADD       KDNP12        @2NP12
     C                   ADD       KDNPRR        @2NPRR
      *
      ** Add 1 to count2
     C                   ADD       1             COUNT2
      *
      ** Store the record as the last one in case there are no more
     C                   MOVE      DLRCRD        @BOTRD
      *
     C                   END
     C                   END
      *
      ** Set *IN71 to zero
     C                   MOVE      '0'           *IN71
      *
      ** If counts are not equal, this means that the number of records
      *     for the first period do not match the number of records for
      *     the second period. Therefore process database error.
     C     COUNT1        IFNE      COUNT2
      *                                                    ***************
     C                   MOVEL     'DLMSY3L'     DBFILE                         *             *
     C                   MOVEL     DLRCRD        DBKEY                          * DBERROR 039 *
     C                   MOVE      '039'         DBASE                          *             *
      *                                                    ***************
     C                   EXSR      *PSSR
      *
     C                   END
      *
      ** Move total fields for 1st half of month back to original
      **      file fields because they are used by subroutine #BD
     C                   Z-ADD     @1NP03        KDNP03
     C                   Z-ADD     @1NP06        KDNP06
     C                   Z-ADD     @1NP09        KDNP09
     C                   Z-ADD     @1NP12        KDNP12
     C                   Z-ADD     @1NPRR        KDNPRR
      *
      ** Edit first subfile line
     C                   EXSR      #BD
      *
      ** Move total fields for 2nd half of month back to original
      **      file fields because they are used by subroutine #BE
     C                   Z-ADD     @2NP03        KDNP03
     C                   Z-ADD     @2NP06        KDNP06
     C                   Z-ADD     @2NP09        KDNP09
     C                   Z-ADD     @2NP12        KDNP12
     C                   Z-ADD     @2NPRR        KDNPRR
      *
      ** Edit second subfile line
     C                   EXSR      #BE
      *
     C                   END
      *
      ** If book and branch are 'ALL'
     C     @@FILE        IFEQ      '4'
      *
      ** Do while record with the same ccy/value date period found
     C     *IN71         DOUEQ     '1'
      *
      ** READE on file DLMSY4L (to get 1st half of month)
     C                   EXSR      #KG
      *
      ** If record found
     C     *IN71         IFNE      '1'
      *
      ** Add file field values to the totals for 1st half of month
     C                   ADD       KENP03        @1NP03
     C                   ADD       KENP06        @1NP06
     C                   ADD       KENP09        @1NP09
     C                   ADD       KENP12        @1NP12
     C                   ADD       KENPRR        @1NPRR
      *
      ** Add 1 to count1
     C                   ADD       1             COUNT1
      *
     C                   END
     C                   END
      *
      ** Change the value date period saved in key field to 2nd period
     C                   MOVE      '2'           @KVLDT
      *
      ** Setup file to first record of 2nd periods
     C                   EXSR      #KA
      *
      ** Initialise totals for 2nd half of month
     C                   Z-ADD     0             @2NP03
     C                   Z-ADD     0             @2NP06
     C                   Z-ADD     0             @2NP09
     C                   Z-ADD     0             @2NP12
     C                   Z-ADD     0             @2NPRR
      *
      ** Set count2 to zero
     C                   Z-ADD     0             COUNT2
      *
      ** Set *IN71 to zero
     C                   MOVE      '0'           *IN71
      *
      ** Do while record with the same ccy/value date period found
     C     *IN71         DOUEQ     '1'
      *
      ** READE on file DLMSY4L (to get 2nd half of month)
     C                   EXSR      #KG
      *
      ** If record found
     C     *IN71         IFNE      '1'
      *
      ** Add file field values to the totals for 2nd half of month
     C                   ADD       KENP03        @2NP03
     C                   ADD       KENP06        @2NP06
     C                   ADD       KENP09        @2NP09
     C                   ADD       KENP12        @2NP12
     C                   ADD       KENPRR        @2NPRR
      *
      ** Add 1 to count2
     C                   ADD       1             COUNT2
      *
      ** Store the record as the last one in case there are no more
     C                   MOVE      DLRCRD        @BOTRD
      *
     C                   END
     C                   END
      *
      ** Set *IN71 to zero
     C                   MOVE      '0'           *IN71
      *
      ** If counts are not equal, this means that the number of records
      *     for the first period do not match the number of records for
      *     the second period. Therefor process database error.
     C     COUNT1        IFNE      COUNT2
      *                                                    ***************
     C                   MOVEL     'DLMSY4L'     DBFILE                         *             *
     C                   MOVEL     DLRCRD        DBKEY                          * DBERROR 040 *
     C                   MOVE      '040'         DBASE                          *
      *                                                    ***************
     C                   EXSR      *PSSR
      *
     C                   END
      *
      ** Move total fields for 1st half of month back to original
      **      file fields because they are used by subroutine #BD
     C                   MOVE      @1NP03        KENP03
     C                   MOVE      @1NP06        KENP06
     C                   MOVE      @1NP09        KENP09
     C                   MOVE      @1NP12        KENP12
     C                   MOVE      @1NPRR        KENPRR
      *
      ** Edit first subfile line
     C                   EXSR      #BD
      *
      ** Move total fields for 2nd half of month back to original
      **      file fields because they are used by subroutine #BE
     C                   MOVE      @2NP03        KENP03
     C                   MOVE      @2NP06        KENP06
     C                   MOVE      @2NP09        KENP09
     C                   MOVE      @2NP12        KENP12
     C                   MOVE      @2NPRR        KENPRR
      *
      ** Edit second subfile line
     C                   EXSR      #BE
      *
     C                   END
     C                   ELSE
      *
      ** Else book is not 'ALL'
     C*
     C** EDIT THE FIELDS FOR THE FIRST LINE OF THE SUBFILE
     C*
     C                   EXSR      #BD                                          ***3
     C*
     C** READE Summary File for 2nd line of subfile format
     C*
     C                   EXSR      #KC                                          **2
     C*
     C** If error occurs, output Database Error, since rec should exist
     C*
     C     *IN71         IFEQ      '1'                                          B**3
     C*
     C     @@FILE        IFEQ      '1'                                          B***4
     C*                                                    ***************
     C                   MOVEL     'DLMSY1L'     DBFILE                         *             *
     C                   MOVEL     DLRCRD        DBKEY                          * DBERROR 015 *
     C                   MOVE      '015'         DBASE                          *             *
     C*                                                    ***************
     C                   ELSE                                                   X***4
     C*                                                    ***************
     C                   MOVEL     'DLMSY2L'     DBFILE                         *             *
     C                   MOVEL     DLRCRD        DBKEY                          * DBERROR 016 *
     C                   MOVE      '016'         DBASE                          *             *
     C*                                                    ***************
     C                   END                                                    E***4
     C*
     C                   EXSR      *PSSR                                        ***3
     C*
     C                   END                                                    E**3
     C*
     C*
     C**  OR, record found, but month half is not second half
     C*
     C     *IN71         IFNE      '1'                                          B**3
     C     @DAYCH        ANDNE     '2'                                          ***3
     C*
     C     @@FILE        IFEQ      '1'                                          B***4
     C*                                                    ***************
     C                   MOVEL     'DLMSY1L'     DBFILE                         *             *
     C                   MOVEL     DLRCRD        DBKEY                          * DBERROR 017 *
     C                   MOVE      '017'         DBASE                          *             *
     C*                                                    ***************
     C                   ELSE                                                   X***4
     C*                                                    ***************
     C                   MOVEL     'DLMSY2L'     DBFILE                         *             *
     C                   MOVEL     DLRCRD        DBKEY                          * DBERROR 018 *
     C                   MOVE      '018'         DBASE                          *             *
     C*                                                    ***************
     C                   END                                                    E***4
     C*
     C                   EXSR      *PSSR                                        ***3
     C*
     C                   END                                                    E**3
     C*
     C** STORE THE RECORD AS THE LAST ONE IN CASE THERE ARE NO MORE
     C*
     C                   MOVE      DLRCRD        @BOTRD                         **2
     C*
     C**  If READE successful, edit the fields prior to displaying them
     C*
     C                   EXSR      #BE                                          **2
     C*
     C                   END
      *
     C**  Now move the edited amounts (which are 11 char signed format)
     C**  into numeric format, add them together and produce the totals
     C**  which are displayed on line 3 of the subfile display
     C*
     C                   EXSR      #BF                                          **2
     C*
     C** Write MONTHLY SUMMARY lines to subfile display
     C*
     C                   WRITE     DL1909S1                                     **2
     C                   ADD       1             RRN                            **2
     C*
     C                   END                                                    E**3
     C                   END                                                    E*2
     C*
     C                   END                                                    E1
     C*
     C     #BC9          ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #BCA     - VALIDATE PROMPT DATA                               *
     C*                                                               *
     C* CALLS    - ZVLDT  - EDIT VALUE DATE                           *
     C*            ZA0240 - ADD A MESSAGE TO THE PROGRAM MESSAGE QUEUE*
     C*                                                               *
     C* CALLED BY  #BC - ENTER NEW PROMPT DATA                        *
     C*                                                               *
     C* FLDS USED  @SCRCY  -  CURRENCY SELECTED IN PROMPTS            *
     C*            @SBOOK  -  BOOK CODE SELECTED IN PROMPTS           *
     C*            @SBRCA  -  BRANCH SELECTED IN PROMPTS              *
     C*            @SMMYY  -  START DATE PROMPT IN MONTH/YEAR FORMAT  *
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
     C                   MOVE      '1'           *IN60                          *1
     C                   MOVE      '1'           *IN69                          *1
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
      *
      **  If @SCRCY is equal to the Ccy code for Consolidated Euro
      **  position, no error must be generated.
      *
     C     CEU012        IFEQ      'Y'
     C     @SCRCY        ANDEQ     BKEUCP
     C                   MOVE      '0'           *IN31
     C                   MOVE      '0'           *IN32
     C                   MOVE      *BLANKS       WINCY
     C                   ELSE
     C*
     C** SET UP PARAMETER FOR ZA0240 AND CALL THE PROGRAM TO ADD
     C** ANOTHER MESSAGE TO THE PROGRAM MESSAGE QUEUE
     C*
     C                   MOVEL     'FIS0001'     @MSGID           10            **2
     C                   CALL      'ZA0240'                                     **2
     C                   PARM                    @MSGID                         **2
     C*
     C** SET ON ERROR-ON-VALIDATION INDICATOR
     C*
     C                   MOVE      '1'           *IN60                          **2
     C                   MOVE      '1'           *IN69                          **2
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
      **    and Spot Date converted from YYYYMMDD to Midas Day Number
     C                   MOVEL     A6INCY        WINCY
     C                   MOVE      A6NBDP        CDP
     C                   MOVE      A6DICB        DICM
                                                                                CAAA02
     C************       Z-ADD     A6MMSD        ZZDTIN                         CAAA02
      * Subroutine replaced by external module                                  CAAA02
     C************       EXSR      ZDAT10                                       CAAA02
     c                   callb     'ZDATE10'                                    CAAA02
     c                   parm                    A6MMSD                         CAAA02
     c                   parm                    SPOT                           CAAA02
     C************       Z-ADD     ZZMDNO        SPOT              5 0          CAAA02
                                                                                CAAA02
     C*
     C                   END                                                    E*2
     C*
     C                   END                                                    E1
      *
      ** Validate the FRA trading book code
      *
      ** If screen field is blank, set to default
     C     @SBOOK        IFEQ      *BLANKS
     C                   MOVE      @FBKCD        @SBOOK
     C                   END
      *
      ** If screen book code is not 'ALL'
     C     @SBOOK        IFNE      'ALL'
      *
      ** Move screen book code into work field so that each
      **      position can be examined
     C                   MOVE      *BLANKS       @WBOOK
     C                   MOVE      @SBOOK        @WBOOK
      *
      ** If first position is blank
     C     @WBKP1        IFEQ      *BLANK
      *
      ** Call Access Program for Book Details to check book code
      **      represented by second/third positions exists
     C                   CALL      'AOBOOKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      @WBKC2        @BOKC             2
     C     SDBOOK        PARM      SDBOOK        DSFDY
      *
      ** If book code not found process error
     C     @RTCD         IFNE      *BLANK
      *
      ** Set up parameter for ZA0240 and call the program to add
      ** another message to the program message queue
     C                   MOVEL     'FIS0009'     @MSGID
     C                   CALL      'ZA0240'
     C                   PARM                    @MSGID
      *
      ** Set on error-on-validation indicator and
      **        error-on-book-code indicator
     C                   MOVE      '1'           *IN69
     C                   MOVE      '1'           *IN64
     C*
     C                   END
     C                   ELSE
      *
      ** Else if first position not blank
      *
      ** If third position is blank
     C     @WBKP3        IFEQ      *BLANK
      *
      ** Call Access Program for Book Details to check book code
      **      represented by first/second positions exists
     C                   CALL      'AOBOOKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      @WBKC1        @BOKC             2
     C     SDBOOK        PARM      SDBOOK        DSFDY
      *
      ** If book code not found process error
     C     @RTCD         IFNE      *BLANK
      *
      ** Set up parameter for ZA0240 and call the program to add
      ** another message to the program message queue
     C                   MOVEL     'FIS0009'     @MSGID
     C                   CALL      'ZA0240'
     C                   PARM                    @MSGID
      *
      ** Set on error-on-validation indicator and
      **        error-on-book-code indicator
     C                   MOVE      '1'           *IN69
     C                   MOVE      '1'           *IN64
      *
     C                   ELSE
      *
      ** If book code found, set up screen book code and
      **    set up *in24 so screen fields are updated
     C                   MOVE      *BLANKS       @SBOOK
     C                   MOVE      BDBKCD        @SBOOK
     C                   MOVE      '1'           *IN24
      *
     C                   END
     C                   ELSE
      *
      ** Set up parameter for ZA0240 and call the program to add
      ** another message to the program message queue
     C                   MOVEL     'FIS0009'     @MSGID
     C                   CALL      'ZA0240'
     C                   PARM                    @MSGID
      *
      ** Set on error-on-validation indicator and
      **        error-on-book-code indicator
     C                   MOVE      '1'           *IN69
     C                   MOVE      '1'           *IN64
      *
     C                   END
     C                   END
     C                   END
      *
     C*
     C** VALIDATE MONTH/YEAR ENTRY
      *
      * If field is blank move the run date month/year back in
     C*
     C     @SMMYY        IFEQ      *BLANK                                       B1
     C*
     C**  Convert date from format MMMYY to MMYY.
     C*
     C                   MOVE      @FMMYY        @SMMYY
     C                   ELSE
     C*
     C**  If @SMMYY is not blank, check input date if it conforms
     C**  with the valid month numbers listed in array @MON and the
     C**  year in array @YR.
     C*
     C                   MOVEL     @SMMYY        TST3              3
     C                   Z-ADD     1             G                 2 0
     C     TST3          LOOKUP    @MT(G)                                 55
     C                   MOVE      G             @MN               2
     C                   MOVEL     @MN           @M1               1
     C     @M1           IFEQ      *BLANKS
     C                   MOVEL     '0'           @MN
     C                   END
     C                   MOVE      @SMMYY        @YN               2
     C                   MOVEL     @YN           @Y1               1
     C                   MOVE      @YN           @Y2               1
     C     @MN           LOOKUP    @MON                                   90
     C     *IN90         IFEQ      '1'
     C     @Y1           LOOKUP    @YR                                    90
     C                   END
     C     *IN90         IFEQ      '1'
     C     @Y2           LOOKUP    @YR                                    90
     C                   END
     C     *IN90         IFNE      '1'
     C                   MOVEL     'FIS0018'     @MSGID           10
     C                   CALL      'ZA0240'
     C                   PARM                    @MSGID
     C                   MOVE      '1'           *IN62
     C                   MOVE      '1'           *IN69
     C                   END
      *
     C                   END
     C*
     C**  If validation error occurs, bypass date conversion.
     C*
     C     *IN90         IFEQ      '1'
     C*
     C** Validate MONTH/YEAR entry by moving in a 'dummy' day, giving
     C** 01MMMYY.  Pass this date format to subroutine ZVLDT.
     C*
     C                   MOVE      'D'           @@DFMT                         *1
     C*
     C**  Convert date from format MMYY to MMMYY
     C*
     C                   MOVEL     @SMMYY        @TMMM             3
      *
      **  Look up month shortnames array - store month number to @TMM
      *
     C                   Z-ADD     1             @TMM              2 0
     C     @TMMM         LOOKUP    @MT(@TMM)                              90
      *
      **  Set up field for MMYY
      *
     C                   MOVE      @SMMYY        @TYY              2 0
     C                   MOVE      @TYY          @TMMYY            4 0
     C                   MOVEL     @TMM          @TMMYY
     C                   MOVE      @TMMYY        ZDATE             6 0
      *
      **  Move a 'dummy' day giving 01MMYY
      *
     C                   MOVEL     '01'          ZDATE
      *
     C                   MOVEL     '01'          ZADAT
     C                   MOVE      @SMMYY        ZADAT
      *
     C                   MOVEL     @SMMYY        WMON
     C     WMON          LOOKUP    @MT                                    11
     C     *IN11         IFEQ      '1'
     C                   MOVE      '0'           *IN18
     C                   ELSE
     C                   MOVE      '1'           *IN18
     C                   ENDIF
      *
     C                   EXSR      CVDT
     C                   MOVE      ZADAT         @@VLDT
      *
     C                   EXSR      ZVLDT                                        *1
     C*
     C     @@RTN         IFEQ      '1'                                          B*2
     C*
     C** SET UP PARAMETER FOR ZA0240 AND CALL THE PROGRAM TO ADD
     C** ANOTHER MESSAGE TO THE PROGRAM MESSAGE QUEUE
     C*
     C                   MOVEL     'FIS0018'     @MSGID           10            **2
     C                   CALL      'ZA0240'                                     **2
     C                   PARM                    @MSGID                         **2
     C*
     C** SET ON ERROR-ON-VALUE-DATE AND ERROR-ON-VALIDATION INDICATORS
     C*
     C                   MOVE      '1'           *IN62                          **2
     C                   MOVE      '1'           *IN69                          **2
     C*
     C                   ELSE                                                   X*2
     C*
     C*
     C** VALUE DATE MUST NOT BE BEFORE RUN DATE
     C*
     C     @@DAYN        IFLT      @@RDAY                                       B**3
     C                   CALL      'ZA0240'                                     ***3
     C                   PARM      'FIS0019'     @MSGID                         ***3
     C                   MOVE      '1'           *IN62                          ***3
     C                   MOVE      '1'           *IN69                          ***3
     C*
     C                   END                                                    E**3
     C                   END                                                    E*2
     C                   END
     C*
     C** Create file pointer by converting start date @@DATE from subr
     C** ZVLDT to format YYMM1 in order to find 1st rec EQ to or GT
     C** this value in relevant file. The field set up thus is
     C** @KVLDT, defined in the @KRCRD data structure.
     C*
     C                   MOVEL     @@YY          @@YMF             4 0
     C                   MOVE      @@MM          @@YMF
     C                   Z-ADD     @@YMF         @KYMNO
     C                   Z-ADD     1             @KDDNO
     C*
     C* To differentiate between records before and after the year
     C* 2000. If @KCENT equals 2 then records belong to the year 2000
     C* or after.
     C*
     C                   MOVE      @@YY          @YY1
     C     @YY1          IFLT      72
     C                   MOVE      '2'           @KCENT
     C                   ELSE
     C                   MOVE      '1'           @KCENT
     C                   ENDIF
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
      ** If screen branch code is not 'ALL'
     C     @SBRCA        IFNE      'ALL'
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
      **      set up *in24 to update screen fields
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
     C                   MOVE      '1'           *IN69
     C                   MOVE      '1'           *IN61
     C                   END
      *
     C                   END
     C                   ELSE
      *
      ** Else screen branch code is 'ALL'
      ** If user not authourised to bank level, process error
     C     @BKLVL        IFNE      'Y'
      *
      ** Set up parameter for ZA0240 and call the program to add
      **     another message to the program message queue
     C                   MOVEL     'FIS0027'     @MSGID
     C                   CALL      'ZA0240'
     C                   PARM                    @MSGID
      *
      ** Set on error-on-validation indicator
     C                   MOVE      '1'           *IN69
     C                   END
      *
     C                   END
     C                   END
      *
     C     #BCA9         ENDSR
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
     C*            @TCRCY - CURRENCY   }  VALUES FOR NEW SCREEN       *
     C*            @TBRCH - BRANCH     }  HEADINGS                    *
     C*            @TBOOK - BOOK CODE  }                              *
     C*                                                               *
     C*            @SCRCY - CURRENCY   )                              *
     C*            @SDBCH - BRANCH     )  VALID ENTRIES RECEIVED      *
     C*            @SBOOK - BOOK CODE  )  FROM PROMPTS                *
     C*                                                               *
     C*            @@ERMS - ERROR-MESSAGE-TO-DISPLAY INDICATOR - Y/N  *
     C*            @MSGID - ERROR MESSAGE NUMBER TO SEND TO ZA0240    *
     C*                                                               *
     C*****************************************************************
     C*
     C     #BCB          BEGSR
     C*
     C** SET UP HEADING FOR CURRENCY
     C** - THE SAME AS THE VALID PROMPT ENTRY
     C*
     C                   MOVE      @SCRCY        @TCRCY
     C*
     C** Also store the Currency;no of dec places for use in ZAMTE; and
     C** default interest calculation method to send down in stack
     C** (none of these shown on the screen)
     C*
     C                   MOVE      @SCRCY        @@CCY
      *
     C     @SCRCY        IFEQ      BKEUCP
     C                   Z-ADD     WENBDP        @@CDP
     C                   ELSE
     C                   Z-ADD     CDP           @@CDP
     C                   ENDIF
      *
     C                   Z-ADD     DICM          @@DICM            1 0
     C                   Z-ADD     SPOT          WSPOT             5 0
     C*
     C** SET UP HEADING FOR BRANCH
     C***-*'ALL'*IF*BLANK*ENTERED ELSE SAME AS THE VALID PROMPT ENTRY
     C** - SAME AS THE VALID PROMPT ENTRY
     C*
     C                   MOVE      @SBRCA        @TBRCH
     C*
     C** SET UP HEADING FOR BOOK CODE
     C** - SAME AS THE VALID PROMPT ENTRY
     C*
     C     @SBOOK        IFEQ      'ALL'
     C                   MOVE      @SBOOK        @TBOOK
     C                   ELSE
     C                   MOVE      *BLANKS       @TBOOK
     C                   MOVE      @SBOOK        @@BOOK            2
     C                   MOVEL     @@BOOK        @TBOOK
     C                   END
     C*
     C     #BCB9         ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #BD      - EDIT ENQUIRY SUBFILE DATA (1ST LINE)               *
     C*                                                               *
     C* CALLS      ZAMTE   -  EDIT AMOUNT                             *
     C*            *PSSR   -  DATABASE ERROR HANDLING                 *
     C*                                                               *
     C* CALLED BY  #BA     -  ROLLUP ENQUIRY SUBFILE                  *
     C*            #BB     -  ROLLDOWN ENQUIRY SUBFILE                *
     C*            #BC     -  ENTER NEW PROMPT DATA                   *
     C*                                                               *
     C* FLDS USED  DD3M    -  3 MONTH AMOUNT)                         *
     C*            DD6M    -  6 MONTH AMOUNT)                         *
     C*            DD9M    -  9 MONTH AMOUNT)  AMOUNT DISPLAY FIELDS  *
     C*            DD12M   -  12 MTH AMOUNT )  FOR THE ENQUIRY SUBFILE*
     C*            DDREM   -  REMAINDER AMT )                         *
     C*                                                               *
     C*            DDMY1   -  VALUE PERIOD  )  ENQUIRY SFILE DISPLAY  *
     C*                                                               *
     C*            KDCCY   -  CURRENCY        }                       *
     C*            KDBRSN  -  BRANCH NO       }                       *
     C*            KDVDTP  -  VALUE DATE      }  ONE-BRANCH SUMMARY   *
     C*            KDNP03  -  TO 3 MONTHS POS }  FILE FIELDS          *
     C*            KDNP06  -  TO 6 MONTHS POS }                       *
     C*            KDNP09  -  TO 9 MONTHS POS }                       *
     C*            KDNP12  -  TO 12 MONTHS POS}                       *
     C*            KDNPRR  -  TO END OF BOOK  }                       *
     C*                                                               *
     C*            KECCY   -  CURRENCY        }                       *
     C*            KEVDTP  -  VALUE DATE      }  ALL-BRANCH SUMMARY   *
     C*            KENP03  -  TO 3 MONTHS POS }  FILE FIELDS          *
     C*            KENP06  -  TO 6 MONTHS POS }                       *
     C*            KENP09  -  TO 9 MONTHS POS }                       *
     C*            KENP12  -  TO 12 MONTHS POS}                       *
     C*            KENPRR  -  TO END OF BOOK  }                       *
     C*                                                               *
     C*****************************************************************
     C*
     C     #BD           BEGSR
     C*
     C** EDIT THE DISPLAY FIELDS FOR SUBFILE BEFORE WRITING TO IT.
     C** ANY FIELDS THAT DO NOT NEED EDITING CAN JUST BE MOVED
     C** DIRECTLY INTO THEIR EQUIVALENT FIELD IN THE DISPLAY FILE
     C*
     C** Use subr ZAMTE to convert summary-file amounts into amounts
     C*  shown as 000's for display files
     C*
     C** Decide which fields are to be edited - either the All-Branch
     C** file is used or the One-Branch file
     C*
     C     @@FILE        IFEQ      '1'                                          B1
     C     @@FILE        OREQ      '3'
     C*
     C                   Z-ADD     KDNP03        @@IAMT                         *1
      *
     C                   MOVEL     '102'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE                                        *1
     C                   MOVEL     @@AMNT        @@SIGN           13            *1
     C*
     C** For each field, decide on plus or minus sign for display
     C*
     C     KDNP03        IFLT      0                                            B*2
     C                   MOVE      '-'           @@SIGN                         **2
     C                   ELSE                                                   X*2
     C     KDNP03        IFEQ      0                                            B**3
     C                   MOVE      ' '           @@SIGN                         ***3
     C                   ELSE                                                   X**3
     C                   MOVE      '+'           @@SIGN                         ***3
     C                   END                                                    E**3
     C                   END                                                    E*2
     C*
     C** Now move resulting 13 char signed field into 11 char signed
     C*  field, ready for display
     C*
     C                   MOVE      @@SIGN        DD3M                           *1
     C*
     C** Store the file field to be used in calculations later
     C*
     C                   Z-ADD     KDNP03        @@3DEC           15 0          *1
     C*
     C*
     C** Continue this processing for each field
     C*
     C                   Z-ADD     KDNP06        @@IAMT                         *1
      *
     C                   MOVEL     '113'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE                                        *1
     C                   MOVEL     @@AMNT        @@SIGN                         *1
     C*
     C     KDNP06        IFLT      0                                            B*2
     C                   MOVE      '-'           @@SIGN                         **2
     C                   ELSE                                                   X*2
     C     KDNP06        IFEQ      0                                            B**3
     C                   MOVE      ' '           @@SIGN                         ***3
     C                   ELSE                                                   X**3
     C                   MOVE      '+'           @@SIGN                         ***3
     C                   END                                                    E**3
     C                   END                                                    E*2
     C*
     C                   MOVE      @@SIGN        DD6M                           *1
     C*
     C                   Z-ADD     KDNP06        @@6DEC           15 0          *1
     C*
     C*
     C                   Z-ADD     KDNP09        @@IAMT                         *1
      *
     C                   MOVEL     '114'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE                                        *1
     C                   MOVEL     @@AMNT        @@SIGN                         *1
     C*
     C     KDNP09        IFLT      0                                            B*2
     C                   MOVE      '-'           @@SIGN                         **2
     C                   ELSE                                                   X*2
     C     KDNP09        IFEQ      0                                            B**3
     C                   MOVE      ' '           @@SIGN                         ***3
     C                   ELSE                                                   X**3
     C                   MOVE      '+'           @@SIGN                         ***3
     C                   END                                                    E**3
     C                   END                                                    E*2
     C*
     C                   MOVE      @@SIGN        DD9M                           *1
     C*
     C                   Z-ADD     KDNP09        @@9DEC           15 0          *1
     C*
     C*
     C                   Z-ADD     KDNP12        @@IAMT                         *1
      *
     C                   MOVEL     '115'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE                                        *1
     C                   MOVEL     @@AMNT        @@SIGN                         *1
     C*
     C     KDNP12        IFLT      0                                            B*2
     C                   MOVE      '-'           @@SIGN                         **2
     C                   ELSE                                                   X*2
     C     KDNP12        IFEQ      0                                            B**3
     C                   MOVE      ' '           @@SIGN                         ***3
     C                   ELSE                                                   X**3
     C                   MOVE      '+'           @@SIGN                         ***3
     C                   END                                                    E**3
     C                   END                                                    E*2
     C*
     C                   MOVE      @@SIGN        DD12M                          *1
     C*
     C                   Z-ADD     KDNP12        @@12DC           15 0          *1
     C*
     C*
     C                   Z-ADD     KDNPRR        @@IAMT                         *1
      *
     C                   MOVEL     '116'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE                                        *1
     C                   MOVEL     @@AMNT        @@SIGN                         *1
     C*
     C     KDNPRR        IFLT      0                                            B*2
     C                   MOVE      '-'           @@SIGN                         **2
     C                   ELSE                                                   X*2
     C     KDNPRR        IFEQ      0                                            B**3
     C                   MOVE      ' '           @@SIGN                         ***3
     C                   ELSE                                                   X**3
     C                   MOVE      '+'           @@SIGN                         ***3
     C                   END                                                    E**3
     C                   END                                                    E*2
     C*
     C                   MOVE      @@SIGN        DDREM                          *1
     C*
     C                   Z-ADD     KDNPRR        @@REMD           15 0          *1
     C*
     C*
     C** Set up date field for display
     C*
     C                   MOVEL     @DCON1        DDMY1             7
     C*
     C*
     C                   ELSE                                                   X1
     C*
     C** If relevant file is All-Branch file, use those fields
     C*
     C                   Z-ADD     KENP03        @@IAMT                         *1
      *
     C                   MOVEL     '117'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE                                        *1
     C                   MOVEL     @@AMNT        @@SIGN                         *1
     C*
     C     KENP03        IFLT      0                                            B*2
     C                   MOVE      '-'           @@SIGN                         **2
     C                   ELSE                                                   X*2
     C     KENP03        IFEQ      0                                            B**3
     C                   MOVE      ' '           @@SIGN                         ***3
     C                   ELSE                                                   X**3
     C                   MOVE      '+'           @@SIGN                         ***3
     C                   END                                                    E**3
     C                   END                                                    E*2
     C*
     C                   MOVE      @@SIGN        DD3M                           *1
     C*
     C                   Z-ADD     KENP03        @@3DEC                         *1
     C*
     C*
     C                   Z-ADD     KENP06        @@IAMT                         *1
      *
     C                   MOVEL     '118'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE                                        *1
     C                   MOVEL     @@AMNT        @@SIGN                         *1
     C*
     C     KENP06        IFLT      0                                            B*2
     C                   MOVE      '-'           @@SIGN                         **2
     C                   ELSE                                                   X*2
     C     KENP06        IFEQ      0                                            B**3
     C                   MOVE      ' '           @@SIGN                         ***3
     C                   ELSE                                                   X**3
     C                   MOVE      '+'           @@SIGN                         ***3
     C                   END                                                    E**3
     C                   END                                                    E*2
     C*
     C                   MOVE      @@SIGN        DD6M                           *1
     C*
     C                   Z-ADD     KENP06        @@6DEC                         *1
     C*
     C*
     C                   Z-ADD     KENP09        @@IAMT                         *1
      *
     C                   MOVEL     '119'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE                                        *1
     C                   MOVEL     @@AMNT        @@SIGN                         *1
     C*
     C     KENP09        IFLT      0                                            B*2
     C                   MOVE      '-'           @@SIGN                         **2
     C                   ELSE                                                   X*2
     C     KENP09        IFEQ      0                                            B**3
     C                   MOVE      ' '           @@SIGN                         ***3
     C                   ELSE                                                   X**3
     C                   MOVE      '+'           @@SIGN                         ***3
     C                   END                                                    E**3
     C                   END                                                    E*2
     C*
     C                   MOVE      @@SIGN        DD9M                           *1
     C*
     C                   Z-ADD     KENP09        @@9DEC                         *1
     C*
     C*
     C                   Z-ADD     KENP12        @@IAMT                         *1
      *
     C                   MOVEL     '120'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE                                        *1
     C                   MOVEL     @@AMNT        @@SIGN                         *1
     C*
     C     KENP12        IFLT      0                                            B*2
     C                   MOVE      '-'           @@SIGN                         **2
     C                   ELSE                                                   X*2
     C     KENP12        IFEQ      0                                            B**3
     C                   MOVE      ' '           @@SIGN                         ***3
     C                   ELSE                                                   X**3
     C                   MOVE      '+'           @@SIGN                         ***3
     C                   END                                                    E**3
     C                   END                                                    E*2
     C*
     C                   MOVE      @@SIGN        DD12M                          *1
     C*
     C                   Z-ADD     KENP12        @@12DC                         *1
     C*
     C*
     C                   Z-ADD     KENPRR        @@IAMT                         *1
      *
     C                   MOVEL     '121'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE                                        *1
     C                   MOVEL     @@AMNT        @@SIGN                         *1
     C*
     C     KENPRR        IFLT      0                                            B*2
     C                   MOVE      '-'           @@SIGN                         **2
     C                   ELSE                                                   X*2
     C     KENPRR        IFEQ      0                                            B**3
     C                   MOVE      ' '           @@SIGN                         ***3
     C                   ELSE                                                   X**3
     C                   MOVE      '+'           @@SIGN                         ***3
     C                   END                                                    E**3
     C                   END                                                    E*2
     C*
     C                   MOVE      @@SIGN        DDREM                          *1
     C*
     C                   Z-ADD     KENPRR        @@REMD                         *1
     C*
     C*
     C** Set up date field for display
     C*
     C                   MOVEL     @DCON2        DDMY1                          *1
     C*
     C                   END                                                    E1
     C*
     C                   MOVE      '-1'          DDMY1
     C*
     C*
     C     #BD9          ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #BE      - EDIT ENQUIRY SUBFILE DATA (2ND LINE)               *
     C*                                                               *
     C* CALLS      ZAMTE   -  EDIT AMOUNT                             *
     C*            *PSSR   -  DATABASE ERROR HANDLING                 *
     C*                                                               *
     C* CALLED BY  #BA     -  ROLLUP ENQUIRY SUBFILE                  *
     C*            #BB     -  ROLLDOWN ENQUIRY SUBFILE                *
     C*            #BC     -  ENTER NEW PROMPT DATA                   *
     C*                                                               *
     C* FLDS USED  DD3M2   -  3 MONTH AMOUNT)                         *
     C*            DD6M2   -  6 MONTH AMOUNT)                         *
     C*            DD9M2   -  9 MONTH AMOUNT)  AMOUNT DISPLAY FIELDS  *
     C*            DD12M2  -  12 MTH AMOUNT )  FOR THE ENQUIRY SUBFILE*
     C*            DDREM2  -  REMAINDER AMT )                         *
     C*                                                               *
     C*            DDMY2   -  VALUE PERIOD  )  ENQUIRY SFILE DISPLAY  *
     C*                                                               *
     C*            KDVDTP  -  VALUE DATE      }  ONE-BRANCH SUMMARY   *
     C*            KDNP03  -  TO 3 MONTHS POS }  FILE FIELDS          *
     C*            KDNP06  -  TO 6 MONTHS POS }                       *
     C*            KDNP09  -  TO 9 MONTHS POS }                       *
     C*            KDNP12  -  TO 12 MONTHS POS}                       *
     C*            KDNPRR  -  TO END OF BOOK  }                       *
     C*                                                               *
     C*            KEVDTP  -  VALUE DATE      }  ALL-BRANCH SUMMARY   *
     C*            KENP03  -  TO 3 MONTHS POS }  FILE FIELDS          *
     C*            KENP06  -  TO 6 MONTHS POS }                       *
     C*            KENP09  -  TO 9 MONTHS POS }                       *
     C*            KENP12  -  TO 12 MONTHS POS}                       *
     C*            KENPRR  -  TO END OF BOOK  }                       *
     C*                                                               *
     C*****************************************************************
     C*
     C     #BE           BEGSR
     C*
     C** EDIT THE DISPLAY FIELDS FOR SUBFILE BEFORE WRITING TO IT.
     C** ANY FIELDS THAT DO NOT NEED EDITING CAN JUST BE MOVED
     C** DIRECTLY INTO THEIR EQUIVALENT FIELD IN THE DISPLAY FILE
     C*
     C** Use subr ZAMTE to convert summary-file amounts into amounts
     C*  shown as 000's for display files
     C*
     C** Decide which fields are to be edited - either the All-Branch
     C** file is used or the One-Branch file
     C*
     C     @@FILE        IFEQ      '1'                                          B1
     C     @@FILE        OREQ      '3'
     C*
     C                   Z-ADD     KDNP03        @@IAMT                         *1
      *
     C                   MOVEL     '122'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE                                        *1
     C                   MOVEL     @@AMNT        @@SIGN           13            *1
     C*
     C** For each field, decide on plus or minus sign for display
     C*
     C     KDNP03        IFLT      0                                            B*2
     C                   MOVE      '-'           @@SIGN                         **2
     C                   ELSE                                                   X*2
     C     KDNP03        IFEQ      0                                            B**3
     C                   MOVE      ' '           @@SIGN                         ***3
     C                   ELSE                                                   X**3
     C                   MOVE      '+'           @@SIGN                         ***3
     C                   END                                                    E**3
     C                   END                                                    E*2
     C*
     C** Now move resulting 13 char signed field into 11 char signed
     C*  field, ready for display
     C*
     C                   MOVE      @@SIGN        DD3M2                          *1
     C*
     C** Store the file field to be used in calculations later
     C*
     C                   Z-ADD     KDNP03        @@3D2            15 0          *1
     C*
     C** Continue this processing for each field
     C*
     C                   Z-ADD     KDNP06        @@IAMT                         *1
      *
     C                   MOVEL     '123'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE                                        *1
     C                   MOVEL     @@AMNT        @@SIGN                         *1
     C*
     C     KDNP06        IFLT      0                                            B*2
     C                   MOVE      '-'           @@SIGN                         **2
     C                   ELSE                                                   X*2
     C     KDNP06        IFEQ      0                                            B**3
     C                   MOVE      ' '           @@SIGN                         ***3
     C                   ELSE                                                   X**3
     C                   MOVE      '+'           @@SIGN                         ***3
     C                   END                                                    E**3
     C                   END                                                    E*2
     C*
     C                   MOVE      @@SIGN        DD6M2                          *1
     C*
     C                   Z-ADD     KDNP06        @@6D2            15 0          *1
     C*
     C*
     C                   Z-ADD     KDNP09        @@IAMT                         *1
      *
     C                   MOVEL     '124'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE                                        *1
     C                   MOVEL     @@AMNT        @@SIGN                         *1
     C*
     C     KDNP09        IFLT      0                                            B*2
     C                   MOVE      '-'           @@SIGN                         **2
     C                   ELSE                                                   X*2
     C     KDNP09        IFEQ      0                                            B**3
     C                   MOVE      ' '           @@SIGN                         ***3
     C                   ELSE                                                   X**3
     C                   MOVE      '+'           @@SIGN                         ***3
     C                   END                                                    E**3
     C                   END                                                    E*2
     C*
     C                   MOVE      @@SIGN        DD9M2                          *1
     C*
     C                   Z-ADD     KDNP09        @@9D2            15 0          *1
     C*
     C*
     C                   Z-ADD     KDNP12        @@IAMT                         *1
      *
     C                   MOVEL     '125'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE                                        *1
     C                   MOVEL     @@AMNT        @@SIGN                         *1
     C*
     C     KDNP12        IFLT      0                                            B*2
     C                   MOVE      '-'           @@SIGN                         **2
     C                   ELSE                                                   X*2
     C     KDNP12        IFEQ      0                                            B**3
     C                   MOVE      ' '           @@SIGN                         ***3
     C                   ELSE                                                   X**3
     C                   MOVE      '+'           @@SIGN                         ***3
     C                   END                                                    E**3
     C                   END                                                    E*2
     C*
     C                   MOVE      @@SIGN        DD12M2                         *1
     C*
     C                   Z-ADD     KDNP12        @@12D2           15 0          *1
     C*
     C*
     C                   Z-ADD     KDNPRR        @@IAMT                         *1
      *
     C                   MOVEL     '126'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE                                        *1
     C                   MOVEL     @@AMNT        @@SIGN                         *1
     C*
     C     KDNPRR        IFLT      0                                            B*2
     C                   MOVE      '-'           @@SIGN                         **2
     C                   ELSE                                                   X*2
     C     KDNPRR        IFEQ      0                                            B**3
     C                   MOVE      ' '           @@SIGN                         ***3
     C                   ELSE                                                   X**3
     C                   MOVE      '+'           @@SIGN                         ***3
     C                   END                                                    E**3
     C                   END                                                    E*2
     C*
     C                   MOVE      @@SIGN        DDREM2                         *1
     C*
     C                   Z-ADD     KDNPRR        @@RMD2           15 0          *1
     C*
     C** Set up date field for display
     C*
     C                   MOVEL     @DCON1        DDMY2             7
     C*
     C                   Z-ADD     KDNPRR        @@RMD2                         *1
     C*
     C*
     C                   ELSE                                                   X1
     C*
     C** If relevant file is All-Branch file, use those fields
     C*
     C                   Z-ADD     KENP03        @@IAMT                         *1
      *
     C                   MOVEL     '127'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE                                        *1
     C                   MOVEL     @@AMNT        @@SIGN           13            *1
     C*
     C     KENP03        IFLT      0                                            B*2
     C                   MOVE      '-'           @@SIGN                         **2
     C                   ELSE                                                   X*2
     C     KENP03        IFEQ      0                                            B**3
     C                   MOVE      ' '           @@SIGN                         ***3
     C                   ELSE                                                   X**3
     C                   MOVE      '+'           @@SIGN                         ***3
     C                   END                                                    E**3
     C                   END                                                    E*2
     C*
     C                   MOVE      @@SIGN        DD3M2                          *1
     C*
     C                   Z-ADD     KENP03        @@3D2                          *1
     C*
     C*
     C                   Z-ADD     KENP06        @@IAMT                         *1
      *
     C                   MOVEL     '128'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE                                        *1
     C                   MOVEL     @@AMNT        @@SIGN                         *1
     C*
     C     KENP06        IFLT      0                                            B*2
     C                   MOVE      '-'           @@SIGN                         **2
     C                   ELSE                                                   X*2
     C     KENP06        IFEQ      0                                            B**3
     C                   MOVE      ' '           @@SIGN                         ***3
     C                   ELSE                                                   X**3
     C                   MOVE      '+'           @@SIGN                         ***3
     C                   END                                                    E**3
     C                   END                                                    E*2
     C*
     C                   MOVE      @@SIGN        DD6M2                          *1
     C*
     C                   Z-ADD     KENP06        @@6D2                          *1
     C*
     C*
     C                   Z-ADD     KENP09        @@IAMT                         *1
      *
     C                   MOVEL     '129'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE                                        *1
     C                   MOVEL     @@AMNT        @@SIGN                         *1
     C*
     C     KENP09        IFLT      0                                            B*2
     C                   MOVE      '-'           @@SIGN                         **2
     C                   ELSE                                                   X*2
     C     KENP09        IFEQ      0                                            B**3
     C                   MOVE      ' '           @@SIGN                         ***3
     C                   ELSE                                                   X**3
     C                   MOVE      '+'           @@SIGN                         ***3
     C                   END                                                    E**3
     C                   END                                                    E*2
     C*
     C                   MOVE      @@SIGN        DD9M2                          *1
     C*
     C                   Z-ADD     KENP09        @@9D2                          *1
     C*
     C*
     C                   Z-ADD     KENP12        @@IAMT                         *1
      *
     C                   MOVEL     '130'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE                                        *1
     C                   MOVEL     @@AMNT        @@SIGN                         *1
     C*
     C     KENP12        IFLT      0                                            B*2
     C                   MOVE      '-'           @@SIGN                         **2
     C                   ELSE                                                   X*2
     C     KENP12        IFEQ      0                                            B**3
     C                   MOVE      ' '           @@SIGN                         ***3
     C                   ELSE                                                   X**3
     C                   MOVE      '+'           @@SIGN                         ***3
     C                   END                                                    E**3
     C                   END                                                    E*2
     C*
     C                   MOVE      @@SIGN        DD12M2                         *1
     C*
     C                   Z-ADD     KENP12        @@12D2                         *1
     C*
     C*
     C                   Z-ADD     KENPRR        @@IAMT                         *1
      *
     C                   MOVEL     '131'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE                                        *1
     C                   MOVEL     @@AMNT        @@SIGN                         *1
     C*
     C     KENPRR        IFLT      0                                            B*2
     C                   MOVE      '-'           @@SIGN                         **2
     C                   ELSE                                                   X*2
     C     KENPRR        IFEQ      0                                            B**3
     C                   MOVE      ' '           @@SIGN                         ***3
     C                   ELSE                                                   X**3
     C                   MOVE      '+'           @@SIGN                         ***3
     C                   END                                                    E**3
     C                   END                                                    E*2
     C*
     C                   MOVE      @@SIGN        DDREM2                         *1
     C*
     C                   Z-ADD     KENPRR        @@RMD2                         *1
     C*
     C*
     C** Set up date field for display
     C*
     C                   MOVEL     @DCON2        DDMY2             7            *1
     C*
     C                   END                                                    E1
     C*
     C                   MOVE      '-2'          DDMY2
     C*
     C** Need another field for 2nd half of month to display on screen
     C*
     C                   MOVE      '-2'          SDMY2             2
     C*
     C     #BE9          ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #BF      - CALCULATE TOTALS AMOUNTS                           *
     C*            (These are the monthly totals)                     *
     C*                                                               *
     C* CALLED BY  #BA     -  ROLLUP ENQUIRY SUBFILE                  *
     C*            #BB     -  ROLLDOWN ENQUIRY SUBFILE                *
     C*            #BC     -  ENTER NEW PROMPT DATA                   *
     C*                                                               *
     C* FLDS USED  DD3TOT  -  3 MONTH TOTAL )                         *
     C*            DD6TOT  -  6 MONTH TOTAL )                         *
     C*            DD9TOT  -  9 MONTH TOTAL )  AMOUNT DISPLAY FIELDS  *
     C*            DD12T   -  12 MTH TOTAL  )  FOR THE ENQUIRY SUBFILE*
     C*            DDREMT  -  REMAINDER TOT )                         *
     C*                                                               *
     C*            DDMY3   -  VALUE PERIOD  )  ENQUIRY SFILE DISPLAY  *
     C*                                                               *
     C*            DD3M    -  TO 3 MONTHS POS }  FIRST-HALF MONTH     *
     C*            DD6M    -  TO 6 MONTHS POS }  SUMMARY AMOUNTS      *
     C*            DD9M    -  TO 9 MONTHS POS }                       *
     C*            DD12M   -  TO 12 MONTHS POS}                       *
     C*            DDREM   -  TO END OF BOOK  }                       *
     C*                                                               *
     C*            DD3M2   -  TO 3 MONTHS POS }  SECOND-HALF MONTH    *
     C*            DD6M2   -  TO 6 MONTHS POS }  SUMMARY AMOUNTS      *
     C*            DD9M2   -  TO 9 MONTHS POS }                       *
     C*            DD12M2  -  TO 12 MONTHS POS}                       *
     C*            DDREM2  -  TO END OF BOOK  }                       *
     C*                                                               *
     C*            @@3DEC/2                   }  NUMERIC WORK FIELDS  *
     C*            @@6DEC/2                   }  HOLDING SUMMARY      *
     C*            @@9DEC/2                   }  AMOUNTS              *
     C*              etc                                              *
     C*                                                               *
     C*****************************************************************
     C*
     C     #BF           BEGSR
     C*
     C** EDIT THE DISPLAY FIELDS FOR SUBFILE BEFORE WRITING TO IT.
     C** ANY FIELDS THAT DO NOT NEED EDITING CAN JUST BE MOVED
     C** DIRECTLY INTO THEIR EQUIVALENT FIELD IN THE DISPLAY FILE
     C*
     C** Add 1st-half month amounts and 2nd-half month amounts
     C*
     C     @@3DEC        ADD       @@3D2         @@3TOT           15 0
     C     @@6DEC        ADD       @@6D2         @@6TOT           15 0
     C     @@9DEC        ADD       @@9D2         @@9TOT           15 0
     C     @@12DC        ADD       @@12D2        @@12T            15 0
     C     @@REMD        ADD       @@RMD2        @@REMT           15 0
     C*
     C** Now edit resulting total amounts, and move edited amounts into
     C** alphameric fields ready for display on 3rd line of the subfile
     C*
     C* First edit the total prior to displaying it
     C*
     C                   Z-ADD     @@3TOT        @@IAMT
      *
     C                   MOVEL     '132'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE
     C*
     C** Move out amount to a 10 alpha field
     C*
     C                   MOVE      @@AMNT        @@WRK            10
     C*
     C     @@3TOT        IFLT      0                                            B1
     C                   MOVE      '-'           DD3TOT                         *1
     C                   ELSE                                                   X1
     C     @@3TOT        IFEQ      0                                            B*2
     C                   MOVE      ' '           DD3TOT                         **2
     C                   ELSE                                                   X*2
     C                   MOVE      '+'           DD3TOT                         **2
     C                   END                                                    E*2
     C                   END                                                    E1
     C                   MOVEL     @@WRK         DD3TOT           11
     C*
     C*
     C                   Z-ADD     @@6TOT        @@IAMT
      *
     C                   MOVEL     '133'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE
     C*
     C** Move out amount to a 10 alpha field
     C*
     C                   MOVE      @@AMNT        @@WRK
     C*
     C     @@6TOT        IFLT      0                                            B1
     C                   MOVE      '-'           DD6TOT                         *1
     C                   ELSE                                                   X1
     C     @@6TOT        IFEQ      0                                            B*2
     C                   MOVE      ' '           DD6TOT                         **2
     C                   ELSE                                                   X*2
     C                   MOVE      '+'           DD6TOT                         **2
     C                   END                                                    E*2
     C                   END                                                    E1
     C                   MOVEL     @@WRK         DD6TOT           11
     C*
     C*
     C                   Z-ADD     @@9TOT        @@IAMT
      *
     C                   MOVEL     '134'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE
     C*
     C** Move out amount to a 10 alpha field
     C*
     C                   MOVE      @@AMNT        @@WRK
     C*
     C     @@9TOT        IFLT      0                                            B1
     C                   MOVE      '-'           DD9TOT                         *1
     C                   ELSE                                                   X1
     C     @@9TOT        IFEQ      0                                            B*2
     C                   MOVE      ' '           DD9TOT                         **2
     C                   ELSE                                                   X*2
     C                   MOVE      '+'           DD9TOT                         **2
     C                   END                                                    E*2
     C                   END                                                    E1
     C                   MOVEL     @@WRK         DD9TOT           11
     C*
     C*
     C                   Z-ADD     @@12T         @@IAMT
      *
     C                   MOVEL     '135'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE
     C*
     C** Move out amount to a 10 alpha field
     C*
     C                   MOVE      @@AMNT        @@WRK
     C*
     C     @@12T         IFLT      0                                            B1
     C                   MOVE      '-'           DD12T                          *1
     C                   ELSE                                                   X1
     C     @@12T         IFEQ      0                                            B*2
     C                   MOVE      ' '           DD12T                          **2
     C                   ELSE                                                   X*2
     C                   MOVE      '+'           DD12T                          **2
     C                   END                                                    E*2
     C                   END                                                    E1
     C                   MOVEL     @@WRK         DD12T            11
     C*
     C*
     C                   Z-ADD     @@REMT        @@IAMT
      *
     C                   MOVEL     '136'         WDBASE
     C                   EXSR      SRECOV
      *
     C                   EXSR      ZAMTE
     C*
     C** Move out amount to a 10 alpha field
     C*
     C                   MOVE      @@AMNT        @@WRK
     C*
     C     @@REMT        IFLT      0                                            B1
     C                   MOVE      '-'           DDREMT                         *1
     C                   ELSE                                                   X1
     C     @@REMT        IFEQ      0                                            B*2
     C                   MOVE      ' '           DDREMT                         **2
     C                   ELSE                                                   X*2
     C                   MOVE      '+'           DDREMT                         **2
     C                   END                                                    E*2
     C                   END                                                    E1
     C                   MOVEL     @@WRK         DDREMT           11
     C*
     C** Set up date field for display
     C*
     C                   MOVEL     DDMY2         DDMY3             5
     C*
     C     #BF9          ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #BG      - PREPARE PARAMTERS                                  *
     C*                                                               *
     C* CALLED BY  #B      -  MAIN PROCESSING                         *
     C*                                                               *
     C* FLDS USED                                                     *
     C*                                                               *
     C*****************************************************************
      *
     C     #BG           BEGSR
      *
      ** If selection is made with '1'
     C     SSSLC1        IFEQ      '1'
     C     SSSLC2        OREQ      '1'
      *
      ** If either book or branch is 'ALL', process error
     C     @TBOOK        IFEQ      'ALL'
     C     @TBRCH        OREQ      'ALL'
      *
     C                   MOVEL     'FIS0028'     @MSGID
     C                   CALL      'ZA0240'
     C                   PARM                    @MSGID
     C                   MOVE      'Y'           @@ERMS
      *
     C                   ELSE
      *
      ** Set termination parameter to 'D' (down)
     C                   MOVE      'D'           @@TERM
      *
      ** If book title is 'ALL', set book to blanks
     C     @TBOOK        IFEQ      'ALL'
     C                   MOVE      *BLANKS       @DNBKC
     C                   ELSE
      *
      ** Else set book to book title
     C                   MOVEL     @TBOOK        @DNBKC
     C                   END
      *
      ** Set currency to currency title
     C                   MOVE      @TCRCY        @DNCCY
      *
      ** If branch title is 'ALL', set branch to blanks
     C     @TBRCH        IFEQ      'ALL'
     C                   MOVE      *BLANKS       @DNBRC
     C                   ELSE
      *
      ** Else set branch to branch title
     C                   MOVE      @TBRCH        @DNBRC
     C                   END
      *
      ** Set date parameter if first half of month selected
     C     SSSLC1        IFEQ      '1'
     C                   MOVEL     DDMY1         @DOWNT            5
     C                   MOVE      @DOWNT        @DNDAT
     C                   MOVEL     '01'          @DNDAT
     C                   ELSE
      *
      ** Set date parameter for second half of month
     C                   MOVEL     DDMY2         @DOWNT
     C                   MOVE      @DOWNT        @DNDAT
     C                   MOVEL     '16'          @DNDAT
     C                   END
      *
      ** If date being passed is before run date then pass run date
     C                   MOVE      BJMRDT        @RUNMY            5
     C                   MOVEL     BJMRDT        @RUNDD            2 0
     C                   MOVEL     @DNDAT        @COMP             2 0
      *
     C     @DOWNT        IFEQ      @RUNMY
     C     @COMP         ANDLT     @RUNDD
     C                   MOVE      *BLANK        @DNDAT
     C                   MOVE      BJMRDT        @DNDAT
     C                   END
     C*
     C** If Date format is 'M'(American), change date format from
     C** UK(DDMMMYY) to US(MMMDDYY).
     C     BJDFIN        IFEQ      'M'
     C                   MOVE      @DNDAT        @DAT7
     C*
     C** If day is before 10th, insert leading zero
     C     @DDY          IFLT      10
     C     @DDY          ANDGT     0
     C                   MOVEL     '0'           @DAY
     C                   END
     C*
     C*
     C                   END
      *
      ** Set up currency decimal places and default int calc method
     C                   Z-ADD     @@CDP         @DCDP
     C                   Z-ADD     @@DICM        @DDICM            1 0
     C                   Z-ADD     WSPOT         @DNSPT
     C                   Z-ADD     A6SSNB        @DSEQN
     C                   MOVEL     WINCY         @DINCY
      *
      ** Send parameters to next pgm down (DL1905)
     C                   MOVEL     @PRMDN        @STRNG
      *
     C                   END
     C                   ELSE
      *
      ** Else, selection is made with '2'
     C     SSSLC1        IFEQ      '2'
     C     SSSLC2        OREQ      '2'
      *
      ** Set termination parameter to 'J' (jump down)
     C                   MOVE      'J'           @@TERM
      *
      ** Set currency to currency title
     C                   MOVE      @TCRCY        @JPCCY
      *
      ** Set broker to blanks (this means 'ALL')
     C                   MOVE      *BLANKS       @JPBRK
      *
      ** If book title is 'ALL', set book to blanks
     C     @TBOOK        IFEQ      'ALL'
     C                   MOVE      *BLANKS       @JPBKC
     C                   ELSE
      *
      ** Else set book to book title
     C                   MOVEL     @TBOOK        @JPBKC
     C                   END
      *
      ** If branch title is 'ALL', set branch to blanks
     C     @TBRCH        IFEQ      'ALL'
     C                   MOVE      *BLANKS       @JPBRC
     C                   ELSE
      *
      ** Else set branch to branch title
     C                   MOVE      @TBRCH        @JPBRC
     C                   END
      *
     C                   Z-ADD     A6SSNB        @JPSEQ
     C                   MOVEL     WINCY         @JPICY
      *
      ** Set up value date
      *
      ** Reset indicator 77
     C                   MOVE      '0'           *IN77
      *
      ** Set date parameter if first half of month selected
     C     SSSLC1        IFEQ      '2'
     C                   MOVEL     DDMY1         @JUMPT            5
     C                   MOVE      @JUMPT        @JPVDT
     C                   MOVEL     '01'          @JPVDT
     C                   ELSE
      *
      ** Set date parameter for second half of month
     C                   MOVEL     DDMY2         @JUMPT
     C                   MOVE      @JUMPT        @JPVDT
     C                   MOVEL     '16'          @JPVDT
     C                   END
      *
      ** If date being passed is before run date then pass run date
     C                   MOVE      BJMRDT        @RUNMY            5
     C                   MOVEL     BJMRDT        @RUNDD            2 0
     C                   MOVEL     @JPVDT        @COMP             2 0
      *
     C     @JUMPT        IFEQ      @RUNMY
     C     @COMP         ANDLT     @RUNDD
     C                   MOVE      *BLANK        @JPVDT
     C                   MOVE      BJMRDT        @JPVDT
     C                   END
     C*
      ** If date being passed is run date then set value date number
      **    to run date number
     C     BJMRDT        IFEQ      @JPVDT
     C                   Z-ADD     BJRDNB        @JPVDY
     C                   ELSE
      *
      ** Else, call subroutine ZVLDT to convert date into midas day no.
      ** (Use DDMMYY format here even if using US format since not yet
      ** converted)
     C                   MOVE      'D'           @@DFMT
     C                   MOVE      @JPVDT        @@VLDT
     C                   EXSR      ZVLDT
      *
      ** If error on date passed to subroutine
     C     @@RTN         IFEQ      '1'
     C                   MOVEL     '#BG     '    DBFILE                         ***************
     C                   MOVEL     @@VLDT        DBKEY                          * DBERROR 041 *
     C                   MOVE      '041'         DBASE                          ***************
     C                   EXSR      *PSSR
     C                   ELSE
      *
      ** Else, date converted
     C                   Z-ADD     @@DAYN        @JPVDY
     C                   END
     C                   END
     C**
     C** If Date format is 'M'(American), change date format from
     C** UK(DDMMMYY) to US(MMMDDYY).
     C     BJDFIN        IFEQ      'M'
     C                   MOVE      @JPVDT        @DAT7
     C*
     C** If day is before 10th, insert leading zero
     C     @DDY          IFLT      10
     C     @DDY          ANDGT     0
     C                   MOVEL     '0'           @DAY
     C                   END
     C*
     C                   MOVE      @DAY          @WRK5             5
     C                   MOVEL     @MMT          @WRK5
     C                   MOVEL     @WRK5         @JPVDT
     C*
     C                   END
      *
      ** Move value date number into key field
     C                   Z-ADD     @JPVDY        @KVLDT
      *
      ** Set lower limits on DLDLDGL5 with appropriate key
     C     @@FILE        IFEQ      '1'
     C     @KPRT5        SETLL     DLDLDGL5
     C                   READ      DLDLDGL5                             7777
     C                   END
      *
      ** Set lower limits on DLDLDGL7 with appropriate key
     C     @@FILE        IFEQ      '2'
     C     @KPRT7        SETLL     DLDLDGL7
     C                   READ      DLDLDGL7                             7777
     C                   END
      *
      ** Set lower limits on DLDLDGL6 with appropriate key
     C     @@FILE        IFEQ      '3'
     C     @KPRT6        SETLL     DLDLDGL6
     C                   READ      DLDLDGL6                             7777
     C                   END
      *
      ** Set lower limits on DLDLDGL8 with appropriate key
     C     @@FILE        IFEQ      '4'
     C     @KPRT8        SETLL     DLDLDGL8
     C                   READ      DLDLDGL8                             7777
     C                   END
      *
      ** Call subroutine ZDATE8 to convert Value Date from midas day
      **   number into date format .
     C     *IN77         IFNE      '1'
     C                   Z-ADD     VDAT          ZDAYNO
     C                   EXSR      ZDATE8
     C                   MOVE      ZADATE        @WJPVD            7
     C**
     C** Edit the dates, according to the date format indicator, for
     C** both the Value Date read from the DEALS file (@WJPVD) and the
     C** first date of the period selected in the enquiry (@JPVDT)
     C** in order to check that @WJPVD falls into the period selected
     C** from the enquiry.
     C**
     C** ..if US date format
     C     BJDFIN        IFEQ      'M'
     C                   MOVEL     @WJPVD        @DAT7
     C                   MOVE      @YY           @WK5A             5
     C                   MOVEL     @MMM          @WK5A             5
     C                   MOVE      @DAT5         @WK2A             2
     C**
     C                   MOVEL     @JPVDT        @DAT7
     C                   MOVE      @YY           @WK5B             5
     C                   MOVEL     @MMM          @WK5B             5
     C                   MOVE      @DAT5         @WK2B             2
     C**
     C** ..else UK date format
     C                   ELSE
     C**
     C                   MOVEL     @WJPVD        @DAT7
     C                   MOVE      @YY           @WK5A             5
     C                   MOVEL     @MMT          @WK5A             5
     C                   MOVEL     @DAY          @WK2A             2
     C**
     C                   MOVEL     @JPVDT        @DAT7
     C                   MOVE      @YY           @WK5B             5
     C                   MOVEL     @MMT          @WK5B             5
     C                   MOVEL     @DAY          @WK2B             2
     C                   END
     C                   END
     C**
     C** IF error on read of DEALS file, OR MMM/YY of @WJPVD and @JPVDT
     C** are not the same, OR they are the same but the first half of
     C** the month was selected AND VDAT is after the 16th THEN process
     C** error message - 'no data in period selected'...
     C     *IN77         IFEQ      '1'
     C     @WK5A         ORNE      @WK5B
     C     @WK5A         OREQ      @WK5B
     C     SSSLC1        ANDEQ     '2'
     C     @WK2A         ANDGT     '16'
     C**
     C                   MOVEL     'FIS0030'     @MSGID
     C                   CALL      'ZA0240'
     C                   PARM                    @MSGID
     C                   MOVE      'Y'           @@ERMS
     C**
     C                   ELSE
     C                   MOVE      ZADATE        @JPVDT
     C                   Z-ADD     VDAT          @JPVDY
     C                   END
      *
      ** Set up currency decimal places and default int calc method
     C                   Z-ADD     @@CDP         @JPCDP
     C                   Z-ADD     @@DICM        @JPDIC
     C                   Z-ADD     WSPOT         @JPSPT
      *
      ** Send parameters for pgm jump (DL1902)
     C                   MOVEL     @PRMJP        @STRNG
      *
     C                   ELSE
      *
      ** Else, selection made is not '1' or '2'
     C                   MOVEL     'FIS0029'     @MSGID
     C                   CALL      'ZA0240'
     C                   PARM                    @MSGID
     C                   MOVE      'Y'           @@ERMS
      *
     C                   END
     C                   END
      *
      *
      ** If no error on selection
     C     @@ERMS        IFNE      'Y'
      *
      ** Set the select field for the record just processed to blank
      **     and update subfile
      ** Set on the selection-processed indicator for when this
      **     program is recalled.
     C                   MOVE      ' '           SSSLC1
     C                   MOVE      ' '           SSSLC2
     C                   UPDATE    DL1909S1
      *
     C                   MOVE      'Y'           @@SLCT
      *
      ** Set off indicators 25/26 (roll up/down) so that if program is
      **     recalled a roll will not be processed
     C                   MOVE      '0'           *IN25
     C                   MOVE      '0'           *IN26
      *
     C                   RETURN
      *
     C                   END
      *
     C                   ENDSR
      *
     C*****************************************************************
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
     C/EJECT
     C*****************************************************************
      ***/COPY ZSRSRC,ZAMTEZ3                                                   CAAA02
      /COPY ZSRSRC,ZAMTEZ3LE                                                    CAAA02
     C*****************************************************************
     C/EJECT
     C*****************************************************************
      ***/COPY ZSRSRC,ZDAT10Z2                                                  CAAA02
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
     C                   OPEN      DLMSY1L
     C                   OPEN      DLMSY2L
     C                   OPEN      DLMSY3L
     C                   OPEN      DLMSY4L
     C                   OPEN      DLMST1L
     C                   OPEN      DLMST2L
     C                   OPEN      DLMST3L
     C                   OPEN      DLMST4L
     C                   OPEN      FDMNTHLL
     C                   OPEN      MUSER
     C                   OPEN      DLDLDGL5
     C                   OPEN      DLDLDGL6
     C                   OPEN      DLDLDGL7
     C                   OPEN      DLDLDGL8
     C*
     C** EXSR #AAA TO READ INSTALLATION FILE
     C*
     C                   EXSR      #AAA
     C*
     C** SET UP THE RUN DATE FOR THE SCREEN HEADING
     C*
     C                   MOVE      BJMRDT        @TDATE
     C**
     C** If Date format is 'M'(American), change date format from
     C** UK(DDMMMYY) to US(MMMDDYY). Also set up Screen Run date.
     C** and set on *IN98 for input to ZDATE8 later.
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
     C                   MOVEL     @WRK5         @TDATE                         *1
     C*                                                    *1
     C                   END                                                    E1
     C*
     C** READ MONTH SHORTNAMES FILE USED IN ZVLDT
     C*
     C     1             CHAIN     FDMNTHLL                           86
     C*
     C     *IN86         IFEQ      '1'                                          B1
     C*                                                    ***************
     C                   MOVEL     'FDMNTHLL'    DBFILE                         *             *
     C                   MOVE      *BLANKS       DBKEY                          * DBERROR 019 *
     C                   MOVE      '019'         DBASE                          *             *
     C*                                                    ***************
     C                   EXSR      *PSSR                                        *1
     C                   END                                                    E1
     C*
     C*
     C** Put Midas Date thru ZVLDT, for conversion to Midas Day No.
     C** This has to be done by moving a 'dummy' day number 01 into it
     C** so that the screen-prompt-date validation in subr #BCA works.
     C*
     C                   MOVE      BJMRDT        @@VLDT
     C                   MOVE      'D'           @@DFMT                         *1
     C                   MOVEL     '01'          @@VLDT                         *1
     C                   EXSR      ZVLDT                                        *1
     C*
     C*
     C** Shouldn't be an error returned, so DBERR if there is.
     C*
     C     @@RTN         IFEQ      '1'                                          B1
     C*                                                    ***************
     C                   MOVEL     'SDBANKPD'    DBFILE                         *             *
     C                   MOVEL     @@VLDT        DBKEY                          * DBERROR 020 *
     C                   MOVE      '020'         DBASE                          *             *
     C*                                                    ***************
     C                   EXSR      *PSSR                                        *1
     C                   END                                                    E1
     C*
     C** Store the returned Midas day number, to be used in #BCA
     C*
     C                   Z-ADD     @@DAYN        @@RDAY            5 0
     C*
     C** SET UP MONTH/YEAR WITH TODAYS DATE FROM THE INSTALLATION FILE
     C*
     C                   MOVE      BJMRDT        @FMMYY            5
     C*
     C** CALCULATE DEFAULT VALUES FOR ALL NECESSARY FIELDS
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
     C                   MOVE      '023'         DBASE                          *             *
     C                   MOVEL     @USER         DBKEY                          * DBERROR 023 *
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
     C*
                                                                                CAAA02
      * If a value is specified on the MUSER record set the maximum             CAAA02
      *  wait time to else, else use a default                                  CAAA02
     c                   if        AURF = 'Y'                                   CAAA02
     c                   eval      MaxWaitTime = REFP                           CAAA02
     c                   else                                                   CAAA02
     c                   eval      MaxWaitTime = 32767                          CAAA02
     c                   end                                                    CAAA02
                                                                                CAAA02
     C                   OPEN      DL1909DF
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
     C* FLDS USED  @@TERM     - TERMINATION PARAMETER                 *
     C*                                                               *
     C*****************************************************************
     C*
     C     #C            BEGSR
     C*
     C** IF FAST EXIT HAS BEEN REQUESTED - CMD 1 EXIT IMMEDIATELY
     C*
     C     *IN03         IFEQ      '1'                                          B1
     C                   MOVE      'Q'           @@TERM                         *1
     C                   MOVE      '1'           *INLR                          *1
     C*
     C                   END                                                    E1
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
     C                   MOVE      '0'           *IN64
     C                   MOVE      '0'           *IN68
     C*
     C** RESET ALL FILE ERROR INDICATORS.
     C*
     C                   MOVE      '0'           *IN71
     C                   MOVE      '0'           *IN72
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
      *
      ** Check if SAR CEU012 is installed
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU012'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CEU012            1
     C                   ELSE
     C                   MOVE      'N'           CEU012
      *
     C     @RTCD         IFNE      '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     'CEU012 '     DBKEY                          *DBERROR 70*
     C                   MOVEL     '070'         DBASE                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
      ** Retrieve general ledger details
      *
     C     CEU012        IFEQ      'Y'
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDGELR        PARM      SDGELR        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE                         ************
     C                   MOVEL     '*FIRST'      DBKEY                          *DBERROR 71*
     C                   MOVEL     '071'         DBASE                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Get the Euro currency details.
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      BKEURO        @CCY
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   MOVEL     BKEURO        DBKEY                          * DBERR 69 *
     C                   MOVEL     '069'         DBASE                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Z-ADD     A6NBDP        WENBDP            1 0
      *
     C                   ENDIF
     C*
     C**  Get ZMUSER to access Default Branch
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
     C*
     C     BGMBIN        IFEQ      'N'                                          B*2
     C                   MOVE      '1'           *IN50                          **2
     C                   END                                                    E*2
     C*
     C*
     C     #AAA9         ENDSR
     C*****************************************************************
     C/EJECT
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
     C* FLDS USED  ZADAT   -  CONTAINS THE 7 CHAR DATE FORMAT         *
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
     C                   MOVE      ZADAT         ZADAT             7
     C*
     C**  Move the date into its various components - DD, MMM and YY
     C*
     C                   MOVE      ZADAT         ZDATE
     C                   MOVEL     ZADAT         @@WRK1            5
     C*
     C**  If *IN98 is on, date format is 'M' (MMMDDYY)
     C*
     C     *IN98         IFEQ      '1'
     C                   MOVEL     @@WRK1        @@MMM             3
     C                   MOVE      @@WRK1        ZWRK4
     C*
     C**  Else *IN98 is off, date format is 'D' (DDMMMYY)
     C*
     C                   ELSE
     C                   MOVEL     @@WRK1        ZWRK4
     C                   MOVE      @@WRK1        @@MMM
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
     C                   MOVE      *BLANKS       ZADAT             7
     C                   MOVE      *BLANKS       @@WRK1            5
     C                   MOVE      @SMMYY        ZDATE
     C                   MOVE      ZDATE         ZDATE             6 0
     C*
     C**  Move the date into its various components - DD, MM and YY
     C*
     C                   MOVE      ZDATE         ZADAT
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
     C                   MOVE      @@MM          WMON2             2
     C     WMON2         LOOKUP    @MON                                   12
      *
     C     *IN12         IFEQ      '1'
     C                   MOVEA     @MT(@@MM)     @@MMM             3
     C                   ELSE
     C                   MOVEL     'FIS0018'     @MSGID           10
     C                   CALL      'ZA0240'
     C                   PARM                    @MSGID
     C                   MOVE      '1'           *IN62
     C                   MOVE      '1'           *IN69
     C                   ENDIF
     C*
     C     *IN98         IFEQ      '1'
     C                   MOVE      '01'          @@WRK1
     C                   MOVEL     @@MMM         @@WRK1
     C                   ELSE
     C                   MOVEL     '01'          @@WRK1
     C                   MOVE      @@MMM         @@WRK1
     C                   END
     C*
     C**  Set up output field for MMMDDYY/DDMMMYY
     C*
     C                   MOVEL     @@WRK1        ZADAT
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
     C* FLDS USED  @BEEN    -  ALREADY BEEN THROUGH *PSSR INDICATOR   *
     C*            DBPGM    -  HOLDS PGM NAME IN LDA                  *
     C*            @LDA     -  VARIABLE TO SET UP LDA WITH DB ERRORS  *
     C*                                                               *
     C*****************************************************************
     C*
     C     *PSSR         BEGSR
     C*
     C** IF NOT BEEN ALREADY BEEN THROUGH *PSSR THEN PROCESS ERROR
     C** ELSE JUST RETURN
     C*
     C     @BEEN         IFNE      'Y'                                          B1
     C*
     C** SET ALREADY-BEEN-THROUGH-*PSSR INDICATOR TO YES
     C*
     C                   MOVE      'Y'           @BEEN             1            *1
     C*
     C** SET UP TERMINATION PARAMETER, TURN ON ERROR SWITCHES,
     C** SET ON LR AND DUMP
     C*
     C                   MOVE      'E'           @@TERM                         *1
     C                   MOVE      '1'           *INU7                          *1
     C                   MOVE      '1'           *INU8                          *1
     C                   MOVE      '1'           *INLR                          *1
     C                   DUMP                                                   *1
     C*
     C** MOVE DATABASE ERROR DETAILS INTO LDA
     C*
     C     *DTAARA       DEFINE    LDA           @LDA            256            *1
     C     *LOCK         IN        @LDA                                         *1
     C                   MOVEL     DBERR         @LDA                           *1
     C                   OUT       @LDA                                         *1
     C*
     C                   END                                                    E1
     C*
     C                   RETURN
     C*
     C                   ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #AD      - SET UP KLISTS - NEVER CALLED                       *
     C*                                                               *
     C* CALLS                                                         *
     C*                                                               *
     C* CALLED BY                                                     *
     C*                                                               *
     C* FLDS USED  @KBKCD     - BOOK CODE      )                      *
     C*            @KCRCY     - CURRENCY       )  FIELDS MAKING UP    *
     C*            @KBRCA     - BRANCH CODE    )  KEYS FOR SUMMARY    *
     C*            @KMMYY     - MONTH/YEAR     )  FILES               *
     C*                                                               *
     C*            @KREQ1 TO @KREQ4 - KLIST FOR ROLLING ONE FOR EACH  *
     C*                               POSSIBLE SUMMARY FILE           *
     C*                                                               *
     C*            @KPRT1 TO @KPRT4 - KLIST FOR NEW PROMPTS ONE FOR   *
     C*                               EACH POSSIBLE SUMMARY FILE      *
     C*                                                               *
     C*****************************************************************
     C*
     C     #AD           BEGSR
      *
      ** Key for reading equal summary file DLMSY1L and
      **     for chaining to summary history file DLMST1L
     C     @KREQ1        KLIST
     C                   KFLD                    @KBKCD
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBRCA
      *
      ** Key used to set limits on summary file DLMSY1L when
      **     new prompts
     C     @KPRT1        KLIST
     C                   KFLD                    @KBKCD
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBRCA
     C                   KFLD                    @KCENT
     C                   KFLD                    @KVLDT
      *
      ** Key for reading equal summary file DLMSY2L and
      **     for chaining to summary history file DLMST2L
     C     @KREQ2        KLIST
     C                   KFLD                    @KBKCD
     C                   KFLD                    @KCRCY
      *
      ** Key used to set limits on summary file DLMSY2L when
      **     new prompts
     C     @KPRT2        KLIST
     C                   KFLD                    @KBKCD
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KCENT
     C                   KFLD                    @KVLDT
      *
      ** Key for reading equal summary file DLMSY3L and
      **     for chaining to summary history file DLMST3L
     C     @KREQ3        KLIST
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBRCA
      *
      ** Key used to set limits on summary file DLMSY3L when
      **     new prompts and for reading equal on file
     C     @KPRT3        KLIST
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBRCA
     C                   KFLD                    @KCENT
     C                   KFLD                    @KVLDT
      *
      ** Key for reading equal summary file DLMSY4L and
      **     for chaining to summary history file DLMST4L
     C     @KREQ4        KLIST
     C                   KFLD                    @KCRCY
      *
      ** Key used to set limits on summary file DLMSY4L when
      **     new prompts and for reading equal on file
     C     @KPRT4        KLIST
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KCENT
     C                   KFLD                    @KVLDT
      *
      ** Key used to read deals file DLDLDGL5
     C     @KPRT5        KLIST
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBKCD
     C                   KFLD                    @KBRCA
     C                   KFLD                    @KVLDT
      *
      ** Key used to read deals file DLDLDGL6
     C     @KPRT6        KLIST
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBRCA
     C                   KFLD                    @KVLDT
      *
      ** Key used to read deals file DLDLDGL7
     C     @KPRT7        KLIST
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBKCD
     C                   KFLD                    @KVLDT
      *
      ** Key used to read deals file DLDLDGL8
     C     @KPRT8        KLIST
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KVLDT
     C     #AD9          ENDSR
     C*****************************************************************
     C/EJECT
      *****************************************************************
      *  SRECOV - This is use to convert the net position from the    *
      *           original currency into the Euro equivalent.         *
      *                                                               *
      *  Call on   : EU0200 - Euro conversion program                 *
      *  Call by   : #BD - Edit enquiry subfile (1st line)            *
      *              #BE - Edit enquiry subfile (2nd line)            *
      *              #BF - Edit enquiry subfile (3rd line)            *
      *                                                               *
      *****************************************************************
     C     SRECOV        BEGSR
      *
     C     CEU012        IFEQ      'Y'
     C     WINCY         ANDEQ     'Y'
     C     *IN32         ANDEQ     '1'
     C     @@IAMT        ANDNE     *ZEROS
      *
     C                   CALL      'EU0200'                             1010
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      @@IAMT        P@FRAM           18 3
     C                   PARM      @SCRCY        P@FRCY            3
     C                   PARM      BKEURO        P@TOCY            3
     C                   PARM      *ZEROS        P@OUTA           15 0
     C                   PARM      *ZEROS        P@INTA           18 3
     C                   PARM      *ZEROS        P@EXRT           15 9
     C                   PARM      *BLANKS       P@MDIN            1
      *
     C     P@RTCD        IFEQ      *BLANKS
     C                   Z-ADD     P@OUTA        @@IAMT           15 0
     C                   ELSE
     C                   MOVEL     '*CALL   '    DBFILE                         ************
     C                   MOVEL     WDBASE        DBASE                          *DBERROR 72*
     C                   MOVEL     'EU0200'      DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
**  @MON - VALID MONTH NUMBERS
010203040506070809101112
**  @YR - VALID YEAR DIGITS
0123456789
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
** @YD  USED BY SR. ZDATE9 - YEARS, IN DAYS, CUMULATIVE IN 4 YEAR SPAN
00366007310109601461
** @MD  USED BY SR. ZDATE9 - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
00000000310005900090001200015100181002120024300273003040033400365
** @OVR  CL COMMAND FOR CALL TO QCMDEXC
OVRDSPF FILE(DL1909DF) WAITRCD(    )
