     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Accounts for Review Report Control')          *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000713 - Accounts for Review Report Control                *
      *                                                               *
      *  Function:  This is a new program to list the details of all  *
      *             accounts for review based on notice days          *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSD092  *CREATE    Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD092 - Account Review                                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    05  - Overflow Indicator SD000713P1                        *
      *    14  - End of File SDACRVL3                                 *
      *    54  - At least one set of details output - used for        *
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
      *  SRTERM - Termination Processing                              *
      *  SRFCP  - File Control Processing                             *
      *  *PSSR  - Error Handling Subroutine                           *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+                     *
      ** ¦ F-specs                              ¦                     *
      ** ¦ =======                              ¦                     *
      ** +--------------------------------------+                     *
      *****************************************************************
 
      ** Account Review File
     FSDACRVL3  IF   E           K DISK
 
      ** RPT: Account Review Report Control
     FSD000713P1O    E             PRINTER INFSR(*PSSR)
     F                                     OFLIND(*IN05)
     F                                     USROPN
     F                                     INFDS(SPOOL)
 
      ** RPT: Account Review Report Audit
     FSD000713AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      ** Data Area giving Installation Control Details
 
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D SYSVAL1         C                    'AccRevNotDaysActRept'
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D WCUST           S             10
     D WRTYP           S              1
     D WRUN            S              1
     D WCALC           S              5  0
     D DRUND           S              5  0
     D DNRDT           S              5  0
     D DDAYS           S              5  0
     D DCMPT           S              5  0
     D PRTCD           S              7
     D POPTN           S              7
     D WFOUND          S              1
     D PCNUM           S             10
     D PCNST           S              7
     D SENTY           S              3
     D WDAYS           S              5
     D WFMTYR          S              5
     D WREC            S              1
     D ENT             S              3
 
      ** ZSFILE Parameters
     D ZSERR           S              1
     D ZSNUM           S              6  0
     D KCUST           S              6
 
      ** ZDATE2 Parameters
     D ZDAYNO          S              5  0
     D ZDATE           S              6  0
     D ZADATE          S              7
 
      ** PLIST Parameters
     D SEQ             S              5
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for Aacces Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Bank Details Accessed via Access Program
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
     D                 DS
     D  WJOB                 244    253
     D  WUSER                254    263
 
      ** SPOOL Information Data Structure for ZSFILE
     D SPOOL           DS
     D  SFILE                 83     92
     D  SFNUM                123    124B 0
 
      ** SPOOL Information Data Structure for ZSFILE - AU Report
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
 
     D RPSCDT          DS
     D  WWMNTH                 3      5
     D  WWMTYR                 3      7
 
      ** Parameters for AOSVALR0
     D PDRTCD          S              7A
     D PDOP01          S             20A
     D PDOP02          S             20A
     D PDOP03          S             20A
     D PDOP04          S             20A
     D PDOP05          S             20A
     D PDOP06          S             20A
     D PDOP07          S             20A
     D PDOP08          S             20A
     D PDOP09          S             20A
     D PDOP10          S             20A
     D PDVL01          S            200A
     D PDVL02          S            200A
     D PDVL03          S            200A
     D PDVL04          S            200A
     D PDVL05          S            200A
     D PDVL06          S            200A
     D PDVL07          S            200A
     D PDVL08          S            200A
     D PDVL09          S            200A
     D PDVL10          S            200A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Initial Processing
 
     C                   EXSR      SRINIT
 
      ** Main Processing
 
     C                   EXSR      SRMAIN
 
      ** Termination Processing
 
     C                   EXSR      SRTERM
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMAIN   - Main Processing                                    *
      *            Controls Set-up of SD000713P1 Details              *
      *            Outputs SD000713P1 Details                         *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      * Calls    : SRHDRD - Prepare Header Data for Printing          *
      *                                                               *
      *****************************************************************
 
     C     SRMAIN        BEGSR
 
     C                   EVAL      WREC = 'N'
     C                   EVALR     WDAYS = %TRIM(PDVL01)
     C                   MOVE      WDAYS         DDAYS
 
     C                   READ      SDACRVL3                               14
 
     C                   IF        *IN14 = *OFF
 
      ** Set Report Details
     C                   EVAL      RPSCDT = *BLANKS
     C                   IF        ARSCDT <> *ZERO
     C                   Z-ADD     ARSCDT        ZDAYNO
     C                   EXSR      SRDATE2
     C                   MOVEL     ZADATE        RPSCDT
     C                   MOVE      WWMNTH        RPMNTH
     C                   MOVE      WWMTYR        WFMTYR
     C                   ENDIF
     C                   ENDIF
 
      ** Do until end of Account Review File
 
     C     *IN14         DOWEQ     *OFF
 
      ** if eof then goto end
 
     C                   IF        *IN14 = *ON
     C                   EVAL      *INLR = *ON
     C                   GOTO      MEND
     C                   ENDIF
 
     C                   EVAL      DNRDT = ARSCDT
     C                   EVAL      DCMPT = DNRDT - DDAYS
     C                   EVAL      WFOUND = 'N'
 
     C                   IF        DCMPT <= DRUND
     C                   EVAL      WFOUND = 'Y'
     C                   EVAL      WREC = 'Y'
     C                   ENDIF
 
      ** Open printer file and indicate that there is at least one
      ** detail to report; ensure report spool file recorded by RCF
 
     C                   IF        *IN54 = *OFF AND WFOUND = 'Y'
     C                   OPEN      SD000713P1
     C                   EVAL      *IN54 = *ON
 
     C                   Z-ADD     SFNUM         ZSNUM
     C                   CALL      'ZSFILE'
     C                   PARM                    SEQ
     C                   PARM      *BLANKS       SENTY
     C                   PARM                    SFILE
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR
 
      ** error during ZSFILE processing, return to calling program
 
     C                   IF        ZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   WRITE     SD0713R0
 
     C                   ENDIF
 
     C                   IF        WFOUND = 'Y'
 
      ** If overflow indicator is on, write new header
 
     C                   IF        *IN05 = *ON
     C                   WRITE     SD0713R0
     C                   ENDIF
 
      ** prepare detail data for printing
 
     C                   EXSR      SRDETAIL
 
      ** if overflow indicator on, then set it off
 
     C                   IF        *IN05 = *ON
     C                   EVAL      *IN05 = *OFF
     C                   ENDIF
 
      ** Write detail record to SD000713P1
 
     C                   WRITE     SD0713R1
 
      ** increment count of records output
 
     C                   ADD       1             WCALC
     C                   ENDIF
 
     C                   READ      SDACRVL3                               14
 
     C                   IF        *IN14 = *OFF
 
      ** Set Report Details
     C                   EVAL      RPSCDT = *BLANKS
     C                   IF        ARSCDT <> *ZERO
     C                   Z-ADD     ARSCDT        ZDAYNO
     C                   EXSR      SRDATE2
     C                   MOVEL     ZADATE        RPSCDT
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        WWMTYR <> WFMTYR OR
     C                             *IN14 = '1'
     C                   IF        WREC = 'Y'
     C                   WRITE     SD0713R3
     C                   MOVE      WWMNTH        RPMNTH
     C                   MOVE      WWMTYR        WFMTYR
     C                   EVAL      WREC = 'N'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDDO
 
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
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      ARCUST        PCNUM
     C                   PARM                    PCNST
     C     SDCUST        PARM      SDCUST        DSSDY
 
      ** Database error
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBKEY  = ARCUST
     C                   EVAL      DBASE  = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      RPCUST = ARCUST
     C                   EVAL      RPCSSN = BBCSSN
     C                   EVAL      RPCRNM = BBCRNM
     C                   EVAL      RPCRTN = BBCRTN
 
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
      * SRINIT   - Initial processing                                 *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      * Calls    : *PSSR  - Error handling subroutine                 *
      *                                                               *
      *****************************************************************
 
     C     SRINIT        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    SEQ
     C                   PARM                    ENT
 
      ** Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '       '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** If access program fails call SR. *PSSR
 
     C                   IF        PRTCD <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = '*FIRST'
     C                   EVAL      DBASE  = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PDRTCD
     C                   PARM      SYSVAL1       PDOP01
     C                   PARM      *BLANKS       PDVL01
     C                   PARM      *BLANKS       PDOP02
     C                   PARM      *BLANKS       PDVL02
     C                   PARM      *BLANKS       PDOP03
     C                   PARM      *BLANKS       PDVL03
     C                   PARM      *BLANKS       PDOP04
     C                   PARM      *BLANKS       PDVL04
     C                   PARM      *BLANKS       PDOP05
     C                   PARM      *BLANKS       PDVL05
     C                   PARM      *BLANKS       PDOP06
     C                   PARM      *BLANKS       PDVL06
     C                   PARM      *BLANKS       PDOP07
     C                   PARM      *BLANKS       PDVL07
     C                   PARM      *BLANKS       PDOP08
     C                   PARM      *BLANKS       PDVL08
     C                   PARM      *BLANKS       PDOP09
     C                   PARM      *BLANKS       PDVL09
     C                   PARM      *BLANKS       PDOP10
     C                   PARM      *BLANKS       PDVL10
 
     C     PDRTCD        IFNE      *BLANKS
     C                   EVAL      DBKEY = SYSVAL1
     C                   EVAL      DBFILE = 'SDSVALPD'
     C                   EVAL      DBASE = 1
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Load printer file fields with date and title
 
     C                   EVAL      RRTITL = BJURPT
     C                   EVAL      RRRUNA = BJMRDT
     C                   EVAL      DRUND  = BJRDNB
 
      ** Set number of records read to Zero
 
     C                   Z-ADD     0             WCALC
     C                   EVAL      WFOUND = 'N'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRTERM   - Termination processing                             *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      * Calls    : SRFCP - File Control Processing                    *
      *                                                               *
      *****************************************************************
 
     C     SRTERM        BEGSR
 
      ** Call ZSFILE for audit report
 
     C                   Z-ADD     SFNUMU        ZSNUM
     C                   CALL      'ZSFILE'
     C                   PARM                    SEQ
     C                   PARM      *BLANK        SENTY
     C                   PARM                    SFILEU
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR
 
      ** If error code = 'Y', then terminate the program
 
     C                   IF        ZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
      ** If database error has occured, output total report headings;
      ** print error message and exit program.
 
     C                   IF        *IN80 = *ON
     C                   WRITE     CONTROL
     C                   WRITE     DBERROR
     C                   GOTO      TEND
     C                   ENDIF
 
      ** Produce standard totals report
 
     C                   EXSR      SRFCP
 
      ** If a database error has occured, bypass further processing
 
     C     *INU7         CABEQ     *ON           TEND
 
      ** Prints 'END OF REPORT' if *IN54 ON.
 
     C                   IF        *IN54 = *ON
     C                   WRITE     SD0713R2
     C                   ENDIF
 
     C                   RETURN
 
     C     TEND          ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFCP    - Produces Standard Totals Report                    *
      *                                                               *
      * Called by: SRTERM - Termination Processing                    *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
 
     C     SRFCP         BEGSR
 
      ** Set-up calculated number of records fields
 
     C                   Z-ADD     WCALC         RRCALC
 
      ** Print standard totals report
 
     C                   WRITE     CONTROL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR    - Error handling subroutine                          *
      *            Executes whenever field or program exception       *
      *            error occurs                                       *
      *                                                               *
      * Called by: SRHDRD - Prepare Header Data for Printing          *
      *            SRINIT - Initial processing                        *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   IF        WRUN  = *BLANK
     C                   EVAL      WRUN = 'Y'
     C                   EVAL      DBPGM = 'SD000713'
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
      ** Set on database error indicator and dump
 
     C                   EVAL      *IN80 = *ON
     C                   DUMP
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2013
