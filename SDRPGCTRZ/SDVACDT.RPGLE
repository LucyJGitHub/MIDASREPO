     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Account Review Actual Date/Time')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVACDT - Validate Account Review Actual Date/Time           *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD026819           Date 26Jul14               *
      *                 MD026262           Date 28May14               *
      *                 MD026207           Date 07Apr14               *
      *                 CSD092   *CREATE   Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD026819 - Actual Time should be in HH:MM:SS format          *
      *  MD026262 - Invalid input for Actual Date, highlights both    *
      *             actual date and scheduled date                    *
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
 
     D WWTIME          DS             6
     D  WWHOUR                 1      2S 0
     D  WWMIN                  3      4S 0
     D  WWSEC                  5      6S 0
 
     D WFTMST          DS
     D  WWHH                   1      2
     D  WWCC1                  3      3
     D  WWMM                   4      5
     D  WWCC2                  6      6
     D  WWSS                   7      8
 
     D WFTMST2         DS
     D  WWHH2                  1      2
     D  WWMM2                  3      4
     D  WWSS2                  5      6
 
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
     D FIdx            S              3P 0
 
     D DDACDF          S              6
     D WWDFIN          S              1
     D WWRDNB          S              5P 0
     D DDCOMP          S              1
     D DDACDTOK        S              1
     D DFACDT          S              5P 0
     D DFACTM          S              6
     D ZDAYNO          S              5P 0
     D ZDATE           S              6P 0
     D DATEB           S              7
     D WWTMST          S             26
     D WKTMST          S             26Z
     D DDACTM          S              8
     D DDACTMOK        S              1
     D WDCOMP          S              1
     D OkFmt           S              1
     D DDTIME          S              6
     D WTTEST          S              1
 
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
     C                   MOVE      'Y'           DDACDTOK
 
     C                   IF        DDACDF <> *BLANKS
     C                   TESTN                   DDACDF               98
     C     *IN98         IFEQ      *OFF
     C                   EVAL      DDACDTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = 'ARACDT    '                            MD026207
     C**********         EVAL      FldNamXAr(Idx) = 'DDSCDF    '                   MD026207 MD026262
     C                   EVAL      FldNamXAr(Idx) = 'DDACDF    '                            MD026262
     C                   EVAL      MsgIdXAr(Idx)  = 'USS0201'
     C                   ELSE
     C                   MOVE      DDACDF        WUWSDT
 
      ** Check Screen Date - Run date
 
     C                   CALL      'ZDATE1'                             90
     C     W0RTN         PARM                    W0RTN
     C     WUWSDT        PARM                    WUWSDT
     C     WUDFF         PARM      WWDFIN        WUDFF
     C     WUWFDT        PARM      *ZERO         WUWFDT
 
     C                   IF        *IN90 = *ON
 
      ** Send message '*Error occured on CALL...'
 
     C                   EVAL      DDACDTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = 'ARACDT    '                            MD026207
     C**********         EVAL      FldNamXAr(Idx) = 'DDSCDF    '                   MD026207 MD026262
     C                   EVAL      FldNamXAr(Idx) = 'DDACDF    '                            MD026262
     C                   EVAL      MsgIdXAr(Idx)  = 'Y2U0032'
     C                   EVAL      MsgDtaXAr(Idx) = 'ZDATE1'
     C                   ENDIF
 
      ** Return code is an Error
 
     C                   IF        W0RTN = '*ERROR*'
     C                   EVAL      DDACDTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = 'ARACDT    '                            MD026207
     C**********         EVAL      FldNamXAr(Idx) = 'DDSCDF    '                   MD026207 MD026262
     C                   EVAL      FldNamXAr(Idx) = 'DDACDF    '                            MD026262
     C                   EVAL      MsgIdXAr(Idx)  = 'USS0201'
     C                   ELSE
 
      ** If Actual date is later than Run date
     C                   IF        WUWFDT > WWRDNB
     C                   EVAL      DDACDTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = 'ARACDT    '                            MD026207
     C**********         EVAL      FldNamXAr(Idx) = 'DDSCDF    '                   MD026207 MD026262
     C                   EVAL      FldNamXAr(Idx) = 'DDACDF    '                            MD026262
     C                   EVAL      MsgIdXAr(Idx)  = 'USS0203'
     C                   ELSE
     C                   MOVE      WUWFDT        DFACDT
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        DDCOMP = 'Y'
     C                   CALLB     'ZDATE2'
     C                   PARM      WWRDNB        ZDAYNO
     C                   PARM                    WWDFIN
     C                   PARM                    ZDATE
     C                   PARM                    DATEB
 
     C                   MOVE      ZDATE         DDACDF
     C                   MOVE      WWRDNB        DFACDT
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        DDACTM <> *BLANKS
 
     C                   EVAL      OkFmt = 'N'
     C**********         IF        %SUBST(DDACTM:7:2) = '  '                                MD026819
     C**********         EVAL      DDTIME = %SUBST(DDACTM:1:6)                              MD026819
     C**********         TESTN                   DDTIME               90                    MD026819
     C**********         MOVE      DDTIME        WTTEST                                     MD026819
     C**********         TESTZ                   WTTEST                   91                MD026819
     C**********         IF        *IN90 = '1' AND                                          MD026819
     C**********                   *IN91 = '1'                                              MD026819
     C**********         MOVE      DDTIME        WFTMST2                                    MD026819
     C**********         EVAL      OkFmt = 'Y'                                              MD026819
     C**********         ELSE                                                               MD026819
     C**********         EVAL      DDACTMOK = 'N'                                           MD026819
     C**********         EVAL      Idx = Idx + 1                                            MD026819
     C**********         EVAL      FldNamXAr(Idx) = 'ARACTM    '                            MD026207
     C**********         EVAL      FldNamXAr(Idx) = 'DDACTM    '                   MD026207 MD026819
     C**********         EVAL      MsgIdXAr(Idx)  = 'USS0380'                               MD026819
     C**********         ENDIF                                                              MD026819
     C**********         ENDIF                                                              MD026819
 
     C                   IF        %SUBST(DDACTM:3:1) = ':' AND
     C                             %SUBST(DDACTM:6:1) = ':'
     C                   MOVE      DDACTM        WFTMST
     C                   MOVE      WWHH          WWHH2
     C                   MOVE      WWMM          WWMM2
     C                   MOVE      WWSS          WWSS2
     C                   TESTN                   WFTMST2              90
     C                   MOVE      WFTMST2       WTTEST
     C                   TESTZ                   WTTEST                   91
     C                   IF        *IN90 = '1' AND
     C                             *IN91 = '1'
     C                   EVAL      OkFmt = 'Y'
     C                   ELSE
     C                   EVAL      DDACTMOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = 'ARACTM    '                            MD026207
     C                   EVAL      FldNamXAr(Idx) = 'DDACTM    '                            MD026207
     C                   EVAL      MsgIdXAr(Idx)  = 'USS0380'
     C                   ENDIF
     C                   ELSE                                                               MD026819
     C                   EVAL      DDACTMOK = 'N'                                           MD026819
     C                   EVAL      Idx = Idx + 1                                            MD026819
     C                   EVAL      FldNamXAr(Idx) = 'DDACTM    '                            MD026819
     C                   EVAL      MsgIdXAr(Idx)  = 'USS0380'                               MD026819
     C                   ENDIF
 
     C                   IF        OkFmt = 'Y'
     C                   MOVE      WFTMST2       WWTIME
     C                   IF        WWHOUR >= 0 AND
     C                             WWHOUR <= 23 AND
     C                             WWMIN >= 0 AND
     C                             WWMIN <= 59 AND
     C                             WWSEC >= 0 AND
     C                             WWSEC <= 59
     C                   MOVE      WWHH2         WWHH
     C                   MOVE      WWMM2         WWMM
     C                   MOVE      WWSS2         WWSS
     C                   EVAL      WWCC1 = ':'
     C                   EVAL      WWCC2 = ':'
     C                   EVAL      DFACTM = WFTMST2
     C                   ELSE
     C                   EVAL      DDACTMOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = 'ARACTM    '                            MD026207
     C                   EVAL      FldNamXAr(Idx) = 'DDACTM    '                            MD026207
     C                   EVAL      MsgIdXAr(Idx)  = 'USS0380'
     C
     C                   ENDIF
     C**********         ELSE                                                               MD026819
     C**********         EVAL      DDACTMOK = 'N'                                           MD026819
     C**********         EVAL      Idx = Idx + 1                                            MD026819
     C**********         EVAL      FldNamXAr(Idx) = 'ARACTM    '                            MD026207
     C**********         EVAL      FldNamXAr(Idx) = 'DDACTM    '                   MD026207 MD026819
     C**********         EVAL      MsgIdXAr(Idx)  = 'USS0380'                               MD026819
     C
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        DDCOMP = 'Y'
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    WKTMST
 
     C                   MOVE      *BLANKS       WWTMST
     C                   MOVE      WKTMST        WWTMST
     C                   EVAL      WWHH = %SUBST(WWTMST:12:2)
     C                   EVAL      WWMM = %SUBST(WWTMST:15:2)
     C                   EVAL      WWSS = %SUBST(WWTMST:18:2)
     C                   EVAL      WWCC1 = ':'
     C                   EVAL      WWCC2 = ':'
     C                   EVAL      WWHH2 = WWHH
     C                   EVAL      WWMM2 = WWMM
     C                   EVAL      WWSS2 = WWSS
     C                   EVAL      DDACTM = WFTMST
     C                   EVAL      DFACTM = WFTMST2
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        DDCOMP = 'Y' AND
     C                             IDx = 0 AND
     C                             FIDx = 0 AND
     C                             WDCOMP <> 'Y'
 
     C                   EVAL      WIx = WIx + 1
     C                   EVAL      WFldNmXAr(WIx) = 'ARACDT    '
     C                   EVAL      WMsgIdXAr(WIx)  = 'USS0202'
 
     C                   ENDIF
 
      ** RETURN
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: SDACRV1VL                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Return Code
     C                   PARM                    ReturnCode
 
      ** Account Review Actual Date
     C                   PARM                    DDACDF
     C                   PARM                    DDACTM
     C                   PARM                    WWDFIN
     C                   PARM                    WWRDNB
     C                   PARM                    DDCOMP
     C                   PARM                    WDCOMP
     C                   PARM                    FIDx
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIdXAr
     C                   PARM                    WMsgDtXAr
 
      ** Account Review Actual Date - OK
     C                   PARM                    DDACDTOK
 
      ** Account Review Actual Time - OK
     C                   PARM                    DDACTMOK
     C                   PARM                    DFACDT
     C                   PARM                    DFACTM
 
     C/COPY ZACPYSRC,DBFIELDS
     C                   EVAL      WWTIME = *ZERO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2014
