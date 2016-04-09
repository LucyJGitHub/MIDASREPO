     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate US Indicium of US TIN')              *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVUSTIN - Validate US Indicium of US TIN                    *
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
 
     D DDTXC1          S             64A
     D DDTXC2          S             64A
     D DDTXCO          S            128A
     D DFTXOV          S              1A
     D DFTXCO          S            128A
     D DDTXS1          S              3S 0
     D DDTXS2          S              3S 0
     D DDTXS3          S              3S 0
     D DDTXS4          S              3S 0
     D DDTXS5          S              3S 0
     D DFTXS1          S              3S 0
     D DFTXS2          S              3S 0
     D DFTXS3          S              3S 0
     D DFTXS4          S              3S 0
     D DFTXS5          S              3S 0
     D WERR            S              1A
     D KDCUST          S             10A
     D KDRTYP          S              1A
     D KDTXDD          S              2A
     D KDTXSS          S              3S 0
 
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
     C                   MOVE      'Y'           DDTXOVOK
     C                   MOVE      'Y'           DDTXCOOK
     C                   MOVE      *BLANK        KDCUST
     C                   MOVEL     DDCUST        KDCUST
     C                   MOVE      DDRTYP        KDRTYP
 
     C                   IF        DDTXOV <> 'Y' AND
     C                             DDTXOV <> 'N' AND
     C                             DDTXOV <> ' '
 
     C                   MOVE      'N'           DDTXOVOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTXOV'      FldNamXAr(Idx)
     C                   MOVEL     'USS0155'     MsgIdXAr(Idx)
 
     C                   ENDIF
 
     C                   EVAL      DDTXCO = DDTXC1 + DDTXC2
 
     C                   IF        DDTXOVO <> DDTXOV AND
     C                             DDTXCO = *BLANKS AND
     C                             Idx = 0
                                                                                           MD027584B
     C                             OR (DDTXOV <> *BLANKS AND                               MD027584B
     C                             DDTXCO = *BLANKS AND                                    MD027584B
     C                             Idx = 0)                                                MD027584B
 
     C                   MOVE      'N'           DDTXCOOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTXCO'      FldNamXAr(Idx)
     C                   MOVEL     'USS0156'     MsgIdXAr(Idx)
 
     C                   ENDIF
 
     C                   IF        DDTXOV = 'Y' OR
     C                             DDTXOV = 'N'
 
     C                   IF        DDTXD1 = *BLANKS
     C                   IF        DDTXD2 <> *BLANKS OR
     C                             DDTXD3 <> *BLANKS OR
     C                             DDTXD4 <> *BLANKS OR
     C                             DDTXD5 <> *BLANKS
     C                   MOVE      'N'           DDTXD1OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTXD1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDTXD2 = *BLANKS
     C                   IF        DDTXD3 <> *BLANKS OR
     C                             DDTXD4 <> *BLANKS OR
     C                             DDTXD5 <> *BLANKS
     C                   MOVE      'N'           DDTXD2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTXD2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDTXD3 = *BLANKS
     C                   IF        DDTXD4 <> *BLANKS OR
     C                             DDTXD5 <> *BLANKS
     C                   MOVE      'N'           DDTXD3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTXD3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDTXD4 = *BLANKS
     C                   IF        DDTXD5 <> *BLANKS
     C                   MOVE      'N'           DDTXD4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTXD4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDTXD1 <> *BLANKS
     C                   MOVE      DDTXD1        KDTXDD
     C                   MOVE      DDTXS1        KDTXSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFTXD1 = DDTXD1
     C                   EVAL      DFTXS1 = DDTXS1
     C                   ELSE
 
     C                   MOVE      'N'           DDTXD1OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTXD1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDTXD1OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTXD1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDTXD2 <> *BLANKS
     C                   MOVE      DDTXD2        KDTXDD
     C                   MOVE      DDTXS2        KDTXSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFTXD2 = DDTXD2
     C                   EVAL      DFTXS2 = DDTXS2
     C                   ELSE
 
     C                   MOVE      'N'           DDTXD2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTXD2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDTXD2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTXD2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDTXD3 <> *BLANKS
     C                   MOVE      DDTXD3        KDTXDD
     C                   MOVE      DDTXS3        KDTXSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFTXD3 = DDTXD3
     C                   EVAL      DFTXS3 = DDTXS3
     C                   ELSE
 
     C                   MOVE      'N'           DDTXD3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTXD3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDTXD3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTXD3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDTXD4 <> *BLANKS
     C                   MOVE      DDTXD4        KDTXDD
     C                   MOVE      DDTXS4        KDTXSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFTXD4 = DDTXD4
     C                   EVAL      DFTXS4 = DDTXS4
     C                   ELSE
 
     C                   MOVE      'N'           DDTXD4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTXD4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDTXD4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTXD4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDTXD5 <> *BLANKS
     C                   MOVE      DDTXD5        KDTXDD
     C                   MOVE      DDTXS5        KDTXSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFTXD5 = DDTXD5
     C                   EVAL      DFTXS5 = DDTXS5
     C                   ELSE
 
     C                   MOVE      'N'           DDTXD5OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTXD5'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDTXD5OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTXD5'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDTXD2 <> '  '
     C**********         IF        DDTXD1 = DDTXD2 AND                                      MD025077
     C**********                   DDTXS1 = DDTXS2                                          MD025077
     C                   IF        DDTXD1 = DDTXD2                                          MD025077
     C                   MOVE      'N'           DDTXD2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTXD2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDTXD3 <> '  '
     C**********         IF        DDTXD1 = DDTXD3 AND                                      MD025077
     C**********                   DDTXS1 = DDTXS3 OR                                       MD025077
     C**********                   DDTXD2 = DDTXD3 AND                                      MD025077
     C**********                   DDTXS2 = DDTXS3                                          MD025077
     C                   IF        DDTXD1 = DDTXD3 OR                                       MD025077
     C                             DDTXD2 = DDTXD3                                          MD025077
     C                   MOVE      'N'           DDTXD3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTXD3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDTXD4 <> '  '
     C**********         IF        DDTXD1 = DDTXD4 AND                                      MD025077
     C**********                   DDTXS1 = DDTXS4 OR                                       MD025077
     C**********                   DDTXD2 = DDTXD4 AND                                      MD025077
     C**********                   DDTXS2 = DDTXS4 OR                                       MD025077
     C**********                   DDTXD3 = DDTXD4 AND                                      MD025077
     C**********                   DDTXS3 = DDTXS4                                          MD025077
     C                   IF        DDTXD1 = DDTXD4 OR                                       MD025077
     C                             DDTXD2 = DDTXD4 OR                                       MD025077
     C                             DDTXD3 = DDTXD4                                          MD025077
     C                   MOVE      'N'           DDTXD4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTXD4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDTXD5 <> '  '
     C**********         IF        DDTXD1 = DDTXD5 AND                                      MD025077
     C**********                   DDTXS1 = DDTXS5 OR                                       MD025077
     C**********                   DDTXD2 = DDTXD5 AND                                      MD025077
     C**********                   DDTXS2 = DDTXS5 OR                                       MD025077
     C**********                   DDTXD3 = DDTXD5 AND                                      MD025077
     C**********                   DDTXS3 = DDTXS5 OR                                       MD025077
     C**********                   DDTXD4 = DDTXD5 AND                                      MD025077
     C**********                   DDTXS4 = DDTXS5                                          MD025077
     C                   IF        DDTXD1 = DDTXD5 OR                                       MD025077
     C                             DDTXD2 = DDTXD5 OR                                       MD025077
     C                             DDTXD3 = DDTXD5 OR                                       MD025077
     C                             DDTXD4 = DDTXD5                                          MD025077
     C                   MOVE      'N'           DDTXD5OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTXD5'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      WERR = 'N'
     C                   IF        DDTXD1 <> *BLANKS
     C                   MOVE      'N'           DDTXD1OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDTXD2 <> *BLANKS
     C                   MOVE      'N'           DDTXD2OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDTXD3 <> *BLANKS
     C                   MOVE      'N'           DDTXD3OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDTXD4 <> *BLANKS
     C                   MOVE      'N'           DDTXD4OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDTXD5 <> *BLANKS
     C                   MOVE      'N'           DDTXD5OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        WERR = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'DDTXD1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0378'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        Idx = 0
     C                   EVAL      DFTXOV = DDTXOV
     C                   EVAL      DFTXD1 = DDTXD1
     C                   EVAL      DFTXD2 = DDTXD2
     C                   EVAL      DFTXD3 = DDTXD3
     C                   EVAL      DFTXD4 = DDTXD4
     C                   EVAL      DFTXD5 = DDTXD5
     C                   EVAL      DFTXS1 = DDTXS1
     C                   EVAL      DFTXS2 = DDTXS2
     C                   EVAL      DFTXS3 = DDTXS3
     C                   EVAL      DFTXS4 = DDTXS4
     C                   EVAL      DFTXS5 = DDTXS5
     C                   EVAL      DFTXCO = DDTXCO
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
 
      ** US Indicium of US TIN - Override Value (Original)
     C                   PARM                    DDTXOVO           1
 
      ** US Indicium of US TIN - Override Value
     C                   PARM                    DDTXOV            1
 
      ** Customer
     C                   PARM                    DDCUST           10
     C                   PARM                    DDRTYP            1
 
      ** US Indicium of US Country of Birth - Override Active Document
     C                   PARM                    DDTXD1            2
     C                   PARM                    DDTXD2            2
     C                   PARM                    DDTXD3            2
     C                   PARM                    DDTXD4            2
     C                   PARM                    DDTXD5            2
     C                   PARM                    DDTXS1
     C                   PARM                    DDTXS2
     C                   PARM                    DDTXS3
     C                   PARM                    DDTXS4
     C                   PARM                    DDTXS5
 
      ** US Indicium of US TIN Comment
     C                   PARM                    DDTXC1           64
     C                   PARM                    DDTXC2           64
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** US Indicium of US TIN - OK
     C                   PARM                    DDTXOVOK          1
     C                   PARM                    DDTXCOOK          1
     C                   PARM                    DDTXD1OK          1
     C                   PARM                    DDTXD2OK          1
     C                   PARM                    DDTXD3OK          1
     C                   PARM                    DDTXD4OK          1
     C                   PARM                    DDTXD5OK          1
 
     C                   PARM                    DFTXOV
     C                   PARM                    DFTXD1            2
     C                   PARM                    DFTXD2            2
     C                   PARM                    DFTXD3            2
     C                   PARM                    DFTXD4            2
     C                   PARM                    DFTXD5            2
     C                   PARM                    DFTXS1
     C                   PARM                    DFTXS2
     C                   PARM                    DFTXS3
     C                   PARM                    DFTXS4
     C                   PARM                    DFTXS5
     C                   PARM                    DFTXCO
 
     C     KDCMT         KLIST
     C                   KFLD                    KDCUST
     C                   KFLD                    KDRTYP
     C                   KFLD                    KDTXDD
     C                   KFLD                    KDTXSS
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2013
