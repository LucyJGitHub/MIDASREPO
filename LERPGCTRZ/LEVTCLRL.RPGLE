     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Validate Client Role')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEVTCLRL - Validate Client Role                              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. LUC139             Date 08Jan21               *
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

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
      /COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving
      ** the size of the arrays.
      /COPY ZACPYSRC,ERR_XARRYS
      **---------------------------------------------------------------

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

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs - short data structure

     D IRFXTB        E DS                  EXTNAME(IRFXTBPD)
      ** DS based on Internal Table

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D Idx             S              3P 0
     D WIdx            S              3P 0
      ** Index for arrays of error message ids etc

     D DDTCLRL         S              3A
     D DDTCLRLOK       S              1A
     D VPFCLRL         S              3S 0

     D PRTCD           S              7A
     D POption         S              7A
     D PCHR003         S              3A
     D PCHR024         S             24A
      ** Entry parameters for AOFXTBR0

     D PZRtnCde        S              1A
     D PZfld16A        S             16A
     D PZDec1P0        S              1P 0
     D PZDig2P0        S              2P 0

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************

      ** Initialization

     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             WIdx

     C                   EVAL      PZFld16A = *BLANKS

      ** Validation

     C                   EXSR      SRMAIN

     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMain - Main Validation routine                             *
      *                                                               *
      *****************************************************************
     C     SRMain        BEGSR

     C                   IF        %SUBST(DDTCLRL:1:1) = '?'

     C                   CALL      'AOFXTBR0'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*KEY'        POption
     C                   PARM      'BAU'         PChr003
     C                   PARM      DDTCLRL       PChr024
     C     IRFXTB        PARM      IRFXTB        DSFDY

     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDTCLRL'
     C                   EVAL      MsgIdXAr(Idx)  = 'ITL3227'
     C                   EVAL      DDTCLRLOK = 'N'
     C                   LEAVESR
     C                   ENDIF

     C                   MOVEL     PChr024       DDTCLRL
     C                   MOVEL     DDTCLRL       VPFCLRL
     C                   LEAVESR

     C                   ENDIF

     C                   IF        DDTCLRL = *BLANKS
     C                   EVAL      DDTCLRL = '000'
     C                   MOVE      DDTCLRL       VPFCLRL
     C                   ENDIF

      ** Verify if Numeric

     C                   MOVE      DDTCLRL       PZfld16A
     C                   CALLB     'ZALIGN'
     C                   PARM                    PZRtnCde
     C                   PARM                    PZfld16A
     C                   PARM      0             PZDec1P0
     C                   PARM      3             PZDig2P0

     C                   IF        PZRtnCde = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDTCLRL'
     C                   EVAL      MsgIdXAr(Idx)  = 'ITL3226'
     C                   EVAL      DDTCLRLOK      = 'N'
     C                   LEAVESR
     C                   ENDIF

     C                   MOVE      PZfld16A      DDTCLRL

      ** Verify if it exists in the Internal Table

     C                   CALL      'AOFXTBR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'BAU'         PChr003
     C                   PARM      DDTCLRL       PChr024
     C     IRFXTB        PARM      IRFXTB        DSFDY

     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDTCLRL'
     C                   EVAL      MsgIdXAr(Idx) = 'ITL3227'
     C                   EVAL      DDTCLRLOK = 'N'
     C                   LEAVESR
     C                   ENDIF

     C                   MOVE      DDTCLRL       VPFCLRL

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

      ** Inputs

     C                   PARM                    DDTCLRL
     C                   PARM                    DDTCLRLOK

      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** Warning fields/message IDs/message data (arrays) from/to
      ** caller

     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr

     C                   PARM                    VPFCLRL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2006
