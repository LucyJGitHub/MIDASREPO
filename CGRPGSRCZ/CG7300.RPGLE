     H
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CG Interest Scale Reports - Extract')            *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG7300 - Interest Scale Report (Extract)                     *
      *                                                               *
      *  Function:  This program receives account references as       *
      *  (COB)      parameter and extracts information associated     *
      *             to Interest Scale report.                         *
      *                                                               *
      *  Called By: CG7290                                            *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER070             Date 19Aug14               *
      *                 MD027781           Date 30Jun14               *
      *                 CLE148             Date 23Jul12               *
      *                 AR822371           Date 02Sep11               *
      *                 AR849385           Date 16Oct11               *
      *                 AR797795           Date 19Jul11               *
      *                 AR796009           Date 05Jul11               *
      *                 AR787880           Date 13Jun11               *
      *                 CER042 *CREATE     Date 16May11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  MD027781 - Interest Scale Reports were not generated after   *
      *             Close of business due to Array Index Error        *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  AR822371 - Component CGC2050 00031 failed in error.          *
      *             Array Index Error (Child: AR822372)               *
      *  AR849385 - Dates extracted for InterestScale are in wrong    *
      *             format (Child: AR849386)                          *
      *  AR797795 - Interest Scale Report Enquiry is missing in       *
      *             BFMidas                                           *
      *  AR796009 - No Interest Scale Report was generated in         *
      *             FormsMaster                                       *
      *  AR787880 - CGUXMLPD appears to extract the header groups     *
      *             twice                                             *
      *  CER042 - Interest Scale Report Correspondence                *
      *           (Upgrade of FGE178/179)                             *
      *                                                               *
      *---------------------------------------------------------------*
     FCGISDDL0  IF   E           K DISK
     FCGISMPL0  UF A E           K DISK
     FCGCORRL4  IF   E           K DISK
     FACCNTL1   IF   E           K DISK
 
     D/COPY CGCPYSRC,CGPACKDLE
     D/COPY CGCPYSRC,SRERRDLE
 
      *-----------------------------------------------------------------
 
      **  ##GRP = Group/RDE Number             ##RDEA = RDE + Attributes
     D ##GRP           S             10    DIM(51) CTDATA PERRCD(1)
     D ##RDEA          S             22    DIM(51) ALT(##GRP)
 
      *-----------------------------------------------------------------
      **  Array of Currencies accessed by program
     D ##CY            S              3    DIM(100)
      *
      *-----------------------------------------------------------------
      **  Copyright array.
      *================================================================
 
      ** String that contains the concatenated path
     D WPathStr        S            256A
 
      ** Index for WMDsPath only
     D WPx             S              3P 0
 
      ** General purpose variables
     D Wx1             S              3P 0
     D Wx2             S              3P 0
     D Wx3             S              3P 0
     D ##INIT          S              1A
     D ##PNAM          S              7A
     D @FIRST          S              3A
     D @COUNT          S              3P 0
     D @SREFN          S              6A
     D Q               S              5P 0
     D MONTH           S              4P 0
     D WMON            S              4A
     D WWWITH          S             47A
     D WWNOBL          S             34A
     D COLON           S             11A
     D C               S              3P 0
     D CCG015          S              1A
     D CFT004          S              1A
     D ##BIS           S             80A
     D #1              S              6P 0
     D #2              S              6P 0
     D #3              S              6P 0
 
      ** Key fields
     D KYCNUM          S              6A
     D ##KEY1          S             10A
     D ##KYST          S              7A
     D ##RETL          S             10A
     D KYBRCA          S              3A
 
      ** Parameter fields
     D PAction8        S              8A
     D PCustNumChr6    S              6A
     D PItmRef         S              8A
     D PMode           S             10A
     D PRtnCode        S              7A
     D W0CMT           S              3A
     D PChgType        S              1A
     D W0SPAT          S             70A
     D*ZDAYNO***       S              5S 0                                                  AR796009
     D ZDAYNO          S              5P 0                                                  AR796009
     D ZDATFM          S              1A
     D*ZDATE****       S              6S 0                                                  AR796009
     D ZDATE           S              6P 0                                                  AR796009
     D ZADATE          S              7A
     D WKCNUM          S              6A
     D WKCCY           S              3A
     D WKACOD          S             10A
     D WKACSQ          S              2A
     D WKBRCA          S              3A
     D ##PROC          S              1A
     D ##OPTN          S              7A
     D ##RTCD          S              7A
     D ##MODE          S             10A
     D ##CMT           S              3A
     D ##CUST          S              6A
     D ##CCYP          S              3A
     D @SARD           S              6A
 
     D                 DS
      ** General data structure to define fields that need to share data
     D WGrp10                  1     10
     D  WGrpNme                1      6
     D  WGrpSeq                7     10S 0
     D  WAr20                 21     40    DIM(20)
     D  WNum20                21     40  0
     D  WAr29                 51     79    DIM(29)
 
     D                 DS
     D  ##GRPX                 1     10
     D  ##GRPS                 1      6
     D  ##RDEN                 7     10  0
      **  Look-up string for RDE definition Array
 
      **  Packed data string.
     D                 DS
     D  ##W                    1     20
     D                                     DIM(20)
     D  ##WNUM                 1     20  0
      **  Number Field
 
     D                 DS
     D  ##ITMA                 1      8
     D  ##ITEM                 1      8  0
      ** Used to convert item reference from character to numeric
 
     D ##UDCR        E DS                  EXTNAME(CGUDCRPD)
      ** External DS for incomplete reference
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      **  External DS for bank details
 
     D SDCURR        E DS                  OCCURS(101) EXTNAME(SDCURRPD)
      **  External DS for currency details
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      **  External DS for Customer details
 
     D SDACUS        E DS                  EXTNAME(SDACUSPD)
      **  External DS for Additional Customer details
 
     D SDACCT        E DS                  EXTNAME(ACCNTAB) PREFIX(AC)
      **  External DS for Master Accounts File
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D  BRDFAC       E                     EXTFLD(QQDFAC)
      **  External DS for Branch
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *   External DS for switchable features
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  First DS for access programs, short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      **  Second DS for access programs, long data structure
 
     D DSPARM        E DS                  EXTNAME(CGISDRPD)
     D  @DACCT                 4     24
      **  External DS for parameters based on PF/STMTAH
 
     D W0FMT         E DS                  EXTNAME(CGUDTAPD)
      **  Record format of PF/CGUDTAPD for use as a parameter
 
     D ##SRDT          DS                  OCCURS(20)
      **  DS to store subroutine specific data.
      **  - Previous Bind
      **  - This Bind
      **  - Saved Path
     D  ##PBIN                 1      5P 0
     D  ##TBIN                 6     10P 0
     D  ##SPAT                11     80
 
     D CPYR            DS
      **  Data Structure for Compilation - Copyright Insertion
     D  ##CPY                  1     80
     D                                     DIM(1) CTDATA PERRCD(1)
 
     D RUNDT           DS
      *  Data area Midas Rundate
     D  RUNA                   1      7
     D  RUND                   8     10P 0
     D  SSF                   11     11
     D  DATF                  12     12
     D  MBIN                  13     13
      *
      *****************************************************************
      *                                                               *
      *   Index to subroutines                                        *
      *   --------------------                                        *
      *                                                               *
      *   INT_SC - Main processing - top level group set              *
      *   Header - Header (simple)                                    *
      *   Dethdr - Posting group set 1 (complex)                      *
      *   Footer - Footer (simple)                                    *
      *   Detail - Posting group set 2 (simple)                      *
      *   SRGENR - Generate reference record                          *
      *   SRRRDE - Retrieve RDE information for RDE in group set      *
      *   SRPACKDTA - Pack/Unpack RDEs and their corresponding data   *
      *   SRFMTDTA - Reformat data before packing it                  *
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
      *                INT_SC - Main Processing - Top Level Group Set *
      *****************************************************************
      *
      **  Parameter list for current program invocation.
     C     *ENTRY        PLIST
     C                   PARM                    W0RTN
     C                   PARM                    W0CMT
     C                   PARM                    DSPARM
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'MAIN'        @STK(Q)
      *
      *................................................................
 
      **  Initial processing - Once Only
     C     ##INIT        IFEQ      *BLANK
     C                   EXSR      SRINIT
     C                   MOVE      'Y'           ##INIT
     C                   ENDIF
 
      **  Initialisation processing
     C                   EXSR      SRINZ
 
      **  Main processing - top level group set
     C                   EXSR      INT_SC
 
      *................................................................
 
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
      **  Terminate program
     C                   RETURN
 
      *****************************************************************
 
      *****************************************************************
      * Subroutine  :  INT_SC                                         *
      * Function    :  Main processing - top level group set          *
      *                                                               *
      * Called by   :  Mainline                                       *
      * Calls       :  SRGENR - Generate reference record             *
      *                DETHED - Posting group set 1 (complex)         *
      *                FOOTER - Footer (simple)                       *
      *                SRNSTD - Calculate Next Statement Date         *
      *                SRERR  - Database Error                        *
      *****************************************************************
     C     INT_SC        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'INT_SC'      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     1             OCCUR     ##SRDT
      *
      **  Set up Path.
     C                   MOVEL     '\INT_SC'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   MOVEL     WPathStr      ##SPAT
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
      *---------------------------------------------------------
      *  Position file pointer at start of this interest period
     C     ZZDLKY        SETLL     CGISDDL0
      *
      *---------------------------------------------------------
      *  Read the first interest movemnt for this account
     C     ZZDSKY        READE     CGISDDL0                               89
      *
      *  set flag to force a header to be produced
     C                   MOVE      *ON           *IN88
      *
      *  Set flag to say first pass therefore footer not produced
     C                   MOVE      'YES'         @FIRST
      *
      *  Initialise line count
     C                   Z-ADD     0             @COUNT
      *
      *  Initialise totals
     C                   Z-ADD     0             @CTOCI
     C                   Z-ADD     0             @CTODI
     C                   Z-ADD     0             @CNETI
      *
     C                   EXSR      PSHGRS
      *
      *---------------------------------------------------------
      *  Loop until end of this interest period for this account
      *---------------------------------------------------------
     C     *IN89         DOWEQ     *OFF
      *
      *  If new page
     C     *IN88         IFEQ      *ON
      *
      *  If first pass
      *
     C     @FIRST        IFEQ      'YES'
      *
      *---------------------------------------------------------
      **  Generate reference number by writing to PF/CGUDCRPD
      **  If the statement is to be produced, then produce it
      *---------------------------------------------------------
     C                   EXSR      SRGENR
     C                   ENDIF
      *
     C     ##PROC        IFEQ      'Y'
      *
      *--------------------------------------
      **  Customer Details - extended (simple)
      *--------------------------------------
     C                   EXSR      CUSTE
     C     1             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        WPathStr
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
 
      *---------------------------
      **  Branch Details (simple)
      *---------------------------
     C                   EXSR      BRANCH
     C     1             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        WPathStr
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
 
      *------------------------------------
      **  Additional Address Info (simple)
      *------------------------------------
     C                   EXSR      CGBRCH
     C     1             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        WPathStr
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
 
      *---------------------
      **  Header (simple)
      *---------------------
     C                   EXSR      HEADER
     C     1             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        WPathStr
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
     C                   ENDIF
     C                   MOVE      'NO '         @FIRST
     C                   ENDIF
      *
      *  Add the detail amounts to the calculated totals
      *
     C                   ADD       Z6INTA        @CNETI
      *
      *  If amount is negative is a credit
      *
     C     Z6INTA        IFLE      0
     C                   ADD       Z6INTA        @CTODI
      *
      *  If amount is positive is a debit
      *
     C                   ELSE
     C                   ADD       Z6INTA        @CTOCI
     C                   ENDIF
      *
      *  If the statement is to be produced, then produce it
      *
     C     ##PROC        IFEQ      'Y'
      *----------------------------------
      **  Posting Group Set 1 (complex)
      *----------------------------------
      *
      **  Increment Bind Levels for Complex Set only
     C                   Z-ADD     ##TBIN        S#PBIN
     C                   ADD       1             ##BNDC
     C                   Z-ADD     ##BNDC        S#TBIN
     C                   EXSR      DETHED
     C     1             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        WPathStr
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
     C                   ENDIF
      *
      *  Increment the line count
      *
     C                   ADD       1             @COUNT
      *
      *  If end of page set flag and reinitialise count
      *
     C*****@COUNT        IFGE      17                                                       AR787880
     C**********         MOVE      *ON           *IN88                                      AR787880
     C**********         Z-ADD     0             @COUNT                                     AR787880
     C**********         ELSE                                                               AR787880
     C                   MOVE      *OFF          *IN88
     C**********         ENDIF                                                              AR787880
      *
      *  Read the next interest move,mnt for this account
      *
     C     ZZDSKY        READE     CGISDDL0                               89
     C                   ENDDO
      *-------------------------------------------------
      *  If there were no movements output a header
      *-------------------------------------------------
     C     @FIRST        IFEQ      'YES'
      *
      **  Generate reference number by writing to PF/CGUDCRPD
      **  If the statement is to be produced, then produce it
      *
     C                   EXSR      SRGENR
      *
      *  If the statement is to be produced, then produce it
      *
     C     ##PROC        IFEQ      'Y'
      *
      *--------------------------------------
      **  Customer Details - extended (simple)
      *--------------------------------------
     C                   EXSR      CUSTE
     C     1             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        WPathStr
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
 
      *---------------------------
      **  Branch Details (simple)
      *---------------------------
     C                   EXSR      BRANCH
     C     1             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        WPathStr
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
 
      *------------------------------------
      **  Additional Address Info (simple)
      *------------------------------------
     C                   EXSR      CGBRCH
     C     1             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        WPathStr
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
      *
      *-------------------
      **  Header (simple)
      *-------------------
     C                   EXSR      HEADER
     C     1             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        WPathStr
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
     C                   ENDIF
     C                   ENDIF
      *
      *  If the statement is to be produced, then produce it
      *
     C     ##PROC        IFEQ      'Y'
      *
      *  Produce the footer for the last time
      *----------------------
      *   Footer (simple)
      *----------------------
     C                   EXSR      FOOTER
     C     1             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        WPathStr
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
     C                   ENDIF
      *
     C**********         EXSR      PSHGRS                                                   AR822371
     C**********         EXSR      PSHGRS                                          AR822371 MD027781
     C                   EXSR      POPGRS                                                   MD027781
      *
      *................................................................
     C     EXSTMT        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  CUSTE                                          *
      * Function    :  Customer Details - Extended (simple)           *
      *                 - Extract RDEs for customer's extended info   *
      *                                                               *
      * Called by   :  INT_SC - Top level group set                   *
      * Calls       :  SRRRDE - Retrieve RDE Information              *
      *                SRPACKDTA - Pack/Unpack RDEs and data          *
      *****************************************************************
     C     CUSTE         BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'CUSTE '      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     2             OCCUR     ##SRDT
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
      *
      **  Set up Customer Key
     C                   MOVEL     Z5CNUM        KYCNUM
      *
      **  Only call access obj if customer has changed since last time
     C     KYCNUM        IFNE      BBCUST
     C                   MOVEL     *BLANKS       ##KEY1
     C                   MOVEL     KYCNUM        ##KEY1
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*KEY   '     ##OPTN
     C                   PARM                    ##KEY1
     C                   PARM      *BLANKS       ##KYST
     C     SDCUST        PARM      SDCUST        DSSDY
      *
      ** Database error
     C     ##RTCD        IFNE      *BLANK
     C                   MOVEL     'SDCUSTPD'    W0FILE
     C                   MOVEL     KYCNUM        W0KEY                          ***************
     C                   Z-ADD     21            W0ERNB                         * DB ERROR 21 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C                   ENDIF
      *
      ** Retrieve Correspondent Details
     C     KYCNUM        CHAIN     CGCORRL4                           87
     C     *IN87         IFEQ      *ON
     C                   MOVEL     'CGCORRPD'    W0FILE
     C                   MOVEL     KYCNUM        W0KEY                          ***************
     C                   Z-ADD     22            W0ERNB                         * DB ERROR 22 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
 
      *................................................................
      **  Retrieve RDE information for RDEs in group set
     C                   MOVEL     'CUSTE '      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
 
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
 
      **  Customer Telephone Number
     C                   MOVEL     BBCTNB        ##D(8)
 
      **  Customer Fax Number
     C                   MOVEL     CDFAX         ##D(9)
 
      **  Customer SWIFT Code
     C                   MOVEL     BBCSID        ##D(10)
 
      **  German Bankleitzahl
     C                   MOVEL     BBBLCD        ##D(11)
 
      **  Customer Chips ID
     C     BBCHID        IFNE      0
     C                   MOVEL     BBCHID        ##D(12)
     C                   ELSE
     C                   MOVEL     *BLANKS       ##D(12)
     C                   ENDIF
 
      **  Customer Chips ABA
     C     BBCABA        IFNE      0
     C                   MOVEL     BBCHID        ##D(13)
     C                   ELSE
     C                   MOVEL     *BLANKS       ##D(13)
     C                   ENDIF
 
      **  Chaps sort code (Branch-Internal Customer)
     C     BBCHSC        IFNE      0
     C                   MOVEL     BBCHSC        ##D(14)
     C                   ELSE
     C                   MOVEL     *BLANKS       ##D(14)
     C                   ENDIF
 
      **  Customer BOJ
     C                   MOVEL     BBBFIC        ##D(15)
 
      **  Customer Fedwire
     C     BBFWCD        IFNE      0
     C                   MOVEL     BBFWCD        ##D(16)
     C                   ELSE
     C                   MOVEL     *BLANKS       ##D(16)
     C                   ENDIF
 
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   EXSR      SrPackDta
     C                   EXSR      POPGRS
      *................................................................
      *
     C     EXCUS2        TAG
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
      * Function    :  Branch Details                                 *
      *                 - Extract RDEs for Branch                     *
      *                                                               *
      * Called by   :  INT_SC - Top level group set                   *
      * Calls       :  SRRRDE - Retrieve RDE Information              *
      *                SRPACKDTA - Pack/Unpack RDEs and data          *
      *****************************************************************
     C     BRANCH        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'BRANCH'      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     2             OCCUR     ##SRDT
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
 
      **  Set up Branch Key
     C                   MOVEL     Z5BRCA        KYBRCA
      *
      **  Only call access obj if customer has changed since last time
     C     KYBRCA        IFNE      A8BRCD
     C                   CALL      'AOBRCHR0'
     C                   PARM      '*MSG    '    ##RTCD
     C                   PARM      '*KEY    '    ##OPTN
     C                   PARM                    KYBRCA
     C     SDBRCH        PARM      SDBRCH        DSFDY
 
      ** Database error
     C     ##RTCD        IFNE      *BLANK
     C                   MOVEL     'SDBRCHPD'    W0FILE
     C                   MOVEL     KYBRCA        W0KEY                          ***************
     C                   Z-ADD     22            W0ERNB                         * DB ERROR 22 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C                   ENDIF
 
      *................................................................
      **  Retrieve RDE information for RDEs in group set
     C                   MOVEL     'BRANCH'      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      **  Branch Code
     C                   MOVEL     A8BRCD        ##D(1)
 
      **  Branch Name
     C                   MOVEL     A8BRNM        ##D(2)
 
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   EXSR      SrPackDta
     C                   EXSR      POPGRS
      *................................................................
      *
     C     EXBRAN        TAG
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
      * Function    :  Additional Address Info                        *
      *                 - Extract RDEs for Additional Info            *
      *                                                               *
      * Called by   :  INT_SC - Top level group set                   *
      * Calls       :  SRRRDE - Retrieve RDE Information              *
      *                SRPACKDTA - Pack/Unpack RDEs and data          *
      *****************************************************************
     C     CGBRCH        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'CGBRCH'      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     2             OCCUR     ##SRDT
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
 
      ** Retrieve Branch Internal Customer
     C                   CALL      'AOBRCHR0'
     C                   PARM      '*MSG    '    ##RTCD
     C                   PARM      '*KEY    '    ##OPTN
     C                   PARM                    Z5BRCA
     C     SDBRCH        PARM      SDBRCH        DSFDY
 
      ** Database error
     C     ##RTCD        IFNE      *BLANK
     C                   MOVEL     'SDBRCHPD'    W0FILE
     C                   MOVEL     Z5BRCA        W0KEY                          ***************
     C                   Z-ADD     23            W0ERNB                         * DB ERROR 23 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
 
      ** Get Customer Details for Branch Internal Customer
     C                   MOVEL     *BLANKS       ##KEY1
     C                   MOVEL     A8BICN        ##KEY1
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*KEY   '     ##OPTN
     C                   PARM                    ##KEY1
     C                   PARM      *BLANKS       ##KYST
     C     SDCUST        PARM      SDCUST        DSSDY
      *
      ** Database error
     C     ##RTCD        IFNE      *BLANK
     C                   MOVEL     'SDCUSTPD'    W0FILE
     C                   MOVEL     A8BICN        W0KEY                          ***************
     C                   Z-ADD     24            W0ERNB                         * DB ERROR 24 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
 
      ** Get Additional Customer Details for Branch Internal Customer
     C                   CALL      'AOACUSR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*KEY   '     ##OPTN
     C                   PARM                    A8BICN
     C     SDACUS        PARM      SDACUS        DSSDY
      *
      ** Database error
     C     ##RTCD        IFNE      *BLANK
     C                   MOVEL     'SDACUSPD'    W0FILE
     C                   MOVEL     A8BICN        W0KEY                          ***************
     C                   Z-ADD     25            W0ERNB                         * DB ERROR 25 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
 
      ** Retrieve Correspondent Detail of Branch Int Cust No
     C     A8BICN        CHAIN     CGCORRL4                           87
      *
      ** Database error
     C     *IN87         IFEQ      *ON
     C                   MOVEL     'CGCORRPD'    W0FILE
     C                   MOVEL     A8BICN        W0KEY                          ***************
     C                   Z-ADD     26            W0ERNB                         * DB ERROR 26 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
 
      *................................................................
      **  Retrieve RDE information for RDEs in group set
     C                   MOVEL     'CGBRCH'      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
 
      ** Telex Number
     C     BBSTAD        IFNE      *BLANKS
     C                   MOVEL     BBSTAD        ##D(1)
     C                   ELSE
     C                   MOVEL     E5TXNB        ##D(1)
     C                   ENDIF
 
      ** Telephone Number
     C                   MOVEL     BBCTNB        ##D(2)
 
      ** SWIFT Code
     C                   MOVEL     BBCSID        ##D(3)
 
      ** German Bankleitzahl
     C                   MOVEL     BBBLCD        ##D(4)
 
      ** Fax Number
     C                   MOVEL     CDFAX         ##D(5)
 
      ** Branch Internal Customer Number
     C                   MOVEL     A8BICN        ##D(6)
 
      ** Chips Id (Branch-Internal Customer)
     C     BBCHID        IFNE      0
     C                   MOVEL     BBCHID        ##D(7)
     C                   ELSE
     C                   MOVEL     *BLANKS       ##D(7)
     C                   ENDIF
 
      ** Chips ABA (Branch-Internal Customer)
     C     BBCABA        IFNE      0
     C                   MOVEL     BBCABA        ##D(8)
     C                   ELSE
     C                   MOVEL     *BLANKS       ##D(8)
     C                   ENDIF
 
      **  Chaps sort code (Branch-Internal Customer)
     C     BBCHSC        IFNE      0
     C                   MOVEL     BBCHSC        ##D(9)
     C                   ELSE
     C                   MOVEL     *BLANKS       ##D(9)
     C                   ENDIF
 
      **  BOJ (Branch-Internal Customer)
     C                   MOVEL     BBBFIC        ##D(10)
 
      **  Fedwire (Branch-Internal Customer)
     C     BBFWCD        IFNE      0
     C                   MOVEL     BBFWCD        ##D(11)
     C                   ELSE
     C                   MOVEL     *BLANKS       ##D(11)
     C                   ENDIF
 
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   EXSR      SrPackDta
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
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  HEADER                                         *
      * Function    :  Header (simple)                                *
      *                 - Extract RDEs for statement header           *
      *                                                               *
      * Called by   :  INT_SC - Top level group set                   *
      * Calls       :  SRRRDE - Retrieve RDE Information              *
      *                SRPACKDTA - Pack/Unpack RDEs and data          *
      *****************************************************************
     C     HEADER        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SC-HDR'      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     2             OCCUR     ##SRDT
      *
      **  Set up Path.
     C                   MOVEL     '\SC-HDR'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   MOVEL     WPathStr      ##SPAT
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
     C                   EXSR      PSHGRS
      *
      **  Determine Currency Details
     C                   EXSR      SRDCDT
      *
      *  Convert Midas run date into 'MMDDYY' format
     C                   CALL      'ZDATE2'
     C                   PARM      Z5INCD        ZDAYNO
     C                   PARM      *BLANKS       ZDATFM
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
     C                   Z-ADD     ZDATE         MONTH
      *
      *  Find the next page number for this month and account
      *
     C     ZZMPKY        CHAIN     CGISMPL0                           87
      *
      *  If no record found or this is before last start at one
      *
     C     *IN87         IFEQ      *ON
     C     Z5INCD        ORLE      Z4INCD
     C                   Z-ADD     1             Z4PAGE
      *
      *  If a record is found increment page number
      *
     C                   ELSE
     C                   ADD       1             Z4PAGE
     C                   ENDIF
      *
      *  Store the last interest capitalisation date
      *
     C                   Z-ADD     Z5INCD        Z4INCD
      *
      *  Depending on whether a record found or not update or write
      *
     C     *IN87         IFEQ      *ON
     C                   MOVE      Z5REFN        Z4REFN
     C                   MOVE      Z5REFT        Z4REFT
     C                   Z-ADD     MONTH         Z4MNTH
     C                   WRITE     CGISMPD0
     C                   ELSE
     C                   UPDATE    CGISMPD0
     C                   ENDIF
      *
      *................................................................
      *
      **  Retrieve RDE information for RDEs in group set
     C                   MOVEL     'SC-HDR'      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      **  Set up Deal Number
     C                   MOVEL     Z5REFN        ##D(1)
      *
      **  Set up Reference Number
     C     Z5REFT        IFEQ      'R'
     C                   MOVEL     Z5REFN        ##D(2)
     C                   ELSE
     C                   MOVE      Z5REFN        @SREFN
     C                   MOVEL     @SREFN        ##D(2)
     C                   ENDIF
      *
      **  Set up Account Name for Retail otherwise, set to Blank.
     C     Z5REFT        IFEQ      'R'
     C                   MOVEL     Z5CNUM        WKCNUM
     C                   MOVEL     Z5CCY         WKCCY
     C                   MOVEL     Z5ACOD        WKACOD
     C                   MOVEL     Z5ACSQ        WKACSQ
     C                   MOVEL     Z5BRCA        WKBRCA
     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*KEY   '     ##OPTN
     C                   PARM      *BLANKS       ##RETL
     C                   PARM                    WKCNUM
     C                   PARM                    WKCCY
     C                   PARM                    WKACOD
     C                   PARM                    WKACSQ
     C                   PARM                    WKBRCA
     C     SDACCT        PARM      SDACCT        DSSDY
      *
      ** Database error
     C     ##RTCD        IFNE      *BLANK
     C                   MOVEL     'ACCNTAB '    W0FILE
     C                   MOVEL     Z5REFN        W0KEY                          ***************
     C                   Z-ADD     27            W0ERNB                         * DB ERROR 27 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
 
      ** Set up Account Name for Retail
     C                   MOVEL     ACANAM        ##D(3)
 
      ** Do not extract account name for Dealing and Lending
     C                   ELSE
     C                   MOVEL     *BLANKS       ##D(3)
     C                   ENDIF
      *
      ****Set*up*interest*from*date                                                         AR849385
      ***Convert*Midas*run*date*into*'MMDDYY'*format                                        AR849385
     C**********         CALL      'ZDATE2'                                                 AR849385
     C**********         PARM      Z5INFD        ZDAYNO                                     AR849385
     C**********         PARM      *BLANKS       ZDATFM                                     AR849385
     C**********         PARM                    ZDATE                                      AR849385
     C**********         PARM                    ZADATE                                     AR849385
     C**********         MOVEL     ZADATE        ##D(4)                                     AR849385
      ** Set up interest from date                                                          AR849385
     C                   MOVEL     Z5INFD        ##D(4)                                     AR849385
      *
      ****Set*up*interest*to*date                                                           AR849385
      ***Convert*Midas*run*date*into*'MMDDYY'*format                                        AR849385
     C**********         CALL      'ZDATE2'                                                 AR849385
     C**********         PARM      Z5INCD        ZDAYNO                                     AR849385
     C**********         PARM      *BLANKS       ZDATFM                                     AR849385
     C**********         PARM                    ZDATE                                      AR849385
     C**********         PARM                    ZADATE                                     AR849385
     C**********         MOVEL     ZADATE        ##D(5)                                     AR849385
      ** Set up interest to date                                                            AR849385
     C                   MOVEL     Z5INCD        ##D(5)                                     AR849385
      *
      **  Set up currency code
     C                   MOVEL     Z5CCY         ##D(6)
      *
      **  Set up Month (move to alpha field first)
     C                   MOVE      MONTH         WMON
     C                   MOVEL     WMON          ##D(7)
      *
      ****Set*up*Extracted*Date                                                             AR849385
      ***Convert*Midas*run*date*into*'MMDDYY'*format                                        AR849385
     C**********         CALL      'ZDATE2'                                                 AR849385
     C**********         PARM      Z5RNDB        ZDAYNO                                     AR849385
     C**********         PARM      *BLANKS       ZDATFM                                     AR849385
     C**********         PARM                    ZDATE                                      AR849385
     C**********         PARM                    ZADATE                                     AR849385
     C**********         MOVEL     ZADATE        ##D(8)                                     AR849385
      ** Set up Extracted Date                                                              AR849385
     C                   MOVEL     Z5RNDB        ##D(8)                                     AR849385
      *
      **  Set up Reference Type
     C                   MOVEL     Z5REFT        ##D(9)
      *
      **  Set up IBAN
     C     CFT004        IFEQ      'Y'
     C                   MOVEL     *BLANKS       WWWITH
 
     C     ACIBAN        IFNE      *BLANKS
     C                   CALL      'AOIBANR3'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM                    ACIBAN
     C                   PARM                    WWWITH
     C                   PARM      *BLANKS       WWNOBL
     C                   ENDIF
 
     C                   MOVEL     WWWITH        ##D(10)
 
     C                   ELSE
     C                   MOVEL     *BLANKS       ##D(10)
     C                   ENDIF
      *
      **  Set up Transaction Class
     C***                MOVEL     Z5TRCL        ##D(11)
      *
      **  Set up First/Subsequent/Last Indicator
     C                   MOVE      'FR'          ##FSLI
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   EXSR      SrPackDta
     C                   EXSR      POPGRS
      *................................................................
      *
     C     EXSHDR        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  DETHED                                         *
      * Function    :  Posting group set 1 (complex)                  *
      *                                                               *
      * Called by   :  INT_SC - Top level group set                   *
      * Calls       :  DETAIL - Posting group set 2 (complex)         *
      *****************************************************************
     C     DETHED        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SC-REP'      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     3             OCCUR     ##SRDT
      *
      **  Set up Path.
     C                   MOVEL     '\SC-REP'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   MOVEL     WPathStr      ##SPAT
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
     C                   EXSR      PSHGRS
      *
      **  Call subroutine for Posting Group Set 2 (complex)
     C                   EXSR      DETAIL
     C     3             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        WPathStr
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
      *
     C                   EXSR      POPGRS
      *................................................................
      *
     C     EXSPS1        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  FOOTER                                         *
      * Function    :  Footer (simple)                                *
      *                                                               *
      * Called by   :  INT_SC - Top level group set                   *
      * Calls       :  -                                              *
      *****************************************************************
     C     FOOTER        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SC-FTR'      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     4             OCCUR     ##SRDT
      *
      **  Set up Path.
     C                   MOVEL     '\SC-FTR'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   MOVEL     WPathStr      ##SPAT
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
     C                   EXSR      PSHGRS
      *
      *................................................................
      *
      **  Retrieve RDE information for RDE's in Group Set
     C                   MOVEL     'SC-FTR'      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      **  Set up total credit amount
     C                   MOVEL     Z5TOCI        ##D(1)
     C                   MOVE      A6NBDP        ##D(1)
      *
      **  Set up total debit amount
     C                   MOVEL     Z5TODI        ##D(2)
     C                   MOVE      A6NBDP        ##D(2)
      *
      **  Set up Net interest total
     C                   MOVEL     Z5NETI        ##D(3)
     C                   MOVE      A6NBDP        ##D(3)
      *
      ****Set*up*Extract*date                                                               AR849385
      ***Convert*Midas*run*date*into*'MMDDYY'*format                                        AR849385
     C**********         CALL      'ZDATE2'                                                 AR849385
     C**********         PARM      Z5RNDB        ZDAYNO                                     AR849385
     C**********         PARM      *BLANKS       ZDATFM                                     AR849385
     C**********         PARM                    ZDATE                                      AR849385
     C**********         PARM                    ZADATE                                     AR849385
     C**********         MOVEL     ZADATE        ##D(4)                                     AR849385
      ** Set up Extract date                                                                AR849385
     C                   MOVEL     Z5RNDB        ##D(4)                                     AR849385
      *
      **  Set up Reference type
     C                   MOVEL     Z5REFT        ##D(5)
      *
      **  Set up First/Subsequent/Last Indicator
     C                   MOVE      'FR'          ##FSLI
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   EXSR      SrPackDta
      *
     C                   EXSR      POPGRS
      *
      *................................................................
     C     EXSFTR        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  DETAIL                                         *
      * Function    :  Closing balance (simple)                       *
      *                                                               *
      * Called by   :  DETHED - Posting group set 1                   *
      * Calls       :  SRRRDE - Retrieve RDE Information              *
      *                SRPACKDTA - Pack/Unpack RDEs and data          *
      *                SRERR  - Database Error                        *
      *****************************************************************
     C     DETAIL        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SC-DET'      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     5             OCCUR     ##SRDT
      *
      **  Set up Path.
     C                   MOVEL     '\SC-DET'     ##PNAM
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
     C                   MOVEL     'SC-DET'      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      ****Set*up*Movement*date                                                              AR849385
      ***Convert*Midas*run*date*into*'MMDDYY'*format                                        AR849385
     C**********         CALL      'ZDATE2'                                                 AR849385
     C**********         PARM      Z6MOVD        ZDAYNO                                     AR849385
     C**********         PARM      *BLANKS       ZDATFM                                     AR849385
     C**********         PARM                    ZDATE                                      AR849385
     C**********         PARM                    ZADATE                                     AR849385
     C**********         MOVEL     ZADATE        ##D(1)                                     AR849385
      ** Set up Movement date                                                               AR849385
     C                   MOVEL     Z6MOVD        ##D(1)                                     AR849385
      *
      **  Set up Account balance
     C                   MOVEL     Z6ABAL        ##D(2)
     C                   MOVE      A6NBDP        ##D(2)
      *
      **  Set up number of days at balance
     C                   MOVEL     Z6DAYS        ##D(3)
      *
      **  Set up interest rate
     C                   MOVEL     Z6RATE        ##D(4)
      *
      **  Set up interest amount
     C                   MOVEL     Z6INTA        ##D(5)
     C                   MOVE      A6NBDP        ##D(5)
      *
      **  Set up the manual adjustment flag
     C                   MOVEL     Z6MANA        ##D(6)
      *
      **  Set up First/Subsequent/Last Indicator
     C                   MOVE      'FR'          ##FSLI
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   EXSR      SrPackDta
      *
     C                   EXSR      POPGRS
      *................................................................
      *
     C     EXSCLB        TAG
      *
      **  Unwind subroutine stack name
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
     C                   MOVEL     Z5BRCA        DRBRCA
     C                   MOVEL     Z5BRCA        DRORBR
 
     C     Z5REFT        IFEQ      'R'
     C                   MOVEL     'RE'          DRMODI
     C                   ELSE
     C     Z5REFT        IFEQ      'L'
     C                   MOVEL     'LE'          DRMODI
     C                   ELSE
     C                   MOVEL     'DL'          DRMODI
     C                   ENDIF
     C                   ENDIF
 
     C                   CLEAR                   DRMTRN
     C                   MOVEL     @DACCT        DRMACT
     C                   MOVE      Z5BRCA        DRMACT
     C                   MOVE      Z5CNUM        ##CUST
     C                   MOVEL     'INTSCL'      DRPTYP
     C                   MOVEL     'GENERAL'     DRPSTP
     C                   MOVEL     'N'           DRATRM
     C                   MOVE      'Y'           ##PROC
      *
     C                   CALL      'CG9010'
     C                   PARM                    ##RTCD
     C                   PARM      '*GEN'        ##MODE
     C                   PARM      W0CMT         ##CMT
     C                   PARM                    ##CUST
     C                   PARM                    ##UDCR
     C                   PARM                    ##ITMA
      *
     C     ##RTCD        IFEQ      *BLANK
     C     DRPTYP        CAT(P)    ':':0         COLON
     C     COLON         CAT(P)    DRPSTP:0      ##REFR
     C                   EXSR      WRAPRF
     C                   END
      *
      **  Blank return code implies generate correspondence.
      **  CGD1270 => no error, but suppress output for this transaction.
      *
      *
     C     ##RTCD        IFNE      *BLANK
      *
     C     ##RTCD        IFEQ      'CGD1270'
     C                   MOVE      'N'           ##PROC
     C                   ELSE
      *
     C                   MOVEL     'CG9010  '    W0FILE
     C                   MOVEL     ##RTCD        W0KEY                          ***************
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
     C     Z5CCY         LOOKUP    ##CY(C)                                99
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
     C                   MOVE      Z5CCY         ##CY(C)
     C     C             OCCUR     SDCURR
     C                   ENDIF
      *
      **  Retrieve the currency details.
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*KEY'        ##OPTN
     C                   PARM      Z5CCY         ##CCYP
     C     SDCURR        PARM      *BLANK        DSSDY
      *
      **  Database Error
     C     ##RTCD        IFNE      *BLANK
     C                   MOVEL     'SDCURRPD'    W0FILE
     C                   MOVEL     Z5CCY         W0KEY                          ***************
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
     C*****************************************************************
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
      *
     C     *LIKE         DEFINE    DERPTH        ##RPTH
     C     *LIKE         DEFINE    DENPTH        ##NPTH
     C     *LIKE         DEFINE    DEFSLI        ##FSLI
     C                   MOVE      *BLANKS       WPathStr
     C     *LIKE         DEFINE    DEPBIN        ##BNDC
     C     *LIKE         DEFINE    DEPBIN        S#PBIN
     C     *LIKE         DEFINE    DETBIN        S#TBIN
     C     *LIKE         DEFINE    DEOSEQ        ##OSEQ
     C     *LIKE         DEFINE    Z5TOCI        @CTOCI
     C     *LIKE         DEFINE    Z5TODI        @CTODI
     C     *LIKE         DEFINE    Z5NETI        @CNETI
      *
      **  Key list for full Account plus Posting Date
     C     ZZDLKY        KLIST
     C                   KFLD                    Z5BRCA
     C                   KFLD                    Z5CNUM
     C                   KFLD                    Z5CCY
     C                   KFLD                    Z5ACOD
     C                   KFLD                    Z5ACSQ
     C                   KFLD                    Z5REFN
     C                   KFLD                    Z5REFT
     C                   KFLD                    Z5INCD
     C                   KFLD                    Z5INFD
      *
      **  Key list for full Account
     C     ZZDSKY        KLIST
     C                   KFLD                    Z5BRCA
     C                   KFLD                    Z5CNUM
     C                   KFLD                    Z5CCY
     C                   KFLD                    Z5ACOD
     C                   KFLD                    Z5ACSQ
     C                   KFLD                    Z5REFN
     C                   KFLD                    Z5REFT
     C                   KFLD                    Z5INCD
      **  Key list for full Account plus Posting Date
     C     ZZMPKY        KLIST
     C                   KFLD                    Z5REFN
     C                   KFLD                    Z5REFT
     C                   KFLD                    MONTH
      *
     C     *DTAARA       DEFINE    RUNDAT        RUNDT
     C                   IN        RUNDT
      *
      *-----------------------------------------------
      **  Call access program for Bank details
      *-----------------------------------------------
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*FIRST  '    ##OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      **  Database error
     C     ##RTCD        IFNE      *BLANK
      *
     C                   MOVEL     'AOBANKR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     10            W0ERNB                         * DB ERROR 10 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      *------------------------------------------------------------
      ** Check for CCG015 (=Correspondence Manager)
      *------------------------------------------------------------
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
     C                   ENDIF
      *
      *------------------------------------------------------------
      ** Check for CFT004 (=IBAN)
      *------------------------------------------------------------
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
      *
     C     ##RTCD        IFNE      '*NRF    '
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   MOVEL     '*CALL   '    W0KEY
     C                   Z-ADD     20            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ENDIF
      *
      **  Copyright
     C                   MOVEA     ##CPY         ##BIS
      *
      *................................................................
      *
     C     EXINIT        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
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
      *
     C                   Z-ADD     *ZEROS        ##OSEQ
     C                   MOVEL     'N'           ##MAST
      *
      **  Initialise Binds.
     C                   Z-ADD     1             S#PBIN
     C                   Z-ADD     1             S#TBIN
     C                   Z-ADD     1             ##BNDC
      *
      ** Initialise XML increment
     C                   EXSR      INIXML
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
     C/COPY CGCPYSRC,SRERRPSSRL
     C/SPACE 5
     C/COPY CGCPYSRC,SRERRCLE
     C/SPACE 5
     C/COPY CGCPYSRC,CGNWEXILE
      ** Changed ##GRP arrays BBCNA1, BBCNA2, BBCNA3, BBCNA4, CUST_NAM, BBOJS_SRT to        AR797795
      **                   CUST_ADR1, CUST_ADR2, CUST_ADR3,CUST_ADR4,CUST_NAME, BBOJ        AR797795
      **                   respectively                                                     AR797795
      ** Changed ZINS_STDT, ZINS_ENDT, ZINS_PTDT, ZINS_DTDT to include Date Format          AR849385
