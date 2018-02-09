     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate US Indicium of US Telephone')        *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVUSTEL - Validate US Indicium of US Telephone              *
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
 
     D DDTEC1          S             64A
     D DDTEC2          S             64A
     D DDTECO          S            128A
     D DFTEOV          S              1A
     D DFTECO          S            128A
     D DDTES1          S              3S 0
     D DDTES2          S              3S 0
     D DDTES3          S              3S 0
     D DDTES4          S              3S 0
     D DDTES5          S              3S 0
     D DFTES1          S              3S 0
     D DFTES2          S              3S 0
     D DFTES3          S              3S 0
     D DFTES4          S              3S 0
     D DFTES5          S              3S 0
     D WERR            S              1A
     D KDCUST          S             10A
     D KDRTYP          S              1A
     D KDTEDD          S              2A
     D KDTESS          S              3S 0
 
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
     C                   MOVE      'Y'           DDTEOVOK
     C                   MOVE      'Y'           DDTECOOK
     C                   MOVE      *BLANK        KDCUST
     C                   MOVEL     DDCUST        KDCUST
     C                   MOVE      DDRTYP        KDRTYP
 
     C                   IF        DDTEOV <> 'Y' AND
     C                             DDTEOV <> 'N' AND
     C                             DDTEOV <> ' '
 
     C                   MOVE      'N'           DDTEOVOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTEOV'      FldNamXAr(Idx)
     C                   MOVEL     'USS0157'     MsgIdXAr(Idx)
 
     C                   ENDIF
 
     C                   EVAL      DDTECO = DDTEC1 + DDTEC2
 
     C                   IF        DDTEOVO <> DDTEOV AND
     C                             DDTECO = *BLANKS AND
     C                             Idx = 0
                                                                                           MD027584B
     C                             OR (DDTEOV <> *BLANKS AND                               MD027584B
     C                             DDTECO = *BLANKS AND                                    MD027584B
     C                             Idx = 0)                                                MD027584B
 
     C                   MOVE      'N'           DDTECOOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTECO'      FldNamXAr(Idx)
     C                   MOVEL     'USS0158'     MsgIdXAr(Idx)
 
     C                   ENDIF
 
     C                   IF        DDTEOV = 'Y' OR
     C                             DDTEOV = 'N'
 
     C                   IF        DDTED1 = *BLANKS
     C                   IF        DDTED2 <> *BLANKS OR
     C                             DDTED3 <> *BLANKS OR
     C                             DDTED4 <> *BLANKS OR
     C                             DDTED5 <> *BLANKS
     C                   MOVE      'N'           DDTED1OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTED1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDTED2 = *BLANKS
     C                   IF        DDTED3 <> *BLANKS OR
     C                             DDTED4 <> *BLANKS OR
     C                             DDTED5 <> *BLANKS
     C                   MOVE      'N'           DDTED2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTED2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDTED3 = *BLANKS
     C                   IF        DDTED4 <> *BLANKS OR
     C                             DDTED5 <> *BLANKS
     C                   MOVE      'N'           DDTED3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTED3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDTED4 = *BLANKS
     C                   IF        DDTED5 <> *BLANKS
     C                   MOVE      'N'           DDTED4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTED4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDTED1 <> *BLANKS
     C                   MOVE      DDTED1        KDTEDD
     C                   MOVE      DDTES1        KDTESS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFTED1 = DDTED1
     C                   EVAL      DFTES1 = DDTES1
     C                   ELSE
 
     C                   MOVE      'N'           DDTED1OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTED1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDTED1OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTED1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDTED2 <> *BLANKS
     C                   MOVE      DDTED2        KDTEDD
     C                   MOVE      DDTES2        KDTESS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFTED2 = DDTED2
     C                   EVAL      DFTES2 = DDTES2
     C                   ELSE
 
     C                   MOVE      'N'           DDTED2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTED2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDTED2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTED2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDTED3 <> *BLANKS
     C                   MOVE      DDTED3        KDTEDD
     C                   MOVE      DDTES3        KDTESS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFTED3 = DDTED3
     C                   EVAL      DFTES3 = DDTES3
     C                   ELSE
 
     C                   MOVE      'N'           DDTED3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTED3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDTED3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTED3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDTED4 <> *BLANKS
     C                   MOVE      DDTED4        KDTEDD
     C                   MOVE      DDTES4        KDTESS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFTED4 = DDTED4
     C                   EVAL      DFTES4 = DDTES4
     C                   ELSE
 
     C                   MOVE      'N'           DDTED4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTED4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDTED4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTED4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDTED5 <> *BLANKS
     C                   MOVE      DDTED5        KDTEDD
     C                   MOVE      DDTES5        KDTESS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFTED5 = DDTED5
     C                   EVAL      DFTES5 = DDTES5
     C                   ELSE
 
     C                   MOVE      'N'           DDTED5OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTED5'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      'N'           DDTED5OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTED5'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDTED2 <> '  '
     C**********         IF        DDTED1 = DDTED2 AND                                      MD025077
     C**********                   DDTES1 = DDTES2                                          MD025077
     C                   IF        DDTED1 = DDTED2                                          MD025077
     C                   MOVE      'N'           DDTED2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTED2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDTED3 <> '  '
     C**********         IF        DDTED1 = DDTED3 AND                                      MD025077
     C**********                   DDTES1 = DDTES3 OR                                       MD025077
     C**********                   DDTED2 = DDTED3 AND                                      MD025077
     C**********                   DDTES2 = DDTES3                                          MD025077
     C                   IF        DDTED1 = DDTED3 OR                                       MD025077
     C                             DDTED2 = DDTED3                                          MD025077
     C                   MOVE      'N'           DDTED3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTED3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDTED4 <> '  '
     C**********         IF        DDTED1 = DDTED4 AND                                      MD025077
     C**********                   DDTES1 = DDTES4 OR                                       MD025077
     C**********                   DDTED2 = DDTED4 AND                                      MD025077
     C**********                   DDTES2 = DDTES4 OR                                       MD025077
     C**********                   DDTED3 = DDTED4 AND                                      MD025077
     C**********                   DDTES3 = DDTES4                                          MD025077
     C                   IF        DDTED1 = DDTED4 OR                                       MD025077
     C                             DDTED2 = DDTED4 OR                                       MD025077
     C                             DDTED3 = DDTED4                                          MD025077
     C                   MOVE      'N'           DDTED4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTED4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDTED5 <> '  '
     C**********         IF        DDTED1 = DDTED5 AND                                      MD025077
     C**********                   DDTES1 = DDTES5 OR                                       MD025077
     C**********                   DDTED2 = DDTED5 AND                                      MD025077
     C**********                   DDTES2 = DDTES5 OR                                       MD025077
     C**********                   DDTED3 = DDTED5 AND                                      MD025077
     C**********                   DDTES3 = DDTES5 OR                                       MD025077
     C**********                   DDTED4 = DDTED5 AND                                      MD025077
     C**********                   DDTES4 = DDTES5                                          MD025077
     C                   IF        DDTED1 = DDTED5 OR                                       MD025077
     C                             DDTED2 = DDTED5 OR                                       MD025077
     C                             DDTED3 = DDTED5 OR                                       MD025077
     C                             DDTED4 = DDTED5                                          MD025077
     C                   MOVE      'N'           DDTED5OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTED5'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      WERR = 'N'
     C                   IF        DDTED1 <> *BLANKS
     C                   MOVE      'N'           DDTED1OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDTED2 <> *BLANKS
     C                   MOVE      'N'           DDTED2OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDTED3 <> *BLANKS
     C                   MOVE      'N'           DDTED3OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDTED4 <> *BLANKS
     C                   MOVE      'N'           DDTED4OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        DDTED5 <> *BLANKS
     C                   MOVE      'N'           DDTED5OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
 
     C                   IF        WERR = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'DDTED1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0379'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        Idx = 0
     C                   EVAL      DFTEOV = DDTEOV
     C                   EVAL      DFTED1 = DDTED1
     C                   EVAL      DFTED2 = DDTED2
     C                   EVAL      DFTED3 = DDTED3
     C                   EVAL      DFTED4 = DDTED4
     C                   EVAL      DFTED5 = DDTED5
     C                   EVAL      DFTES1 = DDTES1
     C                   EVAL      DFTES2 = DDTES2
     C                   EVAL      DFTES3 = DDTES3
     C                   EVAL      DFTES4 = DDTES4
     C                   EVAL      DFTES5 = DDTES5
     C                   EVAL      DFTECO = DDTECO
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
 
      ** US Indicium of US Telephone - Override Value (Original)
     C                   PARM                    DDTEOVO           1
 
      ** US Indicium of US Telephone - Override Value
     C                   PARM                    DDTEOV            1
 
      ** Customer
     C                   PARM                    DDCUST           10
     C                   PARM                    DDRTYP            1
 
      ** US Indicium of US Country of Birth - Override Active Document
     C                   PARM                    DDTED1            2
     C                   PARM                    DDTED2            2
     C                   PARM                    DDTED3            2
     C                   PARM                    DDTED4            2
     C                   PARM                    DDTED5            2
     C                   PARM                    DDTES1
     C                   PARM                    DDTES2
     C                   PARM                    DDTES3
     C                   PARM                    DDTES4
     C                   PARM                    DDTES5
 
      ** US Indicium of US Telephone Comment
     C                   PARM                    DDTEC1
     C                   PARM                    DDTEC2
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** US Indicium of US Telephone - OK
     C                   PARM                    DDTEOVOK          1
     C                   PARM                    DDTECOOK          1
     C                   PARM                    DDTED1OK          1
     C                   PARM                    DDTED2OK          1
     C                   PARM                    DDTED3OK          1
     C                   PARM                    DDTED4OK          1
     C                   PARM                    DDTED5OK          1
 
     C                   PARM                    DFTEOV
     C                   PARM                    DFTED1            2
     C                   PARM                    DFTED2            2
     C                   PARM                    DFTED3            2
     C                   PARM                    DFTED4            2
     C                   PARM                    DFTED5            2
     C                   PARM                    DFTES1
     C                   PARM                    DFTES2
     C                   PARM                    DFTES3
     C                   PARM                    DFTES4
     C                   PARM                    DFTES5
     C                   PARM                    DFTECO
 
     C     KDCMT         KLIST
     C                   KFLD                    KDCUST
     C                   KFLD                    KDRTYP
     C                   KFLD                    KDTEDD
     C                   KFLD                    KDTESS
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2013
