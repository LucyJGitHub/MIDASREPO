     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas BoE extra customer screen input')                *
      *****************************************************************
      *                                                               *
      *  Midas - Bank of England                                      *
      *                                                               *
      *  BYCUSDW0SN - Customer Details Window Scren Input Module      *
      *                                                               *
      *  Function:  This module  allows the maintenance of fields     *
      *             required for the BoE Customer details window      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Prev Amend No. BUG8497            Date 14Sep05               *
      *                 LLN020             Date 14May02               *
      *                 201981             Date 17Jan02               *
      *                 197523             Date 15Jan02               *
      *                 LLN018  *CREATE    Date 17Apr01               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG8497 - SDVCUSDX0 renamed to SDVCUSDPE.                    *
      *          - SDECUSDX0 renamed to SDECUSDPE.                    *
      *  LLN020 - Upgrade BoE to Midas Release 4                      *
      *           Prevent input into BoE Industry and Institution     *
      *           codes if values are to be defaulted to values       *
      *           from main screen.                                   *
      *           Rename fields to avoid conflict with CARS.          *
      *  201981 - Ensure database errors do not occur if no record and*
      *           'E' mode or a record and 'I' mode.                  *
      *  197523 - Appply fix 197523 to the API version. Default       *
      *           Institution and Industry codes in Amend mode as well*
      *           as in Insert.                                       *
      *  LLN018 - Upgrade BoE to APIs and addition of 2 new fields    *
      *           on ICD.
      *                                                               *
      *****************************************************************
      /TITLE    S U B R O U T I N E   I N D E X .                     *
      *                                                               *
      *     Subroutine Index                                          *
      *     ================                                          *
      *                                                               *
      *     1. INIT    -   Initial Processing                         *
      *     2. CLEAR   -   Clear fields/indicators                    *
      *     3. EXIT    -   Leave Program via END (F3)                 *
      *     4. RESET   -   Refresh window display (F5)                *
      *     5. PREV    -   Leave program via END (F12)                *
      *     6. UPDAT   -   Update Processing                          *
      *     7. #EVAL   -   Validation Processing                      *
      *     8. END     -   Leave program                              *
      *     9. ZASNMS  -   Sends Message to Message Subfile           *
      *    10. #EMOVI  -   Move Fields into screen fields             *
      *    11. #EMOVO  -   Move screen fields back                    *
      *    12. *PSSR   -   Database Error Handling                    *
      *                                                               *
      *    STANDARD SUBROUTINES                                       *
      *    ====================                                       *
      *                                                               *
      *    ZALIGN  -  Decimal Place Standardistion Routine            *
      *                                                               *
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *       03      F3 PRESSED EXIT PROGRAM                         *
      *       05      F5 PRESSED REDISPLAY THE SCREEN                 *
      *       12      F12 PRESSED GOTO PREVIOUS SCREEN                *
      *       20      FIELDS TO BE PRETECTED DURING ENQUIRY           *
      *       28      REDISPLAY THE SCREEN                            *
      *---------------------------------------------------------------*
      *       86      CHAIN TO BYCUSTY0 FAILED                        *
      *---------------------------------------------------------------*
      *****************************************************************
      ** Input Files
      *
     FBYCUSTY0  IF   E           K DISK
     F                                     INFSR(*PSSR)
     F                                     COMMIT
      ** Extension file (retrieval)
      *
     FBYCUST#0  CF   E             WORKSTN
      ** Display File for Window
      *
 
      *****************************************************************
      /EJECT
      *
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
     D @EI             S              1    DIM(7)
 
      ** Return code from following window - 'R' if F12 key pressed.
     D SPARE2          DS           256
     D  WUCF12               246    246
 
      *
     D A@CPY           DS
     D* Copyright array
      *
      ** Local data area for database error details
      *
      *** Datastructure to define input parameter DATA
      /COPY QWINDSRC,SDCUSDDTA
      *
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ***  SWITCHABLE FEATURES FILE
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ***  Customer Details file
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ***  Currency Details file
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for Access programs, Short data structure.
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ***  Second DS for Access programs, Long data structure.
      *
 
      ** Current Customer in File Format
     D CrCuFilFmt    E DS                  EXTNAME(BYCUSTY0)
 
      ** Current Customer in Screen Format
     D CrCuScnFmt    E DS                  EXTNAME(SDCUEXPD)
     D                                     PREFIX(SS)
 
      ** New Customer in File Format
     D*NwCuFilFmt****E DS                  EXTNAME(SDVCUSDX0)                                BUG8497
     D NwCuFilFmt    E DS                  EXTNAME(SDVCUSDPE)                                BUG8497
 
      ** New Customer in Screen Format
     D NwCuScnFmt    E DS                  EXTNAME(SDCUEXPD)
 
      ** Error indicators (OK#S)
     D*OkFlags*******E DS                  EXTNAME(SDECUSDX0)                                BUG8497
     D OkFlags       E DS                  EXTNAME(SDECUSDPE)                                BUG8497
      *
      * DS to define layout of data area BYSTAT                                     LLN018
     D BYSTAT        E DS                  EXTNAME(BYSTATPP) DTAARA(BYSTAT)
      *
      **   Declared variables
      **   ==================
      **
 
     D ACTN            S              1
     D W0RTN           S              7
     D WLEN            S              3S 0
     D WWID            S              3S 0
     D WFIRST          S              1
     D WWERR           S              1
     D WFIND           S              1
     D TITLE           S              7
 
 
      ** Define *entry parameters
 
      ** Standards Input Parameters
     D SROW            S              3  0                                      Window position
     D SCOL            S              3  0
     D @EINKE          S              1
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
      ** Continue to redisplay the screen if errors or if redisplay screen
      * flag is 'Y'.
      *
     C     WWERR         DOUEQ     'N'
     C     RedScreen     ANDNE     'Y'
      *
      ** Move 'OK' Flags into array (for checking)
      *
     C                   MOVEA     OkFlags       @EI
      *
      ** Set screen error indicators according to status of 'OK' flags
      *
     C                   Z-ADD     1             C                 2 0
     C                   Z-ADD     50            E                 2 0
 
     C     C             DOUGT     7
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
      *
      ** Write message subfile and window details screen
      *
     C                   IF        Idx > 0
     C                   WRITE     #MSGCTL
     C                   ENDIF
 
      * Program is using IN56 for Counterparty but display file uses IN60.
     C                   MOVE      *IN56         *IN60
 
      * If Redisplay Screen flag is 'Y' then move values passed back from
      * Validation module to screen fields before re-displaying the window
      * as it means ? processing has been invoked in the validation module.
     C     RedScreen     IFEQ      'Y'
     C                   MOVE      UPAR          L#ULP
     C                   MOVE      LINC          L#LINS
     C                   MOVE      LICD          L#LIND
     C                   ENDIF
 
     C                   EXFMT     WINDOWF
 
      ** Clear message subfile
     C                   EXSR      CLEAR
      *
      *
      ** Set screen error indicators off
      *
     C                   MOVEA     '0000000'     *IN(50)
      *
      ** Set return keys
      *
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKE         @INKE
     C                   MOVE      *INKL         @INKL
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
     C                   MOVE      *BLANKS       WWERR
     C                   Eval      RedScreen = 'N'
      *
      *
      *
     C     *INKC         CASEQ     '1'           EXIT
     C     *INKE         CASEQ     '1'           RESET
     C     *INKL         CASEQ     '1'           PREV
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
     C                   SETOFF                                       505152
     C*
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
      *
      ** Define window position
      *
     C                   MOVE      SROW          SWROW
     C                   MOVE      SCOL          SWCOL
      *
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
 
 
      ** Chain records for fields
      *
     C***  ULCUST        CHAIN     BYCUSTY0                           86            LLN020
     C     BYCUST        CHAIN     BYCUSTY0                           86            LLN020
      *
      ** Record not found therefore if amend/enqiry return to previous
      ** screen...
      * Save Action code if changing it as want to pass the correct                 201981
      * Action code back to WN0010.                                                 201981
     C                   MOVE      *BLANKS       LACTN             1                201981
      *
     C     *IN86         IFEQ      '1'
     C     ACTN          ANDEQ     'A'
     C     *IN86         OREQ      '1'                                              201981
     C     ACTN          ANDEQ     'E'                                              201981
     C                   MOVE      ACTN          LACTN                              201981
     C                   MOVE      'I'           ACTN
     C                   ENDIF
      *
      ***Record*found*in*insert*mode,*then*Database*Error                           201981
      ** Record found in insert mode, then change to Amend mode                     201981
      *
     C     ACTN          IFEQ      'I'
     C     *IN86         ANDEQ     '0'
      *
     C*****              MOVEL     'Y2U0004'     W8RTN                              201981
     C******LOCK         IN        LDA                                              201981
      *****                                                                         201981
     C*****              MOVEL     'BYACCTX0'    DBFILE             ***********     201981
     C*****              MOVEL     ULCNUM        DBKEY              ** DBASE 05     201981
     C*****              Z-ADD     5             DBASE              ***********     201981
     C*****              OUT       LDA                                              201981
     C*****              EXSR      *PSSR                                            201981
     C                   MOVE      ACTN          LACTN                              201981
     C                   MOVE      'A'           ACTN                               201981
     C                   ENDIF
      *
      ** Moving fields into screen fields
      *
     C                   EXSR      #EMOVI
      *
 
     C                   ENDSR
      *
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
     C                   CALLB     'BYCUSDW0UP'
     C                   PARM                    ACTN
     C                   PARM                    DATA
     C                   PARM      *BLANK        @RTCD
     C                   PARM                    WFIND
     C                   PARM                    NwCuFilFmt
     C                   PARM                    CrCuFilFmt
      *
      ** If there were any errors in the update functions, rollback any
      ** updates and end this pgm, otherwise commit the updates
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
     C     ACTN          IFEQ      'I'
     C                   MOVE      'N'           L#HAI
     C                   MOVE      'N'           L#CNTP
     C                   ENDIF
      *
     C     ACTN          IFEQ      'A'
     C     ACTN          OREQ      'E'
      *
     C                   MOVE      LSIOF         L#SIO
     C                   MOVE      LHASI         L#HAI
     C                   MOVE      LUPAR         L#ULP
     C                   MOVE      LELGF         L#EGID
     C                   MOVE      LLINC         L#LINS
     C                   MOVE      LLICD         L#LIND
     C                   MOVE      LCNTP         L#CNTP
      *
     C                   ENDIF
      *
      * If Insert check if Institution and Industry should be defaulted.
     C     ACTN          IFEQ      'I'
     C     ACTN          OREQ      'A'                                              197523
     C                   EXSR      DTADEF
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
     C***                MOVE      ULCUST        LVCUST                             LLN020
     C                   MOVE      BYCUST        LVCUST                             LLN020
 
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
      *         ZALIGN                                                *
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
     C                   ENDIF
      *
      ** Clear error indicators
     C                   MOVEA     '0000000'     *IN(50)
      *
      * Move screen fields into data structure fields to be passed to
      * validation module.
     C                   Eval      SIOF = L#SIO
     C                   Eval      HASI = L#HAI
     C                   Eval      UPAR = L#ULP
     C                   Eval      ELGF = L#EGID
     C                   Eval      LINC = L#LINS
     C                   Eval      LICD = L#LIND
     C                   Eval      CNTP = L#CNTP
      *
      *
      ** Validation for each fields.
      *
     C                   CALLB     'BYCUSDW0VL'
     C                   PARM                    ACTN
     C                   PARM                    DATA
     C                   PARM      *BLANKS       CallMod           3
     C                   PARM                    NwCuScnFmt
     C                   PARM                    OkFlags
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    NwCuFilFmt
      *----------------------------------------------------------------
      *
      ** No errors so update the error indicator.
      *
     C     Idx           IFEQ      0
     C                   MOVE      'N'           WWERR
     C                   ENDIF
 
      ** No errors and Redisplay flag not 'Y' so update extension file.
     C     Idx           IFEQ      0
     C     RedScreen     ANDNE     'Y'
     C                   EXSR      UPDAT
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************             LLN018
      * OBTAIN VALUES FROM ICD DTAARA AND DEFAULT FIELDS                            LLN018
      *****************************************************************             LLN018
     C     DTADEF        BEGSR                                                      LLN018
      *                                                                             LLN018
     C     *LOCK         IN        BYSTAT                                           LLN018
      *                                                                             LLN018
      * If Default Local Industry Code Flag is Y on BoE ICD, then                   LLN018
      * move in value on SDCUSTPD.                                                  LLN018
     C                   Move      *off          *In22                              LLN020
     C     LDICD         IFEQ      'Y'                                              LLN018
     C***                MOVE      ULLICD        L#LIND                             LLN018LLN020
     C                   MOVE      BYLICD        L#LIND                             LLN020
     C                   Move      *on           *In22                              LLN020
     C                   ENDIF                                                      LLN018
      *                                                                             LLN018
      * If Default Local Institution Code Flag is Y on BoE ICD, then                LLN018
      * move in value on SDCUSTPD.                                                  LLN018
     C                   Move      *off          *In21                              LLN020
     C     LDINC         IFEQ      'Y'                                              LLN018
     C***                MOVE      ULLINC        L#LINS                             LLN018LLN020
     C                   MOVE      BYLINC        L#LINS                             LLN020
     C                   Move      *on           *In21                              LLN020
     C                   ENDIF                                                      LLN018
     C                   OUT       BYSTAT                                           LLN018
      *                                                                             LLN018
     C                   ENDSR                                                      LLN018
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
(c) Finastra International Limited 2001
