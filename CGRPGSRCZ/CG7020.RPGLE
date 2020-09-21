     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CG Retail Interest Summary - Extract')           *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG7020 - Retail Interest Summary (Extract)                   *
      *                                                               *
      *  Function:  This program reads the Interest Summary           *
      *             extension file and calls the extract              *
      *             program for each statement required.              *
      *                                                               *
      *  Called By: CG7010 - RE Interest Summary (Driver)             *
      *                                                               *
      *  (C) COPYRIGHT Finastra International Limited                 *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 MD031034           Date 25Nov14               *
      *                 CER070             Date 19Aug14               *
      *                 CER069             Date 03Jul14               *
      *                 AR847634           Date 23Nov11               *
      *                 AR864744           Date 15Nov11               *
      *                 AR807782           Date 28Jul11               *
      *                 CER039 *CREATE     Date 05May11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  MD031034 - REC0950 failed in COB with database error due to  *
      *             closed customer.                                  *
      *           - Do not throw error when customer is closed.       *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CER069 - German Tax Enhancement                              *
      *  AR847634 - COB component CGC2050 000030 failed               *
      *  AR864744 - Missing main and secondary tax amounts in the     *
      *             UDC extract file (Child:AR864745)                 *
      *  AR807782 - Increase account field from 15 to 21              *
      *             (Child:AR807783)                                  *
      *  CER039 - Retail Interest Summary Correspondence              *
      *           (Upgrade of German Features FGE092)                 *
      *---------------------------------------------------------------*
     FACNUM     IF   E           K DISK

     FREINSDPD  IF   E           K DISK
     F                                     INFSR(SRFILE)

     FACCNTBJ0  IF   E           K DISK

     FCGCORRL4  IF   E           K DISK
      ** Correspondent file by customer number

     FACCRACJ   IF   E           K DISK
      **Joinfile for alternative accounts

     FSDCSINL7  IF   E           K DISK    USROPN

     F/COPY WNCPYSRC,CG7020FFP

     D/COPY CGCPYSRC,CGPACKDLE
     D/COPY CGCPYSRC,SRERRDLE

      **  ##GRP = Group/RDE Number             ##RDEA = RDE + Attributes
      *
     D ##GRP           S             10    DIM(94) CTDATA PERRCD(1)
     D ##RDEA          S             22    DIM(94) ALT(##GRP)
     D/COPY ZSRSRC,ZPOWERZ1IL
      *
      **  Array of Currencies accessed by program
     D ##CY            S              3    DIM(100)

     D                 DS
     D  ##GRPX                 1     10
     D  ##GRPS                 1      6
     D  ##RDEN                 7     10  0
      **  Look-up string for RDE definition Array
      *

     D                 DS
     D  ##W                    1     20
     D                                     DIM(20)
     D  ##WNUM                 1     20  0
      **  Number Field

     D                 DS
     D  ##ITMA                 1      8
     D  ##ITEM                 1      8  0

      ** String that contains the concatenated path
     D WPathStr        S            256A

      ** Index for WMDsPath only
     D WPx             S              3P 0

      ** General purpose variables
     D Wx1             S              3P 0
     D Wx2             S              3P 0
     D Wx3             S              3P 0

      ** Parameter fields
     D PAction8        S              8A
     D PCustNumChr6    S              6A
     D PItmRef         S              8A
     D PMode           S             10A
     D PRtnCode        S              7A
     D W0CMT           S              3A
     D PChgType        S              1A
     D W0SPAT          S             70A
     D UFCOPD          S              1A
     D UFRETL          S             10A
     D PRTCD           S              7A
     D PIBAN           S             47A
     D PIWITH          S             47A
     D PINOBL          S             34A
     D ##KEY1          S             10A
     D ##KYST          S              7A
     D P@RTCD          S              7A
     D P@FRAM          S             18P 3
     D P@FRCY          S              3A
     D P@TOCY          S              3A
     D P@OUTA          S             15P 0
     D P@INTA          S             18P 3
     D P@EXRT          S             15P 9
     D P@MDIN          S              1A
     D UFCTRT          S              2A
     D UFCTRR          S              2A
     D ##KEY2          S              2A
     D UFRTCD          S              7A
     D UFOPTN          S              7A
     D UFMODE          S             10A
     D UFCUST          S              6A
     D ##CMT           S              3A
     D ##SARD          S              6A
     D @RTCD           S              7A
     D @OPTN           S              7A
     D @SARD           S              6A

      ** Work fields
     D COLON           S             11A
     D C               S              3P 0
     D Q               S              5P 0
     D ##INIT          S              1A
     D ##PNAM          S              7A
     D ##RTCD          S              7A
     D ##OPTN          S              7A
     D ##BRCD          S              3A
     D ##OUTA          S             13P 0
     D WFACNO          S             10P 0
     D UFPBIN          S              5P 0
     D UFTBIN          S              5P 0
     D UFNOCH          S              5P 0
     D UFTSTC          S             13P 0
     D UFKEY1          S             10A
     D UFKYST          S              7A
     D UFSTCH          S             13P 0
     D UFBRCD          S              3A
     D INCCY           S              1A
     D WGINT           S             18P 0
     D WTXSR           S             18P 0
     D WNINT           S             18P 0
     D WSTXA           S             18P 0
     D WGINC           S             18P 0
     D WPTHU           S             18P 0
     D WPTUT           S             18P 0
     D WTXSC           S             18P 0
     D WSTDT           S             18P 0
     D WNINC           S             18P 0
     D WTTAXO          S             18P 0
     D WTTAXT          S             18P 0
     D UFLOCN          S              3A
     D WCONV           S              1A
     D FPTHU           S             18P 0
     D FPTUT           S             18P 0
     D ZCCY            S              3A
     D ZRATE1          S             13P 8
     D WSPRT           S             13P 8
     D ZMDI1           S              1A
     D ZCDPI           S              1S 0
     D ZRATE2          S             13P 8
     D ZMDI2           S              1A
     D ZCDPO           S              1S 0
     D ZRATEX          S             13P 8
     D ZMDIX           S              1A
     D BASCDP          S              1S 0
     D ##BIS           S             80A
     D CEU013          S              1A
     D CEU014          S              1A
     D CER048          S              1A
     D CER054          S              1A
     D CCG015          S              1A
     D CFT004          S              1A
     D #1              S              6P 0
     D #2              S              6P 0
     D #3              S              6P 0
     D F6NBDP          S              1P 0

      ** Key fields
     D KRUND           S              5P 0
     D KMODI           S              1A
     D KCUST           S              6A
     D KCCY            S              3A
     D KACOD           S             10P 0
     D KACSQ           S              2P 0
     D KBRCA           S              3A

     D                 DS
      ** General data structure to define fields that need to share data
     D WGrp10                  1     10
     D  WGrpNme                1      6
     D  WGrpSeq                7     10S 0
     D  WAr20                 21     40    DIM(20)
     D  WNum20                21     40  0
     D  WAr29                 51     79    DIM(29)

     D UFCCYX          DS
     D  UFFIL1                 1      6
     D  UFICCY                 7      9
     D**UFFIL2**              10     15                                                     AR807782
     D  UFFIL2                10     21                                                     AR807782

     D                 DS
     D  UFACCI                 1     18
     D  ACNOK                  1     10  0
     D  #FCNUM                 1      6
     D  #FCCY                  7      9
     D  #FACOD                10     19  0
     D  #FACSQ                20     21  0
     D  #FBRCA                22     24
      **  Account identifier

     D                 DS
     D  UFPI                   1     21
     D  ##CNUM                 1      6
     D  ##CCY                  7      9
     D  ##ACOD                10     19  0
     D  ##ACSQ                20     21  0
      **  A/c to post interest

     D                 DS
     D  UFPOIN                 1     28
     D  BRCDUF                 1      3
     D  UFLIN1                 4      4
     D  CNUMUF                 5     10
     D  UFLIN2                11     11
     D  CCYUF                 12     14
     D  UFLIN3                15     15
     D  ACODUF                16     25
     D  UFLIN4                26     26
     D  ACSQUF                27     28
      **  A/c to post interest
     D                 DS
     D  PHCNUM                 1      6
     D  PHCCY                  7      9
     D  PHACOD                10     19  0
     D  PHACSQ                20     21  0
     D  PHBRCA                22     24
     D  FLAC                   1     24
      * DS used to pass full A/C no to CG9010

     D ##UDCR        E DS                  EXTNAME(CGUDCRPD)
      ** External DS for incomplete reference

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      **  External DS for bank details

     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      **  External DS for branch details

     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)
      **  External DS for Location Code

     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      **  External DS for General Ledger Details

     D SDCURR        E DS                  OCCURS(101) EXTNAME(SDCURRPD)
      **  External DS for currency details

     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D  QQDFACSD     E                     EXTFLD(QQDFAC)
      **  External DS for Customer details

     D SDACUS        E DS                  EXTNAME(SDACUSPD)
      **  External DS for Additional Customer details

     D SDACCT        E DS                  EXTNAME(ACCNTAB)
      **  External DS for Account details

     D SDACOF        E DS                  EXTNAME(SDACOFPD)
      **  External DS for Account officer details

     D SDCTTX        E DS                  EXTNAME(SDCTTXPD)
      **  External DS for Account officer details

     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  First DS for access programs, short data structure

     D DSSDY         E DS                  EXTNAME(DSSDY)
      **  Second DS for access programs, long data structure

     D W0FMT         E DS                  EXTNAME(CGUDTAPD)
      **  Record format of PF/CGUDTAPD for use as a parameter

     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D  QQACCDRE     E                     EXTFLD(QQACCD)
      **  External DS for Retail details

     D ##SRDT          DS                  OCCURS(22)
      **  DS to store subroutine specific data.
      **  - Previous Bind
      **  - This Bind
      **  - Saved Path
     D  ##PBIN                 1      5P 0
     D  ##TBIN                 6     10P 0
     D  ##SPAT                11     80

     DSCSARD         E DS                  EXTNAME(SCSARDPD)
     D  LCDSCS       E                     EXTFLD(LCD)

     D/COPY WNCPYSRC,CG7020I01

     D DSPARM        E DS                  EXTNAME(REINSHPD)
      **  External DS for parameter passed from CG7010

     D SDACTX        E DS                  EXTNAME(SDACTXPD)                                  CER069
      **  External DS for customer details by country of tax                                  CER069
                                                                                              CER069
     D CPYR            DS
      **  Data Structure for Compilation - Copyright Insertion
     D  ##CPY                  1     80
     D                                     DIM(1) CTDATA PERRCD(1)
      *****************************************************************
      *                                                               *
      *   Index to subroutines                                        *
      *   --------------------                                        *
      *                                                               *
      *   ZFGE92 - Main processing - top level group set              *
      *   BRANCH - Branch Details (Simple)                            *
      *   CUSTE  - Customer Details (Simple)                          *
      *   CGBRCH - Branch internal Customer Address details           *
      *   CCYGS  - Currency Details (Simple)                          *
      *   ACCNT  - Account Details (Simple)                           *
      *   Z92HDR - Header   (complex)                                 *
      *   Z92DAH - Header   (simple)                                  *
      *   Z92RE1 - Accounts (complex)                                 *
      *   Z92DA1 - Accounts (simple)                                  *
      *   Z92RE2 - Commissions (complex)                              *
      *   Z92DA2 - Commissions (simple)                               *
      *   Z92RE3 - DR Rate changes (complex)                          *
      *   Z92DA3 - DR Rate changes (simple)                           *
      *   Z92RE4 - Overdraft (complex)                                *
      *   Z92DA4 - Overdraft (simple)                                 *
      *   Z92RE5 - CR Rate Changes (complex)                          *
      *   Z92DA5 - CR Rate Changes (simple)                           *
      *   Z92TOT - Totals (complex)                                   *
      *   Z92DA6 - Totals (simple)                                    *
      *   SRGENR - Generate reference record                          *
      *   SRPACKDTA - Pack and Unpack RDEs and their data             *
      *   SRFMTDTA - Reformat data before packing it                  *
      *   SRRRDE - Retrieve RDE information for RDE in group set      *
      *   SRDCDT - Determine Currency Details                         *
      *   SRINIT - Initial processing - On First Call                 *
      *   SRINZ  - Initialise Fields on Each Invocation               *
      *   *PSSR  - Exception/Error Handling                           *
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Process     :  MAINLINE                                       *
      * Function    :  Mainline processing                            *
      *                                                               *
      * Called by   :  None                                           *
      * Calls       :  SRINIT - Initial Processing - On First Call    *
      *                SRINZ  - Initialise Fields on Each Invocation  *
      *                ZFGE92 - Main Processing - Top Level Group Set *
      *****************************************************************
      *
      **  Parameter list for current program invocation.
     C     *ENTRY        PLIST
     C                   PARM                    W0RTN
     C                   PARM                    W0CMT
     C                   PARM                    UFCOPD
     C                   PARM                    DSPARM
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'MAIN'        @STK(Q)
      *
      *................................................................
      *
      **  Initial processing - Once Only
     C     ##INIT        IFEQ      *BLANK
     C                   EXSR      SRINIT
     C                   MOVE      'Y'           ##INIT
     C                   ENDIF
      *
      **  Initialisation processing
     C                   EXSR      SRINZ
      *
      **  Main processing - top level group set
     C                   EXSR      ZFGE92
      *
      *................................................................
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      **  Terminate program
     C                   RETURN
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  ZFGE92                                         *
      * Function    :  Main processing - top level group set          *
      *                                                               *
      * Called by   :  Mainline                                       *
      * Calls       :  SRGENR - Generate reference record             *
      *                BRANCH - Branch Details (simple)               *
      *                Z92HDR - Header   (complex)                    *
      *                Z92RE1 - Accounts (complex)                    *
      *                Z92RE2 - Commissions (complex)                 *
      *                Z92RE3 - DR Rate changes (complex)             *
      *                Z92RE4 - Overdraft (complex)                   *
      *                Z92RE5 - CR Rate Changes (complex)             *
      *                Z92TOT - Totals (complex)                      *
      *                SRERR  - Database Error                        *
      *****************************************************************
     C     ZFGE92        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'ZFGE92'      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     1             OCCUR     ##SRDT
      *
      **  Set up Path.
     C                   MOVEL     '\ZFGE92'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   MOVEL     WPathStr      ##SPAT
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
      *................................................................
      *
      **  Position the Detail file before the first detail record for this
      **  Customer
     C     KONKEY        SETLL     REINSDPD
      *
      *---------------------------------------------------
      **  Read first detail record (Record Type 1)
     C     KONKEY        READE     REINSDPD                               55
      *
      **  If there is a detail, extract data
     C     *IN55         IFEQ      *OFF
      *
      * save the FACNO because in the record types 02 to 06 is set to 0
     C                   Z-ADD     FACNO         WFACNO
      *
      *---------------------------------------------------------
      **  Generate reference number by writing to PF/CGUDCRPD
      **  Check if statement is to be produced, if not exit pgm.
      *---------------------------------------------------------
     C                   EXSR      SRGENR
     C     UFCOPD        CABEQ     'N'           EXF092
      *
     C                   EXSR      PSHGRS
      *
      *--------------------------
      **  Branch Details (simple)
     C                   EXSR      BRANCH
     C     1             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        WPathStr
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
      *
      *-----------------------------------------------
      **  Header (complex)
      **  Increment Bind Levels for Complex Set only
     C                   Z-ADD     ##TBIN        S#PBIN
     C                   ADD       1             ##BNDC
     C                   Z-ADD     ##BNDC        S#TBIN
     C                   EXSR      Z92HDR
     C     1             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        WPathStr
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
      *
      *-----------------------------------------------
      **  Accounts (complex)
     C                   EXSR      Z92RE1
     C     1             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        WPathStr
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
      *
      *-----------------------------------------------
      **  Commissions (complex)
     C                   EXSR      Z92RE2
     C     1             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        WPathStr
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
      *
      *---------------------------------------------------
      **  Read next detail record (Record Type 3,4,5 or 6)
     C     KONKEY        READE     REINSDPD                               55
      *
      *---------------------------------------------------
      **  Dr Rate Changes (complex)
     C                   EXSR      Z92RE3
     C     1             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        WPathStr
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
      *
      *---------------------------------------------------
      **  Overdrafts (complex)
     C                   EXSR      Z92RE4
     C     1             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        WPathStr
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
      *
      *---------------------------------------------------
      **  CR Rate Changes (complex)
     C                   EXSR      Z92RE5
     C     1             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        WPathStr
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
      *
      *---------------------------------------------------
      **  Totals (complex)
      **  Increment Bind Levels for Complex Set only
     C                   Z-ADD     ##TBIN        S#PBIN
     C                   ADD       1             ##BNDC
     C                   Z-ADD     ##BNDC        S#TBIN
     C                   EXSR      Z92TOT
     C     1             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        WPathStr
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
      *
     C                   EXSR      POPGRS
      *
     C                   ENDIF
      *
     C     EXF092        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  Z92HDR                                         *
      * Function    :  Header (complex)                               *
      *                                                               *
      * Called by   :  ZFGE92 - Top level Group set                   *
      * Calls       :  CUSTE  - Customer Details (simple)             *
      *                CGBRCH - Branch internal Customer Address (sim)*
      *                CCYGS  - Currency Details (simple)             *
      *                ACCNT  - Account Details (simple)              *
      *                Z92DAH - Header (simple)                       *
      *****************************************************************
     C     Z92HDR        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'Z92HDR'      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     2             OCCUR     ##SRDT
      *
      **  Set up Path.
     C                   MOVEL     '\Z92HDR'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   MOVEL     WPathStr      ##SPAT
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
     C                   EXSR      PSHGRS
      *
      *-------------------------------------
      **  Customer Details (simple)
     C                   EXSR      CUSTE
     C     2             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        WPathStr
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
      *
      *-------------------------------------
      **  Account Officer Details (simple)
     C                   EXSR      ACOF
     C     2             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        WPathStr
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
      *
      *-------------------------------------------------
      **  Internal customer address information (simple)
     C                   EXSR      CGBRCH
     C     2             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        WPathStr
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
      *
      *-------------------------------------------------
      **  Currency Details (simple)
     C                   EXSR      CCYGS
     C     2             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        WPathStr
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
      *
      *-------------------------------------------------
      **  Account Details (simple)
     C                   EXSR      ACCNT
     C     2             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        WPathStr
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
      *
      *-------------------------------------------------
      **  Header (simple)
     C                   EXSR      Z92DAH
     C     2             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        WPathStr
      *
     C                   EXSR      POPGRS
      *
     C     EXFHDR        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  Z92DAH                                         *
      * Function    :  Header (simple)                                *
      *                 - Extract Capitalisation Details              *
      *                                                               *
      * Called by   :  Z92HDR - Header (complex)                      *
      * Calls       :  SRRRDE - Retrieve RDE Information              *
      *****************************************************************
     C     Z92DAH        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'Z92DAH'      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     3             OCCUR     ##SRDT
      *
      **  Set up Path.
     C                   MOVEL     '\Z92DAH'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   MOVEL     WPathStr      ##SPAT
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
     C                   EXSR      PSHGRS
      *
      *------------------------------------------------------------
      **  Retrieve RDE information for next 20 RDEs in group set
      *------------------------------------------------------------
     C                   MOVEL     'Z92DAH'      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      *------------------------------------------------------------
      **  Set up  Capitalisation Type
      **  Set up  Capitalisation Frequency
      **  Set up Capitalisation Date
      **  Set up Capitalisation Value Date
      *------------------------------------------------------------
     C     FDICI         IFNE      *BLANKS
     C                   MOVEL     FDICI         ##D(1)
     C                   MOVEL     FDRIF         ##D(2)
     C                   MOVEL     FDCPD         ##D(3)
     C                   MOVEL     FDCPV         ##D(4)
     C                   ELSE
     C                   MOVEL     FCICI         ##D(1)
     C                   MOVEL     FCRIF         ##D(2)
     C                   MOVEL     FCCPD         ##D(3)
     C                   MOVEL     FCCPV         ##D(4)
     C                   ENDIF
      *
      *------------------------------------------------------------
      **  Set up Retail Account number
      *------------------------------------------------------------
     C                   MOVEL     FACNO         ##D(5)
      *------------------------------------------------------------
      **  Set up Account name
      *------------------------------------------------------------
     C                   MOVEL     FANAM         ##D(6)
      *
      **  Read next detail record (Record Type 2)
     C     KONKEY        READE     REINSDPD                               55
      *
      *------------------------------------------------------------
      **  Set up Total DR Turnover in 100s
      *------------------------------------------------------------
     C                   MOVEL     FDRTU         ##D(7)
     C                   MOVE      A6NBDP        ##D(7)
      *------------------------------------------------------------
      **  Set up Total CR Turnover in 100s
      *------------------------------------------------------------
     C                   MOVEL     FCRTU         ##D(8)
     C                   MOVE      A6NBDP        ##D(8)
      *------------------------------------------------------------
      **  Set up Taxable indicator
      *------------------------------------------------------------
     C     ACCKEY        CHAIN     ACCNTBJ0                           44
      *
      **  If account extension record not found, database error
     C     *IN44         IFEQ      *ON
      *
     C                   MOVEL     'ACCNTBJ0'    W0FILE
     C                   MOVEL     UFACCI        W0KEY                          ***************
     C                   Z-ADD     3             W0ERNB                         * DB ERROR 03 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   MOVEL     ATITAX        ##D(9)
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   EXSR      SrPackDta
      *
     C                   EXSR      POPGRS
      *................................................................
      *
     C     EX92DH        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  Z92DA1                                         *
      * Function    :  Accounts (simple)                              *
      *                 - Extract Accounts posted to                  *
      *                                                               *
      * Called by   :  Z92RE1 - Accounts (complex)                    *
      * Calls       :  SRRRDE - Retrieve RDE Information              *
      *****************************************************************
     C     Z92DA1        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'Z92DA1'      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     4             OCCUR     ##SRDT
      *
      **  Set up Path.
     C                   MOVEL     '\Z92DA1'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   MOVEL     WPathStr      ##SPAT
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
     C                   Z-ADD     S#PBIN        UFPBIN
     C                   Z-ADD     S#TBIN        UFTBIN
      *
      *------------------------------------------------------------
      **  Chain alternate accounts from REIACD
     C                   EXSR      ALTACC
      *============================================================
      *   If Dr Interest posted A/c
      *============================================================
     C*****FDACP         IFNE      *BLANKS                                                  AR807782
     C     FDAC1         IFNE      *BLANKS                                                  AR807782
     C                   EXSR      PSHGRS
      *
      **  Increment Bind Levels for Complex Set only
     C                   Z-ADD     ##TBIN        S#PBIN
     C                   ADD       1             ##BNDC
     C                   Z-ADD     ##BNDC        S#TBIN
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
      **  Retrieve RDE information for RDEs in group set
     C                   MOVEL     'Z92DA1'      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      *------------------------------------------------------------
      **  Set up Account posted type
     C                   MOVEL     'DRINTAC'     ##D(1)
      *
      *------------------------------------------------------------
      **  Set up DR Alternate A/C Branch code
     C                   MOVEL     FDRBR         ##D(2)
      *
      **  Set up A/C to post debit interest
     C                   MOVEL     #DACP         ##D(3)
      *
      *------------------------------------------------------------
      **  Set up DR Spot Rate
     C                   MOVEL     FDSPT         ##D(4)
      *
      *------------------------------------------------------------
      **  Set up DR interest currency
     C**********         MOVEL     FDACP         UFCCYX                                     AR807782
     C                   MOVEL     FDAC1         UFCCYX                                     AR807782
     C                   MOVEL     UFICCY        ##D(5)
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   Exsr      SrPackDta
      *
     C                   Z-ADD     UFPBIN        ##PBIN
     C                   Z-ADD     UFTBIN        ##TBIN
      *
     C                   EXSR      POPGRS
     C                   ENDIF
      *
      *================================================================
      *   If Cr Interest posted A/c
      *================================================================
     C*****FCACP         IFNE      *BLANKS                                                  AR807782
     C     FCAC1         IFNE      *BLANKS                                                  AR807782
     C                   EXSR      PSHGRS
      *
      **  Increment Bind Levels for Complex Set only
     C                   Z-ADD     ##TBIN        S#PBIN
     C                   ADD       1             ##BNDC
     C                   Z-ADD     ##BNDC        S#TBIN
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
      **  Retrieve RDE information for RDEs in group set
     C                   MOVEL     'Z92DA1'      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      *------------------------------------------------------------
      **  Set up Account posted type
     C                   MOVEL     'CRINTAC'     ##D(1)
      *
      *------------------------------------------------------------
      **  Set up CR Alternate A/C Branch Code
     C                   MOVEL     FCRBR         ##D(2)
      *
      *------------------------------------------------------------
      **  Set up A/C to post credit interest
     C                   MOVEL     #CACP         ##D(3)
      *
      *------------------------------------------------------------
      **  Set up CR Spot Rate
     C                   MOVEL     FCSPT         ##D(4)
      *
      *------------------------------------------------------------
      **  Set up CR interest currency
     C**********         MOVEL     FCACP         UFCCYX                                     AR807782
     C                   MOVEL     FCAC1         UFCCYX                                     AR807782
     C                   MOVEL     UFICCY        ##D(5)
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   Exsr      SrPackDta
      *
     C                   Z-ADD     UFPBIN        ##PBIN
     C                   Z-ADD     UFTBIN        ##TBIN
      *
     C                   EXSR      POPGRS
     C                   ENDIF
      *
      *================================================================
      *   If Charges posted A/c
      *================================================================
     C*****FCHCP         IFNE      *BLANKS                                                  AR807782
     C     FCHC1         IFNE      *BLANKS                                                  AR807782
     C                   EXSR      PSHGRS
      *
      **  Increment Bind Levels for Complex Set only
     C                   Z-ADD     ##TBIN        S#PBIN
     C                   ADD       1             ##BNDC
     C                   Z-ADD     ##BNDC        S#TBIN
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
      **  Retrieve RDE information for RDEs in group set
     C                   MOVEL     'Z92DA1'      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      *------------------------------------------------------------
      **  Set up Account posted type
     C                   MOVEL     'CHARGAC'     ##D(1)
      *
      *------------------------------------------------------------
      **  Set up Charges Alt. A/C Branch Code
     C                   MOVEL     FCHBR         ##D(2)
      *
      *------------------------------------------------------------
      **  Set up A/C to post charges interest
     C                   MOVEL     #CHAC         ##D(3)
      *
      *------------------------------------------------------------
      **  Set up Charges Spot Rate
     C                   MOVEL     FCHSP         ##D(4)
      *
      *------------------------------------------------------------
      **  Set up Charges currency
     C**********         MOVEL     FCHCP         UFCCYX                                     AR807782
     C                   MOVEL     FCHC1         UFCCYX                                     AR807782
     C                   MOVEL     UFICCY        ##D(5)
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   Exsr      SrPackDta

     C                   EXSR      POPGRS
      *
     C                   ENDIF
      *
      *................................................................
      *
     C     EX92D1        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  Z92DA2                                         *
      * Function    :  Commissions (simple)                           *
      *                 - Extract Commissions                         *
      *                                                               *
      * Called by   :  Z92RE2 - Commissions (complex)                 *
      * Calls       :  SRRRDE - Retrieve RDE Information              *
      *****************************************************************
     C     Z92DA2        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'Z92DA2'      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     5             OCCUR     ##SRDT
      *
      **  Set up Path.
     C                   MOVEL     '\Z92DA2'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   MOVEL     WPathStr      ##SPAT
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
     C                   Z-ADD     S#PBIN        UFPBIN
     C                   Z-ADD     S#TBIN        UFTBIN
      *
      *--------------------------------------------------
      *   If Posting Charges
      *--------------------------------------------------
     C     FTOTC         IFNE      *ZEROS
     C                   EXSR      PSHGRS
      *
      **  Increment Bind Levels for Complex Set only
     C                   Z-ADD     ##TBIN        S#PBIN
     C                   ADD       1             ##BNDC
     C                   Z-ADD     ##BNDC        S#TBIN
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
      **  Retrieve RDE information for next 20 RDEs in group set
     C                   MOVEL     'Z92DA2'      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      **  Set up Commission type
     C                   MOVEL     'POSCOM'      ##D(1)
      *
      **  Set up No. of postings chargeable
     C                   MOVEL     FNPOC         ##D(2)
      *
      **  Set up Total transaction  charges
     C                   MOVEL     FTOTC         ##D(3)
     C                   MOVE      F6NBDP        ##D(3)
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   Exsr      SrPackDta
      *
     C                   Z-ADD     UFPBIN        ##PBIN
     C                   Z-ADD     UFTBIN        ##TBIN
      *
     C                   EXSR      POPGRS
     C                   ENDIF
      *
      *--------------------------------------------------
      *   If Highest O/D Commission
      *--------------------------------------------------
     C     FCHOD         IFNE      *ZEROS
     C                   EXSR      PSHGRS
      *
      **  Increment Bind Levels for Complex Set only
     C                   Z-ADD     ##TBIN        S#PBIN
     C                   ADD       1             ##BNDC
     C                   Z-ADD     ##BNDC        S#TBIN
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
      **  Retrieve RDE information for next 20 RDEs in group set
     C                   MOVEL     'Z92DA2'      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      **  Set up Commission type
     C                   MOVEL     'HODCOM'      ##D(1)
      *
      **  Set up No. chargeable
     C                   Z-ADD     *ZEROS        UFNOCH
     C                   MOVEL     UFNOCH        ##D(2)
      *
      **  Set up Highest O/D Commission Amt
     C                   MOVEL     FCHOD         ##D(3)
     C                   MOVE      A6NBDP        ##D(3)
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   Exsr      SrPackDta
      *
     C                   Z-ADD     UFPBIN        ##PBIN
     C                   Z-ADD     UFTBIN        ##TBIN
      *
     C                   EXSR      POPGRS
     C                   ENDIF
      *
      *--------------------------------------------------
      *   If Turnover Commission
      *--------------------------------------------------
     C     FCTUR         IFNE      *ZEROS
     C                   EXSR      PSHGRS
      *
      **  Increment Bind Levels for Complex Set only
     C                   Z-ADD     ##TBIN        S#PBIN
     C                   ADD       1             ##BNDC
     C                   Z-ADD     ##BNDC        S#TBIN
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
      **  Retrieve RDE information for next 20 RDEs in group set
     C                   MOVEL     'Z92DA2'      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      **  Set up Commission type
     C                   MOVEL     'TUOCOM'      ##D(1)
      *
      **  Set up No. chargeable
     C                   Z-ADD     *ZEROS        UFNOCH
     C                   MOVEL     UFNOCH        ##D(2)
      *
      **  Set up Turnover Commission Amount
     C                   MOVEL     FCTUR         ##D(3)
     C                   MOVE      A6NBDP        ##D(3)
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   Exsr      SrPackDta
      *
     C                   Z-ADD     UFPBIN        ##PBIN
     C                   Z-ADD     UFTBIN        ##TBIN
      *
     C                   EXSR      POPGRS
     C                   ENDIF
      *
      *--------------------------------------------------
      *   If DR Int. Commission
      *--------------------------------------------------
     C     FCDRI         IFNE      *ZEROS
     C                   EXSR      PSHGRS
      *
      **  Increment Bind Levels for Complex Set only
     C                   Z-ADD     ##TBIN        S#PBIN
     C                   ADD       1             ##BNDC
     C                   Z-ADD     ##BNDC        S#TBIN
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
      **  Retrieve RDE information for next 20 RDEs in group set
     C                   MOVEL     'Z92DA2'      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      **  Set up Commission type
     C                   MOVEL     'DRICOM'      ##D(1)
      *
      **  Set up No. chargeable
     C                   Z-ADD     *ZEROS        UFNOCH
     C                   MOVEL     UFNOCH        ##D(2)
      *
      **  Set up DR Int. Commission Amount
     C                   MOVEL     FCDRI         ##D(3)
     C                   MOVE      A6NBDP        ##D(3)
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   Exsr      SrPackDta
      *
     C                   Z-ADD     UFPBIN        ##PBIN
     C                   Z-ADD     UFTBIN        ##TBIN
      *
     C                   EXSR      POPGRS
     C                   ENDIF
      *
      *--------------------------------------------------
      *   If Commission on Inactive A/C
      *--------------------------------------------------
     C     FCINA         IFNE      *ZEROS
     C                   EXSR      PSHGRS
      *
      **  Increment Bind Levels for Complex Set only
     C                   Z-ADD     ##TBIN        S#PBIN
     C                   ADD       1             ##BNDC
     C                   Z-ADD     ##BNDC        S#TBIN
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
      **  Retrieve RDE information for next 20 RDEs in group set
     C                   MOVEL     'Z92DA2'      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      **  Set up Commission type
     C                   MOVEL     'IACCOM'      ##D(1)
      *
      **  Set up No. chargeable
     C                   Z-ADD     *ZEROS        UFNOCH
     C                   MOVEL     UFNOCH        ##D(2)
      *
      **  Set up Commission on Inactive A/C
     C                   MOVEL     FCINA         ##D(3)
     C                   MOVE      A6NBDP        ##D(3)
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   Exsr      SrPackDta
      *
     C                   Z-ADD     UFPBIN        ##PBIN
     C                   Z-ADD     UFTBIN        ##TBIN
      *
     C                   EXSR      POPGRS
     C                   ENDIF
      *
      *--------------------------------------------------
      *   If Minimum CR Balance Commission
      *--------------------------------------------------
     C     FCMCB         IFNE      *ZEROS
     C                   EXSR      PSHGRS
      *
      **  Increment Bind Levels for Complex Set only
     C                   Z-ADD     ##TBIN        S#PBIN
     C                   ADD       1             ##BNDC
     C                   Z-ADD     ##BNDC        S#TBIN
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
      **  Retrieve RDE information for next 20 RDEs in group set
     C                   MOVEL     'Z92DA2'      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      **  Set up Commission type
     C                   MOVEL     'MCRCOM'      ##D(1)
      *
      **  Set up No. chargeable
     C                   Z-ADD     *ZEROS        UFNOCH
     C                   MOVEL     UFNOCH        ##D(2)
      *
      **  Set up Minimum CR Balance Com Amt
     C                   MOVEL     FCMCB         ##D(3)
     C                   MOVE      A6NBDP        ##D(3)
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   Exsr      SrPackDta
      *
     C                   Z-ADD     UFPBIN        ##PBIN
     C                   Z-ADD     UFTBIN        ##TBIN
      *
     C                   EXSR      POPGRS
     C                   ENDIF
      *--------------------------------------------------
      *   If Fixed Commission
      *--------------------------------------------------
     C     FCFIX         IFNE      *ZEROS
     C                   EXSR      PSHGRS
      *
      **  Increment Bind Levels for Complex Set only
     C                   Z-ADD     ##TBIN        S#PBIN
     C                   ADD       1             ##BNDC
     C                   Z-ADD     ##BNDC        S#TBIN
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
      **  Retrieve RDE information for next 20 RDEs in group set
     C                   MOVEL     'Z92DA2'      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      **  Set up Commission type
     C                   MOVEL     'FIXCOM'      ##D(1)
      *
      **  Set up No. chargeable
     C                   Z-ADD     *ZEROS        UFNOCH
     C                   MOVEL     UFNOCH        ##D(2)
      *
      **  Set up Fixed Comission Amount
     C                   MOVEL     FCFIX         ##D(3)
     C                   MOVE      A6NBDP        ##D(3)
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   Exsr      SrPackDta
      *
     C                   Z-ADD     UFPBIN        ##PBIN
     C                   Z-ADD     UFTBIN        ##TBIN
      *
     C                   EXSR      POPGRS
     C                   ENDIF
      *--------------------------------------------------
      *   If Fixed Charge
      *--------------------------------------------------
     C     FCHFX         IFNE      *ZEROS
     C                   EXSR      PSHGRS
      *
      **  Increment Bind Levels for Complex Set only
     C                   Z-ADD     ##TBIN        S#PBIN
     C                   ADD       1             ##BNDC
     C                   Z-ADD     ##BNDC        S#TBIN
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
      **  Retrieve RDE information for next 20 RDEs in group set
     C                   MOVEL     'Z92DA2'      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      **  Set up Commission type
     C                   MOVEL     'FIXCHA'      ##D(1)
      *
      **  Set up No. chargeable
     C                   Z-ADD     *ZEROS        UFNOCH
     C                   MOVEL     UFNOCH        ##D(2)
      *
      **  Set up Fixed Charge Amount
     C                   MOVEL     FCHFX         ##D(3)
     C                   MOVE      A6NBDP        ##D(3)
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   Exsr      SrPackDta
      *
     C                   Z-ADD     UFPBIN        ##PBIN
     C                   Z-ADD     UFTBIN        ##TBIN
      *
     C                   EXSR      POPGRS
     C                   ENDIF
     C/COPY WNCPYSRC,CG7020C01
      *
      *--------------------------------------------------
      *   If Statement Charges
      *--------------------------------------------------
     C     FTEDS         ADD       FTSTC         UFTSTC
     C     FCEDS         ADD       FSTCH         UFSTCH
     C     UFSTCH        IFNE      *ZEROS
     C                   EXSR      PSHGRS
      *
      **  Increment Bind Levels for Complex Set only
     C                   Z-ADD     ##TBIN        S#PBIN
     C                   ADD       1             ##BNDC
     C                   Z-ADD     ##BNDC        S#TBIN
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
      **  Retrieve RDE information for next 20 RDEs in group set
     C                   MOVEL     'Z92DA2'      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      **  Set up Commission type
     C                   MOVEL     'STACHA'      ##D(1)
      *
      **  Set up Statements Charged Number
     C                   MOVEL     UFTSTC        ##D(2)
      *
      **  Set up Stat Charges Amount
     C                   MOVEL     UFSTCH        ##D(3)
     C                   MOVE      A6NBDP        ##D(3)
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   Exsr      SrPackDta
      *
     C                   Z-ADD     UFPBIN        ##PBIN
     C                   Z-ADD     UFTBIN        ##TBIN
      *
     C                   EXSR      POPGRS
     C                   ENDIF
      *--------------------------------------------------
      *   If Generated Adj. to DR Int
      *--------------------------------------------------
     C     FGADI         IFNE      *ZEROS
     C                   EXSR      PSHGRS
      *
      **  Increment Bind Levels for Complex Set only
     C                   Z-ADD     ##TBIN        S#PBIN
     C                   ADD       1             ##BNDC
     C                   Z-ADD     ##BNDC        S#TBIN
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
      **  Retrieve RDE information for next 20 RDEs in group set
     C                   MOVEL     'Z92DA2'      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      **  Set up Commission type
     C                   MOVEL     'GDRADJ'      ##D(1)
      *
      **  Set up No. chargeable
     C                   Z-ADD     *ZEROS        UFNOCH
     C                   MOVEL     UFNOCH        ##D(2)
      *
      **  Set up Generated Adj. to DR Int
     C                   MOVEL     FGADI         ##D(3)
     C                   MOVE      A6NBDP        ##D(3)
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   Exsr      SrPackDta
      *
     C                   Z-ADD     UFPBIN        ##PBIN
     C                   Z-ADD     UFTBIN        ##TBIN
      *
     C                   EXSR      POPGRS
     C                   ENDIF
      *--------------------------------------------------
      *   If Generated Adj. to CR Int
      *--------------------------------------------------
     C     FGACI         IFNE      *ZEROS
     C                   EXSR      PSHGRS
      *
      **  Increment Bind Levels for Complex Set only
     C                   Z-ADD     ##TBIN        S#PBIN
     C                   ADD       1             ##BNDC
     C                   Z-ADD     ##BNDC        S#TBIN
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
      **  Retrieve RDE information for next 20 RDEs in group set
     C                   MOVEL     'Z92DA2'      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      **  Set up Commission type
     C                   MOVEL     'GCRADJ'      ##D(1)
      *
      **  Set up No. chargeable
     C                   Z-ADD     *ZEROS        UFNOCH
     C                   MOVEL     UFNOCH        ##D(2)
      *
      **  Set up Generated Adj. to CR int
     C                   MOVEL     FGACI         ##D(3)
     C                   MOVE      A6NBDP        ##D(3)
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   Exsr      SrPackDta
      *
     C                   EXSR      POPGRS
     C                   ENDIF
      *................................................................
      *
     C     EX92D2        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  BRANCH                                         *
      * Function    :  Branch Details (Simple)                        *
      *                - Obtain Branch Details                        *
      *                                                               *
      * Called by   :  ZFGE92 - top Level group set                   *
      * Calls       :  SRRRDE - Retrieve RDE Information              *
      *                AOBRCHR0 - Obtain Branch Details               *
      *****************************************************************
     C     BRANCH        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'BRANCH'      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     6             OCCUR     ##SRDT
      *
      **  Set up Path.
     C                   MOVEL     '\BRANCH'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   MOVEL     WPathStr      ##SPAT
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
     C                   EXSR      PSHGRS
      *................................................................
      *
      **  Retrieve RDE information for RDE's in Group Set
     C                   MOVEL     'BRANCH'      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      **  Get Branch Details if the Branch has changed
     C     FBRCA         IFNE      UFBRCD
     C                   CALL      'AOBRCHR0'
     C                   PARM      '*MSG    '    UFRTCD
     C                   PARM      '*KEY    '    UFOPTN
     C                   PARM      FBRCA         UFBRCD
     C     SDBRCH        PARM      SDBRCH        DSFDY
      *
      **  Database Error
     C     UFRTCD        IFNE      *BLANK
     C                   MOVEL     'SDBRCHPD'    W0FILE
     C                   MOVEL     FBRCA         W0KEY                          ***************
     C                   Z-ADD     2             W0ERNB                         * DB ERROR 02 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ENDIF
      *
      **  Set up Branch Code
     C                   MOVEL     A8BRCD        ##D(1)
      *
      **  Set up Branch Name
     C                   MOVEL     A8BRNM        ##D(2)
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   Exsr      SrPackDta
      *
     C                   EXSR      POPGRS
      *................................................................
      *
     C     EXBRCH        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  CGBRCH                                         *
      * Function    :  Extract new fields from Customer details file  *
      *                and Correspondent details file                 *
      * Called by   :  Z92HDR                                         *
      * Calls       :                                                 *
      *****************************************************************
     C     CGBRCH        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'CGBRCH'      @STK(Q)
      *
      *................................................................
      *
      **  Retrieve subroutine specific data.
     C     20            OCCUR     ##SRDT
      *
      **  Set up Path.
     C                   MOVEL     '\CGBRCH'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   MOVEL     WPathStr      ##SPAT
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
     C                   EXSR      PSHGRS
      ** Access branch file to retrieve Branch internal customer
      ** of originating branch of customer file
     C                   CALL      'AOBRCHR0'
     C                   PARM      '*MSG    '    ##RTCD
     C                   PARM      '*KEY    '    ##OPTN
     C                   PARM      BBBRCD        ##BRCD
     C     SDBRCH        PARM      SDBRCH        DSFDY
      *
      ** DATABASE ERROR
     C     ##RTCD        IFNE      *BLANK
     C                   MOVEL     'SDBRCHPD'    W0FILE
     C                   MOVEL     BRCA          W0KEY                          ***************
     C                   Z-ADD     28            W0ERNB                         * DB ERROR 28 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      ** Get Customer Details for Branch Internal Customer
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*KEY   '     ##OPTN
     C                   PARM      A8BICN        ##KEY1
     C                   PARM      *BLANKS       ##KYST
     C     SDCUST        PARM      SDCUST        DSSDY
      *
      ** DATABASE ERROR
     C     ##RTCD        IFNE      *BLANK
     C                   MOVEL     'SDCUSTPD'    W0FILE
     C                   MOVEL     A8BICN        W0KEY                          ***************
     C                   Z-ADD     29            W0ERNB                         * DB ERROR 29 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END

      * Get Additional Customer Details for Branch Internal Customer
     C                   CALL      'AOACUSR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*KEY   '     ##OPTN
     C                   PARM      A8BICN        ##KEY1
     C     SDACUS        PARM      SDACUS        DSSDY
      *
      ** DATABASE ERROR
     C     ##RTCD        IFNE      *BLANK
     C                   MOVEL     'SDACUSPD'    W0FILE
     C                   MOVEL     A8BICN        W0KEY                          ***************
     C                   Z-ADD     37            W0ERNB                         * DB ERROR 37 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      ** Get Correspondent Details for Branch Internal Customer
     C     A8BICN        CHAIN     CGCORRL4                           99
      *
      ** If Correspondent not found
     C     *IN99         IFEQ      '1'
      *
      ** DATABASE ERROR
     C                   MOVEL     'CGCORRPD'    W0FILE                         ***************
     C                   MOVEL     A8BICN        W0KEY                          * DB ERROR 30 *
     C                   Z-ADD     30            W0ERNB                         ***************
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      **  Reset arrays
     C                   MOVEL     *BLANK        ##R
     C                   MOVEL     *BLANK        ##D
     C                   MOVEL     *BLANK        ##S
      *
      **  Telex number
     C     BBSTAD        IFNE      *BLANKS
     C                   MOVEL     BBSTAD        ##D(1)
     C                   ELSE
     C                   MOVEL     E5TXNB        ##D(1)
     C                   END
     C                   RESET                   ##RDEF
     C                   MOVEL     ' ZZSTAD'     ##RDE
     C                   MOVEL     ##RDEF        ##R(1)
      *
      **  Telephone number
     C                   MOVEL     BBCTNB        ##D(2)
     C                   RESET                   ##RDEF
     C                   MOVEL     ' ZZCTNB'     ##RDE
     C                   MOVEL     ##RDEF        ##R(2)
      *
      **  SWIFT code
     C                   MOVEL     BBCSID        ##D(3)
     C                   RESET                   ##RDEF
     C                   MOVEL     ' ZZCSID'     ##RDE
     C                   MOVEL     ##RDEF        ##R(3)
      *
      **  Bankleitzahl
     C                   MOVEL     BBBLCD        ##D(4)
     C                   RESET                   ##RDEF
     C                   MOVEL     ' ZZBLCD'     ##RDE
     C                   MOVEL     ##RDEF        ##R(4)

      **  Fax number
     C                   MOVEL     CDFAX         ##D(5)
     C                   RESET                   ##RDEF
     C                   MOVEL     ' ZZFAX'      ##RDE
     C                   MOVEL     ##RDEF        ##R(5)

      **  Branch Internal Customer Number
     C                   MOVEL     A8BICN        ##D(6)
     C                   RESET                   ##RDEF
     C                   MOVEL     ' BICNBR'     ##RDE
     C                   MOVEL     ##RDEF        ##R(6)

      **  Chips Id (Branch-Internal Customer)
     C     BBCHID        IFNE      *ZERO
     C                   MOVEL     BBCHID        ##D(7)
     C                   ELSE
     C                   MOVEL     *BLANKS       ##D(7)
     C                   ENDIF
     C                   RESET                   ##RDEF
     C                   MOVEL     ' BCHIPS_ID'  ##RDE
     C                   MOVEL     ##RDEF        ##R(7)

      **  Chips ABA (Branch-Internal Customer)
     C     BBCABA        IFNE      *ZERO
     C                   MOVEL     BBCABA        ##D(8)
     C                   ELSE
     C                   MOVEL     *BLANKS       ##D(8)
     C                   ENDIF
     C                   RESET                   ##RDEF
     C                   MOVEL     ' BCHIPS_ABA' ##RDE
     C                   MOVEL     ##RDEF        ##R(8)

      **  Chaps Sort Code (Branch-Internal Customer)
     C     BBCHSC        IFNE      *ZERO
     C                   MOVEL     BBCHSC        ##D(9)
     C                   ELSE
     C                   MOVEL     *BLANKS       ##D(9)
     C                   ENDIF
     C                   RESET                   ##RDEF
     C                   MOVEL     ' BCHAPS_SRT' ##RDE
     C                   MOVEL     ##RDEF        ##R(9)

      **  BOJ (Branch-Internal Customer)
     C                   MOVEL     BBBFIC        ##D(10)
     C                   RESET                   ##RDEF
     C                   MOVEL     ' BBOJ'       ##RDE
     C                   MOVEL     ##RDEF        ##R(10)

      **  Fedwire (Branch-Internal Customer)
     C     BBFWCD        IFNE      *ZERO
     C                   MOVEL     BBFWCD        ##D(11)
     C                   ELSE
     C                   MOVEL     *BLANKS       ##D(11)
     C                   ENDIF
     C                   RESET                   ##RDEF
     C                   MOVEL     ' BFEDWIRE'   ##RDE
     C                   MOVEL     ##RDEF        ##R(11)
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   Exsr      SrPackDta
      *
     C                   EXSR      POPGRS
      *................................................................
      *
     C     EXCGBR        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  CUSTE                                          *
      * Function    :  Extended Customer Details (Simple)             *
      *                - Obtain Customer Details                      *
      *                                                               *
      * Called by   :  Z92HDR - Top level group set                   *
      * Calls       :  SRRRDE - Retrieve RDE Information              *
      *                SRERR  - Database Error                        *
      *                AOCUSTR0 - Obtain Customer Details             *
      *****************************************************************
     C     CUSTE         BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'CUSTE '      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     7             OCCUR     ##SRDT
      *
      **  Set up Path.
     C                   MOVEL     '\CUSTE '     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   MOVEL     WPathStr      ##SPAT
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
     C                   EXSR      PSHGRS
      *................................................................
      *
      **  Retrieve RDE information for RDE's in Group Set
     C                   MOVEL     'CUSTE '      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      **  Access Customer Details if the Customer has changed.
      **  (LF/SDCUSTL1)
     C                   MOVE      FCNUM         UFCUST
     C     UFCUST        IFNE      BBCUST
     C                   MOVE      *BLANKS       UFKEY1
     C                   MOVE      FCNUM         UFKEY1
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       UFRTCD
     C                   PARM      '*KEY   '     UFOPTN
     C                   PARM                    UFKEY1
     C                   PARM      *BLANKS       UFKYST
     C     SDCUST        PARM      SDCUST        DSSDY
      *
      *   If not found, Database Error.
     C     UFRTCD        IFNE      *BLANK
     C     UFRTCD        ANDNE     '*CUSCLS'                                                MD031034
     C                   MOVEL     'SDCUSTPD'    W0FILE
     C                   MOVEL     FCNUM         W0KEY                          ***************
     C                   Z-ADD     4             W0ERNB                         * DB ERROR 04 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF

      ** Access Correspondent Details file
     C     A8BICN        CHAIN     CGCORRL4                           99
      *
      *   If not found, Database Error.
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'CGCORRPD'    W0FILE
     C                   MOVEL     A8BICN        W0KEY                          ***************
     C                   Z-ADD     38            W0ERNB                         * DB ERROR 38 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF

     C                   ENDIF

      **  Customer Address Line 1
     C                   MOVEL     BBCNA1        ##D(1)

      **  Customer Address Line 2
     C                   MOVEL     BBCNA2        ##D(2)

      **  Customer Address Line 3
     C                   MOVEL     BBCNA3        ##D(3)

      **  Customer Address Line 4
     C                   MOVEL     BBCNA4        ##D(4)

      **  Customer Name
     C                   MOVEL     BBCRNM        ##D(5)

      **  Customer Number
     C                   MOVEL     BBCUST        ##D(6)

      **  Customer Town
     C                   MOVEL     BBCRTN        ##D(7)

      **  Customer BOJ
     C     BBBFIC        IFNE      *ZERO
     C                   MOVEL     BBBFIC        ##D(8)
     C                   ELSE
     C                   MOVEL     *BLANKS       ##D(8)
     C                   ENDIF

      **  Customer CHAPS Sort Code
     C     BBCHSC        IFNE      *ZERO
     C                   MOVEL     BBCHSC        ##D(9)
     C                   ELSE
     C                   MOVEL     *BLANKS       ##D(9)
     C                   ENDIF

      **  Customer CHIPS ABA
     C     BBCABA        IFNE      *ZERO
     C                   MOVEL     BBCABA        ##D(10)
     C                   ELSE
     C                   MOVEL     *BLANKS       ##D(10)
     C                   ENDIF

      **  Customer CHIPS ID
     C     BBCHID        IFNE      *ZERO
     C                   MOVEL     BBCHID        ##D(11)
     C                   ELSE
     C                   MOVEL     *BLANKS       ##D(11)
     C                   ENDIF

      **  Customer Fedwire
     C     BBFWCD        IFNE      0
     C                   MOVEL     BBFWCD        ##D(12)
     C                   ELSE
     C                   MOVEL     *BLANKS       ##D(12)
     C                   ENDIF

      **  Customer Bankleitzahl
     C                   MOVEL     BBBLCD        ##D(13)

      **  Customer Fax Number
     C                   MOVEL     CDFAX         ##D(14)

      **  Customer SWIFT ID
     C                   MOVEL     BBCSID        ##D(15)

      **  Customer Telephone Number
     C                   MOVEL     BBCTNB        ##D(16)
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   Exsr      SrPackDta
      *
     C                   EXSR      POPGRS
      *................................................................
      *
     C     EXCUST        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  CCYGS                                          *
      * Function    :  Currency Details (Simple)                      *
      *                                                               *
      * Called by   :  ZFGE92 - Top level group set                   *
      * Calls       :  SRRRDE - Retrieve RDE Information              *
      *                SRDCDT - Determine Currency Details            *
      *                SRERR  - Database Error                        *
      *****************************************************************
     C     CCYGS         BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'CCYGS '      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     8             OCCUR     ##SRDT
      *
      **  Set up Path.
     C                   MOVEL     '\CCY   '     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   MOVEL     WPathStr      ##SPAT
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
     C                   EXSR      PSHGRS
      *................................................................
      *
      **  Retrieve RDE information for RDE's in Group Set
     C                   MOVEL     'CCY   '      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      **  Determine Currency Details
     C                   MOVE      ' '           INCCY
     C                   MOVE      FCCY          ##CCY
     C                   EXSR      SRDCDT
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*KEY'        ##OPTN
     C                   PARM      FCCY          ##CCYP
     C     SDCURR        PARM      *BLANK        DSSDY
     C*  DATABASE ERROR
     C     ##RTCD        IFNE      *BLANK
     C                   MOVEL     'SDCURRPD'    W0FILE
     C                   MOVEL     FCCY          W0KEY                          ***************
     C                   Z-ADD     09            W0ERNB                         * DB ERROR 09 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS   '    W0MSGF
     C                   EXSR      SRERR
     C                   ELSE
      **  CURRENCY IS VALID, STORE NO.OF DECIMALS IN WORKFIELD
     C                   Z-ADD     A6NBDP        F6NBDP
     C                   MOVE      A6INCY        INCCY
     C                   ENDIF
      **  Set up Currency Code
     C                   MOVEL     A6CYCD        ##D(1)
      *
      **  Set up Currency Description
     C                   MOVEL     A6CYNM        ##D(2)
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   Exsr      SrPackdta
      *
     C                   EXSR      POPGRS
      *................................................................
      *
     C     EXCCY         TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  ACCNT                                          *
      * Function    :  Account Details (Simple)                       *
      *                - Obtain Account Details                       *
      *                                                               *
      * Called by   :  ZFGE92 - Top level group set                   *
      * Calls       :  SRRRDE - Retrieve RDE Information              *
      *                SRERR  - Database Error                        *
      *****************************************************************
     C     ACCNT         BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'ACCNT '      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     9             OCCUR     ##SRDT
      *
      **  Set up Path.
     C                   MOVEL     '\ACCNT '     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   MOVEL     WPathStr      ##SPAT
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
     C                   EXSR      PSHGRS
      *................................................................
      *
      **  Retrieve RDE information for RDE's in Group Set
     C                   MOVEL     'ACCNT '      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
     C                   MOVEL     FCNUM         #FCNUM
     C                   MOVEL     FCCY          #FCCY
     C                   MOVEL     FACOD         #FACOD
     C                   MOVEL     FACSQ         #FACSQ
     C                   MOVEL     FBRCA         #FBRCA
      *
      **  Access account details (LF/ACCNT)
     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       UFRTCD
     C                   PARM      '*KEY    '    UFOPTN
     C                   PARM      *BLANKS       UFRETL
     C                   PARM                    FCNUM
     C                   PARM                    FCCY
     C                   PARM                    FACOD
     C                   PARM                    FACSQ
     C                   PARM                    FBRCA
     C     SDACCT        PARM      SDACCT        DSSDY
      *
      **  If account master record not found, access ACNUM as the account
      *
     C     UFRTCD        IFNE      *BLANK
     C     ACNOK         CHAIN     ACNUM                              91
     C     *IN91         IFEQ      '0'
     C                   MOVEL     CNUM          #FCNUM
     C                   MOVEL     CCY           #FCCY
     C                   MOVEL     ACOD          #FACOD
     C                   MOVEL     ACSQ          #FACSQ
     C                   MOVEL     BRCA          #FBRCA
     C                   MOVE      *BLANKS       UFRTCD
     C                   ENDIF
     C                   ENDIF
      **  If account master record not found, database error
     C     UFRTCD        IFNE      *BLANK
      *
     C                   MOVEL     'AOACCTR0'    W0FILE
     C                   MOVEL     UFACCI        W0KEY                          ***************
     C                   Z-ADD     1             W0ERNB                         * DB ERROR 01 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      **  Set up Account Identifier
     C                   MOVEL     UFACCI        ##D(1)
      *
      **  Set up Retail Account Number
     C     ACNO          IFNE      *ZEROS
     C                   MOVEL     ACNO          ##D(2)
     C                   ENDIF
      *
      **  Set up Account Name
     C                   MOVEL     ANAM          ##D(3)
      *
      **  Set up Account Type
     C                   MOVEL     ATYP          ##D(4)
      *
      ** Extract 'Account code'
      *
      **  Set up Statement Balances in Euros Indicator
     C     CEU013        IFEQ      'Y'
     C                   MOVEL     EUSB          ##D(5)
     C                   ENDIF
      *
      ** Set up International Bank Account Number (IBAN)
     C     CFT004        IFEQ      'Y'
     C                   MOVE      *BLANKS       PIWITH
     C     IBAN          IFNE      *BLANKS
     C                   CALL      'AOIBANR3'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      IBAN          PIBAN
     C                   PARM                    PIWITH
     C                   PARM      *BLANKS       PINOBL
     C                   ENDIF
     C                   MOVEL     PIWITH        ##D(6)
     C                   ENDIF
      *
      ** Extract 'Account code'
     C                   MOVEL     FACOD         ##D(7)
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   Exsr      SrPackDta
      *
     C                   EXSR      POPGRS
      *................................................................
      *
     C     EXACCN        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  Z92RE1                                         *
      * Function    :  Accounts (complex)                             *
      *                                                               *
      * Called by   :  ZFGE92 - Top level group set                   *
      * Calls       :  Z92DA1 - Accounts (simple)                     *
      *****************************************************************
     C     Z92RE1        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'Z92RE1'      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     10            OCCUR     ##SRDT
      *
      **  Set up Path.
     C                   MOVEL     '\Z92RE1'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   MOVEL     WPathStr      ##SPAT
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
     C                   EXSR      PSHGRS
      *................................................................
      *
      **  For each detail with record type 2
     C     FRECT         IFEQ      002
      *--------------------------------------------
      **  Call subroutine for Accounts (simple)
      *--------------------------------------------
     C                   EXSR      Z92DA1
     C     10            OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        WPathStr
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
      *
     C                   ENDIF
      *
     C                   EXSR      POPGRS
      *................................................................
      *
     C     EXSRE1        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  Z92RE2                                         *
      * Function    :  Commissions (complex)                          *
      *                                                               *
      * Called by   :  ZFGE92 - Top level group set                   *
      * Calls       :  Z92DA2 - Commissions (simple)                  *
      *****************************************************************
     C     Z92RE2        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'Z92RE2'      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     11            OCCUR     ##SRDT
      *
      **  Set up Path.
     C                   MOVEL     '\Z92RE2'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   MOVEL     WPathStr      ##SPAT
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
     C                   EXSR      PSHGRS
      *................................................................
      *
      **  For each detail with record type 2
     C     FRECT         IFEQ      002
     C/COPY WNCPYSRC,CG7020C02
      *--------------------------------------------
      **  Call subroutine for commissions (simple)
      *--------------------------------------------
     C                   EXSR      Z92DA2
     C     11            OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        WPathStr
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
      *
     C                   ENDIF
      *
     C                   EXSR      POPGRS
      *................................................................
      *
     C     EXSRE2        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  Z92RE3                                         *
      * Function    :  DR Rate Changes       (complex)                *
      *                                                               *
      * Called by   :  ZFGE92 - Top level group set                   *
      * Calls       :  Z92DA3 - DR Rate Changes       (simple)        *
      *****************************************************************
     C     Z92RE3        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'Z92RE3'      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     12            OCCUR     ##SRDT
      *
      **  Set up Path.
     C                   MOVEL     '\Z92RE3'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   MOVEL     WPathStr      ##SPAT
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
     C                   EXSR      PSHGRS
      *................................................................
      *
      **  For each detail with record type 3
     C     *IN55         DOWEQ     *OFF
     C     FRECT         ANDEQ     003
      *
     C     FDRIA         IFNE      0
      *
      **  Increment Bind Levels for Complex Set only
     C                   Z-ADD     ##TBIN        S#PBIN
     C                   ADD       1             ##BNDC
     C                   Z-ADD     ##BNDC        S#TBIN
      *
      **  Call subroutine for DR Rate Chg Details (simple)
     C                   EXSR      Z92DA3
     C     12            OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        WPathStr
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
     C                   ENDIF
      *
      **  Read next detail record (Record type 3,4,5 or 6)
     C     KONKEY        READE     REINSDPD                               55
      *
     C                   ENDDO
      *
     C                   EXSR      POPGRS
      *................................................................
      *
     C     EXSRE3        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  Z92RE4                                         *
      * Function    :  Overdrafts    (complex)                        *
      *                                                               *
      * Called by   :  ZFGE92 - Top level group set                   *
      * Calls       :  Z92DA4 - Overdrafts    (simple)                *
      *****************************************************************
     C     Z92RE4        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'Z92RE4'      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     13            OCCUR     ##SRDT
      *
      **  Set up Path.
     C                   MOVEL     '\Z92RE4'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   MOVEL     WPathStr      ##SPAT
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
     C                   EXSR      PSHGRS
      *................................................................
      *
      **  For each detail with record type 4
     C     *IN55         DOWEQ     *OFF
     C     FRECT         ANDEQ     004
      *
     C     FODIA         IFNE      0
      *
      **  Increment Bind Levels for Complex Set only
     C                   Z-ADD     ##TBIN        S#PBIN
     C                   ADD       1             ##BNDC
     C                   Z-ADD     ##BNDC        S#TBIN
      *
      **  Call subroutine for !berziehungen (simple)
     C                   EXSR      Z92DA4
     C     13            OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        WPathStr
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
     C                   ENDIF
      *
      **  Read next detail record (Record type 4,5 or 6)
     C     KONKEY        READE     REINSDPD                               55
      *
     C                   ENDDO
      *
     C                   EXSR      POPGRS
      *................................................................
      *
     C     EXSRE4        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  Z92RE5                                         *
      * Function    :  CR Rate Changes       (complex)                *
      *                                                               *
      * Called by   :  ZFGE92 - Top level group set                   *
      * Calls       :  Z92DA5 - CR Rate Changes       (simple)        *
      *****************************************************************
     C     Z92RE5        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'Z92RE5'      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     14            OCCUR     ##SRDT
      *
      **  Set up Path.
     C                   MOVEL     '\Z92RE5'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   MOVEL     WPathStr      ##SPAT
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
     C                   EXSR      PSHGRS
      *................................................................
      *
      **  For each detail with record type 5
     C     *IN55         DOWEQ     *OFF
     C     FRECT         ANDEQ     005
      *
     C     FCRIA         IFNE      0
      *
      **  Increment Bind Levels for Complex Set only
     C                   Z-ADD     ##TBIN        S#PBIN
     C                   ADD       1             ##BNDC
     C                   Z-ADD     ##BNDC        S#TBIN
      *
      **  Call subroutine for CR Rate Chg Details (simple)
     C                   EXSR      Z92DA5
     C     14            OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        WPathStr
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
     C                   ENDIF
      *
      **  Read next detail record (Record type 5 or 6)
     C     KONKEY        READE     REINSDPD                               55
      *
     C                   ENDDO
      *
     C                   EXSR      POPGRS
      *................................................................
      *
     C     EXSRE5        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  Z92TOT                                         *
      * Function    :  Totals (complex)                               *
      *                                                               *
      * Called by   :  ZFGE92 - Top level group set                   *
      * Calls       :  Z92DA6 - Totals (simple)                       *
      *****************************************************************
     C     Z92TOT        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'Z92TOT'      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     15            OCCUR     ##SRDT
      *
      **  Set up Path.
     C                   MOVEL     '\Z92TOT'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   MOVEL     WPathStr      ##SPAT
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
     C                   EXSR      PSHGRS
      *................................................................
      *
      **  For each detail with record type 6
     C     *IN55         DOWEQ     *OFF
     C     FRECT         ANDEQ     006
      *
      **  If Secondary Tax is ON then process CGSTAX
      *
     C     CER048        IFEQ      'Y'
     C                   OPEN      SDCSINL7
     C                   EXSR      CGSTAX
     C     15            OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        WPathStr
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
     C                   CLOSE     SDCSINL7
     C                   ENDIF
      *
      **  If Third Tax is ON then process CGTTAX
      *
     C     CER054        IFEQ      'Y'
     C                   EXSR      CGTTAX
     C     15            OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        WPathStr
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
     C                   ENDIF
      *
      **  Call subroutine for Totals (simple)
     C                   EXSR      Z92DA6
     C     15            OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        WPathStr
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
      *
      **  Read next detail record (Record type 6)
     C     KONKEY        READE     REINSDPD                               55
      *
     C                   ENDDO
      *
     C                   EXSR      POPGRS
      *................................................................
      *
     C     EXSTOT        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  Z92DA3                                         *
      * Function    :  DR Rate Changes       (simple)                 *
      *                                                               *
      * Called by   :  Z92RE3 - DR Rate Changes       (complex)       *
      * Calls       :  SRRRDE - Retrieve RDE Information              *
      *                SRERR  - Database Error                        *
      *****************************************************************
     C     Z92DA3        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'Z92DA3'      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     16            OCCUR     ##SRDT
      *
      **  Set up Path.
     C                   MOVEL     '\Z92DA3'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   MOVEL     WPathStr      ##SPAT
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
     C                   EXSR      PSHGRS
      *................................................................
      *
      **  Retrieve RDE information for RDE's in Group Set
     C                   MOVEL     'Z92DA3'      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      **  Set up Debit interest Rate
     C     FDRRT         IFNE      0
     C                   MOVEL     FDRRT         ##D(1)
     C                   ENDIF
      *
      **  Set up DR interest calculation type
     C                   MOVEL     FDICT         ##D(2)
      *
      **  Set up DR interest calc. subtype
     C                   MOVEL     FDCST         ##D(3)
      *
      **  Set up DR Int rate change val date
     C                   MOVEL     FDRIV         ##D(4)
      *
      **  Set up DR Interest 'To' Value Date
     C                   MOVEL     FDRTD         ##D(5)
      *
      **  Set up DR Interest Numbers
     C                   MOVEL     FDRIN         ##D(6)
      *
      **  Set up DR Interest Amount
     C                   MOVEL     FDRIA         ##D(7)
     C                   MOVE      F6NBDP        ##D(7)
     C*------------------------------------------------------
     C* if necessary, calculate amt.in Euro
     C*------------------------------------------------------
     C     CEU014        IFEQ      'Y'
     C                   MOVE      *BLANKS       EQCY
     C                   MOVE      FCCY          ##CCY
     C                   EXSR      SRDCDT
     C     A6INCY        IFEQ      'Y'
     C                   MOVE      BKEURO        EQCY
     C                   ENDIF
     C*
     C     ##CCY         IFEQ      BKEURO
     C*
     C**  Access Customer details
     C                   MOVEL     CNUM          ##KEY1
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*KEY   '     ##OPTN
     C                   PARM                    ##KEY1
     C                   PARM      *BLANKS       ##KYST
     C     SDCUST        PARM      SDCUST        DSSDY
     C*  DATABASE ERROR
     C     ##RTCD        IFNE      *BLANK
     C     ##RTCD        ANDNE     '*CUSCLS'                                                MD031034
     C                   MOVEL     'SDCUSTPD'    W0FILE
     C                   MOVEL     CNUM          W0KEY                          ***************
     C                   Z-ADD     29            W0ERNB                         * DB ERROR 29 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS   '    W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   MOVE      BBDINC        EQCY
     C                   ENDIF
      *
      ** Retrieve Equiv. Currency Details (no.of decimals)
     C     EQCY          IFNE      *BLANKS
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*KEY'        ##OPTN
     C                   PARM      EQCY          ##CCYP
     C     SDCURR        PARM      *BLANK        DSSDY
      *  DATABASE ERROR
     C     ##RTCD        IFNE      *BLANK
     C                   MOVEL     'SDCURRPD'    W0FILE
     C                   MOVEL     EQCY          W0KEY                          ***************
     C                   Z-ADD     09            W0ERNB                         * DB ERROR 09 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS   '    W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   Z-ADD     FDRIA         P@FRAM
     C                   MOVE      ##CCY         P@FRCY
     C                   MOVE      EQCY          P@TOCY
     C     INCCY         IFEQ      'Y'
     C     FCCY          OREQ      'EUR'
     C     A6INCY        ANDEQ     'Y'
     C                   EXSR      R@EURO
     C                   Z-ADD     ##OUTA        WRK15
     C                   MOVEL     WRK15         ##D(8)
     C                   MOVE      A6NBDP        ##D(8)
      *
     C                   MOVEL     EQCY          ##D(9)
     C                   MOVEL     A6CYNM        ##D(10)
     C                   MOVEL     P@EXRT        ##D(11)
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------
     C**  Accumulate RDE's and associated data and output to
     C**  PF/CGUDTAPD.
     C                   Exsr      SrPackDta
      *
     C                   EXSR      POPGRS
      *................................................................
      *
     C     EXSDA3        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      * Subroutine  :  R@EURO                                         *
      * Function    :  EURO Currency Conversion:                      *
      *                Converts P@FRAM in P@FRCY to ##OUTA in P@TOCY. *
      * Called by   :  Z92DA3                                         *
      *                                                               *
      * Calls       :  EU0200                                         *
      *                SRERR                                          *
      *****************************************************************
     C     R@EURO        BEGSR
      *
     C                   Z-ADD     0             ##OUTA
     C                   CALL      'EU0200'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM                    P@FRAM
     C                   PARM                    P@FRCY
     C                   PARM                    P@TOCY
     C                   PARM                    P@OUTA
     C                   PARM                    P@INTA
     C                   PARM                    P@EXRT
     C                   PARM                    P@MDIN
      *
      ** Database error handling:
      *
     C     P@RTCD        IFEQ      '*ERROR*'
     C                   MOVEL     'EU0200  '    W0FILE
     C                   MOVEL     '*CALL   '    W0KEY                          ***************
     C                   Z-ADD     34            W0ERNB                         * DB ERROR 34 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
      *
      ** Otherwise, store amount in settlement currency as ##OUTA
      *
     C                   ELSE
     C                   MOVE      P@OUTA        ##OUTA
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  Z92DA4                                         *
      * Function    :  Overdraft             (simple)                 *
      *                                                               *
      * Called by   :  Z92RE4 - Overdraft     (complex)               *
      * Calls       :  SRRRDE - Retrieve RDE Information              *
      *                SRERR  - Database Error                        *
      *****************************************************************
     C     Z92DA4        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'Z92DA4'      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     17            OCCUR     ##SRDT
      *
      **  Set up Path.
     C                   MOVEL     '\Z92DA4'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   MOVEL     WPathStr      ##SPAT
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
     C                   EXSR      PSHGRS
      *................................................................
      *
      **  Retrieve RDE information for RDE's in Group Set
     C                   MOVEL     'Z92DA4'      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      **  Set up Additional O/D Int Rate
     C                   MOVEL     FAODR         ##D(1)
      *
      **  Set up Add. O/D Value Date
     C                   MOVEL     FAODV         ##D(2)
      *
      **  Set up Add. O/D 'TO' Value Date
     C                   MOVEL     FAOTD         ##D(3)
      *
      **  Set up Overdraft Interest Numbers
     C                   MOVEL     FODIN         ##D(4)
      *
      **  Set up Overdraft Interest Amount
     C                   MOVEL     FODIA         ##D(5)
     C                   MOVE      F6NBDP        ##D(5)
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   Exsr      SrPackDta
      *
     C                   EXSR      POPGRS
      *................................................................
      *
     C     EXSDA4        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  Z92DA5                                         *
      * Function    :  CR Rate Changes       (simple)                 *
      *                                                               *
      * Called by   :  Z92RE5 - CR Rate Changes (complex)             *
      * Calls       :  SRRRDE - Retrieve RDE Information              *
      *                SRERR  - Database Error                        *
      *****************************************************************
     C     Z92DA5        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'Z92DA5'      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     18            OCCUR     ##SRDT
      *
      **  Set up Path.
     C                   MOVEL     '\Z92DA5'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   MOVEL     WPathStr      ##SPAT
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
     C                   EXSR      PSHGRS
      *................................................................
      *
      **  Retrieve RDE information for RDE's in Group Set
     C                   MOVEL     'Z92DA5'      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      **  Set up CR Interest Rate
     C     FCRRT         IFNE      0
     C                   MOVEL     FCRRT         ##D(1)
     C                   ENDIF
      *
      **  Set up CR Interest Calculation type
     C                   MOVEL     FCICT         ##D(2)
      *
      **  Set up CR Interest Calculation subtype
     C                   MOVEL     FCCST         ##D(3)
      *
      **  Set up CR Int Rate Change Val Date
     C                   MOVEL     FCRIV         ##D(4)
      *
      **  Set up CR interest 'To' Value Date
     C                   MOVEL     FCRTD         ##D(5)
      *
      **  Set up CR Interest Numbers
     C                   MOVEL     FCRIN         ##D(6)
      *
      **  Set up CR Interest Amount
     C                   MOVEL     FCRIA         ##D(7)
     C                   MOVE      F6NBDP        ##D(7)
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   Exsr      SrPackDta
      *
     C                   EXSR      POPGRS
      *................................................................
      *
     C     EXSDA5        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  Z92DA6                                         *
      * Function    :  Totals (simple)                                *
      *                                                               *
      * Called by   :  ZFGE92 - top level group set                   *
      * Calls       :  SRRRDE - Retrieve RDE Information              *
      *                SRERR  - Database Error                        *
      *****************************************************************
     C     Z92DA6        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'Z92DA6'      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     19            OCCUR     ##SRDT
      *
      **  Set up Path.
     C                   MOVEL     '\Z92DA6'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   MOVEL     WPathStr      ##SPAT
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
     C                   EXSR      PSHGRS
      *................................................................
      *
      **  Retrieve RDE information for RDE's in Group Set
     C                   MOVEL     'Z92DA6'      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      **  Set up Total DR interest
     C                   MOVEL     FTDRI         ##D(1)
     C                   MOVE      F6NBDP        ##D(1)
      *
      **  Set up Total CR Interest
     C                   MOVEL     FTCRI         ##D(2)
     C                   MOVE      F6NBDP        ##D(2)
      *
      **  Set up Total Net Interest
     C     WNINT         IFNE      0
     C     FTDRI         SUB       WNINT         FTNTI
     C                   ENDIF
      *
     C                   MOVEL     FTNTI         ##D(3)
     C                   MOVE      F6NBDP        ##D(3)
      *
      **  Set up Total Charge Amount
     C                   MOVEL     FTCHA         ##D(4)
     C                   MOVE      F6NBDP        ##D(4)
     C/COPY WNCPYSRC,CG7020C03
      *
      **  Set up Total Commission Amount
     C                   MOVEL     FTCOA         ##D(5)
     C                   MOVE      F6NBDP        ##D(5)
      *
      **  Set up Balance
     C                   MOVEL     LDBL          ##D(6)
     C                   MOVE      F6NBDP        ##D(6)
      *
     C*=======================================
     C**if necessary, calculate amt.in euro
     C     CEU014        IFEQ      'Y'
     C                   MOVE      *BLANKS       EQCY
     C                   MOVE      FCCY          ##CCY
     C                   EXSR      SRDCDT
     C     A6INCY        IFEQ      'Y'
     C     INCCY         OREQ      'Y'
     C                   MOVE      BKEURO        EQCY
     C                   ENDIF
     C*
     C     ##CCY         IFEQ      BKEURO
     C*
     C**  Access Customer details
     C                   MOVEL     CNUM          ##KEY1
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*KEY   '     ##OPTN
     C                   PARM                    ##KEY1
     C                   PARM      *BLANKS       ##KYST
     C     SDCUST        PARM      SDCUST        DSSDY
     C*  DATABASE ERROR
     C     ##RTCD        IFNE      *BLANK
     C     ##RTCD        ANDNE     '*CUSCLS'                                                MD031034
     C                   MOVEL     'SDCUSTPD'    W0FILE
     C                   MOVEL     CNUM          W0KEY                          ***************
     C                   Z-ADD     29            W0ERNB                         * DB ERROR 29 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS   '    W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   MOVE      BBDINC        EQCY
     C                   ENDIF
      *
      ** Retrieve Equivalent Currency Details
     C     EQCY          IFNE      *BLANKS
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*KEY'        ##OPTN
     C                   PARM      EQCY          ##CCYP
     C     SDCURR        PARM      *BLANK        DSSDY
     C*  DATABASE ERROR
     C     ##RTCD        IFNE      *BLANK
     C                   MOVEL     'SDCURRPD'    W0FILE
     C                   MOVEL     EQCY          W0KEY                          ***************
     C                   Z-ADD     09            W0ERNB                         * DB ERROR 09 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS   '    W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C*Total debit interest
     C                   Z-ADD     FTDRI         P@FRAM
     C                   MOVE      ##CCY         P@FRCY
     C                   MOVE      EQCY          P@TOCY
     C     INCCY         IFEQ      'Y'
     C     FCCY          OREQ      'EUR'
     C     A6INCY        ANDEQ     'Y'
     C                   EXSR      R@EURO
     C                   Z-ADD     ##OUTA        WRK15
     C                   MOVEL     WRK15         ##D(7)
     C                   MOVE      A6NBDP        ##D(7)
     C*Total crebit interest
     C                   Z-ADD     FTCRI         P@FRAM
     C                   MOVE      ##CCY         P@FRCY
     C                   MOVE      EQCY          P@TOCY
     C                   EXSR      R@EURO
     C                   Z-ADD     ##OUTA        WRK15
     C                   MOVEL     WRK15         ##D(8)
     C                   MOVE      A6NBDP        ##D(8)
      *Ledger balance
     C                   Z-ADD     LDBL          P@FRAM
     C                   MOVE      ##CCY         P@FRCY
     C                   MOVE      EQCY          P@TOCY
     C                   EXSR      R@EURO
     C                   Z-ADD     ##OUTA        WRK15
     C                   MOVEL     WRK15         ##D(9)
     C                   MOVE      A6NBDP        ##D(9)
      *
     C                   MOVEL     EQCY          ##D(10)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   Exsr      SrPackDta
      *
     C                   EXSR      POPGRS
      *................................................................
      *
     C     EXSDA6        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C/SPACE 5
      *****************************************************************
      * Subroutine :  CGSTAX                                          *
      * Function   :  Seconday Tax Details                            *
      *                                                               *
      * Called by  :  Z92TOT - Totals (complex)                       *
      * Calls      :  SRRRDE - Retrieve RDE Information               *
      *               SRERR  - Database Error                         *
      *****************************************************************
     C     CGSTAX        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'CGSTAX'      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     21            OCCUR     ##SRDT
      *
      **  Set up Path.
     C                   MOVEL     '\CGSTAX'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   MOVEL     WPathStr      ##SPAT
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
     C                   EXSR      PSHGRS

      **  Chain to file SDCSINL7 for this interest posting:
      *
      ** Populate the key fields
     C                   Z-ADD     BJRDNB        KRUND
     C                   MOVEL     'G'           KMODI
     C                   MOVEL     FCNUM         KCUST
     C                   MOVEL     FCCY          KCCY
     C                   Z-ADD     FACOD         KACOD
     C                   Z-ADD     FACSQ         KACSQ
     C                   MOVEL     FBRCA         KBRCA

     C     KCSIN1        CHAIN     SDCSINL7                           87
     C     *IN87         IFEQ      *OFF
     C     TSSTAT        IFEQ      'T'
     C                   Z-ADD     0             WGINT
     C                   Z-ADD     0             WTXSR
     C                   Z-ADD     0             WNINT
     C                   Z-ADD     0             WSTXA
     C                   Z-ADD     0             WGINC
     C                   Z-ADD     0             WPTHU
     C                   Z-ADD     0             WPTUT
     C                   Z-ADD     0             WTXSC
     C                   Z-ADD     0             WSTDT
     C                   Z-ADD     0             WNINC

      ** Third Tax fields
     C                   Z-ADD     0             WTTAXO
     C                   Z-ADD     0             WTTAXT

     C     KCSIN1        SETLL     SDCSINL7
     C     KCSIN1        READE     SDCSINL7                               87

     C     *IN87         DOWEQ     *OFF
     C                   ADD       TSGINT        WGINT
     C                   ADD       TSTXSR        WTXSR
     C                   ADD       TSNINT        WNINT
     C                   ADD       TSSTDO        WSTXA
     C                   ADD       TSGINC        WGINC
     C                   ADD       TSPTHU        WPTHU
     C                   ADD       TSPTUT        WPTUT
     C                   ADD       TSTXSC        WTXSC
     C                   ADD       TSSTDT        WSTDT
     C                   ADD       TSNINC        WNINC

      ** Also accumulate Third Tax if feature ON
     C     CER054        IFEQ      'Y'
     C                   ADD       TSTTDO        WTTAXO
     C                   ADD       TSTTDT        WTTAXT
     C                   ENDIF

     C     KCSIN1        READE     SDCSINL7                               87
     C                   ENDDO

      ** Retrieve Location Code
     C                   CALL      'AOLOCNR0'
     C                   PARM      *BLANKS       UFRTCD
     C                   PARM      '*KEY    '    UFOPTN
     C                   PARM      A8LCCD        UFLOCN
     C     SDLOCN        PARM      SDLOCN        DSFDY
      *
      **  Database Error
     C     UFRTCD        IFNE      *BLANK
     C                   MOVEL     'SDLOCNPD'    W0FILE
     C                   MOVEL     UFLOCN        W0KEY                          ***************
     C                   Z-ADD     35            W0ERNB                         * DB ERROR 35 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF

      ** Retrieve Threshold Method

      ** 1st - attempt using Location Code
     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       UFRTCD
     C                   PARM      '*KEY    '    UFOPTN
     C                   PARM      DVCNCD        UFCTRT
     C                   PARM      BBCOLC        UFCTRR
     C     SDCTTX        PARM      SDCTTX        DSFDY

      ** 2nd - if not found using locn code, attempt using blank locn code
     C     UFRTCD        IFEQ      '*NRF   '
     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       UFRTCD
     C                   PARM      '*KEY    '    UFOPTN
     C                   PARM      DVCNCD        UFCTRT
     C                   PARM      *BLANKS       UFCTRR
     C     SDCTTX        PARM      SDCTTX        DSFDY
     C                   ENDIF

      **  Database Error
     C     UFRTCD        IFNE      *BLANK
     C     UFRTCD        ANDNE     '*NRF   '
     C                   MOVEL     'SDCTTXPD'    W0FILE
     C                   MOVEL     DVCNCD        W0KEY                          ***************
     C                   Z-ADD     36            W0ERNB                         * DB ERROR 36 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF

      **  Initialise arrays to blanks
     C                   MOVEL     *BLANKS       ##R
     C                   MOVEL     *BLANKS       ##D
     C                   MOVEL     *BLANKS       ##S

      **  Secondary Tax Amount (1)
     C                   MOVEL     WSTXA         ##D(1)
     C                   RESET                   ##RDEF
     C**********         MOVEL     'SEC_TAXA'    ##RDE                                      AR864744
     C                   MOVEL     ' SEC_TAXA'   ##RDE                                      AR864744
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     TSOCDP        ##RDED
     C                   MOVEL     ##RDEF        ##R(1)

      ** Secondary Tax Basket (2)
     C                   MOVEL     TSSTXB        ##D(2)
     C                   RESET                   ##RDEF
     C**********         MOVEL     'SEC_TAXB'    ##RDE                                      AR864744
     C                   MOVEL     ' SEC_TAXB'   ##RDE                                      AR864744
     C                   MOVEL     ##RDEF        ##R(2)

      ** Secondary Tax Amount Code (3)
     C                   MOVEL     TSSTAC        ##D(3)
     C                   RESET                   ##RDEF
     C**********         MOVEL     'SEC_TXAC'    ##RDE                                      AR864744
     C                   MOVEL     ' SEC_TXAC'   ##RDE                                      AR864744
     C                   MOVEL     ##RDEF        ##R(3)

      **  Secondary Tax Rate (4)
     C                   MOVEL     TSSTRA        ##D(4)
     C                   RESET                   ##RDEF
     C**********         MOVEL     'SEC_TAXR'    ##RDE                                      AR864744
     C                   MOVEL     ' SEC_TAXR'   ##RDE                                      AR864744
     C                   MOVEL     'Rate  '      ##RDEC
     C                   MOVEL     'L4'          ##RDET
     C                   MOVEL     ##RDEF        ##R(4)

      ** CER048 switchable feature flag (5)
     C                   MOVEL     CER048        ##D(5)
     C                   RESET                   ##RDEF
     C**********         MOVEL     'CER048  '    ##RDE                                      AR864744
     C                   MOVEL     ' CER048'     ##RDE                                      AR864744
     C                   MOVEL     ##RDEF        ##R(5)

      ** Threshold Method (6)
     C                   MOVEL     EWTHMD        ##D(6)
     C                   RESET                   ##RDEF
     C**********         MOVEL     'THRSH_METH'  ##RDE                                      AR864744
     C                   MOVEL     ' THRSH_METH' ##RDE                                      AR864744
     C                   MOVEL     ##RDEF        ##R(6)

      **  Gross Interest In Deal Currency (7)
     C                   MOVEL     WGINT         ##D(7)
     C                   RESET                   ##RDEF
     C**********         MOVEL     'ZZFGINTC'    ##RDE                                      AR864744
     C                   MOVEL     ' ZZFGINTC'   ##RDE                                      AR864744
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     TSOCDP        ##RDED
     C                   MOVEL     ##RDEF        ##R(7)

      **  Gross Interest In Tax Currency (8)
     C                   MOVEL     WGINC         ##D(8)
     C                   RESET                   ##RDEF
     C**********         MOVEL     'ZZFGINTD'    ##RDE                                      AR864744
     C                   MOVEL     ' ZZFGINTD'   ##RDE                                      AR864744
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     TSTCDP        ##RDED
     C                   MOVEL     ##RDEF        ##R(8)

      ** Builld key for reading per deal / account
     C     KYACNT        KLIST
     C                   KFLD                    TSCUST
     C                   KFLD                    TSOCCY
     C                   KFLD                    TSACOD
     C                   KFLD                    TSACSQ
     C                   KFLD                    TSBRCA

     C     KYACNT        CHAIN     ACCNTBJ0                           87
                                                                                              CER069
     C                   IF        ATITAX = 'A'                                               CER069
     C                   EXSR      SRACTX                                                     CER069
     C                   ENDIF                                                                CER069

     C                   MOVEL     *BLANKS       WCONV
     C                   Z-ADD     0             FPTHU
     C                   Z-ADD     0             FPTUT

      ** Assign value according to taxable indicator
     C                   SELECT
     C                   WHEN      ATITAX = 'N'
     C                   Z-ADD     0             FPTHU
     C                   Z-ADD     0             FPTUT

     C                   WHEN      ATITAX = 'Y'
     C                   Z-ADD     WGINT         FPTHU
     C                   Z-ADD     WGINC         FPTUT

     C                   WHEN      ATITAX = 'T'
     C                   MOVEL     'Y'           WCONV
     C     TSOCCY        IFEQ      BJCYCD
     C     WGINT         SUB       WPTHU         FPTHU
     C     WGINC         SUB       WPTUT         FPTUT
     C                   ELSE
      ** Retrieve Base Currency details
     C                   MOVEL     BJCYCD        ZCCY
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       UFRTCD
     C                   PARM      '*KEY    '    UFOPTN
     C                   PARM                    ZCCY
     C*****SDCURR        PARM      SDCURR        DSFDY                                      AR847634
     C     SDCURR        PARM      SDCURR        DSSDY                                      AR847634

     C     A6MDIN        IFEQ      'D'
     C                   Z-ADD     A6SPRT        ZRATE1
     C                   ELSE
     C     A6SPRT        SUB       A6TCMP        WSPRT
     C     1             DIV(H)    WSPRT         ZRATE1

     C                   MOVEL     'D'           ZMDI1
     C                   Z-ADD     A6NBDP        ZCDPI

      ** Retrieve Deal Currency details
     C                   MOVEL     TSOCCY        ZCCY
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       UFRTCD
     C                   PARM      '*KEY    '    UFOPTN
     C                   PARM                    ZCCY
     C*****SDCURR        PARM      SDCURR        DSFDY                                      AR847634
     C     SDCURR        PARM      SDCURR        DSSDY                                      AR847634

      ** Calculate conversion rate - Base vs Deal Ccy
     C     A6MDIN        IFEQ      'D'
     C                   Z-ADD     A6SPRT        ZRATE2
     C                   ELSE
     C     A6SPRT        SUB       A6TCMP        WSPRT
     C     1             DIV(H)    WSPRT         ZRATE2
     C                   ENDIF

     C                   MOVEL     'D'           ZMDI2
     C                   Z-ADD     A6NBDP        ZCDPO

     C                   CALL      'ZXRATE'
     C                   PARM                    ZRATE1
     C                   PARM                    ZMDI1
     C                   PARM                    ZRATE2
     C                   PARM                    ZMDI2
     C                   PARM      *ZERO         ZRATEX
     C                   PARM      *BLANK        ZMDIX

     C                   Z-ADD     ZRATEX        ZCRSRT
     C                   MOVE      ZMDI1         ZCRSMD
     C                   Z-ADD     ZCDPI         ZCDPF
     C                   Z-ADD     ZCDPO         ZCDPT

     C                   Z-ADD     WPTHU         ZAMTF
     C                   Z-ADD     0             ZAMTT
     C                   EXSR      ZCCYXR
     C                   MOVE      ZAMTT         WPTHU

     C     WGINT         SUB       WPTHU         FPTHU
     C     WGINC         SUB       WPTUT         FPTUT
     C                   ENDIF

     C                   ENDIF

     C                   ENDSL

      ** Taxable Interest In Deal Currency (9)
     C                   MOVEL     FPTHU         ##D(9)
     C                   RESET                   ##RDEF
     C**********         MOVEL     'ZZFTINTC'    ##RDE                                      AR864744
     C                   MOVEL     ' ZZFTINTC'   ##RDE                                      AR864744
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     TSOCDP        ##RDED
     C                   MOVEL     ##RDEF        ##R(9)

      ** Taxable Interest In Tax Currency (10)
     C                   MOVEL     FPTUT         ##D(10)
     C                   RESET                   ##RDEF
     C**********         MOVEL     'ZZFTINTD'    ##RDE                                      AR864744
     C                   MOVEL     ' ZZFTINTD'   ##RDE                                      AR864744
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     TSTCDP        ##RDED
     C                   MOVEL     ##RDEF        ##R(10)

      ** Witholding Tax in Deal Currency (11)
     C                   MOVEL     WTXSR         ##D(11)
     C                   RESET                   ##RDEF
     C**********         MOVEL     'ZZFWHTC '    ##RDE                                      AR864744
     C                   MOVEL     ' ZZFWHTC'    ##RDE                                      AR864744
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     TSOCDP        ##RDED
     C                   MOVEL     ##RDEF        ##R(11)

      ** Witholding Tax in Tax Currency (12)
     C                   MOVEL     WTXSC         ##D(12)
     C                   RESET                   ##RDEF
     C**********         MOVEL     'ZZFWHTB '    ##RDE                                      AR864744
     C                   MOVEL     ' ZZFWHTB'    ##RDE                                      AR864744
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     TSTCDP        ##RDED
     C                   MOVEL     ##RDEF        ##R(12)

      ** Secondary Tax in Deal Currency (13)
     C                   MOVEL     WSTXA         ##D(13)
     C                   RESET                   ##RDEF
     C**********         MOVEL     'ZZFSCNC '    ##RDE                                      AR864744
     C                   MOVEL     ' ZZFSCNC'    ##RDE                                      AR864744
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     TSOCDP        ##RDED
     C                   MOVEL     ##RDEF        ##R(13)

      ** Secondary Tax in Deal Currency (14)
     C                   MOVEL     WSTXA         ##D(14)
     C                   RESET                   ##RDEF
     C**********         MOVEL     'ZZFSCNB '    ##RDE                                      AR864744
     C                   MOVEL     ' ZZFSCNB'    ##RDE                                      AR864744
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     TSTCDP        ##RDED
     C                   MOVEL     ##RDEF        ##R(14)

      ** Net Interest in Deal Currency (15)
     C                   MOVEL     WNINT         ##D(15)
     C                   RESET                   ##RDEF
     C**********         MOVEL     'ZZFNINTC'    ##RDE                                      AR864744
     C                   MOVEL     ' ZZFNINTC'   ##RDE                                      AR864744
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     TSOCDP        ##RDED
     C                   MOVEL     ##RDEF        ##R(15)

      ** Net Interest in Tax Currency (16)
     C                   MOVEL     WNINC         ##D(16)
     C                   RESET                   ##RDEF
     C**********         MOVEL     'ZZFNINTD'    ##RDE                                      AR864744
     C                   MOVEL     ' ZZFNINTD'   ##RDE                                      AR864744
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     TSTCDP        ##RDED
     C                   MOVEL     ##RDEF        ##R(16)

     C                   ENDIF
     C                   ENDIF
      *-----------------------------------------------------
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   Exsr      SrPackDta
      *
     C                   EXSR      POPGRS
      *................................................................
      *
      **  Unwind subroutine stack name
      *
     C     EXSTAX        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C/SPACE 5
      *****************************************************************
      * Subroutine :  CGTTAX                                          *
      * Function   :  Third Tax Details                               *
      *                                                               *
      * Called by  :  Z92TOT - Totals (complex)                       *
      * Calls      :  SRRRDE - Retrieve RDE Information               *
      *               SRERR  - Database Error                         *
      *****************************************************************
     C     CGTTAX        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'CGTTAX'      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     21            OCCUR     ##SRDT
      *
      **  Set up Path.
     C                   MOVEL     '\CGTTAX'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   MOVEL     WPathStr      ##SPAT
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
     C                   EXSR      PSHGRS

      ** Third Tax Amount In Deal Currency
     C                   MOVEL     WTTAXO        ##D(1)
     C                   RESET                   ##RDEF
     C**********         MOVEL     'ZZFCHTC '    ##RDE                                      AR864744
     C                   MOVEL     ' ZZFCHTC'    ##RDE                                      AR864744
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     TSOCDP        ##RDED
     C                   MOVEL     ##RDEF        ##R(1)

      ** Third Tax Amount In Tax Currency
     C                   MOVEL     WTTAXT        ##D(2)
     C                   RESET                   ##RDEF
     C**********         MOVEL     'ZZFCHTB '    ##RDE                                      AR864744
     C                   MOVEL     ' ZZFCHTB'    ##RDE                                      AR864744
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     TSTCDP        ##RDED
     C                   MOVEL     ##RDEF        ##R(2)

      ** Third Tax Rate
     C                   MOVEL     TSTTRA        ##D(3)
     C                   RESET                   ##RDEF
     C**********         MOVEL     'ZZFCHRT '    ##RDE                                      AR864744
     C                   MOVEL     ' ZZFCHRT'    ##RDE                                      AR864744
     C                   MOVEL     'Rate  '      ##RDEC
     C                   MOVEL     'L5'          ##RDET
     C                   MOVEL     ##RDEF        ##R(3)

      ** Third Tax Basket
     C                   MOVEL     TSTTXB        ##D(4)
     C                   RESET                   ##RDEF
     C**********         MOVEL     'THD_TAXB'    ##RDE                                      AR864744
     C                   MOVEL     ' THD_TAXB'   ##RDE                                      AR864744
     C                   MOVEL     ##RDEF        ##R(4)

      ** Third Tax Account Code
     C                   MOVEL     TSTTAC        ##D(5)
     C                   RESET                   ##RDEF
     C**********         MOVEL     'THD_TXAC'    ##RDE                                      AR864744
     C                   MOVEL     ' THD_TXAC'   ##RDE                                      AR864744
     C                   MOVEL     ##RDEF        ##R(5)

      ** State Code
     C                   MOVEL     TSSTCD        ##D(6)
     C                   RESET                   ##RDEF
     C**********         MOVEL     'THD_STAC'    ##RDE                                      AR864744
     C                   MOVEL     ' THD_STAC'   ##RDE                                      AR864744
     C                   MOVEL     ##RDEF        ##R(6)

      ** Religious Affiliation Code
     C                   MOVEL     TSRLAF        ##D(7)
     C                   RESET                   ##RDEF
     C**********         MOVEL     'THD_RELA'    ##RDE                                      AR864744
     C                   MOVEL     ' THD_RELA'   ##RDE                                      AR864744
     C                   MOVEL     ##RDEF        ##R(7)

      *-----------------------------------------------------
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   Exsr      SrPackDta
      *
     C                   EXSR      POPGRS
      *................................................................
      *
      **  Unwind subroutine stack name
      *
     C     EXTTAX        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  ACOF                                           *
      * Function    :  Account Officer Details                        *
      *                                                               *
      * Called by   :  Z92HDR - Header Group Set Routine              *
      * Calls       :  SRRRDE                                         *
      *                SRERR  - Database Error                        *
      *****************************************************************
     C     ACOF          BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'ACOF  '      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     22            OCCUR     ##SRDT
      *
      **  Set up Path.
     C                   MOVEL     '\ACOF  '     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   MOVEL     WPathStr      ##SPAT
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
      *................................................................
      *
      **  Retrieve RDE information for RDE's in Group Set
     C                   MOVEL     'ACOF  '      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      **  Do not process if Account Officer blank.
     C     BBACOC        IFEQ      *BLANKS
     C                   GOTO      EXACOF
     C                   ENDIF
      *
     C                   EXSR      PSHGRS
      *
      **  Access Account Officer Details
     C                   CALL      'AOACOFR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*KEY   '     ##OPTN
     C                   PARM      BBACOC        ##KEY2
     C     SDACOF        PARM      SDACOF        DSSDY
      *
      **  Account Officer details not found
     C     ##RTCD        IFNE      *BLANK
     C                   GOTO      EXACOF
     C                   END
      *
      **  Account Officer Code
     C                   MOVEL     AZACOC        ##D(1)
      *
      **  Account Officer Dept
     C                   MOVEL     AZDPCD        ##D(2)
      *
      **  Account Officer Name
     C                   MOVEL     AZACON        ##D(3)
      *
      **  Account Officer Telephone Number
     C                   MOVEL     AZAPHN        ##D(4)
      *
      **  Account Officer Telephone Extension
     C                   MOVEL     AZAEXT        ##D(5)
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   Exsr      SrPackDta
      *
     C                   EXSR      POPGRS
      *................................................................
      *
      **  Unwind subroutine stack name
      *
     C     EXACOF        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  SRGENR                                         *
      * Function    :  Generate reference number                      *
      *                by writing to PF/CGUDCRPD                      *
      *                                                               *
      * Called by   :  SRMAIN - Main Processing                       *
      * Calls       :  CG9010 - Create reference record               *
      *****************************************************************
     C     SRGENR        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRGENR'      @STK(Q)
      *
      *................................................................
      *
      **  Generate reference number and check if further processing
      **  required. Set up all available information in the record
      **  format before calling.
      *
     C                   MOVEL     FBRCA         DRBRCA
     C                   MOVEL     FBRCA         DRORBR
     C                   MOVEL     'RE'          DRMODI
     C                   CLEAR                   DRMTRN
     C                   MOVEL     FCNUM         PHCNUM
     C                   MOVEL     FCCY          PHCCY
     C                   Z-ADD     FACOD         PHACOD
     C                   Z-ADD     FACSQ         PHACSQ
     C                   MOVEL     FBRCA         PHBRCA
     C                   MOVEL     FLAC          DRMACT
     C                   MOVEL     'RETAIL'      DRPTYP
     C                   MOVEL     'INTSUM'      DRPSTP
     C                   MOVEL     'N'           DRATRM
     C                   MOVE      FCNUM         UFCUST
      *
     C                   CALL      'CG9010'
     C                   PARM                    UFRTCD
     C                   PARM      '*GEN'        UFMODE
     C                   PARM      W0CMT         ##CMT
     C                   PARM                    UFCUST
     C                   PARM                    ##UDCR
     C                   PARM                    ##ITMA
      *
      **  Blank return code implies generate correspondence.
      **  CGD1270 => no error, but suppress output for this transaction.
      *
     C     UFRTCD        IFEQ      *BLANK
     C     DRPTYP        CAT(P)    ':':0         COLON
     C     COLON         CAT(P)    DRPSTP:0      ##REFR
     C                   EXSR      WRAPRF
     C                   END
      *
     C     UFRTCD        IFNE      *BLANK
      *
     C     UFRTCD        IFEQ      'CGD1270'
     C                   MOVE      'N'           UFCOPD
     C                   ELSE
      *
     C                   MOVEL     'CG9010  '    W0FILE
     C                   MOVEL     UFRTCD        W0KEY                          ***************
     C                   Z-ADD     6             W0ERNB                         * DB ERROR 06 *
     C                   MOVEL     'CGD1286'     W0MSGD                         ***************
     C                   MOVEL     'CGUSRMSG'    W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ENDIF
      *
      *................................................................
      *
     C     EXGENR        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  SRRRDE                                         *
      * Function    :  Retrieve RDE information for RDEs in group set *
      *                                                               *
      * Called by   :  simple group set subroutines                   *
      * Calls       :  -                                              *
      *****************************************************************
     C     SRRRDE        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRRRDE'      @STK(Q)
      *
      *................................................................
      *
      **  Reset
     C                   MOVEL     *BLANK        ##R
     C                   MOVEL     *BLANK        ##D
     C                   MOVEL     *BLANK        ##S
      *
      **  Get information about next 20 RDEs in group set from compile
      **  time arrays
     C                   Z-ADD     0             #1
     C     *IN99         DOUEQ     '0'
     C     #1            OREQ      20
     C                   Z-ADD     1             #2
     C     ##GRPX        LOOKUP    ##GRP(#2)                              99
     C     *IN99         IFEQ      '1'
     C                   ADD       1             #1
     C                   MOVEL     ##RDEA(#2)    ##R(#1)
     C                   ADD       1             ##RDEN
     C                   ENDIF
     C                   ENDDO
      *
      *................................................................
      *
     C     EXRRDE        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  SRDCDT                                         *
      * Function    :  Determine Currency Details                     *
      *                                                               *
      * Called by   :                                                 *
      * Calls       :                                                 *
      *****************************************************************
     C     SRDCDT        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRDCDT'      @STK(Q)
      *
      *................................................................
      *
      **  Access array of Currency Details already loaded
     C                   Z-ADD     1             C
     C     ##CCY         LOOKUP    ##CY(C)                                99
      *
      **  If no match is found determine the next free space in the
      **  loaded currency array.
     C     *IN99         IFEQ      *OFF
     C                   Z-ADD     1             C
     C     *BLANK        LOOKUP    ##CY(C)                                99
      *
      **  If no space is left, set the Currency Data data structure to
      **  the 101st occurrence so that when the new details are
      **  retrieved no existing details are overwritten.
     C     *IN99         IFEQ      *OFF
     C     101           OCCUR     SDCURR
      *
      **  If a space is found, set up the new currency into the array
      **  and position the Currency Data data structure on the
      **  occurrence matching the array index.
     C                   ELSE
     C                   MOVE      ##CCY         ##CY(C)
     C     C             OCCUR     SDCURR
     C                   ENDIF
      *
      **  Retrieve the currency details.
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       UFRTCD
     C                   PARM      '*KEY'        UFOPTN
     C                   PARM                    ##CCY
     C     SDCURR        PARM      *BLANK        DSSDY
      *
      **  Database Error
     C     UFRTCD        IFNE      *BLANK
     C                   MOVEL     'SDCURRPD'    W0FILE
     C                   MOVEL     ##CCY         W0KEY                          ***************
     C                   Z-ADD     9             W0ERNB                         * DB ERROR 09 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      **  If the currency has been retrieved earlier, position the
      **  Currency Data data structure on the relevant occurrence.
     C                   ELSE
     C     C             OCCUR     SDCURR
     C                   ENDIF
     C*
     C     EXDCDP        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      * Subroutine  :  ALTACC                                         *
      * Function    :  Retrieve alternate accounts                    *
      *                                                               *
      * Called by   :  Z92DA1                                         *
      *****************************************************************
     C     ALTACC        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'ALTACC'      @STK(Q)
      *
     C     *LIKE         DEFINE    DACP          #DACP
     C     *LIKE         DEFINE    CACP          #CACP
     C     *LIKE         DEFINE    CHAC          #CHAC
      *
     C                   MOVEL     *BLANKS       #DACP
     C                   MOVEL     *BLANKS       #CACP
     C                   MOVEL     *BLANKS       #CHAC
      *
      **  Key list for full Account plus Posting Date
     C     KLIST1        KLIST
     C                   KFLD                    FBRCA
     C                   KFLD                    FCNUM
     C                   KFLD                    FCCY
     C                   KFLD                    FACOD
     C                   KFLD                    FACSQ
      *
     C     KLIST1        CHAIN     ACCRACJ                            91
     C     *IN91         IFEQ      *OFF
     C                   MOVEL     DACP          #DACP
     C                   MOVEL     CACP          #CACP
     C                   MOVEL     CHAC          #CHAC
     C                   ENDIF
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrPackDta - Pack/Unpack RDEs and their corresponding data.   *
      *                                                               *
      *****************************************************************
     C     SrPackDta     BEGSR

      ** Set up subroutine stack name

     C                   ADD       1             Q
     C                   MOVEL     'SrPackDta '  @STK(Q)

      ** Reformat RDE data

     C                   EXSR      SrFmtDta

     C                   MOVEL     '*NEWARR '    PAction8
     C                   MOVEL     WPathStr      W0SPAT

      ** Pack RDEs and associated data into data strings

     C                   CALL      'CG3999'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM                    PAction8
     C                   PARM                    ##R
     C                   PARM                    ##D
     C                   PARM                    ##S
     C                   PARM                    W0SPAT
     C                   PARM                    ##RN
     C                   PARM                    ##DN
     C                   PARM                    ##FM

     C                   IF        PRtnCode <> *BLANKS
     C                   MOVEL     'CG3999'      W0File
     C                   MOVEL     PRtnCode      W0Key
     C                   Z-ADD     03            W0ERNB
     C                   MOVEL     'MEM5003'     W0MsgD
     C                   MOVEL     'MIDAS  '     W0MsgF
     C                   EXSR      SRERR
     C                   ENDIF

     C                   EXSR      WRTRDE

      ** Unwind subroutine stack name

     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrFmtDta - Reformat data before packing it.                  *
      *****************************************************************
     C     SrFmtDta      BEGSR

      ** Set up subroutine stack name

     C                   ADD       1             Q
     C                   MOVEL     'SrFmtDta  '  @STK(Q)

      ** Loop through RDE's and data

     C                   Z-ADD     0             Wx1

     C     Wx1           DOUEQ     20

      ** Move RDE's and its data to their templates

     C                   ADD       1             Wx1
     C                   MOVEL     ##R(Wx1)      R#DEFN
     C                   MOVEL     ##D(Wx1)      R#DATA

      ** Reformat only if data is present and RDE is edited

     C     R#DATA        IFNE      *BLANK
     C     ##RDEC        ANDNE     *BLANK

      ** Right-align amount

     C                   MOVEA     ##NUMA        WAr29
     C                   Z-ADD     1             Wx2
     C     *BLANK        LOOKUP    WAr29(Wx2)                             61
     C                   Z-ADD     20            Wx3
     C                   Z-ADD     0             WNum20
     C     Wx2           DOWGT     1
     C     Wx2           ANDLE     20
     C     Wx3           ANDGT     1
     C                   SUB       1             Wx2
     C                   MOVEL     WAr29(Wx2)    WAr20(Wx3)
     C                   SUB       1             Wx3
     C                   ENDDO

      ** Sign

     C     ##SIGN        IFEQ      '-'
     C                   Z-SUB     WNum20        ##NUMB
     C                   ELSE
     C                   Z-ADD     WNum20        ##NUMB
     C                   ENDIF

      ** Edit type

     C     ##EDTT        IFEQ      *BLANK
     C                   MOVEL     ##RDET        ##EDTT
     C                   ENDIF

      ** Default decimal places

     C     ##DCPA        IFEQ      *BLANK
     C                   MOVEL     ##RDED        ##DCPA
     C                   ENDIF

      ** New RDE data

     C                   MOVEL     R#DATA        ##D(Wx1)

     C                   ENDIF

     C                   ENDDO

      ** Unwind subroutine stack name

     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

     C                   ENDSR
      *****************************************************************                       CER069
      /EJECT                                                                                  CER069
      *****************************************************************                       CER069
      * SRACTX - Check of EU Tax Value                                *                       CER069
      *****************************************************************                       CER069
     C     SRACTX        BEGSR                                                                CER069
                                                                                              CER069
     C                   CALL      'AOACTXR0'                                                 CER069
     C                   PARM      *BLANKS       ##RTCD                                       CER069
     C                   PARM      '*KEY   '     ##OPTN                                       CER069
     C                   PARM      CNUM          ##CNUM            6                          CER069
     C                   PARM      BRCA          ##BRCD            3                          CER069
     C     SDACTX        PARM      SDACTX        DSFDY                                        CER069
     C                   IF        ##RTCD <> *BLANKS OR ##RTCD = *BLANKS                      CER069
     C                             AND (AXETXS = 'S' OR AXETXS = 'E' OR                       CER069
     C                             AXETXS = 'D' OR AXETXS = ' ')                              CER069
     C                   EVAL      ATITAX = 'N'                                               CER069
     C                   ELSE                                                                 CER069
     C                   EVAL      ATITAX = AXETXS                                            CER069
     C                   ENDIF                                                                CER069
                                                                                              CER069
     C                   ENDSR                                                                CER069
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  SRINIT                                         *
      * Function    :  Initial processing - First Call Only           *
      *                                                               *
      * Called by   :  Mainline                                       *
      * Calls       :  AOBANKR0 - Obtain Bank details                 *
      *                AOGELRR0 - Obtain General Ledger Details       *
      *****************************************************************
     C     SRINIT        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRINIT'      @STK(Q)
      *
      *................................................................
      *
      **  Define Fields
     C     *LIKE         DEFINE    DEPBIN        ##BNDC
     C     *LIKE         DEFINE    DEPBIN        S#PBIN
     C     *LIKE         DEFINE    DETBIN        S#TBIN
     C     *LIKE         DEFINE    CCY           EQCY
     C     *LIKE         DEFINE    CCY           ##CCYP
     C     *LIKE         DEFINE    LDBL          WRK15
      *
      **  Key list for REINSDPD file
     C     KONKEY        KLIST
     C                   KFLD                    FBRCA
     C                   KFLD                    FCNUM
     C                   KFLD                    FCCY
     C                   KFLD                    FACOD
     C                   KFLD                    FACSQ
     C                   KFLD                    FKEYS1
      *
      **  Key list for ACCNTBJ0 file
     C     ACCKEY        KLIST
     C                   KFLD                    FCNUM
     C                   KFLD                    FCCY
     C                   KFLD                    FACOD
     C                   KFLD                    FACSQ
     C                   KFLD                    FBRCA
      *
      **  Key list for SETLL to REINSDPD
      **  FKEYS1 is the key value received in DSPARM
     C     KONSLL        KLIST
     C                   KFLD                    FBRCA
     C                   KFLD                    FCNUM
     C                   KFLD                    FCCY
     C                   KFLD                    FACOD
     C                   KFLD                    FACSQ
     C                   KFLD                    FKEYS1
      *
     C/COPY WNCPYSRC,CG7020C05
      *
     C*===========================================================
     C**  Call access program for Bank details
     C*===========================================================
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       UFRTCD
     C                   PARM      '*FIRST  '    UFOPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      **  Database error
     C     UFRTCD        IFNE      *BLANK
      *
     C                   MOVEL     'AOBANKR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     10            W0ERNB                         * DB ERROR 10 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C*
     C**   DETERMINE NUMBER OF DECIMAL PLACES - BASE CURRENCY
     C*
     C                   MOVEL     BJCYCD        ##CCY
     C                   EXSR      SRDCDT
     C                   Z-ADD     A6NBDP        BASCDP
      *
      **  Copyright
     C                   MOVEA     ##CPY         ##BIS
     C*
     C*===========================================================
     C* GENERAL LEDGER ICD (NEEDED FOR EURO)
     C*===========================================================
     C                   CALL      'AOGELRR0'
     C                   PARM      '*MSG   '     ##RTCD
     C                   PARM      '*FIRST '     ##OPTN
     C     SDGELR        PARM      SDGELR        DSFDY
      *
      **  Database error
     C     ##RTCD        IFNE      *BLANK
     C                   MOVEL     'AOGELRR0'    W0FILE                         *************
     C                   MOVEL     '*CALL'       W0KEY                          *DB-ERROR 33*
     C                   Z-ADD     33            W0ERNB                         *************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C*===========================================================
     C* EURO - CHECK FOR SAR CEU013
     C*===========================================================
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     ##RTCD
     C                   PARM      '*VERIFY'     ##OPTN
     C                   PARM      'CEU013'      ##SARD
     C*
     C     ##RTCD        IFEQ      *BLANK
     C                   MOVEL     'Y'           CEU013
     C                   ELSE
     C                   MOVEL     'N'           CEU013
     C                   END
     C*
     C**  Retrieve the Euro currency details for later use.
     C     CEU013        IFEQ      'Y'
     C     BKEURO        ANDNE     *BLANKS
     C                   MOVE      BKEURO        ##CCY
     C                   EXSR      SRDCDT
     C                   ENDIF
     C*===========================================================
     C*   Check for SAR CEU014
     C*===========================================================
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU014'      @SARD
      *
     C*   If record found
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CEU014
     C                   MOVE      ' '           INCCY
     C                   ELSE
     C                   MOVE      'N'           CEU014
     C                   ENDIF

      *===========================================================
      * CER048 - Secondary Tax
      *===========================================================
      *   Initialize internal switch indicator CER048
     C                   MOVE      'N'           CER048

      *   Check for SAR CER048
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CER048'      @SARD
      *
      *   If record found
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CER048
     C                   ENDIF

      *===========================================================
      * CER054 - Third Tax
      *===========================================================
      *   Initialize internal switch indicator CER054
     C                   MOVE      'N'           CER054

      *   Check for SAR CER054
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CER054'      @SARD
      *
      *   If record found
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CER054
     C                   ENDIF
      *
     C/COPY WNCPYSRC,CG7020C04
      *
      *===========================================================
      ** Access Switchable Features file and check if CCG015 is
      ** installed (Correspondence Manager)
      *===========================================================
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*VERIFY'     ##OPTN
     C                   PARM      'CCG015'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     ##RTCD        IFEQ      *BLANK
     C                   MOVE      'Y'           CCG015
     C                   ELSE
     C                   MOVE      'N'           CCG015
      *
     C     ##RTCD        IFNE      '*NRF    '
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   MOVEL     '*CALL   '    W0KEY
     C                   Z-ADD     19            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   ENDIF
     C*===========================================================
      ** Access Switchable Features file and check if CFT004 is
      ** installed (IBAN-Number)
     C*===========================================================
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*VERIFY'     ##OPTN
     C                   PARM      'CFT004'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     ##RTCD        IFEQ      *BLANK
     C                   MOVE      'Y'           CFT004
     C                   ELSE
     C                   MOVE      'N'           CFT004
     C                   ENDIF

      ** Build key for Customer Income file SDCSINPD
     C     KCSIN1        KLIST
     C                   KFLD                    KRUND
     C                   KFLD                    KMODI
     C                   KFLD                    KCUST
     C                   KFLD                    KCCY
     C                   KFLD                    KACOD
     C                   KFLD                    KACSQ
     C                   KFLD                    KBRCA
      *................................................................
      *
     C     EXINIT        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  SRINZ                                          *
      * Function    :  Initialise Fields on Program Invocation        *
      *                                                               *
      * Called by   :  Mainline                                       *
      * Calls       :  None                                           *
      *****************************************************************
     C     SRINZ         BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRINZ '      @STK(Q)
      *
      *................................................................
      *
      **  Initialise work fields
     C                   Z-ADD     *ZEROS        #1
     C                   Z-ADD     *ZEROS        #2
     C                   Z-ADD     *ZEROS        #3
     C                   MOVE      *BLANKS       WPathStr
     C     *LIKE         DEFINE    DEOSEQ        ##OSEQ
      *
     C                   Z-ADD     *ZEROS        ##OSEQ
     C                   MOVEL     'N'           ##MAST
      *
      **  Initialise Binds.
     C                   Z-ADD     1             S#PBIN
     C                   Z-ADD     1             S#TBIN
     C                   Z-ADD     1             ##BNDC
      *
      **  Use initial fields received from REINSHPD (via DSPARM) as key
      **  for later access to workfile in Z92DAH
     C     *LIKE         DEFINE    FBRCA         AFBRCA
     C     *LIKE         DEFINE    FCNUM         AFCNUM
     C     *LIKE         DEFINE    FCCY          AFCCY
     C     *LIKE         DEFINE    FACOD         AFACOD
     C     *LIKE         DEFINE    FACSQ         AFACSQ
     C     *LIKE         DEFINE    FKEYS1        AKEYS1
      *
     C                   MOVE      FBRCA         AFBRCA
     C                   MOVE      FCNUM         AFCNUM
     C                   MOVE      FCCY          AFCCY
     C                   MOVE      FACOD         AFACOD
     C                   MOVE      FACSQ         AFACSQ
     C                   MOVE      FKEYS1        AKEYS1
      *
     C     KEYWRK        KLIST
     C                   KFLD                    AFBRCA
     C                   KFLD                    AFCNUM
     C                   KFLD                    AFCCY
     C                   KFLD                    AFACOD
     C                   KFLD                    AFACSQ
     C                   KFLD                    AKEYS1
      *
      ** Initialise XML increment
      *
     C                   EXSR      INIXML
      *
     C     EXINZ         TAG
      *
      *................................................................
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
     C/COPY ZSRSRC,ZCCYXR_ILE
     C/SPACE 5
     C/COPY CGCPYSRC,SRERRPSSRL
     C/SPACE 5
     C/COPY CGCPYSRC,SRERRCLE
     O/SPACE 5
     C/COPY CGCPYSRC,CGNWEXILE
