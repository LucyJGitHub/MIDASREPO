     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate US Indicium of US Identity Doc')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVUSIDD - Validate US Indicium of US Identity Document      *
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
 
     D DDIDC1          S             64A
     D DDIDC2          S             64A
     D DDIDCO          S            128A
     D DFIDOV          S              1A
     D DFIDCO          S            128A
     D DDIDS1          S              3S 0
     D DDIDS2          S              3S 0
     D DDIDS3          S              3S 0
     D DDIDS4          S              3S 0
     D DDIDS5          S              3S 0
     D DFIDS1          S              3S 0
     D DFIDS2          S              3S 0
     D DFIDS3          S              3S 0
     D DFIDS4          S              3S 0
     D DFIDS5          S              3S 0
     D WERR            S              1A
     D KDCUST          S             10A
     D KDRTYP          S              1A
     D KDIDDD          S              2A
     D KDIDSS          S              3S 0
 
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
     C                   MOVE      'Y'           DDIDOVOK
     C                   MOVE      'Y'           DDIDCOOK
     C                   MOVE      *BLANK        KDCUST
     C                   MOVEL     DDCUST        KDCUST
     C                   MOVE      DDRTYP        KDRTYP
 
     C                   IF        DDIDOV <> 'Y' AND
     C                             DDIDOV <> 'N' AND
     C                             DDIDOV <> ' '
 
     C                   MOVE      'N'           DDIDOVOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDIDOV'      FldNamXAr(Idx)
     C                   MOVEL     'USS0149'     MsgIdXAr(Idx)
 
     C                   ENDIF
 
     C                   EVAL      DDIDCO = DDIDC1 + DDIDC2
 
     C                   IF        DDIDOVO <> DDIDOV AND
     C                             DDIDCO = *BLANKS AND
     C                             Idx = 0
                                                                                           MD027584B
     C                             OR (DDIDOV <> *BLANKS AND                               MD027584B
     C                             DDIDCO = *BLANKS AND                                    MD027584B
     C                             Idx = 0)                                                MD027584B
 
     C                   MOVE      'N'           DDIDCOOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDIDCO'      FldNamXAr(Idx)
     C                   MOVEL     'USS0150'     MsgIdXAr(Idx)
 
     C                   ENDIF
 
     C                   IF        DDIDOV = 'Y' OR
     C                             DDIDOV = 'N'
 
     C                   IF        DDIDD1 = *BLANKS
     C                   IF        DDIDD2 <> *BLANKS OR
     C                             DDIDD3 <> *BLANKS OR
     C                             DDIDD4 <> *BLANKS OR
     C                             DDIDD5 <> *BLANKS
     C                   MOVE      'N'           DDIDD1OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDIDD1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDIDD2 = *BLANKS
     C                   IF        DDIDD3 <> *BLANKS OR
     C                             DDIDD4 <> *BLANKS OR
     C                             DDIDD5 <> *BLANKS
     C                   MOVE      'N'           DDIDD2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDIDD2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDIDD3 = *BLANKS
     C                   IF        DDIDD4 <> *BLANKS OR
     C                             DDIDD5 <> *BLANKS
     C                   MOVE      'N'           DDIDD3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDIDD3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDIDD4 = *BLANKS
     C                   IF        DDIDD5 <> *BLANKS
     C                   MOVE      'N'           DDIDD4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDIDD4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDIDD1 <> *BLANKS
     C                   MOVE      DDIDD1        KDIDDD
     C                   MOVE      DDIDS1        KDIDSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFIDD1 = DDIDD1
     C                   EVAL      DFIDS1 = DDIDS1
     C                   ELSE
 
     C                   MOVE      'N'           DDIDD1OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDIDD1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDIDD1OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDIDD1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDIDD2 <> *BLANKS
     C                   MOVE      DDIDD2        KDIDDD
     C                   MOVE      DDIDS2        KDIDSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFIDD2 = DDIDD2
     C                   EVAL      DFIDS2 = DDIDS2
     C                   ELSE
 
     C                   MOVE      'N'           DDIDD2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDIDD2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDIDD2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDIDD2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDIDD3 <> *BLANKS
     C                   MOVE      DDIDD3        KDIDDD
     C                   MOVE      DDIDS3        KDIDSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFIDD3 = DDIDD3
     C                   EVAL      DFIDS3 = DDIDS3
     C                   ELSE
 
     C                   MOVE      'N'           DDIDD3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDIDD3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDIDD3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDIDD3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDIDD4 <> *BLANKS
     C                   MOVE      DDIDD4        KDIDDD
     C                   MOVE      DDIDS4        KDIDSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFIDD4 = DDIDD4
     C                   EVAL      DFIDS4 = DDIDS4
     C                   ELSE
 
     C                   MOVE      'N'           DDIDD4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDIDD4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDIDD4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDIDD4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDIDD5 <> *BLANKS
     C                   MOVE      DDIDD5        KDIDDD
     C                   MOVE      DDIDS5        KDIDSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFIDD5 = DDIDD5
     C                   EVAL      DFIDS5 = DDIDS5
     C                   ELSE
 
     C                   MOVE      'N'           DDIDD5OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDIDD5'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDIDD5OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDIDD5'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDIDD2 <> '  '
     C**********         IF        DDIDD1 = DDIDD2 AND                                      MD025077
     C**********                   DDIDS1 = DDIDS2                                          MD025077
     C                   IF        DDIDD1 = DDIDD2                                          MD025077
     C                   MOVE      'N'           DDIDD2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDIDD2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDIDD3 <> '  '
     C**********         IF        DDIDD1 = DDIDD3 AND                                      MD025077
     C**********                   DDIDS1 = DDIDS3 OR                                       MD025077
     C**********                   DDIDD2 = DDIDD3 AND                                      MD025077
     C**********                   DDIDS2 = DDIDS3                                          MD025077
     C                   IF        DDIDD1 = DDIDD3 OR                                       MD025077
     C                             DDIDD2 = DDIDD3                                          MD025077
     C                   MOVE      'N'           DDIDD3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDIDD3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDIDD4 <> '  '
     C**********         IF        DDIDD1 = DDIDD4 AND                                      MD025077
     C**********                   DDIDS1 = DDIDS4 OR                                       MD025077
     C**********                   DDIDD2 = DDIDD4 AND                                      MD025077
     C**********                   DDIDS2 = DDIDS4 OR                                       MD025077
     C**********                   DDIDD3 = DDIDD4 AND                                      MD025077
     C**********                   DDIDS3 = DDIDS4                                          MD025077
     C                   IF        DDIDD1 = DDIDD4 OR                                       MD025077
     C                             DDIDD2 = DDIDD4 OR                                       MD025077
     C                             DDIDD3 = DDIDD4                                          MD025077
     C                   MOVE      'N'           DDIDD4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDIDD4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDIDD5 <> '  '
     C**********         IF        DDIDD1 = DDIDD5 AND                                      MD025077
     C**********                   DDIDS1 = DDIDS5 OR                                       MD025077
     C**********                   DDIDD2 = DDIDD5 AND                                      MD025077
     C**********                   DDIDS2 = DDIDS5 OR                                       MD025077
     C**********                   DDIDD3 = DDIDD5 AND                                      MD025077
     C**********                   DDIDS3 = DDIDS5 OR                                       MD025077
     C**********                   DDIDD4 = DDIDD5 AND                                      MD025077
     C**********                   DDIDS4 = DDIDS5                                          MD025077
     C                   IF        DDIDD1 = DDIDD5 OR                                       MD025077
     C                             DDIDD2 = DDIDD5 OR                                       MD025077
     C                             DDIDD3 = DDIDD5 OR                                       MD025077
     C                             DDIDD4 = DDIDD5                                          MD025077
     C                   MOVE      'N'           DDIDD5OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDIDD5'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      WERR = 'N'
     C                   IF        DDIDD1 <> *BLANKS
     C                   MOVE      'N'           DDIDD1OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDIDD2 <> *BLANKS
     C                   MOVE      'N'           DDIDD2OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDIDD3 <> *BLANKS
     C                   MOVE      'N'           DDIDD3OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDIDD4 <> *BLANKS
     C                   MOVE      'N'           DDIDD4OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDIDD5 <> *BLANKS
     C                   MOVE      'N'           DDIDD5OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        WERR = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'DDIDD1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0375'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        Idx = 0
     C                   EVAL      DFIDOV = DDIDOV
     C                   EVAL      DFIDD1 = DDIDD1
     C                   EVAL      DFIDD2 = DDIDD2
     C                   EVAL      DFIDD3 = DDIDD3
     C                   EVAL      DFIDD4 = DDIDD4
     C                   EVAL      DFIDD5 = DDIDD5
     C                   EVAL      DFIDS1 = DDIDS1
     C                   EVAL      DFIDS2 = DDIDS2
     C                   EVAL      DFIDS3 = DDIDS3
     C                   EVAL      DFIDS4 = DDIDS4
     C                   EVAL      DFIDS5 = DDIDS5
     C                   EVAL      DFIDCO = DDIDCO
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
 
      ** US Indicium of US Identity Document - Override Value
      ** (Original)
     C                   PARM                    DDIDOVO           1
 
      ** US Indicium of US Identity Document - Override Value
     C                   PARM                    DDIDOV            1
 
      ** Customer
     C                   PARM                    DDCUST           10
     C                   PARM                    DDRTYP            1
 
      ** US Indicium of US Country of Birth - Override Active Document
     C                   PARM                    DDIDD1            2
     C                   PARM                    DDIDD2            2
     C                   PARM                    DDIDD3            2
     C                   PARM                    DDIDD4            2
     C                   PARM                    DDIDD5            2
     C                   PARM                    DDIDS1
     C                   PARM                    DDIDS2
     C                   PARM                    DDIDS3
     C                   PARM                    DDIDS4
     C                   PARM                    DDIDS5
 
      ** US Indicium of US Identity Document Comment
     C                   PARM                    DDIDC1
     C                   PARM                    DDIDC2
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** US Indicium of US Identity Document - OK
     C                   PARM                    DDIDOVOK          1
     C                   PARM                    DDIDCOOK          1
     C                   PARM                    DDIDD1OK          1
     C                   PARM                    DDIDD2OK          1
     C                   PARM                    DDIDD3OK          1
     C                   PARM                    DDIDD4OK          1
     C                   PARM                    DDIDD5OK          1
 
     C                   PARM                    DFIDOV
     C                   PARM                    DFIDD1            2
     C                   PARM                    DFIDD2            2
     C                   PARM                    DFIDD3            2
     C                   PARM                    DFIDD4            2
     C                   PARM                    DFIDD5            2
     C                   PARM                    DFIDS1
     C                   PARM                    DFIDS2
     C                   PARM                    DFIDS3
     C                   PARM                    DFIDS4
     C                   PARM                    DFIDS5
     C                   PARM                    DFIDCO
 
     C     KDCMT         KLIST
     C                   KFLD                    KDCUST
     C                   KFLD                    KDRTYP
     C                   KFLD                    KDIDDD
     C                   KFLD                    KDIDSS
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2013
