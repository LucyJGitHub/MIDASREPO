     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Exempt Flag')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVEXEM - Validate Exempt Flag and Remarks                   *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD027458A          Date 15Sep14               *
      *                 MD027458           Date 04Aug14               *
      *                 MD027010A          Date 22May14               *
      *                 MD026873           Date 15May14               *
      *                 MD026507A          Date 12May14               *
      *                 MD026507           Date 09May14               *
      *                 CGL132   *CREATE   Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD027458A - FATCA Exempt? flag should not be amendable to    *
      *             blank (Re-open)                                   *
      *  MD027458 - FATCA Exempt? flag should not be amendable to     *
      *             blank                                             *
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
 
      ** +--------------------------------------+                                           MD027458
      ** ¦ F-specs                              ¦                                           MD027458
      ** ¦ =======                              ¦                                           MD027458
      ** +--------------------------------------+                                           MD027458
                                                                                            MD027458
      ** Midas SD FATCA Customer Details retrieval index                                    MD027458
     FSDFTCSL1  IF   E           K DISK    INFSR(*PSSR)                                     MD027458
                                                                                            MD027458
      ** Midas SD FATCA NAHO Details retrieval index                                        MD027458
     FSDFTNHL1  IF   E           K DISK    INFSR(*PSSR)                                     MD027458
 
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
     D DDEXER          S            256A
     D WNEW            S              1A
     D PTimeStamp      S             26Z
     D WTimeStamp      S             26A
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
     C                   MOVE      'Y'           DDEXEMOK
     C                   MOVE      'Y'           DDEXEROK
     C                   EVAL      WWW1 = ':'
     C                   EVAL      WWW2 = ':'
     C                   EVAL      WNEW = 'N'
     C                   EVAL      DFEXEM = *BLANKS                                        MD026507A
     C                   EVAL      DFEXED = *ZERO                                          MD026507A
     C                   EVAL      DFEXET = *BLANKS                                        MD026507A
     C                   EVAL      DFEXEU = *BLANKS                                        MD026507A
     C                   EVAL      DFEXDF = *BLANKS                                        MD026507A
     C                   EVAL      DFEXER = *BLANKS                                        MD026507A
     C                   EVAL      DDEXER = DDEXE1 + DDEXE2 +
     C                                      DDEXE3 + DDEXE4
                                                                                           MD027010A
     C                   IF        DDUSID = 'QUSER'                                        MD027010A
     C                   EVAL      WKUSER = WUSRID                                         MD027010A
     C                   ELSE                                                              MD027010A
     C                   EVAL      WKUSER = DDUSID                                         MD027010A
     C                   ENDIF                                                             MD027010A
 
     C                   IF        DDEXEM <> 'Y' AND
     C                             DDEXEM <> 'N' AND
     C                             DDEXEM <> ' '
 
     C                   MOVE      'N'           DDEXEMOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDEXEM'      FldNamXAr(Idx)
     C                   MOVEL     'USS0128'     MsgIdXAr(Idx)
 
     C                   ENDIF
                                                                                            MD027458
     C                   IF        DDCUST <> *BLANKS                                        MD027458
      ** Customer Details                                                                   MD027458
     C     DDCUST        CHAIN(N)  SDFTCSL1                                                 MD027458
                                                                                            MD027458
     C**********         IF        FAEXEM = 'Y' OR FAEXEM = 'N' AND               MD027458 MD027458A
     C                   IF        (FAEXEM = 'Y' OR FAEXEM = 'N') AND                      MD027458A
     C                             DDEXEM = *BLANKS                                         MD027458
     C                   MOVE      'N'           DDEXEMOK                                   MD027458
     C                   ADD       1             Idx                                        MD027458
     C                   MOVEL     'DDEXEM'      FldNamXAr(Idx)                             MD027458
     C                   MOVEL     'USS0505'     MsgIdXAr(Idx)                              MD027458
     C                   ENDIF                                                              MD027458
                                                                                            MD027458
     C                   ELSE                                                               MD027458
      ** Non-Account Holder Details                                                         MD027458
     C     DDNAHL        CHAIN(N)  SDFTNHL1                                                 MD027458
                                                                                            MD027458
     C**********         IF        FNEXEM = 'Y' OR FNEXEM = 'N' AND               MD027458 MD027458A
     C                   IF        (FNEXEM = 'Y' OR FNEXEM = 'N') AND                      MD027458A
     C                             DDEXEM = *BLANKS                                         MD027458
     C                   MOVE      'N'           DDEXEMOK                                   MD027458
     C                   ADD       1             Idx                                        MD027458
     C                   MOVEL     'DDEXEM'      FldNamXAr(Idx)                             MD027458
     C                   MOVEL     'USS0505'     MsgIdXAr(Idx)                              MD027458
     C                   ENDIF                                                              MD027458
     C                   ENDIF                                                              MD027458
 
     C                   IF        DDEXEMO <> DDEXEM
     C                   EVAL      WNEW = 'Y'
     C                   CALLB     'ZDATE2'
     C                   PARM      BJRDNB        ZDAYNO            5 0
     C                   PARM                    BJDFIN            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    DATEB             7
 
     C                   MOVE      ZDATE         WFEXDF            6
 
     C                   ENDIF
 
     C**********         IF        DDEXEMO <> DDEXEM AND                                    MD026873
     C**********                   DDEXER = *BLANKS AND                                     MD026873
     C                   IF        DDEXER = *BLANKS AND                                     MD026873
     C                             DDEXEM = 'Y'
 
     C                   MOVE      'N'           DDEXEROK
     C                   ADD       1             Idx
     C                   MOVEL     'DDEXE1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0129'     MsgIdXAr(Idx)
 
     C                   ENDIF
 
     C                   IF        DDEXEMOK = 'Y' AND
     C                             DDEXEROK = 'Y'
     C                   EVAL      DFEXER = DDEXER
     C                   EVAL      DFEXEM = DDEXEM
 
      ** Generate Timestamp
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    PTimestamp
 
     C                   IF        WNEW = 'Y'
     C                   EVAL      DFEXED = BJRDNB
 
     C                   MOVE      PTimestamp    WTimestamp
     C                   EVAL      WHH = %SUBST(WTimestamp:12:2)
     C                   EVAL      WMM = %SUBST(WTimestamp:15:2)
     C                   EVAL      WSS = %SUBST(WTimestamp:18:2)
     C                   EVAL      DFEXET = WHH + WMM + WSS
     C**********         EVAL      DFEXEU = DDUSID                                          MD026507
     C                   EVAL      DFEXEU = WKUSER                                          MD026507
     C                   EVAL      DFEXDF = WFEXDF
     C                   ELSE
 
     C                   MOVE      DDEXEF        WUWSDT
     C                   CALL      'ZDATE1'
     C     W0RTN         PARM                    W0RTN
     C     WUWSDT        PARM                    WUWSDT
     C     WUDFF         PARM      BJDFIN        WUDFF
     C     WUWFDT        PARM      *ZERO         WUWFDT
 
     C                   MOVE      WUWFDT        DFEXED
     C                   EVAL      WWEXET = DDEXET                                         MD026507A
     C                   EVAL      DFEXET = WHH + WMM + WSS
     C                   EVAL      DFEXEU = DDEXEU
     C                   EVAL      DFEXDF = DDEXEF
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
     C                   PARM                    DDEXEMO           1
     C                   PARM                    BJRDNB            5 0
     C                   PARM                    BJDFIN            1
     C                   PARM                    DDUSID           10
 
      ** Exempt
     C                   PARM                    DDEXEM            1
     C                   PARM                    DDCUST            6                        MD027458
     C                   PARM                    DDNAHL           10                        MD027458
 
      ** Exempt Remark
     C                   PARM                    DDEXE1           64
     C                   PARM                    DDEXE2           64
     C                   PARM                    DDEXE3           64
     C                   PARM                    DDEXE4           64
 
     C                   PARM                    DDEXEF            6
     C                   PARM                    DDEXET            8
     C                   PARM                    DDEXEU           10
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Exempt - OK
     C                   PARM                    DDEXEMOK          1
 
      ** Exempt Remark - OK
     C                   PARM                    DDEXEROK          1
     C                   PARM                    DFEXEM            1
     C                   PARM                    DFEXED            5 0
     C                   PARM                    DFEXET            6
     C                   PARM                    DFEXEU           10
     C                   PARM                    DFEXDF            6
     C                   PARM                    DFEXER          256
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
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2013
