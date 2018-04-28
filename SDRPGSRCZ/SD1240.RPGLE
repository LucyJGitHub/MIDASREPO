     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Cashier Commission Codes/Transaction Type')   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD1240 - Cashier Commission Codes/Transaction Types          *
      *                                                               *
      *  Function:  This program allows the user to maintain and      *
      *             enquire Commission Codes/Transaction Types        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
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
      *                 CRT012   *CREATE   Date 21Nov02               *
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
      *   33 - Invalid Commision Code                                 *
      *   34 - Invalid Branch                                         *
      *   35 - Invalid Cashier Transaction                            *
      *   36 - Invalid Midas Account Code                             *
      *   37 - Invalid VAT                                            *
      *   50 - Validation Check                                       *
      *   75 - Enquiry Mode                                           *
      *   78 - Protect key fields                                     *
      *   79 - Protect key fields                                     *
      *   80 - Clear Subfile                                          *
      *   81 - Display subfile                                        *
      *   82 - End of subfile                                         *
      *   83 - Scan for Commission Code                               *
      *   84 - SFLNXTCHG                                              *
      *   85 - Setll SDBACTL1                                         *
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
      ** Cashier Commission Codes / Transaction Types Display File
     FSD1240DF  CF   E             WORKSTN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      *
     FSDBACTL5  IF   E           K DISK
     F                                     INFDS(INFDS1)
     F                                     INFSR(*PSSR)
      ** RTV : Cashier Commission Codes/Transaction Types
      *
      *
     FSDBACTL1  UF A E           K DISK
     F                                     RENAME(SDBACTD0: SDBACTD1)
     F                                     COMMIT
     F                                     INFSR(*PSSR)
      ** RTV : Cashier Commission Codes/Transaction Types
      *
     FSDBACTL3  IF   E           K DISK
     F                                     RENAME(SDBACTD0: SDBACTD3)
     F                                     PREFIX(A_)
      ** RTV : Cashier Commission Codes/Transaction Types
      *
     FSDBACTL4  IF   E           K DISK
     F                                     RENAME(SDBACTD0: SDBACTD4)
     F                                     PREFIX(B_)
      ** RTV : Cashier Commission Codes/Transaction Types
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
 
     D SDNARR        E DS                  EXTNAME(SDNARRPD)
      ** External DS for Narrative Details
 
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D  SDRETLACCD   E                     EXTFLD(QQACCD)                                     CGL029
      ** External DS for Retail ICD Details
 
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
     D @1CCTT        E DS                  EXTNAME(SDBACTL1)
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
     D REC             S              9    DIM(100)
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
     D  WWCOMM         S                   LIKE(D2COMM)
     D  WWBRCH         S                   LIKE(D2BRCH)
     D  WWCTRN         S                   LIKE(D2CTRN)
     D  WWACTN         S                   LIKE(D2ACNT)
     D  WWVAT          S                   LIKE(D2VAT)
     D  WWLCDT         S                   LIKE(D2LCDT)
     D  WWCHTP         S                   LIKE(D2CHTP)
     D  WWNARR         S                   LIKE(D2NARR)
     D  WWSTDY         S                   LIKE(D2STDY)
     D  WWPLMI         S                   LIKE(D2PLMI)
      *
      *
      ** Key Fields
     D  KCCODE         S                   LIKE(CCCODE)
     D  KCCTRT         S                   LIKE(CCCTRT)
     D  KCBRCA         S                   LIKE(CCBRCA)
     D  KCACOD         S                   LIKE(CCACOD)
     D  KCVATF         S                   LIKE(CCVATF)
      *
      ** To format Cashier Transaction to XX-XX
     D                 DS
     D  WW_CTRN                1      5
     D  WW_CTRN1               1      2
     D  WW_DASH                3      3
     D  WW_CTRN2               4      5
      *
     D                 DS
     D  WW_CTRNU               1      4
     D  WW_CTRNU1              1      2
     D  WW_CTRNU2              3      4
      *
     D                 DS
     D  WW_CTRNDSP             1      5
     D  WW_CTRND3              3      3
     D                 DS
     D  WCOMM                  1      2
     D  WCOMM1                 1      1
     D  WCOMM2                 2      2
     D                 DS
     D  WCTRN                  1      5
     D  WCTRN1                 1      1
     D  WCTRN3                 3      3
     D  WCTRN5                 5      5
     D  WCTRN14                1      4
     D  WCTRN25                2      5
      *
     D***WWOLDREC               1     25                                                      CGL029
     D***WWOLDACOD             10     13                                                      CGL029
     D  WWOLDREC               1     35                                                       CGL029
     D  WWOLDACOD             26     35                                                       CGL029
      *
     D  WW_STDY        DS
     D  WW_STDY1               1      1
     D  WW_STDY2               2      2
      *
     D  W_REC          DS
     D  W_BRANCH               1      3
     D  W_CHARGE               4      5
     D  W_CASHTT               6      9
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
     C     W0PMD         IFEQ      'CHG'
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
     C                   MOVE      D2COMM        WWCOMM
     C                   MOVE      D2CTRN        WWCTRN
     C                   MOVE      D2BRCH        WWBRCH
     C                   MOVE      D2ACNT        WWACTN
     C                   MOVE      D2VAT         WWVAT
     C                   Z-ADD     D2LCDT        WWLCDT
     C                   MOVE      D2CHTP        WWCHTP
      *
      ** Set up key
     C                   MOVE      D2COMM        KCCODE
     C                   MOVE      D2CTRN        KCCTRT
     C                   MOVE      D2BRCH        KCBRCA
     C                   MOVE      D2ACNT        KCACOD
      *
     C     KBACT4        SETLL     SDBACTL5                           82
     C  N82              READ      SDBACTL5                             9182
     C                   ELSE
     C                   MOVE      *BLANKS       D2COMM
     C                   MOVE      *BLANKS       D2CTRN
     C                   MOVE      *BLANKS       D2BRCH
     C                   MOVE      *BLANKS       D2ACNT
     C                   MOVE      *OFF          *IN82
     C                   ENDIF
      *
      ** Translate search mask for text field.
      *
      ** Commission Code
     C     *LIKE         DEFINE    D2COMM        WQCOMM
     C                   CALL      'QDCXLATE'
     C                   PARM      2             WQA5N             5 0
     C                   PARM      D2COMM        WQCOMM
     C                   PARM      'QSYSTRNTBL'  WQB10X           10
     C                   PARM      'QSYS'        WQC10X           10
      *
      ** Cashier Transaction
     C     *LIKE         DEFINE    D2CTRN        WQCTRN
     C                   CALL      'QDCXLATE'
     C                   PARM      4             WQA5N
     C                   PARM      D2CTRN        WQCTRN
     C                   PARM      'QSYSTRNTBL'  WQB10X
     C                   PARM      'QSYS'        WQC10X
      *
      ** Branch
     C     *LIKE         DEFINE    D2BRCH        WQBRCH
     C                   CALL      'QDCXLATE'
     C                   PARM      3             WQA5N
     C                   PARM      D2BRCH        WQBRCH
     C                   PARM      'QSYSTRNTBL'  WQB10X
     C                   PARM      'QSYS'        WQC10X
      *
      ** Midas Account Code
     C     *LIKE         DEFINE    D2ACNT        WQACNT
     C                   CALL      'QDCXLATE'
     C                   PARM      4             WQA5N
     C                   PARM      D2ACNT        WQACNT
     C                   PARM      'QSYSTRNTBL'  WQB10X
     C                   PARM      'QSYS'        WQC10X
      *
      ** VAT
     C     *LIKE         DEFINE    D2VAT         WQVAT
     C                   CALL      'QDCXLATE'
     C                   PARM      1             WQA5N
     C                   PARM      D2VAT         WQVAT
     C                   PARM      'QSYSTRNTBL'  WQB10X
     C                   PARM      'QSYS'        WQC10X
      *
      ** Narrative
     C     *LIKE         DEFINE    D2NARR        WQNARR
     C                   CALL      'QDCXLATE'
     C                   PARM      2             WQA5N             5 0
     C                   PARM      D2NARR        WQNARR
     C                   PARM      'QSYSTRNTBL'  WQB10X           10
     C                   PARM      'QSYS'        WQC10X           10
      *
      ** Value Date Comm field
     C     *LIKE         DEFINE    D2STDY        WQSTDY
     C                   CALL      'QDCXLATE'
     C                   PARM      2             WQA5N             5 0
     C                   PARM      D2STDY        WQSTDY
     C                   PARM      'QSYSTRNTBL'  WQB10X           10
     C                   PARM      'QSYS'        WQC10X           10
      *
     C     *LIKE         DEFINE    D2PLMI        WQPLMI
     C                   CALL      'QDCXLATE'
     C                   PARM      1             WQA5N             5 0
     C                   PARM      D2PLMI        WQPLMI
     C                   PARM      'QSYSTRNTBL'  WQB10X           10
     C                   PARM      'QSYS'        WQC10X           10
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
     C                   READP     SDBACTL5                               90
     C                   READ      SDBACTL5                               90
     C                   ENDIF
     C                   ENDIF
      *
      ** Setof record error indicators
     C                   MOVE      *ALL'0'       WKIND0           10
     C                   MOVE      *ALL'1'       WKIND1           10
     C                   MOVE      *ALL'1'       WKIND18           8
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
     C     D2LCDT        IFNE      *ZERO
     C     CCLCD         CABNE     D2LCDT        BB020
     C                   END
     C     D2CHTP        IFNE      *BLANK
     C     CCLCTP        CABNE     D2CHTP        BB020
     C                   END
      *
      ** Scan for search string.
      *
      ** Commission Code
     C     D2COMM        IFNE      *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    CCCODE                         Description
     C                   PARM      2             WQA3N             3 0          Length
     C                   PARM      1             WQB3N             3 0          Start
     C                   PARM                    WQCOMM                         Mask
     C                   PARM      2             WQC3N             3 0          Length
     C                   PARM      '1'           WQD1              1            Translate
     C                   PARM      '1'           WQE1              1            Trim
     C                   PARM      '?'           WQF1              1            Wild
     C                   PARM                    WQG3N             3 0          Result
     C     WQG3N         CABLT     1             BB020
     C                   END
      *
      ** Cashier Transaction
     C     D2CTRN        IFNE      *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    CCCTRT                         Description
     C                   PARM      4             WQA3N                          Length
     C                   PARM      1             WQB3N                          Start
     C                   PARM                    WQCTRN                         Mask
     C                   PARM      4             WQC3N                          Length
     C                   PARM      '1'           WQD1                           Translate
     C                   PARM      '1'           WQE1                           Trim
     C                   PARM      '?'           WQF1                           Wild
     C                   PARM                    WQG3N                          Result
     C     WQG3N         CABLT     1             BB020
     C                   END
      *
      ** Branch
     C     D2BRCH        IFNE      *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    CCBRCA                         Description
     C                   PARM      3             WQA3N                          Length
     C                   PARM      1             WQB3N                          Start
     C                   PARM                    WQBRCH                         Mask
     C                   PARM      3             WQC3N                          Length
     C                   PARM      '1'           WQD1                           Translate
     C                   PARM      '1'           WQE1                           Trim
     C                   PARM      '?'           WQF1                           Wild
     C                   PARM                    WQG3N                          Result
     C     WQG3N         CABLT     1             BB020
     C                   END
      *
      ** Midas Account Code
     C     D2ACNT        IFNE      *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    CCACOD                         Description
     C                   PARM      4             WQA3N                          Length
     C                   PARM      1             WQB3N                          Start
     C                   PARM                    WQACNT                         Mask
     C                   PARM      4             WQC3N                          Length
     C                   PARM      '1'           WQD1                           Translate
     C                   PARM      '1'           WQE1                           Trim
     C                   PARM      '?'           WQF1                           Wild
     C                   PARM                    WQG3N                          Result
     C     WQG3N         CABLT     1             BB020
     C                   END
      *
      ** VAT
     C     D2VAT         IFNE      *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    CCVATF                         Description
     C                   PARM      1             WQA3N                          Length
     C                   PARM      1             WQB3N                          Start
     C                   PARM                    WQVAT                          Mask
     C                   PARM      1             WQC3N                          Length
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
     C                   PARM                    CCNARR                         Description
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
      ** Value Date for Commission
     C     D2STDY        IFNE      *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    CCSTDY                         Description
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
     C     D2PLMI        IFNE      *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    CCPLMI                         Description
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
     C                   MOVEA     WKIND0        *IN(31)
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
     C                   READ      SDBACTL5                               82
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
     C     WWCOMM        CASNE     D2COMM        Sr_ReLoad
     C     WWBRCH        CASNE     D2BRCH        Sr_ReLoad
     C     WWCTRN        CASNE     D2CTRN        Sr_ReLoad
     C     WWACTN        CASNE     D2ACNT        Sr_ReLoad
     C     WWVAT         CASNE     D2VAT         Sr_ReLoad
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
     C     WWCOMM        CASNE     D2COMM        Sr_ReLoad
     C     WWBRCH        CASNE     D2BRCH        Sr_ReLoad
     C     WWCTRN        CASNE     D2CTRN        Sr_ReLoad
     C     WWACTN        CASNE     D2ACNT        Sr_ReLoad
     C     WWVAT         CASNE     D2VAT         Sr_ReLoad
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
     C                   MOVEA     WKIND0        *IN(31)
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
     C     D1COMM        IFEQ      *BLANK
     C     D1BRCH        ANDEQ     *BLANK
     C     D1CTRN        ANDEQ     *BLANK
     C     D1ACNT        ANDEQ     *BLANK
     C     D1VAT         ANDEQ     *BLANK
     C     D1NARR        ANDEQ     *BLANK
     C     D1STDY        ANDEQ     *BLANK
     C     D1PLMI        ANDEQ     *BLANK
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
      ** Program mode is *ADD
      * Ensure details entered for Branch/Charge/Com Code do not exist on SDBACATPD
     C     W0PMD         IFEQ      'ADD'
      *
     C                   MOVEL     D1BRCH        KBRANCH
     C                   MOVEL     D1COMM        KCHARGE
     C                   MOVEL     D1CTRN        WW_CTRNDSP
     C     WW_CTRND3     IFEQ      '-'
     C                   MOVEL     D1CTRN        WW_CTRNU1
     C                   MOVE      D1CTRN        WW_CTRNU2
     C                   MOVE      WW_CTRNU      KCASHTT
     C                   ELSE
     C                   MOVEL     D1CTRN        KCASHTT
     C                   ENDIF
      *
      *
     C     KBACT3        CHAIN     SDBACTL4                           90
     C     *IN90         IFEQ      *OFF
     C                   MOVEA     WKIND18       *IN(33)
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR9753'     W0RTN
     C                   MOVEL     'USR9753'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      ENDVAL
      *
      * Else check record array to see if record for Branch/Charge/Com Code
      * is already on subfile.
     C                   ELSE
     C                   MOVEL     D1BRCH        W_BRANCH
     C                   MOVEL     D1COMM        W_CHARGE
     C                   MOVEL     KCASHTT       W_CASHTT
     C     W_REC         LOOKUP    REC                                    90
     C     *IN90         IFEQ      *ON
     C                   MOVEA     WKIND18       *IN(33)
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR9753'     W0RTN
     C                   MOVEL     'USR9753'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      ENDVAL
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Commission Code
      *
     C     D1COMM        IFNE      *BLANKS
      *
     C                   MOVEL     *BLANK        W0RTN
      ** Test ? in Key Field is Question Mark
     C     D1COMM        IFEQ      '? '
     C     D1COMM        OREQ      ' ?'
     C                   MOVEL     '?INVAL'      W0RTN
      ** Send message 'Question Mark Invalid'
     C                   MOVEL     'USR0382'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN98
     C                   MOVE      *ON           *IN33
     C                   ELSE
      *
      * Commission code should be 2A, if only one character entered - error
     C                   MOVE      D1COMM        WCOMM
     C     WCOMM1        IFEQ      ' '
     C     WCOMM2        OREQ      ' '
     C                   MOVE      *ON           *IN33
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR9601'     W0RTN
     C                   MOVE      'USR9601'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C
     C                   ENDIF
      *
     C*****              ELSE
      ** Commission Code: Mandatory
      *
     C*****D1BRCH        IFNE      *BLANKS
     C*****D1CTRN        ORNE      *BLANKS
     C*****D1ACNT        ORNE      *BLANKS
     C*****D1VAT         ORNE      *BLANKS
     C*****              MOVE      *ON           *IN33
     C*****              MOVE      *ON           *IN50
     C*****              MOVEL     'USR0183'     W0RTN
     C*****              MOVE      'USR0183'     ZAMSID
     C*****              EXSR      ZASNMS
     C*****              ENDIF
      *
     C                   ENDIF
      *
      ** Cashier Transaction: Optional
     C     D1CTRN        IFNE      *BLANKS
      *
     C                   MOVEL     D1CTRN        WUTQKF
     C                   MOVEL     *BLANK        W0RTN
      ** Test ? in Key Field is Question Mark
     C     WUTQKF        IFEQ      '?'
     C                   MOVEL     '?INVAL'      W0RTN
      ** Send message 'Question Mark Invalid'
     C                   MOVEL     'USR0382'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN98
     C                   MOVE      *ON           *IN34
     C                   MOVE      *ON           *IN50
     C                   ENDIF
      *
      * Transaction Code must be in format XXXX or XX-XX.
     C                   MOVE      D1CTRN        WCTRN
     C                   MOVEA     D1CTRN        TRN
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
     C     WCTRN3        ANDNE     '-'
     C                   MOVEL     'USR9602'     W0RTN
     C                   MOVEL     'USR9602'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN98
     C                   MOVE      *ON           *IN34
     C                   MOVE      *ON           *IN50
      *
     C                   ELSE
     C     WCTRN1        IFEQ      ' '
     C                   MOVE      WCTRN25       SaveWCTRN         4
     C                   MOVE      SaveWCTRN     WCTRN14
     C                   MOVE      ' '           WCTRN5
     C                   MOVE      WCTRN         D1CTRN
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Branch: Optional
     C     D1BRCH        IFNE      *BLANKS
      *
      ** Call access programme to determine whether Branch Code
      *  entered is valid.
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      D1BRCH        @DSNB             3
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      A8BRCD        D1BRCH
     C                   ELSE
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN98
     C                   MOVE      *ON           *IN35
     C                   MOVEL     'USR0075'     W0RTN
     C                   MOVEL     'USR0075'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *
      *
      ** VAT: Optional (Y/N)
     C     D1VAT         IFEQ      *BLANKS
     C                   MOVE      'N'           D1VAT
     C                   ENDIF
      *
     C     D1COMM        IFNE      *BLANKS
     C     D1COMM        ANDNE     '? '
     C     D1COMM        ANDNE     ' ?'
     C     D1VAT         IFNE      'Y'
     C     D1VAT         ANDNE     'N'
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN98
     C                   MOVE      *ON           *IN37
     C                   MOVEL     'USR0805'     W0RTN
     C                   MOVEL     'USR0805'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *
      * If Commission code is blank then VAT must be 'N'
     C     D1COMM        IFEQ      *BLANKS
     C     D1VAT         ANDEQ     'Y'
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN98
     C                   MOVE      *ON           *IN37
     C                   MOVEL     'USR9758'     W0RTN
     C                   MOVEL     'USR9758'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validate Account Code
     C                   EXSR      Sr_ValidAcC
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
     C                   MOVE      *ON           *IN38
     C                   MOVEL     'USR9742'     W0RTN
     C                   MOVEL     'USR9742'     ZAMSID
     C                   EXSR      ZASNMS
      *
     C                   ENDIF
     C                   ENDIF
      *
      * Value date for commission if entered must be 01-99
      * and a + of - must be entered.
