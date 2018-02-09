     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Withholding Tax Treaty Full List')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD0377P - Withholding Tax Treaty Full List                   *
      *                                                               *
      *  Function:  This program will print all the withholding tax   *
      *             details                                           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *  Prev Amend No. CSE023  *CREATE    Date 12Jul00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSE023 - Treaty Withholding Tax                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   21  - Print Difference                                      *
      *   22  - Print Header for Audit List                           *
      *                                                               *
      *   89  - End of File                                           *
      *                                                               *
      * U7+U8 - Database Error                                        *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  *INZSR    - Program Initialisation                           *
      *  SRProcess - Detail Processing                                *
      *  SRReport  - Process Report Lines                             *
      *                                                               *
      *  SRWP1END  - Write End of Report                              *
      *                                                               *
      *  SRAudit   - Produce Audit Report and End Program             *
      *                                                               *
      *  *PSSR     - Program Error Processing Subroutine              *
      *  SRRCFP1   - RCF Processing for P1 Report                     *
      *  SRRCFAU   - RCF Processing for Audit Report                  *
      *                                                               *
      *****************************************************************
     FSD0377PM  O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
     FSD0377P1  O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
     FSDWHTTL4  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDWHTTD0:@WHTTL4)
     FSDFCTLL0  IF   E           K DISK    INFSR(*PSSR)
      *                                                               *
      /COPY ZACPYSRC,STD_D_SPEC
      /COPY ZACPYSRC,PSDS
      /SPACE 3
     D SPOOL1          DS
      ** File Information Data Structure for SD0377P1.
 
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
 
     D SPOOLU          DS
      ** File Information Data Structure for SD0377AU.
 
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External data structures for Bank Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS for access programs, Short data structure
 
     D PRtcd           S              7A
     D PMode           S              1A
     D PSeq            S              5A
     D PLevl           S              1A
     D PEnty           S              3A
 
     D WFName          S             10A   INZ('SDWHTTPD')
 
     D WRun            S              1A
     D ZSErr           S              1A
     D ZSNUM           S              6  0
     D ZSNumU          S              6  0
 
     D RQDLN1          S              3  0 INZ(0)
     D DIFLN1          S              3  0 INZ(0)
 
     D ZDayNo          S              5P 0
     D ZDate           S              6P 0
     D ZADate          S              7A
 
     C/TITLE Main Processing
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
 
      ** Perform Detail Processing.
 
     C                   EXSR      SRProcess
 
      ** Output Audit Report and End Program.
 
     C                   EXSR      SRAudit
      *
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
     C/EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Subroutine to do Program Initialisation.            *
      *                                                               *
      *  Called By:                                                   *
      *                                                               *
      *  Calls:     SRRCFAu                                           *
      *             AOBABKR0                                          *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR                                                  ***  INIT  ***
 
      ** Set up copyright parameter
 
     C                   MOVEA     CPY@          CPY2@            80
 
      ** Receive Parameter List.
 
     C     *ENTRY        PLIST
     C                   PARM                    PRtcd
     C                   PARM                    PMode
     C                   PARM                    PSeq
     C                   PARM                    PLevl
     C                   PARM                    PEnty
 
     C     *LOCK         IN        LDA
     C                   Eval      DBPGM = 'SD0377P'
     C                   OUT       LDA
 
      ** Call Access Program for Bank Details - Title, Run Date and
      ** Run Day Number.
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *Blanks       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Handle Database Error.
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   Eval      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKey = POptn                                ***************
     C                   Z-ADD     001           DBASE                          * DB ERROR 01 *
     C                   EXSR      *PSSR                                        ***************
     C                   OUT       LDA
     C                   ENDIF
 
     C                   IF        PMODE = 'A'
     C                   Eval      *IN22 = *On
     C                   ELSE
     C                   Eval      *IN22 = *Off
     C                   ENDIF
 
      ***  RCF Processing for Audit File.
 
     C                   EXSR      SRRCFAu
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcess - Subroutine to do the Detail Processing.          *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:     SRAudit                                           *
      *             SRRCFP1                                           *
      *             SRReport                                          *
      *             SRWP1End                                          *
      *                                                               *
      *****************************************************************
      *
     C     SRProcess     BEGSR                                                  *** PROCES ***
 
      ** RCF Processing for Report File
 
     C                   EXSR      SRRCFP1
 
      ** Read first record from File.
 
     C     *LOVAL        SETLL     @WHTTL4
     C                   READ      @WHTTL4                                89
 
      ** If End of Records, (*IN89), Perform: Audit Reporting (No
      ** Records).
 
     C                   IF        *IN89 = *On
     C                   EXSR      SRAudit
     C                   ENDIF
 
      ** Do Until End of File.
 
     C                   DOU       *IN89 = *On
 
      ** Count records read.
 
     C                   ADD       1             RCount
 
     C                   IF        BJRDNB = WTLCD and *IN22 = *On or
     C                             *IN22 = *Off
 
      ** Process Report Lines.
 
     C                   EXSR      SRReport
     C                   ENDIF
 
      ** Read next record.
 
     C                   READ      @WHTTL4                                89
 
      ** End of Do Until End of Valid Records.
 
     C                   ENDDO
 
      ** Write final records and Totals to Report.
 
     C                   EXSR      SRWP1End
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReport - Process Report Lines.                             *
      *                                                               *
      *  Called By: SRProcess                                         *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRReport      BEGSR                                                  *** REPORT ***
 
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
 
     C                   Z-ADD     1             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
 
      ** Write out Detail Record.
 
     C                   Eval      RCRTT = WTCRTT
     C                   EVAL      RINVT = WTINVT
     C                   EVAL      RCRRS = WTCRRS
     C                   EVAL      RDBDC = WTDBDC
     C                   EVAL      RDRBW = WTDRBW
     C                   EVAL      RDTSU = WTDTSU
     C                   EVAL      RTXBS = WTTXBS
     C                   EVAL      REXCD = WTEXCD
     C                   MOVE      WTALDY        RALDY
     C                   EVAL      REXPI = WTEXPI
     C                   EVAL      RPFEX = WTPFEX
 
     C                   IF        WTTYLC = 'I'
     C                   EVAL      RTYLC = 'Insert'
     C                   ELSE
     C                   EVAL      RTYLC = 'Amend'
     C                   ENDIF
 
     C                   EVAL      ZDayNo = WTLCD
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDayNo
     C                   PARM                    BJDFIN
     C                   PARM      *Zero         ZDate
     C                   PARM      *BLanks       ZADate
      *
     C                   IF        ZDate <> *Zero
     C                   MOVEL     ZADate        RLCDT
     C                   ELSE
     C                   EVAL      RLCDT = *Blanks
     C                   ENDIF
 
     C                   WRITE     DETAIL
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWP1End - Subroutine to Write End of Report.                *
      *                                                               *
      *  Called By: SRProcess                                         *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRWP1End      BEGSR                                                  *** WP1END ***
 
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
 
     C                   Z-ADD     4             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
 
      ** Write out Total Format.
 
     C                   WRITE     TRAILP1
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Subroutine to Output Audit report and End Program  *
      *                                                               *
      *  Called By: Main Processing                                   *
      *             SRProcess                                         *
      *             *INZSR                                            *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRAudit       BEGSR                                                  *** AUDIT  ***
 
      ** Output Report Header and File Controls.
 
     C                   WRITE     HEADAU
 
      ** If there is a DB Error, Output the DB Error Information.
 
     C                   IF        *INU7 = *On
     C                   WRITE     DBERROR
     C                   ELSE
 
      ** Or, if no records read, Output "No Details" message.
 
     C                   IF        RCount = 0
     C                   WRITE     NODTLS
     C                   ELSE
 
     C     WFName        CHAIN     @AHREAU                            35
     C                   EVAL      RAudit = AHNORC
     C                   EVAL      RInser = AHNOIN
     C                   EVAL      RAmend = AHNOAM
     C                   EVAL      RDelet = AHNODL
 
     C                   IF        RAudit <> RCount
     C                   EVAL      *IN21 = *On
     C                   ENDIF
 
     C                   WRITE     CONTROL
     C                   ENDIF
     C                   ENDIF
 
      ** End Program and Return.
 
     C                   Eval      *INLR = *On
     C                   RETURN
 
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/*PSSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error control subroutine                            *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR **
 
      ** Check to see that *PSSR has not already been called.
 
     C                   IF        WRUN = *Blank
     C                   Eval      WRUN = 'Y'
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
     C                   DUMP
     C                   EXSR      SRAudit
     C                   ENDIF
 
      ** If *PSSR already run, then just end the program here.
 
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
     C                   RETURN
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRCFP1 - Subroutine to register the P1 Printer File via RCF *
      *                                                               *
      *  Called By: SRProcess                                         *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRRCFP1       BEGSR
 
      ** Ensure Report Spool File recorded by RCF.
 
     C                   Z-ADD     SFNUM1        ZSNUM
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       PEnty
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM
     C                   PARM      *Blanks       ZSErr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C                   IF        ZSERR = 'Y'
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRCFAu - Subroutine to register the AU Printer File via RCF *
      *                                                               *
      *  Called By: *INZSR                                            *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRRCFAu       BEGSR                                                   *** RCFAU  ***
 
      ** Ensure Audit Spool File recorded by RCF.
 
     C                   Z-ADD     SFNUMU        ZSNumU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *BLANKS       PENTY
     C                   PARM                    SFILEU
     C                   PARM                    ZSNUMU
     C                   PARM      *BLANK        ZSERR
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C                   IF        ZSERR = 'Y'
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
