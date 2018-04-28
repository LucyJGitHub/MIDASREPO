     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas ER Transaction Type Decision Table List')        *
      *****************************************************************
      *                                                               *
      *  Midas - European Reporting Module                            *
      *                                                               *
      *  ER000185 - Midas ER Transaction Type Decision Table List     *
      *                                                               *
      *  Function:  To generate Transaction Type Decision Table       *
      *             Reports.                                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. BUG26779           Date 27Nov09               *
      *                 BUG26481           Date 19Oct09               *
      *                 BUG26260           Date 02Oct09               *
      *                 BUG25987           Date 11Sep09               *
      *                 CER045  *CREATE    Date 20Jul09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26779 - Change Request on GSART Table                     *
      *  BUG26481 - Audit report reflected records while in actual    *
      *             report no records were displayed                  *
      *  BUG26260 - Transaction Type Decision Table Report not        *
      *             generated after COB                               *
      *  BUG25987 - ER000185P1 trailer is not printed. Prints         *
      *             'IAmended' as Last Activity Action for amended    *
      *             records.                                          *
      *  CER045 - German Features - Reporting Bundesbank              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *    21         Print constant "*** DIFFERENCE ***" in          *
      *               ER000185AU Audit Report                         *
      *    22         Condition display for Class field               *
      *   N70         Transaction Type Decision Table - List in       *
      *               ER000185P1                                      *
      *    70         Transaction Type Decision Table - List in       *
      *               ER000185AU                                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR        -  Program Initialisation Routine              *
      *  *PSSR         -  Error handling subroutine                   *
      *  SRProc        -  Print Detail Report                         *
      *  SRFormat      -  Format report fields                        *
      *  SREnd         -  Write Trailer in Report                     *
      *  SRAudit       -  Write audit report                          *
      *  SRRCFP1       -  Register via RCF ER000185P1                 *
      *  SRRCFAU       -  Register via RCF ER000185AU                 *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Midas ER Transaction Type Decision Table
     FERDETTL0  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Midas SD Standing Data Controls
     FSDFCTLL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Midas ER Transaction Type Decision Table - List
     FER000185P1O    E             PRINTER INFDS(SPOOL1)
     F                                     USROPN
     F                                     INFSR(*PSSR)
      *
      ** Midas ER Transaction Type Decision Table - Audit
     FER000185AUO    E             PRINTER INFDS(SPOOLU)
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
      ** External data structure for Loan Type/Subtype/Class
     D SDLOAN        E DS                  EXTNAME(SDLOANPD)
      *
      ** External data structure for Dealing Type/Subtype
     D SDDLST        E DS                  EXTNAME(SDDLSTPD)
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
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
     D PDSTC           S              2A
     D PLNTY           S              2A
     D PLNST           S              2A
     D PLNCL           S              4A
     D PFMT            S                   LIKE(DSFDY)
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
     D WPrtRec         S              1
     D WRun            S              1
     D CDL038          S              1A
     D CLE042          S              1A
      *
      ** Entry parameters
     D  PMODE          S              1A
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      * Execute report processing
     C                   EXSR      SRProc
      *
      * End of program ?
     C**********         EXSR      SREnd                                                    BUG25987
     C                   EXSR      SRAudit                                                  BUG25987
      *
      ** Return to calling program
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRProc - Print Detail Report                                  *
      *****************************************************************
      *
     C     SRProc        BEGSR
      *
      ** Set file pointer to first record and do initial read.
     C     *LOVAL        SETLL     ERDETTL0
     C                   READ      ERDETTL0
      *
      ** No records found ?
     C                   IF        %EOF(ERDETTL0)
     C                   EXSR      SRAudit
      *
      ** Return to calling program
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C**********         ELSE                                                               BUG26481
     C                   ENDIF                                                              BUG26481
      *
      ** Register List Report
     C**********         IF        PMode = 'L'                                              BUG26260
     C**********         EXSR      SRRCFP1                                                  BUG26481
     C**********         ENDIF                                                              BUG26260
      *
     C**********         ENDIF                                                              BUG26481
      *
     C                   DOW       NOT %EOF(ERDETTL0)
      *
     C**********         EVAL      WNoRec = WNoRec + 1                                      BUG26481
      *
     C**********         EVAL      WPrtRec = 'Y'                                            BUG26260
     C                   EVAL      WPrtRec = 'N'                                            BUG26260
      *
     C**********         IF        PMode = 'A' AND N4LCD <> BJRDNB                          BUG26260
     C**********                   OR PMode = 'A'                                           BUG26260
     C**********         EVAL      WPrtRec = 'N'                                            BUG26260
     C                   IF        PMode = 'A' AND N4LCD = BJRDNB                           BUG26260
     C                             OR PMode = 'L'                                           BUG26260
     C                   EVAL      WNoRec = WNoRec + 1                                      BUG26481
     C                   EVAL      WPrtRec = 'Y'                                            BUG26260
     C                   ENDIF
      *
     C                   IF        WNoRec > 0                                               BUG26481
     C                   EXSR      SRRCFP1                                                  BUG26481
     C                   ENDIF                                                              BUG26481
      *                                                                                     BUG26481
     C                   IF        WPrtRec = 'Y'
     C                   EXSR      SRFormat
     C                   EVAL      RqdLn1 = 1
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
      *
     C                   IF        DifLn1 <= RqdLn1 OR
     C                             WFirst = 'Y'
     C                   WRITE     HEADP1
     C                   EVAL      WFirst = 'N'
     C                   ENDIF
      *
      ** Print Details of record
     C                   WRITE     DETAIL
     C                   ENDIF
      *
     C                   READ      ERDETTL0
      *
     C                   ENDDO                                                              BUG25987
      *                                                                                     BUG25987
     C                   EXSR      SREnd                                                    BUG25987
     C**********         IF        %EOF(ERDETTL0)                                           BUG25987
     C**********         EVAL      RCOUNT = WNoRec                                          BUG25987
     C**********         EXSR      SRAudit                                                  BUG25987
     C**********         ENDIF                                                              BUG25987
     C**********         ENDDO                                                              BUG25987
      *
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRFormat - Format report fields                               *
      *****************************************************************
      *
     C     SRFormat      BEGSR
      *
      ** Write details to printer fields.
     C                   MOVE      N4MMOD        R4MMOD
     C                   MOVE      N4TRTY        R4TRTY
     C                   MOVE      N4TRST        R4TRST
     C                   MOVE      N4TRCL        R4TRCL
      *
      ** Retrieve Description
     C                   IF        R4MMOD = 'FX' OR
     C                             R4MMOD = 'MM'
      *
     C                   CALL      'AODLSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM      N4TRST        PDSTC
     C     SDDLST        PARM      SDDLST        PFMT
      *
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POPTN
     C                   EVAL      DBFile = 'SDDLSTPD'
     C                   EVAL      DBase = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVE      ASDSTN        R3DESC
     C                   ENDIF
      *
     C                   ELSEIF    R4MMOD = 'LE'
      *
     C                   CALL      'AOLOANR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM      N4TRTY        PLNTY
     C                   PARM      N4TRST        PLNST
     C                   PARM      N4TRCL        PLNCL
     C     SDLOAN        PARM      SDLOAN        PFMT
     C
      *
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POPTN
     C                   EVAL      DBFile = 'SDLOANPD'
     C                   EVAL      DBase = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVE      AYLNTD        R3DESC
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   MOVE      N4GRI         R4GRI
     C                   MOVE      N4BUCL        R4BUCL
     C                   MOVE      N4BUSU        R4BUSU
     C                   EVAL      R4BUTY = N4BUTY                                          BUG26779
      *
      ** Retrieve description for "Type of Last Change"
     C                   SELECT
     C                   WHEN      N4TYLC = 'I'
     C**********         MOVE      'Inserted'    R4TYLC                                     BUG25987
     C                   EVAL      R4TYLC = 'Insert'                                        BUG25987
     C                   WHEN      N4TYLC = 'A'
     C**********         MOVE      'Amended'     R4TYLC                                     BUG25987
     C                   EVAL      R4TYLC = 'Amend'                                         BUG25987
     C**********         WHEN      N4TYLC = 'D'                                             BUG25987
     C**********         MOVE      'Deleted'     R4TYLC                                     BUG25987
     C                   ENDSL
      *
     C                   EVAL      ZDayNo = N4LCD
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDayNo
     C                   PARM                    BJDFIN
     C                   PARM      *Zero         ZDate
     C                   PARM      *BLANKS       ZADate
      *
     C                   MOVE      ZADate        R4LCD
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRAudit - WRITE AUDIT REPORT                                  *
      *****************************************************************
      *
     C     SRAudit       BEGSR
      *
      ** Register audit file
     C                   EXSR      SRRCFAU
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
     C                   WHEN      WNoRec <> 0
     C                   EVAL      RCOUNT = WNoRec                                          BUG25987
     C                   WRITE     CONTROL
      *
      ** No details to report ?
     C                   WHEN      WNoRec = 0
     C                   WRITE     NODTLS
     C                   ENDSL
 
      ** Close printer files.
 
     C                   IF        %OPEN(ER000185AU)
     C                   CLOSE     ER000185AU
     C                   ENDIF
 
     C                   IF        %OPEN(ER000185P1)
     C                   CLOSE     ER000185P1
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRRCFP1 - Register ER000185P1 via RCF                        *
      *****************************************************************
      *
     C     SRRCFP1       BEGSR
      *
     C                   IF        NOT %OPEN(ER000185P1)
     C                   OPEN      ER000185P1
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
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRRCFAU - Register ER000185AU via RCF                        *
      *****************************************************************
      *
     C     SRRCFAU       BEGSR
      *
      ** Open report file, ER000185AU
     C                   IF        NOT %OPEN(ER000185AU)
     C                   OPEN      ER000185AU
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
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SREnd - Write Trailer in Report                              *
      *****************************************************************
      *
     C     SREnd         BEGSR
      *
     C                   IF        %OPEN(ER000185P1)
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
     C                   PARM                    PMODE
     C                   PARM                    PSEQ
      *
      ** Define LDA
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'ER000185'
     C                   EVAL      DBASE =  *ZEROS
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY =  *BLANKS
     C                   EVAL      DBMOD =  *BLANKS
     C                   EVAL      DBPROC = *BLANKS
     C                   OUT       LDA
      *
      ** Call Access Program for Bank Details
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST  '    POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POPTN
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Check if CDL038 is switched on
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CDL038'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      CDL038 = 'N'
     C                   ELSE
     C                   EVAL      CDL038 = 'Y'
     C                   ENDIF
      *
      ** Check if CLE042 is switched on
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CLE042'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      CLE042 = 'N'
     C                   ELSE
     C                   EVAL      CLE042 = 'Y'
     C                   ENDIF
      *
     C                   IF        CDL038 = 'N' AND
     C                             CLE042 = 'N'
     C                   EVAL      *IN22 = *OFF
     C                   ELSE
     C                   EVAL      *IN22 = *ON
     C                   ENDIF
      *
      ** Report Work Fields
     C                   EVAL      RqdLn1 = 0
     C                   EVAL      DifLn1 = 0
     C                   EVAL      PRTLN1 = 0
      *
      ** Toggle report header between List or Audit to print
      *
     C                   IF        PMODE = 'A'
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
(c) Misys International Banking Systems Ltd. 2009
