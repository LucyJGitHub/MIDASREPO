     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate US Indicium of Hold Mail')           *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVUSHML - Validate US Indicium of Hold Mail                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD027584B          Date 17Jun14               *
      *  Prev Amend No. MD027499           Date 08Aug14               *
      *                 CGL132   *CREATE   Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD027584B - Validation issues with Override comments         *
      *  MD027499 - Override Document (Evidence) accepts Documents    *
      *             with the same Code                                *
      *           - Apply fix MD025077                                *
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
 
     D DDHMC1          S             64A
     D DDHMC2          S             64A
     D DDHMCO          S            128A
     D DFHMOV          S              1A
     D DFHMCO          S            128A
     D DDHMS1          S              3S 0
     D DDHMS2          S              3S 0
     D DDHMS3          S              3S 0
     D DDHMS4          S              3S 0
     D DDHMS5          S              3S 0
     D DFHMS1          S              3S 0
     D DFHMS2          S              3S 0
     D DFHMS3          S              3S 0
     D DFHMS4          S              3S 0
     D DFHMS5          S              3S 0
     D WERR            S              1A
     D KDCUST          S             10A
     D KDRTYP          S              1A
     D KDHMDD          S              2A
     D KDHMSS          S              3S 0
 
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
     C                   MOVE      'Y'           DDHMOVOK
     C                   MOVE      'Y'           DDHMCOOK
     C                   MOVE      *BLANK        KDCUST
     C                   MOVEL     DDCUST        KDCUST
     C                   MOVE      DDRTYP        KDRTYP
 
     C                   IF        DDHMOV <> 'Y' AND
     C                             DDHMOV <> 'N' AND
     C                             DDHMOV <> ' '
 
     C                   MOVE      'N'           DDHMOVOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDHMOV'      FldNamXAr(Idx)
     C                   MOVEL     'USS0147'     MsgIdXAr(Idx)
 
     C                   ENDIF
 
     C                   EVAL      DDHMCO = DDHMC1 + DDHMC2
 
     C                   IF        DDHMOVO <> DDHMOV AND
     C                             DDHMCO = *BLANKS AND
     C                             Idx = 0
                                                                                           MD027584B
     C                             OR (DDHMOV <> *BLANKS AND                               MD027584B
     C                             DDHMCO = *BLANKS AND                                    MD027584B
     C                             Idx = 0)                                                MD027584B
 
     C                   MOVE      'N'           DDHMCOOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDHMCO'      FldNamXAr(Idx)
     C                   MOVEL     'USS0148'     MsgIdXAr(Idx)
 
     C                   ENDIF
 
     C                   IF        DDHMOV = 'Y' OR
     C                             DDHMOV = 'N'
 
     C                   IF        DDHMD1 = *BLANKS
     C                   IF        DDHMD2 <> *BLANKS OR
     C                             DDHMD3 <> *BLANKS OR
     C                             DDHMD4 <> *BLANKS OR
     C                             DDHMD5 <> *BLANKS
     C                   MOVE      'N'           DDHMD1OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDHMD1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDHMD2 = *BLANKS
     C                   IF        DDHMD3 <> *BLANKS OR
     C                             DDHMD4 <> *BLANKS OR
     C                             DDHMD5 <> *BLANKS
     C                   MOVE      'N'           DDHMD2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDHMD2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDHMD3 = *BLANKS
     C                   IF        DDHMD4 <> *BLANKS OR
     C                             DDHMD5 <> *BLANKS
     C                   MOVE      'N'           DDHMD3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDHMD3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDHMD4 = *BLANKS
     C                   IF        DDHMD5 <> *BLANKS
     C                   MOVE      'N'           DDHMD4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDHMD4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDHMD1 <> *BLANKS
     C                   MOVE      DDHMD1        KDHMDD
     C                   MOVE      DDHMS1        KDHMSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFHMD1 = DDHMD1
     C                   EVAL      DFHMS1 = DDHMS1
     C                   ELSE
 
     C                   MOVE      'N'           DDHMD1OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDHMD1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDHMD1OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDHMD1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDHMD2 <> *BLANKS
     C                   MOVE      DDHMD2        KDHMDD
     C                   MOVE      DDHMS2        KDHMSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFHMD2 = DDHMD2
     C                   EVAL      DFHMS2 = DDHMS2
     C                   ELSE
 
     C                   MOVE      'N'           DDHMD2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDHMD2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDHMD2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDHMD2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDHMD3 <> *BLANKS
     C                   MOVE      DDHMD3        KDHMDD
     C                   MOVE      DDHMS3        KDHMSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFHMD3 = DDHMD3
     C                   EVAL      DFHMS3 = DDHMS3
     C                   ELSE
 
     C                   MOVE      'N'           DDHMD3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDHMD3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDHMD3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDHMD3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDHMD4 <> *BLANKS
     C                   MOVE      DDHMD4        KDHMDD
     C                   MOVE      DDHMS4        KDHMSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFHMD4 = DDHMD4
     C                   EVAL      DFHMS4 = DDHMS4
     C                   ELSE
 
     C                   MOVE      'N'           DDHMD4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDHMD4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDHMD4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDHMD4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDHMD5 <> *BLANKS
     C                   MOVE      DDHMD5        KDHMDD
     C                   MOVE      DDHMS5        KDHMSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFHMD5 = DDHMD5
     C                   EVAL      DFHMS5 = DDHMS5
     C                   ELSE
 
     C                   MOVE      'N'           DDHMD5OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDHMD5'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDHMD5OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDHMD5'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDHMD2 <> '  '
     C**********         IF        DDHMD1 = DDHMD2 AND                                      MD025077
     C**********                   DDHMS1 = DDHMS2                                          MD025077
     C                   IF        DDHMD1 = DDHMD2                                          MD025077
     C                   MOVE      'N'           DDHMD2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDHMD2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDHMD3 <> '  '
     C**********         IF        DDHMD1 = DDHMD3 AND                                      MD025077
     C**********                   DDHMS1 = DDHMS3 OR                                       MD025077
     C**********                   DDHMD2 = DDHMD3 AND                                      MD025077
     C**********                   DDHMS2 = DDHMS3                                          MD025077
     C                   IF        DDHMD1 = DDHMD3 OR                                       MD025077
     C                             DDHMD2 = DDHMD3                                          MD025077
     C                   MOVE      'N'           DDHMD3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDHMD3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDHMD4 <> '  '
     C**********         IF        DDHMD1 = DDHMD4 AND                                      MD025077
     C**********                   DDHMS1 = DDHMS4 OR                                       MD025077
     C**********                   DDHMD2 = DDHMD4 AND                                      MD025077
     C**********                   DDHMS2 = DDHMS4 OR                                       MD025077
     C**********                   DDHMD3 = DDHMD4 AND                                      MD025077
     C**********                   DDHMS3 = DDHMS4                                          MD025077
     C                   IF        DDHMD1 = DDHMD4 OR                                       MD025077
     C                             DDHMD2 = DDHMD4 OR                                       MD025077
     C                             DDHMD3 = DDHMD4                                          MD025077
     C                   MOVE      'N'           DDHMD4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDHMD4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDHMD5 <> '  '
     C**********         IF        DDHMD1 = DDHMD5 AND                                      MD025077
     C**********                   DDHMS1 = DDHMS5 OR                                       MD025077
     C**********                   DDHMD2 = DDHMD5 AND                                      MD025077
     C**********                   DDHMS2 = DDHMS5 OR                                       MD025077
     C**********                   DDHMD3 = DDHMD5 AND                                      MD025077
     C**********                   DDHMS3 = DDHMS5 OR                                       MD025077
     C**********                   DDHMD4 = DDHMD5 AND                                      MD025077
     C**********                   DDHMS4 = DDHMS5                                          MD025077
     C                   IF        DDHMD1 = DDHMD5 OR                                       MD025077
     C                             DDHMD2 = DDHMD5 OR                                       MD025077
     C                             DDHMD3 = DDHMD5 OR                                       MD025077
     C                             DDHMD4 = DDHMD5                                          MD025077
     C                   MOVE      'N'           DDHMD5OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDHMD5'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
 
     C                   ELSE
 
     C                   EVAL      WERR = 'N'
     C                   IF        DDHMD1 <> *BLANKS
     C                   MOVE      'N'           DDHMD1OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDHMD2 <> *BLANKS
     C                   MOVE      'N'           DDHMD2OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDHMD3 <> *BLANKS
     C                   MOVE      'N'           DDHMD3OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDHMD4 <> *BLANKS
     C                   MOVE      'N'           DDHMD4OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDHMD5 <> *BLANKS
     C                   MOVE      'N'           DDHMD5OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        WERR = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'DDHMD1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0374'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        Idx = 0
     C                   EVAL      DFHMOV = DDHMOV
     C                   EVAL      DFHMD1 = DDHMD1
     C                   EVAL      DFHMD2 = DDHMD2
     C                   EVAL      DFHMD3 = DDHMD3
     C                   EVAL      DFHMD4 = DDHMD4
     C                   EVAL      DFHMD5 = DDHMD5
     C                   EVAL      DFHMS1 = DDHMS1
     C                   EVAL      DFHMS2 = DDHMS2
     C                   EVAL      DFHMS3 = DDHMS3
     C                   EVAL      DFHMS4 = DDHMS4
     C                   EVAL      DFHMS5 = DDHMS5
     C                   EVAL      DFHMCO = DDHMCO
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
 
      ** US Indicium of US Hold Mail - Override Value (Original)
     C                   PARM                    DDHMOVO           1
 
      ** US Indicium of US Hold Mail - Override Value
     C                   PARM                    DDHMOV            1
 
      ** Customer
     C                   PARM                    DDCUST           10
     C                   PARM                    DDRTYP            1
 
      ** US Indicium of US Country of Birth - Override Active Document
     C                   PARM                    DDHMD1            2
     C                   PARM                    DDHMD2            2
     C                   PARM                    DDHMD3            2
     C                   PARM                    DDHMD4            2
     C                   PARM                    DDHMD5            2
     C                   PARM                    DDHMS1
     C                   PARM                    DDHMS2
     C                   PARM                    DDHMS3
     C                   PARM                    DDHMS4
     C                   PARM                    DDHMS5
 
      ** US Indicium of US Hold Mail Comment
     C                   PARM                    DDHMC1
     C                   PARM                    DDHMC2
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** US Indicium of US Hold Mail - OK
     C                   PARM                    DDHMOVOK          1
     C                   PARM                    DDHMCOOK          1
     C                   PARM                    DDHMD1OK          1
     C                   PARM                    DDHMD2OK          1
     C                   PARM                    DDHMD3OK          1
     C                   PARM                    DDHMD4OK          1
     C                   PARM                    DDHMD5OK          1
 
     C                   PARM                    DFHMOV
     C                   PARM                    DFHMD1            2
     C                   PARM                    DFHMD2            2
     C                   PARM                    DFHMD3            2
     C                   PARM                    DFHMD4            2
     C                   PARM                    DFHMD5            2
     C                   PARM                    DFHMS1
     C                   PARM                    DFHMS2
     C                   PARM                    DFHMS3
     C                   PARM                    DFHMS4
     C                   PARM                    DFHMS5
     C                   PARM                    DFHMCO
 
     C     KDCMT         KLIST
     C                   KFLD                    KDCUST
     C                   KFLD                    KDRTYP
     C                   KFLD                    KDHMDD
     C                   KFLD                    KDHMSS
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2013
