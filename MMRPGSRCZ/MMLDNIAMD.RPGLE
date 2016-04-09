     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Loans/deposits amend checking')               *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMLDNIAMD - Loans,Deposits & NAs Issued Amend Checking       *
      *                                                               *
      *  Function:  This module compares the fields of an             *
      *             amended deal against those currently on file.     *
      *             It checks whether all fields amended are          *
      *             amendable, and if not returns error messages to   *
      *             the calling process.                              *
      *             If can optionally reset fields wrongly amended.   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CGL165             Date 23Mar15               *
      *  Prev Amend No. AR814519           Date 10Mar15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 MD023353           Date 12Nov13               *
      *                 MD000091           Date 14May13               *
      *                 AR324867           Date 14Dec12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23519           Date 24Mar09               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 BUG5169            Date 03Oct06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 219642             Date 18Sep06               *
      *                 BUG8699            Date 21Jun06               *
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL039             Date 22Aug05               *
      *                 CDL038             Date 10May05               *
      *                 211926             Date 09Dec02               *
      *                 BUG4838            Date 27Oct04               *
      *                 CGL014             Date 20Oct03               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CAS005             Date 16Dec02               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 208051             Date 22Aug02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 03Apr00               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 178695             Date 28Jun00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP051             Date 09Nov99               *
      *                 CDL007             DATE 05Oct99               *
      *                 CPB001             Date 02Sep99               *
      *                 164565             Date 09Aug99               *
      *                 151977             Date 11Jun99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CDL006             Date 26Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 154477             Date 29Jan99               *
      *                 CAP004             Date 07Sep98               *
      *                 CAP003             Date 05May98               *
      *                 CAP002  *CREATE    Date 22Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  AR814519 - Allow negative base rate.                         *
      *           - Applied for MD033488                              *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  MD023353 - Reject amendment is not allowed for a deal where  *
      *             tax is amended.                                   *
      *  MD000091 - Event Codes Substitution                          *
      *  AR324867 - MM Deals status shows 'Requires reauthorization'  *
      *             but not listed in WIP.                            *
      *           - Applied for AR916240 (Child: AR916241)            *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23519 - Warning messages with the same text are displayed *
      *             at the same time                                  *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  BUG5169 - Actual Interest Rate may not be amended (CDL020).  *
      *  219642 - Allow maturity date equal to IACD/SLID              *
      *  BUG8699- Cannot amend auto rollover ind. from Y to N, system *
      *           displayed 'Taxable indicator may not be amended'    *
      *           MMM0493 although taxable field is blank.            *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL039 - Amendable Deal Sub Types & Classes                  *
      *  CDL038 - Extended Deal Sub Type                              *
      *  211926 - When checking whether the Funding Spread/Rate was   *
      *           changed on Amend, convert fields DDFSRP and @DDFSRP *
      *           to numeric first before comparing them.             *
      *  BUG4838- Allow amendment of mat date on deals awaiting auth. *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CDL020 - Apply Base Rate at Value Date                       *
      *           (Recompile)                                         *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposit       *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Autumatic Rollover of Fixed Term Loan/Deposit       *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in MMDEAMPP *
      *  208051 - Set the negative interest indicator according to    *
      *           the sign of the interest amount.                    *
      *  CAS001 - Net Present Value (NPV) Accounting (Recompile)      *
      *  CDE002 - Revenue Analysis                                    *
      *  178695 - Protect Amend of Portfolio Reference                *
      *  CAP051 - Automatic Authorisation (MM Part)                   *
      *           Recompiled due to changes in MMDELDPP               *
      *  CDL007 - Deposit Breakdown Penalty                           *
      *           Recompiled due to changes in MMDELDPP               *
      *  CPB001 - 'Private Banking' Module                            *
      *  154477 - Recompile for change to MMVLDNIPD.                  *
      *  164565 - Removed the coding that validates Total Interest    *
      *           field making it  amendable .  The inserted values   *
      *           will be checked/formated correctly  within          *
      *           ZAVTOTINT  routine .                                *
      *  151977 - Total Interest should be amendable only if deal     *
      *           status is 'COMPLETE'.                               *
      *  CDL006 - Dealing Fiduciary.                                  *
      *  154477 - Recompile for change to MMDELDPP.                   *
      *  CAP004 - API's Phase 3.                                      *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs. (RECOMPILED)                           *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FMMCDAFLL  IF   E             DISK    INFSR(*PSSR)
 
     FMMLVDMLL  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MMDEAMP0:MMLVDMP0)
 
     FDEALSC    IF   E           K DISK    INFSR(*PSSR)                                     AR324867
      ** LF of DEALSDC keyed by DLNO                                                        AR324867
      *                                                                                     AR324867
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
 
      ** Array to contain input rate                                                          211926
     D AlpRate         S              1    DIM(12)                                            211926
      ** Array to integer part of rate                                                        211926
     D IntRate         S              1    DIM(4)                                             211926
      ** Array to decimal part of rate                                                        211926
     D DecRate         S              1    DIM(7)                                             211926
                                                                                              211926
      * New Deal in Screen Format
     D NwDlScnFmt    E DS                  EXTNAME(MMLDNIPD)
 
      * (Current) Deal in Screen Format
     D DealScnFmt    E DS                  EXTNAME(MMLDNIPD)
     D                                     PREFIX(@)
 
      * (Current) Deal in File Format
     D DealFilFmt    E DS                  EXTNAME(MMDELDPP)
     D/COPY WNCPYSRC,MMLDNIAD01
 
     D RUNDAT          DS
     D  @MBIN                 13     13
 
     D                 DS
      **  Data structure for date in, to change format.
     D  DateIn                 1      8  0
     D  @@YY                   1      4  0
     D  @@MM                   5      6  0
     D  @@DD                   7      8  0
      **
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
 
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      **  Data structure for Portfolio Management ICD File
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
     D                 DS                                                                   AR324867
      ** Data structure for Notice Days to change type.                                     AR324867
     D  @NTCD                  1      3                                                     AR324867
     D  #NTCD                  1      3  0                                                  AR324867
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for AlpRate                                                                    211926
     D @AR             S              2  0                                                    211926
      ** Index for IntRate                                                                    211926
     D @IR             S              1  0                                                    211926
      ** Index for DecRate                                                                    211926
     D @DR             S              1  0                                                    211926
                                                                                              211926
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Flags to indicate whether transaction fields are valid
     D OKFlagsDS       DS
     D  DDActnOK                      1A
     D  DDDlnoOK                      1A
     D  DDTypeOK                      1A
     D  DDStypOK                      1A
     D  DDFedFOK                      1A
     D  DDDADNOK                      1A
     D  DDDlDtOK                      1A
     D  DDBrCAOK                      1A
     D  DDBokCOK                      1A
     D  DDLnkNOK                      1A
     D  DDBkCdOK                      1A
     D  DDBrkgOK                      1A
     D  DDRaCDOK                      1A
     D  DDCustOK                      1A
     D  DDVDatOK                      1A
     D  DDMDatOK                      1A
     D  DDNtceOK                      1A
     D  DDAcSqOK                      1A
     D  DDCcyOK                       1A
     D  DDAmnpOK                      1A
     D  DDBRatOK                      1A
     D  DDDRIDOK                      1A
     D  DDDDMROK                      1A
     D  DDBsRCOK                      1A
     D  DDSpRtOK                      1A
     D  DDICMtOK                      1A
     D**DDNgvIOK**********************1A                                                      CDL016
     D  DDROLIOK                      1A                                                      CDL016
     D  DDIPFqOK                      1A
     D  DDNDatOK                      1A
     D  DDTotIOK                      1A
     D  DDIPDMOK                      1A
     D  DDCptIOK                      1A
     D  DDMTaxOK                      1A
     D  DDFUIDOK                      1A
     D  DDFLIdOK                      1A
     D  DDRDFCOK                      1A
     D  DDCDRfOK                      1A
     D  DDCDCHOK                      1A
     D  DDPrfCOK                      1A
     D  DDOrBrOK                      1A
     D  DDPtfROK                      1A
     D  DDAuRoOK                      1A
     D  DDCnNaOK                      1A
     D  DDRoFqOK                      1A
     D  DDRlDNOK                      1A
     D  DDIPdSOK                      1A
     D  DDIMetOK                      1A
     D  DDIScyOK                      1A
     D  DDInSAOK                      1A
     D  DDINosOK                      1A
     D  DDIi72OK                      1A
     D  DDFsrpOK                      1A
     D  DDFsgnOK                      1A
     D  DDFprcOK                      1A
     D  DDPenaOK                      1A                                                      CAS005
     D  DDTrTpOK                      1A                                                      CAS005
     D  DDOylcOK                      1A                                                      CAS005
     D  DDLQPROK                      1A                                                      CAS005
     D  DDLQPSOK                      1A                                                      CAS005
     D  DDClasOK                      1A                                                      CDL038
      ** Flag(s) to indicate if combinations of transaction fields are valid
     D  DDDltStpOK                    1A
      ** Currencies for Payment Convention                                                    CDL096
     D  OKC1PC                        1A                                                      CDL096
     D  OKC2PC                        1A                                                      CDL096
     D  OKC3PC                        1A                                                      CDL096
     D  OKC4PC                        1A                                                      CDL096
     D  OKC5PC                        1A                                                      CDL096
     D  OKC6PC                        1A                                                      CDL096
     D  OKC7PC                        1A                                                      CDL096
     D  OKC8PC                        1A                                                      CDL096
     D  OKC9PC                        1A                                                      CDL096
     D  OKC0PC                        1A                                                      CDL096
                                                                                              CDL096
      ** Payment Date and Amount Convention                                                   CDL096
     D  OKPDC                         1A                                                      CDL096
     D  OKAMC                         1A                                                      CDL096
                                                                                              CDL096
 
      ** Flags to indicate whether transaction fields are valid                              BUG5169
     D OKFlagsDS2      DS                                                                    BUG5169
     D  DDSOFDOK                      1A                                                     BUG5169
     D  DDFBRTOK                      1A                                                     BUG5169
     D  DDAIROK                       1A                                                     BUG5169
                                                                                             BUG5169
      ** Define for compilation purpose                                                       CDL016
     D DDNgvIOK        S              1A                                                      CDL016
                                                                                              CDL016
      ** Date out
     D DateOut         S              6P 0
 
      ** Deal Amendment Value Date in Midas Dayno. format
     D DeamValDat      S              5P 0
 
      ** Deal Transaction Date in Midas Dayno. format
     D TransDate       S              5P 0
 
      ** Last Interest Date in Midas Dayno. format
     D LstIntDate      S              5P 0
 
      ** Interest Accrual Date in Midas Dayno. format
     D IntAccDate      S              5P 0
 
      ** New Maturity Date in Midas Dayno. format
     D NewMatDate      S              5P 0
 
      ** New Next Interest Date in Midas Dayno. format
     D NewNxInDte      S              5P 0
 
      ** Dealing fiduciary                                                      CDL006
     D CDL006          S              1A   IMPORT                               CDL006
                                                                                CDL006
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
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
      *
      **  Convert the dates on the current live deal
      **  from YYYYMMDD format to Midas day number format
      *
     C                   EXSR      CONVDATES
      *
      **  Compare fields with amended values.
      *
     C                   EXSR      COMPFLDS
      *
      *  If any errors were found:
      *    Set Amendments OK Indicator to 'N'
      *
     C     Idx           IFGT      0
     C                   EVAL      AmendOK = 'N'
     C                   ELSE
     C                   EVAL      AmendOK = 'Y'
     C                   ENDIF
      *
      *  If any errors were found:
      *  - and reset of fields in error required, do this
      *
     C     Idx           IFGT      0
     C     ResetErrs     ANDEQ     'Y'
     C                   EXSR      RESETFLDS
     C                   ENDIF
      *
      * Return
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * COMPFLDS  - Compare certain fields on the current deal        *
      *             with those amended.                               *
      *****************************************************************
     C     COMPFLDS      BEGSR
     C*
     C*-----------------------------------------*
     C* Deal Type                               *
     C*-----------------------------------------*
     C** This field is NOT AMENDABLE.
     C*
     C     DDTYPE        IFNE      @DDTYPE
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTYPE'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0398'
     C                   EVAL      ddTYPEok        = 'N'
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Deal SubType                            *
     C*-----------------------------------------*
     C** This field is amendable only if so defined on MMCDAFPP.
     C** and if CDL039 is ON                                                                  CDL039
     C*
     C     HKDSTS        IFNE      'C'
     C     DDSTYP        ANDNE     @DDSTYP
     C     CDL039        ANDEQ     'N'                                                        CDL039
     C     HKDSTS        OREQ      'C'
     C     DDSTYP        ANDNE     @DDSTYP
     C     HHDLSA        ANDEQ     'N'
     C     CDL039        ANDEQ     'N'                                                        CDL039
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSTYP'
     C     HKDSTS        IFEQ      'C'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0400'
     C                   ELSE
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0401'
     C                   END
     C                   EVAL      ddSTYPok        = 'N'
     C                   ENDIF
     C/COPY WNCPYSRC,MMLDNIAC01
     C*
     C*-----------------------------------------*
     C* Federal Funds Indicator                 *
     C*-----------------------------------------*
     C** This field may only be amended if deal NOT Authorised.
     C*
     C     HKDSTS        IFNE      'C'
     C     DDFEDF        ANDNE     @DDFEDF
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFEDF'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0396'
     C                   EVAL      ddFEDFok        = 'N'
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Deal Date                               *
     C*-----------------------------------------*
     C** This field may only be amended if deal NOT Authorised.
     C*
     C     DDDLDT        IFNE      @DDDLDT
     C     HKDSTS        ANDNE     'C'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDLDT'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0382'
     C                   EVAL      ddDLDTok        = 'N'
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Branch Code                             *
     C*-----------------------------------------*
     C** Booking branch code validation only when MULTI-BRANCHING
     C** indicator is on.
     C** This field is not amendable for R and A status deals,
     C** and is only amendable for status C if this is indicated on
     C** MMCDAFLL.
     C*
     C     @MBIN         IFEQ      'Y'
     C     DDBRCA        ANDNE     @DDBRCA
     C*
     C     HKDSTS        IFNE      'C'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBRCA'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0381'
     C                   EVAL      ddBRCAok        = 'N'
     C                   ELSE
     C     HHBRCA        IFEQ      'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBRCA'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0380'
     C                   EVAL      ddBRCAok        = 'N'
     C                   ENDIF
     C                   ENDIF
     C*
     C                   ENDIF
     C*                                                                         CAP004
     C*-----------------------------------------*                               CAP004
     C* Book Code                               *                               CAP004
     C*-----------------------------------------*                               CAP004
     C** This field may only be amended if deal NOT Authorised.                 CAP004
     C*                                                                         CAP004
     C     DDBOKC        IFNE      @DDBOKC                                      CAP004
     C     HKDSTS        ANDNE     'C'                                          CAP004
     C                   ADD       1             Idx                            CAP004
     C                   EVAL      FldNameArr(Idx) = 'DDBOKC'                   CAP004
     C                   EVAL      MsgIDArr(Idx)   = 'MMM2570'                  CAP004
     C                   EVAL      ddBOKCok        = 'N'                        CAP004
     C                   ENDIF                                                  CAP004
                                                                                CDL006
      **-----------------------*                                                CDL006
      ** Deal Linked Reference *                                                CDL006
      **-----------------------*                                                CDL006
      ** This field is not amendable for fiduciary takings                      CDL006
                                                                                CDL006
     C     CDL006        IFEQ      'Y'                                          CDL006
     C     DDTYPE        ANDEQ     'FT'                                         CDL006
     C     CDL006        OREQ      'Y'                                          CDL006
     C     DDTYPE        ANDEQ     'DT'                                         CDL006
     C     CDL006        OREQ      'Y'                                          CDL006
     C     DDTYPE        ANDEQ     'LT'                                         CDL006
                                                                                CDL006
     C     DDLNKN        IFNE      @DDLNKN                                      CDL006
     C                   ADD       1             Idx                            CDL006
     C                   EVAL      FldNameArr(Idx) = 'DDLNKN'                   CDL006
     C                   EVAL      MsgIDArr(Idx)   = 'MMM9001'                  CDL006
     C                   EVAL      ddLNKNok        = 'N'                        CDL006
     C                   ENDIF                                                  CDL006
                                                                                CDL006
     C                   ENDIF                                                  CDL006
     C*
     C*-----------------------------------------*
     C* Broker Code                             *
     C*-----------------------------------------*
     C**  This field is not amendable for R and A status deals,
     C**  and is only amendable for status C if this is indicated on
     C**  MMCDAFLL.
     C*
     C     DDBKCD        IFNE      @DDBKCD
     C*
     C     HKDSTS        IFNE      'C'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBKCD'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0391'
     C                   EVAL      ddBKCDok        = 'N'
     C                   ELSE
     C     HHBKRA        IFEQ      'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBKCD'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0390'
     C                   EVAL      ddBKCDok        = 'N'
     C                   ENDIF
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Brokerage                               *
     C*-----------------------------------------*
     C**  This field is not amendable for R and A status deals,
     C**  and is only amendable for status C if this is indicated on
     C**  MMCDAFLL.
     C*
     C     DDBRKG        IFNE      @DDBRKG
     C*
     C     HKDSTS        IFNE      'C'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBRKG'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0395'
     C                   EVAL      ddBRKGok        = 'N'
     C                   ELSE
     C     HHBKGA        IFEQ      'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBRKG'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0394'
     C                   EVAL      ddBRKGok        = 'N'
     C                   ENDIF
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Customer                                *
     C*-----------------------------------------*
     C**  This field is not amendable for R and A status deals,
     C**  and is only amendable for status C if this is indicated on
     C**  MMCDAFLL.
     C*
     C     DDCUST        IFNE      @DDCUST
     C*
     C     HKDSTS        IFNE      'C'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCUST'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0385'
     C                   EVAL      ddCUSTok        = 'N'
     C                   ELSE
     C     HHCNMA        IFEQ      'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCUST'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0384'
     C                   EVAL      ddCUSTok        = 'N'
     C                   ENDIF
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Value Date                              *
     C*-----------------------------------------*
     C** This field is NOT AMENDABLE.
     C*
     C     DDVDAT        IFNE      @DDVDAT
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDVDAT'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0386'
     C                   EVAL      ddVDATok        = 'N'
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Maturity Date                           *
     C*-----------------------------------------*
     C**  If the maturity date has changed
     C**  the deal transaction date can't be today
     C*
     C     DDMDAT        IFNE      @DDMDAT
     C     BJRDNB        ANDEQ     TransDate
     C/COPY WNCPYSRC,MMLDNIAC04
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMDAT'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0583'
     C                   EVAL      ddMDATok        = 'N'
     C/COPY WNCPYSRC,MMLDNIAC05
     C                   ELSE
      *
      ** Else Maturity date cannot be changed if deal has been rolled
      ** over
     C     HKROBY        IFNE      *BLANKS
     C     HKRBSI        ANDEQ     'O'
     C     DDMDAT        ANDNE     @DDMDAT
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMDAT'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0585'
     C**********         EVAL      MsgDtaArr(Idx)  = HKROBY                                 MD000091
     C                   EVAL      BLen = %Len(%Trim(HKROBY))                               MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(HKROBY)                   MD000091
     C                   EVAL      ddMDATok        = 'N'
     C                   ELSE
      *
      ** Else Maturity date cannot be changed if deal is a front up
      ** interest deal
     C     HKFUID        IFEQ      'Y'
     C     DDMDAT        ANDNE     @DDMDAT
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMDAT'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0612'
     C                   EVAL      ddMDATok        = 'N'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C*
     C** This field may only be amended if deal is authorised.
     C*
     C     DDMDAT        IFNE      @DDMDAT
     C     HKDSTS        ANDNE     'A'
     C     HKDSTS        ANDNE     'R'                                                       BUG4838
     C     ddMDATok      ANDNE     'N'                                                      BUG23519
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMDAT'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0388'
     C                   EVAL      ddMDATok        = 'N'
     C                   ENDIF
 
     C** If the deal type is CD,CL or DL, the maturity date on file is
     C** present, and no date has been entered, this is an error.
 
     C     DDTYPE        IFEQ      'CD'
     C     DDTYPE        OREQ      'CL'
     C     DDTYPE        OREQ      'DL'
 
     C     HKMDMM        IFNE      *ZEROS
     C     DDMDAT        ANDEQ     *BLANK
      *                                                                                     AR324867
      ** Check Maturity Date in DEALSDC.                                                    AR324867
      *                                                                                     AR324867
     C     HKDSTS        IFEQ      'R'                                                      AR324867
     C     HKDN38        CHAIN     DEALSC                             61                    AR324867
      *                                                                                     AR324867
      ** If no valid record found then it is a data base  error.                            AR324867
      *                                                                                     AR324867
     C     *IN61         IFEQ      '1'                                                      AR324867
     C                   MOVEL     HKDN38        DBKEY                                      AR324867
     C                   MOVEL     'DEALSDC'     DBFILE                                     AR324867
     C                   MOVE      '905'         DBASE                                      AR324867
     C                   EXSR      *PSSR                                                    AR324867
     C                   ENDIF                                                              AR324867
     C                   MOVE      DDNTCE        @NTCD                                      AR324867
     C                   ENDIF                                                              AR324867
      *                                                                                     AR324867
     C     HKDSTS        IFEQ      'R'                                                      AR324867
     C     MDAT          ANDEQ     *ZEROS                                                   AR324867
     C     #NTCD         ANDEQ     NOTD                                                     AR324867
     C     HKCNTI        ANDEQ     'N'                                                      AR324867
     C     HKDSTS        OREQ      'R'                                                      AR324867
     C     MDAT          ANDEQ     *ZEROS                                                   AR324867
     C     DDNTCE        ANDEQ     '  0'                                                    AR324867
     C     NOTD          ANDEQ     0                                                        AR324867
     C     HKCNTI        ANDEQ     'C'                                                      AR324867
     C                   ELSE                                                               AR324867
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMDAT'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0126'
     C                   EVAL      ddMDATok        = 'N'
     C                   ENDIF                                                              AR324867
      *                                                                                     AR324867
     C                   END
     C                   END
 
      ** Same maturity date validation but for fiduciary deals.                 CDL006
                                                                                CDL006
     C     DDTYPE        IFEQ      'DT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     DDTYPE        OREQ      'LT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     DDTYPE        OREQ      'DP'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     DDTYPE        OREQ      'LP'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     HKMDMM        IFNE      *ZEROS                                       CDL006
     C     DDMDAT        ANDEQ     *BLANK                                       CDL006
     C                   ADD       1             Idx                            CDL006
     C                   EVAL      FldNameArr(Idx) = 'DDMDAT'                   CDL006
     C                   EVAL      MsgIDArr(Idx)   = 'MMM9002'                  CDL006
     C                   EVAL      ddMDATok        = 'N'                        CDL006
     C                   ENDIF                                                  CDL006
     C                   ENDIF                                                  CDL006
                                                                                CDL006
     C     DDMDAT        IFNE      *BLANKS
      **  If a new maturity date has been entered
 
     C**  The new maturity date must be after the (existing)
     C**  last interest date and the interest accrual control date
     C**  (subject to the Japanese Sub Module being installed)
 
     C     DDIPFQ        IFNE      'N'
 
     C*****NewMatDate    IFLE      IntAccDate                                                 219642
     C     NewMatDate    IFLT      IntAccDate                                                 219642
     C     S01391        ANDNE     'Y'
     C*****NewMatDate    ORLE      IntAccDate                                                 219642
     C     NewMatDate    ORLT      IntAccDate                                                 219642
     C     DDTYPE        ANDNE     'IP'
     C     DDTYPE        ANDNE     'IT'
     C     CDL006        ANDEQ     'N'                                          CDL006
     C*****NewMatDate    ORLE      IntAccDate                                          CDL006 219642
     C     NewMatDate    ORLT      IntAccDate                                                 219642
     C     DDTYPE        ANDNE     'IP'                                         CDL006
     C     DDTYPE        ANDNE     'IT'                                         CDL006
     C     DDTYPE        ANDNE     'FL'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     NewMatDate    ORLT      IntAccDate
 
     C*****NewMatDate    ORLE      LstIntDate                                                 219642
     C     NewMatDate    ORLT      LstIntDate                                                 219642
     C     S01391        ANDNE     'Y'
     C*****NewMatDate    ORLE      LstIntDate                                                 219642
     C     NewMatDate    ORLT      LstIntDate                                                 219642
     C     DDTYPE        ANDNE     'IP'
     C     DDTYPE        ANDNE     'IT'
     C     CDL006        ANDEQ     'N'                                          CDL006
     C*****NewMatDate    ORLE      LstIntDate                                          CDL006 219642
     C     NewMatDate    ORLT      LstIntDate                                                 219642
     C     DDTYPE        ANDNE     'IP'                                         CDL006
     C     DDTYPE        ANDNE     'IT'                                         CDL006
     C     DDTYPE        ANDNE     'FL'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     NewMatDate    ORLT      LstIntDate
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMDAT'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0133'
     C                   EVAL      ddMDATok        = 'N'
     C                   END
     C                   END
 
     C**  Access the deal amendments file for the last amendment
     C**  to the deal being processed.
 
     C                   Z-ADD     0             DeamValDat
 
     C**  Set value for key of file to be greater than value required.
     C                   MOVE      HKDN38        @DEAMN
     C                   MOVE      '9999'        @VDYY
     C                   MOVE      '99'          @VDMM
     C                   MOVE      '99'          @VDDD
     C                   MOVE      '999'         @DEAMS
     C     @DEAMK        SETGT     MMLVDMLL
 
     C**  Read the previous record on file.  (Should be the latest deal
     C**  amendment.)
     C                   READP     MMLVDMLL                               65
 
     C**  If a record is found with the correct deal number, convert
     C**  its value date to a MIDAS day no.
     C     *IN65         IFEQ      '0'
     C     HNDA38        ANDEQ     HKDN38
     C                   Z-ADD     HNVDYY        @YEAR
     C                   Z-ADD     HNVDMM        @MNTH
     C                   Z-ADD     HNVDDD        @DAY
 
     C     @DATE         IFEQ      0
     C                   Z-ADD     0             DeamValDat
     C                   ELSE
 
     C                   Z-ADD     @DATE         DateIn
     C                   CALLB     'ZA0770'
     C                   PARM                    RetCodeOut
     C                   PARM                    DateIn
     C                   PARM                    BJDFIN
     C                   PARM                    DateOut
     C                   MOVE      DateOut       @DAT              6 0
 
     C                   CALLB     'ZA0270'
     C                   PARM                    @DAT
     C                   PARM                    BJDFIN
     C                   PARM                    @RTCDE            1
     C                   PARM                    DeamValDat
     C                   END
     C                   END
 
     C**  If the new maturity date is not later than the value date,
     C**  it is an error.
     C     NewMatDate    IFLE      DeamValDat
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMDAT'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0136'
     C                   EVAL      ddMDATok        = 'N'
     C                   END
 
     C                   ENDIF
     C/COPY WNCPYSRC,MMLDNIAC06
 
     C*-----------------------------------------*
     C* Notice Days                             *
     C*-----------------------------------------*
     C** This field is NOT AMENDABLE.
     C*
     C     DDNTCE        IFNE      @DDNTCE
      *                                                                                     AR324867
      ** Check Notice Days in DEALSDC.                                                      AR324867
      *                                                                                     AR324867
     C     HKDSTS        IFEQ      'R'                                                      AR324867
     C     HKDN38        CHAIN     DEALSC                             62                    AR324867
      *                                                                                     AR324867
      ** If no valid record found then it is a data base  error.                            AR324867
      *                                                                                     AR324867
     C     *IN62         IFEQ      '1'                                                      AR324867
     C                   MOVEL     HKDN38        DBKEY                                      AR324867
     C                   MOVEL     'DEALSDC'     DBFILE                                     AR324867
     C                   MOVE      '906'         DBASE                                      AR324867
     C                   EXSR      *PSSR                                                    AR324867
     C                   ENDIF                                                              AR324867
     C                   MOVE      DDNTCE        @NTCD                                      AR324867
     C                   ENDIF                                                              AR324867
      *                                                                                     AR324867
     C     HKDSTS        IFEQ      'R'                                                      AR324867
     C     #NTCD         ANDEQ     NOTD                                                     AR324867
     C                   ELSE                                                               AR324867
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNTCE'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0388'
     C                   EVAL      ddNTCEok        = 'N'
     C                   ENDIF                                                              AR324867
      *                                                                                     AR324867
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Portfolio Reference                     *
     C*-----------------------------------------*
     C** This field may not be amended if original entry date of deal
     C** is less than the run date
     C*
     C     BGPFMG        IFEQ      'Y'
     C     DDPTFR        ANDNE     @DDPTFR
     C     BGN4ST        OREQ      'Y'                                          CPB001
     C     DDPTFR        ANDNE     @DDPTFR                                      CPB001
      *
     C**** TransDate     IFLT      BJRDNB                                       178695
     C     HKDSTS        IFNE      'C'                                          178695
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPTFR'
     C                   EVAL      MsgIDArr(Idx)   = 'PMM0005'
     C                   EVAL      ddPTFRok        = 'N'
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Account Sequence Number                 *
     C*-----------------------------------------*
     C** This field may only be amended if deal NOT Authorised.
     C*
     C     DDACSQ        IFNE      @DDACSQ
     C     HKDSTS        ANDNE     'C'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDACSQ'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0490'
     C                   EVAL      ddACSQok        = 'N'
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Currency                                *
     C*-----------------------------------------*
     C** This field is NOT AMENDABLE.
     C*
     C     DDCCY         IFNE      @DDCCY
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCCY '
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0370'
     C                   EVAL      ddCCYok         = 'N'
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Deal Amount                             *
     C*-----------------------------------------*
     C** This field is NOT AMENDABLE.
     C*
     C     DDAMNP        IFNE      @DDAMNP
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDAMNP'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0372'
     C                   EVAL      ddAMNPok        = 'N'
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Base Rate Code                          *
     C*-----------------------------------------*
     C** This field is NOT AMENDABLE.
     C*
     C     DDBSRC        IFNE      @DDBSRC
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBSRC'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0376'
     C                   EVAL      ddBSRCok        = 'N'
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Interest Rate/Spread                    *
     C*-----------------------------------------*
     C** This field is NOT AMENDABLE.
     C*
     C                   MOVE      DDSPRT        WRATE            12                          211926
     C                   EXSR      ConvRate                                                   211926
     C                   MOVE      CRATE         WSPRT1           11 7                        211926
     C                   MOVE      @DDSPRT       WRATE                                        211926
     C                   EXSR      ConvRate                                                   211926
     C                   MOVE      CRATE         WSPRT2           11 7                        211926
     C*****DDSPRT        IFNE      @DDSPRT                                                    211926
     C     WSPRT1        IFNE      WSPRT2                                                     211926
     C     DDSPRT        IFNE      @DDSPRT
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSPRT'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0374'
     C                   EVAL      ddSPRTok        = 'N'
     C                   ENDIF
     C                   ENDIF                                                                211926
     C*
     C*-----------------------------------------*                                            BUG5169
     C* Actual Interest Rate                    *                                            BUG5169
     C*-----------------------------------------*                                            BUG5169
     C** This field is NOT AMENDABLE.                                                        BUG5169
     C*                                                                                      BUG5169
     C     DDAIR         IFNE      @DDAIR                                                    BUG5169
     C     CDL020        ANDEQ     'Y'                                                       BUG5169
     C                   ADD       1             Idx                                         BUG5169
     C                   EVAL      FldNameArr(Idx) = 'DDAIR'                                 BUG5169
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0379'                               BUG5169
     C                   EVAL      ddAIRok         = 'N'                                     BUG5169
     C                   ENDIF                                                               BUG5169
     C*-----------------------------------------*
     C* Interest Calculation Method             *
     C*-----------------------------------------*
     C**  This field is not amendable for R and A status deals,
     C**  and is only amendable for status C if this is indicated on
     C**  MMCDAFLL.
     C*
     C     DDICMT        IFNE      @DDICMT
     C*
     C     HKDSTS        IFNE      'C'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDICMT'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0485'
     C                   EVAL      ddICMTok        = 'N'
     C                   ELSE
     C     HHINTA        IFEQ      'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDICMT'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0484'
     C                   EVAL      ddICMTok        = 'N'
     C                   ENDIF
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Negative Interest Indicator             *
     C*-----------------------------------------*
     C** This field is NOT AMENDABLE.
     C** Set field according to sign of total interest.                         208051
     C*
     C*****DDNGVI        IFNE      @DDNGVI                                      208051
     C**********         ADD       1             Idx                            208051
     C**********         EVAL      FldNameArr(Idx) = 'DDNGVI'                   208051
     C**********         EVAL      MsgIDArr(Idx)   = 'MMM0491'                  208051
     C**********         EVAL      ddNGVIok        = 'N'                        208051
     C**********         ENDIF                                                  208051
     C*****'-'**         SCAN      DDTOTI        PT                2 0               208051 AR814519
     C*****PT***         IFNE      0                                                 208051 AR814519
     C**********         MOVE      'Y'           DDNGVI                              208051 AR814519
     C**********         ELSE                                                        208051 AR814519
     C**********         MOVE      ' '           DDNGVI                              208051 AR814519
     C**********         ENDIF                                                       208051 AR814519
     C*
     C*-----------------------------------------*
     C* Interest Payment Frequency              *
     C*-----------------------------------------*
     C**  This field is not amendable for R and A status deals,
     C**  and is only amendable for status C if this is indicated on
     C**  MMCDAFLL.
     C*
     C     HKDSTS        IFNE      'C'
     C     DDIPFQ        ANDNE     @DDIPFQ
     C     HHINTA        ANDEQ     'N'
     C     DDTYPE        IFNE      'CD'
     C     DDTYPE        ANDNE     'CL'
     C     DDTYPE        ANDNE     'DL'
     C     CDL006        ANDEQ     'N'                                          CDL006
     C     DDTYPE        ORNE      'CD'                                         CDL006
     C     DDTYPE        ANDNE     'CL'                                         CDL006
     C     DDTYPE        ANDNE     'DL'                                         CDL006
     C     DDTYPE        ANDNE     'DT'                                         CDL006
     C     DDTYPE        ANDNE     'LT'                                         CDL006
     C     DDTYPE        ANDNE     'DP'                                         CDL006
     C     DDTYPE        ANDNE     'LP'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDIPFQ'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0482'
     C                   EVAL      ddIPFQok        = 'N'
     C                   END
     C*
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Next Interest Date                      *
     C*-----------------------------------------*
     C**  This field may only be amended if:
     C**  (a) The deal status is complete and the field is defined as
     C**      amendable on the MMCDAFLL file.
     C**  (b) The deal status is authorised or requiring re-authorisation,
     C**      and the rundate is after the deal input date and the
     C**      NEXT INTEREST DATE is not 0.
     C*
     C     DDNDAT        IFNE      @DDNDAT
     C*
     C     HKDSTS        IFEQ      'C'
     C     HHINTA        ANDNE     'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNDAT'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0480'
     C                   EVAL      ddNDATok        = 'N'
     C                   END
     C*
     C     HKDSTS        IFEQ      'A'
     C     HKNIMM        ANDNE     0
     C     BJRDNB        ANDEQ     TransDate
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNDAT'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0481'
     C                   EVAL      ddNDATok        = 'N'
     C                   END
     C*
     C**  If the next int payment date is now defined
     C*
     C     NewNxInDte    IFNE      *ZEROS
     C*
     C**  The next interest date must be after
     C**  the last interest date and the interest accrual control date.
     C*
     C     NewNxInDte    IFLE      LstIntDate
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNDAT'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0442'
     C                   EVAL      ddNDATok        = 'N'
     C                   END
 
     C     NewNxInDte    IFLE      IntAccDate
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNDAT'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0443'
     C                   EVAL      ddNDATok        = 'N'
     C                   END
     C*
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Total Interest Amount                   *
     C*-----------------------------------------*
     C***This*field*is*NOT*AMENDABLE.                                    151977164565
     C***This*field*is**AMENDABLE,*only*for*deal*status*'C'.***          151977164565
     C*****DDTOTI        IFNE      @DDTOTI
     C*****HKDSTS        ANDNE     'C'                                        151977
     C*****              ADD       1             Idx                          164565
     C*****              EVAL      FldNameArr(Idx) = 'DDTOTI'                 164565
     C*****              EVAL      MsgIDArr(Idx)   = 'MMM0492'                164565
     C*****              EVAL      ddTOTIok        = 'N'                      164565
     C*****              ENDIF                                                164565
     C*
     C*-----------------------------------------*
     C* Interest Frequency day in Month         *
     C*-----------------------------------------*
     C**  This field is only amendable if the deal is
     C**  complete, and the field is designated as amendable on the
     C**  file MMCDAFLL.
     C*
     C     HKDSTS        IFNE      'C'
     C     DDIPDM        ANDNE     @DDIPDM
     C     HHINTA        ANDEQ     'N'
     C     DDTYPE        IFNE      'CD'
     C     DDTYPE        ANDNE     'CL'
     C     DDTYPE        ANDNE     'DL'
     C     CDL006        ANDEQ     'N'                                          CDL006
     C     DDTYPE        ORNE      'CD'                                         CDL006
     C     DDTYPE        ANDNE     'CL'                                         CDL006
     C     DDTYPE        ANDNE     'DL'                                         CDL006
     C     DDTYPE        ANDNE     'DT'                                         CDL006
     C     DDTYPE        ANDNE     'LT'                                         CDL006
     C     DDTYPE        ANDNE     'DP'                                         CDL006
     C     DDTYPE        ANDNE     'LP'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDIPDM'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0486'
     C                   EVAL      ddIPDMok        = 'N'
     C                   END
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Taxable Indicator                       *
     C*-----------------------------------------*
     C** This field is fully amendable if BRT SAR is installed,
     C** otherwise it is only amendable if the deal is NOT authorised.
     C*
     C     S01383        IFNE      'Y'
     C/COPY WNCPYSRC,MMLDNIAC03
                                                                                CDL006
     ** Allow amend of Tax indicator up to maturity for fiduciary               CDL006
     ** takings                                                                 CDL006
     C     CDL006        IFEQ      'N'                                          CDL006
     C     CDL006        OREQ      'Y'                                          CDL006
     C     DDTYPE        ANDNE     'FT'                                         CDL006
     C     DDTYPE        ANDNE     'DT'                                         CDL006
     C     DDTYPE        ANDNE     'LT'                                         CDL006
     C*
     C     DDMTAX        IFNE      @DDMTAX
     C     HKDSTS        ANDNE     'C'
     C     HKDSTS        ANDNE     'A'                                                       BUG8699
     C     HKDSTS        ANDNE     'R'                                                      MD023353
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMTAX'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0493'
     C                   EVAL      ddMTAXok        = 'N'
     C                   ENDIF
                                                                                CDL006
     C                   ENDIF                                                  CDL006
     C*
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Interest Capitalisation Indicator       *
     C*-----------------------------------------*
     C**  This field is not amendable for R and A status deals,
     C**  and is only amendable for status C if this is indicated on
     C**  MMCDAFLL.
     C*
     C     DDCPTI        IFNE      @DDCPTI
     C*
     C     HKDSTS        IFNE      'C'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCPTI'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0489'
     C                   EVAL      ddCPTIok        = 'N'
     C                   ELSE
     C     HHINTA        IFEQ      'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCPTI'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0488'
     C                   EVAL      ddCPTIok        = 'N'
     C                   ENDIF
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Front Up Interest Indicator             *
     C*-----------------------------------------*
     C** This field may only be amended if deal NOT Authorised.
     C*
     C     DDFUID        IFNE      @DDFUID
     C     HKDSTS        ANDNE     'C'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFUID'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0601'
     C                   EVAL      ddFUIDok        = 'N'
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* First & Last Day Interest Indicator     *
     C*-----------------------------------------*
     C** This field may only be amended if deal NOT Authorised.
     C*
     C     DDFLID        IFNE      @DDFLID
     C     HKDSTS        ANDNE     'C'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFLID'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0605'
     C                   EVAL      ddFLIDok        = 'N'
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Round Down Interest Indicator           *
     C*-----------------------------------------*
     C** This field is NOT AMENDABLE.
     C*
     C     DDRDFC        IFNE      @DDRDFC
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRDFC'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0609'
     C                   EVAL      ddRDFCok        = 'N'
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Rollover Deal Number                    *
     C*-----------------------------------------*
     C** This field is NOT AMENDABLE.
     C*
     C     DDDADN        IFNE      @DDDADN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDADN'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0402'
     C                   EVAL      ddDADNok        = 'N'
     C                   ENDIF
     C*
     C**  If the following fields have changed, it is an error;
     C**  Deal type, customer, currency, branch code
     C*
     C     DDDADN        IFNE      *BLANKS
     C     DDDADN        ANDNE     *ZEROS
     C     @DDTYPE       IFNE      DDTYPE
     C     @DDCUST       ORNE      DDCUST
     C     @DDCCY        ORNE      DDCCY
     C     @DDBRCA       ORNE      DDBRCA
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDADN'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0186'
     C                   EVAL      ddDADNok        = 'N'
     C                   END
     C                   END
     C*
     C*-----------------------------------------*
     C* Profit Centre                           *
     C*-----------------------------------------*
     C** Only validate this field if Profit Centre ICD flag on.
     C*
     C     BKPRCU        IFEQ      'Y'
     C*
     C** This field is not amendable unless 'Profit Centre Amendable'
     C** ICD flag is on.
     C*
     C     DDPRFC        IFNE      @DDPRFC
     C     BKPRCA        ANDNE     'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPRFC'
     C                   EVAL      MsgIDArr(Idx)   = 'FXM4002'
     C                   EVAL      ddPRFCok        = 'N'
     C                   ENDIF
     C*
     C                   ENDIF
      *                                                                                       CDL016
      *-----------------------------------------*                                             CDL016
      * Rollover Indicator                      *                                             CDL016
      *-----------------------------------------*                                             CDL016
      *                                                                                       CDL016
      ** Only validate if CDL016 switched on                                                  CDL016
      *                                                                                       CDL016
     C     CDL016        IFEQ      'Y'                                                        CDL016
      *                                                                                       CDL016
      ** Field may not be amended if not a Fixed Deposit Deal.                                CDL016
      *                                                                                       CDL016
     C     DDROLI        IFNE      @DDROLI                                                    CDL016
      *                                                                                       CDL016
     C     DDTYPE        IFNE      'IP'                                                       CDL016
     C     DDTYPE        ANDNE     'IT'                                                       CDL016
     C     DDTYPE        ANDNE     'TD'                                                       CDL016
     C     DDTYPE        ANDNE     'TI'                                                       CDL016
     C                   ADD       1             Idx                                          CDL016
     C                   EVAL      FldNameArr(Idx) = 'DDROLI'                                 CDL016
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0329'                                CDL016
     C                   EVAL      ddROLIok        = 'N'                                      CDL016
     C                   ELSE                                                                 CDL016
      *                                                                                       CDL016
      ** Field may not be amended once deal has been rolled over.                             CDL016
     C     HKROBY        IFNE      *BLANKS                                                    CDL016
     C                   ADD       1             Idx                                          CDL016
     C                   EVAL      FldNameArr(Idx) = 'DDROLI'                                 CDL016
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0343'                                CDL016
     C                   EVAL      ddROLIok        = 'N'                                      CDL016
     C                   ENDIF                                                                CDL016
     C                   ENDIF                                                                CDL016
      *                                                                                       CDL016
     C                   ENDIF                                                                CDL016
     C                   ENDIF                                                                CDL016
     C*
     C*-----------------------------------------*
     C* Automatic Rollover Indicator            *
     C*-----------------------------------------*
     C*
     C** Only validate if Enhanced Rollovers processing switched on
     C*
     C     S01434        IFEQ      'Y'
     C*
     C** Field may not be amended once deal has been rolled over.
     C*
     C     DDAURO        IFNE      @DDAURO
     C     HKROBY        ANDNE     *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDAURO'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0654'
     C                   EVAL      ddAUROok        = 'N'
     C                   ENDIF
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Funding Spread/Rate, Sign, Profit Centre*
     C*-----------------------------------------*
     C*
     C** Only validate if Profit Centre Accounting is installed
      ** or Revenue Analysis is switched on                                     CDE002
     C*
     C     BGN0ST        IFEQ      'Y'
     C     CDE002        OREQ      'Y'                                          CDE002
     C*
     C** These fields may only be amended if deal NOT Authorised.
     C*
     C                   MOVE      DDFSRP        WRATE            12                          211926
     C                   EXSR      ConvRate                                                   211926
     C                   MOVE      CRATE         WFSRP1           11 7                        211926
     C                   MOVE      @DDFSRP       WRATE                                        211926
     C                   EXSR      ConvRate                                                   211926
     C                   MOVE      CRATE         WFSRP2           11 7                        211926
     C*****DDFSRP        IFNE      @DDFSRP                                                    211926
     C     WFSRP1        IFNE      WFSRP2                                                     211926
     C     HKDSTS        ANDNE     'C'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFSRP'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0422'
     C                   EVAL      ddFSRPok        = 'N'
     C                   ENDIF
     C*
     C     DDFSGN        IFNE      @DDFSGN
     C     HKDSTS        ANDNE     'C'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFSGN'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0423'
     C                   EVAL      ddFSGNok        = 'N'
     C                   ENDIF
     C*
     C     DDFPRC        IFNE      @DDFPRC
     C     HKDSTS        ANDNE     'C'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFPRC'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0424'
     C                   EVAL      ddFPRCok        = 'N'
     C                   ENDIF
     C*
     C                   ENDIF
 
     C*-----------------------------------------*                                             CDL038
     C* Class                                   *                                             CDL038
     C*-----------------------------------------*                                             CDL038
     C** This field is amendable only if the deal is complete                                 CDL038
     C** and if CDL039 is ON                                                                  CDL039
     C*                                                                                       CDL038
     C     HKDSTS        IFNE      'C'                                                        CDL038
     C     DDCLAS        ANDNE     @DDCLAS                                                    CDL038
     C     CDL039        ANDEQ     'N'                                                        CDL039
     C                   ADD       1             Idx                                          CDL038
     C                   EVAL      FldNameArr(Idx) = 'DDCLAS'                                 CDL038
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0258'                                CDL038
     C                   EVAL      ddCLASok        = 'N'                                      CDL038
     C                   ENDIF                                                                CDL038
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RESETFLDS - Reset fields in Error                             *
      *****************************************************************
     C     RESETFLDS     BEGSR
      *
      * Reset fields in error to 'current' values
      *
      * Deal Type
     C     ddTYPEOK      IFEQ      'N'
     C                   MOVEL     @DDTYPE       DDTYPE
     C                   END
      *
      * Deal SubType
     C     ddSTYPOK      IFEQ      'N'
     C                   MOVEL     @DDSTYP       DDSTYP
     C                   END
      *
      * Federal Funds Indicator
     C     ddFEDFOK      IFEQ      'N'
     C                   MOVEL     @DDFEDF       DDFEDF
     C                   END
      *
      * Deal Date
     C     ddDLDTOK      IFEQ      'N'
     C                   MOVEL     @DDDLDT       DDDLDT
     C                   END
      *
      * Branch Code
     C     ddBRCAOK      IFEQ      'N'
     C                   MOVEL     @DDBRCA       DDBRCA
     C                   END
      *                                                                         CAP004
      * Book code                                                               CAP004
     C     ddBOKCOK      IFEQ      'N'                                          CAP004
     C                   MOVEL     @DDBOKC       DDBOKC                         CAP004
     C                   END                                                    CAP004
                                                                                CDL006
      ** Deal Linked Reference                                                  CDL006
                                                                                CDL006
     C     CDL006        IFEQ      'Y'                                          CDL006
     C     ddLNKNOK      ANDEQ     'N'                                          CDL006
     C                   MOVEL     @DDLNKN       DDLNKN                         CDL006
     C                   END                                                    CDL006
      *
      * Broker Code
     C     ddBKCDOK      IFEQ      'N'
     C                   MOVEL     @DDBKCD       DDBKCD
     C                   END
      *
      * Brokerage
     C     ddBRKGOK      IFEQ      'N'
     C                   MOVEL     @DDBRKG       DDBRKG
     C                   END
      *
      * Customer
     C     ddCUSTOK      IFEQ      'N'
     C                   MOVEL     @DDCUST       DDCUST
     C                   END
      *
      * Value Date
     C     ddVDATOK      IFEQ      'N'
     C                   MOVEL     @DDVDAT       DDVDAT
     C                   END
      *
      * Maturity Date
     C     ddMDATOK      IFEQ      'N'
     C                   MOVEL     @DDMDAT       DDMDAT
     C                   END
      *
      * Notice Days
     C     ddNTCEOK      IFEQ      'N'
     C                   MOVEL     @DDNTCE       DDNTCE
     C                   END
      *
      * Portfolio Reference
     C     ddPTFROK      IFEQ      'N'
     C                   MOVEL     @DDPTFR       DDPTFR
     C                   END
      *
      * Account Sequence Number
     C     ddACSQOK      IFEQ      'N'
     C                   MOVEL     @DDACSQ       DDACSQ
     C                   END
      *
      * Currency
     C     ddCCYOK       IFEQ      'N'
     C                   MOVEL     @DDCCY        DDCCY
     C                   END
      *
      * Deal Amount
     C     ddAMNPOK      IFEQ      'N'
     C                   MOVEL     @DDAMNP       DDAMNP
     C                   END
      *
      * Base Rate Code
     C     ddBSRCOK      IFEQ      'N'
     C                   MOVEL     @DDBSRC       DDBSRC
     C                   END
      *
      * Interest Rate/Spread
     C     ddSPRTOK      IFEQ      'N'
     C                   MOVEL     @DDSPRT       DDSPRT
     C                   END
      *
      * Actual Interest Rate                                                                 BUG5169
     C     ddAIROK       IFEQ      'N'                                                       BUG5169
     C     CDL020        ANDEQ     'Y'                                                       BUG5169
     C                   MOVEL     @DDAIR        DDAIR                                       BUG5169
     C                   END                                                                 BUG5169
                                                                                             BUG5169
      * Interest Calculation Method
     C     ddICMTOK      IFEQ      'N'
     C                   MOVEL     @DDICMT       DDICMT
     C                   END
      *
      * Negative Interest Indicator
     C     ddNGVIOK      IFEQ      'N'
     C                   MOVEL     @DDNGVI       DDNGVI
     C                   END
      *
      * Interest Payment Frequency
     C     ddIPFQOK      IFEQ      'N'
     C                   MOVEL     @DDIPFQ       DDIPFQ
     C                   END
      *
      * Next Interest Date
     C     ddNDATOK      IFEQ      'N'
     C                   MOVEL     @DDNDAT       DDNDAT
     C                   END
      *
      **Total*Interest*Amount**                                           164565
     C*****ddTOTIOK      IFEQ      'N'                                    164565
     C*****              MOVEL     @DDTOTI       DDTOTI                   164565
     C*****              END                                              164565
      *
      * Interest Frequency day in Month
     C     ddIPDMOK      IFEQ      'N'
     C                   MOVEL     @DDIPDM       DDIPDM
     C                   END
      *
      * Taxable Indicator
     C     ddMTAXOK      IFEQ      'N'
     C                   MOVEL     @DDMTAX       DDMTAX
     C                   END
      *
      * Interest Capitalisation Indicator
     C     ddCPTIOK      IFEQ      'N'
     C                   MOVEL     @DDCPTI       DDCPTI
     C                   END
      *
      * Front Up Interest Indicator
     C     ddFUIDOK      IFEQ      'N'
     C                   MOVEL     @DDFUID       DDFUID
     C                   END
      *
      * First & Last Day Interest Indicator
     C     ddFLIDOK      IFEQ      'N'
     C                   MOVEL     @DDFLID       DDFLID
     C                   END
      *
      * Round Down Interest Indicator
     C     ddRDFCOK      IFEQ      'N'
     C                   MOVEL     @DDRDFC       DDRDFC
     C                   END
      *
      * Rollover Deal Number
     C     ddDADNOK      IFEQ      'N'
     C                   MOVEL     @DDDADN       DDDADN
     C                   END
      *
      * Profit Centre
     C     ddPRFCOK      IFEQ      'N'
     C                   MOVEL     @DDPRFC       DDPRFC
     C                   END
      *
      * Automatic Rollover Indicator
     C     ddAUROOK      IFEQ      'N'
     C                   MOVEL     @DDAURO       DDAURO
     C                   END
      *
      * Funding Spread/Rate
     C     ddFSRPOK      IFEQ      'N'
     C                   MOVEL     @DDFSRP       DDFSRP
     C                   END
      *
      * Funding Rate Sign
     C     ddFSGNOK      IFEQ      'N'
     C                   MOVEL     @DDFSGN       DDFSGN
     C                   END
      *
      * Funding Profit Centre
     C     ddFPRCOK      IFEQ      'N'
     C                   MOVEL     @DDFPRC       DDFPRC
     C                   END
      *                                                                                       CDL038
      * Class                                                                                 CDL038
     C     ddCLASOK      IFEQ      'N'                                                        CDL038
     C                   MOVEL     @DDCLAS       DDCLAS                                       CDL038
     C                   END                                                                  CDL038
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CONVDATES  - Convert date fields from MMDELDPP from DDMMYYYY  *
      *              to Midas Dayno (5,0) format for comparison       *
      *****************************************************************
     C     CONVDATES     BEGSR
     C*
     C***********************************************
     C**  Format the transaction date               *
     C***********************************************
     C*
     C                   Z-ADD     HKDTYY        @@YY
     C                   Z-ADD     HKDTMM        @@MM
     C                   Z-ADD     HKDTDD        @@DD
     C*
     C     DateIn        IFEQ      0
     C                   Z-ADD     0             TransDate
     C                   ELSE
     C                   CALLB     'ZDATE10'
     C                   PARM                    DateIn
     C                   PARM                    ZZMDNO
     C                   MOVE      ZZMDNO        TransDate
     C                   END
     C*
     C***********************************************
     C**  Format the Last Interest date.            *
     C***********************************************
     C*
     C                   Z-ADD     HKSLYY        @@YY
     C                   Z-ADD     HKSLMM        @@MM
     C                   Z-ADD     HKSLDD        @@DD
     C*
     C     DateIn        IFEQ      0
     C                   Z-ADD     0             LstIntDate
     C                   ELSE
     C                   CALLB     'ZDATE10'
     C                   PARM                    DateIn
     C                   PARM                    ZZMDNO
     C                   MOVE      ZZMDNO        LstIntDate
     C                   END
     C*
     C***********************************************
     C**  Format the Interest Accrual Control date. *
     C***********************************************
     C*
     C                   Z-ADD     HKIAYY        @@YY
     C                   Z-ADD     HKIAMM        @@MM
     C                   Z-ADD     HKIADD        @@DD
     C*
     C     DateIn        IFEQ      0
     C                   Z-ADD     0             IntAccDate
     C                   ELSE
     C                   CALLB     'ZDATE10'
     C                   PARM                    DateIn
     C                   PARM                    ZZMDNO
     C                   MOVE      ZZMDNO        IntAccDate
     C                   END
     C*
     C***********************************************
     C**  Format the New Maturity Date.             *
     C***********************************************
     C*
     C     DDMDAT        IFEQ      *BLANK
     C                   Z-ADD     0             NewMatDate
     C                   ELSE
     C                   CALLB     'ZAVDATE'
     C                   PARM                    RetCodeOut
     C                   PARM                    DDMDAT
     C                   PARM                    BJDfin
     C                   PARM                    NewMatDate
     C                   END
     C*
     C***********************************************
     C*  Format the New Next Interest Payment date  *
     C***********************************************
     C*
     C     DDNDAT        IFEQ      *BLANK
     C                   Z-ADD     0             NewNxInDte
     C                   ELSE
     C                   CALLB     'ZAVDATE'
     C                   PARM                    RetCodeOut
     C                   PARM                    DDNDAT
     C                   PARM                    BJDfin
     C                   PARM                    NewNxInDte
     C                   END
     C*
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  211926
      *****************************************************************                       211926
      * ConvRate - Convert rate fields from characters to numeric     *                       211926
      *            first before comparing them.                       *                       211926
      *****************************************************************                       211926
     C     ConvRate      BEGSR                                                                211926
      *                                                                                       211926
      ** Initialise fields first                                                              211926
      *                                                                                       211926
     C                   MOVEA     *BLANKS       AlpRate                                      211926
     C                   MOVEA     *ZEROS        IntRate                                      211926
     C                   MOVEA     *ZEROS        DecRate                                      211926
     C                   Z-ADD     0             @AR                                          211926
     C                   Z-ADD     0             @IR                                          211926
     C                   Z-ADD     0             @DR                                          211926
     C                   Z-ADD     0             CRATE            11 7                        211926
     C                   Z-ADD     0             DEC               2 0                        211926
     C                   Z-ADD     0             NINT              4 0                        211926
     C                   Z-ADD     0             NDEC              7 0                        211926
     C                   MOVE      *BLANKS       CINT              4                          211926
     C                   MOVE      *BLANKS       CDEC              7                          211926
     C                   MOVE      'N'           NegRate           1                          211926
     C                   MOVE      '0'           *IN99                                        211926
     C                   MOVE      '0'           *IN98                                        211926
      *                                                                                       211926
      ** Move input to array.                                                                 211926
      ** Check for negative sign and decimal point.                                           211926
      *                                                                                       211926
     C                   MOVEA     WRATE         AlpRate                                      211926
     C                   Z-ADD     1             X                 2 0                        211926
     C     '-'           LOOKUP    AlpRate(X)                             99                  211926
     C     *IN99         IFEQ      '1'                                                        211926
     C                   MOVE      'Y'           NegRate                                      211926
     C                   ELSE                                                                 211926
     C                   Z-ADD     0             X                                            211926
     C                   ENDIF                                                                211926
     C                   Z-ADD     1             Y                 2 0                        211926
     C     '.'           LOOKUP    AlpRate(Y)                             98                  211926
     C     *IN98         IFEQ      '1'                                                        211926
     C     Y             SUB       1             @AR                                          211926
     C     Y             ADD       1             DEC                                          211926
     C                   ELSE                                                                 211926
     C                   Z-ADD     12            @AR                                          211926
     C                   Z-ADD     13            DEC                                          211926
     C                   ENDIF                                                                211926
      *                                                                                       211926
      ** Move integers to IntRate and Decimals to DecRate                                     211926
      *                                                                                       211926
     C                   Z-ADD     4             @IR                                          211926
     C     @AR           DOWGT     X                                                          211926
     C     @IR           ANDNE     0                                                          211926
     C     AlpRate(@AR)  IFNE      *BLANK                                                     211926
     C                   MOVE      AlpRate(@AR)  IntRate(@IR)                                 211926
     C                   SUB       1             @IR                                          211926
     C                   ENDIF                                                                211926
     C                   SUB       1             @AR                                          211926
     C                   ENDDO                                                                211926
     C                   Z-ADD     1             @DR                                          211926
     C     DEC           DOWLT     13                                                         211926
     C     @DR           ANDLE     7                                                          211926
     C     AlpRate(DEC)  IFNE      *BLANK                                                     211926
     C                   MOVE      AlpRate(DEC)  DecRate(@DR)                                 211926
     C                   ADD       1             @DR                                          211926
     C                   ENDIF                                                                211926
     C                   ADD       1             DEC                                          211926
     C                   ENDDO                                                                211926
      *                                                                                       211926
      ** Move IntRate and DecRate to output variable CRATE.                                   211926
      *                                                                                       211926
     C                   MOVEA     IntRate(1)    CINT                                         211926
     C                   MOVEA     DecRate(1)    CDEC                                         211926
     C                   MOVE      CINT          NINT                                         211926
     C                   MOVE      CDEC          NDEC                                         211926
     C     NDEC          DIV       10000000      CRATE                                        211926
     C                   ADD       NINT          CRATE                                        211926
     C     NegRate       IFEQ      'Y'                                                        211926
     C                   Z-SUB     CRATE         CRATE                                        211926
     C                   ENDIF                                                                211926
     C                   MOVE      *BLANKS       WRATE                                        211926
      *                                                                                       211926
     C                   ENDSR                                                                211926
      *****************************************************************                       211926
      /EJECT
     C*****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * New Deal in Screen Format
     C                   PARM                    NwDlScnFmt
      *
      * Current Deal in Screen Format
     C                   PARM                    DealScnFmt
      *
      * Current Deal in file format
     C                   PARM                    DealFilFmt
     C/COPY WNCPYSRC,MMLDNIAC07
      *
      * OUTPUTS
      *
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      * Amendments OK
     C                   PARM                    AmendOk           1
      *
      * Reset of Fields in Error Required (Y/N)
     C                   PARM                    ResetErrs         1
      *
      ** Initialize program name
      *
     C                   MOVEL     'MMLDNIAMD'   DBPGM
      *
      ** Key List for Deal Amendments file
      *
     C     @DEAMK        KLIST
     C                   KFLD                    @DEAMN            6 0
     C                   KFLD                    @VDYY             4 0
     C                   KFLD                    @VDMM             2 0
     C                   KFLD                    @VDDD             2 0
     C                   KFLD                    @DEAMS            3 0
 
     C     *LIKE         DEFINE    HKDDND        ZZMDNO
     C*
     C**  GET RUNDAT to access MULTI-BRANCHING flag.
     C**
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '900'         DBASE                          * DBERR 900 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
      ** ACCESS GENERAL LEDGER DETAILS
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDGELRPD'    DBFILE                         *************
     C                   MOVEL     '901'         DBASE                          * DBERR 900 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
      ** ACCESS MIDAS MODULE DETAILS
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE                         *************
     C                   MOVEL     '902'         DBASE                          * DBERR 900 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
      ** PORTFOLIO MANAGEMENT DETAILS
      *
     C     BGPFMG        IFEQ      'Y'
     C                   CALL      'AOPORTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDPORT        PARM      SDPORT        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDPORTPD'    DBFILE                         *************
     C                   MOVEL     '903'         DBASE                          * DBERR 900 *
     C                   EXSR      *PSSR                                        *************
     C                   END
     C                   END
      *
      ** ACCESS SAR DETAILS FILE TO DETERMINE IF BRT SAR IS INSTALLED
      ** (DATABASE ERROR HANDLING DONE IN ACCESS PROGRAM)
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01383'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01383            1
     C                   END
      *
      ** ACCESS SAR DETAILS FILE TO DETERMINE IF JSM SAR IS INSTALLED
      ** (DATABASE ERROR HANDLING DONE IN ACCESS PROGRAM)
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01391'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01391            1
     C                   END
      *
      ** Access SAR details file to determine if Enhanced Rollovers
      ** is switched on
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01434'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01434            1
     C                   END
      *
      **  Read the first and only record on MMCDAFLL.
      *
     C     1             CHAIN     MMCDAFLL                           60
      *
      **  If no valid record found then it is a data base error.
      *
     C     *IN60         IFEQ      '1'
     C     HHDLTF        OREQ      '*'
     C                   MOVEL     *BLANKS       DBKEY                          ***************
     C                   MOVEL     'MMCDAFLL'    DBFILE                         * DBERROR 018 *
     C                   MOVE      '904'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access SAR details file to determine if CDE002 is switched on          CDE002
      *                                                                         CDE002
     C                   CallB     'AOSARDR0'                                   CDE002
     C                   Parm      *Blanks       PRTCD             7            CDE002
     C                   Parm      '*VERIFY'     POPTN             7            CDE002
     C                   Parm      'CDE002'      PSARD             6            CDE002
     C     SCSARD        Parm      SCSARD        DSFDY                          CDE002
      *                                                                         CDE002
     C                   Move      'N'           CDE002            1            CDE002
     C                   If        PRTCD = *Blanks                              CDE002
     C                   Eval      CDE002 = 'Y'                                 CDE002
     C                   Endif                                                  CDE002
                                                                                              CDL016
      ** Access SAR details file to determine if CDL016 is switched on                        CDL016
      ** (Autumatic Rollover of Fixed Term Loan/Deposit)                                      CDL016
                                                                                              CDL016
     C                   CallB     'AOSARDR0'                                                 CDL016
     C                   Parm      *Blanks       PRTCD                                        CDL016
     C                   Parm      '*VERIFY'     POPTN                                        CDL016
     C                   Parm      'CDL016'      PSARD                                        CDL016
     C     SCSARD        Parm      SCSARD        DSFDY                                        CDL016
      *                                                                                       CDL016
     C                   Move      'N'           CDL016            1                          CDL016
     C                   If        PRTCD = *Blanks                                            CDL016
     C                   Eval      CDL016 = 'Y'                                               CDL016
     C                   Endif                                                                CDL016
      *                                                                                       CDL039
      ** ACCESS SAR DETAILS FILE TO DETERMINE IF CDL039 IS INSTALLED                          CDL039
      *                                                                                       CDL039
     C                   CALL      'AOSARDR0'                                                 CDL039
     C                   PARM      *BLANKS       @RTCD                                        CDL039
     C                   PARM      '*VERIFY'     @OPTN                                        CDL039
     C                   PARM      'CDL039'      @SARD             6                          CDL039
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL039
      *                                                                                       CDL039
     C     @RTCD         IFEQ      *BLANK                                                     CDL039
     C                   MOVEL     'Y'           CDL039            1                          CDL039
     C                   ELSE                                                                 CDL039
     C                   MOVEL     'N'           CDL039                                       CDL039
     C                   END                                                                  CDL039
                                                                                             BUG5169
      ** Access SAR details file to determine if CDL020 is switched on                       BUG5169
      ** (Apply Base Rate at Value Date)                                                     BUG5169
                                                                                             BUG5169
     C                   CallB     'AOSARDR0'                                                BUG5169
     C                   Parm      *Blanks       PRTCD                                       BUG5169
     C                   Parm      '*VERIFY'     POPTN                                       BUG5169
     C                   Parm      'CDL020'      PSARD                                       BUG5169
     C     SCSARD        Parm      SCSARD        DSFDY                                       BUG5169
      *                                                                                      BUG5169
     C                   Move      'N'           CDL020            1                         BUG5169
     C                   If        PRTCD = *Blanks                                           BUG5169
     C                   Eval      CDL020 = 'Y'                                              BUG5169
     C                   Endif                                                               BUG5169
     C/COPY WNCPYSRC,MMLDNIAC02
                                                                                CDE002
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
