     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade Exchange Rates Validation')
      *****************************************************************
      *                                                               *
      *    Midas SE - Midas Security Trading validation module.       *
      *                                                               *
      *  SETEXCHVAL - Trade Exchange Rates Validation                 *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 156689             Date 18Mar99               *
      *                 CAP003  *CREATE    Date 28Jan98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  156689 - ZASIGN To Recognize '.' or ',' as decimal separator *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------
 
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
 
     D AP              S             10  0 DIM(10) CTDATA PERRCD(1)                              CAC
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Trade Exchange Rates in screen format
     D TrExch        E DS                  EXTNAME(SETREXPD)
 
      ** Trade Exchange Rates OK indicators
     D OKTrExch      E DS                  EXTNAME(SEETREXPD)
 
 
      ** The following /COPY includes the currency details data structures
     D/COPY SECPYSRC,SE_CCYDT
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      *
      ** Working Variables
      *
     D  APWRK1         S             15P 8
     D  APWRK2         S             15P 8
     D  WTDER          S             13P 8
     D  ZMDIX          S              1A
     D  ZRATEX         S             13P 8
 
     D ZASIGNOK        S              1A
     D ZFLD17          S             17A
     D ZFSIGN          S              1A
     D ZOUT15          S             15A
     D ZSDEC           S              1P 0
     D ZSDCSP          S              1A                                        156689
     D ZSDIG           S              2P 0
 
     D FTTMRT          S              3S 0
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
      ** Index for arrays of warning message ids etc
     D WIx             S              3P 0
 
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
      *
      ** Initialization
      *
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   MOVE      *BLANK        WFldNmXAr
     C                   MOVE      *BLANK        WMsgIDXAr
     C                   MOVE      *BLANK        WMsgDtXAr
     C                   Z-ADD     0             WIx
 
      ** Clear output trade fields
 
     C                   MOVE      *BLANK        TMDI
     C                   Z-ADD     0             TDER
     C                   Z-ADD     0             TBCR
     C                   Z-ADD     0             FXMP
     C                   Z-ADD     0             FXMR
     C                   Z-ADD     0             MAMT
      *
      ** Validate Exchange Rate Multiply/Divide Indicator
      *
     C                   EXSR      TDMIV
      *
      ** Validate Exchange Rate
      *
     C     ddSMDIOk      IFNE      'N'
     C                   EXSR      TDERV
     C                   END
      *
      ** Validate Base Currency Exchange Rate
      *
     C                   EXSR      TBCRV
      *
      ** Validate FX Margin Points
      ** if Profit Centre Accounting is installed
      ** and if all the other rate fields are OK
      *
     C     BGN0ST        IFEQ      'Y'
     C     ddSMDIOk      ANDNE     'N'
     C     ddTDEROk      ANDNE     'N'
     C     ddBRTEOk      ANDNE     'N'
     C                   EXSR      FXMPV
     C                   END
      *
      ** Return
      *
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * TDMIV - Validation Routine for Multiply/Divide Indicator      *
      *                                                               *
      *****************************************************************
     C     TDMIV         BEGSR
 
     C     DDSMDI        IFNE      'M'
     C     DDSMDI        ANDNE     'D'
 
     C                   ADD       1             Idx
     C                   MOVEL     'DDSMDI'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0138'     MsgidXAr(Idx)
     C                   MOVE      'N'           DDSMDIOk
     C                   ELSE
      *
      ** Update Trade details
      *
     C                   MOVE      DDSMDI        TMDI
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * TDERV - Validating Routine for the Exchange Rate field        *
      *                                                               *
      *****************************************************************
     C     TDERV         BEGSR
      *
      ** Exchange rate is mandatory
      *
     C     DDTDER        IFEQ      *BLANKS
 
     C                   ADD       1             Idx
     C                   MOVEL     'DDTDER'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0136'     MsgidXAr(Idx)
     C                   MOVE      'N'           DDTDEROk
 
     C                   ELSE
      *
      ** If entered, must be a valid amount GT 0
      *
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVEL     DDTDER        ZFLD17
     C                   Z-ADD     5             ZSDIG
     C                   Z-ADD     8             ZSDEC
      *
     C                   CALLB     'ZASIGN'
     C                   PARM                    ZASIGNok
     C                   PARM                    ZFLD17
     C                   PARM                    ZSDIG
     C                   PARM                    ZSDEC
     C                   PARM                    ZSDCSP                         156689
     C                   PARM                    ZOUT15
     C                   PARM                    ZFSIGN
      *
      ** Update Trade
      *
     C                   MOVE      ZOUT15        TDER
      *
      ** Invalid number
      *
     C     ZASIGNok      IFEQ      'N'
     C     TDER          ORLE      0
     C                   ADD       1             Idx
     C                   MOVEL     'DDTDER'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0136'     MsgidXAr(Idx)
     C                   MOVE      'N'           DDTDEROk
 
     C                   ELSE
      *
      ** Must be within 10% of spot rate between nominal/settlement
      ** currencies
      *
      ** Set nominal currency details
      *
     C                   Z-ADD     NomCcySPRT    ZRATE1           13 8
     C                   MOVE      NomCcyMDIN    ZMDI1             1
     C                   MOVE      NomCcyNQDP    ZNQDP1            1 0
      *
      ** Set settlement currency details
      *
     C                   Z-ADD     SetCcySPRT    ZRATE2           13 8
     C                   MOVE      SetCcyMDIN    ZMDI2             1
     C                   MOVE      SetCcyNQDP    ZNQDP2            1 0
      *
      * Calculate cross rate
      *
     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1
     C                   PARM                    ZMDI1
     C                   PARM                    ZRATE2
     C                   PARM                    ZMDI2
     C                   PARM                    ZRATEX
     C                   PARM                    ZMDIX
      *
     C     DDSMDI        IFNE      ZMDIX
     C     TDER          ANDNE     *ZEROS
     C     1             DIV(H)    TDER          WTDER
     C                   ELSE
     C                   Z-ADD     TDER          WTDER
     C                   END
      *
     C     ZRATEX        DIV       10            APWRK1
     C     ZRATEX        ADD       APWRK1        APWRK2
 
     C     WTDER         IFGT      APWRK2
     C                   ADD       1             WIx
     C                   MOVEL     'DDTDER'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0137'     WMsgidXAr(WIx)
     C                   MOVE      'W'           DDTDEROk
     C                   ELSE
      *
     C     ZRATEX        SUB       APWRK1        APWRK2
 
     C     WTDER         IFLT      APWRK2
     C                   ADD       1             WIx
     C                   MOVEL     'DDTDER'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0137'     WMsgidXAr(WIx)
     C                   MOVE      'W'           DDTDEROk
     C                   END
     C                   END
 
     C                   END
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * TBCRV - Validation Routine for Base Currency Exchange Rate    *
      *                                                               *
      *****************************************************************
     C     TBCRV         BEGSR
      *
      *  Is mandatory if settlement currency is not base currency
      *
     C     DDSETC        IFNE      BJCYCD
     C     DDBRTE        ANDEQ     *BLANKS
     C                   ADD       1             Idx
     C                   MOVEL     'DDBRTE'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0139'     MsgidXAr(Idx)
     C                   MOVE      'N'           DDBRTEOk
     C                   END
      *
      **  If entered it must be a valid amount
      *
     C     DDBRTE        IFNE      *BLANKS
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVEL     DDBRTE        ZFLD17
     C                   Z-ADD     5             ZSDIG
     C                   Z-ADD     8             ZSDEC
 
     C                   CALLB     'ZASIGN'
     C                   PARM                    ZASIGNok
     C                   PARM                    ZFLD17
     C                   PARM                    ZSDIG
     C                   PARM                    ZSDEC
     C                   PARM                    ZSDCSP                         156689
     C                   PARM                    ZOUT15
     C                   PARM                    ZFSIGN
      *
     C                   MOVE      ZOUT15        TBCR
      *
      ** Invalid rate
      *
     C     ZASIGNok      IFEQ      'N'
     C     TBCR          OREQ      0
 
     C                   ADD       1             Idx
     C                   MOVEL     'DDBRTE'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0140'     MsgidXAr(Idx)
     C                   MOVE      'N'           DDBRTEOk
 
     C                   ELSE
      *
      ** It must be within 10% of spot rate
      *
     C     SetCcySPRT    DIV       10            APWRK1
     C     SetCcySPRT    ADD       APWRK1        APWRK2
 
     C     TBCR          IFGT      APWRK2
     C                   ADD       1             WIx
     C                   MOVEL     'DDBRTE'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0141'     WMsgidXAr(WIx)
     C                   MOVE      'W'           DDBRTEOk
     C                   ELSE
 
     C     SetCcySPRT    SUB       APWRK1        APWRK2
 
     C     TBCR          IFLT      APWRK2
     C                   ADD       1             WIx
     C                   MOVEL     'DDBRTE'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0141'     WMsgidXAr(WIx)
     C                   MOVE      'W'           DDBRTEOk
     C                   END
     C                   END
     C                   END
 
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * FXMPV - Validation Routine for FX Margin Points               *
      *                                                               *
      *****************************************************************
     C     FXMPV         BEGSR
      *
      * If settlement currency = nominal currency
      * FX Margin Points can't be entered
      *
     C     DDSETC        IFEQ      NMCY
     C     DDFXMP        ANDNE     *BLANKS
     C                   ADD       1             Idx
     C                   MOVEL     'DDFXMP'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0527'     MsgidXAr(Idx)
     C                   MOVE      'N'           DDFXMPOk
     C                   GOTO      EFXMPV
     C                   END
      *
      * If settlement currency is NOT = nominal currency
      * FX Margin Points is optional
      *
     C     DDSETC        IFNE      NMCY
     C     DDFXMP        ANDEQ     *BLANKS
     C                   GOTO      EFXMPV
     C                   END
      *                                                                                       CGL029
      ** If settlement currency = nominal currency                                            CGL029
      ** Further validation for FX Margin Points not needed                                   CGL029
      *                                                                                       CGL029
     C     DDSETC        IFEQ      NMCY                                                       CGL029
     C                   GOTO      EFXMPV                                                     CGL029
     C                   ENDIF                                                                CGL029
      *
      * If FX Margin Points is entered, it must be a valid number
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDFXMP        ZFIELD
     C                   Z-ADD     2             ZADEC
     C                   Z-ADD     5             ZADIG
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
 
     C     ZALIGNok      IFEQ      'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDFXMP'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0527'     MsgidXAr(Idx)
     C                   MOVE      'N'           DDFXMPOk
     C                   GOTO      EFXMPV
     C                   END
      *
     C                   MOVE      ZFIELD        FXMP
      *
      **  Check if equivalent exchange rate is within defined tolerance
      **  First get Normally-Quoted Decimal Places.
      *
     C                   EXSR      SRNQDP
 
     C     ZNQDPX        ADD       1             ZA                1 0
      *
      **  Compute the maximum margin points allowed.
      **  Maximum Marg Pts = Xccy rate * Tolerance * 10**Quoted DP
      *
     C     FTTMRT        DIV       100           W1                3 2
     C     W1            MULT(H)   TDER          W2               13 8
     C     W2            MULT(H)   AP(ZA)        WMAXPT            7 2
      *
      **  If the entered margin points is greater than the maximum
      **  allowed, display warning error code.
      *
     C     FXMP          IFGT      WMAXPT
     C                   ADD       1             WIx
     C                   MOVEL     'DDFXMP'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0528'     WMsgidXAr(WIx)
     C                   MOVE      'W'           ddFXMPOk
     C                   ENDIF
      *
      **  Calculate Margin rate.
      *
     C     FXMP          DIV(H)    AP(ZA)        FXMR
      *
      ** Adjust exchange rate with margin rate
      *
     C     DDTDTP        IFEQ      'TP'
     C     DDSMDI        ANDEQ     'M'
     C     DDTDTP        OREQ      'TS'
     C     DDSMDI        ANDEQ     'D'
     C                   SUB       FXMR          TDER
     C                   ELSE
     C                   ADD       FXMR          TDER
     C                   END
      *
      ** Convert countervalue with adjusted rate
      *
     C                   Z-ADD     TCTR          ZAMTCI
     C                   Z-ADD     TDER          ZEXCH
     C                   MOVE      DDSMDI        ZMD
     C                   MOVE      NMCY          ZCCYI
     C                   MOVE      DDSETC        ZCCYO
     C                   MOVE      NomCcyDec     ZCDPI
     C                   MOVE      SetCcyDec     ZCDPO
     C                   EXSR      ZCONV
     C                   Z-ADD     ZAMTCO        WCTRV1           15 0
      *
      ** Adjust exchange rate with margin rate
      *
     C     DDTDTP        IFEQ      'TP'
     C     DDSMDI        ANDEQ     'M'
     C     DDTDTP        OREQ      'TS'
     C     DDSMDI        ANDEQ     'D'
     C     TDER          ADD       FXMR          ZEXCH
     C                   ELSE
     C     TDER          SUB       FXMR          ZEXCH
     C                   END
      *
      ** Convert countervalue with adjusted rate
      *
     C                   EXSR      ZCONV
     C                   Z-ADD     ZAMTCO        WCTRV2           15 0
      *
      ** Margin amount is difference of above 2 countervalues
      *
     C     DDTDTP        IFEQ      'TP'
     C     WCTRV2        SUB       WCTRV1        MAMT
     C                   ELSE
     C     WCTRV1        SUB       WCTRV2        MAMT
     C                   END
      *
      ** Format Margin Amount
      *
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      MAMT          ZFLD15
     C                   Z-ADD     SetCcyDec     ZDECS
     C                   MOVE      'J'           ZECODE
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM                    ZDECS             1 0
     C                   PARM                    ZECODE            1
     C                   PARM                    ZOUT21           21
      *
     C                   MOVE      ZOUT21        DDMAMT
      *
     C     EFXMPV        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRNQDP - Get normally quoted decimal places                   *
      *                                                               *
      *****************************************************************
     C     SRNQDP        BEGSR
      *
      ** --------------------------------------------------------------
      **  If either the nominal or settlement currency is the base
      **  currency obtain the number of normally-quoted decimal places
      **  for the other currency. Otherwise:
      **      A)  If ZNQDP1 =  ZNQDP2 =  5       :   ZNQDPX = 5
      **      B)  If ZNQDP1 =  ZNQDP2 <> 5  or
      **             ZNQDP1 <> ZNQDP2
      **             1)  If Rate >= 100          :   ZNQDPX = 2
      **             2)  If 100 > Rate >= 20     :   ZNQDPX = 3
      **             3)  If 20  > Rate >= 1      :   ZNQDPX = 4
      **             4)  If 1   > Rate           :   ZNQDPX = 5
      **---------------------------------------------------------------
      *
     C                   SELECT
      *
     C     NMCY          WHENEQ    BJCYCD
     C                   Z-ADD     ZNQDP2        ZNQDPX            1 0
      *
     C     DDSETC        WHENEQ    BJCYCD
     C                   Z-ADD     ZNQDP1        ZNQDPX
      *
     C     ZNQDP1        WHENEQ    ZNQDP2
     C     ZNQDP1        ANDEQ     5
     C                   Z-ADD     5             ZNQDPX
      *
     C     TDER          WHENEQ    100
     C                   Z-ADD     2             ZNQDPX
      *
     C     TDER          WHENLT    100
     C     TDER          ANDGE     20
     C                   Z-ADD     3             ZNQDPX
      *
     C     TDER          WHENLT    20
     C     TDER          ANDGE     1
     C                   Z-ADD     4             ZNQDPX
      *
     C     TDER          WHENLT    1
     C                   Z-ADD     5             ZNQDPX
      *
     C                   ENDSL
      *
     C     SRNQD9        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZCONV - Convert one currency amount to another                *
      *                                                               *
      *****************************************************************
     C     ZCONV         BEGSR
 
     C                   CALLB     'ZCONV'
     C                   PARM                    ZAMTCI           15 0
     C                   PARM                    ZEXCH            13 8
     C                   PARM                    ZMD               1
     C                   PARM                    ZCCYI             3
     C                   PARM                    ZCCYO             3
     C                   PARM                    ZCDPI             1 0
     C                   PARM                    ZCDPO             1 0
     C                   PARM      *ZERO         ZAMTCO           15 0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
 
      * INPUTS
 
      * Response mode
     C                   PARM                    RespMode          1
 
      ** Trade Exchange Rates
     C                   PARM                    TrExch
 
      ** Nominal Currency
      ** Trade Type
      ** Settlement Currency
     C                   PARM                    NMCY              3
     C                   PARM                    DDTDTP            2
     C                   PARM                    DDSETC            3
 
      ** Nominal Currency Details
      ** Settlement Currency Details
     C                   PARM                    NomCcyDts
     C                   PARM                    SetCcyDts
 
      ** Trade countervalue (in nominal currency)
     C                   PARM                    TCTR             15 0
 
      ** ICD
     C                   PARM                    BJCYCD            3
     C                   PARM                    BGN0ST            1
     C                   PARM                    FTTMRT
 
      * OUTPUTS
 
      ** Exchange Rate Multiply/Divide indicator
      ** Exchange Rate
      ** Base Currency Rate
      ** FX Margin Points
      ** FX Margin Rate
      ** FX Margin Amount
     C                   PARM                    TMDI              1
     C                   PARM                    TDER             13 8
     C                   PARM                    TBCR             13 8
     C                   PARM                    FXMP              7 2
     C                   PARM                    FXMR             13 8
     C                   PARM                    MAMT             13 0
 
      ** FX Margin Amount
     C                   PARM                    DDMAMT           18
 
      ** Trade Exchange Rates OK inds
     C                   PARM                    OKTrExch
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
** AP - Array of powers of 10.
0000000001
0000000010
0000000100
0000001000
0000010000
0000100000
0001000000
0010000000
0100000000
1000000000
