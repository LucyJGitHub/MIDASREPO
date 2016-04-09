     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Cashier Transaction Posting Details')         *
      *****************************************************************
      *                                                               *
      *   Midas - Standing Data Module                                *
      *                                                               *
      *  SD1245 - Cashier Commission Codes Posting Details            *
      *                                                               *
      *  Function:  This program allows the user to maintain and      *
      *             enquire Cashier Transaction Posting Details       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CRT012   *CREATE   Date 12May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CRT012 - Midas/Cashier Interface - Multiple Charges          *
      *                                                               *
      *****************************************************************
      *  Subroutine Index                                             *
      *                                                               *
      *  Sr_Load     - Initialise and load subfile                    *
      *  Sr_Build    - Load subfile page                              *
      *  Sr_Display  - Display screen                                 *
      *  Sr_ScreenIn - Process screen input                           *
      *  Sr_Modified - Process modified subfile record                *
      *  Sr_ProcRec  - Process subfile record                         *
      *  Sr_ChkNull  - Check for null record                          *
      *  Sr_Validate - Validate subfile record                        *
      *  Sr_UpdateSfl- Update DBF from subfile                        *
      *  Sr_ProcModSf- Process modified subfile                       *
      *  Sr_Add      - Process add request                            *
      *  Sr_Delete   - Process delete request                         *
      *  Sr_ProcChng - Process update request                         *
      *  Sr_AddChange- Switch between *ADD/*CHANGE mode               *
      *  Sr_ReLoad   - Request subfile reload                         *
      *  Sr_DspAttr1 - Set display attributes for subfile record      *
      *  Sr_DspAttr2 - Set display attributes for subfile control  *
      *  Sr_ResetFld - Initialise and reset all the Subfile fields    *
      *  Sr_LoadFld  - Load the subfile fields                        *
      *  Sr_AddRec   - Add record                                     *
      *  Sr_DeleteR  - Delete record from the DBF                     *
      *  Sr_ValidateA- Validate Account Code                          *
      *  Sr_Change - Change mode                                      *
      *  #IY8TS - Test cursor                                         *
      *  Sr_EnqInput - Process screen (Enquiry mode)                  *
      *  ZASNMS - Send message to programs message  queue             *
      *  Sr_Exit     - Exit program: Normal                           *
      *  Sr_ExitD    - exit program: Direct                           *
      *  Sr_Init     - Initialisation                                 *
      *  *PSSR  - Program exception error routine                     *
      *                                                               *
      *****************************************************************
      * Indicator Summary                                             *
      *                                                               *
      *   03 - Exit program                                           *
      *   05 - Refresh                                                *
      *   09 - CHANGE Mode                                            *
      *   27 - Next Page                                              *
      *   32 - Invalid Selection code                                 *
      *   33 - Invalid Branch                                         *
      *   34 - Invalid Cashier Transaction                            *
      *   35 - Invalid GL A/C Code                                    *
      *   36 - Invalid A/C Sequence Number                            *
      *   37 - Invalid Narrative Code                                 *
      *   38 - Invalid Use VAlue Date flag                            *
      *   39 - Invalid Standard Days                                  *
      *   40 - Invalid Standard Days +/- ind                          *
      *   50 - Validation Check                                       *
      *   75 - Enquiry Mode                                           *
      *   78 - Protect key fields                                     *
      *   79 - Protect key fields                                     *
      *   80 - Clear Subfile                                          *
      *   81 - Display subfile                                        *
      *   82 - End of subfile                                         *
      *   83 - Scan for Commission Code                               *
      *   84 - SFLNXTCHG                                              *
      *   85 - Setll SDCTPOL1                                         *
      *   86 - PUTOVER                                                *
      *   87 - Enable key screen                                      *
      *   88 - Protect key fields                                     *
      *   89 - ADD mode                                               *
      *   90 - Read SDREJCpp                                          *
      *   92 - Read change SFLRCD                                     *
      *   94 - Clear DDS indicator                                    *
      *   98 - Force input format                                     *
      *   99 - Initialise Record relative number                      *
      *U7-U8 - General Error Indicators                               *
      *   LR - Last Record                                            *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Cashier Transaction Types Posting Details
     FSD1245DF  CF   E             WORKSTN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      *
     FSDCTPOL0  IF   E           K DISK
     F                                     INFDS(INFDS1)
     F                                     INFSR(*PSSR)
      ** RTV : Cashier Transaction Postings File
      *
      *
     FSDCTPOL1  UF A E           K DISK
     F                                     RENAME(SDCTPOD0: SDCTPOD1)
      ** RTV : Cashier Transaction Postings File
      *
     F                                     COMMIT
     F                                     INFSR(*PSSR)
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
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
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** Branch Details
 
     D SDACOD        E DS                  EXTNAME(SDACODPD)
      ** External data structure for account code file
 
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D  SDRETLACCD   E                     EXTFLD(QQACCD)                                     CGL029
      ** External DS for Retail ICD Details
 
     D SDNARR        E DS                  EXTNAME(SDNARRPD)
      ** External DS for Narrative Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** First DS for Access Programs, Long Data Structure
      *
      ** Display file information data structure
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      *
      ** File information data structure
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      *
      ** Current/previous master file format fields for change control
     D @1CCTT        E DS                  EXTNAME(SDCTPOL1)
      *
      *****************************************************************
      ** Data structure for rundat
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
      *
      *
     D TXT             S             78    DIM(3) CTDATA PERRCD(1)
      *
     D TRN             S              1    DIM(5)
      *
     D REC             S              7    DIM(100)
      *
     D CPY2@           S             80
      *
     D @RUN            S              1
      *
     D JBDTTM          DS
      ** Job date/time
      *
     D  ##JDT                  1      6  0
     D  ##JYY                  1      2  0
     D  ##JMM                  3      4  0
     D  ##JDD                  5      6  0
     D  ##JTM                  7     12  0
     D  ##JHH                  7      8  0
     D  ##JNN                  9     10  0
     D  ##JSS                 11     12  0
      *
      *
     D  WWBRCA         S                   LIKE(D2BRCA)
     D  WWCTRT         S                   LIKE(D2CTRT)
     D  WWACOD         S                   LIKE(D2ACOD)
     D  WWACSQ         S                   LIKE(D2ACSQ)
     D  WWNARR         S                   LIKE(D2NARR)
     D  WWVALD         S                   LIKE(D2VALD)
     D  WWSTDY         S                   LIKE(D2STDY)
     D  WWPLMI         S                   LIKE(D2PLMI)
     D  WWCHQC         S                   LIKE(D2CHQC)
     D  WWGROS         S                   LIKE(D2GROS)
     D  WWCUST         S                   LIKE(D2CUST)
      *
      *
      ** Key Fields
     D  KPBRCA         S                   LIKE(CPBRCA)
     D  KPCTRT         S                   LIKE(CPCTRT)
      *
      ** To format Cashier Transaction to XX-XX
     D                 DS
     D  WW_CTRT                1      5
     D  WW_CTRT1               1      2
     D  WW_DASH                3      3
     D  WW_CTRT2               4      5
      *
     D                 DS
     D  WW_CTRTU               1      4
     D  WW_CTRTU1              1      2
     D  WW_CTRTU2              3      4
      *
     D                 DS
     D  WW_CTRTDSP             1      5
     D  WW_CTRTD1              1      1
     D  WW_CTRTD3              3      3
     D                 DS
     D  WCTRT                  1      5
     D  WCTRT1                 1      1
     D  WCTRT3                 3      3
     D  WCTRT5                 5      5
     D  WCTRT14                1      4
     D  WCTRT25                2      5
      *
     D  WWOLDREC               1     20
      *
     D  WW_STDY        DS
     D  WW_STDY1               1      1
     D  WW_STDY2               2      2
      *
     D  W_REC          DS
     D  W_BRANCH               1      3
     D  W_CASHTT               4      7
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Initialize
      *
     C                   EXSR      Sr_Init
      *
     C                   DO        *HIVAL
      *
      ** Initialise and load subfile page
     C                   EXSR      Sr_Load
      *
     C                   MOVEL     'N'           W0RSF             1
      *
      ** Display screen until reload requested
      *
     C     W0RSF         DOWEQ     'N'
      *
      ** Display screen
      *
     C                   EXSR      Sr_Display
      *
      ** Process response
      ** Cancel & exit program
      *
     C     *IN03         CASEQ     *ON           Sr_Exit
      *
      ** Request subfile reload
      *
     C     *IN05         CASEQ     *ON           Sr_ReLoad
      *
      ** Display next SFL page
      *
     C     *IN27         CASEQ     *ON           Sr_Build
      *
      ** Process screen input
      *
     C                   CAS                     Sr_ScreenIn
     C                   ENDCS
      *
     C                   ENDDO
     C                   ENDDO
      *
      *****************************************************************
      *                                                               *
      * Sr_Load   - Initialise and Load Subfile Page                  *
      *                                                               *
      * Calls     - Sr_Build                                          *
      *           - ZASNMS                                            *
      *                                                               *
      * Called by - MAIN                                              *
      *                                                               *
      *****************************************************************
     C     Sr_Load       BEGSR
      *
      ** Set Up Function Key Text - Standard Functions
     C     UMODE         IFEQ      'E'
     C                   MOVE      *OFF          *IN75
     C                   MOVEA     TXT(3)        ##CTX1
     C                   ELSE
     C                   MOVE      *ON           *IN75
     C     W0PMD         IFEQ      'CHQ'
     C                   MOVEA     TXT(1)        ##CTX1
     C                   ENDIF
     C     W0PMD         IFEQ      'ADD'
     C                   MOVEA     TXT(2)        ##CTX1
     C                   ENDIF
     C                   ENDIF
      *
      ** Clear subfile
     C                   MOVE      *ON           *IN80
     C                   WRITE     #SFLCTL
     C                   MOVE      *OFF          *IN80
      *
      ** Reset no of records in subfile
     C                   Z-ADD     *ZERO         ##RRMX            5 081        Setof 81
      *
      *
     C     W0PMD         IFNE      'ADD'
      *
     C                   MOVE      D2BRCA        WWBRCA
     C                   MOVE      D2CTRT        WWCTRT
     C                   MOVE      D2ACOD        WWACOD
     C                   MOVE      D2ACSQ        WWACSQ
     C                   MOVE      D2NARR        WWNARR
     C                   MOVE      D2VALD        WWVALD
     C                   MOVE      D2STDY        WWSTDY
     C                   MOVE      D2PLMI        WWPLMI
     C                   MOVE      D2CHQC        WWCHQC
     C                   MOVE      D2GROS        WWGROS
     C                   MOVE      D2CUST        WWCUST
      *
      ** Set up key
     C                   MOVE      D2BRCA        KPBRCA
     C                   MOVE      D2CTRT        KPCTRT
      *
     C     KCTPO1        SETLL     SDCTPOL0                           82
     C  N82              READ      SDCTPOL0                             9182
     C                   ELSE
     C                   MOVE      *BLANKS       D2BRCA
     C                   MOVE      *BLANKS       D2CTRT
     C                   MOVE      *OFF          *IN82
     C                   ENDIF
      *
      ** Translate search mask for text field.
      *
      ** Branch
     C     *LIKE         DEFINE    D2BRCA        WQBRCA
     C                   CALL      'QDCXLATE'
     C                   PARM      3             WQA5N             5 0
     C                   PARM      D2BRCA        WQBRCA
     C                   PARM      'QSYSTRNTBL'  WQB10X           10
     C                   PARM      'QSYS'        WQC10X           10
      *
      ** Cashier Transaction
     C     *LIKE         DEFINE    D2CTRT        WQCTRT
     C                   CALL      'QDCXLATE'
     C                   PARM      2             WQA5N
     C                   PARM      D2CTRT        WQCTRT
     C                   PARM      'QSYSTRNTBL'  WQB10X
     C                   PARM      'QSYS'        WQC10X
      *
      ** Account Code
     C     *LIKE         DEFINE    D2ACOD        WQACOD
     C                   CALL      'QDCXLATE'
     C                   PARM      4             WQA5N
     C                   PARM      D2ACOD        WQACOD
     C                   PARM      'QSYSTRNTBL'  WQB10X
     C                   PARM      'QSYS'        WQC10X
      *
      ** Account Sequence
     C     *LIKE         DEFINE    D2ACSQ        WQACSQ
     C                   CALL      'QDCXLATE'
     C                   PARM      2             WQA5N
     C                   PARM      D2ACSQ        WQACSQ
     C                   PARM      'QSYSTRNTBL'  WQB10X
     C                   PARM      'QSYS'        WQC10X
      *
      ** Narrative
     C     *LIKE         DEFINE    D2NARR        WQNARR
     C                   CALL      'QDCXLATE'
     C                   PARM      2             WQA5N
     C                   PARM      D2NARR        WQNARR
     C                   PARM      'QSYSTRNTBL'  WQB10X
     C                   PARM      'QSYS'        WQC10X
      *
      ** Use Value Date
     C     *LIKE         DEFINE    D2VALD        WQVALD
     C                   CALL      'QDCXLATE'
     C                   PARM      1             WQA5N
     C                   PARM      D2VALD        WQVALD
     C                   PARM      'QSYSTRNTBL'  WQB10X
     C                   PARM      'QSYS'        WQC10X
      *
      ** Standard Days
     C     *LIKE         DEFINE    D2STDY        WQSTDY
     C                   CALL      'QDCXLATE'
     C                   PARM      2             WQA5N
     C                   PARM      D2STDY        WQSTDY
     C                   PARM      'QSYSTRNTBL'  WQB10X
     C                   PARM      'QSYS'        WQC10X
      *
      ** Plus/Minus
     C     *LIKE         DEFINE    D2PLMI        WQPLMI
     C                   CALL      'QDCXLATE'
     C                   PARM      1             WQA5N
     C                   PARM      D2PLMI        WQPLMI
     C                   PARM      'QSYSTRNTBL'  WQB10X
     C                   PARM      'QSYS'        WQC10X
      *
      ** Include Cheque Clearing Flag
     C     *LIKE         DEFINE    D2CHQC        WQCHQC
     C                   CALL      'QDCXLATE'
     C                   PARM      1             WQA5N
     C                   PARM      D2CHQC        WQCHQC
     C                   PARM      'QSYSTRNTBL'  WQB10X
     C                   PARM      'QSYS'        WQC10X
      *
      ** Include Gross Amount Posting Flag
     C     *LIKE         DEFINE    D2GROS        WQGROS
     C                   CALL      'QDCXLATE'
     C                   PARM      1             WQA5N
     C                   PARM      D2GROS        WQGROS
     C                   PARM      'QSYSTRNTBL'  WQB10X
     C                   PARM      'QSYS'        WQC10X
      *
      ** Include Use Customer in Account Flag
     C     *LIKE         DEFINE    D2CUST        WQCUST
     C                   CALL      'QDCXLATE'
     C                   PARM      1             WQA5N
     C                   PARM      D2CUST        WQCUST
     C                   PARM      'QSYSTRNTBL'  WQB10X
     C                   PARM      'QSYS'        WQC10X
      *
      ** Load subfile page
     C                   EXSR      Sr_Build
      *
      ** If no records found, display error message
     C     *IN82         IFEQ      *ON
     C     ##RR          ANDEQ     *ZERO
      *
      ** Send message '*No data to display'
     C                   MOVEL     'Y2U0008'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF
      *
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * Sr_Build  - Load Subfile Page (write empty page if add record)*
      *                                                               *
      * Calls     - Sr_ResetFld                                       *
      *           - Sr_LoadFld                                        *
      *           - Sr_DspAttr1                                       *
      *                                                               *
      * Called by - MAIN                                              *
      *           - Sr_Load                                           *
      *                                                               *
      *****************************************************************
     C     Sr_Build      BEGSR
      *
     C                   MOVE      *OFF          *IN84                          No SFLNXTCHG
      *
      ** Re-establish fields in read-ahead record
     C     *IN27         IFEQ      *ON
     C     W0PMD         ANDNE     'ADD'
     C     *IN82         IFEQ      *OFF
     C                   READP     SDCTPOL0                               90
     C                   READ      SDCTPOL0                               90
     C                   ENDIF
     C                   ENDIF
      *
      ** Setof record error indicators
     C                   MOVE      *ALL'0'       WKIND0           11
     C                   MOVE      *ALL'1'       WKIND1           11
      *
      ** Start at previous highest record in SFL
     C                   Z-ADD     ##RRMX        ##RR              5 0
     C                   Z-ADD     *ZERO         ##RROK            5 0
      *
      ** Reset count of DBF records read
     C                   Z-ADD     0             ##RRRD            5 0
      *
      ** Set required pages based on *Set Cursor or *Subfile Pages
     C     W0RR0         IFGT      0
     C     W0RR0         DIV       ##SFPG        ##SPG             3 0
     C                   MVR                     ##SLIN            3 0
     C     ##SLIN        IFGT      0
     C                   ADD       1             ##SPG
     C                   ENDIF
     C     W0SPG         IFGT      ##SPG
     C                   Z-ADD     W0SPG         ##SPG
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     W0SPG         ##SPG
     C                   ENDIF
      *
      ** Compute lines required based on pages
     C     ##SPG         MULT      ##SFPG        ##SFLN            9 0
     C     ##SFLN        IFGT      999
     C                   Z-ADD     999           ##SFLN
     C                   ENDIF
      *
      ** Load next SFL page until SFL page full, or :
      ** scan limit reached.
     C     *IN82         DOWEQ     '0'
     C     ##RROK        ANDLT     ##SFPG
     C     ##RRRD        ANDLT     W0SLM
      *
      ** Check selection fields - if fail, read next record.
      ** Scan for search string.
      *
      ** Branch
     C     D2BRCA        IFNE      *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    CPBRCA                         Description
     C                   PARM      3             WQA3N             3 0          Length
     C                   PARM      1             WQB3N             3 0          Start
     C                   PARM                    WQBRCA                         Mask
     C                   PARM      3             WQC3N             3 0          Length
     C                   PARM      '1'           WQD1              1            Translate
     C                   PARM      '1'           WQE1              1            Trim
     C                   PARM      '?'           WQF1              1            Wild
     C                   PARM                    WQG3N             3 0          Result
     C     WQG3N         CABLT     1             BB020
     C                   END
      *
      ** Cashier Transaction
     C     D2CTRT        IFNE      *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    CPCTRT                         Description
     C                   PARM      4             WQA3N                          Length
     C                   PARM      1             WQB3N                          Start
     C                   PARM                    WQCTRT                         Mask
     C                   PARM      4             WQC3N                          Length
     C                   PARM      '1'           WQD1                           Translate
     C                   PARM      '1'           WQE1                           Trim
     C                   PARM      '?'           WQF1                           Wild
     C                   PARM                    WQG3N                          Result
     C     WQG3N         CABLT     1             BB020
     C                   END
      *
      ** Midas Account Code
     C     D2ACOD        IFNE      *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    CPACOD                         Description
     C                   PARM      4             WQA3N                          Length
     C                   PARM      1             WQB3N                          Start
     C                   PARM                    WQACOD                         Mask
     C                   PARM      4             WQC3N                          Length
     C                   PARM      '1'           WQD1                           Translate
     C                   PARM      '1'           WQE1                           Trim
     C                   PARM      '?'           WQF1                           Wild
     C                   PARM                    WQG3N                          Result
     C     WQG3N         CABLT     1             BB020
     C                   END
      *
      ** Account Sequence
     C     D2ACSQ        IFNE      *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    CPACSQ                         Description
     C                   PARM      2             WQA3N                          Length
     C                   PARM      1             WQB3N                          Start
     C                   PARM                    WQACSQ                         Mask
     C                   PARM      2             WQC3N                          Length
     C                   PARM      '1'           WQD1                           Translate
     C                   PARM      '1'           WQE1                           Trim
     C                   PARM      '?'           WQF1                           Wild
     C                   PARM                    WQG3N                          Result
     C     WQG3N         CABLT     1             BB020
     C                   END
      *
      ** Narrative
     C     D2NARR        IFNE      *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    CPNARR                         Description
     C                   PARM      2             WQA3N                          Length
     C                   PARM      1             WQB3N                          Start
     C                   PARM                    WQNARR                         Mask
     C                   PARM      2             WQC3N                          Length
     C                   PARM      '1'           WQD1                           Translate
     C                   PARM      '1'           WQE1                           Trim
     C                   PARM      '?'           WQF1                           Wild
     C                   PARM                    WQG3N                          Result
     C     WQG3N         CABLT     1             BB020
     C                   END
      *
      ** Use Value Date
     C     D2VALD        IFNE      *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    CPVALD                         Description
     C                   PARM      1             WQA3N                          Length
     C                   PARM      1             WQB3N                          Start
     C                   PARM                    WQVALD                         Mask
     C                   PARM      1             WQC3N                          Length
     C                   PARM      '1'           WQD1                           Translate
     C                   PARM      '1'           WQE1                           Trim
     C                   PARM      '?'           WQF1                           Wild
     C                   PARM                    WQG3N                          Result
     C     WQG3N         CABLT     1             BB020
     C                   END
      *
      ** Standard Days
     C     D2STDY        IFNE      *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    CPSTDY                         Description
     C                   PARM      2             WQA3N                          Length
     C                   PARM      1             WQB3N                          Start
     C                   PARM                    WQSTDY                         Mask
     C                   PARM      2             WQC3N                          Length
     C                   PARM      '1'           WQD1                           Translate
     C                   PARM      '1'           WQE1                           Trim
     C                   PARM      '?'           WQF1                           Wild
     C                   PARM                    WQG3N                          Result
     C     WQG3N         CABLT     1             BB020
     C                   END
      *
      ** Plus/Minus
     C     D2PLMI        IFNE      *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    CPPLMI                         Description
     C                   PARM      1             WQA3N                          Length
     C                   PARM      1             WQB3N                          Start
     C                   PARM                    WQPLMI                         Mask
     C                   PARM      1             WQC3N                          Length
     C                   PARM      '1'           WQD1                           Translate
     C                   PARM      '1'           WQE1                           Trim
     C                   PARM      '?'           WQF1                           Wild
     C                   PARM                    WQG3N                          Result
     C     WQG3N         CABLT     1             BB020
     C                   END
      *
      ** Include Cheque Clearing Flag
     C     D2CHQC        IFNE      *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    CPCHQC                         Description
     C                   PARM      1             WQA3N                          Length
     C                   PARM      1             WQB3N                          Start
     C                   PARM                    WQCHQC                         Mask
     C                   PARM      1             WQC3N                          Length
     C                   PARM      '1'           WQD1                           Translate
     C                   PARM      '1'           WQE1                           Trim
     C                   PARM      '?'           WQF1                           Wild
     C                   PARM                    WQG3N                          Result
     C     WQG3N         CABLT     1             BB020
     C                   END
      *
      ** Include Post Gross Amount Flag
     C     D2GROS        IFNE      *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    CPGROS                         Description
     C                   PARM      1             WQA3N                          Length
     C                   PARM      1             WQB3N                          Start
     C                   PARM                    WQGROS                         Mask
     C                   PARM      1             WQC3N                          Length
     C                   PARM      '1'           WQD1                           Translate
     C                   PARM      '1'           WQE1                           Trim
     C                   PARM      '?'           WQF1                           Wild
     C                   PARM                    WQG3N                          Result
     C     WQG3N         CABLT     1             BB020
     C                   END
      *
      ** Include Use Customer in Account Flag
     C     D2CUST        IFNE      *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    CPCUST                         Description
     C                   PARM      1             WQA3N                          Length
     C                   PARM      1             WQB3N                          Start
     C                   PARM                    WQCUST                         Mask
     C                   PARM      1             WQC3N                          Length
     C                   PARM      '1'           WQD1                           Translate
     C                   PARM      '1'           WQE1                           Trim
     C                   PARM      '?'           WQF1                           Wild
     C                   PARM                    WQG3N                          Result
     C     WQG3N         CABLT     1             BB020
     C                   END
      *
     C                   MOVEA     WKIND0        *IN(32)
     C                   MOVE      *OFF          *IN87
      *
      ** Clear subfile fields
     C                   EXSR      Sr_ResetFld
      *
      ** If CHANGE mode, load subfile fields
     C     W0PMD         IFNE      'ADD'
      ** Load SFL fields.
     C                   EXSR      Sr_LoadFld
      *
      ** Record will be selected unless overridden
     C                   MOVEL     'Y'           W0RSL             1
      *
      ** Initialize subfile record (existing record)
     C                   MOVEL     'Y'           WUDELA                         Deletion Allowed
     C                   MOVEL     'Y'           WUAMAL                         Amend allowed
      *
      ** If record dropped...
     C                   SUB       1             ##RR
     C     W0RSL         IFNE      'N'
     C                   ADD       1             ##RR
     C                   ENDIF
      *
     C                   ELSE
      *
      ** USER: Initialize subfile record (new record)
     C                   MOVEL     'Y'           WUAMAL                         Amend allowed
      *
      ** CASE: PGM.*Program mode is *ADD
     C     W0PMD         IFEQ      'ADD'
     C                   MOVEL     'N'           WUDELA                         Deletion Allowed
     C                   ENDIF
     C                   ENDIF
      *
      ** Output to subfile.
     C     W0RSL         IFNE      'N'
     C                   ADD       1             ##RR                 81
     C                   ADD       1             ##RROK
      ** Set screen conditioning indicators
      *
     C                   EXSR      Sr_DspAttr1
     C                   WRITE     #SFLRCD
     C                   ENDIF
     C     BB020         TAG
      *
      ** Increment scan check count.
     C                   ADD       1             ##RRRD
     C     W0PMD         IFNE      'ADD'
     C                   READ      SDCTPOL0                               82
     C                   ENDIF
     C                   ENDDO
      *
      ** If no DBF records found, display error message.
     C     ##RR          IFEQ      *ZERO
     C     *IN82         ANDEQ     '1'
      *
      ** Send message '*no data to display'
     C                   MOVEL     'Y2U0008'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   END                                                    FI ##RR = *ZERO
      *
      ** Save highest SFL record load can continue at end point.
     C     ##RR          IFGT      ##RRMX
     C     ##RRMX        ADD       1             ##SFRC
     C                   Z-ADD     ##RR          ##RRMX
     C                   END
      *
      ** If scan limit reached, display error message.
     C     ##RRRD        IFGE      W0SLM
      *
      ** Send message '*Scan limit reached'
     C                   MOVEL     'Y2U0017'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE
     C                   Z-ADD     0             ##RROK
     C                   END
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * Sr_Display - Display screen                                    *
      *                                                               *
      * Calls     - Sr_DspAttr2                                       *
      *           - #IY8TS                                            *
      *           - #IHPKY                                            *
      *                                                               *
      * Called by - MAIN                                              *
      *                                                               *
      *****************************************************************
     C     Sr_Display    BEGSR
      *
      ** Set screen conditioning indicators
      *
     C                   EXSR      Sr_DspAttr2
      *
      ** Update screen time
     C                   TIME                    DDTIME
      *
      ** PUTOVR unless conditioned fields change
     C                   MOVE      *ON           *IN86
     C     *IN89         IFNE      CAIN89
     C     *IN81         ORNE      CAIN81
     C                   MOVE      *OFF          *IN86
     C                   ENDIF
     C                   MOVE      *IN89         CAIN89            1
     C                   MOVE      *IN81         CAIN81            1
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #SFLCTL
      *
      ** Maintain subfile position where possible
     C     @#SFRC        IFGT      *ZERO
     C                   Z-ADD     @#SFRC        ##SFRC
     C                   ENDIF
      *
      ** Test cursor
     C                   EXSR      #IY8TS
      *
      ** Clear set cursor DDS indicator
     C     WCSRLC        IFEQ      'OFF'
     C                   MOVE      *OFF          *IN94
     C                   ENDIF
     C                   MOVE      *BLANK        WCSRLC
      *
      ** Update job time
     C                   TIME                    ##JTM
      *
      ** Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      *
      ** Reset first message only flag
     C                   MOVEL     'Y'           ZAFSMS            1      99
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * Sr_ScreenIn - Process Screen Input                            *
      *                                                               *
      * Calls     - Sr_Modified                                       *
      *           - Sr_UpdateSfl                                      *
      *           - Sr_AddChange                                      *
      *           - Sr_EnqInput                                       *
      *                                                               *
      * Called by - MAIN                                              *
      *                                                               *
      *****************************************************************
     C     Sr_ScreenIn   BEGSR
      *
     C     UMODE         IFEQ      'E'
     C                   EXSR      Sr_EnqInput
     C                   ELSE
      *
     C     W0PMD         IFNE      'ADD'
      *
      ** Change of position specified
     C     WWBRCA        CASNE     D2BRCA        Sr_ReLoad
     C     WWCTRT        CASNE     D2CTRT        Sr_ReLoad
     C     WWACOD        CASNE     D2ACOD        Sr_ReLoad
     C     WWACSQ        CASNE     D2ACSQ        Sr_ReLoad
     C     WWNARR        CASNE     D2NARR        Sr_ReLoad
     C     WWVALD        CASNE     D2VALD        Sr_ReLoad
     C     WWSTDY        CASNE     D2STDY        Sr_ReLoad
     C     WWPLMI        CASNE     D2PLMI        Sr_ReLoad
     C     WWCHQC        CASNE     D2CHQC        Sr_ReLoad
     C     WWGROS        CASNE     D2GROS        Sr_ReLoad
     C     WWCUST        CASNE     D2CUST        Sr_ReLoad
     C                   END
     C                   END
      *
      ** Validate subfile control
      ** Quit if reload requested
      *
     C     W0RSF         IFNE      'Y'
      *
     C     *IN81         IFEQ      *ON
      *
     C                   DO
      *
      ** No data entered as yet
     C                   MOVEL     'N'           WKIPIN            1
      *
      ** Confirm/update is not deferred
     C                   MOVEL     'N'           W0DCF             1
      *
      ** Process subfile records
     C                   EXSR      Sr_Modified
      *
      ** If error, exit
     C     *IN99         IFNE      *ON
      *
      ** Defer confirm/update requested
     C     W0DCF         IFNE      'Y'
      *
      ** If data entered
     C     WKIPIN        IFEQ      'Y'
     C     *IN09         ANDNE     *ON
      *
      ** Update DBF from subfile
     C                   EXSR      Sr_UpdateSfl
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
     C                   ENDIF
      *
      ** If error during update, exit:
      *
     C     *IN99         IFNE      *ON
      *
      ** Switch to *CHANGE mode
     C     *IN09         IFEQ      *ON
     C                   EXSR      Sr_AddChange
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Process command keys
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * Sr_EnqInput - Process screen input (Enquiry Mode)             *
      *                                                               *
      * Calls     - Sr_ReLoad                                         *
      *                                                               *
      * Called by - Sr_ScreenIn                                       *
      *                                                               *
      *****************************************************************
     C     Sr_EnqInput   BEGSR
      *
     C     @#SFRC        IFGT      *ZERO
     C                   Z-ADD     @#SFRC        ##SFRC
     C                   END
      *
      ** Confirm/update is not defered.
     C                   MOVEL     'N'           W0DCF             1
      *
      ** Change of position specified.
     C     WWBRCA        CASNE     D2BRCA        Sr_ReLoad
     C     WWCTRT        CASNE     D2CTRT        Sr_ReLoad
     C     WWACOD        CASNE     D2ACOD        Sr_ReLoad
     C     WWACSQ        CASNE     D2ACSQ        Sr_ReLoad
     C     WWNARR        CASNE     D2NARR        Sr_ReLoad
     C     WWVALD        CASNE     D2VALD        Sr_ReLoad
     C     WWSTDY        CASNE     D2STDY        Sr_ReLoad
     C     WWPLMI        CASNE     D2PLMI        Sr_ReLoad
     C     WWCHQC        CASNE     D2CHQC        Sr_ReLoad
     C     WWGROS        CASNE     D2GROS        Sr_ReLoad
     C     WWCUST        CASNE     D2CUST        Sr_ReLoad
     C                   END
      *
      ** Reload subfile requested:
     C     W0RSF         CABEQ     'Y'           DAEXIT
      *
      ** If error, Quit processing:
     C     *IN99         CABEQ     '1'           DAEXIT
      *
      ** Defer confirm/update requested:
     C     W0DCF         CABEQ     'Y'           DAEXIT
      *
     C     DAEXIT        ENDSR
      *
      *****************************************************************
      *                                                               *
      * Sr_Modified - Process Modified Subfile Record                 *
      *                                                               *
      * Calls     - Sr_ProcRec                                        *
      *           - Sr_DspAttr1                                       *
      *                                                               *
      * Called by - MAIN                                              *
      *                                                               *
      *****************************************************************
     C     Sr_Modified   BEGSR
      *
      * Clear record array
     C                   MOVEA     *BLANKS       REC
     C                   Z-ADD     1             Y                 3 0
      *
     C                   READC     #SFLRCD                                92
     C     *IN92         DOWEQ     *OFF
     C                   EXSR      Sr_ProcRec
     C                   MOVE      *OFF          *IN87
      *
      ** Set screen conditioning indicators
     C                   EXSR      Sr_DspAttr1
     C                   UPDATE    #SFLRCD
     C                   READC     #SFLRCD                                92
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * Sr_ProcRec- Process Subfile Record                            *
      *                                                               *
      * Calls     - Sr_ChkNull                                        *
      *           - Sr_Validate                                       *
      *                                                               *
      * Called by - Sr_Modified                                       *
      *                                                               *
      *****************************************************************
     C     Sr_ProcRec    BEGSR
      *
      ** Set off error indicators
      *
     C                   MOVEA     WKIND0        *IN(32)
      *
      ** No errors
     C                   MOVE      *OFF          *IN98
      *
      ** No SFLNXTCHG
     C                   MOVE      *OFF          *IN84
      *
     C     W0PMD         IFEQ      'ADD'
      ** Check for null record
     C                   EXSR      Sr_ChkNull
      ** If not null record, continue
     C     W0NLR         IFEQ      'Y'
     C                   GOTO      DCEXIT
     C                   ENDIF
     C                   ENDIF
      *
      ** Data entered
     C                   MOVEL     'Y'           WKIPIN
      *
      ** SFLNXTCHG
     C                   MOVE      *ON           *IN84
      *
     C     D1SELC        IFNE      'D'
      *
      ** Validate subfile record
     C                   EXSR      Sr_Validate
      *
      ** If SFLRCD invalid, note the fact
     C   98
     CANN99              Z-ADD     ##RR          ##SFRC               99
     C                   ENDIF
      *
     C     DCEXIT        ENDSR
      *
      *****************************************************************
      * Sr_ChkNull- Check for Null Record                             *
      *                                                               *
      * Calls     -                                                   *
      *                                                               *
      * Called by - Sr_ProcRec                                        *
      *           - Sr_ProcModSf                                      *
      *                                                               *
      *****************************************************************
     C     Sr_ChkNull    BEGSR
      *
     C                   MOVEL     'N'           W0NLR             1
     C     D1BRCA        IFEQ      *BLANK
     C     D1CTRT        ANDEQ     *BLANK
     C     D1ACOD        ANDEQ     *BLANK
     C     D1ACSQ        ANDEQ     *BLANK
     C     D1NARR        ANDEQ     *BLANK
     C     D1VALD        ANDEQ     *BLANK
     C     D1STDY        ANDEQ     *BLANK
     C     D1PLMI        ANDEQ     *BLANK
     C     D1CHQC        ANDEQ     *BLANK
     C     D1GROS        ANDEQ     *BLANK
     C     D1CUST        ANDEQ     *BLANK
     C                   MOVEL     'Y'           W0NLR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * Sr_Validate - Validate Subfile Record                         *
      *                                                               *
      * Calls     - ZASNMS                                            *
      *                                                               *
      * Called by - Sr_ProcRec                                        *
      *                                                               *
      *****************************************************************
     C     Sr_Validate   BEGSR
      *
      ** Validate subfile record fields
      *
     C                   MOVEL     *BLANK        W0RTN
      *
      * If Insert, ensure details entered for Branch/Transaction do not exist
      * on SDCTPOPD
     C     W0PMD         IFEQ      'ADD'
     C                   MOVEL     D1BRCA        KPBRCA
     C                   MOVEL     D1CTRT        WW_CTRTDSP
     C     WW_CTRTD3     IFEQ      '-'
     C                   MOVEL     D1CTRT        WW_CTRTU1
     C                   MOVE      D1CTRT        WW_CTRTU2
     C                   MOVE      WW_CTRTU      KPCTRT
     C                   ELSE
     C     WW_CTRTD1     IFEQ      ' '
     C                   MOVE      D1CTRT        KPCTRT
     C                   ELSE
     C                   MOVEL     D1CTRT        KPCTRT
     C                   ENDIF
     C                   ENDIF
      *
     C     KCTPO1        CHAIN     SDCTPOL0                           90
     C     *IN90         IFEQ      *OFF
     C                   MOVEA     WKIND1        *IN(33)
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR9753'     W0RTN
     C                   MOVEL     'USR9753'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      EndVal
      *
      * Else check record array to see if record for Branch/Com Code
      * is already on subfile.
     C                   ELSE
     C                   MOVEL     D1BRCA        W_BRANCH
     C                   MOVEL     KPCTRT        W_CASHTT
     C     W_REC         LOOKUP    REC                                    90
     C     *IN90         IFEQ      *ON
     C                   MOVEA     WKIND1        *IN(33)
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR9753'     W0RTN
     C                   MOVEL     'USR9753'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      EndVal
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C
      ** Branch: Optional
     C     D1BRCA        IFNE      *BLANKS
      *
      ** Call access programme to determine whether Branch Code
      *  entered is valid.
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    D1BRCA
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      A8BRCD        D1BRCA
     C                   ELSE
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN98
     C                   MOVE      *ON           *IN33
     C                   MOVEL     'USR0075'     W0RTN
     C                   MOVEL     'USR0075'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *
      ** Cashier Transaction: Mandatory
     C                   MOVEL     D1CTRT        WUTQKF
     C                   MOVEL     *BLANK        W0RTN
      *
      * Transaction Code must be in format XXXX or XX-XX.
     C                   MOVE      D1CTRT        WCTRT
     C                   MOVEA     D1CTRT        TRN
      *
      * If less than 4 characters entered then error
     C                   Z-ADD     1             X                 1 0
     C                   Z-ADD     0             NoChar            1 0
      *
     C     X             DOUEQ     6
     C     TRN(X)        IFNE      ' '
     C                   ADD       1             NoChar
     C                   ENDIF
     C                   ADD       1             X
     C                   ENDDO
      *
     C     NoChar        IFLT      4
     C     NoChar        OREQ      5
     C     WCTRT3        ANDNE     '-'
     C                   MOVEL     'USR9755'     W0RTN
     C                   MOVEL     'USR9755'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN98
     C                   MOVE      *ON           *IN34
     C                   MOVE      *ON           *IN50
      *
     C                   ELSE
     C     WCTRT1        IFEQ      ' '
     C                   MOVE      WCTRT25       SaveWCTRT         4
     C                   MOVE      SaveWCTRT     WCTRT14
     C                   MOVE      ' '           WCTRT5
     C                   MOVE      WCTRT         D1CTRT
     C                   ENDIF
     C                   ENDIF
      *
      ** Validate Account Code
     C                   EXSR      Sr_ValidAcC
      *
      ** Sequence Number: Optional
     C     D1ACSQ        IFNE      *BLANKS
     C     D1ACSQ        IFGT      '99'
     C     D1ACSQ        ORLT      '01'
      *
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN98
     C                   MOVE      *ON           *IN36
     C                   MOVEL     'USR9741'     W0RTN
     C                   MOVEL     'USR9741'     ZAMSID
     C                   EXSR      ZASNMS
      *
     C                   ENDIF
     C                   ELSE
     C     D1ACOD        IFNE      *BLANKS
     C                   MOVE      '01'          D1ACSQ
     C                   ENDIF
     C                   ENDIF
      *
      ** Narrative Code: Optional
      * Must be valid narrative code on Narratives table.
     C     D1NARR        IFNE      *BLANKS
     C                   CALL      'AONARRR0'
     C                   PARM                    @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM                    D1NARR
     C     SDNARR        PARM      SDNARR        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
      *
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN98
     C                   MOVE      *ON           *IN37
     C                   MOVEL     'USR9742'     W0RTN
     C                   MOVEL     'USR9742'     ZAMSID
     C                   EXSR      ZASNMS
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Use Value Date Flag:Optional
      * If entered Y or N.
     C     D1VALD        IFNE      *BLANKS
 
     C     D1VALD        IFNE      'Y'
     C     D1VALD        ANDNE     'N'
      *
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN98
     C                   MOVE      *ON           *IN38
     C                   MOVEL     'USR9743'     W0RTN
     C                   MOVEL     'USR9743'     ZAMSID
     C                   EXSR      ZASNMS
      *
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'N'           D1VALD
     C                   ENDIF
      *
      * Entry may only be made in Standard Days if Use value date flag is N
     C     D1VALD        IFNE      'N'
     C     D1STDY        ANDNE     *BLANKS
     C     D1VALD        ORNE      'N'
     C     D1PLMI        ANDNE     *BLANKS
     C                   MOVE      *ON           *IN39
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR9744'     W0RTN
     C                   MOVEL     'USR9744'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
      *
      * Standard Days if entered must be 01-99
      * and a + or - must be entered.
B1   C     D1STDY        IFNE      *BLANKS
     C     D1PLMI        ORNE      *BLANKS
      *
B2   C     D1STDY        IFLT      '01'
     C     D1STDY        ORGT      '99'
     C                   MOVE      *ON           *IN39
E2   C                   ENDIF
 
B2   C     D1PLMI        IFNE      '+'
     C     D1PLMI        ANDNE     '-'
     C                   MOVE      *ON           *IN39
E2   C                   ENDIF
      *
B2   C     *IN39         IFEQ      *ON
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR9745'     W0RTN
     C                   MOVEL     'USR9745'     ZAMSID
     C                   EXSR      ZASNMS
      *
X2   C                   ELSE
      *
      * If no days entered as 'N ' change to be ' N'.
     C                   MOVEL     D1STDY        WW_STDY           2
     C     WW_STDY1      IFNE      ' '
     C     WW_STDY2      ANDEQ     ' '
     C                   MOVE      WW_STDY1      WW_STDY2
     C                   MOVE      '0'           WW_STDY1
     C                   MOVEL     WW_STDY       D1STDY
     C                   ENDIF
      *
      * If a '+' entered then number of days entered must be between
      * 1 and the number of days to Forward Value from the retail ICD
B3   C     D1PLMI        IFEQ      '+'
     C                   CALL      'AORETLR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDRETL        PARM      SDRETL        DSSDY
     C                   MOVE      BMNDFV        NoDays            2
X3   C                   ELSE
      *
      * If a '-' entered then number of days entered must be between
      * 1 and the back valued period from the bank ICD
     C                   MOVE      BJBVPD        NoDays
E3   C                   ENDIF
      *
B3   C     D1STDY        IFLT      '01'
     C     D1STDY        ORGT      NoDays
      *
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN98
     C                   MOVE      *ON           *IN39
B4   C     D1PLMI        IFEQ      '+'
     C                   MOVEL     'USR9746'     W0RTN
     C                   MOVEL     'USR9746'     ZAMSID
X4   C                   ELSE
     C                   MOVEL     'USR9751'     W0RTN
     C                   MOVEL     'USR9751'     ZAMSID
E4   C                   ENDIF
     C                   EXSR      ZASNMS
      *
E3   C                   ENDIF
E2   C                   ENDIF
E1   C                   ENDIF
E1   C                   ENDIF
      *
      ** Include Cheque Clearing Days:Optional
      * If entered must be Y or N
     C     D1CHQC        IFNE      *BLANKS
     C     D1CHQC        IFNE      'Y'
     C     D1CHQC        ANDNE     'N'
      *
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN98
     C                   MOVE      *ON           *IN40
     C                   MOVEL     'USR9749'     W0RTN
     C                   MOVEL     'USR9749'     ZAMSID
     C                   EXSR      ZASNMS
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Post Gross Amount:Optional
      * If entered must be Y or N
     C     D1GROS        IFNE      *BLANKS
     C     D1GROS        IFNE      'Y'
     C     D1GROS        ANDNE     'N'
      *
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN98
     C                   MOVE      *ON           *IN41
     C                   MOVEL     'USR9750'     W0RTN
     C                   MOVEL     'USR9750'     ZAMSID
     C                   EXSR      ZASNMS
      *
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'N'           D1GROS
     C                   ENDIF
      *
      ** Use Customer Number in Account:Optional
      * If entered must be Y or N
     C     D1CUST        IFNE      *BLANKS
     C     D1CUST        IFNE      'Y'
     C     D1CUST        ANDNE     'N'
      *
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN98
     C                   MOVE      *ON           *IN42
     C                   MOVEL     'USR9759'     W0RTN
     C                   MOVEL     'USR9759'     ZAMSID
     C                   EXSR      ZASNMS
      *
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'N'           D1CUST
     C                   ENDIF
      *
      * If valid, write to record arrays
     C     *IN50         IFEQ      *OFF
     C                   ADD       1             Y
     C                   MOVEL     D1BRCA        W_BRANCH
     C                   MOVEL     D1CTRT        WW_CTRTDSP
     C     WW_CTRTD3     IFEQ      '-'
     C                   MOVEL     D1CTRT        WW_CTRTU1
     C                   MOVE      D1CTRT        WW_CTRTU2
     C                   MOVE      WW_CTRTU      W_CASHTT
     C                   ELSE
     C     WW_CTRTD1     IFEQ      ' '
     C                   MOVE      D1CTRT        W_CASHTT
     C                   ELSE
     C                   MOVEL     D1CTRT        W_CASHTT
     C                   ENDIF
     C                   MOVEL     W_REC         REC(Y)
     C                   ENDIF
     C                   ENDIF
      *
     C     EndVal        TAG
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * Sr_ValidAcC - Validate Account Code                           *
      *                                                               *
      *****************************************************************
      *
     C     Sr_ValidAcC   BEGSR
      *
      ** Midas Account Code: Mandatory
     C***  D1ACOD        IFEQ      *BLANKS
     C***                MOVE      *ON           *IN50
     C***                MOVE      *ON           *IN98
     C***                MOVE      *ON           *IN35
     C***                MOVEL     'USR0183'     W0RTN
     C***                MOVEL     'USR0183'     ZAMSID
     C***                EXSR      ZASNMS
     C***                ENDIF
      *
     C     D1ACOD        IFNE      *BLANKS
      *
     C                   CALL      'AOACODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C**********         PARM      D1ACOD        @ACOD             4                          CGL029
     C                   PARM      D1ACOD        @ACOD            10                          CGL029
     C*****SDACOD        PARM      SDACOD        DSFDY                                        CGL029
     C     SDACOD        PARM      SDACOD        DSSDY                                        CGL029
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN98
     C                   MOVE      *ON           *IN35
     C                   MOVEL     'USR0183'     W0RTN
     C                   MOVEL     'USR0183'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
      *
     C                   MOVE      A5ACCD        D1ACOD
      *
      ** It must be non-Title A/C code.
     C     A5TOIN        IFNE      'N'
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN98
     C                   MOVE      *ON           *IN35
     C                   MOVEL     'USR0183'     W0RTN
     C                   MOVEL     'USR0183'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * Sr_UpdateSfl - Update DBF from Subfile                        *
      *                                                               *
      * Calls     - EBPRSP                                            *
      *           - Sr_DspAttr1                                       *
      *                                                               *
      * Called by - Sr_ScreenIn                                       *
      *                                                               *
      *****************************************************************
     C     Sr_UpdateSfl  BEGSR
      *
      ** Initialise subfile reload flag
      *
     C     W0PMD         IFEQ      'ADD'
     C                   MOVEL     'Y'           W0RSF
     C                   ELSE
     C                   MOVEL     'N'           W0RSF
     C                   ENDIF
      *
      ** Process all modified subfile records
      *
     C                   READC     #SFLRCD                                92
     C     *IN92         DOWEQ     '0'
      *
      ** Process modified subfile record
     C                   EXSR      Sr_ProcModSf
     C     W0RTN         IFNE      *BLANK
      *
      ** ROLLBACK any DBF changes
      *
     C                   ROLBK
     C                   ELSE
      *
      ** Otherwise COMMIT any DBF changes
      *
     C                   COMMIT
     C                   ENDIF
      *
      ** Set screen conditioning indicators
      *
     C                   EXSR      Sr_DspAttr1
     C                   UPDATE    #SFLRCD
     C                   READC     #SFLRCD                                92
     C                   ENDDO
      *
      ** If any errors, cancel reload
      *
     C     *IN99         IFEQ      *ON
     C                   MOVEL     'N'           W0RSF             1
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * Sr_ProcModSf - Process Modified Subfile Record                *
      *                                                               *
      * Calls     - Sr_ChkNull                                        *
      *           - Sr_Add                                            *
      *           - Sr_Delete                                         *
      *           - Sr_ProcChng                                       *
      *                                                               *
      *                                                               *
      * Called by - Sr_UpdateSfl                                      *
      *                                                               *
      *****************************************************************
     C     Sr_ProcModSf  BEGSR
      *
      ** Set off error indicators
     C                   MOVEA     WKIND0        *IN(32)
     C                   MOVE      *OFF          *IN98
      *
     C     W0PMD         IFEQ      'ADD'
      *
      ** Process add request
     C     D1SELC        IFNE      'D'
     C                   EXSR      Sr_ChkNull
     C     W0NLR         IFNE      'Y'
     C                   EXSR      Sr_Add
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C     D1SELC        IFEQ      'D'
     C     WUSUC         IFEQ      'Y'                                          Setup Complete
      *
      *
      ** Send message "Deletion is not allowed as Setup Complete Flag
      ** is equal to 'Y'".
     C                   MOVEL     'USR0026'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
      *
      ** Process delete request
      *
     C                   EXSR      Sr_Delete
     C                   ENDIF
     C                   ELSE
      *
      ** Process change request
      *
     C                   EXSR      Sr_ProcChng
     C                   ENDIF
     C                   ENDIF
      *
      ** If error occurred on update, note the fact
      *
     C     *IN98         IFEQ      *ON
     C     *IN99         IFEQ      *OFF
     C                   Z-ADD     ##RR          ##SFRC               99
     C                   ENDIF
     C                   ELSE
      *
      ** Extra processing after DBF update
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * Sr_Add    - Process add request                               *
      *                                                               *
      * Calls     - Sr_AddRec                                         *
      *                                                               *
      * Called by - Sr_ProcModSf                                      *
      *                                                               *
      *****************************************************************
     C     Sr_Add        BEGSR
      *
      ** Create DBF record
      *
     C                   EXSR      Sr_AddRec
     C     W0RTN         IFNE      *BLANK
      *
      ** Write error detected
      ** Screen errors
      *
     C                   MOVE      *ON           *IN98
      *
      ** Enable entry
     C                   MOVE      *OFF          *IN87
      *
      ** SFLNXTCHG
     C                   MOVE      *ON           *IN84
     C                   ELSE
      *
      ** DBF write successful
      ** Disable entry
      *
     C                   MOVE      *ON           *IN87
      *
      ** No SFLNXTCHG
     C                   MOVE      *OFF          *IN84
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Sr_Delete - Process Delete Request                            *
      *                                                               *
      * Calls     - Sr_DeleteR                                        *
      *                                                               *
      * Called by - Sr_ProcModSf                                      *
      *                                                               *
      *****************************************************************
     C     Sr_Delete     BEGSR
      *
      ** Delete DBF record
      *
     C                   EXSR      Sr_DeleteR
     C     W0RTN         IFNE      *BLANK
      *
      ** Delete unsuccessful
      ** Screen errors
      *
      ** Format error
     C                   MOVE      *ON           *IN98
      *
      ** Enable entry
     C                   MOVE      *OFF          *IN87
      *
      ** SFLNXTCHG
     C                   MOVE      *ON           *IN84
      *
      ** If record altered, reset subfile record
     C     W0RTN         CASEQ     'USR7538'     Sr_LoadFld
     C                   ENDCS
     C                   ELSE
      *
      ** DBF delete successful
      ** Blank out record and protect from entry
     C                   EXSR      Sr_ResetFld
      *
      ** disable entry
     C                   MOVE      *ON           *IN87
      *
      ** No SFLNXTCHG
     C                   MOVE      *OFF          *IN84
      *
      ** Reload subfile
     C                   MOVEL     'Y'           W0RSF             1
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * Sr_ProcChng - Process Update Request                          *
      *                                                               *
      * Calls     - Sr_Change                                         *
      *                                                               *
      * Called by - Sr_ProcModSf                                      *
      *                                                               *
      *****************************************************************
     C     Sr_ProcChng   BEGSR
      *
      ** Change DBF record
     C                   EXSR      Sr_Change
     C     W0RTN         IFNE      *BLANK
      *
      ** Data update error
      ** Screen errors
      *
      ** Format error
      *
     C                   MOVE      *ON           *IN98
      *
      ** Enable entry
     C                   MOVE      *OFF          *IN87
      *
      ** SFLNXTCHG
     C                   MOVE      *ON           *IN84
      *
      ** Reset subfile record if changed record
     C     W0RTN         CASEQ     'USR7538'     Sr_LoadFld
     C                   ENDCS
     C                   ELSE
      *
      ** DBF update successful
      ** Enable entry
     C                   MOVE      *OFF          *IN87
      *
      ** No SFLNXTCHG
     C                   MOVE      *OFF          *IN84
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * Sr_AddChange - Switch between *ADD/*CHANGE modes              *
      *                                                               *
      * Calls     -                                                   *
      *                                                               *
      * Called by - Sr_ScreenIn                                       *
      *                                                               *
      *****************************************************************
     C     Sr_AddChange  BEGSR
     C     W0PMD         IFNE      'ADD'
     C                   MOVEL     'ADD'         W0PMD
     C                   ELSE
     C                   MOVEL     'CHQ'         W0PMD
     C                   ENDIF
     C                   EXSR      Sr_ReLoad
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * Sr_ReLoad - Request Subfile Reload                            *
      *                                                               *
      * Calls     -                                                   *
      *                                                               *
      * Called by - MAIN                                              *
      *           - Sr_ScreenIn                                       *
      *           - Sr_AddChange                                      *
      *                                                               *
      *****************************************************************
     C     Sr_ReLoad     BEGSR
     C                   MOVEL     'Y'           W0RSF
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * Sr_DspAttr1 - Set display attributes for subfile record    *
      *                                                               *
      * Calls     -                                                   *
      *                                                               *
      * Called by - Sr_Build                                          *
      *           - Sr_Modified                                       *
      *           - Sr_UpdateSfl                                      *
      *                                                               *
      *****************************************************************
     C     Sr_DspAttr1   BEGSR
      *
     C     W0PMD         COMP      'ADD'                                  89
      *
      ** Protect keys if change mode or updated record
      *
     C                   MOVE      *ON           *IN88
     C     *IN89         IFEQ      *ON
     C     *IN87         ANDEQ     *OFF
     C                   MOVE      *OFF          *IN88
     C                   ENDIF
      *
     C                   MOVEL     *IN87         *IN79
     C     WUDELA        IFEQ      'N'
     C                   MOVEL     '1'           *IN79
     C                   ENDIF
      *
     C                   MOVEL     *IN87         *IN78
     C     WUAMAL        IFEQ      'N'
     C                   MOVEL     '1'           *IN78
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * Sr_DspAttr2 - Set display attributes for Subfile control      *
      *                                                               *
      * Calls     -                                                   *
      *                                                               *
      * Called by - Sr_Display                                        *
      *                                                               *
      *****************************************************************
     C     Sr_DspAttr2   BEGSR
     C     W0PMD         COMP      'ADD'                                  89
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * Sr_ResetFld - Initialise Subfile Record                  *
      *                                                               *
      * Calls     -                                                   *
      *                                                               *
      * Called by - Sr_Build                                          *
      *           - Sr_Delete                                         *
      *                                                               *
      *****************************************************************
     C     Sr_ResetFld   BEGSR
      *
      ** Previous values
     C                   MOVEL     *BLANK        D1SELC
     C                   MOVEL     *BLANK        D1BRCA
     C                   MOVEL     *BLANK        D1CTRT
     C                   MOVEL     *BLANK        D1ACOD
     C                   MOVEL     *BLANK        D1ACSQ
     C                   MOVEL     *BLANK        D1NARR
     C                   MOVEL     *BLANK        D1VALD
     C                   MOVEL     *BLANK        D1STDY
     C                   MOVEL     *BLANK        D1PLMI
     C                   MOVEL     *BLANK        D1CHQC
     C                   MOVEL     *BLANK        D1GROS
     C                   MOVEL     *BLANK        D1CUST
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * Sr_LoadFld- Move file fields to subfile                       *
      *                                                               *
      * Calls     -                                                   *
      *                                                               *
      * Called by - Sr_Build                                          *
      *           - EEDRLQ                                            *
      *           - Sr_ProcChng                                       *
      *                                                               *
      *****************************************************************
     C     Sr_LoadFld    BEGSR
     C                   MOVEL     CPBRCA        D1BRCA
      *
      ** Display the Cashier Transaction in XX-XX format
     C     CPCTRT        IFNE      *BLANKS
     C                   MOVEL     CPCTRT        WW_CTRT1
     C                   MOVE      CPCTRT        WW_CTRT2
     C                   MOVEL     WW_CTRT       D1CTRT
     C                   ELSE
     C                   MOVE      *BLANKS       D1CTRT
     C                   ENDIF
      *
     C     CPACOD        IFEQ      *ZEROS
     C                   MOVE      *BLANKS       D1ACOD
     C                   ELSE
     C                   MOVEL     CPACOD        D1ACOD
     C                   ENDIF
      *
     C     CPACSQ        IFEQ      *ZEROS
     C                   MOVE      *BLANKS       D1ACSQ
     C                   ELSE
     C                   MOVEL     CPACSQ        D1ACSQ
     C                   ENDIF
      *
     C                   MOVE      CPNARR        D1NARR
     C                   MOVE      CPVALD        D1VALD
      *
     C     CPSTDY        IFEQ      *ZEROS
     C                   MOVE      *BLANKS       D1STDY
     C                   ELSE
     C                   MOVEL     CPSTDY        D1STDY
     C                   ENDIF
      *
     C                   MOVE      CPPLMI        D1PLMI
     C                   MOVE      CPCHQC        D1CHQC
     C                   MOVE      CPGROS        D1GROS
     C                   MOVE      CPCUST        D1CUST
      *
      ** Hold current record image for change detection
     C                   MOVEL     @1CCTT        D1EREC
      *
     C                   ENDSR
      *
      *****************************************************************
      * Initialise subfile control
      *****************************************************************
     C     Sr_InitCFld   BEGSR
     C                   MOVEL     *BLANK        D2BRCA
     C                   MOVEL     *BLANK        D2CTRT
     C                   MOVEL     *BLANK        D2ACOD
     C                   MOVEL     *BLANK        D2ACSQ
     C                   MOVEL     *BLANK        D2NARR
     C                   MOVEL     *BLANK        D2VALD
     C                   MOVEL     *BLANK        D2STDY
     C                   MOVEL     *BLANK        D2PLMI
     C                   MOVEL     *BLANK        D2CHQC
     C                   MOVEL     *BLANK        D2GROS
     C                   MOVEL     *BLANK        D2CUST
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * Sr_AddRec - Add the changed Account Code to the file          *
      *                                                               *
      * Calls     - ZASNMS Sr_ValidateA                               *
      *                                                               *
      * Called by - Sr_Add                                            *
      *                                                               *
      *****************************************************************
     C     Sr_AddRec     BEGSR
     C                   MOVEL     *BLANK        W0RTN             7
     C                   MOVE      *OFF          *IN83
     C                   MOVE      *OFF          *IN85
      *
      ** Set up key
     C                   MOVE      D1BRCA        KPBRCA
      *
     C                   MOVEL     D1CTRT        WW_CTRTDSP
     C     WW_CTRTD3     IFEQ      '-'
     C                   MOVEL     D1CTRT        WW_CTRTU1
     C                   MOVE      D1CTRT        WW_CTRTU2
     C                   MOVE      WW_CTRTU      KPCTRT
     C                   ELSE
     C                   MOVE      D1CTRT        KPCTRT
     C                   ENDIF
      *
      *
     C     KCTPO1        SETLL     SDCTPOD1                               83
     C     *IN83         IFEQ      *ON
     C                   MOVEL     'Y2U0003'     W0RTN             7
      *
      ** Send message 'Record already exists'
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     'Y2U0003'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN33
     C                   ENDIF
      *
     C     *IN83         IFEQ      *OFF
     C                   EXSR      Sr_ValidateA
      *
     C     *IN50         IFEQ      *OFF
      *
      ** Move all fields to SDCTPOL1
     C                   MOVE      D1BRCA        CPBRCA
     C                   MOVE      D1ACOD        CPACOD
     C                   MOVE      D1ACSQ        CPACSQ
     C                   MOVE      D1NARR        CPNARR
     C                   MOVE      D1VALD        CPVALD
     C                   MOVE      D1STDY        CPSTDY
     C                   MOVE      D1PLMI        CPPLMI
     C                   MOVE      D1CHQC        CPCHQC
     C                   MOVE      D1GROS        CPGROS
     C                   MOVE      D1CUST        CPCUST
     C                   Z-ADD     WURDNB        CPLCD
     C                   MOVE      'I'           CPLCTP
     C                   Z-ADD     *ZEROS        QQACOD                                       CGL029
 
      ** Store the Cashier Transaction in xxxx format rather than xx-xx
     C                   MOVEL     D1CTRT        WW_CTRTDSP
     C     WW_CTRTD3     IFEQ      '-'
     C                   MOVEL     D1CTRT        WW_CTRTU1
     C                   MOVE      D1CTRT        WW_CTRTU2
     C                   MOVE      WW_CTRTU      CPCTRT
     C                   ELSE
     C                   MOVEL     D1CTRT        CPCTRT
     C                   ENDIF
      *
      *
     C                   WRITE     SDCTPOD1                             91
     C                   ENDIF
     C                   ENDIF
      *
     C     *IN91         IFEQ      *ON
      *
      ** Write error detected
      *
     C                   MOVEL     'Y2U0003'     W0RTN             7
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * Sr_DeleteR- Delete Commission Code                            *
      *                                                               *
      * Calls     - ZASNMS                                            *
      *                                                               *
      * Called by - Sr_Delete                                         *
      *                                                               *
      *****************************************************************
     C     Sr_DeleteR    BEGSR
     C                   MOVEL     *BLANK        W0RTN             7
      *
      ** Set up key
     C                   MOVE      D1BRCA        KPBRCA
      *
     C                   MOVEL     D1CTRT        WW_CTRTDSP
     C     WW_CTRTD3     IFEQ      '-'
     C                   MOVEL     D1CTRT        WW_CTRTU1
     C                   MOVE      D1CTRT        WW_CTRTU2
     C                   MOVE      WW_CTRTU      KPCTRT
     C                   ELSE
     C                   MOVE      D1CTRT        KPCTRT
     C                   ENDIF
      *
      *
     C     KCTPO1        CHAIN     SDCTPOD1                           9091
     C     *IN90         IFEQ      *ON
      *
      ** Record already deleted
     C                   MOVEA     WKIND1        *IN(32)
     C                   MOVEL     'USR0838'     W0RTN             7
      *
      ** Send message 'Record already deleted by another user'
     C                   MOVEL     'USR0838'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C     *IN91         IFEQ      *ON
     C     *IN90         ANDEQ     *OFF
      *
      ** Record locked
     C                   MOVEL     'USR7626'     W0RTN             7
      *
      ** Send message '*Database operation error'
     C                   MOVEL     'USR7626'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
      ** Check for changed record
     C     D1EREC        IFNE      @1CCTT
     C                   MOVEA     WKIND1        *IN(32)
     C                   MOVEL     'USR7538'     W0RTN             7
      *
      ** Send message '*Update not accepted'
     C                   MOVEL     'USR7538'     ZAMSID
     C                   EXSR      ZASNMS
      *
      ** Use SETLL to release record lock
      *
     C     KCTPO1        SETLL     SDCTPOD1                           9091
     C                   ELSE
      *
     C                   DELETE    SDCTPOD1
     C                   ENDIF
      *
     C     *IN91         IFEQ      *ON
      *
      ** Delete error detected
     C                   MOVEL     'USR0040'     W0RTN
     C                   ENDIF
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * Sr_ValidateA - Validate Account Code                          *
      *                                                               *
      * Calls     - ZASNMS                                            *
      *                                                               *
      * Called by - SACPRC                                            *
      *                                                               *
      *****************************************************************
     C     Sr_ValidateA  BEGSR
     C                   MOVE      *OFF          *IN50
      *
     C     D1SELC        IFNE      'D'
     C     D1SELC        ANDNE     *BLANK
     C                   MOVEL     'ASM0058'     W0RTN             7
      *
      ** Send message 'invalid value...'
      *
     C                   MOVEL     'ASM0058'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN32
     C                   MOVE      *ON           *IN50
     C                   ENDIF
      *
      ** Validate Account Code
     C                   EXSR      Sr_ValidAcC
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * Sr_Change - Change                                            *
      *                                                               *
      * Calls     - ZASNMS                                            *
      *                                                               *
      * Called by - Sr_ProcChng                                       *
      *                                                               *
      *****************************************************************
     C     Sr_Change     BEGSR
     C                   MOVEL     *BLANK        W0RTN             7
     C                   MOVE      'N'           YCRDC             1
      *
      ** Move key fields to SDCTPOL1
      *
     C                   MOVE      D1BRCA        KPBRCA
      *
     C                   MOVEL     D1CTRT        WW_CTRTDSP
     C     WW_CTRTD3     IFEQ      '-'
     C                   MOVEL     D1CTRT        WW_CTRTU1
     C                   MOVE      D1CTRT        WW_CTRTU2
     C                   MOVE      WW_CTRTU      KPCTRT
     C                   ELSE
     C                   MOVE      D1CTRT        KPCTRT
     C                   ENDIF
      *
      *
     C     KCTPO1        CHAIN     SDCTPOD1                           9091
      *
     C     *IN90         IFEQ      *ON
      *
      ** Record not found
     C                   MOVEL     'Y2U0005'     W0RTN             7
      *
      ** Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0005'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C     *IN91         IFEQ      *ON
     C     *IN90         ANDEQ     *OFF
      *
      ** Record locked
     C                   MOVEL     'ENB0210'     W0RTN             7
     C                   ENDIF
      *
      ** Check for changed record
     C     D1EREC        IFNE      @1CCTT
     C                   MOVEA     WKIND1        *IN(32)
     C                   MOVEL     'USR7538'     W0RTN             7
      *
      ** Send message '*Update not accepted'
     C                   MOVEL     'USR7538'     ZAMSID
     C                   EXSR      ZASNMS
      *
      * Release record lock
     C                   UNLOCK    SDCTPOL1                             91
     C                   GOTO      CHQEXIT
     C                   ELSE
      *
      ** Validate Account Code field
     C                   EXSR      Sr_ValidateA
      *
     C     *IN50         IFEQ      *OFF
      *
      ** Move non-key fields to SDCTPOL1
     C                   MOVE      D1ACOD        CPACOD
     C                   MOVE      D1ACSQ        CPACSQ
     C                   MOVE      D1NARR        CPNARR
     C                   MOVE      D1VALD        CPVALD
     C                   MOVE      D1STDY        CPSTDY
     C                   MOVE      D1PLMI        CPPLMI
     C                   MOVE      D1CHQC        CPCHQC
     C                   MOVE      D1GROS        CPGROS
     C                   MOVE      D1CUST        CPCUST
     C                   Z-ADD     WURDNB        CPLCD
     C                   MOVE      'A'           CPLCTP
     C                   Z-ADD     *ZEROS        QQACOD                                       CGL029
      *
      ** Store the Cashier Transaction in XXXX format rather than XX-XX
     C                   MOVEL     D1CTRT        WW_CTRTDSP
     C     WW_CTRTD3     IFEQ      '-'
     C                   MOVEL     D1CTRT        WW_CTRTU1
     C                   MOVE      D1CTRT        WW_CTRTU2
     C                   MOVE      WW_CTRTU      CPCTRT
     C                   ELSE
     C                   MOVEL     D1CTRT        CPCTRT
     C                   ENDIF
      *
     C                   UPDATE    SDCTPOD1                             91
     C                   ENDIF
     C                   ENDIF
      *
     C     *IN91         IFEQ      '1'
      *
      ** Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      ** Update saved record image
      *
     C                   MOVEL     @1CCTT        D1EREC
      *
     C                   ENDIF
      *
     C     CHQEXIT       ENDSR
      *
      *****************************************************************
      *                                                               *
      * #IY8TS    - Test Cursor                                       *
      *                                                               *
      * Calls     -                                                   *
      *                                                               *
      * Called by - Sr_Display                                        *
      *                                                               *
      *****************************************************************
     C     #IY8TS        BEGSR
     C                   Z-ADD     @#RWCL        ZINPOS            5 0
     C     ZINPOS        DIV       256           W0CRW
     C                   MVR                     W0CCL
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZASNMS    - Send message to program message queue             *
      *                                                               *
      * Calls                                                         *
      *                                                               *
      * Called by - Sr_Load                                           *
      *           - Sr_Validate                                       *
      *           - Sr_AddRec                                         *
      *           - Sr_DeleteR                                        *
      *           - Sr_Change                                         *
      *                                                               *
      *****************************************************************
     C     ZASNMS        BEGSR
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   ENDIF
      *
      ** If no message file specified, use default
      *
     C     ZAMSGF        IFEQ      *BLANK
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   ENDIF
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C                   PARM                    ZAMSTP            7            Message type
      *
      ** Clear all fields for default mechanism next time
      *
     C                   MOVEL     *BLANK        ZAPGMQ
     C                   MOVEL     *BLANK        ZAPGRL
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSTP
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Sr_Exit   - Exit Program : Normal                             *
      *                                                               *
      * Calls     - Sr_ExitD                                          *
      *                                                               *
      * Called by - MAIN                                              *
      *                                                               *
      *****************************************************************
     C     Sr_Exit       BEGSR
      *
      ** Exit program processing
      *
     C                   MOVEL     *BLANK        P0RTN             7
     C                   EXSR      Sr_ExitD
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Sr_ExitD  - Exit Program : Direct                             *
      *                                                               *
      * Calls     -                                                   *
      *                                                               *
      * Called by - Sr_Exit                                           *
      *           - Sr_Init                                           *
      *                                                               *
      *****************************************************************
     C     Sr_ExitD      BEGSR
      *
      ** ROLLBACK any uncommitted DBF changes
     C                   ROLBK                                          90
      *
      ** Terminate program
     C                   MOVE      *ON           *INLR
      *
      ** Exit program
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * Sr_Init   - Initialisation                                    *
      *                                                               *
      * Calls     - Sr_ExitD                                          *
      *                                                               *
      * Called by - MAIN                                              *
      *                                                               *
      *****************************************************************
     C     Sr_Init       BEGSR
      *
      *
     C     *ENTRY        PLIST
     C                   PARM                    UMODE             1
      *
      ** Set up copyright parameter
     C                   MOVEA     CPY@          CPY2@
      *
      ** Initialize program name
     C                   MOVEL     'SD1245'      DBPGM
      *
      ** Move workstation ID to screen field
     C                   EVAL      ##PGM  = PSProcName
     C                   EVAL      DDUSR  = PsUser
     C                   EVAL      DDWID  = PsJobName
 
      ** Initialisation
     C     W0ICL         IFEQ      *BLANK
     C                   MOVEL     'Y'           W0ICL             1            Initial call
     C                   ELSE
     C                   MOVEL     'N'           W0ICL
     C                   ENDIF
     C                   MOVE      *BLANK        P0RTN
     C                   MOVE      *BLANK        W0RTN             7
     C                   MOVEL     *BLANK        W0RSL             1
     C                   MOVEL     *BLANK        W0RSF             1
      *
      ** Setup job date/time
      *
     C                   Z-ADD     UDATE         ##JDT
     C                   TIME                    ##JTM
      *
      ** Update screen time
      *
     C                   MOVEL     *BLANK        WUDELA            1            Deletion Allowed
     C                   MOVEL     *BLANK        WUAMAL            1            Amend Allowed
     C                   MOVEL     *BLANK        WUSUC             1            Set up Complete
     C                   MOVEL     *BLANK        WUTQKF            1            Test ? Key field
     C                   MOVEL     *BLANK        WUIVKF            1            If value in key fiel
      *
     C                   Z-ADD     *ZERO         WURDNB            5 0          Run day Number
     C                   MOVEL     *BLANK        WUMRDT            7            Midas Run Date
     C                   MOVEL     *BLANK        WUDFF             1            Date Format FLag
     C                   MOVEL     *BLANK        WUMBIN            1            Multi-branching Indi
     C                   MOVE      'N'           YSETCS            1            *SET Cursor
     C                   MOVE      *BLANK        WCSRLC            3
      *
      ** Begin commit control
      *
     C                   CALL      'Y2BGCMC'
     C                   PARM                    W0RTN             7
     C     W0RTN         IFNE      *BLANK
     C     W0RTN         ANDNE     'CPF8351'
     C                   EXSR      Sr_ExitD
     C                   ENDIF
      *
     C                   MOVEL     *BLANKS       W0CFL            10            *Cursor field
     C                   Z-ADD     *ZEROS        W0CRW             5 0          *Cursor row
     C                   Z-ADD     *ZEROS        W0CCL             5 0          *Cursor column
      *
      ** Move main file information to JOB context
     C                   MOVE      @1FFL         ZZFFL            10            Main file
     C                   MOVE      @1FLB         ZZFLB            10            Main file library
     C                   MOVE      @1FMB         ZZFMB            10            Main file mbr
     C                   MOVE      ZZFFL         @1FFL            10
     C                   MOVE      ZZFLB         @1FLB            10
     C                   MOVE      ZZFMB         @1FMB            10
     C                   CALL      'Y2QLVNR'
     C                   PARM                    ZZFFL            10
     C                   PARM                    ZZFLB            10
     C                   PARM                    ZZFQL            21            Library/File
     C                   MOVEL     'N'           W0PMT             1
      *
     C                   Z-ADD     14            ##SFPG            3 0          SFLPAG
     C                   Z-ADD     1             ##SFRC
      *
      ** Maximum record number
     C                   Z-ADD     *ZERO         ##RRMX
      *
      ** Scan limit
     C                   Z-ADD     500           W0SLM             5 0
      *
      ** Subfile pages
     C                   Z-ADD     1             W0SPG             3 0
      *
      ** Processed Subfile record
     C                   Z-ADD     0             W0RR0             4 0
      *
      ** Set to *CHANGE mode
     C                   MOVEL     'CHQ'         W0PMD             3
     C                   MOVEL     *BLANK        W0GRP             1
      *
      ** Initialize program
      ** Get Rundate - Rundate
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          WUMRDT
     C                   MOVE      RDNB          WURDNB                         Runday No.
     C                   MOVE      SUC           WUSUC                          Sse Up Complete
     C                   MOVE      DFF           WUDFF                          Data format flag
     C                   MOVE      MBIN          WUMBIN                         Multi-branching ind
      *
      ** Access Bank Details
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database Error
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Cashier Transaction is display in XX-XX format.
     C                   MOVE      '-'           WW_DASH
      *
     C     KCTPO1        KLIST
     C                   KFLD                    KPBRCA
     C                   KFLD                    KPCTRT
      *
      ** Initialise subfile control
     C                   EXSR      Sr_InitCFld
 
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   SETON                                        U7U8LR
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
**CTDATA TXT
D=Delete   F3=Exit   F5=Refresh   F9=Go to 'Add' Mode
F3=Exit   F5=Refresh   F9=Go to 'Change' Mode
F3=Exit   F5=Refresh
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2002
