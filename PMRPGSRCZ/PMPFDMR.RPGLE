     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas PM Portfolio definition retrieve')
      *****************************************************************
      *                                                               *
      *  Midas - Portfolio Management Module                          *
      *                                                               *
      *  PMPFDMR - PM Portfolio Definition retrieve a record          *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. CGL029             Date 01Sep03               *
      *                 CAP084  *CREATE    Date 08Sep03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - Conversion of Mm inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
 
      **--------------------------------------------------------------------------------------------
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      *
     D MaxChrgArr      C                   CONST(10)
      *
      **--------------------------------------------------------------------------------------------
      ** SCREEN FORMATS
      **--------------------------------------------------------------------------------------------
 
      *
      ** Portfolio Definition Details from incoming transaction
      ** - in screen format
     D NwDfScnFmt    E DS                  EXTNAME(PMPFDMPD)
      *
      ** Primary details screen fields
     D  NwDetailScrn          16    108
      *
      ** New Portfolio Charges header details - screen format
     D NwChrgScrnH     DS            21
      *
      ** Original Portfolio Charges header details - screen format
     D CrChrgScrnH     DS            21
      *
      ** New Portfolio Charges details array - screen format
     D NwChrgScrnArr   S                   DIM(MaxChrgArr)
     D                                     LIKE(ChrgScrnD)
      *
      ** Original Portfolio Charges details array - screen format
     D CrChrgScrnArr   S                   DIM(MaxChrgArr)
     D                                     LIKE(ChrgScrnD)
      *
      ** DS for Portfolio Charges screen fields - detail
     D ChrgScrnD       DS
     D  DDCGCO                 1      2
     D  DDCGSP                 3     16
     D  DDCGSI                17     17
     D  DDCGEI                18     18
     D  DDCGFQ                19     19
     D  DDCGDY                20     21
     D  DDCGND                22     27
     D  DDCGST                28     28
     D  DDCSFQ                29     29
     D  DDCSDY                30     31
     D  DDCSND                32     37
     D  DDPRFC                38     41
      *
     D  DDVALD                42     42
     D  DDCGCH                43     44
     D  DDCGSH                45     57  0
     D  DDCGEH                58     58
     D  DDCGLH                59     63  0
     D  DDCGDH                64     65
     D  DDCGNH                66     70  0
     D  DDCGFH                71     71
     D  DDCSFH                72     72
     D  DDCSDH                73     74
     D  DDCSNH                75     79  0
     D  DDCGTH                80     80
     D  DDPRFH                81     84
 
      **--------------------------------------------------------------------------------------------
      ** FILE FORMATS
      **--------------------------------------------------------------------------------------------
      *
      ** Portfolio Definition Details - for file update
     D NwDfFilFmt    E DS                  EXTNAME(PMVPFDMPD)
      *
      ** Portfolio Definition Details retrieved from file
      ** - in screen format
     D CrDfScnFmt    E DS                  EXTNAME(PMPFDMPD)
     D                                     PREFIX(P)
      *
      ** Portfolio Definition Details retrieved from file
      ** - in file format
     D CrDfFilFmt    E DS                  EXTNAME(PMPORTPD)
      *
      ** REVIEW FROM Customer and Portfolio Reference fields
     D DDREVIEW        DS
     D  DDPNP8                 1      6
     D  DDPORT                 7     10
      *
      ** Investment Policy Indicators - screen
      ** - (DDIPIN) Instrument Investment Policy Indicator
      ** - (DDCYIN) Currency Investment Policy Indicator
      ** - (DDYPIN) Country of Risk Investment Policy Indicator
      ** - (DDNPIN) Industry Investment Policy Indicator
     D NwInvest        DS
     D  DDIPIN                 1      1
     D  DDCYIN                 2      2
     D  DDYPIN                 3      3
     D  DDNPIN                 4      4
      *
      ** Investment Policy Indicators - hidden
     D Invest_H        DS
     D  DDIPIH                 1      1
     D  DDCYIH                 2      2
     D  DDYPIH                 3      3
     D  DDNPIH                 4      4
      *
      ** Portofolio Definition Error indicators
     D PMEPMD        E DS                  EXTNAME(PMEPFDMPD)
     D  PMEPMD_KEY             1      3
      *
      ** Portfolio Charges details array - for file update
     D NwChrgFileArr   S                   DIM(MaxChrgArr)
     D                                     LIKE(PMCHRG)
      *
      ** Original Portfolio Charges details array - file format
     D CrChrgFileArr   S                   DIM(MaxChrgArr)
     D                                     LIKE(PMCHRG)
      *
      ** Externally described DS for Portfolio Charges details
     D PMCHRG        E DS                  EXTNAME(PMCHRGPD)
      *
      ** Error indicators - charges header
     D PMEPMC          DS
     D  OKBCGY                 1      1
     D  OKCSCY                 2      2
     D  OKCUSA                 3      3
     D  OKBRCA                 4      4
      *
      ** DS for Error indicators - charges details
     D PMEPMCD         DS
     D  OKCGCO                 1      1
     D  OKCGSP                 2      2
     D  OKCGSI                 3      3
     D  OKCGEI                 4      4
     D  OKCGFQ                 5      5
     D  OKCGDY                 6      6
     D  OKCGND                 7      7
     D  OKCGST                 8      8
     D  OKCSFQ                 9      9
     D  OKCSDY                10     10
     D  OKCSND                11     11
     D  OKPRFC                12     12
      *
      ** Error indicators array - charges details
     D PMEPMCArr       S                   DIM(MaxChrgArr)
     D                                     LIKE(PMEPMCD)
      *
      ** Incoming Extra Data
     D PExtData      E DS                  EXTNAME(PMPFEXPD)
      *
      ** Externally described DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for General Ledger ICD Details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      *
      ** Externally described DS for Portfolio Details
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      *
      ** Externally described DS for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** Externally described DS for Custody Fees
     D SDSCFE        E DS                  EXTNAME(SDSCFEPD)
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      ** Second DS for access programs, long data structure                                   CGL029
                                                                                              CGL029
      **--------------------------------------------------------------------------------------------
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
      **--------------------------------------------------------------------------------------------
 
     C                   CLEAR                   CrDfFilFmt
     C     DDACTN        IFEQ      *BLANK
     C     AuthComp      IFEQ      'X'
     C                   MOVEL     'X'           DDACTN
     C                   ELSE
     C                   MOVEL     'E'           DDACTN
     C                   ENDIF
     C                   ENDIF
 
     C     FwdBck        IFEQ      'F'
     C                   MOVEL     'Y'           @RDFWD
     C                   MOVEL     'N'           @RDBCK
     C                   ELSE
     C     FwdBck        IFEQ      'B'
     C                   MOVEL     'N'           @RDFWD
     C                   MOVEL     'Y'           @RDBCK
     C                   ELSE
     C                   MOVEL     'N'           @RDFWD
     C                   MOVEL     'N'           @RDBCK
     C                   ENDIF
     C                   ENDIF
 
     C     @RDFWD        IFEQ      'Y'
     C     @RDBCK        OREQ      'Y'
     C                   EXSR      PMPFDMRED
     C                   ELSE
     C                   MOVEL     DDCUSN_In     PCNUM
     C                   MOVEL     DDPTFR_In     PPTFR
     C                   MOVEL     *BLANK        @ERRMS
     C                   ENDIF
      *
      * If deal read
      * and no error message returned
      *
     C     PCNUM         IFNE      *BLANK
     C     PPTFR         ANDNE     *BLANK
     C     @ERRMS        ANDEQ     *BLANK
      *
      * Retrieve deal details
      *
     C                   MOVEL     PCNUM         DDCSNM
     C                   MOVEL     PPTFR         DDPREF
     C                   EXSR      PMPFDM2RV
      *
      * Convert to screeen format
      *
     C     Idx           IFEQ      0
     C                   EXSR      PMPFDM2CT
     C                   ENDIF
 
     C                   ENDIF
 
     C     @ERRMS        IFNE      *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'DDCSNM'      FldNameArr(1)
     C                   MOVEL     @ERRMS        MsgIDArr(1)
     C                   ENDIF
 
     C                   EVAL                    Buffer = CrDfScnFmt
 
     C                   SETON                                        LR
     C                   RETURN
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    AuthComp          1
     C                   PARM                    FwdBck            1
     C                   PARM                    DDCUSN_In         6
     C                   PARM                    DDPTFR_In         4
     C                   PARM                    Buffer         6000
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc           1
 
      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'PMUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
      *
      ** Access Bank details.
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     001           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Acces Midas General Ledger ICD details.
      *
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      ** Database error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   Z-ADD     002           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access Midas Modules details.
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Database error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   Z-ADD     003           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If Portfolio Management is installed, access ICD details.
      *
     C     BGPFMG        IFEQ      'Y'
      *
     C                   CALLB     'AOPORTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDPORT        PARM      SDPORT        DSFDY
      *
      ** Database error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDPORTPD'    DBFILE
     C                   Z-ADD     004           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Access SAR details file to determine if CAC003
      ** (Profit Centre) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CAC003'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CAC003'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     005           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Switch on Profit Centre feature if Analytical Accounting is
      ** also switched on.
      *
     C     PRTCD         IFEQ      *BLANK
     C     BGN0ST        ANDEQ     'Y'
     C                   MOVEL     'Y'           CAC003            1
     C                   ELSE
     C                   MOVEL     'N'           CAC003
     C                   ENDIF
      *
      ** Access SAR file to determine if S01464 (Safe Custody Fees)
      ** is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'S01464'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'S01464'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     006           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     PRTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01464            1
     C                   ELSE
     C                   MOVEL     'N'           S01464
     C                   ENDIF
      *
      ** If Safe Custody Fees is installed, access ICD details.
      *
     C     S01464        IFEQ      'Y'
      *
     C                   CALL      'AOSCFER0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDSCFE        PARM      SDSCFE        DSFDY
      *
      ** Database error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDSCFEPD'    DBFILE
     C                   Z-ADD     007           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
 
      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,PMPFDMM01
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      **********************************************************************
     C     PMPFDMRED     BEGSR
 
     C                   CALLB     'PMPFDMRED'
      *
      * INPUT PARAMETERS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeOut       10
      *
      ** Customer
     C                   PARM                    DDCUSN_In
      *
      ** Portfolio Reference
     C                   PARM                    DDPTFR_In
      *
      ** REVIEW FROM Customer
     C                   PARM                    DDPNP8
      *
      ** REVIEW FROM Portfolio Reference
     C                   PARM                    DDPORT
      *
      * READ FORWARDS
     C                   PARM                    @RDFWD            1
      *
      * READ BACKWARDS
     C                   PARM                    @RDBCK            1
      *
      ** STANDING DATA
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      * OUTPUT PARAMETERS
      *
      * Error message
     C                   PARM      *BLANK        @ERRMS            7
      *
      ** Customer Number of Portfolio Definition read
     C                   PARM                    PCNUM             6
      *
      ** Portfolio Reference  of Portfolio Definition read
     C                   PARM                    PPTFR             4
 
     C                   ENDSR
      **********************************************************************
     C     PMPFDM2RV     BEGSR
 
     C                   CALLB     'PMPFDM2RV'
      *
      * INPUTS
      *
      * Return code
     C                   PARM      *BLANK        RetCodeIn        10
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '*SIN  ' (SCREEN INPUT function)
      *
     C                   PARM      *BLANK        ModeofOp          6
      *
      * Response mode
     C                   PARM      'S'           RespMode          1
      *
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * Front Office Transaction ID
     C                   PARM      *BLANKS       FOTRID           20
      *
      ** Portfolio Reference
     C                   PARM                    DDPREF            4
      *
      ** Customer Number
     C                   PARM                    DDCSNM           10
      *
      ** REVIEW FROM Customer and Portfolio Reference
     C                   PARM                    DDREVIEW
      *
      ** STANDING DATA
      ** =============
      *
      ** SDPORT - Portfolios Supported
     C                   PARM                    FCPORS
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** SDMMOD - Portfolio Management
     C                   PARM                    BGPFMG
      * OUTPUTS :
      *
      ** Original Portfolio Definition Details in file format
     C                   PARM                    CrDfFilFmt
      *
      ** OK Action Code
     C                   PARM                    OKACTN
      *
      ** OK Portfolio Reference
     C                   PARM                    OKPREF
      *
      ** OK Customer
     C                   PARM                    OKCSNM
      *
      ** OK REVIEW FROM
     C                   PARM                    OKREVIEW          1
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
      *
      ** SDPLCS - Portfolio Customer's Base Currency
     C                   PARM                    QBCSBY            3
      *
      ** Portfolio Management Customer flag
     C                   PARM                    PMCUST            1
      *
      ** SDCUST - Branch Code of incoming customer
     C                   PARM                    BBBRCD            3
      *
      ** SDCUST - Account Officer Code of incoming customer
     C                   PARM                    BBACOC            2
 
 
     C                   ENDSR
      **********************************************************************
     C     PMPFDM2CT     BEGSR
 
     C                   CALLB     'PMPFDM2CT'
 
      * INPUTS
      * Return Code
     C                   PARM      *BLANK        ReturnCode       10
      *
      ** Portfolio Definition Details retrieved from file
      ** - in file format
     C                   PARM                    CrDfFilFmt
      *
      ** Action code from incoming transaction
     C                   PARM                    DDACTN
      *
      ** Portfolio Management Customer flag
     C                   PARM                    PMCUST
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Rundate
     C                   PARM                    BJRDNB
      *
      ** SDBANK - Date Format
     C                   PARM                    BJDFIN
      *
      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST
      *
      ** SDSCFE - Custody Fees Group for Portfolio
     C                   PARM                    FBFGCP
      *
      ** SDMMOD - Futures & Options
     C                   PARM                    BGFUOP
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Safe Custody Fees feature
     C                   PARM                    S01464
      *
      ** Profit Centre feature
     C                   PARM                    CAC003
      * OUTPUTS
 
      ** Portfolio Definition Details retrieved from file
      ** - in screen format
     C                   PARM                    CrDfScnFmt
      *
      ** Investment Policy Indicators - screen
     C                   PARM                    NwInvest
      *
      ** Date Opened retrieved from file - in screen format
     C                   PARM                    PDDDPOP           6
      *
      ** CLOSED/CLOSURE REQUEST narrative - for display
     C                   PARM                    PDDDELT          16
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
