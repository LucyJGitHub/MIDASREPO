     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Loans/deposits rollover validation')          *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMLDNIROV - LOANS/DEPOSITS & NAS ISSUED ROLLOVER VALIDATION  *
      *                                                               *
      *  Function:  This module validates the rollover attributes of a*
      *             deal that would roll over a given deal.           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CGL165             Date 23Feb15               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CDL093             Date 08Apr14               *
      *                 MD025680           Date 21Mar14               *
      *                 MD000091           Date 14May13               *
      *                 AR947093           Date 26Apr12               *
      *                 AR953104           Date 14Apr12               *
      *                 AR847249           Date 28Jan12               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG17342           Date 01Apr08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 11Jul06               *
      *                 219592             Date 14Jul05               *
      *                 CDL038             Date 10May05               *
      *                 239547             Date 28Apr06               *
      *                 238592             Date 21Mar06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL033             Date 10Feb05               *
      *                 CMM105             Date 22Jun04               *
      *                 BUG2804            Date 20May04               *
      *                 CGL014             Date 20Oct03               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 222727             Date 05Nov03               *
      *                 CDL010             Date 02Aug02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 208051             Date 02Aug02               *
      *                 196380             Date 15May02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP067             Date 24Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 15May01               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP051             Date 09Nov99               *
      *                 CDL007             DATE 05Oct99               *
      *                 CPB001             Date 01Jun99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 154477             Date 29Jan99               *
      *                 CAP004  *CREATE    Date 13Oct98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CDL093 - MM Interest calculation type 9.                     *
      *  MD025680 - Incorrect behavior for Rollover deal with Interest*
      *             calc type = 0                                     *
      *  MD000091 - Event Codes Substitution                          *
      *  AR947093 - Base Rate amendment resulted to 0 interest rate   *
      *  AR953104 - No error message for zero final rate              *
      *  AR847249 - Negative interest is shown in the main list and   *
      *             Loan Details enquiry screen                       *
      *  CRE073 - Interest Rate Rounding                              *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG17342 - A serious MidasPLus error in rollover to euro.    *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  219592 - Alpha abbreviations is not accepted.  @@MTID should *
      *           be set to 'Y' to activate the function.             *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  239547 - Always validate interest calculation basis for both *
      *           "R" and "A" action codes.                           *
      *  238592 - Validate action code and currency.                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL033 - Floating rate CDs issued                            *
      *  CMM105 - Core changes for GBO005                             *
      *         - Fixed Deposits Held Under Lien                      *
      *         - Upgrade to Midasplus                                *
      *           Core hooks amended:MMLDNIYD01                       *
      *           Core hooks added:MMLDNIYC07                         *
      *  BUG2804- Parameter mismatch in MMLDNIRTV caused by CDL016    *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Automatic rollover of Fixed Term Loans/Deposits     *
      *           (Recompile)                                         *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in MMDELDPP *
      *  CAS004 - Hedge Accounting Phase A                            *
      *  208051 - Call ZA0841 which allows -ve input amounts.         *
      *  196380 - Added parameter to MMLDNIRTV call.                  *
      *  CAP067 - Repurchase Agreements API.                          *
      *  CSD006 - Use long DS with SDBSRTPD.                          *
      *  CAP051 - Automatic Authorisation (MM Part)                   *
      *           Recompiled due to changes in MMDELDPP               *
      *  CDL007 - Deposit Breakdown Penalty                           *
      *           Recompiled due to changes in MMDELDPP               *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to changes in MMDELDPP               *
      *  154477 - Recompile for change to MMVLDNIPD.                  *
      *  CAP004 - APIs phase 3.                                       *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+


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
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D CrDlFilFmt    E DS                  EXTNAME(MMDELDPP)
      * Current Deal in File Format
     D  Z_HKCCY      E                     EXTFLD(HKCCY)
     D  Z_HKCYDP     E                     EXTFLD(HKCYDP)

     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
      ** EXTERNAL DS FOR BASE RATE DETAILS

     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                  238592
      ** EXTERNAL DS FOR CURRENCY DETAILS                                                     238592
                                                                                              238592
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSSDY         E DS                  EXTNAME(DSSDY)                       CSD006
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE                     CSD006

     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                MD025680
      ** External DS for SAR Details                                                        MD025680

     D/COPY WNCPYSRC,MMLDNIYD01
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D HKCYDP          S              1S 0

      ** Index for arrays of error message ids etc
     D Ix              S              3P 0
     D Wx              S              3P 0
     D WIdx            S              3P 0                                                    CAS004
                                                                                              CDL033
      ** allow negative spread                                                                CDL033
     D  SPRT           S              1    DIM(12)                                            CDL033
      ** Array for Spread                                                                     CDL033
                                                                                              CRE073
     D CRE073          S              1A                                                      CRE073
     D DDCNSP          S             12A                                                      CRE073
     D DDRDMT          S              7A                                                      CRE073
     D DDRDFD          S              4A                                                      CRE073
     D ddCNSPOK        S              1A                                                      CRE073
     D ddRDMTOK        S              1A                                                      CRE073
     D ddRDFDOK        S              1A                                                      CRE073
     D TMCNSP          S             11P 7                                                    CRE073
     D NEWSRT          S             11P 7                                                    CRE073
     D NEWFRT          S             11P 7                                                  AR847249
     D PModule         S              6A   INZ('LDNI')                                        CRE073
     D PCurset         S              2P 0                                                    CRE073
     D WWFXRT          S             12A                                                      CRE073
     D DDDCSG          S              1A   INZ('A')                                           CRE073
     D ddDCSGOK        S              1A                                                      CRE073
     D WWBRTT          S             11P 7                                                    CRE073
     D WDDBRTT         S             12A                                                      CRE073

     D CER016          S              1A                                                    MD025680
     D PRtCd           S              7A                                                    MD025680
     D POptn           S              7A                                                    MD025680
     D PSard           S              6A                                                    MD025680
                                                                                              CDL093
     D CDL093          S              1A                                                      CDL093
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
                                                                                            MD000091
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
      *                                                                                       238592
      ** Validate action code                                                                 238592
      *                                                                                       238592
     C     DDRACT        IFEQ      'C'                                                        238592
     C                   EXSR      VAL_RACT                                                   238592
     C                   ENDIF                                                                238592
      *
      ** Validate deal number
      *
     C                   EXSR      VAL_DLNO
      *
      * Validate rollover amount
      *
     C                   EXSR      VAL_RAMN
      *
      * Validate maturity date
      *
     C                   EXSR      VAL_MDAT
      *
      * Validate interest rate details
      *
     C                   EXSR      VAL_IRTD
      *
      ** Validate interest calculation method
      *
     C*****DDRACT        IFEQ      'C'                                                        239547
     C                   EXSR      VAL_ICMT
     C**********         ELSE                                                          238592 239547
     C**********         EVAL      DDICMT = *BLANKS                                    238592 239547
     C**********         ENDIF                                                                239547
      *                                                                                     BUG17342
      * Validate Euro Currency Code                                                         BUG17342
      *                                                                                     BUG17342
     C     DDRACT        IFEQ      'C'                                                      BUG17342
     C                   EXSR      VAL_EURO                                                 BUG17342
     C                   ENDIF                                                              BUG17342
      *                                                                                       CRE073
      * Validate Interest Rounding fields                                                     CRE073
      *                                                                                       CRE073
     C     CRE073        IFEQ      'Y'                                                        CRE073
                                                                                              CRE073
      ** Validate Contractual Spread/Sign                                                     CRE073
                                                                                              CRE073
     C                   EXSR      SRSPSG                                                     CRE073
                                                                                              CRE073
      ** Validate Rounding Method                                                             CRE073
                                                                                              CRE073
     C                   EXSR      SRRNDM                                                     CRE073
                                                                                              CRE073
      ** Validate Rounding Fraction/Decimal                                                   CRE073
                                                                                              CRE073
     C                   EXSR      SRRNDF                                                     CRE073
                                                                                              CRE073
      ** If all interest rate rounding related fields are valid                               CRE073
      ** compute for the new spread rate                                                      CRE073
                                                                                              CRE073
     C                   IF        ddCNSPOK = 'Y' AND                                         CRE073
     C                             ddCNSPOK = 'Y' AND                                         CRE073
     C                             ddRDMTOK = 'Y' AND                                         CRE073
     C                             ddRDFDOK = 'Y'                                             CRE073
     C                   EXSR      SRSPRT                                                     CRE073
                                                                                              CRE073
     C                   ENDIF                                                                CRE073
     C                   ENDIF                                                                CRE073
      *
      * Return
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL_DLNO - VALIDATE DEAL NUMBER
      ******************************************************************
     C     VAL_DLNO      BEGSR
      *
     C                   CALLB     'MMLDNIRTV'
      *
      * INPUTS
      *
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    @@MODE            6
      *
      * Response mode
     C                   PARM      'S'           @@RSMD            1
      *
      * Action Code
     C                   PARM      'I'           DDACTN            1
      *
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      *
      * Front Office Associated Transaction Id
     C                   PARM                    FOASID           20
      *
      * (Midas) Deal Number
     C                   PARM                    DDDLNO
      *                                                                                       196380
      * (Midas) Depot Movement Reference                                                      196380
     C                   PARM                    DDDDMR            6                          196380
      *
      * (Midas) Associated Deal Number
     C                   PARM                    DDDADN
      *
      * Booking branch
     C                   PARM                    DDBRCA
      *                                                                                       CAP067
      * REPO Flag                                                                             CAP067
     C                   PARM      'N'           RepoFlag          1                          CAP067
      *
      * OUTPUTS
      *
      * (Current) deal in file format
     C                   PARM                    CrDlFilFmt
     C/COPY WNCPYSRC,MMLDNIYC06
      *
      * OK - Action code
     C                   PARM      *BLANK        OKACTN            1
      *
      * OK - Deal Number
     C                   PARM      *BLANK        OKDLNO            1
      *
      * OK - Booking branch
     C                   PARM      *BLANK        OKBRCA            1
      ** Blocked/Unblock Action                                                              BUG2804
     C                   PARM                    BUACT             1                         BUG2804
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Ix
                                                                                              CAS004
      ** Warning flds/message IDs/message data (arrays) from/to caller                        CAS004
                                                                                              CAS004
     C                   PARM                    WFldNamArr                                   CAS004
     C                   PARM                    WMsgIdArr                                    CAS004
     C                   PARM                    WMsgDtaArr                                   CAS004
                                                                                              CAS004
      ** Array index (3P0) from/to caller                                                     CAS004
                                                                                              CAS004
     C                   PARM                    WIdx                                         CAS004
     C/COPY WNCPYSRC,MMLDNIYC07
      *
      * If any fields in error highlight deal number
      *
     C     OKACTN        IFEQ      'N'
     C     OKDLNO        OREQ      'N'
     C     OKBRCA        OREQ      'N'
     C                   MOVE      'N'           ddDLNOok
     C                   ENDIF
      *
     C     EVAL_DLNO     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL_RAMN - VALIDATE ROLLOVER AMOUNT
      ******************************************************************
     C     VAL_RAMN      BEGSR
      *
      * Validate principal is numeric
      *
     C                   Z-ADD     HKCYDP        @@IDP
     C     15            SUB       HKCYDP        @@IINT
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDRAMN        @@ALPH
     C                   MOVE      'N'           @@MTID            1
     C                   EXSR      VALAMT
      *
      ** Non numeric
      *
     C     @@ERCD        IFEQ      1
     C     @@ERCD        OREQ      2
     C                   MOVE      'N'           ddRAMNok
     C                   ADD       1             Ix
     C                   MOVEL     'DDRAMN'      FldNameArr(Ix)
     C                   MOVEL     'MMM0675'     MsgIdArr(Ix)
     C                   GOTO      EVAL_RAMN
     C                   END
      *
      ** If the amount returned by the subroutine is negative
      ** or nil send a mesage to that effect
      *
     C     @@AMT         IFLE      *ZEROS
     C                   MOVE      'N'           ddRAMNok
     C                   ADD       1             Ix
     C                   MOVEL     'DDRAMN'      FldNameArr(Ix)
     C                   MOVEL     'MMM0676'     MsgIdArr(Ix)
     C                   GOTO      EVAL_RAMN
     C                   END
      *
      ** Return the edited amount
      *
     C                   MOVE      @@ALPH        DDRAMN
      *
      ** If rollover from 'in' currency to Euros
      ** Convert principal amount to Euro equivalent
      *
     C     DDRACT        IFEQ      'C'
     C     BKEURO        ANDNE     *BLANK                                                   BUG17342
                                                                                              238592
     C                   MOVE      BKEURO        DDCCY                                        238592
                                                                                              238592
     C                   MOVE      @@AMT         Principal        15 0
     C                   CALL      'EU0200'
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      Principal     P@FRAM           18 3
     C                   PARM      HKCCY         P@FRCY            3
     C                   PARM      BKEURO        P@TOCY            3
     C                   PARM      *ZERO         P@OUTA           15 0
     C                   PARM                    P@INTA           18 3
     C                   PARM                    P@EXRT           15 9
     C                   PARM                    P@MDIN            1
      *
      * DATABASE ERROR
      *
     C     P@RTCD        IFEQ      '*ERROR*'
     C                   MOVEL     'EU0200'      DBFILE
     C                   MOVE      '101'         DBASE
     C                   MOVEL     HKCCY         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Format the Euro equivalent amount for screen output
      *
     C                   Z-ADD     P@OUTA        @@AMTW
     C                   Z-ADD     EuroNBDP      @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDAMNP
     C                   ELSE
     C                   MOVE      HKCCY         DDCCY                                        238592
     C                   MOVE      DDRAMN        DDAMNP
     C                   ENDIF
      *
     C     EVAL_RAMN     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL_MDAT - VALIDATE MATURITY DATE
      ******************************************************************
     C     VAL_MDAT      BEGSR
      *
      * Test if maturity date is numeric
      *
     C                   TESTN                   DDMDAT               9798
      *
      * It is not numeric
      *
     C     *IN97         IFEQ      '0'
     C     *IN98         ANDEQ     '0'
     C                   MOVE      'N'           ddMDATok
     C                   ADD       1             Ix
     C                   MOVEL     'DDMDAT'      FldNameArr(Ix)
     C                   MOVEL     'MMM0677'     MsgIdArr(Ix)
     C                   GOTO      EVAL_MDAT
     C                   END
      *
      * Check if maturity date is a valid date
      *
     C                   CALLB     'ZAVDATE'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM      DDMDAT        @@DATE            6
     C                   PARM                    BJDFIN
     C                   PARM                    NewMatDate        5 0
      *
      * If not a valid date
      *
     C     RetCodeOut    IFEQ      'Error'
     C                   MOVE      'N'           ddMDATok
     C                   ADD       1             Ix
     C                   MOVEL     'DDMDAT'      FldNameArr(Ix)
     C                   MOVEL     'MMM0678'     MsgIdArr(Ix)
     C                   GOTO      EVAL_MDAT
     C                   END
      *
      * Maturity date ought not to be a holiday in the new deal currency
      *
     C                   CALLB     'ZCHKH'
     C                   PARM      NewMatDate    ZDAYNO            5 0
     C                   PARM      DDCCY         ZCCY              3
     C                   PARM      *BLANK        ZLOC              3
     C                   PARM      *BLANK        ZIND              1
      *
     C     ZIND          IFEQ      'H'
     C                   MOVE      'W'           ddMDATok
     C                   ADD       1             Wx
     C                   MOVEL     'DDMDAT'      WFldNamArr(Wx)
     C                   MOVEL     'MMM0679'     WMsgIdArr(Wx)
     C**********         MOVEL     'Enter'       WMsgDtaArr(Wx)                             MD000091
     C                   MOVEL     'Enter'       MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      WMsgDtaArr(Wx) = LenStr +%TRIM(MsgDtaTmp)                MD000091
     C                   END
      *
      * New Maturity must be greater than old maturity date
      *
     C     NewMatDate    IFLE      OldMatDate
     C                   MOVE      'N'           ddMDATok
     C                   ADD       1             Ix
     C                   MOVEL     'DDMDAT'      FldNameArr(Ix)
     C                   MOVEL     'MMM0680'     MsgIdArr(Ix)
     C                   GOTO      EVAL_MDAT
     C                   END
      *
     C     EVAL_MDAT     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL_IRTD - VALIDATE INTEREST RATE DETAILS
      ******************************************************************
     C     VAL_IRTD      BEGSR
      *
      ** If the spread/rate is blank, this is an error,
      ** unless the base rate code is entered
      *
     C     DDSPRT        IFEQ      *BLANKS
      *
     C     DDBSRC        IFEQ      *BLANKS
     C                   MOVE      'N'           ddSPRTok
     C                   ADD       1             Ix
     C                   MOVEL     'DDSPRT'      FldNameArr(Ix)
     C                   MOVEL     'MMM0419'     MsgIdArr(Ix)
     C                   GOTO      EVAL_IRDT
     C                   ENDIF
      *
      ** Else if the spread/rate is NOT blank,
      ** Check that it is a valid number with 7 decimal places
      *
     C                   ELSE
      *
     C/COPY WNCPYSRC,MMLDNIYC01
      *                                                                                       CDL033
      ** Check if negative Spread:                                                            CDL033
      ** if so -save the minus sign via indicator                                             CDL033
      *                                                                                       CDL033
     C                   IF        CDL033 = 'Y'                                               CDL033
                                                                                              CDL033
     C                   MOVE      *OFF          *IN55                                        CDL033
     C                   Z-ADD     *ZEROS        RES               3 0                        CDL033
     C     '-'           SCAN      DDSPRT:1      RES                      55                  CDL033
                                                                                              CDL033
     C     *IN55         IFEQ      *ON                                                        CDL033
     C                   MOVEA     DDSPRT        SPRT                                         CDL033
     C                   MOVE      ' '           SPRT(RES)                                    CDL033
     C                   MOVEA     SPRT          DDSPRT                                       CDL033
     C                   ENDIF                                                                CDL033
                                                                                              CDL033
     C                   ENDIF                                                                CDL033
                                                                                              CDL033
     C                   Z-ADD     7             @@IDP
     C     11            SUB       7             @@IINT
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDSPRT        @@ALPH
     C                   MOVE      'N'           @@MTID            1
     C                   EXSR      VALAMT
      *
     C     @@ERCD        IFNE      0
     C                   MOVE      'N'           ddSPRTok
     C                   ADD       1             Ix
     C                   MOVEL     'DDSPRT'      FldNameArr(Ix)
     C/COPY WNCPYSRC,MMLDNIYC02
     C                   IF        CDL033 = 'Y'                                               CDL033
     C                   MOVEL     'MMN9007'     MsgIdArr(Ix)                                 CDL033
     C                   ELSE                                                                 CDL033
     C                   MOVEL     'MMM0422'     MsgIdArr(Ix)
     C                   ENDIF                                                                CDL033
     C/COPY WNCPYSRC,MMLDNIYC03
     C                   GOTO      EVAL_IRDT
     C                   END
      *
      ** Return the edited amount
      *
     C                   MOVE      @@ALPH        DDSPRT
     C/COPY WNCPYSRC,MMLDNIYC04
      *                                                                                       CDL033
      ** Insert the minus sign, if applicable                                                 CDL033
     C                   IF        CDL033 = 'Y'                                               CDL033
                                                                                              CDL033
     C     *IN55         IFEQ      *ON                                                        CDL033
     C                   MOVE      *OFF          *IN56                                        CDL033
     C                   Z-ADD     *ZEROS        RES               3 0                        CDL033
     C     ' '           SCAN      DDSPRT:1      RES                      56                  CDL033
                                                                                              CDL033
     C     *IN56         IFEQ      *ON                                                        CDL033
     C     @@AMT         ANDNE     *ZEROS                                                     CDL033
     C                   MOVEA     DDSPRT        SPRT                                         CDL033
                                                                                              CDL033
     C     RES           DOWLT     12                                                         CDL033
                                                                                              CDL033
     C     SPRT(RES)     IFNE      ' '                                                        CDL033
     C                   SUB       1             RES                                          CDL033
     C                   LEAVE                                                                CDL033
     C                   ENDIF                                                                CDL033
                                                                                              CDL033
     C                   ADD       1             RES                                          CDL033
     C                   ENDDO                                                                CDL033
                                                                                              CDL033
     C                   MOVE      '-'           SPRT(RES)                                    CDL033
     C                   MOVEA     SPRT          DDSPRT                                       CDL033
     C                   ENDIF                                                                CDL033
                                                                                              CDL033
     C                   ENDIF                                                                CDL033
                                                                                              CDL033
     C                   ENDIF                                                                CDL033
                                                                                              CDL033
     C                   END
      *
      ** Check that the base rate code is valid, if it is entered
      *
     C     DDBSRC        IFNE      *BLANKS
      *
     C                   CALL      'AOBSRTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDCCY         @AJCD             3
     C                   PARM      DDBSRC        @DWNB             2
     C*****SDBSRT        PARM      SDBSRT        DSFDY                          CSD006
     C     SDBSRT        PARM      SDBSRT        DSSDY                          CSD006
     C*
     C     @RTCD         IFNE      *BLANK
     C                   MOVE      'N'           ddBSRCok
     C                   ADD       1             Ix
     C                   MOVEL     'DDBSRC'      FldNameArr(Ix)
     C                   MOVEL     'MMM2704'     MsgIdArr(Ix)
     C                   GOTO      EVAL_IRDT
     C                   ENDIF
     C                   MOVEL     BABSRC        DDBSRC
     C                   EVAL      WWBRTT = 0                                                 CRE073
     C                   EVAL      WWBRTT = BACBSR                                            CRE073
     C/COPY WNCPYSRC,MMLDNIYC05
      *                                                                                       CDL033
      ** Check if Interest Rate is negative                                                   CDL033
      *                                                                                       CDL033
     C                   IF        CDL033 = 'Y'                                               CDL033
                                                                                              CDL033
     C                   Z-ADD     *ZEROS        InterestRate     11 7                        CDL033
     C     BACBSR        ADD       @@AMT         InterestRate                                 CDL033
                                                                                              CDL033
     C     InterestRate  IFLT      *ZEROS                                                     CDL033
     C                   MOVE      'N'           ddSPRTok                                     CDL033
     C                   ADD       1             Ix                                           CDL033
     C                   MOVEL     'DDSPRT'      FldNameArr(Ix)                               CDL033
     C                   MOVEL     'MMN9008'     MsgIdArr(Ix)                                 CDL033
     C                   GOTO      EVAL_IRDT                                                  CDL033
     C                   ENDIF                                                                CDL033
                                                                                              CDL033
     C                   ENDIF                                                                CDL033
                                                                                              CDL033
     C                   ENDIF
      *
     C     EVAL_IRDT     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL_ICMT - VALIDATE INTEREST CALCULATION METHOD
      ******************************************************************
     C     VAL_ICMT      BEGSR
      *
     C                   SELECT
     C     DDICMT        WHENEQ    '1'
     C     DDICMT        WHENEQ    '2'
     C     DDICMT        WHENEQ    '3'
     C     DDICMT        WHENEQ    '4'
     C     DDICMT        WHENEQ    '5'
     C     DDICMT        WHENEQ    '6'
     C     DDICMT        WHENEQ    '9'                                                        CDL093
     C     CDL093        ANDEQ     'Y'                                                        CDL093
     C     DDICMT        WHENEQ    '0'                                                      MD025680
     C     CER016        ANDEQ     'Y'                                                      MD025680
     C                   OTHER
     C                   MOVE      'N'           ddICMTok
     C                   ADD       1             Ix
     C                   MOVEL     'DDICMT'      FldNameArr(Ix)
     C                   MOVEL     'MMM2703'     MsgIdArr(Ix)
     C                   GOTO      EVAL_ICMT
     C                   ENDSL
      *
     C     EVAL_ICMT     ENDSR
      *****************************************************************
      /EJECT                                                                                BUG17342
      *****************************************************************                     BUG17342
      * VAL_EURO - VALIDATE EURO CURRENCY CODE                                              BUG17342
      ******************************************************************                    BUG17342
     C     VAL_EURO      BEGSR                                                              BUG17342
      *                                                                                     BUG17342
      ** Error if Euro currency code field is blank                                         BUG17342
      *                                                                                     BUG17342
     C     BKEURO        IFEQ      *BLANK                                                   BUG17342
     C                   MOVE      'N'           ddEUROok                                   BUG17342
     C                   ADD       1             Ix                                         BUG17342
     C                   MOVEL     'BKEURO'      FldNameArr(Ix)                             BUG17342
     C                   MOVEL     'MMM9206'     MsgIdArr(Ix)                               BUG17342
     C                   END                                                                BUG17342
     C                   ENDSR                                                              BUG17342
      *****************************************************************                     BUG17342
      /EJECT                                                                                  238592
      *****************************************************************                       238592
      * VAL_RACT - VALIDATE ACTION CODE                                                       238592
      ******************************************************************                      238592
     C     VAL_RACT      BEGSR                                                                238592
                                                                                              238592
     C     CEU015        IFEQ      'Y'                                                        238592
      *                                                                                       238592
      ** Get the deal currency details                                                        238592
      *                                                                                       238592
     C                   CALLB     'AOCURRR0'                                                 238592
     C                   PARM      '*DBERR '     @RTCD             7                          238592
     C                   PARM      '*KEY   '     @OPTN             7                          238592
     C                   PARM      HKCCY         @AJCD             3                          238592
     C     SDCURR        PARM      SDCURR        DSSDY                                        238592
      *                                                                                       238592
      * DATABASE ERROR                                                                        238592
      *                                                                                       238592
     C     @RTCD         IFNE      *BLANK                                                     238592
     C                   MOVEL     'SDCURRPD'    DBFILE                                       238592
     C                   MOVEL     '100'         DBASE                                        238592
     C                   MOVEL     HKCCY         DBKEY                                        238592
     C                   EXSR      *PSSR                                                      238592
     C                   ENDIF                                                                238592
      *                                                                                       238592
      ** If original ccy is not an 'In' ccy, issue error message                              238592
      ** Cannot rollover the deal to Euro                                                     238592
      *                                                                                       238592
     C     A6INCY        IFNE      'Y'                                                        238592
     C                   MOVE      'N'           ddRACTok                                     238592
     C                   ADD       1             Ix                                           238592
     C                   MOVEL     'DDRACT'      FldNameArr(Ix)                               238592
     C                   MOVEL     'MMM2706'     MsgIdArr(Ix)                                 238592
     C                   ENDIF                                                                238592
                                                                                              238592
     C                   ENDIF                                                                238592
                                                                                              238592
     C                   ENDSR                                                                238592
      *****************************************************************                       238592
      /EJECT
      *****************************************************************
      * VALAMT - VALIDATE/REFORMAT AMOUNT                             *
      *****************************************************************
     C     VALAMT        BEGSR
     C**********         CALLB     'ZA0840'                                                   208051
     C                   CALLB     'ZA0841'                                                   208051
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    @@ALPH           16            Display field
     C                   PARM                    @@IDP             3 0          no.of dec.plcs
     C                   PARM                    @@IINT            3 0          no.of integers
     C**********         PARM                    @@MTID            1            Million/Thous.219592
     C                   PARM      'Y'           @@MTID            1            Mil/Thou      219592
     C                   PARM      *ZERO         @@ERCD            1 0          Error code
     C                   PARM      *ZERO         @@AMT            15 0          File field
     C                   PARM                    BNDCSP
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FMTAMT - FORMAT AMOUNT FOR DISPLAY                            *
      *****************************************************************
     C     FMTAMT        BEGSR
      *
     C                   CALLB     'ZA0920'
     C                   PARM      *BLANK        @@RETC           10
     C                   PARM                    @@AMTW           13 0
     C                   PARM                    @@QECN            1 0
     C                   PARM                    BNDCSP            1
     C                   PARM      *BLANK        @@AMTD           14
      *
     C                   ENDSR
      *****************************************************************                       CRE073
      /EJECT                                                                                  CRE073
      *****************************************************************                       CRE073
      *  SRSPSG - Validate Contractual Spread/Sign                    *                       CRE073
      *****************************************************************                       CRE073
     C     SRSPSG        BEGSR                                                                CRE073
     C                                                                                        CRE073
     C                   EVAL      WDDBRTT = *BLANKS                                          CRE073
     C                   IF        WWBRTT <> 0                                                CRE073
     C                   EVAL      WDDBRTT = %CHAR(WWBRTT)                                    CRE073
     C                   EVAL      WDDBRTT = %TRIMR(WDDBRTT)                                  CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
                                                                                              CRE073
     C                   EVAL      DDDCSGOK ='Y'                                              CRE073
     C                   CALL      'ZAVCSPSG'                                                 CRE073
     C                   PARM      *BLANKS       P@RTCD                                       CRE073
     C                   PARM                    WDDBRTT                                      CRE073
     C                   PARM                    DDBSRC                                       CRE073
     C                   PARM                    WWFXRT                                       CRE073
     C                   PARM                    DDCNSP                                       CRE073
     C                   PARM                    DDDCSG                                       CRE073
     C                   PARM      *ZERO         TMCNSP                                       CRE073
     C                   PARM                    PModule                                      CRE073
     C                   PARM      *ZERO         PCurset                                      CRE073
     C                   PARM                    FldNameArr                                   CRE073
     C                   PARM                    MsgIDArr                                     CRE073
     C                   PARM                    MsgDtaArr                                    CRE073
     C                   PARM                    Ix                                           CRE073
     C                   PARM                    ddCNSPOK                                     CRE073
     C                   PARM                    ddDCSGOK                                     CRE073
                                                                                              CRE073
     C                   ENDSR                                                                CRE073
      *****************************************************************                       CRE073
      /EJECT                                                                                  CRE073
      *****************************************************************                       CRE073
      *  SRRNDM - Validate Rounding Method                            *                       CRE073
      *****************************************************************                       CRE073
     C     SRRNDM        BEGSR                                                                CRE073
                                                                                              CRE073
     C                   CALL      'ZAVRNDMT'                                                 CRE073
     C                   PARM      *BLANKS       P@RTCD                                       CRE073
     C                   PARM                    DDRDMT                                       CRE073
     C                   PARM                    DDCNSP                                       CRE073
     C                   PARM                    DDRDFD                                       CRE073
     C                   PARM                    PModule                                      CRE073
     C                   PARM      *ZERO         PCurset                                      CRE073
     C                   PARM                    FldNameArr                                   CRE073
     C                   PARM                    MsgIDArr                                     CRE073
     C                   PARM                    MsgDtaArr                                    CRE073
     C                   PARM                    Ix                                           CRE073
     C                   PARM                    ddRDMTOK                                     CRE073
                                                                                              CRE073
     C                   ENDSR                                                                CRE073
      *****************************************************************                       CRE073
      /EJECT                                                                                  CRE073
      *****************************************************************                       CRE073
      *  SRRNDF - Validate Fraction/Decimal                           *                       CRE073
      *****************************************************************                       CRE073
     C     SRRNDF        BEGSR                                                                CRE073
                                                                                              CRE073
     C                   EVAL      DDRDFDOK = 'Y'                                             CRE073
     C                   CALL      'ZAVRNDFD'                                                 CRE073
     C                   PARM      *BLANKS       P@RTCD                                       CRE073
     C                   PARM                    DDRDFD                                       CRE073
     C                   PARM                    DDCNSP                                       CRE073
     C                   PARM                    DDRDMT                                       CRE073
     C                   PARM                    PModule                                      CRE073
     C                   PARM      *ZERO         PCurset                                      CRE073
     C                   PARM                    FldNameArr                                   CRE073
     C                   PARM                    MsgIDArr                                     CRE073
     C                   PARM                    MsgDtaArr                                    CRE073
     C                   PARM                    Ix                                           CRE073
     C                   PARM                    ddRDFDOK                                     CRE073
                                                                                              CRE073
     C                   ENDSR                                                                CRE073
      *****************************************************************                       CRE073
      /EJECT                                                                                  CRE073
      *****************************************************************                       CRE073
      *  SRSPRT - Compute for the new spread rate based on the        *                       CRE073
      *           rounding rules                                      *                       CRE073
      *****************************************************************                       CRE073
     C     SRSPRT        BEGSR                                                                CRE073
                                                                                              CRE073
     C                   CALL      'ZACALCSPRT'                                               CRE073
     C                   PARM      *BLANKS       P@RTCD                                       CRE073
     C                   PARM                    WWBRTT                                       CRE073
     C                   PARM                    TMCNSP                                       CRE073
     C                   PARM                    DDDCSG                                       CRE073
     C                   PARM                    DDRDMT                                       CRE073
     C                   PARM                    DDRDFD                                       CRE073
     C                   PARM      *ZERO         NEWSRT                                       CRE073
     C                   PARM      *ZEROS        NEWFRT                                     AR847249
                                                                                              CRE073
     C                   IF        P@RTCD <> *BLANKS                                          CRE073
     C                   EXSR      *PSSR                                                      CRE073
     C                   ELSE                                                                 CRE073
                                                                                              CRE073
     C**********         IF        NEWFRT = 0 AND                                  AR953104 AR947093
     C**********                   DDRDMT <> *BLANKS                               AR953104 AR947093
     C**********         EVAL      DDRDMTOK = 'N'                                  AR953104 AR947093
     C**********         EVAL      Ix = Ix + 1                                     AR953104 AR947093
     C**********         EVAL      FldNameArr(Ix) = 'DDRDMT'                       AR953104 AR947093
     C**********         EVAL      MsgIDArr(Ix) = 'USS0015'                        AR953104 AR947093
      **********                                                                   AR953104 AR947093
     C**********         EVAL      MsgDtaArr(Ix) = %EDITC(NEWFRT:'J')              AR953104 AR947093
      **********                                                                   AR953104 AR947093
     C**********         ELSE                                                      AR953104 AR947093
     C                   IF        NEWSRT <> *ZERO                                            CRE073
     C                   EVAL      DDSPRT = %CHAR(NEWSRT)                                     CRE073
     C                   EVAL      DDSPRT = %TRIMR(DDSPRT)                                    CRE073
     C                   ENDIF                                                                CRE073
     C**********         ENDIF                                                     AR953104 AR947093
                                                                                              CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
     C                   ENDSR                                                                CRE073
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      * Parameters
      *
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      * RETURN CODE
     C                   PARM                    RetCodeIn
      *
      * Rollover action
      * Rollover deal number
      * Deal Number
      * Rollover Amount
      * Maturity Date
      * Base Rate Code
      * Spread/Rate
      * Interest Calc. Method
     C                   PARM                    DDRACT            1
     C                   PARM                    DDDADN            6
     C                   PARM                    DDDLNO            6
     C                   PARM                    DDRAMN           14
     C                   PARM                    DDMDAT            6
     C                   PARM                    DDBSRC            2
     C                   PARM                    DDSPRT           12
     C                   PARM                    DDICMT            1
      *
      * Booking Branch
      * New Deal Currency
      * Principal Amount
      * Old Maturity Date
      * Old Deal Currency
      * Old Deal Currency Decimal Places
     C                   PARM                    DDBRCA            3
     C                   PARM                    DDCCY             3
     C                   PARM                    DDAMNP           14
     C                   PARM                    DDCNSP                                       CRE073
     C                   PARM                    DDRDMT                                       CRE073
     C                   PARM                    DDRDFD                                       CRE073
     C                   PARM                    OldMatDate        5 0
     C                   PARM                    HKCCY             3
     C                   PARM                    HKCYDP
      *
      * ICD
      * Date format
      * Euro currency code
      * Currency decimal separator
      * Euro currency decimal places
     C                   PARM                    BJDFIN            1
     C                   PARM                    BKEURO            3
     C                   PARM                    BNDCSP            1
     C                   PARM                    EuroNBDP          1 0
     C                   PARM                    CDL033            1                          CDL033
     C                   PARM                    CEU015            1                          238592
     C                   PARM                    CRE073                                       CRE073
      *
      * OUTPUTS
      *
      ** Rollover action - OK
      ** Rollover deal number - OK
      ** Deal number - OK
      ** Rollover Amount - OK
      ** Maturity Date - OK
      ** Base Rate Code - OK
      ** Spread/Rate - OK
      ** Int.Calc.Method - OK
      ** Euro Currency Code - OK                                                            BUG17342
     C                   PARM                    ddRACTok          1            broker
     C                   PARM                    ddDADNok          1            broker
     C                   PARM                    ddDLNOok          1            broker
     C                   PARM                    ddRAMNok          1            brokerage
     C                   PARM                    ddMDATok          1            brokerage
     C                   PARM                    ddBSRCok          1            brokerage
     C                   PARM                    ddSPRTok          1            brokerage
     C                   PARM                    ddICMTok          1            brokerage
     C                   PARM                    ddEUROok          1            brokerage   BUG17342
     C                   PARM                    ddCNSPOK                                     CRE073
     C                   PARM                    ddRDMTOK                                     CRE073
     C                   PARM                    ddRDFDOK                                     CRE073
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Wx
      *
      ** Initialize program name
      *
     C                   MOVEL     'MMLDNIROV'   DBPGM
      *                                                                                     MD025680
      ** Check if switchable feature CER016 is installed                                    MD025680
      *                                                                                     MD025680
     C                   CALLB     'AOSARDR0'                                               MD025680
     C                   PARM      *BLANKS       PRtCd                                      MD025680
     C                   PARM      '*VERIFY'     POptn                                      MD025680
     C                   PARM      'CER016'      PSard                                      MD025680
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD025680
      *                                                                                     MD025680
     C                   IF        PRtCd = *BLANKS                                          MD025680
     C                   EVAL      CER016 = 'Y'                                             MD025680
     C                   ELSE                                                               MD025680
     C                   EVAL      CER016 = 'N'                                             MD025680
     C                   ENDIF                                                              MD025680
      *
     C                   CALLB     'AOSARDR0'                                                 CDL093
     C                   PARM      *BLANKS       PRtCd                                        CDL093
     C                   PARM      '*VERIFY'     POptn                                        CDL093
     C                   PARM      'CDL093'      PSard                                        CDL093
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL093
                                                                                              CDL093
     C                   IF        PRtCd = *BLANKS                                            CDL093
     C                   EVAL      CDL093 = 'Y'                                               CDL093
     C                   ELSE                                                                 CDL093
     C                   EVAL      CDL093 = 'N'                                               CDL093
     C                   ENDIF                                                                CDL093
                                                                                              CDL093
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
