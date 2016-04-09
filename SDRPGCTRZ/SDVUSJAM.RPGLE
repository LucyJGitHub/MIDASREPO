     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate US Indicium of Joint Acnt Member')   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVUSJAM - Validate US Indicium of US Joint Account Member   *
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
 
     D DDJAC1          S             64A
     D DDJAC2          S             64A
     D DDJACO          S            128A
     D DFJAOV          S              1A
     D DFJACO          S            128A
     D DDJAS1          S              3S 0
     D DDJAS2          S              3S 0
     D DDJAS3          S              3S 0
     D DDJAS4          S              3S 0
     D DDJAS5          S              3S 0
     D DFJAS1          S              3S 0
     D DFJAS2          S              3S 0
     D DFJAS3          S              3S 0
     D DFJAS4          S              3S 0
     D DFJAS5          S              3S 0
     D WERR            S              1A
     D KDCUST          S             10A
     D KDRTYP          S              1A
     D KDJADD          S              2A
     D KDJASS          S              3S 0
 
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
     C                   MOVE      *BLANK        MsgIdXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   MOVE      'Y'           DDJAOVOK
     C                   MOVE      'Y'           DDJACOOK
     C                   MOVE      *BLANK        KDCUST
     C                   MOVEL     DDCUST        KDCUST
     C                   MOVE      DDRTYP        KDRTYP
 
     C                   IF        DDJAOV <> 'Y' AND
     C                             DDJAOV <> 'N' AND
     C                             DDJAOV <> ' '
 
     C                   MOVE      'N'           DDJAOVOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDJAOV'      FldNamXAr(Idx)
     C                   MOVEL     'USS0151'     MsgIdXAr(Idx)
 
     C                   ENDIF
 
     C                   EVAL      DDJACO = DDJAC1 + DDJAC2
 
     C                   IF        DDJAOVO <> DDJAOV AND
     C                             DDJACO = *BLANKS AND
     C                             Idx = 0
                                                                                           MD027584B
     C                             OR (DDJAOV <> *BLANKS AND                               MD027584B
     C                             DDJACO = *BLANKS AND                                    MD027584B
     C                             Idx = 0)                                                MD027584B
 
     C                   MOVE      'N'           DDJACOOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDJACO'      FldNamXAr(Idx)
     C                   MOVEL     'USS0152'     MsgIdXAr(Idx)
 
     C                   ENDIF
 
     C                   IF        DDJAOV = 'Y' OR
     C                             DDJAOV = 'N'
 
     C                   IF        DDJAD1 = *BLANKS
     C                   IF        DDJAD2 <> *BLANKS OR
     C                             DDJAD3 <> *BLANKS OR
     C                             DDJAD4 <> *BLANKS OR
     C                             DDJAD5 <> *BLANKS
     C                   MOVE      'N'           DDJAD1OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDJAD1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDJAD2 = *BLANKS
     C                   IF        DDJAD3 <> *BLANKS OR
     C                             DDJAD4 <> *BLANKS OR
     C                             DDJAD5 <> *BLANKS
     C                   MOVE      'N'           DDJAD2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDJAD2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDJAD3 = *BLANKS
     C                   IF        DDJAD4 <> *BLANKS OR
     C                             DDJAD5 <> *BLANKS
     C                   MOVE      'N'           DDJAD3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDJAD3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDJAD4 = *BLANKS
     C                   IF        DDJAD5 <> *BLANKS
     C                   MOVE      'N'           DDJAD4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDJAD4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDJAD1 <> *BLANKS
     C                   MOVE      DDJAD1        KDJADD
     C                   MOVE      DDJAS1        KDJASS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFJAD1 = DDJAD1
     C                   EVAL      DFJAS1 = DDJAS1
     C                   ELSE
 
     C                   MOVE      'N'           DDJAD1OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDJAD1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDJAD1OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDJAD1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDJAD2 <> *BLANKS
     C                   MOVE      DDJAD2        KDJADD
     C                   MOVE      DDJAS2        KDJASS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFJAD2 = DDJAD2
     C                   EVAL      DFJAS2 = DDJAS2
     C                   ELSE
 
     C                   MOVE      'N'           DDJAD2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDJAD2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDJAD2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDJAD2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDJAD3 <> *BLANKS
     C                   MOVE      DDJAD3        KDJADD
     C                   MOVE      DDJAS3        KDJASS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFJAD3 = DDJAD3
     C                   EVAL      DFJAS3 = DDJAS3
     C                   ELSE
 
     C                   MOVE      'N'           DDJAD3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDJAD3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDJAD3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDJAD3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDJAD4 <> *BLANKS
     C                   MOVE      DDJAD4        KDJADD
     C                   MOVE      DDJAS4        KDJASS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFJAD4 = DDJAD4
     C                   EVAL      DFJAS4 = DDJAS4
     C                   ELSE
 
     C                   MOVE      'N'           DDJAD4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDJAD4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDJAD4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDJAD4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDJAD5 <> *BLANKS
     C                   MOVE      DDJAD5        KDJADD
     C                   MOVE      DDJAS5        KDJASS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFJAD5 = DDJAD5
     C                   EVAL      DFJAS5 = DDJAS5
     C                   ELSE
 
     C                   MOVE      'N'           DDJAD5OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDJAD5'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDJAD5OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDJAD5'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDJAD2 <> '  '
     C**********         IF        DDJAD1 = DDJAD2 AND                                      MD025077
     C**********                   DDJAS1 = DDJAS2                                          MD025077
     C                   IF        DDJAD1 = DDJAD2                                          MD025077
     C                   MOVE      'N'           DDJAD2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDJAD2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDJAD3 <> '  '
     C**********         IF        DDJAD1 = DDJAD3 AND                                      MD025077
     C**********                   DDJAS1 = DDJAS3 OR                                       MD025077
     C**********                   DDJAD2 = DDJAD3 AND                                      MD025077
     C**********                   DDJAS2 = DDJAS3                                          MD025077
     C                   IF        DDJAD1 = DDJAD3 OR                                       MD025077
     C                             DDJAD2 = DDJAD3                                          MD025077
     C                   MOVE      'N'           DDJAD3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDJAD3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDJAD4 <> '  '
     C**********         IF        DDJAD1 = DDJAD4 AND                                      MD025077
     C**********                   DDJAS1 = DDJAS4 OR                                       MD025077
     C**********                   DDJAD2 = DDJAD4 AND                                      MD025077
     C**********                   DDJAS2 = DDJAS4 OR                                       MD025077
     C**********                   DDJAD3 = DDJAD4 AND                                      MD025077
     C**********                   DDJAS3 = DDJAS4                                          MD025077
     C                   IF        DDJAD1 = DDJAD4 OR                                       MD025077
     C                             DDJAD2 = DDJAD4 OR                                       MD025077
     C                             DDJAD3 = DDJAD4                                          MD025077
     C                   MOVE      'N'           DDJAD4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDJAD4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDJAD5 <> '  '
     C**********         IF        DDJAD1 = DDJAD5 AND                                      MD025077
     C**********                   DDJAS1 = DDJAS5 OR                                       MD025077
     C**********                   DDJAD2 = DDJAD5 AND                                      MD025077
     C**********                   DDJAS2 = DDJAS5 OR                                       MD025077
     C**********                   DDJAD3 = DDJAD5 AND                                      MD025077
     C**********                   DDJAS3 = DDJAS5 OR                                       MD025077
     C**********                   DDJAD4 = DDJAD5 AND                                      MD025077
     C**********                   DDJAS4 = DDJAS5                                          MD025077
     C                   IF        DDJAD1 = DDJAD5 OR                                       MD025077
     C                             DDJAD2 = DDJAD5 OR                                       MD025077
     C                             DDJAD3 = DDJAD5 OR                                       MD025077
     C                             DDJAD4 = DDJAD5                                          MD025077
     C                   MOVE      'N'           DDJAD5OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDJAD5'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      WERR = 'N'
     C                   IF        DDJAD1 <> *BLANKS
     C                   MOVE      'N'           DDJAD1OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDJAD2 <> *BLANKS
     C                   MOVE      'N'           DDJAD2OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDJAD3 <> *BLANKS
     C                   MOVE      'N'           DDJAD3OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDJAD4 <> *BLANKS
     C                   MOVE      'N'           DDJAD4OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDJAD5 <> *BLANKS
     C                   MOVE      'N'           DDJAD5OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        WERR = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'DDJAD1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0376'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        Idx = 0
     C                   EVAL      DFJAOV = DDJAOV
     C                   EVAL      DFJAD1 = DDJAD1
     C                   EVAL      DFJAD2 = DDJAD2
     C                   EVAL      DFJAD3 = DDJAD3
     C                   EVAL      DFJAD4 = DDJAD4
     C                   EVAL      DFJAD5 = DDJAD5
     C                   EVAL      DFJAS1 = DDJAS1
     C                   EVAL      DFJAS2 = DDJAS2
     C                   EVAL      DFJAS3 = DDJAS3
     C                   EVAL      DFJAS4 = DDJAS4
     C                   EVAL      DFJAS5 = DDJAS5
     C                   EVAL      DFJACO = DDJACO
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
 
      ** US Indicium of US Joint Account Member - Override Value
      ** (Original)
     C                   PARM                    DDJAOVO           1
 
      ** US Indicium of US Joint Account Member - Override Value
     C                   PARM                    DDJAOV            1
 
      ** Customer
     C                   PARM                    DDCUST           10
     C                   PARM                    DDRTYP            1
 
      ** US Indicium of US Country of Birth - Override Active Document
     C                   PARM                    DDJAD1            2
     C                   PARM                    DDJAD2            2
     C                   PARM                    DDJAD3            2
     C                   PARM                    DDJAD4            2
     C                   PARM                    DDJAD5            2
     C                   PARM                    DDJAS1
     C                   PARM                    DDJAS2
     C                   PARM                    DDJAS3
     C                   PARM                    DDJAS4
     C                   PARM                    DDJAS5
 
      ** US Indicium of US Joint Account Member Comment
     C                   PARM                    DDJAC1
     C                   PARM                    DDJAC2
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** US Indicium of US Joint Account Member - OK
     C                   PARM                    DDJAOVOK          1
     C                   PARM                    DDJACOOK          1
     C                   PARM                    DDJAD1OK          1
     C                   PARM                    DDJAD2OK          1
     C                   PARM                    DDJAD3OK          1
     C                   PARM                    DDJAD4OK          1
     C                   PARM                    DDJAD5OK          1
     C                   PARM                    DFJAOV
     C                   PARM                    DFJAD1            2
     C                   PARM                    DFJAD2            2
     C                   PARM                    DFJAD3            2
     C                   PARM                    DFJAD4            2
     C                   PARM                    DFJAD5            2
     C                   PARM                    DFJAS1
     C                   PARM                    DFJAS2
     C                   PARM                    DFJAS3
     C                   PARM                    DFJAS4
     C                   PARM                    DFJAS5
     C                   PARM                    DFJACO
 
     C     KDCMT         KLIST
     C                   KFLD                    KDCUST
     C                   KFLD                    KDRTYP
     C                   KFLD                    KDJADD
     C                   KFLD                    KDJASS
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2013
