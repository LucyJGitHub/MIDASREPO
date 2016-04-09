     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Customer Status Changed Today Report')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD1010 - Customer Status Changed Today Report                *
      *                                                               *
      *  Function:  This is a new daily report that lists the details *
      *  (COB)      of all Customers whose status is closed.          *
      *                                                               *
      *  Called By: SDC1010P - Customer Status Changed Today          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD025A            Date 27Apr05               *
      *  Prev Amend No. CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSD007  *CREATE    Date 28Aug00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD025A- Inactive status                                     *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CSD007 - Customer Closing                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    89         End of file on SDCUSTL1                         *
      *    98         Date Format is MMDDYY                           *
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
 
      ** Customer details retrieval
     FSDCUSTL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Customer status  changed audit report
     FSD1010AU  O    E             PRINTER INFDS(SPOOLU)
 
      ** Customer status  changed details report
     FSD1010P1  O    E             PRINTER USROPN
     F                                     INFDS(SPOOL1)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
 
      ** Data Area giving Installation Control Details
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
 
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** File Information Data Structure for SD1010P1.
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
 
      ** File Information Data Structure for SD1010AU.
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
 
      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Short data structure for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PRTCD           S              7
     D POPTN           S              7
     D WRCDAU          S              1
     D WOPNP1          S              1
     D RQDLN1          S              3  0
     D DIFLN1          S              3  0
     D WSEQ            S              5
     D WENTY           S              3
     D WFILE           S             10
     D ZSNUM           S              6  0
     D ZSERR           S              1
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     C                   EXSR      PROCES
 
     C                   EXSR      AUDIT
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * PROCES - Detail Processing                                    *
      *                                                               *
      * Called by: Main Processing                                    *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     PROCES        BEGSR
 
     C                   READ      @BBREBF                                89
 
      ** If end of file, no details to report
 
     C     *IN89         IFEQ      *ON
     C                   EXSR      AUDIT
     C                   ENDIF
 
      ** Else, print only those Customers whose Closure Status
      ** Change Date is equal to today
 
     C     *IN89         DOWEQ     *OFF
 
     C     BBCLDT        IFEQ      BJRDNB
     C     BBDEDT        OREQ      BJRDNB                                                    CSD025A
     C     CSD025        ANDEQ     'Y'                                                       CSD025A
     C                   MOVE      BBCUST        RCUST
     C                   MOVE      BBCSSN        RCSSN
     C                   MOVE      BBCRNM        RCRNM
     C                   MOVE      BBACOC        RACOC
     C     BBCLST        IFEQ      'Y'
     C                   MOVE      'Closed  '    RSTAT
     C                   ELSE
     C                   MOVE      'Released'    RSTAT
     C     BBDEAC        IFEQ      'Y'                                                       CSD025A
     C     CSD025        ANDEQ     'Y'                                                       CSD025A
     C                   MOVEL(P)  'Inactive'    RSTAT                                       CSD025A
     C                   ENDIF                                                               CSD025A
     C                   ENDIF
     C                   ADD       1             RCOUNT
     C                   EXSR      WP1REC
     C                   ENDIF
 
     C                   READ      @BBREBF                                89
 
     C                   ENDDO
 
      ** Output Audit report if no records were printed, else
      ** write End of report for the P1 printer file
 
     C     RCOUNT        IFEQ      *ZERO
     C                   EXSR      AUDIT
     C                   ELSE
     C                   EXSR      WP1END
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * WP1REC - Write a detail record to the report                  *
      *                                                               *
      * Called by: Main Processing                                    *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     WP1REC        BEGSR
 
     C     WOPNP1        IFNE      'Y'
     C                   MOVE      'Y'           WOPNP1
     C                   OPEN      SD1010P1
     C                   Z-ADD     SFNUM1        ZSNUM
     C                   MOVE      SFILE1        WFILE
     C                   EXSR      RCDRCF
     C                   ENDIF
 
      ** Check that sufficient lines remain for the format
 
     C                   Z-ADD     1             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C                   WRITE     DETAIL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * WP1END - Write end of report                                  *
      *                                                               *
      * Called by: Main Processing                                    *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     WP1END        BEGSR
 
      ** Check that sufficient lines remain for the format
 
     C                   Z-ADD     4             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C                   WRITE     TRAILP1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * AUDIT - Output audit report and end the program               *
      *                                                               *
      * Called by: ***                                                *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     AUDIT         BEGSR
 
      ** Enroll audit report via RCF if not yet recorded
 
     C     WRCDAU        IFNE      'Y'
     C                   MOVE      'Y'           WRCDAU
     C                   Z-ADD     SFNUMU        ZSNUM
     C                   MOVE      SFILEU        WFILE
     C                   EXSR      RCDRCF
     C                   ENDIF
 
     C                   WRITE     HEADAU
 
      ** If a database error has occurred, output DB Error details
 
     C     *INU7         IFEQ      *ON
     C                   WRITE     DBERROR
     C                   ELSE
 
      ** Else, write out number of records printed
 
     C     RCOUNT        IFEQ      *ZERO
     C                   WRITE     NODTLS
     C                   ELSE
     C                   WRITE     CONTROL
     C                   ENDIF
 
     C                   ENDIF
 
     C                   MOVE      *ON           *INLR
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RCDRCF - Register a printer file via RCF                      *
      *                                                               *
      * Called by: ***                                                *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     RCDRCF        BEGSR
 
     C                   CALL      'ZSFILE'
     C                   PARM      PSEQ          WSEQ
     C                   PARM      PENTY         WENTY
     C                   PARM                    WFILE
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR
 
     C     ZSERR         IFEQ      'Y'
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PSEQ              5
     C                   PARM                    PLEVL             1
     C                   PARM                    PENTY             3
 
      ** Define data areas
 
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
 
     C                   IF        AGDFF = 'M'
     C                   EVAL      *IN98 = *ON
     C                   END
 
      ** Call Access Program for Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE                         ***************
     C                   MOVEL     '*FIRST'      DBKEY                          * DB ERROR 01 *
     C                   MOVEL     'SD1010'      DBPGM                          ***************
     C                   Z-ADD     001           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Initialise work fields
 
     C                   MOVE      *BLANKS       WRCDAU
     C                   MOVE      *BLANKS       WOPNP1
     C                   Z-ADD     *ZERO         RQDLN1
     C                   Z-ADD     *ZERO         DIFLN1
     C                   Z-ADD     *ZERO         RCOUNT
 
      ** Access SAR details to check if CSD025 is installed                                  CSD025A
                                                                                             CSD025A
     C                   CALL      'AOSARDR0'                                                CSD025A
     C                   PARM      *BLANKS       PRTCD                                       CSD025A
     C                   PARM      '*VERIFY'     POPTN                                       CSD025A
     C                   PARM      'CSD025'      @SARD             6                         CSD025A
                                                                                             CSD025A
     C     PRTCD         IFNE      *BLANKS                                                   CSD025A
     C     PRTCD         ANDNE     '*NRF   '                                                 CSD025A
     C                   MOVEL     'SCSARDPD'    DBFILE                                      CSD025A
     C                   MOVEL     '912'         DBASE                                       CSD025A
     C                   MOVEL     @SARD         DBKEY                                       CSD025A
     C                   EXSR      *PSSR                                                     CSD025A
     C                   ENDIF                                                               CSD025A
                                                                                             CSD025A
     C     PRTCD         IFEQ      *BLANKS                                                   CSD025A
     C                   MOVEL     'Y'           CSD025            1                         CSD025A
     C                   ELSE                                                                CSD025A
     C                   MOVEL     'N'           CSD025                                      CSD025A
     C                   ENDIF                                                               CSD025A
      *                                                                                      CSD025A
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
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   DUMP
     C                   EXSR      AUDIT
 
     C                   ENDSR
