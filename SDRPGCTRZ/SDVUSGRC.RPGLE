     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate US Indicium of US Green Card')       *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVUSGRC - Validate US Indicium of US Green Card             *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD027584B          Date 17Jun14               *
      *                 MD027499           Date 08Aug14               *
      *                 CGL132   *CREATE   Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
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
 
     D DDGCC1          S             64A
     D DDGCC2          S             64A
     D DDGCCO          S            128A
     D DFGCOV          S              1A
     D DFGCCO          S            128A
     D DDGCS1          S              3S 0
     D DDGCS2          S              3S 0
     D DDGCS3          S              3S 0
     D DDGCS4          S              3S 0
     D DDGCS5          S              3S 0
     D DFGCS1          S              3S 0
     D DFGCS2          S              3S 0
     D DFGCS3          S              3S 0
     D DFGCS4          S              3S 0
     D DFGCS5          S              3S 0
     D WERR            S              1A
     D KDCUST          S             10A
     D KDRTYP          S              1A
     D KDGCDD          S              2A
     D KDGCSS          S              3S 0
 
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
     C                   MOVE      'Y'           DDGCOVOK
     C                   MOVE      'Y'           DDGCCOOK
     C                   MOVE      *BLANK        KDCUST
     C                   MOVEL     DDCUST        KDCUST
     C                   MOVE      DDRTYP        KDRTYP
 
     C                   IF        DDGCOV <> 'Y' AND
     C                             DDGCOV <> 'N' AND
     C                             DDGCOV <> ' '
 
     C                   MOVE      'N'           DDGCOVOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDGCOV'      FldNamXAr(Idx)
     C                   MOVEL     'USS0143'     MsgIdXAr(Idx)
 
     C                   ENDIF
 
     C                   EVAL      DDGCCO = DDGCC1 + DDGCC2
 
     C                   IF        DDGCOVO <> DDGCOV AND
     C                             DDGCCO = *BLANKS AND
     C                             Idx = 0
                                                                                           MD027584B
     C                             OR (DDGCOV <> *BLANKS AND                               MD027584B
     C                             DDGCCO = *BLANKS AND                                    MD027584B
     C                             Idx = 0)                                                MD027584B
 
     C                   MOVE      'N'           DDGCCOOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDGCCO'      FldNamXAr(Idx)
     C                   MOVEL     'USS0144'     MsgIdXAr(Idx)
 
     C                   ENDIF
 
     C                   IF        DDGCOV = 'Y' OR
     C                             DDGCOV = 'N'
 
     C                   IF        DDGCD1 = *BLANKS
     C                   IF        DDGCD2 <> *BLANKS OR
     C                             DDGCD3 <> *BLANKS OR
     C                             DDGCD4 <> *BLANKS OR
     C                             DDGCD5 <> *BLANKS
     C                   MOVE      'N'           DDGCD1OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDGCD1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDGCD2 = *BLANKS
     C                   IF        DDGCD3 <> *BLANKS OR
     C                             DDGCD4 <> *BLANKS OR
     C                             DDGCD5 <> *BLANKS
     C                   MOVE      'N'           DDGCD2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDGCD2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDGCD3 = *BLANKS
     C                   IF        DDGCD4 <> *BLANKS OR
     C                             DDGCD5 <> *BLANKS
     C                   MOVE      'N'           DDGCD3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDGCD3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDGCD4 = *BLANKS
     C                   IF        DDGCD5 <> *BLANKS
     C                   MOVE      'N'           DDGCD4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDGCD4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDGCD1 <> *BLANKS
     C                   MOVE      DDGCD1        KDGCDD
     C                   MOVE      DDGCS1        KDGCSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFGCD1 = DDGCD1
     C                   EVAL      DFGCS1 = DDGCS1
     C                   ELSE
 
     C                   MOVE      'N'           DDGCD1OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDGCD1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDGCD1OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDGCD1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDGCD2 <> *BLANKS
     C                   MOVE      DDGCD2        KDGCDD
     C                   MOVE      DDGCS2        KDGCSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFGCD2 = DDGCD2
     C                   EVAL      DFGCS2 = DDGCS2
     C                   ELSE
 
     C                   MOVE      'N'           DDGCD2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDGCD2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDGCD2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDGCD2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDGCD3 <> *BLANKS
     C                   MOVE      DDGCD3        KDGCDD
     C                   MOVE      DDGCS3        KDGCSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFGCD3 = DDGCD3
     C                   EVAL      DFGCS3 = DDGCS3
     C                   ELSE
 
     C                   MOVE      'N'           DDGCD3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDGCD3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDGCD3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDGCD3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDGCD4 <> *BLANKS
     C                   MOVE      DDGCD4        KDGCDD
     C                   MOVE      DDGCS4        KDGCSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFGCD4 = DDGCD4
     C                   EVAL      DFGCS4 = DDGCS4
     C                   ELSE
 
     C                   MOVE      'N'           DDGCD4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDGCD4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDGCD4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDGCD4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDGCD5 <> *BLANKS
     C                   MOVE      DDGCD5        KDGCDD
     C                   MOVE      DDGCS5        KDGCSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFGCD5 = DDGCD5
     C                   EVAL      DFGCS5 = DDGCS5
     C                   ELSE
 
     C                   MOVE      'N'           DDGCD5OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDGCD5'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDGCD5OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDGCD5'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDGCD2 <> '  '
     C**********         IF        DDGCD1 = DDGCD2 AND                                      MD025077
     C**********                   DDGCS1 = DDGCS2                                          MD025077
     C                   IF        DDGCD1 = DDGCD2                                          MD025077
     C                   MOVE      'N'           DDGCD2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDGCD2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDGCD3 <> '  '
     C**********         IF        DDGCD1 = DDGCD3 AND                                      MD025077
     C**********                   DDGCS1 = DDGCS3 OR                                       MD025077
     C**********                   DDGCD2 = DDGCD3 AND                                      MD025077
     C**********                   DDGCS2 = DDGCS3                                          MD025077
     C                   IF        DDGCD1 = DDGCD3 OR                                       MD025077
     C                             DDGCD2 = DDGCD3                                          MD025077
     C                   MOVE      'N'           DDGCD3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDGCD3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDGCD4 <> '  '
     C**********         IF        DDGCD1 = DDGCD4 AND                                      MD025077
     C**********                   DDGCS1 = DDGCS4 OR                                       MD025077
     C**********                   DDGCD2 = DDGCD4 AND                                      MD025077
     C**********                   DDGCS2 = DDGCS4 OR                                       MD025077
     C**********                   DDGCD3 = DDGCD4 AND                                      MD025077
     C**********                   DDGCS3 = DDGCS4                                          MD025077
     C                   IF        DDGCD1 = DDGCD4 OR                                       MD025077
     C                             DDGCD2 = DDGCD4 OR                                       MD025077
     C                             DDGCD3 = DDGCD4                                          MD025077
     C                   MOVE      'N'           DDGCD4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDGCD4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDGCD5 <> '  '
     C**********         IF        DDGCD1 = DDGCD5 AND                                      MD025077
     C**********                   DDGCS1 = DDGCS5 OR                                       MD025077
     C**********                   DDGCD2 = DDGCD5 AND                                      MD025077
     C**********                   DDGCS2 = DDGCS5 OR                                       MD025077
     C**********                   DDGCD3 = DDGCD5 AND                                      MD025077
     C**********                   DDGCS3 = DDGCS5 OR                                       MD025077
     C**********                   DDGCD4 = DDGCD5 AND                                      MD025077
     C**********                   DDGCS4 = DDGCS5                                          MD025077
     C                   IF        DDGCD1 = DDGCD5 OR                                       MD025077
     C                             DDGCD2 = DDGCD5 OR                                       MD025077
     C                             DDGCD3 = DDGCD5 OR                                       MD025077
     C                             DDGCD4 = DDGCD5                                          MD025077
     C                   MOVE      'N'           DDGCD5OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDGCD5'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      WERR = 'N'
     C                   IF        DDGCD1 <> *BLANKS
     C                   MOVE      'N'           DDGCD1OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDGCD2 <> *BLANKS
     C                   MOVE      'N'           DDGCD2OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDGCD3 <> *BLANKS
     C                   MOVE      'N'           DDGCD3OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDGCD4 <> *BLANKS
     C                   MOVE      'N'           DDGCD4OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDGCD5 <> *BLANKS
     C                   MOVE      'N'           DDGCD5OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        WERR = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'DDGCD1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0373'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        Idx = 0
     C                   EVAL      DFGCOV = DDGCOV
     C                   EVAL      DFGCD1 = DDGCD1
     C                   EVAL      DFGCD2 = DDGCD2
     C                   EVAL      DFGCD3 = DDGCD3
     C                   EVAL      DFGCD4 = DDGCD4
     C                   EVAL      DFGCD5 = DDGCD5
     C                   EVAL      DFGCS1 = DDGCS1
     C                   EVAL      DFGCS2 = DDGCS2
     C                   EVAL      DFGCS3 = DDGCS3
     C                   EVAL      DFGCS4 = DDGCS4
     C                   EVAL      DFGCS5 = DDGCS5
     C                   EVAL      DFGCCO = DDGCCO
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
 
      ** US Indicium of US Green Card - Override Value (Original)
     C                   PARM                    DDGCOVO           1
 
      ** US Indicium of US Green Card - Override Value
     C                   PARM                    DDGCOV            1
 
      ** Customer
     C                   PARM                    DDCUST           10
     C                   PARM                    DDRTYP            1
 
      ** US Indicium of US Country of Birth - Override Active Document
     C                   PARM                    DDGCD1            2
     C                   PARM                    DDGCD2            2
     C                   PARM                    DDGCD3            2
     C                   PARM                    DDGCD4            2
     C                   PARM                    DDGCD5            2
     C                   PARM                    DDGCS1
     C                   PARM                    DDGCS2
     C                   PARM                    DDGCS3
     C                   PARM                    DDGCS4
     C                   PARM                    DDGCS5
 
      ** US Indicium of US Green Card Comment
     C                   PARM                    DDGCC1
     C                   PARM                    DDGCC2
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** US Indicium of US Green Card - OK
     C                   PARM                    DDGCOVOK          1
     C                   PARM                    DDGCCOOK          1
     C                   PARM                    DDGCD1OK          1
     C                   PARM                    DDGCD2OK          1
     C                   PARM                    DDGCD3OK          1
     C                   PARM                    DDGCD4OK          1
     C                   PARM                    DDGCD5OK          1
 
     C                   PARM                    DFGCOV
     C                   PARM                    DFGCD1            2
     C                   PARM                    DFGCD2            2
     C                   PARM                    DFGCD3            2
     C                   PARM                    DFGCD4            2
     C                   PARM                    DFGCD5            2
     C                   PARM                    DFGCS1
     C                   PARM                    DFGCS2
     C                   PARM                    DFGCS3
     C                   PARM                    DFGCS4
     C                   PARM                    DFGCS5
     C                   PARM                    DFGCCO
 
     C     KDCMT         KLIST
     C                   KFLD                    KDCUST
     C                   KFLD                    KDRTYP
     C                   KFLD                    KDGCDD
     C                   KFLD                    KDGCSS
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2013
