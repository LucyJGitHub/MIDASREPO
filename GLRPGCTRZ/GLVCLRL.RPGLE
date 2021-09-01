     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL AMAD Validate Client Role CR')                *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVCLRL - Validate Client Role CR                            *
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
      *  LUC139 - UCI Italian returns upgrade to FM2.1                *
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
     D IRFXTB        E DS                  EXTNAME(IRFXTBPD)
      ** Midas Italy - Internal Table passed to AOFXTBR0

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS for access programs - short data structure

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D Idx             S              3P 0
      ** Index for arrays of error message ids, etc

     D p_RetCode       S              7A
     D p_Option        S              7A
     D p_KeyFld        S              3A
     D p_Field         S             24A
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

     D DDTCLRL         S              3A
      ** Client Role CR

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

      ** Validate Client Role CR

     C                   IF        (DDTCLRL <> *Blanks And p_AType <> 'R') And
     C                             (DDTCLRL <>  '000' And p_AType <> 'R')
     C                   EVAL      RetCodeIn = 'Error'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDTCLRL   '
     C                   EVAL      MsgIdXAr(Idx) = 'ITG7118'

     C                   Else

     C                   IF        DDTCLRL <> *Blanks And DDTCLRL <> '000'

      ** Check if valid numeric field

     C                   MOVE      *Blanks       ZARetcode
     C                   MOVEL (P) DDTCLRL       ZAField
     C                   Z-ADD     0             ZADec
     C                   Z-ADD     3             ZADig
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZARetcode
     C                   PARM                    ZAField
     C                   PARM                    ZADec
     C                   PARM                    ZADig

      ** Client Role CR is not numeric

     C                   IF        ZARetcode  <> 'Y' And
     C                             %subst(DDTCLRL:1:1) <> '?'
     C                   EVAL      RetCodeIn = 'Error'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDTCLRL   '
     C                   EVAL      MsgIdXAr(Idx) = 'ITG7116'

     C                   Else

     C                   IF        %subst(DDTCLRL:1:1) = '?'
     C                   EVAL      p_Field = '?'
     C                   Else
     C                   EVAL      p_Field = DDTCLRL
     C                   ENDIF
     C                   MOVE      *Blanks       p_RetCode
     C                   MOVE      '*KEY   '     p_Option
     C                   MOVE      'BAU'         p_KeyFld

      ** Validates from the Standing Data Internal Table

     C                   CALL      'AOFXTBR0'
     C                   PARM                    p_RetCode
     C                   PARM                    p_Option
     C                   PARM                    p_KeyFld
     C                   PARM                    p_Field
     C     IRFXTB        PARM      IRFXTB        DSFDY

     C     p_RetCode     IFNE      *BLANKS
     C                   EVAL      RetCodeIn = 'Error'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDTCLRL   '
     C                   EVAL      MsgIdXAr(Idx) = 'ITG7107'
     C                   ELSE
     C                   EVAL      DDTCLRL = p_Field
     C                   ENDIF

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

      ** Client Role CR

     C                   PARM                    DDTCLRL

      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** Warning fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr

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
