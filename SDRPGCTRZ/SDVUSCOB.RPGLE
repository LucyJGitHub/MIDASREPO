     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate US Indicium of Country of Birth')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVUSCOB - Validate US Indicium of US Country of Birth       *
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
 
     D DDCBC1          S             64A
     D DDCBC2          S             64A
     D DDCBCO          S            128A
     D DFCBOV          S              1A
     D DFCBCO          S            128A
     D DDCBS1          S              3S 0
     D DDCBS2          S              3S 0
     D DDCBS3          S              3S 0
     D DDCBS4          S              3S 0
     D DDCBS5          S              3S 0
     D DFCBS1          S              3S 0
     D DFCBS2          S              3S 0
     D DFCBS3          S              3S 0
     D DFCBS4          S              3S 0
     D DFCBS5          S              3S 0
     D WERR            S              1A
     D KDCUST          S             10A
     D KDRTYP          S              1A
     D KDCBDD          S              2A
     D KDCBSS          S              3S 0
 
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
     C                   MOVE      'Y'           DDCBOVOK
     C                   MOVE      'Y'           DDCBCOOK
     C                   MOVE      *BLANK        KDCUST
     C                   MOVEL     DDCUST        KDCUST
     C                   MOVE      DDRTYP        KDRTYP
 
     C                   IF        DDCBOV <> 'Y' AND
     C                             DDCBOV <> 'N' AND
     C                             DDCBOV <> ' '
 
     C                   MOVE      'N'           DDCBOVOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCBOV'      FldNamXAr(Idx)
     C                   MOVEL     'USS0139'     MsgIdXAr(Idx)
 
     C                   ENDIF
 
     C                   EVAL      DDCBCO = DDCBC1 + DDCBC2
 
     C                   IF        DDCBOVO <> DDCBOV AND
     C                             DDCBCO = *BLANKS AND
     C                             Idx = 0
                                                                                           MD027584B
     C                             OR (DDCBOV <> *BLANKS AND                               MD027584B
     C                             DDCBCO = *BLANKS AND                                    MD027584B
     C                             Idx = 0)                                                MD027584B
 
     C                   MOVE      'N'           DDCBCOOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCBCO'      FldNamXAr(Idx)
     C                   MOVEL     'USS0140'     MsgIdXAr(Idx)
 
     C                   ENDIF
 
     C                   IF        DDCBOV = 'Y' OR
     C                             DDCBOV = 'N'
 
     C                   IF        DDCBD1 = *BLANKS
     C                   IF        DDCBD2 <> *BLANKS OR
     C                             DDCBD3 <> *BLANKS OR
     C                             DDCBD4 <> *BLANKS OR
     C                             DDCBD5 <> *BLANKS
     C                   MOVE      'N'           DDCBD1OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCBD1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDCBD2 = *BLANKS
     C                   IF        DDCBD3 <> *BLANKS OR
     C                             DDCBD4 <> *BLANKS OR
     C                             DDCBD5 <> *BLANKS
     C                   MOVE      'N'           DDCBD2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCBD2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDCBD3 = *BLANKS
     C                   IF        DDCBD4 <> *BLANKS OR
     C                             DDCBD5 <> *BLANKS
     C                   MOVE      'N'           DDCBD3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCBD3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDCBD4 = *BLANKS
     C                   IF        DDCBD5 <> *BLANKS
     C                   MOVE      'N'           DDCBD4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCBD4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDCBD1 <> *BLANKS
     C                   MOVE      DDCBD1        KDCBDD
     C                   MOVE      DDCBS1        KDCBSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFCBD1 = DDCBD1
     C                   EVAL      DFCBS1 = DDCBS1
     C                   ELSE
 
     C                   MOVE      'N'           DDCBD1OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCBD1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDCBD1OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCBD1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDCBD2 <> *BLANKS
     C                   MOVE      DDCBD2        KDCBDD
     C                   MOVE      DDCBS2        KDCBSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFCBD2 = DDCBD2
     C                   EVAL      DFCBS2 = DDCBS2
     C                   ELSE
 
     C                   MOVE      'N'           DDCBD2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCBD2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDCBD2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCBD2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDCBD3 <> *BLANKS
     C                   MOVE      DDCBD3        KDCBDD
     C                   MOVE      DDCBS3        KDCBSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFCBD3 = DDCBD3
     C                   EVAL      DFCBS3 = DDCBS3
     C                   ELSE
 
     C                   MOVE      'N'           DDCBD3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCBD3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDCBD3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCBD3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDCBD4 <> *BLANKS
     C                   MOVE      DDCBD4        KDCBDD
     C                   MOVE      DDCBS4        KDCBSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFCBD4 = DDCBD4
     C                   EVAL      DFCBS4 = DDCBS4
     C                   ELSE
 
     C                   MOVE      'N'           DDCBD4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCBD4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDCBD4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCBD4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDCBD5 <> *BLANKS
     C                   MOVE      DDCBD5        KDCBDD
     C                   MOVE      DDCBS5        KDCBSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFCBD5 = DDCBD5
     C                   EVAL      DFCBS5 = DDCBS5
     C                   ELSE
 
     C                   MOVE      'N'           DDCBD5OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCBD5'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDCBD5OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCBD5'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDCBD2 <> '  '
     C**********         IF        DDCBD1 = DDCBD2 AND                                      MD025077
     C**********                   DDCBS1 = DDCBS2                                          MD025077
     C                   IF        DDCBD1 = DDCBD2                                          MD025077
     C                   MOVE      'N'           DDCBD2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCBD2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDCBD3 <> '  '
     C**********         IF        DDCBD1 = DDCBD3 AND                                      MD025077
     C**********                   DDCBS1 = DDCBS3 OR                                       MD025077
     C**********                   DDCBD2 = DDCBD3 AND                                      MD025077
     C**********                   DDCBS2 = DDCBS3                                          MD025077
     C                   IF        DDCBD1 = DDCBD3 OR                                       MD025077
     C                             DDCBD2 = DDCBD3                                          MD025077
     C                   MOVE      'N'           DDCBD3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCBD3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDCBD4 <> '  '
     C**********         IF        DDCBD1 = DDCBD4 AND                                      MD025077
     C**********                   DDCBS1 = DDCBS4 OR                                       MD025077
     C**********                   DDCBD2 = DDCBD4 AND                                      MD025077
     C**********                   DDCBS2 = DDCBS4 OR                                       MD025077
     C**********                   DDCBD3 = DDCBD4 AND                                      MD025077
     C**********                   DDCBS3 = DDCBS4                                          MD025077
     C                   IF        DDCBD1 = DDCBD4 OR                                       MD025077
     C                             DDCBD2 = DDCBD4 OR                                       MD025077
     C                             DDCBD3 = DDCBD4                                          MD025077
     C                   MOVE      'N'           DDCBD4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCBD4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDCBD5 <> '  '
     C**********         IF        DDCBD1 = DDCBD5 AND                                      MD025077
     C**********                   DDCBS1 = DDCBS5 OR                                       MD025077
     C**********                   DDCBD2 = DDCBD5 AND                                      MD025077
     C**********                   DDCBS2 = DDCBS5 OR                                       MD025077
     C**********                   DDCBD3 = DDCBD5 AND                                      MD025077
     C**********                   DDCBS3 = DDCBS5 OR                                       MD025077
     C**********                   DDCBD4 = DDCBD5 AND                                      MD025077
     C**********                   DDCBS4 = DDCBS5                                          MD025077
     C                   IF        DDCBD1 = DDCBD5 OR                                       MD025077
     C                             DDCBD2 = DDCBD5 OR                                       MD025077
     C                             DDCBD3 = DDCBD5 OR                                       MD025077
     C                             DDCBD4 = DDCBD5                                          MD025077
     C                   MOVE      'N'           DDCBD5OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCBD5'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      WERR = 'N'
     C                   IF        DDCBD1 <> *BLANKS
     C                   MOVE      'N'           DDCBD1OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDCBD2 <> *BLANKS
     C                   MOVE      'N'           DDCBD2OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDCBD3 <> *BLANKS
     C                   MOVE      'N'           DDCBD3OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDCBD4 <> *BLANKS
     C                   MOVE      'N'           DDCBD4OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDCBD5 <> *BLANKS
     C                   MOVE      'N'           DDCBD5OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        WERR = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCBD1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0371'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        Idx = 0
     C                   EVAL      DFCBOV = DDCBOV
     C                   EVAL      DFCBD1 = DDCBD1
     C                   EVAL      DFCBD2 = DDCBD2
     C                   EVAL      DFCBD3 = DDCBD3
     C                   EVAL      DFCBD4 = DDCBD4
     C                   EVAL      DFCBD5 = DDCBD5
     C                   EVAL      DFCBS1 = DDCBS1
     C                   EVAL      DFCBS2 = DDCBS2
     C                   EVAL      DFCBS3 = DDCBS3
     C                   EVAL      DFCBS4 = DDCBS4
     C                   EVAL      DFCBS5 = DDCBS5
     C                   EVAL      DFCBCO = DDCBCO
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
 
      ** US Indicium of US Country of Birth - Override Value (Original)
     C                   PARM                    DDCBOVO           1
 
      ** US Indicium of US Country of Birth - Override Value
     C                   PARM                    DDCBOV            1
 
      ** Customer
     C                   PARM                    DDCUST           10
     C                   PARM                    DDRTYP            1
 
      ** US Indicium of US Country of Birth - Override Active Document
     C                   PARM                    DDCBD1            2
     C                   PARM                    DDCBD2            2
     C                   PARM                    DDCBD3            2
     C                   PARM                    DDCBD4            2
     C                   PARM                    DDCBD5            2
     C                   PARM                    DDCBS1
     C                   PARM                    DDCBS2
     C                   PARM                    DDCBS3
     C                   PARM                    DDCBS4
     C                   PARM                    DDCBS5
 
      ** US Indicium of US Country of Birth Comment
     C                   PARM                    DDCBC1
     C                   PARM                    DDCBC2
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** US Indicium of US Country of Birth - OK
     C                   PARM                    DDCBOVOK          1
     C                   PARM                    DDCBCOOK          1
     C                   PARM                    DDCBD1OK          1
     C                   PARM                    DDCBD2OK          1
     C                   PARM                    DDCBD3OK          1
     C                   PARM                    DDCBD4OK          1
     C                   PARM                    DDCBD5OK          1
 
     C                   PARM                    DFCBOV
     C                   PARM                    DFCBD1            2
     C                   PARM                    DFCBD2            2
     C                   PARM                    DFCBD3            2
     C                   PARM                    DFCBD4            2
     C                   PARM                    DFCBD5            2
     C                   PARM                    DFCBS1
     C                   PARM                    DFCBS2
     C                   PARM                    DFCBS3
     C                   PARM                    DFCBS4
     C                   PARM                    DFCBS5
     C                   PARM                    DFCBCO
 
     C     KDCMT         KLIST
     C                   KFLD                    KDCUST
     C                   KFLD                    KDRTYP
     C                   KFLD                    KDCBDD
     C                   KFLD                    KDCBSS
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2013
