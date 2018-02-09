     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Exemption Certificate Types List')            *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000790P - Midas SD Exemption Certificate Types List        *
      *                                                               *
      *  Function:  This report shows valid Exemption Certificate Type*
      *             Type entered on the system.                       *
      *                                                               *
      *  (phase(s)) This new report will be produced by Midas on-     *
      *             request during input cycle and on request during  *
      *             the close of business                             *
      *                                                               *
      *  Called By: SDC000790 - Exemption Certificate Type List       *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER048  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER048 - German Features - Taxes                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    21         Ind to signify Audit list                       *
      *   N21         Ind to signify Full list                        *
      *    22         Select record                                   *
      *    89         End of File                                     *
      *                                                               *
      *  Database Error Indicators                                    *
      *                                                               *
      *   U7+U8       Database Error                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRInit - Program Initialisation routine                      *
      *  SRProces - Subroutine to do the Detail Processing.           *
      *  SRReport - Process Report Lines.                             *
      *                                                               *
      *  SRWp1End - Subroutine to Write End of Report.                *
      *                                                               *
      *  SRAudit - Subroutine to Output Audit report and End Program. *
      *  *PSSR - Program Error Processing Subroutine                  *
      *  SRRcfP1 - Subroutine to register the P1 Printer File via RCF.*
      *  SRRcfAU - Subroutine to register the AU Printer File via RCF.*
      *                                                               *
      *  ZDATE2 - Convert Midas Day Number into Date (DDMMYY/MMDDYY)  *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Exemption Certificate Type Detail File
      *
     FSDECTYL0  IF   E             DISK
      *
     FSD000790AUO    E             PRINTER INFDS(SPOOLU)
      *
     FSD000790P1O    E             PRINTER INFDS(SPOOL1) USROPN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      *
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY line includes all the defined fields in
      ** the PSDS. They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** File Information Data Structure for SD000790P1.
      *
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
      ** File Information Data Structure for SD000790AU.
      *
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
      *
      ** Dummy Data Structures used by Access Programs.
      ** DS for access programs, long data structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** External data structures for Bank Details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
     D ZYDY            S              4P 0 DIM(4) CTDATA PERRCD(4)
     D ZMDY            S              3P 0 DIM(13) CTDATA PERRCD(13)
     D ZMNM            S              3A   DIM(12) CTDATA PERRCD(12)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D WCpy2           S             80A
     D WP1Rcf          S              1A
     D WRqdLn1         S              3P 0
     D WDifLn1         S              3P 0
     D ZDayNo          S              5P 0
     D WRun            S              1A
     D PZSNum          S              6P 0
     D PZSeq           S              5A
     D PSEnty          S              3A
     D PZSErr          S              1A
     D PZSNumU         S              6P 0
     D PRtCd           S              7A
     D POptn           S              7A
     D PParm           S              1A
     D PSeq            S              5A
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the SRInit  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Perform Initialisation.
      *
     C                   EXSR      SRInit
      *
      ** Perform Detail Processi
      *
     C                   EXSR      SRProces
      *
      ** Output Audit Report and End Program.
      *
     C                   EXSR      SRAudit
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Program Initialisation routine                      *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: *PSSR, SRRcfAU                                        *
      *                                                               *
      *****************************************************************
      *
     C     SRInit        BEGSR
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          WCpy2
      *
      ** Receive Parameter List.
      *
     C     *ENTRY        PLIST
     C                   PARM                    PParm
     C                   PARM                    PSeq
      *
      ** Initialise LDA field.
      *
     C                   MOVEL     'SD000790P'   DBPGM
      *
      ** RCF Processing
      *
     C                   EXSR      SRRcfAU
      *
      ** Call Access Program for Bank Details - Title, Run Date and
      ** Run Day Number.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Handle Database Error.
      *
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Check System Date Format, DDMMYY (*IN98 off)
      **                           MMDDYY (*IN98 on).
      *
     C                   IF        BJDFIN = 'M'
     C                   EVAL      *IN98 = *ON
     C                   ENDIF
      *
      ** Report Work fields.
      *
     C                   EVAL      WP1Rcf = 'N'
     C                   EVAL      WRqdLn1 = *ZEROS
     C                   EVAL      WDifLn1 = *ZEROS
     C                   EVAL      PRTLN1 = 60
      *
      ** Request : 'Audit list' (IN21 *on)  'full list' (IN21 *OFF)
      *
     C                   IF        PParm = 'A'
     C                   EVAL      *IN21 = *ON
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProces - Subroutine to do the Detail Processing.           *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: SRAudit, SRReport, SRWp1End                           *
      *                                                               *
      *****************************************************************
      *
     C     SRProces      BEGSR
      *
      ** Read first record from File.
      *
     C                   READ      SDECTYL0                               89
      *
      ** If End of Records, (*IN89), Perform: Audit Reporting (No
      ** Records).
      *
     C                   IF        *IN89 = *ON
     C                   EXSR      SRAudit
     C                   ENDIF
      *
      ** Do Until End of File.
      *
     C                   DOU       *IN89 = *ON
      *
      ** Test if record must be processed
      ** audit list (Last change date = Run date)
      *
     C                   EVAL      *IN22 = *ON
     C                   IF        *IN21 = *ON AND
     C                              TCLCD <> BJRDNB
     C                   EVAL      *IN22 = *OFF
     C                   ENDIF
      *
     C                   IF        *IN22 = *ON
      *
      ** Process Report Lines.
      *
     C                   EXSR      SRReport
     C                   ENDIF
      *
      ** Read next record.
      *
     C                   READ      SDECTYL0                               89
      *
      ** End of Do Until End of Valid Records.
      *
     C                   ENDDO
      *
      ** Write Totals to Report.
      *
     C                   IF        WP1Rcf = 'Y'
     C                   EXSR      SRWp1End
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReport - Process Report Lines.                             *
      *                                                               *
      *  Called by: SRProces                                          *
      *                                                               *
      *  Calls: SRRcfP1, ZDATE2                                       *
      *                                                               *
      *****************************************************************
      *
     C     SRReport      BEGSR
      *
      ** RCF Processing
      *
     C                   IF        WP1Rcf = 'N'
     C                   EXSR      SRRcfP1
     C                   EVAL      WP1Rcf = 'Y'
     C                   ENDIF
      *
      ** Count records read.
      *
     C                   EVAL      RCOUNT = RCOUNT + 1
      *
     C                   CLEAR                   SD000790R1
      *
     C                   MOVEL     TCTYPE        RCTYPE
     C                   MOVEL     TCTDES        RCTDES
      *
     C                   IF        TCCHTP = 'I'
     C                   MOVEL     'Insert'      RCCHTP
     C                   ELSE
     C                   MOVEL     'Amend '      RCCHTP
     C                   ENDIF
      *
     C                   Z-ADD     TCLCD         ZDayNo
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        RCLCD
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   EVAL      WRqdLn1 = 1
     C                   EVAL      WDifLn1 = OFLLN1 - PRTLN1
      *
     C                   IF        WDifLn1 <= WRqdLn1
     C                   WRITE     SD000790R0
     C                   ENDIF
      *
      ** Write out Detail Record.
      *
     C                   WRITE     SD000790R1
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWp1End - Subroutine to Write End of Report.                *
      *                                                               *
      *  Called by: SRProces                                          *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRWp1End      BEGSR
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   EVAL      WRqdLn1 = 4
     C                   EVAL      WDifLn1 = OFLLN1 - PRTLN1
      *
     C                   IF        WDifLn1 <= WRqdLn1
     C                   WRITE     SD000790R0
     C                   ENDIF
      *
      ** Write out Total Format.
      *
     C                   WRITE     SD000790R2
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Subroutine to Output Audit report and End Program. *
      *                                                               *
      *  Called by: Main Processing, SRProces, *PSSR                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRAudit       BEGSR
      *
      ** Output Report Header and File Controls.
      *
     C                   WRITE     SD000790R3
     C                   WRITE     SD000790R4
      *
      ** If there is a DB Error, Output the DB Error Information.
      *
     C                   IF        (*INU7 = *ON) OR (*INU8 = *ON)
     C                   WRITE     SD000790R6
     C                   ELSE
      *
      ** Or, if no records read, Output "No Details" message.
      *
     C                   IF        RCOUNT = 0
     C                   WRITE     SD000790R5
     C                   ENDIF
     C                   ENDIF
      *
      ** End Program and Return.
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program Error Processing Subroutine                  *
      *                                                               *
      *  Called by: SRInit                                            *
      *                                                               *
      *  Calls: SRAudit                                               *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
      ** Check to see that *PSSR has not already been called.
      *
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
     C                   EXSR      SRAudit
     C                   ENDIF
      *
      ** If *PSSR already run, then just end the program here.
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRcfP1 - Subroutine to register the P1 Printer File via RCF.*
      *                                                               *
      *  Called by: SRReport                                          *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRRcfP1       BEGSR
      *
     C                   OPEN      SD000790P1
      *
      ** Ensure Report Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNUM1        PZSNum
      *
     C                   CALL      'ZSFILE'
     C                   PARM      PSeq          PZSeq
     C                   PARM                    PSEnty
     C                   PARM                    SFILE1
     C                   PARM                    PZSNum
     C                   PARM                    PZSErr
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C                   IF        PZSErr = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRcfAU - Subroutine to register the AU Printer File via RCF.*
      *                                                               *
      *  Called by: SRInit                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRRcfAU       BEGSR
      *
      ** Ensure Audit Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNUMU        PZSNumU
      *
     C                   CALL      'ZSFILE'
     C                   PARM      PSeq          PZSeq
     C                   PARM      *BLANKS       PSEnty
     C                   PARM                    SFILEU
     C                   PARM                    PZSNumU
     C                   PARM      *BLANKS       PZSErr
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C                   IF        PZSErr = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZDATE2 - Convert Midas Day Number into Date (DDMMYY/MMDDYY)  *
      *                                                               *
      *  Called by: SRReport                                          *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C/COPY ZSRSRC,ZDATE2Z2LE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
**   CPY@
(c) Finastra International Limited 2008
**  ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**  ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
