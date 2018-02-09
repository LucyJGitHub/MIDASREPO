     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate US Indicium of Reg Payment Instr')   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVUSRPI - Validate US Indicium of Regular Payment           *
      *             Instructions to US                                *
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
 
     D DDRPC1          S             64A
     D DDRPC2          S             64A
     D DDRPCO          S            128A
     D DFRPOV          S              1A
     D DFRPCO          S            128A
     D DDRPS1          S              3S 0
     D DDRPS2          S              3S 0
     D DDRPS3          S              3S 0
     D DDRPS4          S              3S 0
     D DDRPS5          S              3S 0
     D DFRPS1          S              3S 0
     D DFRPS2          S              3S 0
     D DFRPS3          S              3S 0
     D DFRPS4          S              3S 0
     D DFRPS5          S              3S 0
     D WERR            S              1A
     D KDCUST          S             10A
     D KDRTYP          S              1A
     D KDRPDD          S              2A
     D KDRPSS          S              3S 0
 
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
     C                   MOVE      'Y'           DDRPOVOK
     C                   MOVE      'Y'           DDRPCOOK
     C                   MOVE      *BLANK        KDCUST
     C                   MOVEL     DDCUST        KDCUST
     C                   MOVE      DDRTYP        KDRTYP
 
     C                   IF        DDRPOV <> 'Y' AND
     C                             DDRPOV <> 'N' AND
     C                             DDRPOV <> ' '
 
     C                   MOVE      'N'           DDRPOVOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRPOV'      FldNamXAr(Idx)
     C                   MOVEL     'USS0153'     MsgIdXAr(Idx)
 
     C                   ENDIF
 
     C                   EVAL      DDRPCO = DDRPC1 + DDRPC2
 
     C                   IF        DDRPOVO <> DDRPOV AND
     C                             DDRPCO = *BLANKS AND
     C                             Idx = 0
                                                                                           MD027584B
     C                             OR (DDRPOV <> *BLANKS AND                               MD027584B
     C                             DDRPCO = *BLANKS AND                                    MD027584B
     C                             Idx = 0)                                                MD027584B
 
     C                   MOVE      'N'           DDRPCOOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRPCO'      FldNamXAr(Idx)
     C                   MOVEL     'USS0154'     MsgIdXAr(Idx)
 
     C                   ENDIF
 
     C                   IF        DDRPOV = 'Y' OR
     C                             DDRPOV = 'N'
 
     C                   IF        DDRPD1 = *BLANKS
     C                   IF        DDRPD2 <> *BLANKS OR
     C                             DDRPD3 <> *BLANKS OR
     C                             DDRPD4 <> *BLANKS OR
     C                             DDRPD5 <> *BLANKS
     C                   MOVE      'N'           DDRPD1OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRPD1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDRPD2 = *BLANKS
     C                   IF        DDRPD3 <> *BLANKS OR
     C                             DDRPD4 <> *BLANKS OR
     C                             DDRPD5 <> *BLANKS
     C                   MOVE      'N'           DDRPD2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRPD2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDRPD3 = *BLANKS
     C                   IF        DDRPD4 <> *BLANKS OR
     C                             DDRPD5 <> *BLANKS
     C                   MOVE      'N'           DDRPD3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRPD3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDRPD4 = *BLANKS
     C                   IF        DDRPD5 <> *BLANKS
     C                   MOVE      'N'           DDRPD4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRPD4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDRPD1 <> *BLANKS
     C                   MOVE      DDRPD1        KDRPDD
     C                   MOVE      DDRPS1        KDRPSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFRPD1 = DDRPD1
     C                   EVAL      DFRPS1 = DDRPS1
     C                   ELSE
 
     C                   MOVE      'N'           DDRPD1OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRPD1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDRPD1OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRPD1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDRPD2 <> *BLANKS
     C                   MOVE      DDRPD2        KDRPDD
     C                   MOVE      DDRPS2        KDRPSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFRPD2 = DDRPD2
     C                   EVAL      DFRPS2 = DDRPS2
     C                   ELSE
 
     C                   MOVE      'N'           DDRPD2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRPD2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDRPD2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRPD2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDRPD3 <> *BLANKS
     C                   MOVE      DDRPD3        KDRPDD
     C                   MOVE      DDRPS3        KDRPSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFRPD3 = DDRPD3
     C                   EVAL      DFRPS3 = DDRPS3
     C                   ELSE
 
     C                   MOVE      'N'           DDRPD3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRPD3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDRPD3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRPD3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDRPD4 <> *BLANKS
     C                   MOVE      DDRPD4        KDRPDD
     C                   MOVE      DDRPS4        KDRPSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFRPD4 = DDRPD4
     C                   EVAL      DFRPS4 = DDRPS4
     C                   ELSE
 
     C                   MOVE      'N'           DDRPD4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRPD4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDRPD4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRPD4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDRPD5 <> *BLANKS
     C                   MOVE      DDRPD5        KDRPDD
     C                   MOVE      DDRPS5        KDRPSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFRPD5 = DDRPD5
     C                   EVAL      DFRPS5 = DDRPS5
     C                   ELSE
 
     C                   MOVE      'N'           DDRPD5OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRPD5'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDRPD5OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRPD5'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDRPD2 <> '  '
     C**********         IF        DDRPD1 = DDRPD2 AND                                      MD025077
     C**********                   DDRPS1 = DDRPS2                                          MD025077
     C                   IF        DDRPD1 = DDRPD2                                          MD025077
     C                   MOVE      'N'           DDRPD2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRPD2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDRPD3 <> '  '
     C**********         IF        DDRPD1 = DDRPD3 AND                                      MD025077
     C**********                   DDRPS1 = DDRPS3 OR                                       MD025077
     C**********                   DDRPD2 = DDRPD3 AND                                      MD025077
     C**********                   DDRPS2 = DDRPS3                                          MD025077
     C                   IF        DDRPD1 = DDRPD3 OR                                       MD025077
     C                             DDRPD2 = DDRPD3                                          MD025077
     C                   MOVE      'N'           DDRPD3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRPD3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDRPD4 <> '  '
     C**********         IF        DDRPD1 = DDRPD4 AND                                      MD025077
     C**********                   DDRPS1 = DDRPS4 OR                                       MD025077
     C**********                   DDRPD2 = DDRPD4 AND                                      MD025077
     C**********                   DDRPS2 = DDRPS4 OR                                       MD025077
     C**********                   DDRPD3 = DDRPD4 AND                                      MD025077
     C**********                   DDRPS3 = DDRPS4                                          MD025077
     C                   IF        DDRPD1 = DDRPD4 OR                                       MD025077
     C                             DDRPD2 = DDRPD4 OR                                       MD025077
     C                             DDRPD3 = DDRPD4                                          MD025077
     C                   MOVE      'N'           DDRPD4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRPD4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDRPD5 <> '  '
     C**********         IF        DDRPD1 = DDRPD5 AND                                      MD025077
     C**********                   DDRPS1 = DDRPS5 OR                                       MD025077
     C**********                   DDRPD2 = DDRPD5 AND                                      MD025077
     C**********                   DDRPS2 = DDRPS5 OR                                       MD025077
     C**********                   DDRPD3 = DDRPD5 AND                                      MD025077
     C**********                   DDRPS3 = DDRPS5 OR                                       MD025077
     C**********                   DDRPD4 = DDRPD5 AND                                      MD025077
     C**********                   DDRPS4 = DDRPS5                                          MD025077
     C                   IF        DDRPD1 = DDRPD5 OR                                       MD025077
     C                             DDRPD2 = DDRPD5 OR                                       MD025077
     C                             DDRPD3 = DDRPD5 OR                                       MD025077
     C                             DDRPD4 = DDRPD5                                          MD025077
     C                   MOVE      'N'           DDRPD5OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRPD5'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      WERR = 'N'
     C                   IF        DDRPD1 <> *BLANKS
     C                   MOVE      'N'           DDRPD1OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDRPD2 <> *BLANKS
     C                   MOVE      'N'           DDRPD2OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDRPD3 <> *BLANKS
     C                   MOVE      'N'           DDRPD3OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDRPD4 <> *BLANKS
     C                   MOVE      'N'           DDRPD4OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDRPD5 <> *BLANKS
     C                   MOVE      'N'           DDRPD5OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        WERR = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'DDRPD1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0377'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        Idx = 0
     C                   EVAL      DFRPOV = DDRPOV
     C                   EVAL      DFRPD1 = DDRPD1
     C                   EVAL      DFRPD2 = DDRPD2
     C                   EVAL      DFRPD3 = DDRPD3
     C                   EVAL      DFRPD4 = DDRPD4
     C                   EVAL      DFRPD5 = DDRPD5
     C                   EVAL      DFRPS1 = DDRPS1
     C                   EVAL      DFRPS2 = DDRPS2
     C                   EVAL      DFRPS3 = DDRPS3
     C                   EVAL      DFRPS4 = DDRPS4
     C                   EVAL      DFRPS5 = DDRPS5
     C                   EVAL      DFRPCO = DDRPCO
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
 
      ** US Indicium of Reg Payment Inst to US - Override
      ** Value (Original)
     C                   PARM                    DDRPOVO           1
 
      ** US Indicium of Reg Payment Inst to US - Override Value
     C                   PARM                    DDRPOV            1
 
      ** Customer
     C                   PARM                    DDCUST           10
     C                   PARM                    DDRTYP            1
 
      ** US Indicium of US Country of Birth - Override Active Document
     C                   PARM                    DDRPD1            2
     C                   PARM                    DDRPD2            2
     C                   PARM                    DDRPD3            2
     C                   PARM                    DDRPD4            2
     C                   PARM                    DDRPD5            2
     C                   PARM                    DDRPS1
     C                   PARM                    DDRPS2
     C                   PARM                    DDRPS3
     C                   PARM                    DDRPS4
     C                   PARM                    DDRPS5
 
      ** US Indicium of Reg Payment Inst to US Comment
     C                   PARM                    DDRPC1
     C                   PARM                    DDRPC2
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** US Indicium of Reg Payment Inst to US - OK
     C                   PARM                    DDRPOVOK          1
     C                   PARM                    DDRPCOOK          1
     C                   PARM                    DDRPD1OK          1
     C                   PARM                    DDRPD2OK          1
     C                   PARM                    DDRPD3OK          1
     C                   PARM                    DDRPD4OK          1
     C                   PARM                    DDRPD5OK          1
 
     C                   PARM                    DFRPOV
     C                   PARM                    DFRPD1            2
     C                   PARM                    DFRPD2            2
     C                   PARM                    DFRPD3            2
     C                   PARM                    DFRPD4            2
     C                   PARM                    DFRPD5            2
     C                   PARM                    DFRPS1
     C                   PARM                    DFRPS2
     C                   PARM                    DFRPS3
     C                   PARM                    DFRPS4
     C                   PARM                    DFRPS5
     C                   PARM                    DFRPCO
 
     C     KDCMT         KLIST
     C                   KFLD                    KDCUST
     C                   KFLD                    KDRTYP
     C                   KFLD                    KDRPDD
     C                   KFLD                    KDRPSS
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2013
