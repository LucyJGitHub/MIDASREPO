     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD FATCA Exceptions by CUST/NAHO Report')        *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000554 - FATCA Exceptions by Customers/NAHOs Report        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD025220           Date 03Feb14               *
      *  Prev Amend No. CGL132   *CREATE   Date 01May13               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD025220 - SD000554P1 and SD000554AU input cycle reports has *
      *             no information if 9 or more exceptions selected   *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    05  - Overflow Indicator SD000554P1                        *
      *    06  - Change of                                            *
      *    14  - End of File                                          *
      *    15  - Chain Fail on File                                   *
      *    50  - At least one set of details output - used for        *
      *          printer file conditioning                            *
      *    80  - Data Base Error Indicator                            *
      *                                                               *
      *  U7+U8 - Data Base Error (job switch)                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRMAIN - Main Processing                                     *
      *  SRHDRD - Prepare Header Data for Printing                    *
      *  SRINIT - Initial Processing                                  *
      *  SRCLOS - Printer File Closure                                *
      *  SRFCP  - File Control Processing                             *
      *  *PSSR  - Error Handling Subroutine                           *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+                     *
      ** ¦ F-specs                              ¦                     *
      ** ¦ =======                              ¦                     *
      ** +--------------------------------------+                     *
      ** FATCA Customers with Exceptions - List
     FSDFTCSL6  IF   E             DISK
 
      ** FATCA Non-Account Holders with Exceptions - List
     FSDFTNHL6  IF   E             DISK
 
      ** Non - Account Holder Details
     FSDNAHOL0  IF   E           K DISK
 
      ** Customer Details
     FSDCUSTL0  IF   E           K DISK
 
      ** FATCA Exception Messages File
     FSDEXMAL0  IF   E           K DISK
 
      ** FATCA Exceptions by Customers/Non-Account Holders Report
     FSD000554P1O    E             PRINTER INFSR(*PSSR)
     F                                     OFLIND(*IN05)
     F                                     USROPN
     F                                     INFDS(SPOOL)
 
      ** FATCA Exceptions by Customers/Non-Account Holders Audit
     FSD000554AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDSVAL        E DS                  EXTNAME(SDSVALPD)
     D SDFATC        E DS                  EXTNAME(SDFATCPD)
 
     DPSDS            SDS
 
      ** Procedure name
     D PSProcName        *PROC
 
      ** Job name
     D PSJobName             244    253
 
      ** User name
     D PSUser                254    263
 
      ** Input DS
     D POutFlds        DS           100
     D  PExceptions            1     30A
 
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
 
     D SPOOL           DS
      ** SPOOL Information Data Structure for ZSFILE
 
     D  SFILE                 83     92
     D  SFNUM                123    124B 0
     D SPOOLU          DS
      ** SPOOL Information Data Structure for ZSFILE - AU Report
 
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
 
     D WCOMM           DS
     D  WCOM1                  1     64
     D  WCOM2                 65    128
     D  WCOM3                129    192
     D  WCOM4                193    256
 
     D WDTMST          DS
     D  WWMn                   1      2
     D  WWDy                   3      4
     D  WWYr                   5      6
 
     DExcpts           S              1A   DIM(30)
     DSelEx            S              1A   DIM(30)
     DMsgLines         S             64A   DIM(4)
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WMatch          S              1  0
     D*WIdx*****       S              1  0                                                  MD025220
     D*WIdx2****       S              1  0                                                  MD025220
     D WIdx            S              2  0                                                  MD025220
     D WIdx2           S              2  0                                                  MD025220
     D WExIDs          S             30A   INZ(*Blanks)
     D PRetCode        S              7A
     D POption         S              7A
     D PSequence       S              5A
     D PLevel          S              1A
     D PEntity         S              3A
     D PAct            S              1A
     D PCmd            S              1A
     D Mode            S              7A
     D Recursive       S              1    INZ('N')
     D WCODE           S             10
     D WNARR           S              1
     D WRUN            S              1
     D WCALC           S              5  0
     D WCALCC          S              5  0
     D WCALCN          S              5  0
     D DRUND           S              5  0
     D WWTMST          S             26A
 
     ** ZSFILE Parameters
     D ZSERR           S              1
     D ZSNUM           S              6  0
     D KCUST           S              6
 
     ** ZDATE2 Parameters
     D ZDAYNO          S              5  0
     D ZDATE           S              6  0
     D ZADATE          S              7
 
     ** PLIST Parameters
     D PMODE           S              1
 
     D RTYPE           S              5
 
      * ZDATE1  parms
     D ZDATEA          S              6  0
     D ZDATFMT         S              1
     D ErrorFlag       S              1
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      *                                                               *
      * M A I N   P R O C E D U R E                                   *
      *                                                               *
      *****************************************************************
      *
      ** Initial Processing
      *
     C                   EXSR      SRINIT
      *
      ** Generate Report
      *
     C                   EXSR      SRREPT
      *
      ** Audit Report
      *
     C                   EXSR      SRFCP
      *
      ** End Program
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      /EJECT
      *
      *****************************************************************
      *                                                               *
      * S U B R O U T I N E S                                         *
      *                                                               *
      *****************************************************************
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRREPT   - Report Processing                                  *
      *            Controls Set-up of SD000554P1 Details              *
      *            Outputs SD000554P1 Details                         *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      * Calls    : SRHDRD - Prepare Header Data for Printing          *
      *                                                               *
      *****************************************************************
     C     SRREPT        BEGSR
 
     C                   EVAL      *IN05 = *ON
      *
      ** Loop through all customers with exceptions
      *
     C                   EVAL      RTYPE = '*CUST'
     C*    *LOVAL        SETLL     SDFTCSL6
     C                   READ      SDFTCSD0                               14
     C                   DOW       *IN14 <> *ON
      ** Record(s) found
     C                   IF        *IN50 = *OFF
     C                   OPEN      SD000554P1
     C                   EVAL      *IN50 = *ON
     C                   EXSR      SRZSPR
     C                   ENDIF
      *
      ** If overflow indicator fires up, write header format
      *
     C                   IF        *IN05 = *ON
     C                   WRITE     SD000554R0
     C                   ENDIF
      *
      ** Prepare detail data for printing
      *
     C                   EXSR      SRDETAIL
      *
      ** If overflow indicator on, then set it off
      *
     C                   IF        *IN05 = *ON
     C                   EVAL      *IN05 = *OFF
     C                   ENDIF
 
     C                   IF        Excpts(1) <> *Blanks
      *
      ** Write detail record to SD000554P1
      *
     C                   WRITE     SD000554R1
     C                   EXSR      SRWREX
      *
      ** Increment count of records output
      *
     C                   ADD       1             WCALC
     C                   ADD       1             WCALCC
     C                   ENDIF
      *
      ** Read next record
      *
     C                   READ      SDFTCSD0                               14
     C                   ENDDO
 
     C                   EVAL      *IN05 = *ON
     C                   IF        *IN50 = *ON
     C                   IF        WCALCC = 0
     C                   WRITE     SD000554R3
     C                   ENDIF
     C                   EXSR      SRCLOS
     C                   CLOSE     SD000554P1
     C                   ENDIF
      *
     C                   EVAL      *IN41 = *ON
     C                   EVAL      *IN50 = *OFF
      *
      ** Loop through all non-account holders with exceptions
      *
     C                   EVAL      RTYPE = '*NAHO'
     C*    *LOVAL        SETLL     SDFTNHL6
     C                   READ      SDFTNHD0                               14
     C                   DOW       *IN14 <> *ON
      ** Record(s) found
     C                   IF        *IN50 = *OFF
     C                   OPEN      SD000554P1
     C                   EVAL      *IN50 = *ON
     C                   EXSR      SRZSPR
     C                   ENDIF
      *
      ** If overflow indicator fires up, write header format
      *
     C                   IF        *IN05 = *ON
     C                   WRITE     SD000554R0
     C                   ENDIF
      *
      ** Prepare detail data for printing
      *
     C                   EXSR      SRDETAIL
      *
      ** If overflow indicator on, then set it off
      *
     C                   IF        *IN05 = *ON
     C                   EVAL      *IN05 = *OFF
     C                   ENDIF
     C                   IF        Excpts(1) <> *Blanks
      *
      ** Write detail record to SD000554P1
      *
     C                   WRITE     SD000554R1
     C                   EXSR      SRWREX
      *
      ** Increment count of records output
      *
     C                   ADD       1             WCALC
     C                   ADD       1             WCALCN
     C                   ENDIF
      *
      ** Read next record
      *
     C                   READ      SDFTNHD0                               14
     C                   ENDDO
     C                   IF        *IN50 = *ON
     C                   IF        WCALCC = 0
     C                   WRITE     SD000554R3
     C                   ENDIF
     C                   EXSR      SRCLOS
     C                   CLOSE     SD000554P1
     C                   ENDIF
 
     C                   IF        WCALC = 0
     C                   OPEN      SD000554P1
     C                   WRITE     SD000554R0
     C                   EVAL      *IN50 = *ON
     C                   EXSR      SRZSPR
     C                   EXSR      SRCLOS
     C                   CLOSE     SD000554P1
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
 
     C     MEND          ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDETAIL - Prepare Details for Printing                       *
      *                                                               *
      * Called by: SRMAIN - Main Processing                           *
      *                                                               *
      * Calls    : *PSSR  - Error handling subroutine                 *
      *                                                               *
      *****************************************************************
     C     SRDETAIL      BEGSR
 
     C                   EVAL      XRREFR = *BLANKS
     C                   EVAL      XRRPNM = *BLANKS
     C                   EVAL      XRRPTN = *BLANKS
     C                   EVAL      XRSNAM = *BLANKS
     C                   MOVEA     *BLANKS       Excpts
      * Set Report Details
 
     C                   IF        RTYPE = '*CUST'
     C                   EVAL      XRREFR = FACUST
      ** Get customer details
     C     FACUST        CHAIN     @BBREBG
     C                   IF        %FOUND = '1'
     C                   EVAL      XRRPNM = BBCRNM
     C                   EVAL      XRRPTN = BBCRTN
     C                   EVAL      XRSNAM = BBCSSN
     C                   ENDIF
     C                   EVAL      Excpts = *BLANKS
     C                   MOVEA     FAEXID        Excpts
      *
     C                   ELSEIF    RTYPE = '*NAHO'
     C                   EVAL      XRREFR = FNNAHO
      ** Get non-account holder details
     C     FNNAHO        CHAIN     SDNAHOD0
     C                   IF        %FOUND = '1'
     C                   EVAL      XRRPNM = NHNARN
     C                   EVAL      XRRPTN = NHNATW
     C                   EVAL      XRSNAM = *BLANKS
     C                   ENDIF
     C                   EVAL      Excpts = *BLANKS
     C                   MOVEA     FNEXID        Excpts
     C                   ENDIF
      ** If a selection was made, filter for them
     C                   IF        PExceptions <> *BLANKS
     C                   EVAL      WIdx = 1
     C                   EVAL      WExIDs = *BLANKS
     C                   DOW       %trim(SelEx(WIdx)) <> *BLANKS
     C                   EVAL      WMatch = %LOOKUP(SelEx(WIdx):Excpts)
     C                   IF        %FOUND = '1' and WMatch > 0
     C                   EVAL      WExIDs = %trim(WExIDs) + SelEx(WIdx)
     C                   ENDIF
     C                   EVAL      WIdx += 1
     C                   ENDDO
     C                   MOVEA     *BLANKS       Excpts
     C                   MOVEA     WExIDs        Excpts
     C                   ENDIF
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWREX - Write Exceptions for crrent Customer                 *
      *                                                               *
      *****************************************************************
     C     SRWREX        BEGSR
     C                   EVAL      WIdx = 1
     C                   DOW       Excpts(WIdx) <> *BLANKS
     C     Excpts(WIdx)  CHAIN     SDEXMAL0
     C                   IF        %FOUND = '1'
      ** Move exception message (256A) to array of 4 elements (64A)
     C                   EVAL      MsgLines = *BLANKS
     C                   MOVEA     FEEXDE        MsgLines
      ** Set on bullet for first line of each message.
     C                   EVAL      *IN42 = *ON
     C                   EVAL      WIdx2 = 1
     C                   DOW       MsgLines(WIdx2) <> *BLANKS
     C                   EVAL      XREXMX = MsgLines(WIdx2)
      ** Append line to exceptions list of current customer
     C                   WRITE     SD000554R2
      ** Move to next exception message line index
     C                   EVAL      WIdx2 += 1
      ** Switch off bullet after first line of each message.
     C                   EVAL      *IN42 = *OFF
     C                   ENDDO
     C                   ENDIF
      ** Move to next exception id index
     C                   EVAL      WIdx += 1
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRHDRD   - Prepare Header Data for Printing                   *
      *                                                               *
      * Called by: SRMAIN - Main Processing                           *
      *                                                               *
      * Calls    : *PSSR  - Error handling subroutine                 *
      *                                                               *
      *****************************************************************
     C     SRHDRD        BEGSR
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDATE1 - Validate & convert date to a day number            *
      *                                                               *
      *****************************************************************
     C     SRDATE1       BEGSR
 
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM                    ZDATEA
     C                   PARM                    ZDATFMT
     C                   PARM                    ZDAYNO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDATE2  - Convert Date to Printer Date                       *
      *                                                               *
      * Called by: SRMAIN - Main Processing                           *
      *                                                               *
      * Calls    : *PSSR  - Error handling subroutine                 *
      *                                                               *
      *****************************************************************
     C     SRDATE2       BEGSR
 
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZSPR   - Invoke ZS Processing                               *
      *                                                               *
      * Called by: SRREPT                                             *
      *                                                               *
      *****************************************************************
     C     SRZSPR        BEGSR
     C                   Z-ADD     SFNUM         ZSNUM
     C*                  CALL      'ZSFILE'
     C*                  PARM                    PSequence
     C*                  PARM      *BLANKS       PEntity
     C**                 PARM                    SFILE
     C*                  PARM                    ZSNUM
     C*                  PARM                    ZSERR
      *
      ** error during ZSFILE processing, return to calling program
      *
     C                   IF        ZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINIT   - Initial processing                                 *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      * Calls    : *PSSR  - Error handling subroutine                 *
      *                                                               *
      *****************************************************************
     C     SRINIT        BEGSR
     C     *ENTRY        PLIST
     C                   PARM                    PSequence
     C                   PARM                    PLevel
     C                   PARM                    PEntity
     C                   PARM                    POutFlds
 
     C                   MOVEA     PExceptions   SelEx
 
      ** access installation control data
      ** access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** if access program fails call SR. *PSSR
 
     C                   IF        PRetCode <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = '*FIRST'
     C                   EVAL      DBASE  = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** if fails goto END
 
     C                   IF        *IN80 = *ON
     C                   GOTO      IEND
     C                   ENDIF
 
      ** load printer file fields with date and title
 
     C                   EVAL      RRTITL = BJURPT
     C                   EVAL      RRRUNA = BJMRDT
     C                   EVAL      XRTITL = BJURPT                                          MD025220
     C                   EVAL      XRRUNA = BJMRDT                                          MD025220
     C                   EVAL      DRUND  = BJRDNB
 
      ** set number of records read to Zero
 
     C                   Z-ADD     0             WCALC
     C                   Z-ADD     0             WCALCC
     C                   Z-ADD     0             WCALCN
 
     C     IEND          ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCLOS   - Printer File Closure                               *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      * Calls    : SRFCP - File Control Processing                    *
      *                                                               *
      *****************************************************************
     C     SRCLOS        BEGSR
 
      ** call ZSFILE for audit report
 
     C*                  Z-ADD     SFNUMU        ZSNUM
     C*                  CALL      'ZSFILE'
     C*                  PARM                    PSequence
     C*                  PARM      *BLANK        PEntity
     C*                  PARM                    SFILEU
     C*                  PARM                    ZSNUM
     C*                  PARM                    ZSERR
 
      ** if error code = 'Y', then terminare the program
 
     C                   IF        ZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
      ** if database error has occured, output total report headings;
      ** print error message and exit program.
 
     C                   IF        *IN80 = *ON
     C                   WRITE     CONTROL
     C                   WRITE     DBERROR
     C                   GOTO      TEND
     C                   ENDIF
 
 
      ** if a database error has occured, bypass further processing
 
     C     *INU7         CABEQ     *ON           TEND
 
      ** prints 'END OF REPORT' if *IN50 ON.
 
     C                   IF        *IN50 = *ON
     C                   WRITE     SD000554R4
     C                   ENDIF
 
     C     TEND          ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFCP    - Produces Standard Totals Report                    *
      *                                                               *
      * Called by: SRCLOS - Termination Processing                    *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
     C     SRFCP         BEGSR
 
      ** set-up calculated number of records fields
 
     C                   Z-ADD     WCALC         RRCALC
     C                   Z-ADD     WCALCC        RRCALCC
     C                   Z-ADD     WCALCN        RRCALCN
 
      ** print standard totals report
 
     C                   WRITE     CONTROL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  -   Program exception error routine                    *
      *            Called automatically if a program error occurs,    *
      *            or directly by the program code using EXSR.        *
      *            This subroutine DUMPs the program just once.       *
      *                                                               *
      * Called by: *INZSR                                             *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = *BLANK
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
