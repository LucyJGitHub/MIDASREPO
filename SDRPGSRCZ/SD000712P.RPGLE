     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Document Management Report Control')          *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000712P - Document Management Report Control               *
      *                                                               *
      *  Function:  This is a new program to list the details of all  *
      *             Document Management Records defined in the system *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. CSD100             Date 17Aug17               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CSD093  *CREATE    Date 01Apr13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD100 - Patronymic and Gender fields for Non-Account Holder *
      *           (Recompile)                                         *      
      *  MD046248 - Finastra Rebranding                               *
      *  CSD093 - Document Management                                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    05  - Overflow Indicator SD000712P1                        *
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
 
      ** RTV: Document Management File - Customer
     FSDDCMTL6  IF   E           K DISK
 
      ** RTV: Document Management File - Non-Account Holder
     FSDDCMTL7  IF   E           K DISK    RENAME(SDDCMTD0:SDDCMTD7)
 
      ** RTV: Customer Details File Retrieval Index
     FSDCUSTL1  IF   E           K DISK
 
      ** RTV: Non Account Holder File Retrieval Index
     FSDNAHOL1  IF   E           K DISK
 
      ** RPT: Document Management Report Control
     FSD000712P1O    E             PRINTER INFSR(*PSSR)
     F                                     OFLIND(*IN05)
     F                                     USROPN
     F                                     INFDS(SPOOL)
 
      ** RPT: Document Management Report Audit
     FSD000712AUO    E             PRINTER INFSR(*PSSR)
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
 
      ** Country Codes Details
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
 
      ** SPOOL Information Data Structure for ZSFILE
     D SPOOL           DS
 
      ** SPOOL Information Data Structure for ZSFILE - AU Report
     D  SFILE                 83     92
     D  SFNUM                123    124B 0
     D SPOOLU          DS
 
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
 
     D PData           DS           100
     D  PDEXP                  1      1A
     D  PDOVR                  2      2A
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WCUST           S             10
     D WRTYP           S              1
     D WRUN            S              1
     D WCALC           S              5  0
     D WCALCEXP        S              5  0
     D WCALCOVR        S              5  0
     D DRUND           S              5  0
     D SENTY           S              3
     D WWTMST          S             26A
     D WSEL            S              1A
     D WDAYS           S              2A
     D WNoticeDays     S              2  0
     D WRepDate        S              5  0
 
      ** ZSFILE Parameters
     D ZSERR           S              1
     D ZSNUM           S              6  0
     D KCUST           S              6
 
      ** ZDATE2 Parameters
     D ZDAYNO          S              5  0
     D ZDATE           S              6  0
     D ZADATE          S              7
 
      ** PLIST Parameters
     D PSeq            S              5
     D PLevel          S              1
     D PEnty           S              3
 
      ** AOCTRY Parameters
     D PRTCD           S              7
     D POPTN           S              7
     D PDCCD           S              2
     D PCTRY           S              2
 
      ** ZDATE1 parms
     D ZDATEA          S              6  0
     D ZDATFMT         S              1
     D ErrorFlag       S              1
 
      ** Parameters for AOSVALR0
     D P@OP01          S             20A
     D P@OP02          S             20A
     D P@OP03          S             20A
     D P@OP04          S             20A
     D P@OP05          S             20A
     D P@OP06          S             20A
     D P@OP07          S             20A
     D P@OP08          S             20A
     D P@OP09          S             20A
     D P@OP10          S             20A
     D P@VL01          S            200A
     D P@VL02          S            200A
     D P@VL03          S            200A
     D P@VL04          S            200A
     D P@VL05          S            200A
     D P@VL06          S            200A
     D P@VL07          S            200A
     D P@VL08          S            200A
     D P@VL09          S            200A
     D P@VL10          S            200A
 
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
      *            Controls Set-up of SD000712P1 Details              *
      *            Outputs SD000712P1 Details                         *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      *****************************************************************
     C     SRMAIN        BEGSR
 
     C                   IF        PDEXP = 'Y'
     C                   EVAL      WSel = 'E'
     C                   EVAL      WRTYP = *BLANKS
     C                   EXSR      SREXPIRE
     C                   ENDIF
      *
     C                   IF        PDOVR = 'Y'
     C                   EVAL      WSel = 'O'
     C                   EVAL      WRTYP = *BLANKS
     C                   EXSR      SROVERDUE
     C                   ENDIF
 
     C     MEND          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREXPIRE - Main Processing                                    *
      *            Controls Set-up of SD000712P1 Details              *
      *            Outputs SD000712P1 Details                         *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      *****************************************************************
     C     SREXPIRE      BEGSR
 
      ** Do until end of Document Management File
 
     C                   DOW       NOT %EOF (SDDCMTL6)
 
      ** Read through soon to Expire Customers or Non-account Holders
 
     C                   READ      SDDCMTL6                               14
 
     C                   IF        NOT %EOF(SDDCMTL6)
     C                             AND DMEXDT <> *ZERO
     C                             AND DMEXDT <= WRepDate
     C                             AND DMSTCD <> 'C'
 
     C                   IF        DMRTYP <> WRTYP
     C                   EXSR      SRCLOSEP1
     C                   EXSR      SROPENP1
     C                   EXSR      SRHEADER
     C                   ENDIF
 
      ** If database error has occured no more processing in this
      ** routine
 
     C                   IF        *IN80 = *ON
     C                   LEAVE
     C                   ENDIF
 
     C                   EXSR      SRPRINT
 
      ** Calculate soon to Expire Documents
     C                   ADD       1             WCALCEXP
 
     C                   ENDIF
     C                   ENDDO
 
     C     EEND          ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SROVERDUE - Overdue Processing                                *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      *****************************************************************
     C     SROVERDUE     BEGSR
 
      ** Do until end of Document Management File
 
     C                   DOW       NOT %EOF (SDDCMTL7)
 
      ** Read through soon to Overdue Customers or Non-account Holders
 
     C                   READ      SDDCMTL7                               14
 
     C                   IF        NOT %EOF(SDDCMTL7)
     C                             AND DMREQB <> *ZERO
     C                             AND DMREQB <= WRepDate
     C                             AND DMSTCD <> 'A'
     C                             AND DMSTCD <> 'C'
 
     C                   IF        DMRTYP <> WRTYP
     C                   EXSR      SRCLOSEP1
     C                   EXSR      SROPENP1
     C                   EXSR      SRHEADER
     C                   ENDIF
 
      ** If database error has occured no more processing in this
      ** routine
 
     C                   IF        *IN80 = *ON
     C                   LEAVE
     C                   ENDIF
 
     C                   EXSR      SRPRINT
 
      ** Calculate soon to Expire Documents
     C                   ADD       1             WCALCOVR
 
     C                   ENDIF
     C                   ENDDO
 
     C     OEND          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRHEADER  - Main Processing                                   *
      *            Controls Set-up of SD000712P1 Details              *
      *            Outputs SD000712P1 Details                         *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      *****************************************************************
     C     SRHEADER      BEGSR
 
     C                   IF        DMRTYP = 'C'
     C                   EVAL      *IN11 = *ON
     C                   ELSE
     C                   EVAL      *IN11 = *OFF
     C                   ENDIF
 
     C                   IF        WSEL   = 'E'
     C                   EVAL      *IN10 = *ON
     C                   ELSE
     C                   EVAL      *IN10 = *OFF
     C                   ENDIF
 
      ** Write header
     C                   WRITE     SD0712R0
 
     C     HEND          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCLOSEP1 - Main Processing                                   *
      *            Controls Set-up of SD000712P1 Details              *
      *            Outputs SD000712P1 Details                         *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      *****************************************************************
     C     SRCLOSEP1     BEGSR
 
     C                   IF        %OPEN (SD000712P1)
     C                   CLOSE     SD000712P1
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SROPENP1 - Main Processing                                    *
      *            Controls Set-up of SD000712P1 Details              *
      *            Outputs SD000712P1 Details                         *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      *****************************************************************
     C     SROPENP1      BEGSR
 
      ** open printer file and indicate that there is atleast one
      ** detail to report; ensure report spool file recorded by RCF
 
     C                   IF        NOT %OPEN (SD000712P1)
     C                   OPEN      SD000712P1
 
     C                   Z-ADD     SFNUM         ZSNUM
     C                   CALL      'ZSFILE'
     C                   PARM                    PSEQ
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
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMAIN   - Main Processing                                    *
      *            Controls Set-up of SD000712P1 Details              *
      *            Outputs SD000712P1 Details                         *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      *****************************************************************
     C     SRPRINT       BEGSR
 
      ** If overflow indicator is on throw page and write header
 
     C                   IF        *IN05 = *ON
     C                   EXSR      SRHEADER
     C                   ENDIF
 
      ** Prepare detail data for printing
 
     C                   EXSR      SRDETAIL
 
      ** If overflow indicator on, then set it off
 
     C                   IF        *IN05 = *ON
     C                   EVAL      *IN05 = *OFF
     C                   ENDIF
 
      ** Write detail record to SD000712P1
 
     C                   WRITE     SD0712R1
 
      ** Save Customer key for comparison to next read
 
     C                   EVAL      WCUST = DMREFN
     C                   EVAL      WRTYP = DMRTYP
 
      ** Increment count of records output
 
     C                   ADD       1             WCALC
     C     PEND          ENDSR
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
 
      * Expiry or Overdue Date
     C                   IF        WSEL = 'E'
     C                   EVAL      ZDAYNO = DMEXDT
     C                   EXSR      SRDATE2
     C                   EVAL      RDDATE = ZADATE
     C                   ENDIF
     C                   IF        WSEL = 'O'
     C                   EVAL      ZDAYNO = DMREQB
     C                   EXSR      SRDATE2
     C                   EVAL      RDDATE = ZADATE
     C                   ENDIF
 
     C                   EVAL      RDCUST = DMREFN
     C                   EXSR      SRCUST
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
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDATE2  - Convert Midas Date to Report Date                  *
      *                                                               *
      * Called by: SRMAIN - Main Processing                           *
      *                                                               *
      * Calls    : *PSSR  - Error handling subroutine                 *
      *                                                               *
      *****************************************************************
     C     SRDATE2       BEGSR
      *
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCUST   - Access Customer or Non-Account Holder Details      *
      *                                                               *
      * Called by: SRMAIN - Main Processing                           *
      *                                                               *
      * Calls    : *PSSR  - Error handling subroutine                 *
      *                                                               *
      *****************************************************************
     C     SRCUST        BEGSR
 
      ** chain to Customer File
     C                   IF        DMRTYP = 'C'
     C                   MOVEL     DMREFN        KCUST
     C     KCUST         CHAIN     SDCUSTL1                           15
     C                   IF        NOT %FOUND (SDCUSTL1)
     C                   EVAL      DBFILE = 'SDCUSTL1'
     C                   EVAL      DBASE = 3
     C                   EVAL      DBKEY = DMREFN
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** move Document Management Header fields to print fields
 
     C                   EVAL      RDCRTN = BBCRTN
     C                   EVAL      RDCRNM = BBCRNM
     C                   ENDIF
     C                   IF        DMRTYP = 'N'
     C     DMREFN        CHAIN     SDNAHOL1                           15
     C                   IF        NOT %FOUND (SDNAHOL1)
     C                   EVAL      DBFILE = 'SDNAHOL1'
     C                   EVAL      DBASE = 4
     C                   EVAL      DBKEY = DMREFN
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Move Document Management Header fields to print fields
 
     C                   EVAL      RDCRTN = NHNATW
     C                   EVAL      RDCRNM = NHNARN
     C                   ENDIF
 
 
     C     CEND          ENDSR
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
     C                   MOVEL     '902'         DBASE
     C                   MOVEL     PDCCD         DBKEY
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
      * SRSVAL   - Get Notice Days Details from System Values         *
      *                                                               *
      * Called by: SRMAIN - Main Processing                           *
      *                                                               *
      * Calls    : *PSSR  - Error handling subroutine                 *
      *                                                               *
      *****************************************************************
     C     SRSVAL        BEGSR
      *
     C                   EVAL      P@OP01 = 'DocMngNotDaysActRept'
 
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtcd             7
     C                   PARM                    P@OP01           20
     C                   PARM                    P@VL01          200
     C                   PARM                    P@OP02           20
     C                   PARM                    P@VL02          200
     C                   PARM                    P@OP03           20
     C                   PARM                    P@VL03          200
     C                   PARM                    P@OP04           20
     C                   PARM                    P@VL04          200
     C                   PARM                    P@OP05           20
     C                   PARM                    P@VL05          200
     C                   PARM                    P@OP06           20
     C                   PARM                    P@VL06          200
     C                   PARM                    P@OP07           20
     C                   PARM                    P@VL07          200
     C                   PARM                    P@OP08           20
     C                   PARM                    P@VL08          200
     C                   PARM                    P@OP09           20
     C                   PARM                    P@VL09          200
     C                   PARM                    P@OP10           20
     C                   PARM                    P@VL10          200
 
     C                   IF        PRtcd <> *Blanks  AND
     C                             PRtcd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDSVALPD'
     C                   EVAL      DBKEY = 'P@OP01'
     C                   EVAL      DBASE = 903
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVALR     WDAYS = %TRIM(P@VL01)
     C                   MOVE      WDAYS         WNoticeDays
     C                   EVAL      WRepDate = WNoticeDays + DRUND
     C                   ENDIF
 
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
     C                   PARM      *BLANKS       PRTCD
     C                   PARM                    ZDATEA
     C                   PARM                    ZDATFMT
     C                   PARM                    ZDAYNO
 
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
     C                   PARM                    PSeq
     C                   PARM                    PLevel
     C                   PARM                    PEnty
     C                   PARM                    PData
 
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
 
      ** if fails goto END
 
     C                   IF        *IN80 = *ON
     C                   GOTO      IEND
     C                   ENDIF
 
      ** load printer file fields with date and title
 
     C                   EVAL      RRTITL = BJURPT
     C                   EVAL      RRRUNA = BJMRDT
     C                   EVAL      DRUND  = BJRDNB
 
     C                   EXSR      SRSVAL
 
      ** set number of records read to Zero
 
     C                   Z-ADD     0             WCALC
     C                   Z-ADD     0             WCALCEXP
     C                   Z-ADD     0             WCALCOVR
 
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
     C                   WRITE     SD0712R2
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
 
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
     C                   Z-ADD     WCALCEXP      RREXPNO
     C                   Z-ADD     WCALCOVR      RROVRNO
 
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
      * Called by: SRINIT - Initial processing                        *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WRUN  = *BLANK
     C                   EVAL      WRUN = 'Y'
     C                   EVAL      DBPGM = 'SD000712'
 
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
(c) Finastra International Limited 2013
