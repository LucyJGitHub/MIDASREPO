     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD FATCA Classfn Codes Report Control')          *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000550 - FATCA Classfn Codes Report Control                *
      *                                                               *
      *  Function:  This is a new program to list the details of      *
      *             FATCA Classification Codes defined in the system  *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD033502           Date 04Mar15               *
      *                 CGL154             Date 13Oct14               *
      *                 MD024613           Date 30Jan14               *
      *                 CGL132  *CREATE    Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD033502 - Component is in infinite loop                     *
      *  CGL154 - FATCA Reporting                                     *
      *  MD024613 - Fields for ICY and COB Reports for FATCA          *
      *             Classification Codes are inconsistent with FDS    *
      *             (Recompile)                                       *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    05  - Overflow Indicator SD000550P1                        *
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
      *  SRTERM - Termination Processing                              *
      *  SRFCP  - File Control Processing                             *
      *  *PSSR  - Error Handling Subroutine                           *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+                     *
      ** ¦ F-specs                              ¦                     *
      ** ¦ =======                              ¦                     *
      ** +--------------------------------------+                     *
 
      ** Midas SD FATCA Classification Codes File
     FSDFATCL0  IF   E           K DISK
 
      ** FATCA Classification Codes Report
     FSD000550P1O    E             PRINTER INFSR(*PSSR)
     F                                     OFLIND(*IN05)
     F                                     USROPN
     F                                     INFDS(SPOOL)
 
      ** FATCA Classification Codes Report - Audit
     FSD000550AUO    E             PRINTER INFSR(*PSSR)
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
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Aacces Programs, Long Data Structure
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank Details Accessed via Access Program
 
     D SDFATC        E DS                  EXTNAME(SDFATCPD)
      ** FATCA Classification Codes Container for Access Program
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CGL154
      ** External DS for SAR Details                                                          CGL154
                                                                                              CGL154
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
 
     D WCODE           S             10
     D WNARR           S              1
     D WRUN            S              1
     D WCALC           S              5  0
     D WCALCI          S              5  0
     D WCALCA          S              5  0
     D WCALCD          S              5  0
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
 
     ** AOCTRY Parameters
     D PRTCD           S              7
     D POPTN           S              7
     D PDCCD           S              2
     D PCTRY           S              2
     D PSard           S              6                                                       CGL154
     D CGL154          S              1                                                       CGL154
 
      * ZDATE1  parms
     D ZDATEA          S              6  0
     D ZDATFMT         S              1
     D ErrorFlag       S              1
     D WCLAC           S              5                                                       CGL154
     D WDMVA           S              5                                                       CGL154
     D WDHVA           S              5                                                       CGL154
 
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
      *            Controls Set-up of SD000550P1 Details              *
      *            Outputs SD000550P1 Details                         *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      * Calls    : SRHDRD - Prepare Header Data for Printing          *
      *                                                               *
      *****************************************************************
     C     SRMAIN        BEGSR
 
 
     C                   EVAL      *IN05 = *ON
 
      ** Loop through Classification Codes file
 
     C     *LOVAL        SETLL     SDFATCL0
     C                   READ      SDFATCL0                               14
 
     C                   DOW       *IN14 <> *ON
 
     C                   IF        (PMode = 'A' AND FCLCDT = BJRDNB)
     C                             OR PMode = 'L'
 
      ** Record(s) found for report
 
     C                   IF        *IN50 = *OFF
     C                   OPEN      SD000550P1
     C                   EVAL      *IN50 = *ON
 
     C                   Z-ADD     SFNUM         ZSNUM
     C*                  CALL      'ZSFILE'
     C*                  PARM                    PSEQ
     C*                  PARM      *BLANKS       PENTY
     C*                  PARM                    SFILE
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
 
     C                   ENDIF
      *
      ** If overflow indicator fires up, write header format
      *
     C                   IF        *IN05 = *ON
     C                   WRITE     SD0550R0
     C                   ENDIF
 
      ** prepare detail data for printing
 
     C                   EXSR      SRDETAIL
 
      ** if overflow indicator on, then set it off
 
     C                   IF        *IN05 = *ON
     C                   EVAL      *IN05 = *OFF
     C                   ENDIF
 
      ** write detail record to SD000550P1
 
     C                   WRITE     SD0550R1
 
      ** increment count of records output
 
     C                   ADD       1             WCALC
 
     C                   SELECT
     C                   WHEN      FCLCTP = 'I'
     C                   ADD       1             WCALCI
 
     C                   WHEN      FCLCTP = 'A'
     C                   ADD       1             WCALCA
 
     C                   WHEN      FCLCTP = 'D'
     C                   ADD       1             WCALCD
 
     C                   ENDSL
 
     C                   ENDIF
 
     C                   READ      SDFATCL0                               14
 
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
 
     C                   EVAL      RDCODE = FCCODE
     C                   EVAL      RDDESC = FCDESC
     C                   EVAL      RDUSIA = FCUSIA
                                                                                              CGL154
     C                   EVAL      *IN60 = *OFF                                               CGL154
                                                                                              CGL154
     C                   IF        CGL154 = 'Y'                                               CGL154
     C                   EVAL      *IN60 = *ON                                                CGL154
     C                   EVAL      WDMVA = FCDMVA                                             CGL154
     C                   EVAL      WDHVA = FCDHVA                                             CGL154
     C                   EVAL      RDDMVA = *BLANKS                                           CGL154
     C                   EVAL      RDDMDS = *BLANKS                                           CGL154
     C                   EVAL      RDDHVA = *BLANKS                                           CGL154
     C                   EVAL      RDDHDS = *BLANKS                                           CGL154
                                                                                              CGL154
      ** Default Medium Value A/C details retrieval                                           CGL154
     C                   IF        WDMVA <> *BLANKS                                           CGL154
     C                   CALL      'AOFATCR0'                                                 CGL154
     C                   PARM      *BLANKS       PRtcd                                        CGL154
     C                   PARM      '*KEY   '     POptn                                        CGL154
     C                   PARM      WDMVA         WCLAC                                        CGL154
     C     SDFATC        PARM      SDFATC        DSFDY                                        CGL154
                                                                                              CGL154
      ** Set Default Medium Value A/C Value and Description                                   CGL154
                                                                                              CGL154
     C                   EVAL      RDDMVA = WDMVA                                             CGL154
     C                   EVAL      RDDMDS = FCDESC                                            CGL154
                                                                                              CGL154
     C                   ENDIF                                                                CGL154
                                                                                              CGL154
      ** Default High Value A/C details retrieval                                             CGL154
     C                   IF        WDHVA <> *BLANKS                                           CGL154
     C                   CALL      'AOFATCR0'                                                 CGL154
     C                   PARM      *BLANKS       PRtcd                                        CGL154
     C                   PARM      '*KEY   '     POptn                                        CGL154
     C                   PARM      WDHVA         WCLAC                                        CGL154
     C     SDFATC        PARM      SDFATC        DSFDY                                        CGL154
                                                                                              CGL154
      ** Set Default High Value A/C Value and Description                                     CGL154
                                                                                              CGL154
     C                   EVAL      RDDHVA = WDHVA                                             CGL154
     C                   EVAL      RDDHDS = FCDESC                                            CGL154
                                                                                              CGL154
     C                   ENDIF                                                                CGL154
                                                                                              CGL154
      ** Reposition file                                                                    MD033502
     C     RDCODE        CHAIN     SDFATCL0                                                 MD033502
                                                                                            MD033502
     C                   ENDIF                                                                CGL154
      *
     C*                  MOVE      FCLCTS        WWTMST
     C*                  EVAL      WWYr = %SUBST(WWTMST:03:2)
     C*                  EVAL      WWMn = %SUBST(WWTMST:06:2)
     C*                  EVAL      WWDy = %SUBST(WWTMST:09:2)
     C*                  MOVEL     WDTMST        ZDATEA
     C*                  EVAL      ZDATFMT = 'M'
     C*                  EXSR      SRDATE1
     C                   EVAL      ZDAYNO = FCLCDT
      *
     C                   EXSR      SRDATE2
     C                   MOVEL     ZADATE        RDLCDT
      *
     C                   EVAL      RDLCUS = FCLCUS
     C*                  EVAL      RDLCDT = %char(FCLCDT)
      *
     C                   SELECT
     C                   WHEN      FCLCTP = 'I'
     C                   EVAL      RDLCTP = 'INSERT'
     C                   WHEN      FCLCTP = 'A'
     C                   EVAL      RDLCTP = 'AMEND'
     C                   WHEN      FCLCTP = 'D'
     C                   EVAL      RDLCTP = 'DELETE'
     C                   ENDSL
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
 
     C     HEND          ENDSR
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
     C                   PARM                    PSEQ
     C                   PARM                    PENTY
 
     C                   IF        PMode = 'A'
     C                   EVAL      *IN70 = *ON
     C                   ELSEIF    PMode = 'L'
     C                   EVAL      *IN71 = *ON
     C                   ENDIF
 
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
 
      ** set number of records read to Zero
 
     C                   Z-ADD     0             WCALC
     C                   Z-ADD     0             WCALCI
     C                   Z-ADD     0             WCALCD
     C                   Z-ADD     0             WCALCA
                                                                                              CGL154
      ** Check if CGL154 - FATCA Reporting is ON                                              CGL154
                                                                                              CGL154
     C                   EVAL      CGL154 = 'N'                                               CGL154
                                                                                              CGL154
     C                   CALL      'AOSARDR0'                                                 CGL154
     C                   PARM      *Blanks       PRtcd                                        CGL154
     C                   PARM      '*VERIFY'     POptn                                        CGL154
     C                   PARM      'CGL154'      PSard                                        CGL154
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL154
                                                                                              CGL154
     C                   IF        (PRtcd <> *BLANKS) AND                                     CGL154
     C                             (PRtcd <> '*NRF   ')                                       CGL154
     C                   EVAL      DBKEY = 'CGL154'                                           CGL154
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL154
     C                   MOVEL     '901'         DBASE                                        CGL154
     C                   EXSR      *PSSR                                                      CGL154
     C                   ELSE                                                                 CGL154
     C                   IF        PRtcd <> '*NRF   '                                         CGL154
     C                   EVAL      CGL154 = 'Y'                                               CGL154
     C                   ENDIF                                                                CGL154
     C                   ENDIF                                                                CGL154
 
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
     C*                  CALL      'ZSFILE'
     C*                  PARM                    PSEQ
     C*                  PARM      *BLANK        PENTY
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
 
      ** produce standard totals report
 
     C                   EXSR      SRFCP
 
      ** if a database error has occured, bypass further processing
 
     C     *INU7         CABEQ     *ON           TEND
 
      ** prints 'END OF REPORT' if *IN50 ON.
 
     C                   IF        *IN50 = *ON
     C                   WRITE     SD0550R2
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
     C                   Z-ADD     WCALCI        RRCALCI
     C                   Z-ADD     WCALCD        RRCALCD
     C                   Z-ADD     WCALCA        RRCALCA
 
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
     C                   EVAL      DBPGM = 'SD000550'
 
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
