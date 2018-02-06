     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas CG Schema & elmnt names reference conversion')
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG3622 - Schema and Element names maintenance                *
      *           Reference Conversion                                *
      *                                                               *
      *  Function:  This program allows conversion for a reference    *
      *             to be defined.                                    *
      *                                                               *
      *  Called By: CG3621 - Data Extract Name Reference Conversion   *
      *                      List                                     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CCG015  *CREATE    Date 09Aug01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CCG015 - Correspondence Manager Phase 1.                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Chain to CGRDECL0                               *
      *    02         Error in Schema Name Field                      *
      *    03         Schema Name Field Protected                     *
      *    04         Enable F5 function key                          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRINIT - Program Initialisation                              *
      *  SRVALD - Validating Schema Name Field                        *
      *  SRUPDT - Update CGRDECPD                                     *
      *  *PSSR  - Error processing                                    *
      *  *INZSR - Initialise                                          *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
 
     FCGRDECL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
     FCG3622DF  CF   E             WORKSTN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Data Area giving Installation Control Details
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      **------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
 
      **------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D MsgidAr         S              7    DIM(25)
     D Msgid           S              7    DIM(25)
 
      ** First Data Structure for Access Objects
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Data Structure to hold file details
     D RecDets       E DS                  EXTNAME(CGRDECPD)
     D WRecDets        DS           165
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D C               S              2  0
     D X               S              2  0
     D Idx             S              2  0
     D PMsgFile        S             10
     D PMsgFLib        S             10
     D PMsgDt          S            256
     D PMsgr           S              5
     D PPrgm           S             10
     D PMsgQ           S             10
     D PMsgType        S              7
     D PGrpSetDef      S              6
     D PGrpSetDesc     S             30
     D PSelOption      S              1
     D PReference      S             23
     D PReferDesc      S             30
     D PSchemaNam      S             30
     D PFuncKey        S              2
     D PRTCD           S              7
     D POPTN           S              7
     D @RUN            S              1
     D WErrVar         S              1
     D WRecErr         S              1
     D WNewVar         S              1
     D WRefer          S              4
     D WREFR           S            111
     D WSchema         S             30
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *****************************************************************
      * Main Processing                                               *
      *****************************************************************
      *
      ** Perform Initialisation
      *
     C                   EXSR      SRINIT
 
     C     KREFR         CHAIN     CGRDECL0                           01
     C                   IF        *IN01 = *OFF
     C                   EVAL      #0SHNM = CGNWFD
     C                   EVAL      WSchema = CGNWFD
     C                   EVAL      WNewVar = 'N'
     C                   EVAL      WRecDets = RecDets
 
     C                   UNLOCK    CGRDECL0                             90
     C                   IF        *IN90 = '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     02            DBASE
     C                   MOVEL     'CGRDECPD'    DBFILE
     C                   MOVEL     '*UNLOCK'     DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      WSchema = *BLANKS
     C                   ENDIF
      *
     C                   DOW       (WErrVar = 'Y' OR WRecErr = 'Y')
     C                             AND *INKC = *OFF
     C                             AND *INKL = *OFF
      *
      ** Write record format to display screen fields.
      *
     C                   WRITE     CG3622F0
     C                   WRITE     CG3622C0
      *
      ** Read record format
      *
     C                   READ      CG3622F0
      *
      ** Clear message subfile and error indicators
      *
     C                   IF        WRecErr = 'N'
     C                   CALL      'ZA0250'
     C                   ENDIF
 
     C                   EVAL      *IN02 = *OFF
 
     C                   Reset                   MsgIdAr
     C                   Reset                   MsgIdArr
 
     C                   EVAL      WErrVar = 'N'
 
     C                   SELECT
     C                   WHEN      *INKC = *ON
     C                   EVAL      PFuncKey = '03'
      *
     C                   WHEN      *INKE = *ON
     C                   EVAL      #0SHNM = WSchema
     C                   EVAL      WErrVar = 'Y'
      *
     C                   WHEN      *INKL = *ON
     C                   EVAL      PFuncKey = '12'
     C                   EVAL      PSchemaNam = WSchema
      *
     C                   WHEN      PSelOption <> 'E'
     C                   EXSR      SRVALD
 
     C                   ENDSL
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVALD - Validating Schema Name Field                         *
      *                                                               *
      * Called by: Main Subroutine                                    *
      *                                                               *
      * Calls: CG3610, CG3611, AOCREPT                                *
      *                                                               *
      *****************************************************************
     C     SRVALD        BEGSR
 
     C                   EVAL      Idx = 0
     C                   EVAL      X = 1
     C                   EVAL      C = 1
     C                   EVAL      *IN02 = *OFF
 
     C                   IF        #0SHNM <> *BLANKS
 
     C                   CALLB     'CG3610'
     C                   PARM                    #0SHNM
     C                   PARM                    MsgIdAr
     C                   PARM      *BLANKS       RetCodeOut
 
     C                   DOW       MsgIdAr(X) <> *Blanks
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = MsgIdAr(X)
     C                   EVAL      X = X + 1
     C                   ENDDO
 
     C                   IF        Idx = 0
     C                             AND CGNWFD <> #0SHNM
 
     C                   RESET                   MsgIdAr
     C                   EVAL      X = 1
 
     C                   CALLB     'CG3611'
     C                   PARM                    CGARGT
     C                   PARM                    CGTYPE
     C                   PARM                    #0SHNM
     C                   PARM                    MsgIdAr
     C                   PARM                    RetCodeOut
 
     C                   DOW       MsgIdAr(X) <> *Blanks
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = MsgIdAr(X)
     C                   EVAL      X = X + 1
     C                   ENDDO
 
     C                   ENDIF
 
     C                   IF        Idx <> 0
 
     C                   EVAL      WErrVar = 'Y'
     C                   EVAL      *IN02 = *ON
     C                   EVAL      PMsgFile = 'CGUSRMSG'
 
     C                   DOW       C <= 25 and
     C                             MsgIdArr(C) <> *Blanks
     C                   MOVEL     *Blanks       MsgId
     C                   MOVEL     MsgIdArr(C)   MsgId
     C                   EXSR      SRSNDMSG
     C                   ADD       1             C
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        WErrVar <> 'Y'
     C                   EXSR      SRUPDT
     C                   IF        WRecErr <> 'Y'
     C                   COMMIT
     C                   ELSE
     C                   ROLBK
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUPDT - Update CGRDECPD                                      *
      *                                                               *
      * Called by: SRVALD                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRUPDT        BEGSR
 
     C                   IF        WNewVar = 'Y'
     C                   IF        #0SHNM <> *Blanks
     C                   EVAL      CGARGT = #0REFR
     C                   EVAL      CGTYPE = 'REFR'
     C                   EVAL      CGNWFD = #0SHNM
     C                   WRITE     CGRDECD0                             90
 
     C                   IF        *IN90 = '1'
     C                   EVAL      MsgId = 'Y2U0004'
     C                   EXSR      SRRecErr
 
     C                   ELSE
     C                   EVAL      PSchemaNam = #0SHNM
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
 
     C     KREFR         CHAIN     CGRDECL0                           90
 
     C                   IF        *IN90 = '1'
     C                   EVAL      MsgId = 'Y2U0007'
     C                   EXSR      SRRecErr
     C                   ELSE
 
     C                   IF        RecDets <> WRecDets
 
     C                   UNLOCK    CGRDECL0                             90
     C                   IF        *IN90 = '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     03            DBASE
     C                   MOVEL     'CGRDECPD'    DBFILE
     C                   MOVEL     '*UNLOCK'     DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      MsgId = 'Y2U0007'
     C                   EXSR      SRRecErr
     C                   ELSE
 
     C                   SELECT
 
     C                   WHEN      #0SHNM = *Blanks
     C                             And CGNWFD <> *Blanks
     C                   EVAL      PSchemaNam = *Blanks
 
     C                   DELETE    CGRDECL0                             90
     C                   IF        *IN90 = '1'
     C                   EVAL      MsgId = 'Y2U0004'
     C                   EXSR      SRRecErr
     C                   ENDIF
 
     C                   WHEN      #0SHNM <> *Blanks
     C                   EVAL      PSchemaNam = #0SHNM
     C                   EVAL      CGNWFD = #0SHNM
     C                   UPDATE    CGRDECD0
 
     C                   ENDSL
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRecErr - Process errors in record-accessing                 *
      *                                                               *
      * Called by: SRVALD                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRRecErr      BEGSR
 
     C                   EVAL      *IN03 = '1'
     C                   EVAL      *IN04 = '0'
     C                   EVAL      PSelOption = 'E'
     C                   EVAL      WRecErr = 'Y'
     C                   EVAL      PMsgFile = 'Y2USRMSG'
     C                   EXSR      SRSNDMSG
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSNDMSG - Send error message                                 *
      *                                                               *
      * Called by: SRVALD                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRSNDMSG      BEGSR
 
     C                   CALL      'AOCREPT'
     C                   PARM                    MsgID
     C                   PARM                    PMsgFile
     C                   PARM      *BLANKS       PMsgFLib
     C                   PARM      *BLANKS       PMsgDt
     C                   PARM      *BLANKS       PMsgr
     C                   PARM      *BLANKS       PPrgm
     C                   PARM      *BLANKS       PMsgQ
     C                   PARM      *BLANKS       PMsgType
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINIT - Subroutine to do Program Initialisation              *
      *                                                               *
      * Called by: Main Subroutine                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRINIT        BEGSR
      *
      ** Initialise all screen fields, indicators and function keys.
      *
     C                   EVAL      #0USER = PsUser
     C                   EVAL      #0WSID = PsJobName
     C                   EVAL      #0RUNA = BJMRDT
     C                   EVAL      #0PGM  = '*'
      *
     C                   EVAL      #0GSET = *BLANKS
     C                   EVAL      #0GSTD = *BLANKS
     C                   EVAL      #0REFR = *BLANKS
     C                   EVAL      #0REFD = *BLANKS
     C                   EVAL      #0SHNM = *BLANKS
      *
     C                   EVAL      *IN02 = *OFF
     C                   EVAL      *IN03 = *OFF
      *
     C                   EVAL      PFuncKey = *BLANKS
      *
      ** Clear message subfile
      *
     C                   CALL      'ZA0250'
      *
      ** Protect Element Name Field
      *
     C                   IF        PSelOption = 'E'
     C                   EVAL      *IN03 = *ON
     C                   ELSE
     C                   EVAL      *IN04 = *ON
     C                   ENDIF
      *
      **  Initialise Variables
      *
     C                   EVAL      WErrVar = 'Y'
     C                   EVAL      WNewVar = 'Y'
     C                   EVAL      WRecErr = 'N'
      *
     C                   EVAL      #0GSET = PGrpSetDef
     C                   EVAL      #0GSTD = PGrpSetDesc
     C                   EVAL      #0REFR = PReference
     C                   EVAL      #0REFD = PReferDesc
 
     C                   EVAL      WRefer = 'REFR'
     C                   EVAL      WREFR = PReference
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: AOBANKR0                                               *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeOut
     C                   PARM                    PGrpSetDef
     C                   PARM                    PGrpSetDesc
     C                   PARM                    PSelOption
     C                   PARM                    PReference
     C                   PARM                    PReferDesc
     C                   PARM                    PSchemaNam
     C                   PARM                    PFuncKey
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C     KREFR         KLIST
     C                   KFLD                    WRefer
     C                   KFLD                    WREFR
      *
      ** Access bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error
      *
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     01            DBASE
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '*FIRST'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2002
