     H DEBUG DATEDIT(*DMY)
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*S*D ***RPGBASE*******************************************************                       CAAA02
/*STD *  RPGBASEMOD                                                   *                       CAAA02
/*EXI *  TEXT('Midas DL IRS summary details enquiry')                 *
      *****************************************************************
      *                                                               *
      *  Midas  -  FRA/IRS Module                                     *
      *                                                               *
      *  DL1912  - IRS Summary Details Enquiry                        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD038929           Date 19Feb19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 245692             Date 09Dec13               *
      *                 CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 TDA035             Date 02Apr04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAAA02             Date 16Jul03               *
      *  Converted to ILE and code-stripped                           *
      *                 217684             Date 12May03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP056             Date 13Mar02               *
      *                 CIR008             Date 13Mar02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 139781             Date 30Jul98               *
      *                 CEU012             Date 16Feb98               *
      *                 E42616             Date 13Nov92               *
      *                 S01117             Date 25Mar92               *
      *                 E28496             DATE 17SEP91               *
      *                 S01269             DATE 25JUN91               *
      *                 E23419             DATE 11NOV90               *
      *                 E23194             DATE 16AUG90               *
      *                 E23183             DATE 07AUG90               *
      *                 E20774             DATE 15MAR90               *
      *                 S01199/E22855      DATE 07MAR90               *
      *                 S01194             DATE 07MAR90               *
      *                 S01117             DATE 07MAR90               *
      *                 S01157             DATE 09/12/88              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD038929 - Recompile for DL1912DF changes                    *
      *  MD046248 - Finastra Rebranding                               *
      *  245692 - Incorrect validation of rates when the decimal se-  *
      *           parator in the Dealing ICD was defined as "," ins-  *
      *           tead of ".".                                        *
      *         - Applied for MD23981.                                *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
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
      *  139781 - Select of Consolidated Euro Currency records for a  *
      *           specific book in IRS summary details enquiry shows  *
      *           records for other books.                            *
      *  CEU012 - Position/Risk Enquiries                             *
      *  E42616 - The Enquiry on IRS Summary Details Enquiry asks for *
      *           the date to be input in format MMMDDYY instead of   *
      *           MMDDYY. This does not meet the standard for the     *
      *           rest of the MIDAS System.                           *
      *  S01117 - RECOMPILE FOR FT CHANGE TO MUSERDD                  *
      *  E28496 - Recompile for SDFAISPD changes (BQHEOC - Hedged     *
      *           Events on Cashflow removed).                        *
      *  S01269 - RECOMPILE FOR TRADE AUTHORISATION CHANGE TO         *
      *           MUSERDD                                             *
      *  E23419 - When ICD has date format 'M' (American- MMMDDYY)    *
      *           Value date and Run date still remain in UK format   *
      *           (ie DDMMMYY) - also remove embedded blank in date   *
      *           if MMMDDYY ie. change 'MAR 890' to  'MAR0890'       *
      *  E23194 - DATE FIELD ALLOWS NON-NUMERICS FOR DAY NUMBER       *
      *           FIELD                                               *
      *  E23183 - ALTERED SUBROUTINE ZVLDT TO ACCEPT DATE IN          *
      *           CORRECT FORMAT ONLY - PROGRAM RECOMPILED.           *
      *  E20774 - REPLACE QCAEXEC WITH QCMDEXC                        *
      *  S01199/E22855 - HELP SYSTEM.  (E22855 WAS APPLIED FOR        *
      *                  R2 TO THIS PROGRAM AT THE SAME TIME AS       *
      *                  S01199 WAS APPLIED FOR R10 - THEREFORE       *
      *                  THEY MAY NOT BE INDENTICAL CHANGES)          *
      *  S01194 - NEW STANDING DATA CHANGES                           *
      *  S01117 - MULTIBRANCHING CHANGES                              *
      *           BRANCH CODES FIELDS CHANGED TO END IN 'BRCA',       *
      *           TO STANDARDIZE WITH BOOKING BRANCH FIELD IN         *
      *           DEALS FILE, WHICH IS NOW ENTERED AND DISPLAYED      *
      *           ON SCREEN                                           *
      *  S01157 - NEW PROGRAM WRITTEN FOR FRA/IRS                     *
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
      *     37   -  INHIBIT SELECT FIELD FOR OTHER SIDE OF RX DETAILS *
      *     50   -  MULTIBRANCHING OFF - BRANCH PROMPT NOT DISPLAYED  *
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
      *     62   -  ERROR ON START DATE SELECTED                      *
      *     63   -  ERROR ON DATE ORDER SEQUENCE SELECTED             *
      *     64   -  ERROR ON BOOK CODE SELECTED                       *
      *     68   -  NO RECORD ON FILE FOR CCY/BRANCH AND GE START DATE*
      *     69   -  GENERAL ERROR ON VALIDATION OF PROMPT SCREEN      *
      *                                                               *
      * INDICATORS TO REPORT ERRORS ON FILE READS                     *
      *                                                               *
      *     70   -  END OF SUBFILE - DL1912S1                         *
      *     71   -  END OF RELEVANT DATA ON IRS FILE                  *
      *     72   -  BEGINNING OF RELEVANT DATA ON IRS FILE            *
      *     73   -  ERROR ON READ OF ENQUIRY SUBFILE CONTROL FORMAT   *
      *                                                               *
      *     85   -  DATABASE ERROR ON MUSER                           *
      *     86   -  DATABASE ERROR ON FDMNTHLL                        *
      *     99   -  INDICATOR USED IN ZDATE1                          *
      *                                                               *
      *****************************************************************
      *
     FDLIRSSL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(DLIRSSP0:FMT1)
      *
     FDLIRSSL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(DLIRSSP0:FMT2)
     F*
     FDLIRSSL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(DLIRSSP0:FMT3)
     F*
     FDLIRSSL4  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(DLIRSSP0:FMT4)
     F*
     FDLIRSSL5  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(DLIRSSP0:FMT5)
     F*
     FDLIRSSL6  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(DLIRSSP0:FMT6)
     F*
     FDLIRSSL7  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(DLIRSSP0:FMT7)
     F*
     FDLIRSSL8  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(DLIRSSP0:FMT8)
      *
     FDLIRSEL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(DLIRSED0:FMTE1)
      *
     FDLIRSEL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(DLIRSED0:FMTE2)
      *
     FDLIRSEL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(DLIRSED0:FMTE3)
      *
     FDLIRSEL4  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(DLIRSED0:FMTE4)
      *
     FDLIRSEL5  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(DLIRSED0:FMTE5)
      *
     FDLIRSEL6  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(DLIRSED0:FMTE6)
      *
     FDLIRSEL7  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(DLIRSED0:FMTE7)
      *
     FDLIRSEL8  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(DLIRSED0:FMTE8)
      *
     FFDMNTHLL  IF   E             DISK    INFSR(*PSSR)
     F                                     USROPN
     F*
     FMUSER     IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F*
     F*
     FDL1912DF  CF   E             WORKSTN INFSR(*PSSR)
     F                                     USROPN
     F                                     SFILE(DL1912S1:RRN)
     F                                     MAXDEV(*FILE)
     F*
     F*****************************************************************
     F*
     D @DYN            S              2    DIM(31) CTDATA PERRCD(31)
     D** Compile-time array for valid day-in-month numbers
     D @MON            S              2    DIM(12) CTDATA PERRCD(12)
     D** Compile-time array for valid month numbers
     D @YR             S              1    DIM(10) CTDATA PERRCD(10)
     D** Compile-time array for valid year digits
     D*
     D***/COPY ZSRSRC,ZDATE1Z1                                                  CAAA02
     D TXT             S             11    DIM(2) CTDATA PERRCD(2)
     D** Compile time array for date order sequence text
     D*
      ***/COPY ZSRSRC,ZVLDTZ1                                                   CAAA02
      /COPY ZSRSRC,ZVLDTZ1LE                                                    CAAA02
     D*
     D @A              S              1    DIM(20)
     D** ARRAY USED TO EDIT AMOUNT FOR DISPLAY
     D*
     D @OVR            S             36    DIM(1) CTDATA PERRCD(1)
     D** ARRAY TO SET UP PARAMETER FOR CALL TO QCMDEXC
      *
     D W#RATE          S              1A   DIM(7)                                             245692
      ** Array used to edit rate for display                                                  245692
      *                                                                                       245692
     D***/COPY ZSRSRC,ZEDITZ1                                                   CAAA02
     D*
      ***/COPY ZSRSRC,ZVLDTZ2                                                   CAAA02
     D*
     D @SRCRD          DS            29
     D*
     D** DATA STRUCTURE FOR SCREEN PROMPT FIELDS
     D*
     D  @SRFST                 1      9
     D  @SCCY                  1      3
     D  @SBOOK                 4      6
     D  @SBRCA                 7      9
     D  @SSDAT                17     22
     D  @SVLDY                24     28  0
     D  @SDORD                29     29
     D*
     D @FRCRD          DS            29
     D*
     D** DATA STRUCTURE FOR DEFAULTS
     D*
     D  @FCCY                  1      3
     D  @FBOOK                 5      6
     D  @FBRCA                 7      9
     D  @FSDAT                17     23
     D  @FVLDY                24     28  0
     D  @FDORD                29     29
     D*
     D DDOPAY          DS            17
     D*
     D** DS for Our Pay display fields if Cap, Collar or Floor
     D*
     D  @@OPD1                 1      7
     D  @@PAYS                 8     10
     D  @@OPD2                11     17
     D*
     D DDOREC          DS            17
     D*
     D** DS for Our Receive display fields if Cap, Collar or Floor
     D*
     D  @@ORD1                 1      7
     D  @@RECS                 8     10
     D  @@ORD2                11     17
     D*
     D @KRCRD          DS            41
     D*
     D** DATA STRUCTURE FOR KEY FIELDS
     D*
     D  @KCCY                  1      3
     D  @KBPBK                 5      6
     D  @KBRCA                 7      9
     D  @KDLNO                11     16  0
     D  @KSDAT                17     23
     D  @KVLDY                24     28  0
     D  @KDORD                29     29
     D  @KERTC                30     34  0
     D  @KMDAT                35     39  0
     D  @KCSQ                 40     41  0
     D*
     D IRSRCD          DS            41
     D*
     D** Data structure for IRS summary file fields
     D*
     D  KGCCY                  1      3
     D  KGBPBK                 5      6
     D  KGBRCA                 7      9
     D  KGDLNO                11     16  0
     D  KGERTC                30     34  0
     D  KGMDAT                35     39  0
     D  KGSSNB                40     41  0
     D*
     D @PRMDN          DS            42
     D*
     D** DATA STRUCTURE FOR PROMPT FIELDS FOR PROGRAM DOWN IN STACK
     D*
     D  @DCCY                  1      3
     D  @DBPBK                 4      6
     D  @DBRCA                 7      9
     D  DDDLNO                11     16  0
     D  @DSDAT                17     23
     D  @DVLDY                24     28  0
     D  @DDORD                29     29
     D  DDERTC                30     34  0
     D  DDMDAT                35     39  0
     D  @CSSN                 40     41  0
     D  @KINC                 42     42
     D*
     D** Data structure to hold top record on screen
     D*
     D @TOPRD          DS            41
     D*
     D** Data structure to hold bottom record on screen
     D*
     D @BOTRD          DS            41
     D*
     D*
     D** Data-structure to be able to access deal types easily
     D*
     D @DLTYP          DS
     D  KGDTPD                 1      6
     D  @DTYP                  1      5
     D  @RTYP                  2      3
     D  @DLTP                  1      3
     D*
     D** Data structure to facilitate the setting up of DDDTAM field
     D** for other RX detail record
     D*
     D @DDTAM          DS
     D  DDDTAM                 1     17
     D  DDXOCD                 5      7
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
0392 D SDCURR        E DS                  EXTNAME(SDCURRPD)
0393 D* Currency details accessed via access program
0393 D*
0392 D SDBOOK        E DS                  EXTNAME(SDBOOKPD)
0393 D* Book Code details accessed via access program
     D*
