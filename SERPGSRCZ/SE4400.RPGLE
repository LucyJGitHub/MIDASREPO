     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*XBIA*: OVRDBF FILE(MESSAGES11) TOFILE(MEML11PD)                     *
/*XBIB*: OVRDBF FILE(SETRANPDX) TOFILE(SETRANPD)                      *
/*STD *  RPGBASEBND                                                   *
/*EXI *  ALWNULL(*USRCTL)                                             *
/*EXI *  TEXT('Midas SE Securities movements enquiry')                *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Module                                    *
      *                                                               *
      *  SE4400 - Securities Movements Enquiry                        *
      *                                                               *
      *  Function:  This program allows the user to select and        *
      *             enquire on Transactions and then can see the      *
      *             Swift messages associated with that transaction   *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027A            Date 17May06               *
      *                 CSE071             Date 19Jul05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3122            Date 17Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 TDA035             Date 02Apr04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CSE039   *CREATE   Date 21Jan03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027A - Conversion of cust. no. to alpha (post 103 build)  *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CSE039 - Auto-settle of trades                               *
      *                                                               *
      *****************************************************************
      *  Subroutine Index                                             *
      *                                                               *
      *  Sr_Create_File - Write records to new file SETRANPD          *
      *  Sr_Create_FileL - Write records to new file SETRANPD (Linked)*
      *  Sr_Load     - Initialise and load subfile                    *
      *  Sr_Build    - Load subfile page                              *
      *  Sr_Display  - Display screen                                 *
      *  Sr_ScreenIn - Process screen input                           *
      *  Sr_Modified - Process modified subfile record                *
      *  Sr_ProcRec  - Process subfile record                         *
      *  Sr_ReLoad   - Request subfile reload                         *
      *  Sr_ResetFld - Initialise and reset all the Subfile fields    *
      *  Sr_LoadFld  - Load the subfile fields                        *
      *  #IY8TS - Test cursor                                         *
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
      *   27 - Next Page                                              *
      *   32 - Invalid Subfile Selection                              *
      *   33 - Invalid Trade/DVP No                                   *
      *   34 - Invalid WI/WO No.                                      *
      *   35 - Invalid Front Office ID                                *
      *   36 - Invalid Trade Date From                                *
      *   37 - Invalid Trade Date To                                  *
      *   38 - Invalid Status                                         *
      *   39 - Invalid Counterparty                                   *
      *   40 - Invalid Custodian                                      *
      *   41 - Invalid Customer                                       *
      *   42 - Invalid Security                                       *
      *   43 - Invalid Branch                                         *
      *   44 - Invalid Nominal                                        *
      *   45 - Invalid Countervalue and CCY                           *
      *   46 - Invalid Order No                                       *
      *   50 - Validation Check                                       *
      *   60 - E of F                                                 *
      *   60 - CHAIN to MESSAGES11                                    *
      *   61 - READE ON SEMVTSPD                                      *
      *   70 - If On the Linked Trade sub file is being displayed     *
      *   71 - If On the Linked Trade sub file with Order Number      *
      *   72 - If On the Linked Trade sub file with Bulk Ref          *
      *   73 - Linked Trade sub file has actually been displayed      *
      *   75 - Trade record being displayed has been deleted          *
      *   76 - Trade record being displayed is on Invalid file        *
      *   80 - Clear Subfile                                          *
      *   81 - Display subfile                                        *
      *   82 - End of subfile                                         *
      *   83 - Scan for Commission Code                               *
      *   84 - SFLNXTCHG                                              *
      *   86 - PUTOVER                                                *
      *   87 - Enable key screen                                      *
      *   88 - Protect key fields                                     *
      *   89 - CHAIN TO SECTY                                         *
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
      ** Transaction Messages Display File
     FSE4400DF  CF   E             WORKSTN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     SFILE(#SFLRCD2:##RR)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      *
     FTRADSDLA  IF   E           K DISK
     F                                     INFSR(*PSSR)
      ** RTV : Midas SE  Trades keyed on Trade Date
     FTRADSDLB  IF   E           K DISK
     F                                     INFSR(*PSSR)
     F                                     RENAME(TRADSDF: TRADSDFB)
      ** RTV : Midas SE  Trades keyed on Security and Order Number
     FTRADSDLC  IF   E           K DISK
     F                                     INFSR(*PSSR)
     F                                     RENAME(TRADSDF: TRADSDFC)
      ** RTV : Midas SE  Trades keyed on Security and Bulk Reference
     FTRADS     IF   E           K DISK
     F                                     INFSR(*PSSR)
     F                                     RENAME(TRADSDF: TRADSDF1)
     FSETRADL0  IF   E           K DISK
     F                                     INFSR(*PSSR)
     F                                     RENAME(TRADSDF: TRADSDFL0)
      ** RTV : Midas SE  Trades keyed on Front Office ID
     FDPTMVDL2  IF   E           K DISK
     F                                     INFSR(*PSSR)
      ** RTV : Midas SE Walk Ins/Walk outs keyed on Trade Date
     FDPTMVDL1  IF   E           K DISK
     F                                     INFSR(*PSSR)
     F                                     RENAME(DPTMVDF: DPTMVDF1)
      ** RTV : Midas SE Walk Ins/Walk Outs keyed on Trade Date
     FSEDPMVL0  IF   E           K DISK
     F                                     INFSR(*PSSR)
     F                                     RENAME(DPTMVDF: DPTMVDFL0)
      ** RTV : Midas SE Walk Ins/Walk Outs keyed on Front Office ID
     FSEDVPRL0  IF   E           K DISK
     F                                     INFSR(*PSSR)
      ** RTV : Midas SE DVP/RVPs keyed on Ref
     FSEDVPRL1  IF   E           K DISK
     F                                     INFSR(*PSSR)
     F                                     RENAME(SEDVPRD0: SEDVPRD1)
      ** RTV : Midas SE DVP/RVP keyed on value date
     FSEDVPRL4  IF   E           K DISK
     F                                     INFSR(*PSSR)
     F                                     RENAME(SEDVPRD0: SEDVPRD4)
      ** RTV : Midas SE DVP/RVPs keyed on Front Office ID
     FSEITRADL0 IF   E           K DISK
     F                                     INFSR(*PSSR)
      ** RTV : Midas SE Invalid Trades
     FSEIDPMVL0 IF   E           K DISK
     F                                     INFSR(*PSSR)
      ** RTV : Midas SE Invalid Walk Ins/Walk outs.
     FSEMVTSL7  IF   E           K DISK
     F                                     INFSR(*PSSR)
      ** RTV : Midas SE Movement Status
     FSECTY     IF   E           K DISK
     F                                     INFSR(*PSSR)
      ** RTV : Midas SE Securities file
     FMESSAGES11IF   E           K DISK
     F                                     INFSR(*PSSR)
      ** RTV : Midas MM Messages file
     FSETRANPDX UF A E           K DISK    USROPN
     F                                     INFSR(*PSSR)
      ** RTV : Midas SE Transactions file
      *
     FSECOND    IF   E           K DISK
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
 
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      ** External DS for Security ICD
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** Branch Details
 
     D SDACOD        E DS                  EXTNAME(SDACODPD)
      ** External data structure for account code file
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D  QQDFA1       E                     EXTFLD(QQDFAC)                                     CGL029
      ** External data structure for customer file
 
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
     D  QQACC1       E                     EXTFLD(QQACCD)                                     CGL029
      ** External data structure for security customer file
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS for Currency Details
 
     D USER          E DS                  EXTNAME(MUSERDD)
      ** External DS for User Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access Programs, Long Data Structure
      *
      ** Display file information data structure
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      *
      ** File information data structure
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      *
      *****************************************************************
     D** Link enquiry data area
     DSESDS          E DS
      *
      ** Data structure for rundat
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
      *
     D KMESSAGE        DS            50
     D  KMESSAGE3              1      3
     D  KMESSAGE9              4      9
     D  KMESSAGE1_9            1      9
     D  KMESSAGE16            10     16
      *
     D KMESSAGEB       DS            50
     D  KMESSAGEB1_9           1      9
      *
     D TFRID           DS
     D  TFRID16                1     16
      *
     D SELECTALL       DS
     D  D2TRAD
     D  D2WIWO
     D  D2FRID
     D  D2TRDTF
     D  D2TRDTT
     D  D2STAT
     D  D2CTPY
     D  D2CUST
     D  D2CUSN
     D  D2SETY
     D  D2SETY1112            90     91
     D  D2BRCH
     D  D2NOML
     D  D2CCCY
     D  D2CTVL
     D  D2ORDE
     D  SELECT1                1     32
     D  SELECT2               33    124
      *
     D TXT             S             78    DIM(3) CTDATA PERRCD(1)
      *
     D TRN             S              1    DIM(5) CTDATA PERRCD(1)
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
     D  WWTRAD         S                   LIKE(D2TRAD)
     D  WWWIWO         S                   LIKE(D2WIWO)
     D  WWFRID         S                   LIKE(D2FRID)
     D  WWSTAT         S                   LIKE(D2STAT)
     D  WWBRCH         S                   LIKE(D2BRCH)
     D  WWCTPY         S                   LIKE(D2CTPY)
     D  WWCUST         S                   LIKE(D2CUST)
     D  WWORDE         S                   LIKE(D2ORDE)
     D  WWSETY         S                   LIKE(D2SETY)
     D  WWNOML         S                   LIKE(D2NOML)
     D  WWTRDTF        S                   LIKE(D2TRDTF)
     D  WWTRDTT        S                   LIKE(D2TRDTT)
     D  WWCUSN         S                   LIKE(D2CUSN)
     D  WWCTVL         S                   LIKE(D2CTVL)
     D  WWCCCY         S                   LIKE(D2CCCY)
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
     ITRADSDF
     I              RECI                        Trad_RECI
     ITRADSDF1
     I              RECI                        Trad_RECI
     ITRADSDFB
     I              RECI                        Trad_RECIB
     ITRADSDFC
     I              RECI                        Trad_RECIC
     ITRADSDFL0
     I              RECI                        Trad_RECI
     IDPTMVDF
     I              RECI                        WIWO_RECI
     IDPTMVDFL0
     I              RECI                        WIWO_RECI
 
      *****************************************************************
      /EJECT
      ***** ***********************************************************
      ** Initialize
      *
     C                   EXSR      Sr_Init
      *
      *
      ** Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      *
     C                   WRITE     #MSGCTL
     C                   MOVEA     TXT(1)        ##CTX1
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #SFLCTL
     C                   MOVE      *OFF          *IN73
      *
     C                   DO        *HIVAL
 
      * Display select fields and Validate selection entries
      * Do not do this if Sub file for Linked trades is being built
     C     *IN70         IFEQ      *OFF
     C                   EXSR      SR_Val_Select
     C                   ENDIF
      *
      * Build file with all details from Trade, DVP/RVP and Depot movements
      * files and their respective Invalid repair files.
      * Only if the Trade Date From or Trade Date To have changed.
     C     D2TRDTF       IFNE      WWTRDTF
     C     D2TRDTT       ORNE      WWTRDTT
     C     D2TRAD        ORNE      WWTRAD
     C     D2WIWO        ORNE      WWWIWO
     C     D2FRID        ORNE      WWFRID
     C     *IN70         ORNE      WWIN70
     C                   CALL      'SEC4401'
     C                   OPEN      SETRANPDX
      *
      * Which sub routine to call depends up whether the subfile
      * for Linked trades or the normal sub file is to be built
     C     *IN70         IFEQ      *OFF
     C                   EXSR      Sr_Create_File
     C                   ELSE
     C                   EXSR      Sr_CreateFileL
     C                   ENDIF
      *
     C                   CLOSE     SETRANPDX
     C                   ENDIF
      *
      ** Initialise and load subfile page
     C                   OPEN      SETRANPDX
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
     C     F3END         TAG
     C                   SELECT
     C     *IN03         WHENEQ    *ON
     C                   EXSR      SR_Exit
      *
      * If F12 taken from Linked Trade sub file screen then ensure
      * main subfile is displayed again.
     C     *IN70         WHENEQ    *ON
     C     *IN12         ANDEQ     *ON
     C                   MOVE      'Y'           W0RSF
     C                   MOVE      *OFF          *IN70
     C                   MOVE      *OFF          *IN71
     C                   MOVE      *OFF          *IN72
      *
      ** Display next SFL page
      *
     C     *IN27         WHENEQ    *ON
     C                   EXSR      Sr_Build
      *
      ** Process screen input
      *
     C                   OTHER
     C                   EXSR      Sr_ScreenIn
     C                   ENDSL
      *
     C                   ENDDO
      *
     C                   CLOSE     SETRANPDX
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
     C     *IN70         IFEQ      *OFF
     C                   MOVEA     TXT(2)        ##CTX1
     C                   ELSE
     C                   MOVEA     TXT(3)        ##CTX1
     C                   ENDIF
      *
      ** Clear subfile
     C                   MOVE      *ON           *IN80
     C     *IN70         IFEQ      *OFF
     C                   WRITE     #SFLCTL
     C                   ELSE
     C                   WRITE     #SFLCTL2
     C                   ENDIF
     C                   MOVE      *OFF          *IN80
      *
      ** Reset no of records in subfile
     C                   Z-ADD     *ZERO         ##RRMX            5 081        Setof 81
      *
     C                   MOVE      D2TRAD        WWTRAD
     C                   MOVE      D2WIWO        WWWIWO
     C                   MOVE      D2FRID        WWFRID
     C                   MOVE      D2STAT        WWSTAT
     C                   MOVE      D2BRCH        WWBRCH
     C                   MOVE      D2CTPY        WWCTPY
     C                   MOVE      D2CUST        WWCUST
     C                   MOVE      D2ORDE        WWORDE
     C                   MOVE      D2SETY        WWSETY
     C                   MOVE      D2NOML        WWNOML
     C                   MOVE      D2TRDTF       WWTRDTF
     C                   MOVE      D2TRDTT       WWTRDTT
     C                   MOVE      D2CUSN        WWCUSN
     C                   MOVE      D2CTVL        WWCTVL
     C                   MOVE      D2CCCY        WWCCCY
     C                   MOVE      *IN70         WWIN70            1
      *
     C     *LOVAL        SETLL     SETRANPDX
     C                   READ      SETRANPDX                            9182
      *
      ** Load subfile page
     C                   EXSR      Sr_Build
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * Sr_Build  - Load Subfile Page                                 *
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
     C     *IN82         IFEQ      *OFF
     C                   READP     SETRANPDX                              90
     C                   READ      SETRANPDX                              90
     C                   ENDIF
     C                   ENDIF
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
      * If displaying Linked Trades subfile then want to
      * show every record currently on SETRANPD otherwise
     C     *IN70         IFEQ      *ON
     C                   GOTO      Tag_SkipScan
     C                   ENDIF
      *
      ** Scan for search string.
      *
      ** Trade/DVP Ref
     C     D2TRAD        IFNE      *BLANK
     C                   Z-ADD     0             W#NUM6            6 0
     C                   MOVEL     D2TRAD        W#NUM6
     C     TTRNO         IFNE      W#NUM6
     C                   GOTO      BB020
     C                   ENDIF
     C                   ENDIF
      *
      ** WI/WO Ref
     C     D2WIWO        IFNE      *BLANK
     C                   Z-ADD     0             W#NUM6
     C                   MOVEL     D2WIWO        W#NUM6
     C     TWIWO         IFNE      W#NUM6
     C                   GOTO      BB020
     C                   ENDIF
     C                   ENDIF
      *
      ** FO ID
     C     D2FRID        IFNE      *BLANK
     C     TFRID         IFNE      D2FRID
     C                   GOTO      BB020
     C                   ENDIF
     C                   ENDIF
      *
      ** Status
     C     D2STAT        IFNE      *BLANK
     C     TSTAT         IFNE      D2STAT
     C                   GOTO      BB020
     C                   ENDIF
     C                   ENDIF
      *
      ** Branch
     C     D2BRCH        IFNE      *BLANK
     C     TBRCH         IFNE      D2BRCH
     C                   GOTO      BB020
     C                   ENDIF
     C                   ENDIF
      *
      ** Order Number
     C     D2ORDE        IFNE      *BLANK
     C                   Z-ADD     0             W#NUM6            6 0
     C                   MOVEL     D2ORDE        W#NUM6
     C     TORDE         IFNE      W#NUM6
     C     TBLKR         ANDNE     D2ORDE
     C                   GOTO      BB020
     C                   ENDIF
     C                   ENDIF
      *
      ** Nominal
     C     D2NOML        IFNE      *BLANK
     C                   MOVE      D2NOML        ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     15            ZADIG
     C                   CALL      'ZALIGN'
     C                   PARM                    ZRTN
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
     C                   PARM                    ZAFLD
      * If value entered is valid numeric then look for matching customer number
      * otherwise scan on shortname.
     C     ZRTN          IFEQ      *BLANKS
     C                   Z-ADD     0             W#NUM11          11 0
     C                   MOVE      ZAFLD         W#NUM11
      * Divide by correct nominal decimal places
     C                   SELECT
     C     TNMDP         WHENEQ    0
     C                   Z-ADD     TNOML         TNOML_DP         11 0
     C     TNMDP         WHENEQ    1
     C     TNOML         DIV       10            TNOML_DP         11 0
     C     TNMDP         WHENEQ    2
     C     TNOML         DIV       100           TNOML_DP         11 0
     C     TNMDP         WHENEQ    3
     C     TNOML         DIV       1000          TNOML_DP         11 0
     C     TNMDP         WHENEQ    4
     C     TNOML         DIV       10000         TNOML_DP         11 0
     C                   ENDSL
      *
     C     1             ADD       TNOML_DP      TNOML_DP1        11 0
     C     W#NUM11       IFGE      TNOML_DP
     C     W#NUM11       ANDLT     TNOML_DP1
     C                   ELSE
     C                   GOTO      BB020
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Trade Date
     C     D2TRDTF       IFNE      *BLANK
      *
     C                   MOVE      D2TRDTF       ZDATE
     C                   CALL      'ZDATE1'
     C                   PARM                    ZERR              7
     C                   PARM                    ZDATE
     C                   PARM                    ZDATFM
     C                   PARM                    ZDAYNO            5 0
     C     TTRDT         IFLT      ZDAYNO
     C                   GOTO      BB020
     C                   ENDIF
     C                   ENDIF
      *
      ** Countervalue
     C     D2CCCY        IFNE      *BLANK
     C     TCCCY         IFEQ      D2CCCY
     C
      * Calulate 5% either side of counervalue entered as selection
     C     Saved_D2CTVL  Div       100           W#Num16_2        16 2
     C     W#Num16_2     Mult      105           D2CTVL_Add5      16 0
     C     W#Num16_2     Mult      95            D2CTVL_Sub5      16 0
      *
     C     TCTVL         IFLT      D2CTVL_Sub5
     C     TCTVL         ORGT      D2CTVL_Add5
     C                   GOTO      BB020
     C                   ENDIF
     C                   ELSE
     C                   GOTO      BB020
     C                   ENDIF
     C                   ENDIF
      *
      ** Security
     C     D2SETY1112    IFNE      *BLANKS
     C     TISIN         IFNE      D2SETY
     C                   GOTO      BB020
     C                   ENDIF
     C                   ELSE
     C     *LIKE         DEFINE    D2SETY        WQSETY
     C                   MOVE      D2SETY        WQSETY
     C     D2SETY        IFNE      *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    TSETY                          Description
     C                   PARM      12            WQA3N             3 0          Length
     C                   PARM      1             WQB3N             3 0          Start
     C                   PARM                    WQSETY                         Mask
     C                   PARM      12            WQC3N             3 0          Length
     C                   PARM      '1'           WQD1              1            Translate
     C                   PARM      '1'           WQE1              1            Trim
     C                   PARM      '?'           WQF1              1            Wild
     C                   PARM                    WQG3N             3 0          Result
     C     WQG3N         CABLT     1             BB020
     C                   ENDIF
     C                   ENDIF
      *
      * Counterparty
     C     D2CTPY        IFNE      *BLANKS
     C*****              MOVE      D2CTPY        ZFIELD                                      CSD027A
     C*****              Z-ADD     0             ZADEC                                       CSD027A
     C*****              Z-ADD     15            ZADIG                                       CSD027A
     C*****              CALL      'ZALIGN'                                                  CSD027A
     C*****              PARM                    ZRTN                                        CSD027A
     C*****              PARM                    ZFIELD                                      CSD027A
     C*****              PARM                    ZADEC                                       CSD027A
     C*****              PARM                    ZADIG                                       CSD027A
     C*****              PARM                    ZAFLD                                       CSD027A
      **If*value*entered*is*valid*numeric*then*look*for*matching*customer*number*            CSD027A
      **otherwise*scan*on*shortname.*                                                        CSD027A
     C*****ZRTN          IFEQ      *BLANKS                                                   CSD027A
     C*****              MOVEL     D2CTPY        W#NUM6                                      CSD027A
     C*****W#NUM6        IFNE      TCTPY                                                     CSD027A
     C*****              GOTO      BB020                                                     CSD027A
     C*****              ENDIF                                                               CSD027A
     C*****              ELSE                                                                CSD027A
      * If the Counterparty is not the Counterparty on file then check shortname.            CSD027A
     C     D2CTPY        IFNE      TCTPY                                                     CSD027A
     C                   MOVEL     D2CTPY        WQCTPY           11
     C                   CALL      'QCLSCAN'
     C                   PARM                    TCTPYN                         Description
     C                   PARM      11            WQA3N                          Length
     C                   PARM      1             WQB3N                          Start
     C                   PARM                    WQCTPY                         Mask
     C                   PARM      11            WQC3N                          Length
     C                   PARM      '1'           WQD1                           Translate
     C                   PARM      '1'           WQE1                           Trim
     C                   PARM      '?'           WQF1                           Wild
     C                   PARM                    WQG3N                          Result
     C     WQG3N         CABLT     1             BB020
     C                   ENDIF
     C                   ENDIF
      *
      * Custodian
     C     D2CUST        IFNE      *BLANKS
     C*****              MOVE      D2CUST        ZFIELD
     C*****              Z-ADD     0             ZADEC                                       CSD027A
     C*****              Z-ADD     15            ZADIG                                       CSD027A
     C*****              CALL      'ZALIGN'                                                  CSD027A
     C*****              PARM                    ZRTN                                        CSD027A
     C*****              PARM                    ZFIELD                                      CSD027A
     C*****              PARM                    ZADEC                                       CSD027A
     C*****              PARM                    ZADIG                                       CSD027A
     C*****              PARM                    ZAFLD                                       CSD027A
      **If*value*entered*is*valid*numeric*then*look*for*matching*customer*number*            CSD027A
      **otherwise*scan*on*shortname.*                                                        CSD027A
     C*****ZRTN          IFEQ      *BLANKS                                                   CSD027A
     C*****              MOVEL     D2CUST        W#NUM6                                      CSD027A
     C*****W#NUM6        IFNE      TCUST                                                     CSD027A
     C*****              GOTO      BB020                                                     CSD027A
     C*****              ENDIF                                                               CSD027A
     C*****              ELSE                                                                CSD027A
      * If the Custodian is not the Custodian on file then check shortname.                  CSD027A
     C     D2CUST        IFNE      TCUST                                                     CSD027A
     C     *LIKE         DEFINE    D2CUST        WQCUST
     C                   MOVE      D2CUST        WQCUST
     C                   CALL      'QCLSCAN'
     C                   PARM                    TCUSTN                         Description
     C                   PARM      10            WQA3N                          Length
     C                   PARM      1             WQB3N                          Start
     C                   PARM                    WQCUST                         Mask
     C                   PARM      10            WQC3N                          Length
     C                   PARM      '1'           WQD1                           Translate
     C                   PARM      '1'           WQE1                           Trim
     C                   PARM      '?'           WQF1                           Wild
     C                   PARM                    WQG3N                          Result
     C     WQG3N         CABLT     1             BB020
     C                   ENDIF
     C                   ENDIF
      *
      * Customer
     C     D2CUSN        IFNE      *BLANKS
     C*****              MOVE      D2CUSN        ZFIELD                                      CSD027A
     C*****              Z-ADD     0             ZADEC                                       CSD027A
     C*****              Z-ADD     15            ZADIG                                       CSD027A
     C*****              CALL      'ZALIGN'                                                  CSD027A
     C*****              PARM                    ZRTN                                        CSD027A
     C*****              PARM                    ZFIELD                                      CSD027A
     C*****              PARM                    ZADEC                                       CSD027A
     C*****              PARM                    ZADIG                                       CSD027A
     C*****              PARM                    ZAFLD                                       CSD027A
      **If*value*entered*is*valid*numeric*then*look*for*matching*customer*number*            CSD027A
      **otherwise*scan*on*shortname.*                                                        CSD027A
     C*****ZRTN          IFEQ      *BLANKS                                                   CSD027A
     C*****              MOVEL     D2CUSN        W#NUM6                                      CSD027A
     C*****W#NUM6        IFNE      TCUSN                                                     CSD027A
     C*****              GOTO      BB020                                                     CSD027A
     C*****              ENDIF                                                               CSD027A
     C*****              ELSE                                                                CSD027A
      * If the Customer is not the Customer on file then check shortname.                    CSD027A
     C     D2CUSN        IFNE      TCUSN                                                     CSD027A
     C     *LIKE         DEFINE    D2CUSN        WQCUSN
     C                   MOVE      D2CUSN        WQCUSN
     C                   CALL      'QCLSCAN'
     C                   PARM                    TCUSNN                         Description
     C                   PARM      10            WQA3N                          Length
     C                   PARM      1             WQB3N                          Start
     C                   PARM                    WQCUSN                         Mask
     C                   PARM      10            WQC3N                          Length
     C                   PARM      '1'           WQD1                           Translate
     C                   PARM      '1'           WQE1                           Trim
     C                   PARM      '?'           WQF1                           Wild
     C                   PARM                    WQG3N                          Result
     C     WQG3N         CABLT     1             BB020
     C                   ENDIF
     C                   ENDIF
     C     Tag_SkipScan  TAG
      *
      * If displaying the linked trade subfile then need to compare
      * the date (from the FO ID) only linked if the date is the same
     C     *IN70         IFEQ      *ON
     C     TFRID16       ANDNE     Link_FOID
     C                   GOTO      BB020
     C                   ENDIF
      *
     C                   MOVE      *OFF          *IN32
     C                   MOVE      *OFF          *IN87
      *
      ** Clear subfile fields
     C                   EXSR      Sr_ResetFld
      *
      ** Load SFL fields.
     C                   EXSR      Sr_LoadFld
      *
      * If record is deleted or from invalid file set indicator to
      * show this.
     C                   SETOFF                                       7576
     C     TDELET        IFEQ      'D'
     C                   MOVE      *ON           *IN75
     C                   ENDIF
     C     TINVAL        IFEQ      'Y'
     C                   MOVE      *ON           *IN76
     C                   ENDIF
     C
      ** Record will be selected unless overridden
     C                   MOVEL     'Y'           W0RSL             1
      *
      ** If record dropped...
     C                   SUB       1             ##RR
     C     W0RSL         IFNE      'N'
     C                   ADD       1             ##RR
     C                   ENDIF
      *
      ** Output to subfile.
     C     W0RSL         IFNE      'N'
     C                   ADD       1             ##RR                 81
     C                   ADD       1             ##RROK
     C     *IN70         IFEQ      *OFF
     C                   WRITE     #SFLRCD
     C                   ELSE
     C                   WRITE     #SFLRCD2
     C                   ENDIF
     C                   ENDIF
     C     BB020         TAG
      *
      ** Increment scan check count.
     C                   ADD       1             ##RRRD
     C                   READ      SETRANPDX                              82
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
      *
      * Also command line should only have F3 as option
     C                   MOVEA     TXT(1)        ##CTX1
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
      * Calls     -                                                   *
      *           - #IY8TS                                            *
      *           - #IHPKY                                            *
      *                                                               *
      * Called by - MAIN                                              *
      *                                                               *
      *****************************************************************
     C     Sr_Display    BEGSR
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
     C     *IN70         IFEQ      *OFF
     C                   EXFMT     #SFLCTL
     C                   MOVE      *OFF          *IN73
     C                   ELSE
     C                   EXFMT     #SFLCTL2
     C                   MOVE      *ON           *IN73
     C                   ENDIF
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
      *                                                               *
      * Called by - MAIN                                              *
      *                                                               *
      *****************************************************************
     C     Sr_ScreenIn   BEGSR
      *
      ** Change of position specified
     C     WWTRAD        CASNE     D2TRAD        Sr_ReLoad
     C     WWWIWO        CASNE     D2WIWO        Sr_ReLoad
     C     WWFRID        CASNE     D2FRID        Sr_ReLoad
     C     WWSTAT        CASNE     D2STAT        Sr_ReLoad
     C     WWBRCH        CASNE     D2BRCH        Sr_ReLoad
     C     WWCTPY        CASNE     D2CTPY        Sr_ReLoad
     C     WWCUST        CASNE     D2CUST        Sr_ReLoad
     C     WWORDE        CASNE     D2ORDE        Sr_ReLoad
     C     WWSETY        CASNE     D2SETY        Sr_ReLoad
     C     WWNOML        CASNE     D2NOML        Sr_ReLoad
     C     WWTRDTF       CASNE     D2TRDTF       Sr_ReLoad
     C     WWTRDTT       CASNE     D2TRDTT       Sr_ReLoad
     C     WWCUSN        CASNE     D2CUSN        Sr_ReLoad
     C     WWCTVL        CASNE     D2CTVL        Sr_ReLoad
     C     WWCCCY        CASNE     D2CCCY        Sr_ReLoad
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
     C                   ENDDO
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * Sr_Modified - Process Modified Subfile Record                 *
      *                                                               *
      * Calls     - Sr_ProcRec                                        *
      *                                                               *
      * Called by - MAIN                                              *
      *                                                               *
      *****************************************************************
     C     Sr_Modified   BEGSR
      *
     C     *IN70         IFEQ      *OFF
     C                   READC     #SFLRCD                                92
     C                   ELSE
     C                   READC     #SFLRCD2                               92
     C                   ENDIF
     C     *IN92         DOWEQ     *OFF
     C                   EXSR      Sr_ProcRec
     C                   MOVE      *OFF          *IN87
      *
      * As all READC records are read then if 'L' for Linked subfile
      * taken want to ensure we are still reading the main subfile
      * until the subfile record has been updated.
     C     *IN70         IFEQ      *OFF
     C     *IN73         OREQ      *OFF
     C     D1INVL        IFEQ      'Y'
     C                   SETON                                        76
     C                   ENDIF
     C     D1DELT        IFEQ      'D'
     C                   SETON                                        75
     C                   ENDIF
     C                   UPDATE    #SFLRCD
      *
      * Re-set colour indicators for the changed record
     C                   SETOFF                                       7576
     C                   READC     #SFLRCD                                92
     C                   ELSE
     C     D1DELT        IFEQ      'D'
     C                   SETON                                        75
     C                   ENDIF
     C                   UPDATE    #SFLRCD2
      *
      * Re-set colour indicators for the changed record
     C                   SETOFF                                       75
     C                   READC     #SFLRCD2                               92
     C                   ENDIF
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * Sr_ProcRec- Process Subfile Record                            *
      *                                                               *
      * Calls     -                                                   *
      *                                                               *
      * Called by - Sr_Modified                                       *
      *                                                               *
      *****************************************************************
     C     Sr_ProcRec    BEGSR
      *
     C     LKEY          KLIST
     C                   KFLD                    PGMNO
     C                   KFLD                    OPTN
      *
      ** Set off error indicators
      *
     C                   MOVE      '0'           *IN32
      *
      ** No errors
     C                   MOVE      *OFF          *IN98
      *
      ** No SFLNXTCHG
     C                   MOVE      *OFF          *IN84
      *
      ** Data entered
     C                   MOVEL     'Y'           WKIPIN
      *
      ** SFLNXTCHG
      *
      * If main subfile being displayed, error if selection not
      * 'M', 'T', 'S', 'P' or 'L' and record not from invalid file.
B1   C     *IN70         IFEQ      *OFF
     C     D1SELC        ANDNE     'M'
     C     D1SELC        ANDNE     'T'
     C     D1SELC        ANDNE     'S'
     C     D1SELC        ANDNE     'P'
     C     D1SELC        ANDNE     'L'
     C     D1SELC        ANDNE     ' '
     C     D1INVL        ANDNE     'Y'
      *
     C                   MOVE      *ON           *IN32
     C                   MOVE      *ON           *IN98
     C                   MOVE      *ON           *IN84
     C                   MOVE      'SE10054'     ZAMSID
     C                   EXSR      ZASNMS
      *
      ** If SFLRCD invalid, note the fact
     C   98
     CANN99              Z-ADD     ##RR          ##SFRC               99
      *
X1   C                   ELSE
      * If main subfile being displayed, error if selection not
      * 'M' or 'P' and record from invalid file.
B2   C     *IN70         IFEQ      *OFF
     C     D1SELC        ANDNE     'M'
     C     D1SELC        ANDNE     'P'
     C     D1SELC        ANDNE     ' '
     C     D1INVL        ANDEQ     'Y'
      *
     C                   MOVE      *ON           *IN32
     C                   MOVE      *ON           *IN98
     C                   MOVE      *ON           *IN84
     C                   MOVE      'SE10057'     ZAMSID
     C                   EXSR      ZASNMS
      *
      ** If SFLRCD invalid, note the fact
     C   98
     CANN99              Z-ADD     ##RR          ##SFRC               99
      *
X2   C                   ELSE
      * 'L' not allowed if Order Number is blank
B3   C     D1SELC        IFEQ      'L'
     C     D1ORDE        ANDEQ     *BLANKS
     C                   MOVE      *ON           *IN32
     C                   MOVE      *ON           *IN98
     C                   MOVE      'SE10056'     ZAMSID
     C                   EXSR      ZASNMS
      *
      ** If SFLRCD invalid, note the fact
     C   98
     CANN99              Z-ADD     ##RR          ##SFRC               99
      *
X3   C                   ELSE
      * If linked trades subfile being displayed, error if selection not
      * 'M', 'T', 'S', or 'P'.
B4   C     *IN70         IFEQ      *ON
     C     D1SELC        ANDNE     'M'
     C     D1SELC        ANDNE     'T'
     C     D1SELC        ANDNE     'S'
     C     D1SELC        ANDNE     'P'
     C     D1SELC        ANDNE     ' '
      *
     C                   MOVE      *ON           *IN32
     C                   MOVE      *ON           *IN98
     C                   MOVE      'SE10055'     ZAMSID
     C                   EXSR      ZASNMS
      *
      ** If SFLRCD invalid, note the fact
     C   98
     CANN99              Z-ADD     ##RR          ##SFRC               99
      *
X4   C                   ELSE
      *
      * Else Valid entry in Subfile Select
      * If 'L' entered for record
B5   C     D1SELC        IFEQ      'L'
     C                   MOVE      *ON           *IN70
     C                   MOVEL     D1FOID        Link_FOID        16
     C                   EXSR      Sr_Reload
E5   C                   ENDIF
      *
      * If 'P' entered for record
B5   C     D1SELC        IFEQ      'P'
     C                   MOVE      '01'          OPTN              2
     C                   MOVEL     'SE4400'      PGMNO             8
     C     LKEY          CHAIN     SECONDF                            42
B6   C     *IN42         IFNE      *ON
     C                   MOVE      D1SETY        RQSESN
     C                   OUT       SESDS
     C                   CALL      TPGM
     C     *LOCK         IN        SESDS
      * On return from lower level check return code
      * '1' if F3 was pressed, '2' or '7' if F12 or F9
      * respectively.
      *
B7   C     RTNC          IFEQ      '1'
     C                   MOVE      *ON           *INLR
     C                   RETURN
X7   C                   ELSE
B8   C     RTNC          IFEQ      '2'
B8   C     RTNC          OREQ      '7'
     C                   MOVE      ' '           D1SELC
E8   C                   ENDIF
E7   C                   ENDIF
      *
E6   C                   ENDIF
      *
E5   C                   ENDIF
      *
      * If 'T' entered and record is for a Trade
B5   C     D1SELC        IFEQ      'T'
     C     D1FILE        ANDEQ     'T'
     C                   MOVE      '02'          OPTN              2
     C                   MOVEL     'SE4400'      PGMNO             8
     C     LKEY          CHAIN     SECONDF                            42
B6   C     *IN42         IFNE      *ON
     C                   MOVE      D1TRNO        RQTDRF
     C                   OUT       SESDS
     C                   CALL      TPGM
     C     *LOCK         IN        SESDS
      * On return from lower level check return code
      * '1' if F3 was pressed, '2' or '7' if F12 or F9
      * respectively.
      *
B7   C     RTNC          IFEQ      '1'
     C                   MOVE      *ON           *INLR
     C                   RETURN
X7   C                   ELSE
B8   C     RTNC          IFEQ      '2'
     C     RTNC          OREQ      '7'
     C                   MOVE      ' '           D1SELC
E8   C                   ENDIF
E7   C                   ENDIF
      *
E6   C                   ENDIF
      *
E5   C                   ENDIF
      *
      * If 'T' entered and record is for a WI/WO
B5   C     D1SELC        IFEQ      'T'
     C     D1FILE        ANDEQ     'W'
      *
     C                   CALL      'SEDPMVSIN'
     C                   PARM                    D1TYPE
     C                   PARM                    D1SETY
     C                   PARM                    D1TRNO
     C                   PARM                    @RTCD
     C                   PARM      'SE4400    '  CallProg         10
B6   C     @RTCD         IFEQ      'Y2U9999'
     C                   MOVE      *ON           *INLR
     C                   RETURN
X6   C                   ELSE
     C                   MOVE      ' '           D1SELC
E6   C                   ENDIF
E5   C                   ENDIF
      *
      * If 'M' entered
B5   C     D1SELC        IFEQ      'M'
      *
      * Call SEC4402 to clear temporary SWFIT messages file as may contain data
     C                   CALL      'SEC4402'
      *
     C                   CALL      'SE4410'
     C                   PARM                    D1TRNO
     C                   PARM                    D1TYPE
     C                   PARM      *BLANKS       Mess_Key         40
     C                   PARM                    @RTCD
B6   C     @RTCD         IFEQ      'Y2U9999'
     C                   MOVE      *ON           *INLR
     C                   RETURN
X6   C                   ELSE
     C                   MOVE      ' '           D1SELC
E6   C                   ENDIF
E5   C                   ENDIF
      *
      * If 'S' entered
B5   C     D1SELC        IFEQ      'S'
      *
     C                   CALL      'SEC025'
     C                   PARM      'SEMVTSSIN'   @PGM             10
     C                   PARM                    D1TRNO
     C                   PARM                    D1TYPE
     C                   PARM      'E'           @MODE             1
     C                   PARM                    @endF3            1
     C                   PARM                    @endF12           1
B6   C     @endF3        IFEQ      'Y'
     C                   MOVE      *ON           *INLR
     C                   RETURN
X6   C                   ELSE
     C                   MOVE      ' '           D1SELC
E6   C                   ENDIF
E5   C                   ENDIF
      *
E4   C                   ENDIF
E3   C                   ENDIF
E2   C                   ENDIF
E1   C                   ENDIF
      *
     C     DCEXIT        ENDSR
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
      * Sr_ResetFld - Initialise Subfile Record                       *
      *                                                               *
      * Calls     -                                                   *
      *                                                               *
      * Called by - Sr_Build                                          *
      *                                                               *
      *****************************************************************
     C     Sr_ResetFld   BEGSR
      *
      ** Previous values
     C                   MOVEL     *BLANK        D1TRNO
     C                   MOVEL     *BLANK        D1STAT
     C                   MOVEL     *BLANK        D1BRCH
     C                   MOVEL     *BLANK        D1CTPY
     C                   MOVEL     *BLANK        D1CUSN
     C                   MOVEL     *BLANK        D1CUST
     C                   MOVEL     *BLANK        D1ORDE
     C                   MOVEL     *BLANK        D1TRDT
     C                   MOVEL     *BLANK        D1TYPE
     C                   MOVEL     *BLANK        D1SETY
     C                   MOVEL     *BLANK        D1NOML
     C                   MOVEL     *BLANK        D1CTVL
     C                   MOVEL     *BLANK        D1CCCY
     C                   MOVEL     *BLANK        D1STAK
     C                   MOVEL     *BLANK        D1BLKR
     C                   MOVEL     *BLANK        D1FILE
     C                   MOVEL     *BLANK        D1INVL
     C                   MOVEL     *BLANK        D1DELT
     C                   MOVEL     *BLANK        D1FOID
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
      *
     C                   MOVE      *BLANKS       D1SELC
      * If Trade or DVP Ref
     C     TFILE         IFEQ      'T'
     C     TFILE         OREQ      'D'
     C                   MOVEL     TTRNO         D1TRNO
     C                   ELSE
      * WI/WO Ref
     C                   MOVEL     TWIWO         D1TRNO
     C                   ENDIF
      *
     C                   MOVEL     TSTAT         D1STAT
     C                   MOVEL     TBRCH         D1BRCH
     C                   MOVEL     TCTPYN        D1CTPY
     C                   MOVEL     TCUSNN        D1CUSN
     C                   MOVEL     TCUSTN        D1CUST
      *
     C     TORDE         IFEQ      0
     C     TORDE         OREQ      999999
     C                   MOVE      *BLANKS       D1ORDE
     C                   ELSE
     C                   MOVEL     TORDE         D1ORDE
     C                   ENDIF
      *
      * If Agency Trade Ind is 'C'or 'M' then move bulk reference into D1ORDE
      * (Order Number will be blank.)
     C     TAGEN         IFEQ      'C'
     C     TAGEN         OREQ      'M'
     C                   MOVE      TBLKR         D1ORDE
     C                   ENDIF
      *
     C                   MOVEL     TTRDTMMM      D1TRDT
     C                   MOVEL     TVLDTMMM      D1VLDT
     C                   MOVEL     TTYPE         D1TYPE
     C                   MOVEL     TSETY         D1SETY
      *
      * Format countervalue and nominal
      * Obtain no decimals for currency entered.
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      TCCCY         @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     TCTVL         IFEQ      0
     C                   MOVE      *BLANKS       D1CTVL
     C                   ELSE
     C                   MOVE      TCTVL         ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   MOVE      'J'           ZECODE
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM                    ZDECS             1 0
     C                   PARM                    ZECODE            1
     C                   PARM                    ZOUT21           21
      *
     C                   MOVEL     ZOUT21        D1CTVL
     C                   ENDIF
      *
     C     TNOML         IFEQ      0
     C                   MOVE      *BLANKS       D1NOML
     C                   ELSE
     C                   MOVE      TNOML         ZFLD15
     C                   Z-ADD     TNMDP         ZDECS
     C                   MOVE      ' '           ZECODE
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM                    ZECODE
     C                   PARM                    ZOUT21
      *
     C                   MOVE      ZOUT21        D1NOML
     C                   ENDIF
     C                   MOVEL     TCCCY         D1CCCY
      *
     C                   MOVEL     TSTAK         D1STAK
     C                   MOVEL     TBLKR         D1BLKR
     C                   MOVEL     TFILE         D1FILE
     C                   MOVEL     TINVAL        D1INVL
     C                   MOVEL     TDELET        D1DELT
      *
     C                   MOVEL     TFRID         D1FOID
      *
     C                   ENDSR
      *
      *****************************************************************
      * Initialise subfile control
      *****************************************************************
     C     Sr_InitCFld   BEGSR
      *
      * Not the Trade Dates as set up to be Rundate.
     C                   MOVEL     *BLANK        D2TRAD
     C                   MOVEL     *BLANK        D2WIWO
     C                   MOVEL     *BLANK        D2FRID
     C                   MOVEL     *BLANK        D2STAT
     C                   MOVEL     *BLANK        D2CTPY
     C                   MOVEL     *BLANK        D2CUST
     C                   MOVEL     *BLANK        D2ORDE
     C                   MOVEL     *BLANK        D2SETY
     C                   MOVEL     *BLANK        D2NOML
     C                   MOVEL     *BLANK        D2CUSN
     C                   MOVEL     *BLANK        D2CTVL
     C                   MOVEL     *BLANK        D2CCCY
     C                   Z-ADD     0             D2LCDT
     C                   MOVEL     *BLANK        D2CHTP
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * Sr_Create_File - Build new file from all input file records.  *
      *                                                               *
      * Calls     -                                                   *
      *                                                               *
      * Called by - Main                                              *
      *                                                               *
      *****************************************************************
     C     Sr_Create_FileBEGSR
      *
      * If Trade/DVP ref entered then CHAIN to Trades file otherwise
      * Read all records on the Trades file greater than From date and
      * up to rundate or To date if entered.
     C     D2TRAD        IFNE      *BLANKS
     C     D2TRAD        CHAIN     TRADS                              60
     C                   ELSE
      * If FO ID entered then CHAIN to Trades file.
     C     D2FRID        IFNE      *BLANKS
     C     D2FRID        CHAIN     SETRADL0                           60
     C                   ELSE
      * If Trade Ref blank but WIWO Ref or not blank then
      * do not read the trades file.
     C     D2WIWO        IFNE      *BLANKS
     C                   MOVE      *ON           *IN60
     C                   ELSE
     C     ZDAYNOF       SETLL     TRADSDLA
     C                   READ      TRADSDLA                               60
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     *IN60         DOWNE     *ON
      *
      * If Trade Date To is entered then do not read rest of file.
     C     D2TRDTT       IFNE      *BLANKS
     C     TDDT          ANDGT     ZDAYNOT
     C                   MOVE      *ON           *IN60
     C                   GOTO      END_TR_READ
     C                   ENDIF
      *
      * Clear output fields on SETRANPD
     C                   CLEAR                   SETRAND0
      *
      * Move fields to ouput file fields.
      * Trade No./DVP No.
     C                   MOVE      TDRF          TTRNO
      * WI/WO No.
     C                   EVAL      TWIWO = 0
      * Front Office ID
     C                   EVAL      TFRID = FRNT
      * Status
      * CHAIN SEMVTSPD
     C     TDRF          CHAIN     SEMVTSL7                           85
     C     *IN85         IFEQ      *OFF
     C                   EVAL      TSTAT = TMSWSC
     C                   ELSE
     C                   EVAL      TSTAT = *BLANKS
     C                   ENDIF
      * Branch
     C                   EVAL      TBRCH = TDBA
      *
      * Counterparty and Customer
      * Check TCNR for classifiaction. If 'M' move to Counterparty
      * but if 'S' or 'D' move to Customer.
     C                   MOVE      *BLANKS       @@CNUM
     C                   MOVE      *BLANKS       @@CUST
     C                   MOVE      TCNR          @@CNUM            6
     C                   MOVE      TCNR          @@CUST           10
     C                   EXSR      SRSECS
     C     BFCLAS        IFEQ      'M'
     C*****              EVAL      TCUSN = 0                                                 CSD027A
     C                   EVAL      TCUSN = *blanks                                           CSD027A
     C                   EVAL      TCTPY = TCNR
     C                   EXSR      SRCUST
     C                   EVAL      TCTPYN = BBCSSN
     C                   ELSE
     C*****              EVAL      TCTPY = 0                                                 CSD027A
     C                   EVAL      TCTPY = *blanks                                           CSD027A
     C                   EVAL      TCUSN = TCNR
     C                   EXSR      SRCUST
     C                   EVAL      TCUSNN = BBCSSN
     C                   ENDIF
      * Custodian
     C     TDTP          IFEQ      'TP'
     C                   EVAL      TCUST = DELT
     C                   ELSE
     C                   EVAL      TCUST = DELF
     C                   ENDIF
      * Customer Shortname of Custodian
     C*****TCUST         IFNE      0                                                         CSD027A
     C     TCUST         IFNE      *blanks                                                   CSD027A
     C                   MOVE      *BLANKS       @@CUST
     C                   MOVE      TCUST         @@CUST
     C                   EXSR      SRCUST
     C                   EVAL      TCUSTN = BBCSSN
     C                   ENDIF
      * Order Number
     C                   EVAL      TORDE = ORDE
      * Bulk Reference
     C                   EVAL      TBLKR = BLKR
      * Trade Date
     C                   EVAL      TTRDT = TDDT
     C                   CALL      'ZDATE2'
     C                   PARM                    TTRDT             5 0
     C                   PARM                    ZDATFM            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    WQ0004            7
     C                   MOVEL     ZDATE         TTRDTMM
     C                   MOVEL     WQ0004        TTRDTMMM
      * Value Date
     C                   EVAL      TVLDT = TDVD
     C                   CALL      'ZDATE2'
     C                   PARM                    TVLDT             5 0
     C                   PARM                    ZDATFM            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    WQ0004            7
     C                   MOVEL     WQ0004        TVLDTMMM
      * Trade Type
     C                   EVAL      TTYPE = TDTP
      * Security
     C                   EVAL      TSETY = TDSS
      * Security ISIN code
     C     TDSS          CHAIN     SECTY                              89
     C     *IN89         IFEQ      *OFF
     C                   EVAL      TISIN = ISIN
     C                   ENDIF
      * Nominal Decimal places
     C                   MOVE      NMDP          TNMDP
      * Nominal
     C                   EVAL      TNOML = NOML
      * Countervalue
     C                   EVAL      TCTVL = TCTR
      * Currency
     C                   EVAL      TCCCY = TNMC
      * Message Send/Ack
     C                   MOVEL     'SET'         KMESSAGE3
     C                   MOVEL     TDRF          KMESSAGE9
     C                   MOVE      '9999999'     KMESSAGE16
     C                   EXSR      SR_GetMessage
      * Agency
     C                   EVAL      TAGEN = ATRD
      * Invalid File Indicator
     C                   EVAL      TINVAL = 'N'
      * File Indicator
     C                   EVAL      TFILE = 'T'
      * Deleted Trade Indicator
     C     Trad_RECI     IFEQ      '*'
     C     Trad_RECI     OREQ      'C'
     C                   MOVE      'D'           TDELET
     C                   ELSE
     C                   MOVE      ' '           TDELET
     C                   ENDIF
      *
     C                   WRITE     SETRAND0
      *
      * If Trade/DVP Ref or FO ID entered one record has been read so want to exit the loop.
     C     D2TRAD        IFNE      *BLANKS
     C     D2FRID        ORNE      *BLANKS
     C                   MOVE      *ON           *IN60
     C                   ELSE
     C                   READ      TRADSDLA                               60
     C                   ENDIF
      *
     C     END_TR_READ   TAG
     C                   ENDDO
      *
      * Read all records on the Invalid Trades file and write a record on
      * temporary file SETRANPD
     C     *LOVAL        SETLL     SEITRADD0
     C                   READ      SEITRADD0                              60
      *
     C     *IN60         DOWNE     *ON
      * Clear output fields on SETRANPD
     C                   CLEAR                   SETRAND0
      *
      * Only process record if Trade date is between entered Trade Date From
      * and Rundate or Trade Date To if entered.
     C     DDACTN        IFEQ      'I'
     C                   MOVEL     DDTDDT        ZDATE
     C                   CALL      'ZDATE1'
     C                   PARM                    ZERR              7
     C                   PARM                    ZDATE
     C                   PARM                    ZDATFM
     C                   PARM                    ZDAYNO            5 0
     C                   Z-ADD     ZDAYNO        TTRDT
      *
     C     TTRDT         IFLT      ZDAYNOF
     C     TTRDT         ORGT      ZDAYNOT
     C     D2TRDTT       ANDNE     *BLANKS
     C                   GOTO      NEXT_TR_READ
     C                   ENDIF
     C                   ELSE
     C                   GOTO      NEXT_TR_READ
     C                   ENDIF
     C
      * Move fields to ouput file fields.
      * Trade No./DVP No.
     C                   MOVE      DDTDRF        TTRNO
      * WI/WO No.
     C                   EVAL      TWIWO = 0
      * Front Office ID
     C                   EVAL      TFRID = DDFOTRANID
      * Status
      * CHAIN SEMVTSPD
     C     DDTDRF        CHAIN     SEMVTSL7                           85
     C     *IN85         IFEQ      *OFF
     C                   EVAL      TSTAT = TMSWSC
     C                   ELSE
     C                   EVAL      TSTAT = *BLANKS
     C                   ENDIF
      * Branch
     C                   EVAL      TBRCH = DDBRCD
      *
      * Counterparty and Customer
      * Check TCNR for classification. If 'M' move to Counterparty
      * but if 'S' or 'D' move to Customer.
     C                   MOVE      *BLANKS       @@CUST
     C                   MOVE      *BLANKS       @@CNUM
     C                   MOVE      DDCNUM        @@CUST
     C                   EXSR      SRCUST
      *
      * If Invalid then blanks to customer and counterparty
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      *BLANKS       TCTPYN
     C                   MOVE      *BLANKS       TCUSNN
     C*****              Z-ADD     0             TCTPY                                       CSD027A
     C*****              Z-ADD     0             TCUSN                                       CSD027A
     C                   EVAL      TCTPY = *blanks                                           CSD027A
     C                   EVAL      TCUSN = *blanks                                           CSD027A
     C                   ELSE
     C                   MOVE      BBCUST        @@CNUM
     C                   EXSR      SRSECS
     C     BFCLAS        IFEQ      'M'
     C*****              EVAL      TCUSN = 0                                                 CSD027A
     C                   EVAL      TCUSN = *blanks                                           CSD027A
     C                   MOVE      BBCUST        TCTPY
     C                   EVAL      TCTPYN = BBCSSN
     C                   ELSE
     C*****              EVAL      TCTPY = 0                                                 CSD027A
     C                   EVAL      TCTPY = *blanks                                           CSD027A
     C                   MOVE      BBCUST        TCUSN
     C                   EVAL      TCUSNN = BBCSSN
     C                   ENDIF
     C                   ENDIF
      * Custodian
     C     TDTP          IFEQ      'TP'
     C                   MOVE      DDDELT        @@CUST
     C                   ELSE
     C                   MOVE      DDDELF        @@CUST
     C                   ENDIF
     C                   EXSR      SRCUST
     C     @RTCD         IFNE      *BLANKS
     C*****              Z-ADD     0             TCUST                                       CSD027A
     C                   EVAL      TCUST = *blanks                                           CSD027A
     C                   ELSE
     C                   MOVE      BBCUST        TCUST
     C                   ENDIF
      *
      * Customer Shortname of Custodian
     C*****TCUST         IFNE      0                                                         CSD027A
     C     TCUST         IFNE      *blanks                                                   CSD027A
     C                   EVAL      TCUSTN = BBCSSN
     C                   ENDIF
      * Order Number
     C                   MOVE      DDORDE        TORDE
      * Bulk Reference
     C                   MOVE      DDBLKR        TORDE
      * Trade Date
     C                   CALL      'ZDATE2'
     C                   PARM                    TTRDT
     C                   PARM                    ZDATFM
     C                   PARM                    ZDATE
     C                   PARM                    WQ0004
     C                   MOVEL     ZDATE         TTRDTMM
     C                   MOVEL     WQ0004        TTRDTMMM
      * Value Date
     C                   MOVEL     DDTDVD        ZDATE
     C                   CALL      'ZDATE1'
     C                   PARM                    ZERR              7
     C                   PARM                    ZDATE
     C                   PARM                    ZDATFM
     C                   PARM                    ZDAYNO            5 0
     C                   Z-ADD     ZDAYNO        TVLDT
      *
     C                   CALL      'ZDATE2'
     C                   PARM                    TVLDT
     C                   PARM                    ZDATFM
     C                   PARM                    ZDATE
     C                   PARM                    WQ0004
     C                   MOVEL     WQ0004        TVLDTMMM
      *
      * Trade Type
     C                   EVAL      TTYPE = DDTDTP
      * Security
     C                   EVAL      TSETY = DDSESN
      * Security ISIN code
     C     DDSESN        CHAIN     SECTY                              89
     C     *IN89         IFEQ      *OFF
     C                   EVAL      TISIN = ISIN
     C                   ENDIF
      * Nominal Decimal places
     C                   MOVE      NMDP          TNMDP
      * Nominal
     C                   MOVE      DDNOML        ZFIELD
     C                   Z-ADD     NMDP          ZADEC
     C     15            SUB       NMDP          ZADIG
     C                   CALL      'ZALIGN'
     C                   PARM                    ZRTN              7
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
     C                   PARM                    ZAFLD            16
      *
     C                   MOVE      ZAFLD         TNOML
      * Countervalue
     C                   EVAL      TCTVL = 0
      * Currency
     C                   EVAL      TCCCY = *BLANKS
      * Message Send/Ack
     C                   MOVEL     'SET'         KMESSAGE3
     C                   MOVEL     DDTDRF        KMESSAGE9
     C                   MOVE      '9999999'     KMESSAGE16
     C                   EXSR      SR_GetMessage
      * Agency
     C                   EVAL      TAGEN = *BLANKS
      * Invalid File Indicator
     C                   EVAL      TINVAL = 'Y'
      * File Indicator
     C                   EVAL      TFILE = 'T'
      *
     C                   WRITE     SETRAND0
      *
     C     NEXT_TR_READ  TAG
     C                   READ      SEITRADD0                              60
     C                   ENDDO
      *
      * If WI/WO ref or FO ID entered then CHAIN to Depot Movements file otherwise
      * Read all records on the Trades file greater than From date and
      * up to rundate or To date if entered writing a record on SETRANPD
     C     D2WIWO        IFNE      *BLANKS
     C     D2WIWO        CHAIN     DPTMVDL1                           60
     C                   ELSE
     C     D2FRID        IFNE      *BLANKS
     C     D2FRID        CHAIN     SEDPMVL0                           60
     C                   ELSE
      * If WIWO Ref blank but Trade Ref entered
      * do not read the depot movements file.
     C     D2TRAD        IFNE      *BLANKS
     C                   MOVE      *ON           *IN60
     C                   ELSE
     C     ZDAYNOF       SETLL     DPTMVDL2
     C                   READ      DPTMVDL2                               60
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     *IN60         DOWNE     *ON
      *
      * If Trade Date To is entered then do not read rest of file.
     C     D2TRDTT       IFNE      *BLANKS
     C     DMTD          ANDGT     ZDAYNOT
     C                   MOVE      *ON           *IN60
     C                   GOTO      END_DP_READ
     C                   ENDIF
      *
      * Clear output fields on SETRANPD
     C                   CLEAR                   SETRAND0
      *
      * Move fields to ouput file fields.
      * Trade No./DVP No.
     C                   EVAL      TTRNO = 0
      * WI/WO No.
     C                   MOVE      DPRN          TWIWO
      * Front Office ID
     C                   EVAL      TFRID = DMFRNT
      * Status
      * CHAIN SEMVTSPD
     C     DPRN          CHAIN     SEMVTSL7                           85
     C     *IN85         IFEQ      *OFF
     C                   EVAL      TSTAT = TMSWSC
     C                   ELSE
     C                   EVAL      TSTAT = *BLANKS
     C                   ENDIF
      * Branch
     C                   EVAL      TBRCH = DPBA
      * Counterparty
     C                   EVAL      TCTPY = CPTY
     C*****TCTPY         IFNE      0                                                         CSD027A
     C     TCTPY         IFNE      *blanks                                                   CSD027A
     C                   MOVE      *BLANKS       @@CUST
     C                   MOVEL     CPTY          @@CUST
     C                   EXSR      SRCUST
     C                   EVAL      TCTPYN = BBCSSN
     C                   ENDIF
      * Customer
     C                   EVAL      TCUSN = DPBN
     C*****TCUSN         IFNE      0                                                         CSD027A
     C     TCUSN         IFNE      *blanks                                                   CSD027A
     C                   MOVE      *BLANKS       @@CUST
     C                   MOVEL     DPBN          @@CUST
     C                   EXSR      SRCUST
     C                   EVAL      TCUSNN = BBCSSN
     C                   ENDIF
      * Custodian
     C     DPMV          IFEQ      'WI'
     C                   EVAL      TCUST = DPID
     C                   ELSE
     C                   EVAL      TCUST = DPOD
     C                   ENDIF
      * Customer Shortname of Custodian
     C*****TCUST         IFNE      0                                                         CSD027A
     C     TCUST         IFNE      *blanks                                                   CSD027A
     C                   MOVE      *BLANKS       @@CUST
     C                   MOVEL     TCUST         @@CUST
     C                   EXSR      SRCUST
     C                   EVAL      TCUSTN = BBCSSN
     C                   ENDIF
      * Order Number
     C                   EVAL      TORDE = 0
      * Bulk Reference
     C                   MOVE      *BLANKS       TBLKR
      * Trade Date
     C                   EVAL      TTRDT = DMTD
     C                   CALL      'ZDATE2'
     C     ZDAYNO        PARM                    TTRDT
     C                   PARM                    ZDATFM
     C                   PARM                    ZDATE
     C                   PARM                    WQ0004
     C                   MOVEL     ZDATE         TTRDTMM
     C                   MOVEL     WQ0004        TTRDTMMM
      * Value Date
     C                   EVAL      TVLDT = DPVD
     C                   CALL      'ZDATE2'
     C     ZDAYNO        PARM                    TVLDT
     C                   PARM                    ZDATFM
     C                   PARM                    ZDATE
     C                   PARM                    WQ0004
     C                   MOVEL     WQ0004        TVLDTMMM
      * Trade Type
     C                   EVAL      TTYPE = DPMV
      * Security
     C                   EVAL      TSETY = DPSS
      * Security ISIN code
     C     DPSS          CHAIN     SECTY                              89
     C     *IN89         IFEQ      *OFF
     C                   EVAL      TISIN = ISIN
     C                   ENDIF
      * Nominal Decimal places
     C                   MOVE      NMDP          TNMDP
      * Nominal
     C                   EVAL      TNOML = DPNA
      * Countervalue
     C                   EVAL      TCTVL = 0
      * Currency
     C                   EVAL      TCCCY = *BLANKS
      * Message Send/Ack
     C                   MOVEL     'SED'         KMESSAGE3
     C                   MOVEL     DPRN          KMESSAGE9
     C                   MOVE      '9999999'     KMESSAGE16
     C                   EXSR      SR_GetMessage
      * Agency
     C                   EVAL      TAGEN = *BLANKS
      * Invalid File Indicator
     C                   EVAL      TINVAL = 'N'
      * File Indicator
     C                   EVAL      TFILE = 'W'
      * Deleted WI/WO Indicator
     C     WIWO_RECI     IFEQ      '*'
     C     WIWO_RECI     OREQ      'C'
     C                   MOVE      'D'           TDELET
     C                   ELSE
     C                   MOVE      ' '           TDELET
     C                   ENDIF
      *
      * Only write record if Movment type is 'WI' or 'WO'.
     C     TTYPE         IFEQ      'WI'
     C     TTYPE         OREQ      'WO'
     C                   WRITE     SETRAND0
     C                   ENDIF
      *
      * If WI/WO Ref or FO ID entered one record has been read so want to exit the loop.
     C     D2WIWO        IFNE      *BLANKS
     C     D2FRID        ORNE      *BLANKS
     C                   MOVE      *ON           *IN60
     C                   ELSE
     C                   READ      DPTMVDL2                               60
     C                   ENDIF
      *
     C     END_DP_READ   TAG
     C                   ENDDO
      *
      * Read all records on the Depot Movements Invalid file and
      * write a record on temporary file SETRANPD
     C     *LOVAL        SETLL     SEIDPMVL0
     C                   READ      SEIDPMVD0                              60
     C     *IN60         DOWNE     *ON
      *
      * Clear output fields on SETRANPD
     C                   CLEAR                   SETRAND0
      *
      * Only process record if Trade date is between entered Trade Date From
      * and Rundate or Trade Date To if entered.
     C     DDACTN        IFEQ      'I'
     C                   MOVEL     DDDMTD        ZDATE
     C                   CALL      'ZDATE1'
     C                   PARM                    ZERR              7
     C                   PARM                    ZDATE
     C                   PARM                    ZDATFM
     C                   PARM                    ZDAYNO            5 0
     C                   Z-ADD     ZDAYNO        TTRDT
      *
     C     TTRDT         IFLT      ZDAYNOF
     C     TTRDT         ORGT      ZDAYNOT
     C     D2TRDTT       ANDNE     *BLANKS
     C                   GOTO      NEXT_DP_READ
     C                   ENDIF
     C                   ELSE
     C                   GOTO      NEXT_DP_READ
     C                   ENDIF
      * Move fields to ouput file fields.
      * Trade No./DVP No.
     C                   EVAL      TTRNO = 0
      * WI/WO No.
     C                   MOVE      DDDPRN        TWIWO
      * Front Office ID
     C                   EVAL      TFRID = FOFFID
      * Status
      * CHAIN SEMVTSPD
     C     DDDPRN        CHAIN     SEMVTSL7                           85
     C     *IN85         IFEQ      *OFF
     C                   EVAL      TSTAT = TMSWSC
     C                   ELSE
     C                   EVAL      TSTAT = *BLANKS
     C                   ENDIF
      * Branch
     C                   EVAL      TBRCH = DDDPBA
      * Counterparty
     C     DDCPTY        IFNE      *BLANKS
     C                   MOVE      DDCPTY        @@CUST
     C                   EXSR      SRCUST
     C     @RTCD         IFNE      *BLANKS
     C*****              Z-ADD     0             TCTPY                                       CSD027A
     C                   EVAL      TCTPY = *blanks                                           CSD027A
     C                   EVAL      TCTPYN = *BLANKS
     C                   ELSE
     C                   MOVE      BBCUST        TCTPY
     C                   EVAL      TCTPYN = BBCSSN
     C                   ENDIF
     C                   ENDIF
     C
      * Customer
     C     DDDPBN        IFNE      *BLANKS
     C                   MOVE      DDDPBN        @@CUST
     C                   EXSR      SRCUST
     C     @RTCD         IFNE      *BLANKS
     C*****              Z-ADD     0             TCUSN                                       CSD027A
     C                   EVAL      TCUSN = *blanks                                           CSD027A
     C                   EVAL      TCUSNN = *BLANKS
     C                   ELSE
     C                   MOVE      BBCUST        TCUSN
     C                   EVAL      TCUSNN = BBCSSN
     C                   ENDIF
     C                   ENDIF
      * Custodian
     C     DDDEPOT       IFNE      *BLANKS
     C                   MOVE      DDDEPOT       @@CUST
     C                   EXSR      SRCUST
     C     @RTCD         IFNE      *BLANKS
     C*****              Z-ADD     0             TCUST                                       CSD027A
     C                   EVAL      TCUST = *blanks                                           CSD027A
     C                   EVAL      TCUSTN = *BLANKS
     C                   ELSE
     C                   MOVE      BBCUST        TCUST
     C                   EVAL      TCUSTN = BBCSSN
     C                   ENDIF
     C                   ENDIF
      * Order Number
     C                   EVAL      TORDE = 0
      * Bulk Reference
     C                   MOVE      *BLANKS       TBLKR
      * Trade Date
     C                   CALL      'ZDATE2'
     C                   PARM                    TTRDT
     C                   PARM                    ZDATFM
     C                   PARM                    ZDATE
     C                   PARM                    WQ0004
     C                   MOVEL     ZDATE         TTRDTMM
     C                   MOVE      WQ0004        TTRDTMMM
      * Value Date
     C                   MOVEL     DDDATE        ZDATE
     C                   CALL      'ZDATE1'
     C                   PARM                    ZERR              7
     C                   PARM                    ZDATE
     C                   PARM                    ZDATFM
     C                   PARM                    ZDAYNO            5 0
     C                   Z-ADD     ZDAYNO        TVLDT
     C                   CALL      'ZDATE2'
     C                   PARM                    TVLDT
     C                   PARM                    ZDATFM
     C                   PARM                    ZDATE
     C                   PARM                    WQ0004
     C                   MOVE      WQ0004        TVLDTMMM
      * Trade Type
     C                   EVAL      TTYPE = DDDPMV
      * Security
     C                   EVAL      TSETY = DDDPSS
      * Security ISIN code
     C     DDDPSS        CHAIN     SECTY                              89
     C     *IN89         IFEQ      *OFF
     C                   EVAL      TISIN = ISIN
     C                   ENDIF
      * Nominal Decimal places
     C                   MOVE      NMDP          TNMDP
      * Nominal
     C                   MOVE      DDDPNA        ZFIELD
     C                   Z-ADD     NMDP          ZADEC
     C     15            SUB       NMDP          ZADIG
     C                   CALL      'ZALIGN'
     C                   PARM                    ZRTN              7
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
     C                   PARM                    ZAFLD            16
      *
     C                   MOVE      ZAFLD         TNOML
      * Countervalue
     C                   EVAL      TCTVL = 0
      * Currency
     C                   EVAL      TCCCY = *BLANKS
      * Message Send/Ack
     C                   MOVEL     'SED'         KMESSAGE3
     C                   MOVEL     DDDPRN        KMESSAGE9
     C                   MOVE      '9999999'     KMESSAGE16
     C                   EXSR      SR_GetMessage
      * Agency
     C                   EVAL      TAGEN = *BLANKS
      * Invalid File Indicator
     C                   EVAL      TINVAL = 'Y'
      * File Indicator
     C                   EVAL      TFILE = 'W'
      *
     C                   WRITE     SETRAND0
      *
     C     NEXT_DP_READ  TAG
     C                   READ      SEIDPMVD0                              60
     C                   ENDDO
      *
      * If Trade/DVP ref or FO ID entered then CHAIN to DVP/RVP file otherwise
      * Read all records on the DVP/RVP file greater than From date and
      * up to rundate or To date if entered.
     C     D2TRAD        IFNE      *BLANKS
     C     D2TRAD        CHAIN     SEDVPRL0                           60
     C                   ELSE
     C     D2FRID        IFNE      *BLANKS
     C     D2FRID        CHAIN     SEDVPRL4                           60
     C                   ELSE
      * If Trade Ref blank but WIWO Ref not blank then
      * do not read the DVP/RVP file.
     C     D2WIWO        IFNE      *BLANKS
     C                   MOVE      *ON           *IN60
     C                   ELSE
     C     ZDAYNOF       SETLL     SEDVPRL1
     C                   READ      SEDVPRL1                               60
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     *IN60         DOWNE     *ON
      *
      * If Trade Date To is entered then do not read rest of file.
     C     D2TRDTT       IFNE      *BLANKS
     C     DVTDAT        ANDGT     ZDAYNOT
     C                   MOVE      *ON           *IN60
     C                   GOTO      END_DV_READ
     C                   ENDIF
      *
      * Clear output fields on SETRANPD
     C                   CLEAR                   SETRAND0
      *
      * Move fields to ouput file fields.
      * Trade No./DVP No.
     C                   MOVE      DVREF         TTRNO
      * WI/WO No.
     C                   EVAL      TWIWO = 0
      * Front Office ID
     C                   EVAL      TFRID = DVFRNT
      * Status
      * CHAIN SEMVTSPD
     C     DVREF         CHAIN     SEMVTSL7                           85
     C     *IN85         IFEQ      *OFF
     C                   EVAL      TSTAT = TMSWSC
     C                   ELSE
     C                   EVAL      TSTAT = *BLANKS
     C                   ENDIF
      * Branch
     C                   EVAL      TBRCH = DVBRCA
      *
      * Counterparty
     C                   MOVE      *BLANKS       @@CUST
     C                   MOVEL     DVCPTY        @@CUST
     C                   EXSR      SRCUST
     C     @RTCD         IFEQ      *BLANKS
     C                   EVAL      TCTPYN = BBCSSN
     C                   MOVE      BBCUST        TCTPY
     C                   ELSE
     C*****              Z-ADD     0             TCTPY                                       CSD027A
     C                   EVAL      TCTPY = *blanks                                           CSD027A
     C                   MOVEL     DVCPTY        TCTPYN
     C                   ENDIF
      * Customer
     C                   MOVE      *BLANKS       @@CUST
     C                   MOVEL     DVCNUM        @@CUST
     C                   EXSR      SRCUST
     C     @RTCD         IFEQ      *BLANKS
     C                   EVAL      TCUSNN = BBCSSN
     C                   MOVE      BBCUST        TCTPY
     C                   ELSE
     C*****              Z-ADD     0             TCTPY                                       CSD027A
     C                   EVAL      TCTPY = *blanks                                           CSD027A
     C                   MOVEL     *BLANKS       TCTPYN
     C                   ENDIF
      * Custodian
     C                   EVAL      TCUST = DVOUDP
      * Customer Shortname of Custodian
     C*****TCUST         IFNE      0                                                         CSD027A
     C     TCUST         IFNE      *blanks                                                   CSD027A
     C                   MOVE      *BLANKS       @@CUST
     C                   MOVE      TCUST         @@CUST
     C                   EXSR      SRCUST
     C                   EVAL      TCUSTN = BBCSSN
     C                   ENDIF
      * Order Number
     C                   EVAL      TORDE = 0
      * Bulk Reference
     C                   MOVE      *BLANKS       TBLKR
      * Trade Date
     C                   EVAL      TTRDT = DVTDAT
     C                   CALL      'ZDATE2'
     C                   PARM                    TTRDT             5 0
     C                   PARM                    ZDATFM            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    WQ0004            7
     C                   MOVEL     ZDATE         TTRDTMM
     C                   MOVEL     WQ0004        TTRDTMMM
      * Value Date
     C                   EVAL      TVLDT = DVVDAT
     C                   CALL      'ZDATE2'
     C                   PARM                    TVLDT             5 0
     C                   PARM                    ZDATFM            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    WQ0004            7
     C                   MOVEL     WQ0004        TVLDTMMM
      * Trade Type
     C                   EVAL      TTYPE = DVTYPE
      * Security
     C                   EVAL      TSETY = DVSESN
      * Security ISIN code
     C     TDSS          CHAIN     SECTY                              89
     C     *IN89         IFEQ      *OFF
     C                   EVAL      TISIN = ISIN
     C                   ENDIF
      * Nominal Decimal places
     C                   MOVE      NMDP          TNMDP
      * Nominal
     C                   EVAL      TNOML = DVNOML
      * Countervalue
     C                   EVAL      TCTVL = DVNCVL
      * Currency
     C                   EVAL      TCCCY = DVNMCY
      * Message Send/Ack
     C                   MOVEL     'SEV'         KMESSAGE3
     C                   MOVEL     DVREF         KMESSAGE9
     C                   MOVE      '9999999'     KMESSAGE16
     C                   EXSR      SR_GetMessage
      * Agency
     C                   EVAL      TAGEN = ' '
      * Invalid File Indicator
     C                   EVAL      TINVAL = 'N'
      * File Indicator
     C                   EVAL      TFILE = 'D'
      * Deleted Trade Indicator
     C     Trad_RECI     IFEQ      '*'
     C     Trad_RECI     OREQ      'C'
     C                   MOVE      'D'           TDELET
     C                   ELSE
     C                   MOVE      ' '           TDELET
     C                   ENDIF
      *
     C                   WRITE     SETRAND0
      *
      * If Trade/DVP Ref entered one record has been read so want to exit the loop.
     C     D2TRAD        IFNE      *BLANKS
     C     D2FRID        ORNE      *BLANKS
     C                   MOVE      *ON           *IN60
     C                   ELSE
     C                   READ      SEDVPRL1                               60
     C                   ENDIF
      *
     C     END_DV_READ   TAG
     C                   ENDDO
      *
      * DVP invalid file read.
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * Sr_CreateFileL - Build new file from all linked records.      *
      *                                                               *
      * Calls     -                                                   *
      *                                                               *
      * Called by - Main                                              *
      *                                                               *
      *****************************************************************
     C     Sr_CreateFileLBEGSR
     C
     C     KTR_SEC_OR    KLIST
     C                   KFLD                    KSETY            10
     C                   KFLD                    KORDE             6 0
      *
     C     KTR_SEC_BR    KLIST
     C                   KFLD                    KSETY
     C                   KFLD                    KBLKR             6
      *
      * If Order Number is not blank then read all trades with same
      * security and order number if bulk reference isn't blank, otherwise
      * read all with same security and bulk reference.
 
     C     D1ORDE        IFNE      *BLANKS
     C     D1BLKR        IFEQ      *BLANKS
     C                   MOVEL     D1SETY        KSETY
     C                   MOVEL     D1ORDE        KORDE
     C     KTR_SEC_OR    SETLL     TRADSDLB
     C     KTR_SEC_OR    READE     TRADSDLB                               60
     C                   MOVE      *ON           *IN71
     C                   MOVEL     D1SETY        D2SESN
     C                   MOVEL     D1ORDE        D2ODER
     C                   ELSE
     C                   MOVEL     D1SETY        KSETY
     C                   MOVEL     D1BLKR        KBLKR
     C     KTR_SEC_BR    SETLL     TRADSDLC
     C     KTR_SEC_BR    READE     TRADSDLC                               60
     C                   MOVE      *ON           *IN72
     C                   MOVEL     D1SETY        D2SESN
     C                   MOVEL     D1BLKR        D2BLKR
     C                   ENDIF
     C                   ENDIF
      *
     C     *IN60         DOWNE     *ON
      *
      * Clear output fields on SETRANPD
     C                   CLEAR                   SETRAND0
      *
      * Move fields to ouput file fields.
      * Trade No./DVP No.
     C                   MOVE      TDRF          TTRNO
      * WI/WO No.
     C                   EVAL      TWIWO = 0
      * Front Office ID
     C                   EVAL      TFRID = FRNT
      * Status
      * CHAIN SEMVTSPD
     C     TDRF          CHAIN     SEMVTSL7                           85
     C     *IN85         IFEQ      *OFF
     C                   EVAL      TSTAT = TMSWSC
     C                   ELSE
     C                   EVAL      TSTAT = *BLANKS
     C                   ENDIF
      * Branch
     C                   EVAL      TBRCH = TDBA
      *
      * Counterparty and Customer
      * Check TCNR for classifiaction. If 'M' move to Counterparty
      * but if 'S' or 'D' move to Customer.
     C                   MOVE      *BLANKS       @@CNUM
     C                   MOVE      *BLANKS       @@CUST
     C                   MOVE      TCNR          @@CNUM            6
     C                   MOVE      TCNR          @@CUST           10
     C                   EXSR      SRSECS
     C     BFCLAS        IFEQ      'M'
     C*****              EVAL      TCUSN = 0                                                 CSD027A
     C                   EVAL      TCUSN = *blanks                                           CSD027A
     C                   EVAL      TCTPY = TCNR
     C                   EXSR      SRCUST
     C                   EVAL      TCTPYN = BBCSSN
     C                   ELSE
     C*****              EVAL      TCTPY = 0                                                 CSD027A
     C                   EVAL      TCTPY = *blanks                                           CSD027A
     C                   EVAL      TCUSN = TCNR
     C                   EXSR      SRCUST
     C                   EVAL      TCUSNN = BBCSSN
     C                   ENDIF
      * Custodian
     C     TDTP          IFEQ      'TP'
     C                   EVAL      TCUST = DELT
     C                   ELSE
     C                   EVAL      TCUST = DELF
     C                   ENDIF
      * Customer Shortname of Custodian
     C*****TCUST         IFNE      0                                                         CSD027A
     C     TCUST         IFNE      *blanks                                                   CSD027A
     C                   MOVE      *BLANKS       @@CUST
     C                   MOVE      TCUST         @@CUST
     C                   EXSR      SRCUST
     C                   EVAL      TCUSTN = BBCSSN
     C                   ENDIF
      * Order Number
     C                   EVAL      TORDE = ORDE
      * Bulk Reference
     C                   EVAL      TBLKR = BLKR
      * Trade Date
     C                   EVAL      TTRDT = TDDT
     C                   CALL      'ZDATE2'
     C                   PARM                    TTRDT             5 0
     C                   PARM                    ZDATFM            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    WQ0004            7
     C                   MOVEL     ZDATE         TTRDTMM
     C                   MOVEL     WQ0004        TTRDTMMM
      * Value Date
     C                   EVAL      TVLDT = TDVD
     C                   CALL      'ZDATE2'
     C                   PARM                    TVLDT             5 0
     C                   PARM                    ZDATFM            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    WQ0004            7
     C                   MOVEL     WQ0004        TVLDTMMM
      * Trade Type
     C                   EVAL      TTYPE = TDTP
      * Security
     C                   EVAL      TSETY = TDSS
      * Security ISIN code
     C     TDSS          CHAIN     SECTY                              89
     C     *IN89         IFEQ      *OFF
     C                   EVAL      TISIN = ISIN
     C                   ENDIF
      * Nominal Decimal places
     C                   MOVE      NMDP          TNMDP
      * Nominal
     C                   EVAL      TNOML = NOML
      * Countervalue
     C                   EVAL      TCTVL = TCTR
      * Currency
     C                   EVAL      TCCCY = TNMC
      * Message Send/Ack
     C                   MOVEL     'SET'         KMESSAGE3
     C                   MOVEL     TDRF          KMESSAGE9
     C                   MOVE      '9999999'     KMESSAGE16
     C                   EXSR      SR_GetMessage
      * Agency
     C                   EVAL      TAGEN = ATRD
      * Invalid File Indicator
     C                   EVAL      TINVAL = 'N'
      * File Indicator
     C                   EVAL      TFILE = 'T'
      * Deleted Trade Indicator
     C     D1ORDE        IFNE      *BLANKS
     C     D1BLKR        ANDEQ     *BLANKS
     C     Trad_RECIB    IFEQ      '*'
     C     Trad_RECIB    OREQ      'C'
     C                   MOVE      'D'           TDELET
     C                   ELSE
     C                   MOVE      ' '           TDELET
     C                   ENDIF
     C                   ELSE
     C     Trad_RECIC    IFEQ      '*'
     C     Trad_RECIC    OREQ      'C'
     C                   MOVE      'D'           TDELET
     C                   ELSE
     C                   MOVE      ' '           TDELET
     C                   ENDIF
     C                   ENDIF
      *
     C                   WRITE     SETRAND0
      *
     C     D1ORDE        IFNE      *BLANKS
     C     D1BLKR        ANDEQ     *BLANKS
     C     KTR_SEC_OR    READE     TRADSDLB                               60
     C                   ELSE
     C     KTR_SEC_BR    READE     TRADSDLC                               60
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * SR_Val_Select - Validate selection fields                     *
      *                                                               *
      * Calls     -                                                   *
      *                                                               *
      * Called by -                                                   *
      *                                                               *
      *****************************************************************
     C     SR_Val_Select BEGSR
      *
      ** Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      *
      * Output Header. Do not load subfile until details entered and correct.
     C                   MOVE      *ON           *IN65
     C                   MOVE      *OFF          *IN66
      *
      ** Set Up Function Key Text - Standard Functions
     C                   MOVEA     TXT(1)        ##CTX1
     C     *IN65         DOUEQ     *OFF
      *
      * Do not show screen on first time through the loop.
     C     *IN66         IFEQ      *ON
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C     *IN70         IFEQ      *OFF
     C                   EXFMT     #SFLCTL
     C                   MOVE      *OFF          *IN73
     C                   ELSE
     C                   EXFMT     #SFLCTL2
     C                   MOVE      *ON           *IN73
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      *ON           *IN66
      *
      ** Setof record error indicators
     C                   MOVEA     WKIND0        *IN(33)
      *
      ** Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      *
     C     *IN03         IFEQ      *ON
     C                   GOTO      F3END
     C                   ELSE
      *
      * If 2 of Trade ref, WI/WO ref and FO ID entered error
     C     D2TRAD        IFNE      *BLANKS
     C     D2WIWO        ANDNE     *BLANKS
     C     D2TRAD        ORNE      *BLANKS
     C     D2FRID        ANDNE     *BLANKS
     C     D2WIWO        ORNE      *BLANKS
     C     D2FRID        ANDNE     *BLANKS
      *
     C     D2TRAD        IFNE      *BLANKS
     C                   MOVE      *ON           *IN33
     C                   ENDIF
     C     D2WIWO        IFNE      *BLANKS
     C                   MOVE      *ON           *IN34
     C                   ENDIF
     C     D2FRID        IFNE      *BLANKS
     C                   MOVE      *ON           *IN35
     C                   ENDIF
      *
      ** Send message 'Only one of Trade/DVP Ref, WI/WO Ref or FO ID may be entered.'
     C                   MOVEL     'SE10050'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      ENDVAL
     C                   ENDIF
      *
      * If 1 of Trade ref, WI/WO ref and FO ID entered but another
      * selection field as well then clear the other selection field(s).
     C     SELECT1       IFNE      *BLANKS
     C     SELECT2       ANDNE     *BLANKS
     C                   MOVE      *BLANKS       SELECT2
     C                   ENDIF
      *
      * If 1 of Trade ref, WI/WO ref and FO ID entered and no other
      * skip rest of validation blanking out the Trade date To and From fields
     C     SELECT1       IFNE      *BLANKS
     C     SELECT2       ANDEQ     *BLANKS
     C                   MOVE      *OFF          *IN65
     C                   Z-ADD     0             ZDAYNOF
     C                   Z-ADD     0             ZDAYNOT
     C                   GOTO      ENDVAL
     C                   ENDIF
      *
      * Convert the entered Trade date From/To into midas day no.
     C     D2TRDTF       IFNE      *BLANKS
     C                   MOVE      D2TRDTF       ZDATE
     C                   CALL      'ZDATE1'
     C                   PARM                    ZERR              7
     C                   PARM                    ZDATE
     C                   PARM                    ZDATFM
     C                   PARM                    ZDAYNO            5 0
     C                   Z-ADD     ZDAYNO        ZDAYNOF           5 0
     C     ZERR          IFNE      *BLANKS
      ** Send message 'Date Invalid'
     C                   MOVE      *ON           *IN36
     C                   MOVEL     'SEA0400'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      ENDVAL
     C                   ENDIF
      *
      * Error if Date From is not entered and none of Trade/DVP Ref,
      * WIWO Ref or FO ID are entered.
     C                   ELSE
     C     SELECT1       IFEQ      *BLANKS
      * Send error message 'Date must be entered'
     C                   MOVE      *ON           *IN36
     C                   MOVEL     'SE10051'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      ENDVAL
     C                   ENDIF
     C                   ENDIF
      *
     C     D2TRDTT       IFNE      *BLANKS
     C                   MOVE      D2TRDTT       ZDATE
     C                   CALL      'ZDATE1'
     C                   PARM                    ZERR              7
     C                   PARM                    ZDATE
     C                   PARM                    ZDATFM
     C                   PARM                    ZDAYNO            5 0
     C                   Z-ADD     ZDAYNO        ZDAYNOT           5 0
     C     ZERR          IFNE      *BLANKS
      ** Send message 'Date Invalid'
     C                   MOVE      *ON           *IN37
     C                   MOVEL     'SEA0402'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      ENDVAL
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     0             ZDAYNOT
     C                   ENDIF
      *
      * Error if Trade Date From is greater than the Trade Date To if entered.
     C     D2TRDTT       IFNE      *BLANKS
     C     ZDAYNOF       ANDGT     ZDAYNOT
      *
      ** Send message 'Date Invalid'
     C                   MOVE      *ON           *IN36
     C                   MOVEL     'SEA0403'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      ENDVAL
     C                   ENDIF
      *
      * Error if Trade Date From is before the rundate - backvalued period.
     C     BJRDNB        SUB       BVBVP         W#NUM5            5 0
     C     ZDAYNOF       IFLT      W#NUM5
      ** Send message 'From date must not be before backvalued period'
     C                   MOVE      *ON           *IN36
     C                   MOVEL     'SE10052'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      ENDVAL
     C                   ENDIF
      *
      * Error if countervalue entered but invalid amount or
      * if only one of countervalue amount and countervalue currency
      * is entered.
     C     D2CTVL        IFNE      *BLANKS
     C     D2CCCY        ORNE      *BLANKS
     C
     C     D2CTVL        IFNE      *BLANKS
     C     D2CCCY        ANDEQ     *BLANKS
     C     D2CTVL        OREQ      *BLANKS
     C     D2CCCY        ANDNE     *BLANKS
      *
      ** Send message 'Countervalue invalid - both fields must be entered'.
     C                   MOVE      *ON           *IN45
     C                   MOVEL     'SE10053'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      ENDVAL
     C                   ENDIF
     C
      * Obtain no decimals for currency entered.
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      D2CCCY        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   MOVE      D2CTVL        ZFIELD
     C                   Z-ADD     A6NBDP        ZADEC
     C     15            SUB       A6NBDP        ZADIG
     C                   CALL      'ZALIGN'
     C                   PARM                    ZRTN              7
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
     C                   PARM                    ZAFLD            16
      *
     C     ZRTN          IFNE      *BLANKS
      ** Send message 'Countervalue invalid'
     C                   MOVE      *ON           *IN45
     C                   MOVEL     'SE10053'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      ENDVAL
     C                   ENDIF
     C                   MOVE      ZAFLD         Saved_D2CTVL     16 0
      *
     C                   ENDIF
      *
     C     D2NOML        IFNE      *BLANKS
     C                   MOVE      D2NOML        ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     15            ZADIG
     C                   CALL      'ZALIGN'
     C                   PARM                    ZRTN              7
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
     C                   PARM                    ZAFLD            16
      *
     C     ZRTN          IFNE      *BLANKS
      ** Send message 'Nominal invalid'
     C                   MOVE      *ON           *IN44
     C                   MOVEL     'SE10058'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      ENDVAL
     C                   ENDIF
     C                   ENDIF
      *
      * See if '?' entered for any of Counterparty, Custodian, Customer,
      * Branch or Security.
     C     D2CTPY        IFEQ      '?'
     C                   CALL      'SD0010S'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      *BLANK        KEY2              6
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     KEY2          D2CTPY
     C                   ELSE
     C                   MOVE      *BLANKS       D2CTPY
     C                   ENDIF
     C                   ENDIF
      *
     C     D2CUST        IFEQ      '?'
     C                   CALL      'SD0010S'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      *BLANK        KEY2              6
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     KEY2          D2CUST
     C                   ELSE
     C                   MOVE      *BLANKS       D2CUST
     C                   ENDIF
     C                   ENDIF
      *
     C     D2CUSN        IFEQ      '?'
     C                   CALL      'SD0010S'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      *BLANK        KEY2              6
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     KEY2          D2CUSN
     C                   ELSE
     C                   MOVE      *BLANKS       D2CUSN
     C                   ENDIF
     C                   ENDIF
      *
     C     D2SETY        IFEQ      '?'
     C                   MOVEL     D2SETY        @SESN            10
      *
     C                   CALL      'SE0043'
     C                   PARM      'E'           PACODE            1
     C                   PARM                    @SESN            10
      *
     C     @SESN         IFNE      *BLANKS
     C                   MOVEL     @SESN         D2SETY
     C                   ELSE
     C                   MOVE      *BLANKS       D2SETY
     C                   ENDIF
     C                   ENDIF
      *
     C     D2BRCH        IFEQ      '?'
      * Branch Code
     C                   MOVEL     D2BRCH        @BRCH             3
     C                   CALL      'SD0061S'
     C                   PARM                    @RTCD
     C                   PARM                    @BRCH
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     @BRCH         D2BRCH
     C                   ELSE
     C                   MOVE      *BLANKS       D2BRCH
     C                   ENDIF
     C                   ENDIF
      *
      *
      * If branch is blank then default back to User's default branch
     C     D2BRCH        IFEQ      *BLANKS
     C                   MOVE      DBRN          D2BRCH
     C                   ENDIF
      *
      * Check Branch is valid if ALL not entered
B1   C     D2BRCH        IFNE      'ALL'
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    D2BRCH
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      *
B2   C     @RTCD         IFNE      *BLANKS
     C                   MOVE      *ON           *IN43
     C                   MOVEL     'SEM1034'     ZAMSID
     C                   EXSR      ZASNMS
     C
X2   C                   ELSE
 
      * Check user is authorised to valid branch
      *
     C                   CALL      'ZVBBU'
     C                   PARM      D2BRCH        @ZBR              3
     C                   PARM                    @ERR              1 0
B3   C     @ERR          IFEQ      1
     C     @ERR          OREQ      2
     C                   SETON                                        43
     C                   MOVEL     'SE06007'     ZAMSID
     C                   EXSR      ZASNMS
E3   C                   ENDIF
 
E2   C                   ENDIF
 
X1   C                   ELSE
      * 'ALL' Entered, check user Authority to Bank level
B2   C     BANK          IFNE      'Y'
     C                   SETON                                        43
     C                   MOVEL     'SE06007'     ZAMSID
     C                   EXSR      ZASNMS
      *
X2   C                   ELSE
      * If ALL entered and user authorised move blanks back to Branch
      * selection field so all branch records will be displayed.
     C                   MOVE      *BLANKS       D2BRCH
E2   C                   ENDIF
 
E1   C                   ENDIF
     C
     C                   ENDIF
      *
     C                   MOVE      *OFF          *IN65
     C     ENDVAL        TAG
     C                   ENDDO
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * SRCUST    - Call AOCUSTR1                                     *
      *                                                               *
      * Calls     -                                                   *
      *                                                               *
      * Called by -                                                   *
      *                                                               *
      *****************************************************************
     C     SRCUST        BEGSR
 
     C                   CALL      'AOCUSTR1'
     C                   PARM      *blanks       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      @@CUST        @CUST            10
     C                   PARM      *BLANKS       @CNST             7
     C     SDCUST        PARM      SDCUST        DSSDY
     C
      ** Database Error, do not have. output blanks if customer not
      ** found
     C
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * SRSECS    - Call AOSECSR0                                     *
      *                                                               *
      * Calls     -                                                   *
      *                                                               *
      * Called by -                                                   *
      *                                                               *
      *****************************************************************
     C     SRSECS        BEGSR
 
     C                   CALL      'AOSECSR0'
     C                   PARM      *Blanks       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      @@CNUM        @CNUM             6
     C     SDSECS        PARM      SDSECS        DSFDY
 
      ** Database Error
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDSECSPD'    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   MOVEL     @CNUM         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
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
     C                   MOVEL     'SEUSRMSG'    ZAMSGF
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
      * Sr_GetMessage - Get message status                            *
      *                                                               *
      * Calls     -                                                   *
      *                                                               *
      * Called by - SR_Create_File, SR_CreateFileL                    *
      *                                                               *
      *****************************************************************
     C     Sr_GetMessage BEGSR
      *
     C     KMessage      SETGT     MESSAGES11
     C                   READP     MESSAGES11                             62
      *
     C                   MOVEL     TRANS00001    KMESSAGEB
      *
     C     *IN62         DOWNE     *ON
     C     KMESSAGE1_9   ANDEQ     KMESSAGEB1_9
      *
     C     EXTER00001    IFEQ      'MT540     '
     C     EXTER00001    OREQ      'MT541     '
     C     EXTER00001    OREQ      'MT542     '
     C     EXTER00001    OREQ      'MT543     '
     C     STATUS        ANDNE     'D'
     C                   MOVE      STATUS        TSTAK
     C                   SETON                                        62
     C                   ELSE
     C                   MOVE      *BLANKS       TSTAK
     C                   ENDIF
     C                   READP     MESSAGES11                             62
     C                   MOVEL     TRANS00001    KMESSAGEB
 
     C                   ENDDO
     C
     C                   ENDSR
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
      ** Set up copyright parameter
     C                   MOVEA     CPY@          CPY2@
      *
     C     *DTAARA       DEFINE                  SESDS
     C     *LOCK         IN        SESDS
      ** Initialize program name
     C                   MOVEL     'SE4400'      DBPGM
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
     C                   Z-ADD     4             ##SFPG            3 0          SFLPAG
     C                   Z-ADD     1             ##SFRC
      *
      ** Maximum record number
     C                   Z-ADD     *ZERO         ##RRMX
      *
      ** Scan limit
     C                   Z-ADD     9999          W0SLM             5 0
      *
      ** Subfile pages
     C                   Z-ADD     1             W0SPG             3 0
      *
      ** Processed Subfile record
     C                   Z-ADD     0             W0RR0             4 0
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
      * Default the From and To Trade Dates to be Rundate.
     C                   CALL      'ZDATE2'
     C                   PARM                    RDNB
     C                   PARM                    ZDATFM
     C                   PARM                    ZDATE
     C                   PARM                    WQ0004
     C                   MOVEL     ZDATE         D2TRDTF
     C                   MOVEL     ZDATE         D2TRDTT
     C
 
      * Obtain User's default branch
     C                   CALL      'AOUSERR0'
     C                   PARM                    @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    DDUSR
     C     USER          PARM      USER          DSSDY
 
     C                   MOVE      DBRN          D2BRCH
      *
      * Initialise indicator to show Main subfile is to be built
     C                   MOVE      *OFF          *IN70
      *
      ** Setof record error indicators
     C                   MOVE      *ALL'0'       WKIND0           14
      *
      ** Access Bank Details
      *  (database error handling done in access program)
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Access Securities Trading details via access program
      *  (database error handling done in access program)
     C                   CALL      'AOSTRDR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDSTRD        PARM      SDSTRD        DSSDY
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
F3=Exit
F3=Exit M=Messages T=Transaction S=Movement Status P=Security L=Linked trades
F3=Exit F12=Previous M=Messages T=Transaction S=Movement Status P=Security
**CTDATA CPY@
(c) Finastra International Limited 2002
