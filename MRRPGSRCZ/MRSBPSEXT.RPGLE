     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
      *****************************************************************
      *                                                               *
      *  Midas - MidasPlus Reporting module                           *
      *                                                               *
      *  RPGLE/MRSBPSEXT - Securities Book Position Extract           *
      *                                                               *
      *  Function:  This module will read BKPHDD as an input primary  *
      *             file.  For each required record from BKPHDD, a    *
      *             record will be written to file MRTRAPPD.          *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MRSEFIX  *CREATE   Date 05Jan06               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MRSEFIX - Add Securities Trading to MR                       *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Book Position Headers
     FBKPHD     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(BH_)

      ** Book Positions
     FBKPOS     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(BP_)

      ** Securities
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(SE_)

      ** Investment Types
     FINVTP     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(IN_)

      ** Reporting Parameters
     FMRRPRMPD  IF   E             DISK    INFSR(*PSSR)

      ** Transactions Report File
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
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
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
                                                                                              CRN001
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D @RUN            S              1
                                                                                              CRN001
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
     D PAcKyPos01      S              3
     D PAcKyPos04      S              1
     D PAcKyPos05      S              1
     D PAcKyPos07      S              2
     D PAcKyPos13      S              1
     D PAcKyPos19      S              2
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
     D I#ERMS          S             60

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

     C                   READ      BKPHDDF

     C                   DOW       NOT %EOF(BKPHD  )

      ** Process live records only
     C                   IF        BH_RECI = 'D'
     C                   IF        BH_BHTV = 'V'
     C                   EXSR      SRGetPosition
     C                   IF        Ext_Position = 'Y'
     C                   EXSR      SRProcess
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   READ      BKPHDDF

     C                   ENDDO

     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetPosition - Subroutine                                   *
      *                                                               *
      *****************************************************************
     C     SRGetPosition BEGSR

     C                   MOVE      'Y'           Ext_Position      1

      * Get security details

     C     BH_BHSC       CHAIN     SECTYDF                            99        *

      * Ignore if security not found or if deleted or matured

     C     *IN99         IFEQ      '1'
     C     SE_RECI       OREQ      '*'
     C     SE_MATY       ORNE      *ZERO
     C     SE_MATY       ANDLT     WkECDat
     C                   EVAL      Ext_Position = 'N'
     C                   GOTO      EEXTRCT
     C                   ENDIF
      *
      * Get investment type details
      *
     C     INVTPK        KLIST
     C                   KFLD                    SE_NMCY
     C                   KFLD                    SE_SITP
     C     INVTPK        CHAIN     INVTPDF                            99        *

      * Ignore if investment type not found or if deleted

     C     *IN99         IFEQ      '1'
     C     IN_RECI       OREQ      '*'
     C                   EVAL      Ext_Position = 'N'
     C                   GOTO      EEXTRCT
     C                   ENDIF
      *
      * Get further position details needed from BKPOSD
      *
     C     BKPOSK        KLIST
     C                   KFLD                    BH_BHSC
     C                   KFLD                    BH_BHBA
     C                   KFLD                    BH_BHBK
     C                   KFLD                    BH_BHMK
     C                   KFLD                    BH_BHTV
     C                   KFLD                    BH_LPSD

      *  Obtain the current position

     C     BKPOSK        CHAIN     BKPOS                              99
     C     *IN99         IFEQ      '1'
     C     BP_RECI       OREQ      '*'
     C     BP_NPSN       OREQ      *ZERO
     C     BP_ECNP       ANDEQ     *ZERO
     C                   EVAL      Ext_Position = 'N'
     C                   GOTO      EEXTRCT
     C                   ENDIF

     C     EEXTRCT       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcess - Subroutine                                       *
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
     C                   EVAL      EXMOD = 'SE'

      ** Set Sub-Module
     C                   EVAL      EXSUB = 'SBPS'

      ** Set Transaction Id
     C                   EVAL      EXTRID = BH_BHSC + '-' + BH_BHBK + '-' +
     C                                      BH_BHMK

      ** Set Sequence Number
     C                   EVAL      EXSEQ = 0

      ** Set Transaction Status (EXSTAT)
     C                   EXSR      SRSetTrStat

      ** Set On/Off Balance Sheet
     C                   EVAL      EXBALS = '1'

      ** Set Branch Details (EXBRCH, EXBICN)
     C                   EXSR      SRSetBrcDet

      ** Set Customer Details (EXCUSN, EXCCIT, EXCLOC, EXCIND, EXCINT, EXCBNK
      ** EXCSWF)
     C                   EXSR      SRSetCusDet

      ** Set Parent Details (EXPARN, EXPCIT, EXPLOC, EXPIND, EXPINT, EXPBNK
      ** EXPSWF)
     C     BBPCNB        IFNE      *BLANK
     C                   EXSR      SRSetParDet
     C                   ENDIF

      ** Set Currency Details (EXCYCD, EXEBRT, EXMDIB, EXERP1, EXMDI1,
      ** EXERP2, EXMDI2)
     C                   EXSR      SRSetCurDet

      ** Set FX Contract and Valuation Rates
     C                   EVAL      EXCNRT = 0
     C                   EVAL      EXVLRT = 0

      ** Set Principal Asset/Liability Indicator, Sign and DR/CR indicator
     C                   IF        BP_NPSN >= 0
     C                   EVAL      EXPALI = 'A'
     C                   Z-ADD     1             EXPSGN
     C                   Z-ADD     0             EXPDCI
     C                   ELSE
     C                   Z-SUB     BP_NPSN       BP_NPSN                                     MRSEFIX
     C                   EVAL      EXPALI = 'L'
     C                   Z-SUB     1             EXPSGN
     C                   Z-ADD     1             EXPDCI
     C                   ENDIF

      ** Set Principal Account Key (EXPACC, EXPACS, EXPREF)
     C                   EXSR      SRSetPrAcKy

      ** Set Principal Amounts (EXPAMT, EXPMTB, EXPMT1, EXPMT2)
     C                   EXSR      SRSetPrnAmt

      ** Set Accrued Interest Sign and DR/CR indicator
     C                   EVAL      EXASGN = 1
     C                   EVAL      EXADCI = 0

      ** Set Accrued Interest Account Key (EXAACC, EXAACS, EXAREF,
      ** Set Interst Inc./Exp. Account Key (EXIACC, EXIACS, EXIREF)
     C                   EXSR      SRSetAIAcKy

      ** Set Accrued Interest Amounts (EXAAMT, EXAMTB, EXAMT1, EXAMT2)
     C                   EXSR      SRSetAInAmt

      ** Set Unearned Disc/Prem Sign and DR/CR ind
     C                   EVAL      EXESGN = -1
     C                   EVAL      EXEDCI =  1

      ** Set Unearned Disc/Prem Account Key (EXEACC, EXEACS, EXAEEF,
      ** Set Disc./Prem. Account Key (EXDACC, EXDACS, EXDREF)
     C                   EXSR      SRSetDsAcKy

      ** Set Unearned Discount Amounts (EXEAMT, EXEMTB, EXEMT1, EXEMT2)
     C                   EXSR      SRSetDscAmt

      ** Initialise Unrealised P/L A/c Details
     C                   EVAL      EXUSGN = *ZERO
     C                   EVAL      EXUDCI = *ZERO
     C                   EVAL      EXUACC = *BLANKS
     C                   EVAL      EXUACS = *BLANKS
     C                   EVAL      EXUREF = *BLANKS
     C                   EVAL      EXUAMT = *ZEROS
     C                   EVAL      EXUMTB = *ZEROS
     C                   EVAL      EXUMT1 = *ZEROS
     C                   EVAL      EXUMT2 = *ZEROS

      ** Initialise the rest of the Interest Inc./Exp. Details
     C                   EVAL      EXIAMT = *ZEROS
     C                   EVAL      EXIMTB = *ZEROS
     C                   EVAL      EXIMT1 = *ZEROS
     C                   EVAL      EXIMT2 = *ZEROS

      ** Initialise Disc/Prem Inc/Exp Amount Details
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
     C                   MOVEL     '01'          EXACSQ
     C                   MOVEL     '01'          EXACS1
     C                   EVAL      EXTRTY = SE_NMCY
     C                   EVAL      EXTRST = SE_SITP
     C                   EVAL      EXPRFC = *BLANK
     C                   EVAL      EXDDAT = *ZERO
     C                   EVAL      EXVDAT = *ZERO

      ** Set Maturity Date and Date Schedules (EXMDAT, EXMDT0 to EXMDT9)
     C                   EXSR      SRSetMatSch

      ** Set Fixed/Variable Rate indicator, Base Rate, Rate/Spread, Interest
      ** Rate, Yield Rate
     C                   EVAL      EXRATE = 'F'

     C                   EVAL      EXBRTE = *ZEROS
     C                   EVAL      EXRTSP = SE_CPNR
     C                   EVAL      EXINTR = SE_CPNR
     C                   EVAL      EXYLDR = *ZERO

      ** Set Next Interest Pay Date/Amount and Date Schedules
      ** (EXNIDT, EXNIMT, EXNID0 to EXNID9)
     C                   EXSR      SRSetNInSch

      ** Set Next Interest Pay Amount (EXNIMT, EXNIMB, EXNIM1, EXNIM2)
     C                   EXSR      SRSetNAmSch

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

      ** Initialise Facility Details
     C                   EVAL      EXFCUS = *BLANKS
     C                   EVAL      EXFTYP = *BLANKS
     C                   EVAL      EXFCNO = *BLANKS
                                                                                         CRN001
     C                   EVAL      EXBOOK = BH_BHBK                                           CRN001

      ** Write record to output file
     C                   WRITE     MRTRAPD0

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetNAmSch - Subroutine that Sets Next Interest Pay Amount  *
      *                                                               *
      *****************************************************************
     C     SRSetNAmSch   BEGSR

     C                   EVAL      EXNIMT = *ZEROS

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

      ** Determine the Next Interest Pay Date to be written to MRTRAPPD
     C                   EVAL      EXNIDT = 0

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

      ** If the Next Interest Pay Date to be written to MRTRAPPD is not zero,
      ** determine Date Schedules
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
      *  SRSetMatSch - Subroutine that Sets Maturity Date - Date      *
      *                Schedules                                      *
      *                                                               *
      *****************************************************************
     C     SRSetMatSch   BEGSR

     C                   EVAL      EXMDAT = SE_MATY

     C                   EVAL      PaRepDt = WkECDat
     C                   EVAL      PaSchDt = SE_MATY

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
      *  SRSetAInAmt - Subroutine that Sets Accrued Interest Amounts  *
      *                                                               *
      *****************************************************************
     C     SRSetAInAmt   BEGSR

     C                   EVAL      WkTAmt = BH_ARPC
     C                   EXSR      SRCvtAmounts
     C                   EVAL(H)   EXAAMT = WkTAmt/(10**A6NBDP)
     C                   EVAL(H)   EXAMTB = WkAmtInB/(10**WkNBDPB)
     C                   EVAL(H)   EXAMT1 = WkAmtIn1/(10**WkNBDP1)
     C                   EVAL(H)   EXAMT2 = WkAmtIn2/(10**WkNBDP2)

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetDscAmt - Subroutine that Sets Discount Amounts          *
      *                                                               *
      *****************************************************************
     C     SRSetDscAmt   BEGSR

     C                   EVAL      WkTAmt = BH_DPAP
     C                   EXSR      SRCvtAmounts
     C                   EVAL(H)   EXEAMT = WkTAmt/(10**A6NBDP)
     C                   EVAL(H)   EXEMTB = WkAmtInB/(10**WkNBDPB)
     C                   EVAL(H)   EXEMT1 = WkAmtIn1/(10**WkNBDP1)
     C                   EVAL(H)   EXEMT2 = WkAmtIn2/(10**WkNBDP2)

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

      ** Get Accrued Interest Amount in Base Currency
     C                   Z-ADD     WkTAmt        ZAMTCI
     C                   EVAL      ZEXCH = A6SPRT
     C                   EVAL      ZMD = A6MDIN
     C                   EVAL      ZCCYI = SE_NMCY
     C                   EVAL      ZCCYO = WkCYCDB
     C                   EVAL      ZCDPI = A6NBDP
     C                   EVAL      ZCDPO = WkNBDPB
     C                   EXSR      SRGetAmount
     C                   Z-ADD     ZAMTCO        WkAmtInB

      ** Get Principal Amount in Reporting Currency 1
     C                   EVAL      ZEXCH = EXERP1
     C                   EVAL      ZMD = EXMDI1
     C                   EVAL      ZCCYO = WkCYCD1
     C                   EVAL      ZCDPO = WkNBDP1
     C                   EXSR      SRGetAmount
     C                   Z-ADD     ZAMTCO        WkAmtIn1

      ** Get Principal Amount in Reporting Currency 2
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
      *  SRSetPrnAmt - Subroutine that Sets Principal Amounts         *
      *                                                               *
      *****************************************************************
     C     SRSetPrnAmt   BEGSR

     C                   IF        PAcKyPos19 = 'FV'
     C                   Z-ADD     100           ZPRC
     C                   ELSE
     C                   Z-ADD     BH_LAVP       ZPRC
     C                   ENDIF

      * Determine current book value

     C                   CALLB     'ZCNSD'
     C                   PARM      BP_NPSN       ZNOML            15 0
     C                   PARM                    ZPRC             16 9
     C                   PARM      SE_SPBS       W#SPBS            1
     C                   PARM      SE_NMDP       W#NMDP            1 0
     C                   PARM      A6NBDP        W#NCDP            1 0
     C                   PARM      *ZERO         ZCONS            15 0

     C                   Z-ADD     ZCONS         WkTAmt

     C                   EXSR      SRCvtAmounts
     C                   EVAL(H)   EXPAMT = WkTAmt/(10**A6NBDP)
     C                   EVAL(H)   EXPMTB = WkAmtInB/(10**WkNBDPB)
     C                   EVAL(H)   EXPMT1 = WkAmtIn1/(10**WkNBDP1)
     C                   EVAL(H)   EXPMT2 = WkAmtIn2/(10**WkNBDP2)

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

     C                   EVAL      I#LFD1 = SE_NMCY

     C                   CALLB     'MXACSCURR'
      /COPY MXCPYSRC,MXACSPRME

     C                   IF        ACS_RTCD = '*ERROR '
     C                   EVAL      I#ERMS = 'INVALID CURRENCY: ' + I#LFD1
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      SDCURR = InData

     C                   EVAL      EXCYCD = SE_NMCY
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

     C                   MOVEL     SE_ISSR       PCust

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

     C                   MOVE      SE_ISSR       EXCUSN
     C                   EVAL      EXCCIT = BBCNCZ
     C                   EVAL      EXCLOC = BBCOLC
     C                   EVAL      EXCIND = BBLICD
     C                   EVAL      EXCINT = BBLINC
     C                   EVAL      EXCBNK = BBBNBI
     C                   EVAL      EXCSWF = BBSWFI

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetParDet - Subroutine that Sets Parent Details            *
      *                                                               *
      *****************************************************************
     C     SRSetParDet   BEGSR

     C                   MOVEL     BBPCNB        PCust

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

     C                   MOVEL     BBCUST        EXPARN
     C                   EVAL      EXPCIT = BBCNCZ
     C                   EVAL      EXPLOC = BBCOLC
     C                   EVAL      EXPIND = BBLICD
     C                   EVAL      EXPINT = BBLINC
     C                   EVAL      EXPBNK = BBBNBI
     C                   EVAL      EXPSWF = BBSWFI

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetBrcDet - Subroutine that Sets Branch Details            *
      *                                                               *
      *****************************************************************
     C     SRSetBrcDet   BEGSR

     C                   EVAL      I#LFD1 = BH_BHBA

     C                   CALLB     'MXACSBRCH'
      /COPY MXCPYSRC,MXACSPRME

     C                   IF        ACS_RTCD = '*ERROR '
     C                   EVAL      I#ERMS = 'ERROR IN FORMAT MXACSBRCH'
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      SDBRCH = InData

     C                   EVAL      EXBRCH = A8BRCD
     C                   EVAL      EXBICN = A8BICN

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
     C                   EVAL      DBASE = 6
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetDsAcKy - Subroutine that Sets Accrued Discount Account  *
      *                Key                                            *
      *                                                               *
      *****************************************************************
     C     SRSetDsAcKy   BEGSR

     C                   EVAL      EXEACC = *BLANKS
     C                   EVAL      EXEACS = *BLANKS
     C                   EVAL      EXEREF = *BLANKS
     C                   EVAL      EXDACC = *BLANKS
     C                   EVAL      EXDACS = *BLANKS
     C                   EVAL      EXDREF = *BLANKS

     C                   EVAL      PAcKyPos01 = BH_INVT
     C                   EVAL      PAcKyPos04 = 'A'
     C                   EVAL      PAcKyPos05 = ' '
     C                   EVAL      PAcKyPos07 = BH_BHBK
     C                   EVAL      PAcKyPos13 = 'S'

      ** If discount amount is GREATER than zero, position is carrying a discount
     C                   IF        BH_BUDU  > 0
     C                   EVAL      PAcKyPos19 = 'DA'

     C                   EXSR      SRGetAcKeyD

     C                   EVAL      EXEACC = PAcCodDR1
     C                   EVAL      EXEACS = PAcSecDR1
     C                   EVAL      EXEREF = PPosRfDR1
     C                   EVAL      EXDACC = PAcCodCR1
     C                   EVAL      EXDACS = PAcSecCR1
     C                   EVAL      EXDREF = PPosRfCR1
     C                   ELSE

      ** If discount amount is LESS than zero, position is carrying a premium
     C                   IF        BH_BUDU  < 0
     C                   EVAL      PAcKyPos19 = 'PA'

     C                   EXSR      SRGetAcKeyD

     C                   EVAL      EXEACC = PAcCodCR1
     C                   EVAL      EXEACS = PAcSecCR1
     C                   EVAL      EXEREF = PPosRfCR1
     C                   EVAL      EXDACC = PAcCodDR1
     C                   EVAL      EXDACS = PAcSecDR1
     C                   EVAL      EXDREF = PPosRfDR1
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetAIAcKy - Subroutine that Sets Accrued Interest Account  *
      *                Key                                            *
      *                                                               *
      *****************************************************************
     C     SRSetAIAcKy   BEGSR

     C                   EVAL      PAcKyPos01 = BH_INVT
     C                   EVAL      PAcKyPos04 = 'A'
     C                   EVAL      PAcKyPos05 = ' '
     C                   EVAL      PAcKyPos07 = BH_BHBK
     C                   EVAL      PAcKyPos13 = 'S'
     C                   EVAL      PAcKyPos19 = 'AI'

     C                   EXSR      SRGetAcKeyD

     C                   EVAL      EXAACC = PAcCodDR1
     C                   EVAL      EXAACS = PAcSecDR1
     C                   EVAL      EXAREF = PPosRfDR1
     C                   EVAL      EXIACC = PAcCodCR1
     C                   EVAL      EXIACS = PAcSecCR1
     C                   EVAL      EXIREF = PPosRfCR1
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

     C                   EVAL      PAcKyPos01 = BH_INVT
     C                   EVAL      PAcKyPos04 = 'V'
     C                   EVAL      PAcKyPos05 = 'P'
     C                   EVAL      PAcKyPos07 = BH_BHBK
     C                   EVAL      PAcKyPos13 = 'S'
     C                   EVAL      PAcKyPos19 = 'CO'

     C                   EXSR      SRGetAcKeyD

     C                   EVAL      EXPACC = PAcCodDR1
     C                   EVAL      EXPACS = PAcSecDR1
     C                   EVAL      EXPREF = PPosRfDR1

     C                   IF        EXPREF = ' '
     C                   EVAL      PAcKyPos19 = 'FV'
     C                   EXSR      SRGetAcKeyD
     C                   EVAL      EXPACC = PAcCodDR1
     C                   EVAL      EXPACS = PAcSecDR1
     C                   EVAL      EXPREF = PPosRfDR1
     C                   ENDIF

     C                   IF        EXPREF = '4'
     C                   EVAL      EXPREF = '3'
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetAcKeyD - Subroutine that Retrieves Account Key Details  *
      *                                                               *
      *****************************************************************
     C     SRGetAcKeyD   BEGSR

     C                   CALLB     'MRACSSAKY'
     C                   PARM                    PAcKyPos01
     C                   PARM                    PAcKyPos04
     C                   PARM                    PAcKyPos05
     C                   PARM                    PAcKyPos07
     C                   PARM                    PAcKyPos13
     C                   PARM                    PAcKyPos19

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
      *****************************************************************
      *                                                               *
      *  SRSetTrStat - Subroutine that Sets Transaction Status field  *
      *                                                               *
      *****************************************************************
     C     SRSetTrStat   BEGSR

      ** Set Transaction Status
     C                   EVAL      EXSTAT = *BLANKS

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

     C     *DTAARA       DEFINE                  RUNDAT
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

     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'

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
