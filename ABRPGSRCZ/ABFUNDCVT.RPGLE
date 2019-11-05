     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AB Internal Funding Deals Cvt Fle to Scn Fmt')   *
      *****************************************************************
      *                                                               *
      *  Midas - Internal Funding Module                              *
      *                                                               *
      *  ABFUNDCVT - Internal Funding Deals Convert File to Screen    *
      *              Format                                           *
      *                                                               *
      *  Function:  This module converts the fields of an internal    *
      *             funding deal from their format as on file to a    *
      *             screen format                                     *
      *                                                               *
      *  Component of: ABFUNDSIN - Internal Funding Deals Maintenance *
      *                ABFUNDRPR - Internal Funding Deals Repair      *
      *                ABFUNDCTL - Internal Funding Deals Interface   *
      *                            Controller                         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 261140             Date 16Sep09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11699           Date 19Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 04Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10571           Date 15Feb06               *
      *                 CDL038             Date 10May05               *
      *                 CGL014             Date 20Oct03               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CAS005             Date 16Dec02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP042  *CREATE    Date 08Jan01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  261140 - Missing Front Office ID / Assoc Front Office ID     *
      *  BUG11699 - Use PAmtOutU instead of PAmtOutS to take into     *
      *             consideration the actual interest rate sign.      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10571 - Move '000' in DDNTCE instead of '  0'             *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date                       *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CAS004 - Hedge Accounting Phase A                            *
      *  CAP042 - Conversion of Internal Funding Deal inputs into     *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of Indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRINIT   - Initialization                                    *
      *  SRSetFld - Set output screen fields                          *
      *  SRCvtDat - Convert date fromYYYYMMDD to DDMMYY (or MMDDYY)   *
      *  SRFmtAmt - Format amount for display                         *
      *  SRSclRte - Scale rate                                        *
      *                                                               *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
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
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
 
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      ** The following /COPY includes the MM standard declares:
 
     D/COPY ZACPYSRC,STDDECLARE
 
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
 
      ** Deal Status
     D WStatArr        S              7    DIM(2) CTDATA PERRCD(1)
 
      ** External DS for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External DS for profit centre details
     D SDPRFC        E DS                  EXTNAME(SDPRFCPD)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Current Deal in File Format of main deal
     D CrDlFilFmt1   E DS                  EXTNAME(MMDELDPP)
     D                                     Prefix(D1:2)
     D  QQDoriD1     E                     EXTFLD(QQDORI)                                     CGL029
     D  QQMoriD1     E                     EXTFLD(QQMORI)                                     CGL029
     D  QQDopiD1     E                     EXTFLD(QQDOPI)                                     CGL029
     D  QQMopiD1     E                     EXTFLD(QQMOPI)                                     CGL029
     D  QQRonsD1     E                     EXTFLD(QQRONS)                                     CGL029
     D  QQPonsD1     E                     EXTFLD(QQPONS)                                     CGL029
     D  QQInsaD1     E                     EXTFLD(QQINSA)                                     CGL029
 
      ** Current Deal in File Format of associated deal
     D CrDlFilFmt2   E DS                  EXTNAME(MMDELDPP)
     D                                     Prefix(D2:2)
     D  QQDoriD2     E                     EXTFLD(QQDORI)                                     CGL029
     D  QQMoriD2     E                     EXTFLD(QQMORI)                                     CGL029
     D  QQDopiD2     E                     EXTFLD(QQDOPI)                                     CGL029
     D  QQMopiD2     E                     EXTFLD(QQMOPI)                                     CGL029
     D  QQRonsD2     E                     EXTFLD(QQRONS)                                     CGL029
     D  QQPonsD2     E                     EXTFLD(QQPONS)                                     CGL029
     D  QQInsaD2     E                     EXTFLD(QQINSA)                                     CGL029
 
      ** Deal in Screen Format
     D DealScnFmt    E DS                  EXTNAME(ABFUNDPD)
     D                                     Prefix(DD:2)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PCcy            S              3A
     D PAmtOutS        S             16A
     D PAmtOutU        S             17A
     D PAmtIn          S             15  0
     D PDateOut        S              6  0
     D PErrCde         S              1  0
     D PMulDiv         S              1A
     D PIntRt          S             13  8
     D PISRt           S             13  8
     D PNoOfDecPl      S              1  0
     D PScRte          S             13  8
     D PSxP1           S              1S 0
     D PSxP2           S              1S 0
     D PStatus         S              7A
     D PBJDFIN         S              1A
     D PBNDCSP         S              1A
     D PPCCd           S              4A
     D PPCDesc1        S             30A
     D PPCDesc2        S             30A
     D FRNT            S             20A                                                      261140
     D AFRT            S             20A                                                      261140
 
      ** Parameters for ZALIGN
     D PZAlignOk       S              1A
     D PZField         S             16A
     D PZADEC          S              1P 0
     D PZADIG          S              2P 0
 
     D WPOS1           S              1  0
     D WDDACTN         S              1A
 
     D CAS004          S              1A                                                      CAS004
                                                                                              CAS004
     D CDL019          S              1A                                                      CDL019
     D CDL020          S              1A                                                      CDL020
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
 
      *********************************************************************
      * Main Procedure                                                    *
      *********************************************************************
 
      ** Initialization
 
     C                   EXSR      SRINIT
 
      ** Set output screen fields
 
     C                   EXSR      SRSetFld
 
      * Return
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRSetFld - Set output screen fields                          *
      *****************************************************************
     C     SRSetFld      BEGSR
 
      ** Action Code
 
     C                   EVAL      DDACTN = WDDACTN
 
      ** Deal number 1
 
     C                   MOVE      D1DN38        DDDLNO
 
      ** Branch code 1
 
     C                   IF        D1BRCA <> *BLANKS
     C                   EVAL      DDBRC1 = D1BRCA
     C                   ENDIF
 
      ** Deal sub-type 1
 
     C                   EVAL      DDSTP1 = D1STYP
 
      ** Book code 1
 
     C                   EVAL      DDBOK1 = D1BOKC
 
      ** Profit Centre 1
 
     C                   EVAL      DDPRF1 = D1PRFC
 
      **  Access the profit centre file to find the description of
      **  the profit centre code
 
     C                   IF        DDPRF1 <> *BLANK
 
     C                   CALLB     'AOPRFCR0'
     C                   PARM      *BLANK        @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      DDPRF1        PPCCd
     C     SDPRFC        PARM      SDPRFC        DSSDY
 
      ** Database Error
 
     C                   IF        @RtCd <> *BLANK
     C                   EVAL      DBKEY = DDPRF1                               *************
     C                   EVAL      DBFILE = 'SDPRFCPD'                          * DBERR 001 *
     C                   EVAL      DBASE  = 001                                 *************
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      PPCDesc1 = DSPCDS
 
     C                   ENDIF
 
      ** Deal number 2
 
     C                   EVAL      DDDADN = D1DADN
 
      ** Branch code 2
 
     C                   IF        D2BRCA <> *BLANKS
     C                   EVAL      DDBRC2 = D2BRCA
     C                   ENDIF
 
      ** Deal sub-type 2
 
     C                   EVAL      DDSTP2 = D2STYP
 
      ** Book code 2
 
     C                   EVAL      DDBOK2 = D2BOKC
 
      ** Profit Centre 2
 
     C                   EVAL      DDPRF2 = D2PRFC
 
      **  Access the profit centre file to find the description of
      **  the profit centre code
 
     C                   IF        DDPRF2 <> *BLANK
 
     C                   CALLB     'AOPRFCR0'
     C                   PARM      *BLANK        @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      DDPRF2        PPCCd
     C     SDPRFC        PARM      SDPRFC        DSSDY
 
      ** Database Error
 
     C                   IF        @RtCd <> *BLANK
     C                   EVAL      DBKEY = DDPRF2                               *************
     C                   EVAL      DBFILE = 'SDPRFCPD'                          * DBERR 002 *
     C                   EVAL      DBASE  = 002                                 *************
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      PPCDesc2 = DSPCDS
 
     C                   ENDIF
 
      ** Deal date.
 
     C                   Z-ADD     D1DDYY        @YEAR
     C                   Z-ADD     D1DDMM        @MNTH
     C                   Z-ADD     D1DDDD        @DAY
 
     C                   IF        @DATE <> *ZEROS
     C                   EXSR      SRCvtDat
     C                   MOVE      PDateOut      DDDDAT
     C                   ENDIF
 
      ** Value date
 
     C                   Z-ADD     D1VDYY        @YEAR
     C                   Z-ADD     D1VDMM        @MNTH
     C                   Z-ADD     D1VDDD        @DAY
 
     C                   IF        @DATE <> *ZEROS
     C                   EXSR      SRCvtDat
     C                   MOVE      PDateOut      DDVDAT
     C                   ENDIF
 
      ** Maturity Date
 
     C                   Z-ADD     D1MDYY        @YEAR
     C                   Z-ADD     D1MDMM        @MNTH
     C                   Z-ADD     D1MDDD        @DAY
 
     C                   IF        @DATE <> *ZEROS
     C                   EXSR      SRCvtDat
     C                   MOVE      PDateOut      DDMDAT
     C                   ENDIF
 
      ** Notice Days
 
     C                   IF        D1NTCE = 0
 
     C                   IF        DDSTP1 = 'ID' AND DDMDAT = *BLANKS OR
     C                             DDSTP1 = 'IL' AND DDMDAT = *BLANKS
     C**********         EVAL      DDNTCE = '  0'                                           BUG10571
     C                   EVAL      DDNTCE = '000'                                           BUG10571
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        D1NTCE <> -999
 
     C                   MOVE      *BLANKS       PZField
     C                   MOVE      D1NTCE        PZField
     C                   Z-ADD     0             PZADEC
     C                   Z-ADD     6             PZADIG
     C                   EXSR      SRZAlign
     C                   MOVE      PZField       DDNTCE
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Currency Code
 
     C                   EVAL      DDCCY = D1CCY
 
      ** Principal Amount
 
     C                   IF        D1AMNP < 0
     C                   Z-SUB     D1AMNP        PAmtIn
     C                   ELSE
     C                   Z-ADD     D1AMNP        PAmtIn
     C                   ENDIF
 
     C                   Z-ADD     D1CYDP        PNoOfDecPl
     C                   EXSR      SRFmtAmt
     C                   MOVE      PAmtOutS      DDAMNP
 
      ** Base Currency Rate
 
      **  Access the currency file to find the dealing currency
      **  scaling exponent.
 
     C                   IF        DDCCY <> *BLANK
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      DDCCY         PCcy
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Database Error
 
     C                   IF        @RtCd <> *BLANK
     C                   EVAL      DBKEY = DDCCY                                *************
     C                   EVAL      DBFILE = 'SDCURRPD'                          * DBERR 003 *
     C                   EVAL      DBASE  = 003                                 *************
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Scale the Base Currency Exchange Rate.
 
     C                   Z-ADD     A6SCEX        PSxP1
     C                   Z-ADD     0             PSxP2
     C                   Z-ADD     D1BRAT        PIntRt
     C                   EVAL      PMulDiv = 'M'
     C                   EXSR      SRSclRte
 
      ** Format the rate, using 8 decimal places
 
     C                   IF        PScRte <> 0
     C                   EVAL      PAmtIn = PScRte * 100000000
     C                   Z-ADD     8             PNoOfDecPl
 
      ** Format the rate for 5 integers, if required (& only 7 decimal)
 
     C                   MOVE      *ZERO         WPOS1
     C                   MOVEL     PScRte        WPOS1
 
     C                   IF        WPOS1 <> 0
     C                   Z-ADD     7             PNoOfDecPl
     C                   EVAL      PAmtIn = PAmtIn / 10
     C                   ENDIF
 
     C                   EXSR      SRFmtAmt
     C                   MOVE      PAmtOutS      DDBCXR
     C                   ENDIF
 
     C                   ENDIF
 
      ** Base Rate Code
 
     C                   IF        D1BSRC <> *BLANKS
     C                   EVAL      DDBRTT = D1BSRC
     C                   ENDIF
 
      ** Rate/Spread - if no Base Rate Code has been entered, use the
      ** Input Interest Rate, otherwise use the Spread.
 
     C                   IF        DDBRTT = *BLANKS
 
     C                   IF        D1IIRT < 0
     C                   Z-SUB     D1IIRT        D1IIRT
     C                   ENDIF
     C                   MOVE      D1IIRT        PAmtIn
 
     C                   ELSE
 
     C                   IF        D1SPRD < 0
     C                   Z-SUB     D1SPRD        D1SPRD
     C                   ENDIF
     C                   MOVE      D1SPRD        PAmtIn
 
     C                   ENDIF
 
      ** Format the Rate/Spread, using 7 decimal places
 
     C                   Z-ADD     7             PNoOfDecPl
     C                   EXSR      SRFmtAmt
     C                   MOVE      PAmtOutS      DDRTSP
 
      ** Interest Calculation Method
 
     C                   EVAL      DDICBS = D1ICMT
 
      ** Interest Payment Frequency
 
     C                   EVAL      DDIPFR = D1IPFQ
 
      ** Format the Next Interest Date
 
     C                   Z-ADD     D1NIYY        @YEAR
     C                   Z-ADD     D1NIMM        @MNTH
     C                   Z-ADD     D1NIDD        @DAY
 
     C                   IF        @DATE <> 0 AND DDIPFR <> 'N'
     C                   EXSR      SRCvtDat
     C                   MOVE      PDateOut      DDNIDT
     C                   ENDIF
 
      ** Total interest amount
 
     C     D1MTTI        IFLT      0
     C                   Z-SUB     D1MTTI        PAmtIn
     C                   ELSE
     C                   Z-ADD     D1MTTI        PAmtIn
     C                   ENDIF
 
     C                   Z-ADD     D1CYDP        PNoOfDecPl
     C                   EXSR      SRFmtAmt
     C                   MOVE      PAmtOutS      DDTOTI
 
      ** Interest Frequency Day in Month .
 
     C                   IF        D1IPDM <> 0 AND D1IPFQ <> *BLANK AND
     C                             D1IPFQ <> 'N'
     C                   MOVE      D1IPDM        DDINTF
     C                   ENDIF
 
      ** Capitalise Interest Indicator
 
     C                   EVAL      DDCPTI = D1CPTI
 
      ** Linked Deal Number
 
     C                   IF        D1LNKN = *ZERO
     C                   EVAL      DDLNKR = *BLANK
     C                   ELSE
     C                   MOVE      D1LNKN        DDLNKR
     C                   ENDIF
 
      ** Originating Branch Code
 
     C                   EVAL      DDORBR = D1ORBR
 
      ** Set up text for deal status
 
     C                   CLEAR                   PStatus
 
     C                   IF        D1DDLT = 'D'
     C                   EVAL      PStatus = WStatArr(2)
 
     C                   ELSE
 
     C                   IF        D1DSTS <> 'A' AND D1DN38 <> *ZERO
     C                   EVAL      PStatus = WStatArr(1)
     C                   ENDIF
 
     C                   ENDIF
 
      ** Yield curve                                                                          CAS004
                                                                                              CAS004
     C                   IF        CAS004 = 'Y'                                               CAS004
     C                   EVAL      DDOYC1 = D1OYLC                                            CAS004
     C                   EVAL      DDOYC2 = D2OYLC                                            CAS004
     C                   ENDIF                                                                CAS004
 
      ** Fix Base Rate                                                                        CDL019
                                                                                              CDL019
     C                   IF        CDL019 = 'Y'                                               CDL019
     C                   EVAL      DDFBRT = D1FBRT                                            CDL019
     C                   ENDIF                                                                CDL019
                                                                                              CDL020
      ** Format Actual Interest Rate, using 7 decimal places                                  CDL020
                                                                                              CDL020
     C                   IF        CDL020 = 'Y'                                               CDL020
     C                   IF        D1BSRC  <> *BLANKS                                         CDL020
     C                   Z-ADD     0             PAmtIn                                       CDL020
     C                   MOVE      D1INTR        PAmtIn                                       CDL020
     C                   Z-ADD     7             PNoOfDecPl                                   CDL020
     C                   EXSR      SRFmtAmt                                                   CDL020
     C**********         MOVE      PAmtOutS      DDAIR                               CDL020 BUG11699
     C                   MOVE      PAmtOutU      DDAIR                                      BUG11699
     C                   ELSE                                                                 CDL020
     C                   MOVE      *BLANKS       DDAIR                                        CDL020
     C                   ENDIF                                                                CDL020
     C                   ENDIF                                                                CDL020
                                                                                              CDL020
                                                                                              CDL038
      ** Deal class 1                                                                         CDL038
                                                                                              CDL038
     C                   EVAL      DDCLS1 = D1CLAS                                            CDL038
                                                                                              CDL038
      ** Deal class 2                                                                         CDL038
                                                                                              CDL038
     C                   EVAL      DDCLS2 = D2CLAS                                            CDL038
                                                                                              CDL038
      ** Front Office Transaction ID                                                          261140
     C                   EVAL      FRNT = D1FRNT                                              261140
                                                                                              261140
      ** Associated Front Office Transaction ID                                               261140
     C                   EVAL      AFRT = D1AFRT                                              261140
                                                                                              261140
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRCvtDat - Convert date from YYYYMMDD to DDMMYY (or MMDDYY)  *
      *****************************************************************
     C     SRCvtDat      BEGSR
 
     C                   CALLB     'ZA0770'
     C                   PARM      *BLANK        ReturnCode
     C                   PARM                    @DATE
     C                   PARM                    PBJDFIN
     C                   PARM      *ZERO         PDateOut
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRFmtAmt - Format amount for display                         *
      *****************************************************************
     C     SRFmtAmt      BEGSR
 
     C                   CALLB     'ZA0921'
     C                   PARM      *BLANK        ReturnCode
     C                   PARM                    PAmtIn
     C                   PARM                    PNoOfDecPl
     C                   PARM                    PBNDCSP
     C                   PARM      *BLANK        PAmtOutS
     C                   PARM      *BLANK        PAmtOutU
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRSclRte - Scale rate                                        *
      *****************************************************************
     C     SRSclRte      BEGSR
 
     C                   CALLB     'ZA1150'
     C                   PARM                    PSxP1
     C                   PARM                    PSxP2
     C                   PARM                    PIntRt
     C                   PARM                    PMulDiv
     C                   PARM      *ZEROS        PScRte
     C                   PARM      *ZEROS        PISRt
     C                   PARM      *ZEROS        PErrCde
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZAlign - Validate numeric fields                           *
      *                                                               *
      *****************************************************************
 
     C     SRZAlign      BEGSR
 
     C                   CALLB     'ZALIGN'
     C                   PARM                    PZAlignOk
     C                   PARM                    PZField
     C                   PARM                    PZADEC
     C                   PARM                    PZADIG
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRINIT - Initialization                                      *
      *****************************************************************
     C     SRINIT        BEGSR
 
      ** Blank outputs (except for action code within deal format)
 
     C                   EVAL      WDDACTN = ActionCode
     C                   EVAL      DealScnFmt = *BLANK
     C                   EVAL      PStatus = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** *INZSR - Initial Processing                                  *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Program parameters
 
     C     *ENTRY        PLIST
 
      ** Input Parameters
      ** ================
      ** Return Code
      ** Action Code
 
     C                   PARM                    RetCodeIn
     C                   PARM                    ActionCode
 
      ** Deal in file format of deal
      ** Deal in file format of associated deal
 
     C                   PARM                    CrDlFilFmt1
     C                   PARM                    CrDlFilFmt2
 
      ** Standing Data
      ** =============
      ** SDBANKPD
      ** ========
 
     C                   PARM                    PBJDFIN
 
      ** SDDEALPD
      ** ========
 
     C                   PARM                    PBNDCSP
                                                                                              CAS004
     C                   PARM                    CAS004                                       CAS004
 
     C                   PARM                    CDL019                                       CDL019
                                                                                              CDL019
     C                   PARM                    CDL020                                       CDL020
                                                                                              CDL020
      ** Output parameters
      ** =================
      ** Deal in screen format
     C                   PARM                    DealScnFmt
 
      ** Deal Status
     C                   PARM                    PStatus
 
      ** Profit Centre Description 1
      ** Profit Centre Description 2
     C                   PARM                    PPCDesc1
     C                   PARM                    PPCDesc2
 
      ** Front Office Transaction ID                                                          261140
      ** Associated Front Office Transaction ID                                               261140
     C                   PARM                    FRNT                                         261140
     C                   PARM                    AFRT                                         261140
                                                                                              261140
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
 
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
 
     C/COPY ZACPYSRC,PSSR_ILE
 
      ********************************************************************
      /EJECT
      *****************************************************************
 
**  CPY@
(c) Finastra International Limited 2001
** TEXT FOR DEAL STATUS
MATURED
DELETED
