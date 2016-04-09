     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate FATCA Non-A/c Holder Type')          *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVNHTY - Validate FATCA Non-Account Holder Type             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. CGL132   *CREATE   Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
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
     C                   MOVE      'Y'           DDNHT1OK
     C                   EVAL      DDNHTD = *BLANKS
 
     C                   IF        DDNHTP <> ' ' AND
     C                             DDNHTP <> 'F' AND
     C                             DDNHTP <> 'N' AND
     C                             DDNHTP <> 'P' AND
     C                             DDNHTP <> 'J' AND
     C                             DDNHTP <> 'O'
 
     C                   MOVE      'N'           DDNHT1OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDNHTP'      FldNamXAr(Idx)
     C                   MOVEL     'USS0440'     MsgIdXAr(Idx)
 
     C                   ELSE
 
     C                   IF        DDNHTP = 'F'
     C                   EVAL      DDNHTD = 'Foreign Financial +
     C                                      Institution'
     C                   ENDIF
 
     C                   IF        DDNHTP = 'N'
     C                   EVAL      DDNHTD = 'Non-financial +
     C                                      Entity'
     C                   ENDIF
 
     C                   IF        DDNHTP = 'P'
     C                   EVAL      DDNHTD = 'Physical Person'
     C                   ENDIF
 
     C                   IF        DDNHTP = 'J'
     C                   EVAL      DDNHTD = 'Joint Account'
     C                   ENDIF
 
     C                   IF        DDNHTP = 'O'
     C                   EVAL      DDNHTD = 'Other'
     C                   ENDIF
 
     C                   EVAL      DFNHTY = DDNHTP
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
 
      ** FATCA Customer Type
     C                   PARM                    DDNHTP            1
     C                   PARM                    DDNHTD           29
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** FATCA Customer Type - OK
     C                   PARM                    DDNHT1OK          1
     C                   PARM                    DFNHTY            1
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2013
