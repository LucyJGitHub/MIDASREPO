     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CG NAHO Tax Advice - Extract')                   *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG7440 - CG NAHO Tax Advice - Extract                        *
      *                                                               *
      *  Function: This program extracts all the data required to     *
      *            construct the relevant statement.                  *
      *                                                               *
      *  Called By: CG7430 Via CGC7430                                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. CER070             Date 25Nov14               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CER069             Date 03Jul14               *
      *                 CDL094             Date 11Jun14               *
      *                 AR784693 *CREATE   Date 17Jun11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CER069 - German Tax Enhancement                              *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  AR784693 - No tax advice was generated for primary acccount  *
      *             defined as NAH                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Indicator usage                                              *
      *  ===============                                              *
      *                                                               *
      *  55   -    No Record found on LF/SDCSINL2                     *
      *  65   -    No Record found on LF/SDLTOFL1                     *
      *  66   -    READ PER DEAL/ACC.#                                *
      *  67   -    No record found ACCNTBJ0                           *
      *  69   -    No record found SDACTXL1                           *
      *  90   -    No record found CGCORRL4                           *
      *  99   -    LOOKUP indicator                                   *
      *                                                               *
      *  Structure of the extract                                     *
      *  ========================                                     *
      *  1 - ZFSM58 (top-level)                                       *
      *  .                                                            *
      *  .static data on customer level                               *
      *  .   2 - Z58HDR (simple)                                      *
      *  .   3 - CUST   (simple)                                      *
      *  .   4 - CGBRCH (simple)                                      *
      *  .                                                            *
      *  .   dynamic data on deal/account level                       *
      *  .   5 - POSDTA (complex, repeater)                           *
      *  .   .   6 - Z58POS (complex)                                 *
      *  .   .     7 - Z58DTA                                         *
      *  .   .     8 - Z58DT2                                         *
      *  .   .     9 - BRANCH                                         *
      *  .   .     10- CCYGS                                          *
      *  .   .     11- Z58DT3                                         *
      *  .   .     12- Z58DT4                                         *
      *  .   .     13- ACOF                                           *
      *****************************************************************
      *
      ** Midas SD Customer Income
      *
     FSDCSINLM  IF   E           K DISK
     F                                     INFSR(SRFILE)
      *
      ** Midas SD Customer Income by customer income generation date,
      ** Join Acct. No
      *
     FSDCSINLN  IF   E           K DISK
     F                                     RENAME(SDCSIND0:CSINDLN)
      *
      ** Midas DL Deals file
      *
     FDEALS     IF   E           K DISK
     F                                     IGNORE(DEALSDAF)
     F                                     IGNORE(DEALSDBF)
     F                                     IGNORE(DEALSDDF)
     F                                     IGNORE(DEALSDEF)
     F                                     IGNORE(DEALSDFF)
     F                                     IGNORE(DEALSDGF)
      *
      ** Midas SD Local Tax Office File
      *
     FSDLTOFL1  IF   E           K DISK
      *
      ** Correspondent File by Customer Number
      *
     FCGCORRL4  IF   E           K DISK
      *
      ** Midas SD Tax Basket Details
      *
     FSDTXBSL1  IF   E           K DISK
      *
      ** Midas SD Cust Details by Country of Tax
      *
     FSDACTXL1  IF   E           K DISK
      *
      ** Midas GL Account Details Join logic
      *
     FACCNTBJ0  IF   E           K DISK
      *
      ** Midas GL Accounts Master
      *
     FACCNT     IF   E           K DISK
      *
      ** Retail History file
      *
     FREHISDL   IF   E           K DISK
      *
     F/EJECT
      *
     D/COPY CGCPYSRC,CGPACKDLE
     D/COPY CGCPYSRC,SRERRDLE
      *
      ** Note: the below array defines the total number of RDE elements
      **       at compile-time declared below. Adjust the table length
      **       ONLY when newly added element would exceed the defined
      **       length!
      ** ##GRP = Group/RDE Number ##RDEA = RDE + Attributes
      *
     D ##GRP           S             10    DIM(70) CTDATA PERRCD(1)
     D ##RDEA          S             22    DIM(70) ALT(##GRP)
      *
      ** Array of Currencies accessed by program
      *
     D/COPY ZSRSRC,ZPOWERZ1IL
      *
      ** Array of Currencies accessed by program
      *
     D ##CY            S              3    DIM(100)
      *
     D                 DS
     D  ##GRPX                 1     10
     D  ##GRPS                 1      6
     D  ##RDEN                 7     10  0
      *
      ** Look-up string for RDE definition Array
      *
     D ##SDS           DS
     D  ##S1                   1   5632
      *
      ** Packed data string.
      *
     D                 DS
     D  ##W                    1     20
     D                                     DIM(20)
     D  ##WNUM                 1     20  0
      *
      ** Number Field
      *
     D                 DS
     D  ##ITMA                 1      8
     D  ##ITEM                 1      8  0
      *
      ** String that contains the concatenated path
      *
     D WPathStr        S            256A
      *
      ** Index for WMDsPath only
      *
     D WPx             S              3P 0
      *
      ** General purpose variables
      *
     D Wx1             S              3P 0
     D Wx2             S              3P 0
     D Wx3             S              3P 0
      *
      ** Parameter fields
      *
     D ##INIT          S              1
     D ##CMT           S              3
     D W0CMT           S              3
     D UFCOPD          S              1
     D POPTN           S              7
     D PRTCD           S              7
     D PACOF           S              2
     D ##RTCD          S              7
     D ##OPTN          S              7
     D ##SARD          S              6
     D UFMODE          S             10
     D W0SPAT          S             70
      *
      ** Work fields
      *
     D C               S              3  0
     D Q               S              5  0
     D #1              S              6  0
     D #2              S              6  0
     D #3              S              6  0
     D ##CCY           S              3
     D ##PNAM          S              7
     D ##IN50          S              1
     D W0CUST          S              6
     D UTCUST          S              6
     D ##KEY           S              6
     D ##KEY1          S             10
     D ##KYST          S              7
     D ##BRCD          S              3
     D UFBRCD          S              3
     D INCCY           S              1
     D W0TXBS          S              2
     D WTAXI           S              1
     D FSPTHU          S             15  0
     D FSPTUT          S             15  0
     D WCONV           S              1
     D ZRATEX          S             13  8
     D ZRATE1          S             13  8
     D ZRATE2          S             13  8
     D WSPRT           S             13  8
     D ZMDIX           S              1
     D ZMDI1           S              1
     D ZMDI2           S              1
     D ZCDPI           S              1  0
     D ZCDPO           S              1  0
     D COLON           S             11
     D W0PATH          S            256
     D ##RFMT          S              1
     D BASCDP          S              1  0
     D CEU013          S              1
     D CEU014          S              1
     D CCG015          S              1
     D CER054          S              1
     D ##BIS           S             80
     D KCNUM           S              6
      *
      ** General data structure to define fields that need to share data
      *
     D                 DS
     D WGrp10                  1     10
     D  WGrpNme                1      6
     D  WGrpSeq                7     10S 0
     D  WAr20                 21     40    DIM(20)
     D  WNum20                21     40  0
     D  WAr29                 51     79    DIM(29)
      *
     D ##UDCR        E DS                  EXTNAME(CGUDCRPD)
      *
      ** External DS for incomplete reference
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      *
      ** External DS for General Ledger details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** External DS for bank details
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      *
      ** External DS for branch details
      *
     D SDCURR        E DS                  OCCURS(101) EXTNAME(SDCURRPD)
      *
      ** External DS for currency details
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D  QDFAC        E                     EXTFLD(QQDFAC)
      *
      ** External DS for Customer details
      *
     D SDACCT        E DS                  EXTNAME(ACCNTAB)
      *
      ** Account Details
      *
     D SDACOF        E DS                  EXTNAME(SDACOFPD)
      *
      ** External DS for Account officer details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** First DS for access programs, short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Second DS for access programs, long data structure
      *
     D DSLDY         E DS                  EXTNAME(DSLDY)
      *
      ** Third DS for access programs, long data structure
      *
     D W0FMT         E DS                  EXTNAME(CGUDTAPD)
      *
      ** Record format of PF/CGUDTAPD for use as a parameter
      *
     D SDACUS        E DS                  EXTNAME(SDACUSPD)
      *
      **  External DS for Additinal Customer details
      *
     D ##SRDT          DS                  OCCURS(20)
      *
      ** DS to store subroutine specific data.
      ** - Previous Bind
      ** - This Bind
      ** - Saved Path
      *
     D  ##PBIN                 1      5P 0
     D  ##TBIN                 6     10P 0
     D  ##SPAT                11     80
      *
     D DSPARM        E DS                  EXTNAME(SDINPHPD)
      *
      ** External DS for parameter passed from CG7430
      *
     D SDACTX        E DS                  EXTNAME(SDACTXPD)                                  CER069
      *                                                                                       CER069
      ** External DS for Customer Details by Country of Tax                                   CER069
      *                                                                                       CER069
     D CPYR            DS
      *
      ** Data Structure for Compilation - Copyright Insertion
      *
     D  ##CPY                  1     80
     D                                     DIM(1) CTDATA PERRCD(1)
      *
     I/EJECT
      *
      ** Rename fields of SDCSINLF to avoid confusion with SDCSINL2
      *
     ICSINDLN
     I              TSRDNB                      XSRDNB
     I              TSEDAT                      XSEDAT
     I              TSTAXY                      XSTAXY
     I              TSTAXM                      XSTAXM
     I              TSCTRT                      XSCTRT
     I              TSBRCA                      XSBRCA
     I              TSJOIN                      XSJOIN
     I              TSCUST                      XSCUST
     I              TSNAHO                      XSNAHO
     I              TSINVP                      XSINVP
     I              TSSTAT                      XSSTAT
     I              TSFAMN                      XSFAMN
     I              TSFIRN                      XSFIRN
     I              TSSTRT                      XSSTRT
     I              TSZIPC                      XSZIPC
     I              TSCITY                      XSCITY
     I              TSRCTR                      XSRCTR
     I              TSRTIN                      XSRTIN
     I              TSDBTH                      XSDBTH
     I              TSTBTH                      XSTBTH
     I              TSCBTH                      XSCBTH
     I              TSIPDT                      XSIPDT
     I              TSTXBS                      XSTXBS
     I              TSWTAC                      XSWTAC
     I              TSOCCY                      XSOCCY
     I              TSOCSR                      XSOCSR
     I              TSOCMD                      XSOCMD
     I              TSOCDP                      XSOCDP
     I              TSSCCY                      XSSCCY
     I              TSSCSR                      XSSCSR
     I              TSSCMD                      XSSCMD
     I              TSSCDP                      XSSCDP
     I              TSTXCY                      XSTXCY
     I              TSTCSR                      XSTCSR
     I              TSTCMD                      XSTCMD
     I              TSTCDP                      XSTCDP
     I              TSXROS                      XSXROS
     I              TSXRST                      XSXRST
     I              TSOSMD                      XSOSMD
     I              TSSTMD                      XSSTMD
     I              TSMODI                      XSMODI
     I              TSINST                      XSINST
     I              TSTRTP                      XSTRTP
     I              TSTRST                      XSTRST
     I              TSDLLN                      XSDLLN
     I              TSACOD                      XSACOD
     I              TSACSQ                      XSACSQ
     I              TSIBAN                      XSIBAN
     I              TSETYP                      XSETYP
     I              TSSESN                      XSSESN
     I              TSSRPN                      XSSRPN
     I              TSISIN                      XSISIN
     I              TSPAMT                      XSPAMT
     I              TSGINT                      XSGINT
     I              TSTXRT                      XSTXRT
     I              TSTXSR                      XSTXSR
     I              TSNINT                      XSNINT
     I              TSPAMS                      XSPAMS
     I              TSGINS                      XSGINS
     I              TSTXSS                      XSTXSS
     I              TSNINS                      XSNINS
     I              TSPAMC                      XSPAMC
     I              TSGINC                      XSGINC
     I              TSTXSC                      XSTXSC
     I              TSNINC                      XSNINC
     I              TSPAMB                      XSPAMB
     I              TSGINB                      XSGINB
     I              TSTXSB                      XSTXSB
     I              TSNINB                      XSNINB
     I              TSINPR                      XSINPR
     I              TSTNLU                      XSTNLU
     I              TSSTXB                      XSSTXB
     I              TSSTAC                      XSSTAC
     I              TSSTRA                      XSSTRA
     I              TSSTDO                      XSSTDO
     I              TSSTDS                      XSSTDS
     I              TSSTDT                      XSSTDT
     I              TSSTDB                      XSSTDB
     I              TSPTHU                      XSPTHU
     I/EJECT
      *
      ** Rename fields of REHISDL to avoid confusion with ACCNTAB
      *
     IREHISPPF
     I              RECI                        RRECI
     I              ZZ001                       RZZ001
     I              BRCA                        RBRCA
     I              CNUM                        RCNUM
     I              CCY                         RCCY
     I              ACODQQ                      RACODQ
     I              ACSQ                        RACSQ
     I              HISD                        RHISD
     I              HISB                        RHISB
     I              MNBL                        RMNBL
     I              CHGAR                       RCHGAR
     I              TCHGAR                      RTCHGA
     I              CHGAN                       RCHGAN
     I              TCHGAN                      RTCHGN
     I              DMVT                        RDMVT
     I              DICT                        RDICT
     I              DRCB                        RDRCB
     I              DRIR                        RDRIR
     I              DRCD                        RDRCD
     I              DAID                        RDAID
     I              MADI                        RMADI
     I              TMADI                       RTMADI
     I              PDID                        RPDID
     I              DMINT                       RDMINT
     I              CMVT                        RCMVT
     I              CICT                        RCICT
     I              CRCB                        RCRCB
     I              CRIR                        RCRIR
     I              CRCD                        RCRCD
     I              CAID                        RCAID
     I              MACI                        RMACI
     I              TMACI                       RTMACI
     I              PCID                        RPCID
     I              CMINT                       RCMINT
     I              DICI                        RDICI
     I              CICI                        RCICI
     I              DRCI                        RDRCI
     I              CRCI                        RCRCI
     I              VDTC                        RVDTC
     I              ADTY                        RADTY
     I              ALTI                        RALTI
     I              MNBCP                       RMNBCP
     I              LGID                        RLGID
     I              VALL                        RVALL
     I              LINK                        RLINK
     I              ZZ008                       RZZ008
     I              AODR                        RAODR
     I              ODRL                        RODRL
     I              ODLI                        RODLI
     I              ODIA                        RODIA
     I              ACOD                        RACOD
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  Index to subroutines                                         *
      *  --------------------                                         *
      *                                                               *
      *  ZFSM58 - Main processing - top level group set               *
      *  Z58HDR - Header (simple)                                     *
      *  BRANCH - Branch Details (Simple)                             *
      *  CUST   - Customer Details (Simple)                           *
      *  CGBRCH - Additional Branch information                       *
      *  CCYGS  - Currency Details (Simple)                           *
      *  Z58POS - Posting group set (complex)                         *
      *  Z58DTA - Posting group set (simple)                          *
      *  Z58DT2 - Posting group set (simple) more RDE's               *
      *  Z58DT3 - Posting group set (simple) more RDE's               *
      *  Z58DT4 - RDES FOR EURO                                       *
      *  SRGENR - Generate reference record                           *
      *  SRPACKDTA - Accumulate RDEs & associated data for Output     *
      *  SRFMTDTA - Reformat RDE data                                 *
      *  SRRRDE - Retrieve RDE information for RDE in group set       *
      *  SRDCDT - Determine Currency Details                          *
      *  SRINIT - Initial processing - On First Call                  *
      *  SRINZ  - Initialise Fields on Each Invocation                *
      *  *PSSR  - Exception/Error Handling                            *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  Process     -  MAINLINE                                      *
      *  Function    -  Mainline processing                           *
      *                                                               *
      *  Called by   -  None                                          *
      *  Calls       -  SRINIT - Initial Processing - On First Call   *
      *                 SRINZ  - Initialise Fields on Each Invocation *
      *                 G#STMT - Main Processing - Top Level Group Set*
      *****************************************************************
      *
      ** Parameter list for current program invocation.
      *
     C     *ENTRY        PLIST
     C                   PARM                    W0RTN
     C                   PARM                    W0CMT
     C                   PARM                    UFCOPD
     C                   PARM                    DSPARM
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'MAIN'        @STK(Q)
      *
      ** Initial processing - Once Only
      *
     C     ##INIT        IFEQ      *BLANKS
     C                   EXSR      SRINIT
     C                   MOVE      'Y'           ##INIT
     C                   ENDIF
      *
      ** Initialisation processing
      *
     C                   EXSR      SRINZ
      *
      ** Main processing - top level group set
      *
     C                   EXSR      ZFSM58
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      ** Terminate program
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  Subroutine  -  ZFSM58                                        *
      *  Function    -  Main processing - top level group set         *
      *                                                               *
      *  Called by   -  Mainline                                      *
      *  Calls       -  SRGENR - Generate reference record            *
      *                 Z58HDR - Header (simple)                      *
      *                 CUST   - Customer Details (simple)            *
      *                 CGBRCH - Additional branch information        *
      *                 Z58POS - Posting group set (complex)          *
      *                 SRERR  - Database Error                       *
      *****************************************************************
     C     ZFSM58        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'ZFSM58'      @STK(Q)
      *
      ** Retrieve subroutine specific data.
      *
     C     1             OCCUR     ##SRDT
      *
      ** Set up Path.
      *
     C                   MOVEL     '\ZFSM58'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   MOVEL     WPathStr      ##SPAT
      *
      ** Set up Binds from passed in values.
      *
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
      ** Position the Postings file before the first posting for this
      ** Customer
      *
     C     UFGLKY        SETLL     SDCSINLM
     C     UFGLKY        READE     SDCSINLM                               55
      *
     C                   MOVEL     'N'           ##IN50
     C     *IN55         IFEQ      *ON
     C                   MOVEL     'Y'           ##IN50
     C                   ENDIF
      *
      ** If there is a posting, extract data
      *
     C     *IN55         IFEQ      *OFF
      *
      ** Generate reference number by writing to PF/CGUDCRPD
      ** If the statement is to be produced, then produce it
      *
     C                   EXSR      SRGENR
     C     UFCOPD        CABEQ     'N'           EXF058
      *
     C                   EXSR      PSHGRS
      *
      ** Header (simple)
      *
     C                   EXSR      Z58HDR
     C     1             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        WPathStr
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
      *
      ** Customer Details (simple)
      *
     C                   EXSR      CUST
     C     1             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        WPathStr
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
      *
      ** Internal customer address information (simple)
      *
     C                   EXSR      CGBRCH
     C     1             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        WPathStr
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
      *
     C     *IN55         DOWEQ     *OFF
      *
      ** Posting Group Set (complex)
      *
     C                   EXSR      POSDTA
     C     1             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        WPathStr
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
      *
      ** Process next record for that customer/date
      *
     C     UFGLKY        READE     SDCSINLM                               55
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** Only call if records read
      *
     C     ##IN50        IFEQ      'N'
     C                   EXSR      POPGRS
     C                   ENDIF
      *
     C     EXF058        TAG
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  Subroutine  -  Z58HDR                                        *
      *  Function    -  Header (simple)                               *
      *                  - Extract RDEs for statement header          *
      *                                                               *
      *  Called by   -  ZFSM58 - Top level group set                  *
      *  Calls       -  SRRRDE - Retrieve RDE Information             *
      *                 SrPackDta - Format Extract Data               *
      *****************************************************************
     C     Z58HDR        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'Z58HDR'      @STK(Q)
      *
      ** Retrieve subroutine specific data.
      *
     C     2             OCCUR     ##SRDT
      *
      ** Set up Path.
      *
     C                   MOVEL     '\Z58HDR'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   MOVEL     WPathStr      ##SPAT
      *
      ** Set up Binds from passed in values.
      *
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
     C                   EXSR      PSHGRS
      *
      ** Retrieve RDE information for RDEs in group set
      *
     C                   MOVEL     'Z58HDR'      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      ** Last Generation Date
      *
     C     TILSSD        IFNE      *ZEROS
     C                   MOVEL     TILSSD        ##D(1)
     C                   ELSE
     C                   MOVEL     BJRDNB        ##D(1)
     C                   ENDIF
      *
      ** Generation Date
      *
     C                   MOVEL     BJRDNB        ##D(2)
      *
      ** Statement Number
      *
     C                   MOVEL     TIPGNO        ##D(3)
      *
      ** Utilisation Up to Threshold
      *
     C                   MOVEL     TIUTTH        ##D(4)
     C                   MOVEL     BJLCCY        ##CCY
     C                   EXSR      SRDCDT
     C                   MOVE      A6NBDP        ##D(4)
      *
      ** Total Utilisation
      *
     C                   MOVEL     TITOUT        ##D(5)
     C                   MOVE      A6NBDP        ##D(5)
      *
      ** Current threshold
      *
     C                   MOVEL     TICUTH        ##D(6)
      *
      ** Accumulate RDE's and associated data and output to
      ** PF/CGUDTAPD.
      *
     C                   EXSR      SrPackDta
      *
     C                   EXSR      POPGRS
      *
     C     EX1HDR        TAG
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      *  Subroutine  _  POSDTA                                        *
      *  Function    _  Repeating structure for Details               *
      *                                                               *
      *  Called by   _  ZFSM58 - Top level group set                  *
      *  Calls       _  Z58POS - extract details                      *
      *****************************************************************
     C     POSDTA        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'POSDTA'      @STK(Q)
      *
      ** Retrieve subroutine specific data.
      *
     C     10            OCCUR     ##SRDT
      *
      ** Set up Path.
      *
     C                   MOVEL     '\POSDTA'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   MOVEL     WPathStr      ##SPAT
      *
      ** Set up Binds from passed in values.
      *
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
     C                   EXSR      PSHGRS
      *
     C                   SETOFF                                       66
      *
      ** Key for reading Retail History file
      *
     C     KYREHI        KLIST
     C                   KFLD                    TSBRCA
     C                   KFLD                    KCNUM
     C                   KFLD                    TSOCCY
     C                   KFLD                    TSACOD
     C                   KFLD                    TSACSQ
     C                   KFLD                    TSEDAT
      *
      ** Key for reading per deal/account
      *
     C                   MOVEL     TSJOIN        W0CUST
     C     ACNTKY        KLIST
     C                   KFLD                    W0CUST
     C                   KFLD                    TSOCCY
     C                   KFLD                    TSACOD
     C                   KFLD                    TSACSQ
     C                   KFLD                    TSBRCA
      *
      ** For each Deal/Account
      *
     C     KEY2          KLIST
     C                   KFLD                    BJRDNB
     C                   KFLD                    TSJOIN
     C                   KFLD                    TSDLLN
     C                   KFLD                    TSBRCA
     C                   KFLD                    TSOCCY
     C                   KFLD                    TSACOD
     C                   KFLD                    TSACSQ
      *
      ** Read per deal/account no
      *
     C     KEY2          SETLL     CSINDLN
     C     KEY2          READE     CSINDLN                                66
      *
     C     *IN66         DOWEQ     *OFF
      *
     C     TSJOIN        IFEQ      XSJOIN
      *
     C                   EXSR      Z58POS
      *
     C     10            OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        WPathStr
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
      *
     C                   ENDIF
      *
     C     KEY2          READE     CSINDLN                                66
      *
     C                   ENDDO
      *
     C     EXPOS         TAG
      *
      ** Unwind subroutine stack name
      *
     C                   EXSR      POPGRS
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  Subroutine  -  CUST                                          *
      *  Function    -  Customer Details (Simple)                     *
      *                 - Obtain Customer Details                     *
      *                                                               *
      *  Called by   -  ZFSM58 - Top level group set                  *
      *  Calls       -  SRRRDE - Retrieve RDE Information             *
      *                 SrPackDta - Format Extract Data               *
      *                 SRERR  - Database Error                       *
      *                 AOCUSTR0 - Obtain Customer Details            *
      *****************************************************************
     C     CUST          BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'CUST  '      @STK(Q)
      *
      ** Retrieve subroutine specific data.
      *
     C     4             OCCUR     ##SRDT
      *
      ** Set up Path.
      *
     C                   MOVEL     '\CUST  '     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   MOVEL     WPathStr      ##SPAT
      *
      ** Set up Binds from passed in values.
      *
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
     C                   EXSR      PSHGRS
      *
      ** Retrieve RDE information for RDE's in Group Set
      *
     C                   MOVEL     'CUST  '      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      ** Access Customer Details if the Customer has changed.
      ** (LF/SDCUSTL1)
      *
     C                   MOVE      TSJOIN        UTCUST
     C     UTCUST        IFNE      BBCUST
     C                   MOVE      *BLANKS       ##KEY1
     C                   MOVE      TSJOIN        ##KEY1
     C                   CALL      'AOCUSTR1'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*KEY   '     ##OPTN
     C                   PARM                    ##KEY1
     C                   PARM      *BLANKS       ##KYST
     C     SDCUST        PARM      SDCUST        DSLDY
      *
      ** If not found, Database Error.
      *
     C     BBCLST        IFNE      'Y'
     C     BBDTDL        ANDEQ     0
     C     ##RTCD        IFNE      *BLANKS
     C                   MOVEL     'SDCUSTPD'    W0FILE
     C                   MOVEL     TSJOIN        W0KEY
     C                   Z-ADD     4             W0ERNB
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Set up Customer Number
      *
     C                   MOVEL     BBCUST        ##D(1)
      *
      ** Set up Customer Name
      *
     C                   MOVEL     BBCRNM        ##D(2)
      *
      ** Set up Customer Address Line 1
      *
     C                   MOVEL     BBCNA1        ##D(3)
      *
      ** Set up Customer Address Line 2
      *
     C                   MOVEL     BBCNA2        ##D(4)
      *
      ** Set up Customer Address Line 3
      *
     C                   MOVEL     BBCNA3        ##D(5)
      *
      ** Set up Customer Address Line 4
      *
     C                   MOVEL     BBCNA4        ##D(6)
      *
      ** Set up Customer Town
      *
     C                   MOVEL     BBCRTN        ##D(7)
      *
      ** Set up Non-Account Holder flag
      *
     C                   MOVEL     'Y'           ##D(8)
      *
      ** Accumulate RDE's and associated data and output to
      ** PF/CGUDTAPD.
      *
     C                   EXSR      SrPackDta
      *
     C                   EXSR      POPGRS
      *
     C     EXCUST        TAG
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  Subroutine  -  CGBRCH                                        *
      *  Function    -  Extract additinal branch information          *
      *                                                               *
      *  Called by   -  ZFSM58                                        *
      *  Calls       -                                                *
      *****************************************************************
     C     CGBRCH        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'CGBRCH'      @STK(Q)
      *
      ** Retrieve subroutine specific data.
      *
     C     1             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        WPathStr
      *
      ** Set up Path.
      *
     C                   MOVEL     '\CGBRCH'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
      *
      ** Access branch file to retrieve Branch internal customer
      ** of originating branch of deal
      *
     C                   CALL      'AOBRCHR0'
     C                   PARM      '*MSG    '    PRTCD
     C                   PARM      '*KEY    '    POPTN
     C                   PARM      TSBRCA        ##BRCD
     C     SDBRCH        PARM      SDBRCH        DSFDY
      *
      ** Database error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBRCHPD'    W0FILE
     C                   MOVEL     TSBRCA        W0KEY
     C                   Z-ADD     28            W0ERNB
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      ** Get Additional Customer Details for Branch Internal Customer
      *
     C                   CALL      'AOACUSR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*KEY   '     ##OPTN
     C                   PARM      A8BICN        ##KEY
     C     SDACUS        PARM      SDACUS        DSSDY
      *
      ** Database error
      *
     C     ##RTCD        IFNE      *BLANKS
     C                   MOVEL     'SDACUSPD'    W0FILE
     C                   MOVEL     A8BICN        W0KEY
     C                   Z-ADD     31            W0ERNB
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      ** Get Correspondent Details for Branch Internal Custome
      *
     C     A8BICN        CHAIN     CGCORRL4                           90
      *
      ** If Correspondent not found
      *
     C     *IN90         IFEQ      '1'
      *
      ** Database error
      *
     C                   MOVEL     'CGCORRPD'    W0FILE
     C                   MOVEL     A8BICN        W0KEY
     C                   Z-ADD     30            W0ERNB
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      ** Reset arrays
      *
     C                   MOVEL     *BLANKS       ##R
     C                   MOVEL     *BLANKS       ##D
     C                   MOVEL     *BLANKS       ##S
      *
     C                   EXSR      PSHGRS
      *
      ** Telex Number
      *
     C     BBSTAD        IFNE      *BLANKS
     C                   MOVEL     BBSTAD        ##D(1)
     C                   ELSE
     C                   MOVEL     E5TXNB        ##D(1)
     C                   ENDIF
     C                   RESET                   ##RDEF
     C                   MOVEL     ' ZZSTAD'     ##RDE
     C                   MOVEL     ##RDEF        ##R(1)
      *
      ** Telephone Number
      *
     C                   MOVEL     BBCTNB        ##D(2)
     C                   RESET                   ##RDEF
     C                   MOVEL     ' ZZCTNB'     ##RDE
     C                   MOVEL     ##RDEF        ##R(2)
      *
      ** SWIFT Code
      *
     C                   MOVEL     BBCSID        ##D(3)
     C                   RESET                   ##RDEF
     C                   MOVEL     ' ZZCSID'     ##RDE
     C                   MOVEL     ##RDEF        ##R(3)
      *
      ** German Bankleitzahl
      *
     C                   MOVEL     BBBLCD        ##D(4)
     C                   RESET                   ##RDEF
     C                   MOVEL     ' ZZBLCD'     ##RDE
     C                   MOVEL     ##RDEF        ##R(4)
      *
      ** Fax Number
      *
     C                   MOVEL     CDFAX         ##D(5)
     C                   RESET                   ##RDEF
     C                   MOVEL     ' ZZFAX'      ##RDE
     C                   MOVEL     ##RDEF        ##R(5)
      *
      ** Branch Internal Customer Number
      *
     C                   MOVEL     A8BICN        ##D(6)
     C                   RESET                   ##RDEF
     C                   MOVEL     ' BICNBR'     ##RDE
     C                   MOVEL     ##RDEF        ##R(6)
      *
      ** Chips Id (Branch-Internal Customer):
      *
     C                   MOVEL     BBCHID        ##D(7)
     C                   RESET                   ##RDEF
     C                   MOVEL     ' BCHIPS_'    ##RDE
     C                   MOVE      'ID  '        ##RDE
     C                   MOVEL     ##RDEF        ##R(7)
      *
      ** Chips ABA (Branch-Internal Customer)
      *
     C     BBCABA        IFNE      0
     C                   MOVEL     BBCABA        ##D(8)
     C                   ELSE
     C                   MOVEL     BBCABA        ##D(8)
     C                   ENDIF
     C                   RESET                   ##RDEF
     C                   MOVEL     ' BCHIPS_'    ##RDE
     C                   MOVE      'ABA '        ##RDE
     C                   MOVEL     ##RDEF        ##R(8)
      *
      ** Chaps sort code (Branch-Internal Customer)
      *
     C                   MOVEL     BBCHSC        ##D(9)
     C                   RESET                   ##RDEF
     C                   MOVEL     ' BCHAPS_'    ##RDE
     C                   MOVE      'SRT '        ##RDE
     C                   MOVEL     ##RDEF        ##R(9)
      *
      ** BOJ (Branch-Internal Customer)
      *
     C                   MOVEL     BBBFIC        ##D(10)
     C                   RESET                   ##RDEF
     C                   MOVEL     ' BBOJ'       ##RDE
     C                   MOVEL     ##RDEF        ##R(10)
      *
      ** Fedwire (Branch-Internal Customer)
      *
     C                   MOVEL     BBFWCD        ##D(11)
     C                   RESET                   ##RDEF
     C                   MOVEL     ' BFEDWIR'    ##RDE
     C                   MOVE      'E   '        ##RDE
     C                   MOVEL     ##RDEF        ##R(11)
      *
      ** Accumulate RDE's and associated data and output to
      ** PF/CGUDTAPD.
      *
     C                   EXSR      SrPackDta
      *
     C                   EXSR      POPGRS
      *
     C     EXBRC         TAG
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  Subroutine  -  BRANCH                                        *
      *  Function    -  Branch Details (Simple)                       *
      *                 - Obtain Branch Details                       *
      *                                                               *
      *  Called by   -  Z58POS - Posting group set                    *
      *  Calls       -  SRRRDE - Retrieve RDE Information             *
      *                 SRPACKDTA - Format Extract Data               *
      *                 AOBRCHR0 - Obtain Branch Details              *
      *****************************************************************
     C     BRANCH        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'BRANCH'      @STK(Q)
      *
      ** Retrieve subroutine specific data.
      *
     C     3             OCCUR     ##SRDT
      *
      ** Set up Path.
      *
     C                   MOVEL     '\BRANCH'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   MOVEL     WPathStr      ##SPAT
      *
      ** Set up Binds from passed in values.
      *
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
     C                   EXSR      PSHGRS
      *
      ** Retrieve RDE information for RDE's in Group Set
      *
     C                   MOVEL     'BRANCH'      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      ** Get Branch Details if the Branch has changed
      *
     C     TSBRCA        IFNE      UFBRCD
     C                   CALL      'AOBRCHR0'
     C                   PARM      '*MSG    '    ##RTCD
     C                   PARM      '*KEY    '    ##OPTN
     C                   PARM      TSBRCA        UFBRCD
     C     SDBRCH        PARM      SDBRCH        DSFDY
      *
      ** Database Error
      *
     C     ##RTCD        IFNE      *BLANKS
     C                   MOVEL     'SDBRCHPD'    W0FILE
     C                   MOVEL     TSBRCA        W0KEY
     C                   Z-ADD     15            W0ERNB
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** Get Branch Extension file details
      *
     C     A8BRCD        CHAIN     SDLTOFL1                           65
      *
      ** If Branch not found
      *
     C     *IN65         IFEQ      '1'
      *
      ** Database error
      *
     C                   MOVEL     'SDLTOFL1'    W0FILE
     C                   MOVEL     A8BRCD        W0KEY
     C                   Z-ADD     16            W0ERNB
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ENDIF
      *
      ** Set up Branch Code
      *
     C                   MOVEL     A8BRCD        ##D(1)
      *
      ** Set up Branch Name
      *
     C                   MOVEL     A8BRNM        ##D(2)
      *
      ** Accumulate RDE's and associated data and output to
      ** PF/CGUDTAPD.
      *
     C                   EXSR      SrPackDta
      *
     C                   EXSR      POPGRS
      *
     C     EXBRCH        TAG
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  Subroutine  -  Z58POS                                        *
      *  Function    -  Posting group set (complex)                   *
      *                                                               *
      *  Called by   -  ZFSM58 - Top level group set                  *
      *  Calls       -  Z58DTA - Posting group set (simple)           *
      *                 Z58DT2 - Posting group set (simple) more RDE's*
      *                 Z58DT3 - Posting group set (simple) more RDE's*
      *                 BRANCH - Branch Details (simple)              *
      *                 CCYGS  - Currency Details (simple)            *
      *****************************************************************
     C     Z58POS        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'Z58POS'      @STK(Q)
      *
      ** Retrieve subroutine specific data.
      *
     C     5             OCCUR     ##SRDT
      *
      ** Set up Path.
      *
     C                   MOVEL     '\Z58POS'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   MOVEL     WPathStr      ##SPAT
      *
      ** Set up Binds from passed in values.
      *
     C                   Z-ADD     S#TBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
     C                   EXSR      PSHGRS
      *
      ** For each posting...
      *
     C     XSDLLN        IFNE      0
     C     XSBRCA        ORNE      *BLANKS
     C     XSJOIN        ANDNE     *BLANKS
     C     XSOCCY        ANDNE     *BLANKS
     C     XSACOD        ANDNE     *ZERO
     C     XSACSQ        ANDNE     *ZERO
      *
      ** Increment Bind Levels for Complex Set only
      *
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   ADD       1             ##BNDC
     C                   Z-ADD     ##BNDC        S#TBIN
     C                   Z-ADD     ##BNDC        ##TBIN
      *
      ** Call subroutine for Posting Group Set  (simple)
      *
     C                   EXSR      Z58DTA
     C     5             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        WPathStr
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
      *
      ** Call subroutine for Posting Group Set (simple) more RDE's
      *
     C                   EXSR      Z58DT2
     C     5             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        WPathStr
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
      *
      ** Branch Details (simple)
      *
     C                   EXSR      BRANCH
     C     5             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        WPathStr
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
      *
      ** Call subroutine for Currency details (simple)
      *
     C                   EXSR      CCYGS
     C     5             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        WPathStr
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
      *
      ** Call subroutine for Posting Group Set (simple) more RDE's
      *
     C                   EXSR      Z58DT3
     C     5             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        WPathStr
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
      *
      ** Call subroutine for Euro amounts Groupset (simple) more RDE's
      *
     C                   EXSR      Z58DT4
     C     5             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        WPathStr
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
      *
      ** Call subroutine for Account Officer (simple)
      *
     C                   EXSR      ACOF
     C     5             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        WPathStr
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
      *
     C                   ENDIF
      *
     C                   EXSR      POPGRS
      *
     C     EXSPS1        TAG
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  Subroutine  -  CCYGS                                         *
      *  Function    -  Currency Details (Simple)                     *
      *                                                               *
      *  Called by   -  Z58POS - Posting group set (complex)          *
      *  Calls       -  SRRRDE - Retrieve RDE Information             *
      *                 SRDCDT - Determine Currency Details           *
      *                 SRPACKDTA - Format Extract Data               *
      *                 SRERR  - Database Error                       *
      *****************************************************************
     C     CCYGS         BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'CCYGS '      @STK(Q)
      *
      ** Retrieve subroutine specific data.
      *
     C     7             OCCUR     ##SRDT
      *
      ** Set up Path.
      *
     C                   MOVEL     '\CCY   '     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   MOVEL     WPathStr      ##SPAT
      *
      ** Set up Binds from passed in values.
      *
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
     C                   EXSR      PSHGRS
      *
      ** Retrieve RDE information for RDE's in Group Set
      *
     C                   MOVEL     'CCY   '      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      ** Determine Currency Details
      *
     C                   MOVE      *BLANKS       INCCY
      *
      ** Set up Currency Code
      ** Retrieve currency details for TSOCCY
      *
     C                   MOVEL     TSOCCY        ##CCY
     C                   EXSR      SRDCDT
      *
      ** No error exit, since currency has been validated before
      ** Euro conversion necessary
      *
     C     A6INCY        IFEQ      'Y'
     C                   MOVE      'Y'           INCCY
     C                   ENDIF
      *
      ** Currency Code
      *
     C                   MOVEL     A6CYCD        ##D(1)
      *
      ** Set up Currency Description
      *
     C                   MOVEL     A6CYNM        ##D(2)
      *
      ** Precious Metal Indicator
      *
     C                   MOVEL     A6PMRT        ##D(3)
      *
      ** Accumulate RDE's and associated data and output to
      ** PF/CGUDTAPD.
      *
     C                   EXSR      SrPackDta
      *
     C                   EXSR      POPGRS
      *
     C     EXCCY         TAG
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  Subroutine  -  Z58DT3                                        *
      *  Function    -  Posting Group Set (simple) more RDE's         *
      *                                                               *
      *  Called by   -  Z58POS - Posting group set (complex)          *
      *  Calls       -  SRRRDE - Retrieve RDE Information             *
      *                 SRPACKDTA - Format Extract Data               *
      *                 SRERR  - Database Error                       *
      *****************************************************************
     C     Z58DT3        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'Z58DT3'      @STK(Q)
      *
      ** Retrieve subroutine specific data.
      *
     C     7             OCCUR     ##SRDT
      *
      ** Set up Path.
      *
     C                   MOVEL     '\Z58DT3'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   MOVEL     WPathStr      ##SPAT
      *
      ** Set up Binds from passed in values.
      *
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
     C                   EXSR      PSHGRS
      *
      ** Retrieve RDE information for RDE's in Group Set
      *
     C                   MOVEL     'Z58DT3'      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      ** Prev. Utilisat. Up to Thresh.
      *
      *
     C     TSBRCA        CHAIN     SDLTOFL1                           65
     C     *IN65         IFEQ      *OFF
      *
      ** Tax Office Registration
      *
     C                   MOVEL     LTOFRN        ##D(1)
      *
      ** Tax Office Name
      *
     C                   MOVEL     LTOFNM        ##D(2)
      *
     C                   ENDIF
      *
      ** Accumulate RDE's and associated data and output to
      ** PF/CGUDTAPD.
      *
     C                   EXSR      SrPackDta
      *
     C                   EXSR      POPGRS
      *
     C     EXSDA3        TAG
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  Subroutine  -  Z58DT4                                        *
      *  Function    -  Amounts in Euro                               *
      *                                                               *
      *  Called by   -  Z58POS - Posting group set (complex)          *
      *  Calls       -  SRRRDE - Retrieve RDE Information             *
      *                 SRPACKDTA - Format Extract Data               *
      *                 SRERR  - Database Error                       *
      *****************************************************************
     C     Z58DT4        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'Z58DT4'      @STK(Q)
      *
      ** Retrieve subroutine specific data.
      *
     C     7             OCCUR     ##SRDT
      *
      ** Set up Path.
      *
     C                   MOVEL     '\Z58DT4'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   MOVEL     WPathStr      ##SPAT
      *
      ** Set up Binds from passed in values.
      *
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
     C                   EXSR      PSHGRS
      *
      ** Retrieve RDE information for RDE's in Group Set
      *
     C                   MOVEL     'Z58DT4'      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      ** Gross interest in Tax ccy
      *
     C     TSOCCY        IFEQ      TSTXCY
     C                   MOVEL     TSGINC        ##D(1)
     C                   MOVE      A6NBDP        ##D(1)
      *
     C                   ELSE
      *
     C                   MOVEL     TSGINC        ##D(1)
     C                   MOVEL     TSTXCY        ##CCY
     C                   EXSR      SRDCDT
     C                   MOVE      A6NBDP        ##D(1)
     C                   ENDIF
      *
      ** Main tax in tax ccy
      *
     C     TSOCCY        IFEQ      TSTXCY
     C                   MOVEL     TSTXSC        ##D(2)
     C                   MOVE      A6NBDP        ##D(2)
      *
     C                   ELSE
      *
     C                   MOVEL     TSTXSC        ##D(2)
     C                   MOVEL     TSTXCY        ##CCY
     C                   EXSR      SRDCDT
     C                   MOVE      A6NBDP        ##D(2)
     C                   ENDIF
      *
      ** Secondary tax in tax ccy
      *
     C     TSOCCY        IFEQ      TSTXCY
     C                   MOVEL     TSSTDT        ##D(3)
      *
     C     CER054        IFEQ      'Y'
      *
      *  Third tax in tax ccy
      *
     C                   MOVEL     TSTTDT        ##D(5)
      *
     C                   ENDIF
     C                   MOVE      A6NBDP        ##D(3)
      *
     C                   ELSE
      *
     C                   MOVEL     TSSTDT        ##D(3)
     C                   MOVEL     TSTXCY        ##CCY
     C                   EXSR      SRDCDT
     C                   MOVE      A6NBDP        ##D(3)
     C                   ENDIF
      *
      ** Net Interest in tax ccy
      *
     C     TSOCCY        IFEQ      TSTXCY
     C                   MOVEL     TSNINC        ##D(4)
     C                   MOVE      A6NBDP        ##D(4)
      *
     C                   ELSE
      *
     C                   MOVEL     TSNINC        ##D(4)
     C                   MOVEL     TSTXCY        ##CCY
     C                   EXSR      SRDCDT
     C                   MOVE      A6NBDP        ##D(4)
     C                   ENDIF
      *
      ** Accumulate RDE's and associated data and output to
      ** PF/CGUDTAPD.
      *
     C                   EXSR      SrPackDta
      *
     C                   EXSR      POPGRS
      *
     C     EXSDA4        TAG
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  Subroutine  -  ACOF                                          *
      *  Function    -  Account Officer Details                       *
      *                                                               *
      *  Called by   -  Z58POS - Common Group Set Routine             *
      *  Calls       -  SRRRDE                                        *
      *                 SRPACKDTA - Format Extract Data               *
      *                 SRERR  - Database Error                       *
      *****************************************************************
     C     ACOF          BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'ACOF  '      @STK(Q)
      *
      ** Retrieve subroutine specific data.
      *
     C     9             OCCUR     ##SRDT
      *
      ** Set up Path.
      *
     C                   MOVEL     '\ACOF  '     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   MOVEL     WPathStr      ##SPAT
      *
      ** Set up Binds from passed in values.
      *
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
      ** Retrieve RDE information for RDE's in Group Set
      *
     C                   MOVEL     'ACOF  '      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      ** Do not process if Account Officer blank.
      *
     C     BBACOC        IFEQ      *BLANKS
     C                   GOTO      EXACOF
     C                   ENDIF
      *
     C                   EXSR      PSHGRS
      *
      ** Access Account Officer Details
      *
     C                   CALL      'AOACOFR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      BBACOC        PACOF
     C     SDACOF        PARM      SDACOF        DSSDY
      *
      ** Account Officer details not found
      *
     C     PRTCD         IFNE      *BLANKS
     C                   GOTO      EXACOF
     C                   END
      *
      ** Account Officer Code
      *
     C                   MOVEL     AZACOC        ##D(1)
      *
      ** Account Officer Dept
      *
     C                   MOVEL     AZDPCD        ##D(2)
      *
      ** Account Officer Name
      *
     C                   MOVEL     AZACON        ##D(3)
      *
      ** Account Officer Telephone Number
      *
     C                   MOVEL     AZAPHN        ##D(4)
      *
      ** Account Officer Telephone Extension
      *
     C                   MOVEL     AZAEXT        ##D(5)
      *
      ** Accumulate RDE's and associated data and output to
      ** PF/CGUDTAPD.
      *
     C                   EXSR      SrPackDta
      *
     C                   EXSR      POPGRS
      *
      ** Unwind subroutine stack name
      *
     C     EXACOF        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  Subroutine  -  Z58DTA                                        *
      *  Function    -  Posting Group Set (simple)                    *
      *                                                               *
      *  Called by   -  Z58POS - Posting group set (complex)          *
      *  Calls       -  SRRRDE - Retrieve RDE Information             *
      *                 SrPackDta - Format Extract Data               *
      *                 SRERR  - Database Error                       *
      *****************************************************************
     C     Z58DTA        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'Z58DTA'      @STK(Q)
      *
      ** Retrieve subroutine specific data.
      *
     C     6             OCCUR     ##SRDT
      *
      ** Set up Path.
      *
     C                   MOVEL     '\Z58DTA'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   MOVEL     WPathStr      ##SPAT
      *
      ** Set up Binds from passed in values.
      *
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
     C                   EXSR      PSHGRS
      *
      ** Retrieve RDE information for RDE's in Group Set
      *
     C                   MOVEL     'Z58DTA'      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      ** Klists For SDTXBSL1
      *
     C                   MOVEL     TSTXBS        W0TXBS
     C     KEY1          KLIST
     C                   KFLD                    TSCTRT
     C                   KFLD                    W0TXBS
     C                   KFLD                    TSRDNB
      *
     C     KEY4          KLIST
     C                   KFLD                    TSCTRT
     C                   KFLD                    W0TXBS
      *
      ** Deal Number
      *
     C                   MOVEL     TSDLLN        ##D(1)
      *
      ** Account Number
      *
     C     TSMODI        IFEQ      'G'
     C     ACNTKY        CHAIN     ACCNT                              66
     C     *IN66         IFEQ      *OFF
     C     ATYP          ANDEQ     'R'
     C                   MOVEL     ACNO          ##D(2)
     C                   ENDIF
     C                   ENDIF
      *
      ** Taxable Indicator
      *
     C                   SELECT
     C     TSMODI        WHENEQ    'D'
     C     TSDLLN        CHAIN     DEALS                              66
     C     *IN66         IFEQ      *OFF
     C                   MOVEL     TAXI          ##D(3)
     C                   MOVEL     TAXI          WTAXI
     C                   ENDIF
      *
     C     TSMODI        WHENEQ    'G'
     C     ACNTKY        CHAIN     ACCNTBJ0                           67
     C     *IN67         IFEQ      *OFF
     C                   MOVEL     ATITAX        ##D(3)
     C                   MOVEL     ATITAX        WTAXI
     C                   ENDIF
      *
     C                   ENDSL
                                                                                              CER069
      ** If Tax value at Account level is 'A', this means the EU Tax                          CER069
      ** indicator at Customer level should be used to determine whether                      CER069
      ** the account is taxable.                                                              CER069
                                                                                              CER069
     C                   IF        WTAXI = 'A'                                                CER069
     C                   CALL      'AOACTXR0'                                                 CER069
     C                   PARM      *BLANKS       ##RTCD                                       CER069
     C                   PARM      '*KEY   '     ##OPTN                                       CER069
     C                   PARM      TSCUST        ##CUST            6                          CER069
     C                   PARM      TSBRCA        ##BRCD                                       CER069
     C     SDACTX        PARM      SDACTX        DSSDY                                        CER069
     C                   IF        ##RTCD <> *BLANKS or ##RTCD = *BLANKS                      CER069
     C                             and (AXETXS = 'S' or AXETXS = 'D' or                       CER069
     C                             AXETXS = 'E' or AXETXS = ' ')                              CER069
     C                   MOVEL     'N'           ##D(3)                                       CER069
     C                   MOVEL     'N'           WTAXI                                        CER069
     C                   ELSE                                                                 CER069
     C                   MOVEL     AXETXS        ##D(3)                                       CER069
     C                   MOVEL     AXETXS        WTAXI                                        CER069
     C                   ENDIF                                                                CER069
     C                   ENDIF                                                                CER069
      *
      ** Transaction Type
      *
     C     KEY1          SETGT     SDTXBSL1
     C     KEY4          READPE    SDTXBSL1                               68
     C     *IN68         IFEQ      *OFF
     C                   MOVEL     TBTRTY        ##D(4)
     C                   ENDIF
      *
      ** Start date or last int. date
      *
     C                   MOVEL     TSSLID        ##D(5)
      *
      ** Set up Value Date
      *
     C                   MOVEL     TSRDNB        ##D(6)
      *
      ** Gross Interest in Deal Currency
      *
     C                   MOVEL     TSGINT        ##D(7)
     C                   MOVE      TSOCCY        ##CCY
     C                   EXSR      SRDCDT
     C                   MOVE      A6NBDP        ##D(7)
      *
      ** Gross Interest in Tax Currency
      *
     C     TSOCCY        IFEQ      TSTXCY
     C                   MOVEL     TSGINC        ##D(8)
     C                   MOVE      A6NBDP        ##D(8)
      *
     C                   ELSE
      *
     C                   MOVEL     TSGINC        ##D(8)
     C                   MOVEL     TSTXCY        ##CCY
     C                   EXSR      SRDCDT
     C                   MOVE      A6NBDP        ##D(8)
     C                   ENDIF
      *
      ** Margin Points in Deal Currency
      *
      ** Withholding Tax
      *
     C                   MOVEL     TSTXSR        ##D(10)
     C                   MOVEL     TSOCCY        ##CCY
     C                   EXSR      SRDCDT
     C                   MOVEL     A6TCMP        ##D(9)
     C                   MOVE      A6NBDP        ##D(10)
      *
      ** Withholding Tax in Tax Currency
      *
     C     TSOCCY        IFEQ      TSTXCY
     C                   MOVEL     TSTXSC        ##D(11)
     C                   MOVE      A6NBDP        ##D(11)
      *
     C                   ELSE
      *
     C                   MOVEL     TSTXSC        ##D(11)
     C                   MOVEL     TSTXCY        ##CCY
     C                   EXSR      SRDCDT
     C                   MOVE      A6NBDP        ##D(11)
     C                   ENDIF
      *
      ** Solidarity Contribution in Deal Currency
      *
     C                   MOVEL     TSSTDO        ##D(12)
     C                   MOVE      TSOCCY        ##CCY
     C                   EXSR      SRDCDT
     C                   MOVE      A6NBDP        ##D(12)
      *
      ** Solidarity Contribution in Tax Currency
      *
     C     TSOCCY        IFEQ      TSTXCY
     C                   MOVEL     TSSTDT        ##D(13)
     C                   MOVE      A6NBDP        ##D(13)
      *
     C                   ELSE
      *
     C                   MOVEL     TSSTDT        ##D(13)
     C                   MOVEL     TSTXCY        ##CCY
     C                   EXSR      SRDCDT
     C                   MOVE      A6NBDP        ##D(13)
     C                   ENDIF
      *
      ** Net Interest in Deal Currency
      *
     C                   MOVEL     TSNINT        ##D(14)
     C                   MOVE      TSOCCY        ##CCY
     C                   EXSR      SRDCDT
     C                   MOVE      A6NBDP        ##D(14)
      *
      ** Net Interest in Tax Currency
      *
      *
     C     CER054        IFEQ      'Y'
      *
      ** Third tax in Deal Currency
      *
     C                   MOVEL     TSTTDO        ##D(16)
     C                   MOVE      TSOCCY        ##CCY
     C                   EXSR      SRDCDT
     C                   MOVE      A6NBDP        ##D(16)
      *
      ** Third tax in Tax Currency
      *
     C     TSOCCY        IFEQ      TSTXCY
     C                   MOVEL     TSTTDT        ##D(17)
     C                   MOVE      A6NBDP        ##D(17)
     C                   ELSE
     C                   MOVEL     TSTTDT        ##D(17)
     C                   MOVEL     TSTXCY        ##CCY
     C                   EXSR      SRDCDT
     C                   MOVE      A6NBDP        ##D(17)
     C                   ENDIF
      *
      ** Third tax rate
      *
     C                   MOVEL     TSTTRA        ##D(18)
      *
     C                   ENDIF
      *
     ** Net Interest in Tax Currency
      *
     C     TSOCCY        IFEQ      TSTXCY
     C                   MOVEL     TSNINC        ##D(15)
     C                   MOVE      A6NBDP        ##D(15)
      *
     C                   ELSE
      *
     C                   MOVEL     TSNINC        ##D(15)
     C                   MOVEL     TSTXCY        ##CCY
     C                   EXSR      SRDCDT
     C                   MOVE      A6NBDP        ##D(15)
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       WCONV
     C                   Z-ADD     0             FSPTHU
     C                   Z-ADD     0             FSPTUT
      *
      ** Taxable interest in Deal & Tax CCY
      *
     C                   SELECT
      *
     C     WTAXI         WHENEQ    'N'
     C                   Z-ADD     0             FSPTHU
     C                   Z-ADD     0             FSPTUT
      *
     C     WTAXI         WHENEQ    'Y'
     C                   Z-ADD     TSGINT        FSPTHU
     C                   Z-ADD     TSGINC        FSPTUT
      *
     C     WTAXI         WHENEQ    'T'
      *
     C                   Z-ADD     TSPTHU        WSPTHU
     C                   Z-ADD     TSPTUT        WSPTUT
     C                   MOVE      'Y'           WCONV
      *
     C     TSOCCY        IFEQ      BJCYCD
     C     TSGINT        SUB       WSPTHU        FSPTHU
     C     TSGINC        SUB       WSPTUT        FSPTUT
     C                   ENDIF
      *
     C                   ENDSL
      *
      ** Set up Taxable Interest in Deal Currency
      *
      *
     C     WCONV         IFEQ      'Y'
     C     TSOCCY        ANDNE     BJCYCD
      *
     C                   MOVE      BJCYCD        ##CCY
     C                   EXSR      SRDCDT
      *
     C     A6MDIN        IFEQ      'D'
     C                   Z-ADD     A6SPRT        ZRATE1
     C                   ELSE
     C     A6SPRT        SUB       A6TCMP        WSPRT
     C     1             DIV(H)    WSPRT         ZRATE1
     C                   ENDIF
      *
     C                   MOVE      'D'           ZMDI1
     C                   Z-ADD     A6NBDP        ZCDPI
      *
     C                   MOVE      TSOCCY        ##CCY
      *
      ** Get Rate for conversion from Base - Deal Ccy
      *
     C     A6MDIN        IFEQ      'D'
     C                   Z-ADD     A6SPRT        ZRATE2
     C                   ELSE
     C     A6SPRT        SUB       A6TCMP        WSPRT
     C     1             DIV(H)    WSPRT         ZRATE1
     C                   ENDIF
      *
     C                   MOVE      'D'           ZMDI2
     C                   Z-ADD     A6NBDP        ZCDPO
      *
     C                   Z-ADD     *ZEROS        ZRATEX
      *
      ** Calculate Cross Rate
      *
     C     ZMDI1         IFEQ      ZMDI2
     C     ZRATE2        IFNE      *ZEROS
     C     ZRATE1        DIV(H)    ZRATE2        ZRATEX
     C                   ENDIF
      *
     C                   ELSE
     C     ZRATE1        MULT(H)   ZRATE2        ZRATEX
     C                   ENDIF
      *
      ** Set Cross M/D Indicator
      *
     C                   MOVE      ZMDI1         ZMDIX
      *
     C                   Z-ADD     ZRATEX        ZCRSRT
     C                   MOVE      ZMDI1         ZCRSMD
     C                   Z-ADD     ZCDPI         ZCDPF
     C                   Z-ADD     ZCDPO         ZCDPT
      *
      ** Convert to Taxable Interest into Deal Ccy
      *
     C                   Z-ADD     0             ZAMTT
     C                   Z-ADD     WSPTHU        ZAMTF
     C                   EXSR      ZCCYXR
     C                   MOVEL     ZAMTT         WSPTHU
      *
     C     TSGINT        SUB       WSPTHU        FSPTHU
     C     TSGINC        SUB       WSPTUT        FSPTUT
     C                   ENDIF
      *
     C                   MOVEL     FSPTHU        ##D(19)
     C                   MOVEL     TSOCCY        ##CCY
     C                   EXSR      SRDCDT
     C                   MOVE      A6NBDP        ##D(19)
      *
      ** Set up Taxable Interest in Tax Currency
      *
     C                   MOVEL     FSPTUT        ##D(20)
     C                   MOVEL     TSTXCY        ##CCY
     C                   EXSR      SRDCDT
     C                   MOVE      A6NBDP        ##D(20)
      *
      * --------------------------------------------------------
      ** NOTE : System can only handle up to max of 20 RDEs at
      **        a time so accumulate the current set so far and
      **        reset ##D index back to 1.
      * --------------------------------------------------------
      ** Accumulate RDEs and associated data
      *
     C                   EXSR      SrPackDta
      *
      ** Retrieve RDE information for RDEs in group set
      *
     C                   MOVEL     @STK(Q)       ##GRPS
     C                   Z-ADD     21            ##RDEN
     C                   EXSR      SRRRDE
      *
      ** Tax currency
      *
     C                   MOVEL     TSTXCY        ##D(1)
      *
      ** Secondary Tax Rate (Solidarity Surcharge rate)
      *
     C                   MOVEL     TSSTRA        ##D(2)
      *
      ** Withholding Tax Rate
      *
     C                   MOVEL     TSTXRT        ##D(3)
      *
      ** Interest To
      *
     C                   MOVEL     TSEDAT        ##D(4)
      *
      ** Accumulate RDE's and associated data and output to
      ** PF/CGUDTAPD.
      *
     C                   EXSR      SrPackDta
      *
     C                   EXSR      POPGRS
      *
     C     EXSRC2        TAG
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  Subroutine  -  Z58DT2                                        *
      *  Function    -  Posting Group Set (simple) more RDE's         *
      *                                                               *
      *  Called by   -  Z58POS - Posting group set (complex)          *
      *  Calls       -  SRRRDE - Retrieve RDE Information             *
      *                 SrPackDta - Format Extract Data               *
      *                 SRERR  - Database Error                       *
      *****************************************************************
     C     Z58DT2        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'Z58DT2'      @STK(Q)
      *
      ** Retrieve subroutine specific data.
      *
     C     7             OCCUR     ##SRDT
      *
      ** Set up Path.
      *
     C                   MOVEL     '\Z58DT2'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   MOVEL     WPathStr      ##SPAT
      *
      ** Set up Binds from passed in values.
      *
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
     C                   EXSR      PSHGRS
      *
      ** KLIST for SDACTXL1
      *
     C     KEY3          KLIST
     C                   KFLD                    TICUST
     C                   KFLD                    BBCNCZ
      *
      ** Retrieve RDE information for RDE's in Group Set
      *
     C                   MOVEL     'Z58DT2'      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      ** Customer Report Name
      *
     C                   MOVEL     BBCRNM        ##D(1)
      *
      ** Spot Rate
      *
     C                   MOVEL     TSOCSR        ##D(2)
      *
      ** Tax Type
      *
     C     KEY3          CHAIN     SDACTXL1                           69
     C     *IN69         IFEQ      *OFF
     C                   MOVEL     AXETXS        ##D(3)
     C                   ENDIF
      *
      ** Join Account Number
      *
     C                   MOVEL     TSJOIN        ##D(4)
      *
      ** Join Reference
      *
     C                   MOVEL     TSNAHO        ##D(5)
      *
      ** Account officer
      *
     C                   MOVEL     BBACOC        ##D(6)
      *
      ** Deal Type
      *
     C                   MOVEL     TSTRTP        ##D(7)
      *
      ** Deal Sub-type
      *
     C                   MOVEL     TSTRST        ##D(8)
      *
      ** Exchange Rate
      *
     C                   MOVEL     TSXRST        ##D(9)
      *
      ** Interest Rate
      *
      ** Hide retrieval of Interest Rate in subroutine SRINTR.
      ** It is currently not extracted but if needed later, just
      ** reinstate the commented line "EXSR SRINTR" below.
      *
     C                   MOVEL     *BLANKS       ##D(10)
      *
      ** Accumulate RDE's and associated data and output to
      ** PF/CGUDTAPD.
      *
     C                   EXSR      SrPackDta
      *
     C                   EXSR      POPGRS
      *
     C     EXSDA2        TAG
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  Subroutine  -  SRGENR                                        *
      *  Function    -  Generate reference number                     *
      *                 by writing to PF/CGUDCRPD                     *
      *                                                               *
      *  Called by   -  ZFSM58 - Main Processing                      *
      *  Calls       -  CG9010 - Create reference record              *
      *****************************************************************
     C     SRGENR        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRGENR'      @STK(Q)
      *
      ** Generate reference number and check if further processing
      ** required. Set up all available information in the record
      ** format before calling.
      *
     C                   MOVEL     TSBRCA        DRBRCA
     C                   MOVEL     TSBRCA        DRORBR
     C     TSMODI        IFEQ      'D'
     C                   MOVEL     TSDLLN        DRMTRN
     C                   MOVEL     'DL'          DRMODI
     C                   MOVEL     *BLANK        DRMACT
     C                   ELSE
     C                   CLEAR                   DRMTRN
     C                   MOVEL     'RE'          DRMODI
      *
     C                   MOVEL     TSJOIN        W0CUST
      *
     C     ACNTKY        CHAIN     ACCNT                              80
      *
     C     *IN80         IFEQ      *OFF
      *
     C                   MOVEL     ACNO          DRMACT
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVEL     'WTAX'        DRPTYP
     C                   MOVEL     'ADVICE'      DRPSTP
     C                   MOVEL     'N'           DRATRM
     C                   MOVE      TSJOIN        UTCUST
      *
     C                   CALL      'CG9010'
     C                   PARM                    ##RTCD
     C                   PARM      '*GEN'        UFMODE
     C                   PARM      W0CMT         ##CMT
     C                   PARM                    UTCUST
     C                   PARM                    ##UDCR
     C                   PARM                    ##ITMA
      *
      ** BLANKSreturn code implies generate correspondence.
      ** CGD1270 => no error, but suppress output for this transaction.
      *
     C     ##RTCD        IFEQ      *BLANKS
     C     DRPTYP        CAT(P)    ':':0         COLON
     C     COLON         CAT(P)    DRPSTP:0      ##REFR
     C                   EXSR      WRAPRF
     C                   END
      *
     C     ##RTCD        IFNE      *BLANKS
      *
     C     ##RTCD        IFEQ      'CGD1270'
     C                   MOVE      'N'           UFCOPD
     C                   ELSE
      *
     C                   MOVEL     'CG9010  '    W0FILE
     C                   MOVEL     ##RTCD        W0KEY
     C                   Z-ADD     6             W0ERNB
     C                   MOVEL     'CGD1286'     W0MSGD
     C                   MOVEL     'CGUSRMSG'    W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ENDIF
      *
     C     EXGENR        TAG
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  Subroutine  -  SRRRDE                                        *
      *  Function    -  Retrieve RDE information for RDEs in group set*
      *                                                               *
      *  Called by   -  simple group set subroutines                  *
      *  Calls       -  -                                             *
      *                                                               *
      *****************************************************************
     C     SRRRDE        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRRRDE'      @STK(Q)
      *
      ** Reset
      *
     C                   MOVEL     *BLANKS       ##R
     C                   MOVEL     *BLANKS       ##D
     C                   MOVEL     *BLANKS       ##S
      *
      ** Get information about next 20 RDEs in group set from compile
      ** time arrays
      *
     C                   Z-ADD     0             #1
     C     *IN99         DOUEQ     '0'
     C     #1            OREQ      20
     C                   Z-ADD     1             #2
     C     ##GRPX        LOOKUP    ##GRP(#2)                              99    *
     C     *IN99         IFEQ      '1'
     C                   ADD       1             #1
     C                   MOVEL     ##RDEA(#2)    ##R(#1)
     C                   ADD       1             ##RDEN
     C                   ENDIF
     C                   ENDDO
      *
     C     EXRRDE        TAG
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  Subroutine  -  SrPackDta                                     *
      *  Function    -  Accumulate RDEs and associated data for output*
      *                                                               *
      *  Called by   -  simple group set subroutines                  *
      *  Calls       -  CG3999 - Format and Pack Data                 *
      *                 SRERR  - Database Error                       *
      *                                                               *
      *****************************************************************
     C     SrPackDta     BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SrPackDta'   @STK(Q)
      *
      ** Reformat RDE data
      *
     C                   EXSR      SrFmtDta
      *
      ** Pack RDEs and associated data into data string
      *
     C                   CLEAR                   ##SDS
      *
      ** If CCG015 is installed, value of W0ACT is '*NEWARR'
      *
     C     CCG015        IFEQ      'Y'
     C                   MOVEL     '*NEWARR '    W0ACT
     C                   MOVEL     WPathStr      W0SPAT
     C                   ELSE
     C                   MOVEL     '*PACK   '    W0ACT
     C                   MOVEL     *BLANKS       W0SPAT
     C                   ENDIF
      *
     C                   CALL      'CG3999'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM                    W0ACT
     C                   PARM                    ##R
     C                   PARM                    ##D
     C                   PARM                    ##S
     C                   PARM                    W0SPAT
     C                   PARM                    ##RN
     C                   PARM                    ##DN
     C                   PARM                    ##FM
      *
      ** Database error
      *
     C     ##RTCD        IFNE      *BLANKS
      *
     C                   MOVEL     'CG3999  '    W0FILE
     C                   MOVEL     ##RTCD        W0KEY
     C                   Z-ADD     7             W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   EXSR      WRTRDE
      *
      ** Initialise Write Format Parameter.
      *
     C                   CLEAR                   W0FMT
      *
      ** Set up Control Information.
      *
     C                   Z-ADD     ##ITEM        DEITEM
     C                   ADD       1             ##OSEQ
     C                   Z-ADD     ##OSEQ        DEOSEQ
     C                   Z-ADD     ##PBIN        DEPBIN
     C                   Z-ADD     ##TBIN        DETBIN
     C                   MOVE      'FR'          DEFSLI
     C                   MOVE      *BLANKS       W0PATH
     C                   MOVEL     WPathStr      W0PATH
      *
      ** Append Data from pack routine.
      *
     C     W0FMT         CAT       ##SDS:0       W0FMT
      *
      ** Set Flag to show record formatted
      *
     C                   MOVE      'Y'           ##RFMT
      *
     C     EXADTA        TAG
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  Subroutine  -  SrFmtDta                                      *
      *  Function    -  Reformat RDE data                             *
      *                                                               *
      *  Called by   -  SrPackDta                                     *
      *  Calls       -                                                *
      *****************************************************************
     C     SrFmtDta      BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SrFmtDta'    @STK(Q)
      *
      ** Loop through RDE's and data
      *
     C                   Z-ADD     0             Wx1
     C     Wx1           DOUEQ     20
      *
      ** Move RDE's and its data to their templates
      *
     C                   ADD       1             Wx1
     C                   MOVEL     ##R(Wx1)      R#DEFN
     C                   MOVEL     ##D(Wx1)      R#DATA
      *
      ** If data present and RDE is edited
      *
     C     R#DATA        IFNE      *BLANKS
     C     ##RDEC        ANDNE     *BLANKS
      *
      ** Reformat Amount
      *
     C                   MOVEA     ##NUMA        WAr29
     C                   Z-ADD     1             Wx2
     C     *BLANKS       LOOKUP    WAr29(Wx2)                             99    *
     C                   Z-ADD     20            Wx3
     C                   Z-ADD     0             WNum20
     C     Wx2           DOWGT     1
     C     Wx2           ANDLE     20
     C     Wx3           ANDGT     1
     C                   SUB       1             Wx2
     C                   MOVEL     WAr29(Wx2)    WAr20(Wx3)
     C                   SUB       1             Wx3
     C                   ENDDO
      *
      ** Sign the amount
      *
     C     ##SIGN        IFEQ      '-'
     C                   Z-SUB     WNum20        ##NUMB
     C                   ELSE
     C                   Z-ADD     WNum20        ##NUMB
     C                   ENDIF
      *
      ** Default Edit Type
      *
     C     ##EDTT        IFEQ      *BLANKS
     C                   MOVEL     ##RDET        ##EDTT
     C                   ENDIF
      *
      ** Default Decimal Places
      *
     C     ##DCPA        IFEQ      *BLANKS
     C                   MOVEL     ##RDED        ##DCPA
     C                   ENDIF
      *
      ** New RDE data
      *
     C                   MOVEL     R#DATA        ##D(Wx1)
     C                   ENDIF
     C                   ENDDO
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  Subroutine  -  SRINTR                                        *
      *  Function    -  Extract Interest Rate                         *
      *                                                               *
      *  Called by   -                                                *
      *  Calls       -                                                *
      *                                                               *
      *****************************************************************
     C     SRINTR        BEGSR
      *
      ** Dealing transaction (module ID is 'D')
      *
     C     TSMODI        IFEQ      'D'
     C     TSDLLN        CHAIN     DEALS                              66
      *
     C     *IN66         IFEQ      '0'
     C                   MOVEL     INTR          ##D(10)
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Retail caplitalisation (module ID is 'G')
      *
     C     TSMODI        IFEQ      'G'
      *
      ** Convert customer number to be used as one of the key fields.
      ** (the rest of the keys fields can be used directly from SDCSINPD)
     C                   MOVEL     TSJOIN        KCNUM
      *
     C     KYREHI        SETGT     REHISDL
     C                   READP     REHISDL                              9090
      *
     C     *IN90         IFEQ      '0'
     C                   MOVEL     RCRIR         ##D(10)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  Subroutine  -  SRDCDT                                        *
      *  Function    -  Determine Currency Details                    *
      *                                                               *
      *  Called by   -                                                *
      *  Calls       -                                                *
      *                                                               *
      *****************************************************************
     C     SRDCDT        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRDCDT'      @STK(Q)
      *
      ** Access array of Currency Details already loaded
      *
     C                   Z-ADD     1             C
     C     ##CCY         LOOKUP    ##CY(C)                                99
      *
      ** If no match is found determine the next free space in the
      ** loaded currency array.
      *
     C     *IN99         IFEQ      *OFF
     C                   Z-ADD     1             C
     C     *BLANKS       LOOKUP    ##CY(C)                                99
      *
      ** If no space is left, set the Currency Data data structure to
      ** the 101st occurrence so that when the new details are
      ** retrieved no existing details are overwritten.
      *
     C     *IN99         IFEQ      *OFF
     C     101           OCCUR     SDCURR
      *
      ** If a space is found, set up the new currency into the array
      ** and position the Currency Data data structure on the
      ** occurrence matching the array index.
      *
     C                   ELSE
     C                   MOVE      ##CCY         ##CY(C)
     C     C             OCCUR     SDCURR
     C                   ENDIF
      *
      ** Retrieve the currency details.
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*KEY'        ##OPTN
     C                   PARM                    ##CCY
     C     SDCURR        PARM      *BLANKS       DSSDY
      *
      ** Database Error
      *
     C     ##RTCD        IFNE      *BLANKS
     C                   MOVEL     'SDCURRPD'    W0FILE
     C                   MOVEL     ##CCY         W0KEY
     C                   Z-ADD     9             W0ERNB
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** If the currency has been retrieved earlier, position the
      ** Currency Data data structure on the relevant occurrence.
      *
     C                   ELSE
     C     C             OCCUR     SDCURR
     C                   ENDIF
      *
     C     EXDCDP        TAG
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  Subroutine  -  SRINIT                                        *
      *  Function    -  Initial processing - First Call Only          *
      *                                                               *
      *  Called by   -  Mainline                                      *
      *  Calls       -  AOBANKR0 - Obtain Bank details                *
      *                 AOGELRR0 - Obtain General Ledger Details      *
      *                                                               *
      *****************************************************************
     C     SRINIT        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRINIT'      @STK(Q)
      *
      ** Define Fields
      *
     C                   MOVE      *BLANKS       WPathStr
     C     *LIKE         DEFINE    DEPBIN        ##BNDC
     C     *LIKE         DEFINE    DEPBIN        S#PBIN
     C     *LIKE         DEFINE    DETBIN        S#TBIN
     C     *LIKE         DEFINE    TSPTHU        WSPTHU
     C     *LIKE         DEFINE    TSPTUT        WSPTUT
      *
     C     *LIKE         DEFINE    ##CCY         EQCY
     C     *LIKE         DEFINE    CCY           ##CCYP
      *
      ** Call access program for Bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*FIRST  '    ##OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error
      *
     C     ##RTCD        IFNE      *BLANKS
      *
     C                   MOVEL     'AOBANKR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY
     C                   Z-ADD     10            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** Determine number of decimal places - base currency
      *
     C                   MOVEL     BJCYCD        ##CCY
     C                   EXSR      SRDCDT
     C                   Z-ADD     A6NBDP        BASCDP
      *
      ** Determine number of decimal places - local currency
      *
      *
      ** Call access program for General Ledger details
      *
     C                   CALL      'AOGELRR0'
     C                   PARM      '*MSG   '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDGELR        PARM      SDGELR        DSFDY
      *
      ** Database error
      *
     C     PRTCD         IFNE      *BLANKS
      *
     C                   MOVEL     'AOGELRR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY
     C                   Z-ADD     11            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** Access SAR details file to determine if CEU013 is installed
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CEU013'      ##SARD
     C                   PARM                    DSFDY
      *
      ** Database error
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY
     C                   Z-ADD     12            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CEU013
     C                   ELSE
     C                   MOVEL     'N'           CEU013
     C                   END
      *
      ** Retrieve the Euro currency details for later use.
      *
     C     CEU013        IFEQ      'Y'
     C     BKEURO        ANDNE     *BLANKS
     C                   MOVE      BKEURO        ##CCY
     C                   EXSR      SRDCDT
     C                   ENDIF
      *
      ** Access SAR details file to determine if CEU014 is installed
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CEU014'      ##SARD
     C                   PARM                    DSFDY
      *
      ** Database error
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY
     C                   Z-ADD     13            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CEU014
     C                   ELSE
     C                   MOVEL     'N'           CEU014
     C                   END
      *
      ** Access Switchable Features file and check if CCG015 is
      ** installed (Correspondence Manager)
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CCG015'      ##SARD
     C                   PARM                    DSFDY
      *
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CCG015
     C                   ELSE
     C                   MOVE      'N'           CCG015
      *
     C     PRTCD         IFNE      '*NRF    '
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   MOVEL     '*CALL   '    W0KEY
     C                   Z-ADD     19            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Access SAR details file to determine if CER054 is installed
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CER054'      ##SARD
     C                   PARM                    DSFDY
      *
      ** Database error
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY
     C                   Z-ADD     14            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C                   MOVEL     'N'           CER054
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CER054
     C                   END
      *
      ** Ket for access of SDCSINL2 (only records added today)
      *
     C     UFGLKY        KLIST
     C                   KFLD                    BJRDNB
     C                   KFLD                    TICUST
      *
      *
      ** Copyright
      *
     C                   MOVEA     ##CPY         ##BIS
      *
     C     EXINIT        TAG
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  Subroutine  -  SRINZ                                         *
      *  Function    -  Initialise Fields on Program Invocation       *
      *                                                               *
      *  Called by   -  Mainline                                      *
      *  Calls       -  None                                          *
      *                                                               *
      *****************************************************************
     C     SRINZ         BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRINZ '      @STK(Q)
      *
      ** Initialise work fields
      *
     C                   Z-ADD     *ZEROS        #1
     C                   Z-ADD     *ZEROS        #2
     C                   Z-ADD     *ZEROS        #3
     C                   MOVE      *BLANKS       WPathStr
     C     *LIKE         DEFINE    DEOSEQ        ##OSEQ
      *
     C                   Z-ADD     *ZEROS        ##OSEQ
      *
      ** Initialise Binds.
      *
     C                   Z-ADD     1             S#PBIN
     C                   Z-ADD     1             S#TBIN
     C                   Z-ADD     1             ##BNDC
      *
      ** Initialise XML increment
      *
     C                   EXSR      INIXML
      *
     C     EXINZ         TAG
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
     C/COPY ZSRSRC,ZCCYXR_ILE
     C/COPY CGCPYSRC,SRERRPSSRL
     C/SPACE 5
     C/COPY CGCPYSRC,SRERRCLE
     O/SPACE 5
     C/COPY CGCPYSRC,CGNWEXILE
      *
      ** Added ZZFINTO rde to the Z58DTA group set
      *
