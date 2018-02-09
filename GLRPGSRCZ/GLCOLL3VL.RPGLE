     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Collateral 3rd Detail Screen Validation')     *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLCOLL3VL - Collateral Third Detail Screen Validation        *
      *                                                               *
      *  Function: This module will perform validation on the third   *
      *            detail screen and return any error conditions or   *
      *            messages to the screen input module. This screen   *
      *            will only be called for collateral processing      *
      *            types relating to 'Charges'.                       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CGL011  *CREATE    Date 20Sep99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CGL011 - Collateral Processing for Midas (Phase 1)           *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
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
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Collateral File Definition Details
     D NwCoFilFmt    E DS                  EXTNAME(GLCOLLPD)
      *
      ** Collateral Screen Definition Details
     D NwCoScnFmt    E DS                  EXTNAME(GLSCOLPD)
      *
      ** Error indicator for Collateral Details
     D OkCoScnFld    E DS                  EXTNAME(GLECOLPD)
      *
      ** Externally described DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for Collateral Locations
     D SDCOLO        E DS                  EXTNAME(SDCOLOPD)
      *
      ** Externally described DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** Externally described DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** Externally described DS for Counterparty Nostros
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
      *
      ** DS for Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for Access Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** DS for Access Programs
     D DSLDY         E DS                  EXTNAME(DSLDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message IDs
     D Ix              S              3P 0
      *
      ** Index for arrays of warning messages
     D WIx             S              3P 0
      *
      ** Parameters for ZALIGN
     D ZAlignOk        S              1A
     D ZFIELD          S             16A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
      *
      ** Parameters for ZDATE1
     D DateIn          S              6A
     D DaynoOut        S              5P 0
     D ErrorFlag       S              1A
      *
     D WWIVAL          S                   LIKE(CDIVAL)
     D WWINDT          S                   LIKE(CDINDT)
     D WWVPCH          S                   LIKE(CDVPCH)
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Perform detail validation process
     C                   EXSR      SRDETVAL
      *
      ** If no errors, set up outstanding fields for valid file.
     C     IX            IFEQ      0
     C                   EXSR      SRSETUPVLD
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDETVAL - Detail Validation processing                      *
      *                                                               *
      *****************************************************************
     C     SRDETVAL      BEGSR
      *
      ** Perform Insurer Validation
     C                   EXSR      SRINSURE
      *
      ** Set Insurance Policy Reference ok
     C                   MOVE      'Y'           DDIPLYOK
      *
      ** Perform Insurance Policy Location Validation
     C                   EXSR      SRPOLO
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR '     PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DDCCY         PCCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      ** Perform Insurance Valuation Validation
     C                   EXSR      SRINSVAL
      *
      ** Perform Insurance Policy Restrictions Indicator alidation
     C                   EXSR      SRREST
      *
      ** Perform Insurance Date Validation
     C                   EXSR      SRINSDAT
      *
      ** Perform Insurance Frequency Validation
     C                   EXSR      SRINSFRQ
      *
      ** Perform Insurance Date Day Number Validation
     C                   EXSR      SRINSDAY
      *
      ** Perform Registered Indicator Validation
     C                   EXSR      SRREGT
      *
      ** Perform Value of Prior Charges Validation
     C                   EXSR      SRPCHGVAL
      *
      ** Perform Subsequent Chargee Validation
     C                   EXSR      SRSUBCHG
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINSURE - Insurer Validation process                        *
      *                                                               *
      *****************************************************************
     C     SRINSURE      BEGSR
      *
     C     DDINSR        IFNE      *BLANKS
     C                   CALLB     'AOCUSTR1'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DDINSR        PKEY1            10
     C                   PARM      *Blanks       PKYST             7
     C     SDCUST        PARM      SDCUST        DSLDY
      *
     C     PRTCD         IFNE      *BLANKS
     C     BBPAIN        OREQ      'P'
     C                   MOVE      'N'           DDINSROK
     C                   ADD       1             Ix
     C                   MOVEL     'DDINSR'      FldNameArr(Ix)
     C                   MOVEL     'COL0111'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVEL     *BLANKS       DDINSR
     C                   MOVEL     BBCUST        DDINSR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPOLO - Insurance Policy Location Validation process        *
      *                                                               *
      *****************************************************************
     C     SRPOLO        BEGSR
      *
     C     DDIPLO        IFNE      *BLANKS
     C                   CALL      'AOCOLOR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DDIPLO        PCOLO             3
     C     SDCOLO        PARM      SDCOLO        DSFDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDIPLOOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDIPLO'      FldNameArr(Ix)
     C                   MOVEL     'COL0112'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVEL     CLCOLO        DDIPLO
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINSVAL - Insurance Valuation Validation process            *
      *                                                               *
      *****************************************************************
     C     SRINSVAL      BEGSR
      *
     C                   Z-ADD     0             WWIVAL
      *
     C     DDIVAL        IFNE      *BLANKS
      *
     C                   MOVEL     *Blanks       ZFIELD
     C                   Z-ADD     A6NBDP        ZADEC
     C     15            SUB       ZADEC         ZADIG
      *
     C                   CALLB     'ZALIGN'
     C                   PARM      'Y'           ZAlignOk
     C                   PARM      DDIVAL        ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
      *
     C     ZALIGNOK      IFNE      'Y'
     C                   MOVEL     'N'           DDIVALOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDIVAL'      FldNameArr(Ix)
     C                   MOVEL     'COL0113'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVE      ZFIELD        WWIVAL
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRREST - Restictions Indicator Validation process            *
      *                                                               *
      *****************************************************************
     C     SRREST        BEGSR
      *
     C     DDIRST        IFNE      *BLANK
     C     DDIRST        ANDNE     'Y'
     C     DDIRST        ANDNE     'N'
     C                   MOVE      'N'           DDIRSTOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDIRST'      FldNameArr(Ix)
     C                   MOVEL     'COL0114'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C     DDIRST        IFEQ      *BLANK
     C                   MOVE      'N'           DDIRST
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINSDAT - Insurance Date Validation process                 *
      *                                                               *
      *****************************************************************
     C     SRINSDAT      BEGSR
      *
     C                   Z-ADD     0             WWINDT
      *
     C     DDINDT        IFNE      *BLANKS
      *
     C                   CALLB     'ZDATE1'
     C                   PARM      DDINDT        DateIn
     C                   PARM      *ZERO         DaynoOut
     C                   PARM                    BJDFIN
     C                   PARM      *BLANK        ErrorFlag
      *
     C     ErrorFlag     IFEQ      'Y'
     C                   MOVE      'N'           DDINDTOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDINDT'      FldNameArr(Ix)
     C                   MOVEL     'COL0115'     MsgIdArr(Ix)
     C                   ELSE
     C                   Z-ADD     DAYNOOUT      WWINDT
     C     WWINDT        IFLT      BJRDNB
     C                   MOVE      'N'           DDINDTOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDINDT'      FldNameArr(Ix)
     C                   MOVEL     'COL0116'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINSFRQ - Review Frequency Validation process               *
      *                                                               *
      *****************************************************************
     C     SRINSFRQ      BEGSR
      *
     C     DDINDT        IFNE      *BLANKS
     C     DDINFQ        ANDNE     *BLANK
     C     DDINFQ        ANDNE     'D'
     C     DDINFQ        ANDNE     'W'
     C     DDINFQ        ANDNE     'F'
     C     DDINFQ        ANDNE     'M'
     C     DDINFQ        ANDNE     'T'
     C     DDINFQ        ANDNE     'Q'
     C     DDINFQ        ANDNE     'X'
     C     DDINFQ        ANDNE     'Y'
     C     DDINDT        OREQ      *BLANKS
     C     DDINFQ        ANDNE     *BLANKS
     C                   MOVE      'N'           DDINFQOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDINFQ'      FldNameArr(Ix)
     C                   MOVEL     'COL0117'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINSDAY - Insurance Date Day Number Validation process      *
      *                                                               *
      *****************************************************************
     C     SRINSDAY      BEGSR
      *
     C                   MOVE      DDINDN        WWNUM2            2 0
     C     DDINFQ        IFNE      'M'
     C     DDINFQ        ANDNE     'T'
     C     DDINFQ        ANDNE     'Q'
     C     DDINFQ        ANDNE     'X'
     C     DDINFQ        ANDNE     'Y'
     C     DDINDN        ANDNE     *BLANKS
     C     DDINDN        ORNE      *BLANKS
     C     WWNUM2        ANDLT     01
     C     DDINDN        ORNE      *BLANKS
     C     WWNUM2        ANDGT     31
     C                   MOVE      'N'           DDINDNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDINDN'      FldNameArr(Ix)
     C                   MOVEL     'COL0118'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRREGT - Registered Indicator Validation process             *
      *                                                               *
      *****************************************************************
     C     SRREGT        BEGSR
      *
     C     DDRGTR        IFNE      *BLANK
     C     DDRGTR        ANDNE     'Y'
     C     DDRGTR        ANDNE     'N'
     C                   MOVE      'N'           DDRGTROK
     C                   ADD       1             Ix
     C                   MOVEL     'DDRGTR'      FldNameArr(Ix)
     C                   MOVEL     'COL0119'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C     DDRGTR        IFEQ      *BLANK
     C                   MOVE      'N'           DDRGTR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPCHGVAL - Value of Prior Charges Valuation Validation pr.  *
      *                                                               *
      *****************************************************************
     C     SRPCHGVAL     BEGSR
      *
     C                   Z-ADD     0             WWVPCH
      *
     C     DDVPCH        IFNE      *BLANKS
      *
     C                   MOVEL     *Blanks       ZFIELD
     C                   Z-ADD     A6NBDP        ZADEC
     C     15            SUB       ZADEC         ZADIG
      *
     C                   CALLB     'ZALIGN'
     C                   PARM      'Y'           ZAlignOk
     C                   PARM      DDVPCH        ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
      *
     C     ZALIGNOK      IFNE      'Y'
     C                   MOVEL     'N'           DDVPCHOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDVPCH'      FldNameArr(Ix)
     C                   MOVEL     'COL0120'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVE      ZFIELD        WWVPCH
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSUBCHG - Subsequent Chargee Validation process             *
      *                                                               *
      *****************************************************************
     C     SRSUBCHG      BEGSR
      *
     C     DDSCHC        IFNE      *BLANKS
      *
     C                   IF        %SUBST(DDSCHC:7:4) = *BLANKS
     C                   MOVE      'C'           @SUBCUST          1
     C                   ELSE
     C                   IF        %SUBST(DDSCHC:9:2) = *BLANKS
     C                   MOVE      'N'           @SUBCUST
     C                   ELSE
     C                   MOVE      'C'           @SUBCUST
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        %SUBST(DDSCHC:1:1) = '?'
     C                   SELECT
     C                   WHEN      %SUBST(DDSCHC:2:1) = 'N'
     C                   MOVE      'N'           @SUBCUST
     C                   WHEN      %SUBST(DDSCHC:2:1) = 'C'
     C                   MOVE      'C'           @SUBCUST
     C                   ENDSL
     C                   EVAL      %SUBST(DDSCHC:2:1) = ' '
     C                   ENDIF
      *
     C     @SUBCUST      IFEQ      'C'
      *
     C                   CALLB     'AOCUSTR1'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DDSCHC        PKEY1
     C                   PARM      *Blanks       PKYST
     C     SDCUST        PARM      SDCUST        DSLDY
      *
     C     PRTCD         IFNE      *BLANKS
     C     BBPAIN        OREQ      'P'
     C                   MOVE      'N'           DDSCHCOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDSCHC'      FldNameArr(Ix)
     C                   MOVEL     'COL0121'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVEL     *BLANKS       DDSCHC
     C                   MOVEL     BBCUST        DDSCHC
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     @SUBCUST      IFEQ      'N'
      *
     C                   CALLB     'AOCNSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DDSCHC        PCNCD             8
     C     SDCNST        PARM      SDCNST        DSFDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDSCHCOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDSCHC'      FldNameArr(Ix)
     C                   MOVEL     'COL0122'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVEL     *BLANKS       DDSCHC
     C                   MOVEL     AWCPNC        DDSCHC
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZALIGN - Validate/Right allign numeric field               *
      *                                                               *
      *****************************************************************
     C     SRZALIGN      BEGSR
      *
     C                   CALLB     'ZALIGN'
     C                   PARM      'Y'           ZAlignOk
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZDATE1 - Validate and convert date to day number           *
      *                                                               *
      *****************************************************************
     C     SRZDATE1      BEGSR
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    DateIn
     C                   PARM      *ZERO         DaynoOut
     C                   PARM                    BJDFIN
     C                   PARM      *BLANK        ErrorFlag
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSETUPVLD - Set up validated fields for the valid file.     *
      *                                                               *
      *****************************************************************
     C     SRSETUPVLD    BEGSR
      *
     C                   MOVEL     DDINSR        CDINSR
     C                   MOVEL     DDIPLY        CDIPLY
     C                   MOVEL     DDIPLO        CDIPLO
     C     DDIVAL        IFNE      *BLANKS
     C                   Z-ADD     WWIVAL        CDIVAL
     C                   ENDIF
     C                   MOVEL     DDIRST        CDIRST
     C     DDINDT        IFNE      *BLANKS
     C                   Z-ADD     WWINDT        CDINDT
     C                   ENDIF
     C                   MOVEL     DDINFQ        CDINFQ
     C     DDINDN        IFNE      *BLANKS
     C                   MOVEL     DDINDN        CDINDN
     C                   ENDIF
     C                   MOVEL     DDRGTR        CDRGTR
     C                   Z-ADD     WWVPCH        CDVPCH
      *
     C     DDSCHC        IFNE      *BLANKS
     C     @SUBCUST      IFEQ      'C'
     C                   MOVEL     DDSCHC        CDSCHC
     C                   MOVEL     *BLANKS       CDSCNS
     C                   ELSE
     C                   MOVEL     DDSCHC        CDSCNS
     C**********         Z-ADD     0             CDSCHC                                       CSD027
     C                   MOVE      *BLANKS       CDSCHC                                       CSD027
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** Transaction Screen Format
     C                   PARM                    NwCoScnFmt
      *
      ** Transaction Status
     C                   PARM                    TransStat         7
      *
      ** Mode of Operation
     C                   PARM                    RespMode          1
      *
      ** New Collateral Record
     C                   PARM                    NwCoFilFmt
      *
      ** Fields OK indicators
     C                   PARM                    OKCoScnFld
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    Ix
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIx
      *
      ** Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'GLCOLL3VAL ' DBPGM
     C                   OUT       LDA
      *
      ** Access Bank details.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     001           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2001
