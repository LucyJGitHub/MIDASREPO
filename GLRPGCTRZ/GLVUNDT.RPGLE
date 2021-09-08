     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL AMAD Validate Scaduto Dal')                   *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVUNDT - Validate Scaduto Dal                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. LUC139             Date 21Dec20               *
      *  Prev Amend No. BUG18898A          Date 12Feb09               *
      *                 CER009  *CREATE    Date 16Aug06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC139 - UCI Italian features upgrade to FM2.1               *
      *  BUG18898A - Changes in APDUMP and APHEADPD (Recompile)       *
      *  CER009 - Puma II Upgrade to MidasPlus                        *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

      ** Standard D-specs
      ** ================

      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

      /COPY ZACPYSRC,STD_D_SPEC

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

      /COPY ZACPYSRC,PSDS

      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.

      /COPY ZACPYSRC,ERR_XARRYS

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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External data structures for Bank Details

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS for access programs - short data structure

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D Idx             S              3P 0
      ** Index for arrays of error message ids, etc

     D DateIn          S              6A
     D DaynoOut        S              5P 0
     D ErrorFlag       S              1A
     D ZARetcode       S              1A
      ** Ok flag

     D ZAField         S             16A
      ** Field value

     D ZADec           S              1P 0
      ** Decimal places

     D ZADig           S              2P 0
      ** Number of digits

     D p_AType         S              1A
      ** Account Type

     D DDTUNDT         S              6A
      ** Scaduto Dal

     D ITUNDT          S              5P 0
      ** Format

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation                   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

      ** Initialise work variable

     C                   Z-ADD     0             Idx

      ** Initialize return code

     C                   EXSR      Sr_Initialize
     C                   Z-ADD     0             ITUNDT

      ** Validate Scaduto Dal

     C                   IF        (DDTUNDT <> *Blanks And p_AType <>'R') And
     C                             (DDTUNDT <> '000000' And p_AType <> 'R')
     C                   EVAL      RetCodeIn = 'Error'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDTUNDT   '
     C                   EVAL      MsgIdXAr(Idx) = 'ITG7118'

     C                   ELSE
     C                   IF        DDTUNDT <> *Blanks And DDTUNDT <> '000000'

     C                   MOVE      *Blanks       ZARetcode
     C                   MOVE      *Blanks       ErrorFlag
     C                   MOVEL (P) DDTUNDT       ZAField
     C                   Z-ADD     0             ZADec
     C                   Z-ADD     6             ZADig
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZARetcode
     C                   PARM                    ZAField
     C                   PARM                    ZADec
     C                   PARM                    ZADig

     C                   IF        ZARetcode= 'Y'
     C                   MOVE      ZAField       DateIn
     C                   Z-ADD     0             DaynoOut
     C                   CALLB     'ZDATE1'
     C                   PARM                    DateIn
     C                   PARM                    DaynoOut
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
     C                   ENDIF

      ** If either ZALIGN and ZDATE1 errors

     C                   IF        ZARetcode = 'N' OR ErrorFlag = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDTUNDT   '
     C                   EVAL      MsgIdXAr(Idx) = 'ITG7102'
     C                   Else
     C                   Eval      ITUNDT = DaynoOut
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Sr_Initialize - Initialize return code parameter             *
      *                                                               *
      *****************************************************************

     C     Sr_Initialize BEGSR

     C                   EVAL      RetCodeIn = *Blanks

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST

      ** Return code

     C                   PARM                    RetCodeIn

      ** Account Type

     C                   PARM                    p_AType

      ** Format

     C                   PARM                    DDTUNDT

      ** Scaduto Dal

     C                   PARM                    ITUNDT

      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** Warning fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr

      ** Access Bank details

     C                   CALLB     'AOBANKR0'
     C                   PARM      '*BLANKS'     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY

     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values

      /COPY ZACPYSRC,DBFIELDS

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************

      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module

      /COPY ZACPYSRC,PSSR_ILE

      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2006
