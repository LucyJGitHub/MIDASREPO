     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate receivers correspondnt header')      *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVRECR01  - Validate Receiver's Correspondent Header        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CSW207             Date 07Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 221760             Date 01Apr04               *
      * Midas Release 4.01.01 ----------------------------------------*
      *                 CSW202             Date 20May02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      *                 184060             Date 22Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT008  *CREATE    Date 17Nov99               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - Swift 2007 Changes (Recompiled)                     *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  221760 - Do not validate SWIFT ID if MEBICDPD is empty.      *
      *  CSW202 - SWIFT 2002 Standards Update                         *
      *  CSW201 - SWIFT 2001 Standards Update                         *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  184060 - No transaction type code in detail screen -Recompile*
      *  CFT008 - Funds Transfer/Swift Messages MT102                 *
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
 
      ** Program, procedure and module names for parameters
      ** ==================================================
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      * Header record datastructure
     D HdrRcdIn      E DS                  EXTNAME(FT102HSPD)
     D DtlRcdIn      E DS                  EXTNAME(FT102DSPD) PREFIX(D)
 
      *  External Data structure to hold the outgoing record format
     D ACCNT         E DS                  EXTNAME(ACCNTAB)
     D   ACBRCA      E                     EXTFLD(BRCA)
     D   ACPRFC      E                     EXTFLD(PRFC)
 
      ** External data structure for access programs (Long)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External data structure for access programs (Short)                                  CSW202
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CSW202
                                                                                              CSW202
      ** Data structure for Business Entity Identifier details                                CSW202
     D MEBEIS        E DS                  EXTNAME(MEBEISPD)                                  CSW202
                                                                                              CSW202
      ** Data structure for Midas BIC Directory                                               CSW201
     D MEBICD        E DS                  EXTNAME(MEBICDPD)                                  CSW201
                                                                                              CSW201
      ** Data structure for Customer Details                                                  CSW201
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CSW201
                                                                                              CSW201
      ** Data structure for Nostro Details                                                    CSW201
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)                                  CSW201
                                                                                              CSW201
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D wvalid          S              1
     D wivld           S              1
     D wdvld           S              1
     D wsvld           S              1
     D wssvld          S              1
     D CFT004          S              1
     D  XSINST         S                   Like(PSINST)
 
      * OK Flags for first screen - Header
     D OKFlagHs1     E DS                  EXTNAME(FTE102H1PD)
 
     D GenOkFlag2      S              1    Import
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
      ** SWIFT 2001 switchable feature                                                        CSW201
     D CSW201          S              1A                                                      CSW201
                                                                                              CSW201
      ** BIC id parameter for AOBICDV0                                                        CSW201
     D PIDENF          S             18A                                                      CSW201
                                                                                              CSW201
      ** Account type parameter for AOBICDV0                                                  CSW201
     D PTTyp           S              7A                                                      CSW201
                                                                                              CSW201
      ** Customer No. work variable                                                           CSW201
     D WCust           S              6A                                                      CSW201
                                                                                              CSW201
     D CSW202          S              1                                                       CSW202
     D PRTCD           S              7                                                       CSW202
     D POPTN           S              7                                                       CSW202
     D PBICD           S              4                                                       CSW202
                                                                                              CSW202
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   Eval      RetCodeIn  = *Blanks
     C                   Eval      Idx        = 0
     C                   Eval      WIdx       = 0
     C                   Eval      PTType = *Blanks
     C                   Eval      PType = *Blanks
     C                   Eval      GenOkFlag2 = 'Y'
 
     C                   Eval      PRCVTYP = *Blanks
 
     C                   Eval      wsvld = 'Y'
     C                   Eval      wssvld = 'Y'
     C                   Eval      wdvld = 'Y'
     C                   Eval      wivld = 'Y'
      *
      ** Check to see if sending institution has a valid field
      *
     C                   Eval      PACCT = PSINST
     C                   Exsr      SrAcct
      *
      ** Account invalid for sending institution
     C                   If        wvalid = 'N'
     C                   Eval      wivld = 'N'
     C                   Endif
      *
      ** Check to see if destination has a valid entry
      *
     C                   Eval      PACCT = PCctDst
     C                   Exsr      SrAcct
 
      ** Account invalid for destination
     C                   If        wvalid = 'N'
     C                   Eval      wdvld = 'N'
     C                   Endif
      *
      ** Check to see if sender's correspondent has a valid entry
      *
     C                   EVAL      PACCT = PSNDCOR
     C                   EXSR      SrAcct
      *
      ** Account invalid for sender's  correspondent
      *
     C                   If        wvalid = 'N'
     C                   Eval      wsvld = 'N'
     C                   Endif
      *
     C                   Select
     C                   When      PCCTTYP = 'BI' and
     C                             wivld = 'N' and
     C                             wsvld = 'N'
     C                   If        PRcvcor = *blanks
     C                   Eval      GenOkFlag2 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      RetCodeIn = 'Error'
     C                   Eval      FldNamXAr(Idx) = DDSName
     C                   Eval      MsgIdXAr(Idx) = 'RFV0346'
     C                   Else
     C                   Eval      PACCT = PRcvCor
     C                   Exsr      SrAcct
      ** Account invalid
     C                   If        wvalid = 'N'
     C                   Eval      GenOkFlag2 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      RetCodeIn = 'Error'
     C                   Eval      FldNamXAr(Idx) = DDSName
     C                   Eval      MsgIdXAr(Idx) = 'RFV0346'
     C                   Else
      *
     C                   Select
     C                   When      PTYPE = 'IBAN'
     C                   Eval      PRCVTYP = 'I'
     C                   When      PTYPE = '*LEDGER'
     C                   Eval      PRCVTYP = 'G'
     C                   When      PTYPE = '*NOSTRO'
     C                   Eval      PRCVTYP = 'F'
     C                   When      PTYPE = '*RETAIL'
     C                   Eval      PRCVTYP = 'R'
     C                   Endsl
      *
     C                   Endif
      *
     C                   Endif
      *
     C                   WHEN      PCCTTYP = 'BO' and
     C                             wdvld = 'N' and
     C                             wsvld = 'N'
      *
     C                   If        PRcvCor = *blanks
     C                   Eval      GenOkFlag2 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      RetCodeIn = 'Error'
     C                   Eval      FldNamXAr(Idx) = DDSName
     C                   Eval      MsgIdXAr(Idx) = 'RFV0347'
     C                   Else
     C                   Eval      PACCT = PRCVCOR
     C                   Exsr      SrAcct
      *
      ** Account invalid
     C                   If        wvalid = 'N'
     C                   Eval      GenOkFlag2 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      RetCodeIn = 'Error'
     C                   Eval      FldNamXAr(Idx) = DDSName
     C                   Eval      MsgIdXAr(Idx) = 'RFV0347'
     C                   Else
 
      *
      ** If a valid account and starts with a '/', remove it.
      *
     C                   If        %Subst(PRCVCOR:1:1) = '/'
     C                   Eval      PRCVCOR = %Subst(PRCVCOR:2)
     C                   Endif
 
     C                   Select
     C                   When      PTYPE = 'IBAN'
     C                   Eval      PRCVTYP = 'I'
     C                   When      PTYPE = '*LEDGER'
     C                   Eval      PRCVTYP = 'G'
     C                   When      PTYPE = '*NOSTRO'
     C                   Eval      PRCVTYP = 'F'
     C                   When      PTYPE = '*RETAIL'
     C                   Eval      PRCVTYP = 'R'
     C                   Endsl
      *
     C                   Endif
      *
     C                   Endif
      *
      ** If the other fields contain a valid account then entry can be a swi
      ** B.I.C, customer number or shortname.
      *
     C                   Other
 
     C                   If        PRcvCor <> *Blanks
     C                   Eval      XSINST = PSINST
      *
     C**********         CallB     'AOBICDV0'                                                 221760
     C                   CallB     'AOBICDV01'                                                221760
     C                   Parm                    RetCodeIn
     C                   Parm                    PRcvCor
     C                   Parm                    PTType            7
     C                   Parm                    Dssdy
 
     C                   If        PTType = '*BIC   ' or
     C                             PTType =  '*NUMBER'  and
     C                             RetCodeIn = '*BICFND' or
     C                             PTType =  '*SHNAME' and
     C                             RetCodeIn = '*BICFND'
 
      *
      ** If a valid account and starts with a '/', remove it.
      *
     C                   If        %Subst(PRCVCOR:1:1) = '/'
     C                   Eval      PRCVCOR = %Subst(PRCVCOR:2)
     C                   Endif
 
     C                   Else
 
      *
     C                   Eval      PACCT = PRCVCOR
     C                   Exsr      SrAcct
      *
      ** Must be BIC, customer number, shortname or valid account
      *
     C                   If        wvalid = 'N'
     C                   Eval      GenOkFlag2 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      RetCodeIn = 'Error'
     C                   Eval      FldNamXAr(Idx) = DDSName
     C                   Eval      MsgIdXAr(Idx) = 'RFV0323'
     C                   Else
 
      *
      ** If a valid account and starts with a '/', remove it.
      *
     C                   If        %Subst(PRCVCOR:1:1) = '/'
     C                   Eval      PRCVCOR = %Subst(PRCVCOR:2)
     C                   Endif
 
     C                   Select
     C                   When      PTYPE = 'IBAN'
     C                   Eval      PRCVTYP = 'I'
     C                   When      PTYPE = '*LEDGER'
     C                   Eval      PRCVTYP = 'G'
     C                   When      PTYPE = '*NOSTRO'
     C                   Eval      PRCVTYP = 'F'
     C                   When      PTYPE = '*RETAIL'
     C                   Eval      PRCVTYP = 'R'
     C                   Endsl
 
     C                   Endif
     C                   Endif
 
     C                   Endif
     C                   Endsl
 
      * Now validate that all data entered is OK for SWIFT
 
     C                   If        PRCVCOR <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      PRCVCOR       Swift_Text       50
     C                   If        RetCdeIn = 'Error'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'
     C                   Eval      FldNamXAr(Idx) =  DDSName
     C                   Eval      GenOkFlag2 = 'N'
     C                   Endif
     C                   Endif
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y' AND PRCVCOR <> *BLANKS                        CSW201
      *                                                                                       CSW201
      ** Check if *BIC                                                                        CSW201
      *                                                                                       CSW201
     C                   SELECT                                                               CSW201
      *                                                                                       CSW201
     C                   WHEN      PTType = '*BIC   '                                         CSW201
     C                   EVAL      MEBICD = DSSDY                                             CSW201
                                                                                              CSW202
      ** If SWIFT 2002 is on, verify if SWIFT BIC is attached with                            CSW202
      ** a SWIFT BEI by calling access object AOBEISR0.                                       CSW202
                                                                                              CSW202
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   CALLB     'AOBEISR0'                                                 CSW202
     C                   PARM      *BLANKS       PRTCD                                        CSW202
     C                   PARM      '*VERIFY'     POPTN                                        CSW202
     C                   PARM      BDSUBT        PBICD                                        CSW202
     C     MEBEIS        PARM      MEBEIS        DSFDY                                        CSW202
     C                   ENDIF                                                                CSW202
      *                                                                                       CSW201
      ***If*subtype*is*'BEID'*or*'TRCO',*generate*error                                CSW201 CSW202
      ** If subtype is a BEI, generate error.                                                 CSW202
      *                                                                                       CSW201
     C**********         IF        BDSUBT = 'BEID' OR BDSUBT = 'TRCO'                  CSW201 CSW202
     C                   IF        (BDSUBT = 'BEID'  OR  BDSUBT = 'TRCO')                     CSW202
     C                             AND  CSW202 = 'N'                                          CSW202
     C                             OR   CSW202 = 'Y'  AND  PRTCD = *BLANKS                    CSW202
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      RetCodeIn = 'Error'                                        CSW201
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0512'                                  CSW201
     C                   EVAL      FldNamXAr(Idx) = DDSName                                   CSW201
     C                   EVAL      GenOkFlag2 = 'N'                                           CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   WHEN      PTType = '*NUMBER' AND                                     CSW201
     C                             RetCodeIn = '*BICFND'                                      CSW201
     C                             OR PTType = '*SHNAME' AND                                  CSW201
     C                             RetCodeIn = '*BICFND'                                      CSW201
     C                   EVAL      SDCUST = DSSDY                                             CSW201
     C                   EVAL      PIDENF = BBCSID                                            CSW201
     C                   EXSR      SRBEID                                                     CSW201
      *                                                                                       CSW201
     C                   OTHER                                                                CSW201
     C                   EVAL      WCust = *BLANKS                                            CSW201
     C                   IF        PTYPE = 'IBAN'                                             CSW201
     C                   MOVEL     CNUM          WCust                                        CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   IF        PTYPE = '*NOSTRO'                                          CSW201
     C                   EVAL      SDNOST = DSSDY                                             CSW201
     C                   EVAL      WCust = A7CUST                                             CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   IF        PTYPE = '*LEDGER' OR                                       CSW201
     C                             PTYPE = '*RETAIL'                                          CSW201
     C                   EVAL      ACCNT = DSSDY                                              CSW201
     C                   MOVEL     CNUM          WCust                                        CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   IF        WCust <> *BLANKS                                           CSW201
     C                   EVAL      PIDENF = WCust                                             CSW201
     C                   EXSR      SRBEID                                                     CSW201
     C                   IF        PTTyp = '*NUMBER' AND                                      CSW201
     C                             RetCodeIn = '*BICFND'                                      CSW201
     C                   EVAL      SDCUST = DSSDY                                             CSW201
     C                   EVAL      PIDENF = BBCSID                                            CSW201
     C                   EXSR      SRBEID                                                     CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   ENDSL                                                                CSW201
     C                   ENDIF                                                                CSW201
 
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrAcct - Checks for valid account                             *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: AOIBANR2, AOACCTV1                                     *
      *                                                               *
      *****************************************************************
     C     SrAcct        Begsr
 
     C                   Eval      PTYPE = *Blanks
     C                   Eval      wvalid = 'Y'
 
      ** CFT is switched on
     C                   If        CFT004 = 'Y'
 
      ** Validate Account
     C                   CallB     'AOIBANR2'
     C                   Parm      *Blanks       PRTCD
     C                   Parm                    PACCT            35
     C     ACCNT         Parm      ACCNT         DSSDY
 
     C                   If        PRTCD = *Blanks
     C                   Eval      PTYPE = 'IBAN'
     C                   Endif
     C                   Endif
 
     C                   If        PTYPE <> 'IBAN'
 
      ** Validate Account
     C                   CallB     'AOACCTV1'
     C                   Parm      *Blanks       PRTCD             7            B:Return code
     C                   Parm                    PTYPE             7            I:A/c ID
     C                   Parm                    PACCT                          I:A/c Currency
     C                   Parm                    DSSDY                          I:A/c code
     C                   Endif
 
      ** Invalid Account
     C                   If        PTYPE <> 'IBAN' and
     C                             PTYPE <> '*NOSTRO'  and
     C                             PTYPE <> '*RETAIL'  and
     C                             PTYPE <> '*LEDGER' or
     C                             PRTCD <> *Blanks
     C                   Eval      wvalid = 'N'
     C                   Endif
 
     C                   Endsr
      *****************************************************************                       CSW201
      /EJECT                                                                                  CSW201
      *****************************************************************                       CSW201
      *                                                               *                       CSW201
      * SRBEID - Verify if BEI identifier                             *                       CSW201
      *                                                               *                       CSW201
      * Called by: Main processing                                    *                       CSW201
      *                                                               *                       CSW201
      * Calls: AOBICDV0                                               *                       CSW201
      *                                                               *                       CSW201
      *****************************************************************                       CSW201
     C     SRBEID        BEGSR                                                                CSW201
      *                                                                                       CSW201
     C**********         CALLB     'AOBICDV0'                                          CSW201 221760
     C                   CALLB     'AOBICDV01'                                                221760
     C                   PARM                    RetCodeIn                                    CSW201
     C                   PARM                    PIDENF                                       CSW201
     C                   PARM                    PTTyp                                        CSW201
     C                   PARM                    DSSDY                                        CSW201
      *                                                                                       CSW201
     C                   IF        PTTyp = '*BIC   '                                          CSW201
     C                   EVAL      MEBICD = DSSDY                                             CSW201
                                                                                              CSW202
      ** If SWIFT 2002 is on, verify if SWIFT BIC is attached with                            CSW202
      ** a SWIFT BEI by calling access object AOBEISR0.                                       CSW202
                                                                                              CSW202
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   CALLB     'AOBEISR0'                                                 CSW202
     C                   PARM      *BLANKS       PRTCD                                        CSW202
     C                   PARM      '*VERIFY'     POPTN                                        CSW202
     C                   PARM      BDSUBT        PBICD                                        CSW202
     C     MEBEIS        PARM      MEBEIS        DSFDY                                        CSW202
     C                   ENDIF                                                                CSW202
      *                                                                                       CSW201
     C**********         IF        BDSUBT = 'BEID' OR BDSUBT = 'TRCO'                  CSW201 CSW202
     C                   IF        (BDSUBT = 'BEID'  OR  BDSUBT = 'TRCO')                     CSW202
     C                             AND  CSW202 = 'N'                                          CSW202
     C                             OR   CSW202 = 'Y'  AND  PRTCD = *BLANKS                    CSW202
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      RetCodeIn = 'Error'                                        CSW201
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0512'                                  CSW201
     C                   EVAL      FldNamXAr(Idx) = DDSName                                   CSW201
     C                   EVAL      GenOkFlag2 = 'N'                                           CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   ENDSR                                                                CSW201
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        Begsr
 
     C     *Entry        PLIST
 
      ** INPUTS
 
     C                   Parm                    RetCodeIn
     C                   Parm                    RespMode          1
     C                   Parm                    ActionCode        1
 
      ** Screen fields
     C                   Parm                    HdrRcdIn
     C                   Parm                    DTlRcdIn
     C                   PARM                    OKFlagHS1
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr
     C                   Parm                    DDSName          10
 
      ** Access SAR file to see if CFT004 is present
     C                   CallB     'AOSARDR0'
     C                   Parm      *Blanks       PRTCD
     C                   Parm      '*VERIFY'     POPTN             7
     C                   Parm      'CFT004'      PSARD             6
     C                   Parm                    DSSDY
 
     C                   Eval      CFT004 = 'N'
     C                   If        PRTCD = *Blanks
     C                   Eval      CFT004 = 'Y'
     C                   Endif
      *                                                                                       CSW201
      ** Check if SWIFT 2001 is installed                                                     CSW201
      *                                                                                       CSW201
     C                   CALL      'SWIF2001'                                                 CSW201
     C                   PARM      *BLANKS       @RTCD                                        CSW201
      *                                                                                       CSW201
     C                   IF        @RTCD = 'CSW2001'                                          CSW201
     C                   EVAL      CSW201 = 'Y'                                               CSW201
     C                   ELSE                                                                 CSW201
     C                   EVAL      CSW201 = 'N'                                               CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
                                                                                              CSW202
      ** Check if SWIFT 2002 is installed                                                     CSW202
                                                                                              CSW202
     C                   CALL      'SWIF2002'                                                 CSW202
     C                   PARM      *BLANKS       PRTCD                                        CSW202
                                                                                              CSW202
     C                   IF        PRTCD = 'CSW2002'                                          CSW202
     C                   EVAL      CSW202 = 'Y'                                               CSW202
     C                   ELSE                                                                 CSW202
     C                   EVAL      CSW202 = 'N'                                               CSW202
     C                   ENDIF                                                                CSW202
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   Endsr                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
