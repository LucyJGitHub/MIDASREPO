     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas CG Schema and elmnt names conversion types')
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG3618 - Schema and Element names maintenance                *
      *           Conversion Types                                    *
      *                                                               *
      *  Function:  This program will allow the type of conversion to *
      *             be selected.                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CAAA03             Date 24Mar04               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CCG015  *CREATE    Date 09Aug01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAAA03 - Webfacing Changes (recompile)                       *
      *  CCG015 - Correspondence Manager Phase 1                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Error Indicator for Select Path                 *
      *    02         Error Indicator for Select Reference            *
      *                                                               *
      *    90-99      Used by Standard Subroutines                    *
      *                                                               *
      *    U7+U8      Database Error                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRVALD - Validate Selection Option Field                     *
      *  SRERRO - Send Message to program queue                       *
      *  *INSZR - Initialisation routine                              *
      *  *PSSR  - Program Error Processing Subroutine                 *
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
 
     FCG3618DF  CF   E             WORKSTN
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
 
     D PMsgId          S              7A
 
     D PMsgFile        S             10
 
     D PMsgFLib        S             10
 
     D PMsgDt          S            256
 
     D PMsgr           S              5
 
     D PPrgm           S             10
 
     D PMsgQ           S             10
 
     D PMsgType        S              7
 
     D PGroupSet       S              6A
 
     D PGrpStDesc      S             30A
 
     D PFuncKey        S              2A
 
     D WError          S              1A
 
     D PRtCd           S              7A
 
     D POptn           S              7A
 
      ** External DS for bank details
     DSDBANK         E DS                  EXTNAME(SDBANKPD)
 
      ** First Data Structure for Access Objects
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D WRun            S              1A
 
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
 
     C                   EVAL      #0SPAT = *BLANKS
     C                   EVAL      #0SREF = *BLANKS
     C                   EVAL      #0GSET = PGroupSet
     C                   EVAL      #0GSTD = PGrpStDesc
 
     C                   EVAL      PFuncKey = *BLANKS
     C                   EVAL      *INKC = '0'
     C                   EVAL      *INKL = '0'
     C                   EVAL      *IN01 = '0'
     C                   EVAL      *IN02 = '0'
 
      ** Clear message subfile
 
     C                   CALL      'ZA0250'
 
     ** Do until F3 or F12 is pressed on this screen or Function Key is F3
 
     C     *INKC         DOUEQ     *ON
     C     *INKL         OREQ      *ON
     C     PFuncKey      OREQ      '03'
     C     WError        OREQ      'N'
 
      ** Format fields for output
 
 
      ** Write record format to display screen
 
     C                   WRITE     CG3618C0
     C                   WRITE     CG3618F0
 
      ** Read record format
 
     C                   READ      CG3618F0
     C                   EVAL      *IN01 = '0'
     C                   EVAL      *IN02 = '0'
     C                   EVAL      WError = 'N'
 
      ** Clear message subfile, error  variable and error indicator
 
     C                   CALL      'ZA0250'
 
     C                   SELECT
 
     C     *INKC         WHENEQ    *ON
     C                   EVAL      PFuncKey = '03'
 
     C     *INKE         WHENEQ    *ON
     C                   EVAL      #0SPAT = *BLANKS
     C                   EVAL      #0SREF = *BLANKS
     C                   EVAL      WError = 'Y'
 
     C     *INKL         WHENEQ    *ON
     C                   EVAL      PFuncKey = '12'
 
     C                   OTHER
     C                   EXSR      SRVALD
 
     C                   ENDSL
 
     C                   ENDDO
 
     C                   MOVE      *ON           *INLR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALD - Validate Selction Option Field                      *
      *                                                               *
      *****************************************************************
 
     C     SRVALD        BEGSR
 
      ** Validate if Path is Selected
 
     C     #0SPAT        IFEQ      *BLANKS
     C     #0SREF        ANDEQ     *BLANKS
     C                   EVAL      WError = 'N'
     C                   ENDIF
 
     C     #0SPAT        IFNE      '1'
     C     #0SPAT        ANDNE     *BLANKS
     C                   EVAL      *IN01 = '1'
     C                   EVAL      WError = 'Y'
     C                   EVAL      PMsgID = 'CGD2581'
     C                   EXSR      SRERRO
     C                   ENDIF
 
     C     #0SREF        IFNE      '1'
     C     #0SREF        ANDNE     *BLANKS
     C                   EVAL      *IN02 = '1'
     C                   EVAL      WError = 'Y'
     C                   EVAL      PMsgID = 'CGD2581'
     C                   EXSR      SRERRO
     C                   ENDIF
 
     C     WError        IFNE      'Y'
     C                   EVAL      PFuncKey = *BLANKS
 
     C     #0SPAT        IFNE      *BLANK
     C                   CALLB     'CG3619'
     C                   PARM                    RetCodeOut
     C                   PARM                    PGroupSet
     C                   PARM                    PGrpStDesc
     C                   PARM                    PFuncKey
 
     C                   EVAL      #0SPAT = *BLANKS
     C     PFuncKey      IFEQ      *BLANKS
     C                   EVAL      WError = 'N'
     C                   ELSE
     C                   EVAL      WError = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C     #0SREF        IFNE      *BLANK
     C     PFuncKey      ANDEQ     *BLANKS
 
     C                   CALLB     'CG3621'
     C                   PARM                    RetCodeOut
     C                   PARM                    PGroupSet
     C                   PARM                    PGrpStDesc
     C                   PARM                    PFuncKey
 
     C                   EVAL      #0SREF = *BLANKS
     C     PFuncKey      IFEQ      *BLANKS
     C                   EVAL      WError = 'N'
     C                   ELSE
     C                   EVAL      WError = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRERRO - Send Message to program queue                       *
      *                                                               *
      *****************************************************************
 
     C     SRERRO        BEGSR
 
     C                   CALL      'AOCREPT'
     C                   PARM                    PMsgID
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
     C                   PARM                    RetCodeIn
     C                   PARM                    PGroupSet
     C                   PARM                    PGrpStDesc
     C                   PARM                    PFuncKey
 
      ** Move workstation ID to screen field.
 
     C                   MOVEL     PsUser        #0USER
     C                   MOVEL     PsJobName     #0WSID
     C                   MOVEL     PSProcName    #0PGMQ
     C                   EVAL      PMsgFile = 'CGUSRMSG'
 
      ** The following /COPY sets the program, module and procedure
      ** names for database error processing.
 
     C/COPY ZACPYSRC,DBFIELDS
 
      ** Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C     PRtcd         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     01            DBase
     C                   MOVEL     'SDBANKPD'    DBfile
     C                   MOVEL     '*FIRST'      DBKey
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVEL     BJMRDT        #0RUNA
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
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
