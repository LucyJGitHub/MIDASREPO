     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas Bank of England Extra Account Data Repair')      *
      *****************************************************************
      *                                                               *
      *  Midas - Bank Of England                                      *
      *                                                               *
      *  BYCUSDW0RP - Window repair module                            *
      *                                                               *
      *  Function:  This program allows the repair of any invalid     *
      *             fields input via the APIs for the extension file. *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CSD027             Date 21Jan09               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Prev Amend No. LLN022             Date 24Jan05               *
      *                 LLN020             Date 15Jul02               *
      *                 201981             Date 17Jan02               *
      *                 LLN018 *CREATE     Date 17Apr01               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  LLN022 - BOE Upgrade to MidasPlus.                           *
      *  LLN020 - Upgrade BOE to Midas Release 4.                     *
      *           Rename fields to avoid conflict with CARS.          *
      *  201981 - Ensure database errors do not occur if no record and*
      *           'E' mode or a record and 'I' mode.                  *
      *  LLN018 - Upgrade BoE to APIs and addition of 2 new fields    *
      *           on ICD.
      *                                                               *
      *****************************************************************
      /TITLE    S U B R O U T I N E   I N D E X .                     *
      *                                                               *
      *     Subroutine Index                                          *
      *     ================                                          *
      *                                                               *
      *     1. CLEAR   -   Clear fields/indicators                    *
      *     2. RESET   -   Refresh window display (F5)                *
      *     3. EXIT    -   Leave Program via END (F3)                 *
      *     4. INIT    -   Initial Processing                         *
      *     5. PREV    -   Leave program via END (F12)                *
      *     6. UPDAT   -   Update Processing                          *
      *     7. #EMOVI  -   Move Fields into screen fields             *
      *     8. #EMOVO  -   Move screen fields back                    *
      *     9. #EVAL   -   Validation Processing                      *
      *    10. ZASNMS  -   Sends Message to Message Subfile           *
      *    11. *PSSR   -   Database Error Handling                    *
      *    12. END     -   Leave program                              *
      *                                                               *
      *    STANDARD SUBROUTINES                                       *
      *    ====================                                       *
      *                                                               *
      *                                                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *       03      F3 PRESSED EXIT PROGRAM                         *
      *       05      F5 PRESSED REDISPLAY THE SCREEN                 *
      *       12      F12 PRESSED GOTO PREVIOUS SCREEN                *
      *       20      FIELDS TO BE PRETECTED DURING ENQUIRY           *
      *---------------------------------------------------------------*
      *       **      FIELDS ENTERED INCORRECTLY                      *
      *       50      Field 1                                         *
      *       51      Field 2                                         *
      *       52      Field 3                                         *
      *     53-69     FURTHER EXPANSION OF WINDOW FIELDS              *
      *---------------------------------------------------------------*
      *       86      CHAIN TO BYACCTY0 FAILED  (extension logical)   *
      *---------------------------------------------------------------*
      *       99      Chain indicator                                 *
      *****************************************************************
      ** Input Files
 
     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)
 
     FBYACCTY0  IF   E           K DISK
     F                                     INFSR(*PSSR)
     F                                     COMMIT
      ** Extension file (retrieval)
 
     FGLIAMADY0 UF   E           K DISK
     F                                     INFSR(*PSSR)
     F                                     COMMIT
      ** Invalid Account Details logical file
 
     FBYACCT#0  CF   E             WORKSTN
      ** Display File for Window
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      /SPACE 3
      *****************************************************************
     D*****************************************************************
 
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
 COPYD/COPY ZACPYSRC,ERR_ARRAYS
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      **
      **   Named constants
      **   ===============
      **
 
      **
      **   Arrays and Data Structures
      **   ==========================
      **
      * Add 1 onto elements in array for each field on window
     D @EI             S              1    DIM(6)
 
      ** Return code from following window - 'R' if F12 key pressed.
     D SPARE2          DS           256
     D  WUCF12               246    246
 
      *
      *** Datastructure to define input parameter DATA
      /COPY QWINDSRC,GLAMADDTA
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for Access programs, Short data structure.
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ***  Second DS for Access programs, Long data structure.
      *
 
      ** Current Customer in File Format
     D CrAcFilFmt    E DS                  EXTNAME(BYACCTY0)
 
      ** Current Customer in Screen Format (#S)
     D CrAcScnFmt    E DS                  EXTNAME(GLAMEXPD)
     D                                     PREFIX(SS)
 
      ** New Customer in File Format (V)
     D NwAcFilFmt    E DS                  EXTNAME(GLVAMADX0)
 
      ** New Customer in Screen Format (#S)
     D NwAcScnFmt    E DS                  EXTNAME(GLAMEXPD)
 
      ** Error indicators (OK#S)
     D OkFlags       E DS                  EXTNAME(GLEAMADX0)
 
      **   Declared variables
      **   ==================
      **
 
     D U#ACOD          S             10  0                                                    LLN022
     D ACTN            S              1
     D W0RTN           S              7
     D WLEN            S              3S 0
     D WWID            S              3S 0
     D WFIRST          S              1
     D WWERR           S              1
     D WFIND           S              1
     D TITLE           S              7
 
 
      ** Fields for getting the starting field number from file (parameters
      ** to ZAGETFLDNO, plus the offset to the requested field).
      ** Initialise Field to first field on Extra Data Layout file.
 
     D Format          S             10A   INZ('GLAMEXPD')
     D Field           S             10A   INZ('LSIOF')
     D FieldNo         S              5P 0
     D FldOffset       S              5P 0
 
      ** Define *entry parameters
 
      ** Standards Input Parameters
     D SROW            S              3  0                                      Window position
     D SCOL            S              3  0
     D @EINKE          S              1
     D @EIN20          S              1                                         Enable Indicator
      ** Standards Output Parameters
     D @INKC           S              1                                         Function Keys
     D @INKL           S              1
     D @INKE           S              1
 
 
     D Idx             S              3P 0 INZ(0)                               Index error array
     D WIdx            S              3P 0 INZ(0)                               Index warning array
 
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *
      **   Standard parameter list for window manager
      *
     C     *ENTRY        PLIST
     C                   PARM                    ACTN              1
     C                   PARM                    DATA
     C                   PARM                    W8RTN             7
     C                   PARM                    WLEN              3 0
     C                   PARM                    WWID              3 0
     C                   PARM                    SROW              3 0
     C                   PARM                    SCOL              3 0
     C                   PARM                    TITLE             7
     C                   PARM                    SPARE2          256
      *
      *
      *****************************************************************
      *
      *                M A I N  P R O C E S S I N G
      *
      *****************************************************************
      *                                                               *
      *  Main Loop                                                    *
      *                                                               *
      *  Calls: INIT                                                  *
      *         EXIT                                                  *
      *         PREV                                                  *
      *         #EVAL                                                 *
      *         CLEAR                                                 *
      *         END                                                   *
      *                                                               *
      *****************************************************************
      *
      ** Initialise data
      *
     C                   EXSR      INIT
      *
      *
      ** Continue to redisplay the screen while errors
      *
     C     WWERR         DOUEQ     'N'
      *
      ** Move 'OK' Flags into array (for checking)
      *
     C                   MOVEA     OkFlags       @EI
      *
      ** Set screen error indicators according to status of 'OK' flags
      *
     C                   Z-ADD     1             C                 2 0
     C                   Z-ADD     50            E                 2 0
      *
 
     C     C             DOUGT     6
     C     @EI(C)        IFEQ      'N'
     C     @EI(C)        OREQ      'W'
     C                   MOVEL     '1'           *IN(E)
     C                   END
     C                   ADD       1             C
     C                   ADD       1             E
     C                   END
      *
      ** Do while error messages found write error messages to subfile
      *
     C                   Z-ADD     1             C
     C     C             DOWLE     ArrayMax
     C     FldNameArr(C) ANDNE     *BLANKS
     C                   MOVEL     MsgIdArr(C)   ZAMSID
     C                   MOVEL     MsgDtaArr(C)  ZAMSDA
     C                   EXSR      ZASNMS
     C                   ADD       1             C
     C                   END
      *
      ** Do while warning messages found write warning messages to subfile
      *
     C                   Z-ADD     1             C
     C     C             DOWLE     ArrayMax
     C     WFldNamArr(C) ANDNE     *BLANKS
     C                   MOVEL     WMsgIdArr(C)  ZAMSID
     C                   MOVEL     WMsgDtaArr(C) ZAMSDA
     C                   EXSR      ZASNMS
     C                   ADD       1             C
     C                   END
      *
      ** Set screen protect/non-display indicators
      **
     C     @EINKE        COMP      'Y'                                    35
      *
      ** Write message subfile and window details screen
      *
     C                   WRITE     WINDOWF
     C                   WRITE     #MSGCTL
 
     C                   EXFMT     WINDOWF
      ** Clear message subfile
     C                   EXSR      CLEAR
      *
      *
      ** Set screen error indicators off (One 0 per screen field)
      *
     C                   MOVEA     '000000'      *IN(50)
      *
      ** Set return keys
      *
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKE         @INKE
     C                   MOVE      *INKL         @INKL
      *
      *
      *
      ** Reset errors
      *
     C                   MOVE      *ALL'Y'       OkFlags
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             WIdx
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
     C                   MOVE      *BLANKS       W0RTN
      *
      *
      *
     C     @INKC         CASEQ     '1'           EXIT
     C     @INKE         CASEQ     '1'           RESET
     C     @INKL         CASEQ     '1'           PREV
     C                   CAS                     #EVAL
     C                   ENDCS
     C                   ENDDO
      *
      **   Exit from program
      *
     C                   EXSR      END
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * CLEAR MESSAGE FILE AND ERROR INDICATORS FOR NEXT VALIDATION
      *****************************************************************
      *                                                               *
      *  SR/CLEAR                                                     *
      *                                                               *
      *  Called by: MAIN LOOP                                         *
      *                                                               *
      *  Calls: -                                                     *
      *                                                               *
      *****************************************************************
     C     CLEAR         BEGSR
     C                   CALL      'Y2CLMSC'
     C                   PARM      PSProcName    ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
     C                   ENDSR
      *****************************************************************
      /EJECT
     C*****************************************************************
     C* RESET/REFRESH THE SCREEN IF F5 IS PRESSED
     C*****************************************************************
     C     RESET         BEGSR
     C*
     C** CALL SUBROUTINE INIT TO RETRIEVE THE LAST COMMITED DATA ON
     C** THE EXTENSION FILE.
     C*
     C                   EXSR      INIT
     C*
     C** RESET ALL THE ERROR INDICATORS (However many screen fields)
     C*
     C                   SETOFF                                       505152                   LBH02
     C                   SETOFF                                       535455                   LBH02
 
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
      * EXIT FROM PROGRAM IF F3 HAS BEEN PRESSED
      *****************************************************************
      *                                                               *
      *  SR/EXIT                                                      *
      *                                                               *
      *  Called by: MAIN LOOP                                         *
      *                                                               *
      *  Calls: END                                                   *
      *                                                               *
      *****************************************************************
     C     EXIT          BEGSR
     C                   MOVE      'Y2U9999'     W8RTN
     C                   EXSR      END
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INITIALISE FIELDS
      *****************************************************************
      *                                                               *
      *  SR/INIT                                                      *
      *                                                               *
      *  Called by: MAIN LOOP                                         *
      *                                                               *
      *  Calls: *PSSR (3 times)                                       *
      *                                                               *
      *****************************************************************
      *
     C     INIT          BEGSR
      *
      ** Moving message file details
      *
     C                   MOVEL     'GBBYUSRMSG'  ZAMSGF
     C                   MOVEL     PSProcName    ZAPGMQ
     C                   MOVEL     PSProcName    DBPGM
     C                   MOVEL     PSProcName    ##PGM
      ** Define window position
      *
     C                   MOVE      SROW          SWROW
     C                   MOVE      SCOL          SWCOL
      *
      **   Retrieve title for window
      *
     C                   MOVEL     'GBBYUSRMSG'  ZAMSGF
     C                   CALL      'SDRTVTXT'
     C                   PARM                    TITLE
     C                   PARM                    ZAMSGF
     C                   PARM                    TEXT            132
     C                   MOVEL     TEXT          STITL
      *
      ** Protect input fields if enquiry, else make sure they are
      **                                  highlighted on window
      *
     C     ACTN          IFEQ      'E'
     C                   MOVE      '1'           *IN20
     C                   ENDIF
      *---------------------------------------------------------------
      *
     C     K@KEY1        KLIST
     C***                KFLD                    ULTMST                         LLN020
     C***                KFLD                    ULFOTR                         LLN020
     C                   KFLD                    BYTMST                         LLN020
     C                   KFLD                    BYFOTR                         LLN020
 
     C     KLIST1        KLIST
     C                   KFLD                    U#BRCD            3
     C**********         KFLD                    U#CNUM            6 0                        CSD027
     C                   KFLD                    U#CNUM            6                          CSD027
     C                   KFLD                    U#CCY             3
     C**********         KFLD                    U#ACOD            4 0                        LLN022
     C                   KFLD                    U#ACOD                                       LLN022
     C                   KFLD                    U#ACSQ            2 0
 
      ** Retrieve record in extension file
      ** Chain records for fields
     C***                MOVEL     ULBRCD        U#BRCD                         LLN020
     C***                MOVEL     ULCNUM        U#CNUM                         LLN020
     C***                MOVEL     ULCCY         U#CCY                          LLN020
     C***                MOVEL     ULACOD        U#ACOD                         LLN020
     C***                MOVEL     ULACSQ        U#ACSQ                         LLN020
     C                   MOVEL     BYBRCD        U#BRCD                         LLN020
     C**********         MOVEL     BYCNUM        U#CNUM                                LLN020 CSD027
     C                   MOVE      BYCNUM        U#CNUM                                       CSD027
     C                   MOVEL     BYCCY         U#CCY                          LLN020
     C                   MOVEL     BYACOD        U#ACOD                         LLN020
     C                   MOVEL     BYACSQ        U#ACSQ                         LLN020
      *
     C     KLIST1        CHAIN     BYACCTY0                           86
      *
      ** Record not found therefore if amend/enqiry return to previous
      ** screen...
      * Save Action code if changing it as want to pass the correct                 201981
      * Action code back to WN0010.                                                 201981
     C                   MOVE      *BLANKS       LACTN             1                201981
      *
     C     *IN86         IFEQ      *ON
     C     ACTN          ANDEQ     'A'
     C     *IN86         OREQ      '1'                                              201981
     C     ACTN          ANDEQ     'E'                                              201981
     C                   MOVE      ACTN          LACTN                              201981
     C                   MOVE      'I'           ACTN
     C                   ENDIF
      *
      ** Record found in insert mode, then change mode to Amend.
      *
     C     ACTN          IFEQ      'I'
     C     *IN86         ANDEQ     '0'
     C                   MOVE      ACTN          LACTN                              201981
     C                   MOVE      'A'           ACTN
     C                   ENDIF
      *
      ** Moving fields into screen fields
      *
     C                   EXSR      #EMOVI
      *
      ** Now overwrite the fields on the main details screen with those
      ** on the invalid extended deals file
      *
     C     K@KEY1        CHAIN     GLIAMADD0                          85
 
      * Move screen fields into data structure fields to be passed to
      * validation module.
     C                   Eval      NETI = LINETI
     C                   Eval      DPTP = LIDPTP
     C                   Eval      SNOD = LISNOD
     C                   Eval      LNTP = LILNTP
     C                   Eval      MDAT = LIMDAT
     C                   Eval      LLIM = LILLIM
      *
     C                   MOVE      *ALL'Y'       OkFlags
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             WIdx
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
     C                   MOVE      *BLANKS       W0RTN
     C                   MOVEA     '000000'      *IN(50)
 
     C                   CALLB     'BYAMADW0VL'
     C                   PARM                    ACTN
     C                   PARM                    DATA
     C                   PARM                    NwAcScnFmt
     C                   PARM                    OkFlags
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    NwAcFilFmt
      *
      * Move Invalid file fields to screen fields.
     C                   MOVE      LINETI        L#NETT
     C                   MOVE      LIDPTP        L#DPTY
     C                   MOVE      LISNOD        L#SNOD
     C                   MOVE      LILNTP        L#LNTY
     C                   MOVE      LIMDAT        L#LNMD
     C                   MOVE      LILLIM        L#LNLT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *    EXIT FROM PROGRAM IF F12 HAS BEEN PRESSED
      *****************************************************************
      *                                                               *
      *  SR/PREV                                                      *
      *                                                               *
      *  Called by: MAIN LOOP                                         *
      *                                                               *
      *  Calls: END                                                   *
      *                                                               *
      *****************************************************************
      *
     C     PREV          BEGSR
      *
      ** Set F12 return code and end program
      *
     C                   MOVE      'USR0790'     W8RTN
     C                   EXSR      CLEAR
     C                   EXSR      END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATE THE EXTENSION FILE
      *****************************************************************
      *                                                               *
      *  SR/UPDAT                                                     *
      *                                                               *
      *  Called by: MAIN LOOP                                         *
      *                                                               *
      *  Calls: *PSSR                                                 *
      *                                                               *
      *****************************************************************
      *
     C     UPDAT         BEGSR
      *
     C                   EXSR      #EMOVO
      ** In Amend Mode
     C                   CALLB     'BYAMADW0UP'
     C                   PARM                    ACTN
     C                   PARM                    DATA
     C                   PARM      *BLANK        @RTCD
     C                   PARM                    WFIND
     C                   PARM                    NwAcFilFmt
     C                   PARM                    CrAcFilFmt
      *
      ** If there were any errors in the update functions, rollback any
      ** updates and end this pgm,
      *
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*RECUPD'
     C     @RTCD         ANDNE     '*RECLCK'
     C                   ROLBK
     C                   EXSR      *PSSR
     C                   ENDIF
 
 
      *
      ** If update not done due to record has been updated by another
      ** workstation send message to screen.
      *
     C     @RTCD         IFEQ      '*RECUPD'
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'ER99919'     #MsgID
     C                   MOVEL     #MsgID        MsgIdArr(1)
     C                   MOVE      ' '           WWERR
     C                   ENDIF
      *
      ** If update not done due to record being locked by another
      ** workstation send message to screen.
      *
     C     @RTCD         IFEQ      '*RECLCK'
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'ERL0950'     #MsgID
     C                   MOVEL     #MsgID        MsgIdArr(1)
     C                   MOVE      ' '           WWERR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      * MOVE FIELDS INTO SCREEN FIELDS
      *****************************************************************
      *                                                               *
      *  SR/#EMOVI                                                    *
      *                                                               *
      *  Called by: INIT                                              *
      *                                                               *
      *  Calls: -                                                     *
      *                                                               *
      *****************************************************************
      *
      ** Move Fields into screen fields in Amend and Enquiry modes
      *
     C     #EMOVI        BEGSR
      *
      *
     C                   MOVE      'Y'           WFIND
      *
     C     ACTN          IFEQ      'A'
     C     ACTN          OREQ      'E'
      *
     C                   MOVE      LNETI         L#NETT
     C                   MOVE      LDPTP         L#DPTY
     C                   MOVE      LSNOD         L#SNOD
     C                   MOVE      LLNTP         L#LNTY
 
     C                   Z-ADD     LMDAT         ZDAYNO
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
 
     C                   MOVE      ZDATE         L#LNMD
     C                   MOVE      LLLIM         L#LNLT
      *
     C                   MOVEL     CrAcFilFmt    NwAcFilFmt
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * MOVE FIELDS OUT OF SCREEN FIELDS
      *****************************************************************
      *                                                               *
      *  SR/#EMOVO                                                    *
      *                                                               *
      *  Called by: UPDAT                                             *
      *                                                               *
      *  Calls: -                                                     *
      *                                                               *
      *****************************************************************
      *
     C     #EMOVO        BEGSR
      *
     C     ACTN          IFEQ      'A'
     C     ACTN          OREQ      'I'
      *
     C                   MOVEL     LVBRCD        LBRCD
     C                   MOVEL     LVCNUM        LCNUM
     C                   MOVEL     LVCCY         LCCY
     C                   MOVEL     LVACOD        LACOD
     C                   MOVEL     LVACSQ        LACSQ
     C*                  MOVE      L#NETT        LNETI
     C*                  MOVE      L#DPTY        LDPTP
     C*                  MOVE      L#SNOD        LSNOD
     C*                  MOVE      L#LNTY        LLNTP
     C*                  MOVE      L#LNMD        LMDAT
     C*                  MOVE      L#LNLT        LLLIM
      *
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALIDATE THE SCREEN
      *****************************************************************
      *                                                               *
      *  SR/#EVAL Validation Routine                                  *
      *                                                               *
      *  Called by: MAIN LOOP                                         *
      *                                                               *
      *  Calls: END                                                   *
      *         ZASNMS                                                *
      *         UPDAT                                                 *
      *                                                               *
      *****************************************************************
      *
     C     #EVAL         BEGSR
     C                   MOVE      *BLANKS       VALID             1
      *
      *----------------------------------------------------------------
      ** IF THE ACTION CODE IS ENQUIRE THEN SIMPLY EXIT FROM PROGRAM
      *
     C*****ACTN          IFEQ      'E'                                              201981
     C     *IN20         IFEQ      *ON                                              201981
     C                   EXSR      END
     C                   ENDIF
      *
      ** Clear error indicators
     C                   MOVEA     '000000'      *IN(50)
     C                   MOVE      '0'           *IN99
      *
      * Move screen fields into data structure fields to be passed to
      * validation module.
     C                   Eval      NETI = L#NETT
     C                   Eval      DPTP = L#DPTY
     C                   Eval      SNOD = L#SNOD
     C                   Eval      LNTP = L#LNTY
     C                   Eval      MDAT = L#LNMD
     C                   Eval      LLIM = L#LNLT
      *
      ** Validation for each fields.
      *
     C                   CALLB     'BYAMADW0VL'
     C                   PARM                    ACTN
     C                   PARM                    DATA
     C                   PARM                    NwAcScnFmt
     C                   PARM                    OkFlags
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    NwAcFilFmt
      *
      ** No errors so update the extension file
      *
     C     Idx           IFEQ      0
     C                   MOVE      'N'           WWERR
     C                   EXSR      UPDAT
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * Send message to program's message queue.
      *****************************************************************
      *
     C     ZASNMS        BEGSR
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message Id.
     C                   PARM                    ZAMSGF           10            Message file.
     C                   PARM                    ZAMSDA          132            Message data.
     C                   PARM                    ZAMSTP            7            Message type.
      *
     C     ZAEXIT        ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C     @RUN          IFEQ      *BLANKS
     C                   MOVE      'Y'           @RUN              1
     C                   SETON                                        U7U8LR
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  END   - End Program, no errors                               *
      *                                                               *
      *****************************************************************
      *
     C     END           BEGSR                                                              **
      *
      * If LACTN is not blank means we changed the Action Code earlier              201981
      * so move original Code back.                                                 201981
     C     LACTN         IFNE      *BLANKS                                          201981
     C                   MOVE      LACTN         ACTN                               201981
     C                   ENDIF                                                      201981
     C                   SETON                                            LR
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
      /EJECT
      *****************************************************************
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2001
