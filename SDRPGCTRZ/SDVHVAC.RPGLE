     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate High Value Account')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVHVAC - Validate High Value Account                        *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD035388           Date 20Oct15               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGL132  *CREATE    Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD035388 - FATCA Screen order rework                         *
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
     D WIx             S              3P 0
 
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
     C                   MOVE      'Y'           DDHVACOK
 
     C                   IF        DDACTI = 'I'                                             MD035388
     C                             AND DDHVACO = *BLANK                                     MD035388
     C                             AND DDHVAC = *BLANK                                      MD035388
     C                             AND C_DDHVAL <> *BLANK                                   MD035388
     C                   EVAL      DDHVAC = C_DDHVAL                                        MD035388
     C                   ENDIF                                                              MD035388
                                                                                            MD035388
     C                   IF        DDHVAC <> ' ' AND
     C                             DDHVAC <> 'L' AND
     C                             DDHVAC <> 'M' AND
     C                             DDHVAC <> 'H' AND
     C                             DDHVAC <> 'N'
 
     C                   MOVE      'N'           DDHVACOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDHVAC'      FldNamXAr(Idx)
     C                   MOVEL     'USS0392'     MsgIdXAr(Idx)
 
     C                   ENDIF
 
     C                   IF        DDHVACO <> DDHVAC
     C                   IF        DDHVACO = 'L' OR
     C                             DDHVACO = 'M' OR
     C                             DDHVACO = 'H' OR
     C                             DDHVACO = 'N'
     C                   IF        DDHVACO = 'N' AND
     C                             DDHVAC = 'L' OR
     C                             DDHVACO = 'N' AND
     C                             DDHVAC = 'M' OR
     C                             DDHVACO = 'N' AND
     C                             DDHVAC = 'H' OR
     C                             DDHVACO = 'N' AND
     C                             DDHVAC = ' ' OR
     C                             DDHVACO = ' ' AND
     C                             DDHVAC <> ' ' OR
     C                             DDHVACO = 'L' AND
     C                             DDHVAC = 'M' OR
     C                             DDHVACO = 'L' AND
     C                             DDHVAC = 'H' OR
     C                             DDHVACO = 'M' AND
     C                             DDHVAC = 'H'
     C                   ELSE
 
     C                   MOVE      'N'           DDHVACOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDHVAC'      FldNamXAr(Idx)
     C                   MOVEL     'USS0393'     MsgIdXAr(Idx)
     C                   MOVEL     DDHVACO       MsgDtaXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        Idx = 0
     C                   EVAL      DFHVAC = DDHVAC
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
 
      ** High Value Account - Original                                                      MD035388
     C                   PARM                    DDACTI            1                        MD035388
                                                                                            MD035388
      ** High Value Account - Original
     C                   PARM                    DDHVACO           1
 
      ** High Value Account
     C                   PARM                    DDHVAC            1
 
      ** CRS High Value Account                                                             MD035388
     C                   PARM                    C_DDHVAL          1                        MD035388
                                                                                            MD035388
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIdXAr
     C                   PARM                    WMsgDtXAr
 
      ** High Value Account - OK
     C                   PARM                    DDHVACOK          1
     C                   PARM                    DFHVAC            1
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2013
