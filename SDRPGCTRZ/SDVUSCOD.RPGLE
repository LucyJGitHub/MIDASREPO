     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate US Indicium of Country of Domici')   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVUSCOD - Validate US Indicium of US Country of Domicile    *
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
 
     D DDCDC1          S             64A
     D DDCDC2          S             64A
     D DDCDCO          S            128A
     D DFCDOV          S              1A
     D DFCDCO          S            128A
     D DDCDS1          S              3S 0
     D DDCDS2          S              3S 0
     D DDCDS3          S              3S 0
     D DDCDS4          S              3S 0
     D DDCDS5          S              3S 0
     D DFCDS1          S              3S 0
     D DFCDS2          S              3S 0
     D DFCDS3          S              3S 0
     D DFCDS4          S              3S 0
     D DFCDS5          S              3S 0
     D WERR            S              1A
     D KDCUST          S             10A
     D KDRTYP          S              1A
     D KDCDDD          S              2A
     D KDCDSS          S              3S 0
 
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
     C                   MOVE      'Y'           DDCDOVOK
     C                   MOVE      'Y'           DDCDCOOK
     C                   MOVE      *BLANK        KDCUST
     C                   MOVEL     DDCUST        KDCUST
     C                   MOVE      DDRTYP        KDRTYP
 
     C                   IF        DDCDOV <> 'Y' AND
     C                             DDCDOV <> 'N' AND
     C                             DDCDOV <> ' '
 
     C                   MOVE      'N'           DDCDOVOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCDOV'      FldNamXAr(Idx)
     C                   MOVEL     'USS0141'     MsgIdXAr(Idx)
 
     C                   ENDIF
 
     C                   EVAL      DDCDCO = DDCDC1 + DDCDC2
 
     C                   IF        DDCDOVO <> DDCDOV AND
     C                             DDCDCO = *BLANKS AND
     C                             Idx = 0
                                                                                           MD027584B
     C                             OR (DDCDOV <> *BLANKS AND                               MD027584B
     C                             DDCDCO = *BLANKS AND                                    MD027584B
     C                             Idx = 0)                                                MD027584B
 
     C                   MOVE      'N'           DDCDCOOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCDCO'      FldNamXAr(Idx)
     C                   MOVEL     'USS0142'     MsgIdXAr(Idx)
 
     C                   ENDIF
 
     C                   IF        DDCDOV = 'Y' OR
     C                             DDCDOV = 'N'
 
     C                   IF        DDCDD1 = *BLANKS
     C                   IF        DDCDD2 <> *BLANKS OR
     C                             DDCDD3 <> *BLANKS OR
     C                             DDCDD4 <> *BLANKS OR
     C                             DDCDD5 <> *BLANKS
     C                   MOVE      'N'           DDCDD1OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCDD1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDCDD2 = *BLANKS
     C                   IF        DDCDD3 <> *BLANKS OR
     C                             DDCDD4 <> *BLANKS OR
     C                             DDCDD5 <> *BLANKS
     C                   MOVE      'N'           DDCDD2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCDD2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDCDD3 = *BLANKS
     C                   IF        DDCDD4 <> *BLANKS OR
     C                             DDCDD5 <> *BLANKS
     C                   MOVE      'N'           DDCDD3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCDD3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDCDD4 = *BLANKS
     C                   IF        DDCDD5 <> *BLANKS
     C                   MOVE      'N'           DDCDD4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCDD4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDCDD1 <> *BLANKS
     C                   MOVE      DDCDD1        KDCDDD
     C                   MOVE      DDCDS1        KDCDSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFCDD1 = DDCDD1
     C                   EVAL      DFCDS1 = DDCDS1
     C                   ELSE
 
     C                   MOVE      'N'           DDCDD1OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCDD1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDCDD1OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCDD1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDCDD2 <> *BLANKS
     C                   MOVE      DDCDD2        KDCDDD
     C                   MOVE      DDCDS2        KDCDDD
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFCDD2 = DDCDD2
     C                   EVAL      DFCDS2 = DDCDS2
     C                   ELSE
 
     C                   MOVE      'N'           DDCDD2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCDD2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDCDD2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCDD2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDCDD3 <> *BLANKS
     C                   MOVE      DDCDD3        KDCDDD
     C                   MOVE      DDCDS3        KDCDSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFCDD3 = DDCDD3
     C                   EVAL      DFCDS3 = DDCDS3
     C                   ELSE
 
     C                   MOVE      'N'           DDCDD3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCDD3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDCDD3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCDD3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDCDD4 <> *BLANKS
     C                   MOVE      DDCDD4        KDCDDD
     C                   MOVE      DDCDS4        KDCDSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFCDD4 = DDCDD4
     C                   EVAL      DFCDS4 = DDCDS4
     C                   ELSE
 
     C                   MOVE      'N'           DDCDD4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCDD4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDCDD4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCDD4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDCDD5 <> *BLANKS
     C                   MOVE      DDCDD5        KDCDDD
     C                   MOVE      DDCDS5        KDCDSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFCDD5 = DDCDD5
     C                   EVAL      DFCDS5 = DDCDS5
     C                   ELSE
 
     C                   MOVE      'N'           DDCDD5OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCDD5'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDCDD5OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCDD5'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDCDD2 <> '  '
     C**********         IF        DDCDD1 = DDCDD2 AND                                      MD025077
     C**********                   DDCDS1 = DDCDS2                                          MD025077
     C                   IF        DDCDD1 = DDCDD2                                          MD025077
     C                   MOVE      'N'           DDCDD2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCDD2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDCDD3 <> '  '
     C**********         IF        DDCDD1 = DDCDD3 AND                                      MD025077
     C**********                   DDCDS1 = DDCDS3 OR                                       MD025077
     C**********                   DDCDD2 = DDCDD3 AND                                      MD025077
     C**********                   DDCDS2 = DDCDS3                                          MD025077
     C                   IF        DDCDD1 = DDCDD3 OR                                       MD025077
     C                             DDCDD2 = DDCDD3                                          MD025077
     C                   MOVE      'N'           DDCDD3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCDD3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDCDD4 <> '  '
     C**********         IF        DDCDD1 = DDCDD4 AND                                      MD025077
     C**********                   DDCDS1 = DDCDS4 OR                                       MD025077
     C**********                   DDCDD2 = DDCDD4 AND                                      MD025077
     C**********                   DDCDS2 = DDCDS4 OR                                       MD025077
     C**********                   DDCDD3 = DDCDD4 AND                                      MD025077
     C**********                   DDCDS3 = DDCDS4                                          MD025077
     C                   IF        DDCDD1 = DDCDD4 OR                                       MD025077
     C                             DDCDD2 = DDCDD4 OR                                       MD025077
     C                             DDCDD3 = DDCDD4                                          MD025077
     C                   MOVE      'N'           DDCDD4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCDD4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDCDD5 <> '  '
     C**********         IF        DDCDD1 = DDCDD5 AND                                      MD025077
     C**********                   DDCDS1 = DDCDS5 OR                                       MD025077
     C**********                   DDCDD2 = DDCDD5 AND                                      MD025077
     C**********                   DDCDS2 = DDCDS5 OR                                       MD025077
     C**********                   DDCDD3 = DDCDD5 AND                                      MD025077
     C**********                   DDCDS3 = DDCDS5 OR                                       MD025077
     C**********                   DDCDD4 = DDCDD5 AND                                      MD025077
     C**********                   DDCDS4 = DDCDS5                                          MD025077
     C                   IF        DDCDD1 = DDCDD5 OR                                       MD025077
     C                             DDCDD2 = DDCDD5 OR                                       MD025077
     C                             DDCDD3 = DDCDD5 OR                                       MD025077
     C                             DDCDD4 = DDCDD5                                          MD025077
     C                   MOVE      'N'           DDCDD5OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCDD5'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      WERR = 'N'
     C                   IF        DDCDD1 <> *BLANKS
     C                   MOVE      'N'           DDCDD1OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDCDD2 <> *BLANKS
     C                   MOVE      'N'           DDCDD2OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDCDD3 <> *BLANKS
     C                   MOVE      'N'           DDCDD3OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDCDD4 <> *BLANKS
     C                   MOVE      'N'           DDCDD4OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDCDD5 <> *BLANKS
     C                   MOVE      'N'           DDCDD5OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        WERR = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCDD1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0372'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        Idx = 0
     C                   EVAL      DFCDOV = DDCDOV
     C                   EVAL      DFCDD1 = DDCDD1
     C                   EVAL      DFCDD2 = DDCDD2
     C                   EVAL      DFCDD3 = DDCDD3
     C                   EVAL      DFCDD4 = DDCDD4
     C                   EVAL      DFCDD5 = DDCDD5
     C                   EVAL      DFCDS1 = DDCDS1
     C                   EVAL      DFCDS2 = DDCDS2
     C                   EVAL      DFCDS3 = DDCDS3
     C                   EVAL      DFCDS4 = DDCDS4
     C                   EVAL      DFCDS5 = DDCDS5
     C                   EVAL      DFCDCO = DDCDCO
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
 
      ** US Indicium of US Country of Domicile - Override Value
      ** (Original)
     C                   PARM                    DDCDOVO           1
 
      ** US Indicium of US Country of Domicile - Override Value
     C                   PARM                    DDCDOV            1
 
      ** Customer
     C                   PARM                    DDCUST           10
     C                   PARM                    DDRTYP            1
 
      ** US Indicium of US Country of Domicile - Override Active Document
     C                   PARM                    DDCDD1            2
     C                   PARM                    DDCDD2            2
     C                   PARM                    DDCDD3            2
     C                   PARM                    DDCDD4            2
     C                   PARM                    DDCDD5            2
     C                   PARM                    DDCDS1
     C                   PARM                    DDCDS2
     C                   PARM                    DDCDS3
     C                   PARM                    DDCDS4
     C                   PARM                    DDCDS5
 
      ** US Indicium of US Country of Domicile Comment
     C                   PARM                    DDCDC1
     C                   PARM                    DDCDC2
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** US Indicium of US Country of Domicile - OK
     C                   PARM                    DDCDOVOK          1
     C                   PARM                    DDCDCOOK          1
     C                   PARM                    DDCDD1OK          1
     C                   PARM                    DDCDD2OK          1
     C                   PARM                    DDCDD3OK          1
     C                   PARM                    DDCDD4OK          1
     C                   PARM                    DDCDD5OK          1
 
     C                   PARM                    DFCDOV
     C                   PARM                    DFCDD1            2
     C                   PARM                    DFCDD2            2
     C                   PARM                    DFCDD3            2
     C                   PARM                    DFCDD4            2
     C                   PARM                    DFCDD5            2
     C                   PARM                    DFCDS1
     C                   PARM                    DFCDS2
     C                   PARM                    DFCDS3
     C                   PARM                    DFCDS4
     C                   PARM                    DFCDS5
     C                   PARM                    DFCDCO
 
     C     KDCMT         KLIST
     C                   KFLD                    KDCUST
     C                   KFLD                    KDRTYP
     C                   KFLD                    KDCDDD
     C                   KFLD                    KDCDSS
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2013
