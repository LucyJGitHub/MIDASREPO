     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE EIR History Update')                          *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending module                              *
      *                                                               *
      *  LE000401 - LE Effective Interest Rate History Update         *
      *                                                               *
      *  Function:  This program will rebuild Loan's history and      *
      *             will update cash flow file.                       *
      *                                                               *
      *  Called By: LEC000401                                         *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE154             Date 07Aug12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 AR751137           Date 30May11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CAS019A            Date 26Jul07               *
      *                 CAS016  *CREATE    Date 28Feb06               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data.    *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE154 - Loan Repayment Schedule Enhancement (Recompile)     *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  AR751137 -  EIR becomes zero after change of base rate.      *
      *              LEHTRxPD files corruption of records when a non- *
      *              auto settle loan with 0 NRPD is processed.       *
      *              (Child: Artf751970)                              *
      *  CAS019A - CAS016 Upgrade to Midasplus-Alphanumeric Customer  *
      *  CAS016 - IAS18 EIR Recalculation (Fee Amortisation Over      *
      *           Whole Period)                                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of Indicator                           *
      *    98         Date Format                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
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

      ** Midas SD Loan types/sub-types
     FSDLOANL3  IF   E           K DISK

      ** Midas LE Customer Loans
     FCLOANL8   IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(CL)

      ** Midas LE Loan Amendments File  - PD records
     FLELAUPL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(PD)

      ** Midas LE Loan Amendments File  - RE records
     FLELAUPL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LOAMSDKF:LOAMSD2)
     F                                     PREFIX(RE)

      ** Midas LE N/M/P/Q History Files - MR's with EXVD>0 omitted
     FLEHISTL5  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(HS)
     F                                     RENAME(HISTSHMF:HISTSHM5)
     F                                     RENAME(HISTSHNF:HISTSHN5)
     F                                     RENAME(HISTSHPF:HISTSHP5)
     F                                     RENAME(HISTSHQF:HISTSHQ5)

      ** Midas LE N/M/P/Q History Files - MR's with EXVD>0
     FLEHISTL6  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(MR)

      ** Midas EIR Cash Flow File
     FLECFLSL0  UF   E           K DISK    INFSR(*PSSR)

      ** Midas LE EIR Loan Header History File
     FLEHTRMPD  O  A E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(HT)

      ** Midas LE EIR Loan Interest History File
     FLEHTRNPD  O  A E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(HT)

      ** Midas LE EIR Loan amount History File
     FLEHTRPPD  O  A E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(HT)

      ** Midas LE EIR Rate History File
     FLEHTRQPD  O  A E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(HT)

      ****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      ** Array containing Copyright statement

      ** +--------------------------------------+
      ** ¦ External data areas                  ¦
      ** ¦ ===================                  ¦
      ** +--------------------------------------+

     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)

      ** Program Status Data Structure
      /COPY ZACPYSRC,PSDS

      ** First DS for Access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Second DS for Access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External data structure for Module Details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)

      ** External data structure for Branch Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)

      ** External data structure for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      **  External DS for General Ledger Details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)

      ** Whether or not *PSSR has been run previously
     D RunBefore       S              1A

      ** Parameters for AOBANKR0
     D pReturnCode     S              7A
     D pOption         S              7A

      ** Parameters for calling EU0200
     D PRTCD           S              7A
     D PFRAM           S             18  3
     D PFRCY           S              3A
     D PTOCY           S              3A
     D POUTA           S             15  0
     D PINTA           S             18  3
     D PEXRT           S             15  9
     D PMDIN           S              1A

      ** Parameters for calling GLINTC
     D pZIBEG          S              5  0
     D pZIEND          S              5  0
     D pZICALC         S              1  0
     D pZIAMT          S             15  0
     D pZIRATE         S             11  7
     D pZINTR          S             30  9

      ** Work Variables
     D wCPAM           S                   LIKE(CLCPAM)
     D wIPRD           S                   LIKE(CLIPRD)
     D wAIAP           S                   LIKE(CLAIAP)
     D wACCR           S                   LIKE(CLAITC)
     D wICTD           S                   LIKE(CLICTD)
     D wPrinAmt        S                   LIKE(HSPRAM)
     D wCLVDate        S                   LIKE(CLVDAT)
     D wREVDate        S                   LIKE(CLVDAT)
     D wMRVDate        S                   LIKE(CLVDAT)
     D wPDVDate        S                   LIKE(CLVDAT)
     D wHSVDate        S                   LIKE(CLVDAT)
     D wBegDate        S                   LIKE(CLVDAT)
     D wEndDate        S                   LIKE(CLVDAT)
     D wEvCD           S                   LIKE(CLVDAT)
     D EndOfProc       S              1A   INZ('N')
     D wRecalHist      S              1A   INZ('N')
     D wSTREC          S              1A   INZ('N')
     D wCLREC          S              1A   INZ('N')
     D wREREC          S              1A   INZ('N')
     D wMRREC          S              1A   INZ('N')
     D wPDREC          S              1A   INZ('N')
     D wHSREC          S              1A   INZ('N')
     D wCFTYP          S                   LIKE(LFFTYP)
     D wCFVDt          S                   LIKE(LFFLDT)
     D wCFSeq          S                   LIKE(LFPSeq)

     ******************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - Main Processing                                        *
      *                                                               *
      *****************************************************************

      ** Read Deal Type/Sub Type combinations to index deals file
     C     *LOVAL        SETLL     SDLOANL3
     C                   READ      SDLOANL3

     C                   DOW       NOT %EOF(SDLOANL3)

     C     KLoanType     SETLL     CLOANL8
     C     KLoanType     READE     CLOANL8

      ** Read thru Loans file
     C                   DOW       NOT %EOF(CLOANL8)

     ** Initilialise workfields
     C                   EVAL      EndOfProc = 'N'
     C                   EVAL      wCPAM = *ZEROS
     C                   EVAL      wACCR = *ZEROS
     C                   EVAL      wIPRD = *ZEROS
     C                   EVAL      wAIAP = *ZEROS
     C                   EVAL      wICTD = *ZEROS
     C                   EVAL      wSTRec = 'N'
     C                   EVAL      wRecalHist = 'N'

      ** Get and check loan details for repayment sked
     C                   EXSR      SRLoanDetail

      ** Read History Records of the loan
     C                   EVAL      wHSVDate = *HIVAL
     C     CLLNRF        SETLL     LEHISTL5
     C                   EXSR      SRReadHist

      ** Read Loan Amendments to check for existing Past Dues for the loan
     C                   EVAL      wPDVDate = *HIVAL
     C     CLLNRF        SETLL     LOAMSDKF
     C                   EXSR      SRReadPD

      ** Read Loan Amendments to check for existing Repayments to be PDs
     C                   EVAL      wREVDate = *HIVAL
     C     KLoanDate     SETLL     LOAMSD2
     C                   EXSR      SRReadRE

      ** Read Manual Repayments for Past Dues
     C                   EVAL      wMRVDate = *HIVAL
     C     CLLNRF        SETLL     LEHISTL6
     C                   EXSR      SRReadMR

      ** Process history records without payments gone past due
     C                   EXSR      SRProcHist

     C     KLoanType     READE     CLOANL8

     C                   ENDDO
     C                   READ      SDLOANL3
     C                   ENDDO

      ** End of program
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProcHist - Process history records                          *
      *                                                               *
      * Called by: SRCheckPD                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRProcHist    BEGSR

     C                   DOW       EndOfProc = 'N'

     C                   SELECT
      ** Process history records
     C                   WHEN      wHSRec = 'Y'
     C                             AND wHSVDate <= wPDVDate
     C                             AND wHSVDate <= wMRVDate
     C                             AND wHSVDate <= wCLVDate
     C                             AND wHSVDate <= wREVDate
     C                   EXSR      SRProcHSRec
      ** Read Next History Records
     C                   EXSR      SRReadHist

      ** Process Loan Detail records
     C                   WHEN      wCLRec = 'Y'
     C                             AND wCLVDate <= wHSVDate
     C                             AND wCLVDate <= wMRVDate
     C                             AND wCLVDate <= wPDVDate
     C                             AND wCLVDate <= wREVDate
     C                   EXSR      SRProcCLRec

      ** Process Loan Amendments records
     C                   WHEN      wRERec = 'Y'
     C                             AND wREVDate <= wHSVDate
     C                             AND wREVDate <= wMRVDate
     C                             AND wREVDate <= wPDVDate
     C                             AND wREVDate <= wCLVDate
     C                   EXSR      SRProcRERec

      ** Read Next RE record
     C                   EXSR      SRReadRE

      ** Process history records when there are existing PD records for the loan
     C                   WHEN      wPDRec = 'Y'
     C                             AND wPDVDate <= wHSVDate
     C                             AND wPDVDate <= wMRVDate
     C                             AND wPDVDate <= wCLVDate
     C                             AND wPDVDate <= wREVDate
     C                   EXSR      SRProcPDRec

      ** Read Next Past Due Record
     C                   EXSR      SRReadPD

     C                   WHEN      wMRRec = 'Y'
     C                             AND wMRVDate <= wHSVDate
     C                             AND wMRVDate <= wPDVDate
     C                             AND wMRVDate <= wCLVDate
     C                             AND wMRVDate <= wREVDate
     C                   EXSR      SRProcMRRec

      ** Read Next Manual Repayment Record
     C                   EXSR      SRReadMR
     C                   ENDSL

      ** Save date for interest recalculation
     C                   EVAL      wBegDate = HTVDAT

      ** End process if
     C                   IF        wCLRec = 'N'
     C                             AND wRERec = 'N'
     C                             AND wHSRec = 'N'
     C                             AND wPDRec = 'N'
     C                             AND wMRRec = 'N'
     C                             AND wCLRec = 'N'
     C                   EVAL      EndOfProc = 'Y'
     C                   ENDIF

     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      * SRProcHSRec - Write and recalculate history record if PD rec  *
      *               exist for the loan                              *
      *                                                               *
      * Called by: SRProcHist                                         *
      *                                                               *
      * Calls: SRRecalHist                                            *
      *                                                               *
      *****************************************************************
     C     SRProcHSRec   BEGSR

     C                   IF        wRecalHist = 'Y'

      ** Recalculate History records for the new Principal/Interest Amount
     C                   EXSR      SRRecalHist

     C                   ELSE
     C                   EVAL      HTPRAM = HSPRAM
     C                   EVAL      HTCPAM = HSCPAM
     C                   EVAL      HTAITC = HSAITC
     C                   EVAL      HTINTA = HSINTA
     C                   EVAL      HTIPRD = HSIPRD
     C                   EVAL      HTAIAP = HSAIAP
     C                   ENDIF

     C                   IF        HSAMTP = 'ST'
     C                   EVAL      wBegDate = HSVDAT
     C                   ENDIF

      ** Populate fields with history data

     C                   SELECT
     C                   WHEN      HSRCDT = 'A'
     C                   EXSR      SRPopHTRM
     C                   WRITE     ZAHTRMD0
     C                   WHEN      HSRCDT = 'H'
     C                   EXSR      SRPopHTRN
     C                   WRITE     ZAHTRND0
     C                   WHEN      HSRCDT = 'D'
     C                   EXSR      SRPopHTRP
     C                   WRITE     ZAHTRPD0
     C                   WHEN      HSRCDT = 'E'
     C                   EXSR      SRPopHTRQ
     C                   WRITE     ZAHTRQD0
     C                   ENDSL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProcPDRec - Check if loan has PD record.                    *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRProcPDRec   BEGSR

      ** Recalculate History records for the new PD record
     C                   EVAL      wEndDate = PDVDAT
     C                   EXSR      SRIntCalc
     C                   EVAL      HTAITC = HTAITC + wACCR

      ** Write record in history for 'PD' before next history record
     C                   EVAL      HTRCDT = 'D'
     C                   EVAL      HTVDAT = PDVDAT
     C                   EVAL      HTEXVD = PDVDAT
     C                   EVAL      HTAMTP = 'PD'
     C                   EVAL      HTPRAM = PDPRAM
     C                   EVAL      HTINTA = PDINTA

     C                   IF        PDPRAM > 0
     C                   EVAL      HTCPAM = HTCPAM - PDPRAM
     C                   ENDIF
     C                   IF        PDINTA > 0
     C                   IF        PDINTC <> 'Y'
     C                   EVAL      HTIPRD = HTIPRD + HTINTA
     C                   ELSE
     C                   EVAL      HTCPAM = HTCPAM + HTINTA
     C                   EVAL      wICTD = wICTD + HTINTA
     c                   ENDIF
     C                   ENDIF

      ** Update date for the recalculation of history
     C                   EVAL      wRecalHist = 'Y'

     C                   WRITE     ZAHTRPD0

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProcMRRec - Check if loan has MR record.                    *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRProcMRRec   BEGSR

      ** Update date for the recalculation of history
     C                   EVAL      wEndDate = MREXVD
     C                   EXSR      SRIntCalc
     C                   EVAL      HTAITC = HTAITC + wACCR

      ** Write record in history for 'MR' before next history record
     C                   EVAL      HTRCDT = 'D'
     C                   EVAL      HTVDAT = MREXVD
     C                   EVAL      HTEXVD = MREXVD
     C                   EVAL      HTAMTP = 'MR'

      ** Update date for the recalculation of history
     C                   IF        MRPRAM > 0
     C                   EVAL      HTPRAM = MRPRAM
     C                   EVAL      HTCPAM = HTCPAM - MRPRAM
     C                   ENDIF
     C                   IF        MRINTA > 0
     C                   EVAL      HTINTA = MRINTA
     C                   IF        HTINTC <> 'Y'
     C                   EVAL      HTIPRD = HTIPRD + HTINTA
     C                   ELSE
     C                   EVAL      HTCPAM = HTCPAM + HTINTA
     C                   EVAL      wICTD = wICTD + HTINTA
     c                   ENDIF
     C                   ENDIF

      ** Update indicator for recalculation of history
     C                   EVAL      wRecalHist = 'Y'

     C                   WRITE     ZAHTRPD0

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProcCLRec - Process repayment record in loan details file   *
      *               not yet PD due                                  *
      *                                                               *
      * Called by: SRCheckPD                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRProcCLRec   BEGSR

      ** Update date for the recalculation of history
     C                   EVAL      wEndDate = CLNRPD
     C                   EXSR      SRIntCalc
     C                   EVAL      HTAITC = HTAITC + wACCR

     C                   IF        CLRAMT > 0
     C                   EVAL      HTPRAM = CLRAMT
     C                   ENDIF

      ** Write record in history for 'MR' before next history record
     C                   EVAL      HTRCDT = 'D'
     C                   EVAL      HTVDAT = CLNRPD
     C                   EVAL      HTEXVD = CLNRPD
     C                   EVAL      HTAMTP = 'RE'

      ** Update indicator for recalculation of history
     C                   EVAL      wRecalHist = 'Y'
     C                   EVAL      wCLRec = 'N'
     C                   EVAL      wCLVDate = *HIVAL

     C                   WRITE     ZAHTRPD0

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProcRERec - Process repayment record in Loan Amendments     *
      *               file not yet PD due                             *
      *                                                               *
      * Called by: SRCheckPD                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRProcRERec   BEGSR

     C                   IF        REVDAT <= wEvCD
      ** Update date for the recalculation of history
     C                   EVAL      wEndDate = REVDAT
     C                   EXSR      SRIntCalc
     C                   EVAL      HTAITC = HTAITC + wACCR

      ** Write record in history for 'MR' before next history record
     C                   EVAL      HTRCDT = 'D'
     C                   EVAL      HTVDAT = REVDAT
     C                   EVAL      HTEXVD = REVDAT
     C                   EVAL      HTAMTP = 'RE'

     C                   IF        REPRAM > 0
     C                   EVAL      HTCPAM = HTCPAM - REPRAM
     C                   EVAL      HTPRAM = REPRAM
     C                   ENDIF
     C                   IF        REINTA > 0
     C                   EVAL      HTINTA = REINTA
     C                   IF        REINTC <> 'Y'
     C                   EVAL      HTIPRD = HTIPRD + HTINTA
     C                   ELSE
     C                   EVAL      HTCPAM = HTCPAM + HTINTA
     C                   EVAL      wICTD = wICTD + HTINTA
     c                   ENDIF
     C                   ENDIF

      ** Update date for the recalculation of history
     C                   EVAL      wRecalHist = 'Y'
     C                   EVAL      wRERec = 'Y'
     C                   EVAL      wREVDate = REVDAT

     C                   WRITE     ZAHTRPD0
     C                   ELSE
     C                   EVAL      wRERec = 'N'
     C                   EVAL      wREVDate = *HIVAL
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRecalHist - Process Hiatory Detail for recalculations       *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRRecalHist   BEGSR

      ** Check amendment type then recalculate interest accruals

     C                   SELECT
     C                   WHEN      HSAMTP = 'IN'
     C                   EVAL      wEndDate = HSVDAT
     C                   EXSR      SRIntCalc
      ** Compute for interest payment
     C                   EVAL      HTINTA = wACCR + HTAITC + HTAIAP
     C                                      + CLAIMN - CLIWOD - HTIPRD - wICTD
     C                   EVAL      HTAITC = HTAITC + wACCR

     C                   EXSR      SRCFUpdate

      ** Check if Interest Capitalised

     C                   IF        HSINTC <> 'Y'
     C                   EVAL      HTIPRD = HTIPRD + HSINTA
     C                   ELSE
     C                   EVAL      HTCPAM = HTCPAM + HTINTA
     C                   EVAL      wICTD = wICTD + HTINTA
     C                   ENDIF
     C                   EVAL      HTPRAM = HSPRAM

     C                   WHEN      HSAMTP = 'MI'
     C                   EVAL      wEndDate = HSVDAT
     C                   EXSR      SRIntCalc
     C                   EVAL      HTAITC = HTAITC + wACCR
     C                   EVAL      HTAIAP = HTAIAP + HSINTA
     C                   EVAL      HTPRAM = HSPRAM

     C                   WHEN      HSAMTP = 'PI'
     C                   EVAL      wEndDate = HSVDAT
     C                   EXSR      SRIntCalc
     C                   EVAL      HTAITC = HTAITC + wACCR
     C                   EVAL      HTPRAM = HSPRAM
     C                   EVAL      HTCPAM = HTCPAM + HSPRAM

     C                   WHEN      HSAMTP = 'MA'
     C                   EVAL      wEndDate = HSVDAT
     C                   EXSR      SRIntCalc
      ** Compute for interest payment
     C                   EVAL      HTINTA = wACCR + HTAITC + HTAIAP
     C                                      + CLAIMN - CLIWOD - HTIPRD - wICTD
     C                   EVAL      HTAITC = HTAITC + wACCR
     C                   EVAL      HTPRAM = HTCPAM
     C                   EVAL      HTCPAM = 0

     C                   WHEN      HSAMTP = 'BC' OR HSAMTP = 'BR'
     C                   EVAL      wEndDate = HSVDAT
     C                   EXSR      SRIntCalc
     C                   EVAL      HTAITC = HTAITC + wACCR

     C                   WHEN      HSAMTP = 'SC'
     C                   EVAL      wEndDate = HSVDAT
     C                   EXSR      SRIntCalc
     C                   EVAL      HTAITC = HTAITC + wACCR

     C                   WHEN      HSAMTP = 'RE' OR HSAMTP = 'MR'
     C                   EVAL      wEndDate = HSVDAT
     C                   EXSR      SRIntCalc
     C                   EVAL      HTAITC = HTAITC + wACCR

     C                   IF        HSINTA > 0
     C                   IF        HSINTC <> 'Y'
     C                   EVAL      HTIPRD = HTIPRD + HSINTA
     C                   ELSE
     C                   EVAL      HTCPAM = HTCPAM + HTINTA
     C                   EVAL      wICTD = wICTD + HSINTA
     c                   ENDIF
     C                   ENDIF
     C                   EVAL      HTPRAM = HSPRAM

     C                   WHEN      HSAMTP = 'RO' OR HSAMTP = 'MC'
     C                   EVAL      wEndDate = HSVDAT
     C                   EXSR      SRIntCalc
     C                   EVAL      HTAITC = HTAITC + wACCR

      ** check for change in currency on rollover
     C                   IF        HTCCY <> HSRLCY
     C                             AND HSRLCY <> *BLANKS
     C                   IF        HTAITC > 0
     C                   Z-ADD     HTAITC        PFRAM
     C                   MOVE      HTCCY         PFRCY
     C                   MOVE      HSRLCY        PTOCY
     C                   EXSR      SRConvCcy
     C                   Z-ADD     POUTA         HTAITC
     C                   ENDIF

     C                   IF        HTIPRD > 0
     C                   Z-ADD     HTIPRD        PFRAM
     C                   EXSR      SRConvCcy
     C                   Z-ADD     POUTA         HTIPRD
     C                   ENDIF

     C                   IF        HTAIAP > 0
     C                   Z-ADD     HTAIAP        PFRAM
     C                   EXSR      SRConvCcy
     C                   Z-ADD     POUTA         HTAIAP
     C                   ENDIF

     C                   ENDIF

     C                   IF        HSRLCY <> *BLANKS
     C                   MOVE      HTCCY         PFRCY
     C                   MOVE      HSRLCY        PTOCY
     C                   Z-ADD     HTCPAM        PFRAM
     C                   EXSR      SRConvCcy
     C                   Z-ADD     POUTA         HTCPAM
     C                   ENDIF

     C                   WHEN      HSAMTP = 'IH'
     C                   EVAL      wEndDate = HSVDAT
     C                   EXSR      SRIntCalc
     C                   EVAL      HTINTA = HTAITC + wACCR
     C                   EVAL      HTPRAM = HTCPAM

     C                   ENDSL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRConvCcy - Convert Amount to new currency                    *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRConvCcy     BEGSR

     C                   CALL      'EU0200'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM                    PFRAM
     C                   PARM                    PFRCY
     C                   PARM                    PTOCY
     C                   PARM                    POUTA
     C                   PARM                    PINTA
     C                   PARM                    PEXRT
     C                   PARM                    PMDIN

      ** Handle Error
     C                   IF        PRTCD <> *BLANKS
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRReadHist - Read history file of current loan                *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRReadHist    BEGSR

     C     CLLNRF        READE     LEHISTL5
     C                   IF        NOT %EOF(LEHISTL5)
     C                   EVAL      wHSRec = 'Y'
     C                   EVAL      wHSVDate = HSVDAT
     C                   IF        HSAMTP = 'ST'
     C                   EVAL      HTRECI = HSRECI
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
      * SRReadPD - Read PD record of the current loan                 *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRReadPD      BEGSR

     C     CLLNRF        READE     LOAMSDKF
     C                   IF        NOT %EOF(LELAUPL1)
     C                             AND wSTRec = 'Y'
     C                   EVAL      wPDRec = 'Y'
     C                   EVAL      wPDVDate = PDVDAT
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

     C     CLLNRF        READE     LOAMSD2
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
      * SRReadMR - Read MR record of the current loan                 *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRReadMR      BEGSR

     C     CLLNRF        READE     LEHISTL6
     C                   IF        NOT %EOF(LEHISTL6)
     C                             AND wSTRec = 'Y'
     C                   EVAL      wMRRec = 'Y'
     C                   EVAL      wMRVDate = MREXVD
     C                   ELSE
     C                   EVAL      wMRRec = 'N'
     C                   EVAL      wMRVDate = *HIVAL
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRLoanDetail - Check Loan detail for PD records not generated *
      *                due to grace days.                             *
      *                                                               *
      * Called by: SRCheckPD                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRLoanDetail  BEGSR

     C                   EVAL      wCLVDate = *HIVAL
     C                   IF        CLAUTO = 'N'
     C                   EVAL      wCLVDate = CLNRPD

      ** Check if the repayment should value irregardless of grace days
     C                   IF        wCLVDate > wEvCD
      ** Or if there is no repayment to process                                             AR751137
     C                             OR wCLVDate = 0                                          AR751137
     C                   EVAL      wCLVDate = *HIVAL
     C                   EVAL      wCLRec = 'N'
     C                   ELSE
     C                   EVAL      wCLRec = 'Y'
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCFUpdate - Update Cashflow file                             *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRCFUpdate    BEGSR

     C                   EVAL      wCFSeq = HSPRSQ
     C                   EVAL      wCFVDt = HSVDAT
     C                   IF        HSPTYP = 66
     C                             OR HSPTYP = 69
     C                   EVAL      wCFTYP = 'SINT'
     C                   ELSE
     C                   EVAL      wCFTYP = 'INTP'
     C                   ENDIF
      *
     C     KCFTran       CHAIN     LECFLSL0
     C                   IF        %FOUND(LECFLSL0)
     C                   EVAL      LFCAMT = HTINTA
     C                   UPDATE    LECFLSD0
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRIntCalc - Calculate Interest Amount                         *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRIntCalc     BEGSR

     C                   EVAL      wACCR = 0
     C                   IF        wBegDate <> wEndDate
     C                   Z-ADD     HTINTR        pZIRATE
     C                   Z-ADD     HTCPAM        pZIAMT
     C                   Z-ADD     HTCALC        pZICALC
     C                   Z-ADD     wBegDate      pZIBEG
     C                   Z-ADD     wEndDate      pZIEND

     C                   CALLB     'GLINTC'
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
      * SRPopHTRM  - Populate Loan History Header File                *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRPopHTRM     BEGSR

     C                   EVAL      HTRCDT  =  HSRCDT
     C                   EVAL      HTBRCA  =  HSBRCA
     C**********         EVAL      HTCNUM  =  HSCNUM                                         CAS019A
     C                   MOVEL     HSCNUM        HTCNUM                                      CAS019A
     C                   EVAL      HTTRNO  =  HSLNRF
     C                   EVAL      HTVDAT  =  HSVDAT
     C                   EVAL      HTPRSQ  =  HSPRSQ
     C                   EVAL      HTLASN  =  HSLASN
     C                   EVAL      HTFCUS  =  HSFCUS
     C                   EVAL      HTFTYP  =  HSFTYP
     C                   EVAL      HTFSEQ  =  HSFSEQ
     C                   EVAL      HTPTYP  =  HSPTYP
     C                   EVAL      HTCCY   =  HSCCY
     C                   EVAL      HTAMTP  =  HSAMTP
     C                   EVAL      HTBRTT  =  HSBRTT
     C                   EVAL      HTBRTE  =  HSBRTE
     C                   EVAL      HTRTSP  =  HSRTSP
     C                   EVAL      HTSPIN  =  HSSPIN
     C                   EVAL      HTCALC  =  HSCALC
     C                   EVAL      HTWTIN  =  HSWTIN
     C                   EVAL      HTREPT  =  HSREPT
     C                   EVAL      HTINTC  =  HSINTC
     C                   EVAL      HTLTYP  =  HSLTYP
     C                   EVAL      HTSUTP  =  HSSUTP
     C                   EVAL      HTTOTI  =  HSTOTI
     C                   EVAL      HTFCLB  =  HSFCLB
     C                   EVAL      HTLCD   =  HSLCD
     C                   EVAL      HTINTR  =  HSINTR

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPopHTRN  - Populate Loan History Interest File              *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRPopHTRN     BEGSR

     C                   EVAL      HTRCDT  =  HSRCDT
     C                   EVAL      HTBRCA  =  HSBRCA
     C**********         EVAL      HTCNUM  =  HSCNUM                                         CAS019A
     C                   MOVEL     HSCNUM        HTCNUM                                      CAS019A
     C                   EVAL      HTTRNO  =  HSLNRF
     C                   EVAL      HTVDAT  =  HSVDAT
     C                   EVAL      HTPRSQ  =  HSPRSQ
     C                   EVAL      HTLASN  =  HSLASN
     C                   EVAL      HTFCUS  =  HSFCUS
     C                   EVAL      HTFTYP  =  HSFTYP
     C                   EVAL      HTFSEQ  =  HSFSEQ
     C                   EVAL      HTPTYP  =  HSPTYP
     C                   EVAL      HTCCY   =  HSCCY
     C                   EVAL      HTAMTP  =  HSAMTP
     C                   EVAL      HTBRTT  =  HSBRTT
     C                   EVAL      HTBRTE  =  HSBRTE
     C                   EVAL      HTRTSP  =  HSRTSP
     C                   EVAL      HTSPIN  =  HSSPIN
     C                   EVAL      HTCALC  =  HSCALC
     C                   EVAL      HTSTPG  =  HSSTPG
     C                   EVAL      HTPPIS  =  HSPPIS
     C                   EVAL      HTIPIS  =  HSIPIS
     C                   EVAL      HTIPPS  =  HSIPPS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPopHTRP  - Populate Loan Amount History File                *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRPopHTRP     BEGSR

     C                   EVAL      HTRCDT  =  HSRCDT
     C                   EVAL      HTBRCA  =  HSBRCA
     C**********         EVAL      HTCNUM  =  HSCNUM                                         CAS019A
     C                   MOVEL     HSCNUM        HTCNUM                                      CAS019A
     C                   EVAL      HTTRNO  =  HSLNRF
     C                   EVAL      HTVDAT  =  HSVDAT
     C                   EVAL      HTPRSQ  =  HSPRSQ
     C                   EVAL      HTLASN  =  HSLASN
     C                   EVAL      HTFCUS  =  HSFCUS
     C                   EVAL      HTFTYP  =  HSFTYP
     C                   EVAL      HTFSEQ  =  HSFSEQ
     C                   EVAL      HTPTYP  =  HSPTYP
     C                   EVAL      HTCCY   =  HSCCY
     C                   EVAL      HTAMTP  =  HSAMTP
     C                   EVAL      HTWTXA  =  HSWTXA
     C                   EVAL      HTFEAM  =  HSFEAM
     C                   EVAL      HTFECD  =  HSFECD
     C                   EVAL      HTWOIN  =  HSWOIN
     C                   EVAL      HTEXVD  =  HSEXVD
     C                   EVAL      HTLTYP  =  HSLTYP
     C                   EVAL      HTSUTP  =  HSSUTP
     C                   EVAL      HTLCD   =  HSLCD
     C                   EVAL      HTINTR  =  HSINTR
     C                   EVAL      HTMNSG  =  HSMNSG
     C                   EVAL      HTGASS  =  HSGASS
     C                   EVAL      HTGPRT  =  HSGPRT
     C                   EVAL      HTROLN  =  HSROLN
     C                   EVAL      HTREPI  =  HSREPI

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPopHTRQ  - Populate EIR Loan Rate History File              *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRPopHTRQ     BEGSR

     C                   EVAL      HTRCDT   =  HSRCDT
     C                   EVAL      HTBRCA   =  HSBRCA
     C**********         EVAL      HTCNUM   =  HSCNUM                                        CAS019A
     C                   MOVEL     HSCNUM        HTCNUM                                      CAS019A
     C                   EVAL      HTTRNO   =  HSLNRF
     C                   EVAL      HTVDAT   =  HSVDAT
     C                   EVAL      HTPRSQ   =  HSPRSQ
     C                   EVAL      HTLASN   =  HSLASN
     C                   EVAL      HTFCUS   =  HSFCUS
     C                   EVAL      HTFTYP   =  HSFTYP
     C                   EVAL      HTFSEQ   =  HSFSEQ
     C                   EVAL      HTPTYP   =  HSPTYP
     C                   EVAL      HTCCY    =  HSCCY
     C                   EVAL      HTAMTP   =  HSAMTP
     C                   EVAL      HTBRTT   =  HSBRTT
     C                   EVAL      HTBRTE   =  HSBRTE
     C                   EVAL      HTRTSP   =  HSRTSP
     C                   EVAL      HTSPIN   =  HSSPIN
     C                   EVAL      HTCALC   =  HSCALC
     C                   EVAL      HTSTAI   =  HSSTAI
     C                   EVAL      HTPRINRO =  HSPRINRO
     C                   EVAL      HTDISCRO =  HSDISCRO
     C                   EVAL      HTLCD    =  HSLCD
     C                   EVAL      HTIRCF   =  HSIRCF
     C                   EVAL      HTINTR   =  HSINTR
     C                   EVAL      HTMNSG   =  HSMNSG
     C                   EVAL      HTRLCY   =  HSRLCY

     C                   ENDSR
      *****************************************************************
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

     C     *DTAARA       DEFINE                  LDA

      ** Access Bank ICD
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       pReturnCode
     C                   PARM      '*FIRST '     pOption
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database Error
     C                   IF        pReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DbFile = 'SDBANKPD'
     C                   EVAL      Dbase = 1
     C                   EVAL      DbKey = pOption
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access General Ledger
     C                   CALLB     'AOGELRR0'
     C                   PARM      *BLANKS       pReturnCode
     C                   PARM      '*FIRST '     pOption
     C     SDGELR        PARM      SDGELR        DSFDY

     C                   IF        pReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DbFile = 'SDGELRPD'
     C                   EVAL      Dbase = 2
     C                   EVAL      DbKey = pOption
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Calculate Event Control Date

     C                   IF        (BJDNWD - 1) > BKAPDT
     C                   EVAL      wEvCD = BKAPDT
     C                   ELSE
     C                   EVAL      wEvCD = BJDNWD - 1
     C                   ENDIF

     C     KLoanType     KLIST
     C                   KFLD                    AYLNTY
     C                   KFLD                    AYLNST

     C     KLoanDate     KLIST
     C                   KFLD                    CLLNRF
     C                   KFLD                    BJRDNB

     C     KCFTran       KLIST
     C                   KFLD                    CLLNRF
     C                   KFLD                    wCFVDt
     C                   KFLD                    wCFTYP
     C                   KFLD                    wCFSeq

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   DUMP

     C                   IF        RunBefore = *BLANK
     C                   EVAL      RunBefore = 'Y'

     C                   CALLB     'DBERRCTL'

     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      ********************************************************************

** WCPY@
(c) Finastra International Limited 2006
