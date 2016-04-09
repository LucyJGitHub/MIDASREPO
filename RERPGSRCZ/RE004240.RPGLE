     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE Cheque Books Issued/Reversed Today Report')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE004240 - Cheque Books Issued/Reversed Today Report         *
      *                                                               *
      *  Function:  This program generates a report in close of       *
      *  business showing details of all cheque books issued and      *
      *  cancelled/reversed today.                                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. 242474             Date 22Sep06               *
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 BUG9011            Date 19Oct05               *
      *                 CSD027             Date 09Dec05               *
      *                 CRE019  *CREATE    Date 12Jan04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  242474 - Change default Rqd line counter to prevent printer  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG9011- Increase field size of No. of Cheques to avoid      *
      *           truncation. (Recompiled)                            *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CRE019 - Cheque Processing and Maintenance                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators:                                           *
      *                                                               *
      *    37         Multi-branching                                 *
      *    U7 + U8    Error Occured                                   *
      *    LR         End Program                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrInit - Initialise counters, flags, save variables          *
      *  SrBranch - Retrieve branch details                           *
      *  SrDetail - Format details of each record                     *
      *  SrEndProcess - Perform final processing                      *
      *  SrOpenP1 - Open printer file 1, Cheques Issued Report        *
      *  SrOpenP2 - Open printer file 2, Cheques Cancelled Report     *
      *  SrRegisterPF - Register the Printer File via RCF             *
      *  SrRegisterAU - Register the Audit Printer File via RCF       *
      *  SrEditAmt - Convert amount from file format to screen format *
      *  SrConvDate - Convert Midas day number to DDMMMYY format      *
      *  *PSSR   - Error processing                                   *
      *  *INZSR  - Initialise                                         *
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
 
     FCHQBKL2   IF   E           K DISK    INFSR(*PSSR)
      ** Cheque book file - Logical file
 
     FACNUM     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(AC)
      ** GL Accounts master details file
 
     FRE004240AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
      ** Cheque Books Today Audit Report
 
     FRE004240P1O    E             PRINTER USROPN
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
     ** Cheque Books Issued Today Report
 
     FRE004240P2O    E             PRINTER USROPN
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL2)
      ** Cheque Books Cancelled/Reversed Today Report
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D SPOOLU          DS
      ** File Information Data Structure for RE004240AU
     D  PsFileU               83     92
     D  PsFNumU              123    124B 0
 
     D SPOOL1          DS
      ** File Information Data Structure for RE004240P1
     D  PsFile1               83     92
     D  PsFNum1              123    124B 0
     D  OflLn1               188    189B 0
     D  PrtLn1               367    368B 0
 
     D SPOOL2          DS
      ** File Information Data Structure for RE004240P2
     D  PsFile2               83     92
     D  PsFNum2              123    124B 0
     D  OflLn2               188    189B 0
     D  PrtLn2               367    368B 0
 
     D RUNDAT          DS
      ** Rundate Data Structure
     D  MBIN                  13     13
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** DS for Access Programs: Long Data Structure
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS for Access Programs: Short Data Structure
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External Data Structure for Bank Details
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** External Data Structure for Branch Details
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Currency Data Structure
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters for Access Objects
     D PRtcd           S              7
     D POptn           S              7
     D PBrca           S              3
     D PCcy            S              3
 
      ** ZDATE2 fields
     D PDayNum         S              5  0
     D PDateFmt        S              1A
     D PDateVal        S              6  0
     D PAlphaDate      S              7A
 
      ** ZSEDIT fields
     D PzFld15         S             15  0
     D PzDecs          S              1  0
     D PzECode         S              1
     D PzOut21         S             21
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D PsEnty          S              3
     D PsFile          S             10
     D PzSnum          S              6  0
     D PzSnumU         S              6  0
     D PzSerr          S              1
 
      ** Printer line counters
     D RqdLn1          S              3P 0
     D DifLn1          S              4P 0
     D RqdLn2          S              3P 0
     D DifLn2          S              4P 0
 
     D WP1Flag         S              1A
     D WP2Flag         S              1A
     D WP1Open         S              1A
     D WP2Open         S              1A
     D WSaveBRCH       S                   LIKE(BRCA)
 
     D WRun            S              1
 
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
 
     C                   EXSR      SrInit
 
      **  Process all records from CHQBKPD
 
     C                   READ      CHQBKPDF
 
     C                   DOW       NOT %EOF(CHQBKL2)
 
      **  Clear print P1 and P2 flags
 
     C                   EVAL      WP1Flag = *BLANK
     C                   EVAL      WP2Flag = *BLANK
 
      ** Select only records changed today and are not out of range
 
     C                   IF        LCD = BJRDNB AND
     C                             OUTR = *BLANK
 
      ** Determine if cheque record is issued today
 
     C                   IF        RECID = 'D' AND
     C                             OEDT = BJRDNB
     C                   EVAL      WP1Flag = 'Y'
     C                   ENDIF
 
      ** Determine if record is cancelled/reversed today
 
     C                   IF        RECID = '*'
     C                   EVAL      WP2Flag = 'Y'
     C                   ENDIF
     C                   ENDIF
 
      ** If either print P1 flag or print P2 flag is 'Y', process current record
 
     C                   IF        WP1Flag = 'Y' OR
     C                             WP2Flag = 'Y'
 
      ** Process new report for new branch
 
     C                   IF        WSaveBRCH <> BRCA
     C                   EVAL      WSaveBRCH = BRCA
     C                   EXSR      SrBranch
     C                   ENDIF
 
      ** Format and print detail line
 
     C                   EXSR      SrDetail
 
     C                   ENDIF
 
     C                   READ      CHQBKPDF
     C                   ENDDO
 
     C                   EXSR      SrEndProcess
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      *                                                               *
      *  SrInit - Initialise counters, flags, save variables          *
      *                                                               *
      *****************************************************************
     C     SrInit        BEGSR
 
     C                   EVAL      RqdLn1  = *ZERO
     C                   EVAL      DifLn1  = *ZERO
     C                   EVAL      PrtLn1  = *ZERO
 
     C                   EVAL      RqdLn2  = *ZERO
     C                   EVAL      DifLn2  = *ZERO
     C                   EVAL      PrtLn2  = *ZERO
 
     C                   EVAL      RIssued = *ZERO
     C                   EVAL      RCancel = *ZERO
 
     C                   EVAL      WSaveBRCH = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SrBranch - Retrieve branch details                           *
      *                                                               *
      *****************************************************************
     C     SrBranch      BEGSR
 
      ** Close previously opened printer files
 
     C                   IF        RIssued > 0 AND
     C                             WP1Open = 'Y'
     C                   WRITE     TRAILERP1
     C                   CLOSE     RE004240P1
     C                   EVAL      WP1Open = *BLANK
     C                   ENDIF
 
     C                   IF        RCancel > 0 AND
     C                             WP2Open = 'Y'
     C                   WRITE     TRAILERP2
     C                   CLOSE     RE004240P2
     C                   EVAL      WP2Open = *BLANK
     C                   ENDIF
 
      ** Access branch details
 
     C                   CALL      'AOBRCHR0'
     C                   PARM      '*MSG   '     PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      BRCA          PBrca
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
      ** Database Error
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  = 1
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBKEY  = PBrca
     C                   OUT       LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EXSR      SrEndProcess
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Open printer files for new branch
 
     C                   IF        WP1Flag = 'Y'
     C                   EXSR      SrOpenP1
     C                   ENDIF
 
     C                   IF        WP2Flag = 'Y'
     C                   EXSR      SrOpenP2
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SrDetail - Format details of each record                     *
      *                                                               *
      *****************************************************************
 
     C     SrDetail      BEGSR
 
      ** Retail A/c
     C                   MOVEL     ACNO          RACNO
 
      ** GIRO/cheque indicator
     C                   MOVE      GCQI          RGCQI
 
      ** Starting Cheque No.
     C                   MOVE      SCQN          RSCQN
 
      ** Ending Cheque No.
     C                   MOVE      ECQN          RECQN
 
      ** No. of cheques
     C                   MOVE      NOCQ          RNOCQ
 
      ** Date Issued
     C                   MOVE      DISS          PDayNum
     C                   EXSR      SrConvDate
     C                   MOVE      PAlphaDate    RDISS
 
      ** Date Collected
     C                   MOVE      DCOL          PDayNum
     C                   EXSR      SrConvDate
     C                   MOVE      PAlphaDate    RDCOL
 
      ** Charge Amount (first retrieve accounts currency/decimal)
 
     C                   IF        CHAM <> *ZERO
 
     C                   EXSR      SrDecimals
 
     C                   MOVE      *BLANKS       PzFld15
     C                   MOVE      CHAM          PzFld15
     C                   EVAL      PzDecs = A6NBDP
     C                   EVAL      PzECode = 'J'
     C                   EXSR      SrEditAmt
     C                   MOVE      PzOut21       RCHAM
 
     C                   ELSE
 
     C                   EVAL      RCHAM = *BLANKS
 
     C                   ENDIF
 
      ** Charge Account
 
     C                   IF        CHAC <> *ZERO
     C                   MOVEL     CHAC          RCHAC
     C                   ELSE
     C                   EVAL      RCHAC = *BLANKS
     C                   ENDIF
 
      ** Charge Transaction Type
 
     C                   IF        CHTT <> *ZERO
     C                   MOVEL     CHTT          RCHTT
     C                   ELSE
     C                   EVAL      RCHTT = *BLANKS
     C                   ENDIF
 
      ** Write details to RE004240P1
 
     C                   IF        WP1Flag = 'Y'
     C                   IF        WP1Open <> 'Y'
     C                   EXSR      SrOpenP1
     C                   ENDIF
 
     C**********         EVAL      RqdLn1 = 1                                                 242474
     C                   EVAL      RqdLn1 = 4                                                 242474
     C                   EVAL      DifLn1 = OflLn1 - PrtLn1
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADERP1
     C                   ENDIF
 
     C                   WRITE     DETAILP1
     C                   EVAL      RIssued = RIssued + 1
     C                   ENDIF
 
      ** Write details to RE004240P2
 
     C                   IF        WP2Flag = 'Y'
     C                   IF        WP2Open <> 'Y'
     C                   EXSR      SrOpenP2
     C                   ENDIF
 
     C                   EVAL      RqdLn2 = 1
     C                   EVAL      DifLn2 = OflLn2 - PrtLn2
     C                   IF        DifLn2 <= RqdLn2
     C                   WRITE     HEADERP2
     C                   ENDIF
 
     C                   WRITE     DETAILP2
     C                   EVAL      RCancel = RCancel + 1
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SrEndProcess - Perform final processing                      *
      *                                                               *
      *****************************************************************
     C     SrEndProcess  BEGSR
 
     C                   IF        WP1Open = 'Y'
     C                   WRITE     TRAILERP1
     C                   CLOSE     RE004240P1
     C                   ENDIF
 
     C                   IF        WP2Open = 'Y'
     C                   WRITE     TRAILERP2
     C                   CLOSE     RE004240P2
     C                   ENDIF
 
      ** RCF Processing for Audit File
 
     C                   EXSR      SrRegisterAU
     C                   WRITE     HEADAU
 
      ** If a DB error occured, print DB error information
 
     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ELSE
 
      ** Else, print number of records processed
 
     C                   WRITE     CONTROL
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SrOpenP1 - Open printer file 1, Cheques Issued Report        *
      *                                                               *
      *****************************************************************
     C     SrOpenP1      BEGSR
 
     C                   OPEN      RE004240P1
     C                   EVAL      WP1Open = 'Y'
     C                   EVAL      PsFile = PsFile1
     C                   EVAL      PzSnum = PsFNum1
     C                   EXSR      SrRegisterPF
     C                   WRITE     HEADERP1
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SrOpenP2 - Open printer file 2, Cheques Cancelled Report     *
      *                                                               *
      *****************************************************************
     C     SrOpenP2      BEGSR
 
     C                   OPEN      RE004240P2
     C                   EVAL      WP2Open = 'Y'
     C                   EVAL      PsFile = PsFile2
     C                   EVAL      PzSnum = PsFNum2
     C                   EXSR      SrRegisterPF
     C                   WRITE     HEADERP2
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SrRegisterPF - Register the Printer File via RCF             *
      *                                                               *
      *****************************************************************
     C     SrRegisterPF  BEGSR
 
      ** Ensure detail spool file recorded by RCF
 
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       PSeq
     C                   PARM      *BLANKS       PsEnty
     C                   PARM                    PsFile
     C                   PARM                    PzSnum
     C                   PARM      *BLANKS       PzSerr
 
     C                   IF        PzSerr = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EXSR      SrEndProcess
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SrRegisterAU - Register the AU Printer File via RCF          *
      *                                                               *
      *****************************************************************
     C     SrRegisterAU  BEGSR
 
      ** Ensure audit spool file recorded by RCF
 
     C                   EVAL      PzSnumU = PsFNumU
 
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       PSeq
     C                   PARM      *BLANKS       PsEnty
     C                   PARM                    PsFileU
     C                   PARM                    PzSnumU
     C                   PARM      *BLANK        PzSerr
 
     C                   IF        PzSerr = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EXSR      SrEndProcess
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrEditAmt - Convert amount from file format to screen format  *
      *                                                               *
      *****************************************************************
     C     SrEditAmt     BEGSR
 
     C                   CALL      'ZSEDIT'
     C                   PARM                    PzFld15
     C                   PARM                    PzDecs
     C                   PARM                    PzECode
     C                   PARM                    PzOut21
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrConvDate - Convert Midas day number to DDMMMYY format       *
      *                                                               *
      *****************************************************************
     C     SrConvDate    BEGSR
 
     C                   CALL      'ZDATE2'
     C                   PARM                    PDayNum
     C                   PARM      *BLANKS       PDateFmt
     C                   PARM                    PDateVal
     C                   PARM      *BLANKS       PAlphaDate
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDecimals - Retrieve account's currency details             *
      *                                                               *
      *****************************************************************
     C     SrDecimals    BEGSR
 
     C     ACNO          CHAIN     ACNUM
 
     C                   IF        %FOUND()
 
     C                   MOVE      ACCCY         PCcy
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM                    PCcy
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 2
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY = PCcy
     C                   OUT       LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EXSR      SrEndProcess
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 3
     C                   EVAL      DBFILE = 'ACNUM'
     C                   MOVEL     ACNO          DBKEY
     C                   OUT       LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EXSR      SrEndProcess
     C                   EXSR      *PSSR
     C                   ENDIF
 
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
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'RE004240'
     C                   OUT       LDA
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  = 4
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = POptn
     C                   OUT       LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EXSR      SrEndProcess
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
 
      ** Set multibranching indicator
 
     C     MBIN          IFEQ      'Y'
     C                   EVAL      *IN37 = *ON
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   CALL      'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
