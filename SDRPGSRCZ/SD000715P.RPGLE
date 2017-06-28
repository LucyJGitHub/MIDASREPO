     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Default Classification of Expiry Date Report')         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000715P - Default Classification of New Customers and New  *
      *              NAHO Expiry Date Report                          *
      *                                                               *
      *  Function:  This is a new program to list the details of all  *
      *             Default Classification of New Customers and New   *
      *             non-account Holders Expiry Date Report            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD041709           Date 28Sep16               *
      *  Prev Amend No. MD027474           Date 11Jun14               *
      *                 MD027483           Date 16Jun14               *
      *                 MD024592           Date 28Jan14               *
      *                 CGL132  *CREATE    Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD041709 - Component SDC000715 failure. Adjusted customer    *
      *             counter to 10 numeric.                            *
      *  MD027474 - Report is not arranged by Expiry Date (CUAP/NAHO) *
      *           - Applied fix MD025536                              *
      *  MD027483 - Report includes Customers/NAHL with blank         *
      *             creation date                                     *
      *  MD024592 - FATCA Missing Report Programs (Recompile)         *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    05  - Overflow Indicator SD000715P1                        *
      *    06  - Change of Document Management Key                    *
      *    14  - End of File SDFTCSPD                                 *
      *    15  - Chain Fail on File SDCUSTXC                          *
      *    16  - Chain Fail on File SDCUSTL1                          *
      *    24  - End of File SDFTNHL1                                 *
      *    25  - Chain Fail on File SDNAHOL1                          *
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
 
      ***Midas*SD*FATCA*Customer*Details*retrieval*index                                    MD025536
     F***SDFTCSL1  IF   E           K DISK                                                  MD025536
 
      ***Midas*SD*Customer*Details*Ext*C*-*Keyed                                            MD025536
     F***SDCUSXL0  IF   E           K DISK                                                  MD025536
 
      ***Midas*SD*FATCA*NAHO*Details*retrieval*index                                        MD025536
     F***SDFTNHL1  IF   E           K DISK                                                  MD025536
 
      ***RTV:*Non*Account*Holder*File*Retrieval*Index                                       MD025536
     F***SDNAHOL1  IF   E           K DISK                                                  MD025536
 
      ** Customer Details Master File Retrieval
     FSDCUSTL1  IF   E           K DISK
 
      ** Midas SD FATCA Customer Details by Creation Date                                   MD025536
     FSDFTCSJ0  IF   E           K DISK                                                     MD025536
                                                                                            MD025536
      ** Midas SD FATCA NAHO Details by Creation Date                                       MD025536
     FSDFTNHJ0  IF   E           K DISK                                                     MD025536
                                                                                            MD025536
      ** RPT: Document Management Report Control
     FSD000715P1O    E             PRINTER INFSR(*PSSR)
     F                                     OFLIND(*IN05)
     F                                     USROPN
     F                                     INFDS(SPOOL)
 
      ** RPT: Document Management Report Audit
     FSD000715AUO    E             PRINTER INFSR(*PSSR)
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
 
     D  @JOB                 244    253
     D  @USER                254    263
     D                 DS
 
     D SPOOL           DS
      ** SPOOL Information Data Structure for ZSFILE
 
     D  SFILE                 83     92
     D  SFNUM                123    124B 0
     D  OflLn1               188    189B 0
     D  PrtLn1               367    368B 0
 
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
 
     D WRUN            S              1
     D***WCalcCust     S              5  0                                                  MD041709
     D***WCalcNaho     S              5  0                                                  MD041709
     D WCalcCust       S             10  0                                                  MD041709
     D WCalcNaho       S             10  0                                                  MD041709
     D DRUND           S              5  0
     D SENTY           S              3
     D WWTMST          S             26A
     D***WCustCnt      S              5  0                                                  MD041709
     D***WNahoCnt      S              5  0                                                  MD041709
     D WCustCnt        S             10  0                                                  MD041709
     D WNahoCnt        S             10  0                                                  MD041709
     D WInputDate      S              5  0
     D WExpiryDate     S              5  0
     D WStrNotDate     S              5  0
     D WType           S              1A
     D WClassCode      S              5A
     D WExpiryDays     S              3  0
     D WNoticeDays     S              2  0
     D WPrintYN        S              1A
 
      ** ZSFILE Parameters
     D ZSERR           S              1
     D ZSNUM           S              6  0
     D KCUST           S              6
 
      ** ZDATE2 Parameters
     D ZDAYNO          S              5  0
     D ZDATE           S              6  0
     D ZADATE          S              7
 
      ** ZDATE10 Parameters
     D PDateIn         S              8S 0
     D PMDNO           S              5P 0
 
      ** PLIST Parameters
     D PMode           S              1
     D PSeq            S              5
     D PEnty           S              3
     D PIntyp          S              1
 
      ** AOCTRY Parameters
     D PRTCD           S              7
     D POPTN           S              7
     D PDCCD           S              2
     D PCTRY           S              2
 
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
      ** Parameters for ZALIGN                                                              MD027483
     D ZALIGNOK        S              1                                                     MD027483
     D ZFIELD          S             16                                                     MD027483
     D ZADEC           S              1P 0                                                  MD027483
     D ZADIG           S              2P 0                                                  MD027483
 
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
      *            Controls Set-up of SD000715 Details                *
      *            Outputs SD000715 Details                           *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      *****************************************************************
 
     C     SRMAIN        BEGSR
 
      ** For customers
 
     C                   EXSR      SRCUSTOMER
 
      ** For non-account holders
 
     C                   EXSR      SRNAHO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCUSTOMER - Processing for Customers.                        *
      *              Access SDFTCSPD                                  *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      * Calls: SRCUSTEXT                                              *
      *                                                               *
      *****************************************************************
 
     C     SRCUSTOMER    BEGSR
 
      ** Set report type to customers
 
     C                   EVAL      WType = 'C'
      **********                                                                            MD025536
      ***Do*unit*end*of**SD*FATCA*Customer*Details*retrieval*index.                         MD025536
      **********                                                                            MD025536
     C**********         READ      SDFTCSL1                               14                MD025536
     C*****FACUST        SETLL     SDFTCSL1                                                 MD025536
     C**********         DOW       NOT %EOF (SDFTCSL1)                                      MD025536
      **********                                                                            MD025536
      ***Read*through*SD*FATCA*Customer*Details*retrieval*index.                            MD025536
      **********                                                                            MD025536
     C**********         READ      SDFTCSL1                               14                MD025536
     C**********         IF        NOT %EOF (SDFTCSL1)                                      MD025536
     C**********                   AND FACLAC = WClassCode                                  MD025536
     C**********         EXSR      SRCUSTEXT                                                MD025536
     C**********         ENDIF                                                              MD025536
      **********                                                                            MD025536
     C**********         ENDDO                                                              MD025536
                                                                                            MD025536
     C                   READ      SDFTCSJ0                               14                MD025536
     C     XCKEY         SETLL     SDFTCSJ0                                                 MD025536
     C                   DOW       NOT %EOF (SDFTCSJ0)                                      MD025536
     C                   READ      SDFTCSJ0                               14                MD025536
     C                   IF        NOT %EOF (SDFTCSJ0)                                      MD025536
     C                             AND FACLAC = WClassCode                                  MD025536
     C                   EXSR      SRDETAILC                                                MD025536
     C                   ENDIF                                                              MD025536
                                                                                            MD025536
     C                   ENDDO                                                              MD025536
 
     ** Close Printer file if it is open and records have been printed.
 
     C                   EXSR      SRCLOSEP1
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************                     MD025536
      **SRCUSTOMER*-*Look*up*SD*Customer*Extension*Fiels*and***********                     MD025536
      ***************Set-up*Date.*Access*SDCUSXPD**********************                     MD025536
      *****************************************************************                     MD025536
      **Called*by:*SRCUSTOMER******************************************                     MD025536
      *****************************************************************                     MD025536
      **Calls:*SRCLOSEP1,*SROPENP1,************************************                     MD025536
      *****************************************************************                     MD025536
      *****************************************************************
      **********                                                                            MD025536
     C*****SRCUSTEXT     BEGSR                                                              MD025536
      **********                                                                            MD025536
     C*****FACUST        CHAIN     SDCUSXL0                           15                    MD025536
     C**********         IF        %FOUND (SDCUSXL0)                                        MD025536
     C**********         EXSR      SRDETAILC                                                MD025536
     C**********         ENDIF                                                              MD025536
      **********                                                                            MD025536
     C**********         ENDSR                                                              MD025536
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCLOSEP1 - Closes SD000715P1                                 *
      *                                                               *
      * Called by: SRCUSTEXT, SRNAHOEXT                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRCLOSEP1     BEGSR
 
     C                   IF        %OPEN (SD000715P1)
     C                   WRITE     SD0715R5
     C                   CLOSE     SD000715P1
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SROPENP1 - Open printer file SD000715P1                       *
      *                                                               *
      * Called by: SRCUSTOMER                                         *
      *                                                               *
      * Calls: ZSFILE, SRNAHOEXT                                      *
      *                                                               *
      *****************************************************************
 
     C     SROPENP1      BEGSR
 
      ** open printer file and indicate that there is atleast one
      ** detail to report; ensure report spool file recorded by RCF
 
     C                   IF        NOT %OPEN (SD000715P1)
     C                   OPEN      SD000715P1
 
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
      * SRHEADER  - Controls Set-up of SD000715P1 Title               *
      *             depending if it is a customer or NAHO.            *
      *             Outputs SD0715R0, SD0715R1, SD0715R3              *
      *                                                               *
      * Called by: SRDETAILC, SRNAHOEXT                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRHEADER      BEGSR
 
     C                   IF        WType = 'C'
     C                   EVAL      RRTYPE = 'CUSTOMERS EXPIRY DATE REPORT'
     C                   EVAL      RRLINE = '----------------------------'
     C                   ELSE
     C                   EVAL      RRTYPE = 'NON-ACCOUNT HOLDERS'
     C                   EVAL      RRTYPE2 = 'EXPIRY DATE REPORT'
     C                   EVAL      RRLINE = '--------------------'
     C                   EVAL      RRLINE2 = '------------------'
     C                   ENDIF
     C                   EVAL      RFACLAC = WClassCode
     C                   WRITE     SD0715R0
 
      ** Set-up Customer or NAHO Details Title
 
     C                   IF        WType = 'C'
     C                   WRITE     SD0715R1
     C                   ELSE
     C                   WRITE     SD0715R3
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDETAILC - Access SDCUSTPD                                   *
      *             Set-ups the details of the customer to be printed.*
      *                                                               *
      * Called by: SRCUSTEXT                                          *
      *                                                               *
      * Calls: SRCOMPDATE, *PSSR                                      *
      *                                                               *
      *****************************************************************
 
     C     SRDETAILC     BEGSR
 
     C     FACUST        CHAIN     SDCUSTL1                           16
     C                   IF        NOT %FOUND (SDCUSTL1)
     C                   EVAL      DBFILE = 'SDCUSTL1'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = '*FIRST'
     C                   EXSR      *PSSR
     C                   ELSE
 
      ** Convert, compute and set-up date.
 
     C                   EVAL      WInputDate = XCCRDT
     C                   EXSR      SRCOMPDATE
     C                   EVAL      RDDATE = ZADATE
 
      ** Set-up other details
 
     C                   EVAL      RDCUST = FACUST
     C                   EVAL      RDCSSN = BBCSSN
     C                   EVAL      RDCRNM = BBCRNM
     C                   EVAL      RDCRTN = BBCRTN
     C                   ENDIF
 
     C                   IF        WPrintYN = 'Y'                                           MD027483
                                                                                            MD027483
      ** Open printer file if there are successful record.
 
     C                   IF        WCustCnt = 1
     C                   EXSR      SROPENP1
     C                   ENDIF
 
      ** Print Title if there is a record counted.
 
     C                   IF        WCustCnt = 1
     C                   EXSR      SRHEADER
     C                   ENDIF
 
      ** Print Details. Print Title if next page occurs
 
     C**********         IF        WPrintYN = 'Y'                                           MD027483
 
     C                   IF        PrtLn1 + 1 >= OflLn1
     C                   EXSR      SRHEADER
     C                   ENDIF
 
     C                   IF        (PMode = 'A' AND BBLCD = BJRDNB)
     C                             OR PMode = 'L' OR PMode = ' '
     C                   EVAL      WCalcCust = WCalcCust + 1
     C                   WRITE     SD0715R2
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRNAHO - Control the processing of Non-Account Holders        *
      *          Access SDFTNHPD                                      *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SRNAHOEXT                                              *
      *                                                               *
      *****************************************************************
 
     C     SRNAHO        BEGSR
 
      ** Set report type to NAHO
 
     C                   EVAL      WType = 'N'
      **********                                                                            MD025536
      **Do*until*end*of*SD*FATCA*Non-account*holders*retrieval*index.                       MD025536
      **********                                                                            MD025536
     C**********         READ      SDFTNHL1                               24                MD025536
     C*****FNNAHO        SETLL     SDFTNHL1                                                 MD025536
     C**********         DOW       NOT %EOF (SDFTNHL1)                                      MD025536
      **********                                                                            MD025536
      ***Read*through*SD*FATCA*NAHO*details*retrieveal*index.                               MD025536
      **********                                                                            MD025536
     C**********         READ      SDFTNHL1                               24                MD025536
     C**********         IF        NOT %EOF (SDFTNHL1)                                      MD025536
     C**********                   AND FNCLAC = WClassCode                                  MD025536
     C**********         EXSR      SRNAHOEXT                                                MD025536
     C**********         ENDIF                                                              MD025536
     C**********         ENDDO                                                              MD025536
                                                                                            MD025536
     C                   READ      SDFTNHJ0                               24                MD025536
     C     NHKEY         SETLL     SDFTNHJ0                                                 MD025536
     C                   DOW       NOT %EOF (SDFTNHJ0)                                      MD025536
     C                   READ      SDFTNHJ0                               24                MD025536
     C                   IF        NOT %EOF (SDFTNHJ0)                                      MD025536
     C                             AND FNCLAC = WClassCode                                  MD025536
     C                   EXSR      SRNAHOEXT                                                MD025536
     C                   ENDIF                                                              MD025536
     C                   ENDDO                                                              MD025536
 
      ** Close Printer file if it is open and records have been printed.
 
     C                   EXSR      SRCLOSEP1
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRNAHOEXT - Look up SD NAHO Extension Files and Set-up Data   *
      *                                                               *
      * Called by: SRNAHO                                             *
      *                                                               *
      * Calls: SRCLOSEP1, SROPENP1, SRHEADER, SRZDate10, *PSSR        *
      *                                                               *
      *****************************************************************
 
     C     SRNAHOEXT     BEGSR
 
     C*****FNNAHO        CHAIN     SDNAHOL1                           25                    MD025536
     C**********         IF        %FOUND (SDNAHOL1)                                        MD025536
 
      ** Convert, compute and set-up date.
 
     C                   EXSR      SRZDate10
     C                   EVAL      RDDATEN = ZADATE
     C                   EVAL      RDCUSTN = FNNAHO
     C                   EVAL      RDCRNMN = NHNARN
     C                   EVAL      RDCRTNN = NHNATW
 
      ** Open printer file for NAHO if not yet open in customer routine.
 
     C                   IF        WPrintYN = 'Y'                                           MD027483
                                                                                            MD027483
     C                   IF        WNahoCnt = 1
     C                   EXSR      SROPENP1
     C                   ENDIF
 
      ** Print Title if there is a record counted.
 
     C                   IF        WNahoCnt = 1
     C                   EXSR      SRHEADER
     C                   ENDIF
 
      ** Print Details. Print Title if next page occurs
 
     C**********         IF        WPrintYN = 'Y'                                           MD027483
 
     C                   IF        PrtLn1 + 1 >= OflLn1
     C                   EXSR      SRHEADER
     C                   ENDIF
 
     C                   IF        (PMode = 'A' AND NHLCDT = BJRDNB)
     C                             OR PMode = 'L' OR PMode = ' '
     C                   EVAL      WCalcNaho = WCalcNaho + 1
     C                   WRITE     SD0715R4
     C                   ENDIF
 
     C                   ENDIF
 
     C**********         ELSE                                                               MD025536
     C**********         EVAL      DBFILE = 'SDNAHOL1'                                      MD025536
     C**********         EVAL      DBASE = 2                                                MD025536
     C**********         EVAL      DBKEY = '*FIRST'                                         MD025536
     C**********         EXSR      *PSSR                                                    MD025536
     C**********         ENDIF                                                              MD025536
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      ** Sub-routine for expiry date computation
      *****************************************************************
      *                                                               *
      * SRCOMPDATE - Computes Expiry Days                             *
      *              Computes Notice Days                             *
      *              Checks Rundate if within Notice Date             *
      *                                                               *
      * Called by: SRDETAILC, SRZDate10                               *
      *                                                               *
      * Calls: SRZDate2                                               *
      *                                                               *
      *****************************************************************
 
     C     SRCOMPDATE    BEGSR
 
     C                   EVAL      WPrintYN = 'N'                                           MD027483
      ** Compute Expiry Date
     C                   IF        WInputDate > 0                                           MD027483
 
     C                   EVAL      WExpiryDate = WInputDate +  WExpiryDays
 
      ** Compute Start of Notice Days
 
     C                   EVAL      WStrNotDate = WExpiryDate - WNoticeDays
 
      ** Check if run date is with in the notice days
 
     C                   IF        BJRDNB >= WStrNotDate
 
     C                   EVAL      WPrintYN = 'Y'
 
     C                   IF        WType = 'C'
     C                   EVAL      WCustCnt = WCustCnt + 1
     C                   ELSE
     C                   EVAL      WNahoCnt = WNahoCnt + 1
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      WPrintYN = 'N'
 
     C                   ENDIF
 
      ** Convert Expiry date numeric format to ddMMMyy.
 
     C                   EXSR      SRZDate2
 
     C                   ENDIF                                                              MD027483
                                                                                            MD027483
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZDate2   - Calls ZDATE2 to convert  day no. to ddMMMyy      *
      *                                                               *
      * Called by:  SRCOMPDATE                                        *
      *                                                               *
      * Calls: ZDATE                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRZDate2      BEGSR
 
     C                   EVAL      ZDAYNO = WExpiryDate
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZDate10  - Calls ZDATE10 to convert YYYYMMDD to day no.     *
      *                                                               *
      * Called by:  SRNAHOEXT                                         *
      *                                                               *
      * Calls: ZDATE10, SRCOMPDATE                                    *
      *                                                               *
      *****************************************************************
 
     C     SRZDate10     BEGSR
 
     C                   MOVEL     NHCRDT        PDateIN
     C                   CALLB     'ZDATE10'
     C                   PARM                    PDateIN
     C                   PARM                    PMDNO
 
      ** Set-up Input Date and call SRCOMPDATE routine
 
     C                   EVAL      WInputDate = PMDNO
     C                   EXSR      SRCOMPDATE
 
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
 
     C                   Z-ADD     WCalcCust     RRCUST
     C                   Z-ADD     WCalcNaho     RRNAHO
 
      ** print standard totals report
 
     C                   EVAL      *IN54 = *ON
     C                   IF        RRCUST = 0
     C                             AND RRNAHO =0
     C                   EVAL      *IN54 = *OFF
     C                   ENDIF
 
     C                   WRITE     CONTROL
 
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
     C                   PARM                    PMode
     C                   PARM                    PIntyp
     C                   PARM                    PSeq
     C                   PARM                    PEnty
 
     C     NHKEY         KLIST                                                              MD025536
     C                   KFLD                    NHCRDT                                     MD025536
     C                   KFLD                    NHNAHO                                     MD025536
                                                                                            MD025536
     C     XCKEY         KLIST                                                              MD025536
     C                   KFLD                    XCCRDT                                     MD025536
     C                   KFLD                    XCCUST                                     MD025536
                                                                                            MD025536
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
     C                   EVAL      DBASE  = 3
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
 
      ** set number of record count for title printing and tail.
 
     C                   Z-ADD     0             WCustCnt
     C                   Z-ADD     0             WNahoCnt
 
      ** set number of records read to Zero
 
     C                   Z-ADD     0             WCalcCust
     C                   Z-ADD     0             WCalcNaho
 
     C     IEND          ENDSR
 
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
     C                   EVAL      DBPGM = 'SD000715'
 
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
 
     C                   EVAL      P@OP01 = 'FATCADftCLsNewCustNH'
     C                   EVAL      P@OP02 = 'FATCAExpDayDftClsNew'
     C                   EVAL      P@OP03 = 'FATCANotDaysActRept'
 
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
     C                   EVAL      DBASE = 4
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
                                                                                            MD027483
     C                   EVAL      ZADEC = 0                                                MD027483
     C                   EVAL      ZADIG = 3                                                MD027483
     C                   EVAL      ZFIELD = P@VL02                                          MD027483
     C                   EXSR      SRAlgAmount                                              MD027483
     C                   MOVE      ZFIELD        WExpiryDays                                MD027483
     C                   EVAL      ZFIELD = P@VL03                                          MD027483
     C                   EXSR      SRAlgAmount                                              MD027483
     C                   MOVE      ZFIELD        WNoticeDays                                MD027483
                                                                                            MD027483
     C                   MOVEL     P@VL01        WClassCode
     C**********         MOVEL     P@VL02        WExpiryDays                                MD027483
     C**********         MOVEL     P@VL03        WNoticeDays                                MD027483
     C                   ENDIF
 
     C                   ENDSR
      /EJECT                                                                                MD027483
      *****************************************************************                     MD027483
      *                                                               *                     MD027483
      *  SRAlgAmount - Align amount                                   *                     MD027483
      *                                                               *                     MD027483
      *  Called by: SRSVAL                                            *                     MD027483
      *                                                               *                     MD027483
      *  Calls: None                                                  *                     MD027483
      *                                                               *                     MD027483
      *****************************************************************                     MD027483
      *                                                                                     MD027483
     C     SRAlgAmount   BEGSR                                                              MD027483
      *                                                                                     MD027483
      * Align amount                                                                        MD027483
     C                   CALLB     'ZALIGN'                                                 MD027483
     C                   PARM                    ZALIGNOK                                   MD027483
     C                   PARM                    ZFIELD                                     MD027483
     C                   PARM                    ZADEC                                      MD027483
     C                   PARM                    ZADIG                                      MD027483
      *                                                                                     MD027483
     C                   ENDSR                                                              MD027483
      *****************************************************************                     MD027483
** CPY@
(c) Misys International Banking Systems Ltd. 2013
