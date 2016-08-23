     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Reporting Type')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVRPTT - Validate Reporting Type and Reporting Type Remarks *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD027010B          Date 22May14               *
      *  Prev Amend No. MD027010A          Date 22May14               *
      *                 MD026873           Date 15May14               *
      *                 MD026507A          Date 12May14               *
      *                 MD026507           Date 09May14               *
      *                 CGL132   *CREATE   Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD027010B - FATCA Exempt and Reporting type is incorrect     *
      *  MD027010A - FATCA Exempt and Reporting type is incorrect     *
      *  MD026873 - Reason for Reporting Type and FATCA Exempt can be *
      *             amended to blank.                                 *
      *  MD026507A - FATCA reporting type date/time details is not    *
      *              updated                                          *
      *  MD026507 - FATCA reporting type date/time details is not     *
      *             updated                                           *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
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
 
     D ZMUSER          DS            17                                                     MD026507
     D  WUSRID                 1     10                                                     MD026507
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D DDRPTR          S            128A
     D WNEW            S              1A
     D PTimeStamp      S             26Z
     D WTimeStamp      S             26A
     D WDEF            S              1A                                                    MD026507
     D WKUSER          S             10A                                                    MD026507
 
      ** Define work field Return code
     D W0RTN           S              7
      ** Define work field Work Screen Date
     D WUWSDT          S              6  0
      ** Define work field Date format flag
     D WUDFF           S              1
      ** Define work field Work File Date
     D WUWFDT          S              5  0
 
     DWWEXET           DS             8
     D WHH                     1      2
     D WWW1                    3      3
     D WMM                     4      5
     D WWW2                    6      6
     D WSS                     7      8
 
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
     C                   Z-ADD     0             Idx
     C                   MOVE      'Y'           DDRPTTOK
     C                   MOVE      'Y'           DDRPTROK
     C                   EVAL      WWW1 = ':'
     C                   EVAL      WWW2 = ':'
     C                   EVAL      WNEW = 'N'
     C                   EVAL      DDRPTR = DDRPT1 + DDRPT2
     C                   EVAL      WDEF = *BLANKS                                           MD026507
                                                                                           MD027010A
     C                   IF        DDUSID = 'QUSER'                                        MD027010A
     C                   EVAL      WKUSER = WUSRID                                         MD027010A
     C                   ELSE                                                              MD027010A
     C                   EVAL      WKUSER = DDUSID                                         MD027010A
     C                   ENDIF                                                             MD027010A
 
     C                   IF        DDRPTT = *BLANKS
     C                   EVAL      DDRPTT = 'U'
     C                   EVAL      WDEF = 'Y'                                               MD026507
     C                   ENDIF
 
     C                   IF        DDRPTT <> 'C' AND
     C                             DDRPTT <> 'N' AND
     C                             DDRPTT <> 'P' AND
     C                             DDRPTT <> 'R' AND
     C                             DDRPTT <> 'U'
 
     C                   MOVE      'N'           DDRPTTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRPTT'      FldNamXAr(Idx)
     C                   MOVEL     'USS0390'     MsgIdXAr(Idx)
 
     C                   ENDIF
 
     C                   EVAL      DDRPDE = *BLANKS
     C                   IF        DDRPTTOK = 'Y'
     C                   IF        DDRPTT = 'C'
     C                   EVAL      DDRPDE = 'ConsentReceived'
     C                   ENDIF
     C                   IF        DDRPTT = 'N'
     C                   EVAL      DDRPDE = 'Not Relevant'
     C                   ENDIF
     C                   IF        DDRPTT = 'P'
     C                   EVAL      DDRPDE = 'Pending'
     C                   ENDIF
     C                   IF        DDRPTT = 'R'
     C                   EVAL      DDRPDE = 'Recalcitrant'
     C                   ENDIF
     C                   IF        DDRPTT = 'U'
     C                   EVAL      DDRPDE = 'Unknown'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDRPTTO = *BLANK AND
     C                             DDRPTT = 'U'
     C                   ELSE
     C                   IF        DDRPTTO <> DDRPTT
     C                             OR WDEF = 'Y'                                            MD026507
     C
     C                   EVAL      WNEW = 'Y'
     C                   CALLB     'ZDATE2'
     C                   PARM      BJRDNB        ZDAYNO            5 0
     C                   PARM                    BJDFIN            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    DATEB             7
 
     C                   MOVE      ZDATE         WFRPTF            6
 
     C                   ENDIF
     C                   ENDIF
 
     C**********         IF        DDRPTTO <> DDRPTT AND                                    MD026873
     C**********                   DDRPTR = *BLANKS AND                                     MD026873
     C**********                   DDRPTTO <> *BLANKS                                       MD026873
     C                   IF        DDRPTT <> 'U' AND                                        MD026873
     C                             DDRPTR = *BLANKS                                         MD026873
 
     C                   MOVE      'N'           DDRPTROK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRPT1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0391'     MsgIdXAr(Idx)
 
     C                   ENDIF
 
     C                   IF        DDRPTTOK = 'Y' AND
     C                             DDRPTROK = 'Y'
     C                   EVAL      DFRPTT = DDRPTT
     C                   EVAL      DFRPTR = DDRPTR
 
      ** Generate Timestamp
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    PTimestamp
 
     C                   IF        WNEW = 'Y'
     C                   EVAL      DFRPTD = BJRDNB
 
     C                   MOVE      PTimestamp    WTimestamp
     C                   EVAL      WHH = %SUBST(WTimestamp:12:2)
     C                   EVAL      WMM = %SUBST(WTimestamp:15:2)
     C                   EVAL      WSS = %SUBST(WTimestamp:18:2)
     C                   EVAL      DFRPTM = WHH + WMM + WSS
     C**********         EVAL      DFRPTU = DDUSID                                          MD026507
     C                   EVAL      DFRPTU = WKUSER                                          MD026507
     C                   EVAL      DFRPTF = WFRPTF
     C                   ELSE
 
     C                   MOVE      DDRPTF        WUWSDT
     C                   CALL      'ZDATE1'
     C     W0RTN         PARM                    W0RTN
     C     WUWSDT        PARM                    WUWSDT
     C     WUDFF         PARM      BJDFIN        WUDFF
     C     WUWFDT        PARM      *ZERO         WUWFDT
 
     C                   MOVE      WUWFDT        DFRPTD
     C                   IF        DFRPTD = *ZERO                                           MD026507
     C                   EVAL      DFRPTD = BJRDNB                                          MD026507
     C                   ENDIF                                                              MD026507
     C**********         EVAL      DFRPTM = WHH + WMM + WSS
     C**********         EVAL      DFRPTU = DDUSID
     C**********         EVAL      DFRPTM = DDRPTM                                MD026507 MD026507A
     C                   EVAL      WWEXET = DDRPTM                                         MD026507A
     C                   EVAL      DFRPTM = WHH + WMM + WSS                                MD026507A
     C                   IF        DFRPTM = *BLANKS                                         MD026507
     C                   MOVE      PTimestamp    WTimestamp                                 MD026507
     C                   EVAL      WHH = %SUBST(WTimestamp:12:2)                            MD026507
     C                   EVAL      WMM = %SUBST(WTimestamp:15:2)                            MD026507
     C                   EVAL      WSS = %SUBST(WTimestamp:18:2)                            MD026507
     C                   EVAL      DFRPTM = WHH + WMM + WSS                                 MD026507
     C                   ENDIF                                                              MD026507
     C**********         EVAL      DFRPTU = WKUSER                                MD026507 MD027010B
     C                   EVAL      DFRPTU = DDRPTU                                         MD027010B
     C                   IF        DFRPTU = *BLANKS                                        MD027010B
     C                   EVAL      DFRPTU = WKUSER                                         MD027010B
     C                   ENDIF                                                             MD027010B
     C                   EVAL      DFRPTF = DDRPTF
     C                   IF        DFRPTF = *BLANKS                                         MD026507
     C                   CALLB     'ZDATE2'                                                 MD026507
     C                   PARM      BJRDNB        ZDAYNO                                     MD026507
     C                   PARM                    BJDFIN                                     MD026507
     C                   PARM                    ZDATE                                      MD026507
     C                   PARM                    DATEB                                      MD026507
                                                                                            MD026507
     C                   MOVE      ZDATE         DFRPTF                                     MD026507
     C                   ENDIF                                                              MD026507
     C                   ENDIF
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
     C                   PARM                    DDRPTTO           1
     C                   PARM                    BJRDNB            5 0
     C                   PARM                    BJDFIN            1
     C                   PARM                    DDUSID           10
 
      ** Exempt
     C                   PARM                    DDRPTT            1
 
      ** Exempt Remark
     C                   PARM                    DDRPT1           64
     C                   PARM                    DDRPT2           64
 
     C                   PARM                    DDRPTF            6
     C                   PARM                    DDRPTM            8
     C                   PARM                    DDRPTU           10
     C                   PARM                    DDRPDE           14
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Reporting Type - OK
     C                   PARM                    DDRPTTOK          1
 
      ** Reason of Reporting Type - OK
     C                   PARM                    DDRPTROK          1
     C                   PARM                    DFRPTT            1
     C                   PARM                    DFRPTD            5 0
     C**********         PARM                    DFRPTM            8                       MD026507A
     C                   PARM                    DFRPTM            6                       MD026507A
     C                   PARM                    DFRPTU           10
     C                   PARM                    DFRPTF            6
     C                   PARM                    DFRPTR          128
 
     C/COPY ZACPYSRC,DBFIELDS
                                                                                            MD026507
      ** Retrieve ZMUSER details.                                                           MD026507
     C     *DTAARA       DEFINE                  ZMUSER                                     MD026507
     C                   IN        ZMUSER                                                   MD026507
                                                                                            MD026507
     C**********         IF        DDUSID = 'QUSER'                               MD026507 MD027010A
     C**********         EVAL      WKUSER = WUSRID                                MD026507 MD027010A
     C**********         ELSE                                                     MD026507 MD027010A
     C**********         EVAL      WKUSER = DDUSID                                MD026507 MD027010A
     C**********         ENDIF                                                    MD026507 MD027010A
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2013
