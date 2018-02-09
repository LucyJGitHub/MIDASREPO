     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*S*D ***RPGBASE*******************************************************                       CAAA02
/*STD *  RPGBASEMOD                                                   *                       CAAA02
/*EXI *  TEXT('Midas DL FRA daily deals enquiry')                     *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Module
      *                                                               *
      *  DL1902 - FRA DAILY DEALS ENQUIRY                             *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. 245692             Date 09Dec13               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL028             Date 07Feb05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 TDA035             Date 02Apr04               *
      *                 CAAA03             Date 29Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAAA02             Date 16Jul03               *
      *  Converted to ILE and code-stripped                           *
      *                 217684             Date 12May03               *
      *                 216647             Date 11Apr03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP056             Date 13Mar02               *
      *                 CIR008             Date 13Mar02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 192374             Date 20Apr01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 15May01               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 139971             Date 03Aug98               *
      *                 CEU012             Date 16Feb98               *
      *                 126426             Date 29Dec97               *
      *                 099037             Date 30Jul96               *
      *                 061426             Date 30Sep93               *
      *                 046114             DATE 09JUL93               *
      *                 E26570             DATE 04SEP92               *
      *                 S01117             DATE 25MAR92               *
      *                 E28496             DATE 17SEP91               *
      *                  E28440                 DATE 17SEP91          *
      *                  S01269                 DATE 25JUN91          *
      *                  E23419                 DATE 05NOV90          *
      *                  E23418                 DATE 01OCT90          *
      *                  E22035                 DATE 27SEP90          *
      *                  E23194                 DATE 16AUG90          *
      *                  E23183                 DATE 07AUG90          *
      *                  S01199/E22695          DATE 30MAR90          *
      *                  S01117                 DATE 30MAR90          *
      *                  S01194                 DATE 30MAR90          *
      *                  E20774                 DATE 15MAR90          *
      *                  S01157                 DATE 28/11/88         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  245692 - Incorrect validation of rates when the decimal se-  *
      *           parator in the Dealing ICD was defined as "," ins-  *
      *           tead of ".".                                        *
      *         - Applied for MD23981.                                *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
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
      *  217684 - Authorisation User Malfunction (Recompile)          *
      *  216647 - Unable to select book code from list.               *
      *           After call from AOBOOKR0, move selected value       *
      *           on screen field.                                    *
      *  CAP056 - Automatic Authorisation of Interface deals          *
      *           (Recompile)                                         *
      *  CIR008 - FRA/IRS Deals Authorisation (Recompile)             *
      *  192374 - Array Index error                                   *
      *  CSD006 - Use long DS with SDBSRTPD.                          *
      *  139971 - Enquiry of Consolidated Euro currency records for a *
      *           specific book in FRA Daily Deals and FRA Book Posi- *
      *           tion also show records for other books.             *
      *  CEU012 - Position/Risk Enquiries                             *
      *  126426 - If Date Format flag is 'M', convert the date to     *
      *           American date format after calling SR/ZDATE8.       *
      *  099037 - ACCORDING TO THE MANUAL, THE ENQUIRY MUST SHOW THE  *
      *           DEALS WITH VALUE DATE ON ANY DAY FORWARD INCLUDING  *
      *           TODAY.                                              *
      *  061426 - Recompile after ZDATE9 correction                   *
      *  046114 - FRA book position enquiry - F12 takes you to        *
      *           another enquiry screen.                             *
      *  E26570 - The enquiry on FRA Daily Deals asks for the date to *
      *           be input in format MMMDDYY instead of MMDDYY.  This *
      *           does  not  meet the  standard for the  rest of  the *
      *           MIDAS system.                                       *
      *   S01117 - RECOMPILE FOR FT CHANGE TO MUSERDD                 *
      *   E28496 -   Recompile for SDFAISPD changes (BQHEOC - Hedged  *
      *              Events on Cashflow removed).                     *
      *   E28440 -   DL1905 needs Spot Date for Ccy - add this to the *
      *              parameters passed (converted to Midas Day No).   *
      *   S01269 - RECOMPILE FOR TRADE AUTHORISATION CHANGE TO        *
      *            MUSERDD                                            *
      *   E23419  -  Tidied up American date formats and ensured no   *
      *              embedded blank in date if MMMDDYY ie. changed    *
      *              'MAR 890' to MAR0890'                            *
      *   E23418  -  When ICD has date format 'M' (American- MMMDDYY) *
      *              Value date and Run date still remain in UK       *
      *              format (ie DDMMMYY).                             *
      *   E22035  -  On return from DL0170, TITLES & Subfile are      *
      *              updated but prompts contains incorrect values    *
      *              + no errors are displayed.                       *
      *   E23194  -  DATE FIELD ALLOWS NON-NUMERICS FOR DAY NUMBER    *
      *              FIELD                                            *
      *   E23183  -  SUBROUTINE ZVLDT ALTERED TO ACCEPT DATE IN       *
      *              CORRECT FORMAT ONLY - PROGRAM RECOMPILED         *
      *   S01199/E22695  -  HELP SYSTEM.  (E22695 WAS APPLIED FOR *
      *                     R2 TO THIS PROGRAM AT THE SAME TIME AS    *
      *                     S01199 WAS APPLIED FOR R10 - THEREFORE    *
      *                     THEY MAY NOT BE INDENTICAL CHANGES)       *
      *   S01117 - MULTI-BRANCHING CHANGES                            *
      *   S01194 - NEW STANDING DATA CHANGES                          *
      *   E20774  -  REPLACE QCAEXEC WITH QCMDEXC                     *
      *   S01157 - NEW PROGRAM WRITTEN FOR FRA/IRS                    *
      *                                                               *
      *****************************************************************
      *
      /EJECT
      * ID  F  C  H  L    FUNCTION OF INDICATORS
      *****************************************************************
      *                                                               *
      * INDICATORS TO BE RECEIVED FROM THE SCREEN - COMMANDS          *
      *                                                               *
      *     03   -  EXIT PROGRAM                                      *
      *     05   -  REFRESH SCREEN                                    *
      *     07   -  Toggle between 'Display Euro Equivalent'          *
      *             and 'Display Ccy Amount'                          *
     F*     12   -  FURTHER SUMMARY SCREEN                            *
     F*     18   -  IF OFF, MMMDDYY -> MMDDYY; ON, MMDDYY -> MMMDDYY  *
     F*     25   -  ROLLUP REQUESTED                                  *
     F*     26   -  ROLLDOWN REQUESTED                                *
     F*                                                               *
     F*     27   -  INHIBIT ROLL/REFRESH/SELECT KEYS & TEXT/ENQ.TITLES*
     F*     28   -  ACTIVATE THE OVRDTA KEYWORD FOR KEYS/TEXT & TITLES*
     F*     29   -  ACTIVATE THE OVRATR KEYWORD FOR THE SELECT FIELDS *
     F*     24   -  ACTIVATE THE OVRDTA KEYWORD FOR THE SELECT FIELDS *
     F*                                                               *
      *     31   -  Position/Risk Enquiries & Reprots Feature Ind     *
      *     32   -  Display Euro Equivalent Indicator                 *
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
     F*     63   -  ERROR ON BROKER SELECTED                          *
     F*     64   -  ERROR ON BOOK CODE SELECTED                       *
     F*     68   -  NO RECORD ON FILE FOR CCY/BRANCH AND GE VALUE DATE*
     F*     69   -  GENERAL ERROR ON VALIDATION OF PROMPT SCREEN      *
     F*                                                               *
     F* INDICATORS TO REPORT ERRORS ON FILE READS                     *
     F*                                                               *
     F*     70   -  END OF SUBFILE - DL1902S1                         *
     F*     71   -  END OF RELEVANT DATA ON DEALS FILE                *
     F*     72   -  BEGINNING OF RELEVANT DATA ON DEALS FILE          *
     F*     73   -  ERROR ON READ OF ENQUIRY SUBFILE CONTROL FORMAT   *
     F*                                                               *
     F*     85   -  DATABASE ERROR ON MUSER                           *
     F*     86   -  DATABASE ERROR ON FDMNTHLL                        *
     F*                                                               *
     F*     98   -  INDICATOR USED IN ZDATE8                          *
     F*     99   -  INDICATOR USED IN ZDATE1                          *
     F*                                                               *
     F*****************************************************************
     F*
     FDLDLDGL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(DEALSDGF:FMT1)
     F*
     FDLDLDGL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(DEALSDGF:FMT2)
     F*
     FDLDLDGL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(DEALSDGF:FMT3)
     F*
     FDLDLDGL4  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(DEALSDGF:FMT4)
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
     FDLDLDEL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
      *
      ** DL Daily Deals Files 1-8
      *
     F                                     RENAME(DLFRAED0:FMTE1)
      *
     FDLDLDEL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(DLFRAED0:FMTE2)
      *
     FDLDLDEL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(DLFRAED0:FMTE3)
      *
     FDLDLDEL4  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(DLFRAED0:FMTE4)
      *
     FDLDLDEL5  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(DLFRAED0:FMTE5)
      *
     FDLDLDEL6  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(DLFRAED0:FMTE6)
      *
     FDLDLDEL7  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(DLFRAED0:FMTE7)
      *
     FDLDLDEL8  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(DLFRAED0:FMTE8)
      *
     FFDMNTHLL  IF   E             DISK    INFSR(*PSSR)
     F                                     USROPN
     F*
     FMUSER     IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
      *
     FSDCURRL0  IF   E           K DISK
      *
      ** Currencies File
      *
     F*
     FDL1902DF  CF   E             WORKSTN INFSR(*PSSR)
     F                                     USROPN
     F                                     SFILE(DL1902S1:RRN)
     F                                     MAXDEV(*FILE)
     F*
     F*
     F*****************************************************************
     D*
      ***/COPY ZSRSRC,ZDATE8Z1                                                  CAAA02
      ***/COPY ZSRSRC,ZFRPEDZ1                                                  CAAA02
      ***/COPY ZSRSRC,ZRATE1Z1                                                  CAAA02
      ***/COPY ZSRSRC,ZDATE9Z1                                                  CAAA02
      /COPY ZSRSRC,ZDATE8Z1LE                                                   CAAA02
      /COPY ZSRSRC,ZRATE1Z1LE                                                   CAAA02
      /COPY ZSRSRC,ZDATE9Z1LE                                                   CAAA02
     D*
     D @A              S              1    DIM(20)
     D** ARRAY USED TO EDIT AMOUNT FOR DISPLAY
     D*
     D @OVR            S             36    DIM(1) CTDATA PERRCD(1)
     D** ARRAY TO SET UP PARAMETER FOR CALL TO QCMDEXC
     D WCY             S              3    DIM(99)
     D WDC             S              1  0 DIM(99)
      *
      ** Array to store Currency Decimal Places
      *
     D*
      ***/COPY ZSRSRC,ZVLDTZ2                                                   CAAA02
      ***/COPY ZSRSRC,ZFRPEDZ2                                                  CAAA02
      ***/COPY ZSRSRC,ZDAT10Z1                                                  CAAA02
     D*
     D*
     D @KRCRD          DS            42
     D*
     D** DATA STRUCTURE FOR KEY FIELDS
     D*
     D  @KCRCY                 1      3
     D  @KBRKR                 4      7
     D  @KBKCD                 8      9
     D  @KBRCA                10     12
     D  @KVLDT                13     19
     D  @KVLDY                20     24  0
     D  @KMTDY                28     32  0
     D  @KBSRT                33     34  0
     D  @KDLNO                35     40  0
     D  @KSSNB                41     42  0
     D*
     D @@WRK           DS
     D*                                          32
     D** Data structure to move parameter string to
     D*
     D  @@WORK                 1     27
     D  CDP                   28     28  0
     D  DICM                  29     29  0
     D  SPOT                  30     32P 0
     D  WSSNB                 33     34  0
     D  WINCY                 35     35
     D*
     D*
     D @PRMUP          DS            28
     D*
     D** DATA STRUCTURE FOR PROMPT FIELDS FOR PROGRAM UP IN STACK
     D*
     D  @UPBKC                 1      2
     D  @UPCCY                 3      5
     D  @UPBCH                 6      8
     D  @UPVDT                 9     15
     D  @UPVDY                16     20  0
     D  @UPCDP                21     21  0
     D  @UPDIC                22     22  0
     D  @UPSPT                23     25P 0
     D  @UPSNB                26     27  0
     D  @UPINC                28     28
     D*
     D*
     D @PRMHP          DS            29
     D*
     D** DATA STRUCTURE FOR PROMPT FIELDS FOR PROGRAM HOP IN STACK
     D*
     D  @HPBKC                 1      2
     D  @HPCCY                 3      5
     D  @HPBRC                 6      8
     D  @HPDAT                 9     13
     D  @HPCDP                14     14  0
     D  @HPDIC                15     15  0
     D  @HPSPT                16     18P 0
     D  @HPINC                19     19
     D*
     D*
     D @PRMDN          DS           227
     D*
     D** DATA STRUCTURE FOR PROMPT FIELD FOR PROGRAM DOWN IN STACK
     D*
     D  @DNDLN                11     16  0
     D*
     D DLRCRD          DS            42
     D*
     D** DATA STRUCTURE FOR DEALS FILE FIELDS
     D*
     D  UCUCY                  1      3
     D  BRKC                   4      7
     D  BOKC                   8      9
     D  BRCA                  10     12
     D  @@FILL                13     19
     D  VDAT                  20     24  0
     D  MDAT                  28     32  0
     D  BRSQ                  33     34  0
     D  DLNO                  35     40  0
     D  SSNB                  41     42  0
     D*
     D*
     D @YRCRD          DS            42
     D*
     D** DATA STRUCTURE TO SET UP @BOTRD WHEN SELECTION MADE
     D*
     D  @YCRCY                 1      3
     D  @YBRKR                 4      7
     D  @YBOKC                 8      9
     D  @YBRCA                10     12
     D  @YFILL                13     19
     D  @YVDAT                20     24  0
     D  @YMDAT                28     32  0
     D  @YBRSQ                33     34  0
     D  @YDLNO                35     40  0
     D  @YSSNB                41     42  0
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
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
     D** RECORD FORMATS FOR ACCESS TO BASE RATE DETAILS
     D*
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D** RECORD FORMATS FOR ACCESS TO BRANCH CODES
     D*
     D SDBOOK        E DS                  EXTNAME(SDBOOKPD)
     D** RECORD FORMATS FOR ACCESS TO BOOK DETAILS
     D*
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D  #DFAC1       E                     EXTFLD(QQDFAC)                                     CGL029
     D** RECORD FORMATS FOR ACCESS TO CUSTOMER DETAILS
     D*
     D SDBROK        E DS                  EXTNAME(SDBROKPD)
     D** RECORD FORMATS FOR ACCESS TO BROKER DETAILS
     D*
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** General ledger details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      **  Switchable Features File
      *
     D SDFAIS        E DS                  EXTNAME(SDFAISPD)
     D** RECORD FORMATS FOR FWD RATE AGMT/INT RATE SWAP DETAILS
     D*
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)                                  245692
     D QQACC1        E                     EXTFLD(QQACCD)                                     245692
      ** Data Structure to retrieve DEALING ICD details                                       245692
                                                                                              245692
     D LDA           E DS           256    EXTNAME(LDA)
      *  Data Structure for LDA
     D ZMUSER          DS            17
     D* DATA STRUCTURE IN QTEMP - USER DETAILS
     D  @BKLVL                17     17
                                                                                CAAA02
     D ZErrorFlag      s              1a                                        CAAA02
      * Flag used to return error condition from Z* modules                     CAAA02
                                                                                CAAA02
     D ZIn15           s             15p 0                                      CAAA02
      * Field used to pass an amount into Z* modules                            CAAA02
     D ZDecs           s              1p 0                                      CAAA02
      * Field used to pass currency decimal places into Z* modules              CAAA02
     D ZJay            s              1a   inz('J')                             CAAA02
      * Field used to pass a 'J' into Z* modules                                CAAA02
     D ZOut22          s             22a   inz(*blank)                          CAAA02
      * Field used to receive a 22 long result from Z* modules                  CAAA02
     D ZOut25          s             25a   inz(*blank)                          CAAA02
      * Field used to receive a 25 long result from Z* modules                  CAAA02
                                                                                CAAA02
      * WaitTime is the time from WRITE to READ                                 CAAA02
     d WaitTime        s              5p 0                                      CAAA02
     d MaxWaitTime     s              5p 0                                      CAAA02
                                                                                CAAA02
      * Now1Time is the time before the READ and Now2Time the time after        CAAA02
     d Now1Time        s               t                                        CAAA02
     d Now2Time        s               t                                        CAAA02
                                                                                CAAA02
      /COPY ZSRSRC,ZVLDTZ2LE                                                    CAAA02
     I*
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
     C* CALLED BY          -                                          *
     C*                                                               *
     C* FLDS USED  @STIND  -  FROM-STACK-BELOW INDICATOR              *
     C*                                                               *
     C*****************************************************************
     C*
     C** ONLY DO THIS IF NOT RETURNING FROM STACK BELOW AFTER A
     C** SELECTION FROM THIS ENQUIRY
     C*
     C     @STIND        IFNE      'Y'
     C                   EXSR      #A
     C                   END
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
     C*  03  #KA     - DETERMINE FILE - SETLL WITH ROLL KEY           *
     C*  04  #KB     - DETERMINE FILE - SETGT WITH ROLL KEY           *
     C*  05  #KC     - DETERMINE FILE - READE WITH PROMPT KEY         *
     C*  06  #KD     - DETERMINE FILE - SETLL WITH PROMPT KEY         *
     C*  07  #KE     - DETERMINE FILE - READP RECORD                  *
     C*  08  #AB     - SET UP PROMPT FIELDS - DEFAULTS IF NECESSARY   *
     C*  09  #BA     - ROLLUP ENQUIRY SUBFILE                         *
     C*  10  #BB     - ROLLDOWN ENQUIRY SUBFILE                       *
     C*  11  #BC     - ENTER NEW PROMPT DATA                          *
     C*  12  #BCA    - VALIDATE PROMPT DATA                           *
     C*  13  #BCB    - SET UP NEW SCREEN HEADINGS                     *
     C*  14  #BCC    - DETERMINE FILE AND KEY TO BE USED WITH PROMPTS *
     C*  15  #BD     - EDIT ENQUIRY SUBFILE DATA                      *
     C*  16  ZDATE8  - EDIT DATE USING MONTH SHORTNAMES FROM FILE     *
     C*  17  ZFRPED  - EDIT AMOUNT                                    *
     C*  18  ZRATE1  - EDIT CONTRACT RATE                             *
     C*  19  ZVLDT   - EDIT VALUE DATE                                *
     C*  20  #AA     - OPEN FILES AND SET UP DEFAULT PROMPT DATA      *
     C*  21  #AC     - SET UP AUTO REFRESH PROCESSING                 *
     C*  22  #C      - TERMINATION PROCESSING                         *
     C*  23  #ZA     - RESET ERROR INDICATORS AND CLEAR MESSAGE QUEUE *
     C*  24  #AAA    - READ INSTALLATION FILES                        *
     C*  26  *PSSR   - DATABASE ERROR HANDLING                        *
     C*  27  #AD     - SET UP KLISTS - NEVER CALLED                   *
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
     C*            @YRCRD     - DS OF RECORD SELECTED PREVIOUSLY      *
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
     C                   MOVEL     'DL1902'      DBPGM
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
     C** SETUP KEY FIELDS USING DATA PASSED VIA PARAMETERS. @@WORK IS
     C** A WORK FIELD TO AVOID GETTING DECIMAL DATA ERRORS ON @KRCRD.
     C** CLEAR PARAMETER STRING.
     C*
     C                   MOVEL     @STRNG        @@WRK
     C*
     C** Also, need to move no. of d.p's for currency; it is kept in
     C** position 28 of parameter string.
     C*
     C                   Z-ADD     CDP           ZDECS
     C                   MOVEL     @@WORK        @KRCRD
     C                   MOVE      WSSNB         @KRCRD
     C                   MOVE      WINCY         @WINCY            1
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
     C                   WRITE     DL1902F0
     C                   WRITE     DL1902F1
     C*
     C** CLEAR THE SUBFILE BY SETTING OFF THE SUBFILE DISPLAY AND
     C** THE SUBFILE DISPLAY CONTROL INDICATORS AND THEN WRITING
     C** THE ENQUIRY SUBFILE CONTROL FORMAT
     C*
     C                   MOVE      '0'           *IN35
     C                   MOVE      '0'           *IN36
     C                   WRITE     DL1902C1
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
     C                   EXFMT     DL1902C1                                     *1
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
     C*            #KA       - DETERMINE FILE - SETLL WITH ROLL KEY   *
     C*            #KB       - DETERMINE FILE - SETGT WITH ROLL KEY   *
     C*            #KC       - DETERMINE FILE - READE WITH PROMPT KEY *
     C*                                                               *
     C* CALLED BY  MAIN CONTROLLING ROUTINE                           *
     C*                                                               *
     C* FLDS USED  @TOPRD     - FIRST RECORD CURRENTLY ON SCREEN      *
     C*            @BOTRD     - LAST RECORD CURRENTLY ON SCREEN       *
     C*            SSSLCT     - SELECT FIELD FROM SCREEN              *
     C*            @@SLCT     - SELECTION-PROCESSED INDICATOR - Y/N   *
     C*            @@ERMS     - ERROR MESSAGE TO DISPLAY - Y OR N     *
     C*            @@TERM     - TERMINATION PARAMETER                 *
     C*            @KROLL     - KEY USED FOR ROLLING                  *
     C*            @STIND     - FROM-STACK-BELOW INDICATOR            *
     C*                                                               *
     C*****************************************************************
     C*
     C     #B            BEGSR
     C*
     C** If returning from stack below (DL0170) after
     C**      selection from this enquiry.
     C     @STIND        IFEQ      'Y'
     C*
     C*
     C** Call subroutine CVDT to convert date format from
     C** MMMDDYY/DDMMMYY to MMDDYY/DDMMYY
     C                   MOVE      @TVLDT        ZADATE            7
     C                   MOVE      '0'           *IN18
     C                   EXSR      CVDT
     C                   MOVE      ZDATE         @SVLDT
     C                   MOVE      @TCRCY        @SCRCY
     C                   MOVE      @TBRCH        @SBRCA
      *
     C     @TBKCD        IFEQ      'ALL'
     C                   MOVE      @TBKCD        @SBKCD
     C                   ELSE
     C                   MOVE      *BLANKS       @SBKCD
     C                   MOVEL     @TBKCD        @WBKCD            2
     C                   MOVE      @WBKCD        @SBKCD
     C                   END
     C*
     C** If Broker Code specified is 'ALL'...
     C     @TBRKR        IFEQ      'ALL'
     C                   MOVE      *BLANKS       @SBRKR
     C                   ELSE
     C                   MOVE      @TBRKR        @SBRKR
     C                   END
      *
      ** Set on *IN24 so screen prompts are updated
     C                   MOVE      '1'           *IN24
     C                   END
     C*
     C** SET OFF THE SELECTION-PROCESSED INDICATOR
     C*
     C                   MOVE      'N'           @@SLCT            1
     C*
      ** If @FLAG is on, this signifies that F12 has been pressed
      **    for book positions but the prompts are
      **    multi-branched/multi-booked.
      *
      ** If @FLAG is off then clear the message queue of any old
      **    messages and reset any error indicators
     C     @FLAG         IFEQ      '0'
     C                   EXSR      #ZA
     C                   ELSE
      *
      ** Else reset @FLAG to '0' and
      **      Reset the error-message-to-display indicator
     C                   MOVE      '0'           @FLAG
     C                   MOVE      'N'           @@ERMS
     C                   END
     C*
     C** IF REFRESH (CMD 5) HAS BEEN REQUESTED (IF ON PROMPT SCREEN
     C** STILL THEN MANUAL REFRESH INHIBITED AND AUTO REFRESH CAUGHT
     C** IMMEDIATELY AFTER READ) SET UP KEY FROM FIRST RECORD CURRENTLY
     C** ON SCREEN, POSITION ON FILE (#KA) AND PROCESS AS FOR ROLLUP.
     C** BUT IF FROM-STACK-BELOW INDICATOR ON THEN SET UP KEY FROM LAST
     C** RECORD SELECTED IN ENQUIRY, POSITION AND PROCESS AS FOR ROLLUP
     C*
     C     *IN05         IFEQ      '1'                                          B1
     C*
     C     @STIND        IFEQ      'Y'                                          B*2
     C                   MOVEL     @YRCRD        @KRCRD                         **2
     C*
     C** (set on OVRDTA for select fields to clear previous error;and
     C**  reset ccy dec places from previous call of program)
     C                   MOVE      '1'           *IN24                          **2
     C                   Z-ADD     @@CDP         CDP                            **2
     C                   Z-ADD     @@CDP         ZDECS                          **2
     C                   ELSE                                                   X*2
     C                   MOVEL     @TOPRD        @KRCRD                         **2
     C                   END                                                    E*2
     C*
     C                   EXSR      #KA                                          *1
     C                   EXSR      #BA                                          *1
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
     C                   READC     DL1902S1                               70    ***3
     C*
     C** IF RECORD FOUND AND SELECT FIELD NOT '1' THEN RETURN TO
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
     C** BELOW IN STACK. SETUP @YRCRD WITH RECORD SELECTED SO THAT ON
     C** RETURN CAN POSITION WITH THIS RECORD AT THE TOP OF THE SCREEN
     C*
     C                   MOVE      DDDLNO        @DNDLN                         ****4
     C                   MOVEL     @PRMDN        @STRNG                         ****4
     C*
     C                   MOVE      @TCRCY        @YCRCY                         ****4
     C                   MOVE      DDBRKR        @YBRKR                         ****4
     C                   MOVE      DDDLNO        @YDLNO                         ****4
     C                   MOVE      'Y'           @STIND            1            ****4
     C*
     C** SET THE SELECT FIELD FOR THE RECORD JUST PROCESSED TO BLANK
     C** AND UPDATE SUBFILE.
     C** SET ON THE SELECTION-PROCESSED INDICATOR FOR WHEN THIS
     C** PROGRAM IS RECALLED
     C*
     C                   MOVE      ' '           SSSLCT                         ****4
     C                   UPDATE    DL1902S1                                     ****4
     C*
     C                   MOVE      'Y'           @@SLCT                         ****4
     C*
     C** SET OFF INDICATORS 25 AND 26 (ROLLUP/ROLLDOWN) SO THAT IF
     C** PROGRAM RECALLED NEITHER WILL BE PROCESSED. BUT SET ON *IN05
     C** SO THAT AN EFFECTIVE REFRESH CAN TAKE PLACE FROM SELECTED
     C** RECORD
     C*
     C                   MOVE      '0'           *IN25                          ****4
     C                   MOVE      '0'           *IN26                          ****4
     C                   MOVE      '1'           *IN05                          ****4
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
     C** FOR THE ROLL/REFRESH/EXIT/SELECT KEYS AND TEXT.
     C** WRITE THE FOOTER FOR THE COMMAND KEYS TEXT.
     C*
     C     *IN27         IFEQ      '1'                                          B*2
     C                   MOVE      '0'           *IN27                          **2
     C*
     C                   WRITE     DL1902F1                                     **2
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
     C                   WRITE     DL1902F0                                     *1
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
     C*
      ** F7 - Toggle between 'Display Euro Equivalent' and
      ** 'Display Ccy Amount' is pressed (available only
      ** when Position/Risk Enquiries & Reports feature is on)
      *
     C     CEU012        IFEQ      'Y'
     C     @WINCY        IFEQ      'Y'
     C     *IN68         ANDEQ     '0'
     C                   MOVE      *ON           *IN31
     C                   ELSE
     C                   MOVE      *OFF          *IN31
     C                   ENDIF
      *
     C     @SCRCY        IFEQ      BKEUCP
     C     *IN68         ANDEQ     '0'
     C                   MOVE      *ON           *IN31
     C                   ENDIF
     C                   WRITE     DL1902F1
     C                   ENDIF
      *
     C** WRITE THE MESSAGE SUBFILE - IF THERE IS AN ERROR THERE
     C** WILL BE A MESSAGE TO DISPLAY OTHERWISE IT WILL REMOVE ANY
     C** PREVIOUS ERROR MESSAGES ON THE SCREEN
     C*
     C                   MOVE      '1'           *IN46
     C                   WRITE     DL1902C0
     C*
     C** WRITE THE ENQUIRY SUBFILE CONTROL; 'INVITE' WILL BE ACTIVATED
     C*
     C                   MOVE      '1'           *IN36
     C                   WRITE     DL1902C1
     C                   MOVE      '0'           *IN28
     C*
     C** DE-ACTIVATE THE OVRDTA INDICATOR FOR THE SELECT FIELDS IN
     C** CASE IT WAS ON IE. PROGRAM HAS BEEN RE-CALLED WITH NEW PROMPTS
     C** TO DISPLAY - DO NOT WANT TO KEEP WRITING THEM
     C*
     C                   MOVE      '0'           *IN24
     C*
     C** READ DSPF FOR ROLL/REFRESH/PROMPT; IF REFRESH ON PROMPT SCREEN
     C** (*IN27 AND *IN05 ON) THEN, SINCE REFRESH CANNOT BE DONE HERE,
     C** RE-READ THE DISPLAY FILE; IF REFRESH ON SUBFILE SCREEN THEN
     C** EXIT DO-LOOP.
     C*
     C     *IN27         DOUEQ     '0'                                          B1
     C     *IN05         OREQ      '0'                                          *1
     C*
     C                   MOVE      '0'           *IN05                          *1
     C************       READ      DL1902DF                             0573    CAAA02
      /free
         Now1Time = %time();                                                  //CAAA02
                                                                              //CAAA02
         read DL1902C1;                                                       //CAAA02
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
      *
      ** When F7 is pressed, change F7 text
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
     C                   WRITE     DL1902F1
      *
     C                   ENDIF
      *
      ** If F12 has been pressed
      **    ( this is necessary because this error cannot be
      **      processed in termination processing )
     C     *IN12         IFEQ      '1'
      *
      ** If program originally requested from DL1905
     C     @@TERM        IFEQ      'D'
      *
      ** If book or branch is 'ALL' process error
     C     @TBKCD        IFEQ      'ALL'
     C     @TBRCH        OREQ      'ALL'
      *
      ** Clear message queue
     C                   CALL      'ZA0250'
      *
      ** Add error message to message queue
     C                   MOVEL     'FIS0028'     @MSGID
     C                   CALL      'ZA0240'
     C                   PARM                    @MSGID
      *
      ** Set the error-message-to-display indicator
     C                   MOVE      'Y'           @@ERMS
      *
      ** Set of *IN12
     C                   MOVE      '0'           *IN12
      *
      ** Set on @FLAG so message queue is not cleared
     C                   MOVE      '1'           @FLAG             1
      *
     C                   END
     C                   END
     C                   END
     C*
     C** SET INDICATOR TO SHOW FROM WHERE ENQUIRY HAS COME TO 'L'
     C** FOR LOOPING INCASE ANOTHER ENQUIRY IS MADE FROM THIS PROGRAM
     C** AND SET ON FROM-STACK-BELOW INDICATOR
     C*
     C                   MOVE      'L'           @FROM
     C                   MOVE      'N'           @STIND
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
     C* FLDS USED  @KROL1 TO @KROL8 - KLIST FOR ROLLING ONE FOR EACH  *
     C*                               POSSIBLE DEALS FILE             *
     C*                                                               *
     C*            @KPRT1 TO @KPRT8 - KLIST FOR NEW PROMPTS ONE FOR   *
     C*                               EACH POSSIBLE DEALS FILE        *
     C*                                                               *
     C*            @@FILE - FILE TO BE USED FLAG                      *
     C*                                                               *
     C*****************************************************************
     C*
     C     #KA           BEGSR
     C*
     C                   SELECT
      *
      ** When Position/Risk Enquiries & Reports Feature is switched
      ** on, use the corresponding @KRLE* KLISTS defined in SR/#DA
      ** to set the lower limit for DLDLDEL1-8.
      *
     C     CEU012        WHENEQ    'Y'
     C                   SELECT
      *
     C     @@FILE        WHENEQ    '1'
     C     @KRLE1        SETLL     DLDLDEL1
      *
     C     @@FILE        WHENEQ    '2'
     C     @KRLE2        SETLL     DLDLDEL2
      *
     C     @@FILE        WHENEQ    '3'
     C     @KRLE3        SETLL     DLDLDEL3
      *
     C     @@FILE        WHENEQ    '4'
     C     @KRLE4        SETLL     DLDLDEL4
      *
     C     @@FILE        WHENEQ    '5'
     C     @KRLE5        SETLL     DLDLDEL5
      *
     C     @@FILE        WHENEQ    '6'
     C     @KRLE6        SETLL     DLDLDEL6
      *
     C     @@FILE        WHENEQ    '7'
     C     @KRLE7        SETLL     DLDLDEL7
      *
     C                   OTHER
      *
     C     @KRLE8        SETLL     DLDLDEL8
     C                   ENDSL
      *
      ** else, Position/Risk Enquiries & Reports feature is
      ** switched off, use DLDLDGL1-8 files.
     C                   OTHER
      *
     C** USE THE APPROPRIATE KEY TO SET LOWER LIMITS ON THE FILE
     C*
     C     @@FILE        IFEQ      '1'                                          B1
     C     @KROL1        SETLL     DLDLDGL1                                     *1
     C                   GOTO      #KA9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '2'                                          B1
     C     @KROL2        SETLL     DLDLDGL2                                     *1
     C                   GOTO      #KA9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '3'                                          B1
     C     @KROL3        SETLL     DLDLDGL3                                     *1
     C                   GOTO      #KA9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '4'                                          B1
     C     @KROL4        SETLL     DLDLDGL4                                     *1
     C                   GOTO      #KA9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '5'                                          B1
     C     @KROL5        SETLL     DLDLDGL5                                     *1
     C                   GOTO      #KA9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '6'                                          B1
     C     @KROL6        SETLL     DLDLDGL6                                     *1
     C                   GOTO      #KA9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '7'                                          B1
     C     @KROL7        SETLL     DLDLDGL7                                     *1
     C                   GOTO      #KA9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '8'                                          B1
     C     @KROL8        SETLL     DLDLDGL8                                     *1
     C                   GOTO      #KA9                                         *1
     C                   END                                                    E1
     C*
     C                   ENDSL
     C     #KA9          ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*
     C* #KB      - DETERMINE FILE - SETGT WITH ROLL KEY               *
     C*                                                               *
     C* CALLS                                                         *
     C*                                                               *
     C* CALLED BY  #B   -  MAIN PROCESSING                            *
     C*                                                               *
     C* FLDS USED  @KROL1 TO @KROL8 - KLIST FOR ROLLING ONE FOR EACH  *
     C*                               POSSIBLE DEALS FILE             *
     C*                                                               *
     C*            @KPRT1 TO @KPRT8 - KLIST FOR NEW PROMPTS ONE FOR   *
     C*                               EACH POSSIBLE DEALS FILE        *
     C*                                                               *
     C*            @@FILE - FILE TO BE USED FLAG                      *
     C*                                                               *
     C*****************************************************************
     C*
     C     #KB           BEGSR
     C*
     C                   SELECT
      *
      ** When Position/Risk Enquiries & Reports Feature is switched
      ** on, use the corresponding @KRLE* KLISTS defined in SR/#DA
      ** to SETGT files DLDLDEL1-8.
      *
     C     CEU012        WHENEQ    'Y'
     C                   SELECT
      *
     C     @@FILE        WHENEQ    '1'
     C     @KRLE1        SETGT     DLDLDEL1
      *
     C     @@FILE        WHENEQ    '2'
     C     @KRLE2        SETGT     DLDLDEL2
      *
     C     @@FILE        WHENEQ    '3'
     C     @KRLE3        SETGT     DLDLDEL3
      *
     C     @@FILE        WHENEQ    '4'
     C     @KRLE4        SETGT     DLDLDEL4
      *
     C     @@FILE        WHENEQ    '5'
     C     @KRLE5        SETGT     DLDLDEL5
      *
     C     @@FILE        WHENEQ    '6'
     C     @KRLE6        SETGT     DLDLDEL6
      *
     C     @@FILE        WHENEQ    '7'
     C     @KRLE7        SETGT     DLDLDEL7
      *
     C                   OTHER
      *
     C     @KRLE8        SETGT     DLDLDEL8
     C                   ENDSL
      *
      ** else, Position/Risk Enquiries & Reports feature is
      ** switched off, use DLDLDGL1-8 files.
     C                   OTHER
      *
     C** USE THE APPROPRIATE KEY TO SET GREATER LIMITS ON THE FILE
     C*
     C     @@FILE        IFEQ      '1'                                          B1
     C     @KROL1        SETGT     DLDLDGL1                                     *1
     C                   GOTO      #KB9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '2'                                          B1
     C     @KROL2        SETGT     DLDLDGL2                                     *1
     C                   GOTO      #KB9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '3'                                          B1
     C     @KROL3        SETGT     DLDLDGL3                                     *1
     C                   GOTO      #KB9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '4'                                          B1
     C     @KROL4        SETGT     DLDLDGL4                                     *1
     C                   GOTO      #KB9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '5'                                          B1
     C     @KROL5        SETGT     DLDLDGL5                                     *1
     C                   GOTO      #KB9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '6'                                          B1
     C     @KROL6        SETGT     DLDLDGL6                                     *1
     C                   GOTO      #KB9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '7'                                          B1
     C     @KROL7        SETGT     DLDLDGL7                                     *1
     C                   GOTO      #KB9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '8'                                          B1
     C     @KROL8        SETGT     DLDLDGL8                                     *1
     C                   GOTO      #KB9                                         *1
     C                   END                                                    E1
     C*
     C                   ENDSL
      *
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
     C* FLDS USED  @KROL1 TO @KROL8 - KLIST FOR ROLLING ONE FOR EACH  *
     C*                               POSSIBLE DEALS FILE             *
     C*                                                               *
     C*            @KPRT1 TO @KPRT8 - KLIST FOR NEW PROMPTS ONE FOR   *
     C*                               EACH POSSIBLE DEALS FILE        *
     C*                                                               *
     C*            @@FILE - FILE TO BE USED FLAG                      *
     C*                                                               *
     C*****************************************************************
     C*
     C     #KC           BEGSR
     C*
     C                   SELECT
      *
      ** When Position/Risk Enquiries & Reports Feature is switched
      ** on, use the corresponding @KPR* KLISTS defined in SR/#DA
      ** to READ records from files DLDLDEL1-8.
      *
     C     CEU012        WHENEQ    'Y'
     C     @SCRCY        ANDNE     BKEUCP
     C                   SELECT
      *
     C     @@FILE        WHENEQ    '1'
     C     @KPR1E        READE     DLDLDEL1                               71
      *
     C     @@FILE        WHENEQ    '2'
     C     @KPR2E        READE     DLDLDEL2                               71
      *
     C     @@FILE        WHENEQ    '3'
     C     @KPR3E        READE     DLDLDEL3                               71
      *
     C     @@FILE        WHENEQ    '4'
     C     @KPR4E        READE     DLDLDEL4                               71
      *
     C     @@FILE        WHENEQ    '5'
     C     @KPR5E        READE     DLDLDEL5                               71
      *
     C     @@FILE        WHENEQ    '6'
     C     @KPR6E        READE     DLDLDEL6                               71
      *
     C     @@FILE        WHENEQ    '7'
     C     @KPR7E        READE     DLDLDEL7                               71
      *
     C                   OTHER
      *
     C     @KPR8E        READE     DLDLDEL8                               71
     C                   ENDSL
      *
      ** When Position/Risk Enquiries & Reports Feature is switched
      ** on and input ccy is equal to Euro Consolidated ccy, read
      ** 'In' ccy records as well as Euro ccy records on file
      *
     C     CEU012        WHENEQ    'Y'
     C     @SCRCY        ANDEQ     BKEUCP
     C                   SELECT
      *
     C     @@FILE        WHENEQ    '1'
     C     *IN71         DOWEQ     '0'
     C                   READ      DLDLDEL1                               71
     C     *IN71         IFEQ      '0'
     C     BRKC          ANDEQ     @KBRKR
     C     BOKC          ANDEQ     @KBKCD
     C     BRCA          ANDEQ     @KBRCA
     C     INCY          IFEQ      'Y'
     C     UCUCY         OREQ      BKEURO
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C     @@FILE        WHENEQ    '2'
     C     *IN71         DOWEQ     '0'
     C                   READ      DLDLDEL2                               71
     C     *IN71         IFEQ      '0'
     C     BRKC          ANDEQ     @KBRKR
     C     BOKC          ANDEQ     @KBKCD
     C     INCY          IFEQ      'Y'
     C     UCUCY         OREQ      BKEURO
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C     @@FILE        WHENEQ    '3'
     C     *IN71         DOWEQ     '0'
     C                   READ      DLDLDEL3                               71
     C     *IN71         IFEQ      '0'
     C     BRKC          ANDEQ     @KBRKR
     C     BRCA          ANDEQ     @KBRCA
     C     INCY          IFEQ      'Y'
     C     UCUCY         OREQ      BKEURO
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C     @@FILE        WHENEQ    '4'
     C     *IN71         DOWEQ     '0'
     C                   READ      DLDLDEL4                               71
     C     *IN71         IFEQ      '0'
     C     BRKC          ANDEQ     @KBRKR
     C     INCY          IFEQ      'Y'
     C     UCUCY         OREQ      BKEURO
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C     @@FILE        WHENEQ    '5'
     C     *IN71         DOWEQ     '0'
     C                   READ      DLDLDEL5                               71
     C     *IN71         IFEQ      '0'
     C     BOKC          ANDEQ     @KBKCD
     C     BRCA          ANDEQ     @KBRCA
     C     INCY          IFEQ      'Y'
     C     UCUCY         OREQ      BKEURO
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C     @@FILE        WHENEQ    '6'
     C     *IN71         DOWEQ     '0'
     C                   READ      DLDLDEL6                               71
     C     *IN71         IFEQ      '0'
     C     BRCA          ANDEQ     @KBRCA
     C     INCY          IFEQ      'Y'
     C     UCUCY         OREQ      BKEURO
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C     @@FILE        WHENEQ    '7'
     C     *IN71         DOWEQ     '0'
     C                   READ      DLDLDEL7                               71
     C     *IN71         IFEQ      '0'
     C     BOKC          ANDEQ     @KBKCD
     C     INCY          IFEQ      'Y'
     C     UCUCY         OREQ      BKEURO
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C                   OTHER
      *
     C     *IN71         DOWEQ     '0'
     C                   READ      DLDLDEL8                               71
     C     *IN71         IFEQ      '0'
     C     INCY          IFEQ      'Y'
     C     UCUCY         OREQ      BKEURO
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
     C                   ENDSL
      *
      ** else, Position/Risk Enquiries & Reports feature is
      ** switched off, use DLDLDGL1-8 files.
     C                   OTHER
      *
     C** USE THE APPROPRIATE KEY TO READE ON THE FILE
     C*
     C     @@FILE        IFEQ      '1'                                          B1
     C     @KPR1A        READE     DLDLDGL1                               71    *1
     C                   GOTO      #KC9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '2'                                          B1
     C     @KPR2A        READE     DLDLDGL2                               71    *1
     C                   GOTO      #KC9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '3'                                          B1
     C     @KPR3A        READE     DLDLDGL3                               71    *1
     C                   GOTO      #KC9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '4'                                          B1
     C     @KPR4A        READE     DLDLDGL4                               71    *1
     C                   GOTO      #KC9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '5'                                          B1
     C     @KPR5A        READE     DLDLDGL5                               71    *1
     C                   GOTO      #KC9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '6'                                          B1
     C     @KPR6A        READE     DLDLDGL6                               71    *1
     C                   GOTO      #KC9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '7'                                          B1
     C     @KPR7A        READE     DLDLDGL7                               71    *1
     C                   GOTO      #KC9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '8'                                          B1
     C     @KPR8A        READE     DLDLDGL8                               71    *1
     C                   GOTO      #KC9                                         *1
     C                   END                                                    E1
     C*
     C                   ENDSL
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
     C*            #BC    - ENTER NEW PROMPT DATA                     *
     C*                                                               *
     C* FLDS USED  @KROL1 TO @KROL8 - KLIST FOR ROLLING ONE FOR EACH  *
     C*                               POSSIBLE DEALS FILE             *
     C*                                                               *
     C*            @KPRT1 TO @KPRT8 - KLIST FOR NEW PROMPTS ONE FOR   *
     C*                               EACH POSSIBLE DEALS FILE        *
     C*                                                               *
     C*            @@FILE - FILE TO BE USED FLAG                      *
     C*                                                               *
     C*****************************************************************
     C*
     C     #KD           BEGSR
     C*
     C                   SELECT
      *
      ** When Position/Risk Enquiries & Reports Feature is switched
      ** on, use the corresponding @KPRE* KLISTS defined in SR/#DA
      ** to SETLL files DLDLDEL1-8.
      *
     C     CEU012        WHENEQ    'Y'
     C     @SCRCY        ANDNE     BKEUCP
     C                   SELECT
      *
     C     @@FILE        WHENEQ    '1'
     C     @KPRE1        SETLL     DLDLDEL1
      *
     C     @@FILE        WHENEQ    '2'
     C     @KPRE2        SETLL     DLDLDEL2
      *
     C     @@FILE        WHENEQ    '3'
     C     @KPRE3        SETLL     DLDLDEL3
      *
     C     @@FILE        WHENEQ    '4'
     C     @KPRE4        SETLL     DLDLDEL4
      *
     C     @@FILE        WHENEQ    '5'
     C     @KPRE5        SETLL     DLDLDEL5
      *
     C     @@FILE        WHENEQ    '6'
     C     @KPRE6        SETLL     DLDLDEL6
      *
     C     @@FILE        WHENEQ    '7'
     C     @KPRE7        SETLL     DLDLDEL7
      *
     C                   OTHER
      *
     C     @KPRE8        SETLL     DLDLDEL8
     C                   ENDSL
      *
      ** When Position/Risk Enquiries & Reports Feature is switched
      ** on, use the corresponding position file on first record
      ** before reading file when input ccy is equal to
      ** Consolidated Euro ccy.
      *
     C     CEU012        WHENEQ    'Y'
     C     @SCRCY        ANDEQ     BKEUCP
     C                   SELECT
      *
     C     @@FILE        WHENEQ    '1'
     C     *LOVAL        SETLL     DLDLDEL1
      *
     C     @@FILE        WHENEQ    '2'
     C     *LOVAL        SETLL     DLDLDEL2
      *
     C     @@FILE        WHENEQ    '3'
     C     *LOVAL        SETLL     DLDLDEL3
      *
     C     @@FILE        WHENEQ    '4'
     C     *LOVAL        SETLL     DLDLDEL4
      *
     C     @@FILE        WHENEQ    '5'
     C     *LOVAL        SETLL     DLDLDEL5
      *
     C     @@FILE        WHENEQ    '6'
     C     *LOVAL        SETLL     DLDLDEL6
      *
     C     @@FILE        WHENEQ    '7'
     C     *LOVAL        SETLL     DLDLDEL7
      *
     C                   OTHER
      *
     C     *LOVAL        SETLL     DLDLDEL8
     C                   ENDSL
      *
      ** else, Position/Risk Enquiries & Reports feature is
      ** switched off, use DLDLDGL1-8 files.
     C                   OTHER
      *
     C** USE THE APPROPRIATE KEY TO SET LOWER LIMITS ON THE FILE
     C*
     C     @@FILE        IFEQ      '1'                                          B1
     C     @KPRT1        SETLL     DLDLDGL1                                     *1
     C                   GOTO      #KD9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '2'                                          B1
     C     @KPRT2        SETLL     DLDLDGL2                                     *1
     C                   GOTO      #KD9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '3'                                          B1
     C     @KPRT3        SETLL     DLDLDGL3                                     *1
     C                   GOTO      #KD9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '4'                                          B1
     C     @KPRT4        SETLL     DLDLDGL4                                     *1
     C                   GOTO      #KD9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '5'                                          B1
     C     @KPRT5        SETLL     DLDLDGL5                                     *1
     C                   GOTO      #KD9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '6'                                          B1
     C     @KPRT6        SETLL     DLDLDGL6                                     *1
     C                   GOTO      #KD9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '7'                                          B1
     C     @KPRT7        SETLL     DLDLDGL7                                     *1
     C                   GOTO      #KD9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '8'                                          B1
     C     @KPRT8        SETLL     DLDLDGL8                                     *1
     C                   GOTO      #KD9                                         *1
     C                   END                                                    E1
     C*
     C                   ENDSL
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
     C*            @SBRKR     - BROKER         )  FIELDS ENTERED IN   *
     C*            @SBKCD     - BOOK CODE      )  PROMPTS             *
     C*            @SBRCA     - BRANCH CODE    )                      *
     C*            @SVLDY     - VALUE DAY NO   )                      *
     C*                                                               *
     C*            UCUCY      - CURRENCY       )                      *
     C*            BRKC       - BROKER         )  FIELDS READ FROM    *
     C*            BOKC       - BOOK CODE      )  FILE (MUST          *
     C*            BRCA       - BRANCH CODE    )  PROMPTS)            *
     C*            VDAT       - VALUE DAY NO   )                      *
     C*                                                               *
     C*            @KROL1 TO @KROL8 - KLIST FOR ROLLING ONE FOR EACH  *
     C*                               POSSIBLE DEALS FILE             *
     C*                                                               *
     C*            @KPRT1 TO @KPRT8 - KLIST FOR NEW PROMPTS ONE FOR   *
     C*                               EACH POSSIBLE DEALS FILE        *
     C*                                                               *
     C*            @@FILE - FILE TO BE USED FLAG                      *
     C*                                                               *
     C*****************************************************************
     C*
     C     #KE           BEGSR
     C*
      ** Use files DLDLDEL1-8 when doing READP when
      ** Position/Risk Eqnuiries & Reports switchable
      ** feature is on.
      *
     C                   SELECT
     C     CEU012        WHENEQ    'Y'
      *
     C                   SELECT
     C     @@FILE        WHENEQ    '1'
     C                   READP     DLDLDEL1                               72
      *
      ** Record read must match fields entered in prompts
      *
     C     UCUCY         IFNE      @KCRCY
     C     VDAT          ORNE      @KVLDY
     C     BRKC          ORNE      @KBRKR
     C     BOKC          ORNE      @KBKCD
     C     BRCA          ORNE      @KBRCA
     C     BKEUCP        ORNE      @KCRCY
     C     UCUCY         ANDNE     @KCRCY
     C     BKEUCP        OREQ      @KCRCY
     C     INCY          ANDEQ     'N'
     C     UCUCY         ANDNE     BKEURO
     C                   MOVE      '1'           *IN72
     C                   ENDIF
      *
     C     @@FILE        WHENEQ    '2'
     C                   READP     DLDLDEL2                               72
      *
      ** Record read must match fields entered in prompts
      *
     C     UCUCY         IFNE      @KCRCY
     C     VDAT          ORNE      @KVLDY
     C     BRKC          ORNE      @KBRKR
     C     BOKC          ORNE      @KBKCD
     C     BKEUCP        ORNE      @KCRCY
     C     UCUCY         ANDNE     @KCRCY
     C     BKEUCP        OREQ      @KCRCY
     C     INCY          ANDEQ     'N'
     C     UCUCY         ANDNE     BKEURO
     C                   MOVE      '1'           *IN72
     C                   ENDIF
      *
     C     @@FILE        WHENEQ    '3'
     C                   READP     DLDLDEL3                               72
      *
      ** Record read must match fields entered in prompts
      *
     C     UCUCY         IFNE      @KCRCY
     C     VDAT          ORNE      @KVLDY
     C     BRKC          ORNE      @KBRKR
     C     BRCA          ORNE      @KBRCA
     C     BKEUCP        ORNE      @KCRCY
     C     UCUCY         ANDNE     @KCRCY
     C     BKEUCP        OREQ      @KCRCY
     C     INCY          ANDEQ     'N'
     C     UCUCY         ANDNE     BKEURO
     C                   MOVE      '1'           *IN72
     C                   ENDIF
      *
     C     @@FILE        WHENEQ    '4'
     C                   READP     DLDLDEL4                               72
      *
      ** Record read must match fields entered in prompts
      *
     C     UCUCY         IFNE      @KCRCY
     C     VDAT          ORNE      @KVLDY
     C     BRKC          ORNE      @KBRKR
     C     BKEUCP        ORNE      @KCRCY
     C     UCUCY         ANDNE     @KCRCY
     C     BKEUCP        OREQ      @KCRCY
     C     INCY          ANDEQ     'N'
     C     UCUCY         ANDNE     BKEURO
     C                   MOVE      '1'           *IN72
     C                   ENDIF
      *
     C     @@FILE        WHENEQ    '5'
     C                   READP     DLDLDEL5                               72
      *
      ** Record read must match fields entered in prompts
      *
     C     UCUCY         IFNE      @KCRCY
     C     VDAT          ORNE      @KVLDY
     C     BOKC          ORNE      @KBKCD
     C     BRCA          ORNE      @KBRCA
     C     BKEUCP        ORNE      @KCRCY
     C     UCUCY         ANDNE     @KCRCY
     C     BKEUCP        OREQ      @KCRCY
     C     INCY          ANDEQ     'N'
     C     UCUCY         ANDNE     BKEURO
     C                   MOVE      '1'           *IN72
     C                   ENDIF
      *
     C     @@FILE        WHENEQ    '6'
     C                   READP     DLDLDEL6                               72
      *
      ** Record read must match fields entered in prompts
      *
     C     UCUCY         IFNE      @KCRCY
     C     VDAT          ORNE      @KVLDY
     C     BRCA          ORNE      @KBRCA
     C     BKEUCP        ORNE      @KCRCY
     C     UCUCY         ANDNE     @KCRCY
     C     BKEUCP        OREQ      @KCRCY
     C     INCY          ANDEQ     'N'
     C     UCUCY         ANDNE     BKEURO
     C                   MOVE      '1'           *IN72
     C                   ENDIF
      *
     C     @@FILE        WHENEQ    '7'
     C                   READP     DLDLDEL7                               72
      *
      ** Record read must match fields entered in prompts
      *
     C     UCUCY         IFNE      @KCRCY
     C     VDAT          ORNE      @KVLDY
     C     BOKC          ORNE      @KBKCD
     C     BKEUCP        ORNE      @KCRCY
     C     UCUCY         ANDNE     @KCRCY
     C     BKEUCP        OREQ      @KCRCY
     C     INCY          ANDEQ     'N'
     C     UCUCY         ANDNE     BKEURO
     C                   MOVE      '1'           *IN72
     C                   ENDIF
      *
     C                   OTHER
     C                   READP     DLDLDEL8                               72
      *
      ** Record read must match fields entered in prompts
      *
     C     UCUCY         IFNE      @KCRCY
     C     VDAT          ORNE      @KVLDY
     C     BKEUCP        ORNE      @KCRCY
     C     UCUCY         ANDNE     @KCRCY
     C     BKEUCP        OREQ      @KCRCY
     C     INCY          ANDEQ     'N'
     C     UCUCY         ANDNE     BKEURO
     C                   MOVE      '1'           *IN72
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   OTHER
      *
     C** USE THE APPROPRIATE KEY TO READ THE PREVIOUS RECORD
     C** RECORD
     C*
     C     @@FILE        IFEQ      '1'                                          B1
     C                   READP     DLDLDGL1                               72    *1
     C*
     C** RECORD READ MUST MATCH FIELDS ENTERED IN PROMPTS
     C*
     C     UCUCY         IFNE      @KCRCY                                       B*2
     C     VDAT          ORNE      @KVLDY                                       **2
     C     BRKC          ORNE      @KBRKR                                       **2
     C     BOKC          ORNE      @KBKCD                                       **2
     C     BRCA          ORNE      @KBRCA
     C                   MOVE      '1'           *IN72                          **2
     C                   END                                                    E*2
     C*
     C                   GOTO      #KE9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '2'                                          B1
     C                   READP     DLDLDGL2                               72    *1
     C*
     C** RECORD READ MUST MATCH FIELDS ENTERED IN PROMPTS
     C*
     C     UCUCY         IFNE      @KCRCY                                       B*2
     C     VDAT          ORNE      @KVLDY                                       **2
     C     BRKC          ORNE      @KBRKR                                       **2
     C     BOKC          ORNE      @KBKCD                                       **2
     C                   MOVE      '1'           *IN72                          **2
     C                   END                                                    E*2
     C*
     C                   GOTO      #KE9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '3'                                          B1
     C                   READP     DLDLDGL3                               72    *1
     C*
     C** RECORD READ MUST MATCH FIELDS ENTERED IN PROMPTS
     C*
     C     UCUCY         IFNE      @KCRCY                                       B*2
     C     VDAT          ORNE      @KVLDY                                       **2
     C     BRKC          ORNE      @KBRKR                                       **2
     C     BRCA          ORNE      @KBRCA
     C                   MOVE      '1'           *IN72                          **2
     C                   END                                                    E*2
     C*
     C                   GOTO      #KE9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '4'                                          B1
     C                   READP     DLDLDGL4                               72    *1
     C*
     C** RECORD READ MUST MATCH FIELDS ENTERED IN PROMPTS
     C*
     C     UCUCY         IFNE      @KCRCY                                       B*2
     C     VDAT          ORNE      @KVLDY                                       **2
     C     BRKC          ORNE      @KBRKR                                       **2
     C                   MOVE      '1'           *IN72                          **2
     C                   END                                                    E*2
     C*
     C                   GOTO      #KE9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '5'                                          B1
     C                   READP     DLDLDGL5                               72    *1
     C*
     C** RECORD READ MUST MATCH FIELDS ENTERED IN PROMPTS
     C*
     C     UCUCY         IFNE      @KCRCY                                       B*2
     C     VDAT          ORNE      @KVLDY                                       **2
     C     BOKC          ORNE      @KBKCD                                       **2
     C     BRCA          ORNE      @KBRCA
     C                   MOVE      '1'           *IN72                          **2
     C                   END                                                    E*2
     C*
     C                   GOTO      #KE9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '6'                                          B1
     C                   READP     DLDLDGL6                               72    *1
     C*
     C** RECORD READ MUST MATCH FIELDS ENTERED IN PROMPTS
     C*
     C     UCUCY         IFNE      @KCRCY                                       B*2
     C     VDAT          ORNE      @KVLDY                                       **2
     C     BRCA          ORNE      @KBRCA
     C                   MOVE      '1'           *IN72                          **2
     C                   END                                                    E*2
     C*
     C                   GOTO      #KE9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '7'                                          B1
     C                   READP     DLDLDGL7                               72    *1
     C*
     C** RECORD READ MUST MATCH FIELDS ENTERED IN PROMPTS
     C*
     C     UCUCY         IFNE      @KCRCY                                       B*2
     C     VDAT          ORNE      @KVLDY                                       **2
     C     BOKC          ORNE      @KBKCD                                       **2
     C                   MOVE      '1'           *IN72                          **2
     C                   END                                                    E*2
     C*
     C                   GOTO      #KE9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '8'                                          B1
     C                   READP     DLDLDGL8                               72    *1
     C*
     C** RECORD READ MUST MATCH FIELDS ENTERED IN PROMPTS
     C*
     C     UCUCY         IFNE      @KCRCY                                       B*2
     C     VDAT          ORNE      @KVLDY                                       **2
     C                   MOVE      '1'           *IN72                          **2
     C                   END                                                    E*2
     C                   GOTO      #KE9                                         *1
     C                   END                                                    E1
     C*
     C                   ENDSL
      *
     C     #KE9          ENDSR
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
     C* FLDS USED  @KCRCY  -  CURRENCY       )                        *
     C*            @KBRKR  -  BROKER         )  STRING                *
     C*            @KBKCD  -  BOOK CODE      )  SENT IN PARAMETER     *
     C*            @KBRCA  -  BRANCH CODE    )                        *
     C*            @KVLDT  -  VALUE DATE     )                        *
     C*            @KVLDY  -  VALUE DAY NO   )                        *
     C*                                                               *
     C*            @SCRCY  -  CURRENCY       )                        *
     C*            @SBRKR  -  BROKER         )                        *
     C*            @SBKCD  -  BOOK CODE      )  SET UP IN PROMPTS     *
     C*            @SBRCA  -  BRANCH CODE    )                        *
     C*            @SVLDT  -  VALUE DATE     )                        *
     C*            @SVLDY  -  VALUE DAY NO   )                        *
     C*            @FBRCA  -  DEFAULT BRANCH CODE                     *
     C*            @FVLDT  -  DEFAULT VALUE DATE                      *
     C*            @FVLDY  -  DEFAULT VALUE DAY                       *
     C*            @FBKCD  -  DEFAULT BOOK CODE                       *
     C*                                                               *
     C*****************************************************************
     C*
     C     #AB           BEGSR
     C*
     C** LEAVE CURRENCY AS IT COMES - IF FROM MENU THEN BLANK AS NO
     C** DEFAULT GIVEN OR VALID FROM STACK - SAME FOR BROKER
     C*
     C                   MOVE      @KCRCY        @SCRCY
     C                   MOVE      @KBRKR        @SBRKR
     C*
     C** IF VALUE DATE BLANK THEN SET UP VALUE DATE WITH TODAYS
     C** DATE FROM THE INSTALLATION FILE
     C*
     C     @KVLDT        IFEQ      *BLANKS                                      B1
     C*
     C** Move date to ZADATE which is 7 chars long to be converted to
     C** 6 chars long (MMMDDYY/DDMMMYY to MMDDYY/DDMMYY)
     C                   MOVE      @FVLDT        ZADATE
     C                   MOVE      '0'           *IN18
     C                   EXSR      CVDT
     C                   MOVE      ZDATE         @SVLDT
     C                   Z-ADD     @FVLDY        @SVLDY            5 0          *1
     C                   ELSE                                                   X1
     C*
     C** Move date to ZADATE which is 7 chars long to be converted to
     C** 6 chars long (MMMDDYY/DDMMMYY to MMDDYY/DDMMYY)
     C                   MOVE      @KVLDT        ZADATE
     C                   MOVE      '0'           *IN18
     C                   EXSR      CVDT
     C                   MOVE      ZDATE         @SVLDT
     C                   Z-ADD     @KVLDY        @SVLDY                         *1
     C                   END                                                    E1
      *
      ** If from menu, set screen fields to default values
     C     @FROM         IFEQ      'M'
     C                   MOVE      @FBRCA        @SBRCA
     C                   MOVE      @FBKCD        @SBKCD
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
      ** If passed book is blank, set screen book to 'ALL'
     C     @KBKCD        IFEQ      *BLANKS
     C                   MOVE      'ALL'         @SBKCD
     C                   ELSE
      *
      ** Else set screen book as passed
     C                   MOVE      *BLANKS       @SBKCD
     C                   MOVE      @KBKCD        @SBKCD
     C                   END
      *
     C                   END
      *
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
     C*            DLRCRD  -  RECORD DATA OFF DEALS FILE (DATA STRUCT)*
     C*            @MSGID -   ERROR MESSAGE NUMBER TO SEND TO ZA0240  *
     C*                                                               *
     C*****************************************************************
     C*
     C     #BA           BEGSR
     C*
     C** DO FOR AS MANY RECORDS AS THERE ARE IN THE SUBFILE PAGE
     C*
     C                   Z-ADD     1             RRN               2 0
     C*
     C     RRN           DOUEQ     17                                           B1
     C*
     C** READ THE DEALS FILE
     C*
     C                   EXSR      #KC                                          *1
     C     CEU012        IFEQ      'Y'
     C                   MOVE      INCY          @WINCY
     C                   ENDIF
     C*
     C     *IN71         IFEQ      '1'                                          B*2
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
     C                   WRITE     DL1902C1                                     ***3
     C*
     C                   MOVE      '0'           *IN30                          ***3
     C                   MOVE      DLRCRD        @TOPRD           42            ***3
     C*
     C                   END                                                    E**3
     C*
     C** STORE THE RECORD AS THE LAST ONE IN CASE THERE ARE NO MORE
     C*
     C                   MOVE      DLRCRD        @BOTRD           42            **2
     C*
     C** EDIT THE FIELDS AND THEN WRITE THE RECORD TO THE SUBFILE
     C*
     C                   EXSR      #BD                                          **2
     C                   WRITE     DL1902S1                                     **2
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
     C                   EXSR      #KE                                          *1
     C*
     C     *IN72         IFEQ      '1'                                          B*2
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
     C** BEGINNING OF FILE OR DATA (#KD). PROCESS AS FOR A ROLLUP
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
     C                   WRITE     DL1902C1                                     ***3
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
     C                   WRITE     DL1902S1                                     **2
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
     C                   END                                                    E1
     C*
     C** IF THERE ARE NO ERRORS
     C*
     C     @@ERMS        IFNE      'Y'                                          B1
     C*
     C** SET UP FILE-TO-USE-FLAG AND POSITION ON FILE AT BEGINNING
     C** OF PROMPTS (#KD) AND PROCESS A NEW SUBFILE
     C*
     C                   EXSR      #BCC                                         *1
     C*
      *
      ** Set up branch key field
     C                   MOVE      @SBRCA        @KBRCA
      *
      ** Set up book key field
     C                   MOVE      @SBKCD        @KBKCD
      *
      ** Set up currency key field
     C                   MOVE      @SCRCY        @KCRCY
      *
      ** Set up broker key field
     C                   MOVE      @SBRKR        @KBRKR
      *
      ** Set up Sort Sequence number Key field
      *
     C     CEU012        IFEQ      'Y'
     C     @FROM         ANDNE     'S'
     C                   MOVE      A6SSNB        @KSSNB
     C                   MOVE      A6SSNB        SSNB
     C                   ENDIF
     C*
     C** Convert date format from MMDDYY/DDMMYY to MMMDDYY/DDMMMYY
     C                   MOVE      @SVLDT        ZDATE
     C                   MOVE      '1'           *IN18
     C                   EXSR      CVDT
      *
      ** Set up value date key field
     C                   MOVE      ZADATE        @KVLDT
      *
      * Set up value day no. key field
     C                   MOVE      @SVLDY        @KVLDY
      *
     C                   EXSR      #KD                                          *1
     C*
     C** DO FOR AS MANY RECORDS AS THERE ARE IN THE SUBFILE PAGE
     C*
     C                   Z-ADD     1             RRN               2 0          *1
     C*
     C     RRN           DOUEQ     17                                           B*2
     C*
     C** READ THE DEALS FILE
     C*
     C                   EXSR      #KC                                          **2
     C     CEU012        IFEQ      'Y'
     C                   MOVE      INCY          @WINCY
     C                   ENDIF
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
     C                   WRITE     DL1902C1                                     ****4
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
      *
     C** EDIT THE FIELDS AND THEN WRITE THE RECORD TO THE SUBFILE
     C*
     C                   EXSR      #BD                                          ***3
     C                   WRITE     DL1902S1                                     ***3
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
     C* CALLS    - ZVLDT  - EDIT VALUE DATE                           *
     C*            ZA0240 - ADD A MESSAGE TO THE PROGRAM MESSAGE QUEUE*
     C*                                                               *
     C* CALLED BY  #BC - ENTER NEW PROMPT DATA                        *
     C*                                                               *
     C* FLDS USED  @SCRCY  -  CURRENCY SELECTED IN PROMPTS            *
     C*            @SBRCA  -  BRANCH SELECTED IN PROMPTS              *
     C*            @SVLDT  -  VALUE DATE SELECTED IN PROMPTS          *
     C*            @SVLDY  -  VALUE MIDAS DAY NO SELECTED IN PROMPTS  *
     C*            @SBKCD  -  BOOK CODE SELECTED IN PROMPTS           *
     C*            @SBRKR  -  BROKER SELECTED IN PROMPTS              *
     C*            @@ERMS - ERROR-MESSAGE-TO-DISPLAY INDICATOR - Y/N  *
     C*            @MSGID - ERROR MESSAGE NUMBER TO SEND TO ZA0240    *
     C*                                                               *
     C*****************************************************************
     C*
     C     #BCA          BEGSR
     C*
     C** VALIDATE THE VALUE DATE
      *
      * If field is blank use run date (default)
     C*
     C     @SVLDT        IFEQ      *BLANK                                       B1
     C*
     C** Convert date from MMMDDYY/DDMMMYY to MMDDYY/DDMMYY
     C                   MOVE      @FVLDT        ZADATE
     C                   MOVE      '0'           *IN18
     C                   EXSR      CVDT
     C                   MOVE      ZDATE         @SVLDT
     C                   END
      *
     C** IF NOT RUN DATE (DEFAULT) THEN VALIDATE THE DATE
     C*
     C** Convert date from MMMDDYY/DDMMMYY to MMDDYY/DDMMYY format
     C                   MOVE      @FVLDT        ZADATE
     C                   MOVE      '0'           *IN18
     C                   EXSR      CVDT
     C                   MOVE      ZDATE         ZDATE6            6
     C     @SVLDT        IFNE      ZDATE6
     C                   MOVE      @SVLDT        ZDATE             6 0
     C                   MOVE      ZDATE         ZDATE6            6
     C*
     C** If entered date is non-numeric, set *IN99 on for error message
     C     @SVLDT        IFNE      ZDATE6
     C                   MOVE      '1'           *IN99
     C*
     C** If entered date is numeric, validate date entered. *IN99 is
     C** set on if error in validation, if successful store no. of days
     C                   ELSE
                                                                                CAAA02
      * Subroutine replaced by external module                                  CAAA02
     C************       EXSR      ZDATE1                                       CAAA02
     C************       MOVE      ZDAYNO        @@DAYN                         CAAA02
     c                   callb     'ZDATE1'                                     CAAA02
     c                   parm                    @SVLDT                         CAAA02
     c                   parm                    @@DAYN                         CAAA02
     c                   parm                    BJDFIN                         CAAA02
     c                   parm                    ZErrorFlag                     CAAA02
     c                   if        ZErrorFlag = 'Y'                             CAAA02
     c                   eval      *in99 = '1'                                  CAAA02
     c                   endif                                                  CAAA02
                                                                                CAAA02
     C                   END
     C*
     C     *IN99         IFEQ      '1'                                          B**3
     C*
     C** SET UP PARAMETER FOR ZA0240 AND CALL THE PROGRAM TO ADD
     C** ANOTHER MESSAGE TO THE PROGRAM MESSAGE QUEUE
     C*
     C                   MOVEL     'FIS0007'     @MSGID           10            ***3
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
     C** Ensure that value date field does not have embedded blanks
     C                   MOVE      @SVLDT        ZDATE             6 0
     C                   MOVE      ZDATE         @SVLDT
     C                   MOVE      '1'           *IN24
     C*
     C** If Value Date is valid then check that it is later then today
     C*
     C     @@DAYN        IFLT      @FVLDY                                       B***4
     C*
     C** SET UP PARAMETER FOR ZA0240 AND CALL THE PROGRAM TO ADD
     C** ANOTHER MESSAGE TO THE PROGRAM MESSAGE QUEUE
     C*
     C                   MOVEL     'FIS0010'     @MSGID           10            ****4
     C                   CALL      'ZA0240'                                     ****4
     C                   PARM                    @MSGID                         ****4
     C*
     C** SET ON ERROR-ON-VALUE-DATE AND ERROR-ON-VALIDATION INDICATORS
     C*
     C                   MOVE      '1'           *IN62                          ****4
     C                   MOVE      '1'           *IN69                          ****4
     C*
     C                   ELSE                                                   X***4
     C                   Z-ADD     @@DAYN        @SVLDY                         ****4
     C                   END                                                    E***4
     C*
     C                   END                                                    E**3
     C*
     C                   ELSE                                                   X*2
     C*
     C** ELSE IF DEFAULT DATE THEN SET UP WITH DEFAULT MIDAS DAY NO
     C*
     C                   Z-ADD     @FVLDY        @SVLDY                         **2
     C*
     C                   END                                                    E*2
     C*
     C*
      *
      ** Switch off *IN31 so that F7 will not be displayed
      ** until input ccy is validated as an 'In' ccy
      *
     C     CEU012        IFEQ      'Y'
     C                   MOVE      *OFF          *IN31
     C                   ENDIF
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
     C*
      ** If Position/Risk Enquiries & Reports Feature is
      ** on and input ccy is the Consolidated Euro ccy defined
      ** in GL ICD, no error.
      *
     C     CEU012        IFEQ      'N'
     C     @SCRCY        ANDNE     BKEUCP
      *
     C** SET UP PARAMETER FOR ZA0240 AND CALL THE PROGRAM TO ADD
     C** ANOTHER MESSAGE TO THE PROGRAM MESSAGE QUEUE
     C*
     C                   MOVEL     'FIS0001'     @MSGID           10            **2
     C                   CALL      'ZA0240'                                     **2
     C                   PARM                    @MSGID                         **2
     C*
     C** SET ON ERROR-ON-VALIDATION INDICATOR
     C*
     C                   MOVE      '1'           *IN60
     C                   MOVE      '1'           *IN69                          **2
     C                   ENDIF
     C*
     C** ELSE STORE THE CURRENCY DECIMAL PLACES FOR LATER USE IN ZFRPED
     C*
     C                   ELSE                                                   X*2
     C*
     C                   Z-ADD     A6NBDP        ZDECS
     C*
      ** Move validated currency code to screen field and
      **      set up *in24 to update screen fields
     C                   MOVEL     A6CYCD        @SCRCY
     C                   MOVE      '1'           *IN24
      *
      ** Set up currency decimal places and
      **     default interest calculation basis.
     C                   MOVE      A6NBDP        CDP
     C                   MOVE      A6DICB        DICM
                                                                                CAAA02
      * Subroutine replaced by external module                                  CAAA02
     C************       Z-ADD     A6MMSD        ZZDTIN                         CAAA02
     C************       EXSR      ZDAT10                                       CAAA02
     C************       Z-ADD     ZZMDNO        SPOT              5 0          CAAA02
     c                   callb     'ZDATE10'                                    CAAA02
     c                   parm                    A6MMSD                         CAAA02
     c                   parm                    SPOT                           CAAA02
                                                                                CAAA02
     C     CEU012        IFEQ      'Y'
     C                   MOVE      A6INCY        @WINCY
     C                   ENDIF
      *
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
      ** If screen book code is not 'ALL'
     C     @SBKCD        IFNE      'ALL'
      *
      ** Move screen book code into work field so that each
      **      position can be examined
     C                   MOVE      *BLANKS       @WBOOK
     C                   MOVE      @SBKCD        @WBOOK
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
     C                   ELSE                                                                 216647
     C                   MOVE      BDBKCD        @SBKCD                                       216647
     C                   MOVE      '1'           *IN24                                        216647
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
     C                   MOVE      *BLANKS       @SBKCD
     C                   MOVE      BDBKCD        @SBKCD
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
     C*
     C** VALIDATE THE BROKER CODE
     C** - IF ENTERED THEN MUST EXIST ON BROKER FILE
     C*
     C     @SBRKR        IFNE      *BLANKS                                      B1
     C     @SBRKR        ANDNE     'TELX'                                       *1
     C     @SBRKR        ANDNE     'PHON'                                       *1
     C     @SBRKR        ANDNE     'MAIL'                                       *1
      *
      ** Call Access Program for Broker Details to check
      **      broker code exists
     C                   CALL      'AOBROKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      @SBRKR        @BRKR             4
     C     SDBROK        PARM      SDBROK        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C*
     C** SET UP PARAMETER FOR ZA0240 AND CALL THE PROGRAM TO ADD
     C** ANOTHER MESSAGE TO THE PROGRAM MESSAGE QUEUE
     C*
     C                   MOVEL     'FIS0008'     @MSGID                         **2
     C                   CALL      'ZA0240'                                     **2
     C                   PARM                    @MSGID                         **2
     C*
     C** SET ON ERROR-ON-VALIDATION INDICATORS
     C*
     C                   MOVE      '1'           *IN63
     C                   MOVE      '1'           *IN69                          **2
      *
     C                   ELSE
      *
      ** If broker code found, set up screen broker code and
      **    set up *in24 so screen fields are updated
     C                   MOVE      A9BROK        @SBRKR
     C                   MOVE      '1'           *IN24
     C*
     C                   END                                                    E*2
     C*
     C                   END                                                    E1
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
     C                   MOVE      '1'           *IN61
     C                   END
      *
     C                   END
     C                   END
      *
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
     C*            @TBRKR - BROKER     )                              *
     C*            @TVLDT - VALUE DATE )                              *
     C*                                                               *
     C*            @SCRCY - CURRENCY   )                              *
     C*            @SBRCA - BRANCH     )  VALID ENTRIES RECEIVED      *
     C*            @SBRKR - BROKER     )  FROM PROMPTS                *
     C*            @SBKCD - BOOK CODE  )                              *
     C*            @SVLDT - VALUE DATE )                              *
     C*                                                               *
     C*            @@ERMS - ERROR-MESSAGE-TO-DISPLAY INDICATOR - Y/N  *
     C*            @MSGID - ERROR MESSAGE NUMBER TO SEND TO ZA0240    *
     C*                                                               *
     C*****************************************************************
     C*
     C     #BCB          BEGSR
      *
      ** Set up heading for book code
     C     @SBKCD        IFEQ      'ALL'
     C                   MOVE      @SBKCD        @TBKCD
     C                   ELSE
     C                   MOVE      *BLANKS       @TBKCD
     C                   MOVE      @SBKCD        @@BKCD            2
     C                   MOVEL     @@BKCD        @TBKCD
     C                   END
     C*
     C** SET UP HEADING FOR CURRENCY
     C** - THE SAME AS THE VALID PROMPT ENTRY
     C*
     C                   MOVE      @SCRCY        @TCRCY
     C*
     C** ALSO STORE DEFAULT INTEREST CALCULATION METHOD AND CURRENCY
     C** DEC PLACES SENT UP IN STACK LATER (BUT NOT SHOWN ON SCREEN)
     C*
     C                   Z-ADD     DICM          @@DICM            1 0
     C                   Z-ADD     CDP           @@CDP             1 0
     C                   Z-ADD     SPOT          WSPOT             5 0
     C*
     C** SET UP HEADING FOR BRANCH
     C** - 'ALL' IF BLANK ENTERED ELSE SAME AS THE VALID PROMPT ENTRY
     C*
     C                   MOVE      @SBRCA        @TBRCH
     C*
     C** SET UP HEADING FOR BROKER
     C** - 'ALL' IF BLANK ENTERED ELSE SAME AS THE VALID PROMPT ENTRY
     C*
     C     @SBRKR        IFEQ      *BLANKS                                      B1
     C                   MOVE      'ALL '        @TBRKR                         *1
     C                   ELSE                                                   X1
     C                   MOVE      @SBRKR        @TBRKR                         *1
     C                   END                                                    E1
     C*
     C** SET UP HEADING FOR VALUE DATE
     C** - SAME AS THE VALID PROMPT ENTRY
     C*
     C*
     C** Convert date format from DDMMYY/MMDDYY to DDMMMYY/MMMDDYY
     C                   MOVE      @SVLDT        ZDATE
     C                   MOVE      '1'           *IN18
     C                   EXSR      CVDT
     C                   MOVE      ZADATE        @TVLDT
     C*
     C     #BCB9         ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #BCC     - DETERMINE FILE AND KEY TO BE USED WITH PROMPTS     *
     C*                                                               *
     C* CALLS                                                         *
     C*                                                               *
     C* CALLED BY  #BC  -  ENTER NEW PROMPT DATA                      *
     C*                                                               *
     C* FLDS USED  @@FILE - FIELD  TO BE USED FLAG (1 TO 8)           *
     C*                                                               *
     C*            @SBRKR - BROKER FIELD) KEY TO BE DETERMINED        *
     C*            @SBKCD - BOOK CODE   ) ACCORDING TO COMBINATION    *
     C*            @SBRCA - BRANCH      ) OF FIELDS SELECTED          *
     C*                                                               *
     C*****************************************************************
     C*
     C     #BCC          BEGSR
     C*
     C** DECIDE WHICH FILE IS TO BE USED - DEPENDING ON PROMPTS INPUT
     C** AS FOLLOWS.
     C*
     C*   **************************************************
     C*   *              BROKER         BOOK        BRANCH *
     C*   *                                                *
     C*   * DLDLDGL1       X             X            X    *
     C*   * DLDLDGL2       X             X                 *
     C*   * DLDLDGL3       X                          X    *
     C*   * DLDLDGL4       X                               *
     C*   * DLDLDGL5                     X            X    *
     C*   * DLDLDGL6                                  X    *
     C*   * DLDLDGL7                     X                 *
     C*   * DLDLDGL8                                       *
     C*   **************************************************
     C*
     C     @SBRKR        IFNE      *BLANKS                                      B1
     C     @SBKCD        ANDNE     'ALL'
     C     @SBKCD        ANDNE     *BLANKS
     C     @SBRCA        ANDNE     'ALL'
     C     @SBRCA        ANDNE     *BLANKS
     C                   MOVE      '1'           @@FILE            1            *1
     C                   GOTO      #BCC9                                        *1
     C                   END                                                    E1
     C*
     C     @SBRKR        IFNE      *BLANKS                                      B1
     C     @SBKCD        ANDNE     'ALL'
     C     @SBKCD        ANDNE     *BLANKS
     C     @SBRCA        ANDEQ     'ALL'
     C                   MOVE      '2'           @@FILE                         *1
     C                   GOTO      #BCC9                                        *1
     C                   END                                                    E1
     C*
     C     @SBRKR        IFNE      *BLANKS                                      B1
     C     @SBKCD        ANDEQ     'ALL'
     C     @SBRCA        ANDNE     'ALL'
     C     @SBRCA        ANDNE     *BLANKS
     C                   MOVE      '3'           @@FILE                         *1
     C                   GOTO      #BCC9                                        *1
     C                   END                                                    E1
     C*
     C     @SBRKR        IFNE      *BLANKS                                      B1
     C     @SBKCD        ANDEQ     'ALL'
     C     @SBRCA        ANDEQ     'ALL'
     C                   MOVE      '4'           @@FILE                         *1
     C                   GOTO      #BCC9                                        *1
     C                   END                                                    E1
     C*
     C     @SBRKR        IFEQ      *BLANKS                                      B1
     C     @SBKCD        ANDNE     'ALL'
     C     @SBKCD        ANDNE     *BLANKS
     C     @SBRCA        ANDNE     'ALL'
     C     @SBRCA        ANDNE     *BLANKS
     C                   MOVE      '5'           @@FILE                         *1
     C                   GOTO      #BCC9                                        *1
     C                   END                                                    E1
     C*
     C     @SBRKR        IFEQ      *BLANKS                                      B1
     C     @SBKCD        ANDEQ     'ALL'
     C     @SBRCA        ANDNE     'ALL'
     C     @SBRCA        ANDNE     *BLANKS
     C                   MOVE      '6'           @@FILE                         *1
     C                   GOTO      #BCC9                                        *1
     C                   END                                                    E1
     C*
     C     @SBRKR        IFEQ      *BLANKS                                      B1
     C     @SBKCD        ANDNE     'ALL'
     C     @SBKCD        ANDNE     *BLANKS
     C     @SBRCA        ANDEQ     'ALL'
     C                   MOVE      '7'           @@FILE                         *1
     C                   GOTO      #BCC9                                        *1
     C                   END                                                    E1
     C*
     C     @SBRKR        IFEQ      *BLANKS                                      B1
     C                   MOVE      '8'           @@FILE                         *1
     C                   GOTO      #BCC9                                        *1
     C                   END                                                    E1
     C*
     C     #BCC9         ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #BD      - EDIT ENQUIRY SUBFILE DATA                          *
     C*                                                               *
     C* CALLS      ZDATE8  -  EDIT DATE USING MONTH SHORTNAMES IN FILE*
     C*            ZFRPED  -  EDIT AMOUNT                             *
     C*            ZRATE1  -  EDIT CONTRACT RATE                      *
     C*            *PSSR   -  DATABASE ERROR HANDLING                 *
     C*                                                               *
     C* CALLED BY  #BA     -  ROLLUP ENQUIRY SUBFILE                  *
     C*            #BB     -  ROLLDOWN ENQUIRY SUBFILE                *
     C*            #BC     -  ENTER NEW PROMPT DATA                   *
     C*                                                               *
     C* FLDS USED  DDBRKR  -  BROKER        )                         *
     C*            DDMTDY  -  MATURITY DAY NO)                        *
     C*            DDBSRT  -  BASE RATE     )  DISPLAY FIELDS FOR THE *
     C*            DDDLNO  -  DEAL NUMBER   )  ENQUIRY SUBFILE        *
     C*            DDFIX   -  FIX           )                         *
     C*            DDCLNT  -  CLIENT        )                         *
     C*            DDAMNT  -  AMOUNT        )                         *
     C*            DDCNTR  -  CONTRACT RATE )                         *
     C*                                                               *
     C*            BRKC    -  BROKER        )                         *
     C*            MDAT    -  MATURITY DAY NO)                        *
     C*            BRSQ    -  BASE RATE     )  FIELDS FROM DEALS      *
     C*            DLNO    -  DEAL NUMBER   )  FILE TO BE EDITED      *
     C*            UFRFD   -  RATE FIX DAYS )  BEFORE DISPLAY IN THE  *
     C*            CNUM    -  CLIENT        )  ENQUIRY SUBFILE        *
     C*            UPAMT   -  AMOUNT        )                         *
     C*            UEINR   -  OUR EFFECTIVE RATE  )        CONTRACT   *
     C*            TEINR   -  THEIR EFFECTIVE RATE)        RATE       *
     C*                                                               *
     C*            @YBOKC  -  HIDDEN FIELD / BOOK CODE                *
     C*            @YBRCA  -  HIDDEN FIELD / BRANCH CODE - MIDAS      *
     C*            @YVDAT  -  HIDDEN FIELD / VALUE DATE - MIDAS       *
     C*            @YMDAT  -  HIDDEN FIELD / MATURITY DATE - MIDAS    *
     C*            @YBRSQ  -  HIDDEN FIELD / BASE RATE                *
     C*                                                               *
     C*****************************************************************
     C*
     C     #BD           BEGSR
     C*
     C** SET UP HIDDEN FIELDS (USED TO SET UP @BOTRD IF SELECTION MADE)
     C*
     C                   MOVE      BOKC          @YBOKC
     C                   MOVE      BRCA          @YBRCA
     C                   MOVE      VDAT          @YVDAT
     C                   MOVE      MDAT          @YMDAT
     C                   MOVE      BRSQ          @YBRSQ
     C*
     C** EDIT THE DISPLAY FIELDS FOR SUBFILE BEFORE WRITING TO IT.
     C** ANY FIELDS THAT DO NOT NEED EDITING CAN JUST BE MOVED
     C** DIRECTLY INTO THEIR EQUIVALENT FIELD IN THE DISPLAY FILE
     C*
     C** BROKER DOES NOT NEED EDITING
     C*
     C                   MOVE      BRKC          DDBRKR
     C*
     C** EDIT THE MATURITY DATE BEFORE OUTPUT TO SCREEN
     C** SET UP MIDAS DAY NO INPUT PARAMETER. *IN98 SET UP PREVIOUSLY
     C** ACCORDING TO THE DATE FORMAT INDICATOR.
     C*
     C                   Z-ADD     MDAT          ZDAYNO
     C                   EXSR      ZDATE8
     C                   MOVE      ZADATE        DDMTDT
     C     BJDFIN        IFEQ      'M'
     C                   MOVEL     DDMTDT        WRK5              5
     C                   MOVEL     WRK5          WRK3              3
     C                   MOVE      WRK5          WRK2              2
     C                   MOVEL     WRK2          WRK5
     C                   MOVE      WRK3          WRK5
     C                   MOVEL     WRK5          DDMTDT
     C                   END
     C*
     C** EDIT THE BASE RATE BEFORE OUTPUT TO SCREEN
      *
      ** Move the base rate into an alpha field
     C                   MOVE      BRSQ          @BSRT             2
      *
      ** Setup Key field to be used when calling AOBSRTR0.
      ** Key field must be equal to the 'In' ccy read from file
      ** when screen ccy input is Cons Euor ccy.
      *
     C     CEU012        IFEQ      'Y'
     C     @SCRCY        ANDEQ     BKEUCP
     C                   MOVE      UCUCY         @KCRCY
     C                   ENDIF
      *
      ** Call Access Program for Base Rate Details
     C                   CALL      'AOBSRTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      @KCRCY        @CCY              3
     C                   PARM      @BSRT         @BBSRT            2
     C     SDBSRT        PARM      SDBSRT        DSSDY
      *
      ** If Base Rate not found
     C     @RTCD         IFNE      *BLANK
     C*                                                    ***************
     C                   MOVEL     'SDBSRTPD'    DBFILE                         *             *
     C                   MOVEL     @SCRCY        DBKEY                          * DBERROR 003 *
     C                   MOVE      @BSRT         DBKEY                          *             *
     C                   Z-ADD     3             DBASE
     C*                                                    ***************
     C                   EXSR      *PSSR                                        *1
     C                   END                                                    E1
     C*
     C                   MOVE      BABSRS        DDBSRT
     C*
     C** DEAL NO DOES NOT NEED EDITING
     C*
     C                   MOVE      DLNO          DDDLNO
     C*
     C** RATE FIX DAY DOES NOT NEED EDITING
     C*
     C     BYSL          IFEQ      'S'
     C                   MOVE      UFRFD         DDFIX
     C                   ELSE
     C                   MOVE      TFRFD         DDFIX
     C                   END
     C*
     C** EDIT THE CLIENT BEFORE OUTPUT TO THE SCREEN
     C*
     C*
     C                   MOVE      CNUM          @CNUM             6
      ** Call Access Program for Customer Details using the
      **      Customer Shortname.
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      @CNUM         @KEY1            10
     C                   PARM      *BLANKS       @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     @RTCD         IFNE      *BLANK
     C*                                                    ***************
     C                   MOVEL     'SDCUSTPD'    DBFILE                         *             *
     C                   MOVEL     CNUM          DBKEY                          * DBERROR 004 *
     C                   Z-ADD     4             DBASE
     C*                                                    ***************
     C                   EXSR      *PSSR                                        *1
     C                   END                                                    E1
     C*
     C                   MOVE      BBCSSN        DDCLNT
     C*
      *
      ** Get 'In' ccy number of decimal places for
      ** formatting 'In' ccy amounts.
      *
     C     CEU012        IFEQ      'Y'
     C     @SCRCY        IFEQ      BKEUCP
     C                   Z-ADD     1             X
     C     UCUCY         LOOKUP    WCY(X)                                 33
     C     *IN33         IFEQ      *ON
     C                   MOVE      WDC(X)        ZDECS
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVE      'N'           SCHCK             1
     C     @SCRCY        IFEQ      BKEUCP
     C     *IN32         IFEQ      '0'
     C                   MOVE      'Y'           SCHCK
     C                   ENDIF
     C                   ENDIF
      *
      ** Convert 'In' ccy amounts
      *
     C     SCHCK         IFEQ      'N'
     C     INCY          IFEQ      'Y'
     C     *IN32         ANDEQ     *ON
     C     @SCRCY        OREQ      BKEUCP
     C     UCUCY         ANDNE     BKEURO
     C                   MOVE      *BLANKS       PRTCD
     C                   Z-ADD     UPAMT         PFRAM
     C                   MOVE      UCUCY         PFRCY
     C                   MOVE      BKEURO        PTOCY
     C                   Z-ADD     0             POUTA
     C                   Z-ADD     0             PINTA
     C                   Z-ADD     0             PEXRT
     C                   MOVE      *BLANKS       PMDIN
      *
     C                   CALL      'EU0200'                             1010
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
     C                   Z-ADD     POUTA         UPAMT
     C                   ELSE
     C                   MOVEL     '*CALL   '    DBFILE
     C                   MOVEL     'EU0200  '    DBKEY                           ************
     C                   Z-ADD     2             DBASE                           * DBERR 02 *
     C                   EXSR      *PSSR                                         ************
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C** EDIT THE AMOUNT BEFORE OUTPUT TO THE SCREEN.
     C** SET UP AMOUNT FIELD AND EDIT CODE ('J' TO PRINT COMMAS).
     C** ZDECS (NUMBER OF DECIMAL PLACES FOR CURRENCY) PREVIOUSLY SET
     C** UP.
     C*
                                                                                CAAA02
      * Subroutine replaced by external module                                  CAAA02
     C************       Z-ADD     UPAMT         ZFLD15                         CAAA02
     C************       MOVE      'J'           ZECODE                         CAAA02
     C************       EXSR      ZFRPED                                       CAAA02
                                                                                CAAA02
     c**********         eval      ZIn15 = UPAMT                                       CAAA02 245692
      **********                                                                       CAAA02 245692
     c**********         callb     'ZFRPED'                                            CAAA02 245692
     c**********         parm                    ZIn15                                 CAAA02 245692
     c**********         parm                    ZDECS                                 CAAA02 245692
     c**********         parm                    ZJay                                  CAAA02 245692
     c**********         parm                    ZOUT22                                CAAA02 245692
     c**********         parm                    ZOUT25                                CAAA02 245692
     C                   EVAL      ZFLD15 = UPAMT                                             245692
     C                   Z-ADD     ZDECS         @@CDP                                        245692
     C                   Z-ADD     21            @@CRET                                       245692
     C                   CALLB     'ZA1020'                                                   245692
     C                   PARM                    ZFLD15           15 0                        245692
     C                   PARM                    @@CRET            2 0                        245692
     C                   PARM                    @@CDP             1 0                        245692
     C                   PARM                    BNDCSP            1                          245692
     C                   PARM                    BNTHSP            1                          245692
     C                   PARM                    ZOUT21           21                          245692
                                                                                CAAA02
     C*
     C** REMOVE DECIMALS AND POINT BY MOVING RESULT INTO A SMALLER
     C** ARRAY. SET SIGN ACCORDING TO BUY/SELL INDICATOR. MOVE THE
     C** ARRAY INTO THE DISPLAY FIELD - LOSING THE LEFTHAND CHARACTERS.
     C*
     C**********         MOVEA     ZOUT25        @A                                           245692
     C                   MOVE      ZOUT21        W#AMNT           19                          245692
     C                   MOVEA     W#AMNT        @A                                           245692
     C     BYSL          IFEQ      'B'                                          B1
     C                   MOVE      '+'           @A(20)                         *1
     C                   ELSE                                                   X1
     C                   MOVE      '-'           @A(20)                         *1
     C                   END                                                    E1
     C                   MOVEA     @A(7)         DDAMNT
     C*
     C** EDIT THE CONTRACT RATE BEFORE OUTPUT TO THE SCREEN
     C** IF THE BUY/SELL INDICATOR IS 'B' THEN SET TO OUR EFFECTIVE
     C** RATE ELSE SET TO THEIR EFFECTIVE RATE. EXECUTE ZRATE1 TO
     C** INSERT DECIMAL POINT AND REMOVE LEADING AND TRAILING ZEROES.
     C*
     C     BYSL          IFEQ      'B'                                          B1
     C                   MOVE      UEINR         @@INPR                         *1
     C                   ELSE                                                   X1
     C                   MOVE      TEINR         @@INPR                         *1
     C                   END                                                    E1
     C                   EXSR      ZRATE1
     C                   MOVEL     @@OUTR        DDCNTR
     C*
     C     #BD9          ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
      ***/COPY ZSRSRC,ZDATE8Z3                                                  CAAA02
      /COPY ZSRSRC,ZDATE8Z3LE                                                   CAAA02
     C*****************************************************************
     C/EJECT
     C*****************************************************************
      ***/COPY ZSRSRC,ZFRPEDZ3                                                  CAAA02
     C*****************************************************************
     C/EJECT
     C*****************************************************************
      ***/COPY ZSRSRC,ZRATE1Z2                                                  CAAA02
      *COPY*ZSRSRC,ZRATE1Z2LE***                                                       CAAA02 245692
      /COPY ZSRSRC,ZRATE1Z3LE                                                                 245692
     C*****************************************************************
     C/EJECT
     C*****************************************************************
      ***/COPY ZSRSRC,ZVLDTZ3
      /COPY ZSRSRC,ZVLDTZ3LE
     C*****************************************************************
     C/EJECT
     C*****************************************************************
      ***/COPY ZSRSRC,ZDAT10Z2                                                  CAAA02
     C*****************************************************************
     C/EJECT
     C*****************************************************************
      ***/COPY ZSRSRC,ZDATE1Z2                                                  CAAA02
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
     C* FLDS USED  @FBRCA  -  DEFAULT MIDAS BRANCH CODE               *
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
      ** When Position/Risk Enquiries & Reports feature is
      ** switched on, open files DLDLDEL1-8 otherwise,
      ** open files DLDLDGL1-8.
      *
     C     CEU012        IFEQ      'Y'
     C                   OPEN      DLDLDEL1
     C                   OPEN      DLDLDEL2
     C                   OPEN      DLDLDEL3
     C                   OPEN      DLDLDEL4
     C                   OPEN      DLDLDEL5
     C                   OPEN      DLDLDEL6
     C                   OPEN      DLDLDEL7
     C                   OPEN      DLDLDEL8
     C                   ELSE
     C                   OPEN      DLDLDGL1
     C                   OPEN      DLDLDGL2
     C                   OPEN      DLDLDGL3
     C                   OPEN      DLDLDGL4
     C                   OPEN      DLDLDGL5
     C                   OPEN      DLDLDGL6
     C                   OPEN      DLDLDGL7
     C                   OPEN      DLDLDGL8
     C                   ENDIF
     C*
     C** SET UP THE RUN DATE FOR THE SCREEN HEADING
     C*
     C                   MOVE      BJMRDT        @TDATE
     C*
     C                   MOVE      BJMRDT        @FVLDT            7
     C                   Z-ADD     BJRDNB        @FVLDY            5 0
     C**
     C** Store the date format indicator as @@DFMT used by ZVLDT later.
     C                   MOVE      BJDFIN        @@DFMT
     C**
     C** Store the date format indicator as *IN98 used by ZDATE8 later.
     C** If Date format is 'M'(American), change date format from
     C** UK(DDMMMYY) to US(MMMDDYY). Also set up Screen Run date
     C** and Screen Value date.
     C*
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
     C                   MOVEL     @WRK5         @DAT7                          *1
     C*                                                    *1
     C                   MOVE      @DAT7         @FVLDT                         *1
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
                                                                                CAAA02
      * N.B. INVITE based processing no longer done, timeout is now             CAAA02
      *      controlled in the RPG after the READ.                              CAAA02
                                                                                CAAA02
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
      *******************                                                       CAAA02
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
     C                   OPEN      DL1902DF
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
     C*            @TOPRD     - FIRST RECORD CURRENTLY ON SUBFILE     *
     C*            @KRCRD     - ALL KEY FIELDS (DATA STRUCTURE)       *
     C*                                                               *
     C*****************************************************************
     C*
     C     #C            BEGSR
     C*
     C** IF FAST EXIT HAS BEEN REQUESTED - F3 EXIT IMMEDIATELY
     C*
     C     *IN03         IFEQ      '1'                                          B1
     C                   MOVE      'Q'           @@TERM                         *1
     C                   MOVE      '1'           *INLR                          *1
     C*
     C** Else F12 has been requested for further summary screen.
     C*
     C                   ELSE                                                   X1
      *
      ** If F12 taken
     C     *IN12         IFEQ      '1'
      *
      ** If program originally requested from DL1909
     C     @@TERM        IFEQ      'J'
      *
      **  Set @@TERM to Hop Up
     C                   MOVE      'H'           @@TERM
     C                   ELSE
      *
      ** Else, if program originally requested from DL1905
     C     @@TERM        IFEQ      'D'
      *
      ** Else, set @@TERM to Up
     C                   MOVE      'U'           @@TERM
     C                   ELSE
      *
      ** Else, if book or branch is 'ALL'
     C     @TBKCD        IFEQ      'ALL'
     C     @TBRCH        OREQ      'ALL'
      *
      ** set @@TERM to Hop Up
     C                   MOVE      'H'           @@TERM
     C                   ELSE
      ** Else set @@TERM to Up
     C                   MOVE      'U'           @@TERM
      *
     C                   END
     C                   END
     C                   END
     C                   END
      *
      ** If @@TERM is Up
     C     @@TERM        IFEQ      'U'
      *
      ** Move relevent data from key fields into prompts for program
      **      above in stack
     C                   MOVE      @KBKCD        @UPBKC
     C                   MOVE      @KBRCA        @UPBCH
      *
     C     CEU012        IFEQ      'Y'
     C     @SCRCY        ANDEQ     BKEUCP
     C                   MOVE      @SCRCY        @UPCCY
     C                   ELSE
      *
     C                   MOVE      @KCRCY        @UPCCY
     C                   ENDIF
      *
     C     CEU012        IFEQ      'Y'
     C                   MOVE      @KSSNB        @UPSNB
     C                   MOVE      @WINCY        @UPINC
     C                   ENDIF
      *
     C                   Z-ADD     @KVLDY        @UPVDY
      *
      ** Value date is set up from the title field
     C                   MOVE      @TVLDT        @UPVDT
      *
      ** Set up currency decimal places and deferred interest
      **     calculation method and Spot Date
     C                   Z-ADD     @@CDP         @UPCDP
     C                   Z-ADD     @@DICM        @UPDIC
     C                   Z-ADD     WSPOT         @UPSPT
      *
      ** Move prompts into parameter string
     C                   MOVEL     @PRMUP        @STRNG
     C                   END
      *
      ** If @@TERM is Hop Up
     C     @@TERM        IFEQ      'H'
      *
      ** If book title is 'ALL'
     C     @TBKCD        IFEQ      'ALL'
      *
      ** Set book to blank
     C                   MOVE      *BLANKS       @HPBKC
     C                   ELSE
      *
      ** Else set book to book title
     C                   MOVEL     @TBKCD        @HPBKC
     C                   END
      *
      ** Move relevent data from top record into prompts
      **      to set up currency
     C                   MOVEL     @TOPRD        @KRCRD
      *
     C     CEU012        IFEQ      'Y'
     C     @SCRCY        ANDEQ     BKEUCP
     C                   MOVE      @SCRCY        @HPCCY
     C                   ELSE
      *
     C                   MOVE      @KCRCY        @HPCCY
     C                   ENDIF
      *
     C     CEU012        IFEQ      'Y'
     C                   MOVE      @WINCY        @HPINC
     C                   ENDIF
      *
      ** If branch title is 'ALL'
     C     @TBRCH        IFEQ      'ALL'
      *
      ** Set branch to blank
     C                   MOVE      *BLANKS       @HPBRC
     C                   ELSE
      *
      ** Else set branch to branch title
     C                   MOVE      @TBRCH        @HPBRC
     C                   END
      *
      ** Value date is set up from the title field - only MMMYY to be
      ** sent therefore extract month and year according to date format
      ** indicator.
     C     BJDFIN        IFEQ      'D'
     C                   MOVE      @TVLDT        @HPDAT
     C                   ELSE
     C                   MOVEL     @TVLDT        @WHPDT            3
     C                   MOVE      @TVLDT        @HPDAT
     C                   MOVEL     @WHPDT        @HPDAT
     C                   END
      *
      ** Set up currency decimal places and deferred interest
      **     calculation method
     C                   Z-ADD     @@CDP         @HPCDP
     C                   Z-ADD     @@DICM        @HPDIC
     C                   Z-ADD     WSPOT         @HPSPT
      *
      ** Move prompts into parameter string
     C                   MOVEL     @PRMHP        @STRNG
     C                   END
     C*
     C** TURN OFF INDICATOR *IN12 SO THAT IF PROGRAM IS RECALLED SLOW
     C** EXIT WILL NOT BE PROCESSED
     C*
     C                   MOVE      '0'           *IN12                          *1
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
     C                   ENDIF
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
      *
      ** Call to program ended in error
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'CEU012'      DBKEY                          ************
     C                   MOVE      'SCSARDPD'    DBFILE                         * DBERR 01 *
     C                   Z-ADD     001           DBASE                          ************
     C                   MOVEL     'DL1902'      DBPGM
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
     C                   Z-ADD     005           DBASE                          * DBERR 05 *
     C                   MOVEL     '*FIRST'      DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Retrieve Ccy no of decimal places and store into
      ** array for later use in formatting amounts.
      *
     C     CEU012        IFEQ      'Y'
     C                   Z-ADD     1             X                 2 0
     C     *LOVAL        SETLL     SDCURRL0
     C     *IN40         DOUEQ     '1'
     C                   READ      SDCURRL0                               40
     C     *IN40         IFEQ      '0'
     C                   MOVE      A6CYCD        WCY(X)
     C                   MOVE      A6NBDP        WDC(X)
     C                   ADD       1             X
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
     C*
     C**  Get ZMUSER to access Default Branch
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
     C*
     C     BGMBIN        IFEQ      'N'
     C                   MOVE      '1'           *IN50
     C                   END
     C*
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
     C** If *IN18 is off, convert MMMDDYY/DDMMMYY to MMDDYY/DDMMYY
     C     *IN18         IFEQ      '0'
     C*
     C** Define the input field and clear output field
     C                   MOVE      *ZEROS        ZDATE             6 0
     C                   MOVE      *ZEROS        ZWRK4             4 0
     C                   MOVE      ZADATE        ZADATE            7
     C*
     C** Move the date into its various components - DD, MMM and YY
     C                   MOVE      ZADATE        ZDATE
     C                   MOVEL     ZADATE        @@WRK1            5
     C*
     C** If *IN98 is on, date format is 'M' (MMMDDYY)
     C     *IN98         IFEQ      '1'
     C                   MOVE      @@WRK1        ZWRK4
     C                   MOVEL     @@WRK1        @@MMM             3
     C*
     C** else *IN98 is off, date format is 'D' (DDMMMYY)
     C                   ELSE
     C                   MOVE      @@WRK1        @@MMM
     C                   MOVEL     @@WRK1        ZWRK4
     C                   END
     C*
     C** Look up month shortnames array - store month number to @@MM
     C                   Z-ADD     1             @@MM              2 0
     C     @@MMM         LOOKUP    @MT(@@MM)                              90
     C*
     C** Set up field for DD and MM
     C     *IN98         IFEQ      '1'
     C                   MOVEL     @@MM          ZWRK4
     C                   ELSE
     C                   MOVE      @@MM          ZWRK4
     C                   END
     C*
     C** Set up output field for MMDDYY/DDMMYY
     C                   MOVEL     ZWRK4         ZDATE
     C*
     C** If *IN18 on, convert MMDDYY/DDMMYY to MMMDDYY/DDMMMYY
     C                   ELSE
     C*
     C** Define the input field and clear output field
     C                   MOVE      *BLANKS       ZADATE            7
     C                   MOVE      *BLANKS       @@WRK1            5
     C                   MOVE      ZDATE         ZDATE             6 0
     C*
     C** Move the date into its various components - DD, MM and YY
     C                   MOVE      ZDATE         ZADATE
     C                   MOVEL     ZDATE         ZWRK4             4 0
     C*
     C** If *IN98 is on, date format is 'M' (MMDDYY)
     C     *IN98         IFEQ      '1'
     C                   MOVEL     ZWRK4         @@MM              2 0
     C                   MOVE      ZWRK4         @@WRK1
     C*
     C** else *IN98 is off, date format is 'D' (DDMMYY)
     C                   ELSE
     C                   MOVE      ZWRK4         @@MM
     C                   MOVEL     ZWRK4         @@WRK1
     C                   END
     C*
     C** Get the corresponding month shortname of the month number
     C** in the month shortnames array
     C                   MOVEA     @MT(@@MM)     @@MMM             3
     C*
     C     *IN98         IFEQ      '1'
     C                   MOVEL     @@MMM         @@WRK1
     C                   ELSE
     C                   MOVE      @@MMM         @@WRK1
     C                   END
     C*
     C** Set up output field for MMMDDYY/DDMMMYY
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
     C* FLDS USED  @BEEN    -  ALREADY BEEN THROUGH *PSSR INDICATOR   *
     C*            @LDA     -  VARIABLE TO SET UP LDA WITH DB ERRORS  *
     C*            DBERR    -  DS TO HOLD DB ERROR                    *
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
     C* FLDS USED  @KCRCY     - CURRENCY       )                      *
     C*            @KBRKR     - BROKER         )                      *
     C*            @KBKCD     - BOOK CODE      )  FIELDS MAKING UP    *
     C*            @KBRCA     - BRANCH CODE    )  KEYS FOR DEALS      *
     C*            @KVLDY     - VALUE DAY NO   )  FILES               *
     C*            @KMTDY     - MATURITY DAY NO)                      *
     C*            @KBSRT     - BASE RATE      )                      *
     C*            @KDLNO     - DEAL NUMBER    )                      *
     C*                                                               *
     C*            @KROL1 TO @KROL8 - KLIST FOR ROLLING ONE FOR EACH  *
     C*                               POSSIBLE DEALS FILE             *
     C*                                                               *
     C*            @KPRT1 TO @KPRT8 - KLIST FOR NEW PROMPTS ONE FOR   *
     C*                               EACH POSSIBLE DEALS FILE        *
     C*                                                               *
     C*****************************************************************
     C*
     C     #AD           BEGSR
     C*
     C** KEYS USED TO READ DEALS FILE DLDLDGL1 WHEN ROLLING
     C*
     C     @KROL1        KLIST
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBRKR
     C                   KFLD                    @KBKCD
     C                   KFLD                    @KBRCA
     C                   KFLD                    @KVLDY
     C                   KFLD                    @KMTDY
     C                   KFLD                    @KBSRT
     C                   KFLD                    @KDLNO
     C*
     C** KEYS USED TO READ DEALS FILE DLDLDGL1 WHEN NEW PROMPTS
     C*
     C     @KPRT1        KLIST
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBRKR
     C                   KFLD                    @KBKCD
     C                   KFLD                    @KBRCA
     C                   KFLD                    @KVLDY
     C*
     C** KEYS USED TO READ DEALS FILE DLDLDGL1
     C*
     C     @KPR1A        KLIST
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBRKR
     C                   KFLD                    @KBKCD
     C                   KFLD                    @KBRCA
     C*
     C** KEYS USED TO READ DEALS FILE DLDLDGL2 WHEN ROLLING
     C*
     C     @KROL2        KLIST
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBRKR
     C                   KFLD                    @KBKCD
     C                   KFLD                    @KVLDY
     C                   KFLD                    @KMTDY
     C                   KFLD                    @KBSRT
     C                   KFLD                    @KDLNO
     C*
     C** KEYS USED TO READ DEALS FILE DLDLDGL2 WHEN NEW PROMPTS
     C*
     C     @KPRT2        KLIST
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBRKR
     C                   KFLD                    @KBKCD
     C                   KFLD                    @KVLDY
     C*
     C** KEYS USED TO READ DEALS FILE DLDLDGL2
     C*
     C     @KPR2A        KLIST
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBRKR
     C                   KFLD                    @KBKCD
     C*
     C** KEYS USED TO READ DEALS FILE DLDLDGL3 WHEN ROLLING
     C*
     C     @KROL3        KLIST
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBRKR
     C                   KFLD                    @KBRCA
     C                   KFLD                    @KVLDY
     C                   KFLD                    @KMTDY
     C                   KFLD                    @KBSRT
     C                   KFLD                    @KDLNO
     C*
     C** KEYS USED TO READ DEALS FILE DLDLDGL3 WHEN NEW PROMPTS
     C*
     C     @KPRT3        KLIST
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBRKR
     C                   KFLD                    @KBRCA
     C                   KFLD                    @KVLDY
     C*
     C** KEYS USED TO READ DEALS FILE DLDLDGL3
     C*
     C     @KPR3A        KLIST
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBRKR
     C                   KFLD                    @KBRCA
     C*
     C** KEYS USED TO READ DEALS FILE DLDLDGL4 WHEN ROLLING
     C*
     C     @KROL4        KLIST
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBRKR
     C                   KFLD                    @KVLDY
     C                   KFLD                    @KMTDY
     C                   KFLD                    @KBSRT
     C                   KFLD                    @KDLNO
     C*
     C** KEYS USED TO READ DEALS FILE DLDLDGL4 WHEN NEW PROMPTS
     C*
     C     @KPRT4        KLIST
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBRKR
     C                   KFLD                    @KVLDY
     C*
     C** KEYS USED TO READ DEALS FILE DLDLDGL4
     C*
     C     @KPR4A        KLIST
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBRKR
     C*
     C** KEYS USED TO READ DEALS FILE DLDLDGL5 WHEN ROLLING
     C*
     C     @KROL5        KLIST
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBKCD
     C                   KFLD                    @KBRCA
     C                   KFLD                    @KVLDY
     C                   KFLD                    @KMTDY
     C                   KFLD                    @KBSRT
     C                   KFLD                    @KDLNO
     C*
     C** KEYS USED TO READ DEALS FILE DLDLDGL5 WHEN NEW PROMPTS
     C*
     C     @KPRT5        KLIST
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBKCD
     C                   KFLD                    @KBRCA
     C                   KFLD                    @KVLDY
     C*
     C** KEYS USED TO READ DEALS FILE DLDLDGL5
     C*
     C     @KPR5A        KLIST
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBKCD
     C                   KFLD                    @KBRCA
     C*
     C** KEYS USED TO READ DEALS FILE DLDLDGL6 WHEN ROLLING
     C*
     C     @KROL6        KLIST
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBRCA
     C                   KFLD                    @KVLDY
     C                   KFLD                    @KMTDY
     C                   KFLD                    @KBSRT
     C                   KFLD                    @KDLNO
     C*
     C** KEYS USED TO READ DEALS FILE DLDLDGL6 WHEN NEW PROMPTS
     C*
     C     @KPRT6        KLIST
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBRCA
     C                   KFLD                    @KVLDY
     C*
     C** KEYS USED TO READ DEALS FILE DLDLDGL6
     C*
     C     @KPR6A        KLIST
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBRCA
     C*
     C** KEYS USED TO READ DEALS FILE DLDLDGL7 WHEN ROLLING
     C*
     C     @KROL7        KLIST
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBKCD
     C                   KFLD                    @KVLDY
     C                   KFLD                    @KMTDY
     C                   KFLD                    @KBSRT
     C                   KFLD                    @KDLNO
     C*
     C** KEYS USED TO READ DEALS FILE DLDLDGL7 WHEN NEW PROMPTS
     C*
     C     @KPRT7        KLIST
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBKCD
     C                   KFLD                    @KVLDY
     C*
     C** KEYS USED TO READ DEALS FILE DLDLDGL7
     C*
     C     @KPR7A        KLIST
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBKCD
     C*
     C** KEYS USED TO READ DEALS FILE DLDLDGL8 WHEN ROLLING
     C*
     C     @KROL8        KLIST
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KVLDY
     C                   KFLD                    @KMTDY
     C                   KFLD                    @KBSRT
     C                   KFLD                    @KDLNO
     C*
     C** KEYS USED TO READ DEALS FILE DLDLDGL3 WHEN NEW PROMPTS
     C*
     C     @KPRT8        KLIST
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KVLDY
     C*
     C** KEYS USED TO READ DEALS FILE DLDLDGL8
     C*
     C     @KPR8A        KLIST
     C                   KFLD                    @KCRCY
      *
      ** Keys used to read file DLDLDEL1 when rolling
      *
     C     @KRLE1        KLIST
     C                   KFLD                    @KSSNB
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBRKR
     C                   KFLD                    @KBKCD
     C                   KFLD                    @KBRCA
     C                   KFLD                    @KVLDY
     C                   KFLD                    @KMTDY
     C                   KFLD                    @KBSRT
     C                   KFLD                    @KDLNO
      *
      ** Keys used to read file DLDLDEL1 when new prompts
      *
     C     @KPRE1        KLIST
     C                   KFLD                    @KSSNB
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBRKR
     C                   KFLD                    @KBKCD
     C                   KFLD                    @KBRCA
     C                   KFLD                    @KVLDY
      *
      ** Keys used to read file DLDLDEL1
      *
     C     @KPR1E        KLIST
     C                   KFLD                    @KSSNB
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBRKR
     C                   KFLD                    @KBKCD
     C                   KFLD                    @KBRCA
      *
      ** Keys used to read file DLDLDEL2 when rolling
      *
     C     @KRLE2        KLIST
     C                   KFLD                    @KSSNB
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBRKR
     C                   KFLD                    @KBKCD
     C                   KFLD                    @KVLDY
     C                   KFLD                    @KMTDY
     C                   KFLD                    @KBSRT
     C                   KFLD                    @KDLNO
      *
      ** Keys used to read file DLDLDEL2 when new prompts
      *
     C     @KPRE2        KLIST
     C                   KFLD                    @KSSNB
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBRKR
     C                   KFLD                    @KBKCD
     C                   KFLD                    @KVLDY
      *
      ** Keys used to read file DLDLDEL2
      *
     C     @KPR2E        KLIST
     C                   KFLD                    @KSSNB
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBRKR
     C                   KFLD                    @KBKCD
      *
      ** Keys used to reaf file DLDLDEL3 when rolling
      *
     C     @KRLE3        KLIST
     C                   KFLD                    @KSSNB
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBRKR
     C                   KFLD                    @KBRCA
     C                   KFLD                    @KVLDY
     C                   KFLD                    @KMTDY
     C                   KFLD                    @KBSRT
     C                   KFLD                    @KDLNO
      *
      ** Keys used to read file DLDLDEL3 when new prompts
      *
     C     @KPRE3        KLIST
     C                   KFLD                    @KSSNB
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBRKR
     C                   KFLD                    @KBRCA
     C                   KFLD                    @KVLDY
      *
      ** Keys used to read file DLDLDEL3
      *
     C     @KPR3E        KLIST
     C                   KFLD                    @KSSNB
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBRKR
     C                   KFLD                    @KBRCA
      *
      ** Keys used to read file DLDLDEL4 when rolling
      *
     C     @KRLE4        KLIST
     C                   KFLD                    @KSSNB
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBRKR
     C                   KFLD                    @KVLDY
     C                   KFLD                    @KMTDY
     C                   KFLD                    @KBSRT
     C                   KFLD                    @KDLNO
      *
      ** Keys used to read file DLDLDEL4 when new prompts
      *
     C     @KPRE4        KLIST
     C                   KFLD                    @KSSNB
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBRKR
     C                   KFLD                    @KVLDY
      *
      ** Keys used to read file DLDLDEL4
      *
     C     @KPR4E        KLIST
     C                   KFLD                    @KSSNB
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBRKR
      *
      ** Keys used to read file DLDLDEL5 when rollling
      *
     C     @KRLE5        KLIST
     C                   KFLD                    @KSSNB
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBKCD
     C                   KFLD                    @KBRCA
     C                   KFLD                    @KVLDY
     C                   KFLD                    @KMTDY
     C                   KFLD                    @KBSRT
     C                   KFLD                    @KDLNO
      *
      ** Keys used to read file DLDLDEL5 when new prompts
      *
     C     @KPRE5        KLIST
     C                   KFLD                    @KSSNB
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBKCD
     C                   KFLD                    @KBRCA
     C                   KFLD                    @KVLDY
      *
      ** Keys used to read file DLDLDEL5
      *
     C     @KPR5E        KLIST
     C                   KFLD                    @KSSNB
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBKCD
     C                   KFLD                    @KBRCA
      *
      ** Keys used to read file DLDLDEL6 when rolling
      *
     C     @KRLE6        KLIST
     C                   KFLD                    @KSSNB
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBRCA
     C                   KFLD                    @KVLDY
     C                   KFLD                    @KMTDY
     C                   KFLD                    @KBSRT
     C                   KFLD                    @KDLNO
      *
      ** Keys used to read file DLDLDEL6 when new prompts
      *
     C     @KPRE6        KLIST
     C                   KFLD                    @KSSNB
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBRCA
     C                   KFLD                    @KVLDY
      *
      ** Keys used to read file DLDLDEL6
      *
     C     @KPR6E        KLIST
     C                   KFLD                    @KSSNB
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBRCA
      *
      ** Keys used to read file DLDLDEL7 when rolling
      *
     C     @KRLE7        KLIST
     C                   KFLD                    @KSSNB
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBKCD
     C                   KFLD                    @KVLDY
     C                   KFLD                    @KMTDY
     C                   KFLD                    @KBSRT
     C                   KFLD                    @KDLNO
      *
      ** Keys used to read file DLDLDEL7 when new prompts
      *
     C     @KPRE7        KLIST
     C                   KFLD                    @KSSNB
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBKCD
     C                   KFLD                    @KVLDY
      *
      ** Keys used to read file DLDLDEL7
      *
     C     @KPR7E        KLIST
     C                   KFLD                    @KSSNB
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KBKCD
      *
      ** Keys used to read file DLDLDEL8 when rolling
      *
     C     @KRLE8        KLIST
     C                   KFLD                    @KSSNB
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KVLDY
     C                   KFLD                    @KMTDY
     C                   KFLD                    @KBSRT
     C                   KFLD                    @KDLNO
      *
      ** Keys used to read file DLDLDEL8 when new prompts
      *
     C     @KPRE8        KLIST
     C                   KFLD                    @KSSNB
     C                   KFLD                    @KCRCY
     C                   KFLD                    @KVLDY
      *
      ** Keys used to read file DLDLDEL8
      *
     C     @KPR8E        KLIST
     C                   KFLD                    @KSSNB
     C                   KFLD                    @KCRCY
      *
     C     #AD9          ENDSR
     C*****************************************************************
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
** @YD  USED BY SR. ZDATE9 - YEARS, IN DAYS, CUMULATIVE IN 4 YEAR SPAN
00366007310109601461
** @MD  USED BY SR. ZDATE9 - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
00000000310005900090001200015100181002120024300273003040033400365
** @OVR  CL COMMAND FOR CALL TO QCMDEXC
OVRDSPF FILE(DL1902DF) WAITRCD(    )
