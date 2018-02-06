     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas CG Schema & elmnt names MNT paths conversion')
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG3620 - Schema and Element names maintenance                *
      *           Paths Conversion                                    *
      *                                                               *
      *  Function:  This program allows the conversion for a path to  *
      *             be defined.                                       *
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
      *  CCG015 - Correspondence Manager Phase 1                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    09         Function of indicator                           *
      *    23         Function of indicator                           *
      *    24         General purpose file-access indicator           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRVALD - Validate Element Name Field                         *
      *  SRUPDT - Update CGRDECPD                                     *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FCGRDECL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     FCG3620DF  CF   E             WORKSTN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
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
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
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
 
     D PMsgId          S              7    DIM(25)
 
      ** External DS for bank details
     DSDBANK         E DS                  EXTNAME(SDBANKPD)
 
      ** First Data Structure for Access Objects
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Data Structure to hold file details
     D RecDets       E DS                  EXTNAME(CGRDECPD)
     D WRecDets        DS           165
 
     D PGroupSet       S              6A
     D PGrpStDesc      S             30A
     D PSelOption      S              1A
     D PPath           S             70A
     D PElement        S             30A
     D PFuncKey        S              2A
 
     D PMsgFile        S             10A
     D PMsgFLib        S             10A
     D PMsgDt          S            256A
     D PMsgr           S              5A
     D PPrgm           S             10A
     D PMsgQ           S             10A
     D PMsgType        S              7A
     D PRetCode        S              7A
     D PRTCD           S              7
     D POPTN           S              7
 
     D WSavElem        S             30A
     D WError          S              1A
     D WRecErr         S              1A
     D WNewVar         S              1A
     D WValid          S              1A
     D WErrorMsg       S              7A
     D WRun            S              1A
     D Idx             S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Initialise screen fields, indicators and function key
 
     C                   MOVE      *BLANKS       #0GSET
     C                   MOVE      *BLANKS       #0GSTD
     C                   MOVE      *BLANKS       #0PATH
     C                   MOVE      *BLANKS       #0ELEM
     C                   MOVE      *BLANKS       PFuncKey
 
     C                   MOVE      *OFF          *IN09
     C                   MOVE      *OFF          *IN23
 
      ** Clear message subfile
 
     C                   CALL      'ZA0250'
 
      ** Protect element name field
 
     C     PSelOption    IFEQ      'E'
     C                   MOVE      *ON           *IN09
     C                   ENDIF
 
     C                   MOVE      'Y'           WError
     C                   MOVE      'Y'           WNewVar
     C                   MOVE      PElement      WSavElem
     C                   MOVE      'N'           WRecErr
 
      ** Format fields for output
 
     C                   MOVE      PGroupSet     #0GSET
     C                   MOVE      PGrpStDesc    #0GSTD
     C                   MOVEL     PPath         #0PATH
 
     C                   MOVE      'PATH'        CGTYPE
     C                   MOVEL     *BLANKS       CGARGT
     C                   MOVEL     PPath         CGARGT
 
     C     KRDEC         CHAIN     CGRDECL0                           24
 
     C     *IN24         IFEQ      *OFF
     C                   MOVEL     CGNWFD        #0ELEM
     C                   MOVE      'N'           WNewVar
     C                   EVAL      WRecDets = RecDets
 
     C                   UNLOCK    CGRDECL0                             90
     C                   IF        *IN90 = '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     03            DBASE
     C                   MOVEL     'CGRDECPD'    DBFILE
     C                   MOVEL     '*UNLOCK'     DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ELSE
     C                   MOVE      *BLANKS       PElement
     C                   ENDIF
 
     C                   DOW       (WError = 'Y' OR WRecErr = 'Y') AND
     C                             *INKC = *OFF AND *INKL = *OFF
 
      ** Write record format to display screen
 
     C                   WRITE     CG3620C1
     C                   WRITE     CG3620F0
 
      ** Read record format
 
     C                   READ      CG3620F0
 
      ** Clear message subfile, error variable and error indicator
 
     C                   IF        WRecErr = 'N'
     C                   CALL      'ZA0250'
     C                   ENDIF
 
     C                   MOVE      *OFF          *IN23
     C                   MOVE      'N'           WError
 
     C                   SELECT
 
     C     *INKC         WHENEQ    *ON
     C                   MOVE      '03'          PFuncKey
 
     C     *INKE         WHENEQ    *ON
     C                   MOVE      PElement      #0ELEM
     C                   MOVE      'Y'           WError
 
     C     *INKL         WHENEQ    *ON
     C                   MOVE      '12'          PFuncKey
     C                   MOVE      WSavElem      PElement
 
     C     PSelOption    WHENNE    'E'
     C                   EXSR      SRVALD
 
     C                   ENDSL
 
     C                   ENDDO
 
     C                   MOVE      *ON           *INLR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALD - Validate Element Name Field                         *
      *                                                               *
      *****************************************************************
 
     C     SRVALD        BEGSR
 
     C                   MOVE      *BLANK        WValid
     C                   MOVEA     *BLANKS       PMsgID
 
     C     #0ELEM        IFNE      *BLANKS
 
      ** Validate element name field
 
     C                   CALLB     'CG3610'
     C                   PARM      #0ELEM        PElement
     C                   PARM                    PMsgID
     C                   PARM      *BLANKS       PRetCode
 
      ** Validate uniqueness if valid
 
     C     PRetCode      IFEQ      *BLANKS
     C     CGNWFD        ANDNE     PElement
 
     C                   CALLB     'CG3611'
     C                   PARM                    PPath
     C                   PARM                    CGTYPE
     C                   PARM                    PElement
     C                   PARM                    PMsgID
     C                   PARM      *BLANKS       PRetCode
 
     C     PRetCode      IFEQ      *BLANKS
     C                   MOVE      'Y'           WVaLid
     C                   ENDIF
 
     C                   ENDIF
 
     C     PRetCode      IFNE      *BLANKS
 
     C                   MOVE      *ON           *IN23
     C                   MOVE      'Y'           WError
 
     C                   Z-ADD     1             Idx
     C                   MOVEA     PMsgID(Idx)   WErrorMsg
     C                   EVAL      PMsgFile = 'CGUSRMSG'
 
     C     WErrorMsg     DOWNE     *BLANKS
 
     C                   EXSR      SRSNDMSG
 
     C                   ADD       1             Idx
     C                   MOVEA     PMsgID(Idx)   WErrorMsg
 
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDIF
 
     C     WError        IFNE      'Y'
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
      *  SRUPDT - Update CGRDECPD                                     *
      *                                                               *
      *****************************************************************
 
     C     SRUPDT        BEGSR
 
     C     WNewVar       IFEQ      'Y'
 
     C     #0ELEM        IFNE      *BLANKS
     C     WValid        ANDEQ     'Y'
     C                   MOVEL     *BLANKS       CGNWFD
     C                   MOVEL     #0ELEM        CGNWFD
     C                   WRITE     CGRDECD0                             90
 
     C                   IF        *IN90 = '1'
     C                   EVAL      WErrorMsg = 'Y2U0004'
     C                   EXSR      SRRecErr
 
     C                   ELSE
     C                   MOVE      #0ELEM        PElement
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
 
     C     KRDEC         CHAIN     CGRDECL0                           90
 
     C                   IF        *IN90 = '1'
     C                   EVAL      WErrorMsg = 'Y2U0007'
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
 
     C                   EVAL      WErrorMsg = 'Y2U0007'
     C                   EXSR      SRRecErr
     C                   ELSE
 
     C                   SELECT
 
     C     #0ELEM        WHENEQ    *BLANKS
     C     CGNWFD        ANDNE     *BLANKS
 
     C                   DELETE    CGRDECL0                             90
     C                   IF        *IN90 = '1'
     C                   EVAL      WErrorMsg = 'Y2U0004'
     C                   EXSR      SRRecErr
     C                   ENDIF
     C                   MOVE      #0ELEM        PElement
 
     C     #0ELEM        WHENNE    *BLANKS
     C     WValid        ANDEQ     'Y'
     C                   MOVEL     *BLANKS       CGNWFD
     C                   MOVEL     #0ELEM        CGNWFD
     C                   UPDATE    CGRDECD0
     C                   MOVE      #0ELEM        PElement
 
     C                   ENDSL
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRecErr - Process errors in record-accessing                *
      *                                                               *
      *****************************************************************
 
     C     SRRecErr      BEGSR
 
     C                   EVAL      *IN09 = '1'
     C                   EVAL      WRecErr = 'Y'
     C                   EVAL      PSelOption = 'E'
     C                   EVAL      PMsgFile = 'Y2USRMSG'
     C                   EXSR      SRSNDMSG
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSNDMSG - Send error message via AOCREPT                    *
      *                                                               *
      *****************************************************************
 
     C     SRSNDMSG      BEGSR
 
     C                   CALL      'AOCREPT'
     C                   PARM                    WErrorMsg
     C                   PARM                    PMsgFile
     C                   PARM      *BLANKS       PMsgFLib
     C                   PARM      *BLANKS       PMsgDt
     C                   PARM      *BLANKS       PMsgr
     C                   PARM      *BLANKS       PPrgm
     C                   PARM      *BLANKS       PMsgQ
     C                   PARM      *BLANKS       PMsgType
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeOut
     C                   PARM                    PGroupSet
     C                   PARM                    PGrpStDesc
     C                   PARM                    PSelOption
     C                   PARM                    PPath
     C                   PARM                    PElement
     C                   PARM                    PFuncKey
 
     C     KRDEC         KLIST
     C                   KFLD                    CGTYPE
     C                   KFLD                    CGARGT
 
      ** Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     01            DBASE
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '*FIRST'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVEL     PsUser        #0USER
     C                   MOVEL     PsJobName     #0WSID
     C                   MOVEL     BJMRDT        #0RUNA
     C                   MOVEL     PSProcName    #1PGM
 
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
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   CALLB     'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2002
