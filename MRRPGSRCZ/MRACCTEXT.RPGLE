     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MR Accounts Extract')
      *****************************************************************
      *                                                               *
      *  Midas - MidasPlus Reporting module                           *
      *                                                               *
      *  RPGLE/MRACCTEXT - Accounts Extract                           *
      *                                                               *
      *  Function:  This module will read ACCNTAB as an input primary *
      *             file.  For each required record from ACCNTAB, a   *
      *             record will be written to file MRTRAPPD.          *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CRN001             Date 20Jul05               *
      *                 CDL038             Date 10May05               *
      *                 CMR001  *CREATE    Date 16Aug04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
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
 
      ** Accounts File
     FACCNTAB   IF   E             DISK    INFSR(*PSSR)
 
      ** Reporting Parameters
     FMRRPRMPD  IF   E             DISK    INFSR(*PSSR)
 
      ** Midas RETAIL ACCRUED ITD FILE                                                        CRN001
     FREACR     IF   E           K DISK    INFSR(*PSSR)                                       CRN001
                                                                                              CRN001
      ** Transactions, Accounts and Positions Report File
     FMRTRAPPD  O    E             DISK    INFSR(*PSSR)
 
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
 
      ** Account Code Details Data Structure
     D SDACOD        E DS                  EXTNAME(SDACODPD)
     D  QQACC1       E                     EXTFLD(QQACCD)
 
      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Access Object Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WkRun           S              1
 
     D WkTAmt          S             15  0
     D WkTAmt2         S             15  0                                                    CRN001
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
     D PRetCode        S              7
     D POption         S              7
     D PCust           S             10
     D PStKey          S              7
     D PCcy            S              3
     D WkECDat         S              5  0
     D I#ERMS          S             30
     D WDebitInt       S             18  3                                                    CRN001
     D WCreditInt      S             18  3                                                    CRN001
 
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
 
     C     1             SETLL     ACCNTAB
 
     C                   READ      ACCNTAB
 
     C                   DOW       NOT %EOF(ACCNTAB)
 
      ** Process account record if live
     C                   IF        RECI = 'D'
     C                   EXSR      SRProcess
     C                   ENDIF
 
      ** Read next record
     C                   READ      ACCNTAB
 
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
     C                   EVAL      EXMOD = 'GL'
 
      ** Set Sub-Module
     C                   EVAL      EXSUB = 'ACCT'
 
      ** Set Transaction Id
     C                   EVAL      EXTRID = *BLANKS
 
      ** Set Sequence Number
     C                   EVAL      EXSEQ = 0
 
      ** Set Transaction Status
     C                   IF        RECI = 'C'
     C                   EVAL      EXSTAT = 'M'
     C                   ELSE
     C                   EVAL      EXSTAT = *BLANKS
     C                   ENDIF
 
      ** Set On/Off Balance Sheet
     C                   MOVE      *BLANKS       I#LFD1
     C                   MOVEL     ACOD          I#LFD1
     C                   EXSR      SRGetAcCdD
     C                   IF        A5ACSC = 'AS' OR A5ACSC = 'LI' OR
     C                             A5ACSC = 'IN' OR A5ACSC = 'EX' OR
     C                             A5ACSC = 'TR'
     C                   EVAL      EXBALS = '1'
     C                   ELSE
     C                   EVAL      EXBALS = '0'
     C                   ENDIF
 
      ** Set Principal Account Code and Section
     C                   EVAL      EXPACC = A5ACCD
     C                   EVAL      EXPACS = A5ACSC
     C                   EVAL      EXPREF = *BLANKS
 
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
 
      ** Initialise FX Contract and Valuation Rates
     C                   EVAL      EXCNRT = 0
     C                   EVAL      EXVLRT = 0
 
      ** Set Principal Asset/Liability indicator, sign and DR/CR ind
     C                   IF        LDBL >= 0
     C                   EVAL      EXPALI = 'A'
     C                   Z-ADD     1             EXPSGN
     C                   Z-ADD     0             EXPDCI
     C                   ELSE
     C                   EVAL      EXPALI = 'L'
     C                   Z-SUB     1             EXPSGN
     C                   Z-ADD     1             EXPDCI
     C                   ENDIF
 
      ** Set Principal Amounts
     C                   IF        LDBL < 0
     C                   Z-SUB     LDBL          WkTAmt
     C                   ELSE
     C                   Z-ADD     LDBL          WkTAmt
     C                   ENDIF
 
     C                   EXSR      SRCvtAmounts
     C                   EVAL(H)   EXPAMT = WkTAmt/(10**A6NBDP)
     C                   EVAL(H)   EXPMTB = WkAmtInB/(10**WkNBDPB)
     C                   EVAL(H)   EXPMT1 = WkAmtIn1/(10**WkNBDP1)
     C                   EVAL(H)   EXPMT2 = WkAmtIn2/(10**WkNBDP2)
                                                                                              CRN001
     C                   Z-ADD     CLBL          WkTAmt2                                      CRN001
     C                   EVAL(H)   EXRTCB = WkTAmt2/(10**A6NBDP)                              CRN001
 
      ** Initialise Accrued Interest Details
     C**********         EVAL      EXASGN = *ZERO                                             CRN001
     C                   EVAL      EXASGN = 1                                                 CRN001
     C                   EVAL      EXADCI = *ZERO
     C                   EVAL      EXAACC = *BLANKS
     C                   EVAL      EXAACS = *BLANKS
     C                   EVAL      EXAREF = *BLANKS
     C                   EVAL      EXAAMT = *ZEROS
     C                   EVAL      EXAMTB = *ZEROS
     C                   EVAL      EXAMT1 = *ZEROS
     C                   EVAL      EXAMT2 = *ZEROS
 
      ** Initialise Other Accrued Interest Details                                            CRN001
     C                   EVAL      EXOASG = 1                                                 CRN001
     C                   EVAL      EXOADC = 1                                                 CRN001
     C                   EVAL      EXOACC = *BLANKS                                           CRN001
     C                   EVAL      EXOACS = *BLANKS                                           CRN001
     C                   EVAL      EXOARF = *BLANKS                                           CRN001
     C                   EVAL      EXOAAM = *ZEROS                                            CRN001
     C                   EVAL      EXOAMB = *ZEROS                                            CRN001
     C                   EVAL      EXOAM1 = *ZEROS                                            CRN001
     C                   EVAL      EXOAM2 = *ZEROS                                            CRN001
 
      *                                                                                       CRN001
      ** Get Accrued Interest                                                                 CRN001
      *                                                                                       CRN001
     C                   IF        ATYP = 'R'                                                 CRN001
     C     KREACR        CHAIN     REACRDF                            85                      CRN001
     C                   IF        *IN85 = *OFF                                               CRN001
     C                   EVAL(H)   WDebitInt  = DAIC1 + MADI + GADI                           CRN001
     C                   EVAL(H)   WCreditInt = CAIC1 + MACI + GACI                           CRN001
     C**********         EVAL(H)   WkTAmt     = WDebitInt  -  WCreditInt                      CRN001
                                                                                              CRN001
     C                   EVAL      WkTAmt =  WDebitInt                                        CRN001
     C                   EXSR      SRCvtAmounts                                               CRN001
     C                   EVAL(H)   EXAAMT = WkTAmt/(10**A6NBDP)                               CRN001
     C                   EVAL(H)   EXAMTB = WkAmtInB/(10**WkNBDPB)                            CRN001
     C                   EVAL(H)   EXAMT1 = WkAmtIn1/(10**WkNBDP1)                            CRN001
     C                   EVAL(H)   EXAMT2 = WkAmtIn2/(10**WkNBDP2)                            CRN001
                                                                                              CRN001
     C                   EVAL      WkTAmt =  WCreditInt                                       CRN001
     C                   EXSR      SRCvtAmounts                                               CRN001
     C                   EVAL(H)   EXOAAM = WkTAmt/(10**A6NBDP)                               CRN001
     C                   EVAL(H)   EXOAMB = WkAmtInB/(10**WkNBDPB)                            CRN001
     C                   EVAL(H)   EXOAM1 = WkAmtIn1/(10**WkNBDP1)                            CRN001
     C                   EVAL(H)   EXOAM2 = WkAmtIn2/(10**WkNBDP2)                            CRN001
     C                   ENDIF                                                                CRN001
                                                                                              CRN001
     C                   ENDIF                                                                CRN001
                                                                                              CRN001
      ** Initialise Unearned Discount Premium Details
     C                   EVAL      EXESGN = *ZERO
     C                   EVAL      EXEDCI = *ZERO
     C                   EVAL      EXEACC = *BLANKS
     C                   EVAL      EXEACS = *BLANKS
     C                   EVAL      EXEREF = *BLANKS
     C                   EVAL      EXEAMT = *ZEROS
     C                   EVAL      EXEMTB = *ZEROS
     C                   EVAL      EXEMT1 = *ZEROS
     C                   EVAL      EXEMT2 = *ZEROS
 
      ** Initialise Unrealised Profit/Loss Details
     C                   EVAL      EXUSGN = *ZERO
     C                   EVAL      EXUDCI = *ZERO
     C                   EVAL      EXUACC = *BLANKS
     C                   EVAL      EXUACS = *BLANKS
     C                   EVAL      EXUREF = *BLANKS
     C                   EVAL      EXUAMT = *ZEROS
     C                   EVAL      EXUMTB = *ZEROS
     C                   EVAL      EXUMT1 = *ZEROS
     C                   EVAL      EXUMT2 = *ZEROS
 
      ** Initialise Interest Income/Expense Details
     C                   EVAL      EXIACC = *BLANKS
     C                   EVAL      EXIACS = *BLANKS
     C                   EVAL      EXIREF = *BLANKS
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
 
      ** Set Account Sequence, Account Type, Sub-Type, Profit Centre, Deal
      ** Date, Value Date, and Maturity Date
     C                   MOVE      ACSQ          EXACSQ
     C                   MOVE      '01'          EXACS1
     C                   EVAL      EXTRTY = ATYP
     C                   EVAL      EXTRST = STYP
     C                   EVAL      EXCLAS = *BLANK                                            CDL038
     C                   EVAL      EXPRFC = PRFC
     C                   EVAL      EXDDAT = BJRDNB
     C                   EVAL      EXVDAT = BJRDNB
     C                   EVAL      EXMDAT = BJRDNB
 
      ** Set Maturity Date Schedules
     C                   EXSR      SRSetMatSch
 
      ** Initialise Fixed/Variable Rate indicator, Base Rate, Rate/Spread, Interest
      ** Rate, Yield Rate
     C                   EVAL      EXRATE = *BLANKS
     C                   EVAL      EXBRTE = *ZEROS
     C                   EVAL      EXRTSP = *ZEROS
     C                   EVAL      EXINTR = *ZEROS
     C                   EVAL      EXYLDR = *ZEROS
 
      ** Set Next Interest Pay Details
     C                   EVAL      EXNIMT = *ZEROS
     C                   EVAL      EXNIMB = *ZEROS
     C                   EVAL      EXNIM1 = *ZEROS
     C                   EVAL      EXNIM2 = *ZEROS
     C                   EVAL      EXNIDT = *ZEROS
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
 
      ** Set Next Principal Pay Details
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
 
      ** Set Facility Details
     C                   EVAL      EXFCUS = *BLANKS
     C                   IF        FACT <> 0
     C                   MOVE      CNUM          EXFCUS
     C                   ENDIF
     C                   MOVE      FACT          EXFTYP
     C                   MOVE      FCNO          EXFCNO
 
      ** Write record to Extract File
 
     C                   WRITE     MRTRAPD0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetAcCdD - Subroutine that Gets Account Code Details       *
      *                                                               *
      *****************************************************************
     C     SRGetAcCdD    BEGSR
 
     C                   CALLB     'MXACSACOD'
      /COPY MXCPYSRC,MXACSPRME
 
     C                   IF        ACS_RTCD = '*ERROR '
     C                   EVAL      I#ERMS = 'Invalid Account Code: ' + I#LFD1
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      SDACOD = InData
 
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
     C                   EVAL      DBASE = 3
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
     C                   EVAL      DBASE = 4
     C                   OUT       LDA
     C                   EXSR      *PSSR
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
     C                   EVAL      DBASE = 5
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
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
     C                   EVAL      DBPGM = 'MRACCTEXT'
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
     C                   EXSR      SRGetRepPrm
 
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
 
      *                                                                                       CRN001
      **Keyfields on REACR                                                                    CRN001
      *                                                                                       CRN001
     C     KREACR        KLIST                                                                CRN001
     C                   KFLD                    CNUM                                         CRN001
     C                   KFLD                    CCY                                          CRN001
     C                   KFLD                    ACOD                                         CRN001
     C                   KFLD                    ACSQ                                         CRN001
     C                   KFLD                    BRCA                                         CRN001
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
(c) Finastra International Limited 2004
