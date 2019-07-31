     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2009')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Borrower Sector Classification Code List')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000830 - Midas SD Borrower Sector Classification Code List *
      *                                                               *
      *  Function:  To generate Borrower Sector Classificatin Code    *
      *             Reports.                                          *
      *                                                               *
      *  (c) Finastra International Limited 2009                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER045  *CREATE    Date 20Jul09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *    21         Print constant "*** DIFFERENCE ***" in          *
      *               SD000830AU Audit Report                         *
      *    70         Borrower Sector Code Report - List in SD000830P1*
      *    71         Borrower Sector Code Report - Audit in          *
      *               SD000830AU                                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR        -  Program Initialisation Routine              *
      *  *PSSR         -  Error handling subroutine                   *
      *  SRPrint       -  Print Detail Report                         *
      *  SREnd         -  Write Trailer in Report                     *
      *  SRAudit       -  Write audit report                          *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Midas SD Borrower Sector Classification Code by N5BSCC
     FSDBSCCL0  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Midas SD Standing Data Controls
     FSDFCTLL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Midas SD Borrower Sector Classification Code - List
     FSD000830P1O    E             PRINTER INFDS(SPOOL1)
     F                                     USROPN
     F                                     INFSR(*PSSR)
      *
      ** Midas SD Borrower Sector Classification Code - Audit
     FSD000830AUO    E             PRINTER INFDS(SPOOLU)
     F                                     USROPN
     F                                     INFSR(*PSSR)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *
      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** External data structure for Switchable Features
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Parameters for ZDATE2
     D ZDayNo          S              5P 0
     D ZDate           S              6P 0
     D ZADate          S              7A
      *
      ** Parameters for ZSFILE
     D PSeq            S              5
     D SEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1
      *
      ** Access Object Parameters
     D PrtCD           S              7A
     D POptn           S              7A
      *
      ** File Information Data Structure for SD000830P1
     D SPOOL1          DS
     D   SFile1               83     92
     D   SFNum1              123    124B 0
     D   OfLln1              188    189B 0
     D   PrtLn1              367    368B 0
      *
      ** File Information Data Structure for SD000830AU
     D SPOOLU          DS
     D   SFileU               83     92
     D   SplfNo              123    124B 0
      *
     D RqdLn1          S              3  0
     D DifLn1          S              4  0
     D WFirst          S              1    INZ('Y')
     D WNoRec          S              5S 0 INZ(0)
     D WNoRecA         S              5S 0 INZ(0)
     D WPrtRec         S              1
     D WRun            S              1
      *
      ** Entry parameters
     D  PMode          S              1
     D  PLevel         S              1
     D  PEntity        S              3
      *
     D WFileName       C                   CONST('SDBSCCPD  ')
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Set file pointer to first record and do initial read.
     C     *LOVAL        SETLL     SDBSCCL0
     C                   READ      SDBSCCL0
      *
      ** No records found ?
     C                   IF        %EOF(SDBSCCL0)
     C                   EXSR      SRAudit
      *
      ** Return to calling program
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   DOW       NOT %EOF(SDBSCCL0)
      *
     C                   EVAL      WNoRec = WNoRec + 1
      *
     C                   EVAL      WPrtRec = 'Y'
      *
     C                   IF        PMode = 'A' AND N5LCD <> BJRDNB
     C                   EVAL      WPrtRec = 'N'
     C                   ENDIF
      *
     C                   IF        WPrtRec = 'Y'
     C                   EVAL      WNoRecA = WNoRecA + 1
     C                   EXSR      SRPrint
     C                   ENDIF
      *
     C                   READ      SDBSCCL0
      *
     C                   ENDDO
      *
      * End of program ?
     C                   EXSR      SREnd
      *
      ** Return to calling program
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRPrint  - Print Detail Report                                *
      *****************************************************************
      *
     C     SRPrint       BEGSR
      *
     C                   IF        NOT %OPEN(SD000830P1)
     C                   OPEN      SD000830P1
      *
     C                   EVAL      ZSnum = SFNUM1
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *BLANKS       SEnty
     C                   PARM                    SFile1
     C                   PARM                    ZSnum
     C                   PARM      *BLANKS       ZSerr
      *
     C     ZSerr         IFEQ      'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   EVAL      RqdLn1 = 1
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
      *
     C                   IF        DifLn1 <= RqdLn1 OR
     C                             WFirst = 'Y'
     C                   WRITE     HEADP1
     C                   EVAL      WFirst = 'N'
     C                   ENDIF
      *
      ** Write details to printer fields.
     C                   MOVE      N5BSCC        RCODE
     C                   MOVE      N5DESC        RDESC
      *
      ** Retrieve description for "Type of Last Change"
     C                   SELECT
     C                   WHEN      N5TYLC = 'I'
     C                   MOVE      'INSERT'      RTYLC
     C                   WHEN      N5TYLC = 'A'
     C                   MOVE      'AMEND '      RTYLC
     C                   WHEN      N5TYLC = 'D'
     C                   MOVE      'DELETE'      RTYLC
     C                   ENDSL
      *
     C                   EVAL      ZDayNo = N5LCD
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDayNo
     C                   PARM                    BJDFIN
     C                   PARM      *Zero         ZDate
     C                   PARM      *BLANKS       ZADate
      *
     C                   MOVE      ZADate        RLCD
      *
      ** Print Details of record
     C                   WRITE     DETAIL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRAudit - WRITE AUDIT REPORT                                  *
      *****************************************************************
      *
     C     SRAudit       BEGSR
      *
      ** Open report file, SD000830AU
     C                   IF        NOT %OPEN(SD000830AU)
     C                   OPEN      SD000830AU
     C                   ENDIF
      *
      ** Retrieve spool file number
     C                   EVAL      ZSnumU = SplfNo
      *
      ** Record Audit Spool File.
      ** End Program when Error occurs during ZSFILE processing.
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *BLANKS       SEnty
     C                   PARM                    SFileU
     C                   PARM                    ZSnumU
     C                   PARM      *BLANKS       ZSerr
      *
      ** Close down program, when error occurs
     C     ZSerr         IFEQ      'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDIF
      *
      ** Print Report Header - Audit Report
     C                   WRITE     HEADAU
      *
      ** Either DBERROR, CONTROL or NODTLS is to be printed
     C                   SELECT
      *
      ** If there is a DB Error, Output the DB Error Information.
     C                   WHEN      *INU7 = *ON AND WRun = 'Y'
     C                   WRITE     DBERROR
      *
      ** Record was sensed? Print Audit Report Details - CONTROL
     C                   WHEN      WNoRecA <> 0
     C                   WRITE     CONTROL
      *
      ** No details to report ?
     C                   WHEN      WNoRecA = 0
     C                   WRITE     NODTLS
     C                   ENDSL
 
      ** Close printer files.
 
     C                   IF        %OPEN(SD000830AU)
     C                   CLOSE     SD000830AU
     C                   ENDIF
 
     C                   IF        %OPEN(SD000830P1)
     C                   CLOSE     SD000830P1
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SREnd - Write Trailer in Report                              *
      *****************************************************************
      *
     C     SREnd         BEGSR
      *
     C                   IF        %OPEN(SD000830P1)
     C                   EVAL      RqdLn1 = 4
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
      *
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
      *
     C                   WRITE     TRAILP1
     C                   ENDIF
      *
     C     WFileName     CHAIN     SDFCTLL1
      *
     C                   IF        NOT %FOUND(SDFCTLL1)
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'SDBSCCPD'
     C                   EVAL      DBFILE = 'SDFCTLL1'
     C                   EVAL      DBASE = 2
     C                   EVAL      DBPGM = PSProcPgm
     C                   OUT       LDA
      *
     C                   EXSR      *PSSR
      *
     C                   ELSE
      *
     C                   EVAL      RINSER = AHNOIN
     C                   EVAL      RAMEND = AHNOAM
     C                   EVAL      RDELET = AHNODL
     C                   EVAL      RAUDIT = AHNORC
     C                   EVAL      RCOUNT = WNoRec
      *
      ** Print the word "Difference" if no. of records processed
      ** is not the same with the number of records on SDFCTLPA
     C                   IF        RCOUNT <> RAUDIT AND WNoRec <> 0
     C                   EVAL      *IN21 = *ON
     C                   ENDIF
     C                   EXSR      SRAudit
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation Routine                       *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Accept entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    PrtCD
     C                   PARM                    PMode
     C                   PARM                    PSeq
     C                   PARM                    PLevel
     C                   PARM                    PEntity
      *
      ** Define LDA
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'SD000830'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY =  *BLANKS
     C                   EVAL      DBASE = 0
     C                   OUT       LDA
      *
      ** Call Access Program for Bank Details
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PrtCD
     C                   PARM      '*FIRST  '    POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error
     C                   IF        PrtCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POPTN
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Report Work Fields
     C                   EVAL      RqdLn1 = 0
     C                   EVAL      DifLn1 = 0
     C                   EVAL      PRTLN1 = 0
      *
      ** Toggle report header between List or Audit to print
      *
     C                   IF        PMode = 'A'
     C                   MOVEL     *ON           *IN70
     C                   ENDIF
      *
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
      *
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   DUMP
     C                   EXSR      SRAudit
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2009
