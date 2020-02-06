     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE Cheques Presented Today Report')
      *****************************************************************
      *                                                               *
      *  Midas - Retail module                                        *
      *                                                               *
      *  RE004242 - Cheques Presented Today Report                    *
      *                                                               *
      *  Function:  This module will produce a report automatically   *
      *             in close of business showing details of all       *
      *             cheques presented today where                     *
      *             1.) the cheque numbers have presented more than   *
      *                 once.                                         *
      *             2.) the cheque numbers are outside of the range   *
      *                 corresponding to the cheque books issued      *
      *                 against each account.                         *
      *             3.) the cheque numbers result in an account       *
      *                 balance exceeding its overdraft limit.        *
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
      *                 CRE019   *CREATE   Date 12Jan04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CRE019 - Cheque Processing and Maintenance                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         match LOOKUP                                    *
      *    37         Multi-branching                                 *
      *    U7 + U8    Error Occured                                   *
      *    LR         End Pgm                                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrInit  - Initialisation                                     *
      *  SrBrch  - Get branch details                                 *
      *  SrDetl  - Format details of the the record                   *
      *  SrEndP  - Perform final processing                           *
      *  SrOpen1 - Open printer file 1, RE004242P1                    *
      *  SrOpen2 - Open printer file 2, RE004242P2                    *
      *  SrOpen3 - Open printer file 3, RE004242P3                    *
      *  SrRcfP  - Subroutine to register the Printer File via RCF    *
      *  SrRcfAu - Subroutine to register the AU Printer File via RCF *
      *  SrCurr  - Get Currency Details                               *
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
 
     FCHQPRL0   IF   E           K DISK    INFSR(*PSSR)
      ** Midas RE Cheque Presented with Warning Message File
 
     FRE004242AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
      ** PRT: Audit file for Presented Cheques Today Report
 
     FRE004242P1O    E             PRINTER USROPN
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
      ** PRT: Printer file for Duplicate Presented Cheques Today Report
 
     FRE004242P2O    E             PRINTER USROPN
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL2)
      ** PRT: Printer file for Cheques Out of Range Today Report
 
     FRE004242P3O    E             PRINTER USROPN
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL3)
      ** PRT: Printer file for Cheques Overdrawing Accounts Today Report
 
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
 
      ** Work field arrays
     D WPrintFlag      S              1A   DIM(3)
     D WOpenFlag       S              1A   DIM(3)
 
      ** Today's Date
     D RUNDAT          DS
     D  MBIN                  13     13
 
      ** File Information Data Structure for RE004242AU
     D SPOOLU          DS
     D  PsFileU               83     92
     D  PsFNumU              123    124B 0
 
      ** File Information Data Structure for RE004242P1
     D SPOOL1          DS
     D  PsFile1               83     92
     D  PsFNum1              123    124B 0
     D  OflLn1               188    189B 0
     D  PrtLn1               367    368B 0
 
      ** File Information Data Structure for RE004242P2
     D SPOOL2          DS
     D  PsFile2               83     92
     D  PsFNum2              123    124B 0
     D  OflLn2               188    189B 0
     D  PrtLn2               367    368B 0
 
      ** File Information Data Structure for RE004242P3
     D SPOOL3          DS
     D  PsFile3               83     92
     D  PsFNum3              123    124B 0
     D  OflLn3               188    189B 0
     D  PrtLn3               367    368B 0
 
      ** DS for Access Programs: Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** DS for Access Programs: Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External Data Structures for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External Data Structures for Branch Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** Currency Data Structure
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters for Access Objects
     D PRtcd           S              7
     D POptn           S              7
     D PBrca           S              3
     D PCcy            S              3
 
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
     D RqdLn3          S              3P 0
     D DifLn3          S              4P 0
 
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
 
      ** Initialise all counter/flag variables
 
     C                   EXSR      SrInit
 
      ** Read through all records in Cheques Presented File
 
     C     *LOVAL        SETLL     CHQPRL0
     C                   READ      CHQPRL0
 
     C                   DOW       NOT %EOF(CHQPRL0)
 
     C                   CLEAR                   WPrintFlag
 
     C                   IF        PRDUPW = 'Y'
     C                   EVAL      WPrintFlag(1) = 'Y'
     C                   ENDIF
 
     C                   IF        PROUTW = 'Y'
     C                   EVAL      WPrintFlag(2) = 'Y'
     C                   ENDIF
 
     C                   IF        PROVRW = 'Y'
     C                   EVAL      WPrintFlag(3) = 'Y'
     C                   ENDIF
 
     C     'Y'           LOOKUP    WPrintFlag                             01
     C                   IF        %EQUAL
 
      ** If change in branch or 1st pass, get branch details, end and
      ** close necessary printer files, print new page/header.
 
     C                   IF        WrkBrca <> PRBRCA
     C                   EVAL      WrkBrca =  PRBRCA
     C                   EXSR      SrBrch
     C                   ENDIF
 
      ** Format details of the the record to printer fields
 
     C                   EXSR      SrDetl
     C                   ENDIF
 
     C                   READ      CHQPRL0
     C                   ENDDO
 
     C                   EXSR      SrEndP
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      *                                                               *
      *  SrInit - Initialisation                                      *
      *                                                               *
      *****************************************************************
 
     C     SrInit        BEGSR
 
     C                   EVAL      RqdLn1  = *ZERO
     C                   EVAL      DifLn1  = *ZERO
     C                   EVAL      PrtLn1  = *ZERO
     C                   EVAL      RqdLn2  = *ZERO
     C                   EVAL      DifLn2  = *ZERO
     C                   EVAL      PrtLn2  = *ZERO
     C                   EVAL      RqdLn3  = *ZERO
     C                   EVAL      DifLn3  = *ZERO
     C                   EVAL      PrtLn3  = *ZERO
 
     C                   EVAL      RCNT1   = *ZERO
     C                   EVAL      RCNT2   = *ZERO
     C                   EVAL      RCNT3   = *ZERO
     C                   CLEAR                   WOpenFlag
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SrBrch - Get branch details                                  *
      *                                                               *
      *****************************************************************
 
     C     SrBrch        BEGSR
 
      ** End and Close necessary printer file/s
 
     C                   IF        RCNT1 > 0 AND
     C                             WOpenFlag(1) = 'Y'
     C                   WRITE     TRAILP1
     C                   CLOSE     RE004242P1
     C                   ENDIF
 
     C                   IF        RCNT2 > 0 AND
     C                             WOpenFlag(2) = 'Y'
     C                   WRITE     TRAILP2
     C                   CLOSE     RE004242P2
     C                   ENDIF
 
     C                   IF        RCNT3 > 0 AND
     C                             WOpenFlag(3) = 'Y'
     C                   WRITE     TRAILP3
     C                   CLOSE     RE004242P3
     C                   ENDIF
 
     C                   CLEAR                   WOpenFlag
     C                   EVAL      PBrca = PRBRCA
 
      ** Access branch details
 
     C                   CALL      'AOBRCHR0'
     C                   PARM      '*MSG   '     PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PBrca
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
      ** Database Error
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBase  = 2
     C                   EVAL      DBFile = 'SDBRCHPD'
     C                   EVAL      DBKey  = PBrca
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Open necessary printer file/s and print header
 
     C                   IF        WPrintFlag(1) = 'Y'
     C                   EXSR      SrOpen1
     C                   ENDIF
 
     C                   IF        WPrintFlag(2) = 'Y'
     C                   EXSR      SrOpen2
     C                   ENDIF
 
     C                   IF        WPrintFlag(3) = 'Y'
     C                   EXSR      SrOpen3
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SrDetl - Format details of the the record                    *
      *                                                               *
      *****************************************************************
 
     C     SrDetl        BEGSR
 
      ** Retail A/c
 
     C                   EVAL      RACNO = PRACNO
 
      ** Cheque number
 
     C                   EVAL      RCHQN = PRCHQN
 
      ** Transacrion Number
 
     C                   EVAL      RTRNO = PRTRNO
 
      ** Transaction description
 
     C                   EVAL      RDESC = PRDESC
 
      ** Currency
 
     C                   EVAL      RCCY  = PRCCY
     C                   EVAL      Pccy  = PRCCY
     C                   EXSR      SrCurr
 
      ** Amount
 
     C                   MOVE      *BLANKS       PzFld15
     C                   MOVE      PRCHQA        PzFld15
     C                   EVAL      PzDecs = A6NBDP
     C                   EVAL      PzECode = 'J'
     C                   EXSR      SrZSEdit
     C                   MOVE      PzOut21       RCHQA
 
      ** Write details to RE004242P1
 
     C                   IF        WPrintFlag(1) = 'Y'
     C                   IF        WOpenFlag(1) <> 'Y'
     C                   EXSR      SrOpen1
     C                   ENDIF
 
     C                   EVAL      RqdLn1 = 1
     C                   EVAL      DifLn1 = OflLn1 - PrtLn1
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C                   WRITE     DETAIL1
     C                   EVAL      RCNT1 = RCNT1 + 1
     C                   ENDIF
 
      ** Write details to RE004242P2
 
     C                   IF        WPrintFlag(2) = 'Y'
     C                   IF        WOpenFlag(2) <> 'Y'
     C                   EXSR      SrOpen2
     C                   ENDIF
 
     C                   EVAL      RqdLn2 = 1
     C                   EVAL      DifLn2 = OflLn2 - PrtLn2
     C                   IF        DifLn2 <= RqdLn2
     C                   WRITE     HEADP2
     C                   ENDIF
 
     C                   WRITE     DETAIL2
     C                   EVAL      RCNT2 = RCNT2 + 1
     C                   ENDIF
 
      ** Write details to RE004242P3
 
     C                   IF        WPrintFlag(3) = 'Y'
     C                   IF        WOpenFlag(3) <> 'Y'
     C                   EXSR      SrOpen3
     C                   ENDIF
 
     C                   EVAL      RqdLn3 = 1
     C                   EVAL      DifLn3 = OflLn3 - PrtLn3
     C                   IF        DifLn3 <= RqdLn3
     C                   WRITE     HEADP3
     C                   ENDIF
 
     C                   WRITE     DETAIL3
     C                   EVAL      RCNT3 = RCNT3 + 1
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SrEndP - Perform final processing                            *
      *                                                               *
      *****************************************************************
 
     C     SrEndP        BEGSR
 
     C                   IF        WOpenFlag(1) = 'Y'
     C                   WRITE     TRAILP1
     C                   CLOSE     RE004242P1
     C                   ENDIF
 
     C                   IF        WOpenFlag(2) = 'Y'
     C                   WRITE     TRAILP2
     C                   CLOSE     RE004242P2
     C                   ENDIF
 
     C                   IF        WOpenFlag(3) = 'Y'
     C                   WRITE     TRAILP3
     C                   CLOSE     RE004242P3
     C                   ENDIF
 
      ** RCF Processing for Audit File
 
     C                   EXSR      SrRcfAu
     C                   WRITE     HEADAU
     C                   WRITE     CONTROL
 
      ** If there is a DB Error, Output the DB Error Information.
 
     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SrOpen1 - Open printer file 1, RE004242P1                    *
      *                                                               *
      *****************************************************************
 
     C     SrOpen1       BEGSR
 
     C                   OPEN      RE004242P1
     C                   EVAL      WOpenFlag(1) = 'Y'
     C                   EVAL      PsFile = PsFile1
     C                   EVAL      PzSnum = PsFNum1
     C                   EXSR      SrRcfP
     C                   WRITE     HEADP1
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SrOpen2 - Open printer file 2, RE004242P2                    *
      *                                                               *
      *****************************************************************
 
     C     SrOpen2       BEGSR
 
     C                   OPEN      RE004242P2
     C                   EVAL      WOpenFlag(2) = 'Y'
     C                   EVAL      PsFile = PsFile2
     C                   EVAL      PzSnum = PsFNum2
     C                   EXSR      SrRcfP
     C                   WRITE     HEADP2
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SrOpen3 - Open printer file 3, RE004242P3                    *
      *                                                               *
      *****************************************************************
 
     C     SrOpen3       BEGSR
 
     C                   OPEN      RE004242P3
     C                   EVAL      WOpenFlag(3) = 'Y'
     C                   EVAL      PsFile = PsFile3
     C                   EVAL      PzSnum = PsFNum3
     C                   EXSR      SrRcfP
     C                   WRITE     HEADP3
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SrRcfP - Subroutine to register the Printer File via RCF     *
      *                                                               *
      *****************************************************************
 
     C     SrRcfP        BEGSR
 
      ** Ensure Detail Spool File recorded by RCF.
 
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       PSeq
     C                   PARM      *BLANKS       PsEnty
     C                   PARM                    PsFile
     C                   PARM                    PzSnum
     C                   PARM      *BLANKS       PzSerr
 
     C                   IF        PzSerr = 'Y'
     C                   EVAL      *INU7  = *ON
     C                   EVAL      *INU8  = *ON
     C                   EVAL      *INLR  = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SrRcfAu - Subroutine to register the AU Printer File via RCF *
      *                                                               *
      *****************************************************************
 
     C     SrRcfAu       BEGSR
 
      ** Ensure Audit Spool File recorded by RCF.
 
     C                   EVAL      PzSnumU = PsFNumU
 
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       PSeq
     C                   PARM      *BLANKS       PsEnty
     C                   PARM                    PsFileU
     C                   PARM                    PzSnumU
     C                   PARM      *BLANK        PzSerr
 
     C                   IF        PzSerr = 'Y'
     C                   EVAL      *INU7  = *ON
     C                   EVAL      *INU8  = *ON
     C                   EVAL      *INLR  = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrZSEdit  - Convert amount from file format to screen format  *
      *                                                               *
      *****************************************************************
 
     C     SrZSEdit      BEGSR
 
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
      *  SrCurr - Get Currency Details                                *
      *                                                               *
      *****************************************************************
 
     C     SrCurr        BEGSR
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM                    PCcy
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY = PCcy
     C                   EVAL      DBASE = 3
     C                   OUT       LDA
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
 
      ** Initialize program name
 
     C                   EVAL      DBPGM = 'RE004242'
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBase  = 1
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKey  = POptn
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
 
      ** Check multibranch function
 
     C     MBIN          IFEQ      'Y'
     C                   EVAL      *IN37 = *ON
     C                   ENDIF
 
     C     *LIKE         DEFINE    PRBRCA        WrkBrca
 
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
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
 
     C                   CALL      'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2004