0392 D SDBANK        E DS                  EXTNAME(SDBANKPD)
0393 D* Bank details accessed via access program
0393 D*
0392 D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
0393 D* Branch Code details accessed via access program
0393 D*
0392 D SDFAIS        E DS                  EXTNAME(SDFAISPD)
0393 D* FRA/IRS Enquiry Default details accessed via access program
0393 D*
0392 D SDMMOD        E DS                  EXTNAME(SDMMODPD)
0393 D* Module details accessed via access program
0393 D*
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
     D* Dummy data structures used by access programs
     D* (DSSDY only used if file records over 150 chars. long)
     D*
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D*
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D*
     D*
     D*
     D @OVRID          DS            36
     D*
     D*   DATA STRUCTURE FOR COMMAND IN ARRAY @OVR
     D*
     D  @WAIT                 32     35  0
     D*
     D* Data structure to split screen Broker Code field for
     D* use in validation processing
     D @@SBK           DS             3
     D  @SBK1                  1      1
     D  @SBK3                  3      3
     D  @SBK23                 2      3
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *  Data Structure for LDA
      *
                                                                                CAAA02
     D ZErrorFlag      s              1a                                        CAAA02
      * Flag used to return error condition from Z* modules                     CAAA02
                                                                                CAAA02
     D ZZero           s              1p 0                                      CAAA02
                                                                                CAAA02
      * WaitTime is the time from WRITE to READ                                 CAAA02
     d WaitTime        s              5p 0                                      CAAA02
     d MaxWaitTime     s              5p 0                                      CAAA02
                                                                                CAAA02
      * Now1Time is the time before the READ and Now2Time the time after        CAAA02
     d Now1Time        s               t                                        CAAA02
     d Now2Time        s               t                                        CAAA02
                                                                                CAAA02
     D @@DAYN          s              5p 0                                      CAAA02
     D @@DFMT          s              1a                                        CAAA02
      * Values defined in ZVLDT subroutine which is /COPYied into               CAAA02
      * RPG code but not used                                                   CAAA02
                                                                                CAAA02
     I*****************************************************************
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
     C** PROCESS UNTIL EXIT REQUIRED
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
     C*  03  #KA     - DETERMINE FILE - SETLL WITH POSITION KEY       *
     C*  04  #KB     - DETERMINE FILE - SETGT WITH POSITION KEY       *
     C*  05  #KC     - DETERMINE FILE - READE WITH READ KEY           *
     C*  06  #KD     - DETERMINE FILE - SETLL WITH READ KEY           *
     C*  07  #KE     - DETERMINE FILE - READP RECORD                  *
     C*  09  #BA     - ROLLUP ENQUIRY SUBFILE                         *
     C*  10  #BB     - ROLLDOWN ENQUIRY SUBFILE                       *
     C*  11  #BC     - ENTER NEW PROMPT DATA                          *
     C*  12  #BCA    - VALIDATE PROMPT DATA                           *
     C*  13  #BCB    - SET UP NEW SCREEN HEADINGS                     *
     C*  14  #BCC    - DETERMINE FILE AND KEY TO BE USED WITH PROMPTS *
     C*  15  #BD     - EDIT ENQUIRY SUBFILE DATA                      *
     C*  19  ZVLDT   - EDIT VALUE DATE                                *
     C*  20  #AA     - OPEN FILES AND SET UP DEFAULT PROMPT DATA      *
     C*  21  #AC     - SET UP AUTO REFRESH PROCESSING                 *
     C*  22  #C      - TERMINATION PROCESSING                         *
     C*  23  #ZA     - RESET ERROR INDICATORS AND CLEAR MESSAGE QUEUE *
     C*  24  #AAA    - ACCESS STANDING DATA                           *
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
     C*            #AC     - SET UP AUTO REFRESH PROCESSING           *
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
     C                   MOVEL     'DL1912'      DBPGM
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
     C                   MOVEL     @STRNG        @@WORK           42
     C                   MOVEL     @@WORK        @KRCRD
     C*
     C** Move it into parameter down data structure too, just in case
     C** it is needed
     C*
     C                   MOVEL     @STRNG        @PRMDN
     C*
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
     C                   MOVE      'N'           @CALL1            1            *1
     C                   END                                                    E1
     C*
     C** SET AN INDICATOR TO SHOW FROM WHERE ENQUIRY HAS COME -
     C** 'M' FOR MENU; 'S' FOR STACK; AND 'L' FOR LOOPING IN ITSELF
     C** (FROM MENU IF PARAMETER STRING SENT IS ENTIRELY BLANK)
     C** (NEED TO RESTORE SCREEN VALUES (FROM @KRCRD) IF FROM STACK)
     C*
     C     @@WORK        IFEQ      *BLANKS                                      B1
     C                   MOVE      'M'           @FROM             1            *1
     C                   ELSE                                                   X1
     C                   MOVE      'S'           @FROM                          *1
     C                   MOVEL     @KRCRD        @SRCRD                         *1
      *
      * If called from stack and saved Book Code in @PRMDN was 'ALL',
      * Book Code key will be set up wrong (since 2A), so need to
      * check for this and amend the screen field accordingly
     C     @DBPBK        IFEQ      'ALL'
     C                   MOVE      @DBPBK        @SBOOK
     C                   END
     C                   END                                                    E1
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
     C                   WRITE     DL1912F0
     C                   WRITE     DL1912F1
     C*
     C** CLEAR THE SUBFILE BY SETTING OFF THE SUBFILE DISPLAY AND
     C** THE SUBFILE DISPLAY CONTROL INDICATORS AND THEN WRITING
     C** THE ENQUIRY SUBFILE CONTROL FORMAT
     C*
     C                   MOVE      '0'           *IN35
     C                   MOVE      '0'           *IN36
     C                   WRITE     DL1912C1
     C*
     C*
     C** IF FROM MENU THEN WRITE THE PROMPT SCREEN BY SETTING ON THE
     C** SUBFILE DISPLAY CONTROL INDICATOR - WAIT FOR A RESPONSE
     C*
     C     @FROM         IFEQ      'M'                                          B1
     C*
      * Set up screen default values
     C                   MOVE      @FRCRD        @SRCRD
     C*
     C**  Move date to ZADATE which is 7 chars long to be converted to
     C**  6 chars long (MMMDDYY/DDMMMYY to MMDDYY/DDMMYY)
     C*
     C                   MOVE      @FSDAT        ZADATE
     C                   MOVE      '0'           *IN18
     C                   EXSR      CVDT
     C                   MOVE      ZDATE         @SSDAT
     C*
     C                   MOVE      '1'           *IN36                          *1
     C                   EXFMT     DL1912C1                                     *1
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
     C*            #ZA       - RESET ERROR INDS. AND CLEAR MESSAGE Q  *
     C*                                                               *
     C* CALLED BY  MAIN CONTROLLING ROUTINE                           *
     C*                                                               *
     C* FLDS USED  @TOPRD     - FIRST RECORD CURRENTLY ON SCREEN      *
     C*            @BOTRD     - LAST RECORD CURRENTLY ON SCREEN       *
     C*            SSSLCT     - SELECT FIELD FROM SCREEN              *
     C*            @@SLCT     - SELECTION-PROCESSED INDICATOR - Y/N   *
     C*            @@ERMS     - ERROR MESSAGE TO DISPLAY - Y OR N     *
     C*            @@TERM     - TERMINATION PARAMETER                 *
     C*            @KPOSN     - KEY USED FOR ROLLING                  *
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
     C                   READC     DL1912S1                               70    ***3
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
     C** EVERYTHING REQUIRED FOR PROGRAM BELOW IS ALREADY SET UP, SO
     C** JUST MOVE @PRMDN DATA STRUCTURE INTO PARAMETER STRING
     C*
     C                   MOVEL     @PRMDN        @STRNG                         ****4
     C*
     C** SET THE SELECT FIELD FOR THE RECORD JUST PROCESSED TO BLANK
     C** AND UPDATE SUBFILE.
     C** SET ON THE SELECTION-PROCESSED INDICATOR FOR WHEN THIS
     C** PROGRAM IS RECALLED
     C*
     C                   MOVE      ' '           SSSLCT                         ****4
     C                   UPDATE    DL1912S1                                     ****4
     C*
     C                   MOVE      'Y'           @@SLCT                         ****4
     C*
     C** SET OFF INDICATORS 25/26 (ROLL UP/DOWN) SO THAT IF PROGRAM IS
     C** RECALLED A ROLL WILL NOT BE PROCESSED
     C*
     C                   MOVE      '0'           *IN25                          ****4
     C                   MOVE      '0'           *IN26                          ****4
     C*
     C                   MOVE      '1'           *INLR                          ****4
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
     C     CEU012        IFEQ      'Y'
     C                   MOVE      KGINCY        @KINC
     C                   ENDIF
      *
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
     C                   WRITE     DL1912F1                                     **2
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
     C                   WRITE     DL1912F0                                     *1
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
     C     CEU012        IFEQ      'Y'
      *
     C     @KINC         IFEQ      'Y'
     C     @SCCY         ANDNE     BKEUCP
     C     *IN69         ANDEQ     '0'
     C     @SCCY         OREQ      BKEUCP
     C     *IN69         ANDEQ     '0'
     C                   MOVE      *ON           *IN74
     C                   ELSE
     C                   MOVE      *OFF          *IN74
     C                   ENDIF
      *
     C     *IN69         IFEQ      '0'
     C                   WRITE     DL1912F1
     C                   ENDIF
      *
     C                   ENDIF
     C*
     C** WRITE THE MESSAGE SUBFILE - IF THERE IS AN ERROR THERE
     C** WILL BE A MESSAGE TO DISPLAY OTHERWISE IT WILL REMOVE ANY
     C** PREVIOUS ERROR MESSAGES ON THE SCREEN
     C*
     C                   MOVE      '1'           *IN46
      *
      * Set on the Override Data indicator to ensure Book Code
      * is displayed right-justified
     C                   MOVE      '1'           *IN24
     C                   WRITE     DL1912C0
     C*
     C** WRITE THE ENQUIRY SUBFILE CONTROL; 'INVITE' WILL BE ACTIVATED
     C*
     C                   MOVE      '1'           *IN36
     C                   WRITE     DL1912C1
     C                   MOVE      '0'           *IN28
     C*
     C** DE-ACTIVATE THE OVRDTA INDICATOR FOR THE SELECT FIELDS IN
     C** CASE IT WAS ON IE. PROGRAM HAS BEEN RE-CALLED WITH NEW PROMPTS
     C** TO DISPLAY - DO NOT WANT TO KEEP WRITING THEM
     C*
     C                   MOVE      '0'           *IN24
     C*
     C** READ THE DISPLAY FILE FOR ROLLS/REFRESH/PROMPTS
     C** IF REFRESH ON THE PROMPT SCREEN
     C** (*IN27 AND *IN05 ON) THEN, SINCE REFRESH CANNOT BE DONE HERE,
     C** RE-READ THE DISPLAY FILE; IF REFRESH ON SUBFILE SCREEN THEN
     C** EXIT DO-LOOP.
     C*
     C     *IN27         DOUEQ     '0'                                          B1
     C     *IN05         OREQ      '0'                                          *1
     C*
     C                   MOVE      '0'           *IN05                          *1
     C************       READ      DL1912DF                             0573    CAAA02
      /free
         Now1Time = %time();                                                  //CAAA02
                                                                              //CAAA02
         read DL1912C1;                                                       //CAAA02
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
      ** Setup the proper text on the function key text line.
      *
     C     CEU012        IFEQ      'Y'
      *
     C     @KINC         IFEQ      'Y'
     C                   WRITE     DL1912F1
     C                   ENDIF
      *
     C     *IN07         IFEQ      *ON
      *
     C     *IN75         IFEQ      '0'
     C                   MOVE      *ON           *IN75
     C                   ELSE
     C                   MOVE      *OFF          *IN75
     C                   ENDIF
      *
     C                   WRITE     DL1912F1
     C                   ENDIF
      *
     C                   ENDIF
     C*
     C** SET INDICATOR TO SHOW FROM WHERE ENQUIRY HAS COME TO 'L'
     C** FOR LOOPING INCASE ANOTHER ENQUIRY IS MADE FROM THIS PROGRAM
     C*
     C                   MOVE      'L'           @FROM
     C*
     C     #B9           ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #KA      - DETERMINE FILE - SETLL WITH POSITION KEY           *
     C*                                                               *
     C* CALLS                                                         *
     C*                                                               *
     C* CALLED BY  #B   -  MAIN PROCESSING                            *
     C*                                                               *
     C* FLDS USED  @KPOS1 TO @KPOS8 - KLIST FOR POSITIONING FILE PTR. *
     C*                               AT SPECIFIC POINT ON FILE       *
     C*                                                               *
     C*            @@FILE - FILE TO BE USED FLAG                      *
     C*                                                               *
     C*****************************************************************
     C*
     C     #KA           BEGSR
     C*
     C** USE THE APPROPRIATE KEY TO SET LOWER LIMITS ON THE FILE
     C*
      *
     C                   SELECT
      *
      ** If CEU012 is ON, use DLIRSEL1 to L8 logical files
      *
     C     CEU012        WHENEQ    'Y'
      *
     C                   SELECT
     C     @@FILE        WHENEQ    '1'
     C     @KPO1A        SETLL     DLIRSEL1
      *
     C     @@FILE        WHENEQ    '2'
     C     @KPO2A        SETLL     DLIRSEL2
      *
     C     @@FILE        WHENEQ    '3'
     C     @KPO3A        SETLL     DLIRSEL3
      *
     C     @@FILE        WHENEQ    '4'
     C     @KPO4A        SETLL     DLIRSEL4
      *
     C     @@FILE        WHENEQ    '5'
     C     @KPO5A        SETLL     DLIRSEL5
      *
     C     @@FILE        WHENEQ    '6'
     C     @KPO6A        SETLL     DLIRSEL6
      *
     C     @@FILE        WHENEQ    '7'
     C     @KPO7A        SETLL     DLIRSEL7
      *
     C     @@FILE        WHENEQ    '8'
     C     @KPO8A        SETLL     DLIRSEL8
     C                   ENDSL
      *
     C     CEU012        WHENEQ    'N'
      *
     C     @@FILE        IFEQ      '1'                                          B1
     C     @KPOS1        SETLL     DLIRSSL1                                     *1
     C                   GOTO      #KA9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '2'                                          B1
     C     @KPOS2        SETLL     DLIRSSL2                                     *1
     C                   GOTO      #KA9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '3'                                          B1
     C     @KPOS3        SETLL     DLIRSSL3                                     *1
     C                   GOTO      #KA9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '4'                                          B1
     C     @KPOS4        SETLL     DLIRSSL4                                     *1
     C                   GOTO      #KA9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '5'                                          B1
     C     @KPOS5        SETLL     DLIRSSL5                                     *1
     C                   GOTO      #KA9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '6'                                          B1
     C     @KPOS6        SETLL     DLIRSSL6                                     *1
     C                   GOTO      #KA9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '7'                                          B1
     C     @KPOS7        SETLL     DLIRSSL7                                     *1
     C                   GOTO      #KA9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '8'                                          B1
     C     @KPOS8        SETLL     DLIRSSL8                                     *1
     C                   GOTO      #KA9                                         *1
     C                   END                                                    E1
      *
     C                   ENDSL
     C*
     C     #KA9          ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #KB      - DETERMINE FILE - SETGT WITH POSITION KEY           *
     C*                                                               *
     C* CALLS                                                         *
     C*                                                               *
     C* CALLED BY  #B   -  MAIN PROCESSING                            *
     C*                                                               *
     C* FLDS USED  @KPOS1 TO @KPOS8 - KLIST FOR POSITIONING FILE PTR. *
     C*                               AT SPECIFIC POINT ON FILE       *
     C*                                                               *
     C*            @@FILE - FILE TO BE USED FLAG                      *
     C*                                                               *
     C*****************************************************************
     C*
     C     #KB           BEGSR
     C*
     C** USE THE APPROPRIATE KEY TO SET GREATER LIMITS ON THE FILE
     C*
      *
     C                   SELECT
      *
      ** If CEU012 is ON, use DLIRSEL1 to L8 logical files
      *
     C     CEU012        WHENEQ    'Y'
      *
     C                   SELECT
     C     @@FILE        WHENEQ    '1'
     C     @KPO1A        SETGT     DLIRSEL1
      *
     C     @@FILE        WHENEQ    '2'
     C     @KPO2A        SETGT     DLIRSEL2
      *
     C     @@FILE        WHENEQ    '3'
     C     @KPO3A        SETGT     DLIRSEL3
      *
     C     @@FILE        WHENEQ    '4'
     C     @KPO4A        SETGT     DLIRSEL4
      *
     C     @@FILE        WHENEQ    '5'
     C     @KPO5A        SETGT     DLIRSEL5
      *
     C     @@FILE        WHENEQ    '6'
     C     @KPO6A        SETGT     DLIRSEL6
      *
     C     @@FILE        WHENEQ    '7'
     C     @KPO7A        SETGT     DLIRSEL7
      *
     C     @@FILE        WHENEQ    '8'
     C     @KPO8A        SETGT     DLIRSEL8
     C                   ENDSL
      *
     C     CEU012        WHENEQ    'N'
      *
     C     @@FILE        IFEQ      '1'                                          B1
     C     @KPOS1        SETGT     DLIRSSL1                                     *1
     C                   GOTO      #KB9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '2'                                          B1
     C     @KPOS2        SETGT     DLIRSSL2                                     *1
     C                   GOTO      #KB9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '3'                                          B1
     C     @KPOS3        SETGT     DLIRSSL3                                     *1
     C                   GOTO      #KB9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '4'                                          B1
     C     @KPOS4        SETGT     DLIRSSL4                                     *1
     C                   GOTO      #KB9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '5'                                          B1
     C     @KPOS5        SETGT     DLIRSSL5                                     *1
     C                   GOTO      #KB9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '6'                                          B1
     C     @KPOS6        SETGT     DLIRSSL6                                     *1
     C                   GOTO      #KB9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '7'                                          B1
     C     @KPOS7        SETGT     DLIRSSL7                                     *1
     C                   GOTO      #KB9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '8'                                          B1
     C     @KPOS8        SETGT     DLIRSSL8                                     *1
     C                   GOTO      #KB9                                         *1
     C                   END                                                    E1
      *
     C                   ENDSL
     C*
     C     #KB9          ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #KC      - DETERMINE FILE - READE WITH READ KEY               *
     C*                                                               *
     C* CALLS                                                         *
     C*                                                               *
     C* CALLED BY  #B     - MAIN PROCESSING                           *
     C*            #BA    - ROLLUP ENQUIRY SUBFILE                    *
     C*            #BB    - ROLLDOWN ENQUIRY SUBFILE                  *
     C*            #BC    - ENTER NEW PROMPT DATA                     *
     C*                                                               *
     C* FLDS USED  @KRDF1 TO @KRDF8 - KLIST FOR READING FILE          *
     C*                                                               *
     C*            @@FILE - FILE TO BE USED FLAG                      *
     C*                                                               *
     C*****************************************************************
     C*
     C     #KC           BEGSR
     C*
     C** USE THE APPROPRIATE KEY TO READE ON THE FILE
     C*
      *
      ** If CEU012 is ON, use DLIRSEL1 to L8 logical files
      *
     C                   SELECT
      *
      ** If CEU012 is ON and currency to be processed is not the
      ** Consolidated Euro Currency Code.
      *
     C     CEU012        WHENEQ    'Y'
     C     @SCCY         ANDNE     BKEUCP
      *
     C                   SELECT
     C     @@FILE        WHENEQ    '1'
     C     @KRD1A        READE     DLIRSEL1                               71
      *
     C     @@FILE        WHENEQ    '2'
     C     @KRD2A        READE     DLIRSEL2                               71
      *
     C     @@FILE        WHENEQ    '3'
     C     @KRD3A        READE     DLIRSEL3                               71
      *
     C     @@FILE        WHENEQ    '4'
     C     @KRD4A        READE     DLIRSEL4                               71
      *
     C     @@FILE        WHENEQ    '5'
     C     @KRD5A        READE     DLIRSEL5                               71
      *
     C     @@FILE        WHENEQ    '6'
     C     @KRD6A        READE     DLIRSEL6                               71
      *
     C     @@FILE        WHENEQ    '7'
     C     @KRD7A        READE     DLIRSEL7                               71
      *
     C     @@FILE        WHENEQ    '8'
     C     @KRD8A        READE     DLIRSEL8                               71
      *
     C                   ENDSL
      *
     C     CEU012        WHENEQ    'Y'
     C     @SCCY         ANDEQ     BKEUCP
      *
     C                   SELECT
      *
     C     @@FILE        WHENEQ    '1'
     C     *IN71         DOWEQ     *OFF
     C                   READ      DLIRSEL1                               71
     C     *IN71         IFEQ      *OFF
     C     KGBRCA        ANDEQ     @KBRCA
     C     KGINCY        IFEQ      'Y'
     C     KGCCY         OREQ      BKEURO
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C     @@FILE        WHENEQ    '2'
     C     *IN71         DOWEQ     *OFF
     C                   READ      DLIRSEL2                               71
     C     *IN71         IFEQ      *OFF
     C     KGBPBK        ANDEQ     @KBPBK
     C     KGBRCA        ANDEQ     @KBRCA
     C     KGINCY        IFEQ      'Y'
     C     KGCCY         OREQ      BKEURO
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C     @@FILE        WHENEQ    '3'
     C     *IN71         DOWEQ     *OFF
     C                   READ      DLIRSEL3                               71
     C     *IN71         IFEQ      *OFF
     C     KGINCY        IFEQ      'Y'
     C     KGCCY         OREQ      BKEURO
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C     @@FILE        WHENEQ    '4'
     C     *IN71         DOWEQ     *OFF
     C                   READ      DLIRSEL4                               71
     C     *IN71         IFEQ      *OFF
     C     KGBPBK        ANDEQ     @KBPBK
     C     KGINCY        IFEQ      'Y'
     C     KGCCY         OREQ      BKEURO
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C     @@FILE        WHENEQ    '5'
     C     *IN71         DOWEQ     *OFF
     C                   READ      DLIRSEL5                               71
     C     *IN71         IFEQ      *OFF
     C     KGBPBK        ANDEQ     @KBPBK
     C     KGBRCA        ANDEQ     @KBRCA
     C     KGINCY        IFEQ      'Y'
     C     KGCCY         OREQ      BKEURO
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C     @@FILE        WHENEQ    '6'
     C     *IN71         DOWEQ     *OFF
     C                   READ      DLIRSEL6                               71
     C     *IN71         IFEQ      *OFF
     C     KGBRCA        ANDEQ     @KBRCA
     C     KGINCY        IFEQ      'Y'
     C     KGCCY         OREQ      BKEURO
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C     @@FILE        WHENEQ    '7'
     C     *IN71         DOWEQ     *OFF
     C                   READ      DLIRSEL7                               71
     C     *IN71         IFEQ      *OFF
     C     KGINCY        IFEQ      'Y'
     C     KGCCY         OREQ      BKEURO
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C     @@FILE        WHENEQ    '8'
     C     *IN71         DOWEQ     *OFF
     C                   READ      DLIRSEL8                               71
     C     *IN71         IFEQ      *OFF
     C     KGBPBK        ANDEQ     @KBPBK
     C     KGINCY        IFEQ      'Y'
     C     KGCCY         OREQ      BKEURO
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C                   ENDSL
      *
     C     CEU012        WHENEQ    'N'
      *
     C     @@FILE        IFEQ      '1'                                          B1
     C     @KRDF1        READE     DLIRSSL1                               71    *1
     C                   GOTO      #KC9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '2'                                          B1
     C     @KRDF2        READE     DLIRSSL2                               71    *1
     C                   GOTO      #KC9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '3'                                          B1
     C     @KRDF3        READE     DLIRSSL3                               71    *1
     C                   GOTO      #KC9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '4'                                          B1
     C     @KRDF4        READE     DLIRSSL4                               71    *1
     C                   GOTO      #KC9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '5'                                          B1
     C     @KRDF5        READE     DLIRSSL5                               71    *1
     C                   GOTO      #KC9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '6'                                          B1
     C     @KRDF6        READE     DLIRSSL6                               71    *1
     C                   GOTO      #KC9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '7'                                          B1
     C     @KRDF7        READE     DLIRSSL7                               71    *1
     C                   GOTO      #KC9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '8'                                          B1
     C     @KRDF8        READE     DLIRSSL8                               71    *1
     C                   GOTO      #KC9                                         *1
     C                   END                                                    E1
      *
     C                   ENDSL
     C*
     C     #KC9          ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #KD      - DETERMINE FILE - SETLL WITH BEGINNING KEY          *
     C*                                                               *
     C* CALLS                                                         *
     C*                                                               *
     C* CALLED BY  #BB    - ROLLDOWN ENQUIRY SUBFILE                  *
     C*            #BC    - ENTER NEW PROMPT DATA                     *
     C*                                                               *
     C* FLDS USED  @KBEG1 TO @KBEG8 - KLIST FOR NEW PROMPTS; IE. TO   *
     C*                               POSITION FILE PTR AT BEGINNING  *
     C*                               OF RELEVANT DATA                *
     C*                                                               *
     C*            @@FILE - FILE TO BE USED FLAG                      *
     C*                                                               *
     C*****************************************************************
     C*
     C     #KD           BEGSR
     C*
     C** USE THE APPROPRIATE KEY TO SET LOWER LIMITS ON THE FILE
     C*
      *
     C                   SELECT
      *
      ** If CEU012 is ON, use DLIRSEL1 to L8 logical files
      *
     C     CEU012        WHENEQ    'Y'
      *
     C                   SELECT
     C     @@FILE        WHENEQ    '1'
     C     @KBE1A        SETLL     DLIRSEL1
      *
     C     @@FILE        WHENEQ    '2'
     C     @KBE2A        SETLL     DLIRSEL2
      *
     C     @@FILE        WHENEQ    '3'
     C     @KBE3A        SETLL     DLIRSEL3
      *
     C     @@FILE        WHENEQ    '4'
     C     @KBE4A        SETLL     DLIRSEL4
      *
     C     @@FILE        WHENEQ    '5'
     C     @KBE5A        SETLL     DLIRSEL5
      *
     C     @@FILE        WHENEQ    '6'
     C     @KBE6A        SETLL     DLIRSEL6
      *
     C     @@FILE        WHENEQ    '7'
     C     @KBE7A        SETLL     DLIRSEL7
      *
     C     @@FILE        WHENEQ    '8'
     C     @KBE8A        SETLL     DLIRSEL8
     C                   ENDSL
      *
     C     CEU012        WHENEQ    'N'
      *
     C     @@FILE        IFEQ      '1'                                          B1
     C     @KBEG1        SETLL     DLIRSSL1                                     *1
     C                   GOTO      #KD9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '2'                                          B1
     C     @KBEG2        SETLL     DLIRSSL2                                     *1
     C                   GOTO      #KD9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '3'                                          B1
     C     @KBEG3        SETLL     DLIRSSL3                                     *1
     C                   GOTO      #KD9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '4'                                          B1
     C     @KBEG4        SETLL     DLIRSSL4                                     *1
     C                   GOTO      #KD9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '5'                                          B1
     C     @KBEG5        SETLL     DLIRSSL5                                     *1
     C                   GOTO      #KD9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '6'                                          B1
     C     @KBEG6        SETLL     DLIRSSL6                                     *1
     C                   GOTO      #KD9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '7'                                          B1
     C     @KBEG7        SETLL     DLIRSSL7                                     *1
     C                   GOTO      #KD9                                         *1
     C                   END                                                    E1
     C*
     C     @@FILE        IFEQ      '8'                                          B1
     C     @KBEG8        SETLL     DLIRSSL8                                     *1
     C                   GOTO      #KD9                                         *1
     C                   END                                                    E1
      *
     C                   ENDSL
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
     C* FLDS USED  @SCCY      - CURRENCY       )                      *
     C*            @SMDAT     - MATURITY DATE  )  FIELDS ENTERED IN   *
     C*            @SBOOK     - BOOK CODE      )  PROMPTS             *
     C*            @SBRCA     - BOOKING BRANCH CODE)                  *
     C*            @SERTC     - EARLIEST NRCD  )                      *
     C*                                                               *
     C*            KGCCY      - CURRENCY       )                      *
     C*            KGBRCA     - BK. BRANCH CODE)  FIELDS READ FROM    *
     C*            KGBPBK     - BOOK CODE      )  FILE (MUST          *
     C*            KGMDAT     - MATURITY DATE  )  CORRESPOND WITH     *
     C*            KGERTC     - EARLIEST NRCD  )  PROMPTS)            *
     C*                                                               *
     C*            @@FILE - FILE TO BE USED FLAG                      *
     C*                                                               *
     C*****************************************************************
     C*
     C     #KE           BEGSR
     C*
     C** Use the correct key to read the previous record on file.
     C** NOTE: Since 'READP' is not the exact opposite of 'READE' the
     C** relevant file fields have to be compared to the prompt fields
     C** to ensure that prompt criteria are met.
      *
      * N.B. Since @SBOOK is now 3A, @SBK23 is used to compare
      * with file book code. This is part of a data structure
      * and contains last two chars. of @SBOOK
      *
     C                   SELECT
      *
      ** If CEU012 is ON, use DLIRSEL1 to L8 logical files
      *
     C     CEU012        WHENEQ    'Y'
     C     @SCCY         ANDNE     BKEUCP
      *
     C                   SELECT
      *
      ** All books, named branch, maturity date order
      *
     C     @@FILE        WHENEQ    '1'
     C                   READP     DLIRSEL1                               72
      *
     C     KGCCY         IFNE      @SCCY
     C     @SCCY         ANDNE     BKEUCP
     C     @SCCY         OREQ      BKEUCP
     C     KGINCY        ANDEQ     'N'
     C     KGCCY         ANDNE     BKEURO
     C     KGBRCA        ORNE      @SBRCA
     C                   MOVE      *ON           *IN72
     C                   ENDIF
      *
      ** Named book & branch, maturity order
      *
     C     @@FILE        WHENEQ    '2'
     C                   READP     DLIRSEL2                               72
      *
     C     KGCCY         IFNE      @SCCY
     C     @SCCY         ANDNE     BKEUCP
     C     @SCCY         OREQ      BKEUCP
     C     KGINCY        ANDEQ     'N'
     C     KGCCY         ANDNE     BKEURO
     C     KGBPBK        ORNE      @SBK23
     C     KGBRCA        ORNE      @SBRCA
     C                   MOVE      *ON           *IN72
     C                   ENDIF
      *
      ** All books & branches, maturity order
      *
     C     @@FILE        WHENEQ    '3'
     C                   READP     DLIRSEL3                               72
      *
     C     KGCCY         IFNE      @SCCY
     C     @SCCY         ANDNE     BKEUCP
     C     @SCCY         OREQ      BKEUCP
     C     KGINCY        ANDEQ     'N'
     C     KGCCY         ANDNE     BKEURO
     C                   MOVE      *ON           *IN72
     C                   ENDIF
      *
      ** Named book, all branches, maturity order
      *
     C     @@FILE        WHENEQ    '4'
     C                   READP     DLIRSEL4                               72
      *
     C     KGCCY         IFNE      @SCCY
     C     @SCCY         ANDNE     BKEUCP
     C     @SCCY         OREQ      BKEUCP
     C     KGINCY        ANDEQ     'N'
     C     KGCCY         ANDNE     BKEURO
     C     KGBPBK        ORNE      @SBK23
     C                   MOVE      *ON           *IN72
     C                   ENDIF
      *
      ** Named book & branch, NRCD order
      *
     C     @@FILE        WHENEQ    '5'
     C                   READP     DLIRSEL5                               72
      *
     C     KGCCY         IFNE      @SCCY
     C     @SCCY         ANDNE     BKEUCP
     C     @SCCY         OREQ      BKEUCP
     C     KGINCY        ANDEQ     'N'
     C     KGCCY         ANDNE     BKEURO
     C     KGBPBK        ORNE      @SBK23
     C     KGBRCA        ORNE      @SBRCA
     C                   MOVE      *ON           *IN72
     C                   ENDIF
      *
      ** All books, named branch, NRCD order
      *
     C     @@FILE        WHENEQ    '6'
     C                   READP     DLIRSEL6                               72
      *
     C     KGCCY         IFNE      @SCCY
     C     @SCCY         ANDNE     BKEUCP
     C     @SCCY         OREQ      BKEUCP
     C     KGINCY        ANDEQ     'N'
     C     KGCCY         ANDNE     BKEURO
     C     KGBRCA        ORNE      @SBRCA
     C                   MOVE      *ON           *IN72
     C                   ENDIF
      *
      ** All books & branches, NRCD order
      *
     C     @@FILE        WHENEQ    '7'
     C                   READP     DLIRSEL7                               72
      *
     C     KGCCY         IFNE      @SCCY
     C     @SCCY         ANDNE     BKEUCP
     C     @SCCY         OREQ      BKEUCP
     C     KGINCY        ANDEQ     'N'
     C     KGCCY         ANDNE     BKEURO
     C                   MOVE      *ON           *IN72
     C                   ENDIF
      *
      ** Named book, all branches, NRCD order
      *
     C     @@FILE        WHENEQ    '8'
     C                   READP     DLIRSEL8                               72
      *
     C     KGCCY         IFNE      @SCCY
     C     @SCCY         ANDNE     BKEUCP
     C     @SCCY         OREQ      BKEUCP
     C     KGINCY        ANDEQ     'N'
     C     KGCCY         ANDNE     BKEURO
     C     KGBPBK        ORNE      @SBK23
     C                   MOVE      *ON           *IN72
     C                   ENDIF
      *
     C                   ENDSL
      *
     C     CEU012        WHENEQ    'Y'
     C     @SCCY         ANDEQ     BKEUCP
      *
     C                   SELECT
      *
      ** All books, named branch, maturity date order
      *
     C     @@FILE        WHENEQ    '1'
     C                   READP     DLIRSEL1                               72
      *
      ** Named book & branch, maturity order
      *
     C     @@FILE        WHENEQ    '2'
     C                   READP     DLIRSEL2                               72
      *
      ** All books & branches, maturity order
      *
     C     @@FILE        WHENEQ    '3'
     C                   READP     DLIRSEL3                               72
      *
      ** Named book, all branches, maturity order
      *
     C     @@FILE        WHENEQ    '4'
     C                   READP     DLIRSEL4                               72
      *
      ** Named book & branch, NRCD order
      *
     C     @@FILE        WHENEQ    '5'
     C                   READP     DLIRSEL5                               72
      *
      ** All books, named branch, NRCD order
      *
     C     @@FILE        WHENEQ    '6'
     C                   READP     DLIRSEL6                               72
      *
      ** All books & branches, NRCD order
      *
     C     @@FILE        WHENEQ    '7'
     C                   READP     DLIRSEL7                               72
      *
      ** Named book, all branches, NRCD order
      *
     C     @@FILE        WHENEQ    '8'
     C                   READP     DLIRSEL8                               72
      *
     C                   ENDSL
      *
     C     CEU012        WHENEQ    'N'
     C*
     C** All books, named branch, maturity date order
     C*
     C     @@FILE        IFEQ      '1'                                          B1
     C                   READP     DLIRSSL1                               72    *1
     C*
     C     KGCCY         IFNE      @SCCY                                        B*2
     C     KGBRCA        ORNE      @SBRCA                                       **2
     C                   MOVE      '1'           *IN72                          **2
     C                   END                                                    E*2
     C*
     C                   GOTO      #KE9                                         *1
     C                   END                                                    E1
     C*
     C** Named book & branch, maturity order
     C*
     C     @@FILE        IFEQ      '2'                                          B1
     C                   READP     DLIRSSL2                               72    *1
     C*
     C     KGCCY         IFNE      @SCCY                                        B*2
     C     KGBPBK        ORNE      @SBK23                                       **2
     C     KGBRCA        ORNE      @SBRCA                                       **2
     C                   MOVE      '1'           *IN72                          **2
     C                   END                                                    E*2
     C*
     C                   GOTO      #KE9                                         *1
     C                   END                                                    E1
     C*
     C** All books & branches, maturity order
     C*
     C     @@FILE        IFEQ      '3'                                          B1
     C                   READP     DLIRSSL3                               72    *1
     C*
     C     KGCCY         IFNE      @SCCY                                        B*2
     C                   MOVE      '1'           *IN72                          **2
     C                   END                                                    E*2
     C*
     C                   GOTO      #KE9                                         *1
     C                   END                                                    E1
     C*
     C** Named book, all branches, maturity order
     C*
     C     @@FILE        IFEQ      '4'                                          B1
     C                   READP     DLIRSSL4                               72    *1
     C*
     C     KGCCY         IFNE      @SCCY                                        B*2
     C     KGBPBK        ORNE      @SBK23                                       **2
     C                   MOVE      '1'           *IN72                          **2
     C                   END                                                    E*2
     C*
     C                   GOTO      #KE9                                         *1
     C                   END                                                    E1
     C*
     C** Named book & branch, NRCD order
     C*
     C     @@FILE        IFEQ      '5'                                          B1
     C                   READP     DLIRSSL5                               72    *1
     C*
     C     KGCCY         IFNE      @SCCY                                        B*2
     C     KGBPBK        ORNE      @SBK23                                       **2
     C     KGBRCA        ORNE      @SBRCA                                       **2
     C                   MOVE      '1'           *IN72                          **2
     C                   END                                                    E*2
     C*
     C                   GOTO      #KE9                                         *1
     C                   END                                                    E1
     C*
     C** All books, named branch, NRCD order
     C*
     C     @@FILE        IFEQ      '6'                                          B1
     C                   READP     DLIRSSL6                               72    *1
     C*
     C     KGCCY         IFNE      @SCCY                                        B*2
     C     KGBRCA        ORNE      @SBRCA                                       **2
     C                   MOVE      '1'           *IN72                          **2
     C                   END                                                    E*2
     C*
     C                   GOTO      #KE9                                         *1
     C                   END                                                    E1
     C*
     C** All books & branches, NRCD order
     C*
     C     @@FILE        IFEQ      '7'                                          B1
     C                   READP     DLIRSSL7                               72    *1
     C*
     C     KGCCY         IFNE      @SCCY                                        B*2
     C                   MOVE      '1'           *IN72                          **2
     C                   END                                                    E*2
     C*
     C                   GOTO      #KE9                                         *1
     C                   END                                                    E1
     C*
     C** Named book, all branches, NRCD order
     C*
     C     @@FILE        IFEQ      '8'                                          B1
     C                   READP     DLIRSSL8                               72    *1
     C*
     C     KGCCY         IFNE      @SCCY                                        B*2
     C     KGBPBK        ORNE      @SBK23                                       **2
     C                   MOVE      '1'           *IN72                          **2
     C                   END                                                    E*2
     C                   GOTO      #KE9                                         *1
     C                   END                                                    E1
      *
     C                   ENDSL
     C*
     C     #KE9          ENDSR
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
     C*            IRSRCD  -  RECORD DATA OFF IRS FILE (DATA STRUCT)  *
     C*            @MSGID  -  ERROR MESSAGE NUMBER TO SEND TO ZA0240  *
     C*            @RTYP   -  RECORD TYPE (IF 'RX')                   *
     C*                                                               *
     C*****************************************************************
     C*
     C     #BA           BEGSR
     C*
     C** NOTE: We do not fill the sub-file page entirely for two
     C** reasons: 1) the '+' will cause the last field to be shortened,
     C**          2) by only using the first 15 records, then there is
     C** always a spare record in the sub-file so that 'RX' details are
     C** not split over two screens
     C*
     C                   Z-ADD     1             RRN               2 0
     C*
     C** Need GE condition as RRN may be 16 or 17 at the end
     C*
     C     RRN           DOUGE     16                                           B1
     C*
     C** READ THE IRS FILE
     C*
     C                   EXSR      #KC                                          *1
     C*
     C     *IN71         IFEQ      '1'                                          B*2
     C*
     C     RRN           IFEQ      1                                            B**3
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
     C                   MOVEL     'FIS0004'     @MSGID                         ***3
     C*
     C                   END
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
     C                   WRITE     DL1912C1                                     ***3
     C*
     C                   MOVE      '0'           *IN30                          ***3
     C                   MOVE      IRSRCD        @TOPRD                         ***3
     C*
     C                   END                                                    E**3
     C*
     C** STORE THE RECORD AS THE LAST ONE IN CASE THERE ARE NO MORE
     C*
     C                   MOVE      IRSRCD        @BOTRD                         **2
     C*
     C** EDIT THE FIELDS AND THEN WRITE THE RECORD TO THE SUBFILE
     C*
     C                   EXSR      #BD                                          **2
     C                   WRITE     DL1912S1                                     **2
     C                   ADD       1             RRN                            **2
     C*
     C** If record just written was 'RX' then need to do the preceding
     C** again to display the other side of the deal.
     C*
     C     @RTYP         IFEQ      'RX'                                         B**3
     C                   EXSR      #BD                                           **3
     C*                                                     **3
     C** Set-on ind. 37 to inhibit the select field for other detail
     C** record. Set-off after record written to sub-file.
     C*                                                     **3
     C                   MOVE      '1'           *IN37                           **3
     C                   WRITE     DL1912S1                                      **3
     C                   MOVE      '0'           *IN37                           **3
     C                   ADD       1             RRN                             **3
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
     C*            #BA     -  ROLLUP ENQUIRY SUBFILE                  *
     C*            #BD     -  EDIT ENQUIRY SUBFILE DATA               *
     C*            #KC     -  DETERMINE FILE - READE WITH PROMPT KEY  *
     C*            #KD     -  DETERMINE FILE - SETLL WITH PROMPT KEY  *
     C*            #KE     -  DETERMINE FILE - READP RECORD           *
     C*                                                               *
     C* CALLED BY  #B      -  MAIN PROCESSING                         *
     C*                                                               *
     C* FLDS USED  RRN     -  COUNT FOR ROLLING UP AND DOWN           *
     C*            @@ERMS  -  ERROR-MESSAGE-TO-DISPLAY INDICATOR - Y/N*
     C*            @TOPRD  -  FIRST RECORD CURRENTLY ON SUBFILE       *
     C*            @BOTRD  -  LAST RECORD CURRENTLY ON SUBFILE        *
     C*            IRSRCD  -  RECORD DATA OFF IRS FILE (DATA STRUCT)  *
     C*            @MSGID -   ERROR MESSAGE NUMBER TO SEND TO ZA0240  *
     C*            @RTYP   -  RECORD TYPE (IF 'RX')                   *
     C*                                                               *
     C*****************************************************************
     C*
     C     #BB           BEGSR
     C*
     C** READ THE IRS FILE BACKWARDS AND FILL THE SUBFILE SIMILARLY
     C** NOTE: We do not fill the sub-file page entirely because the
     C** '+' will cause the last field to be shortened.
     C*
     C                   Z-ADD     16            RRN
     C*
     C     RRN           DOUEQ     0                                            B1
     C*
     C** READ THE PREVIOUS RECORD
     C*
     C     *IN71         IFEQ      '1'
     C     *IN30         ANDEQ     '1'
      *
     C                   MOVE      '0'           *IN30
     C                   MOVE      '0'           *IN71
      *
     C                   ENDIF
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
     C** Need to place new top record in key fields first
     C*
     C                   MOVE      @TOPRD        @KRCRD                         ***3
     C*
     C     CEU012        IFEQ      'Y'
     C     @SCCY         ANDEQ     BKEUCP
     C                   MOVE      '0'           *IN71
     C                   ENDIF
      *
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
     C                   WRITE     DL1912C1                                     ***3
     C*
     C                   MOVE      '0'           *IN30                          ***3
     C                   MOVE      IRSRCD        @BOTRD                         ***3
     C*
     C                   END                                                    E**3
     C*
     C** EDIT THE FIELDS AND THEN WRITE THE RECORD TO THE SUBFILE
     C** NOTE: Have to do things differently if record is an RX detail.
     C*
     C     @RTYP         IFNE      'RX'                                         B**3
     C*                                                     **3
     C                   EXSR      #BD                                           **3
     C                   WRITE     DL1912S1                                      **3
     C                   SUB       1             RRN                             **3
     C*                                                     **3
     C                   ELSE                                                   X**3
     C*                                                     **3
     C** If RRN = 1, then we cannot write RX detail record as we would
     C** go off the top of the sub-file. In this case we also need to
     C** re-position the file pointer to the last record that was put
     C** in the sub-file otherwise the current record will not be
     C** displayed on a subsequent roll-down. READE should be
     C** sufficient for re-positioning as it is unlikely that the file
     C** has changed at this point in the meantime.
     C*                                                     **3
     C     RRN           IFEQ      1                                            B***4
     C                   EXSR      #KC                                           ***4
     C*                                                     ***4
     C** Re-set counter to zero to indicate that sub-file is full
     C*                                                     ***4
     C                   Z-ADD     0             RRN                             ***4
     C*                                                     ***4
     C                   ELSE                                                   X***4
     C*                                                     ***4
     C** At this point, we know that we have an 'RX' record to write.
     C** Fill the sub-file record before this one. Adding 1 to RRN
     C** after this means that we write to current sub-file record and
     C** subtracting 2 afterwards gives us the next free sub-file
     C** record for next time round.                        ***4
     C*                                                     ***4
     C                   EXSR      #BD                                           ***4
     C                   SUB       1             RRN                             ***4
     C                   WRITE     DL1912S1                                      ***4
     C                   EXSR      #BD                                           ***4
     C                   ADD       1             RRN                             ***4
     C*
     C** Set-on ind. 37 to inhibit the select field for other detail
     C** record. Set-off after record written to sub-file.
     C*
     C                   MOVE      '1'           *IN37                           ***4
     C                   WRITE     DL1912S1                                      ***4
     C                   MOVE      '0'           *IN37                           ***4
     C                   SUB       2             RRN                             ***4
     C*                                                     ***4
     C                   END                                                    E***4
     C*                                                     **3
     C                   END                                                    E**3
     C*                                                     *2
     C** STORE THE RECORD AS THE FIRST ONE IN CASE IT IS    *2
     C*                                                     *2
     C                   MOVE      IRSRCD        @TOPRD                          *2
     C*                                                     *2
     C                   END                                                    E*2
     C*                                                     1
     C                   END                                                    E1
     C*
     C     #BB9          ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #BC      - ENTER NEW PROMPT DATA                              *
     C*                                                               *
     C* CALLS      #BCA    -  VALIDATE PROMPT DATA                    *
     C*            #BCB    -  SET UP NEW SCREEN HEADINGS              *
     C*            #BCC    -  DETERMINE FILE AND KEY TO BE USED       *
     C*            #BD     -  EDIT ENQUIRY SUBFILE DATA               *
     C*            #KC     -  DETERMINE FILE - READE WITH PROMPT KEY  *
     C*            #KD     -  DETERMINE FILE - SETLL WITH PROMPT KEY  *
     C*            ZA0240  -  ADD MESSAGE TO PROGRAM MESSAGE QUEUE    *
     C*                                                               *
     C* CALLED BY  #B      -  MAIN PROCESSING                         *
     C*                                                               *
     C* FLDS USED  @@ERMS  -  ERROR-MESSAGE-TO-DISPLAY INDICATOR - Y/N*
     C*            IRSRCD  -  RECORD DATA OFF IRS FILE (DATA STRUCT)  *
     C*            @KRCRD  -  RECORD DATA OF KEYS                     *
     C*            @SRCRD  -  SCREEN FIELDS DATA STRUCTURE            *
     C*            @RTYP   -  RECORD TYPE (IF 'RX')                   *
     C*            @SDORD  -  DATE ORDER SEQUENCE                     *
     C*            @FROM   -  WHERE CALL TO PROGRAM CAME FROM         *
     C*            @SVLDY  -  DAY NO OF SCREEN START DATE             *
     C*            @KERTC  -  KEY FIELD NEXT RATE CHANGE DATE         *
     C*            @KMATD  -  KEY FIELD MATURITY DATE                 *
     C*            RRN     -  NEXT EMPTY RECORD IN SUB-FILE           *
     C*            @MSGID  -  ERROR MESSAGE NUMBER TO SEND TO ZA0240  *
     C*            @TOPRD  -  DATA STRUCTURE FOR TOP RECORD ON SCREEN *
     C*            @BOTRD  -  DATA STRUCTURE FOR BOTTOM SCREEN RECORD *
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
      *
      * else if from stack, move screen Broker field into
      * data structure to enable heading to be set up correctly
      * (done in validation if from menu)
     C                   ELSE
     C                   MOVE      @SBOOK        @@SBK
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
     C** If not from stack, then save new key data from screen and
     C** position file pointer at start of relevant data (#KD),
     C** otherwise position at specific point in file (#KA)
     C*
     C     @FROM         IFNE      'S'                                          B*2
     C*
     C                   MOVEL     @SRCRD        @KRCRD                         **2
     C*
     C** Move start date into @KMDAT/@KNRCD depending on date seq (M/N)
     C*
     C     @SDORD        IFEQ      'N'                                          B**3
     C                   Z-ADD     @SVLDY        @KERTC                          **3
     C                   Z-ADD     0             @KMDAT                          **3
     C                   ELSE                                                   X**3
     C                   Z-ADD     @SVLDY        @KMDAT                          **3
     C                   Z-ADD     0             @KERTC                          **3
     C                   END                                                    E**3
     C*
     C                   EXSR      #KD                                          **2
     C*
     C                   ELSE                                                   X*2
     C*
     C                   EXSR      #KA                                          **2
     C*
     C                   END                                                    E*2
     C*
     C** DO FOR AS MANY RECORDS AS THERE ARE IN THE SUBFILE PAGE
     C*
     C                   Z-ADD     1             RRN               2 0          *1
     C*
     C     RRN           DOUGE     16                                           B*2
     C*
     C** READ THE IRS FILE
     C*
      *
     C                   MOVE      *OFF          *IN71
      *
     C                   EXSR      #KC                                          **2
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
     C                   WRITE     DL1912C1                                     ****4
     C*
     C                   MOVE      '0'           *IN30                          ****4
     C                   MOVE      IRSRCD        @TOPRD                         ****4
     C*
     C** SET UP NEW SCREEN HEADINGS
     C*
     C                   EXSR      #BCB                                         ****4
     C*
     C                   END                                                    E***4
     C*
     C** STORE THE RECORD AS THE LAST ONE IN CASE THERE ARE NO MORE
     C*
     C                   MOVE      IRSRCD        @BOTRD                         ***3
     C*
     C** EDIT THE FIELDS AND THEN WRITE THE RECORD TO THE SUBFILE
     C*
     C                   EXSR      #BD                                          ***3
     C                   WRITE     DL1912S1                                     ***3
     C                   ADD       1             RRN                            ***3
     C*
     C** If record just written was 'RX' then need to do the preceding
     C** again to display the other side of the deal.
     C*
     C     @RTYP         IFEQ      'RX'                                         B***4
     C                   EXSR      #BD                                          ****4
     C*
     C** Set-on ind. 37 to inhibit the select field for other detail
     C** record. Set-off after record written to sub-file.
     C*
     C                   MOVE      '1'           *IN37                          ****4
     C                   WRITE     DL1912S1                                     ****4
     C                   MOVE      '0'           *IN37                          ****4
     C                   ADD       1             RRN                            ****4
     C                   END                                                    E***4
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
     C* FLDS USED  @SCCY   -  CURRENCY SELECTED IN PROMPTS            *
     C*            @SBRCA  -  BOOKING BRANCH CODE SELECTED IN PROMPTS *
     C*            @SSDAT  -  START DATE SELECTED IN PROMPTS          *
     C*            @SVLDY  -  VALUE MIDAS DAY NO SELECTED IN PROMPTS  *
     C*            @SBOOK  -  BOOK CODE SELECTED IN PROMPTS           *
     C*            @SDORD  -  DATE ORDER SEQUENCE SELECTED IN PROMPTS *
     C*            @@ERMS - ERROR-MESSAGE-TO-DISPLAY INDICATOR - Y/N  *
     C*            @MSGID - ERROR MESSAGE NUMBER TO SEND TO ZA0240    *
     C*            @FBOOK - DEFAULT BOOK                              *
     C*            @FSDAT - DEFAULT START DATE                        *
     C*            @FVLDY - DEFAULT START DATE DAY NO                 *
     C*            @FBRCA - IRS ENQUIRY DEFAULT BRANCH                *
     C**           @@RTN  - RETURN CODE FROM STANDARD SUB-ROUTINE     *
     C*                                                               *
     C*****************************************************************
     C*
     C     #BCA          BEGSR
     C*
     C** VALIDATE THE DATE ORDER SEQUENCE REQUESTED
     C*
     C     @SDORD        IFNE      'M'                                          B1
     C     @SDORD        ANDNE     'N'                                          *1
     C*
     C** SET UP PARAMETER FOR ZA0240 AND CALL THE PROGRAM TO ADD
     C** ANOTHER MESSAGE TO THE PROGRAM MESSAGE QUEUE
     C*
     C                   MOVEL     'FIS0012'     @MSGID                         *1
     C                   CALL      'ZA0240'                                     *1
     C                   PARM                    @MSGID                         *1
     C*
     C** SET ON ERROR-ON-SEQUENCE AND ERROR-ON-VALIDATION INDICATORS
     C*
     C                   MOVE      '1'           *IN63                          *1
     C                   MOVE      '1'           *IN69                          *1
     C*
     C                   ELSE                                                   X1
     C*
     C** SET UP PARAMETER DOWN VALUE IN CASE SELECTED
     C*
     C                   MOVE      @SDORD        @DDORD                         *1
     C                   END                                                    E1
     C*
     C** VALIDATE THE CURRENCY
     C** - CURRENCY MUST BE ENTERED AND EXIST ON CURRENCY FILE
     C*
     C     @SCCY         IFEQ      *BLANK                                       B1
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
     C*
     C*
      * Call access program to validate currency
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      @SCCY         @CCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
     C*
     C     @RTCD         IFNE      *BLANKS
     C     CEU012        ANDEQ     'Y'
     C     @SCCY         ANDNE     BKEUCP
     C     @RTCD         ORNE      *BLANKS
     C     CEU012        ANDEQ     'N'
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
     C                   MOVE      '1'           *IN69                          **2
      *
      * Set on currency field error indicator
     C                   MOVE      '1'           *IN60
     C*
     C                   ELSE                                                   X*2
     C     @SCCY         IFNE      BKEUCP
     C                   MOVE      A6CYCD        @SCCY
     C                   ENDIF
     C*
     C** SET UP PARAMETER DOWN VALUE IN CASE SELECTED
     C*
     C                   MOVE      @SCCY         @DCCY                          **2
     C     CEU012        IFEQ      'Y'
      *
     C     @SCCY         IFEQ      BKEUCP
     C                   Z-ADD     *ZEROS        @KCSQ
     C                   Z-ADD     *ZEROS        @CSSN
     C                   ELSE
     C                   MOVE      A6SSNB        @KCSQ
     C                   MOVE      A6SSNB        @CSSN
     C                   ENDIF
      *
     C                   MOVE      A6INCY        @KINC
      *
     C                   ENDIF
     C                   END                                                    E*2
     C*
     C                   END                                                    E1
     C*
     C** VALIDATE THE TRADING BOOK CODE
      *
      * If the field is blanks, move the default IRS Trading
      * Book Code back in
     C     @SBOOK        IFEQ      *BLANKS
     C                   MOVE      @FBOOK        @SBOOK
     C                   END
     C*
      * Since the Book Code screen field is 3A, a book code may
      * have been entered in either positions 1-2, or 2-3, so
      * need to check both possibilities
      *
      * Move screen field into data structure to split the field
     C                   MOVE      @SBOOK        @@SBK
      *
      * If 'ALL' Book Codes requested no validation needed
     C     @@SBK         IFNE      'ALL'
      *
      * Determine which character positions of book code field
      * to use for validation
      * If first char. is blank, use last two chars., otherwise
      * use first two chars. (If the first and last chars. both
      * contain data, or both contain blanks, the entry is invalid)
     C     @SBK1         IFNE      *BLANKS
     C     @SBK3         ANDNE     *BLANKS
      *
     C     @SBK1         OREQ      *BLANKS
     C     @SBK3         ANDEQ     *BLANKS
      *
     C                   MOVE      '1'           *IN64
     C                   ELSE
     C*
     C     @SBK1         IFEQ      *BLANKS
     C*
     C* Use last two chars.
     C                   MOVE      @SBOOK        @SBK              2
     C                   ELSE
     C*
     C* Use first two chars.
     C                   MOVEL     @SBOOK        @SBK
     C*
     C                   END
     C                   END
     C*
     C*
     C* If no error so far call access program to validate Book Code
     C     *IN64         IFEQ      '0'
     C                   CALL      'AOBOOKR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      @SBK          @BOOK             2
     C     SDBOOK        PARM      SDBOOK        DSFDY
     C                   END
     C*
     C     @RTCD         IFNE      *BLANKS
     C     *IN64         OREQ      '1'
     C*
     C** SET UP PARAMETER FOR ZA0240 AND CALL THE PROGRAM TO ADD
     C** ANOTHER MESSAGE TO THE PROGRAM MESSAGE QUEUE
     C*
     C                   MOVEL     'FIS0009'     @MSGID
     C                   CALL      'ZA0240'
     C                   PARM                    @MSGID
     C*
     C** SET ON ERROR-ON-BOOK-CODE AND ERROR-ON-VALIDATION INDICATORS
     C** (*IN64 MAY ALREADY HAVE BEEN SET ON)
     C*
     C                   MOVE      '1'           *IN64
     C                   MOVE      '1'           *IN69
      *
      * Right-justify Book Code whether or not field is in error
     C                   MOVE      *BLANKS       @SBOOK
     C                   MOVE      @SBK          @SBOOK
     C                   ELSE
     C                   MOVE      BDBKCD        @SBOOK
     C                   MOVEL     ' '           @SBOOK
      *
      * Move screen field back into data structure for correct
      * positioning of header field
     C                   MOVE      @SBOOK        @@SBK
     C*
     C                   END
     C*
     C                   END
     C*
     C** IF NO ERROR, THEN SET UP PARAMETER DOWN VALUE
     C*
     C     *IN64         IFEQ      '0'                                          B1
     C                   MOVE      @SBOOK        @DBPBK                          1
     C                   END                                                    E1
     C*
     C** VALIDATE THE START DATE
     C*  - IF ENTERED MUST BE A VALID DATE
     C*
     C     @SSDAT        IFEQ      *BLANK                                       B1
     C*
     C** SET TO BLANK
     C                   MOVE      *BLANKS       @SSDAT                         *1
     C                   Z-ADD     0             @SVLDY                         *1
     C*
     C                   ELSE                                                   X1
     C*
     C** IF NOT RUN DATE (DEFAULT) THEN VALIDATE THE DATE
     C*
     C*
     C**  Convert date from MMMDDYY/DDMMMYY to MMDDYY/DDMMYY format
     C*
     C                   MOVE      @FSDAT        ZADATE
     C                   MOVE      '0'           *IN18
     C                   EXSR      CVDT
     C                   MOVE      ZDATE         ZDATE6            6
     C     @SSDAT        IFNE      ZDATE6
     C*
     C**  If @SSDAT is not blank, check input date if it conforms
     C**  with the valid month numbers listed in array @MON and the
     C**  year in array @YR. Check also if day input is valid, i.e.
     C*   ranging from 01 to 31.
     C                   MOVEL     @SSDAT        @DDMM             4
     C                   MOVEL     @DDMM         @DN               2
     C                   MOVEL     @DN           @D1               1
     C     @D1           IFEQ      *BLANKS
     C                   MOVEL     '0'           @DN
     C                   MOVEL     '0'           @SSDAT
     C                   END
     C                   MOVE      @DDMM         @MN               2
     C                   MOVE      @SSDAT        @YN               2
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
     C**  set on if error invalidation, if successful store no. of days
     C*
     C                   ELSE
                                                                                CAAA02
     C************       MOVE      @SSDAT        ZDATE                          CAAA02
      * Subroutine replaced by external module                                  CAAA02
     C************       EXSR      ZDATE1                                       CAAA02
     c                   callb     'ZDATE1'                                     CAAA02
     c                   parm                    @SSDAT                         CAAA02
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
     C     *IN99         IFEQ      '1'                                          B**3
     C*
     C** SET UP PARAMETER FOR ZA0240 AND CALL THE PROGRAM TO ADD
     C** ANOTHER MESSAGE TO THE PROGRAM MESSAGE QUEUE
     C*
     C                   MOVEL     'FIS0022'     @MSGID           10            ***3
     C                   CALL      'ZA0240'                                     ***3
     C                   PARM                    @MSGID                         ***3
     C*
     C** SET ON ERROR-ON-START-DATE AND ERROR-ON-VALIDATION INDICATORS
     C*
     C                   MOVE      '1'           *IN62                          ***3
     C                   MOVE      '1'           *IN69                          ***3
     C*
     C                   ELSE                                                   X**3
     C*
     C** ELSE IF VALID START DATE SET UP CORRESPONDING MIDAS DAY NO
     C*
     C                   Z-ADD     @@DAYN        @SVLDY            5 0          ***3
     C**
     C*
     C                   MOVEL     @SSDAT        @D1
     C     @D1           IFEQ      '0'
     C                   MOVEL     ' '           @SSDAT
     C                   END
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
     C                   END                                                    E1
     C*
     C** IF NO ERROR, THEN SET UP PARAMETER DOWN VALUE
     C*
     C     *IN62         IFEQ      '0'                                          B1
     C*
     C**  If @SSDAT is blank, set @DSDAT to blank and bypass
     C**    CVDT subroutine.
     C*
     C     @SSDAT        IFEQ      *BLANK
     C                   MOVE      *BLANKS       @DSDAT
     C                   ELSE
     C                   MOVEL     @SSDAT        @DSDAT                          1
     C                   END
     C                   Z-ADD     @SVLDY        @DVLDY                          1
     C                   END                                                    E1
     C*
     C* Validate Booking Branch
     C*
      *
      * Field already set to IRS Enquiry Default Branch
      * If multibranched and field left blank, move default back in
     C     @SBRCA        IFEQ      *BLANKS
     C                   MOVE      @FBRCA        @SBRCA
     C                   END
     C*
      * If non-multibranched, no validation needed for branch
     C     BGMBIN        IFEQ      'Y'
      *
      * If entered branch code is not 'ALL', validate using
      * using call to access object
     C     @SBRCA        IFNE      'ALL'
     C     BGMBIN        ANDEQ     'Y'
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      @SBRCA        @BRCA             3
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
     C*
     C     @RTCD         IFNE      *BLANKS
     C*
     C** SET UP PARAMETER FOR ZA0240 AND CALL THE PROGRAM TO ADD
     C** ANOTHER MESSAGE TO THE PROGRAM MESSAGE QUEUE
     C*
     C                   MOVEL     'FIS0002'     @MSGID
     C                   CALL      'ZA0240'
     C                   PARM                    @MSGID
     C*
     C** SET ON ERROR-ON-VALIDATION INDICATOR
     C*
     C                   MOVE      '1'           *IN69
     C                   MOVE      '1'           *IN61
     C*
     C                   ELSE
      *
      * else if Branch Code valid, check user is authorized to it
     C                   MOVEL     A8BRCD        @SBRCA
     C                   CALL      'ZVBBU'
     C                   PARM      @SBRCA        @BRCA
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
     C*
     C                   END
     C*
     C                   ELSE
      *
      * else if 'ALL' Branches requested, check user has Bank
      * Level Authority
     C     BANK          IFNE      'Y'
      *
      * Not authorized, so set up error message I.D. and set
      * on error indicators
     C                   MOVEL     'FIS0027'     @MSGID
     C                   CALL      'ZA0240'
     C                   PARM                    @MSGID
     C                   MOVE      '1'           *IN69
     C                   MOVE      '1'           *IN61
     C*
     C*
     C                   END
     C*
     C                   END
     C                   END
     C*
     C** IF NO ERROR, SET UP PARAMETER DOWN VALUE
     C*
     C     *IN61         IFEQ      '0'
     C                   MOVE      @SBRCA        @DBRCA
     C                   END
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
     C*                                                               *
     C* #BCB     - SET UP NEW SCREEN HEADINGS                         *
     C*                                                               *
     C* CALLS                                                         *
     C*                                                               *
     C* CALLED BY  #BC    - ENTER NEW PROMPT DATA                     *
     C*                                                               *
     C* FLDS USED  @FBOOK - BOOK CODE   DEFAULT VALUE                 *
     C*                                                               *
     C*            @TBOOK - BOOK CODE  )                              *
     C*            @TCCY  - CURRENCY   )  VALUES FOR NEW SCREEN       *
     C*            @TBRCH - BRANCH     )  HEADINGS                    *
     C*            @TDORD - DATE SEQ.  )                              *
     C*            @TSDAT - START DATE )                              *
     C*                                                               *
     C*            @SCCY  - CURRENCY   )                              *
     C*            @SBRCA - BRANCH     )  VALID ENTRIES RECEIVED      *
     C*            @SDORD - DATE SEQ.  )  FROM PROMPTS                *
     C*            @SBOOK - BOOK CODE  )                              *
     C*            @SSDAT - START DATE )                              *
     C*                                                               *
     C*            @@ERMS - ERROR-MESSAGE-TO-DISPLAY INDICATOR - Y/N  *
     C*            @MSGID - ERROR MESSAGE NUMBER TO SEND TO ZA0240    *
     C*            @SBK23 - LAST TWO CHARS. OF BOOK CODE PROMPT FIELD *
     C*                     (USED TO SHIFT BOOK CODE TO RIGHT OF      *
     C*                      FIELD @TBOOK)                            *
     C*                                                               *
     C*****************************************************************
     C*
     C     #BCB          BEGSR
     C*
     C** SET UP HEADING FOR BOOK CODE
     C*
      * If field was left blank at prompt, will contain the IRS
      * Trading Book Code from file SDFAISPD as default
      * (ALL must be actually entered if required)
     C     @SBOOK        IFEQ      'ALL'
     C                   MOVE      @SBOOK        @TBOOK
     C                   ELSE
     C                   MOVE      *BLANKS       @TBOOK
     C                   MOVEL     @SBK23        @TBOOK
     C                   END
     C*
     C** SET UP HEADING FOR CURRENCY
     C** - THE SAME AS THE VALID PROMPT ENTRY
     C*
     C                   MOVE      @SCCY         @TCCY
     C*
     C** SET UP HEADING FOR BRANCH
      *
      * If not multibranched, branch not displayed
      * If field was left blank at prompt, will contain the IRS
      * Enquiry Default Branch from file SDFAISPD as default
      * (ALL must be actually entered if required)
     C                   MOVE      @SBRCA        @TBRCH
     C*
     C*
     C** Set up heading for date order sequence text
     C*
     C     @SDORD        IFEQ      'N'
     C                   MOVE      TXT(1)        @TSEQ
     C                   ELSE
     C                   MOVE      TXT(2)        @TSEQ
     C                   END
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
     C*            @SDORD - DATE ORDER  ) KEY TO BE DETERMINED        *
     C*            @SBOOK - BOOK CODE   ) ACCORDING TO COMBINATION    *
     C*            @SBRCA - BRANCH      ) OF FIELDS SELECTED          *
     C*                                                               *
     C*****************************************************************
     C*
     C     #BCC          BEGSR
     C*
     C* N.B. IF THE BOOK CODE OR BRANCH PROMPT FIELDS ARE LEFT BLANK
     C*      THEY WILL NO LONGER DEFAULT TO 'ALL' BUT TO THE IRS
     C*      ENQUIRY DEFAULT HELD IN FILE SDFAISPD
     C*      THE FIELD WILL THEREFORE ALWAYS CONTAIN A VALUE, BUT
     C*      MUST BE CHECKED TO SEE IF 'ALL' HAS BEEN ENTERED
     C*
     C** DECIDE WHICH FILE IS TO BE USED - DEPENDING ON PROMPTS INPUT
     C** AS FOLLOWS.
     C*     B - 'ALL'      V - VALUE (DEFAULT IF FIELD LEFT BLANK)
     C*   **************************************************
     C*   *               BOOK         BRANCH    MDAT/NRCD *
     C*   *                                        (M/N)   *
     C*   * DLIRSSL1       B             V           M     *
     C*   * DLIRSSL2       V             V           M     *
     C*   * DLIRSSL3       B             B           M     *
     C*   * DLIRSSL4       V             B           M     *
     C*   * DLIRSSL5       V             V           N     *
     C*   * DLIRSSL6       B             V           N     *
     C*   * DLIRSSL7       B             B           N     *
     C*   * DLIRSSL8       V             B           N     *
     C*   **************************************************
     C*
     C     @SBOOK        IFEQ      'ALL'                                        B1
     C     @SBRCA        ANDNE     'ALL'                                        *1
     C     @SDORD        ANDEQ     'M'                                          *1
     C                   MOVE      '1'           @@FILE            1            *1
     C                   GOTO      #BCC9                                        *1
     C                   END                                                    E1
     C*
     C     @SBOOK        IFNE      'ALL'                                        B1
     C     @SBRCA        ANDNE     'ALL'                                        *1
     C     @SDORD        ANDEQ     'M'                                          *1
     C                   MOVE      '2'           @@FILE                         *1
     C                   GOTO      #BCC9                                        *1
     C                   END                                                    E1
     C*
     C     @SBOOK        IFEQ      'ALL'                                        B1
     C     @SBRCA        ANDEQ     'ALL'                                        *1
     C     @SDORD        ANDEQ     'M'                                          *1
     C                   MOVE      '3'           @@FILE                         *1
     C                   GOTO      #BCC9                                        *1
     C                   END                                                    E1
     C*
     C     @SBOOK        IFNE      'ALL'                                        B1
     C     @SBRCA        ANDEQ     'ALL'                                        *1
     C     @SDORD        ANDEQ     'M'                                          *1
     C                   MOVE      '4'           @@FILE                         *1
     C                   GOTO      #BCC9                                        *1
     C                   END                                                    E1
     C*
     C     @SBOOK        IFNE      'ALL'                                        B1
     C     @SBRCA        ANDNE     'ALL'                                        *1
     C     @SDORD        ANDEQ     'N'                                          *1
     C                   MOVE      '5'           @@FILE                         *1
     C                   GOTO      #BCC9                                        *1
     C                   END                                                    E1
     C*
     C     @SBOOK        IFEQ      'ALL'                                        B1
     C     @SBRCA        ANDNE     'ALL'                                        *1
     C     @SDORD        ANDEQ     'N'                                          *1
     C                   MOVE      '6'           @@FILE                         *1
     C                   GOTO      #BCC9                                        *1
     C                   END                                                    E1
     C*
     C     @SBOOK        IFEQ      'ALL'                                        B1
     C     @SBRCA        ANDEQ     'ALL'                                        *1
     C     @SDORD        ANDEQ     'N'                                          *1
     C                   MOVE      '7'           @@FILE                         *1
     C                   GOTO      #BCC9                                        *1
     C                   END                                                    E1
     C*
     C     @SBOOK        IFNE      'ALL'                                        B1
     C     @SBRCA        ANDEQ     'ALL'                                        *1
     C     @SDORD        ANDEQ     'N'                                          *1
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
     C* CALLS      NONE                                               *
     C*                                                               *
     C* CALLED BY  #BA     -  ROLLUP ENQUIRY SUBFILE                  *
     C*            #BB     -  ROLLDOWN ENQUIRY SUBFILE                *
     C*            #BC     -  ENTER NEW PROMPT DATA                   *
     C*                                                               *
     C* FLDS USED  DDDLNO  -  DEAL NO       )                         *
     C*            DDNRCD  -  NXT RATE CHG DATE)                      *
     C*            DDMTDT  -  MATURITY DATE )  DISPLAY FIELDS FOR THE *
     C*            DDDTAM  -  DEAL TYP/AMOUNT) ENQUIRY SUBFILE        *
     C*            DDOPAY  -  OUR PAY       )                         *
     C*            DDOREC  -  OUR RECEIVE   )                         *
     C*            DDXOCD  -  OTHER CURRENCY)                         *
     C*                                                               *
     C*            KGDLNO  -  DEAL NO       )                         *
     C*            KGERDD  -  EARLIEST NRCD )                         *
     C*            KGMTDD  -  MATURITY DATE )  FIELDS FROM DEALS      *
     C*            KGAMOD  -  AMOUNT        )  FILE TO BE EDITED      *
     C*            KGDTPD  -  DEAL TYPE     )  BEFORE DISPLAY IN THE  *
     C*            KGOPD1  -  OUR PAY 1     )  ENQUIRY SUBFILE        *
     C*            KGOPD2  -  OUR PAY 2     )                         *
     C*            KGORD1  -  OUR RECEIVE 1 )                         *
     C*            KGORD2  -  OUR RECEIVE 2 )                         *
     C*            KGXOAD  -  OTHER AMOUNT  )                         *
     C*            KGXOCD  -  OTHER CURRENCY)                         *
     C*            KGXOP1  -  OTHER PAY 1   )                         *
     C*            KGXOP2  -  OTHER PAY 2   )                         *
     C*            KGXOR1  -  OTHER RECEIVE 1)                        *
     C*            KGXOR2  -  OTHER RECEIVE 2)                        *
     C*                                                               *
     C*            @RTYP   -  RECORD TYPE (IF 'RX')                   *
     C*            @DTYP   -  DEAL TYPE                               *
     C*            @PRVRX  -  WAS PREVIOUS RECORD 'RX' DETAIL         *
     C*****************************************************************
     C*
     C     #BD           BEGSR
     C*
     C** Clear the Pay/Receive signs (<,>)
     C*
     C                   MOVE      *BLANKS       @@PAYS
     C                   MOVE      *BLANKS       @@RECS
     C*
     C** EDIT THE DISPLAY FIELDS FOR SUBFILE BEFORE WRITING TO IT.
     C** ANY FIELDS THAT DO NOT NEED EDITING CAN JUST BE MOVED
     C** DIRECTLY INTO THEIR EQUIVALENT FIELD IN THE DISPLAY FILE.
     C** IF THE DEAL TYPE WAS 'RX' LAST TIME THIS SUB-ROUTINE WAS
     C** CALLED, THEN 'RX_OTHER_DETAILS' MUST BE MOVED INTO FIELDS.
     C*
     C     @PRVRX        IFEQ      'N'                                          B1
     C*                                                     1
     C** DEAL NO DOES NOT NEED EDITING                      1
     C*                                                     1
     C                   MOVE      KGDLNO        DDDLNO                          1
     C*                                                     1
     C** Next rate change date does not need editing        1
     C*                                                     1
     C                   MOVE      KGERDD        DDNRCD                          1
     C                   Z-ADD     KGERTC        DDERTC                          1
     C*                                                     1
     C** Maturity date does not need editing                1
     C*                                                     1
     C                   MOVE      KGMTDD        DDMTDT                          1
     C                   Z-ADD     KGMDAT        DDMDAT                          1
     C*                                                     1
     C** Amount field does not need editing.                1
     C** NOTE: Deal type shares the same field for display purposes;
     C**       will need editing if type is 'RX'            1
     C*                                                     1
      *
      ** If prompt currency is equal to Consolidated Euro Currency
      ** Code and amount is to be displayed in its Euro Equivalent,
      ** convert the amount using EU0200.
      *
     C     CEU012        IFEQ      'Y'
      *
     C     KGINCY        IFEQ      'Y'
     C     *IN75         ANDEQ     '1'
     C     KGCCY         ANDNE     BKEURO
     C     KGAMOD        ANDNE     *ZEROS
      *
     C                   MOVE      *BLANKS       PRTCD
     C                   Z-ADD     *ZEROS        NAMNT            15 0
     C                   MOVE      KGAMOD        NAMNT
     C                   Z-ADD     NAMNT         PFRAM
     C                   MOVE      KGCCY         PFRCY
     C                   MOVE      BKEURO        PTOCY
     C                   Z-ADD     0             POUTA
     C                   Z-ADD     0             PINTA
     C                   Z-ADD     0             PEXRT
     C                   MOVE      *BLANKS       PMDIN
      *
     C                   CALL      'EU0200'                             8383
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
                                                                                CAAA02
     C************       MOVE      POUTA         ZFIELD                         CAAA02
     C************       Z-ADD     0             ZADEC                          CAAA02
      * Subroutine replaced by external module                                  CAAA02
     C************       EXSR      ZEDIT                                        CAAA02
     c                   callb     'ZEDIT'                                      CAAA02
     c                   parm                    POUTA                          CAAA02
     c                   parm                    ZZero                          CAAA02
                                                                                CAAA02
     C                   MOVE      *BLANKS       DDDTAM
     C************       MOVE      ZFIELD        DDDTAM                         CAAA02
     c                   move      POUTA         DDDTAM                         CAAA02
     C                   MOVEL     KGDTPD        DDDTAM
     C                   MOVE      *BLANKS       DDXOCD
     C                   ELSE
     C                   MOVEL     '*CALL   '    DBFILE
     C                   MOVEL     'EU0200  '    DBKEY                           ************
     C                   Z-ADD     3             DBASE                           * DBERR 03 *
     C                   EXSR      *PSSR                                         ************
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVE      *BLANKS       DDDTAM
     C                   MOVE      KGAMOD        DDDTAM
     C                   MOVEL     KGDTPD        DDDTAM
     C                   MOVE      KGCCY         DDXOCD
     C                   ENDIF
      *
     C     @SCCY         IFEQ      BKEUCP
     C     KGCCY         ANDEQ     BKEURO
     C                   MOVE      *BLANKS       DDXOCD
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   MOVE      KGAMOD        DDDTAM                          1
     C                   MOVE      *BLANKS       DDXOCD                          1
     C                   MOVEL     KGDTPD        DDDTAM                          1
      *
     C                   ENDIF
     C*                                                     1
     C** If this is an 'RX' record, need to remember this for next time
     C** this sub-routine is called                         1
     C*                                                     1
     C     @RTYP         IFEQ      'RX'                                         B*2
     C                   MOVE      'Y'           @PRVRX                          *2
     C                   END                                                    E*2
     C*
     C** Our pay/rec fields will need editing if deal type is
     C** cap, collar or floor - output fields DDOPAY and DDOREC
     C*
     C     @DLTP         IFEQ      'CAP'                                        B2
     C     @DLTP         OREQ      'CLR'                                         2
     C     @DLTP         OREQ      'FLR'                                         2
     C*
     C                   MOVEL     KGOPD1        @@OPD1                          2
     C     @DTYP         IFEQ      'CAP-S'                                      B*3
     C     @DTYP         OREQ      'CLR-S'                                       *3
     C                   MOVE      ' > '         @@PAYS                          *3
     C                   ELSE                                                   X*3
     C     @DTYP         IFEQ      'CLR-B'                                      B**4
     C     @DTYP         OREQ      'FLR-S'                                       **4
     C                   MOVE      ' < '         @@PAYS                          **4
     C                   END                                                    E**4
     C                   END                                                    E*3
     C*
     C                   MOVEL     KGOPD2        @@OPD2                          2
     C*
     C                   MOVEL     KGORD1        @@ORD1                          2
     C     @DTYP         IFEQ      'CAP-B'                                      B*3
     C     @DTYP         OREQ      'CLR-B'                                       *3
     C                   MOVE      ' > '         @@RECS                          *3
     C                   ELSE                                                   X*3
     C     @DTYP         IFEQ      'CLR-S'                                      B**4
     C     @DTYP         OREQ      'FLR-B'                                       **4
     C                   MOVE      ' < '         @@RECS                          **4
     C                   END                                                    E**4
     C                   END                                                    E*3
     C*
     C                   MOVEL     KGORD2        @@ORD2                          2
     C*
     C                   ELSE                                                   X2
     C*
     C                   MOVEL     KGOPD1        DDOPAY                          2
     C                   MOVEL     KGOPD2        @@OPD2                          2
     C                   MOVEL     KGORD1        DDOREC                          2
     C                   MOVEL     KGORD2        @@ORD2                          2
     C*
     C                   END                                                    E2
     C*
     C** Deal type was RX last time, so set up other detail record
     C*
     C                   ELSE                                                   X1
      *
      ** If prompt currency is equal to Consolidated Euro Currency
      ** Code and amount is to be displayed in its Euro Equivalent,
      ** convert the amount using EU0200.
      *
     C     CEU012        IFEQ      'Y'
      *
     C     KGINCY        IFEQ      'Y'
     C     *IN75         ANDEQ     '1'
     C     KGXOAD        ANDNE     *ZEROS
     C     KGCCY         ANDNE     BKEURO
      *
     C                   MOVE      *BLANKS       PRTCD
     C                   Z-ADD     *ZEROS        NAMNT            15 0
     C                   MOVE      KGXOAD        NAMNT
     C                   Z-ADD     NAMNT         PFRAM
     C                   MOVE      KGCCY         PFRCY
     C                   MOVE      BKEURO        PTOCY
     C                   Z-ADD     0             POUTA
     C                   Z-ADD     0             PINTA
     C                   Z-ADD     0             PEXRT
     C                   MOVE      *BLANKS       PMDIN
      *
     C                   CALL      'EU0200'                             8383
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
                                                                                CAAA02
     C************       MOVE      POUTA         ZFIELD                         CAAA02
     C************       Z-ADD     0             ZADEC                          CAAA02
      * Subroutine replaced by external module                                  CAAA02
     C************       EXSR      ZEDIT                                        CAAA02
     c                   callb     'ZEDIT'                                      CAAA02
     c                   parm                    POUTA                          CAAA02
     c                   parm                    ZZero                          CAAA02
                                                                                CAAA02
     C                   MOVE      *BLANKS       DDDTAM
     C************       MOVE      ZFIELD        DDDTAM                         CAAA02
     C                   MOVE      POUTA         DDDTAM                         CAAA02
     C                   MOVEL     KGDTPD        DDDTAM
     C                   MOVE      *BLANKS       DDXOCD
     C                   ELSE
     C                   MOVEL     '*CALL   '    DBFILE
     C                   MOVEL     'EU0200  '    DBKEY                           ************
     C                   Z-ADD     4             DBASE                           * DBERR 04 *
     C                   EXSR      *PSSR                                         ************
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVE      *BLANKS       DDDTAM
     C                   MOVE      KGXOAD        DDDTAM
     C                   MOVEL     KGDTPD        DDDTAM
     C                   MOVE      KGCCY         DDXOCD
     C                   ENDIF
      *
     C     @SCCY         IFEQ      BKEUCP
     C     KGCCY         ANDEQ     BKEURO
     C                   MOVE      *BLANKS       DDXOCD
     C                   ENDIF
      *
     C                   ELSE
      *
     C*
     C                   MOVE      KGXOAD        DDDTAM                          1
     C                   MOVEL     '   {'        DDDTAM                          1
     C                   MOVE      KGXOCD        DDXOCD                          1
      *
     C                   ENDIF
     C*                                                     1
     C                   MOVEL     KGXOP1        DDOPAY                          1
     C                   MOVEL     KGXOP2        @@OPD2                          1
     C                   MOVEL     KGXOR1        DDOREC                          1
     C                   MOVEL     KGXOR2        @@ORD2                          1
     C*                                                     1
     C                   MOVE      'N'           @PRVRX                          1
     C*                                                     1
     C                   END                                                    E1
      *                                                                                       245692
     C     BNDCSP        IFEQ      ','                                                        245692
     C     '.'           SCAN      @@OPD1        W                 1 0    97                  245692
     C   97              MOVEA     @@OPD1        W#RATE                                       245692
     C   97              MOVE      ','           W#RATE(W)                                    245692
     C   97              MOVEA     W#RATE        @@OPD1                                       245692
      *                                                                                       245692
     C     '.'           SCAN      @@OPD2        W                        97                  245692
     C   97              MOVEA     @@OPD2        W#RATE                                       245692
     C   97              MOVE      ','           W#RATE(W)                                    245692
     C   97              MOVEA     W#RATE        @@OPD2                                       245692
      *                                                                                       245692
     C     '.'           SCAN      @@ORD1        W                        97                  245692
     C   97              MOVEA     @@ORD1        W#RATE                                       245692
     C   97              MOVE      ','           W#RATE(W)                                    245692
     C   97              MOVEA     W#RATE        @@ORD1                                       245692
      *                                                                                       245692
     C     '.'           SCAN      @@ORD2        W                        97                  245692
     C   97              MOVEA     @@ORD2        W#RATE                                       245692
     C   97              MOVE      ','           W#RATE(W)                                    245692
     C   97              MOVEA     W#RATE        @@ORD2                                       245692
     C                   ENDIF                                                                245692
     C*
     C     #BD9          ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
      ***/COPY ZSRSRC,ZVLDTZ3                                                   CAAA02
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
     C* CALLS      #AAA    -  READ STANDING DATA FILES                *
     C*            *PSSR   -  DATABASE ERROR HANDLING                 *
     C*                                                               *
     C* CALLED BY  #A      -  INITIAL PROCESSING                      *
     C*                                                               *
     C* FLDS USED                                                     *
     C*            @FDORD  -  DEFAULT DATE ORDER SEQUENCE             *
     C*            @FBOOK  -  DEFAULT TRADING BOOK                    *
     C*            @FVLDY  -  DEFAULT START DATE DAY NO               *
     C*            @FSDAT  -  DEFAULT START DATE                      *
     C*            @FBRCA  -  IRS ENQUIRY DEFAULT BRANCH              *
     C*            @TDATE  -  SREEN HEADING DATE                      *
     C*            @PRVRX  -  PREVIOUS RECORD WAS RX DETAIL INDICATOR *
     C*                                                               *
     C*****************************************************************
     C*
     C     #AA           BEGSR
      *
      ** Call Access pgm AOSARDR0 to check if CEU012 is ON.
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
     C                   MOVE      'SCSARDPD'    DBFILE                         * DBERR 01 *
     C                   Z-ADD     1             DBASE                          ************
     C                   MOVEL     'DL1912'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C*
     C** OPEN ALL FILES
     C*
      *
      ** If CEU012 is ON, open DLIRSEL1 to L8 lfs
      *
     C     CEU012        IFEQ      'Y'
     C                   OPEN      DLIRSEL1
     C                   OPEN      DLIRSEL2
     C                   OPEN      DLIRSEL3
     C                   OPEN      DLIRSEL4
     C                   OPEN      DLIRSEL5
     C                   OPEN      DLIRSEL6
     C                   OPEN      DLIRSEL7
     C                   OPEN      DLIRSEL8
      *
     C                   ELSE
     C                   OPEN      DLIRSSL1
     C                   OPEN      DLIRSSL2
     C                   OPEN      DLIRSSL3
     C                   OPEN      DLIRSSL4
     C                   OPEN      DLIRSSL5
     C                   OPEN      DLIRSSL6
     C                   OPEN      DLIRSSL7
     C                   OPEN      DLIRSSL8
      *
     C                   ENDIF
      *
     C                   OPEN      FDMNTHLL
     C                   OPEN      MUSER
     C*
     C** EXSR #AAA TO READ STANDING DATA FILES
     C*
     C                   EXSR      #AAA
     C*
      **  Store the date format indicator later used in ZVLDT
     C                   MOVE      BJDFIN        @@DFMT
     C*
     C**  If date format is 'M' (MMMDDYY), set on *IN98
     C*
     C     BJDFIN        IFEQ      'M'
     C                   MOVE      '1'           *IN98
     C                   END
     C*
     C** READ MONTH SHORTNAMES FILE USED IN ZVLDT
     C*
     C     1             CHAIN     FDMNTHLL                           86
     C*
     C     *IN86         IFEQ      '1'                                          B1
     C*                                                    ***************
     C                   MOVEL     'FDMNTHLL'    DBFILE                         *             *
     C                   MOVE      *BLANKS       DBKEY                          * DBERROR 010 *
     C                   MOVE      '010'         DBASE                          *             *
     C*                                                    ***************
     C                   EXSR      *PSSR                                        *1
     C                   END                                                    E1
     C*
     C*
      *
      * Set up Default IRS Trading Book Code and Default IRS
      * Enquiry Branch using fields from SDFAISPD
     C                   MOVE      BQITBC        @FBOOK
     C                   MOVE      BQFIDB        @FBRCA
     C*
     C** SET UP START DATE WITH TODAY'S DATE FROM SDBANKPD
     C                   MOVE      BJMRDT        @FSDAT            7
     C                   Z-ADD     BJRDNB        @FVLDY            5 0
      **
      * If date format indicator is American ('M') convert date
     C     BJDFIN        IFEQ      'M'
     C                   MOVE      BJMRDT        @DAT7
     C*
     C** If day is before 10th, insert leading zero
     C     @DDY          IFLT      10
     C     @DDY          ANDGT     0
     C                   MOVEL     '0'           @DAY
     C                   END
     C*
     C                   MOVE      @DAY          @WRK5             5
     C                   MOVEL     @MMT          @WRK5
     C                   MOVEL     @WRK5         @FSDAT
     C                   END
     C*
     C** Set up the Run Date for the screen heading
     C                   MOVE      @FSDAT        @TDATE
     C*
     C** Set up default for date order sequence, ie. by maturity or by
     C** next rate change date order (M/N)
     C*
     C                   MOVE      'N'           @FDORD            1
     C*
     C** Set @PRVRX so that it shows previous record was not RX detail
     C*
     C                   MOVE      'N'           @PRVRX            1
     C*
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
     C* CALLS      *PSSR      - DATABASE ERROR HANDLING               *
     C*            QCMDEXC                                            *
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
     C                   MOVEL     'MUSER'       DBFILE                         ***************
     C                   MOVE      '009'         DBASE                          *             *
     C                   MOVEL     @USER         DBKEY                          * DBERROR 009 *
     C*                                                    *             *
     C                   EXSR      *PSSR                                        ***************
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
     C                   OPEN      DL1912DF
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
     C** IF EXIT HAS BEEN REQUESTED - CMD 1 EXIT IMMEDIATELY
     C*
     C     *IN03         IFEQ      '1'                                          B1
     C                   MOVE      'Q'           @@TERM                         *1
     C                   MOVE      '1'           *INLR                          *1
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
     C* #AAA     - READ STANDING DATA FILES                           *
     C*                                                               *
     C* CALLS      *PSSR      - DATABASE ERROR HANDLING               *
     C*                                                               *
     C* CALLED BY  #AA    - OPEN FILES AND SET UP DEFAULT PROMPT DATA *
     C*                                                               *
     C*                                                               *
     C*****************************************************************
     C*
     C     #AAA          BEGSR
     C*
     C*
     C* Call Access prog. for Bank Details.
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C*
     C* Call Access prog. for Module Details.
     C*
     C                   CALL      'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDMMOD        PARM      SDMMOD        DSFDY
     C*
     C* Call Access prog. for IRS Enquiry Defaults
     C*
     C                   CALL      'AOFAISR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDFAIS        PARM      SDFAIS        DSFDY
     C*
     C     BGMBIN        IFEQ      'N'
     C                   MOVE      '1'           *IN50
     C                   END
      *                                                                                       245692
      ** Call Access Program for DEALING ICD Details                                          245692
      *                                                                                       245692
     C                   CALL      'AODEALR1'                                                 245692
     C                   PARM      '*DBERR '     @RTCD             7                          245692
     C                   PARM      '*FIRST '     @OPTN             7                          245692
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        245692
     C*
      *
      ** If CEU012 is ON, call Access pgm AOGELRR0 to retrieve
      ** the assigned Currency Code for Consolidated Currency
      ** Euro Position.
      *
     C     CEU012        IFEQ      'Y'
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDGELR        PARM      SDGELR        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDGELRPD'    DBFILE                         ************
     C                   Z-ADD     2             DBASE                          * DBERR 02 *
     C                   MOVEL     '*FIRST'      DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
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
     C**  If *IN98 is ON, date format is 'M' (MMDDYY)
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
     C** Set up output field for MMMDDYY/DDMMMYY
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
     C* FLDS USED  @KCCY      - CURRENCY       )                      *
     C*            @KBPBK     - BOOK CODE      )  FIELDS MAKING UP    *
     C*            @KBRCA     - BRANCH CODE    )  KEYS FOR IRS FILE   *
     C*            @KMATD     - MATURITY DAY NO)                      *
     C*            @KERTC     - EARLIEST NRCD  )                      *
     C*            @KDLNO     - DEAL NUMBER    )                      *
     C*                                                               *
     C*            @KBEG1 TO @KBEG8 - KLIST FOR NEW PROMPTS; IE. TO   *
     C*                               POSITION FILE PTR AT BEGINNING  *
     C*                               OF RELEVANT DATA                *
     C*                                                               *
     C*            @KPOS1 TO @KPOS8 - KLIST FOR POSITIONING FILE PTR. *
     C*                               AT SPECIFIC POINT ON FILE       *
     C*                                                               *
     C*            @KRDF1 TO @KRDF8 - KLIST FOR READING FILE          *
     C*                                                               *
     C*****************************************************************
     C*
     C     #AD           BEGSR
     C*
     C** Key used to position file ptr at specific position of DLIRSSL1
     C*
     C     @KPOS1        KLIST
     C                   KFLD                    @KCCY
     C                   KFLD                    @KBRCA
     C                   KFLD                    @KMDAT
     C                   KFLD                    @KERTC
     C                   KFLD                    @KDLNO
     C*
     C** Key used to position file ptr at beginning of relevant data
     C*
     C     @KBEG1        KLIST
     C                   KFLD                    @KCCY
     C                   KFLD                    @KBRCA
     C                   KFLD                    @KMDAT
     C*
     C** Key used to read IRS file DLIRSSL1
     C*
     C     @KRDF1        KLIST
     C                   KFLD                    @KCCY
     C                   KFLD                    @KBRCA
     C*
     C** Key used to position file ptr at specific position of DLIRSSL2
     C*
     C     @KPOS2        KLIST
     C                   KFLD                    @KCCY
     C                   KFLD                    @KBPBK
     C                   KFLD                    @KBRCA
     C                   KFLD                    @KMDAT
     C                   KFLD                    @KERTC
     C                   KFLD                    @KDLNO
     C*
     C** Key used to position file ptr at beginning of relevant data
     C*
     C     @KBEG2        KLIST
     C                   KFLD                    @KCCY
     C                   KFLD                    @KBPBK
     C                   KFLD                    @KBRCA
     C                   KFLD                    @KMDAT
     C*
     C** Key used to read IRS file DLIRSSL2
     C*
     C     @KRDF2        KLIST
     C                   KFLD                    @KCCY
     C                   KFLD                    @KBPBK
     C                   KFLD                    @KBRCA
     C*
     C** Key used to position file ptr at specific position of DLIRSSL3
     C*
     C     @KPOS3        KLIST
     C                   KFLD                    @KCCY
     C                   KFLD                    @KMDAT
     C                   KFLD                    @KERTC
     C                   KFLD                    @KDLNO
     C*
     C** Key used to position file ptr at beginning of relevant data
     C*
     C     @KBEG3        KLIST
     C                   KFLD                    @KCCY
     C                   KFLD                    @KMDAT
     C*
     C** Key used to read IRS file DLIRSSL3
     C*
     C     @KRDF3        KLIST
     C                   KFLD                    @KCCY
     C*
     C** Key used to position file ptr at specific position of DLIRSSL4
     C*
     C     @KPOS4        KLIST
     C                   KFLD                    @KCCY
     C                   KFLD                    @KBPBK
     C                   KFLD                    @KMDAT
     C                   KFLD                    @KERTC
     C                   KFLD                    @KDLNO
     C*
     C** Key used to position file ptr at beginning of relevant data
     C*
     C     @KBEG4        KLIST
     C                   KFLD                    @KCCY
     C                   KFLD                    @KBPBK
     C                   KFLD                    @KMDAT
     C*
     C** Key used to read IRS file DLIRSSL4
     C*
     C     @KRDF4        KLIST
     C                   KFLD                    @KCCY
     C                   KFLD                    @KBPBK
     C*
     C** Key used to position file ptr at specific position of DLIRSSL5
     C*
     C     @KPOS5        KLIST
     C                   KFLD                    @KCCY
     C                   KFLD                    @KBPBK
     C                   KFLD                    @KBRCA
     C                   KFLD                    @KERTC
     C                   KFLD                    @KMDAT
     C                   KFLD                    @KDLNO
     C*
     C** Key used to position file ptr at beginning of relevant data
     C*
     C     @KBEG5        KLIST
     C                   KFLD                    @KCCY
     C                   KFLD                    @KBPBK
     C                   KFLD                    @KBRCA
     C                   KFLD                    @KERTC
     C*
     C** Key used to read IRS file DLIRSSL5
     C*
     C     @KRDF5        KLIST
     C                   KFLD                    @KCCY
     C                   KFLD                    @KBPBK
     C                   KFLD                    @KBRCA
     C*
     C** Key used to position file ptr at specific position of DLIRSSL6
     C*
     C     @KPOS6        KLIST
     C                   KFLD                    @KCCY
     C                   KFLD                    @KBRCA
     C                   KFLD                    @KERTC
     C                   KFLD                    @KMDAT
     C                   KFLD                    @KDLNO
     C*
     C** Key used to position file ptr at beginning of relevant data
     C*
     C     @KBEG6        KLIST
     C                   KFLD                    @KCCY
     C                   KFLD                    @KBRCA
     C                   KFLD                    @KERTC
     C*
     C** Key used to read IRS file DLIRSSL6
     C*
     C     @KRDF6        KLIST
     C                   KFLD                    @KCCY
     C                   KFLD                    @KBRCA
     C*
     C** Key used to position file ptr at specific position of DLIRSSL7
     C*
     C     @KPOS7        KLIST
     C                   KFLD                    @KCCY
     C                   KFLD                    @KERTC
     C                   KFLD                    @KMDAT
     C                   KFLD                    @KDLNO
     C*
     C** Key used to position file ptr at beginning of relevant data
     C*
     C     @KBEG7        KLIST
     C                   KFLD                    @KCCY
     C                   KFLD                    @KERTC
     C*
     C** Key used to read IRS file DLIRSSL7
     C*
     C     @KRDF7        KLIST
     C                   KFLD                    @KCCY
     C*
     C** Key used to position file ptr at specific position of DLIRSSL8
     C*
     C     @KPOS8        KLIST
     C                   KFLD                    @KCCY
     C                   KFLD                    @KBPBK
     C                   KFLD                    @KERTC
     C                   KFLD                    @KMDAT
     C                   KFLD                    @KDLNO
     C*
     C** Key used to position file ptr at beginning of relevant data
     C*
     C     @KBEG8        KLIST
     C                   KFLD                    @KCCY
     C                   KFLD                    @KBPBK
     C                   KFLD                    @KERTC
     C*
     C** Key used to read IRS file DLIRSSL8
     C*
     C     @KRDF8        KLIST
     C                   KFLD                    @KCCY
     C                   KFLD                    @KBPBK
      *
      ** Key used to position file ptr at specific position of DLIRSEL1
      *
     C     @KPO1A        KLIST
     C                   KFLD                    @KCSQ
     C                   KFLD                    @KCCY
     C                   KFLD                    @KBRCA
     C                   KFLD                    @KMDAT
     C                   KFLD                    @KERTC
     C                   KFLD                    @KDLNO
      *
      ** Key used to position file ptr at beginning of relevant data
      *
     C     @KBE1A        KLIST
     C                   KFLD                    @KCSQ
     C                   KFLD                    @KCCY
     C                   KFLD                    @KBRCA
     C                   KFLD                    @KMDAT
      *
      ** Key used to read IRS file DLIRSEL1
      *
     C     @KRD1A        KLIST
     C                   KFLD                    @KCSQ
     C                   KFLD                    @KCCY
     C                   KFLD                    @KBRCA
      *
      ** Key used to position file ptr at specific position of DLIRSEL2
      *
     C     @KPO2A        KLIST
     C                   KFLD                    @KCSQ
     C                   KFLD                    @KCCY
     C                   KFLD                    @KBPBK
     C                   KFLD                    @KBRCA
     C                   KFLD                    @KMDAT
     C                   KFLD                    @KERTC
     C                   KFLD                    @KDLNO
      *
      ** Key used to position file ptr at beginning of relevant data
      *
     C     @KBE2A        KLIST
     C                   KFLD                    @KCSQ
     C                   KFLD                    @KCCY
     C                   KFLD                    @KBPBK
     C                   KFLD                    @KBRCA
     C                   KFLD                    @KMDAT
      *
      ** Key used to read IRS file DLIRSEL2
      *
     C     @KRD2A        KLIST
     C                   KFLD                    @KCSQ
     C                   KFLD                    @KCCY
     C                   KFLD                    @KBPBK
     C                   KFLD                    @KBRCA
      *
      ** Key used to position file ptr at specific position of DLIRSEL3
      *
     C     @KPO3A        KLIST
     C                   KFLD                    @KCSQ
     C                   KFLD                    @KCCY
     C                   KFLD                    @KMDAT
     C                   KFLD                    @KERTC
     C                   KFLD                    @KDLNO
      *
      ** Key used to position file ptr at beginning of relevant data
      *
     C     @KBE3A        KLIST
     C                   KFLD                    @KCSQ
     C                   KFLD                    @KCCY
     C                   KFLD                    @KMDAT
      *
      ** Key used to read IRS file DLIRSEL3
      *
     C     @KRD3A        KLIST
     C                   KFLD                    @KCSQ
     C                   KFLD                    @KCCY
      *
      ** Key used to position file ptr at specific position of DLIRSEL4
      *
     C     @KPO4A        KLIST
     C                   KFLD                    @KCSQ
     C                   KFLD                    @KCCY
     C                   KFLD                    @KBPBK
     C                   KFLD                    @KMDAT
     C                   KFLD                    @KERTC
     C                   KFLD                    @KDLNO
      *
      ** Key used to position file ptr at beginning of relevant data
      *
     C     @KBE4A        KLIST
     C                   KFLD                    @KCSQ
     C                   KFLD                    @KCCY
     C                   KFLD                    @KBPBK
     C                   KFLD                    @KMDAT
      *
      ** Key used to read IRS file DLIRSEL4
      *
     C     @KRD4A        KLIST
     C                   KFLD                    @KCSQ
     C                   KFLD                    @KCCY
     C                   KFLD                    @KBPBK
      *
      ** Key used to position file ptr at specific position of DLIRSEL5
      *
     C     @KPO5A        KLIST
     C                   KFLD                    @KCSQ
     C                   KFLD                    @KCCY
     C                   KFLD                    @KBPBK
     C                   KFLD                    @KBRCA
     C                   KFLD                    @KERTC
     C                   KFLD                    @KMDAT
     C                   KFLD                    @KDLNO
      *
      ** Key used to position file ptr at beginning of relevant data
      *
     C     @KBE5A        KLIST
     C                   KFLD                    @KCSQ
     C                   KFLD                    @KCCY
     C                   KFLD                    @KBPBK
     C                   KFLD                    @KBRCA
     C                   KFLD                    @KERTC
      *
      ** Key used to read IRS file DLIRSEL5
      *
     C     @KRD5A        KLIST
     C                   KFLD                    @KCSQ
     C                   KFLD                    @KCCY
     C                   KFLD                    @KBPBK
     C                   KFLD                    @KBRCA
      *
      ** Key used to position file ptr at specific position of DLIRSEL6
      *
     C     @KPO6A        KLIST
     C                   KFLD                    @KCSQ
     C                   KFLD                    @KCCY
     C                   KFLD                    @KBRCA
     C                   KFLD                    @KERTC
     C                   KFLD                    @KMDAT
     C                   KFLD                    @KDLNO
      *
      ** Key used to position file ptr at beginning of relevant data
      *
     C     @KBE6A        KLIST
     C                   KFLD                    @KCSQ
     C                   KFLD                    @KCCY
     C                   KFLD                    @KBRCA
     C                   KFLD                    @KERTC
      *
      ** Key used to read IRS file DLIRSEL6
      *
     C     @KRD6A        KLIST
     C                   KFLD                    @KCSQ
     C                   KFLD                    @KCCY
     C                   KFLD                    @KBRCA
      *
      ** Key used to position file ptr at specific position of DLIRSEL7
      *
     C     @KPO7A        KLIST
     C                   KFLD                    @KCSQ
     C                   KFLD                    @KCCY
     C                   KFLD                    @KERTC
     C                   KFLD                    @KMDAT
     C                   KFLD                    @KDLNO
      *
      ** Key used to position file ptr at beginning of relevant data
      *
     C     @KBE7A        KLIST
     C                   KFLD                    @KCSQ
     C                   KFLD                    @KCCY
     C                   KFLD                    @KERTC
      *
      ** Key used to read IRS file DLIRSEL7
      *
     C     @KRD7A        KLIST
     C                   KFLD                    @KCSQ
     C                   KFLD                    @KCCY
      *
      ** Key used to position file ptr at specific position of DLIRSEL8
      *
     C     @KPO8A        KLIST
     C                   KFLD                    @KCSQ
     C                   KFLD                    @KCCY
     C                   KFLD                    @KBPBK
     C                   KFLD                    @KERTC
     C                   KFLD                    @KMDAT
     C                   KFLD                    @KDLNO
      *
      ** Key used to position file ptr at beginning of relevant data
      *
     C     @KBE8A        KLIST
     C                   KFLD                    @KCSQ
     C                   KFLD                    @KCCY
     C                   KFLD                    @KBPBK
     C                   KFLD                    @KERTC
      *
      ** Key used to read IRS file DLIRSEL8
      *
     C     @KRD8A        KLIST
     C                   KFLD                    @KCSQ
     C                   KFLD                    @KCCY
     C                   KFLD                    @KBPBK
      *
     C     #AD9          ENDSR
     C*****************************************************************
      *
     C***/COPY ZSRSRC,ZEDITZ2                                                   CAAA02
      /EJECT
**  @DYN - VALID DAY-IN-MONTH NUMBER
01020304050607080910111213141516171819202122232425262728293031
**  @MON - VALID MONTH NUMBERS
010203040506070809101112
**  @YR - VALID YEAR DIGITS
0123456789
**   TXT - TEXT FOR DATE ORDER SEQUENCE
BY NRCD    BY MATURITY
** @OVR  CL COMMAND FOR CALL TO QCMDEXC
OVRDSPF FILE(DL1912DF) WAITRCD(    )
