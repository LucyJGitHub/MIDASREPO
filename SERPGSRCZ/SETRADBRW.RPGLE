     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade browse')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Module                                    *
      *                                                               *
      *  SETRADBRW - SECURITIES TRADES BROWSE                         *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One display a list of trades for selection,       *
      *             the other picks off the selection made.           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. BU13364            Date 15Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE065             Date 08Nov04               *
      *                 CSE071             Date 19Jul05               *
      *                 211800             Date 12Nov02               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3122            Date 17Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 214408             Date 16Apr03               *
      * Midas Release 4.01.03 ----------------------------------------*
      * Midas Release 4.01.02 ----------------------------------------*
      *                 202981             Date 28Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 196918             Date 19Feb02               *
      *                 196903             Date 28Aug01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE016             Date 10Jan01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 186044             Date 08Nov00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CSE019             Date 24Feb00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP051             Date 16Nov99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CPB001             Date 01Jun99               *
      *                 CSE010             Date 21Jun99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 154653             Date 02Feb99               *
      *                 CAP004             Date 01Sep98               *
      *                 CAP003  *CREATE    Date 01Jun98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG13364 - Database error upon pressing Enter key in Trade   *
      *             Details Enquiry                                   *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE065 - Cost Yield Amort. on Mortgage Backed Assets         *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  211800 - If customer is flagged as 'Closed' Customer is not  *
      *           filled up.                                          *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  214408 - TRDN selection, no refresh on F11 key.  Toggle (F11)*
      *           will display the screen on the same subfile page,   *
      *           and NOT on the last subfile page read.              *
      *  202981 - if module is called with action code 'E' only       *
      *           option 'E' should be possible.                      *
      *  196918 - Trade selection function key F15 in Trade Input     *
      *           Maintenance display trades in different colors      *
      *           depending on their status:                          *
      *             * White : Trade settled or cancelled              *
      *             * Blue  : Trade authorised                        *
      *             * Red   : Trade not authorised                    *
      *  196903 - Manage the status of the trade                      *
      *  CSE016 - Extended Security Descriptions                      *
      *  186044 - Import variables changed to exports                 *
      *  CSE019 - SE Trades Selection Enhancements                    *
      *  CAP051 - Automatic Authorisation (SE Trades Part)            *
      *           Recompiled due to database changes                  *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to database changes                  *
      *  CSE010 - SE Transactions Enhancements                        *
      *  154653 - Action code 'P' & 'Y' on browse not allowed sometimes
      *  CAP004 - API's Phase 3.                                      *
      *           Allow browse by Front Office Id.                    *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FSETRADBDF CF   E             WORKSTN
     F                                     SFILE(SETRADS1:@@RRN)
     F                                     SFILE(SETRADS3:@@RRN)                CAP004
     F                                     SFILE(SETRADS5:@@RRN)                              CSE010
     F                                     SFILE(SETRADS7:@@RRN)                CSE019
     F                                     INFDS(INFDS)                                       214408
      * Trades file
     FTRADS     IF   E           K DISK    INFSR(*PSSR)
 
      * Trades file - by Front Office Id.                                       CAP004
     FSETRADL0  IF   E           K DISK    INFSR(*PSSR)                         CAP004
     F                                     RENAME(TRADSDF:TRADSFO)              CAP004
 
      ** SE Securities File                                                                   CSE010
     FSECTY     IF   E           K DISK    INFSR(*PSSR)                                       CSE010
                                                                                              CSE010
      * Trades requiring autorization
     FTRADTA    IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(TRADSDF:TRADSRA)
                                                                                              CSE010
     FTRADSDL5  IF   E           K DISK    INFSR(*PSSR)                                       CSE010
     FTRADSDL6  IF   E           K DISK    INFSR(*PSSR)                                       CSE010
     FTRADSDL7  IF   E           K DISK    INFSR(*PSSR)                                       CSE010
     FTRADSDL8  IF   E           K DISK    INFSR(*PSSR)                                       CSE010
     FTRADSDL9  IF   E           K DISK    INFSR(*PSSR)                                       CSE010
     FTRADSR    IF   E           K DISK    INFSR(*PSSR)                                       CSE010
     F                                     RENAME(TRADSDF:TRADSRD)                            CSE010
     FSETRADL1  IF   E           K DISK    INFSR(*PSSR)                         CSE019
     F                                     RENAME(TRADSDF:TRADSL1)              CSE019
     FSETRADL2  IF   E           K DISK    INFSR(*PSSR)                         CSE019
     F                                     RENAME(TRADSDF:TRADSL2)              CSE019
      ** Table of field numbers and names                                                     CSE010
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)                                       CSE010
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **------------------------------------------------------------------------              CSE010
      ** The following /COPY line includes the definitions for error and                      CSE010
      ** warning message arrays.                                                              CSE010
      /COPY ZACPYSRC,ERR_ARRAYS                                                               CSE010
      **------------------------------------------------------------------------              CSE010
                                                                                              CSE010
      **------------------------------------------------------------------------              CSE010
      ** The following /COPY line includes the definitions for error and                      CSE010
      ** warning message arrays.                                                              CSE010
     D/COPY ZACPYSRC,APICTLARR                                                                CSE010
      **------------------------------------------------------------------------              CSE010
                                                                                              CSE010
      **------------------------------------------------------------------------              CSE010
      ** The following /COPY line includes the definitions for fields                         CSE010
      ** required by the message handler.                                                     CSE010
     D/COPY ZACPYSRC,MSGHNDDCL                                                                CSE010
      **------------------------------------------------------------------------              CSE010
                                                                                              CSE010
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** EXTERNAL DS FOR BANK DETAILS
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** Securities Trading ICD
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
 
      ** Customer file
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** External DS for Securities Clients File                                              CSE010
     D SDSECS        E DS                  EXTNAME(SDSECSPD)                                  CSE010
     D  QQACCD1      E                     EXTFLD(QQACCD)                                     CGL029
                                                                                              CSE010
      ** Module File                                                                          CSE010
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  CSE010
                                                                                              CSE010
      ** Book Details File                                                      CSE019
     D SDBOOK        E DS                  EXTNAME(SDBOOKPD)                    CSE019
                                                                                CSE019
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
                                                                                211800
     D DSLDY         E DS                  EXTNAME(DSLDY)                       211800
      ** FIRST DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE                      211800
 
     D*EXORDE**********S****************** LIKE(DDTDRF) Import                          CSE010186044
     D EXORDE          S                   LIKE(DDTDRF) Export                                CSE010
     D*@ENDEL**********S**************1****Import                                       CSE010186044
     D @ENDEL          S              1    Export                                             186044
     D DDOPT           S                   LIKE(@OPSEL) Export                                CSE010
     D*FldNameA********S*******************LIKE(FldNameArr) Import                      CSE010186044
     D*MsgIdA**********S*******************LIKE(MsgIdArr) Import                        CSE010186044
     D FldNameA        S                   LIKE(FldNameArr) Export                            186044
     D MsgIdA          S                   LIKE(MsgIdArr) Export                              186044
                                                                                              CSE010
     D WTRDT           S              6A                                                      CSE010
     D WTDRF           S              6A                                                      CSE010
     D WTDSS           S             10A                                                      CSE010
     D WTCNR           S             10A                                                      CSE010
     D WTINC           S              1A                                                      CSE010
     D WSTSI           S              1A                                                      CSE010
     D WORNO           S              6A                                                      CSE010
     D WTDTP           S              2A                                        CSE019
     D WTDVD           S              6A                                        CSE019
     D WTDBK           S              2A                                        CSE019
     D WFRNT           S             20A                                        CSE019
     D WWSTSI          S              1A                                        CSE019
     D WWFMT           S             10A                                        CSE019
     D WSFMT           S             10A                                        CSE019
                                                                                              CSE010
     D DateIn          S              6A                                                      CSE010
     D DaynoOut        S              5P 0                                                    CSE010
     D ErrorFlag       S              1A                                                      CSE010
                                                                                              CSE010
     D FILE            S              9A                                                      CSE010
                                                                                              CSE010
     D WNewSel         S              1A                                                      CSE010
                                                                                              CSE010
     D Ix              S              3P 0                                                    CSE010
                                                                                              CSE010
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
                                                                                              CSE016
      ** Parameter declaration of ZSDESC                                                      CSE016
                                                                                              CSE016
     D PSRPN           S             20A                                                      CSE016
     D PSFN1           S             30A                                                      CSE016
     D PSFN2           S             30A                                                      CSE016
     D PRSFD           S              1A                                                      CSE016
     D PRNME           S             41A                                                      CSE016
     D PFNM1           S             30A                                                      CSE016
     D PFNM2           S             50A                                                      CSE016
     D PFNM3           S             50A                                                      CSE016
      ** Data structure for screen management @#SFRC : Subfile Record                         214408
     D INFDS         E DS                  EXTNAME(Y2I#DSP)                                   214408
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Initialization
      *
     C                   EXSR      INIT
      *
      ** Build Sub-file
      *
     C     @BDSFL        IFEQ      'Y'
      *                                                                         CAP004
      **  If First time in or subfile by Midas trade number was previously      CAP004
      **  being run, then build subfile keyed on Midas trade number.            CAP004
      **  Stay in loop while F11 toggle key is used.                            CAP004
      *                                                                         CAP004
     C     WTRAD         IFNE      'F'                                          CAP004
     C     *INKK         DOUEQ     '0'                                          CAP004
     C                   EXSR      BLDSFL
      *                                                                         CAP004
      **  If F11, switch to Front Office Deal subfile                           CAP004
      *                                                                         CAP004
     C     *INKK         IFEQ      '1'                                          CAP004
     C                   EXSR      BLDSFL2                                      CAP004
     C                   END                                                    CAP004
     C                   END                                                    CAP004
      *
     C                   ELSE                                                   CAP004
      *
      **  If the subfile by Front Office Identifier was previously              CAP004
      **  being run, then build subfile keyed on Front Office ID.               CAP004
      **  Stay in loop while F11 toggle key is used.                            CAP004
      *
     C     *INKK         DOUEQ     '0'                                          CAP004
     C                   EXSR      BLDSFL2                                      CAP004
      *                                                                         CAP004
      **  If F11, switch to Midas Deal Number subfile                           CAP004
      *                                                                         CAP004
     C     *INKK         IFEQ      '1'                                          CAP004
     C                   EXSR      BLDSFL                                       CAP004
     C                   END                                                    CAP004
     C                   END                                                    CAP004
     C                   END                                                    CAP004
     C                   END
      *
      ** Read Subfile Record
      *
     C     @RDSFL        IFEQ      'Y'
     C     @@RRN         ANDGT     0                                                        BUG13364
     C                   EXSR      RDSFLR
     C                   END
      *
      ** Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      ********************************************************************
      * BLDSFL - BUILD SUBFILE
      ********************************************************************
     C     BLDSFL        BEGSR
      *                                                                                       CSE010
      ** If CSE010 is not installed                                                           CSE010
      *                                                                                       CSE010
     C                   IF        CSE010 = 'N'                                               CSE010
     C                             AND CSE019 <> 'Y'                            CSE019
     C                   CLEAR                   SETRADS0                                     CSE010
      *                                                                                       CSE010
     C                   ELSE                                                                 CSE010
      *                                                                                       CSE010
     C                   MOVE      *BLANKS       STRDT                                        CSE010
     C                   MOVE      *BLANKS       STDRF                                        CSE010
     C                   MOVE      *BLANKS       STDSS                                        CSE010
     C                   MOVE      *BLANKS       STCNR                                        CSE010
     C                   MOVE      *BLANKS       STINC                                        CSE010
     C                   MOVE      *BLANKS       SSTSI                                        CSE010
     C                   MOVE      *BLANKS       SORNO                                        CSE010
     C                   MOVE      *BLANKS       STDVD                          CSE019
     C                   MOVE      *BLANKS       STDBK                          CSE019
     C                   MOVE      *BLANKS       STDTP                          CSE019
     C                   MOVE      *BLANKS       SFRNT                          CSE019
      *                                                                                       CSE010
     C                   MOVE      *BLANKS       WFIRST                                       CSE010
      *                                                                                       CSE010
     C     @ENDEL        IFEQ      'Y'                                                        CSE010
     C                   MOVE      *ON           *IN25                                        CSE010
     C                   ELSE                                                                 CSE010
     C                   MOVE      *OFF          *IN25                                        CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   ENDIF                                                                CSE010
      *
      * Set indicator ans flag for Midas (back) office trade number key used    CAP004
      *                                                                         CAP004
     C                   MOVE      'B'           WTRAD             1            CAP004
     C                   MOVE      '0'           *IN20                          CAP004
      *                                                                         CAP004
      ** Check for user Authority to Browse IF NOT MULTI-BRANCHING
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      CHAUTN
     C                   END
      *
      * Validate Trade Ref (FOR POINTER)
      *
     C     CSE010        IFEQ      'N'                                                        CSE010
     C     CSE019        ANDNE     'Y'                                          CSE019
     C                   EXSR      VALTDRF
     C/COPY WNCPYSRC,SETRADBC01
     C                   ENDIF                                                                CSE010
      *
      **  Initialise subfile relative record number.
      *
     C                   Z-ADD     0             @@RRN             5 0
      *
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
      *
     C                   MOVE      '1'           *IN97
     C     CSE010        IFEQ      'N'                                                        CSE010
     C     CSE019        ANDNE     'Y'                                          CSE019
     C                   WRITE     SETRADS0
     C                   ELSE                                                                 CSE010
      *                                                                         CSE019
     C                   Select                                                 CSE019
      *                                                                         CSE019
      **  First Format Selection's screen                                       CSE019
     C     WWFMT         Wheneq    'First'                                      CSE019
     C     CSE019        Orne      'Y'                                          CSE019
     C                   WRITE     SETRADS4                                                   CSE010
      *                                                                         CSE019
      **  Second Format Selection's screen                                      CSE019
     C     WWFMT         Wheneq    'Second'                                     CSE019
     C                   WRITE     SETRADS8                                     CSE019
     C                   Endsl                                                  CSE019
      *                                                                         CSE019
     C                   ENDIF                                                                CSE010
     C                   MOVE      '0'           *IN97
      *
      **  Write the select screen footer to the screen.
      *
     C     CSE010        IFEQ      'N'                                                        CSE010
     C     CSE019        ANDNE     'Y'                                          CSE019
     C                   WRITE     SETRADF1
     C                   ELSE                                                                 CSE010
      *                                                                         CSE019
     C                   Select                                                 CSE019
      *                                                                         CSE019
      **  First Format Selection's screen                                       CSE019
     C     WWFMT         Wheneq    'First'                                      CSE019
     C     CSE019        Orne      'Y'                                          CSE019
     C                   WRITE     SETRADF2                                                   CSE010
      *                                                                         CSE019
      **  Second Format Selection's screen                                      CSE019
     C     WWFMT         Wheneq    'Second'                                     CSE019
     C                   WRITE     SETRADF5                                     CSE019
     C                   Endsl                                                  CSE019
      *                                                                         CSE019
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
      ** Do the follwing if CSE010 is not installed                                           CSE010
      ** And CSE019 is not installed                                            CSE019
      *                                                                                       CSE010
     C                   IF        CSE010 = 'N'                                               CSE010
     C                             AND CSE019 <> 'Y'                            CSE019
      *
      **  Set file pointer on key displayed on screen.
      *
     C     DDACTN        IFEQ      'Y'
     C     DDACTN        OREQ      'P'
     C     @@TDRF        SETLL     TRADSRA
     C                   ELSE
     C     @@TDRF        SETLL     TRADS
     C                   ENDIF
      *
      ** Read a Valid Trade
      *
     C                   EXSR      RDTDRF
      *
      **  If no records exist - set up an error message.
      **  and terminate
      *
     C     @@EOF         IFEQ      'Y'
     C                   MOVEL     'MMM1007'     @ERRMS
     C                   RETURN
     C                   END
      *
      **  Set on ROLLUP indicator to drive initial loop.
      *
     C                   MOVE      '1'           *IN98
      *                                                                                       CSE010
      ** If CSE010 is installed                                                               CSE010
      *                                                                                       CSE010
     C                   ELSE                                                                 CSE010
     C                   MOVE      *BLANKS       @@EOF                                        CSE010
     C                   MoveA     FldNameA      FldNameArr                                   CSE010
     C                   MoveA     MsgIdA        MsgIdArr                                     CSE010
     C                   ENDIF                                                                CSE010
      *                                                                         CSE019
     C     CSE019        Ifeq      'Y'                                          CSE019
     C                   Movel     'First     '  WSFMT                          CSE019
     C                   Endif                                                  CSE019
      *
      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Repeat the process until either the end of file, ROLLUP
      **  has not been entered or F3 or F12 is input.
      *
     C*****@@EOF*        DOWNE     'Y'                                                        CSE010
     C******IN98*        ANDEQ     '1'                                                        CSE010
      *
      ****Initialise*count*of*records*written*to*subfile*page.*********                       CSE010
      *
     C***********        Z-ADD     0             @@CNT             3 0                        CSE010
      *
      ****For*each*record*read,*write*it*to*the*subfile.***************                       CSE010
      ****Do*this*until*end*of*file*or*the*subfile*page*is*full.*******                       CSE010
      *
     C*****@@EOF*        DOWNE     'Y'                                                        CSE010
     C*****@@CNT*        ANDLT     14                                                         CSE010
      *
      ****Increment*the*subfile*record*no.*and*records*written*fields.*                       CSE010
      *
     C***********        ADD       1             @@RRN                                        CSE010
     C***********        ADD       1             @@CNT                                        CSE010
      *
      ***Format*trade*fields*for*output********************************                       CSE010
      *
     C***********        EXSR      FMTTRD                                                     CSE010
      *
      ****Write*the*trade*to*the*subfile.******************************                       CSE010
      *
     C***********        MOVE      *BLANK        DDOPT                                        CSE010
     C***********        Z-ADD     @@RRN         DDSFRN                                       CSE010
     C***********        WRITE     SETRADS1                                                   CSE010
      *
      ***Read*a*valid*Trade********************************************                       CSE010
      *
     C***********        EXSR      RDTDRF                                                     CSE010
     C***********        END                                                                  CSE010
      *
      ****Write*the*subfile*control*record*to*the*screen*to*display****                       CSE010
      ****the*subfile.*************************************************                       CSE010
      *
     C***********        WRITE     SETRADS0                                                   CSE010
      *
      ****Read*the*subfile*control*record*to*determine*whether records*                       CSE010
      ****have*been*selected*or*whether*ROLLUP*is*required.************                       CSE010
      *
     C***********        READ      SETRADS0                               99                  CSE010
      *
      ****If*F3,*bypass*further*processing.****************************                       CSE010
      *
     C******INKC*        IFEQ      '1'                                                        CSE010
     C***********        MOVEL     '1'           @INKC                                        CSE010
     C***********        SETON                                        LR                      CSE010
     C***********        RETURN                                                               CSE010
     C***********        END                                                                  CSE010
      *
      ****If*F12,*bypass*further*processing.***************************                       CSE010
      *
     C******INKL*        IFEQ      '1'                                                        CSE010
     C***********        MOVEL     '1'           @INKL                                        CSE010
     C***********        RETURN                                                               CSE010
     C***********        END                                                                  CSE010
      *
     C***********        END                                                                  CSE010
      *
     C     @@EOF         DOWNE     'Y'                                                        CSE010
     C     CSE010        ANDEQ     'Y'                                                        CSE010
     C     @@EOF         ORNE      'Y'                                          CSE019
     C     CSE019        ANDEQ     'Y'                                          CSE019
     C     @@EOF         ORNE      'Y'                                                        CSE010
     C     *IN98         ANDEQ     *ON                                                        CSE010
     C     CSE010        ANDEQ     'N'                                                        CSE010
     C     CSE019        ANDNE     'Y'                                          CSE019
      *                                                                                       CSE010
      ** Initialise count of records written to subfile page                                  CSE010
      *                                                                                       CSE010
     C                   Z-ADD     0             @@CNT                                        CSE010
      *                                                                                       CSE010
      ** Reset Indicators and Array Index                                                     CSE010
      *                                                                                       CSE010
     C                   Z-ADD     0             Ix                                           CSE010
     C                   MOVEA     '000'         *IN(27)                                      CSE010
     C                   MOVE      '0'           *IN32                                        CSE010
     C                   MOVEA     '00000'       *IN(33)                        CSE019
      *                                                                                       CSE010
      ** If CSE010 is installed                                                               CSE010
      ** Or CSE019 is installed                                                 CSE019
      *                                                                                       CSE010
     C     CSE010        IFEQ      'Y'                                                        CSE010
     C     CSE019        OREQ      'Y'                                          CSE019
      *                                                                                       CSE010
      ** Clear new message subfile                                                            CSE010
      *                                                                                       CSE010
     C                   CALL      'ZA0250'                                                   CSE010
      *                                                                                       CSE010
      ** Validate input fields                                                                CSE010
      *                                                                                       CSE010
     C                   EXSR      VALINP                                                     CSE010
      *                                                                                       CSE010
      ** If new selection flag is yes                                                         CSE010
      *                                                                                       CSE010
     C     WNewSel       IFEQ      'Y'                                                        CSE010
      *                                                                                       CSE010
     C     FldNameArr(1) IFEQ      *BLANKS                                                    CSE010
     C     CSE019        ANDNE     'Y'                                          CSE019
     C     FldNameArr(1) OREQ      *BLANKS                                      CSE019
     C     WWFMT         ANDEQ     WSFMT                                        CSE019
     C     CSE019        ANDEQ     'Y'                                          CSE019
     C                   MOVE      *BLANKS       DDOPT                                        CSE010
     C                   EXSR      SEL                                                        CSE010
     C                   ENDIF                                                                CSE010
      *                                                                         CSE019
     C     CSE019        IFEQ      'Y'                                          CSE019
     C     WWFMT         ANDNE     WSFMT                                        CSE019
     C                   MOVE      WWFMT         WSFMT                          CSE019
     C                   ENDIF                                                  CSE019
      *                                                                                       CSE010
      ** If no records exist                                                                  CSE010
      *                                                                                       CSE010
     C     @@RRN         IFEQ      0                                                          CSE010
      *                                                                         CSE019
     C                   Select                                                 CSE019
      *                                                                         CSE019
      **  First Format Selection's screen                                       CSE019
     C     WWFMT         Wheneq    'First'                                      CSE019
     C     CSE019        Orne      'Y'                                          CSE019
     C                   WRITE     SETRADF3                                                   CSE010
     C                   READ      SETRADF3                               50                  CSE010
      *                                                                         CSE019
      **  Second Format Selection's screen                                      CSE019
     C     WWFMT         Wheneq    'Second'                                     CSE019
     C                   WRITE     SETRADF4                                     CSE009
     C                   READ      SETRADF4                               50    CSE009
     C                   Endsl                                                  CSE009
      *                                                                                       CSE010
     C                   ELSE                                                                 CSE010
      *                                                                                       CSE010
      ** Set Subfile Record Number field, write and read new screen format                    CSE010
      *                                                                                       CSE010
     C     @#SFRC        IFEQ      0                                                          214408
     C                   Z-ADD     @@RRN         DDSFRN                                       CSE010
     C                   ELSE                                                                 214408
     C                   Z-ADD     @#SFRC        DDSFRN                                       214408
     C                   ENDIF                                                                214408
      /COPY ZACPYSRC,MSGHNDDSP1                                                               CSE010
     C                   WRITE     SETRADC6                                                   CSE010
     C                   MOVEA     *BLANKS       FldNameArr(1)                                CSE010
     C                   MOVEA     *BLANKS       MsgIdArr(1)                                  CSE010
      *                                                                         CSE019
     C                   Select                                                 CSE019
      *                                                                         CSE019
      **  First Format Selection's screen                                       CSE019
     C     WWFMT         Wheneq    'First'                                      CSE019
     C     CSE019        Orne      'Y'                                          CSE019
     C                   WRITE     SETRADS4                                                   CSE010
     C                   READ      SETRADS4                               50                  CSE010
      *                                                                         CSE019
      **  Second Format Selection's screen                                      CSE019
     C     WWFMT         Wheneq    'Second'                                     CSE019
     C                   WRITE     SETRADS8                                     CSE019
     C                   READ      SETRADS8                               50    CSE019
     C                   Endsl                                                  CSE019
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   ELSE                                                                 CSE010
     C                   LEAVE                                                                CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
      ** If CSE010 if not installed                                                           CSE010
      *                                                                                       CSE010
     C                   ELSE                                                                 CSE010
      *                                                                                       CSE010
     C     @@EOF         DOWNE     'Y'                                                        CSE010
     C*****@@CNT         ANDLT     14                                                  CSE010 CSE016
     C     @@CNT         ANDLT     7                                                          CSE016
     C                   ADD       1             @@RRN                                        CSE010
     C                   ADD       1             @@CNT                                        CSE010
     C                   EXSR      FMTTRD                                                     CSE010
     C                   MOVE      *Blanks       DDOPT                                        CSE010
     C                   Z-ADD     @@RRN         DDSFRN                                       CSE010
     C                   WRITE     SETRADS1                                                   CSE010
     C                   EXSR      RDTDRF                                                     CSE010
     C                   ENDDO                                                                CSE010
      *                                                                                       CSE010
     C                   WRITE     SETRADS0                                                   CSE010
     C                   READ      SETRADS0                               50                  CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
      ** If F3 is taken                                                                       CSE010
      *                                                                                       CSE010
     C     *INKC         IFEQ      *ON                                                        CSE010
     C                   MOVE      '1'           @INKC                                        CSE010
     C                   MOVE      *ON           *INLR                                        CSE010
     C                   RETURN                                                               CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
      ** If F12 is taken                                                                      CSE010
      *                                                                                       CSE010
     C     *INKL         IFEQ      *ON                                                        CSE010
     C                   MOVE      '1'           @INKL                                        CSE010
     C                   RETURN                                                               CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C     CSE010        IFEQ      'Y'                                                        CSE010
     C     CSE019        OREQ      'Y'                                          CSE019
      *                                                                                       CSE010
      ** If Selection fields are not blanks, blank out EOF                                    CSE010
      *                                                                                       CSE010
     C     @@EOF         IFEQ      'Y'                                                        CSE010
      *                                                                                       CSE010
     C     STRDT         IFNE      *Blanks                                                    CSE010
     C     STDRF         ORNE      *Blanks                                                    CSE010
     C     STDSS         ORNE      *Blanks                                                    CSE010
     C     STCNR         ORNE      *Blanks                                                    CSE010
     C     STINC         ORNE      *Blanks                                                    CSE010
     C     SORNO         ORNE      *Blanks                                                    CSE010
     C     STDTP         ORNE      *Blanks                                      CSE019
     C     STDVD         ORNE      *Blanks                                      CSE019
     C     STDBK         ORNE      *Blanks                                      CSE019
     C     SFRNT         ORNE      *Blanks                                      CSE019
     C     *INKQ         OREQ      *ON                                                        CSE010
     C                   MOVE      ' '           @@EOF                                        CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
      ** If F5 is taken, clear all input fields                                               CSE010
      *                                                                                       CSE010
     C     *INKE         IFEQ      *ON                                                        CSE010
     C                   MOVE      *BLANKS       STRDT                                        CSE010
     C                   MOVE      *BLANKS       STDRF                                        CSE010
     C                   MOVE      *BLANKS       STDSS                                        CSE010
     C                   MOVE      *BLANKS       STCNR                                        CSE010
     C                   MOVE      *BLANKS       STINC                                        CSE010
     C                   MOVE      *BLANKS       SSTSI                                        CSE010
     C                   MOVE      *BLANKS       SORNO                                        CSE010
     C                   MOVE      *BLANKS       STDTP                          CSE019
     C                   MOVE      *BLANKS       STDVD                          CSE019
     C                   MOVE      *BLANKS       STDBK                          CSE019
     C                   MOVE      *BLANKS       SFRNT                          CSE019
     C                   MOVE      *OFF          *IN32                                        CSE010
     C                   MOVE      *OFF          *IN27                                        CSE010
     C                   MOVE      *OFF          *IN28                                        CSE010
     C                   MOVE      *OFF          *IN29                                        CSE010
     C                   MOVE      *OFF          *IN33                          CSE019
     C                   MOVE      *OFF          *IN34                          CSE019
     C                   MOVE      *OFF          *IN35                          CSE019
     C                   MOVE      *OFF          *IN36                          CSE019
     C                   MOVE      *OFF          *IN37                          CSE019
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
      ** IF F10 is taken                                                                      CSE010
      *                                                                                       CSE010
     C     *INKJ         IFEQ      *ON                                                        CSE010
     C     @ENDEL        ANDEQ     'Y'                                                        CSE010
     C                   MOVE      '1'           @ENDEL            1                          CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
      ** If F11 is taken, leave loop                                                          CSE010
      *                                                                                       CSE010
     C     *INKK         IFEQ      *ON                                                        CSE010
     C     CSE019        ANDNE     'Y'                                          CSE019
     C                   LEAVE                                                                CSE010
     C                   ENDIF                                                                CSE010
      *                                                                         CSE019
     C     *INKK         Ifeq      True                                         CSE019
     C     CSE019        Andeq     'Y'                                          CSE019
     C                   Move      False         *INKK                          CSE019
      *                                                                         CSE019
     C                   Select                                                 CSE019
     C     WWFMT         Wheneq    'First'                                      CSE019
     C                   Eval      WWFMT = 'Second'                             CSE019
     C                   Other                                                  CSE019
     C                   Eval      WWFMT = 'First'                              CSE019
     C                   Endsl                                                  CSE019
     C                   Endif                                                  CSE019
      *                                                                                       CSE010
     C/COPY WNCPYSRC,SETRADBC02
     C                   ENDDO                                                                CSE010
      *                                                                                       CSE010
     C                   ENDSR
      /EJECT
      ********************************************************************      CAP004
      * BLDSFL2 - BUILD SUBFILE by FRONT OFFICE ID.                             CAP004
      ********************************************************************      CAP004
                                                                                CAP004
     C     BLDSFL2       BEGSR                                                  CAP004
      *                                                                         CAP004
      * Set indicator and flag for Midas (back) office trade number key used    CAP004
      *                                                                         CAP004
     C                   MOVE      'F'           WTRAD                          CAP004
     C                   MOVE      '1'           *IN20                          CAP004
      *                                                                         CAP004
      ** Check for user Authority to Browse IF NOT MULTI-BRANCHING              CAP004
      *                                                                         CAP004
     C     BJSBRC        IFNE      *BLANK                                       CAP004
     C                   EXSR      CHAUTN                                       CAP004
     C                   END                                                    CAP004
      *                                                                         CAP004
      * Validate Trade Ref (FOR POINTER)                                        CAP004
      *                                                                         CAP004
     C                   EXSR      VALTDRF                                      CAP004
      *                                                                         CAP004
      **  Get Front Office Trade Ref.                                           CAP004
      *                                                                         CAP004
     C     DDACTN        IFEQ      'Y'                                          CAP004
     C     DDACTN        OREQ      'P'                                          CAP004
     C     @@TDRF        CHAIN     TRADSRA                            89        CAP004
     C                   ELSE                                                   CAP004
     C     @@TDRF        CHAIN     TRADS                              89        CAP004
     C                   END                                                    CAP004
     C                   MOVE      FRNT          @@FOTD           20            CAP004
     C     *IN89         IFEQ      '1'                                          CAP004
     C                   MOVE      *BLANK        @@FOTD                         CAP004
     C                   END                                                    CAP004
     C/COPY WNCPYSRC,SETRADBC03
      *                                                                         CAP004
      **  Initialise subfile relative record number.                            CAP004
      *                                                                         CAP004
     C                   Z-ADD     0             @@RRN             5 0          CAP004
      *                                                                         CAP004
      **  Clear subfile before refilling by writing control record              CAP004
      **  with SFLCLR active.                                                   CAP004
      *                                                                         CAP004
     C                   MOVE      '1'           *IN97                          CAP004
     C                   WRITE     SETRADS2                                     CAP004
     C                   MOVE      '0'           *IN97                          CAP004
      *                                                                         CAP004
      **  Write the select screen footer to the screen.                         CAP004
      *                                                                         CAP004
     C                   WRITE     SETRADF1                                     CAP004
      *                                                                         CAP004
      **  Set file pointer on key displayed on screen.                          CAP004
      *                                                                         CAP004
     C     @@FOTD        SETLL     TRADSFO                                      CAP004
      *                                                                         CAP004
      ** Read a Valid Trade                                                     CAP004
      *                                                                         CAP004
     C                   EXSR      RDTDRF                                       CAP004
      *                                                                         CAP004
      **  If no records exist - set up an error message.                        CAP004
      **  and terminate                                                         CAP004
      *                                                                         CAP004
     C     @@EOF         IFEQ      'Y'                                          CAP004
     C                   MOVEL     'MMM1007'     @ERRMS                         CAP004
     C                   RETURN                                                 CAP004
     C                   END                                                    CAP004
      *                                                                         CAP004
      **  Set on ROLLUP indicator to drive initial loop.                        CAP004
      *                                                                         CAP004
     C                   MOVE      '1'           *IN98                          CAP004
      *                                                                         CAP004
      **  Read records from the file into the subfile until a page has          CAP004
      **  been filled or there are no more records.                             CAP004
      **  Repeat the process until either the end of file, ROLLUP               CAP004
      **  has not been entered or F3 or F12 is input.                           CAP004
      *                                                                         CAP004
     C     @@EOF         DOWNE     'Y'                                          CAP004
     C     *IN98         ANDEQ     '1'                                          CAP004
      *                                                                         CAP004
      **  Initialise count of records written to subfile page.                  CAP004
      *                                                                         CAP004
     C                   Z-ADD     0             @@CNT             3 0          CAP004
      *                                                                         CAP004
      **  For each record read, write it to the subfile.                        CAP004
      **  Do this until end of file or the subfile page is full.                CAP004
      *                                                                         CAP004
     C     @@EOF         DOWNE     'Y'                                          CAP004
     C*****@@CNT         ANDLT     14                                                  CAP004 CSE016
     C     @@CNT         ANDLT     7                                                          CSE016
      *                                                                         CAP004
      **  Increment the subfile record no. and records written fields.          CAP004
      *                                                                         CAP004
     C                   ADD       1             @@RRN                          CAP004
     C                   ADD       1             @@CNT                          CAP004
      *                                                                         CAP004
      ** Format trade fields for output                                         CAP004
      *                                                                         CAP004
     C                   EXSR      FMTTRD                                       CAP004
      *                                                                         CAP004
      **  Write the trade to the subfile.                                       CAP004
      *                                                                         CAP004
     C                   MOVE      *BLANK        DDOPT                          CAP004
     C                   Z-ADD     @@RRN         DDSFRN                         CAP004
     C                   WRITE     SETRADS3                                     CAP004
      *                                                                         CAP004
      ** Read a valid Trade                                                     CAP004
      *                                                                         CAP004
     C                   EXSR      RDTDRF                                       CAP004
     C                   END                                                    CAP004
      *                                                                         CAP004
      **  Write the subfile control record to the screen to display             CAP004
      **  the subfile.                                                          CAP004
      *                                                                         CAP004
     C                   WRITE     SETRADS2                                     CAP004
      *                                                                         CAP004
      **  Read the subfile control record to determine whether records          CAP004
      **  have been selected or whether ROLLUP is required.                     CAP004
      *                                                                         CAP004
     C                   READ      SETRADS2                               99    CAP004
      *                                                                         CAP004
      **  If F3, bypass further processing.                                     CAP004
      *                                                                         CAP004
     C     *INKC         IFEQ      '1'                                          CAP004
     C                   MOVEL     '1'           @INKC                          CAP004
     C                   SETON                                        LR        CAP004
     C                   RETURN                                                 CAP004
     C                   END                                                    CAP004
      *                                                                         CAP004
      **  If F12, bypass further processing.                                    CAP004
      *                                                                         CAP004
     C     *INKL         IFEQ      '1'                                          CAP004
     C                   MOVEL     '1'           @INKL                          CAP004
     C                   RETURN                                                 CAP004
     C                   END                                                    CAP004
      *                                                                         CAP004
     C/COPY WNCPYSRC,SETRADBC04
     C                   END                                                    CAP004
      *                                                                         CAP004
     C                   ENDSR                                                  CAP004
      ********************************************************************
      /EJECT
      ********************************************************************
      * RDSFLR - READ SUBFILE RECORD
      ********************************************************************
     C     RDSFLR        BEGSR
      *
      **  Read the subfile for selected records
      **  Only process those for which the option field is blank.
      *
     C     *IN99         DOUEQ     '1'
     C     DDOPT         ORNE      *BLANK
     C     WTRAD         IFNE      'F'                                          CAP004
      *                                                                                       CSE010
      ** If CSE010 is not installed, ReadC on old subfile                                     CSE010
      *                                                                                       CSE010
     C     CSE010        IFEQ      'N'                                                        CSE010
     C     CSE019        ANDNE     'Y'                                          CSE019
     C                   READC     SETRADS1                               99
     C                   ELSE                                                                 CSE010
      *                                                                         CSE019
     C                   Select                                                 CSE019
      *                                                                         CSE019
      ** First Format Selection's screen                                        CSE019
     C     WWFMT         Wheneq    'First'                                      CSE019
     C     CSE019        Orne      'Y'                                          CSE019
     C                   READC     SETRADS5                               99                  CSE010
     C     *IN99         Ifeq      *on                                          CSE019
     C     CSE019        Andeq     'Y'                                          CSE019
     C                   READC     SETRADS7                               99    CSE019
     C                   Endif                                                  CSE019
      *                                                                         CSE019
      ** Second Format Selection's screen                                       CSE019
     C     WWFMT         Wheneq    'Second'                                     CSE019
     C                   READC     SETRADS7                               99    CSE019
     C     *IN99         Ifeq      *on                                          CSE019
     C                   READC     SETRADS5                               99    CSE019
     C                   Endif                                                  CSE019
     C                   Endsl                                                  CSE019
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   ELSE                                                   CAP004
     C                   READC     SETRADS3                               99    CAP004
     C                   END
      *                                                                                       CSE010
     C                   END
      *
      **  Return the selected trade reference and option
      *
     C     *IN99         IFNE      '1'
     C     DDOPT         ANDNE     *BLANK
      *
     C     DDOPT         IFEQ      'A'
     C     DDOPT         OREQ      'C'
     C     DDOPT         OREQ      'D'
     C     DDOPT         OREQ      'Y'
     C     BVAUTH        ANDNE     '00'                                         154653
     C     BVAUTH        ANDNE     '15'                                         154653
     C     DDOPT         OREQ      'P'
     C     BVAUTH        ANDEQ     '20'                                         154653
     C                   MOVE      DDOPT         @OPSEL
     C                   ELSE
     C                   MOVE      'E'           @OPSEL
     C                   END
      *                                                                                       CSE010
      ** If CSE010 & TOF/Midas Interface are installed and Order Number                       CSE010
      ** if not blank, default action code                                                    CSE010
      *                                                                                       CSE010
     C     CSE010        IFEQ      'Y'                                                        CSE010
     C     CPB001        ANDEQ     'Y'                                                        CSE010
     C     EXORDE        ANDNE     *Blanks                                                    CSE010
     C     CSE019        ANDNE     'Y'                                          CSE019
     C                   MOVEL     DDACTN        @OPSEL                                       CSE010
     C                   ENDIF                                                                CSE010
      *
     C                   MOVE      DDTDR         @TRSEL
      *
     C                   END
     C     DDACTN        IFEQ      'E'                                                        202981
     C                   MOVEL     'E'           DDOPT                                        202981
     C                   MOVEL     'E'           @OPSEL                                       202981
     C                   END                                                                  202981
      *
     C     EBLDSF        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FMTTRD - FORMAT TRADE FOR OUTPUT
      ******************************************************************
     C     FMTTRD        BEGSR
      *
      * Trade reference
     C                   MOVE      TDRF          DDTDR
      *                                                                         CAP004
      * Front Office Deal number                                                CAP004
      *                                                                         CAP004
     C                   MOVE      FRNT          DDFODN                         CAP004
      *
      * Status fields
     C     RECI          IFEQ      'C'
     C     RECI          OREQ      '*'
     C     RECI          OREQ      'R'                                                         S0126
     C     RECI          OREQ      'L'                                                         10132
     C     CHTP          ANDEQ     'D'                                                         10132
     C     RECI          OREQ      'P'                                                         10132
     C     CHTP          ANDEQ     'D'                                                         10132
      *                                                                                       CSE010
      ** Format status field if screen field is F or CSE010 is off                            CSE010
      *                                                                                       CSE010
     C     WTRAD         IFEQ      'F'                                                        CSE010
     C     CSE010        OREQ      'N'                                                        CSE010
     C     CSE019        OREQ      'Y'                                          CSE019
     C                   EVAL      DDSTAT = 'CANCELLED'
     C                   MOVE      *ON           *IN80
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   ELSE
      *                                                                                       CSE010
     C     WTRAD         IFEQ      'F'                                                        CSE010
     C     CSE010        OREQ      'N'                                                        CSE010
     C     CSE019        OREQ      'Y'                                          CSE019
     C                   MOVE      *OFF          *IN80
     C                   EVAL      DDSTAT = *BLANKS
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   ENDIF
 
     C     RECI          IFEQ      'L'                                                         S0126
     C     RECI          OREQ      'P'                                                         S0126
     C     RECI          OREQ      'R'                                                         S0126
      *                                                                                       CSE010
     C     WTRAD         IFEQ      'F'                                                        CSE010
     C     CSE010        OREQ      'N'                                                        CSE010
     C     CSE019        OREQ      'Y'                                          CSE019
     C                   EVAL      DDSTAT  = 'NOT AUTH.'
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   END
      *
      * Security shortname
     C                   MOVE      TDSS          DDSESN
      *                                                                                       CSE016
     C                   MOVE      *BLANKS       DDSRNM                                       CSE016
      *                                                                                       CSE016
      ** Retrieve security description                                                        CSE016
      *                                                                                       CSE016
     C     DDSESN        CHAIN     SECTY                              31                      CSE016
     C     *IN31         IFEQ      *OFF                                                       CSE016
      *                                                                                       CSE016
      ** Format security report description                                                   CSE016
      *                                                                                       CSE016
     C     DDSESN        IFNE      *BLANKS                                                    CSE016
      *                                                                                       CSE016
     C                   CALLB     'ZSDESC'                                                   CSE016
     C                   PARM      SRPN          PSRPN                                        CSE016
     C                   PARM                    PSFN1                                        CSE016
     C                   PARM                    PSFN2                                        CSE016
     C                   PARM                    CPNR                                         CSE016
     C                   PARM                    MATY                                         CSE016
     C                   PARM                    SCPP                                         CSE016
     C                   PARM                    SCPD                                         CSE016
     C                   PARM      BVRIDF        PRSFD                                        CSE016
     C                   PARM                    SCPI                                         CSE016
     C                   PARM                    PRNME                                        CSE016
     C                   PARM                    PFNM1                                        CSE016
     C                   PARM                    PFNM2                                        CSE016
     C                   PARM                    PFNM3                                        CSE016
      *                                                                                       CSE016
     C                   EVAL      DDSRNM = PRNME                                             CSE016
     C                   ENDIF                                                                CSE016
      *                                                                                       CSE016
     C                   ENDIF                                                                CSE016
      *
      * Nominal
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      NOML          ZFIELD
     C                   Z-ADD     TNMD          ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDNOML
      *
      * Value Date
     C                   Z-ADD     TDVD          ZDAYNO
     C     ZDAYNO        IFNE      *ZERO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZDATE         DDVDAT
     C                   ELSE
     C                   MOVEL     *BLANK        DDVDAT
     C                   END
      *
      * Customer number
     C                   CLEAR                   DDCNUM
     C                   MOVE      TCNR          DDCNUM
      *
     C*******************CALLB     'AOCUSTR0'                                             211800
     C                   CALLB     'AOCUSTR1'                                             211800
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDCNUM        @KEY1            10                           S0111
     C                   PARM                    @KYST             7                           S0111
     C*****SDCUST        PARM      SDCUST        DSSDY                          O:Format  211800
     C     SDCUST        PARM      SDCUST        DSLDY                          O:Format  211800
      *
     C     @RTCD         IFEQ      *BLANKS
     C     @RTCD         ORNE      *BLANKS                                                211800
     C     BBCLST        ANDEQ     'Y'                                                    211800
     C                   CLEAR                   DDCNUM
     C                   MOVEL     BBCSSN        DDCNUM
     C                   ELSE
     C                   CLEAR                   DDCNUM
     C                   ENDIF
      * Trade Type
     C                   MOVE      TDTP          DDTDTP
      * Incomplete Ind
     C                   MOVE      TINC          DDINCS
      *                                                                                       CSE010
      ** If Screen field WTRAD is B and CSE010 is installed                                   CSE010
      *                                                                                       CSE010
     C     WTRAD         IFEQ      'B'                                                        CSE010
     C     CSE010        ANDEQ     'Y'                                                        CSE010
     C     WTRAD         OREQ      'B'                                          CSE019
     C     CSE019        ANDEQ     'Y'                                          CSE019
     C                   Z-ADD     TDDT          ZDAYNO                                       CSE010
      *                                                                                       CSE010
     C     ZDAYNO        IFNE      *ZERO                                                      CSE010
     C                   EXSR      ZDATE2                                                     CSE010
     C                   MOVEL     ZDATE         DDTRDT                                       CSE010
     C                   ELSE                                                                 CSE010
     C                   MOVEL     *BLANKS       DDTRDT                                       CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
      ** If TOF/Midas Interface is installed                                                  CSE010
      *                                                                                       CSE010
     C     CPB001        IFEQ      'Y'                                                        CSE010
     C     CSE019        Andne     'Y'                                          CSE019
     C                   MOVE      ORDE          DDORDE                                       CSE010
     C                   ELSE                                                                 CSE010
     C     CPB001        IFEQ      'Y'                                          CSE019
     C                   MOVE      *ON           *IN21                                        CSE010
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                                CSE010
      *                                                                         CSE019
      * Value Date                                                              CSE019
     C     CSE019        Ifeq      'Y'                                          CSE019
     C                   Z-add     TDFS          ZDAYNO                         CSE019
      *                                                                         CSE019
     C     ZDAYNO        Ifne      *ZERO                                        CSE019
     C                   Exsr      ZDATE2                                       CSE019
     C                   Movel     ZDATE         DDORDE                         CSE019
     C                   Else                                                   CSE019
     C                   Movel     *BLANKS       DDORDE                         CSE019
     C                   Endif                                                  CSE019
      *                                                                         CSE019
      * Book Code                                                               CSE019
     C                   Movel     TDBK          DDTDBK                         CSE019
      * Front Office ID                                                         CSE019
     C                   Movel     FRNT          DDFRNT                         CSE019
     C                   Endif                                                  CSE019
      *                                                                                       CSE010
      ** If no authorisation is required, set new status field                                CSE010
      *                                                                                       CSE010
     C                   MOVE      *Blanks       DDSTSI                                       CSE010
     C                   MOVEA     '0000'        *IN(61)                                      196918
      *                                                                                       CSE010
     C     BVAUTH        IFEQ      '00'                                                       CSE010
      *                                                                                       CSE010
     C     TINC          IFEQ      'C'                                                        CSE010
     C                   MOVE      'A'           DDSTSI                                       CSE010
     c                   ELSE                                                                 CSE010
     C                   MOVE      'N'           DDSTSI                                       CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
      ** If record identifies of trads is 'C' or '*' or 'R'                                   CSE010
      ** or RECI is 'L' and CHTP is 'D'                                                       CSE010
      ** or RECI is 'P' and CHTP is 'D'                                                       CSE010
      *                                                                                       CSE010
     C     RECI          IFEQ      'C'                                                        CSE010
     C     RECI          OREQ      '*'                                                        CSE010
     C     RECI          OREQ      'R'                                                        CSE010
      *                                                                                       CSE010
     C     RECI          OREQ      'L'                                                        CSE010
     C     CHTP          ANDEQ     'D'                                                        CSE010
      *                                                                                       CSE010
     C     RECI          OREQ      'P'                                                        CSE010
     C     CHTP          ANDEQ     'D'                                                        CSE010
      *                                                                                       CSE010
     C                   MOVE      'C'           DDSTSI                                       CSE010
     C                   MOVE      '1'           *IN61                                        196918
     C                   ELSE                                                                 CSE010
      *                                                                                       CSE010
      ** If RECI is 'S', or Settlement Date equals rundate                                    CSE010
      ** or RECI 'D' and incomplete indicator is 'C' and auto settlement                      CSE010
      ** indicator is 'Y' and the value date is before or equal to rundate                    CSE010
      ** or RECI 'A' and incomplete indicator is 'C' and auto settlement                      CSE010
      ** indicator is 'Y' and the value date is before or equal to rundate                    CSE010
      ** new status field is 'S' for settled                                                  CSE010
      *                                                                                       CSE010
     C     RECI          IFEQ      'S'                                                        CSE010
     C     TDFS          ORLE      BJRDNB                                                     CSE010
     C     TDFS          ANDNE     0                                                          196903
      *                                                                                       CSE010
     C     RECI          OREQ      'D'                                                        CSE010
     C     TINC          ANDEQ     'C'                                                        CSE010
     C     AUTS          ANDEQ     'Y'                                                        CSE010
     C     TDVD          ANDLE     BJRDNB                                                     CSE010
      *                                                                                       CSE010
     C     RECI          OREQ      'A'                                                        CSE010
     C     TINC          ANDEQ     'C'                                                        CSE010
     C     AUTS          ANDEQ     'Y'                                                        CSE010
     C     TDVD          ANDLE     BJRDNB                                                     CSE010
      *                                                                                       CSE010
     C                   MOVE      'S'           DDSTSI                                       CSE010
     C                   MOVE      '1'           *IN62                                        196918
     C                   ELSE                                                                 CSE010
      *                                                                                       CSE010
      ***If*no*authorisation*is*required*and*Incomplete*Indicator*is                   CSE010 196903
      ** If authorisation is required and Incomplete Indicator is                             196903
      ** Complete                                                                             CSE010
      *                                                                                       CSE010
     C*****BVAUTH        IFEQ      '00'                                                CSE010 196903
     C     BVAUTH        IFNE      '00'                                                       196903
     C     TINC          ANDEQ     'C'                                                        CSE010
      *                                                                                       CSE010
      ** Set new status field to 'N' for not authorised is RECI is 'L',                       CSE010
      ** 'P' or 'R' else new status field is 'A' for authorised                               CSE010
      *                                                                                       CSE010
     C     RECI          IFEQ      'L'                                                        CSE010
     C     RECI          OREQ      'P'                                                        CSE010
     C     RECI          OREQ      'R'                                                        CSE010
     C                   MOVE      'N'           DDSTSI                                       CSE010
     C                   MOVE      '1'           *IN63                                        196918
     C                   ELSE                                                                 CSE010
     C                   MOVE      'A'           DDSTSI                                       CSE010
     C                   MOVE      '1'           *IN64                                        196918
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       196918
      ** Authorised trades were not setup correctly if BVAUTH is '00'.                        196918
      *                                                                                       196918
     C     DDSTSI        IFEQ      'A'                                                        196918
     C                   MOVE      '1'           *IN64                                        196918
     C                   ENDIF                                                                196918
      *                                                                                       196918
      ** Incomplete trades are still shown on the default color.                              196918
      *                                                                                       196918
     C     TINC          IFEQ      'I'                                                        196918
     C                   MOVEA     '0000'        *IN(61)                                      196918
     C     DDSTSI        IFEQ      *BLANK                                                     196918
     C                   MOVE      'N'           DDSTSI                                       196918
     C                   ENDIF                                                                196918
     C                   ENDIF                                                                196918
      *                                                                                       196918
      *
     C                   ENDSR
     C******************************************************************
      /EJECT
      *****************************************************************
      * RDTDRF - READ A TRADE
      *****************************************************************
     C     RDTDRF        BEGSR
      *
      **  Reset End of File indicator
      *
     C                   MOVE      *BLANK        @@EOF             1
      *
      **  Read the file initially - if @@EOF is set on then the end of
      **  the file has been reached.  Read until a valid record is
      **  found or until no more records exist.
      *
     C     @@EOF         DOUEQ     'Y'
     C     TDRF          ORNE      *BLANKS
     C     @@ERR         ANDEQ     *ZERO
      *
      **  Read the file.
      *
     C     WTRAD         IFEQ      'B'                                          CAP004
      *                                                                                       CSE010
      ** If CSE010 is not installed, read TRADSRA os Action code is 'Y'                       CSE010
      ** of 'P' else read TRADS file                                                          CSE010
      *                                                                                       CSE010
     C     CSE010        IFEQ      'N'                                                        CSE010
     C     CSE019        ANDNE     'Y'                                          CSE019
      *                                                                                       CSE010
     C     DDACTN        IFEQ      'Y'
     C     DDACTN        OREQ      'P'
     C                   READ      TRADSRA                                96
     C                   ELSE
     C                   READ      TRADS                                  96
     C                   ENDIF
      *                                                                                       CSE010
     C                   ELSE                                                                 CSE010
      *                                                                                       CSE010
      ** If CSE010 is installed                                                               CSE010
      *                                                                                       CSE010
     C                   SELECT                                                               CSE010
     C                   WHEN      FILE = 'ORDER'                                             CSE010
     C                   READ      @TRADL9                                96                  CSE010
      *                                                                                       CSE010
     C                   WHEN      FILE = 'SECTY'                                             CSE010
     C                   READ      TRADSRD                                96                  CSE010
      *                                                                                       CSE010
     C                   WHEN      FILE = 'CUST'                                              CSE010
     C                   READ      @TRADL7                                96                  CSE010
      *                                                                                       CSE010
     C                   WHEN      FILE = 'SECCUST'                                           CSE010
     C                   READ      @TRADL8                                96                  CSE010
      *                                                                                       CSE010
     C                   WHEN      FILE = 'TDRF'                                              CSE010
     C                   READ      @TRADL5                                96                  CSE010
      *                                                                         CSE019
     C                   WHEN      FILE = 'VDATE'                               CSE019
     C     KeyVDate      READE     SETRADL1                               96    CSE019
      *                                                                         CSE019
     C                   WHEN      FILE = 'SDATE'                               CSE019
     C     KeySDate      READE     SETRADL2                               96    CSE019
      *                                                                         CSE019
     C                   WHEN      FILE = 'FRONT'                               CSE019
     C                   READ      SETRADL0                               96    CSE019
      *                                                                                       CSE010
     C                   OTHER                                                                CSE010
     C                   READ      @TRADL6                                96                  CSE010
      *                                                                                       CSE010
     C                   ENDSL                                                                CSE010
      *                                                                                       CSE010
      ** If entry paramteter action code is 'Y' or 'P', and if RECI is not                    CSE010
      ** 'R', 'L' or 'P', set on error indicator                                              CSE010
      *                                                                                       CSE010
     C                   Z-ADD     *Zeros        @@ERR                                        CSE010
     C     DDACTN        IFEQ      'Y'                                                        CSE010
     C     DDACTN        OREQ      'P'                                                        CSE010
      *                                                                                       CSE010
     C     RECI          IFNE      'R'                                                        CSE010
     C     RECI          ANDNE     'L'                                                        CSE010
     C     RECI          ANDNE     'P'                                                        CSE010
     C                   Z-ADD     1             @@ERR                                        CSE010
     C                   ELSE                                                                 CSE010
     C                   Z-ADD     *Zeros        @@ERR                                        CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
      ** If WWTRAD is not 'B'                                                                 CSE010
      *                                                                                       CSE010
     C                   ELSE                                                   CAP004
     C                   READ      TRADSFO                                96    CAP004
     C/COPY WNCPYSRC,SETRADBC05
     C                   END                                                    CAP004
      *
      * End of File
      *
     C     *IN96         IFEQ      '1'
     C                   MOVEL     'Y'           @@EOF
     C                   END
      *
      ** If trade read, check whether user can see it
      ** Also check that the errros indicator is off & CSE010 is installed                    CSE010
      *
     C     @@EOF         IFNE      'Y'
     C     @@ERR         OREQ      *ZEROS                                                     CSE010
     C     CSE010        ANDEQ     'Y'                                                        CSE010
     C     @@ERR         OREQ      *ZEROS                                       CSE019
     C     CSE019        ANDEQ     'Y'                                          CSE019
      *                                                                                       CSE010
     C     BJSBRC        IFEQ      *BLANK
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    TDBA
     C                   PARM                    @@ERR
     C     BKOBUV        IFEQ      'Y'
     C     @@ERR         ANDEQ     *ZERO
     C                   CALL      'ZVOBU'
     C                   PARM                    ORBR
     C                   PARM                    @@ERR
     C                   END
     C                   END
     C                   END
     C                   END
      *
     C     ERDTDRF       ENDSR
      *****************************************************************         CSE019
      /EJECT                                                                    CSE019
      *****************************************************************         CSE019
      * SETSTAT - Status of the trade selected                                  CSE019
      ******************************************************************        CSE019
     C     SETSTAT       BEGSR                                                  CSE019
      *                                                                         CSE019
      ** If no authorisation is required, set new status field                  CSE019
      *                                                                         CSE019
     C                   MOVE      *Blanks       WWSTSI                         CSE019
      *                                                                         CSE019
     C     BVAUTH        IFEQ      '00'                                         CSE019
      *                                                                         CSE019
     C     TINC          IFEQ      'C'                                          CSE019
     C                   MOVE      'A'           WWSTSI                         CSE019
     c                   ELSE                                                   CSE019
     C                   MOVE      'N'           WWSTSI                         CSE019
     C                   ENDIF                                                  CSE019
      *                                                                         CSE019
     C                   ENDIF                                                  CSE019
      *                                                                         CSE019
      ** If record identifies of trads is 'C' or '*' or 'R'                     CSE019
      ** or RECI is 'L' and CHTP is 'D'                                         CSE019
      ** or RECI is 'P' and CHTP is 'D'                                         CSE019
      *                                                                         CSE019
     C     RECI          IFEQ      'C'                                          CSE019
     C     RECI          OREQ      '*'                                          CSE019
     C     RECI          OREQ      'R'                                          CSE019
      *                                                                         CSE019
     C     RECI          OREQ      'L'                                          CSE019
     C     CHTP          ANDEQ     'D'                                          CSE019
      *                                                                         CSE019
     C     RECI          OREQ      'P'                                          CSE019
     C     CHTP          ANDEQ     'D'                                          CSE019
      *                                                                         CSE019
     C                   MOVE      'C'           WWSTSI                         CSE019
     C                   ELSE                                                   CSE019
      *                                                                         CSE019
      ** If RECI is 'S', or Settlement Date equals rundate                      CSE019
      ** or RECI 'D' and incomplete indicator is 'C' and auto settlement        CSE019
      ** indicator is 'Y' and the value date is before or equal to rundate      CSE019
      ** or RECI 'A' and incomplete indicator is 'C' and auto settlement        CSE019
      ** indicator is 'Y' and the value date is before or equal to rundate      CSE019
      ** new status field is 'S' for settled                                    CSE019
      *                                                                         CSE019
     C     RECI          IFEQ      'S'                                          CSE019
     C     TDFS          ORLE      BJRDNB                                       CSE019
     C     TDFS          ANDNE     0                                                          196903
      *                                                                         CSE019
     C     RECI          OREQ      'D'                                          CSE019
     C     TINC          ANDEQ     'C'                                          CSE019
     C     AUTS          ANDEQ     'Y'                                          CSE019
     C     TDVD          ANDLE     BJRDNB                                       CSE019
      *                                                                         CSE019
     C     RECI          OREQ      'A'                                          CSE019
     C     TINC          ANDEQ     'C'                                          CSE019
     C     AUTS          ANDEQ     'Y'                                          CSE019
     C     TDVD          ANDLE     BJRDNB                                       CSE019
      *                                                                         CSE019
     C                   MOVE      'S'           WWSTSI                         CSE019
     C                   ELSE                                                   CSE019
      *                                                                         CSE019
      ***If*no*authorisation*is*required*and*Incomplete*Indicator*is***                CSE019 196918
      ** If authorisation is required and Incomplete Indicator is                             196918
      ** Complete                                                               CSE019
      *                                                                         CSE019
     C*****BVAUTH        IFEQ      '00'                                                CSE019 196918
     C     BVAUTH        IFNE      '00'                                                       196918
     C     TINC          ANDEQ     'C'                                          CSE019
      *                                                                         CSE019
      ** Set new status field to 'N' for not authorised is RECI is 'L',         CSE019
      ** 'P' or 'R' else new status field is 'A' for authorised                 CSE019
      *                                                                         CSE019
     C     RECI          IFEQ      'L'                                          CSE019
     C     RECI          OREQ      'P'                                          CSE019
     C     RECI          OREQ      'R'                                          CSE019
     C                   MOVE      'N'           WWSTSI                         CSE019
     C                   ELSE                                                   CSE019
     C                   MOVE      'A'           WWSTSI                         CSE019
     C                   ENDIF                                                  CSE019
      *                                                                         CSE019
     C                   ENDIF                                                  CSE019
      *                                                                         CSE019
     C                   ENDIF                                                  CSE019
      *                                                                         CSE019
     C                   ENDIF                                                  CSE019
      *                                                                         CSE019
     C                   ENDSR                                                  CSE019
      *****************************************************************
      /EJECT
      *****************************************************************
      * CHAUTN - CHECK FOR USER AUTHORITY IF NOT MULTI-BRANCHING
      *****************************************************************
     C     CHAUTN        BEGSR
      *
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN             1
     C                   PARM                    @@ERR             1 0
      *
      * RETURN ERROR MESSAGE
      *
     C     @@ERR         IFEQ      1
     C                   MOVEL     'FXM0292'     @ERRMS
     C                   RETURN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALTDRF - VALIDATE TRADE REFERENCE POINTER
      *****************************************************************
     C     VALTDRF       BEGSR
      *
      **  Validate that the trade reference is numeric or blank.
      *
     C                   TESTN                   DDTDRF               98
     C                   MOVE      DDTDRF        @@TEST            1
     C                   TESTZ                   @@TEST                   99
     C     DDTDRF        IFEQ      *BLANKS
     C     *IN98         OREQ      '1'
     C     *IN99         ANDEQ     '1'
     C                   MOVE      DDTDRF        @@TDRF            6
      *
      * RETURN ERROR MESSAGE
      *
     C                   ELSE
     C                   MOVEL     'MMA0087'     @ERRMS
     C                   RETURN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CSE010
      *****************************************************************                       CSE010
      * VALINP - Validation of Input fields                           *                       CSE010
      *                                                               *                       CSE010
      * Called By: BLDSFL - Build Subfile                             *                       CSE010
      *                                                               *                       CSE010
      * Calls:     SE0043   - Securities Selection                    *                       CSE010
      *            AOSECSR0 - AO Securities Clients                   *                       CSE010
      *            AOCUSTR0 - AO Customer Details                     *                       CSE010
      *            ZDATE1   - Validate & Convert Date to a number     *                       CSE010
      *                                                               *                       CSE010
      *****************************************************************                       CSE010
     C     VALINP        BEGSR                                                                CSE010
      *                                                                                       CSE010
      ** If a '?' is found in the Security Shortname field, call SE0041                       CSE010
      *                                                                                       CSE010
     C     '?'           SCAN      STDSS                                  31                  CSE010
      *                                                                                       CSE010
     C     *IN31         IFEQ      *ON                                                        CSE010
     C                   MOVE      STDSS         @SESN                                        CSE010
     C                   CALL      'SE0043'                                                   CSE010
     C                   PARM      DDACTN        @ACTN             1                          CSE010
     C                   PARM                    @SESN            10                          CSE010
      *                                                                                       CSE010
     C     @SESN         IFNE      *Blanks                                                    CSE010
     C                   MOVEL     @SESN         STDSS                                        CSE010
     C                   ELSE                                                                 CSE010
     C                   MOVE      *Blanks       STDSS                                        CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   MOVE      STDSS         KTDSS            10                          CSE010
      *                                                                                       CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
      ** If a "?" is found in the Trade Counterparty field,                                   CSE010
      ** Call AOSECSR0                                                                        CSE010
      *                                                                                       CSE010
     C     '?'           SCAN      STCNR                                  30                  CSE010
      *                                                                                       CSE010
     C     *IN30         IFEQ      *ON                                                        CSE010
     C                   MOVEL     STCNR         @CUST                                        CSE010
     C                   CALL      'AOSECSR0'                                                 CSE010
     C                   PARM      *Blanks       @RTCD                                        CSE010
     C                   PARM                    @OPTN                                        CSE010
     C                   PARM                    @CUST             6                          CSE010
     C     SDSECS        PARM      SDSECS        DSFDY                                        CSE010
      *                                                                                       CSE010
     C     @RTCD         IFEQ      *Blanks                                                    CSE010
     C                   MOVEL     @CUST         STCNR                                        CSE010
      *                                                                                       CSE010
      ** Call AOCUSTR0 to get the Customer Shortname                                          CSE010
      *                                                                                       CSE010
     C                   CALLB     'AOCUSTR0'                                                 CSE010
     C                   PARM      *BLANKS       PRTCD             7                          CSE010
     C                   PARM      '*KEY   '     POPTN             7                          CSE010
     C                   PARM      @CUST         PKEY1            10                          CSE010
     C                   PARM                    PKYST             7                          CSE010
     C     SDCUST        PARM      SDCUST        DSSDY                                        CSE010
      *                                                                                       CSE010
     C     PRTCD         IFEQ      *Blanks                                                    CSE010
     C                   MOVEL     BBCSSN        STCNR                                        CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   ELSE                                                                 CSE010
     C                   MOVE      *Blanks       STCNR                                        CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C**********         MOVEL     @CUST         WKTCNR            6 0                 CSE010 CSD027
     C                   MOVEL     @CUST         WKTCNR            6                          CSD027
      *                                                                                       CSE010
     C                   ENDIF                                                                CSE010
      *                                                                         CSE019
     C     CSE019        Ifeq      'Y'                                          CSE019
      *                                                                         CSE019
      ** If a '?' is found in the Book Code field, Access to AOBOOKR0           CSE019
      *                                                                         CSE019
     C     '?'           Scan      STDBK                                  31    CSE019
      *                                                                         CSE019
     C     *IN31         Ifeq      *ON                                          CSE019
     C                   Callb     'AOBOOKR0'                                   CSE019
     C                   Parm      *Blanks       PRTCD                          CSE019
     C                   Parm      '*KEY   '     POPTN                          CSE019
     C                   Parm      STDBK         PTDBK                          CSE019
     C     SDBOOK        Parm      SDBOOK        DSFDY                          CSE019
      *                                                                         CSE019
     C     PRTCD         Ifeq      *Blanks                                      CSE019
     C                   Movel     BDBKCD        STDBK                          CSE019
     C                   Else                                                   CSE019
     C                   Move      *Blanks       STDBK                          CSE019
     C                   Endif                                                  CSE019
     C                   Endif                                                  CSE019
     C                   Endif                                                  CSE019
      *                                                                                       CSE010
      ** If New Selection has been entered                                                    CSE010
      *                                                                                       CSE010
     C     STRDT         IFNE      WTRDT                                                      CSE010
     C     STDRF         ORNE      WTDRF                                                      CSE010
     C     STDSS         ORNE      WTDSS                                                      CSE010
     C     STCNR         ORNE      WTCNR                                                      CSE010
     C     STINC         ORNE      WTINC                                                      CSE010
     C     SSTSI         ORNE      WSTSI                                                      CSE010
     C     SORNO         ORNE      WORNO                                                      CSE010
     C     STDTP         ORNE      WTDTP                                        CSE019
     C     STDVD         ORNE      WTDVD                                        CSE019
     C     STDBK         ORNE      WTDBK                                        CSE019
     C     SFRNT         ORNE      WFRNT                                        CSE019
     C     *INKE         OREQ      *ON                                                        CSE010
      *                                                                                       CSE010
      ** Save selection fields                                                                CSE010
      *                                                                                       CSE010
     C                   MOVEL     STRDT         WTRDT                                        CSE010
     C                   MOVEL     STDRF         WTDRF                                        CSE010
     C                   MOVEL     STDSS         WTDSS                                        CSE010
     C                   MOVEL     STCNR         WTCNR                                        CSE010
     C                   MOVEL     STINC         WTINC                                        CSE010
     C                   MOVEL     SSTSI         WSTSI                                        CSE010
     C                   MOVEL     SORNO         WORNO                                        CSE010
     C                   MOVEL     STDTP         WTDTP                          CSE019
     C                   MOVEL     STDVD         WTDVD                          CSE019
     C                   MOVEL     STDBK         WTDBK                          CSE019
     C                   MOVEL     SFRNT         WFRNT                          CSE019
      *                                                                                       CSE010
     C                   MOVE      'Y'           WnewSel                                      CSE010
     C                   MOVE      STDRF         KTDRF             6                          CSE010
     C                   Z-ADD     *Zeros        KORDE             6 0                        CSE010
     C**********         MOVE      WKTCNR        KTCNR             6 0                 CSE010 CSD027
     C                   MOVE      WKTCNR        KTCNR             6                          CSD027
      *                                                                                       CSE010
      ** If rollup is pressed                                                                 CSE010
      *                                                                                       CSE010
     C     *IN98         IFEQ      *ON                                                        CSE010
     C                   MOVE      *OFF          *IN98                                        CSE010
     C                   MOVE      *OFF          *IN26                                        CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
      ** IF F16(Scan) has not been requested and scan indicator 26 is on                      CSE010
      *                                                                                       CSE010
     C     *INKQ         IFEQ      *OFF                                                       CSE010
     C     *IN26         ANDEQ     *ON                                                        CSE010
     C                   MOVE      *OFF          *IN26                                        CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   ELSE                                                                 CSE010
     C                   MOVE      'N'           WNewSel                                      CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
      ** If the security shortname is not blanks, check that the                              CSE010
      ** shortname is correct by chaining to security file, SECTYD                            CSE010
      *                                                                                       CSE010
     C     STDSS         IFNE      *BLANKS                                                    CSE010
     C     *INKQ         ANDEQ     *OFF                                                       CSE010
     C     *IN26         ANDEQ     *OFF                                                       CSE010
     C     STDSS         CHAIN     SECTYDF                            31                      CSE010
      *                                                                                       CSE010
      ** If record not found, database error                                                  CSE010
      *                                                                                       CSE010
     C     *IN31         IFEQ      *ON                                                        CSE010
     C**********         MOVEL     'SECTY'       DBFILE                  CSE010 CSE019
     C**********         MOVEL     '906'         DBASE                   CSE010 CSE019
     C**********         MOVEL     STDSS         DBKEY                   CSE010 CSE019
     C**********         EXSR      *PSSR                                 CSE010 CSE019
     C                   Add       1             Ix                             CSE019
     C                   Move      'SEW1023'     MsgIdArr(Ix)                   CSE019
     C                   Movel     'DDTDSS'      FldNameArr(Ix)                 CSE019
     C                   Move      *ON           *IN32                          CSE019
     C                   ELSE                                                                 CSE010
     C                   MOVE      STDSS         KTDSS                                        CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   ENDIF                                                                CSE010
      *                                                                         CSE019
     C     STCNR         Ifne      *Blanks                                      CSE019
     C                   Movel     STCNR         PKEY1                          CSE019
      *                                                                         CSE019
      ** Call AOCUSTR0 to get the Customer Shortname                            CSE019
      *                                                                         CSE019
     C                   Callb     'AOCUSTR0'                                   CSE019
     C                   PARM      *Blanks       PRTCD             7            CSE019
     C                   PARM      '*KEY   '     POPTN             7            CSE019
     C                   PARM                    PKEY1            10            CSE019
     C                   PARM                    PKYST             7            CSE019
     C     SDCUST        PARM      SDCUST        DSSDY                          CSE019
      *                                                                         CSE019
     C     PRTCD         Ifeq      *BLANKS                                      CSE019
     C                   Callb     'AOSECSR0'                                   CSE019
     C                   Parm      *Blanks       PRTCD                          CSE019
     C                   Parm      '*KEY   '     POPTN                          CSE019
     C                   Parm      BBCUST        @KEY6             6            CSE019
     C     SDSECS        Parm      SDSECS        DSFDY                          CSE019
     C                   Endif                                                  CSE019
      *                                                                         CSE019
     C     PRTCD         Ifne      *Blanks                                      CSE019
     C                   Add       1             Ix                             CSE019
     C                   Move      'SEW1030'     MsgIdArr(Ix)                   CSE019
     C                   Movel     'DDTCNR'      FldNameArr(Ix)                 CSE019
     C                   Move      *on           *IN37                          CSE019
     C**********         Z-add     *Zeros        KTCNR             6 0          CSE019        CSD027
     C                   Move      *Blanks       KTCNR             6            CSE019        CSD027
     C                   Else                                                   CSE019
     C**********         Movel     BBCUST        KTCNR             6 0          CSE019        CSD027
     C                   Movel     BBCUST        KTCNR             6            CSE019        CSD027
     C                   Endif                                                  CSE019
     C                   Endif                                                  CSE019
      *                                                                                       CSE010
      ** If the trade date is not blanks, check if date is correct                            CSE010
      *                                                                                       CSE010
     C     STRDT         IFNE      *BLANKS                                                    CSE010
     C                   CALLB     'ZDATE1'                                                   CSE010
     C                   Parm      STRDT         DateIn                                       CSE010
     C                   Parm                    DaynoOut                                     CSE010
     C                   PARM                    BJDFIN                                       CSE010
     C                   PARM                    ErrorFlag                                    CSE010
      *                                                                                       CSE010
     C     ErrorFlag     IFEQ      'N'                                                        CSE010
     C                   Z-ADD     DaynoOut      KDate                                        CSE010
     C                   ELSE                                                                 CSE010
     C                   Z-ADD     99999         KDate             5 0                        CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   ELSE                                                                 CSE010
     C                   Z-ADD     99999         KDate                                        CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
      ** Check if Incomplete indicator is valid                                               CSE010
      *                                                                                       CSE010
     C     STINC         IFNE      'I'                                                        CSE010
     C     STINC         ANDNE     'C'                                                        CSE010
     C     STINC         ANDNE     *BLANKS                                                    CSE010
     C                   Add       1             Ix                                           CSE010
     C                   MOVEL     'SEW1014'     MsgIdArr(Ix)                                 CSE010
     C                   MOVEL     'DDINCS'      FldNameArr(Ix)                               CSE010
     C                   MOVE      *ON           *IN27                                        CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
      ** Check if status indicator is valid                                                   CSE010
      *                                                                                       CSE010
     C     SSTSI         IFNE      'A'                                                        CSE010
     C     SSTSI         ANDNE     'N'                                                        CSE010
     C     SSTSI         ANDNE     'S'                                                        CSE010
     C     SSTSI         ANDNE     'C'                                                        CSE010
     C     SSTSI         ANDNE     *Blanks                                                    CSE010
     C                   Add       1             Ix                                           CSE010
     C                   MOVE      'SEW1015'     MsgIdArr(Ix)                                 CSE010
     C                   MOVEL     'DDSTSI'      FldNameArr(Ix)                               CSE010
     C                   MOVE      *ON           *IN28                                        CSE010
     C                   ENDIF                                                                CSE010
      *                                                                         CSE019
     C     CSE019        Ifeq      'Y'                                          CSE019
      *                                                                         CSE019
      ** Check if Trade Type is valid: 'TP' or 'TS'                             CSE019
      *                                                                         CSE019
     C     STDTP         Ifne      'TP'                                         CSE019
     C     STDTP         Andne     'TS'                                         CSE019
     C     STDTP         Andne     *Blanks                                      CSE019
     C                   Add       1             Ix                             CSE019
     C                   Move      'SEW1020'     MsgIdArr(Ix)                   CSE019
     C                   Movel     'DDTDTP'      FldNameArr(Ix)                 CSE019
     C                   Move      *ON           *IN33                          CSE019
     C                   Endif                                                  CSE019
      *                                                                         CSE019
      ** If the Value date is not blanks, check if date is correct              CSE019
      *                                                                         CSE019
     C     STDVD         Ifne      *BLANKS                                      CSE019
     C                   Callb     'ZDATE1'                                     CSE019
     C                   Parm      STDVD         DateIn                         CSE019
     C                   Parm                    DaynoOut                       CSE019
     C                   Parm                    BJDFIN                         CSE019
     C                   Parm                    ErrorFlag                      CSE019
      *                                                                         CSE019
     C     ErrorFlag     Ifeq      'N'                                          CSE019
     C                   Z-add     DaynoOut      KVDate                         CSE019
     C                   Else                                                   CSE019
     C                   Z-add     0             KVDate            5 0          CSE019
     C                   Add       1             Ix                             CSE019
     C                   Move      'SEW1021'     MsgIdArr(Ix)                   CSE019
     C                   Movel     'DDTDVD'      FldNameArr(Ix)                 CSE019
     C                   Move      *ON           *IN34                          CSE019
     C                   Endif                                                  CSE019
      *                                                                         CSE019
     C                   Else                                                   CSE019
     C                   Z-add     0             KVDate                         CSE019
     C                   Endif                                                  CSE019
      *                                                                         CSE019
      ** If the Settlement date is not blanks, check if date is correct         CSE019
      *                                                                         CSE019
     C     SORNO         Ifne      *BLANKS                                      CSE019
     C                   Callb     'ZDATE1'                                     CSE019
     C                   Parm      SORNO         DateIn                         CSE019
     C                   Parm                    DaynoOut                       CSE019
     C                   Parm                    BJDFIN                         CSE019
     C                   Parm                    ErrorFlag                      CSE019
      *                                                                         CSE019
     C     ErrorFlag     Ifeq      'N'                                          CSE019
     C                   Z-add     DaynoOut      KSDate                         CSE019
     C                   Else                                                   CSE019
     C                   Z-add     0             KSDate            5 0          CSE019
     C                   Add       1             Ix                             CSE019
     C                   Move      'SEW1022'     MsgIdArr(Ix)                   CSE019
     C                   Movel     'DDORNO'      FldNameArr(Ix)                 CSE019
     C                   Move      *ON           *IN29                          CSE019
     C                   Endif                                                  CSE019
      *                                                                         CSE019
     C                   Else                                                   CSE019
     C                   Z-add     0             KSDate                         CSE019
     C                   Endif                                                  CSE019
      *                                                                         CSE019
      ** Check if Book Code is valid                                            CSE019
      *                                                                         CSE019
     C     STDBK         Ifne      *blanks                                      CSE019
     C                   Callb     'AOBOOKR0'                                   CSE019
     C                   Parm      *Blanks       PRTCD                          CSE019
     C                   Parm      '*KEY   '     POPTN                          CSE019
     C                   Parm      STDBK         PTDBK             2            CSE019
     C     SDBOOK        Parm      SDBOOK        DSFDY                          CSE019
      *                                                                         CSE019
     C     PRTCD         Ifne      *blanks                                      CSE019
     C                   Add       1             Ix                             CSE019
     C                   Move      'SEW1029'     MsgIdArr(Ix)                   CSE019
     C                   Movel     'DDTDBK'      FldNameArr(Ix)                 CSE019
     C                   Move      *ON           *IN35                          CSE019
     C                   Else                                                   CSE019
     C                   Movel     BDBKCD        STDBK                          CSE019
     C                   Endif                                                  CSE019
     C                   Endif                                                  CSE019
     C                   Endif                                                  CSE019
      *                                                                                       CSE010
      ** Check that the Order Number is numeric or Blanks                                     CSE010
      *                                                                                       CSE010
     C     SORNO         IFNE      *Blanks                                                    CSE010
     C     CSE019        Andne     'Y'                                          CSE019
     C                   TESTN                   SORNO                30                      CSE010
      *                                                                                       CSE010
     C     *IN30         IFEQ      *OFF                                                       CSE010
     C                   Add       1             Ix                                           CSE010
     C                   MOVEL     'SEW1016'     MsgIdArr(Ix)                                 CSE010
     C                   MOVEL     'DDORDE'      FldNameArr(Ix)                               CSE010
     C                   MOVE      *ON           *IN29                                        CSE010
     C                   ELSE                                                                 CSE010
     C                   MOVE      SORNO         KORDE                                        CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
      ** If no new selection have been made and rollup not requested, and                     CSE010
      ** scan not requested                                                                   CSE010
      *                                                                                       CSE010
     C     WNewSel       IFNE      'Y'                                                        CSE010
     C     *IN98         ANDEQ     *OFF                                                       CSE010
     C     *INKQ         ANDEQ     *OFF                                                       CSE010
     C                   MOVEL     'N'           WNewSel                                      CSE010
     C                   ELSE                                                                 CSE010
     C                   MOVEL     'Y'           WNewSel                                      CSE010
     C                   ENDIF                                                                CSE010
      *                                                                         CSE019
     C     CSE019        IFEQ      'Y'                                          CSE019
     C     WWFMT         ANDNE     WSFMT                                        CSE019
     C                   MOVE      'Y'           WNewsel                        CSE019
     C                   ENDIF                                                  CSE019
      *                                                                                       CSE010
      ** If Scan has been requested                                                           CSE010
      *                                                                                       CSE010
     C     *INKQ         IFEQ      *ON                                                        CSE010
     C                   MOVE      *ON           *IN26                                        CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
      ** Check if Scan requested, F16, Security Shortname has been entered                    CSE010
      *                                                                                       CSE010
     C     *INKQ         IFEQ      *ON                                                        CSE010
     C     WTDSS         ANDEQ     *BLANKS                                                    CSE010
     C                   Add       1             Ix                                           CSE010
     C                   MOVE      'SEW1017'     MsgIdArr(Ix)                                 CSE010
     C                   MOVEL     'DDSESN'      FldNameArr(Ix)                               CSE010
     C                   MOVE      *ON           *IN32                                        CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C     WFIRST        IFNE      'Y'                                                        CSE010
     C                   Move      'Y'           WNewSel                                      CSE010
     C                   Move      'Y'           WFIRST            1                          CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
      ** Build subfile keyed on order no.                                                     CSE010
      *                                                                                       CSE010
     C     STRDT         IFEQ      *BLANKS                                                    CSE010
     C     STDRF         ANDEQ     *BLANKS                                                    CSE010
     C     STDSS         ANDEQ     *BLANKS                                                    CSE010
     C     STCNR         ANDEQ     *BLANKS                                                    CSE010
     C     STINC         ANDEQ     *BLANKS                                                    CSE010
     C     SSTSI         ANDEQ     *BLANKS                                                    CSE010
     C     SORNO         ANDEQ     *BLANKS                                                    CSE010
     C     CSE019        ANDNE     'Y'                                          CSE019
     C                   MOVE      EXORDE        KORDE                                        CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   ENDSR                                                                CSE010
      *****************************************************************                       CSE010
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
      *
      * CLEAR OUTPUTS
      *
     C     CSE010        IFEQ      'N'                                                        CSE010
     C     CSE019        ANDNE     'Y'                                          CSE019
     C                   MOVE      *BLANK        @ERRMS
     C                   MOVE      *BLANK        @OPSEL
     C                   MOVE      *BLANK        @TRSEL
     C                   ENDIF                                                                CSE010
     C                   MOVE      '0'           @INKC
     C                   MOVE      '0'           @INKL
     C                   MOVE      '0'           *IN20                          CAP004
      *                                                                                       CSE010
      ** Import order number field if CPB001 is installed                                     CSE010
      *                                                                                       CSE010
     C     CPB001        IFEQ      'Y'                                                        CSE010
     C     CSE019        ANDNE     'Y'                                          CSE019
     C                   MOVE      EXORDE        KORDE             6 0                        CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
      ** Initialize error indicators                                                          CSE010
      *                                                                                       CSE010
     C                   Eval      *in22 = False                                CSE019
     C     CSE010        IFEQ      'Y'                                                        CSE010
     C     CSE019        OREQ      'Y'                                          CSE019
     C                   MOVE      *OFF          *IN32                                        CSE010
     C                   MOVE      *OFF          *IN27                                        CSE010
     C                   MOVE      *OFF          *IN28                                        CSE010
     C                   MOVE      *OFF          *IN29                                        CSE010
     C                   Move      False         *IN33                          CSE019
     C                   Move      False         *IN34                          CSE019
     C                   Move      False         *IN35                          CSE019
     C                   Move      False         *IN36                          CSE019
     C                   Move      False         *IN37                          CSE019
      *                                                                         CSE019
     C     CSE019        Ifeq      'Y'                                          CSE019
     C                   Eval      *in22 = True                                 CSE019
     C     @BDSFL        Ifeq      'Y'                                          CSE019
     C                   Eval      WWFMT = 'First'                              CSE019
     C                   Endif                                                  CSE019
     C                   Endif                                                  CSE019
     C                   ENDIF                                                                CSE010
      *                                                                         CSE019
     C     CPB001        Ifeq      'Y'                                          CSE019
     C                   Eval      *in21 = True                                 CSE019
     C                   Else                                                   CSE019
     C                   Eval      *in21 = False                                CSE019
     C                   Endif                                                  CSE019
      *
     C/COPY WNCPYSRC,SETRADBC06
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * ZEDIT - Edit an unsigned field                                *
      *                                                               *
      *****************************************************************
     C     ZEDIT         BEGSR
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * ZDATE2 - Format a date for output                             *
      *                                                               *
      *****************************************************************
     C     ZDATE2        BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
 
     C                   ENDSR
     C********************************************************************
      /EJECT                                                                                  CSE010
      *****************************************************************                       CSE010
      *                                                               *                       CSE010
      * SEL - Selection                                               *                       CSE010
      *                                                               *                       CSE010
      * Called By: BLDSFL - Build Subfile                             *                       CSE010
      *                                                               *                       CSE010
      * Calls:     SELORDE    - Selection by Order Number             *                       CSE010
      *            SELSECTY   - Selection by Security Shortname       *                       CSE010
      *            SELCUST    - Selection by Customer Number          *                       CSE010
      *            SELSECCUST - Selection by Sucurity Shortname &     *                       CSE010
      *                         Customer Number                       *                       CSE010
      *            SELTDRF    - Selection by Trade Reference          *                       CSE010
      *            SELSCAN    - Selection if F16 is pressed           *                       CSE010
      *            SELOTHER   - Selection by Trade Date               *                       CSE010
      *                                                               *                       CSE010
      *****************************************************************                       CSE010
     C     SEL           BEGSR                                                                CSE010
      *                                                                                       CSE010
     C     *IN98         IFEQ      *OFF                                                       CSE010
     C                   MOVE      *ON           *IN97                                        CSE010
     C                   WRITE     SETRADS4                                                   CSE010
     C     CSE019        Ifeq      'Y'                                          CSE019
     C                   WRITE     SETRADS8                                     CSE019
     C                   Endif                                                  CSE019
     C                   MOVE      *OFF          *IN97                                        CSE010
     C                   Z-ADD     *Zeros        @@RRN                                        CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   SELECT                                                               CSE010
      *                                                                         CSE019
     C     SFRNT         Whenne    *Blanks                                      CSE019
     C                   EXSR      SELFRONT                                     CSE019
      *                                                                                       CSE010
     C     KORDE         WHENNE    *ZEROS                                                     CSE010
     C     CSE019        Andne     'Y'                                          CSE019
     C                   EXSR      SELORDE                                                    CSE010
      *                                                                                       CSE010
     C     STDSS         WHENNE    *BLANKS                                                    CSE010
     C     STCNR         ANDEQ     *BLANKS                                                    CSE010
     C     *IN26         ANDEQ     *OFF                                                       CSE010
     C                   EXSR      SELSECTY                                                   CSE010
      *                                                                                       CSE010
     C     STDSS         WHENEQ    *BLANKS                                                    CSE010
     C     STCNR         ANDNE     *BLANKS                                                    CSE010
     C     *IN26         ANDEQ     *OFF                                                       CSE010
     C                   EXSR      SELCUST                                                    CSE010
      *                                                                                       CSE010
     C     STDSS         WHENNE    *BLANKS                                                    CSE010
     C     STCNR         ANDNE     *BLANKS                                                    CSE010
     C     *IN26         ANDEQ     *OFF                                                       CSE010
     C                   EXSR      SELSECCUST                                                 CSE010
      *                                                                                       CSE010
     C     STDRF         WHENNE    *BLANKS                                                    CSE010
     C     STRDT         ANDEQ     *BLANKS                                                    CSE010
     C     STDSS         ANDEQ     *BLANKS                                                    CSE010
     C     STCNR         ANDEQ     *BLANKS                                                    CSE010
     C                   EXSR      SELTDRF                                                    CSE010
      *                                                                         CSE019
     C     KVDate        Whenne    *Zeros                                       CSE019
     C     CSE019        Andeq     'Y'                                          CSE019
     C                   EXSR      SELVDATE                                     CSE019
      *                                                                         CSE019
     C     KSDate        Whenne    *Zeros                                       CSE019
     C     CSE019        Andeq     'Y'                                          CSE019
     C                   EXSR      SELSDATE                                     CSE019
      *                                                                                       CSE010
     C     *IN26         WHENEQ    *ON                                                        CSE010
     C                   EXSR      SELSCAN                                                    CSE010
      *                                                                                       CSE010
     C                   OTHER                                                                CSE010
     C                   EXSR      SELOTHER                                                   CSE010
      *                                                                                       CSE010
     C                   ENDSL                                                                CSE010
      *                                                                                       CSE010
     C                   ENDSR                                                                CSE010
      *****************************************************************                       CSE010
      /EJECT                                                                                  CSE010
      *****************************************************************                       CSE010
      * SELORDE - Selection by Order Number                           *                       CSE010
      *                                                               *                       CSE010
      * Called By: SEL    - Selection                                 *                       CSE010
      *                                                               *                       CSE010
      * Calls:     RDTDRF -   - Read a Trade                          *                       CSE010
      *            FMTTRD     - Format a Trade for output             *                       CSE010
      *                                                               *                       CSE010
      *****************************************************************                       CSE010
     C     SELORDE       BEGSR                                                                CSE010
      *                                                                                       CSE010
     C     Key3          KLIST                                                                CSE010
     C                   KFLD                    KORDE                                        CSE010
     C                   KFLD                    KTDRF                                        CSE010
      *                                                                                       CSE010
     C     *IN98         IFEQ      *OFF                                                       CSE010
     C     Key3          SETLL     @TRADL9                                                    CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   MOVEL     *Blanks       FILE                                         CSE010
     C                   MOVEL     'ORDER'       FILE                                         CSE010
     C                   EXSR      RDTDRF                                                     CSE010
      *                                                                                       CSE010
     C     @@EOF         DOWNE     'Y'                                                        CSE010
     C*****@@CNT         ANDLT     14                                                  CSE010 CSE016
     C     @@CNT         ANDLT     7                                                          CSE016
      *                                                                                       CSE010
      ** If Screen Trade Reference is less than or equal to file Trade                        CSE010
      ** Reference, and screen Trade Date is after or equal to file                           CSE010
      ** Trade Date                                                                           CSE010
      *                                                                                       CSE010
     C     STDRF         IFLE      TDRF                                                       CSE010
      *                                                                                       CSE010
     C     STDRF         IFNE      *Blanks                                                    CSE010
     C     DaynoOut      ANDGE     TDDT                                                       CSE010
      *                                                                                       CSE010
     C     STRDT         OREQ      *Blanks                                                    CSE010
      *                                                                                       CSE010
      ** If screen Security Shortname is blank or equals file Security                        CSE010
      ** Shortname                                                                            CSE010
      *                                                                                       CSE010
     C     STDSS         IFEQ      *BLANKS                                                    CSE010
     C     STDSS         OREQ      TDSS                                                       CSE010
      *                                                                                       CSE010
      ** If Screen Customer is blanks or equals file Customer                                 CSE010
      *                                                                                       CSE010
     C**********         Z-ADD     *ZEROS        WWTCNR            6 0                 CSE010 CSD027
     C                   MOVE      *BLANKS       WWTCNR            6                          CSD027
     C                   MOVE      @CUST         WWTCNR                                       CSE010
      *                                                                                       CSE010
     C     STCNR         IFEQ      *BLANKS                                                    CSE010
     C     WWTCNR        OREQ      TCNR                                                       CSE010
      *                                                                                       CSE010
      ** If screen Incomplete Indicator is blanks or equal to file                            CSE010
      ** Incomplete indicator                                                                 CSE010
      *                                                                                       CSE010
     C     STINC         IFEQ      *BLANKS                                                    CSE010
     C     STINC         OREQ      TINC                                                       CSE010
      *                                                                         CSE019
     C                   Exsr      SETSTAT                                      CSE019
      *                                                                         CSE019
      ** If screen Status Indicator is blanks or equal to Status Trade          CSE019
      *                                                                         CSE019
     C     SSTSI         IFEQ      *BLANKS                                      CSE019
     C     SSTSI         OREQ      WWSTSI                                       CSE019
      *                                                                         CSE019
      ** If screen Trade Type is blanks or equal to Trade Type of the trade     CSE019
      *                                                                         CSE019
     C     STDTP         IFEQ      *BLANKS                                      CSE019
     C     STDTP         OREQ      TDTP                                         CSE019
      *                                                                         CSE019
      ** If screen Book Code is blanks or equal to Book Code of the trade       CSE019
      *                                                                         CSE019
     C     STDBK         IFEQ      *BLANKS                                      CSE019
     C     STDBK         OREQ      TDBK                                         CSE019
      *                                                                         CSE019
      ** If screen Value Date is blanks or equal to Value Date of the Trade     CSE019
      *                                                                         CSE019
     C     KVDate        IFEQ      *ZEROS                                       CSE019
     C     KVDate        OREQ      TDVD                                         CSE019
      *                                                                         CSE019
      ** If screen Settl Date is blanks or equal to Settl Date of the Trade     CSE019
      *                                                                         CSE019
     C     KSDate        IFEQ      *ZEROS                                       CSE019
     C     KSDate        OREQ      TDFS                                         CSE019
      *                                                                                       CSE010
      ** Increase subfile record count, increase subfile page count,                          CSE010
      ** execute FMTTRD, write subfile record and execute subroutine RDTDRF                   CSE010
      *                                                                                       CSE010
     C                   ADD       1             @@RRN                                        CSE010
     C                   ADD       1             @@CNT                                        CSE010
     C                   EXSR      FMTTRD                                                     CSE010
     C                   WRITE     SETRADS5                                                   CSE010
     C     CSE019        IFEQ      'Y'                                          CSE019
     C                   WRITE     SETRADS7                                     CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   EXSR      RDTDRF                                                     CSE010
      *                                                                                       CSE010
     C                   ENDDO                                                                CSE010
      *                                                                                       CSE010
     C                   READP     @TRADL9                                50                  CSE010
      *                                                                                       CSE010
     C                   ENDSR                                                                CSE010
      *****************************************************************                       CSE010
      /EJECT                                                                                  CSE010
      *****************************************************************                       CSE010
      *                                                               *                       CSE010
      * SELSECTY - Selection by Security Shortname                    *                       CSE010
      *                                                               *                       CSE010
      * Called By: SEL    - Selection                                 *                       CSE010
      *                                                               *                       CSE010
      * Calls:     RDTDRF -   - Read a Trade                          *                       CSE010
      *            FMTTRD     - Format a Trade for output             *                       CSE010
      *                                                               *                       CSE010
      *****************************************************************                       CSE010
     C     SELSECTY      BEGSR                                                                CSE010
      *                                                                                       CSE010
     C     Key4          KLIST                                                                CSE010
     C                   KFLD                    KTDSS                                        CSE010
     C                   KFLD                    KDate                                        CSE010
     C                   KFLD                    KTDRF                                        CSE010
      *                                                                                       CSE010
     C     *IN98         IFEQ      *OFF                                                       CSE010
     C     Key4          SETLL     TRADSRD                                                    CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   MOVEL     *Blanks       FILE                                         CSE010
     C                   MOVEL     'SECTY'       FILE                                         CSE010
     C                   EXSR      RDTDRF                                                     CSE010
      *                                                                                       CSE010
     C     @@EOF         DOWNE     'Y'                                                        CSE010
     C*****@@CNT         ANDLT     14                                                  CSE010 CSE016
     C     @@CNT         ANDLT     7                                                          CSE016
      *                                                                                       CSE010
      ** If screen Trade Reference is less than or equal to file Trade                        CSE010
      ** reference, and screen Trade Date is after or equals file Trade Date                  CSE010
      *                                                                                       CSE010
     C     STDRF         IFLE      TDRF                                                       CSE010
      *                                                                                       CSE010
     C     STRDT         IFNE      *BLANKS                                                    CSE010
     C     DaynoOut      ANDGE     TDDT                                                       CSE010
     C     STRDT         OREQ      *BLANKS                                                    CSE010
      *                                                                                       CSE010
      ** If screen Incomplete Indicator is blanks or equal to file                            CSE010
      *                                                                                       CSE010
     C     STINC         IFEQ      *Blanks                                                    CSE010
     C     STINC         OREQ      TINC                                                       CSE010
      *                                                                         CSE019
     C                   Exsr      SETSTAT                                      CSE019
      *                                                                         CSE019
      ** If screen Status Indicator is blanks or equal to Status Trade          CSE019
      *                                                                         CSE019
     C     SSTSI         IFEQ      *BLANKS                                      CSE019
     C     SSTSI         OREQ      WWSTSI                                       CSE019
      *                                                                         CSE019
      ** If screen Trade Type is blanks or equal to Trade Type of the trade     CSE019
      *                                                                         CSE019
     C     STDTP         IFEQ      *BLANKS                                      CSE019
     C     STDTP         OREQ      TDTP                                         CSE019
      *                                                                         CSE019
      ** If screen Book Code is blanks or equal to Book Code of the trade       CSE019
      *                                                                         CSE019
     C     STDBK         IFEQ      *BLANKS                                      CSE019
     C     STDBK         OREQ      TDBK                                         CSE019
      *                                                                         CSE019
      ** If screen Value Date is blanks or equal to Value Date of the Trade     CSE019
      *                                                                         CSE019
     C     KVDate        IFEQ      *ZEROS                                       CSE019
     C     KVDate        OREQ      TDVD                                         CSE019
      *                                                                         CSE019
      ** If screen Settl Date is blanks or equal to Settl Date of the Trade     CSE019
      *                                                                         CSE019
     C     KSDate        IFEQ      *ZEROS                                       CSE019
     C     KSDate        OREQ      TDFS                                         CSE019
     C                   ADD       1             @@RRN                                        CSE010
     C                   ADD       1             @@CNT                                        CSE010
     C                   EXSR      FMTTRD                                                     CSE010
     C                   WRITE     SETRADS5                                                   CSE010
     C     CSE019        IFEQ      'Y'                                          CSE019
     C                   WRITE     SETRADS7                                     CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   EXSR      RDTDRF                                                     CSE010
     C                   ENDDO                                                                CSE010
      *                                                                                       CSE010
     C                   READP     TRADSRD                                50                  CSE010
      *                                                                                       CSE010
     C                   ENDSR                                                                CSE010
      *****************************************************************                       CSE010
      /EJECT                                                                                  CSE010
      *****************************************************************                       CSE010
      *                                                               *                       CSE010
      * SELCUST - Selection by Customer Number                        *                       CSE010
      *                                                               *                       CSE010
      * Called By: SEL    - Selection                                 *                       CSE010
      *                                                               *                       CSE010
      * Calls:     RDTDRF -   - Read a Trade                          *                       CSE010
      *            FMTTRD     - Format a Trade for output             *                       CSE010
      *                                                               *                       CSE010
      *****************************************************************                       CSE010
     C     SELCUST       BEGSR                                                                CSE010
      *                                                                                       CSE010
     C     Key5          KLIST                                                                CSE010
     C                   KFLD                    KTCNR                                        CSE010
     C                   KFLD                    KDate                                        CSE010
     C                   KFLD                    KTDRF                                        CSE010
      *                                                                                       CSE010
     C     *IN98         IFEQ      *OFF                                                       CSE010
     C     Key5          SETLL     @TRADL7                                                    CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   MOVEL     *Blanks       FILE                                         CSE010
     C                   MOVEL     'CUST'        FILE                                         CSE010
     C                   EXSR      RDTDRF                                                     CSE010
      *                                                                                       CSE010
     C     @@EOF         DOWNE     'Y'                                                        CSE010
     C*****@@CNT         ANDLT     14                                                  CSE010 CSE016
     C     @@CNT         ANDLT     7                                                          CSE016
      *                                                                                       CSE010
      ** If screen Trade Reference is less than or equal to file Trade                        CSE010
      ** Reference and screen Trade Date is after or equals file Trade                        CSE010
      ** Date                                                                                 CSE010
      *                                                                                       CSE010
     C     STDRF         IFLE      TDRF                                                       CSE010
      *                                                                                       CSE010
     C     STRDT         IFNE      *BLANKS                                                    CSE010
     C     DaynoOut      ANDGE     TDDT                                                       CSE010
     C     STRDT         OREQ      *BLANKS                                                    CSE010
      *                                                                                       CSE010
      ** If screen Incomplete Indicator is blans or equal to file                             CSE010
      ** Incomplete Indicator                                                                 CSE010
      *                                                                                       CSE010
     C     STINC         IFEQ      *BLANKS                                                    CSE010
     C     STINC         OREQ      TINC                                                       CSE010
      *                                                                         CSE019
     C                   Exsr      SETSTAT                                      CSE019
      *                                                                         CSE019
      ** If screen Status Indicator is blanks or equal to Status Trade          CSE019
      *                                                                         CSE019
     C     SSTSI         IFEQ      *BLANKS                                      CSE019
     C     SSTSI         OREQ      WWSTSI                                       CSE019
      *                                                                         CSE019
      ** If screen Trade Type is blanks or equal to Trade Type of the trade     CSE019
      *                                                                         CSE019
     C     STDTP         IFEQ      *BLANKS                                      CSE019
     C     STDTP         OREQ      TDTP                                         CSE019
      *                                                                         CSE019
      ** If screen Book Code is blanks or equal to Book Code of the trade       CSE019
      *                                                                         CSE019
     C     STDBK         IFEQ      *BLANKS                                      CSE019
     C     STDBK         OREQ      TDBK                                         CSE019
      *                                                                         CSE019
      ** If screen Value Date is blanks or equal to Value Date of the Trade     CSE019
      *                                                                         CSE019
     C     KVDate        IFEQ      *ZEROS                                       CSE019
     C     KVDate        OREQ      TDVD                                         CSE019
      *                                                                         CSE019
      ** If screen Settl Date is blanks or equal to Settl Date of the Trade     CSE019
      *                                                                         CSE019
     C     KSDate        IFEQ      *ZEROS                                       CSE019
     C     KSDate        OREQ      TDFS                                         CSE019
     C                   ADD       1             @@RRN                                        CSE010
     C                   ADD       1             @@CNT                                        CSE010
     C                   EXSR      FMTTRD                                                     CSE010
     C                   WRITE     SETRADS5                                                   CSE010
     C     CSE019        IFEQ      'Y'                                          CSE019
     C                   WRITE     SETRADS7                                     CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   EXSR      RDTDRF                                                     CSE010
     C                   ENDDO                                                                CSE010
      *                                                                                       CSE010
     C                   READP     @TRADL7                                50                  CSE010
      *                                                                                       CSE010
     C                   ENDSR                                                                CSE010
      *****************************************************************                       CSE010
      /EJECT                                                                                  CSE010
      *****************************************************************                       CSE010
      * SELSECCUST - Selection by Security Shortname and Customer     *                       CSE010
      *              Number                                           *                       CSE010
      *                                                               *                       CSE010
      * Called By: SEL    - Selection                                 *                       CSE010
      *                                                               *                       CSE010
      * Calls:     RDTDRF -   - Read a Trade                          *                       CSE010
      *            FMTTRD     - Format a Trade for output             *                       CSE010
      *                                                               *                       CSE010
      *****************************************************************                       CSE010
     C     SELSECCUST    BEGSR                                                                CSE010
      *                                                                                       CSE010
     C     Key2          KLIST                                                                CSE010
     C                   KFLD                    KTDSS                                        CSE010
     C                   KFLD                    KTCNR                                        CSE010
     C                   KFLD                    KDate                                        CSE010
     C                   KFLD                    KTDRF                                        CSE010
      *                                                                                       CSE010
     C     *IN98         IFEQ      *OFF                                                       CSE010
     C     Key2          SETLL     @TRADL8                                                    CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   MOVEL     *Blanks       FILE                                         CSE010
     C                   MOVEL     'SECCUST'     FILE                                         CSE010
     C                   EXSR      RDTDRF                                                     CSE010
      *                                                                                       CSE010
     C     @@EOF         DOWNE     'Y'                                                        CSE010
     C*****@@CNT         ANDLT     14                                                  CSE010 CSE016
     C     @@CNT         ANDLT     7                                                          CSE016
      *                                                                                       CSE010
      ** If screen Trade reference is less than or equal to file Trade                        CSE010
      ** Reference, and screen Trade Date is after or equal to the file                       CSE010
      ** Trade Date                                                                           CSE010
      *                                                                                       CSE010
     C     STDRF         IFLE      TDRF                                                       CSE010
      *                                                                                       CSE010
     C     STRDT         IFNE      *BLANKS                                                    CSE010
     C     DaynoOut      ANDGE     TDDT                                                       CSE010
     C     STRDT         OREQ      *BLANKS                                                    CSE010
      *                                                                                       CSE010
      ** If screen Incomplete indicator is blank or equal to file                             CSE010
      ** Incomplete Indicator                                                                 CSE010
      *                                                                                       CSE010
     C     STINC         IFEQ      *BLANKS                                                    CSE010
     C     STINC         OREQ      TINC                                                       CSE010
      *                                                                         CSE019
     C                   Exsr      SETSTAT                                      CSE019
      *                                                                         CSE019
      ** If screen Status Indicator is blanks or equal to Status Trade          CSE019
      *                                                                         CSE019
     C     SSTSI         IFEQ      *BLANKS                                      CSE019
     C     SSTSI         OREQ      WWSTSI                                       CSE019
      *                                                                         CSE019
      ** If screen Trade Type is blanks or equal to Trade Type of the trade     CSE019
      *                                                                         CSE019
     C     STDTP         IFEQ      *BLANKS                                      CSE019
     C     STDTP         OREQ      TDTP                                         CSE019
      *                                                                         CSE019
      ** If screen Book Code is blanks or equal to Book Code of the trade       CSE019
      *                                                                         CSE019
     C     STDBK         IFEQ      *BLANKS                                      CSE019
     C     STDBK         OREQ      TDBK                                         CSE019
      *                                                                         CSE019
      ** If screen Value Date is blanks or equal to Value Date of the Trade     CSE019
      *                                                                         CSE019
     C     KVDate        IFEQ      *ZEROS                                       CSE019
     C     KVDate        OREQ      TDVD                                         CSE019
      *                                                                         CSE019
      ** If screen Settl Date is blanks or equal to Settl Date of the Trade     CSE019
      *                                                                         CSE019
     C     KSDate        IFEQ      *ZEROS                                       CSE019
     C     KSDate        OREQ      TDFS                                         CSE019
     C                   ADD       1             @@RRN                                        CSE010
     C                   ADD       1             @@CNT                                        CSE010
     C                   EXSR      FMTTRD                                                     CSE010
     C                   WRITE     SETRADS5                                                   CSE010
     C     CSE019        IFEQ      'Y'                                          CSE019
     C                   WRITE     SETRADS7                                     CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   EXSR      RDTDRF                                                     CSE010
     C                   ENDDO                                                                CSE010
      *                                                                                       CSE010
     C                   READP     @TRADL8                                50                  CSE010
      *                                                                                       CSE010
     C                   ENDSR                                                                CSE010
      *****************************************************************                       CSE010
      /EJECT                                                                                  CSE010
      *****************************************************************                       CSE010
      *                                                               *                       CSE010
      * SELTDRF - Selection by Trade Reference                        *                       CSE010
      *                                                               *                       CSE010
      * Called By: SEL    - Selection                                 *                       CSE010
      *                                                               *                       CSE010
      * Calls:     RDTDRF -   - Read a Trade                          *                       CSE010
      *            FMTTRD     - Format a Trade for output             *                       CSE010
      *                                                               *                       CSE010
      *****************************************************************                       CSE010
     C     SELTDRF       BEGSR                                                                CSE010
      *                                                                                       CSE010
     C     Key6          KLIST                                                                CSE010
     C                   KFLD                    KTDRF                                        CSE010
     C                   KFLD                    KDate                                        CSE010
      *                                                                                       CSE010
     C     *IN98         IFEQ      *OFF                                                       CSE010
     C     Key6          SETLL     @TRADL5                                                    CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   MOVE      *Blanks       FILE                                         CSE010
     C                   MOVEL     'TDRF'        FILE                                         CSE010
     C                   EXSR      RDTDRF                                                     CSE010
      *                                                                                       CSE010
     C     @@EOF         DOWNE     'Y'                                                        CSE010
     C*****@@CNT         ANDLT     14                                                  CSE010 CSE016
     C     @@CNT         ANDLT     7                                                          CSE016
      *                                                                                       CSE010
      ** If screen Incomplete Indicator is blanks or equal to file                            CSE010
      ** Incomplete Indicator                                                                 CSE010
      *                                                                                       CSE010
     C     STINC         IFEQ      *BLANKS                                                    CSE010
     C     STINC         OREQ      TINC                                                       CSE010
      *                                                                         CSE019
     C                   Exsr      SETSTAT                                      CSE019
      *                                                                         CSE019
      ** If screen Status Indicator is blanks or equal to Status Trade          CSE019
      *                                                                         CSE019
     C     SSTSI         IFEQ      *BLANKS                                      CSE019
     C     SSTSI         OREQ      WWSTSI                                       CSE019
      *                                                                         CSE019
      ** If screen Trade Type is blanks or equal to Trade Type of the trade     CSE019
      *                                                                         CSE019
     C     STDTP         IFEQ      *BLANKS                                      CSE019
     C     STDTP         OREQ      TDTP                                         CSE019
      *                                                                         CSE019
      ** If screen Book Code is blanks or equal to Book Code of the trade       CSE019
      *                                                                         CSE019
     C     STDBK         IFEQ      *BLANKS                                      CSE019
     C     STDBK         OREQ      TDBK                                         CSE019
      *                                                                         CSE019
      ** If screen Value Date is blanks or equal to Value Date of the Trade     CSE019
      *                                                                         CSE019
     C     KVDate        IFEQ      *ZEROS                                       CSE019
     C     KVDate        OREQ      TDVD                                         CSE019
      *                                                                         CSE019
      ** If screen Settl Date is blanks or equal to Settl Date of the Trade     CSE019
      *                                                                         CSE019
     C     KSDate        IFEQ      *ZEROS                                       CSE019
     C     KSDate        OREQ      TDFS                                         CSE019
     C                   ADD       1             @@RRN                                        CSE010
     C                   ADD       1             @@CNT                                        CSE010
     C                   EXSR      FMTTRD                                                     CSE010
     C                   WRITE     SETRADS5                                                   CSE010
     C     CSE019        IFEQ      'Y'                                          CSE019
     C                   WRITE     SETRADS7                                     CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   EXSR      RDTDRF                                                     CSE010
     C                   ENDDO                                                                CSE010
      *                                                                                       CSE010
     C                   READP     @TRADL5                                50                  CSE010
      *                                                                                       CSE010
     C                   ENDSR                                                                CSE010
      *****************************************************************         CSE019
      /EJECT                                                                    CSE019
      *****************************************************************         CSE019
      * SELVDATE- Selection by Value Date                             *         CSE019
      *                                                               *         CSE019
      * Called By: SEL    - Selection                                 *         CSE019
      *                                                               *         CSE019
      * Calls:     RDTDRF -   - Read a Trade                          *         CSE019
      *            FMTTRD     - Format a Trade for output             *         CSE019
      *                                                               *         CSE019
      *****************************************************************         CSE019
     C     SELVDATE      BEGSR                                                  CSE019
      *                                                                         CSE019
     C     KeyVDate      KLIST                                                  CSE019
     C                   KFLD                    KVDate                         CSE019
      *                                                                         CSE019
     C     *IN98         IFEQ      *OFF                                         CSE019
     C     KeyVDate      SETLL     SETRADL1                                     CSE019
     C                   ENDIF                                                  CSE019
      *                                                                         CSE019
     C                   MOVEL     *Blanks       FILE                           CSE019
     C                   MOVEL     'VDATE'       FILE                           CSE019
     C                   EXSR      RDTDRF                                       CSE019
      *                                                                         CSE019
     C     @@EOF         DOWNE     'Y'                                          CSE019
     C*****@@CNT         ANDLT     14                                                  CSE019 CSE016
     C     @@CNT         ANDLT     7                                                          CSE016
      *                                                                         CSE019
      ** If Screen Trade Reference is less than or equal to file Trade          CSE019
      ** Reference, and screen Trade Date is after or equal to file             CSE019
      ** Trade Date                                                             CSE019
      *                                                                         CSE019
     C     STDRF         IFLE      TDRF                                         CSE019
      *                                                                         CSE019
     C     STDRF         IFNE      *Blanks                                      CSE019
     C     DaynoOut      ANDGE     TDDT                                         CSE019
      *                                                                         CSE019
     C     STRDT         OREQ      *Blanks                                      CSE019
      *                                                                         CSE019
      ** If screen Security Shortname is blank or equals file Security          CSE019
      ** Shortname                                                              CSE019
      *                                                                         CSE019
     C     STDSS         IFEQ      *BLANKS                                      CSE019
     C     STDSS         OREQ      TDSS                                         CSE019
      *                                                                         CSE019
      ** If Screen Customer is blanks or equals file Customer                   CSE019
      *                                                                         CSE019
     C**********         Z-ADD     *ZEROS        WWTCNR            6 0          CSE019        CSD027
     C                   MOVE      *BLANKS       WWTCNR            6            CSE019        CSD027
     C                   MOVE      @CUST         WWTCNR                         CSE019
      *                                                                         CSE019
     C     STCNR         IFEQ      *BLANKS                                      CSE019
     C     WWTCNR        OREQ      TCNR                                         CSE019
      *                                                                         CSE019
      ** If screen Incomplete Indicator is blanks or equal to file              CSE019
      ** Incomplete indicator                                                   CSE019
      *                                                                         CSE019
     C     STINC         IFEQ      *BLANKS                                      CSE019
     C     STINC         OREQ      TINC                                         CSE019
      *                                                                         CSE019
     C                   Exsr      SETSTAT                                      CSE019
      *                                                                         CSE019
      ** If screen Status Indicator is blanks or equal to Status Trade          CSE019
      *                                                                         CSE019
     C     SSTSI         IFEQ      *BLANKS                                      CSE019
     C     SSTSI         OREQ      WWSTSI                                       CSE019
      *                                                                         CSE019
      ** If screen Trade Type is blanks or equal to Trade Type of the trade     CSE019
      *                                                                         CSE019
     C     STDTP         IFEQ      *BLANKS                                      CSE019
     C     STDTP         OREQ      TDTP                                         CSE019
      *                                                                         CSE019
      ** If screen Book Code is blanks or equal to Book Code of the trade       CSE019
      *                                                                         CSE019
     C     STDBK         IFEQ      *BLANKS                                      CSE019
     C     STDBK         OREQ      TDBK                                         CSE019
      *                                                                         CSE019
      ** If screen Settl Date is blanks or equal to Settl Date of the Trade     CSE019
      *                                                                         CSE019
     C     KSDate        IFEQ      *ZEROS                                       CSE019
     C     KSDate        OREQ      TDFS                                         CSE019
      *                                                                         CSE019
      ** Increase subfile record count, increase subfile page count,            CSE019
      ** execute FMTTRD, write subfile record and execute subroutine RDTDRF     CSE019
      *                                                                         CSE019
     C                   ADD       1             @@RRN                          CSE019
     C                   ADD       1             @@CNT                          CSE019
     C                   EXSR      FMTTRD                                       CSE019
     C                   WRITE     SETRADS5                                     CSE019
     C     CSE019        IFEQ      'Y'                                          CSE019
     C                   WRITE     SETRADS7                                     CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                  CSE019
      *                                                                         CSE019
     C                   ENDIF                                                  CSE019
      *                                                                         CSE019
     C                   ENDIF                                                  CSE019
      *                                                                         CSE019
     C                   ENDIF                                                  CSE019
      *                                                                         CSE019
     C                   ENDIF                                                  CSE019
      *                                                                         CSE019
     C                   EXSR      RDTDRF                                       CSE019
      *                                                                         CSE019
     C                   ENDDO                                                  CSE019
      *                                                                         CSE019
     C                   READP     SETRADL1                               50    CSE019
      *                                                                         CSE019
     C                   ENDSR                                                  CSE019
      *****************************************************************         CSE019
      /EJECT                                                                    CSE019
      *****************************************************************         CSE019
      * SELSDATE- Selection by Settlement Date                        *         CSE019
      *                                                               *         CSE019
      * Called By: SEL    - Selection                                 *         CSE019
      *                                                               *         CSE019
      * Calls:     RDTDRF -   - Read a Trade                          *         CSE019
      *            FMTTRD     - Format a Trade for output             *         CSE019
      *                                                               *         CSE019
      *****************************************************************         CSE019
     C     SELSDATE      BEGSR                                                  CSE019
      *                                                                         CSE019
     C     KeySDate      KLIST                                                  CSE019
     C                   KFLD                    KSDate                         CSE019
      *                                                                         CSE019
     C     *IN98         IFEQ      *OFF                                         CSE019
     C     KeySDate      SETLL     SETRADL2                                     CSE019
     C                   ENDIF                                                  CSE019
      *                                                                         CSE019
     C                   MOVEL     *Blanks       FILE                           CSE019
     C                   MOVEL     'SDATE'       FILE                           CSE019
     C                   EXSR      RDTDRF                                       CSE019
      *                                                                         CSE019
     C     @@EOF         DOWNE     'Y'                                          CSE019
     C*****@@CNT         ANDLT     14                                                  CSE019 CSE016
     C     @@CNT         ANDLT     7                                                          CSE016
      *                                                                         CSE019
      ** If Screen Trade Reference is less than or equal to file Trade          CSE019
      ** Reference, and screen Trade Date is after or equal to file             CSE019
      ** Trade Date                                                             CSE019
      *                                                                         CSE019
     C     STDRF         IFLE      TDRF                                         CSE019
      *                                                                         CSE019
     C     STDRF         IFNE      *Blanks                                      CSE019
     C     DaynoOut      ANDGE     TDDT                                         CSE019
      *                                                                         CSE019
     C     STRDT         OREQ      *Blanks                                      CSE019
      *                                                                         CSE019
      ** If screen Security Shortname is blank or equals file Security          CSE019
      ** Shortname                                                              CSE019
      *                                                                         CSE019
     C     STDSS         IFEQ      *BLANKS                                      CSE019
     C     STDSS         OREQ      TDSS                                         CSE019
      *                                                                         CSE019
      ** If Screen Customer is blanks or equals file Customer                   CSE019
      *                                                                         CSE019
     C**********         Z-ADD     *ZEROS        WWTCNR            6 0          CSE019        CSD027
     C                   MOVE      *BLANKS       WWTCNR            6            CSE019        CSD027
     C                   MOVE      @CUST         WWTCNR                         CSE019
      *                                                                         CSE019
     C     STCNR         IFEQ      *BLANKS                                      CSE019
     C     WWTCNR        OREQ      TCNR                                         CSE019
      *                                                                         CSE019
      ** If screen Incomplete Indicator is blanks or equal to file              CSE019
      ** Incomplete indicator                                                   CSE019
      *                                                                         CSE019
     C     STINC         IFEQ      *BLANKS                                      CSE019
     C     STINC         OREQ      TINC                                         CSE019
      *                                                                         CSE019
     C                   Exsr      SETSTAT                                      CSE019
      *                                                                         CSE019
      ** If screen Status Indicator is blanks or equal to Status Trade          CSE019
      *                                                                         CSE019
     C     SSTSI         IFEQ      *BLANKS                                      CSE019
     C     SSTSI         OREQ      WWSTSI                                       CSE019
      *                                                                         CSE019
      ** If screen Trade Type is blanks or equal to Trade Type of the trade     CSE019
      *                                                                         CSE019
     C     STDTP         IFEQ      *BLANKS                                      CSE019
     C     STDTP         OREQ      TDTP                                         CSE019
      *                                                                         CSE019
      ** If screen Book Code is blanks or equal to Book Code of the trade       CSE019
      *                                                                         CSE019
     C     STDBK         IFEQ      *BLANKS                                      CSE019
     C     STDBK         OREQ      TDBK                                         CSE019
      *                                                                         CSE019
      ** Increase subfile record count, increase subfile page count,            CSE019
      ** execute FMTTRD, write subfile record and execute subroutine RDTDRF     CSE019
      *                                                                         CSE019
     C                   ADD       1             @@RRN                          CSE019
     C                   ADD       1             @@CNT                          CSE019
     C                   EXSR      FMTTRD                                       CSE019
     C                   WRITE     SETRADS5                                     CSE019
     C     CSE019        IFEQ      'Y'                                          CSE019
     C                   WRITE     SETRADS7                                     CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                  CSE019
      *                                                                         CSE019
     C                   ENDIF                                                  CSE019
      *                                                                         CSE019
     C                   ENDIF                                                  CSE019
      *                                                                         CSE019
     C                   ENDIF                                                  CSE019
      *                                                                         CSE019
     C                   ENDIF                                                  CSE019
      *                                                                         CSE019
     C                   EXSR      RDTDRF                                       CSE019
      *                                                                         CSE019
     C                   ENDDO                                                  CSE019
      *                                                                         CSE019
     C                   READP     SETRADL2                               50    CSE019
      *                                                                         CSE019
     C                   ENDSR                                                  CSE019
      *****************************************************************         CSE019
      /EJECT                                                                    CSE019
      *****************************************************************         CSE019
      * SELFRONT - Selection by Front Office Id                       *         CSE019
      *                                                               *         CSE019
      * Called By: SEL    - Selection                                 *         CSE019
      *                                                               *         CSE019
      * Calls:     RDTDRF -   - Read a Trade                          *         CSE019
      *            FMTTRD     - Format a Trade for output             *         CSE019
      *                                                               *         CSE019
      *****************************************************************         CSE019
     C     SELFRONT      BEGSR                                                  CSE019
      *                                                                         CSE019
     C     KeyFront      KLIST                                                  CSE019
     C                   KFLD                    SFRNT                          CSE019
      *                                                                         CSE019
     C     *IN98         IFEQ      *OFF                                         CSE019
     C     KeyFront      SETLL     SETRADL0                                     CSE019
     C                   ENDIF                                                  CSE019
      *                                                                         CSE019
     C                   MOVEL     *Blanks       FILE                           CSE019
     C                   MOVEL     'FRONT'       FILE                           CSE019
     C                   EXSR      RDTDRF                                       CSE019
      *                                                                         CSE019
     C     @@EOF         DOWNE     'Y'                                          CSE019
     C*****@@CNT         ANDLT     14                                                  CSE019 CSE016
     C     @@CNT         ANDLT     7                                                          CSE016
      *                                                                         CSE019
      ** If Screen Trade Reference is less than or equal to file Trade          CSE019
      ** Reference, and screen Trade Date is after or equal to file             CSE019
      ** Trade Date                                                             CSE019
      *                                                                         CSE019
     C     STDRF         IFLE      TDRF                                         CSE019
      *                                                                         CSE019
     C     STDRF         IFNE      *Blanks                                      CSE019
     C     DaynoOut      ANDGE     TDDT                                         CSE019
      *                                                                         CSE019
     C     STRDT         OREQ      *Blanks                                      CSE019
      *                                                                         CSE019
      ** If screen Security Shortname is blank or equals file Security          CSE019
      ** Shortname                                                              CSE019
      *                                                                         CSE019
     C     STDSS         IFEQ      *BLANKS                                      CSE019
     C     STDSS         OREQ      TDSS                                         CSE019
      *                                                                         CSE019
      ** If Screen Customer is blanks or equals file Customer                   CSE019
      *                                                                         CSE019
     C**********         Z-ADD     *ZEROS        WWTCNR            6 0          CSE019        CSD027
     C                   MOVE      *BLANKS       WWTCNR            6            CSE019        CSD027
     C                   MOVE      @CUST         WWTCNR                         CSE019
      *                                                                         CSE019
     C     STCNR         IFEQ      *BLANKS                                      CSE019
     C     WWTCNR        OREQ      TCNR                                         CSE019
      *                                                                         CSE019
      ** If screen Incomplete Indicator is blanks or equal to file              CSE019
      ** Incomplete indicator                                                   CSE019
      *                                                                         CSE019
     C     STINC         IFEQ      *BLANKS                                      CSE019
     C     STINC         OREQ      TINC                                         CSE019
      *                                                                         CSE019
     C                   Exsr      SETSTAT                                      CSE019
      *                                                                         CSE019
      ** If screen Status Indicator is blanks or equal to Status Trade          CSE019
      *                                                                         CSE019
     C     SSTSI         IFEQ      *BLANKS                                      CSE019
     C     SSTSI         OREQ      WWSTSI                                       CSE019
      *                                                                         CSE019
      ** If screen Trade Type is blanks or equal to Trade Type of the trade     CSE019
      *                                                                         CSE019
     C     STDTP         IFEQ      *BLANKS                                      CSE019
     C     STDTP         OREQ      TDTP                                         CSE019
      *                                                                         CSE019
      ** If screen Book Code is blanks or equal to Book Code of the trade       CSE019
      *                                                                         CSE019
     C     STDBK         IFEQ      *BLANKS                                      CSE019
     C     STDBK         OREQ      TDBK                                         CSE019
      *                                                                         CSE019
      ** If screen Value Date is blanks or equal to Value Date of the Trade     CSE019
      *                                                                         CSE019
     C     KVDate        IFEQ      *ZEROS                                       CSE019
     C     KVDate        OREQ      TDVD                                         CSE019
      *                                                                         CSE019
      ** If screen Settl Date is blanks or equal to Settl Date of the Trade     CSE019
      *                                                                         CSE019
     C     KSDate        IFEQ      *ZEROS                                       CSE019
     C     KSDate        OREQ      TDFS                                         CSE019
      *                                                                         CSE019
      ** Increase subfile record count, increase subfile page count,            CSE019
      ** execute FMTTRD, write subfile record and execute subroutine RDTDRF     CSE019
      *                                                                         CSE019
     C                   ADD       1             @@RRN                          CSE019
     C                   ADD       1             @@CNT                          CSE019
     C                   EXSR      FMTTRD                                       CSE019
     C                   WRITE     SETRADS5                                     CSE019
     C     CSE019        IFEQ      'Y'                                          CSE019
     C                   WRITE     SETRADS7                                     CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                  CSE019
      *                                                                         CSE019
     C                   ENDIF                                                  CSE019
      *                                                                         CSE019
     C                   ENDIF                                                  CSE019
      *                                                                         CSE019
     C                   ENDIF                                                  CSE019
      *                                                                         CSE019
     C                   ENDIF                                                  CSE019
      *                                                                         CSE019
     C                   EXSR      RDTDRF                                       CSE019
      *                                                                         CSE019
     C                   ENDDO                                                  CSE019
      *                                                                         CSE019
     C                   READP     SETRADL0                               50    CSE019
      *                                                                         CSE019
     C                   ENDSR                                                  CSE019
      *****************************************************************                       CSE010
      /EJECT                                                                                  CSE010
      *****************************************************************                       CSE010
      * SELSCAN - Selection if F16 is Pressed                         *                       CSE010
      *                                                               *                       CSE010
      * Called By: SEL    - Selection                                 *                       CSE010
      *                                                               *                       CSE010
      * Calls:     RDTDRF -   - Read a Trade                          *                       CSE010
      *            FMTTRD     - Format a Trade for output             *                       CSE010
      *                                                               *                       CSE010
      *****************************************************************                       CSE010
     C     SELSCAN       BEGSR                                                                CSE010
      *                                                                                       CSE010
     C     *IN98         IFEQ      *OFF                                                       CSE010
     C     Key6          SETLL     @TRADL5                                                    CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   MOVEL     *Blanks       FILE                                         CSE010
     C                   MOVEL     'SCAN'        FILE                                         CSE010
     C                   EXSR      RDTDRF                                                     CSE010
      *                                                                                       CSE010
     C     @@EOF         DOWNE     'Y'                                                        CSE010
     C*****@@CNT         ANDLT     14                                                  CSE010 CSE016
     C     @@CNT         ANDLT     7                                                          CSE016
      *                                                                                       CSE010
      ** If screen Trade Reference is less than or eqaul to file                              CSE010
      ** Trade Reference                                                                      CSE010
      *                                                                                       CSE010
     C     STDRF         IFLE      TDRF                                                       CSE010
     C                   CALL      'QCLSCAN'                                                  CSE010
     C                   PARM      TDSS          WWORK            30                          CSE010
     C                   PARM      30            WQA3N             3 0                        CSE010
     C                   PARM      1             WQB3N             3 0                        CSE010
     C                   PARM      STDSS         WMASK            30                          CSE010
     C                   PARM      30            WQC3N             3 0                        CSE010
     C                   PARM      '1'           WQD1              1                          CSE010
     C                   PARM      '1'           WQE1              1                          CSE010
     C                   PARM      '?'           WQF1              1                          CSE010
     C                   PARM                    WQG3N             3 0                        CSE010
      *                                                                                       CSE010
     C     WQG3N         IFGE      1                                                          CSE010
      *                                                                                       CSE010
      ** If screen Customer is blanks or equal to file Customer                               CSE010
      *                                                                                       CSE010
     C**********         Z-ADD     *ZEROS        WWTCNR                                CSE010 CSD027
     C                   EVAL      WWTCNR = *BLANKS                                           CSD027
     C                   MOVE      @CUST         WWTCNR                                       CSE010
      *                                                                                       CSE010
     C     STCNR         IFEQ      *BLANKS                                                    CSE010
     C     WWTCNR        OREQ      TCNR                                                       CSE010
      *                                                                                       CSE010
      ** If screen Incomplete Indicator is blanks or equal to file                            CSE010
      ** Incomplete Indicator                                                                 CSE010
      *                                                                                       CSE010
     C     STINC         IFEQ      *BLANKS                                                    CSE010
     C     STINC         OREQ      TINC                                                       CSE010
      *                                                                         CSE019
     C                   Exsr      SETSTAT                                      CSE019
      *                                                                         CSE019
      ** If screen Status Indicator is blanks or equal to Status Trade          CSE019
      *                                                                         CSE019
     C     SSTSI         IFEQ      *BLANKS                                      CSE019
     C     SSTSI         OREQ      WWSTSI                                       CSE019
      *                                                                         CSE019
      ** If screen Trade Type is blanks or equal to Trade Type of the trade     CSE019
      *                                                                         CSE019
     C     STDTP         IFEQ      *BLANKS                                      CSE019
     C     STDTP         OREQ      TDTP                                         CSE019
      *                                                                         CSE019
      ** If screen Book Code is blanks or equal to Book Code of the trade       CSE019
      *                                                                         CSE019
     C     STDBK         IFEQ      *BLANKS                                      CSE019
     C     STDBK         OREQ      TDBK                                         CSE019
     C                   ADD       1             @@RRN                                        CSE010
     C                   ADD       1             @@CNT                                        CSE010
     C                   EXSR      FMTTRD                                                     CSE010
     C                   WRITE     SETRADS5                                                   CSE010
     C     CSE019        IFEQ      'Y'                                          CSE019
     C                   WRITE     SETRADS7                                     CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   EXSR      RDTDRF                                                     CSE010
     C                   ENDDO                                                                CSE010
      *                                                                                       CSE010
     C                   READP     @TRADL5                                50                  CSE010
      *                                                                                       CSE010
     C                   ENDSR                                                                CSE010
      *****************************************************************                       CSE010
      /EJECT                                                                                  CSE010
      *****************************************************************                       CSE010
      *                                                               *                       CSE010
      * SELOTHER - Selection by Trade Date                            *                       CSE010
      *                                                               *                       CSE010
      * Called By: SEL    - Selection                                 *                       CSE010
      *                                                               *                       CSE010
      * Calls:     RDTDRF -   - Read a Trade                          *                       CSE010
      *            FMTTRD     - Format a Trade for output             *                       CSE010
      *                                                               *                       CSE010
      *****************************************************************                       CSE010
     C     SELOTHER      BEGSR                                                                CSE010
      *                                                                                       CSE010
     C     Key1          KLIST                                                                CSE010
     C                   KFLD                    KDate                                        CSE010
     C                   KFLD                    KTDRF                                        CSE010
      *                                                                                       CSE010
     C     *IN98         IFEQ      *OFF                                                       CSE010
     C     Key1          SETLL     @TRADL6                                                    CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   MOVEL     *Blanks       FILE                                         CSE010
     C                   MOVEL     'OTHER'       FILE                                         CSE010
     C                   EXSR      RDTDRF                                                     CSE010
      *                                                                                       CSE010
     C     @@EOF         DOWNE     'Y'                                                        CSE010
     C*****@@CNT         ANDLT     14                                                  CSE010 CSE016
     C     @@CNT         ANDLT     7                                                          CSE016
      *                                                                                       CSE010
      ** If screen Trade Reference is less than or equal to file                              CSE010
      ** Trade Reference                                                                      CSE010
      *                                                                                       CSE010
     C     STDRF         IFLE      TDRF                                                       CSE010
      *                                                                                       CSE010
      ** If screen Incomplete Indicator is blank or equal to file                             CSE010
      ** Incomplete Indicator                                                                 CSE010
      *                                                                                       CSE010
     C     STINC         IFEQ      *BLANKS                                                    CSE010
     C     STINC         OREQ      TINC                                                       CSE010
      *                                                                         CSE019
     C                   Exsr      SETSTAT                                      CSE019
      *                                                                         CSE019
      ** If screen Status Indicator is blanks or equal to Status Trade          CSE019
      *                                                                         CSE019
     C     SSTSI         IFEQ      *BLANKS                                      CSE019
     C     SSTSI         OREQ      WWSTSI                                       CSE019
      *                                                                         CSE019
      ** If screen Trade Type is blanks or equal to Trade Type of the trade     CSE019
      *                                                                         CSE019
     C     STDTP         IFEQ      *BLANKS                                      CSE019
     C     STDTP         OREQ      TDTP                                         CSE019
      *                                                                         CSE019
      ** If screen Book Code is blanks or equal to Book Code of the trade       CSE019
      *                                                                         CSE019
     C     STDBK         IFEQ      *BLANKS                                      CSE019
     C     STDBK         OREQ      TDBK                                         CSE019
     C                   ADD       1             @@RRN                                        CSE010
     C                   ADD       1             @@CNT                                        CSE010
     C                   EXSR      FMTTRD                                                     CSE010
     C                   WRITE     SETRADS5                                                   CSE010
     C     CSE019        IFEQ      'Y'                                          CSE019
     C                   WRITE     SETRADS7                                     CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                  CSE019
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   EXSR      RDTDRF                                                     CSE010
     C                   ENDDO                                                                CSE010
      *                                                                                       CSE010
     C                   READP     @TRADL6                                50                  CSE010
      *                                                                                       CSE010
     C                   ENDSR                                                                CSE010
      *****************************************************************                       CSE010
      /EJECT                                                                                  CSE010
      *****************************************************************                       CSE010
      ** The following /COPY line includes the ProcMsgs subroutine                            CSE010
      ** to process error and warning messages.                                               CSE010
      /COPY ZACPYSRC,MSGHNDDSP2                                                               CSE010
      *****************************************************************                       CSE010
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      * Parameters
      *
     C     *ENTRY        PLIST
      *
      * INPUT PARAMETERS :
      * RETURN CODE
      * ACTION CODE
      * Trade Ref Pointer
      * BUILD SUB-FILE
      * READ SUBFILE RECORD
     C                   PARM                    RetCodeIn
     C                   PARM                    DDACTN            1
     C                   PARM                    DDTDRF            6
     C                   PARM                    @BDSFL            1
     C                   PARM                    @RDSFL            1
      *
      * OUTPUT PARAMETERS :
      * ERROR MESSAGE
      * OPTION SELECTED
      * Trade Ref. selected
     C                   PARM                    @ERRMS            7
     C                   PARM                    @OPSEL            1
     C                   PARM                    @TRSEL            6
      * COMMAND KEYS
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
      *
      ** Initialize program name
     C                   MOVEL     'SETRADBRW'   DBPGM
      *
      ** Move workstation ID to screen field.
     C                   MOVEL     PsJobName     DDWID
     C                   MOVEL     PsUser        DDUSER
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS GENERAL LEDGER DETAILS
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE                         ************
     C                   MOVEL     '902'         DBASE                          * DBERR 902*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      ** Securities Trading ICD
      *
     C                   CALL      'AOSTRDR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDSTRD        PARM      SDSTRD        DSSDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDSTRDPD'    DBFILE                         ************
     C                   MOVEL     '903'         DBASE                          * DBERR 903*
     C                   EXSR      *PSSR                                        ************
     C                   END
      *                                                                                       CSE010
      ** Access Switchable Features File, for SE Transactions Enhancement                     CSE010
      *                                                                                       CSE010
     C                   MOVE      'N'           CSE010            1                          CSE010
     C                   CALLB     'AOSARDR0'                                                 CSE010
     C                   PARM      *BLANKS       PRTCD             7                          CSE010
     C                   PARM      '*VERIFY'     POPTN             7                          CSE010
     C                   PARM      'CSE010'      PSARD             6                          CSE010
      *                                                                                       CSE010
     C     PRTCD         IFEQ      *BLANKS                                                    CSE010
     C                   MOVE      'Y'           CSE010                                       CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
      ** Database Error                                                                       CSE010
      *                                                                                       CSE010
     C     PRTCD         IFNE      *BLANKS                                                    CSE010
     C     PRTCD         ANDNE     '*NRF   '                                                  CSE010
     C                   MOVEL     'CSE010 '     DBKEY                                        CSE010
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSE010
     C                   MOVEL     '904'         DBASE                                        CSE010
     C                   EXSR      *PSSR                                                      CSE010
     C                   ENDIF                                                                CSE010
      *                                                                         CSE019
      ** Access Switchable Features File, for SE Trades Selections Enhancements CSE019
      *                                                                         CSE019
     C                   MOVE      'N'           CSE019            1            CSE019
     C                   MOVE      False         *IN22                          CSE019
     C                   CALLB     'AOSARDR0'                                   CSE019
     C                   PARM      *BLANKS       PRTCD             7            CSE019
     C                   PARM      '*VERIFY'     POPTN             7            CSE019
     C                   PARM      'CSE019'      PSARD             6            CSE019
      *                                                                         CSE019
     C     PRTCD         IFEQ      *BLANKS                                      CSE019
     C                   MOVE      'Y'           CSE019                         CSE019
     C                   MOVE      True          *IN22                          CSE019
     C                   ENDIF                                                  CSE019
      *                                                                         CSE019
      ** Database Error                                                         CSE019
      *                                                                         CSE019
     C     PRTCD         IFNE      *BLANKS                                      CSE019
     C     PRTCD         ANDNE     '*NRF   '                                    CSE019
     C                   MOVEL     'CSE019 '     DBKEY                          CSE019
     C                   MOVEL     'SCSARDPD'    DBFILE                         CSE019
     C                   MOVEL     '904'         DBASE                          CSE019
     C                   EXSR      *PSSR                                        CSE019
     C                   ENDIF                                                  CSE019
      *                                                                                       CSE010
      ** Access Switchable Features File for TOF/Midas Interface                              CSE010
      *                                                                                       CSE010
     C                   MOVE      'N'           CPB001            1                          CSE010
     C                   MOVE      *OFF          *IN21                          CSE019
     C                   CALLB     'AOMMODR0'                                                 CSE010
     C                   PARM      *BLANKS       PRTCD                                        CSE010
     C                   PARM      '*FIRST '     POPTN                                        CSE010
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        CSE010
      *                                                                                       CSE010
     C**** BGN4ST        IFNE      *BLANKS                                             CSE010 CPB001
     C     BGN4ST        IFEQ      'Y'                                                        CPB001
     C                   MOVE      'Y'           CPB001                                       CSE010
     C                   MOVE      *ON           *IN21                          CSE019
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
      ** Database Error                                                                       CSE010
      *                                                                                       CSE010
     C     PRTCD         IFNE      *BLANKS                                                    CSE010
     C                   MOVEL     '*FIRST '     DBKEY                                        CSE010
     C                   MOVEL     'SDMMODPD'    DBFILE                                       CSE010
     C                   MOVEL     '905'         DBASE                                        CSE010
     C                   EXSR      *PSSR                                                      CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   MOVEL     '*'           DDPGMQ                                       CSE010
     C/COPY WNCPYSRC,SETRADBC07
      *                                                                                       CSE010
      ** The following /COPY line sets up the fixed data for SE *DSP                          CSE010
      ** functions for the message handler, ZAMSGHNDLE.                                       CSE010
      /COPY SECPYSRC,MSGHNDDATA                                                               CSE010
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