B1   C     D1STDY        IFNE      *BLANKS
     C     D1PLMI        ORNE      *BLANKS
      *
      * If commission code has been entered then record is for
      * internal posting of that commission so no value may be entered
      * in value date field.
     C     D1COMM        IFNE      *BLANKS
     C                   MOVE      *ON           *IN39
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR9756'     W0RTN
     C                   MOVEL     'USR9756'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C*
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
     C                   MOVEL     'USR9752'     W0RTN
     C                   MOVEL     'USR9752'     ZAMSID
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
     C                   ENDIF
E1   C                   ENDIF
      *
      * If valid, write to record arrays
     C     *IN50         IFEQ      *OFF
     C                   ADD       1             Y
     C                   MOVEL     D1BRCH        W_BRANCH
     C                   MOVEL     D1COMM        W_CHARGE
     C                   MOVEL     D1CTRN        WW_CTRNDSP
     C     WW_CTRND3     IFEQ      '-'
     C                   MOVEL     D1CTRN        WW_CTRNU1
     C                   MOVE      D1CTRN        WW_CTRNU2
     C                   MOVE      WW_CTRNU      KCASHTT
     C                   ELSE
     C                   MOVEL     D1CTRN        KCASHTT
     C                   ENDIF
      *
     C                   MOVEL     W_REC         REC(Y)
     C                   ENDIF
      *
     C     ENDVAL        TAG
      *
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
      ** Midas Account Code: Mandatory if VAT = N and Commission code
      ** entered.
     C     D1ACNT        IFEQ      *BLANKS
     C     D1VAT         ANDEQ     'N'
     C     D1COMM        ANDNE     '  '
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN98
     C                   MOVE      *ON           *IN36
     C                   MOVEL     'USR0183'     W0RTN
     C                   MOVEL     'USR0183'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C     D1ACNT        IFNE      *BLANKS
      *
      ** Entry is prohibited if VAT = Y or Commission code is blank
     C     D1VAT         IFEQ      'Y'
     C     D1COMM        OREQ      '  '
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN98
     C                   MOVE      *ON           *IN36
     C     D1VAT         IFEQ      'Y'
     C                   MOVEL     'USR0264'     W0RTN
     C                   MOVEL     'USR0264'     ZAMSID
     C                   ELSE
     C                   MOVEL     'USR9757'     W0RTN
     C                   MOVEL     'USR9757'     ZAMSID
     C                   ENDIF
     C                   EXSR      ZASNMS
     C                   ELSE
      *
     C                   CALL      'AOACODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C**********         PARM      D1ACNT        @ACOD             4                          CGL029
     C                   PARM      D1ACNT        @ACOD            10                          CGL029
     C*****SDACOD        PARM      SDACOD        DSFDY                                        CGL029
     C     SDACOD        PARM      SDACOD        DSSDY                                        CGL029
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN98
     C                   MOVE      *ON           *IN36
     C                   MOVEL     'USR0173'     W0RTN
     C                   MOVEL     'USR0173'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
      *
     C                   MOVE      A5ACCD        D1ACNT
      *
      ** It must be Account Section Type 'IN and non-Title A/C code.
     C     A5ACSC        IFNE      'IN'
     C     A5TOIN        ORNE      'N'
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN98
     C                   MOVE      *ON           *IN36
     C                   MOVEL     'USR0183'     W0RTN
     C                   MOVEL     'USR0183'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
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
     C                   MOVEA     WKIND0        *IN(31)
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
     C                   MOVEL     'CHG'         W0PMD
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
     C                   MOVEL     *BLANK        D1COMM
     C                   MOVEL     *BLANK        D1BRCH
     C                   MOVEL     *BLANK        D1CTRN
     C                   MOVEL     *BLANK        D1ACNT
     C                   MOVEL     *BLANK        D1VAT
     C                   Z-ADD     *ZERO         D1LCDT
     C                   MOVEL     *BLANK        D1CHTP
     C                   MOVEL     *BLANK        D1SELC
     C                   MOVEL     *BLANK        D1EREC
     C                   MOVEL     *BLANK        D1NARR
     C                   MOVEL     *BLANK        D1STDY
     C                   MOVEL     *BLANK        D1PLMI
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
     C                   MOVEL     CCCODE        D1COMM
     C                   MOVEL     CCBRCA        D1BRCH
     C                   MOVEL     CCVATF        D1VAT
     C                   Z-ADD     CCLCD         D1LCDT
     C                   MOVEL     CCLCTP        D1CHTP
     C                   MOVEL     CCNARR        D1NARR
     C                   MOVEL     CCSTDY        D1STDY
     C                   MOVEL     CCPLMI        D1PLMI
      *
      ** Display the Cashier Transaction in XX-XX format
     C     CCCTRT        IFNE      *BLANKS
     C                   MOVEL     CCCTRT        WW_CTRN1
     C                   MOVE      CCCTRT        WW_CTRN2
     C                   MOVEL     WW_CTRN       D1CTRN
     C                   ELSE
     C                   MOVE      *BLANKS       D1CTRN
     C                   ENDIF
      *
     C     CCACOD        IFEQ      *ZEROS
     C                   MOVE      *BLANKS       D1ACNT
     C                   ELSE
     C                   MOVEL     CCACOD        D1ACNT
     C                   ENDIF
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
     C                   MOVEL     *BLANK        D2COMM
     C                   MOVEL     *BLANK        D2CTRN
     C                   MOVEL     *BLANK        D2BRCH
     C                   MOVEL     *BLANK        D2ACNT
     C                   MOVEL     *BLANK        D2VAT
     C                   MOVEL     *BLANK        D2CHTP
     C                   Z-ADD     *ZERO         D2LCDT
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
     C                   MOVE      D1COMM        KCCODE
     C                   MOVE      D1BRCH        KCBRCA
     C                   MOVE      D1ACNT        KCACOD
     C                   MOVE      D1VAT         KCVATF
      *
     C                   MOVEL     D1CTRN        WW_CTRNDSP
     C     WW_CTRND3     IFEQ      '-'
     C                   MOVEL     D1CTRN        WW_CTRNU1
     C                   MOVE      D1CTRN        WW_CTRNU2
     C                   MOVE      WW_CTRNU      KCCTRT
     C                   ELSE
     C                   MOVE      D1CTRN        KCCTRT
     C                   ENDIF
      *
      *
     C     KBACT5        SETLL     SDBACTD1                               83
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
      ** Move all fields to SDBACTL1
     C                   MOVE      D1COMM        CCCODE
     C                   MOVE      D1BRCH        CCBRCA
     C                   MOVE      D1ACNT        CCACOD
     C                   MOVE      D1VAT         CCVATF
     C                   Z-ADD     WURDNB        CCLCD
     C                   MOVE      D1NARR        CCNARR
     C                   MOVE      D1STDY        CCSTDY
     C                   MOVEL     D1PLMI        CCPLMI
     C                   MOVE      'I'           CCLCTP
     C                   Z-ADD     *ZEROS        QQACOD                                       CGL029
      *
      ** Store the Cashier Transaction in xxxx format rather than xx-xx
     C                   MOVEL     D1CTRN        WW_CTRNDSP
     C     WW_CTRND3     IFEQ      '-'
     C                   MOVEL     D1CTRN        WW_CTRNU1
     C                   MOVE      D1CTRN        WW_CTRNU2
     C                   MOVE      WW_CTRNU      CCCTRT
     C                   ELSE
     C                   MOVEL     D1CTRN        CCCTRT
     C                   ENDIF
      *
      *
     C                   WRITE     SDBACTD1                             91
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
     C                   MOVE      D1COMM        KCCODE
     C                   MOVE      D1BRCH        KCBRCA
     C                   MOVE      D1ACNT        KCACOD
     C                   MOVE      D1VAT         KCVATF
      *
     C                   MOVEL     D1CTRN        WW_CTRNDSP
     C     WW_CTRND3     IFEQ      '-'
     C                   MOVEL     D1CTRN        WW_CTRNU1
     C                   MOVE      D1CTRN        WW_CTRNU2
     C                   MOVE      WW_CTRNU      KCCTRT
     C                   ELSE
     C                   MOVE      D1CTRN        KCCTRT
     C                   ENDIF
      *
      *
     C     KBACT5        CHAIN     SDBACTD1                           9091
     C     *IN90         IFEQ      *ON
      *
      ** Record already deleted
     C                   MOVEA     WKIND1        *IN(31)
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
     C                   MOVEA     WKIND1        *IN(31)
     C                   MOVEL     'USR7538'     W0RTN             7
      *
      ** Send message '*Update not accepted'
     C                   MOVEL     'USR7538'     ZAMSID
     C                   EXSR      ZASNMS
      *
      ** Use SETLL to release record lock
      *
     C     KBACT5        SETLL     SDBACTD1                           9091
     C                   ELSE
      *
     C                   DELETE    SDBACTD1
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
      ** Move key fields to SDBACTL1
      *
     C                   MOVE      D1COMM        KCCODE
     C                   MOVE      D1BRCH        KCBRCA
     C                   MOVE      D1EREC        WWOLDREC
     C                   MOVE      WWOLDACOD     KCACOD
     C                   MOVE      D1VAT         KCVATF
      *
     C                   MOVEL     D1CTRN        WW_CTRNDSP
     C     WW_CTRND3     IFEQ      '-'
     C                   MOVEL     D1CTRN        WW_CTRNU1
     C                   MOVE      D1CTRN        WW_CTRNU2
     C                   MOVE      WW_CTRNU      KCCTRT
     C                   ELSE
     C                   MOVE      D1CTRN        KCCTRT
     C                   ENDIF
      *
      *
     C     KBACT5        CHAIN     SDBACTD1                           9091
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
     C                   MOVEA     WKIND1        *IN(31)
     C                   MOVEL     'USR7538'     W0RTN             7
      *
      ** Send message '*Update not accepted'
     C                   MOVEL     'USR7538'     ZAMSID
     C                   EXSR      ZASNMS
      *
      * Release record lock
     C                   UNLOCK    SDBACTL1                             91
     C                   GOTO      CHGEXIT
     C                   ELSE
      *
      ** Validate Account Code field
     C                   EXSR      Sr_ValidateA
      *
     C     *IN50         IFEQ      *OFF
      *
      ** Move non-key fields to SDBACTL1
     C                   MOVE      D1COMM        CCCODE
     C                   MOVE      D1BRCH        CCBRCA
     C                   MOVE      D1ACNT        CCACOD
     C                   MOVE      D1VAT         CCVATF
     C                   MOVEL     D1NARR        CCNARR
     C                   MOVE      D1STDY        CCSTDY
     C                   MOVE      D1PLMI        CCPLMI
     C                   MOVEL     'A'           CCLCTP
     C                   Z-ADD     WURDNB        CCLCD
     C                   Z-ADD     *ZEROS        QQACOD                                       CGL029
      *
      ** Store the Cashier Transaction in XXXX format rather than XX-XX
     C                   MOVEL     D1CTRN        WW_CTRNDSP
     C     WW_CTRND3     IFEQ      '-'
     C                   MOVEL     D1CTRN        WW_CTRNU1
     C                   MOVE      D1CTRN        WW_CTRNU2
     C                   MOVE      WW_CTRNU      CCCTRT
     C                   ELSE
     C                   MOVEL     D1CTRN        CCCTRT
     C                   ENDIF
      *
     C                   UPDATE    SDBACTD1                             91
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
     C     CHGEXIT       ENDSR
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
     C                   MOVEL     'SD1240'      DBPGM
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
     C                   MOVEL     'CHG'         W0PMD             3
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
     C     KBACT2        KLIST
     C                   KFLD                    KCTRT             4
     C                   KFLD                    KBRCA             3
      *
     C     KBACT3        KLIST
     C                   KFLD                    KBRANCH           3
     C                   KFLD                    KCHARGE           2
     C                   KFLD                    KCASHTT           4
      *
     C     KBACT4        KLIST
     C                   KFLD                    KCBRCA
     C                   KFLD                    KCCTRT
     C                   KFLD                    KCACOD
      *
     C     KBACT5        KLIST
     C                   KFLD                    KCCODE
     C                   KFLD                    KCCTRT
     C                   KFLD                    KCBRCA
     C                   KFLD                    KCACOD
     C                   KFLD                    KCVATF
 
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
