     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Document Management Report Control')          *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000710 - Document Management Report Control                *
      *                                                               *
      *  Function:  This is a new program to list the details of all  *
      *             Document Management Records for the Customer or   *
      *             Non-account Holders defined in the system.        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD029841           Date 29Aug14               *
      *  Prev Amend No. MD026276           Date 08Apr14               *
      *                 CSD093  *CREATE    Date 01Apr13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD029841 - SD000710AU 2 reports produced during COB          *
      *             Apply Fix MD027026                                *
      *  MD026276 - Incorrect Audit Report is generated when Documents*
      *             for Customers is requested in IC                  *
      *  CSD093 - Document Management                                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    05  - Overflow Indicator SD000710P1                        *
      *    06  - Change of Document Management Key                    *
      *    14  - End of File SDYLDRL2                                 *
      *    15  - Chain Fail on File SDYLDCL1                          *
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
 
      ** Midas SD Document Management File - Customer
     FSDDCMTL3  IF   E           K DISK
 
      ** Midas SD Document Management File - Non-Account Holder
     FSDDCMTL4  IF   E           K DISK    RENAME(SDDCMTD0:SDDCMTD4)
 
      ** Midas SD Customer Details File Retrieval Index
     FSDCUSTL1  IF   E           K DISK
 
      ** Midas SD Non Account Holder File Retrieval Index
     FSDNAHOL1  IF   E           K DISK
 
      ** Document Management Report Control
     FSD000710P1O    E             PRINTER INFSR(*PSSR)
     F                                     OFLIND(*IN05)
     F                                     USROPN
     F                                     INFDS(SPOOL)
 
      ** Document Management Report Audit
     FSD000710AUO    E             PRINTER INFSR(*PSSR)
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for Aacces Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Bank Details Accessed via Access Program
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Document Code Details Accessed via Access Program
     D SDDOCM        E DS                  EXTNAME(SDDOCMPD)
 
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
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WCUST           S             10
     D WRTYP           S              1
     D WRUN            S              1
     D WCALC           S              5  0
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
     D PSEQ            S              5
     D PENTY           S              3
     D PINTYP          S              1
 
     ** AOCTRY Parameters
     D PRTCD           S              7
     D POPTN           S              7
     D PDCCD           S              2
     D PCTRY           S              2
 
      * ZDATE1  parms
     D ZDATEA          S              6  0
     D ZDATFMT         S              1
     D ErrorFlag       S              1
 
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
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMAIN   - Main Processing                                    *
      *            Controls Set-up of SD000710P1 Details              *
      *            Outputs SD000710P1 Details                         *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      * Calls    : SRHDRD - Prepare Header Data for Printing          *
      *                                                               *
      *****************************************************************
     C     SRMAIN        BEGSR
 
      ** do until end of Document Management File
 
     C     *IN14         DOWNE     *ON
 
      ** reset change of Customer key indicator
 
     C                   EVAL      *IN06 = *OFF
 
      ** read the Document Management File
 
     C                   IF        PINTYP = 'C'
     C                   READ      SDDCMTL3                               14
     C                   ELSE
     C                   READ      SDDCMTL4                               14
     C                   ENDIF
 
      ** if eof then goto end
 
     C                   IF        *IN14 = *ON
     C                   EVAL      *INLR = *ON
     C                   GOTO      MEND
     C                   ENDIF
 
     C                   IF        (PMode = 'A' AND DMLCDT = BJRDNB)
     C                             OR PMode = 'L'
      ** check if Customer key has changed
      ** if so, prepare header data for printing
 
     C                   IF        DMREFN <> WCUST
     C                             OR DMRTYP <> WRTYP
     C                   EVAL      *IN06 = *ON
     C                   EXSR      SRHDRD
     C                   ENDIF
 
      ** if database error has occured no more processing in this
      ** routine
 
     C                   IF        *IN80 = *ON
     C                   GOTO      MEND
     C                   ENDIF
 
      ** open printer file and indicate that there is atleast one
      ** detail to report; ensure report spool file recorded by RCF
 
     C                   IF        *IN54 = *OFF
     C                   OPEN      SD000710P1
     C                   EVAL      *IN54 = *ON
 
     C                   Z-ADD     SFNUM         ZSNUM
     C                   CALL      'ZSFILE'
     C                   PARM                    PSEQ
     C                   PARM      *BLANKS       PENTY
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
 
     C                   ENDIF
 
      ** if Document Management Customer Changed
      ** or overflow indicator is on throw page and write header
 
     C                   IF        (*IN06 = *ON)  OR  (*IN05 = *ON)
     C                   IF        *IN05 = *ON
     C                   WRITE     SD0710R0
     C                   ENDIF
     C                   WRITE     SD0710S0
     C                   ENDIF
 
      ** prepare detail data for printing
 
     C                   EXSR      SRDETAIL
 
      ** if overflow indicator on, then set it off
 
     C                   IF        *IN05 = *ON
     C                   EVAL      *IN05 = *OFF
     C                   ENDIF
 
      ** write detail record to SD000710P1
 
     C                   WRITE     SD0710R1
 
      ** save Customer key for comparison to next read
 
     C                   EVAL      WCUST = DMREFN
     C                   EVAL      WRTYP = DMRTYP
 
      ** increment count of records output
 
     C                   ADD       1             WCALC
 
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
 
      * Set Report Details
 
     C                   EVAL      RDCODE = DMCODE
     C                   EXSR      SRDOCM
     C                   EVAL      RDDREF = DMDREF
 
     C                   SELECT
     C                   WHEN      DMSTCD = 'A'
     C                   EVAL      RDSTAT = 'RECEIVED'
     C                   WHEN      DMSTCD = 'C'
     C                   EVAL      RDSTAT = 'DELETED'
     C                   WHEN      DMSTCD = 'O'
     C                   EVAL      RDSTAT = 'OUTSTANDING'
     C                   WHEN      DMSTCD = 'R'
     C                   EVAL      RDSTAT = 'REQUESTED'
     C                   WHEN      DMSTCD = 'Z'
     C                   EVAL      RDSTAT = 'REJECTED'
     C                   ENDSL
 
     C                   EVAL      RDSYST = *BLANKS
     C                   IF        DRUND  > DMEXDT
     C                             AND DMEXDT > *ZERO
     C                             AND DMSTCD <> 'C'
     C                   EVAL      RDSYST = 'EXPIRED'
     C                   ELSE
     C                   IF        DRUND  > DMREQB
     C                             AND DMREQB > *ZERO
     C                             AND DMSTCD <> 'A'
     C                             AND DMSTCD <> 'C'
     C                   EVAL      RDSYST = 'OVERDUE'
     C                   ENDIF
     C                   ENDIF
      *
     C                   EVAL      ZDAYNO = DMLCDT
     C                   EXSR      SRDATE2
     C                   MOVEL     ZADATE        RDLCDT
      *
     C                   EVAL      RDLUSR = DMLUSR
      *
     C                   IF        DMLTYP = 'I'
     C                   EVAL      RDLTYP = 'INSERT'
     C                   ELSE
     C                   EVAL      RDLTYP = 'AMEND'
     C                   ENDIF
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
      *
      ** Chain to Customer File
      *
     C                   IF        DMRTYP = 'C'
     C                   MOVEL     DMREFN        KCUST
     C     KCUST         CHAIN     SDCUSTL1                           15
     C                   IF        *IN15 = *ON
     C                   EVAL      DBFILE = 'SDCUSTL1'
     C                   EVAL      DBASE = 3
     C                   EVAL      DBKEY = DMREFN
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Move Document Management Header fields to print fields
      *
     C                   EVAL      *IN11  = *ON
     C                   EVAL      *IN71  = *ON                                             MD026276
     C                   EVAL      RPTYPE = 'Customer Number   :'
     C                   EVAL      RPREFN = DMREFN
     C                   EVAL      RPCSSN = BBCSSN
     C                   EVAL      RPCRTN = BBCRTN
     C                   EVAL      RPCRNM = BBCRNM
     C                   ENDIF
     C                   IF        DMRTYP = 'N'
     C     DMREFN        CHAIN     SDNAHOL1                           15
     C                   IF        *IN15 = *ON
     C                   EVAL      DBFILE = 'SDNAHOL1'
     C                   EVAL      DBASE = 4
     C                   EVAL      DBKEY = DMREFN
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Move Document Management Header fields to print fields
      *
     C                   EVAL      *IN11  = *OFF
     C                   EVAL      *IN71  = *OFF                                            MD026276
     C                   EVAL      RPTYPE = 'Non-Account Holder:'
     C                   EVAL      RPREFN = DMREFN
     C                   EVAL      RPCSSN = *BLANKS
     C                   EVAL      RPCRTN = NHNATW
     C                   EVAL      RPCRNM = NHNARN
     C                   ENDIF
 
     C     HEND          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDOCM   - Get Document Code Details                          *
      *                                                               *
      * Called by: SRMAIN - Main Processing                           *
      *                                                               *
      * Calls    : *PSSR  - Error handling subroutine                 *
      *                                                               *
      *****************************************************************
     C     SRDOCM        BEGSR
      *
     C                   CALL      'AODOCMR2'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DMCODE        PDCCD
     C     SDDOCM        PARM      SDDOCM        DSSDY
      *
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBASE = 902
     C                   EVAL      DBKEY = PDCCD
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      RDNARR = ATDCNA
     C                   ENDIF
      *
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
     C                   PARM                    PMODE
     C                   PARM                    PINTYP
     C                   PARM                    PSEQ
     C                   PARM                    PENTY
 
      ** access installation control data
      ** access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** if access program fails call SR. *PSSR
 
     C                   IF        PRTCD <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = '*FIRST'
     C                   EVAL      DBASE  = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      *IN05 = *ON
 
      ** if fails goto END
 
     C                   IF        *IN80 = *ON
     C                   GOTO      IEND
     C                   ENDIF
 
      ** load printer file fields with date and title
 
     C                   EVAL      RRTITL = BJURPT
     C                   EVAL      RRRUNA = BJMRDT
     C                   EVAL      DRUND  = BJRDNB
 
      ** Change header depend if Audit or Full List Report
 
     C                   IF        PMode = 'A'
     C                   EVAL      *IN70  = *ON
     C                   ELSE
     C                   EVAL      *IN70  = *OFF
     C                   ENDIF
 
      ** Set Report Header Indicator for AU                                                 MD027026
                                                                                            MD027026
     C                   IF        PINTYP = 'C'                                             MD027026
     C                   EVAL      *IN71  = *ON                                             MD027026
     C                   ELSE                                                               MD027026
     C                   EVAL      *IN71  = *OFF                                            MD027026
     C                   ENDIF                                                              MD027026
                                                                                            MD027026
      ** set number of records read to Zero
 
     C                   Z-ADD     0             WCALC
 
     C     IEND          ENDSR
 
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
 
      ** call ZSFILE for audit report
 
     C                   Z-ADD     SFNUMU        ZSNUM
     C                   CALL      'ZSFILE'
     C                   PARM                    PSEQ
     C                   PARM      *BLANK        PENTY
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
     C                   WRITE     SD0710R2
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
     C                   EVAL      DBPGM = 'SD000710'
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
      ** set on database error indicator and dump
 
     C                   EVAL      *IN80 = *ON
     C                   DUMP
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2013
