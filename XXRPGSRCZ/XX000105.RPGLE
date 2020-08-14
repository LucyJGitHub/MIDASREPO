     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2017')
      *****************************************************************
/*STD *  RPGBASEMODE                                                  *
/*EXI *  TEXT('Midas SD Income & Expense Mapping Report')             *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  XX000105 - Income and Expense Account Mapping Report         *
      *                                                               *
      *  Function:  This is a new program to list the details of the  *
      *             Income and Expense Account Codes and their        *
      *             Profit & Loss and Spot Trading Account Codes      *
      *             which will be used to post to multiple Retained   *
      *             Earnings accounts.                                *
      *                                                               *
      *  (c) Finastra International Limited 2017                      *
      *                                                               *
      *  Last Amend No. FVT102  *CREATE     Date 08May17              *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  FVT102 - Posting of Profit and Loss to Multiple Retained     *
      *           Earnings Accounts.                                  *
      *                                                               *
      *****************************************************************
      *  Note:  The structure of this new program has been based on   *
      *         the existing core RPGLE program SD000742.             *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    05  - Overflow Indicator XX000105P1                        *
      *    14  - End of File XXINEXL1                                 *
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

     FXXINEXL1  IF   E           K DISK
      ** RTV: SD Mapped Income & Expense by INC1 - Retrieval Index

     FXX000105P1O    E             PRINTER INFSR(*PSSR)
     F                                     OFLIND(*IN05)
     F                                     USROPN
     F                                     INFDS(SPOOL)
      ** RPT: Income & Expense a/c Mapping Report

     FXX000105AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
      ** RPT: Income & Expense a/c Mapping Report Audit

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

     D WRUN            S              1
     D ZDAYNO          S              5  0
     D ZDATE           S              6  0
     D ZADATE          S              7

     D FVT102          S              1
     D FirstRec        S              1

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D CONS            S             20    DIM(2) CTDATA PERRCD(1)

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Aacces Programs, Long Data Structure

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank Details Accessed via Access Program

     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** External DS for SAR Details

     D  @JOB                 244    253
     D  @USER                254    263
     D                 DS
     D SPOOL           DS
      ** SPOOL Information Data Structure for ZSFILE

     D  SFILE                 83     92
     D  SFNUM                123    124B 0
     D SPOOLU          DS
      ** SPOOL Information Data Structure for ZSFILE - AU Report

     D  SFILEU                83     92
     D  SFNUMU               123    124B 0

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
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

      ** Initial Processing

     C                   EXSR      SRINIT

      ** Main Processing

     C                   EXSR      SRMAIN

      ** Termination Processing

     C                   EXSR      SRTERM

      /EJECT
      *****************************************************************
      *                                                               *
      * SRMAIN   - Main Processing                                    *
      *            Controls Set-up of XX000105P1 Details              *
      *            Outputs XX000105P1 Details                         *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      * Calls    :                                                    *
      *                                                               *
      *****************************************************************
     C     SRMAIN        BEGSR

      ** do until end of Income & Expense a/c mapping file

     C     *IN14         DOWNE     *ON

      ** read the Income & Expense a/c mapping file

     C                   READ      XXINEXL1                               14

      ** if eof then goto end

     C                   IF        *IN14 = *ON
     C                   EVAL      *INLR = *ON
     C                   GOTO      MEND
     C                   ENDIF

      ** if database error has occured no more processing in this
      ** routine

     C                   IF        *IN80 = *ON
     C                   GOTO      MEND
     C                   ENDIF

      ** open printer file and indicate that there is at least one
      ** detail to report; ensure report spool file recorded by RCF

     C                   IF        *IN54 = *OFF
     C                   OPEN      XX000105P1
     C                   EVAL      *IN54 = *ON

     C                   Z-ADD     SFNUM         ZSNUM             6 0
     C                   CALL      'ZSFILE'
     C                   PARM                    SEQ
     C                   PARM      *BLANKS       SENTY             3
     C                   PARM                    SFILE
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR             1

      ** error during ZSFILE processing, return to calling program

     C                   IF        ZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF

     C                   ENDIF

      ** If processing the first Income & Expense Detail record
      ** or overflow indicator is on, throw page and write header

     C                   IF        (FirstRec = 'Y') or (*IN05 = *ON)
     C                   WRITE     XX0105R0
     C                   ENDIF

     C                   EVAL      FirstRec  = 'N'

      ** Clear previous detail data from print output fields.

     C                   EVAL      XRINC1 = *BLANKS
     C                   EVAL      XRINC2 = *BLANKS
     C                   EVAL      XRPLA1 = *BLANKS
     C                   EVAL      XRSRVL = *BLANKS
     C                   EVAL      XRLCDT = *BLANKS
     C                   EVAL      XRLCTP = *BLANKS

      ** Output detail data for printing.

     C                   IF        MAINC1 <> *ZERO
     C                   MOVE      MAINC1        XRINC1
     C                   ENDIF

     C                   IF        MAINC2 <> *ZERO
     C                   MOVE      MAINC2        XRINC2
     C                   ENDIF

     C                   IF        MAPLA1 <> *ZERO
     C                   MOVE      MAPLA1        XRPLA1
     C                   ENDIF

     C                   MOVE      MASRVL        XRSRVL

      ** Convert last change date to DDMMMYY format.

     C                   EVAL      ZDAYNO = MALCDT
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        ZDATE
     C                   PARM      *BLANKS       ZADATE

     C                   EVAL      XRLCDT = ZADATE

      ** Output last change type in words.

     C                   IF        MALCTP = 'I'
     C                   EVAL      XRLCTP = CONS(1)
     C                   ENDIF

     C                   IF        MALCTP = 'A'
     C                   EVAL      XRLCTP = CONS(2)
     C                   ENDIF

      ** if overflow indicator on, then set it off

     C                   IF        *IN05 = *ON
     C                   EVAL      *IN05 = *OFF
     C                   ENDIF

      ** write detail record to XX000105P1

     C                   WRITE     XX0105R1

      ** increment count of records output

     C                   ADD       1             WCALC

     C                   ENDDO

     C                   EVAL      *INLR = *ON

     C     MEND          ENDSR

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
     C                   PARM                    SEQ               5

      ** access installation control data
      ** access bank details

     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY

      ** if access program fails call SR. *PSSR

     C                   IF        PRTCD <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = '*FIRST'
     C                   EVAL      DBASE  = 1
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

      ** set number of records read to Zero

     C                   Z-ADD     0             WCALC             5 0

      ** Check if switchable feature FVT102 is switched on

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY '    @OPTN
     C                   PARM      'FVT102'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        @RTCD <> *BLANKS AND
     C                             @RTCD <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE  = 2
     C                   EVAL      DBKEY  = 'FVT102'
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        @RTCD = *BLANKS
     C                   EVAL      FVT102 = 'Y'
     C                   ELSE
     C                   EVAL      FVT102 = 'N'
     C                   ENDIF

     C                   EVAL      FirstRec  = 'Y'

     C     IEND          ENDSR

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

      ** call ZSFILE for audit report

     C                   Z-ADD     SFNUMU        ZSNUM             6 0
     C                   CALL      'ZSFILE'
     C                   PARM                    SEQ
     C                   PARM      *BLANK        SENTY
     C                   PARM                    SFILEU
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR

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

      ** produce standard totals report

     C                   EXSR      SRFCP

      ** if a database error has occured, bypass further processing

     C     *INU7         CABEQ     *ON           TEND

      ** prints 'END OF REPORT' if *IN54 ON.

     C                   IF        *IN54 = *ON
     C                   WRITE     XX0105R2
     C                   ENDIF

     C                   RETURN

     C     TEND          ENDSR

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

      ** set-up calculated number of records fields

     C                   Z-ADD     WCALC         RRCALC

      ** print standard totals report

     C                   WRITE     CONTROL

     C                   ENDSR

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
     C                   EVAL      DBPGM = 'XX000105'

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

      ** set on database error indicator and dump

     C                   EVAL      *IN80 = *ON
     C                   DUMP

     C                   ENDIF

     C                   ENDSR

      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited. 2006
** CONS Constants used in program.
Insert
Amend
