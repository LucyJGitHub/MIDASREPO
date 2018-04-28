     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas Bank Directory Plus Details Enquiry')            *
      *****************************************************************
      *                                                               *
      *  Midas - S.W.I.F.T Direct Link                                *
      *                                                               *
      *  MS000101 - Bank Directory Plus Details Enquiry               *
      *                                                               *
      *  Function:  This program displays Bank Directory Details.     *
      *             The first screen allows the user to display       *
      *             using SETLL for BIC Code and Branch and           *
      *             QCLSCAN for Institution Name 1 and City.          *
      *             The second screen displays all non-blank          *
      *             details as held on MEBICDPD for the selected      *
      *             record.                                           *
      *             The inclusion/exclusion, sequencing and field     *
      *             names are obtained from MEBICDPA which is         *
      *             is initially derived from performing DSPFFD       *
      *             to an output file and then copying *MAP *DROP     *
      *             to MEBICDPA.                                      *
      *                                                               *
      *  Called By: Directly from MIDAS MENU                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD024108           Date 16Dec13               *
      *  Prev Amend No. MD023398           Date 12Nov13               *
      *                 MD023143A          Date 06Nov13               *
      *                 MD023856           Date 28Nov13               *
      *                 MD022084           Date 05Sep13               *
      *                 CFT050  *CREATE    Date 03Jun13               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD024108 - Functions of F12 & F15 keys in IBAN Plus Direc-   *
      *             tory Enquiry are interchanged                     *
      *  MD023398 - Mainlist view should be displayed after pressing  *
      *             enter on the last screen of CUAP during amend and *
      *             enquire                                           *
      *  MD023143A - 1 = Select should be displayed in the Bank direc-*
      *             tory Plus Search Screen of CUAP (Reopen)          *
      *  MD023856 - Incorrect Branch length displayed in Midas Bank   *
      *             Directory Plus Details Enquiry                    *
      *  MD022084 - F15 = IBAN Plus not available on Bank Directory   *
      *             Plus Enquiry                                      *
      *  CFT050 - SWIFTRef Directories upload                         *
      *                                                               *
      *****************************************************************
      *
     FMS000101DFCF   E             WORKSTN INFSR(*PSSR)
     F                                     INFDS(INFDS1)
     F                                     SFILE(MS000101S0:S0RRN)
     F                                     SFILE(MS000101S1:S1RRN)
     FMEBIB3L0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MEBIB3D0:MEBIB3D1)
     FMEBIB3L1  IF   E           K DISK    INFSR(*PSSR)
     FMEIBN3L0  IF   E           K DISK    INFSR(*PSSR)
     FMEBICFPD  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   KC - F3  Exit                                               *
      *   KL - F12 Previous                                           *
      *   KP - F15 = BANK Directory     -   F15 = IBAN Directory      *
      *                                                               *
      *   30 - S0 SFLDSPCTL                                           *
      *   31 - S0 SFLDSP                                              *
      *   32 - S0 SFLEND                                              *
      *   33 - S0 SFLNXTCHG                                           *
      *   39 - S0 ROLLUP                                              *
      *                                                               *
      *   50 - S1 SFLDSPCTL                                           *
      *   51 - S1 SFLDSP                                              *
      *   52 - S1 SFLEND                                              *
      *   59 - S1 ROLLUP                                              *
      *   60 - Bank or IBAN display                                   *
      *   61 - "F15=IBAN Plus" will be enable                         *
      *   62 - Determine if first call contains a parameter.          *
      *        F12 will in 2nd screen will return to Keyref to FT0900 *
      *                                                               *
      *****************************************************************
      *
      ** File Information Data structure for Display file
      *
     D INFDS1          DS
     D  INSFRC               378    379B 0
      *
      ** Program status data structure
      *
     D PSDS           SDS
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
      ** Data Structure to pass parameters to Access programs
      *
     D AOFMTS        E DS                  EXTNAME(DSFDY)
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
     D S1BUFF          C                   CONST('. . . . . . . . . . -
     D                                     . . . . . . . . . . ')
      *
      **------------------------------------------------------------------
      *
     C                   EXSR      #INIT
      *
      ** Everytime F12 is pressed on 2nd or 3rd screen perform checking.
      *
     C     START         TAG
      *
      ** Check if Record kery is define in the parameter
      *
     C     KEYREF        DOWNE     *BLANKS
     C     MENREF        ANDEQ     ' '
      *
     C                   MOVEL     KEYREF        B3KEY
      *
     C     CFT004        IFEQ      'Y'
     C                   MOVEA     '1'           *IN(61)
     C                   ENDIF
      *
      ** Execute reading and displaying 2nd screen.
      *
     C                   EXSR      #READ1
     C*****B3KEY         CHAIN     MEIBN3L0                           99                    MD022084
     C     B3IBNK        CHAIN     MEIBN3L0                           99                    MD022084
     C     *IN99         IFEQ      '1'
     C                   MOVEA     '0'           *IN(61)
     C                   ENDIF
     C                   EXSR      #DISP1
      *
      ** If F15 is enabled in 2nd screen and pressed, display 3rd screen.
      *
     C     *INKP         IFEQ      '1'
     C                   EXSR      #READ1
      *
      ** F12 is pressed in 3rd screen. Store current keyref then chain back to 2nd screen.
      *
     C     *INKL         IFEQ      '1'
      ** If original MENREF is M and F12 was pressed, clear KEYREF                          MD024108
      ** to go back to START and re-display the LISTVIEW                                    MD024108
     C                   IF        SVMREF <> 'M'                                            MD024108
     C                   MOVE      *BLANKS       MENREF
     C                   ELSE                                                               MD024108
     C                   MOVE      *BLANKS       KEYREF                                     MD024108
     C                   ENDIF                                                              MD024108
      ** If not coming from IBAN Plus screen and F12 was pressed                            MD023398
     C     *INKP         IFEQ      '0'                                                      MD023398
     C                   MOVE      'C'           MENREF                                     MD023398
     C                   ENDIF                                                              MD023398
     C                   MOVE      '0'           *INKL
     C                   MOVE      '0'           *INKP
     C                   GOTO      START
     C                   ENDIF
      *                                                                                    MD023143A
      ** If F3 is pressed exit program.                                                    MD023143A
      *                                                                                    MD023143A
     C     *INKC         IFEQ      '1'                                                     MD023143A
     C                   MOVE      'C'           MENREF                                     MD023398
     C                   GOTO      TAGEND                                                  MD023143A
     C                   ENDIF                                                             MD023143A
      *
      ** F15 is pressed on third screen empty keyref and process main subfile.
      *
     C******INKP         IFEQ      '1'                                                      MD023398
     C**********         MOVE      'M'           MENREF                                     MD023398
     C**********         MOVE      *BLANKS       KEYREF                                     MD023398
     C**********         MOVE      '0'           *INKP                                      MD023398
     C**********         MOVE      '0'           *INKL                                      MD023398
     C**********         GOTO      START                                                    MD023398
     C**********         ENDIF                                                              MD023398
     C                   ENDIF
      *
      ***If*F3*is*pressed*exit*program.**                                                  MD023143A
      *
     C******INKC         IFEQ      '1'                                                     MD023143A
     C**********         GOTO      TAGEND                                                  MD023143A
     C**********         ENDIF                                                             MD023143A
      *  If F3 is pressed exit program.                                                     MD023398
      *                                                                                     MD023398
     C     *INKC         IFEQ      '1'                                                      MD023398
     C                   MOVE      'C'           MENREF                                     MD023398
     C                   GOTO      TAGEND                                                   MD023398
     C                   ENDIF                                                              MD023398
      ** If ENTER key is pressed exit program                                               MD023398
     C                   IF        *INKP = '0'                                              MD023398
     C                   MOVE      'E'           MENREF                                     MD023398
     C                   ELSE                                                               MD023398
     C                   MOVE      '0'           *INKL                                      MD023398
     C                   MOVE      '0'           *INKP                                      MD023398
     C                   GOTO      START                                                    MD023398
     C                   ENDIF                                                              MD023398
      *
      ** If F12 is pressed, empty KEYREF parameter and display main subfile if *62 is on.
      ** If 1st call contains keyref, F12 in 2nd screen will exit and return to FT0900.
      *
     C     *INKL         IFEQ      '1'
     C                   MOVE      '0'           *INKP
     C     *IN62         IFEQ      '1'
     C                   MOVE      'M'           MENREF
     C                   MOVE      *BLANKS       KEYREF
     C                   ELSE
     C                   MOVE      'L'           MENREF                                     MD023398
     C                   GOTO      TAGEND
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
      ** If a Value is in *entry parameter, retrieve directly MEBIB3L0 data.
      ** Switched on *62 to determine the first call contains no keyref.
      *
     C     KEYREF        IFEQ      *BLANKS
     C     MENREF        ANDEQ     'M'
     C                   MOVE      '1'           *INKE
     C                   MOVE      '1'           *IN(62)
      *
     C     *INKC         DOWEQ     '0'
     C     KEYREF        IFNE      *BLANKS
     C     CFT004        IFEQ      'Y'
     C                   MOVEA     '1'           *IN(61)
      *
      ** Read directly the details of MEIBN3L0
      *
     C                   EXSR      #READ1
      *
      ** If F12 is pressed on 2nd screen empty keyref and return to 1st screen.
      ** If F12 is pressed on 3rd screen store keyref ans display 2nd screen.
      *
     C     *INKL         IFEQ      '1'
      ** If original MENREF is M and F12 was pressed, clear KEYREF                          MD024108
      ** to go back to START and re-display the LISTVIEW                                    MD024108
     C                   IF        SVMREF <> 'M'                                            MD024108
     C                   MOVE      *BLANKS       MENREF
     C                   ELSE                                                               MD024108
     C                   MOVE      *BLANKS       KEYREF                                     MD024108
     C                   ENDIF                                                              MD024108
      *
     C     *INKP         IFEQ      '0'
     C                   MOVE      'M'           MENREF
     C                   MOVE      *BLANKS       KEYREF
     C                   ENDIF
      *
     C                   MOVE      '0'           *INKL
     C                   MOVE      '0'           *INKP
      ** BIC Directory header should be displayed instead of IBAN Directory                 MD024108
     C                   MOVE      '0'           *IN60                                      MD024108
     C                   GOTO      START
     C                   ENDIF
      *
      ** If F15 is pressed on 3rd screen return to main subfile.
      *
     C     *INKP         IFEQ      '1'
      ** If F15=BIC screen was pressed, reload subfile                                      MD024108
     C                   IF        SVMREF <> 'M'                                            MD024108
     C                   MOVE      'M'           MENREF
     C                   MOVE      *BLANKS       KEYREF
     C                   MOVE      '0'           *INKP
     C                   MOVE      '0'           *INKL
     C                   GOTO      START
     C                   ELSE                                                               MD024108
      ** Initialize indicators and re-point the subfile                                     MD024108
     C                   EVAL      *IN31 = '1'                                              MD024108
     C     S0RRN         CHAIN     MS000101S0                         90                    MD024108
     C                   EVAL      *INKP = '1'                                              MD024108
     C                   GOTO      BICTAG                                                   MD024108
     C                   ENDIF                                                              MD024108
     C                   ENDIF
     C                   ENDIF
      *
      ** If F3 is pressed exit program.
      *
     C     *INKC         IFEQ      '1'
     C                   MOVE      'C'           MENREF                                     MD023398
     C                   GOTO      TAGEND
     C                   ENDIF
     C                   ENDIF
      *
      ** Initialize and Load subfile if *INKE has been set on
      ** (First time through or change of SETLL fields)
      *
     C   KE              EXSR      #INLZ0
     C   KE              EXSR      #LOAD0
      *
      ** Display screen
      *
     C                   EXSR      #DISP0
      *
      ** Process screen if F3 not taken
      *
      ** System should go back here if F15=BIC details was pressed from                     MD024108
      ** IBAN detail screen                                                                 MD024108
     C     BICTAG        TAG                                                                MD024108
     C     *INKC         IFEQ      '0'
      *
      ** Check if SETLL values changed
      *
     C     C0BICC        IFNE      SVBICC
     C     C0BRCD        ORNE      SVBRCD
     C     C0INS1        ORNE      SVINS1
     C     C0CITY        ORNE      SVCITY
     C                   MOVE      '1'           *INKE
     C                   MOVE      C0BICC        SVBICC
     C                   MOVE      C0BRCD        SVBRCD
     C                   MOVE      C0INS1        SVINS1
     C                   MOVE      C0CITY        SVCITY
     C                   ENDIF
      *
     C     *IN39         CASEQ     '1'           #LOAD0
     C     *INKE         CASNE     '1'           #READ0
     C                   END
     C                   END
      *
     C                   ENDDO
     C                   ENDIF
      *
     C     TAGEND        TAG
     C                   SETON                                        LR
     C                   RETURN
      *
      *******************************************************************
      *                                                                 *
      * #INLZ0 - Initialize Subfile                                     *
      *                                                                 *
      *******************************************************************
      *
     C     #INLZ0        BEGSR
      *
      ** Clear subfile
      *
     C                   MOVEA     '0000'        *IN(30)
     C                   WRITE     MS000101C0
     C                   MOVE      '1'           *IN30
      *
     C                   Z-ADD     0             S0RRN
     C                   Z-ADD     0             X0RRN
      *
     C     K0BICD        SETLL     MEBIB3L1
     C                   READ      MEBIB3L1                               32
      *
     C                   ENDSR
      *
      *******************************************************************
      *                                                                 *
      * #LOAD0 - Load Subfile                                           *
      *                                                                 *
      *******************************************************************
      *
     C     #LOAD0        BEGSR
      *
     C                   Z-ADD     0             LINENO
     C                   Z-ADD     0             WBCBF
     C                   Z-ADD     X0RRN         S0RRN
      *
      ** Reset position
      *
     C     *IN39         IFEQ      '1'
     C     K1BICD        CHAIN     MEBIB3L1                           90
     C                   END
      *
      ** Load SFL page until SFL page full or end of file
      *
     C     *IN32         DOWEQ     '0'
     C     LINENO        ANDLE     15
      *
      ** Check Select fields
      *
     C                   Z-ADD     1             P1RSLT
     C                   Z-ADD     1             P3RSLT
     C     SVBRCD        IFNE      *BLANKS
     C     WBCBF         ANDEQ     0
     C                   MOVE      B3BRCD        WBRCD                                      MD023856
     C                   EXSR      CVTBRCD                                                  MD023856
     C                   CALL      'QCLSCAN'
     C**********         PARM                    B3BRCD                                     MD023856
     C                   PARM                    WBRCD             3                        MD023856
     C                   PARM      3             P1LEN1
     C                   PARM                    P1STRT
     C                   PARM                    SVBRCD
     C                   PARM      3             P1LEN1
     C                   PARM                    P1XLAT
     C                   PARM                    P1TRIM
     C                   PARM                    P1WILD
     C                   PARM                    P1RSLT
      *
     C     SVBICC        IFNE      *BLANKS
     C                   Z-ADD     1             WBCBF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     SVINS1        IFNE      *BLANKS
     C                   CALL      'QCLSCAN'
     C                   PARM                    B3INS1
     C                   PARM      35            P1LEN1
     C                   PARM                    P1STRT
     C                   PARM                    SVINS1
     C                   PARM      35            P1LEN2
     C                   PARM                    P1XLAT
     C                   PARM                    P1TRIM
     C                   PARM                    P1WILD
     C                   PARM                    P1RSLT
     C                   ENDIF
      *
     C                   Z-ADD     1             P2RSLT
     C     SVCITY        IFNE      *BLANKS
     C                   CALL      'QCLSCAN'
     C                   PARM                    B3CITY
     C                   PARM      35            P1LEN1
     C                   PARM                    P1STRT
     C                   PARM                    SVCITY
     C                   PARM      20            P1LEN2
     C                   PARM                    P1XLAT
     C                   PARM                    P1TRIM
     C                   PARM                    P1WILD
     C                   PARM                    P2RSLT
     C                   ENDIF
      *
      ** Write detail to subfile
      *
     C     P1RSLT        IFGE      1
     C     P2RSLT        ANDGE     1
     C     P3RSLT        ANDGE     1
     C                   ADD       1             LINENO
      *
     C     LINENO        IFLE      15
     C                   MOVE      B3BICC        S0BICC
     C                   MOVE      B3BRCD        S0BRCD
     C                   MOVE      B3BRCD        H0BRCD                                     MD023856
     C                   EXSR      CVTBRCD                                                  MD023856
     C                   MOVE      B3INS1        S0INS1
     C                   MOVEL     B3CITY        S0CITY
     C                   MOVE      *BLANK        S0SEL
     C                   ADD       1             S0RRN                31
      ** Write subfile record number                                                        MD024108
     C                   Z-ADD     S0RRN         C0SFRC                                     MD024108
     C                   WRITE     MS000101S0
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Read next record
      *
     C     LINENO        IFLE      15
     C                   READ      MEBIB3L1                               32
     C                   ENDIF
     C                   ENDDO
      *
      ** Set Subfile Record Number and Save
      *
     C*****X0RRN         ADD       1             C0SFRC                                     MD024108
     C                   Z-ADD     S0RRN         X0RRN
     C                   MOVE      B3BICC        X0BICC
     C                   MOVE      B3BRCD        X0BRCD
      *
     C                   ENDSR
      *
      *******************************************************************
      *                                                                 *
      * #DISP0 - Display Subfile                                        *
      *                                                                 *
      *******************************************************************
      *
     C     #DISP0        BEGSR
      *
      ** If no records displayed, output message
      *
     C     S0RRN         IFEQ      0
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     'Y2U0008'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C                   WRITE     MS000101F1
     C                   WRITE     MS000101C2
     C                   WRITE     MS000101F2
     C                   EXFMT     MS000101C0
      *
      ** Clear messages from program message queue
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM                    ZAPGM
     C                   PARM      '*SAME'       ZAPGRL
      *
      ** Maintain subfile page
      *
      ** Remove the following codes, incorrect subfile record number                        MD024108
     C*****INSFRC        IFNE      0                                                        MD024108
     C**********         Z-ADD     INSFRC        C0SFRC                                     MD024108
     C**********         ENDIF                                                              MD024108
      *
     C                   ENDSR
      *
      *******************************************************************
      *                                                                 *
      * #READ0 - Read Subfile                                           *
      *                                                                 *
      *******************************************************************
      *
     C     #READ0        BEGSR
      *
      * Process each record selected until either all processed or F3 or
      * F12 taken
      *
     C     *IN31         IFEQ      '1'
      ** If F15=IBAN screen was pressed, re-point to previous sfl RRN                       MD024108
      ** else read sfl change for next record                                               MD024108
     C                   IF        *INKP = '0'                                              MD024108
     C                   READC     MS000101S0                             90
     C                   ELSE                                                               MD024108
     C     S0RRN         CHAIN     MS000101S0                         90                    MD024108
     C                   EVAL      S0SEL = 'E'                                              MD024108
     C                   ENDIF                                                              MD024108
      *
     C     *IN90         DOWEQ     '0'
     C     *INKC         ANDEQ     '0'
     C     *INKL         ANDEQ     '0'
      *
     C     K2BICD        CHAIN     MEBIB3L1                           99
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'MEBIB3L1'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     S0BICC        DBKEY
     C**********         MOVE      S0BRCD        DBKEY                                      MD023856
     C                   MOVE      H0BRCD        DBKEY                                      MD023856
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     S0SEL         IFEQ      'E'
     C                   EXSR      #INLZ1
     C                   EXSR      #LOAD1
      *
      ** If CFT004 is on and if corresponding entry exist in IBAN Plus,
      ** "F15=IBAN Plus" will be enable.
      *
     C*****B3KEY         CHAIN     MEIBN3L0                           99                    MD022084
     C     B3IBNK        CHAIN     MEIBN3L0                           99                    MD022084
     C     *IN99         IFEQ      '1'
     C                   MOVEA     '0'           *IN(61)
     C                   ELSE
     C                   MOVEA     '1'           *IN(61)
     C                   ENDIF
     C                   EXSR      #DISP1
     C                   ENDIF
      *
      ** Re-point the subfile RRN                                                           MD024108
     C     S0RRN         CHAIN     MS000101S0                         90                    MD024108
     C                   MOVE      ' '           S0SEL
     C                   UPDATE    MS000101S0
      *
      ** If F15=IBAN screen was pressed, set indicator 91 to ON                             MD024108
      ** to load the IBAN screen else read sfl change for next record                       MD024108
     C                   IF        *INKP = '0'                                              MD024108
     C  NKL              READC     MS000101S0                             90
     C                   ELSE                                                               MD024108
     C                   EVAL      *IN90 = '1'                                              MD024108
     C                   ENDIF                                                              MD024108
     C                   ENDDO
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *
      *****************************************************************
     C     #READ1        BEGSR
      *
      ** Display using KEY Field
      *
     C     B3KEY         CHAIN     MEBIB3L0                           99
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      '1'           *IN(63)
     C                   ENDIF
      *
     C     *INKP         IFNE      *ON
     C                   MOVEA     '0'           *IN(60)
     C                   EXSR      #INLZ1
     C                   EXSR      #LOAD1
     C                   ENDIF
      *
      ***  WHEN *IN15 is available
      ***  Please add/activate code to EXSR #INLZ2, #LOAD2, #DISP2
      ***  F12 BACK to #READ1
      ***  F3 Leave PGM
      *
     C     *INKP         IFEQ      *ON
     C*****B3KEY         CHAIN     MEIBN3L0                           99                    MD022084
     C     B3IBNK        CHAIN     MEIBN3L0                           99                    MD022084
      *
      *
     C                   EXSR      #INLZ2
     C                   EXSR      #LOAD2
     C******INKC         DOWEQ     '0'                                            MD023143A MD023398
     C******INKL         ANDEQ     '0'                                            MD023143A MD023398
     C                   EXSR      #DISP2
     C**********         ENDDO                                                    MD023143A MD023398
     C                   MOVE      '1'           *INKP
     C                   ENDIF
      *
     C                   ENDSR
      *******************************************************************
      /EJECT
      *******************************************************************
      *                                                                 *
      * #INLZ1 - Initialize Subfile                                     *
      *                                                                 *
      *******************************************************************
      *
     C     #INLZ1        BEGSR
      *
      ** Clear subfile
      *
     C                   MOVEA     '0000'        *IN(50)
     C                   WRITE     MS000101C1
     C                   MOVE      '1'           *IN50
     C                   MOVE      '0'           *INKP
     C     *INKP         IFEQ      '0'
     C                   MOVEA     '0'           *IN(60)
     C                   ENDIF
      *
     C                   WRITE     MS000101F1
      *
     C                   Z-ADD     0             S1RRN
      *
     C                   MOVE      '1'           MFILE             1
     C                   Z-ADD     10            MSEQN             5 0
      *
     C     *LOVAL        SETLL     MEBICFPD
     C                   READE     MEBICFPD                               52
      *
     C                   ENDSR
      *
      *******************************************************************
      /EJECT
      *******************************************************************
      *                                                                 *
      * #INLZ2 - Initialize Subfile                                     *
      *                                                                 *
      *******************************************************************
      *
     C     #INLZ2        BEGSR
      *
      ** Clear subfile
      *
     C                   MOVEA     '0000'        *IN(50)
     C                   WRITE     MS000101C1
     C                   MOVE      '1'           *IN50
     C                   MOVE      '1'           *INKP
     C     *INKP         IFEQ      '1'
     C                   MOVEA     '1'           *IN(60)
     C                   ENDIF
      *
     C                   WRITE     MS000101F1
      *
     C                   Z-ADD     0             S1RRN
      *
     C                   MOVE      '2'           MFILE
     C                   Z-ADD     10            MSEQN
      *
     C     *LOVAL        SETLL     MEBICFPD
     C                   READE     MEBICFPD                               52
      *
     C                   ENDSR
      *
      *******************************************************************
      /EJECT
      *******************************************************************
      *                                                                 *
      * #LOAD1 - Load Subfile                                           *
      *                                                                 *
      *******************************************************************
      *
     C     #LOAD1        BEGSR
      *
      ** Load SFL page until end of file
      *
     C     *IN52         DOWEQ     '0'
      *
      ** Set Line detail
      *
     C     MEXCL         IFEQ      ' '
     C                   EXSR      #SETL1
      *
     C     S1FVAL        IFNE      *BLANKS
     C                   ADD       1             S1RRN                51
     C                   WRITE     MS000101S1
     C                   ENDIF
     C                   ENDIF
      *
      ** Read next record
      *
     C                   READ      MEBICFPD                               52
     C                   ENDDO
      *
     C                   ENDSR
      *
      *******************************************************************
      /EJECT
      *******************************************************************
      *                                                                 *
      * #LOAD2 - Load Subfile                                           *
      *                                                                 *
      *******************************************************************
      *
     C     #LOAD2        BEGSR
      *
      * Load SFL page until end of file
      *
     C     *IN52         DOWEQ     '0'
      *
      ** Set Line detail
      *
     C     MEXCL         IFEQ      ' '
     C                   EXSR      #SETL2
      *
     C     S1FVAL        IFNE      *BLANKS
     C                   ADD       1             S1RRN                51
     C                   WRITE     MS000101S1
     C                   ENDIF
     C                   ENDIF
      *
      ** Read next record
      *
     C                   READ      MEBICFPD                               52
     C                   ENDDO
      *
     C                   ENDSR
      *
      *******************************************************************
      /EJECT
      *******************************************************************
      *                                                                 *
      * #SETL1 - Write Subfile                                          *
      *                                                                 *
      *******************************************************************
      *
     C     #SETL1        BEGSR
      *
     C                   MOVE      *BLANKS       S1DESC
     C                   MOVE      *BLANKS       S1FVAL
      *
      ** Process for each of the fields on file
      *
     C     WHFLDE        IFEQ      'B3FLAG'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     B3FLAG        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'B3KEY '
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     B3KEY         S1FVAL
     C                   MOVEL     B3KEY         KEYREF
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'B3OFTP'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     B3OFTP        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'B3POKY'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     B3POKY        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'B3HOKY'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     B3HOKY        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'B3LGTP'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     B3LGTP        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'B3LGPK'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     B3LGPK        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'B3GRTP'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     B3GRTP        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'B3ISST'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     B3ISST        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'B3CGKY'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     B3CGKY        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'B3LEIC'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     B3LEIC        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'B3BICC'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     B3BICC        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'B3BRCD'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     B3BRCD        S1FVAL
     C                   EXSR      CVTBRCD                                                  MD023856
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'B3UBIC'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     B3UBIC        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'B3CHIP'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     B3CHIP        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'B3NATI'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     B3NATI        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'B3CBIC'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     B3CBIC        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'B3INS1'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     B3INS1        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'B3INS2'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     B3INS2        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'B3INS3'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     B3INS3        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'B3BIN1'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     B3BIN1        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'B3BIN2'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     B3BIN2        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'B3POBN'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     B3POBN        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'B3ADD1'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     B3ADD1        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'B3ADD2'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     B3ADD2        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'B3ADD3'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     B3ADD3        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'B3ADD4'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     B3ADD4        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'B3CITY'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     B3CITY        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'B3CPS1'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     B3CPS1        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'B3CPS2'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     B3CPS2        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'B3CPS3'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     B3CPS3        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'B3ZIP '
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     B3ZIP         S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'B3CNT1'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     B3CNT1        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'B3CNT2'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     B3CNT2        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'B3ISOC'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     B3ISOC        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'B3TMZN'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     B3TMZN        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'B3STYP'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     B3STYP        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'B3NWCY'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     B3NWCY        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'B3BRQA'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     B3BRQA        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'B3SER1'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     B3SER1        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'B3SER2'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     B3SER2        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'B3SSIC'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     B3SSIC        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'B3IBNK'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     B3IBNK        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'B3FILA'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     B3FILA        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'B3FLB1'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     B3FLB1        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'B3FLB2'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     B3FLB2        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'B3UDAT'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     B3UDAT        S1FVAL
     C                   ENDIF
      *
     C                   ENDSR
      *
      *******************************************************************
      /EJECT
      *******************************************************************
      *                                                                 *
      * #SETL2 - Write Subfile                                          *
      *                                                                 *
      *******************************************************************
      *
     C     #SETL2        BEGSR
      *
     C                   MOVE      *BLANKS       S1DESC
     C                   MOVE      *BLANKS       S1FVAL
      *
      * Process for each of the fields on file
     C     WHFLDE        IFEQ      'N3FLAG'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     N3FLAG        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'N3KEY '
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     N3KEY         S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'N3INS1'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     N3INS1        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'N3INS2'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     N3INS2        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'N3INS3'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     N3INS3        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'N3CTY1'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     N3CTY1        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'N3CTY2'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     N3CTY2        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'N3ISOC'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     N3ISOC        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'N3IBNC'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     N3IBNC        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'N3IBIC'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     N3IBIC        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'N3INAT'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     N3INAT        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'N3SCTX'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     N3SCTX        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'N3FLDA'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     N3FLDA        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'N3FLB1'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     N3FLB1        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'N3FLB2'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     N3FLB2        S1FVAL
     C                   ENDIF
      *
     C     WHFLDE        IFEQ      'N3UDAT'
     C                   MOVEL     WHFTXT        S1DESC
     C                   MOVEL     N3UDAT        S1FVAL
     C                   ENDIF
      *
     C                   ENDSR
      *******************************************************************
      /EJECT
      *******************************************************************
      *                                                                 *
      * #DISP1 - Display Subfile                                        *
      *                                                                 *
      *******************************************************************
      *
     C     #DISP1        BEGSR
      *
      ** If no records displayed, output message
      *
     C                   MOVE      '0'           *INKP
     C     S1RRN         IFEQ      0
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     'Y2U0008'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C                   WRITE     MS000101C2
     C                   WRITE     MS000101F3
     C                   EXFMT     MS000101C1
      *
      ** Clear messages from program message queue
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM                    ZAPGM
     C                   PARM      '*SAME'       ZAPGRL
      *
     C                   ENDSR
      *
      *******************************************************************
      /EJECT
      *******************************************************************
      *                                                                 *
      * #DISP2 - Display Subfile                                        *
      *                                                                 *
      *******************************************************************
      *
     C     #DISP2        BEGSR
      *
      ** If no records displayed, output message
      *
     C     S1RRN         IFEQ      0
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     'Y2U0008'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C                   MOVEA     '0'           *IN(60)
     C                   MOVEA     '0'           *IN(61)
     C     *IN62         IFEQ      '1'
     C                   MOVEA     '1'           *IN(60)
     C                   MOVEA     '1'           *IN(61)
     C                   ENDIF
     C                   WRITE     MS000101C2
     C                   WRITE     MS000101F3
     C                   EXFMT     MS000101C1
      *
      ** Clear messages from program message queue
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM                    ZAPGM
     C                   PARM      '*SAME'       ZAPGRL
      *
     C                   ENDSR
      *
      *******************************************************************
      *                                                                 *
      * ZASNMS - Send Message to Program Message Queue                  *
      *                                                                 *
      *******************************************************************
      *
     C     ZASNMS        BEGSR
      *
     C     ZAMSGF        IFEQ      *BLANKS
     C                   MOVEL     'XXUSRMSG'    ZAMSGF
     C                   ENDIF
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGM
     C                   PARM                    ZAPGRL
     C                   PARM                    ZAMSID
     C                   PARM                    ZAMSGF
     C                   PARM                    ZAMSDA
     C                   PARM                    ZAMSTP
      *
     C                   MOVEL     *BLANKS       ZAMSGF
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     *BLANK        ZAPGRL
      *
     C                   ENDSR
      *
      *******************************************************************
      *                                                                 *
      * #INIT - Initial Program Subroutine                              *
      *                                                                 *
      *******************************************************************
      *
     C     #INIT         BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    MENREF            1
     C                   PARM                    KEYREF           12
      *
      ** Define Key Lists
      *
     C     K0BICD        KLIST
     C                   KFLD                    C0BICC
     C                   KFLD                    C0BRCD
      *
     C     K1BICD        KLIST
     C                   KFLD                    SVBICC
     C                   KFLD                    SVBRCD
      *
     C     K2BICD        KLIST
     C                   KFLD                    S0BICC
     C**********         KFLD                    S0BRCD                                     MD023856
     C                   KFLD                    H0BRCD                                     MD023856
      *
     C     K1FSEQ        KLIST
     C                   KFLD                    MFILE
     C                   KFLD                    MSEQN
      *
      ** Define all program work fields
      *
     C     *LIKE         DEFINE    B3BICC        X0BICC
     C     *LIKE         DEFINE    B3BRCD        X0BRCD
     C     *LIKE         DEFINE    S0RRN         X0RRN
     C     *LIKE         DEFINE    C0BICC        SVBICC
     C     *LIKE         DEFINE    C0BRCD        SVBRCD
     C     *LIKE         DEFINE    C0INS1        SVINS1
     C     *LIKE         DEFINE    C0CITY        SVCITY
      ** Save the MENREF key                                                                MD024108
     C                   MOVEL     MENREF        SVMREF            1                        MD024108
      *
     C                   Z-ADD     0             P1LEN1            3 0
     C                   Z-ADD     1             P1STRT            3 0
     C                   Z-ADD     0             P1LEN2            3 0
     C                   Z-ADD     0             P1RSLT            3 0
     C                   Z-ADD     0             P2RSLT            3 0
     C                   Z-ADD     0             P3RSLT            3 0
     C                   MOVE      '1'           P1XLAT            1
     C                   MOVE      '1'           P1TRIM            1
     C                   MOVE      '?'           P1WILD            1
      *
     C                   MOVE      *BLANKS       ZAPGM            10
     C                   MOVE      *BLANKS       ZAPGRL            5
     C                   MOVE      *BLANKS       ZAMSID            7
     C                   MOVE      *BLANKS       ZAMSGF           10
     C                   MOVE      *BLANKS       ZAMSDA          132
     C                   MOVE      *BLANKS       ZAMSTP            7
      *
     C                   Z-ADD     0             S0RRN             5 0
     C                   Z-ADD     0             S1RRN             5 0
     C                   Z-ADD     0             LINENO            2 0
     C                   Z-ADD     0             X                 2 0
     C                   Z-ADD     0             POSN              2 0
     C                   Z-ADD     0             LNGTH             2 0
     C                   Z-ADD     0             WBCBF             1 0
      *
      ** Get Rundate
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
      *
      ** Access AOSARDR0 to check if CFT004 is switched on
      ** CFT004 - INTERNATIONAL BANK ACCOUNT NUMBER
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CFT004'      @SARD             6
      *
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   Z-ADD     1             DBASE
     C                   MOVEL     '*VERIFY'     DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CFT004            1
     C                   ELSE
     C                   MOVE      'N'           CFT004
     C                   ENDIF
      *
     C                   MOVEL     PGM           ZAPGM
      *
      ** Set screen constants and output header
      *
     C                   MOVEL     PGM           SPGM
     C                   MOVEL     WSID          SWSID
     C                   MOVEL     USER          SUSER
     C                   MOVEL     AGMRDT        SRUNA
      *
     C                   WRITE     MS000101F1
      *
     C                   ENDSR
      *******************************************************************                   MD023856
      *                                                                 *                   MD023856
      * CVTBRCD - Convert Branch Code                                   *                   MD023856
      *                                                                 *                   MD023856
      *******************************************************************                   MD023856
      *                                                                                     MD023856
     C     CVTBRCD       BEGSR                                                              MD023856
      *                                                                                     MD023856
     C     ' '           CHECKR    B3BRCD        WPOS              1 0    99                MD023856
     C                   IF        WPOS < 3                                                 MD023856
     C                   MOVE      *BLANKS       WCHAR             1                        MD023856
     C                   MOVE      'Y'           WFLAG             1                        MD023856
     C                   Z-ADD     0             WX                1 0                      MD023856
     C                   DOW       WX < WPOS                                                MD023856
     C                   EVAL      WX +=1                                                   MD023856
     C                   EVAL      WCHAR = %SUBST(B3BRCD:WX:1)                              MD023856
     C                   IF        WCHAR >= '0'                                             MD023856
     C                             AND WCHAR <= '9'                                         MD023856
     C                   ELSE                                                               MD023856
     C                   EVAL      WFLAG = 'N'                                              MD023856
     C                   ENDIF                                                              MD023856
     C                   ENDDO                                                              MD023856
     C                   IF        WFLAG = 'Y'                                              MD023856
     C                   EVALR     WBRCD = '000' + %TRIM(B3BRCD)                            MD023856
     C                   EVAL      S0BRCD = WBRCD                                           MD023856
     C                   EVAL      S1FVAL = WBRCD                                           MD023856
     C                   ENDIF                                                              MD023856
     C                   ENDIF                                                              MD023856
      *                                                                                     MD023856
     C                   ENDSR                                                              MD023856
      *
      *******************************************************************
      *                                                                 *
      * *PSSR  - Program Exception Error Routine                        *
      *                                                                 *
      *******************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   MOVEL     'MS000101'    DBPGM
     C                   OUT       LDA
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *******************************************************************
