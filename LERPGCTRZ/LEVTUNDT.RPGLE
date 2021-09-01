     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Validate Scaduto Dal')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEVTUNDT - Validate Scaduto Dal                              *
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

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D Idx             S              3P 0
     D WIdx            S              3P 0
      ** Index for arrays of error message ids etc

     D DDTUNDT         S              6A
     D DDTUNDTOK       S              1A
     D VPFUNDT         S              5P 0

     D ZDte06A         S              6A
     D ZDayNo          S              5P 0
     D PBJDFIN         S              1A
     D ZErrFlg1A       S              1A
      ** ZDATE1 Parameters

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

     C                   IF        DDTUNDT = *BLANKS
     C                   LEAVESR
     C                   ENDIF

      ** Validate and convert the date to Midas day number

     C                   EVAL      ZDayNo = *ZERO
     C                   CALLB     'ZDATE1'
     C                   PARM      DDTUNDT       ZDte06A
     C                   PARM                    ZDayNo
     C                   PARM                    PBJDFIN
     C                   PARM                    ZErrFlg1A

     C                   IF        ZErrFlg1A = 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDTUNDT'
     C                   EVAL      MsgIdXAr(Idx)  = 'ITL3241'
     C                   EVAL      DDTUNDTOK = 'N'
     C                   LEAVESR
     C                   ENDIF

     C                   MOVE      ZDayNo        VPFUNDT

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

     C                   PARM                    DDTUNDT
     C                   PARM                    PBJDFIN
     C                   PARM                    DDTUNDTOK

      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** Warning fields/message IDs/message data (arrays) from/to
      ** caller

     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr

     C                   PARM                    VPFUNDT

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2006
