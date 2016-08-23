     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate FATCA Customer Type')                *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVCSTY - Validate FATCA Customer Type                       *
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
     C                   MOVE      'Y'           DDCST1OK
     C                   EVAL      DDCSTD = *BLANKS
 
     C                   IF        DDCSTP <> ' ' AND
     C                             DDCSTP <> 'F' AND
     C                             DDCSTP <> 'N' AND
     C                             DDCSTP <> 'P' AND
     C                             DDCSTP <> 'J' AND
     C                             DDCSTP <> 'O'
 
     C                   MOVE      'N'           DDCST1OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCSTP'      FldNamXAr(Idx)
     C                   MOVEL     'USS0114'     MsgIdXAr(Idx)
 
     C                   ELSE
 
     C                   IF        DDCSTP = 'F'
     C                   EVAL      DDCSTD = 'Foreign Financial +
     C                                      Institution'
     C                   ENDIF
 
     C                   IF        DDCSTP = 'N'
     C                   EVAL      DDCSTD = 'Non-financial +
     C                                      Entity'
     C                   ENDIF
 
     C                   IF        DDCSTP = 'P'
     C                   EVAL      DDCSTD = 'Physical Person'
     C                   ENDIF
 
     C                   IF        DDCSTP = 'J'
     C                   EVAL      DDCSTD = 'Joint Account'
     C                   ENDIF
 
     C                   IF        DDCSTP = 'O'
     C                   EVAL      DDCSTD = 'Other'
     C                   ENDIF
 
     C                   EVAL      DFCSTY = DDCSTP
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
     C                   PARM                    DDCSTP            1
     C                   PARM                    DDCSTD           29
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** FATCA Customer Type - OK
     C                   PARM                    DDCST1OK          1
     C                   PARM                    DFCSTY            1
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2013
