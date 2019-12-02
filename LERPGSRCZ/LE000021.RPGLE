     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Initialisation program for CAS016')           *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000021 - Lending Initialisation program for CAS016         *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. CLE071             Date 18Jul18               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE154             Date 06Aug12               *
      *                 CLE141             Date 08Feb16               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CLE139             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CAS016  *CREATE    Date 28Feb06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  CLE071 - Value Dating of Rate Changes to Fees (Recompile)    *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE154 - Loan Repayment Schedule Enhancement (Recompile)     *
      *  CLE141 - Currency and Location Business Day Convention       *
      *           (Recompile)                                         *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CLE139 - Lending Fee Capitalisation (Recompile)              *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CAS016 - IAS18 EIR Recalculation (Fee Amortisation Over      *
      *           Whole Period)                                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Function of Indicators                                       *
      *                                                               *
      *  LR - Last record indicator (program termination)             *
      *  U7 and U8 - DB error processing indicator                    *
      *                                                               *
      *****************************************************************
      /SPACE
      *****************************************************************
      *                                                               *
      *  Subroutine Index                                             *
      *                                                               *
      *  SrProcCFs  - Process in generating historic cashflows        *
      *  SrProcHist - Process history files                           *
      *  SrReadHist - Read history file of current loan               *
      *  SrReadPD   - Read PD record of the current loan              *
      *  SrReadMR   - Read MR record of the current loan              *
      *  SrLoanDtl  - Check Loan detail for PD records not generated  *
      *                 due to grace days.                            *
      *  SrCrtHisCF - Generate cash flows for existing historic       *
      *                 amount details                                *
      *  SrCrtMRrec - Generate cash flows for MR events               *
      *  SrCrtRErec - Generate cash flows for RE events               *
      *  SrCrtPDrec - Generate cash flows for Past Due events         *
      *  SrProcFeCL - Process in updating loan and fee files          *
      *  SrPopFeeCL - Populate LEFEED and CLOANCL                     *
      *  SrAudit    - Write Audit Report                              *
      *  SrIntCalc  - Calculate Interest Amount                       *
      *  SrZDate2   - Convert day number to date                      *
      *  *PSSR      - Program exception error routine                 *
      *  *INZSR     - Initial First Cycle processing                  *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FCLOANL8   UF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(CL_)
     F                                     COMMIT
      ** Loans File

     FLECFLSL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Midas LE Cash Flows Using All-in-Rate

     FLEFEEDL1  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Fees File

     FLEHISTL9  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(HS_)
     F                                     RENAME(HISTSHMF:HISTSHM5)
     F                                     IGNORE(HISTSHNF)
     F                                     RENAME(HISTSHPF:HISTSHP5)
     F                                     RENAME(HISTSHQF:HISTSHQ5)
      ** Midas LE N/M/P/Q History Files - MR's with EXVD>0 omitted

     FLEHISTL10 IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(MR_)
      ** Midas LE N/M/P/Q History Files - MR's with EXVD>0

     FLELAUPL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(PD_)
      ** Midas LE Loan Amendment Detail(Past Due)

      ** Midas LE Loan Amendments File  - RE records
     FLELAUPL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LOAMSDKF:LOAMSD2)
     F                                     PREFIX(RE)

     FSDLOANL3  IF   E           K DISK    INFSR(*PSSR)
      ** Loan Type/subtype file

     FSDFEEL0   IF   E           K DISK    INFSR(*PSSR)
      ** Fee Codes File

     FLEFHSTL0  IF   E           K DISK    INFSR(*PSSR)
      ** Fee history file

     FLE000021AUO    E             PRINTER
      ** Lending Transactions Initialisation Audit Report
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short Data Structure for Access programs

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details

     D SDHEDG        E DS                  EXTNAME(SDHEDGPD)
      ** External data structure for the Hedging ICD

     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details

     D PSDS           SDS
      ** Program Status Data Structure

     D  ##PGM            *PROC
     D  JOB                  244    253
     D  WSID                 244    246
     D  USER                 254    263

      ** Work fields
     D wCPAM           S                   LIKE(CL_CPAM)
     D wIPRD           S                   LIKE(CL_IPRD)
     D wAIAP           S                   LIKE(CL_AIAP)
     D wACCR           S                   LIKE(CL_AITC)
     D wREVDate        S                   LIKE(CL_VDAT)
     D wMRVDate        S                   LIKE(CL_VDAT)
     D wPDVDate        S                   LIKE(CL_VDAT)
     D wHSVDate        S                   LIKE(CL_VDAT)
     D wBegDate        S                   LIKE(CL_VDAT)
     D wEndDate        S                   LIKE(CL_VDAT)
     D EndOfProc       S              1A   INZ('N')
     D wRecalHist      S              1A   INZ('N')
     D wSTREC          S              1A   INZ('N')
     D WCLREC          S              1A   INZ('N')
     D wMRREC          S              1A   INZ('N')
     D wREREC          S              1A   INZ('N')
     D wPDREC          S              1A   INZ('N')
     D wHSREC          S              1A   INZ('N')
     D WFacility       S              5S 0
     D WFeeCode        S              2A
     D WrkPDInd        S              1A
     D WDump           S              1A
     D @RtCd           S              7A
     D @Optn           S              7A
     D BIS@            S             80
     D KyVDAT          S              5P 0

      ** ZDATE2 parameters
     D PDayNoIn        S              5  0
     D PDateOut        S              6  0
     D PADate          S              7A

      ** Parameters for calling GLINTC
     D pZIBEG          S              5  0
     D pZIEND          S              5  0
     D pZICALC         S              1  0
     D pZIAMT          S             15  0
     D pZIRATE         S             11  7
     D pZINTR          S             30  9

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - Main Processing                                        *
      *                                                               *
      *****************************************************************

      ** Read all records in loans file

     C     *LOVAL        SETLL     CLOANL8
     C                   READ      CLOANL8
     C                   DOW       NOT %EOF(CLOANL8)
     C                   EXSR      SrProcCFs
     C                   READ      CLOANL8
     C                   ENDDO

      ** Populate CLOANCL and LEFEED

     C                   EXSR      SrProcFeCL

     C                   COMMIT
     C                   EVAL      *INLR = *ON

      ** Write File Controls Report.

     C                   EXSR      SrAudit

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrProcCFs  - Process in generating historic cashflows        *
      *                                                               *
      *****************************************************************
     C     SrProcCFs     BEGSR

     ** Initilialise workfields
     C                   EVAL      EndOfProc = 'N'
     C                   EVAL      wCPAM = *ZEROS
     C                   EVAL      wACCR = *ZEROS
     C                   EVAL      wIPRD = *ZEROS
     C                   EVAL      wAIAP = *ZEROS
     C                   EVAL      wSTRec = 'N'

      ** Get and check loan details for repayment sked
     C                   EXSR      SrLoanDtl

      ** Read History Records of the loan
     C                   EVAL      wHSVDate = *HIVAL
     C     CL_LNRF       SETLL     LEHISTL9
     C                   EXSR      SrReadHist

      ** Read Loan Amendments to check for existing Past Dues for the loan
     C                   EVAL      wPDVDate = *HIVAL
     C     CL_LNRF       SETLL     LOAMSDKF
     C                   EXSR      SrReadPD

      ** Read Loan Amendments to check for existing Repayments to be PDs
     C                   EVAL      wREVDate = *HIVAL
     C     KyLoan        SETLL     LOAMSD2
     C                   EXSR      SRReadRE

      ** Read Manual Repayments for Past Dues
     C                   EVAL      wMRVDate = *HIVAL
     C     CL_LNRF       SETLL     LEHISTL10
     C                   EXSR      SrReadMR

      ** Process history records without payments gone past due
     C                   EXSR      SrProcHist

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrProcHist - Process history files                           *
      *                                                               *
      *****************************************************************
     C     SrProcHist    BEGSR

     C                   DOW       EndOfProc = 'N'

     C                   SELECT

      ** Process history records

     C                   WHEN      wHSRec = 'Y'
     C                             AND wHSVDate <= wPDVDate
     C                             AND wHSVDate <= wMRVDate
     C                             AND wHSVDate <= wREVDate
     C                   EXSR      SrCrtHisCF
     C                   EXSR      SrReadHist

      ** Process history records

     C                   WHEN      wRERec = 'Y'
     C                             AND wREVDate <= wHSVDate
     C                             AND wREVDate <= wMRVDate
     C                             AND wREVDate <= wPDVDate
     C                   EXSR      SrCrtRErec

      ** Process history records when there are existing PD records for the loan

     C                   WHEN      wPDRec = 'Y'
     C                             AND wPDVDate <= wHSVDate
     C                             AND wPDVDate <= wMRVDate
     C                             AND wPDVDate <= wREVDate
     C                   EXSR      SrCrtPDrec
     C                   EXSR      SrReadPD

      ** Process Manual Repayment Record

     C                   WHEN      wMRRec = 'Y'
     C                             AND wMRVDate <= wHSVDate
     C                             AND wMRVDate <= wPDVDate
     C                             AND wMRVDate <= wREVDate
     C                   EXSR      SrCrtMRrec
     C                   EXSR      SrReadMR

     C                   ENDSL

      ** End process

     C                   IF        wCLRec = 'N'
     C                             AND wHSRec = 'N'
     C                             AND wPDRec = 'N'
     C                             AND wMRRec = 'N'
     C                             AND wRERec = 'N'
     C                   EVAL      EndOfProc = 'Y'
     C                   ENDIF
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrReadHist - Read history file of current loan               *
      *                                                               *
      *****************************************************************
     C     SrReadHist    BEGSR

     C     CL_LNRF       READE     LEHISTL9
     C                   IF        NOT %EOF(LEHISTL9)
     C                   EVAL      wHSRec = 'Y'
     C                   EVAL      wHSVDate = HS_VDAT
     C                   IF        HS_AMTP = 'ST'
     C                   EVAL      wSTRec = 'Y'
     C                   ENDIF
     C                   ELSE
     C                   EVAL      wHSRec = 'N'
     C                   EVAL      wHSVDate = *HIVAL
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrReadPD   - Read PD record of the current loan              *
      *                                                               *
      *****************************************************************
     C     SrReadPD      BEGSR

     C     CL_LNRF       READE     LOAMSDKF
     C                   IF        NOT %EOF(LELAUPL1)
     C                             AND wSTRec = 'Y'
     C                   EVAL      wPDRec = 'Y'
     C                   EVAL      wPDVDate = PD_VDAT
     C                   ELSE
     C                   EVAL      wPDRec = 'N'
     C                   EVAL      wPDVDate = *HIVAL
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRReadRE - Read RE record in Loan Amendments file             *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRReadRE      BEGSR

     C     CL_LNRF       READE     LOAMSD2
     C                   IF        NOT %EOF(LELAUPL2)
     C                             AND wSTRec = 'Y'
     C                   EVAL      wRERec = 'Y'
     C                   EVAL      wREVDate = REVDAT
     C                   ELSE
     C                   EVAL      wRERec = 'N'
     C                   EVAL      wREVDate = *HIVAL
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrReadMR   - Read MR record of the current loan              *
      *                                                               *
      *****************************************************************
     C     SrReadMR      BEGSR

     C     CL_LNRF       READE     LEHISTL10
     C                   IF        NOT %EOF(LEHISTL10)
     C                             AND wSTRec = 'Y'
     C                   EVAL      wMRRec = 'Y'
     C                   EVAL      wMRVDate = MR_EXVD
     C                   ELSE
     C                   EVAL      wMRRec = 'N'
     C                   EVAL      wMRVDate = *HIVAL
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrLoanDtl  - Check Loan detail for PD records not generated  *
      *                 due to grace days.                            *
      *                                                               *
      *****************************************************************
     C     SrLoanDtl     BEGSR

     C                   EVAL      wREVDate = *HIVAL
     C                   IF        CL_AUTO = 'N'
     C                   EVAL      wREVDate = CL_NRPD

      ** Check if the repayment should value irregardless of grace days

     C                   IF        wREVDate > BJRDNB
     C                   EVAL      wREVDate = *HIVAL
     C                   EVAL      wRERec = 'N'
     C                   ELSE
     C                   EVAL      wRERec = 'Y'
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCrtHisCF - Generate cash flows for existing historic       *
      *                 amount details                                *
      *                                                               *
      *****************************************************************
     C     SrCrtHisCF    BEGSR

     C                   CLEAR                   LECFLSD0

     C                   EVAL      LFLNRF = HS_LNRF
     C                   EVAL      LFFSEQ = *ZERO
     C                   EVAL      LFLTYP = HS_LTYP
     C                   EVAL      LFLNST = HS_SUTP
     C                   EVAL      LFFLDT = HS_VDAT

     C                   EVAL      LFDATE = *BLANKS
     C                   EVAL      PDayNoIn = HS_VDAT
     C                   EXSR      SrZDate2
     C                   MOVE      PADate        LFDATE
     C                   EVAL      LFCAMT = HS_PRAM

     C                   SELECT

     C                   WHEN      HS_AMTP = 'ST'
     C                   IF        HS_PTYP = 66 OR
     C                             HS_PTYP = 67 OR
     C                             HS_PTYP = 69
     C                   EVAL      LFFTYP = 'SSAM'
     C                   ELSE
     C                   EVAL      LFFTYP  = 'SAMT'
     C                   ENDIF

     C                   WHEN      HS_AMTP = 'PI'
     C                   IF        HS_PTYP = 66 OR
     C                             HS_PTYP = 69
     C                   EVAL      LFFTYP = 'SPIN'
     C                   ELSE
     C                   EVAL      LFFTYP = 'PINC'
     C                   ENDIF

     C                   WHEN      HS_AMTP = 'RE'
     C                   IF        HS_PTYP = 66 OR
     C                             HS_PTYP = 69
     C                   EVAL      LFFTYP = 'SSRP'
     C                   ELSE
     C                   EVAL      LFFTYP = 'SRPY'
     C                   ENDIF

     C                   WHEN      HS_AMTP = 'MR'
     C                   IF        HS_PTYP = 66 OR
     C                             HS_PTYP = 67 OR
     C                             HS_PTYP = 69
     C                   EVAL      LFFTYP = 'SRPA'
     C                   ELSE
     C                   EVAL      LFFTYP = 'RPAY'
     C                   ENDIF

     C                   WHEN      HS_AMTP = 'PF'
     C                   IF        HS_PTYP = 66 OR
     C                             HS_PTYP = 67 OR
     C                             HS_PTYP = 69
     C                   EVAL      LFFTYP = 'SPTF'
     C                   ELSE
     C                   EVAL      LFFTYP = 'PTFA'
     C                   ENDIF

     C                   WHEN      HS_AMTP = 'PT'
     C                   IF        HS_PTYP = 66 OR
     C                             HS_PTYP = 67 OR
     C                             HS_PTYP = 69
     C                   EVAL      LFFTYP = 'SPTT'
     C                   ELSE
     C                   EVAL      LFFTYP = 'PTTA'
     C                   ENDIF

     C                   WHEN      HS_AMTP = 'IN'
     C                   IF        HS_PTYP = 66 OR
     C                             HS_PTYP = 69
     C                   EVAL      LFFTYP = 'SINT'
     C                   ELSE
     C                   EVAL      LFFTYP = 'INTP'
     C                   ENDIF

     C                   WHEN      HS_AMTP = 'MA'
     C                   IF        HS_PTYP = 66 OR
     C                             HS_PTYP = 67 OR
     C                             HS_PTYP = 69
     C                   EVAL      LFFTYP = 'SMAM'
     C                   ELSE
     C                   EVAL      LFFTYP = 'MAMT'
     C                   ENDIF

     C                   WHEN      HS_AMTP = 'RO'
     C                   EVAL      LFFTYP = 'ROPR'
     C                   EVAL      LFCAMT = HS_CPAM

     C                   WHEN      HS_AMTP = 'BR'
     C                             OR HS_AMTP = 'SC'
     C                             OR HS_AMTP = 'BC'
     C                   EVAL      LFCAMT = 0
     C                   ENDSL

     C                   IF        HS_AMTP = 'ST' OR
     C                             HS_AMTP = 'PI' OR
     C                             HS_AMTP = 'PT'
     C                   EVAL      LFIOIN = 'O'
     C                   ELSE
     C                   IF        HS_AMTP = 'RO'
     C                   EVAL      LFIOIN = 'S'
     C                   ELSE
     C                   EVAL      LFIOIN = 'I'
     C                   ENDIF
     C                   ENDIF

     C                   IF        CL_LRLD  <> *ZERO
     C                   EVAL      LFNDYP = CL_LRLD - BJRDNB
     C                   ELSE
     C                   EVAL      LFNDYP = CL_VDAT - BJRDNB
     C                   ENDIF
     C                   EVAL      LFICBS = CL_ICBS

      ** Calculation methods are:

     C                   SELECT

      ** 1 Actual/365, 4 365/365 (excluding 29/02)

     C                   WHEN      CL_ICBS = 1 OR
     C                             CL_ICBS = 4
     C                   EVAL      LFNDYY = 365

      ** 2 Actual/360, 3 360/360 (sometimes called 30/360), 5 365/360 (excluding 29/02)

     C                   WHEN      CL_ICBS = 2 OR
     C                             CL_ICBS = 3 OR
     C                             CL_ICBS = 5
     C                   EVAL      LFNDYY = 360

      ** 6 Actual/366

     C                   WHEN      CL_ICBS = 6
     C                   EVAL      LFNDYY = 366

     C                   ENDSL

     C                   EVAL      LFIRAT = HS_INTR
     C                   EVAL      LFCNUM = HS_CNUM
     C                   EVAL      LFBRCA = HS_BRCA
     C                   EVAL      LFCYCD = HS_CCY
     C                   EVAL      LFBKCD = CL_BOKC

     C                   EVAL      LFCPAM = CL_CPAM
     C                   EVAL      LFYLDC = CL_FSYLDC
     C                   EVAL      LFFYLD = CL_FSFYLD
     C                   EVAL      LFSPRR = CL_RTSP

     C                   IF        LFCAMT <> *ZERO
     C                   WRITE     LECFLSD0
     C                   EVAL      WCountCF = WCountCF + 1
     C                   ENDIF

      ** Write separate cash flow record for Interest Amount

     C                   IF        HS_INTA <> *ZERO
     C                             AND HS_RCDT = 'D'
     C                   IF        WrkPDind = 'Y'
     C                   EVAL      wEndDate = HS_VDAT
     C                   EVAL      pZIRATE = HS_INTR
     C                   EVAL      pZIAMT  = HS_CPAM
     C                   EXSR      SrIntCalc
     C                   EVAL      LFCAMT = HS_INTA + wACCR
     C                   ELSE
     C                   EVAL      LFCAMT = HS_INTA
     C                   ENDIF

     C                   EVAL      LFFTYP = 'INTP'
     C                   WRITE     LECFLSD0
     C                   EVAL      WCountCF = WCountCF + 1
     C                   ENDIF

     C                   IF        HS_AMTP = 'RO'
     C                             AND HS_AITC > HS_IPRD
     C                   EVAL      LFCAMT = HS_AITC - HS_IPRD
     C                   EVAL      LFFTYP = 'ROIN'
     C                   WRITE     LECFLSD0
     C                   ENDIF
      *

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCrtMRrec - Generate cash flows for MR events               *
      *                                                               *
      *****************************************************************
     C     SrCrtMRrec    BEGSR

     C                   CLEAR                   LECFLSD0

     C                   EVAL      LFLNRF = MR_LNRF
     C                   EVAL      LFFSEQ = *ZERO
     C                   EVAL      LFLTYP = MR_LTYP
     C                   EVAL      LFLNST = MR_SUTP
     C                   EVAL      LFFLDT = MR_VDAT

     C                   EVAL      LFDATE = *BLANKS
     C                   EVAL      PDayNoIn = MR_VDAT
     C                   EXSR      SrZDate2
     C                   MOVE      PADate        LFDATE
     C                   EVAL      LFCAMT = MR_PRAM

     C                   IF        MR_PTYP = 66 OR
     C                             MR_PTYP = 67 OR
     C                             MR_PTYP = 69
     C                   EVAL      LFFTYP = 'SRPA'
     C                   ELSE
     C                   EVAL      LFFTYP = 'RPAY'
     C                   ENDIF

     C                   IF        MR_AMTP = 'ST' OR
     C                             MR_AMTP = 'PI' OR
     C                             MR_AMTP = 'PT'
     C                   EVAL      LFIOIN = 'O'
     C                   ELSE
     C                   EVAL      LFIOIN = 'I'
     C                   ENDIF

     C                   IF        CL_LRLD  <> *ZERO
     C                   EVAL      LFNDYP = CL_LRLD - BJRDNB
     C                   ELSE
     C                   EVAL      LFNDYP = CL_VDAT - BJRDNB
     C                   ENDIF
     C                   EVAL      LFICBS = CL_ICBS

      ** Calculation methods are:

     C                   SELECT

      ** 1 Actual/365, 4 365/365 (excluding 29/02)

     C                   WHEN      CL_ICBS = 1 OR
     C                             CL_ICBS = 4
     C                   EVAL      LFNDYY = 365

      ** 2 Actual/360, 3 360/360 (sometimes called 30/360), 5 365/360 (excluding 29/02)

     C                   WHEN      CL_ICBS = 2 OR
     C                             CL_ICBS = 3 OR
     C                             CL_ICBS = 5
     C                   EVAL      LFNDYY = 360

      ** 6 Actual/366

     C                   WHEN      CL_ICBS = 6
     C                   EVAL      LFNDYY = 366

     C                   ENDSL

     C                   EVAL      LFIRAT = MR_INTR
     C                   EVAL      LFCNUM = MR_CNUM
     C                   EVAL      LFBRCA = MR_BRCA
     C                   EVAL      LFCYCD = MR_CCY
     C                   EVAL      LFBKCD = CL_BOKC

     C                   EVAL      LFCPAM = CL_CPAM
     C                   EVAL      LFYLDC = CL_FSYLDC
     C                   EVAL      LFFYLD = CL_FSFYLD
     C                   EVAL      LFSPRR = CL_RTSP

     C                   IF        LFCAMT <> *ZERO
     C                   WRITE     LECFLSD0
     C                   EVAL      WCountCF = WCountCF + 1
     C                   ENDIF

      ** Write separate cash flow record for Interest Amount

     C                   IF        MR_INTA <> *ZERO
     C                   IF        WrkPDind = 'Y'
     C                   EVAL      wEndDate = MR_VDAT
     C                   EVAL      pZIRATE = MR_INTR
     C                   EVAL      pZIAMT  = MR_CPAM
     C                   EXSR      SrIntCalc
     C                   EVAL      LFCAMT = MR_INTA + wACCR
     C                   ELSE
     C                   EVAL      LFCAMT = MR_INTA
     C                   ENDIF

     C                   EVAL      LFFTYP = 'INTP'
     C                   WRITE     LECFLSD0
     C                   EVAL      WCountCF = WCountCF + 1
     C                   ENDIF

      ** Update date for the recalculation of history

     C                   EVAL      wRecalHist = 'Y'

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCrtRErec - Generate cash flows for RE events               *
      *                                                               *
      *****************************************************************
     C     SrCrtRErec    BEGSR

     C                   CLEAR                   LECFLSD0

     C                   EVAL      LFLNRF = CL_LNRF
     C                   EVAL      LFFSEQ = *ZERO
     C                   EVAL      LFLTYP = CL_LTYP
     C                   EVAL      LFLNST = CL_SUTP
     C                   EVAL      LFFLDT = CL_VDAT

     C                   EVAL      LFDATE = *BLANKS
     C                   EVAL      PDayNoIn = CL_VDAT
     C                   EXSR      SrZDate2
     C                   MOVE      PADate        LFDATE
     C                   EVAL      LFCAMT = CL_CPAM

     C                   IF        CL_PTYP = 66 OR
     C                             CL_PTYP = 69
     C                   EVAL      LFFTYP = 'SSRP'
     C                   ELSE
     C                   EVAL      LFFTYP = 'SRPY'
     C                   ENDIF

     C                   EVAL      LFIOIN = 'I'

     C                   IF        CL_LRLD  <> *ZERO
     C                   EVAL      LFNDYP = CL_LRLD - BJRDNB
     C                   ELSE
     C                   EVAL      LFNDYP = CL_VDAT - BJRDNB
     C                   ENDIF
     C                   EVAL      LFICBS = CL_ICBS

      ** Calculation methods are:

     C                   SELECT

      ** 1 Actual/365, 4 365/365 (excluding 29/02)

     C                   WHEN      CL_ICBS = 1 OR
     C                             CL_ICBS = 4
     C                   EVAL      LFNDYY = 365

      ** 2 Actual/360, 3 360/360 (sometimes called 30/360), 5 365/360 (excluding 29/02)

     C                   WHEN      CL_ICBS = 2 OR
     C                             CL_ICBS = 3 OR
     C                             CL_ICBS = 5
     C                   EVAL      LFNDYY = 360

      ** 6 Actual/366

     C                   WHEN      CL_ICBS = 6
     C                   EVAL      LFNDYY = 366

     C                   ENDSL

     C                   EVAL      LFIRAT = CL_INTR
     C                   EVAL      LFCNUM = CL_CNUM
     C                   EVAL      LFBRCA = CL_BRCA
     C                   EVAL      LFCYCD = CL_CCY
     C                   EVAL      LFBKCD = CL_BOKC

     C                   EVAL      LFCPAM = CL_CPAM
     C                   EVAL      LFYLDC = CL_FSYLDC
     C                   EVAL      LFFYLD = CL_FSFYLD
     C                   EVAL      LFSPRR = CL_RTSP

     C                   IF        LFCAMT <> *ZERO
     C                   WRITE     LECFLSD0
     C                   EVAL      WCountCF = WCountCF + 1
     C                   ENDIF

      ** Update indicator for recalculation of history

     C                   EVAL      wRecalHist = 'Y'
     C                   EVAL      wRERec = 'N'
     C                   EVAL      wREVDate = *HIVAL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCrtPDrec - Generate cash flows for Past Due events         *
      *                                                               *
      *****************************************************************
     C     SrCrtPDrec    BEGSR

     C                   CLEAR                   LECFLSD0
     C                   EVAL      LFLNRF = PD_LNRF
     C                   EVAL      LFFSEQ = *ZERO
     C                   EVAL      LFLTYP = PD_LTYP
     C                   EVAL      LFLNST = PD_SUTP
     C                   EVAL      LFFLDT = PD_VDAT

     C                   EVAL      LFDATE = *BLANKS
     C                   EVAL      PDayNoIn = PD_VDAT
     C                   EXSR      SrZDate2
     C                   MOVE      PADate        LFDATE
     C                   EVAL      LFCAMT = PD_PRAM

     C                   IF        PD_PTYP = 66 OR
     C                             PD_PTYP = 67 OR
     C                             PD_PTYP = 69
     C                   EVAL      LFFTYP = 'SRPA'
     C                   ELSE
     C                   EVAL      LFFTYP = 'RPAY'
     C                   ENDIF

     C                   EVAL      LFIOIN = 'I'

     C                   IF        CL_LRLD  <> *ZERO
     C                   EVAL      LFNDYP = CL_LRLD - BJRDNB
     C                   ELSE
     C                   EVAL      LFNDYP = CL_VDAT - BJRDNB
     C                   ENDIF
     C                   EVAL      LFICBS = CL_ICBS

      ** Calculation methods are:

     C                   SELECT

      ** 1 Actual/365, 4 365/365 (excluding 29/02)

     C                   WHEN      CL_ICBS = 1 OR
     C                             CL_ICBS = 4
     C                   EVAL      LFNDYY = 365

      ** 2 Actual/360, 3 360/360 (sometimes called 30/360), 5 365/360 (excluding 29/02)

     C                   WHEN      CL_ICBS = 2 OR
     C                             CL_ICBS = 3 OR
     C                             CL_ICBS = 5
     C                   EVAL      LFNDYY = 360

      ** 6 Actual/366

     C                   WHEN      CL_ICBS = 6
     C                   EVAL      LFNDYY = 366

     C                   ENDSL

     C                   EVAL      LFIRAT = PD_RTSP
     C                   EVAL      LFCNUM = PD_CNUM
     C                   EVAL      LFBRCA = PD_BRCA
     C                   EVAL      LFCYCD = PD_CCY
     C                   EVAL      LFBKCD = CL_BOKC

     C                   EVAL      LFCPAM = CL_CPAM
     C                   EVAL      LFYLDC = CL_FSYLDC
     C                   EVAL      LFFYLD = CL_FSFYLD
     C                   EVAL      LFSPRR = CL_RTSP

     C                   IF        LFCAMT <> *ZERO
     C                   WRITE     LECFLSD0
     C                   EVAL      WCountCF = WCountCF + 1
     C                   ENDIF

      ** Write separate cash flow record for Interest Amount

     C                   IF        PD_INTA <> *ZERO
     C                   EVAL      wEndDate = PD_VDAT
     C                   EVAL      pZIRATE = PD_RTSP
     C                   EVAL      pZIAMT  = PD_INTA
     C                   EXSR      SrIntCalc
     C                   EVAL      LFCAMT = PD_INTA + wACCR
     C                   EVAL      LFFTYP = 'INTP'
     C                   WRITE     LECFLSD0
     C                   EVAL      WCountCF = WCountCF + 1
     C                   ENDIF

      ** Update date for the recalculation of history

     C                   EVAL      wRecalHist = 'Y'

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrProcFeCL - Process in updating loan and fee files          *
      *                                                               *
      *****************************************************************
     C     SrProcFeCL    BEGSR

      ** Read Loan Type/Sub Type file that will do amortise accounting

     C     *LOVAL        SETLL     SDLOANL3
     C                   READ      SDLOANL3

     C                   DOW       NOT %EOF(SDLOANL3)

     C     KLoanType     SETLL     CLOANL8
     C     KLoanType     READE     CLOANL8

      ** Read thru Loans file

     C                   DOW       NOT %EOF(CLOANL8)

      ** Process when loan value date is on or after the cut-off date

     C                   IF        CL_VDAT >= FSNLAC AND
     C                             CL_RECI = 'D'
     C                   EXSR      SrPopFeeCL
     C                   ENDIF

     C     KLoanType     READE     CLOANL8
     C                   ENDDO

     C                   READ      SDLOANL3
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrPopFeeCL - Populate LEFEED and CLOANCL                     *
      *                                                               *
      *****************************************************************
     C     SrPopFeeCL    BEGSR

      ** Initialise key fields

     C                   EVAL      CL_TFDP  = CL_TOTI
     C                   EVAL      CL_TFDPA = CL_TOTI
     C                   EVAL      CL_TFAM  = CL_TOTI
     C                   EVAL      CL_TFAC  = CL_TOTI
     C                   EVAL      CL_TFOF  = CL_TOTI
     C                   EVAL      CL_DSAM  = CL_TOTI

     C     KyFee         SETLL     LEFEEDL1
     C     KyFee         READE     LEFEEDL1
     C                   DOW       NOT %EOF(LEFEEDL1)

      ** Total Fees/Discount/Premium

     C                   IF        FESDAT < BJRDNB
     C                   EVAL      CL_TFDP = CL_TFDP + FEFAMT
     C                   EVAL      CL_TFAM = CL_TFAM + FEFAMT
     C                   EVAL      CL_TFAC = *ZERO
     C                   EVAL      CL_TFOF = *ZERO
     C                   ENDIF

      ** Check if Fee code is defined as having an
      ** Adjustment to Yield as 'Y'

     C                   MOVE      FEFCOD        WFeeCode
     C     WFeeCode      CHAIN     SDFEEL0
     C                   IF        %FOUND(SDFEEL0) AND
     C                             AUADJY = 'Y'

      ** Total Fees/Discount/Premium Adjustmnet to Yield

     C                   EVAL      CL_TFDPA = CL_TFDPA + FEFAMT

     C                   IF        CL_DDAT <= FEPSTD AND
     C                             CL_MDAT >= FEPSTD
     C                   EVAL      FEAMRI = 'N'
     C                   EVAL      FESTPD = BJRDNB
     C                   EVAL      FEENPD = CL_MDAT

     C                   UPDATE    LEFEEDF
     C                   EVAL      WCountFE = WCountFE + 1
     C                   ENDIF

     C                   ENDIF

     C     KyFee         READE     LEFEEDL1
     C                   ENDDO

      ** Access Fee History file

     C     CL_LNRF       SETLL     LEFHSTL0
     C     CL_LNRF       READE     LEFHSTL0
     C                   DOW       NOT %EOF(LEFHSTL0)

      ** Total Fees/Discount/Premium

     C                   EVAL      CL_TFDP = CL_TFDP + FEFAMT
     C     CL_LNRF       READE     LEFHSTL0
     C                   ENDDO

     C                   UPDATE    CLOANCLF

      ** Increment counter only if fields are initialised with values

     C                   EVAL      WCountCL = WCountCL + 1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrAudit    - Write Audit Report                              *
      *                                                               *
      *****************************************************************
     C     SrAudit       BEGSR

      ** Write File Control Report Heading

     C                   WRITE     HEADAU

     C                   IF        WCountCF <> 0 OR
     C                             WCountFE <> 0 OR
     C                             WCountCL <> 0
     C                   WRITE     CONTROL

     C                   ELSE
     C                   WRITE     NODTLS
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrIntCalc  - Calculate Interest Amount                       *
      *                                                               *
      *****************************************************************
     C     SrIntCalc     BEGSR

     C                   EVAL      wACCR = *ZERO
     C                   IF        wBegDate <> wEndDate
     C                   Z-ADD     CL_ICBS       pZICALC
     C                   Z-ADD     wBegDate      pZIBEG
     C                   Z-ADD     wEndDate      pZIEND

     C                   CALL      'GLINTC'
     C                   PARM                    pZIBEG
     C                   PARM                    pZIEND
     C                   PARM                    pZICALC
     C                   PARM                    pZIAMT
     C                   PARM                    pZIRATE
     C                   PARM                    pZINTR
     C                   EVAL(H)   wACCR = pZINTR
     C                   Z-ADD     wEndDate      wBegDate
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrZDate2   - Convert day number to date                      *
      *                                                               *
      *****************************************************************
     C     SrZDate2      BEGSR

     C                   CALL      'ZDATE2'
     C                   PARM                    PDayNoIn
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         PDateOut
     C                   PARM      *BLANK        PADate

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR     - Initial First Cycle processing                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C                   MOVEA     CPY@          BIS@

      **  Set up Local Data Area (LDA)

     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   EVAL      DbFile = *BLANKS
     C                   EVAL      DbKey  = *BLANKS
     C                   EVAL      DbPgm  = *BLANKS
     C                   EVAL      DbPgm  = 'LE000021'
     C                   EVAL      DBase  = *ZERO
     C                   OUT       LDA

      ** Access Bank details

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSFDY

      ** If not found, database error

     C                   IF        @RtCd <>  *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DbFile = 'SDBANKPD'
     C                   EVAL      DBase  = 1
     C                   EVAL      DbKey  = @Optn
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access Object for Hedge ICD

     C                   CALL      'AOHEDGR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDHEDG        PARM      SDHEDG        DSFDY

     C                   IF        @RtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DbFile = 'SDHEDGPD'
     C                   EVAL      DBase = 2
     C                   EVAL      DbKey = @Optn
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      WCountCF = *ZERO
     C                   EVAL      WCountFE = *ZERO
     C                   EVAL      WCountCL = *ZERO
     C                   EVAL      WFacility = *ZERO

      ** Key List for Fees File

     C     KyFee         KLIST
     C                   KFLD                    CL_CNUM
     C                   KFLD                    WFacility
     C                   KFLD                    CL_LNRF

      ** Key List for Loan types/subtypes file

     C     KLoanType     KLIST
     C                   KFLD                    AYLNTY
     C                   KFLD                    AYLNST

      ** Key Lists for History amount detail

     C     KyHist1       KLIST
     C                   KFLD                    CL_BRCA
     C                   KFLD                    CL_CNUM
     C                   KFLD                    CL_LNRF
     C                   KFLD                    KyVDAT

     C     KyHist2       KLIST
     C                   KFLD                    CL_BRCA
     C                   KFLD                    CL_CNUM
     C                   KFLD                    CL_LNRF

     C     KyLoan        KLIST
     C                   KFLD                    CL_LNRF
     C                   KFLD                    BJRDNB

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR      - Program exception error routine                 *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        WDump = *BLANKS
     C                   EVAL      WDump = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP

      ** Write File Control Report Heading

     C                   WRITE     HEADAU

      ** Write Database error

     C                   WRITE     DBERROR

     C                   RETURN

     C                   ENDIF

     C                   ENDSR
      ****************************************************************
** CPY@
(c) Finastra International Limited 2006