**CTDATA ##GRP
BRANCH0001 BRANCH
BRANCH0002 BRANCH NAM
CUSTE 0001 CUST_ADR1
CUSTE 0002 CUST_ADR2
CUSTE 0003 CUST_ADR3
CUSTE 0004 CUST_ADR4
CUSTE 0005 CUST_NAME
CUSTE 0006 CUSTOMER
CUSTE 0007 CUST_TOWN
CUSTE 0008 CBOJ
CUSTE 0009 CCHAPS_SRT
CUSTE 0010 CCHIPS_ABA
CUSTE 0011 CCHIPS_ID
CUSTE 0012 CFEDWIRE
CUSTE 0013 CUST_BLZ
CUSTE 0014 CUST_FAX
CUSTE 0015 CUST_SWIFT
CUSTE 0016 CUST_TEL
CCY   0001 CURRENCY
CCY   0002 CCY_DESC
ACCNT 0001 ACCOUNT
ACCNT 0002 RETL_ACNO
ACCNT 0003 ACC_NAME
ACCNT 0004 ACC_TYPE
ACCNT 0005 BAL_EURO
ACCNT 0006 IBAN
ACCNT 0007 ZZACCD
Z92DAH0001 ZZFCATY
Z92DAH0002 ZZFCAFR
Z92DAH0003 ZZFCADA    Date
Z92DAH0004 ZZFCAVA    Date
Z92DAH0005 RETL_ACNO
Z92DAH0006 ACC_NAME
Z92DAH0007 ZZFDRTU    AmountL0
Z92DAH0008 ZZFCRTU    AmountL0
Z92DAH0009 TAXI
Z92DAH0010 ZDETAIL
Z92DA10001 ZZACTYP
Z92DA10002 ZZACBRC
Z92DA10003 ZZACNT
Z92DA10004 ZZACSPT    Rate  L8
Z92DA10005 ZZACCCY
Z92DA20001 ZZCOTYP
Z92DA20002 ZZCONUM    AmountL0
Z92DA20003 ZZCOAMT    AmountL
Z92DA30001 ZZFDRRT    Rate  L7
Z92DA30002 ZZFDICT
Z92DA30003 ZZFDCST
Z92DA30004 ZZFDRIV    Date
Z92DA30005 ZZFDRTD    Date
Z92DA30006 ZZFDRIN    AmountL0
Z92DA30007 ZZFDRIA    AmountL
Z92DA30008 ZZEUR1     AmountL
Z92DA30009 EQUIV_CCY
Z92DA30010 EQUIV_CCYD
Z92DA30011 ZZEQRAT    AmountL
Z92DA40001 ZZFAODR    Rate  L7
Z92DA40002 ZZFAODV    Date
Z92DA40003 ZZFAOTD    Date
Z92DA40004 ZZFODIN    AmountL0
Z92DA40005 ZZFODIA    AmountL
Z92DA50001 ZZFCRRT    Rate  L7
Z92DA50002 ZZFCICT
Z92DA50003 ZZFCCST
Z92DA50004 ZZFCRIV    Date
Z92DA50005 ZZFCRTD    Date
Z92DA50006 ZZFCRIN    AmountL0
Z92DA50007 ZZFCRIA    AmountL
Z92DA60001 ZZFTDRI    AmountL
Z92DA60002 ZZFTCRI    AmountL
Z92DA60003 ZZFTNTI    AmountL
Z92DA60004 ZZFTCHA    AmountL
Z92DA60005 ZZFTCOA    AmountL
Z92DA60006 STMT_CFBAL AmountL
Z92DA60007 ZZDR_EU    AmountL
Z92DA60008 ZZCR_EU    AmountL
Z92DA60009 ZZEUBAL    AmountL
Z92DA60010 EQUIV_CCY
ACOF  0001 ACOF_CODE                     Account Officer Code
ACOF  0002 ACOF_DEPT                     Account Officer Dept
ACOF  0003 ACOF_NAME                     Account Officer Name
ACOF  0004 ACOF_TELP                     Account Officer Telephone Num
ACOF  0005 ACOF_TELX                     Account Officer Telephone Ext.
CGBRCH0001 ZZSTAD
CGBRCH0002 ZZCTNB
CGBRCH0003 ZZCSID
CGBRCH0004 ZZBLCD
CGBRCH0005 ZZFAX
CGBRCH0006 BICNBR
CGBRCH0007 BCHIPS_ID
CGBRCH0008 BCHIPS_ABA
CGBRCH0009 BCHAPS_SRT
CGBRCH0010 BBOJS_SRT
CGBRCH0011 BFEDWIRE
**CTDATA POWER
0000001
0000010
0000100
0001000
0010000
0100000
1000000
**CTDATA ##CPY
(c) COPYRIGHT Finastra International Limited 2011
