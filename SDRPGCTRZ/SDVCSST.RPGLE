     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate FATCA Customer Sub Type')            *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVCSST - Validate FATCA Customer Sub Type                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD027252           Date 04Aug14               *
      *  Prev Amend No. MD027010A          Date 22May14               *
      *                 CGL132   *CREATE   Date 15Mar13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD027252 - Error Message is displayed when FATCA Customer    *
      *             Type (F or N) is amended to blank                 *
      *  MD027010A - FATCA Exempt and Reporting type is incorrect     *
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
     D WWCSSD          S             10A                                                   MD027010A
 
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
     C                   MOVE      'Y'           DDCSSTOK
     C                   EVAL      WWCSSD = DDCSSD                                         MD027010A
     C                   EVAL      DDCSSD = *BLANKS
     C                                                                                      MD027252
     C                   IF        P_DDCSTP <> DDCSTP AND                                   MD027252
     C                             DDCSTP = *BLANKS                                         MD027252
     C                   EVAL      DDCSST = *BLANKS                                         MD027252
     C                   ENDIF                                                              MD027252
 
     C                   IF        DDCSTP = ' ' AND
     C                             DDCSST <> ' '
 
     C                   MOVE      'N'           DDCSSTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCSST'      FldNamXAr(Idx)
     C                   MOVEL     'USS0115'     MsgIdXAr(Idx)
 
     C                   ENDIF
 
     C                   IF        DDCSTP = 'F'
     C                   IF        DDCSST <> 'PO' AND
     C                             DDCSST <> 'PW' AND
     C                             DDCSST <> 'PS' AND
     C                             DDCSST <> 'NP' AND
     C                             DDCSST <> 'OW' AND
     C                             DDCSST <> 'UN'
 
     C                   MOVE      'N'           DDCSSTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCSST'      FldNamXAr(Idx)
     C                   MOVEL     'USS0116'     MsgIdXAr(Idx)
 
     C                   ENDIF
 
     C                   IF        DDCSSTOK = 'Y'
     C                   IF        DDCSST = 'PO'
     C                   EVAL      DDCSSD = 'Participating +
     C                                      - Own GIIN'
     C                   ENDIF
 
     C                   IF        DDCSST = 'PW'
     C                   EVAL      DDCSSD = 'Participating +
     C                                      - W/o GIIN'
     C                   ENDIF
 
     C                   IF        DDCSST = 'PS'
     C                   EVAL      DDCSSD = 'Part. w/ +
     C                                      someone elses GIIN'
     C                   ENDIF
 
     C                   IF        DDCSST = 'NP'
     C                   EVAL      DDCSSD = 'Non-participating'
     C                   ENDIF
 
     C                   IF        DDCSST = 'OW'
     C                   EVAL      DDCSSD = 'Owner Document +
     C                                      FFI'
     C                   ENDIF
 
     C                   IF        DDCSST = 'UN'
     C                   EVAL      DDCSSD = 'Unknown'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        DDCSTP = 'N'
     C                   IF        DDCSST <> 'AC' AND
     C                             DDCSST <> 'PA' AND
     C                             DDCSST <> 'UN'
 
     C                   MOVE      'N'           DDCSSTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCSST'      FldNamXAr(Idx)
     C                   MOVEL     'USS0117'     MsgIdXAr(Idx)
 
     C                   ENDIF
 
     C                   IF        DDCSSTOK = 'Y'
     C                   IF        DDCSST = 'AC'
     C                   EVAL      DDCSSD = 'Active'
     C                   ENDIF
 
     C                   IF        DDCSST = 'PA'
     C                   EVAL      DDCSSD = 'Passive'
     C                   ENDIF
 
     C                   IF        DDCSST = 'UN'
     C                   EVAL      DDCSSD = 'Unknown'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDCSTP = 'P' AND
     C                             DDCSST <> '  ' OR
     C                             DDCSTP = 'J' AND
     C                             DDCSST <> '  ' OR
     C                             DDCSTP = 'O' AND
     C                             DDCSST <> '  '
 
     C                   MOVE      'N'           DDCSSTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCSST'      FldNamXAr(Idx)
     C                   MOVEL     'USS0118'     MsgIdXAr(Idx)
 
     C                   ENDIF
 
     C                   IF        DDCSSTOK = 'Y'
     C                   EVAL      DFCSST = DDCSST
     C                   ENDIF
     C                   EVAL      DDCSSD = WWCSSD                                         MD027010A
 
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
     C                   PARM                    DDCSST            2
 
      ** FATCA Customer Type
     C                   PARM                    DDCSTP            1
 
      ** FATCA Customer Sub Type Description
     C                   PARM                    DDCSSD           29
                                                                                            MD027252
      ** FATCA Customer Sub Type Description (Previous)                                     MD027252
     C                   PARM                    P_DDCSTP          1                        MD027252
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Customer Sub Type - OK
     C                   PARM                    DDCSSTOK          1
     C                   PARM                    DFCSST            2
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2013
