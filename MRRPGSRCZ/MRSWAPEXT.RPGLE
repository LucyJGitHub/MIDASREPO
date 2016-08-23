     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MR Interest Rate Swaps Extract')
      *****************************************************************
      *                                                               *
      *  Midas - MidasPlus Reporting module                           *
      *                                                               *
      *  RPGLE/MRSWAPEXT - Interest Rate Swaps Extract                *
      *                                                               *
      *  Function:  This module will read DEALSDG as an input primary *
      *             file.  For each required record from DEALSDG, two *
      *             records will be written to file MRTRAPPD.         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CRN001             Date 20Jul05               *
      *                 CDL038             Date 10May05               *
      *                 CMR001  *CREATE    Date 16Aug04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
 
      ** Forward Rate Agreement/Interest Rate Swaps File
     FDEALSDG   IF   E             DISK    INFSR(*PSSR)
 
      ** Deals Extension File
     FDLDEALL5  IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(DLDLDBD0)
     F                                     IGNORE(DLDLDCD0)
 
      ** Reporting Parameters
     FMRRPRMPD  IF   E             DISK    INFSR(*PSSR)
                                                                                              CRN001
      ** Midas IR Revalued SIRS file                                                          CRN001
     FIRNPVAL0  IF   E           K DISK    INFSR(*PSSR)                                       CRN001
                                                                                              CRN001
      ** Midas IR Revalued CIRS file                                                          CRN001
     FRXNPVAL1  IF   E           K DISK    INFSR(*PSSR)                                       CRN001
                                                                                              CRN001
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
 
      ** General Ledger Details Data Structure
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D  QQACC2       E                     EXTFLD(QQACCD)
 
      ** Currency Details Data Structure
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Customer Details Data Structure
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Branch Details Data Structure
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D  QQDFAC1      E                     EXTFLD(QQDFAC)
 
      ** Account Code Details Data Structure
     D SDACOD        E DS                  EXTNAME(SDACODPD)
 
      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Access Object Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
                                                                                              CRN001
     ** External DS for SAR details                                                           CRN001
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CRN001
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WkRun           S              1
                                                                                              CRN001
     D CAS001          S              1                                                       CRN001
 
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
     D PAcCd           S             10
     D WkECDat         S              5  0
     D I#ERMS          S             30
     D PDBCE           S             13  0
 
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
 
     C     1             SETLL     DEALSDG
 
     C                   READ      DEALSDG
 
     C                   DOW       NOT %EOF(DEALSDG)
 
      ** Process deal if this is live or matured and deal is single or cross
      ** currencies IRS
     C                   IF        (RECI = 'D' OR RECI = 'M') AND
     C                             (DTYP = 'RS' OR DTYP = 'RX')
     C                   EXSR      SRProcess
     C                   ENDIF
 
     C                   READ      DEALSDG
 
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
 
      ** Setup Asset Leg:
 
     C                   EVAL      EXPALI = 'A'
 
      ** Setup common fields to both buy and sell legs
     C                   EXSR      SRSetCommon
 
      ** Set Currency Details, Base/Reporting Currencies Exchange Rates for
      ** Purchase Ccy
     C                   EVAL      I#LFD1 = TCUCY
     C                   EXSR      SRSetCurDet
 
      ** Set Principal Account Key Details
     C                   EXSR      SRSetPrAcKy
     C                   EVAL      EXPACC = PAcCodDR1
     C                   EVAL      EXPACS = PAcSecDR1
     C                   EVAL      EXPREF = PPosRfDR1
 
      ** Set Principal Amounts
     C                   Z-ADD     TPAMT         WkTAmt
     C                   EXSR      SRCvtAmounts
     C                   EVAL(H)   EXPAMT = WkTAmt/(10**A6NBDP)
     C                   EVAL(H)   EXPMTB = WkAmtInB/(10**WkNBDPB)
     C                   EVAL(H)   EXPMT1 = WkAmtIn1/(10**WkNBDP1)
     C                   EVAL(H)   EXPMT2 = WkAmtIn2/(10**WkNBDP2)
 
      ** Set Accrued Interest Account Key Details
      ** and Interest Inc./Exp. Account Key Details
     C                   EXSR      SRSetAIAcKy
     C                   EVAL      EXAACC = PAcCodDR1
     C                   EVAL      EXAACS = PAcSecDR1
     C                   EVAL      EXAREF = PPosRfDR1
     C                   EVAL      EXIACC = PAcCodCR1
     C                   EVAL      EXIACS = PAcSecCR1
     C                   EVAL      EXIREF = PPosRfCR1
 
      ** Set Accrued Interest Sign and DR/CR indicator
     C                   EVAL      EXASGN = 1
     C                   EVAL      EXADCI = 0
 
      ** Set Accrued Interest Amounts
     C                   EVAL      WkTAmt = TAIPD - TIPRD
     C                   EXSR      SRCvtAmounts
     C                   EVAL(H)   EXAAMT = WkTAmt/(10**A6NBDP)
     C                   EVAL(H)   EXAMTB = WkAmtInB/(10**WkNBDPB)
     C                   EVAL(H)   EXAMT1 = WkAmtIn1/(10**WkNBDP1)
     C                   EVAL(H)   EXAMT2 = WkAmtIn2/(10**WkNBDP2)
 
      ** Set Next Interest Pay Date and Date Schedules and Amounts
     C                   IF        TNIPD <> *ZERO
     C                   EVAL      EXNIDT = TNIPD
     C                   ELSE
     C                   EVAL      EXNIDT = MDAT
     C                   ENDIF
 
     C                   IF        EXNIDT <> *ZERO
     C                   EXSR      SRSetNInSch
     C                   IF        TEINR <> *ZERO
     C                   EXSR      SRSetNIPAmt
     C                   EVAL      WkTAmt = WkIntrst + TAITC + TAIAP - TIPRD
     C                   EXSR      SRCvtAmounts
     C                   EVAL(H)   EXNIMT = WkTAmt/(10**A6NBDP)
     C                   EVAL(H)   EXNIMB = WkAmtInB/(10**WkNBDPB)
     C                   EVAL(H)   EXNIM1 = WkAmtIn1/(10**WkNBDP1)
     C                   EVAL(H)   EXNIM2 = WkAmtIn2/(10**WkNBDP2)
     C                   ENDIF
     C                   ENDIF
 
      ** Set Fixed/Variable Rate indicator, Base Rate, Rate/Spread, Interest
      ** Rate, Yield Rate
     C                   IF        TBRTT <> *ZERO
     C                   EVAL      EXRATE = 'V'
     C                   EVAL      EXBRTE = TBRTE
     C                   EVAL      EXRTSP = TRTSP
     C                   ELSE
     C                   EVAL      EXRATE = 'F'
     C                   EVAL      EXBRTE = *ZERO
     C                   EVAL      EXRTSP = *ZERO
     C                   ENDIF
 
     C                   EVAL      EXINTR = TEINR
                                                                                              CRN001
     C                   EVAL      EXBOOK = BOKC                                              CRN001
 
     C                   WRITE     MRTRAPD0
 
      ** Reset Fields
     C                   CLEAR                   MRTRAPD0
 
      ** Set up Sell Leg:
     C                   EVAL      EXPALI = 'L'
 
      ** Setup common fields to both buy and sell legs
     C                   EXSR      SRSetCommon
 
      ** Set Currency Details, Base/Reporting Currencies Exchange Rates for
      ** Sell Ccy
     C                   EVAL      I#LFD1 = UCUCY
     C                   EXSR      SRSetCurDet
 
      ** Set Principal Account Key
     C                   EXSR      SRSetPrAcKy
     C                   EVAL      EXPACC = PAcCodCR1
     C                   EVAL      EXPACS = PAcSecCR1
     C                   EVAL      EXPREF = PPosRfCR1
 
      ** Set Principal Amounts
     C                   Z-ADD     UPAMT         WkTAmt
     C                   EXSR      SRCvtAmounts
     C                   EVAL(H)   EXPAMT = WkTAmt/(10**A6NBDP)
     C                   EVAL(H)   EXPMTB = WkAmtInB/(10**WkNBDPB)
     C                   EVAL(H)   EXPMT1 = WkAmtIn1/(10**WkNBDP1)
     C                   EVAL(H)   EXPMT2 = WkAmtIn2/(10**WkNBDP2)
 
      ** Set Accrued Interest Account Key Details
      ** and Interest Inc./Exp. Account Key Details
     C                   EXSR      SRSetAIAcKy
     C                   EVAL      EXAACC = PAcCodCR1
     C                   EVAL      EXAACS = PAcSecCR1
     C                   EVAL      EXAREF = PPosRfCR1
     C                   EVAL      EXIACC = PAcCodDR1
     C                   EVAL      EXIACS = PAcSecDR1
     C                   EVAL      EXIREF = PPosRfDR1
 
      ** Set Accrued Interest Sign and DR/CR indicator
     C                   EVAL      EXASGN = -1
     C                   EVAL      EXADCI =  1
 
      ** Set Accrued Interest Amounts
     C                   EVAL      WkTAmt = UAIPD - UIPRD
     C                   EXSR      SRCvtAmounts
     C                   EVAL(H)   EXAAMT = WkTAmt/(10**A6NBDP)
     C                   EVAL(H)   EXAMTB = WkAmtInB/(10**WkNBDPB)
     C                   EVAL(H)   EXAMT1 = WkAmtIn1/(10**WkNBDP1)
     C                   EVAL(H)   EXAMT2 = WkAmtIn2/(10**WkNBDP2)
 
      ** Set Next Interest Pay Date and Date Schedules and Amounts
     C                   IF        UNIPD <> *ZERO
     C                   EVAL      EXNIDT = UNIPD
     C                   ELSE
     C                   EVAL      EXNIDT = MDAT
     C                   ENDIF
 
     C                   IF        EXNIDT <> *ZERO
     C                   EXSR      SRSetNInSch
     C                   IF        UEINR <> *ZERO
     C                   EXSR      SRSetNIPAmt
     C                   EVAL      WkTAmt = WkIntrst + UAITC + UAIAP - UIPRD
     C                   EXSR      SRCvtAmounts
     C                   EVAL(H)   EXNIMT = WkTAmt/(10**A6NBDP)
     C                   EVAL(H)   EXNIMB = WkAmtInB/(10**WkNBDPB)
     C                   EVAL(H)   EXNIM1 = WkAmtIn1/(10**WkNBDP1)
     C                   EVAL(H)   EXNIM2 = WkAmtIn2/(10**WkNBDP2)
     C                   ENDIF
     C                   ENDIF
 
      ** Set Fixed/Variable Rate indicator, Base Rate, Rate/Spread, Interest
      ** Rate, Yield Rate
     C                   IF        UBRTT <> *ZERO
     C                   EVAL      EXRATE = 'V'
     C                   EVAL      EXBRTE = UBRTE
     C                   EVAL      EXRTSP = URTSP
     C                   ELSE
     C                   EVAL      EXRATE = 'F'
     C                   EVAL      EXBRTE = *ZERO
     C                   EVAL      EXRTSP = *ZERO
     C                   ENDIF
 
     C                   EVAL      EXINTR = UEINR
                                                                                              CRN001
     C                   EVAL      EXBOOK = BOKC                                              CRN001
 
     C                   WRITE     MRTRAPD0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetNIPAmt - Subroutine that Sets Next Interest Pay Amount  *
      *                Fields                                         *
      *                                                               *
      *****************************************************************
     C     SRSetNIPAmt   BEGSR
 
     C                   IF        EXPALI = 'A'
     C                   Z-ADD     TIACD         ZIBEG
     C                   Z-ADD     EXNIDT        ZIEND
     C                   Z-ADD     TICBS         ZICALC
     C                   Z-ADD     TPAMT         ZIAMT
     C                   Z-ADD     TEINR         ZIRATE
     C                   ELSE
     C                   Z-ADD     UIACD         ZIBEG
     C                   Z-ADD     EXNIDT        ZIEND
     C                   Z-ADD     UICBS         ZICALC
     C                   Z-ADD     UPAMT         ZIAMT
     C                   Z-ADD     UEINR         ZIRATE
     C                   ENDIF
 
     C                   CALLB     'GLINTC'
     C                   PARM                    ZIBEG
     C                   PARM                    ZIEND
     C                   PARM                    ZICALC
     C                   PARM                    ZIAMT
     C                   PARM                    ZIRATE
      ** Output
     C                   PARM      *ZEROS        ZINTR
 
     C                   Z-ADD(H)  ZINTR         WkIntrst         15 0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetCommon - Subroutine that Sets Common Fields to Both     *
      *                Asset and Liability Legs                       *
      *                                                               *
      *****************************************************************
     C     SRSetCommon   BEGSR
 
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
     C                   EVAL      EXSUB = 'SWAP'
 
      ** Set Transaction Id
     C                   MOVEL     DLNO          EXTRID
 
      ** Set Sequence Number
     C                   IF        EXPALI = 'A'
     C                   EVAL      EXSEQ = 0
     C                   ELSE
     C                   EVAL      EXSEQ = 1
     C                   ENDIF
 
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
     C                   EVAL      EXBALS = '0'
 
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
 
      ** Set Principal Sign and DR/CR ind
     C                   IF        EXPALI = 'A'
     C                   Z-ADD     1             EXPSGN
     C                   Z-ADD     0             EXPDCI
     C                   ELSE
     C                   Z-SUB     1             EXPSGN
     C                   Z-ADD     1             EXPDCI
     C                   ENDIF
 
      ** Set Account Sequence, Transaction Type, Sub-Type, Profit Centre,
      ** Deal Date and Value Date
     C                   EVAL      EXACSQ = '01'
     C                   EVAL      EXACS1 = '01'
     C                   EVAL      EXTRTY = DTYP
     C                   EVAL      EXTRST = DLST
     C                   EVAL      EXCLAS = CLAS                                              CDL038
     C                   EVAL      EXPRFC = PRFC
     C                   EVAL      EXDDAT = DDAT
     C                   EVAL      EXVDAT = VDAT
     C                   EVAL      EXMDAT = MDAT
 
      ** Set Unrealised Profit/Loss Sign and DR/CR indicator
     C                   EVAL      EXUSGN = -1
     C                   EVAL      EXUDCI =  1
 
      ** Set Unrealised Profit/Loss Account Key Details
     C                   IF        UNRLP <> 0
     C                   EXSR      SRSetURAcKy
 
     C                   IF        DTYP = 'RS'
 
     C                   EVAL      I#LFD1 = UCUCY
     C                   CALLB     'MXACSCURR'
      /COPY MXCPYSRC,MXACSPRME
     C                   IF        ACS_RTCD = '*ERROR '
     C                   EVAL      I#ERMS = 'INVALID CURRENCY: ' + I#LFD1
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   EVAL      SDCURR = InData
     C                   Z-ADD     UNRLP         WkTAmt
     C                   EVAL      ZEXCH = A6SPRT
     C                   EVAL      ZMD = A6MDIN
     C                   EVAL      ZAMTCI = UNRLP
     C                   EVAL      ZCCYI = A6CYCD
     C                   EVAL      ZCCYO = WkCYCDB
     C                   EVAL      ZCDPI = A6NBDP
     C                   EVAL      ZCDPO = WkNBDPB
     C                   EXSR      SRGetCvtAmt
     C                   Z-ADD     ZAMTCO        WkAmtInB
 
      ** Convert amount to amount in Reporting Ccy 1
     C                   EVAL      ZRATE1 = A6SPRT
     C                   EVAL      ZMDI1 = A6MDIN
     C                   EVAL      ZRATE2 = WkSPRT1
     C                   EVAL      ZMDI2 = WkMDIN1
     C                   EXSR      SRGetXRate
     C                   EVAL      ZEXCH = ZRATEX
     C                   EVAL      ZMD = ZMDIX
     C                   EVAL      ZAMTCI = UNRLP
     C                   EVAL      ZCCYI = UCUCY
     C                   EVAL      ZCCYO = RPCCY1
     C                   EVAL      ZCDPI = A6NBDP
     C                   EVAL      ZCDPO = WkNBDP1
     C                   EXSR      SRGetCvtAmt
     C                   Z-ADD     ZAMTCO        WkAmtIn1
 
      ** Convert amount to amount in Reporting Ccy 2
     C                   EVAL      ZRATE1 = A6SPRT
     C                   EVAL      ZMDI1 = A6MDIN
     C                   EVAL      ZRATE2 = WkSPRT2
     C                   EVAL      ZMDI2 = WkMDIN2
     C                   EXSR      SRGetXRate
     C                   EVAL      ZEXCH = ZRATEX
     C                   EVAL      ZMD = ZMDIX
     C                   EVAL      ZCCYO = RPCCY2
     C                   EVAL      ZCDPO = WkNBDP2
     C                   EXSR      SRGetCvtAmt
     C                   Z-ADD     ZAMTCO        WkAmtIn2
                                                                                              CRN001
     C                   IF        CAS001 = 'N'                                               CRN001
 
     C                   EVAL(H)   EXUAMT = WkTAmt/(10**A6NBDP)
     C                   EVAL(H)   EXUMTB = WkAmtInB/(10**WkNBDPB)
     C                   EVAL(H)   EXUMT1 = WkAmtIn1/(10**WkNBDP1)
     C                   EVAL(H)   EXUMT2 = WkAmtIn2/(10**WkNBDP2)
                                                                                              CRN001
     C                   ELSE                                                                 CRN001
                                                                                              CRN001
      ** Get Unrealized P/L amount from IRNPVAL0 for 'RS' deals                               CRN001
     C     DLNO          CHAIN     IRNPVAL0                                                   CRN001
                                                                                              CRN001
      ** Set Unrealized P/L Amount                                                            CRN001
     C                   IF        %FOUND                                                     CRN001
     C                   EVAL      WkTAmt = IRURPL                                            CRN001
     C                   EXSR      SRCvtAmounts                                               CRN001
     C                   EVAL(H)   EXUAMT = WkTAmt/(10**A6NBDP)                               CRN001
     C                   EVAL(H)   EXUMTB = WkAmtInB/(10**WkNBDPB)                            CRN001
     C                   EVAL(H)   EXUMT1 = WkAmtIn1/(10**WkNBDP1)                            CRN001
     C                   EVAL(H)   EXUMT2 = WkAmtIn2/(10**WkNBDP2)                            CRN001
     C                   ENDIF                                                                CRN001
                                                                                              CRN001
     C                   ENDIF                                                                CRN001
 
     C                   ELSE
     C                   Z-ADD     UNRLP         WkTAmt
 
      ** Convert Amount in Base Ccy to Amount in Reporting Ccy 1
     C                   Z-ADD     WkTAmt        ZAMTCI
     C                   EVAL      ZEXCH = WkSPRT1
     C                   IF        WkMDIN1 = 'M'
     C                   EVAL      ZMD = 'D'
     C                   ELSE
     C                   EVAL      ZMD = 'M'
     C                   ENDIF
     C                   EVAL      ZCCYI = WkCYCDB
     C                   EVAL      ZCCYO = WkCYCD1
     C                   EVAL      ZCDPI = WkNBDPB
     C                   EVAL      ZCDPO = WkNBDP1
     C                   EXSR      SRGetCvtAmt
     C                   Z-ADD     ZAMTCO        WkAmtIn1
 
      ** Convert Amount in Base Ccy to Amount in Reporting Ccy 2
     C                   EVAL      ZEXCH = WkSPRT2
     C                   IF        WkMDIN2 = 'M'
     C                   EVAL      ZMD = 'D'
     C                   ELSE
     C                   EVAL      ZMD = 'M'
     C                   ENDIF
     C                   EVAL      ZCCYO = WkCYCD2
     C                   EVAL      ZCDPO = WkNBDP2
     C                   EXSR      SRGetCvtAmt
     C                   Z-ADD     ZAMTCO        WkAmtIn2
 
     C                   IF        CAS001 = 'N'                                               CRN001
                                                                                              CRN001
     C                   EVAL(H)   EXUMTB = WkTAmt/(10**WkNBDPB)
     C                   EVAL(H)   EXUMT1 = WkAmtIn1/(10**WkNBDP1)
     C                   EVAL(H)   EXUMT2 = WkAmtIn2/(10**WkNBDP2)
                                                                                              CRN001
     C                   ELSE                                                                 CRN001
                                                                                              CRN001
      ** Get Unrealized P/L amount from RXNPVAL1 for 'RX' deals                               CRN001
     C     KNPVMT        CHAIN     RXNPVAL1                                                   CRN001
                                                                                              CRN001
      ** Set Unrealized P/L Amount                                                            CRN001
     C                   IF        %FOUND                                                     CRN001
     C                   EVAL      WkTAmt = IRURPL                                            CRN001
     C                   EXSR      SRCvtAmounts                                               CRN001
     C                   EVAL(H)   EXUAMT = WkTAmt/(10**A6NBDP)                               CRN001
     C                   EVAL(H)   EXUMTB = WkAmtInB/(10**WkNBDPB)                            CRN001
     C                   EVAL(H)   EXUMT1 = WkAmtIn1/(10**WkNBDP1)                            CRN001
     C                   EVAL(H)   EXUMT2 = WkAmtIn2/(10**WkNBDP2)                            CRN001
     C                   ENDIF                                                                CRN001
                                                                                              CRN001
     C                   ENDIF                                                                CRN001
                                                                                              CRN001
     C                   ENDIF
 
     C                   ENDIF
 
      ** Set Maturity Date - Date Schedules (EXMDT0-EXMDT9)
     C                   EXSR      SRSetMatSch
 
      ** Set Facility Details
     C                   MOVE      DLNO          F1DLNO
     C                   EXSR      SRSetFacDet
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetFacDet - Subroutine that Sets Facility Details          *
      *                                                               *
      *****************************************************************
     C     SRSetFacDet   BEGSR
 
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
 
     C                   EVAL      PaRepDt = WkECDat
     C                   EVAL      PaSchDt = EXNIDT
 
      ** Set Maturity Date - Date schedule 0
     C                   EVAL      PaDtSch = 0
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXNID0 = PaBuckCode
 
      ** Set Maturity Date - Date schedule 1
     C                   EVAL      PaDtSch = 1
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXNID1 = PaBuckCode
 
      ** Set Maturity Date - Date schedule 2
     C                   EVAL      PaDtSch = 2
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXNID2 = PaBuckCode
 
      ** Set Maturity Date - Date schedule 3
     C                   EVAL      PaDtSch = 3
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXNID3 = PaBuckCode
 
      ** Set Maturity Date - Date schedule 4
     C                   EVAL      PaDtSch = 4
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXNID4 = PaBuckCode
 
      ** Set Maturity Date - Date schedule 5
     C                   EVAL      PaDtSch = 5
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXNID5 = PaBuckCode
 
      ** Set Maturity Date - Date schedule 6
     C                   EVAL      PaDtSch = 6
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXNID6 = PaBuckCode
 
      ** Set Maturity Date - Date schedule 7
     C                   EVAL      PaDtSch = 7
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXNID7 = PaBuckCode
 
      ** Set Maturity Date - Date schedule 8
     C                   EVAL      PaDtSch = 8
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXNID8 = PaBuckCode
 
      ** Set Maturity Date - Date schedule 9
     C                   EVAL      PaDtSch = 9
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXNID9 = PaBuckCode
 
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
 
     C                   EVAL      PaRepDt = WkECDat
     C                   EVAL      PaSchDt = EXMDAT
 
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
     C                   EVAL      ZCCYI = EXCYCD
     C                   EVAL      ZCCYO = WkCYCDB
     C                   EVAL      ZCDPI = A6NBDP
     C                   EVAL      ZCDPO = WkNBDPB
     C                   EXSR      SRGetCvtAmt
     C                   Z-ADD     ZAMTCO        WkAmtInB
 
      ** Get Amount in Reporting Currency 1
     C                   EVAL      ZEXCH = EXERP1
     C                   EVAL      ZMD = EXMDI1
     C                   EVAL      ZCCYO = WkCYCD1
     C                   EVAL      ZCDPO = WkNBDP1
     C                   EXSR      SRGetCvtAmt
     C                   Z-ADD     ZAMTCO        WkAmtIn1
 
      ** Get Amount in Reporting Currency 2
     C                   EVAL      ZEXCH = EXERP2
     C                   EVAL      ZMD = EXMDI2
     C                   EVAL      ZCCYO = WkCYCD2
     C                   EVAL      ZCDPO = WkNBDP2
     C                   EXSR      SRGetCvtAmt
     C                   Z-ADD     ZAMTCO        WkAmtIn2
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetCvtAmt - Subroutine that Gets Converted Amount via      *
      *                ZCONVZ1                                        *
      *                                                               *
      *****************************************************************
     C     SRGetCvtAmt   BEGSR
 
     C                   CALLB     'ZCONVZ1'
      ** Inputs
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
     C                   EVAL      I#ERMS = 'INVALID CURRENCY: ' + I#LFD1
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
      ** Inputs
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
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PCust
     C                   PARM      *BLANKS       PStKey
     C     SDCUST        PARM      *BLANKS       DSSDY
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBKEY = PCust
     C                   EVAL      DBASE = 4
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
     C                   EVAL      I#ERMS = 'INVALID BRANCH: ' + I#LFD1
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
     C                   EVAL      DBASE = 5
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetURAcKy - Subroutine that Sets Unrealised P/L Account    *
      *                Key Details                                    *
      *                                                               *
      *****************************************************************
     C     SRSetURAcKy   BEGSR
 
     C                   EVAL      PAcKyPos01 = DTYP
     C                   EVAL      PAcKyPos03 = 'A'
     C                   EVAL      PAcKyPos04 = DLST
     C                   EVAL      PAcKyPos11 = CLAS                                          CDL038
     C                   EVAL      PAcKyPos06 = *BLANKS
     C                   EVAL      PAcKyPos07 = *BLANKS
     C                   EVAL      PAcKyPos08 = *BLANKS
     C                   EVAL      PAcKyPos09 = 'U'
     C                   IF        UNRLP > 0
     C                   EVAL      PAcKyPos10 = 'P'
     C                   EXSR      SRGetAcKeyD
     C                   EVAL      EXUACC = PAcCodCR1
     C                   EVAL      EXUACS = PAcSecCR1
     C                   EVAL      EXUREF = PPosRfCR1
     C                   ELSE
     C                   EVAL      PAcKyPos10 = 'L'
     C                   EXSR      SRGetAcKeyD
     C                   EVAL      EXUACC = PAcCodDR1
     C                   EVAL      EXUACS = PAcSecDR1
     C                   EVAL      EXUREF = PPosRfDR1
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
     C                   IF        EXPALI = 'A'
     C                   EVAL      PAcKyPos09 = 'R'
     C                   ELSE
     C                   EVAL      PAcKyPos09 = 'P'
     C                   ENDIF
     C                   EVAL      PAcKyPos10 = 'A'
 
     C                   EXSR      SRGetAcKeyD
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetPrAcKy - Subroutine that Sets Principal Account Key     *
      *                                                               *
      *****************************************************************
     C     SRSetPrAcKy   BEGSR
 
     C                   EVAL      PAcKyPos01 = DTYP
     C                   EVAL      PAcKyPos03 = 'D'
     C                   EVAL      PAcKyPos04 = DLST
     C                   EVAL      PAcKyPos11 = CLAS                                          CDL038
     C                   EVAL      PAcKyPos06 = *BLANKS
     C                   EVAL      PAcKyPos07 = *BLANKS
     C                   EVAL      PAcKyPos08 = *BLANKS
     C                   EVAL      PAcKyPos09 = *BLANKS
     C                   EVAL      PAcKyPos10 = 'A'
 
     C                   EXSR      SRGetAcKeyD
 
     C                   ENDSR
      *****************************************************************
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
                                                                                              CRN001
     ** Key for RXNPVAL1                                                                      CRN001
     C     KNPVMT        KLIST                                                                CRN001
     C                   KFLD                    DLNO                                         CRN001
     C                   KFLD                    EXCYCD                                       CRN001
 
      ** Initialise LDA field.
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'MRSWAPEXT'
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
 
      ** Access Report Parameters
 
     C     1             SETLL     MRRPRMPD
     C                   READ      MRRPRMPD
 
     C                   IF        %EOF(MRRPRMPD)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'MRRPRMPD'
     C                   EVAL      DBKEY = '*READ '
     C                   EVAL      DBASE = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Get Details of Base Currency
     C                   EVAL      PCcy = BJCYCD
     C                   EXSR      SRGetCurrD
     C                   EVAL      WkCYCDB = A6CYCD
     C                   EVAL      WkNBDPB = A6NBDP
     C                   EVAL      WkSPRTB = A6SPRT
     C                   EVAL      WkMDINB = A6MDIN
 
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
      ** Check if enhancement CAS001 is on                                                    CRN001
                                                                                              CRN001
     C                   MOVE      'N'           CAS001                                       CRN001
     C                   CALLB     'AOSARDR0'                                                 CRN001
     C                   PARM      *BLANKS       @RTCD                                        CRN001
     C                   PARM      '*VERIFY'     @OPTN                                        CRN001
     C                   PARM      'CAS001'      @SARD                                        CRN001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRN001
                                                                                              CRN001
     C     @RTCD         IFEQ      *BLANK                                                     CRN001
     C                   MOVEL     'Y'           CAS001                                       CRN001
     C                   ENDIF                                                                CRN001
 
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
