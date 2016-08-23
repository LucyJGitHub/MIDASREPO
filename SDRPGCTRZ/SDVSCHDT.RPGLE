     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Account Review Sched Date')          *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVSCHDT - Validate Account Review Scheduled Date            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. MD026207           Date 07Apr14               *
      *  Prev Amend No. CSD092   *CREATE   Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD026207 - Mandatory fields are not highlighted after        *
      *             error validation                                  *
      *  CSD092 - Account Review                                      *
      *                                                               *
      *****************************************************************
 
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
 
     D/COPY ZACPYSRC,PSDS
 
     D/COPY ZACPYSRC,ERR_XARRYS
 
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
      ** Define work field Return code
     D W0RTN           S              7
      ** Define work field Work Screen Date
     D WUWSDT          S              6  0
      ** Define work field Date format flag
     D WUDFF           S              1
      ** Define work field Work File Date
     D WUWFDT          S              5  0
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids
     D WIx             S              3P 0
 
     D DDSCDF          S              6
     D ZDAYNO          S              5P 0
     D ZCCY            S              3
     D ZLOC            S              3
     D ZIND            S              1
     D WWDFIN          S              1
     D WWRDNB          S              5P 0
     D WWLCCY          S              3
     D WWSLCD          S              3
     D WWACTN          S              1
     D DDSCDTOK        S              1
     D DFSCDT          S              5P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Initialization
 
     C                   MOVE      *BLANK        ReturnCode
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   MOVE      *BLANK        WFldNmXAr
     C                   MOVE      *BLANK        WMsgIdXAr
     C                   MOVE      *BLANK        WMsgDtXAr
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             WIx
     C                   MOVE      'Y'           DDSCDTOK
 
     C                   IF        DDSCDF <> *BLANKS
     C                   TESTN                   DDSCDF               98
     C     *IN98         IFEQ      *OFF
     C                   EVAL      DDSCDTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = 'ARSCDT    '                            MD026207
     C                   EVAL      FldNamXAr(Idx) = 'DDSCDF    '                            MD026207
     C                   EVAL      MsgIdXAr(Idx)  = 'USS0204'
     C                   ELSE
     C                   MOVE      DDSCDF        WUWSDT
 
      ** Check Screen Date - Run date
 
     C                   CALL      'ZDATE1'                             90
     C     W0RTN         PARM                    W0RTN
     C     WUWSDT        PARM                    WUWSDT
     C     WUDFF         PARM      WWDFIN        WUDFF
     C     WUWFDT        PARM      *ZERO         WUWFDT
 
     C                   IF        *IN90 = *ON
 
      ** Send message '*Error occured on CALL...'
 
     C                   EVAL      DDSCDTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = 'ARSCDT    '                            MD026207
     C                   EVAL      FldNamXAr(Idx) = 'DDSCDF    '                            MD026207
     C                   EVAL      MsgIdXAr(Idx)  = 'Y2U0032'
     C                   EVAL      MsgDtaXAr(Idx) = 'ZDATE1'
     C                   ENDIF
 
      ** Return code is an Error
 
     C                   IF        W0RTN = '*ERROR*'
     C                   EVAL      DDSCDTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = 'ARSCDT    '                            MD026207
     C                   EVAL      FldNamXAr(Idx) = 'DDSCDF    '                            MD026207
     C                   EVAL      MsgIdXAr(Idx)  = 'USS0204'
     C                   ELSE
 
      ** If Schedule Date is less than rundate
     C                   IF        WUWFDT < WWRDNB AND
     C                             WWACTN = 'I'
     C                   EVAL      DDSCDTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = 'ARSCDT    '                            MD026207
     C                   EVAL      FldNamXAr(Idx) = 'DDSCDF    '                            MD026207
     C                   EVAL      MsgIdXAr(Idx)  = 'USS0210'
     C                   ELSE
 
     C                   CALLB     'ZCHKH'
     C                   PARM      WUWFDT        ZDAYNO
     C                   PARM      WWLCCY        ZCCY
     C                   PARM      WWSLCD        ZLOC
     C                   PARM      *BLANK        ZIND
 
     C                   IF        ZIND = 'H' AND
     C                             WWACTN = 'I'
     C                   EVAL      WIx = WIx + 1
     C                   EVAL      WFldNmXAr(WIx) = 'ARSCDT    '
     C                   EVAL      WMsgIdXAr(WIx) = 'USS0196'
     C                   ENDIF
 
     C                   MOVE      WUWFDT        DFSCDT
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      DDSCDTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = 'ARSCDT    '                            MD026207
     C                   EVAL      FldNamXAr(Idx) = 'DDSCDF    '                            MD026207
     C                   EVAL      MsgIdXAr(Idx)  = 'USS0205'
 
     C                   ENDIF
 
      ** RETURN
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Return Code
     C                   PARM                    ReturnCode
 
      ** Account Review Scheduled Date
     C                   PARM                    DDSCDF
     C                   PARM                    WWACTN
     C                   PARM                    WWDFIN
     C                   PARM                    WWRDNB
     C                   PARM                    WWLCCY
     C                   PARM                    WWSLCD
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIdXAr
     C                   PARM                    WMsgDtXAr
 
      ** Account Review Scheduled Date - OK
     C                   PARM                    DDSCDTOK
     C                   PARM                    DFSCDT
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2014
