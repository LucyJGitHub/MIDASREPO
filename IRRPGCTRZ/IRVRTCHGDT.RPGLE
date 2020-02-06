     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Validate rate change date')                   *
      *****************************************************************
      *                                                               *
      *  Midas - IRS Validation Module                                *
      *                                                               *
      *  IRVRTCHGDT - IRS Validate rate change days                   *
      *                                                               *
      *  Function:  This module accepts the rate change date field and*
      *             confirms whither it has a valid value. If it is   *
      *             not the 10A return code will contain 'Error'.     *
      *             If it is the return code will contain blanks      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CIR018             Date 06Aug14               *
      *                 CIR017             Date 10Apr14               *
      *                 MD000091           Date 08May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      *                 CIR007             Date 11May01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 185057             Date 23Jan01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CIR005             Date 21Jan00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 167511             Date 14Sep99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003  *CREATE    Date 01Feb98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CIR018 - Daily Rate Change Frequency on SIRS                 *
      *  CIR017 - SIRS Business Day Conventions for both legs         *
      *           (Recompile)                                         *
      *  MD000091 - Event Codes Substitution                          *
      *  CIR007 - Overnight Index Swaps                               *
      *  185057 - Validate 'Rate fix days' and 'Rate change Date,     *
      *           only if one of them has changed.                    *
      *  CIR005 - FRA/IRS Business Day Conventions.                   *
      *  167511 - FRA/IRS functions fail if dates contain invalid data*
      *           (also fix mistreatment of warning errors)           *
      *  CAP003 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** External data extructure for SAR details                               CIR005
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CIR005
                                                                                CIR005
      ** External data extructure used by access objects                        CIR005
     D DSFDY         E DS                  EXTNAME(DSFDY)                       CIR005
                                                                                CIR005
      ** ZDAYNO data area to extract ZDAY
     D DateDS          DS             6
     D ZMTH                    1      2  0
     D ZDAY                    3      4  0
     D ZYR                     5      6  0
                                                                                CIR005
      ** Single currency IRS Business Day Conventions layout                    CIR005
     D BsDayConv     E DS                  EXTNAME(IRSBDYPD)                    CIR005
     D  PayCurr                1     30                                         CIR005
     D  RateCurr              35     64                                         CIR005
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ***Holiday*currency array for payment conventions                              CIR005 MD000091
     D*HolCurrArr******S              4A   DIM(10)                                   CIR005 MD000091
      ** Holiday currency array for payment conventions                                     MD000091
     D TmpCcyArr       S              5A   DIM(10)                                          MD000091
                                                                                CIR005
      ** Valid Rate Change Date passed back to calling programme
     D   TNICDX        S              5  0
 
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      **Rate Change Date passed to module by calling program
     D  STNICD         S              6A                                        (STNICD+SUNICD)
 
      ** Base Rate code passed as a parameter from calling program
     D  STBRTT         S              2A                                        (STBRTT+SUBRTT)
 
      ** Run day number passed as a parameter from calling program
     D BJRDNB          S              5  0                                      (BJRDNB)
 
      **Valid value date passed as a parameter from calling program
     D  VDATX          S              5  0                                      (VDATX)
 
      **Valid Maturity date passed as a parameter from calling program
     D  MDATX          S              5  0                                      (MDATX)
 
      ** Currency for rate fix holiday passed as a parameter from calling program
     D  BQCRFH         S              1A                                        (BQCRFH)
 
      ** Local currency code passed as a parameter from calling program
     D  BJLCCY         S              3A                                        (BJLCCY)
 
      ** Currency code passed as a parameter from calling program
     D   BLCYCD        S              3A
 
      ** System location code passed as a parameter from calling program
     D  BJSLCD         S              3A                                        (BJSLCD)
 
      ** Currency passed as a parameter from calling program
     D  SUCUCY         S              3A                                        (SUCUCY)
 
      ** Valid Rate fix days passed as a parameter from calling program
     D  TFRFDX         S              2S 0                                      (TFRFDX+URFDFX)
 
      ** Valid value date indicator passed as a parameter from calling program
     D  VDATXok        S              1A                                        (20)
 
      ** Valid Maturity date indicator passed as a parameter from calling program
     D  MDATXok        S              1A                                        (21)
 
      ** Valid Floating Rate Fix Days Indicator passed as a parameter from calling program
     D  TFRFDXok       S              1A                                        (31+57)
 
      ** Valid Currency indicator passed from calling program
     D  SUCUCYok       S              1A                                        (23)
 
      ** Date format indicator passed as a parameter to ZDATE
     D   BJDFIN        S              1A
 
      ** Error flag passed back from ZDATE to module
     D  ErrorFlag      S              1A
 
      ** Error Flag passed back from ZCHKH to module
     D   HolInd        S              1A
 
      ** Average rate method indicator passed as a parameter from calling program. Default 'N'
     D  SAVRAM         S              1A
                                                                                              185057
      ** Valid Rate fix days passed as a parameter from calling program                       185057
     D  @SUFRFD        S              2S 0                                                    185057
 
      **Rate Change Date passed to module by calling program                                  185057
     D  @SUNICD        S              6A                                                      185057
                                                                                              185057
     D  PActCode       S              1A                                                      CIR018
     D  POred          S              5P 0                                                    CIR018
     D  POredC         S              5A                                                      CIR018
      *                                                                                       CIR018
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message passed back to calling program from module
     D  Msgid1         S                   LIKE(#Msgid)
 
      ** Error message passed back to calling program from module
     D  WMsgid1        S                   LIKE(#Msgid)
 
      ** Error message passed back to calling program from module
     D  WMsgid2        S                   LIKE(#Msgid)
                                                                                CIR005
      ** Error message passed back to calling program from module               CIR005
     D  WMsgid3        S                   LIKE(#Msgid)                         CIR005
                                                                                CIR005
      ** Validate Business Day Convention flag                                  CIR005
     D  WValBDC        S              1A                                        CIR005
                                                                                CIR005
      ** Mode of operation received from controller                             CIR005
     D ModeOfOp        S              6A                                        CIR005
                                                                                CIR005
      ** Warning message data to be passed back to the calling module           CIR005
     D  WMsgData       S                   LIKE(#MsgData)                       CIR005
 
      ** Check Indicator for intital validations
     D   CheckInd      S              1A
 
      ** Rate fix date field for DLBACK
     D  ZRFDT          S              5  0
 
      ** Rate fix day field for DLBACK
     D  ZRFDY          S              5  0
 
      ** Midas day number passed to DLBACK subroutine
     D  ZINDT          S              5  0
 
      ** Day number passed back to calling program
     D  ZDAYX          S              2  0
 
      ** Currency field passed to ZCHKH as a parameter
     D   ZCCY          S              3A
 
      ** Midas day number passed back from ZDATE
     D   ZDAYNO        S              5  0
 
      ** Location code passed to DLBACK and module ZCHKH
     D   ZLOC          S              3A
 
      ** Work Field used by DLBACK
     D  ZWKFLD         S              5  0
      ** Numerical test indicator
     D  NUMok          S              1A
 
      ** Rate Change Frequency                                                                CIR007
     DPRatChgFq        S              1A                                                      CIR007
                                                                                              CIR007
      ** Deal Type used as Parameter                                                          CIR007
     DPDealTyp         S              2A                                                      CIR007
                                                                                              CIR007
      ** OVERNIGHT INDEX SWAPS                                                                CIR007
     DCIR007           S              1A                                                      CIR007
                                                                                              CIR018
      ** Variable for ZDATE2                                                                  CIR018
     DWDate6N          S              6  0                                                    CIR018
                                                                                              CIR018
      ** Variable for ZDATE2                                                                  CIR018
     DWDate7A          S              7A                                                      CIR018
                                                                                            MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   RESET                   ErrorFound
     C                   RESET                   WarnFound                      167511
     C                   Reset                   Msgid1
     C                   Reset                   WMsgid1
     C                   Reset                   WMsgid2
     C                   Reset                   WMsgid3                        CIR005
     C                   Reset                   WMsgData                       CIR005
     C*******************RESET                   *IN84                          167511
     C                   MOVE      'N'           CheckInd
 
      ** If CIR007 is on , Deal Type is 'RS' and Rate Change Frequency                        CIR007
      ** Code is 'O', then the Rate Change Date must be blank.                                CIR007
                                                                                              CIR007
     C                   IF        CIR007 = 'Y' AND PDealTyp = 'RS'                           CIR007
     C                             AND PRatChgFq = 'O'                                        CIR007
     C                   IF        STNICD <> *BLANKS                                          CIR007
     C                   MOVE      'Y'           ErrorFound                                   CIR007
     C                   MOVE      'MMA1177'     Msgid1                                       CIR007
     C                   MOVE      'Y'           CheckInd                                     CIR007
     C                   ENDIF                                                                CIR007
                                                                                              CIR007
     C                   ElSE                                                                 CIR007
                                                                                              CIR007
     C                   Z-ADD     0             TNICDX
     C     STNICD        IFNE      *BLANKS
     C     STBRTT        IFEQ      *BLANKS
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMA0033'     Msgid1
     C                   MOVE      'Y'           CheckInd
     C                   ELSE
                                                                                167511
     C*******************TESTN                   STNICD               84        167511
     C******IN84*********IFEQ      *ON                                          167511
                                                                                167511
     C                   TESTN                   STNICD               9798      167511
     C     *IN97         IFEQ      '1'                                          167511
     C     *IN98         OREQ      '1'                                          167511
     C                   MOVE      'Y'           NUMok
     C                   ELSE
     C                   MOVE      'N'           NUMok
     C                   ENDIF
     C     NUMok         IFEQ      'Y'
     C                   CALLB     'ZDATE1'
     C                   PARM                    STNICD
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
     C                   ENDIF
 
     C     NUMok         IFEQ      'N'
     C     ErrorFlag     OREQ      'Y'
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'EMM0008'     Msgid1
     C                   MOVE      'Y'           CheckInd
     C                   ENDIF
     C                   ENDIF
     C
      **Cross-Check with Value Date, Maturity Date and Run Date
     C     CheckInd      IFEQ      'N'
     C     ZDAYNO        IFLT      BJRDNB
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMA0036'     Msgid1
     C                   MOVE      'Y'           CheckInd
     C                   ELSE
     C*****VDATXok       IFEQ      'Y'                                          167511
     C     VDATXok       IFNE      'N'                                          167511
     C     ZDAYNO        ANDLE     VDATX
     C*****MDATXok       OREQ      'Y'                                          167511
     C     MDATXok       ORNE      'N'                                          167511
     C     ZDAYNO        ANDGE     MDATX
     C                   MOVE      'Y'           ErrorFound
     C                   MOVE      'MMA0037'     Msgid1
     C                   MOVE      'Y'           CheckInd
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CIR018
     C                   If        CIR018 = 'Y' and PDealTyp = 'RS'                           CIR018
     C                             and PRatChgFq = 'D' and                                    CIR018
     C                             ZDAYNO <> (VDATX + 1)                                      CIR018
     C                             and PActCode = 'I'                                         CIR018
     C                             and VDATX >= Bjrdnb                                        CIR018
     C                             Or CIR018 = 'Y' and PDealTyp = 'RS'                        CIR018
     C                             and PRatChgFq = 'D' and                                    CIR018
     C                             ZDAYNO <> (BJRDNB + 1)                                     CIR018
     C                             and PActCode = 'I'                                         CIR018
     C                             and VDATX < Bjrdnb                                         CIR018
     C                             OR CIR018 = 'Y' and PDealTyp = 'RS'                        CIR018
     C                             and PRatChgFq = 'D' and                                    CIR018
     C                             ZDAYNO <> (VDATX + 1)                                      CIR018
     C                             and PActCode = 'A' and POred = Bjrdnb                      CIR018
     C                             and VDATX >= Bjrdnb                                        CIR018
     C                             Or CIR018 = 'Y' and PDealTyp = 'RS'                        CIR018
     C                             and PRatChgFq = 'D' and                                    CIR018
     C                             ZDAYNO <> (BJRDNB + 1)                                     CIR018
     C                             and PActCode = 'A' and POred = Bjrdnb                      CIR018
     C                             and VDATX < BJRDNB                                         CIR018
     C                             OR CIR018 = 'Y' and PDealTyp = 'RS'                        CIR018
     C                             and PRatChgFq = 'D' and                                    CIR018
     C**********                   ZDAYNO <> (Bjrdnb + 1)                                     CIR018
     C                             ZDAYNO <> Bjrdnb                                           CIR018
     C                             and PActCode = 'A' and POred < Bjrdnb                      CIR018
     C                   move      'Y'           ErrorFound                                   CIR018
     C**********         If        PActCode = 'I' and VDATX >= Bjrdnb                         CIR018
     C                   If        PActCode = 'I'                                             CIR018
     C                             Or (PActCode = 'A' and POred = BJRDNB)                     CIR018
     C**********                   and VDATX >= Bjrdnb                                        CIR018
     C                   move      '5047296'     Msgid1                                       CIR018
     C                   else                                                                 CIR018
     C                   move      '5047299'     Msgid1                                       CIR018
     C                   Endif                                                                CIR018
     C                   move      'Y'           CheckInd                                     CIR018
     C                   Endif                                                                CIR018
 
      ** Save valid date number and day number
     C     CheckInd      IFEQ      'N'
     C                   MOVEL     STNICD        DateDS
     C     BJDFIN        IFEQ      'M'
     C                   Z-ADD     ZDAY          ZDAYX
     C                   ELSE
     C                   MOVE      ZMTH          ZDAYX
     C                   ENDIF
     C
     C                   Z-ADD     ZDAYNO        TNICDX            5 0
     C                   ENDIF
      *                                                                                       CIR018
     C                   If        CIR018 = 'Y' and PDealTyp = 'RS'                           CIR018
     C                             and PRatChgFq = 'D'                                        CIR018
     C                   else                                                                 CIR018
      *                                                                                       CIR018
      ** Check through Module DLBACK
     C     SAVRAM        IFNE      'Y'
     C     CheckInd      IFEQ      'N'
     C     TFRFDXok      ANDNE     'N'                                          167511
     C     SUCUCYok      ANDNE     'N'                                          167511
     C*****TFRFDXok      ANDEQ     'Y'                                          167511
     C*****SUCUCYok      ANDEQ     'Y'                                          167511
     C                   Z-ADD     ZDAYNO        ZINDT
     C                   Z-ADD     TFRFDX        ZRFDY
     C
      ** If 'currency for rate fix holiday' flag from FRA/IRS I.C.D. is 'F',
      ** 'L' or 'D' , set currency code to 'Sterling code', 'local currency code' or
      ** 'screen currency code' respectively.
     C
     C     BQCRFH        IFEQ      'F'
     C                   MOVE      BLCYCD        ZCCY
     C                   ENDIF
 
     C     BQCRFH        IFEQ      'L'
     C                   MOVE      BJLCCY        ZCCY
     C                   ENDIF
 
     C     BQCRFH        IFEQ      'D'
     C     BQCRFH        OREQ      ' '
     C                   MOVE      SUCUCY        ZCCY
     C                   ENDIF
     C                   MOVE      *BLANKS       ZLOC
                                                                                CIR005
      ** Calculate rate fix date using DLBACK if one of the following           CIR005
      ** conditions is satisfied:                                               CIR005
      ** 1) Business Day Convention enhancement is switched off.                CIR005
      ** 2) Business Day Convention enhancement is switched on AND              CIR005
      **    Validate Business Day Flag is set to 'Y' AND the first              CIR005
      **    Currency for Rate Fixing Convention is blank.                       CIR005
      ** 3) Module is called from the API CTL module.                           CIR005
                                                                                CIR005
     C                   IF        (CIR005 = 'N') Or ((CIR005 = 'Y') And        CIR005
     C                             (WValBDC = 'Y') And (SC1R1 = *Blanks))       CIR005
     C                             Or ((CIR005 = 'Y') And                       CIR005
     C                             (ModeOfOp = '*FRONT') And (SC1R1 = *Blank )) CIR005
     C                   EXSR      DLBACK
     C                   ENDIF                                                  CIR005
                                                                                CIR005
      ** Calculate rate fix date using Rate Fixing Conv. Currencies if          CIR005
      ** Business Day enhancement is switched on and the validate busi          CIR005
      ** ness day flag is set to 'Y' (second time screen validation)            CIR005
      ** and the 1st currency for Rate Fixing Conv. is not blank.               CIR005
                                                                                CIR005
     C                   IF        ((CIR005 = 'Y') And (WValBDC = 'Y')          CIR005
     C                             And (SC1R1 <> *Blank)) Or                    CIR005
     C                             ((CIR005 = 'Y') And                          CIR005
     C                             (ModeOfOp = '*FRONT') And (SC1R1 <> *Blank)) CIR005
     C                   Z-ADD     ZRFDY         WRFDY             2 0          CIR005
                                                                                CIR005
     C                   CALLB     'IRRTFXCNV'                                  CIR005
     C                   PARM                    ZINDT                          CIR005
     C                   PARM                    WRFDY                          CIR005
     C                   PARM      *Blank        ZLOC                           CIR005
     C                   PARM                    RateCurr                       CIR005
     C                   PARM                    ZRFDT                          CIR005
                                                                                CIR005
     C                   ENDIF                                                  CIR005
 
     C     @SUNICD       IFNE      STNICD                                                     185057
     C     @SUFRFD       ORNE      TFRFDX                                                     185057
                                                                                              185057
     C     ZRFDT         IFLT      BJRDNB
     C     CIR005        ANDEQ     'N'                                          CIR005
     C     CIR005        OREQ      'Y'                                          CIR005
     C     ZRFDT         ANDLT     BJRDNB                                       CIR005
     C     WValBDC       ANDEQ     'Y'                                          CIR005
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMA0038'     Msgid1
     C                   MOVE      'Y'           CheckInd
     C                   END
     C                   END
     C                   END
 
      ** Check if Rate change date is a holiday in local currency
 
     C     CheckInd      IFEQ      'N'
     C                   MOVE      TNICDX        ZDAYNO
                                                                                CIR005
      ** Validate rate change date against local/dealing currency               CIR005
      ** if one of the following conditions is satisfied:                       CIR005
      ** 1) Business Day Convention enhancement is switched off.                CIR005
      ** 2) Business Day Convention enhancement is switched on AND              CIR005
      **    Validate Business Day Flag is set to 'Y' AND the first              CIR005
      **    Currency for Payment Convention is blank.                           CIR005
      ** 3) Module is called from the API CTL module.                           CIR005
                                                                                CIR005
     C                   IF        (CIR005 = 'N') Or ((CIR005 = 'Y') And        CIR005
     C                             (WValBDC = 'Y') And (SC1P1 = *Blanks))       CIR005
     C                             Or ((CIR005 = 'Y') And                       CIR005
     C                             (ModeOfOp = '*FRONT') And (SC1P1 = *Blanks)) CIR005
     C                   MOVE      BJLCCY        ZCCY
     C     ZDAYNO        IFNE      0
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    BJSLCD
     C                   PARM                    HolInd
     C     HolInd        IFEQ      'H'
     C*******************Move      'Y'           ErrorFound                     167511
     C                   EVAL      WarnFound    = 'Y'                           167511
     C                   MOVEL     'MMA0040'     WMsgid1
     C                   MOVE      'Y'           CheckInd
     C                   ENDIF
     C                   ENDIF
 
 
      ** Check if Rate change date is holiday in dealing currency
     C*****SUCUCYok      IFEQ      'Y'                                          167511
     C     SUCUCYok      IFNE      'N'                                          167511
     C                   MOVE      SUCUCY        ZCCY
     C     ZDAYNO        IFNE      0
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    BJSLCD
     C                   PARM                    HolInd
     C     HolInd        IFEQ      'H'
     C*******************MOVE      'Y'           ErrorFound                     167511
     C                   EVAL      WarnFound    = 'Y'                           167511
     C                   MOVEL     'MMA0040'     WMsgid2
     C                   MOVE      'Y'           CheckInd
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                  CIR005
                                                                                CIR005
      ** Validate rate change date for Payment Convention currency if           CIR005
      ** Business Day enhancement is switched on and the validate busi          CIR005
      ** ness day flag is set to 'Y' (second time screen validation)            CIR005
      ** and the 1st currency for Payment Convention is not blank.              CIR005
                                                                                CIR005
     C                   IF        ((CIR005 = 'Y') And (WValBDC = 'Y')          CIR005
     C                             And (SC1P1 <> *Blank)) Or                    CIR005
     C                             ((CIR005 = 'Y') And                          CIR005
     C                             (ModeOfOp = '*FRONT') And (SC1P1 <> *Blank)) CIR005
                                                                                CIR005
     C                   MOVE      'N'           WHolFnd           1            CIR005
     C                   Z-ADD     1             H                 2 0          CIR005
     C                   Z-ADD     1             C                 2 0          CIR005
     C                   Z-ADD     1             S                 2 0          CIR005
     C                   Z-ADD     3             L                 2 0          CIR005
                                                                                CIR005
      ** Get first currency                                                     CIR005
                                                                                CIR005
     C     L             SUBST     PayCurr:S     ZCCY                           CIR005
                                                                                CIR005
     C     C             DOWLE     10                                           CIR005
     C     ZCCY          ANDNE     *Blank                                       CIR005
     C                   CALLB     'ZCHKH'                                      CIR005
     C                   PARM                    ZDAYNO                         CIR005
     C                   PARM                    ZCCY                           CIR005
     C                   PARM                    BJSLCD                         CIR005
     C                   PARM                    HolInd                         CIR005
                                                                                CIR005
      ** Rate change date is holiday in payment convention currency             CIR005
                                                                                CIR005
     C                   IF        Holind = 'H'                                 CIR005
     C**********         MOVEL     ZCCY          HolCurrArr(H)                  CIR005      MD000091
     C                   MOVEL     ZCCY          TmpCcyArr(H)                               MD000091
     C                   EVAL      BLen = %Len(%Trim(ZCCY))                                 MD000091
     C                   EVAL      TmpCcyArr(H) = LenStr +%TRIM(ZCCY)                       MD000091
     C                   EVAL      H = H + 1                                    CIR005
                                                                                CIR005
      ** Set holiday found indicator to 'Y'                                     CIR005
                                                                                CIR005
     C                   MOVE      'Y'           WHolFnd                        CIR005
     C                   ENDIF                                                  CIR005
                                                                                CIR005
      ** Get next currency                                                      CIR005
                                                                                CIR005
     C                   EVAL      C = C+1                                      CIR005
     C                   EVAL      S = S+3                                      CIR005
     C                   IF        (C < 10) Or (C = 10)                         CIR005
     C     L             SUBST     PayCurr:S     ZCCY                           CIR005
     C                   ENDIF                                                  CIR005
     C                   ENDDO                                                  CIR005
                                                                                CIR005
      ** Holiday is found in any of the currency..Warning message.              CIR005
                                                                                CIR005
     C                   IF        WHolFnd = 'Y'                                CIR005
     C                   EVAL      WarnFound    = 'Y'                           CIR005
     C                   MOVEL     'MMA1112'     WMsgid3                        CIR005
     C**********         MOVEA     HolCurrArr    WMsgData                            CIR005 MD000091
     C                   MOVEA     TmpCcyArr     WMsgData                                   MD000091
     C                   MOVE      'Y'           CheckInd                       CIR005
     C**********         MOVEL     *Blanks       HolCurrArr                          CIR005 MD000091
     C                   MOVEL     *Blanks       TmpCcyArr                                  MD000091
     C                   ENDIF                                                  CIR005
     C                   ENDIF                                                  CIR005
     C                   ENDIF
     C                   ENDIF
     C                   Endif                                                                CIR018
      *                                                                                       CIR018
     C                   Else                                                                 CIR018
     C                   If        CIR018 = 'Y' and PDealTyp = 'RS'                           CIR018
     C                             and PRatChgFq = 'D'                                        CIR018
     C                   If        PActCode = 'I' and VDATX >= Bjrdnb                         CIR018
     C                             Or (PActCode = 'A' and POred = Bjrdnb)                     CIR018
     C                             and VDATX >= Bjrdnb                                        CIR018
     C                   Eval      TNICDX = VDATX + 1                                         CIR018
     C                   else                                                                 CIR018
     C                   If        PActCode = 'I'                                             CIR018
     C                   Eval      TNICDX = Bjrdnb + 1                                        CIR018
     C                   else                                                                 CIR018
     C                   Eval      TNICDX = Bjrdnb                                            CIR018
     C                   Endif                                                                CIR018
     C                   Endif                                                                CIR018
      *                                                                                       CIR018
      * Only default date if < Maturity Date                                                  CIR018
     C                   If        TNICDX < MDATX                                             CIR018
     C                   Callb     'ZDATE2'                                                   CIR018
     C                   Parm                    TNICDX                                       CIR018
     C                   Parm                    BJDFIN                                       CIR018
     C                   Parm                    WDate6N                                      CIR018
     C                   Parm                    WDate7A                                      CIR018
     C                   move      WDate6N       STNICD                                       CIR018
     C                   Endif                                                                CIR018
     C                   Endif                                                                CIR018
     C                   ENDIF
 
     C                   ENDIF                                                                CIR007
 
     C*******************IF        ErrorFound = 'Y'                             167511
     C*******************EVAL      RetCodeIn = 'Error'                          167511
     C*******************ENDIF                                                  167511
 
      ** The return code is set in the following /COPY:                         167511
     C/COPY ZACPYSRC,SETRETCDE                                                  167511
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    ReturnCode                     167511
     C*******************PARM                    RetCodeIn                      167511
     C                   PARM                    Msgid1
     C                   PARM                    WMsgid1
     C                   PARM                    WMsgid2
     C                   PARM                    WMsgid3                        CIR005
     C                   PARM                    WMsgData                       CIR005
     C                   PARM                    TNICDX
     C                   PARM                    STNICD
     C                   PARM                    STBRTT
     C                   PARM                    BJRDNB
     C                   PARM                    VDATX
     C                   PARM                    MDATX
     C                   PARM                    BQCRFH
     C                   PARM                    BJLCCY
     C                   PARM                    BLCYCD
     C                   PARM                    BJSLCD
     C                   PARM                    SUCUCY
     C                   PARM                    TFRFDX
     C                   PARM                    VDATXok
     C                   PARM                    MDATXok
     C                   PARM                    TFRFDXok
     C                   PARM                    SUCUCYok
     C                   PARM                    BJDFIN
     C                   PARM                    ZDAYX
     C                   PARM                    SAVRAM
     C                   PARM                    ModeOfOp                       CIR005
     C                   PARM                    WValBDC                        CIR005
     C                   PARM                    BsDayConv                      CIR005
     C                   PARM                    @SUFRFD                                      185057
     C                   PARM                    @SUNICD                                      185057
     C                   PARM                    PRatChgFq                                    CIR007
     C                   PARM                    PDealTyp                                     CIR007
     C                   PARM                    CIR007                                       CIR007
     C                   PARM                    PActCode                                     CIR018
     C                   PARM                    POredC                                       CIR018
                                                                                CIR005
     C                   z-add     0             POred                                        CIR018
     C                   move      POredC        PORED                                        CIR018
                                                                                              CIR018
      ** Access SAR details file to determine if FRA/IRS Business Day           CIR005
      ** Day Convention is switched on.                                         CIR005
                                                                                CIR005
     C                   CALL      'AOSARDR0'                                   CIR005
     C                   PARM      *BLANKS       @RTCD                          CIR005
     C                   PARM      '*VERIFY'     @OPTN                          CIR005
     C                   PARM      'CIR005'      @SARD                          CIR005
     C     SCSARD        PARM      SCSARD        DSFDY                          CIR005
                                                                                CIR005
     C                   IF        (@RTCD <> *BLANKS) And (@RTCD <> '*NRF   ')  CIR005
     C                   MOVEL     'SCSARDPD'    DBFILE                         CIR005
     C                   MOVEL     '001'         DBASE                          CIR005
     C                   MOVEL     'CIR005'      DBKEY                          CIR005
     C                   EXSR      *PSSR                                        CIR005
     C                   ENDIF                                                  CIR005
                                                                                CIR005
     C                   IF        @RTCD = *BLANKS                              CIR005
     C                   MOVEL     'Y'           CIR005            1            CIR005
     C                   ELSE                                                   CIR005
     C                   MOVEL     'N'           CIR005                         CIR005
     C                   ENDIF                                                  CIR005
                                                                                              CIR018
      ** Access SAR details file to determine if CIR018 is switched on                        CIR018
                                                                                              CIR018
     C                   CALL      'AOSARDR0'                                                 CIR018
     C                   PARM      *BLANKS       @RTCD                                        CIR018
     C                   PARM      '*VERIFY'     @OPTN                                        CIR018
     C                   PARM      'CIR018'      @SARD                                        CIR018
     C     SCSARD        PARM      SCSARD        DSFDY                                        CIR018
                                                                                              CIR018
     C                   IF        (@RTCD <> *BLANKS) And (@RTCD <> '*NRF   ')                CIR018
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CIR018
     C                   MOVEL     '002'         DBASE                                        CIR018
     C                   MOVEL     'CIR018'      DBKEY                                        CIR018
     C                   EXSR      *PSSR                                                      CIR018
     C                   ENDIF                                                                CIR018
                                                                                              CIR018
     C                   IF        @RTCD = *BLANKS                                            CIR018
     C                   MOVEL     'Y'           CIR018            1                          CIR018
     C                   ELSE                                                                 CIR018
     C                   MOVEL     'N'           CIR018                                       CIR018
     C                   ENDIF                                                                CIR018
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C*                                                               *
     C*   SR: DLBACK - TO CALCULATE RATE FIX DATE FOR FRA/IRS         *
     C*****************************************************************
     C     DLBACK        BEGSR                                                  ** DLBACK **
     C*
     C* INPUT FIELD ZLOC CONTAINS THE RELEVANT BRANCH LOCATION
     C*
     C**  Initialise Work Field
     C                   Z-ADD     ZRFDT         ZRFDT
     C                   Z-ADD     ZRFDY         ZRFDY
     C                   Z-ADD     ZINDT         ZINDT
     C                   MOVE      ZCCY          ZCCY
     C                   Z-ADD     0             ZWKFLD
     C                   MOVE      ZLOC          ZLOC
 
     C*
     C**********                                                          S01195
     C**  Set Rate Fix Date equal to Input Date
     C                   Z-ADD     ZINDT         ZRFDT             5 0
     C**  Perform the following processing until the work field is
     C**  greater than or equal to the Rate Fix Days
     C     ZWKFLD        DOUGE     ZRFDY
     C*
     C**  If the Rate Fix Days are not equal to zero subtract 1
     C**  from the Rate Fix Date
     C     ZRFDY         IFNE      0
     C                   SUB       1             ZRFDT
     C                   END
     C*   The following is repeated until the resultant date is
     C*   proved to be a working day in the relevant currency and
     C*   location.
     C*   Uses ZCHKH to check Rate Fix Date for a holiday
     C*
     C     HolInd        DOUEQ     'W'
     C*
     C                   Z-ADD     ZRFDT         ZDAYNO
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC
     C                   PARM                    HolInd
     C*
     C* IF DATE IS A HOLIDAY (HolInd = 'H')
     C* SUBTRACT 1 FROM RATE FIX DATE
     C*
     C     HolInd        IFEQ      'H'
     C                   SUB       1             ZRFDT
     C                   END
     C                   END
     C*
     C**  When a working day has been found, add 1 to the Work Field
     C                   ADD       1             ZWKFLD
     C                   END
     C*
     C                   ENDSR
     C********************************************************************
      /EJECT
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