**CTDATA ##GRP
CUSTE 0001 CUST_ADR1
CUSTE 0002 CUST_ADR2
CUSTE 0003 CUST_ADR3
CUSTE 0004 CUST_ADR4
CUSTE 0005 CUST_NAME
CUSTE 0006 CUSTOMER
CUSTE 0007 CUST_TOWN
CUSTE 0008 CUST_TEL
CUSTE 0009 CUST_FAX
CUSTE 0010 CUST_SWIFT
CUSTE 0011 CUST_BLZ
CUSTE 0012 CCHIPS_ID
CUSTE 0013 CCHIPS_ABA
CUSTE 0014 CCHAPS_SRT
CUSTE 0015 CBOJ
CUSTE 0016 CFEDWIRE
BRANCH0001 BRANCH
BRANCH0002 BRANCH NAM
CGBRCH0001 ZZSTAD
CGBRCH0002 ZZCTNB
CGBRCH0003 ZZCSID
CGBRCH0004 ZZBLCD
CGBRCH0005 ZZFAX
CGBRCH0006 BICNBR
CGBRCH0007 BCHIPS_ID
CGBRCH0008 BCHIPS_ABA
CGBRCH0009 BCHAPS_SRT
CGBRCH0010 BBOJ
CGBRCH0011 BFEDWIRE
SC-HDR0001 DEALNUMBER
SC-HDR0002 RETL_ACNO
SC-HDR0003 ACC_NAME
SC-HDR0004 ZINS_STDT  Date                                                                  AR849385
SC-HDR0005 ZINS_ENDT  Date                                                                  AR849385
SC-HDR0006 CURRENCY
SC-HDR0007 ZINS_MNTH
SC-HDR0008 ZINS_PTDT  Date                                                                  AR849385
SC-HDR0009 ZINS_TYPE
SC-HDR0010 IBAN
SC-HDR0011 TCLASS
SC-DET0001 ZINS_DTDT  Date                                                                  AR849385
SC-DET0002 ZINS_ACBL  AmountL
SC-DET0003 DAYS INT   AmountL
SC-DET0004 INT RATE   Rate  L8
SC-DET0005 ZINS_INT   AmountL
SC-DET0006 ZINS_MANA
SC-FTR0001 ZINS_TOCI  AmountL
SC-FTR0002 ZINS_TODI  AmountL
SC-FTR0003 ZINS_NETI  AmountL
SC-FTR0004 ZINS_PTDT  Date                                                                  AR849385
SC-FTR0005 ZINS_TYPE
**CTDATA ##CPY
(c) Finastra International Limited 2011
