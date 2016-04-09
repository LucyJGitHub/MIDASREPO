     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MR Loans and Deposits Extracts')                 *
      *****************************************************************
      *                                                               *
      *  Midas - MidasPlus Reporting module                           *
      *                                                               *
      *  RPGLE/MRLDNIEXT - Loans and Deposits Extracts                *
      *                                                               *
      *  Function:  This module will read DEALSDC as an input primary *
      *             file.  For each required record from DEALSDC, a   *
      *             record will be written to file MRTRAPPD.          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CGL165             Date 15Feb17               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 AR750273A          Date 20May11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23797A          Date 16Jun09               *
      *                 BUG23797           Date 23Apr09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CRN001             Date 20Jul05               *
      *                 CDL038             Date 10May05               *
      *                 CMR001  *CREATE    Date 16Aug04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  AR750273A - SDC000776 00001 failed (Child: AR750274)         *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23797A - Do not fail the component when the customer is   *
      *             deleted or closed                                 *
      *  BUG23797 - Replace AOCUSTR0 with AOCUSTR1                    *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CRN001 - MidasPlus Regulatory Reporting Interface            *
      *           Enhancement                                         *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CMR001 - MidasPlus Reporting                                 *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Loans and Deposits
     FDEALSDC   IF   E             DISK    INFSR(*PSSR)
 
      ** Deals Extension File
     FDLDEALL5  IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(DLDLDBD0)
     F                                     IGNORE(DLDLDGD0)
 
      ** Reporting Parameters
     FMRRPRMPD  IF   E             DISK    INFSR(*PSSR)
                                                                                              CRN001
      **                                                                                      CRN001
     FMMNPVAL0  IF   E           K DISK    INFSR(*PSSR)                                       CRN001
 
      ** Transactions, Accounts and Positions Report File
     FMRTRAPPD  O    E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D                 DS
     D DayMonthYear            1      6  0
     D Day                     1      2  0
     D Month                   3      4  0
     D Year                    5      6  0
 
      ** Bank Details Data Structure
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Currency Details Data Structure
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Customer Details Data Structure
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Branch Details Data Structure
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D  QQDFAC1      E                     EXTFLD(QQDFAC)
 
      ** General Ledger Details Data Structure
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Access Object Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Long Access Object Data Structure                                                  BUG23797
     D DSLDY         E DS                  EXTNAME(DSLDY)                                   BUG23797
                                                                                            BUG23797
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CRN001
      ** External DS for SAR details                                                          CRN001
                                                                                              CRN001
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WkRun           S              1
 
     D WkTAmt          S             15  0
     D WkAmtInB        S             15  0
     D WkAmtIn1        S             15  0
     D WkAmtIn2        S             15  0
     D WkCYCDB         S              3
     D WkNBDPB         S              1  0
     D WkSPRTB         S             13P 8
     D WkMDINB         S              1
     D WkCYCD1         S              3
     D WkNBDP1         S              1  0
     D WkSPRT1         S             13P 8
     D WkMDIN1         S              1
     D WkCYCD2         S              3
     D WkNBDP2         S              1  0
     D WkSPRT2         S             13P 8
     D WkMDIN2         S              1
     D PAcKyPos01      S              2
     D PAcKyPos03      S              1
     D PAcKyPos04      S              2
     D PAcKyPos06      S              1
     D PAcKyPos07      S              1
     D PAcKyPos08      S              1
     D PAcKyPos09      S              1
     D PAcKyPos10      S              1
     D PAcKyPos11      S              4                                                       CDL038
     D PAcCodDR1       S             10
     D PAcSecDR1       S              2
     D PPosRfDR1       S              1
     D PAcCodDR2       S             10
     D PAcSecDR2       S              2
     D PPosRfDR2       S              1
     D PAcCodDR3       S             10
     D PAcSecDR3       S              2
     D PPosRfDR3       S              1
     D PAcCodCR1       S             10
     D PAcSecCR1       S              2
     D PPosRfCR1       S              1
     D PAcCodCR2       S             10
     D PAcSecCR2       S              2
     D PPosRfCR2       S              1
     D PAcCodCR3       S             10
     D PAcSecCR3       S              2
     D PPosRfCR3       S              1
     D PRetCode        S              7
     D POption         S              7
     D PCust           S             10
     D PStKey          S              7
     D PCcy            S              3
     D WkECDat         S              5  0
     D I#ERMS          S             30
 
      ** Parameters for MRDATBID - Date Bucket Identification Module
     D PaDtSch         S              1  0
     D PaRepDt         S              5  0
     D PaSchDt         S              5  0
     D PaBuckCode      S              8
 
      ** Parameters for ZXRATE module
     D ZRATE1          S             13P 8
     D ZMDI1           S              1
     D ZRATE2          S             13P 8
     D ZMDI2           S              1
     D ZRATEX          S             13P 8
     D ZMDIX           S              1
 
      ** Parameters for ZCONVZ1 module
     D ZAMTCI          S             15  0
     D ZEXCH           S             13P 8
     D ZMD             S              1
     D ZCCYI           S              3
     D ZCCYO           S              3
     D ZCDPI           S              1  0
     D ZCDPO           S              1  0
     D ZAMTCO          S             15  0
 
      ** Parameters for GLINTC module
     D ZIBEG           S              5  0
     D ZIEND           S              5  0
     D ZICALC          S              1  0
     D ZIAMT           S             15  0
     D ZIRATE          S             11  7
     D ZINTR           S             30  9
 
      **                                                                                      CRN001
     D CAS001          S              1                                                       CRN001
                                                                                              CRN001
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     C     1             SETLL     DEALSDC
 
     C                   READ      DEALSDC
 
     C                   DOW       NOT %EOF(DEALSDC)
 
      ** Process live and matured records only
     C                   IF        RECI = 'D' OR RECI = 'M'
     C                   EXSR      SRProcess
     C                   ENDIF
 
     C                   READ      DEALSDC
 
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcess - Subroutine that Processes Records to be Written  *
      *              to the Extract File                              *
      *                                                               *
      *****************************************************************
     C     SRProcess     BEGSR
     C                   CLEAR                   MRTRAPD0
 
      ** Set Extract Date
     C                   EVAL      EXTDAT = BJRDNB
 
      ** Set Event Control Date
     C                   EVAL      EXVCD = WkECDat
 
      ** Set Calendar/Financial
     C                   EVAL      EXCAFI = 'C'
 
      ** Set Period Type
     C                   EVAL      EXPERT = 'M'
 
      ** Set Calendar Year/Month
     C                   EVAL      EXCY = CalendarYear
     C                   EVAL      EXCM = CalendarMonth
 
      ** Set Module
     C                   EVAL      EXMOD = 'DL'
 
      ** Set Sub-Module
     C                   EVAL      EXSUB = 'LDNI'
 
      ** Set Transaction Id
     C                   MOVEL     DLNO          EXTRID
 
      ** Set Sequence Number
     C                   EVAL      EXSEQ = 0
 
      ** Set Transaction Status
     C                   IF        RECI = 'M'
     C                   EVAL      EXSTAT = 'M'
     C                   ELSE
 
     C                   IF        VDAT > WkECDat
     C                   EVAL      EXSTAT = 'N'
     C                   ELSE
     C                   EVAL      EXSTAT = *BLANKS
     C                   ENDIF
 
     C                   ENDIF
 
      ** Set On/Off Balance Sheet
     C                   EVAL      EXBALS = '1'
 
      ** Set Branch Details
     C                   EVAL      I#LFD1 = BRCA
     C                   EXSR      SRSetBrcDet
     C                   EVAL      SDBRCH = InData
     C                   EVAL      EXBRCH = A8BRCD
     C                   EVAL      EXBICN = A8BICN
 
      ** Set Customer Details
     C                   MOVEL     CNUM          PCust
     C                   EXSR      SRSetCusDet
     C                   MOVEL     CNUM          EXCUSN
     C                   EVAL      EXCCIT = BBCNCZ
     C                   EVAL      EXCLOC = BBCOLC
     C                   EVAL      EXCIND = BBLICD
     C                   EVAL      EXCINT = BBLINC
     C                   EVAL      EXCBNK = BBBNBI
     C                   EVAL      EXCSWF = BBSWFI
 
      ** Set Parent Details
     C     BBPCNB        IFNE      *BLANK
     C                   MOVEL     BBPCNB        PCust
     C                   EXSR      SRSetCusDet
     C                   MOVEL     BBCUST        EXPARN
     C                   EVAL      EXPCIT = BBCNCZ
     C                   EVAL      EXPLOC = BBCOLC
     C                   EVAL      EXPIND = BBLICD
     C                   EVAL      EXPINT = BBLINC
     C                   EVAL      EXPBNK = BBBNBI
     C                   EVAL      EXPSWF = BBSWFI
     C                   ENDIF
 
      ** Set Currency Details (EXCYCD, EXEBRT, EXMDIB, EXERP1, EXMDI1, EXERP2,
      **                       EXMDI2)
     C                   EVAL      I#LFD1 = CCY
     C                   EXSR      SRSetCurDet
 
      ** Set FX Contract and Valuation Rates
     C                   EVAL      EXCNRT = 0
     C                   EVAL      EXVLRT = 0
 
      ** Set Principal Asset/Liability indicator, sign and DR/CR ind
     C                   IF        DTYP = 'IP' OR DTYP = 'TI' OR DTYP = 'CL' OR
     C                             DTYP = 'LN' OR DTYP = 'DL' OR DTYP = 'FL' OR
     C                             DTYP = 'LP' OR DTYP = 'DP'
     C                   EVAL      EXPALI = 'A'
     C                   Z-ADD     1             EXPSGN
     C                   Z-ADD     0             EXPDCI
     C                   ELSE
     C                   EVAL      EXPALI = 'L'
     C                   Z-SUB     1             EXPSGN
     C                   Z-ADD     1             EXPDCI
     C                   ENDIF
 
      ** Set Principal Account Key Details (EXPACC, EXPACS, EXPREF)
     C                   EXSR      SRSetPrAcKy
 
      ** Set Principal Amounts
     C                   Z-ADD     PCPL          WkTAmt
     C                   EXSR      SRCvtAmounts
     C                   EVAL(H)   EXPAMT = WkTAmt/(10**A6NBDP)
     C                   EVAL(H)   EXPMTB = WkAmtInB/(10**WkNBDPB)
     C                   EVAL(H)   EXPMT1 = WkAmtIn1/(10**WkNBDP1)
     C                   EVAL(H)   EXPMT2 = WkAmtIn2/(10**WkNBDP2)
 
      ** Set Accrued Interest Account Key Details (EXAACC, EXAACS, EXAREF)
      ** and Interest Inc./Exp. Account Key Details (EXIACC, EXIACS, EXIREF)
     C                   EXSR      SRSetAIAcKy
 
      ** Set Accrued Interest Sign and DR/CR ind
     C                   IF        EXPALI = 'A'
     C                   EVAL      EXASGN = 1
     C                   EVAL      EXADCI = 0
     C                   ELSE
     C                   EVAL      EXASGN = -1
     C                   EVAL      EXADCI = 1
     C                   ENDIF
 
      ** Set Accrued Interest Amounts
     C                   EVAL      WkTAmt = AIPD - IPRD - ICTD
     C                   EXSR      SRCvtAmounts
     C                   EVAL(H)   EXAAMT = WkTAmt/(10**A6NBDP)
     C                   EVAL(H)   EXAMTB = WkAmtInB/(10**WkNBDPB)
     C                   EVAL(H)   EXAMT1 = WkAmtIn1/(10**WkNBDP1)
     C                   EVAL(H)   EXAMT2 = WkAmtIn2/(10**WkNBDP2)
 
      ** Initialise Unearned Discount Premium Details
     C                   EVAL      EXESGN = *ZEROS
     C                   EVAL      EXEDCI = *ZEROS
     C                   EVAL      EXEACC = *BLANKS
     C                   EVAL      EXEACS = *BLANKS
     C                   EVAL      EXEREF = *BLANKS
     C                   EVAL      EXEAMT = *ZEROS
     C                   EVAL      EXEMTB = *ZEROS
     C                   EVAL      EXEMT1 = *ZEROS
     C                   EVAL      EXEMT2 = *ZEROS
 
      ** Initialise Unrealised Profit/Loss Details
     C                   EVAL      EXUSGN = *ZEROS
     C                   EVAL      EXUDCI = *ZEROS
     C                   EVAL      EXUACC = *BLANKS
     C                   EVAL      EXUACS = *BLANKS
     C                   EVAL      EXUREF = *BLANKS
     C                   EVAL      EXUAMT = *ZEROS
     C                   EVAL      EXUMTB = *ZEROS
     C                   EVAL      EXUMT1 = *ZEROS
     C                   EVAL      EXUMT2 = *ZEROS
     C                                                                                        CRN001
      ** Check switchable feature CAS001                                                      CRN001
     C                   IF        CAS001   = 'Y'                                             CRN001
                                                                                              CRN001
     C                   EXSR      SRSetURAcKy                                                CRN001
                                                                                              CRN001
      ** Get amounts from MMNPVAL0, use DLNO from DEALSDC                                     CRN001
     C     DLNO          CHAIN     MMNPVAL0                                                   CRN001
                                                                                              CRN001
      ** Set Unrealized P/L Amount                                                            CRN001
     C                   IF          %FOUND                                                   CRN001
     C                   EVAL      WkTAmt = MNURPL                                            CRN001
     C                   EXSR      SRCvtAmounts                                               CRN001
     C                   EVAL(H)   EXUAMT = WkTAmt/(10**A6NBDP)                               CRN001
     C                   EVAL(H)   EXUMTB = WkAmtInB/(10**WkNBDPB)                            CRN001
     C                   EVAL(H)   EXUMT1 = WkAmtIn1/(10**WkNBDP1)                            CRN001
     C                   EVAL(H)   EXUMT2 = WkAmtIn2/(10**WkNBDP2)                            CRN001
     C                   ENDIF                                                                CRN001
                                                                                              CRN001
     C                   ENDIF                                                                CRN001
 
      ** Initialise the rest of the Interest Income/Expense Details
     C                   EVAL      EXIAMT = *ZEROS
     C                   EVAL      EXIMTB = *ZEROS
     C                   EVAL      EXIMT1 = *ZEROS
     C                   EVAL      EXIMT2 = *ZEROS
 
      ** Initialise Discount Premium Income/Expense Details
     C                   EVAL      EXDACC = *BLANKS
     C                   EVAL      EXDACS = *BLANKS
     C                   EVAL      EXDREF = *BLANKS
     C                   EVAL      EXDAMT = *ZEROS
     C                   EVAL      EXDMTB = *ZEROS
     C                   EVAL      EXDMT1 = *ZEROS
     C                   EVAL      EXDMT2 = *ZEROS
 
      ** Initialise Realised Profit/Loss Details
     C                   EVAL      EXRACC = *BLANKS
     C                   EVAL      EXRACS = *BLANKS
     C                   EVAL      EXRREF = *BLANKS
     C                   EVAL      EXRAMT = *ZEROS
     C                   EVAL      EXRMTB = *ZEROS
     C                   EVAL      EXRMT1 = *ZEROS
     C                   EVAL      EXRMT2 = *ZEROS
 
      ** Set Account Sequence, Transaction Type, Sub-Type, Profit Centre,
      ** Deal Date and Value Date
     C                   MOVEL     CDAS          EXACSQ
     C                   MOVEL     '01'          EXACS1
     C                   EVAL      EXTRTY = DTYP
     C                   EVAL      EXTRST = DLST
     C                   EVAL      EXCLAS = CLAS                                              CDL038
     C                   EVAL      EXPRFC = PRFC
     C                   EVAL      EXDDAT = DDAT
     C                   EVAL      EXVDAT = VDAT
 
      ** Set Maturity Date and Date Schedules (EXMDAT, EXMDT0 to EXMDT9)
     C                   EXSR      SRSetMatSch
 
      ** Set Fixed/Variable Rate indicator, Base Rate, Rate/Spread, Interest
      ** Rate, Yield Rate
     C                   TESTB     '2'           DNSI                     33
     C                   IF        *IN33 = *ON
     C                   EVAL      EXRATE = 'V'
     C                   ELSE
     C                   EVAL      EXRATE = 'F'
     C                   ENDIF
 
     C                   EVAL      EXBRTE = BRTE
     C                   EVAL      EXRTSP = RTSP
     C                   EVAL      EXINTR = INTR
     C                   EVAL      EXYLDR = *ZEROS
 
      ** Set Next Interest Pay Date and Date Schedules (EXNIDT, EXNID0 to EXNID9)
     C                   EXSR      SRSetNInSch
 
      ** Set Next Interest Pay Date and Date Schedules
     C                   EVAL      EXNIMT = *ZEROS
     C                   EVAL      EXNIMB = *ZEROS
     C                   EVAL      EXNIM1 = *ZEROS
     C                   EVAL      EXNIM2 = *ZEROS
     C                   IF        EXNIDT <> 0
     C                   TESTB     '2'           DNSI                     31
     C                   MOVE      *ON           *IN31
     C                   EXSR      SRSetNIPAmt
     C                   EXSR      SRCvtAmounts
     C                   EVAL(H)   EXNIMT = WkTAmt/(10**A6NBDP)
     C                   EVAL(H)   EXNIMB = WkAmtInB/(10**WkNBDPB)
     C                   EVAL(H)   EXNIM1 = WkAmtIn1/(10**WkNBDP1)
     C                   EVAL(H)   EXNIM2 = WkAmtIn2/(10**WkNBDP2)
     C                   ENDIF
 
      ** Initialise Next Principal Pay Details
     C                   EVAL      EXNPMT = *ZEROS
     C                   EVAL      EXNPMB = *ZEROS
     C                   EVAL      EXNPM1 = *ZEROS
     C                   EVAL      EXNPM2 = *ZEROS
     C                   EVAL      EXNPDT = *ZEROS
     C                   EVAL      EXNPD0 = *BLANKS
     C                   EVAL      EXNPD1 = *BLANKS
     C                   EVAL      EXNPD2 = *BLANKS
     C                   EVAL      EXNPD3 = *BLANKS
     C                   EVAL      EXNPD4 = *BLANKS
     C                   EVAL      EXNPD5 = *BLANKS
     C                   EVAL      EXNPD6 = *BLANKS
     C                   EVAL      EXNPD7 = *BLANKS
     C                   EVAL      EXNPD8 = *BLANKS
     C                   EVAL      EXNPD9 = *BLANKS
 
      ** Initialise Recourse Indicator
     C                   EVAL      EXRCSI = *BLANKS
                                                                                              CRN001
     C                   EVAL      EXBOOK = BOKC                                              CRN001
 
      ** Set Facility Details (EXFCUS, EXFTYP, EXFCNO)
     C                   EXSR      SRSetFacDet
 
      ** Write record to output file
     C                   WRITE     MRTRAPD0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetFacDet - Subroutine that Sets Facility Details          *
      *                                                               *
      *****************************************************************
     C     SRSetFacDet   BEGSR
 
     C                   MOVE      DLNO          F1DLNO
     C     F1DLNO        CHAIN     DLDEALL5                           32
 
     C                   IF        *IN32 = *OFF
     C                   MOVE      F1FCCU        EXFCUS
     C                   MOVE      F1FACT        EXFTYP
     C                   MOVE      F1FCNO        EXFCNO
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetNInSch - Subroutine that Sets Next Interest Pay Date -  *
      *                Date Schedules                                 *
      *                                                               *
      *****************************************************************
     C     SRSetNInSch   BEGSR
 
      ** Determine the Next Interest Pay Date to be written to MRTRANPD
     C                   IF        NIDT <> 0
     C                   EVAL      EXNIDT = NIDT
     C                   ELSE
     C                   EVAL      EXNIDT = MDAT
     C                   ENDIF
 
     C                   EVAL      EXNID0 = *BLANKS
     C                   EVAL      EXNID1 = *BLANKS
     C                   EVAL      EXNID2 = *BLANKS
     C                   EVAL      EXNID3 = *BLANKS
     C                   EVAL      EXNID4 = *BLANKS
     C                   EVAL      EXNID5 = *BLANKS
     C                   EVAL      EXNID6 = *BLANKS
     C                   EVAL      EXNID7 = *BLANKS
     C                   EVAL      EXNID8 = *BLANKS
     C                   EVAL      EXNID9 = *BLANKS
 
      ** If the Next Interest Pay Date to be written to MRTRANPD is not zero,
      ** determine the bucket codes for the 5 date schedules
     C                   IF        EXNIDT <> 0
     C                   EVAL      PaRepDt = WkECDat
     C                   EVAL      PaSchDt = EXNIDT
 
      ** Set Next Interest Pay Date - Date schedule 0
     C                   EVAL      PaDtSch = 0
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXNID0 = PaBuckCode
 
      ** Set Next Interest Pay Date - Date schedule 1
     C                   EVAL      PaDtSch = 1
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXNID1 = PaBuckCode
 
      ** Set Next Interest Pay Date - Date schedule 2
     C                   EVAL      PaDtSch = 2
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXNID2 = PaBuckCode
 
      ** Set Next Interest Pay Date - Date schedule 3
     C                   EVAL      PaDtSch = 3
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXNID3 = PaBuckCode
 
      ** Set Next Interest Pay Date - Date schedule 4
     C                   EVAL      PaDtSch = 4
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXNID4 = PaBuckCode
 
      ** Set Next Interest Pay Date - Date schedule 5
     C                   EVAL      PaDtSch = 5
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXNID5 = PaBuckCode
 
      ** Set Next Interest Pay Date - Date schedule 6
     C                   EVAL      PaDtSch = 6
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXNID6 = PaBuckCode
 
      ** Set Next Interest Pay Date - Date schedule 7
     C                   EVAL      PaDtSch = 7
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXNID7 = PaBuckCode
 
      ** Set Next Interest Pay Date - Date schedule 8
     C                   EVAL      PaDtSch = 8
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXNID8 = PaBuckCode
 
      ** Set Next Interest Pay Date - Date schedule 9
     C                   EVAL      PaDtSch = 9
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXNID9 = PaBuckCode
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetNIPAmt - Subroutine that Sets Next Interest Pay Amounts *
      *                                                               *
      *****************************************************************
     C     SRSetNIPAmt   BEGSR
 
      ** Compute for the Next Interest Pay Amount to be written to MRTRANPD
     C                   IF        EXNIDT = MDAT AND *IN31 = *OFF
     C                   EVAL      WkTAmt = TOTI - IPRD - ICTD
     C                   ELSE
 
     C                   Z-ADD     IACD          ZIBEG
     C                   Z-ADD     EXNIDT        ZIEND
     C                   Z-ADD     ICBS          ZICALC
     C                   Z-ADD     PCPL          ZIAMT
     C                   Z-ADD     INTR          ZIRATE
     C                   CALLB     'GLINTC'
     C                   PARM                    ZIBEG
     C                   PARM                    ZIEND
     C                   PARM                    ZICALC
     C                   PARM                    ZIAMT
     C                   PARM                    ZIRATE
      ** Output
     C                   PARM      *ZEROS        ZINTR
 
     C                   Z-ADD(H)  ZINTR         WkIntrst         15 0
 
     C                   EVAL      WkTAmt = WkIntrst + AITC + AIAP - IPRD - ICTD
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetMatSch - Subroutine that Sets Maturity Date - Date      *
      *                Schedules                                      *
      *                                                               *
      *****************************************************************
     C     SRSetMatSch   BEGSR
 
     C                   EVAL      EXMDAT = MDAT
     C                   EVAL      EXMDT0 = *BLANKS
     C                   EVAL      EXMDT1 = *BLANKS
     C                   EVAL      EXMDT2 = *BLANKS
     C                   EVAL      EXMDT3 = *BLANKS
     C                   EVAL      EXMDT4 = *BLANKS
     C                   EVAL      EXMDT5 = *BLANKS
     C                   EVAL      EXMDT6 = *BLANKS
     C                   EVAL      EXMDT7 = *BLANKS
     C                   EVAL      EXMDT8 = *BLANKS
     C                   EVAL      EXMDT9 = *BLANKS
 
     C                   EVAL      PaRepDt = WkECDat
     C                   EVAL      PaSchDt = MDAT
 
      ** Set Maturity Date - Date schedule 0
     C                   EVAL      PaDtSch = 0
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXMDT0 = PaBuckCode
 
      ** Set Maturity Date - Date schedule 1
     C                   EVAL      PaDtSch = 1
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXMDT1 = PaBuckCode
 
      ** Set Maturity Date - Date schedule 2
     C                   EVAL      PaDtSch = 2
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXMDT2 = PaBuckCode
 
      ** Set Maturity Date - Date schedule 3
     C                   EVAL      PaDtSch = 3
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXMDT3 = PaBuckCode
 
      ** Set Maturity Date - Date schedule 4
     C                   EVAL      PaDtSch = 4
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXMDT4 = PaBuckCode
 
      ** Set Maturity Date - Date schedule 5
     C                   EVAL      PaDtSch = 5
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXMDT5 = PaBuckCode
 
      ** Set Maturity Date - Date schedule 6
     C                   EVAL      PaDtSch = 6
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXMDT6 = PaBuckCode
 
      ** Set Maturity Date - Date schedule 7
     C                   EVAL      PaDtSch = 7
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXMDT7 = PaBuckCode
 
      ** Set Maturity Date - Date schedule 8
     C                   EVAL      PaDtSch = 8
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXMDT8 = PaBuckCode
 
      ** Set Maturity Date - Date schedule 9
     C                   EVAL      PaDtSch = 9
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXMDT9 = PaBuckCode
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetBuckCd - Subroutine that Gets Bucket Code               *
      *                                                               *
      *****************************************************************
     C     SRGetBuckCd   BEGSR
 
     C                   CALLB     'MRDATBID'
     C                   PARM                    PaDtSch
     C                   PARM                    PaRepDt
     C                   PARM                    PaSchDt
      ** Output
     C                   PARM                    PaBuckCode
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCvtAmounts - Subroutine that Converts the Amount in Tran-  *
      *                 saction Ccy to be in Base Ccy, Reporting Ccy  *
      *                 1 and Reporting Ccy 2                         *
      *                                                               *
      *****************************************************************
     C     SRCvtAmounts  BEGSR
 
      ** Get Amount in Base Currency
     C                   Z-ADD     WkTAmt        ZAMTCI
     C                   EVAL      ZEXCH = A6SPRT
     C                   EVAL      ZMD = A6MDIN
     C                   EVAL      ZCCYI = CCY
     C                   EVAL      ZCCYO = WkCYCDB
     C                   EVAL      ZCDPI = A6NBDP
     C                   EVAL      ZCDPO = WkNBDPB
     C                   EXSR      SRGetAmount
     C                   Z-ADD     ZAMTCO        WkAmtInB
 
      ** Get Amount in Reporting Currency 1
     C                   EVAL      ZEXCH = EXERP1
     C                   EVAL      ZMD = EXMDI1
     C                   EVAL      ZCCYO = WkCYCD1
     C                   EVAL      ZCDPO = WkNBDP1
     C                   EXSR      SRGetAmount
     C                   Z-ADD     ZAMTCO        WkAmtIn1
 
      ** Get Amount in Reporting Currency 2
     C                   EVAL      ZEXCH = EXERP2
     C                   EVAL      ZMD = EXMDI2
     C                   EVAL      ZCCYO = WkCYCD2
     C                   EVAL      ZCDPO = WkNBDP2
     C                   EXSR      SRGetAmount
     C                   Z-ADD     ZAMTCO        WkAmtIn2
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetAmount - Subroutine that Gets Converted Amount via      *
      *                ZCONVZ1                                        *
      *                                                               *
      *****************************************************************
     C     SRGetAmount   BEGSR
 
     C                   CALLB     'ZCONVZ1'
     C                   PARM                    ZAMTCI
     C                   PARM                    ZEXCH
     C                   PARM                    ZMD
     C                   PARM                    ZCCYI
     C                   PARM                    ZCCYO
     C                   PARM                    ZCDPI
     C                   PARM                    ZCDPO
      ** Output
     C                   PARM      *ZEROS        ZAMTCO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetCurDet - Subroutine that Sets Currency Details          *
      *                                                               *
      *****************************************************************
     C     SRSetCurDet   BEGSR
 
     C                   CALLB     'MXACSCURR'
      /COPY MXCPYSRC,MXACSPRME
 
     C                   IF        ACS_RTCD = '*ERROR '
     C                   EVAL      I#ERMS = 'Invalid Currency: ' + I#LFD1
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      SDCURR = InData
 
     C                   EVAL      EXCYCD = A6CYCD
     C                   EVAL      EXEBRT = A6SPRT
     C                   EVAL      EXMDIB = A6MDIN
 
      ** Retrieve Cross Rate between Transaction Currency and Reporting Ccy 1
     C                   EVAL      ZRATE1 = A6SPRT
     C                   EVAL      ZMDI1 = A6MDIN
     C                   EVAL      ZRATE2 = WkSPRT1
     C                   EVAL      ZMDI2 = WkMDIN1
     C                   EXSR      SRGetXRate
     C                   EVAL      EXERP1 = ZRATEX
     C                   EVAL      EXMDI1 = ZMDIX
 
      ** Retrieve Cross Rate between Transaction Currency and Reporting Ccy 2
     C                   EVAL      ZRATE2  = WkSPRT2
     C                   EVAL      ZMDI2 = WkMDIN2
     C                   EXSR      SRGetXRate
     C                   EVAL      EXERP2 = ZRATEX
     C                   EVAL      EXMDI2 = ZMDIX
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetXRate - Subroutine that Retrieves Cross Currency Rate   *
      *                                                               *
      *****************************************************************
     C     SRGetXRate    BEGSR
 
     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1
     C                   PARM                    ZMDI1
     C                   PARM                    ZRATE2
     C                   PARM                    ZMDI2
      ** Outputs
     C                   PARM      *ZEROS        ZRATEX
     C                   PARM      *BLANKS       ZMDIX
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetCusDet - Subroutine that Sets Customer Details          *
      *                                                               *
      *****************************************************************
     C     SRSetCusDet   BEGSR
 
     C**********         CALL      'AOCUSTR0'                                               BUG23797
     C**********         CALL      'AOCUSTR1'                                     BUG23797 AR750273A
     C                   CALL      'AOCUSTR0'                                              AR750273A
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PCust
     C                   PARM      *BLANKS       PStKey
     C*****SDCUST        PARM      *BLANKS       DSSDY                                      BUG23797
     C*****SDCUST        PARM      *BLANKS       DSLDY                            BUG23797 AR750273A
     C     SDCUST        PARM      *BLANKS       DSSDY                                     AR750273A
 
     C                   IF        PRetCode <> *BLANKS
     C                             AND PRetCode <> '*CUSDEL'                               AR750273A
     C                             AND PRetCode <> '*CUSCLS'                               AR750273A
     C**********                   AND BBCLST <> 'Y'                              BUG23797 BUG23797A
     C**********                   AND PRetCode <> '*CUSCLO'                     BUG23797A AR750273A
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBKEY = PCust
     C                   EVAL      DBASE = 5
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetBrcDet - Subroutine that Sets Branch Details            *
      *                                                               *
      *****************************************************************
     C     SRSetBrcDet   BEGSR
 
     C                   CALLB     'MXACSBRCH'
      /COPY MXCPYSRC,MXACSPRME
 
     C                   IF        ACS_RTCD = '*ERROR '
     C                   EVAL      I#ERMS = 'Invalid Branch: ' + I#LFD1
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetCurrD - Subroutine that Retrieves Currency Details      *
      *                                                               *
      *****************************************************************
     C     SRGetCurrD    BEGSR
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PCcy
     C     SDCURR        PARM      *BLANKS       DSSDY
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY = PCcy
     C                   EVAL      DBASE = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetRepPrm - Subroutine that Accesses Report Parameters     *
      *                                                               *
      *****************************************************************
     C     SRGetRepPrm   BEGSR
 
     C     1             SETLL     MRRPRMPD
     C                   READ      MRRPRMPD
 
     C                   IF        %EOF(MRRPRMPD)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'MRRPRMPD'
     C                   EVAL      DBKEY = '*READ '
     C                   EVAL      DBASE = 4
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetAIAcKy - Subroutine that Sets Accrued Interest Account  *
      *                Key Details                                    *
      *                                                               *
      *****************************************************************
     C     SRSetAIAcKy   BEGSR
 
     C                   EVAL      PAcKyPos01 = DTYP
     C                   EVAL      PAcKyPos03 = 'A'
     C                   EVAL      PAcKyPos04 = DLST
     C                   EVAL      PAcKyPos11 = CLAS                                          CDL038
     C                   EVAL      PAcKyPos06 = *BLANKS
     C                   EVAL      PAcKyPos07 = *BLANKS
     C                   EVAL      PAcKyPos08 = *BLANKS
     C                   EVAL      PAcKyPos09 = *BLANKS
     C                   EVAL      PAcKyPos10 = 'A'
 
     C                   EXSR      SRGetAcKeyD
 
     C                   IF        EXPALI = 'A'
     C                   EVAL      EXAACC = PAcCodDR1
     C                   EVAL      EXAACS = PAcSecDR1
     C                   EVAL      EXAREF = PPosRfDR1
     C                   EVAL      EXIACC = PAcCodCR1
     C                   EVAL      EXIACS = PAcSecCR1
     C                   EVAL      EXIREF = PPosRfCR1
     C                   ELSE
     C                   EVAL      EXAACC = PAcCodCR1
     C                   EVAL      EXAACS = PAcSecCR1
     C                   EVAL      EXAREF = PPosRfCR1
     C                   EVAL      EXIACC = PAcCodDR1
     C                   EVAL      EXIACS = PAcSecDR1
     C                   EVAL      EXIREF = PPosRfDR1
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetPrAcKy - Subroutine that Sets Principal Account Key     *
      *                Details                                        *
      *                                                               *
      *****************************************************************
     C     SRSetPrAcKy   BEGSR
 
     C                   EVAL      PAcKyPos01 = DTYP
     C                   IF        EXSTAT = 'N'
     C                   EVAL      PAcKyPos03 = 'D'
     C                   ELSE
     C                   EVAL      PAcKyPos03 = 'V'
     C                   ENDIF
     C                   EVAL      PAcKyPos04 = DLST
     C                   EVAL      PAcKyPos11 = CLAS                                          CDL038
     C                   EVAL      PAcKyPos06 = *BLANKS
     C                   EVAL      PAcKyPos07 = *BLANKS
     C                   EVAL      PAcKyPos08 = *BLANKS
     C                   EVAL      PAcKyPos09 = *BLANKS
     C                   EVAL      PAcKyPos10 = 'A'
 
     C                   EXSR      SRGetAcKeyD
 
     C                   IF        EXPALI = 'A'
     C                   EVAL      EXPACC = PAcCodDR1
     C                   EVAL      EXPACS = PAcSecDR1
     C                   EVAL      EXPREF = PPosRfDR1
     C                   ELSE
     C                   EVAL      EXPACC = PAcCodCR1
     C                   EVAL      EXPACS = PAcSecCR1
     C                   EVAL      EXPREF = PPosRfCR1
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      *****************************************************************                       CRN001
      *                                                               *                       CRN001
      *  SRSetURAcKy - Subroutine that Sets Unrealised P/L Account    *                       CRN001
      *                Key Details                                    *                       CRN001
      *                                                               *                       CRN001
      *****************************************************************                       CRN001
     C     SRSetURAcKy   BEGSR                                                                CRN001
                                                                                              CRN001
     C                   EVAL      PAcKyPos01 = DTYP                                          CRN001
     C                   EVAL      PAcKyPos03 = 'A'                                           CRN001
     C                   EVAL      PAcKyPos04 = DLST                                          CRN001
     C                   EVAL      PAcKyPos06 = *BLANKS                                       CRN001
     C                   EVAL      PAcKyPos07 = *BLANKS                                       CRN001
     C                   EVAL      PAcKyPos08 = *BLANKS                                       CRN001
     C                   EVAL      PAcKyPos09 = 'U'                                           CRN001
     C                   IF        FSURPL > 0                                                 CRN001
     C                   EVAL      PAcKyPos10 = 'P'                                           CRN001
     C                   EXSR      SRGetAcKeyD                                                CRN001
     C                   EVAL      EXUACC = PAcCodCR1                                         CRN001
     C                   EVAL      EXUACS = PAcSecCR1                                         CRN001
     C                   EVAL      EXUREF = PPosRfCR1                                         CRN001
     C                   ELSE                                                                 CRN001
     C                   EVAL      PAcKyPos10 = 'L'                                           CRN001
     C                   EXSR      SRGetAcKeyD                                                CRN001
     C                   EVAL      EXUACC = PAcCodDR1                                         CRN001
     C                   EVAL      EXUACS = PAcSecDR1                                         CRN001
     C                   EVAL      EXUREF = PPosRfDR1                                         CRN001
     C                   ENDIF                                                                CRN001
                                                                                              CRN001
     C                   ENDSR                                                                CRN001
      *****************************************************************                       CRN001
                                                                                              CRN001
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetAcKeyD - Subroutine that Retrieves Account Key Details  *
      *                                                               *
      *****************************************************************
     C     SRGetAcKeyD   BEGSR
 
     C                   CALLB     'MRACSACKY'
     C                   PARM                    PAcKyPos01
     C                   PARM                    PAcKyPos03
     C                   PARM                    PAcKyPos04
     C                   PARM                    PAcKyPos06
     C                   PARM                    PAcKyPos07
     C                   PARM                    PAcKyPos08
     C                   PARM                    PAcKyPos09
     C                   PARM                    PAcKyPos10
     C                   PARM                    PAcKyPos11                                   CDL038
 
     C                   PARM      *BLANKS       PAcCodDR1
     C                   PARM      *BLANKS       PAcSecDR1
     C                   PARM      *BLANKS       PPosRfDR1
     C                   PARM      *BLANKS       PAcCodDR2
     C                   PARM      *BLANKS       PAcSecDR2
     C                   PARM      *BLANKS       PPosRfDR2
     C                   PARM      *BLANKS       PAcCodDR3
     C                   PARM      *BLANKS       PAcSecDR3
     C                   PARM      *BLANKS       PPosRfDR3
     C                   PARM      *BLANKS       PAcCodCR1
     C                   PARM      *BLANKS       PAcSecCR1
     C                   PARM      *BLANKS       PPosRfCR1
     C                   PARM      *BLANKS       PAcCodCR2
     C                   PARM      *BLANKS       PAcSecCR2
     C                   PARM      *BLANKS       PPosRfCR2
     C                   PARM      *BLANKS       PAcCodCR3
     C                   PARM      *BLANKS       PAcSecCR3
     C                   PARM      *BLANKS       PPosRfCR3
 
     C                   ENDSR
      *****************************************************************
      /EJECT
     C*****************************************************************
     C     ZDATE2        BEGSR
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO            5 0          Value date
     C                   PARM      'D'           ZDATFM            1            Date format ind
     C                   PARM      *zero         ZDATE             6 0          Value date
     C                   PARM      *blank        ZADATE            7            Run-date in DDM
     C                   ENDSR
     C*****************************************************************
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
 
      ** Initialise LDA field.
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'MRLDNIEXT'
     C                   OUT       LDA
 
     C                   IN        RUNDAT
 
      ** Access Bank Details
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access General Ledger Details
     C                   CALL      'AOGELRR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDGELR        PARM      SDGELR        DSFDY
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDGELRPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBASE = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Set event control date to whichever is the lesser of the next
      ** working day and accrual profit date
     C                   EVAL      WkECDat = BJDNWD - 1
     C                   IF        BKAPDT < WkECDat
     C                   EVAL      WkECDat = BKAPDT
     C                   ENDIF
 
      ** Get Details of Base Currency
     C                   EVAL      PCcy = BJCYCD
     C                   EXSR      SRGetCurrD
     C                   EVAL      WkCYCDB = A6CYCD
     C                   EVAL      WkNBDPB = A6NBDP
     C                   EVAL      WkSPRTB = A6SPRT
     C                   EVAL      WkMDINB = A6MDIN
 
      ** Access Report Parameters
     C                   EXSR      SRGetRepPrm
 
      ** Get Details of Reporting Currency 1
     C                   EVAL      PCcy = RPCCY1
     C                   EXSR      SRGetCurrD
     C                   EVAL      WkCYCD1 = A6CYCD
     C                   EVAL      WkNBDP1 = A6NBDP
     C                   EVAL      WkSPRT1 = A6SPRT
     C                   EVAL      WkMDIN1 = A6MDIN
 
      ** Get Details of Reporting Currency 2
     C                   EVAL      PCcy = RPCCY2
     C                   EXSR      SRGetCurrD
     C                   EVAL      WkCYCD2 = A6CYCD
     C                   EVAL      WkNBDP2 = A6NBDP
     C                   EVAL      WkSPRT2 = A6SPRT
     C                   EVAL      WkMDIN2 = A6MDIN
 
      * Convert run date to DD/MM/YY
 
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZDATE         DayMonthYear
 
      * Calendar Year/Month
 
     C                   Z-ADD     Year          CalendarYear      2 0
     C                   Z-ADD     Month         CalendarMonth     2 0
                                                                                              CRN001
     C                   MOVE      'N'           CAS001                                       CRN001
                                                                                              CRN001
      ** Check if enhancement CAS001 is on                                                    CRN001
                                                                                              CRN001
     C                   CALLB     'AOSARDR0'                                                 CRN001
     C                   PARM      *BLANKS       @RTCD                                        CRN001
     C                   PARM      '*VERIFY'     @OPTN                                        CRN001
     C                   PARM      'CAS001'      @SARD                                        CRN001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRN001
                                                                                              CRN001
     C     @RTCD         IFEQ      *BLANK                                                     CRN001
     C                   MOVEL     'Y'           CAS001                                       CRN001
     C                   ENDIF                                                                CRN001
                                                                                              CRN001
 
     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        WkRun = *BLANK
     C                   EVAL      WkRun = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
