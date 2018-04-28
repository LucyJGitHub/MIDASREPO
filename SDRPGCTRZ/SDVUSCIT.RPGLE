     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate US Indicium of US Citizenship')      *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVUSCIT - Validate US Indicia of US Citizenship             *
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
      *           - Apply fix MD25077                                 *
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
 
     D DDCIC1          S             64A
     D DDCIC2          S             64A
     D DDCICO          S            128A
     D DFCIOV          S              1A
     D DFCICO          S            128A
     D DDCIS1          S              3S 0
     D DDCIS2          S              3S 0
     D DDCIS3          S              3S 0
     D DDCIS4          S              3S 0
     D DDCIS5          S              3S 0
     D DFCIS1          S              3S 0
     D DFCIS2          S              3S 0
     D DFCIS3          S              3S 0
     D DFCIS4          S              3S 0
     D DFCIS5          S              3S 0
     D WERR            S              1A
     D KDCUST          S             10A
     D KDRTYP          S              1A
     D KDCIDD          S              2A
     D KDCISS          S              3S 0
 
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
     C                   MOVE      'Y'           DDCIOVOK
     C                   MOVE      'Y'           DDCICOOK
     C                   MOVE      *BLANK        KDCUST
     C                   MOVEL     DDCUST        KDCUST
     C                   MOVE      DDRTYP        KDRTYP
 
     C                   IF        DDCIOV <> 'Y' AND
     C                             DDCIOV <> 'N' AND
     C                             DDCIOV <> ' '
 
     C                   MOVE      'N'           DDCIOVOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCIOV'      FldNamXAr(Idx)
     C                   MOVEL     'USS0136'     MsgIdXAr(Idx)
 
     C                   ENDIF
 
     C                   EVAL      DDCICO = DDCIC1 + DDCIC2
 
     C                   IF        DDCIOVO <> DDCIOV AND
     C                             DDCICO = *BLANKS AND
     C                             Idx = 0
                                                                                           MD027584B
     C                             OR (DDCIOV <> *BLANKS AND                               MD027584B
     C                             DDCICO = *BLANKS AND                                    MD027584B
     C                             Idx = 0)                                                MD027584B
 
     C                   MOVE      'N'           DDCICOOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCICO'      FldNamXAr(Idx)
     C                   MOVEL     'USS0137'     MsgIdXAr(Idx)
 
     C                   ENDIF
 
     C                   IF        DDCIOV = 'Y' OR
     C                             DDCIOV = 'N'
 
     C                   IF        DDCID1 = *BLANKS
     C                   IF        DDCID2 <> *BLANKS OR
     C                             DDCID3 <> *BLANKS OR
     C                             DDCID4 <> *BLANKS OR
     C                             DDCID5 <> *BLANKS
     C                   MOVE      'N'           DDCID1OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCID1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDCID2 = *BLANKS
     C                   IF        DDCID3 <> *BLANKS OR
     C                             DDCID4 <> *BLANKS OR
     C                             DDCID5 <> *BLANKS
     C                   MOVE      'N'           DDCID2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCID2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDCID3 = *BLANKS
     C                   IF        DDCID4 <> *BLANKS OR
     C                             DDCID5 <> *BLANKS
     C                   MOVE      'N'           DDCID3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCID3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDCID4 = *BLANKS
     C                   IF        DDCID5 <> *BLANKS
     C                   MOVE      'N'           DDCID4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCID4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDCID1 <> *BLANKS
     C                   MOVE      DDCID1        KDCIDD
     C                   MOVE      DDCIS1        KDCISS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFCID1 = DDCID1
     C                   EVAL      DFCIS1 = DDCIS1
     C                   ELSE
 
     C                   MOVE      'N'           DDCID1OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCID1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDCID1OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCID1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDCID2 <> *BLANKS
     C                   MOVE      DDCID2        KDCIDD
     C                   MOVE      DDCIS2        KDCISS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFCID2 = DDCID2
     C                   EVAL      DFCIS2 = DDCIS2
     C                   ELSE
 
     C                   MOVE      'N'           DDCID2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCID2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDCID2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCID2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDCID3 <> *BLANKS
     C                   MOVE      DDCID3        KDCIDD
     C                   MOVE      DDCIS3        KDCISS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFCID3 = DDCID3
     C                   EVAL      DFCIS3 = DDCIS3
     C                   ELSE
 
     C                   MOVE      'N'           DDCID3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCID3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDCID3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCID3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDCID4 <> *BLANKS
     C                   MOVE      DDCID4        KDCIDD
     C                   MOVE      DDCIS4        KDCISS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFCID4 = DDCID4
     C                   EVAL      DFCIS4 = DDCIS4
     C                   ELSE
 
     C                   MOVE      'N'           DDCID4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCID4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDCID4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCID4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDCID5 <> *BLANKS
     C                   MOVE      DDCID5        KDCIDD
     C                   MOVE      DDCIS5        KDCISS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFCID5 = DDCID5
     C                   EVAL      DFCIS5 = DDCIS5
     C                   ELSE
 
     C                   MOVE      'N'           DDCID5OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCID5'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDCID5OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCID5'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDCID2 <> '  '
     C**********         IF        DDCID1 = DDCID2 AND                                      MD025077
     C**********                   DDCIS1 = DDCIS2                                          MD025077
     C                   IF        DDCID1 = DDCID2                                          MD025077
     C                   MOVE      'N'           DDCID2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCID2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDCID3 <> '  '
     C**********         IF        DDCID1 = DDCID3 AND                                      MD025077
     C**********                   DDCIS1 = DDCIS3 OR                                       MD025077
     C**********                   DDCID2 = DDCID3 AND                                      MD025077
     C**********                   DDCIS2 = DDCIS3                                          MD025077
     C                   IF        DDCID1 = DDCID3 OR                                       MD025077
     C                             DDCID2 = DDCID3                                          MD025077
     C                   MOVE      'N'           DDCID3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCID3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDCID4 <> '  '
     C**********         IF        DDCID1 = DDCID4 AND                                      MD025077
     C**********                   DDCIS1 = DDCIS4 OR                                       MD025077
     C**********                   DDCID2 = DDCID4 AND                                      MD025077
     C**********                   DDCIS2 = DDCIS4 OR                                       MD025077
     C**********                   DDCID3 = DDCID4 AND                                      MD025077
     C**********                   DDCIS3 = DDCIS4                                          MD025077
     C                   IF        DDCID1 = DDCID4 OR                                       MD025077
     C                             DDCID2 = DDCID4 OR                                       MD025077
     C                             DDCID3 = DDCID4                                          MD025077
     C                   MOVE      'N'           DDCID4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCID4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDCID5 <> '  '
     C**********         IF        DDCID1 = DDCID5 AND                                      MD025077
     C**********                   DDCIS1 = DDCIS5 OR                                       MD025077
     C**********                   DDCID2 = DDCID5 AND                                      MD025077
     C**********                   DDCIS2 = DDCIS5 OR                                       MD025077
     C**********                   DDCID3 = DDCID5 AND                                      MD025077
     C**********                   DDCIS3 = DDCIS5 OR                                       MD025077
     C**********                   DDCID4 = DDCID5 AND                                      MD025077
     C**********                   DDCIS4 = DDCIS5                                          MD025077
     C                   IF        DDCID1 = DDCID5 OR                                       MD025077
     C                             DDCID2 = DDCID5 OR                                       MD025077
     C                             DDCID3 = DDCID5 OR                                       MD025077
     C                             DDCID4 = DDCID5                                          MD025077
     C                   MOVE      'N'           DDCID5OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCID5'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      WERR = 'N'
     C                   IF        DDCID1 <> *BLANKS
     C                   MOVE      'N'           DDCID1OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDCID2 <> *BLANKS
     C                   MOVE      'N'           DDCID2OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDCID3 <> *BLANKS
     C                   MOVE      'N'           DDCID3OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDCID4 <> *BLANKS
     C                   MOVE      'N'           DDCID4OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDCID5 <> *BLANKS
     C                   MOVE      'N'           DDCID5OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        WERR = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCID1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0370'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        Idx = 0
     C                   EVAL      DFCIOV = DDCIOV
     C                   EVAL      DFCID1 = DDCID1
     C                   EVAL      DFCID2 = DDCID2
     C                   EVAL      DFCID3 = DDCID3
     C                   EVAL      DFCID4 = DDCID4
     C                   EVAL      DFCID5 = DDCID5
     C                   EVAL      DFCICO = DDCICO
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
 
      ** US Indicium of Citizenship - Override Value (Original)
     C                   PARM                    DDCIOVO           1
 
      ** US Indicium of Citizenship - Override Value
     C                   PARM                    DDCIOV            1
 
      ** Customer
     C                   PARM                    DDCUST           10
     C                   PARM                    DDRTYP            1
 
      ** US Indicium of Citizenship - Override Active Document
     C                   PARM                    DDCID1            2
     C                   PARM                    DDCID2            2
     C                   PARM                    DDCID3            2
     C                   PARM                    DDCID4            2
     C                   PARM                    DDCID5            2
     C                   PARM                    DDCIS1
     C                   PARM                    DDCIS2
     C                   PARM                    DDCIS3
     C                   PARM                    DDCIS4
     C                   PARM                    DDCIS5
 
      ** US Indicium of Citizenship Comment
     C                   PARM                    DDCIC1
     C                   PARM                    DDCIC2
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** US Indicium of Citizenship - OK
     C                   PARM                    DDCIOVOK          1
     C                   PARM                    DDCICOOK          1
     C                   PARM                    DDCID1OK          1
     C                   PARM                    DDCID2OK          1
     C                   PARM                    DDCID3OK          1
     C                   PARM                    DDCID4OK          1
     C                   PARM                    DDCID5OK          1
 
     C                   PARM                    DFCIOV
     C                   PARM                    DFCID1            2
     C                   PARM                    DFCID2            2
     C                   PARM                    DFCID3            2
     C                   PARM                    DFCID4            2
     C                   PARM                    DFCID5            2
     C                   PARM                    DFCIS1
     C                   PARM                    DFCIS2
     C                   PARM                    DFCIS3
     C                   PARM                    DFCIS4
     C                   PARM                    DFCIS5
     C                   PARM                    DFCICO
 
     C     KDCMT         KLIST
     C                   KFLD                    KDCUST
     C                   KFLD                    KDRTYP
     C                   KFLD                    KDCIDD
     C                   KFLD                    KDCISS
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2013
