     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Yield Rates Report Control')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000742 - Yield Rates Report Control                        *
      *                                                               *
      *  Function:  This is a new program to list the details of all  *
      *             yield curves defined in the system as well as the *
      *             discount factors calculated for each period.      *
      *             Report Details will come from the Yield Curves    *
      *             File and Yield Rates File.                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 228390             Date 14Jul04               *
      *                 CAS008             Date 16Jun04               *
      *                 224743             Date 15Mar04               *
      *                 212407             Date 19Sep02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001  *CREATE    Date 23Nov01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  228390 - Introduce a new yield curve type 'S' (for swap      *
      *           rates) which will apply the formula currently being *
      *           used by curve type 'Z' and a new formula for type   *
      *           'Z' is to be introduced.                            *
      *  CAS008 - IAS 39 Enhancements                                 *
      *  224743 - If CIR004 is installed, system should               *
      *           allow interest calculation method '7'.              *
      *  212407 - Maturity date is still in Midas run date            *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    05  - Overflow Indicator SD000742P1                        *
      *    06  - Change of Yield Rate Key                             *
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
 
     FSDYLDRL2  IF   E           K DISK
      ** RTV: Yield Rates File by Maturity Date Retrieval Index
 
     FSDYLDCL1  IF   E           K DISK
      ** RTV: Yield Curves File Retrieval Index
 
     FSD000742P1O    E             PRINTER INFSR(*PSSR)
     F                                     OFLIND(*IN05)
     F                                     USROPN
     F                                     INFDS(SPOOL)
      ** RPT: Yield Rates Report Control
 
     FSD000742AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
      ** RPT: Yield Rates Report Audit
 
     F/COPY WNCPYSRC,SD000742F1
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
 
     D CONS            S             20    DIM(1) CTDATA PERRCD(1)
     D*YLDT*****       S             21    DIM(2) CTDATA PERRCD(1)                            228390
     D YLDT            S             21    DIM(3) CTDATA PERRCD(1)                            228390
     D*INTC*****       S             22    DIM(6) CTDATA PERRCD(1)                            224743
     D INTC            S             22    DIM(7) CTDATA PERRCD(1)                            224743
     D*FREQ*****       S             13    DIM(4) CTDATA PERRCD(1)                            228390
     D FREQ            S             13    DIM(5) CTDATA PERRCD(1)                            228390
 
     D FSKEYP          S              9
     D WRUN            S              1
     D ZDAYNO          S              5  0                                                    212407
     D ZDATE           S              6  0                                                    212407
     D ZADATE          S              7                                                       212407
 
     D CAS008          S              1                                                       CAS008
                                                                                              CAS008
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Aacces Programs, Long Data Structure
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank Details Accessed via Access Program
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Currency Details Accessed via Access Program
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  224743
      ** External DS for SAR Details                                                          224743
                                                                                              224743
     D  @JOB                 244    253
     D  @USER                254    263
     D                 DS
      ** Yield Rate Key
 
     D  FSKEY                  1      9
     D  FSYLDC                 1      5
     D  FSYCCY                 6      8
     D  FSYICM                 9      9
 
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
      *            Controls Set-up of SD000742P1 Details              *
      *            Outputs SD000742P1 Details                         *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      * Calls    : SRHDRD - Prepare Header Data for Printing          *
      *                                                               *
      *****************************************************************
     C     SRMAIN        BEGSR
 
      ** do until end of Yield Rates File
 
     C     *IN14         DOWNE     *ON
 
      ** reset change of Yield Rate key indicator
 
     C                   EVAL      *IN06 = *OFF
 
      ** read the Yield Rates file
 
     C                   READ      SDYLDRL2                               14
 
      ** if eof then goto end
 
     C                   IF        *IN14 = *ON
     C                   EVAL      *INLR = *ON
     C                   GOTO      MEND
     C                   ENDIF
 
      ** check if Yield Rate key has changed
      ** if so, prepare header data for printing
 
     C                   IF        FSKEY <> FSKEYP
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
     C                   OPEN      SD000742P1
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
 
      ** if Yield Rate key has changed
      ** or overflow indicator is on throw page and write header
 
     C                   IF        (*IN06 = *ON)  OR  (*IN05 = *ON)
     C                   WRITE     SD0742R0
     C                   ENDIF
     C/COPY WNCPYSRC,SD000742C1
 
      ** prepare detail data for printing
 
     C**********         Z-ADD     FSPDYR        XRPDYR                                       212407
     C**********         Z-ADD     FSPDMN        XRPDMN                                       212407
     C**********         Z-ADD     FSPDDY        XRPDDY                                       212407
     C**********         MOVE      FSMMDN        XRMDMY                                       212407
                                                                                              212407
     C                   EVAL      XRPDYR = *BLANKS                                           212407
     C                   EVAL      XRPDMN = *BLANKS                                           212407
     C                   EVAL      XRPDDY = *BLANKS                                           212407
                                                                                              212407
      ** Year                                                                                 212407
     C                   IF        FSPDYR <> 0                                                212407
     C                   MOVEL     FSPDYR        XRPDYR                                       212407
     C                   ENDIF                                                                212407
                                                                                              212407
      ** Month                                                                                212407
     C                   IF        FSPDMN <> 0                                                212407
     C                   MOVEL     FSPDMN        XRPDMN                                       212407
     C                   ENDIF                                                                212407
                                                                                              212407
      ** Day                                                                                  212407
     C                   IF        FSPDDY <> 0                                                212407
     C                   MOVEL     FSPDDY        XRPDDY                                       212407
     C                   ENDIF                                                                212407
     C                   EVAL      ZDAYNO = FSMMDN                                            212407
                                                                                              212407
      ** Convert maturity date                                                                212407
                                                                                              212407
     C                   CALLB     'ZDATE2'                                                   212407
     C                   PARM                    ZDAYNO                                       212407
     C                   PARM                    BJDFIN                                       212407
     C                   PARM      *ZEROS        ZDATE                                        212407
     C                   PARM      *BLANKS       ZADATE                                       212407
                                                                                              212407
     C                   EVAL      XRMDMY = ZADATE                                            212407
                                                                                              212407
     C                   IF        FSYLDT = 'D'
     C                   Z-ADD     FSDSCF        XRATE
     C                   ELSE
     C                   Z-ADD     FSYRAT        XRATE
     C                   ENDIF
     C                   Z-ADD     FSDSCF        XRDSCF
 
      ** if overflow indicator on, then set it off
 
     C                   IF        *IN05 = *ON
     C                   EVAL      *IN05 = *OFF
     C                   ENDIF
 
      ** write detail record to SD000742P1
 
     C                   WRITE     SD0742R1
 
      ** save Yield Rate key for comparison to next read
 
     C                   EVAL      FSKEYP = FSKEY
 
      ** increment count of records output
 
     C                   ADD       1             WCALC
 
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
 
     C     MEND          ENDSR
 
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
 
      ** chain to Yield Curves file
 
     C     FSYLDC        CHAIN     SDYLDCL1                           15
     C                   IF        *IN15 = *ON
     C                   EVAL      DBFILE = 'SDYLDCL1'
     C                   EVAL      DBASE = 3
     C                   EVAL      DBKEY = FSYLDC
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** move Yield Rates and Yield Curves fields to print fields
 
     C                   EVAL      XRYLDN = FSYLDC
     C                   EVAL      XRYLDD = FSYLDD
     C                   EVAL      XRYLDT = FSYLDT
     C                   EVAL      XRINTP = FSINTP
     C                   EVAL      XRCCY  = FSYCCY
     C                   EVAL      XRICM  = FSYICM
     C                   EVAL      XRCFRQ = FSYCFQ
 
      ** get Currency Name
      ** Currency can be blank; if so, set it to 'ALL'
 
     C                   EVAL      XRCCNM = *BLANK
     C                   IF        FSYCCY = *BLANKS
     C                   EVAL      XRCCNM = CONS(1)
     C                   ELSE
 
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG   '     PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      FSYCCY        PCRKEY            3
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE  = 1
     C                   EVAL      DBKEY  = FSYCCY
     C                   EXSR      *PSSR
     C                   GOTO      HEND
     C                   ENDIF
 
     C                   EVAL      XRCCNM = A6CYNM
     C                   ENDIF
 
      ** get Yield Type Description
 
     C                   EVAL      XRYTNM = *BLANKS
     C                   SELECT
     C     XRYLDT        WHENEQ    'Z'
     C                   EVAL      XRYTNM = YLDT(1)
     C     XRYLDT        WHENEQ    'D'
     C                   EVAL      XRYTNM = YLDT(2)
     C     XRYLDT        WHENEQ    'S'                                                        228390
     C                   EVAL      XRYTNM = YLDT(3)                                           228390
     C                   ENDSL
 
      ** get Interest Calculation Method Description
 
     C                   EVAL      XRICNM = *BLANKS
     C                   SELECT
     C     XRICM         WHENEQ    '1'
     C                   EVAL      XRICNM = INTC(1)
     C     XRICM         WHENEQ    '2'
     C                   EVAL      XRICNM = INTC(2)
     C     XRICM         WHENEQ    '3'
     C                   EVAL      XRICNM = INTC(3)
     C     XRICM         WHENEQ    '4'
     C                   EVAL      XRICNM = INTC(4)
     C     XRICM         WHENEQ    '5'
     C                   EVAL      XRICNM = INTC(5)
     C     XRICM         WHENEQ    '6'
     C                   EVAL      XRICNM = INTC(6)
     C     XRICM         WHENEQ    '7'                                                        224743
     C     CIR004        ANDEQ     'Y'                                                        224743
     C                   EVAL      XRICNM = INTC(7)                                           224743
     C                   ENDSL
 
      ** get Frequency Description
 
     C                   EVAL      XRFRNM = *BLANKS
     C                   SELECT
     C     XRCFRQ        WHENEQ    'D'
     C                   EVAL      XRFRNM = FREQ(1)
     C     XRCFRQ        WHENEQ    'Q'
     C                   EVAL      XRFRNM = FREQ(2)
     C     XRCFRQ        WHENEQ    'S'
     C                   EVAL      XRFRNM = FREQ(3)
     C     XRCFRQ        WHENEQ    'Y'
     C                   EVAL      XRFRNM = FREQ(4)
     C     XRCFRQ        WHENEQ    'C'                                                        228390
     C                   EVAL      XRFRNM = FREQ(5)                                           228390
     C                   ENDSL
 
      ** Spot Days                                                                            CAS008
                                                                                              CAS008
     C                   EVAL      XRSPDY = *BLANKS                                           CAS008
     C                   IF        CAS008 = 'Y'                                               CAS008
     C                   MOVE      FSSPDY        XRSPDY                                       CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
     C     HEND          ENDSR
 
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
 
      ** set number of records read to Zero
 
     C                   Z-ADD     0             WCALC             5 0
     C/COPY WNCPYSRC,SD000742C2
      *                                                                                       224743
      ** Check if switchable feature CIR004 is switched on                                    224743
      *                                                                                       224743
     C                   CALLB     'AOSARDR0'                                                 224743
     C                   PARM      *BLANKS       @RTCD             7                          224743
     C                   PARM      '*VERIFY '    @OPTN             7                          224743
     C                   PARM      'CIR004'      @SARD             6                          224743
     C     SCSARD        PARM      SCSARD        DSFDY                                        224743
                                                                                              224743
     C     @RTCD         IFEQ      *BLANKS                                                    224743
     C                   MOVE      'Y'           CIR004            1                          224743
     C                   ELSE                                                                 224743
     C                   MOVE      'N'           CIR004                                       224743
     C                   ENDIF                                                                224743
                                                                                              CAS008
      ** Check if switchable feature CAS008 is switched on                                    CAS008
                                                                                              CAS008
     C                   CALLB     'AOSARDR0'                                                 CAS008
     C                   PARM      *BLANKS       @RTCD                                        CAS008
     C                   PARM      '*VERIFY '    @OPTN                                        CAS008
     C                   PARM      'CAS008'      @SARD                                        CAS008
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS008
                                                                                              CAS008
     C                   IF        @RTCD <> *BLANKS AND                                       CAS008
     C                             @RTCD <> '*NRF   '                                         CAS008
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS008
     C                   EVAL      DBASE  = 4                                                 CAS008
     C                   EVAL      DBKEY  = 'CAS008'                                          CAS008
     C                   EXSR      *PSSR                                                      CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
     C                   IF        @RTCD = *BLANKS                                            CAS008
     C                   EVAL      CAS008 = 'Y'                                               CAS008
     C                   EVAL      *IN20 = *ON                                                CAS008
     C                   ELSE                                                                 CAS008
     C                   EVAL      CAS008 = 'N'                                               CAS008
     C                   EVAL      *IN20 = *OFF                                               CAS008
     C                   ENDIF                                                                CAS008
 
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
     C                   WRITE     SD0742R2
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
     C                   EVAL      DBPGM = 'SD000742'
 
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
(c) Misys International Banking Systems Ltd. 2001
** CONS Long constants used in program.
All currencies
** YLDT Yield Type Descriptions
Zero-coupon curve
Discount Factor curve
Swap rate curve                                                                               228390
** INTC Interest Calculation Method Descriptions
Actual/365
Actual/360
30/360
Actual/365 (Ign 29Feb)
Actual/360 (Ign 29Feb)
Actual/Actual
Eurobond                                                                                      224743
** FREQ Frequency Descriptions
Daily
Quarterly
Semi-annually
Yearly
Continuous                                                                                    228390
