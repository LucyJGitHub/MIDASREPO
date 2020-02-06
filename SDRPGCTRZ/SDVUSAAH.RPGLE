     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate US Indicium of Authority Holder')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVUSAAH - Validate US Indicium of Account Authority Holder  *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD027584B          Date 17Jun14               *
      *                 MD027499           Date 08Aug14               *
      *                 MD026740           Date 29May14               *
      *                 CGL132   *CREATE   Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD027584B - Validation issues with Override comments         *
      *  MD027499 - Override Document (Evidence) accepts Documents    *
      *             with the same Code                                *
      *           - Apply fix MD25077                                 *
      *  MD026740 - Wrong error message for Account Authority Holder  *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *                                                               *
      *****************************************************************
 
      ** Document Management file
     FSDDCMTL1  IF   E           K DISK    INFSR(*PSSR)
 
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
 
     D DDAUC1          S             64A
     D DDAUC2          S             64A
     D DDAUCO          S            128A
     D DFAUOV          S              1A
     D DFAUCO          S            128A
     D DDAUS1          S              3S 0
     D DDAUS2          S              3S 0
     D DDAUS3          S              3S 0
     D DDAUS4          S              3S 0
     D DDAUS5          S              3S 0
     D DFAUS1          S              3S 0
     D DFAUS2          S              3S 0
     D DFAUS3          S              3S 0
     D DFAUS4          S              3S 0
     D DFAUS5          S              3S 0
     D WERR            S              1A
     D KDCUST          S             10A
     D KDRTYP          S              1A
     D KDAUDD          S              2A
     D KDAUSS          S              3S 0
 
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
     C                   MOVE      'Y'           DDAUOVOK
     C                   MOVE      'Y'           DDAUCOOK
     C                   MOVE      *BLANK        KDCUST
     C                   MOVEL     DDCUST        KDCUST
     C                   MOVE      DDRTYP        KDRTYP
 
     C                   IF        DDAUOV <> 'Y' AND
     C                             DDAUOV <> 'N' AND
     C                             DDAUOV <> ' '
 
     C                   MOVE      'N'           DDAUOVOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDAUOV'      FldNamXAr(Idx)
     C**********         MOVEL     'USS0153'     MsgIdXAr(Idx)                              MD026740
     C                   MOVEL     'USS0491'     MsgIdXAr(Idx)                              MD026740
 
     C                   ENDIF
 
     C                   EVAL      DDAUCO = DDAUC1 + DDAUC2
 
     C                   IF        DDAUOVO <> DDAUOV AND
     C                             DDAUCO = *BLANKS AND
     C                             Idx = 0
                                                                                           MD027584B
     C                             OR (DDAUOV <> *BLANKS AND                               MD027584B
     C                             DDAUCO = *BLANKS AND                                    MD027584B
     C                             Idx = 0)                                                MD027584B
 
     C                   MOVE      'N'           DDAUCOOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDAUCO'      FldNamXAr(Idx)
     C**********         MOVEL     'USS0154'     MsgIdXAr(Idx)                              MD026740
     C                   MOVEL     'USS0492'     MsgIdXAr(Idx)                              MD026740
 
     C                   ENDIF
 
     C                   IF        DDAUOV = 'Y' OR
     C                             DDAUOV = 'N'
 
     C                   IF        DDAUD1 = *BLANKS
     C                   IF        DDAUD2 <> *BLANKS OR
     C                             DDAUD3 <> *BLANKS OR
     C                             DDAUD4 <> *BLANKS OR
     C                             DDAUD5 <> *BLANKS
     C                   MOVE      'N'           DDAUD1OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDAUD1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDAUD2 = *BLANKS
     C                   IF        DDAUD3 <> *BLANKS OR
     C                             DDAUD4 <> *BLANKS OR
     C                             DDAUD5 <> *BLANKS
     C                   MOVE      'N'           DDAUD2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDAUD2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDAUD3 = *BLANKS
     C                   IF        DDAUD4 <> *BLANKS OR
     C                             DDAUD5 <> *BLANKS
     C                   MOVE      'N'           DDAUD3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDAUD3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDAUD4 = *BLANKS
     C                   IF        DDAUD5 <> *BLANKS
     C                   MOVE      'N'           DDAUD4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDAUD4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDAUD1 <> *BLANKS
     C                   MOVE      DDAUD1        KDAUDD
     C                   MOVE      DDAUS1        KDAUSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFAUD1 = DDAUD1
     C                   EVAL      DFAUS1 = DDAUS1
     C                   ELSE
 
     C                   MOVE      'N'           DDAUD1OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDAUD1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDAUD1OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDAUD1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDAUD2 <> *BLANKS
     C                   MOVE      DDAUD2        KDAUDD
     C                   MOVE      DDAUS2        KDAUSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFAUD2 = DDAUD2
     C                   EVAL      DFAUS2 = DDAUS2
     C                   ELSE
 
     C                   MOVE      'N'           DDAUD2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDAUD2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDAUD2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDAUD2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDAUD3 <> *BLANKS
     C                   MOVE      DDAUD3        KDAUDD
     C                   MOVE      DDAUS3        KDAUSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFAUD3 = DDAUD3
     C                   EVAL      DFAUS3 = DDAUS3
     C                   ELSE
 
     C                   MOVE      'N'           DDAUD3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDAUD3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDAUD3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDAUD3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDAUD4 <> *BLANKS
     C                   MOVE      DDAUD4        KDAUDD
     C                   MOVE      DDAUS4        KDAUSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFAUD4 = DDAUD4
     C                   EVAL      DFAUS4 = DDAUS4
     C                   ELSE
 
     C                   MOVE      'N'           DDAUD4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDAUD4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDAUD4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDAUD4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDAUD5 <> *BLANKS
     C                   MOVE      DDAUD5        KDAUDD
     C                   MOVE      DDAUS5        KDAUSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFAUD5 = DDAUD5
     C                   EVAL      DFAUS5 = DDAUS5
     C                   ELSE
 
     C                   MOVE      'N'           DDAUD5OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDAUD5'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDAUD5OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDAUD5'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDAUD2 <> '  '
     C**********         IF        DDAUD1 = DDAUD2 AND                                      MD025077
     C**********                   DDAUS1 = DDAUS2                                          MD025077
     C                   IF        DDAUD1 = DDAUD2                                          MD025077
     C                   MOVE      'N'           DDAUD2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDAUD2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDAUD3 <> '  '
     C**********         IF        DDAUD1 = DDAUD3 AND                                      MD025077
     C**********                   DDAUS1 = DDAUS3 OR                                       MD025077
     C**********                   DDAUD2 = DDAUD3 AND                                      MD025077
     C**********                   DDAUS2 = DDAUS3                                          MD025077
     C                   IF        DDAUD1 = DDAUD3 OR                                       MD025077
     C                             DDAUD2 = DDAUD3                                          MD025077
     C                   MOVE      'N'           DDAUD3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDAUD3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDAUD4 <> '  '
     C**********         IF        DDAUD1 = DDAUD4 AND                                      MD025077
     C**********                   DDAUS1 = DDAUS4 OR                                       MD025077
     C**********                   DDAUD2 = DDAUD4 AND                                      MD025077
     C**********                   DDAUS2 = DDAUS4 OR                                       MD025077
     C**********                   DDAUD3 = DDAUD4 AND                                      MD025077
     C**********                   DDAUS3 = DDAUS4                                          MD025077
     C                   IF        DDAUD1 = DDAUD4 OR                                       MD025077
     C                             DDAUD2 = DDAUD4 OR                                       MD025077
     C                             DDAUD3 = DDAUD4                                          MD025077
     C                   MOVE      'N'           DDAUD4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDAUD4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDAUD5 <> '  '
     C**********         IF        DDAUD1 = DDAUD5 AND                                      MD025077
     C**********                   DDAUS1 = DDAUS5 OR                                       MD025077
     C**********                   DDAUD2 = DDAUD5 AND                                      MD025077
     C**********                   DDAUS2 = DDAUS5 OR                                       MD025077
     C**********                   DDAUD3 = DDAUD5 AND                                      MD025077
     C**********                   DDAUS3 = DDAUS5 OR                                       MD025077
     C**********                   DDAUD4 = DDAUD5 AND                                      MD025077
     C**********                   DDAUS4 = DDAUS5                                          MD025077
     C                   IF        DDAUD1 = DDAUD5 OR                                       MD025077
     C                             DDAUD2 = DDAUD5 OR                                       MD025077
     C                             DDAUD3 = DDAUD5 OR                                       MD025077
     C                             DDAUD4 = DDAUD5                                          MD025077
     C                   MOVE      'N'           DDAUD5OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDAUD5'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      WERR = 'N'
     C                   IF        DDAUD1 <> *BLANKS
     C                   MOVE      'N'           DDAUD1OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDAUD2 <> *BLANKS
     C                   MOVE      'N'           DDAUD2OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDAUD3 <> *BLANKS
     C                   MOVE      'N'           DDAUD3OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDAUD4 <> *BLANKS
     C                   MOVE      'N'           DDAUD4OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDAUD5 <> *BLANKS
     C                   MOVE      'N'           DDAUD5OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        WERR = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'DDAUD1'      FldNamXAr(Idx)
     C**********         MOVEL     'USS0377'     MsgIdXAr(Idx)                              MD026740
     C                   MOVEL     'USS0493'     MsgIdXAr(Idx)                              MD026740
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        Idx = 0
     C                   EVAL      DFAUOV = DDAUOV
     C                   EVAL      DFAUD1 = DDAUD1
     C                   EVAL      DFAUD2 = DDAUD2
     C                   EVAL      DFAUD3 = DDAUD3
     C                   EVAL      DFAUD4 = DDAUD4
     C                   EVAL      DFAUD5 = DDAUD5
     C                   EVAL      DFAUS1 = DDAUS1
     C                   EVAL      DFAUS2 = DDAUS2
     C                   EVAL      DFAUS3 = DDAUS3
     C                   EVAL      DFAUS4 = DDAUS4
     C                   EVAL      DFAUS5 = DDAUS5
     C                   EVAL      DFAUCO = DDAUCO
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
 
      ** US Indicium of Account Authority Holder - Override
      ** Value (Original)
     C                   PARM                    DDAUOVO           1
 
      ** US Indicium of Account Authority Holder - Override Value
     C                   PARM                    DDAUOV            1
 
      ** Customer
     C                   PARM                    DDCUST           10
     C                   PARM                    DDRTYP            1
 
      ** US Indicium of Account Authority Holder
      ** - Override Active Document
     C                   PARM                    DDAUD1            2
     C                   PARM                    DDAUD2            2
     C                   PARM                    DDAUD3            2
     C                   PARM                    DDAUD4            2
     C                   PARM                    DDAUD5            2
     C                   PARM                    DDAUS1
     C                   PARM                    DDAUS2
     C                   PARM                    DDAUS3
     C                   PARM                    DDAUS4
     C                   PARM                    DDAUS5
 
      ** US Indicium of Account Authority Holder Comment
     C                   PARM                    DDAUC1
     C                   PARM                    DDAUC2
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** US Indicium of Account Authority Holder - OK
     C                   PARM                    DDAUOVOK          1
     C                   PARM                    DDAUCOOK          1
     C                   PARM                    DDAUD1OK          1
     C                   PARM                    DDAUD2OK          1
     C                   PARM                    DDAUD3OK          1
     C                   PARM                    DDAUD4OK          1
     C                   PARM                    DDAUD5OK          1
 
     C                   PARM                    DFAUOV
     C                   PARM                    DFAUD1            2
     C                   PARM                    DFAUD2            2
     C                   PARM                    DFAUD3            2
     C                   PARM                    DFAUD4            2
     C                   PARM                    DFAUD5            2
     C                   PARM                    DFAUS1
     C                   PARM                    DFAUS2
     C                   PARM                    DFAUS3
     C                   PARM                    DFAUS4
     C                   PARM                    DFAUS5
     C                   PARM                    DFAUCO
 
     C     KDCMT         KLIST
     C                   KFLD                    KDCUST
     C                   KFLD                    KDRTYP
     C                   KFLD                    KDAUDD
     C                   KFLD                    KDAUSS
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2013
