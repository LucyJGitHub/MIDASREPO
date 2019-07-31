     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate FATCA Non-A/c Holder Sub Type')      *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVNHST - Validate FATCA Non-Account Holder Sub Type         *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL132  *CREATE    Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
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
     C                   MOVE      'Y'           DDNHSTOK
     C                   EVAL      DDNHSD = *BLANKS
 
     C                   IF        DDNHTP = ' ' AND
     C                             DDNHST <> ' '
 
     C                   MOVE      'N'           DDNHSTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDNHST'      FldNamXAr(Idx)
     C                   MOVEL     'USS0441'     MsgIdXAr(Idx)
 
     C                   ENDIF
 
     C                   IF        DDNHTP = 'F'
     C                   IF        DDNHST <> 'PO' AND
     C                             DDNHST <> 'PW' AND
     C                             DDNHST <> 'PS' AND
     C                             DDNHST <> 'NP' AND
     C                             DDNHST <> 'OW' AND
     C                             DDNHST <> 'UN'
 
     C                   MOVE      'N'           DDNHSTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDNHST'      FldNamXAr(Idx)
     C                   MOVEL     'USS0442'     MsgIdXAr(Idx)
 
     C                   ENDIF
 
     C                   IF        DDNHSTOK = 'Y'
     C                   IF        DDNHST = 'PO'
     C                   EVAL      DDNHSD = 'Participating +
     C                                      - Own GIIN'
     C                   ENDIF
 
     C                   IF        DDNHST = 'PW'
     C                   EVAL      DDNHSD = 'Participating +
     C                                      - W/o GIIN'
     C                   ENDIF
 
     C                   IF        DDNHST = 'PS'
     C                   EVAL      DDNHSD = 'Part. w/ +
     C                                      someone elses GIIN'
     C                   ENDIF
 
     C                   IF        DDNHST = 'NP'
     C                   EVAL      DDNHSD = 'Non-participating'
     C                   ENDIF
 
     C                   IF        DDNHST = 'OW'
     C                   EVAL      DDNHSD = 'Owner Document +
     C                                      FFI'
     C                   ENDIF
 
     C                   IF        DDNHST = 'UN'
     C                   EVAL      DDNHSD = 'Unknown'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        DDNHTP = 'N'
     C                   IF        DDNHST <> 'AC' AND
     C                             DDNHST <> 'PA' AND
     C                             DDNHST <> 'UN'
 
     C                   MOVE      'N'           DDNHSTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDNHST'      FldNamXAr(Idx)
     C                   MOVEL     'USS0443'     MsgIdXAr(Idx)
 
     C                   ENDIF
 
     C                   IF        DDNHSTOK = 'Y'
     C                   IF        DDNHST = 'AC'
     C                   EVAL      DDNHSD = 'Active'
     C                   ENDIF
 
     C                   IF        DDNHST = 'PA'
     C                   EVAL      DDNHSD = 'Passive'
     C                   ENDIF
 
     C                   IF        DDNHST = 'UN'
     C                   EVAL      DDNHSD = 'Unknown'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDNHTP = 'P' AND
     C                             DDNHST <> '  ' OR
     C                             DDNHTP = 'J' AND
     C                             DDNHST <> '  ' OR
     C                             DDNHTP = 'O' AND
     C                             DDNHST <> '  '
 
     C                   MOVE      'N'           DDNHSTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDNHST'      FldNamXAr(Idx)
     C                   MOVEL     'USS0444'     MsgIdXAr(Idx)
 
     C                   ENDIF
 
     C                   IF        DDNHSTOK = 'Y'
     C                   EVAL      DFNHST = DDNHST
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
 
      ** FATCA Customer Sub Type
     C                   PARM                    DDNHST            2
 
      ** FATCA Customer Type
     C                   PARM                    DDNHTP            1
 
      ** FATCA Customer Sub Type Description
     C                   PARM                    DDNHSD           29
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Customer Sub Type - OK
     C                   PARM                    DDNHSTOK          1
     C                   PARM                    DFNHST            2
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2013
