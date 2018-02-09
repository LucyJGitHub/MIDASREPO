     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate US Indicium of Mailing Country')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVUSMAC - Validate US Indicia of Mailing Country            *
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
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
     D DDMCC1          S             64A
     D DDMCC2          S             64A
     D DDMCCO          S            128A
     D DFMCOV          S              1A
     D DFMCCO          S            128A
     D DDMCS1          S              3S 0
     D DDMCS2          S              3S 0
     D DDMCS3          S              3S 0
     D DDMCS4          S              3S 0
     D DDMCS5          S              3S 0
     D DFMCS1          S              3S 0
     D DFMCS2          S              3S 0
     D DFMCS3          S              3S 0
     D DFMCS4          S              3S 0
     D DFMCS5          S              3S 0
     D WERR            S              1A
     D KDCUST          S             10A
     D KDRTYP          S              1A
     D KDMCDD          S              2A
     D KDMCSS          S              3S 0
 
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
     C                   MOVE      'Y'           DDMCOVOK
     C                   MOVE      'Y'           DDMCCOOK
     C                   MOVE      *BLANK        KDCUST
     C                   MOVEL     DDCUST        KDCUST
     C                   MOVE      DDRTYP        KDRTYP
 
     C                   IF        DDMCOV <> 'Y' AND
     C                             DDMCOV <> 'N' AND
     C                             DDMCOV <> ' '
 
     C                   MOVE      'N'           DDMCOVOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMCOV'      FldNamXAr(Idx)
     C                   MOVEL     'USS0134'     MsgIdXAr(Idx)
 
     C                   ENDIF
 
     C                   EVAL      DDMCCO = DDMCC1 + DDMCC2
 
     C                   IF        DDMCOVO <> DDMCOV AND
     C                             DDMCCO = *BLANKS AND
     C                             Idx = 0
                                                                                           MD027584B
     C                             OR (DDMCOV <> *BLANKS AND                               MD027584B
     C                             DDMCCO = *BLANKS AND                                    MD027584B
     C                             Idx = 0)                                                MD027584B
 
     C                   MOVE      'N'           DDMCCOOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMCCO'      FldNamXAr(Idx)
     C                   MOVEL     'USS0135'     MsgIdXAr(Idx)
 
     C                   ENDIF
 
     C                   IF        DDMCOV = 'Y' OR
     C                             DDMCOV = 'N'
 
     C                   IF        DDMCD1 = *BLANKS
     C                   IF        DDMCD2 <> *BLANKS OR
     C                             DDMCD3 <> *BLANKS OR
     C                             DDMCD4 <> *BLANKS OR
     C                             DDMCD5 <> *BLANKS
     C                   MOVE      'N'           DDMCD1OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMCD1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDMCD2 = *BLANKS
     C                   IF        DDMCD3 <> *BLANKS OR
     C                             DDMCD4 <> *BLANKS OR
     C                             DDMCD5 <> *BLANKS
     C                   MOVE      'N'           DDMCD2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMCD2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDMCD3 = *BLANKS
     C                   IF        DDMCD4 <> *BLANKS OR
     C                             DDMCD5 <> *BLANKS
     C                   MOVE      'N'           DDMCD3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMCD3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDMCD4 = *BLANKS
     C                   IF        DDMCD5 <> *BLANKS
     C                   MOVE      'N'           DDMCD4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMCD4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDMCD1 <> *BLANKS
     C                   MOVE      DDMCD1        KDMCDD
     C                   MOVE      DDMCS1        KDMCSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFMCD1 = DDMCD1
     C                   EVAL      DFMCS1 = DDMCS1
     C                   ELSE
 
     C                   MOVE      'N'           DDMCD1OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMCD1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'Y'           DDMCD1OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMCD1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDMCD2 <> *BLANKS
     C                   MOVE      DDMCD2        KDMCDD
     C                   MOVE      DDMCS2        KDMCSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFMCD2 = DDMCD2
     C                   EVAL      DFMCS2 = DDMCS2
     C                   ELSE
 
     C                   MOVE      'N'           DDMCD2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMCD2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDMCD2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMCD2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDMCD3 <> *BLANKS
     C                   MOVE      DDMCD3        KDMCDD
     C                   MOVE      DDMCS3        KDMCSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFMCD3 = DDMCD3
     C                   EVAL      DFMCS3 = DDMCS3
     C                   ELSE
 
     C                   MOVE      'N'           DDMCD3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMCD3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDMCD3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMCD3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDMCD4 <> *BLANKS
     C                   MOVE      DDMCD4        KDMCDD
     C                   MOVE      DDMCS4        KDMCSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFMCD4 = DDMCD4
     C                   EVAL      DFMCS4 = DDMCS4
     C                   ELSE
 
     C                   MOVE      'N'           DDMCD4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMCD4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDMCD4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMCD4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDMCD5 <> *BLANKS
     C                   MOVE      DDMCD5        KDMCDD
     C                   MOVE      DDMCS5        KDMCSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFMCD5 = DDMCD5
     C                   EVAL      DFMCS5 = DDMCS5
     C                   ELSE
 
     C                   MOVE      'N'           DDMCD5OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMCD5'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDMCD5OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMCD5'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDMCD2 <> '  '
     C**********         IF        DDMCD1 = DDMCD2 AND                                      MD025077
     C**********                   DDMCS1 = DDMCS2                                          MD025077
     C                   IF        DDMCD1 = DDMCD2                                          MD025077
     C                   MOVE      'N'           DDMCD2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMCD2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDMCD3 <> '  '
     C**********         IF        DDMCD1 = DDMCD3 AND                                      MD025077
     C**********                   DDMCS1 = DDMCS3 OR                                       MD025077
     C**********                   DDMCD2 = DDMCD3 AND                                      MD025077
     C**********                   DDMCS2 = DDMCS3                                          MD025077
     C                   IF        DDMCD1 = DDMCD3 OR                                       MD025077
     C                             DDMCD2 = DDMCD3                                          MD025077
     C                   MOVE      'N'           DDMCD3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMCD3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDMCD4 <> '  '
     C**********         IF        DDMCD1 = DDMCD4 AND                                      MD025077
     C**********                   DDMCS1 = DDMCS4 OR                                       MD025077
     C**********                   DDMCD2 = DDMCD4 AND                                      MD025077
     C**********                   DDMCS2 = DDMCS4 OR                                       MD025077
     C**********                   DDMCD3 = DDMCD4 AND                                      MD025077
     C**********                   DDMCS3 = DDMCS4                                          MD025077
     C                   IF        DDMCD1 = DDMCD4 OR                                       MD025077
     C                             DDMCD2 = DDMCD4 OR                                       MD025077
     C                             DDMCD3 = DDMCD4                                          MD025077
     C                   MOVE      'N'           DDMCD4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMCD4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDMCD5 <> '  '
     C**********         IF        DDMCD1 = DDMCD5 AND                                      MD025077
     C**********                   DDMCS1 = DDMCS5 OR                                       MD025077
     C**********                   DDMCD2 = DDMCD5 AND                                      MD025077
     C**********                   DDMCS2 = DDMCS5 OR                                       MD025077
     C**********                   DDMCD3 = DDMCD5 AND                                      MD025077
     C**********                   DDMCS3 = DDMCS5 OR                                       MD025077
     C**********                   DDMCD4 = DDMCD5 AND                                      MD025077
     C**********                   DDMCS4 = DDMCS5                                          MD025077
     C                   IF        DDMCD1 = DDMCD5 OR                                       MD025077
     C                             DDMCD2 = DDMCD5 OR                                       MD025077
     C                             DDMCD3 = DDMCD5 OR                                       MD025077
     C                             DDMCD4 = DDMCD5                                          MD025077
     C                   MOVE      'N'           DDMCD5OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMCD5'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      WERR = 'N'
     C                   IF        DDMCD1 <> *BLANKS
     C                   MOVE      'N'           DDMCD1OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDMCD2 <> *BLANKS
     C                   MOVE      'N'           DDMCD2OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDMCD3 <> *BLANKS
     C                   MOVE      'N'           DDMCD3OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDMCD4 <> *BLANKS
     C                   MOVE      'N'           DDMCD4OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDMCD5 <> *BLANKS
     C                   MOVE      'N'           DDMCD5OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        WERR = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'DDMCD1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0369'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        Idx = 0
     C                   EVAL      DFMCOV = DDMCOV
     C                   EVAL      DFMCD1 = DDMCD1
     C                   EVAL      DFMCD2 = DDMCD2
     C                   EVAL      DFMCD3 = DDMCD3
     C                   EVAL      DFMCD4 = DDMCD4
     C                   EVAL      DFMCD5 = DDMCD5
     C                   EVAL      DFMCS1 = DDMCS1
     C                   EVAL      DFMCS2 = DDMCS2
     C                   EVAL      DFMCS3 = DDMCS3
     C                   EVAL      DFMCS4 = DDMCS4
     C                   EVAL      DFMCS5 = DDMCS5
     C                   EVAL      DFMCCO = DDMCCO
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
 
      ** US Indicium of Mailing Country - Override Value (Original)
     C                   PARM                    DDMCOVO           1
 
      ** US Indicium of Mailing Country - Override Value
     C                   PARM                    DDMCOV            1
 
      ** Customer
     C                   PARM                    DDCUST           10
     C                   PARM                    DDRTYP            1
 
      ** US Indicium of Mailing Country - Override Active Document
     C                   PARM                    DDMCD1            2
     C                   PARM                    DDMCD2            2
     C                   PARM                    DDMCD3            2
     C                   PARM                    DDMCD4            2
     C                   PARM                    DDMCD5            2
     C                   PARM                    DDMCS1
     C                   PARM                    DDMCS2
     C                   PARM                    DDMCS3
     C                   PARM                    DDMCS4
     C                   PARM                    DDMCS5
 
      ** US Indicium of Mailing Country Comment
     C                   PARM                    DDMCC1
     C                   PARM                    DDMCC2
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** US Indicium of Mailing Country - OK
     C                   PARM                    DDMCOVOK          1
 
      ** US Indicium of Mailing Country Comment - OK
     C                   PARM                    DDMCCOOK          1
     C                   PARM                    DDMCD1OK          1
     C                   PARM                    DDMCD2OK          1
     C                   PARM                    DDMCD3OK          1
     C                   PARM                    DDMCD4OK          1
     C                   PARM                    DDMCD5OK          1
 
     C                   PARM                    DFMCOV
     C                   PARM                    DFMCD1            2
     C                   PARM                    DFMCD2            2
     C                   PARM                    DFMCD3            2
     C                   PARM                    DFMCD4            2
     C                   PARM                    DFMCD5            2
     C                   PARM                    DFMCS1
     C                   PARM                    DFMCS2
     C                   PARM                    DFMCS3
     C                   PARM                    DFMCS4
     C                   PARM                    DFMCS5
     C                   PARM                    DFMCCO
 
     C     KDCMT         KLIST
     C                   KFLD                    KDCUST
     C                   KFLD                    KDRTYP
     C                   KFLD                    KDMCDD
     C                   KFLD                    KDMCSS
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2013