** ##GRP/##RDEA
Z58HDR0001 ZZFLTSD    Date
Z58HDR0002 ZZFSD      Date
Z58HDR0003 ZZPAGNO    AmountL0
Z58HDR0004 ZZUUTHR    AmountL
Z58HDR0005 ZZUTIL     AmountL
Z58HDR0006 ZZCTHR     AmountL
BRANCH0001 BRANCH
BRANCH0002 BRANCH NAM
CUST  0001 CUSTOMER
CUST  0002 CUST_NAME
CUST  0003 CUST_ADR1
CUST  0004 CUST_ADR2
CUST  0005 CUST_ADR3
CUST  0006 CUST_ADR4
CUST  0007 CUST_TOWN
CUST  0008 NAH_FLAG
CCY   0001 CURRENCY
CCY   0002 CCY_DESC
CCY   0003 PREC_METIN
Z58DTA0001 ZZDLNO
Z58DTA0002 ZZACNO
Z58DTA0003 ZZFTAXI
Z58DTA0004 ZZFTRTP
Z58DTA0005 ZZFSLID    Date
Z58DTA0006 ZZFVALD    Date
Z58DTA0007 ZZFGINTC   AmountL
Z58DTA0008 ZZFGINTD   AmountL
Z58DTA0009 ZZFGLKR    Rate  L7
Z58DTA0010 ZZFWHTC    AmountL
Z58DTA0011 ZZFWHTB    AmountL
Z58DTA0012 ZZFSCNC    AmountL
Z58DTA0013 ZZFSCNB    AmountL
Z58DTA0014 ZZFNINTC   AmountL
Z58DTA0015 ZZFNINTD   AmountL
Z58DTA0016 ZZFCHTC    AmountL
Z58DTA0017 ZZFCHTB    AmountL
Z58DTA0018 ZZFCHRT    Rate  L4
Z58DTA0019 ZZFTINTC   AmountL
Z58DTA0020 ZZFTINTD   AmountL
Z58DTA0021 CCY_LOCAL
Z58DTA0022 SEC_TAXRT  Rate  L4
Z58DTA0023 ZZFWHTR    Rate  L4
Z58DTA0024 ZZFINTO    Date
Z58DT20001 ZZCRNM
Z58DT20002 ZZSPRT     Rate  L8
Z58DT20003 ZZTAXT
Z58DT20004 ZZJACC
Z58DT20005 ZZJREF
Z58DT20006 ZZACOF
Z58DT20007 DEAL TYPE
Z58DT20008 DEALSUBTYP
Z58DT20009 EXCH RATE  Xrate L8
Z58DT20010 INT RATE   Rate  L7
Z58DT30001 ZZTONO
Z58DT30002 ZZTONA
Z58DT30001 ZZPUTHR    AmountL
Z58DT30002 ZZTONO
Z58DT30003 ZZTONA
Z58DT40001 GINTCCY    AmountL
Z58DT40002 MAINTAX    AmountL
Z58DT40003 SCNDTAX    AmountL
Z58DT40004 NINTCCY    AmountL
Z58DT40005 THRDTAX    AmountL
ACOF  0001 ACOF_CODE                     Account Officer Code
ACOF  0002 ACOF_DEPT                     Account Officer Dept
ACOF  0003 ACOF_NAME                     Account Officer Name
ACOF  0004 ACOF_TELP                     Account Officer Telephone Num.
ACOF  0005 ACOF_TELX                     Account Officer Telephone Ext.
** POWER - ARRAY OF POWERS FOR CURRENCY CONVERSION
0000001
0000010
0000100
0001000
0010000
0100000
1000000
** ##CPY  **      OBJECT COPYRIGHT
(c) Misys International Banking Systems Ltd. 2011
