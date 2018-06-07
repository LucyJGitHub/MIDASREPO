     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate FATCA Customer Type')                *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVCSTY - Validate FATCA Customer Type                       *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD035388           Date 20Oct15               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGL132  *CREATE    Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD033588 - FATCA Screen order rework                         *
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
     C                   MOVE      'Y'           DDCST1OK
     C                   EVAL      DDCSTD = *BLANKS
 
      ** Default to CRS Details                                                             MD035388
     C                   IF        DDACTI = 'I'                                             MD035388
     C                             AND P_DDCSTP = *BLANKS                                   MD035388
     C                             AND DDCSTP = *BLANKS                                     MD035388
     C                   EVAL      DDCSTP = C_DDTYPE                                        MD035388
     C                   ENDIF                                                              MD035388
                                                                                            MD035388
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
 
     C                   PARM                    DDACTI            1                        MD035388
                                                                                            MD035388
      ** FATCA Customer Type
     C                   PARM                    DDCSTP            1
     C                   PARM                    DDCSTD           29
 
     C                   PARM                    P_DDCSTP          1                        MD035388
     C                   PARM                    C_DDTYPE          1                        MD035388
                                                                                            MD035388
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
(c) Finastra International Limited 2013
