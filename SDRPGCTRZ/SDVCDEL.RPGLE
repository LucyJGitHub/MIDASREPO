     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2015')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Subject to CRS Reporting')           *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVCRSR - Validate Subject to CRS Reporting and Reason       *
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *  Last Amend No. MD036219           Date 16Oct15               *
      *  Prev Amend No. CGL157  *CREATE    Date 17Aug15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD036219 - No validation on TIN field during delete          *
      *  CGL157 - CRS Reporting                                       *
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

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0

     D DDPREP          S              1
     D DDREPT          S              1
     D DDREP1          S             64
     D DDREP2          S             64
     D DDREPTOK        S              1
     D DDREPROK        S              1
     D DFREPT          S              1
     D DFREPR          S            128
     D DFREPU          S             10
     D DFREPM          S              6
     D DFREPD          S              5P 0
     D WNEW            S              1A
     D PTimeStamp      S             26Z
     D WTimeStamp      S             26A
     D WWRDNB          S              5P 0
     D DDUSID          S             10
     D WIx             S              3P 0
     D PWarning        S              1
     D DeleteOK        S              1
     D DDCTRYOK        S              1
     D DDCODO          S              1
     D DDJACM          S              1
     D DDMAIL          S              1
     D DDPHON          S              1
     D DDRPAY          S              1
     D DDTINN          S             25
     D DDEFFD          S              6
     D DDEXPD          S              6
     D WDATEA          S              6
     D BJDFIN          S              1
     D BJRDNB          S              5P 0
     D ZDAYNO          S              5  0
     D ErrorFlag       S              1

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
     C                   MOVE      *BLANK        WFldNmXAr
     C                   MOVE      *BLANK        WMsgIdXAr
     C                   MOVE      *BLANK        WMsgDtXAr
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             WIx
     C                   MOVE      ' '           DeleteOK

     C                   IF        DDCODO = 'Y'
     C                             OR DDJACM = 'Y'
     C                             OR DDMAIL = 'Y'
     C                             OR DDPHON = 'Y'
     C                             OR DDRPAY = 'Y'
     C                   MOVE      'N'           DDCTRYOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCTRY'      FldNamXAr(Idx)
     C                   MOVEL     'USS0655'     MsgIdXAr(Idx)
     C                   ENDIF

     C                   IF        DDREPT = 'Y'
     C                   MOVE      'N'           DDCTRYOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCTRY'      FldNamXAr(Idx)
     C                   MOVEL     'USS0650'     MsgIdXAr(Idx)
     C                   ENDIF
                                                                                            MD036219
     C                   IF        DDTINN <> *Blanks                                        MD036219
     C                             AND DDEXPD = *Blanks                                     MD036219
     C                   MOVE      'N'           DDCTRYOK                                   MD036219
     C                   ADD       1             Idx                                        MD036219
     C                   MOVEL     'DDCTRY'      FldNamXAr(Idx)                             MD036219
     C                   MOVEL     'USS0651'     MsgIdXAr(Idx)                              MD036219
     C                   ENDIF                                                              MD036219

     C                   IF        DDTINN <> *Blanks
     C                             AND DDEXPD <> *Blanks

     C                   CALLB     'ZDATE1'
     C                   PARM      DDEXPD        WDATEA
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag

     C                   IF        ZDAYNO > BJRDNB
     C                   MOVE      'N'           DDCTRYOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCTRY'      FldNamXAr(Idx)
     C                   MOVEL     'USS0651'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF

     C                   IF        Idx = 0
     C                             AND PWarning <> 'Y'
     C                   EVAL      WIx = WIx + 1
     C                   EVAL      WFldNmXAr(WIx) = 'DDCTRY    '
     C                   EVAL      WMsgIdXAr(WIx) = 'USS0654'
     C                   ENDIF

     C                   IF        PWarning = 'Y'
     C                   EVAL      DeleteOK = 'Y'
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

     C                   PARM                    DDCODO
     C                   PARM                    DDJACM
     C                   PARM                    DDMAIL
     C                   PARM                    DDPHON
     C                   PARM                    DDRPAY
     C                   PARM                    DDREPT
     C                   PARM                    DDTINN
     C                   PARM                    DDEFFD
     C                   PARM                    DDEXPD
     C                   PARM                    PWarning
     C                   PARM                    BJRDNB
     C                   PARM                    BJDFIN

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIdXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDCTRYOK

      ** Delete - OK
     C                   PARM                    DeleteOK

     C/COPY ZACPYSRC,DBFIELDS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2015
