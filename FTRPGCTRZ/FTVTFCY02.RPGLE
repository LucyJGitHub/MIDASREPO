     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate Total Transfer Amt/Ccy-Header')      *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVTFCY02  - Validate Transfer Ccy and Transfer Amount Hdr   *
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
      *  Prev Amend No. CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG25861           Date 03Sep09               *
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CSW207             Date 07Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG3281            Date 17Jun04               *
      *                 CGL014             Date 20Oct03               *
      *                 CLE025             Date 20Oct03               *
      *                 CAP084             Date 16Jul03               *
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
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  BUG25861 - Validate total transfer field after transaction   *
      *             input                                             *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - Swift 2007 Changes (Recompiled)                     *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG3281 - Discrepancies on sources                           *
      *  CGL014 - Collaterals Processing                              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CAP084 - Creation of wrappers for use with front end.        *
      *  CSW201 - SWIFT 2001 Standards Update (Recompiled)            *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  184060 - No transaction type code in detail screen -Recompile*
      *  CFT008 - Funds Transfer/Swift Messages MT102                 *
      *                                                               *
      *****************************************************************
 
      ** CCt detail file
     FFT102DL0  IF   E           K DISK    Prefix(D)
                                                                                              CGL014
      ** RE Shadow balances file                                                              CGL014
     FMEMOSL2   IF   E           K DISK    INFSR(*PSSR)                                       CGL014
 
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
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
 
      ** Header record in screen format
     D HdrRcdIn      E DS                  EXTNAME(FT102HSPD)
     D DtlRcdIn      E DS                  EXTNAME(FT102DSPD) PREFIX(D)
 
      ** OK Flags for First screen
     D OKFlags       E DS                  EXTNAME(FTE102H1PD)
 
      ** External data structure for Currency standing data
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
                                                                                              CGL014
      ** External data structure for Switchable features data                                 CGL014
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CGL014
     D  SLCD         E                     EXTFLD(LCD)                                        CGL014
 
      ** External data structure for access programs (long)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External data structure for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External Data structure to hold the outgoing record format
     D ACcnt         E DS                  EXTNAME(ACCNTAB)
     D   ACBRCA      E                     EXTFLD(BRCA)
     D   ACPRFC      E                     EXTFLD(PRFC)
 
     D PType           S                   LIKE(PRtcd)
 
     D CFT004          S              1    INZ('N')
 
     D PAcct           S             35
 
     D WValid          S              1    INZ('Y')
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Numeric version of Transfer Amount
     D NumTRNAMT       S             15P 0
 
      ** Numeric total transfer amount (with/without relevant charges)
     D W#Total         S             15P 0
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIx             S              3P 0
                                                                                              CGL014
     D CGL014          S              1                                                       CGL014
     D PRTCD           S              7                                                       CGL014
     D POPTN           S              7                                                       CGL014
     D PSARD           S              6                                                       CGL014
     D WAmount         S             15  0                                                    CGL014
     D WrkCLBLN        S             15  0                                                    CGL014
     D WTranAmt        S             15  0                                                    CGL014
 
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
 
     C                   EVAL      RetCodeIn  = *Blanks
     C                   EVAL      Idx        = 0
     C                   EVAL      WIx        = 0
     C                   EVAL      OKCTCCY = 'Y'
     C                   EVAL      OKCTAMT = 'Y'
     C                   EVAL      PType = 'Y'
      *
      ** Currency is mandatory
      *
     C                   IF        PCCTCCY = *Blanks
     C                   EVAL      Idx            =   Idx+1
     C                   EVAL      RetCodeIn      =   'Error'
     C                   EVAL      MsgIdXAr(Idx)  =   'RFV0148'
     C*******************EVAL      FldNamXAr(Idx) =   DDSName                   CAP084
     C                   EVAL      FldNamXAr(Idx) =   'PCCTCCY'                 CAP084
     C                   EVAL      OKCTCCY = 'N'
     C                   ELSE
      *
      ** Access currency file
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *Blanks       PRTCD             7
     C                   PARM      '*KEY'        POPTN             7
     C                   PARM      PCCTCCY       PCCY              3
     C     SDCURR        PARM      SDCURR        Dssdy
      *
     C                   IF        PRTCD <> *Blanks
     C                   EVAL      Idx            =   Idx+1
     C                   EVAL      RetCodeIn      =   'Error'
     C                   EVAL      MsgIdXAr(Idx)  =   'RFV0147'
     C*******************EVAL      FldNamXAr(Idx) =   DDSName                   CAP084
     C                   EVAL      FldNamXAr(Idx) =   'PCCTCCY'                 CAP084
     C                   EVAL      OKCTCCY = 'N'
      *
     C                   ELSE
      *
     C                   IF        PCcttyp = 'BO'
     C                   EXSR      ValacctO
     C                   ENDIF
      *
     C                   IF        PCcttyp = 'BI'
     C                   EXSR      ValacctI
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      **  Transfer amount cannot be validated until correct currency has been
      **  entered
      *
     C                   IF        OkCtccy = 'N'
     C                   EVAL      Idx            =   Idx+1
     C                   EVAL      RetCodeIn      =   'Error'
     C                   EVAL      MsgIdXAr(Idx)  =   'RFV0330'
     C                   EVAL      FldNamXAr(Idx) =   DDSName
     C                   EVAL      OKCTAMT = 'N'
     C                   ELSE
      *
     C                   IF        PCctAmt <> *Blanks
      *
      ** Reset work fields
      *
     C                   EVAL      ZALIGNok = 'Y'
     C                   EVAL      ZFIELD = *Blanks
     C                   EVAL      ZADEC = *Zero
     C                   EVAL      ZADIG = *Zero
     C                   EVAL      NumTRNAMT = *Zero
     C                   EVAL      ZADIG = 15 - A6NBDP
     C                   MOVE      PCCTAMT       ZFIELD
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      A6NBDP        ZADEC             1 0
     C                   PARM                    ZADIG             2 0
      *
      ** Transfer Amount must be in correct format for this currency
      *
     C                   IF        ZALIGNok = 'N'
     C                   EVAL      OKCTAmt = 'N'
     C                   EVAL      Idx =  Idx + 1
     C                   EVAL      FldNamXAr(Idx) = DDSName
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0149'
     C                   ELSE
     C                   IF        PcctId <> *Blanks                                        BUG25861
      *
      ******** If no error in Amount, ensure it is greater than zero
      *
     C                   MOVE      ZFIELD        NumTRNAMT
      *
      ** If Amount is OK format entry to aprropriate decimal places.
      *
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      A6NBDP        ZADEC
      *
     C                   MOVE      ZFIELD        PCCTAMT
      *
      ** Total transfer amount must be the sum of the individual transfer
      ** amount +/- relevant charges depending on the 'details of charges'
      *
     C                   EVAL      W#Total = *Zeros
      *
     C     PcctId        SETLL     FT102DL0
     C     PcctId        READE     FT102DL0                               99
     C                   DOW       *In99 = *Off
      *
     C                   IF        PCctChg <> *Blanks OR
     C                             DCcyChg <> *Blanks
      *
     C                   IF        PCctChg = 'OUR' OR
     C                             DCcyChg = 'OUR'
     C                   EVAL      W#Total = W#Total + DRcvCtf + DcctAmt
      * is the one above correct or is it the one below!???
     C                   ENDIF
 
     C                   IF        PCctChg = 'SHA' OR
     C                             DCcyChg = 'SHA'
     C                   EVAL      W#Total = W#Total + DCctAmt
     C                   ENDIF
 
     C                   IF        PCctChg = 'BEN' OR
     C                             DCcyChg = 'BEN'
     C                   EVAL      W#Total = W#Total + DCctAmt
     C                   ENDIF
      *
     C                   ENDIF
     C     PcctId        READE     FT102DL0                               99
     C                   ENDDO
      *
     C                   IF        W#Total <> NumTrnAmt
     C                   EVAL      OKCTAmt = 'N'
     C                   EVAL      Idx =  Idx + 1
     C                   EVAL      FldNamXAr(Idx) = DDSName
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0334'
     C                   ENDIF
                                                                                              CGL014
     C                   IF        PCcttyp = 'BI'  AND  CGL014 = 'Y'  AND                     CGL014
     C                             ATYP = 'R'  AND  COLF = 'Y'                                CGL014
     C                   EVAL      WTranAmt = W#Total                                         CGL014
     C                   EXSR      SRValBlock                                                 CGL014
     C                   ENDIF                                                                CGL014
      *
     C                   ENDIF
     C                   ENDIF                                                              BUG25861
      *
      ** If total transfer amount is blank then default it to the sum
      ** of the detail entered so far
      *
     C                   ELSE
      *                                                                es'
      ** Total transfer amount must be the sum of the individual transfer
      ** amount +/- relevant charges depending on the 'details of charges'
      *
     C                   EVAL      W#Total = *Zeros
      *
     C     PcctId        SETLL     FT102DL0
     C     PcctId        READE     FT102DL0                               99
     C                   DOW       *In99 = *Off
      *
     C                   IF        PCctChg <> *Blanks OR
     C                             DCcyChg <> *Blanks
      *
     C                   IF        PCctChg = 'OUR' OR
     C                             DCcyChg = 'OUR'
     C                   EVAL      W#Total = W#Total + DRcvCtf + DcctAmt
      * is the one above correct or is it the one below?
     C                   ENDIF
 
     C                   IF        PCctChg = 'SHA' OR
     C                             DCcyChg = 'SHA'
     C                   EVAL      W#Total = W#Total + DCctAmt
     C                   ENDIF
 
     C                   IF        PCctChg = 'BEN' OR
     C                             DCcyChg = 'BEN'
     C                   EVAL      W#Total = W#Total + DCctAmt
     C                   ENDIF
      *
     C                   ENDIF
     C     PcctId        READE     FT102DL0                               99
     C                   ENDDO
      *
      **
     C                   EVAL      NumTrnAmt = *Zeros
     C                   EVAL      NumTrnAmt = W#Total
     C                   EVAL      ZField = *Blanks
     C                   MOVE      NumTrnAmt     Zfield
      *
      ** If Amount is OK format entry to appropriate decimal places.
      *
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      A6NBDP        ZADEC
      *
     C                   MOVE      ZFIELD        PCCTAmt
                                                                                              CGL014
     C                   IF        PCcttyp = 'BI'  AND  CGL014 = 'Y'  AND                     CGL014
     C                             ATYP = 'R'  AND  COLF = 'Y'                                CGL014
     C                   EVAL      WTranAmt = W#Total                                         CGL014
     C                   EXSR      SRValBlock                                                 CGL014
     C                   ENDIF                                                                CGL014
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValacctO - Validate the currency to ensure the it is in       *
      *            same currency as the account entered               *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     ValacctO      BEGSR
      *
     C                   SELECT
     C                   WHEN      PDstTyp = 'I' OR PDstTyp = 'G' OR
     C                             PDstTyp = 'F' OR PDsttyp = 'R'
     C                   EVAL      PAcct = PCCtdst
     C                   EXSR      ValCcy
      *
     C                   WHEN      PSndtyp = 'I' OR PSndtyp = 'G' OR
     C                             PSndtyp = 'F' OR PSndtyp = 'R'
     C                   EVAL      PAcct = PSndCor
     C                   EXSR      ValCcy
      *
     C                   WHEN      PRcvtyp = 'I' OR PRcvtyp = 'G' OR
     C                             PRcvtyp = 'F' OR PRcvtyp = 'R'
     C                   EVAL      PAcct = PRcvCor
     C                   EXSR      ValCcy
      *
     C                   OTHER
      *
     C                   EVAL      OkCtCcy = 'N'
     C                   EVAL      Idx = Idx + 1
     C*******************EVAL      FldNamXAr(Idx) = DDSName                     CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PCCTCCY'                   CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0328'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDSL
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValacctI - Validate the currency to ensure the it is in       *
      *            same currency as the account entered               *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     ValacctI      BEGSR
      *
     C                   SELECT
     C                   WHEN      PSinstt = 'I' OR PSinstt = 'G' OR
     C                             PSinstt = 'F' OR PSinstt = 'R'
     C                   EVAL      PAcct = PSinst
     C                   EXSR      ValCcy
      *
     C                   WHEN      Psndtyp = 'I' OR PSndtyp = 'G' OR
     C                             PSndtyp = 'F' OR PSndtyp = 'R'
     C                   EVAL      PAcct = PSndCor
     C                   EXSR      ValCcy
      *
     C                   WHEN      PRcvtyp = 'I' OR PRcvtyp = 'G' OR
     C                             PRcvtyp = 'F' OR PRcvtyp = 'R'
     C                   EVAL      PAcct = PRcvCor
     C                   EXSR      ValCcy
      *
     C                   OTHER
      *
     C                   EVAL      OkCtCcy = 'N'
     C                   EVAL      Idx = Idx + 1
     C*******************EVAL      FldNamXAr(Idx) = DDSName                     CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PCCTCCY'                   CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0329'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDSL
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************                       CGL014
      *                                                               *                       CGL014
      *  SRValBlock - Further validation for sufficient funds         *                       CGL014
      *                                                               *                       CGL014
      *****************************************************************                       CGL014
                                                                                              CGL014
     C     SRValBlock    BEGSR                                                                CGL014
                                                                                              CGL014
      ** Access MEMOS for the shadow cleared balance                                          CGL014
                                                                                              CGL014
     C     ACNO          CHAIN     MEMOSL2                                                    CGL014
                                                                                              CGL014
     C                   IF        %FOUND(MEMOSL2)                                            CGL014
     C                   Z-SUB     CLBLN         WrkCLBLN                                     CGL014
     C                   EVAL      WAmount = WrkCLBLN - WTranAmt                              CGL014
                                                                                              CGL014
      ** Error:  Available balance is not sufficient                                          CGL014
      ** to cover blocked amount                                                              CGL014
                                                                                              CGL014
     C                   IF        WAmount < BCOA                                             CGL014
     C                   EVAL      OKCTAMT = 'N'                                              CGL014
     C                   ADD       1             Idx                                          CGL014
     C                   EVAL      FldNamXAr(Idx) = DDSName                                   CGL014
     C                   EVAL      MsgIdXAr(Idx) = 'FTA0140'                                  CGL014
     C                   ELSE                                                                 CGL014
                                                                                              CGL014
      ** Warning:  Balance is greater than blocked amount but less                            CGL014
      ** than minimum balance; minimum balance will be exceeded                               CGL014
                                                                                              CGL014
     C**********         IF        WAmount < MINB                                     CGL014 BUG3281
     C                   IF        WAmount < COLA                                            BUG3281
     C                   EVAL      OKCTAMT = 'W'                                              CGL014
     C                   ADD       1             WIx                                          CGL014
     C                   EVAL      WFldNmXAr(WIx) = DDSName                                   CGL014
     C                   EVAL      WMsgIdXAr(WIx) = 'FTA0141'                                 CGL014
     C                   ENDIF                                                                CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   ENDSR                                                                CGL014
                                                                                              CGL014
      *****************************************************************                       CGL014
      /EJECT                                                                                  CGL014
      *****************************************************************
      *                                                               *
      * ValCcy - Validate Currency is same as account identifier      *
      *                                                               *
      * Called by: Validate                                           *
      *                                                               *
      * Calls: ValAcct                                                *
      *                                                               *
      *****************************************************************
      *
     C     ValCCy        BEGSR
      *
      ** Test to see which type of account identifier has been entered
      *
     C                   EXSR      ValAcct
     C                   MOVE      *Blanks       Ccy               3
      *
      ** Determine the currncy depending on the account identifier
      *
     C                   SELECT
      *
     C                   WHEN      PType = '*LEDGER'
      *   Len                            Start
     C     3             SUBST     Dssdy:8       CCY
      *
     C                   WHEN      PType = '*NOSTRO'
     C     3             SUBST     DssDy:1       CCy
      *
     C                   WHEN      PType = '*RETAIL'
     C     3             SUBST     DssDy:8       CCy
      *
     C                   WHEN      PType = 'IBAN'
     C     3             SUBST     DssDy:8       CCy
      *
     C                   ENDSL
      *
      ** Check to see if ccy is the same as the entered account's
      *
     C                   IF        CCy <> PcctCcy
     C                   EVAL      OkCtCcy = 'N'
     C                   EVAL      Idx = Idx + 1
     C****************** EVAL      FldNamXAr(Idx) = DDSName                     CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PCCTCCY'                   CAP084
     C                   EVAL      RetCodeIn = 'Error'
     C                   IF        PCcttyp = 'BO'
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0328'
     C                   ELSE
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0329'
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValAcct  - Checks for valid account                           *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: AOIBANR2, AOACCTV1                                     *
      *                                                               *
      *****************************************************************
      *
     C     ValAcct       BEGSR
      *
     C                   EVAL      PType = *Blanks
     C                   EVAL      WValid = 'Y'
      *
     C                   IF        CFT004 = 'Y'
      *
      ** Validate Account
      *
     C                   CALLB     'AOIBANR2'
     C                   PARM      *Blanks       PRtcd
     C                   PARM                    PAcct            35
     C     Accnt         PARM      Accnt         DSSDY
      *
     C                   IF        PRtcd = *Blanks
     C                   EVAL      PType = 'IBAN'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        PType <> 'IBAN'
      *
      ** Validate Account
      *
     C                   CALLB     'AOACCTV1'
     C                   PARM      *Blanks       PRtcd             7            B:Return code
     C                   PARM                    PType             7            I:A/c ID
     C                   PARM                    PAcct            35            I:A/c Currency
     C**********         PARM      *Blanks       DSSDY                          I:A/c code    CGL014
     C     ACCNT         PARM      ACCNT         DSSDY                                        CGL014
     C                   ENDIF
      *
      ** Invalid Account
      *
     C                   IF        PType <> 'IBAN' AND
     C                             PType <> '*NOSTRO'  AND
     C                             PType <> '*RETAIL'  AND
     C                             PType <> '*LEDGER' OR
     C                             PRtcd <> *Blanks
     C                   EVAL      Wvalid = 'N'
     C                   ENDIF
      *
     C                   ENDSR
      *
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
      *
     C     *INZSR        BEGSR
      *
     C     *Entry        PLIST
      *
      ** INPUTS
      *
     C                   PARM                    RetCodeIn
     C                   PARM                    RespMode          1
     C                   PARM                    ActionCode        1
 
      ** Screen fields
     C                   PARM                    HdrRcdIn
     C                   PARM                    DtlRcdIn
     C                   PARM                    OKFlags
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDSName          10
      *
      ** Access SAR file to see if CFT004 is present
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *Blanks       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CFT004'      @SARD             6
     C                   PARM                    DSFDY
      *
     C                   IF        @RTCD = *Blank
     C                   EVAL      CFT004 = 'Y'
     C                   ELSE
      *
     C                   IF        @RTCD = '*NRF'
     C                   EVAL      CFT004 = 'N'
     C                   ELSE
      *
      ** Database Error
      *
     C                   EVAL      DBKey  =  CFT004
     C                   EVAL      DBFile = 'AOSARDR0'
     C                   EVAL      DBPgm  = PSProcPgm
     C                   EVAL      Dbase  = 1
     C                   EVAL      DBMod  = PSProcMod
     C                   EVAL      DBProc = '*Inzsr'
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                              CGL014
      ** Check if enhancement CGL014 (Collaterals Processing) is on                           CGL014
                                                                                              CGL014
     C                   CALLB     'AOSARDR0'                                                 CGL014
     C                   PARM      *BLANKS       PRTCD                                        CGL014
     C                   PARM      '*VERIFY'     POPTN                                        CGL014
     C                   PARM      'CGL014'      PSARD                                        CGL014
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL014
                                                                                              CGL014
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CGL014
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL014
     C                   EVAL      DBKEY  = 'CGL014'                                          CGL014
     C                   EVAL      DBASE  = 2                                                 CGL014
     C                   EXSR      *PSSR                                                      CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   IF        PRTCD = *BLANKS                                            CGL014
     C                   EVAL      CGL014 = 'Y'                                               CGL014
     C                   ELSE                                                                 CGL014
     C                   EVAL      CGL014 = 'N'                                               CGL014
     C                   ENDIF                                                                CGL014
      *
     C                   ENDIF
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
