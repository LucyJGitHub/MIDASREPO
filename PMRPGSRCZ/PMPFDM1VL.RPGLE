     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas PM Portfolio charges validation control')
      *****************************************************************
      *                                                               *
      *  Midas - Portfolio Management Module                          *
      *                                                               *
      *  PMPFDM1VL - Portfolio Charges Validation Control            *
      *                                                               *
      *  Function: This module validates Portfolio Charges fields     *
      *            for input into the Midas database.                 *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CPB002             Date 13Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP033  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CPB002 - New Private Banking Customer Processing.            *
      *           Just recompile over changes in PMVPFDMPD.           *
      *  CAP033 - Conversion of PM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,PMPFDCV001
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      *
      /COPY ZACPYSRC,ERR_XARRYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
     D MaxChrgArr      C                   CONST(10)
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** New Portfolio Charges header details - screen format
     D NwChrgScrnH     DS
     D  DDBCGY                 1      3
     D  DDCSCY                 4      6
     D***DDCUSA                 7     18                                                      CGL029
     D***DDBRCA                19     21                                                      CGL029
     D  DDCUSA                 7     24                                                       CGL029
     D  DDBRCA                25     27                                                       CGL029
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
     D  DDPFRC                38     41
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
      *
     D  DDSCRN                 1     41
      *
      ** New Portfolio Charges details array - screen format
     D NwChrgScrnArr   S                   DIM(MaxChrgArr)
     D                                     LIKE(ChrgScrnD)
      *
      ** Charges details array - for file update
     D NwChrgFileArr   S                   DIM(MaxChrgArr)
     D                                     LIKE(PMCHRG)
      *
      ** Externally described DS for Portfolio Charges details
     D PMCHRG        E DS                  EXTNAME(PMCHRGPD)
      *
      ** Portfolio Definition Details - for file update
     D NwDfFilFmt    E DS                  EXTNAME(PMVPFDMPD)
      *
      ** Error indicators - charges header
     D OKChrg          DS
     D  OKBCGY                 1      1
     D  OKCSCY                 2      2
     D  OKCUSA                 3      3
     D  OKBRCA                 4      4
      *
      ** DS for Error indicators - charges details
     D OKChrgD         DS
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
     D  OKPFRC                12     12
      *
      ** Error indicators array - charges details
     D OkChrgArr       S                   DIM(MaxChrgArr)
     D                                     LIKE(OkChrgD)
      *
      ** Charge Codes array
     D ChrgCodeArr     S              2    DIM(MaxChrgArr)
      *
      ** OK Charge Codes array
     D OKCGArr         S              1    DIM(MaxChrgArr)
      *
      ** Externally described DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** Externally described DS for Portfolio Management
      ** Customer Details
     D SDPLCS        E DS                  EXTNAME(SDPLCSPD)
      *
      ** DS for Access Programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message IDs
     D IDX             S              3P 0
      *
      ** Index for arrays of warning messages
     D WIDX            S              3P 0
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      /COPY WNCPYSRC,PMPFDCV002
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      /COPY WNCPYSRC,PMPFDCV003
 
      ** Build the Charge Codes array.
 
      /COPY WNCPYSRC,PMPFDCV004
 
     C                   EXSR      SRBLDCodesArr
 
      /COPY WNCPYSRC,PMPFDCV005
 
      ** Retrieve Customer Details.
 
      /COPY WNCPYSRC,PMPFDCV006
 
     C                   EXSR      SRCUSTDET
 
      /COPY WNCPYSRC,PMPFDCV007
 
      ** Validate Bank's Charging Currency.
 
      /COPY WNCPYSRC,PMPFDCV008
 
     C                   EXSR      SRVBCGY
 
      /COPY WNCPYSRC,PMPFDCV009
 
      ** Validate Customer Settlement Account.
 
      /COPY WNCPYSRC,PMPFDCV010
 
     C                   EXSR      SRVCUSA
 
      /COPY WNCPYSRC,PMPFDCV011
 
      ** Processing for Charges details subfile starts here.
 
      /COPY WNCPYSRC,PMPFDCV012
 
     C                   Z-ADD     1             WCNTR
     C     WCNTR         DOUGT     MaxChrgArr
 
      /COPY WNCPYSRC,PMPFDCV013
 
      ** Reset work area data strutures.
 
      /COPY WNCPYSRC,PMPFDCV014
 
     C                   CLEAR                   PMCHRG
     C                   Z-ADD     *ZERO         PODLUP
     C                   Z-ADD     *ZERO         POYLUP
     C                   Z-ADD     *ZERO         POTLUP
     C                   Z-ADD     *ZERO         POLCD
     C                   Z-ADD     *ZERO         POTNLU
     C**********         Z-ADD     *ZERO         POCNUM                                       CSD027
     C                   EVAL      POCNUM =      *BLANKS                                      CSD027
     C                   Z-ADD     *ZERO         POCGSQ
     C                   Z-ADD     *ZERO         POCGSP
     C                   Z-ADD     *ZERO         POCGDY
     C                   Z-ADD     *ZERO         POCGND
     C                   Z-ADD     *ZERO         POCSDY
     C                   Z-ADD     *ZERO         POCSND
     C                   Z-ADD     *ZERO         POCGAD
     C                   Z-ADD     *ZERO         POCGLD
     C                   Z-ADD     *ZERO         POCGLS
     C                   Z-ADD     *ZERO         POCSSP
     C                   Z-ADD     *ZERO         POCGAJ
     C                   Z-ADD     *ZERO         POCGAT
     C                   Z-ADD     *ZERO         POCSTT
 
     C                   CLEAR                   ChrgScrnD
     C                   Z-ADD     0             DDCGSH
     C                   Z-ADD     0             DDCGLH
     C                   Z-ADD     0             DDCGNH
     C                   Z-ADD     0             DDCSNH
 
     C                   MOVE      *ALL'Y'       OKChrgD
 
      /COPY WNCPYSRC,PMPFDCV015
 
      ** Move Charges screen and file details to data structures.
 
      /COPY WNCPYSRC,PMPFDCV016
 
     C                   Eval      ChrgScrnD = NwChrgScrnArr(WCNTR)
     C                   Eval      PMCHRG = NwChrgFileArr(WCNTR)
 
      /COPY WNCPYSRC,PMPFDCV017
 
      ** If current Charge element was retrieved from file, check if any
      ** details were blanked out.
 
      /COPY WNCPYSRC,PMPFDCV018
 
     C     DDVALD        IFEQ      'Y'
     C                   EXSR      SRVVALD
     C                   ENDIF
 
      /COPY WNCPYSRC,PMPFDCV019
 
      ** Continue validation only if screen details exist.
 
      /COPY WNCPYSRC,PMPFDCV020
 
     C     DDSCRN        IFNE      *BLANKS
 
      /COPY WNCPYSRC,PMPFDCV021
 
      ** Validate Charge Code.
 
      /COPY WNCPYSRC,PMPFDCV022
 
     C                   EXSR      SRVCGCO
 
      /COPY WNCPYSRC,PMPFDCV023
 
      ** Validate Charge Spread details.
 
      /COPY WNCPYSRC,PMPFDCV024
 
     C                   EXSR      SRVCGSPSI
 
      /COPY WNCPYSRC,PMPFDCV025
 
      ** Validate Charge Effective Indicator.
 
      /COPY WNCPYSRC,PMPFDCV026
 
     C                   EXSR      SRVCGEI
 
      /COPY WNCPYSRC,PMPFDCV027
 
      ** Validate Accrual details.
 
      /COPY WNCPYSRC,PMPFDCV028
 
     C                   EXSR      SRVCGAFDN
 
      /COPY WNCPYSRC,PMPFDCV029
 
      ** Validate Charge Stopped Indicator.
 
      /COPY WNCPYSRC,PMPFDCV030
 
     C                   EXSR      SRVCGST
 
      /COPY WNCPYSRC,PMPFDCV031
 
      ** Validate Settlement details.
 
      /COPY WNCPYSRC,PMPFDCV032
 
     C                   EXSR      SRVCGSFDN
 
      /COPY WNCPYSRC,PMPFDCV033
 
      ** Validate Profit Centre.
 
      /COPY WNCPYSRC,PMPFDCV034
 
     C     BKPRCU        IFEQ      'Y'
     C                   EXSR      SRVPRFC
     C                   ENDIF
 
      /COPY WNCPYSRC,PMPFDCV035
 
      ** Update Charges details in screen and file formats and
      ** error arrays.
 
      /COPY WNCPYSRC,PMPFDCV036
 
     C                   Eval      NwChrgScrnArr(WCNTR) = ChrgScrnD
     C                   Eval      NwChrgFileArr(WCNTR) = PMCHRG
     C                   Eval      OKChrgArr(WCNTR) = OKChrgD
 
      /COPY WNCPYSRC,PMPFDCV037
 
     C                   ENDIF
 
      /COPY WNCPYSRC,PMPFDCV038
 
      ** Increment counter for the next record in array.
 
      /COPY WNCPYSRC,PMPFDCV039
 
     C                   ADD       1             WCNTR
 
      /COPY WNCPYSRC,PMPFDCV040
 
     C                   ENDDO
 
      /COPY WNCPYSRC,PMPFDCV041
 
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,PMPFDCV042
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCUSTDET - Retrieve Customer Details                        *
      *                                                               *
      *****************************************************************
      *
     C     SRCUSTDET     BEGSR
      *
      ** Access Customer details.
      *
     C                   MOVEL     DDCSNM        PCNUM
      *
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY'        POPTN             7
     C                   PARM                    PCNUM            10
     C                   PARM      '*CNUM '      PKEY              7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
      ** Database error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     PCNUM         DBKEY
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   Z-ADD     001           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access Customer Portfolio details.
      *
     C                   CALLB     'AOPLCSR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM                    PCNUM
     C     SDPLCS        PARM      SDPLCS        DSSDY
      *
      ** Database error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     PCNUM         DBKEY
     C                   MOVEL     'SDPLCSPD'    DBFILE
     C                   Z-ADD     002           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVBCGY - Routine to validate Bank's Charging Currency       *
      *                                                               *
      *****************************************************************
      *
     C     SRVBCGY       BEGSR
      *
      ** Reset error fields.
      *
     C                   EXSR      SRResetErr
      *
     C                   CALLB     'PMVCHCY'
      *                             =======
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANKS       RETCODEOUT
      *
      ** Portfolio Charges Charging Currency - incoming
     C                   PARM                    DDBCGY
      *
      ** Portfolio Charge Codes Exist indicator
     C                   PARM                    ChrgCodeExist
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Base Currency
     C                   PARM                    BJCYCD
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FLDNAMXAR
     C                   PARM                    MSGIDXAR
     C                   PARM                    MSGDTAXAR
      *
      ** Portfolio Charges Charging Currency - OK indicator
     C                   PARM                    OKBCGY
      *
      ** Portfolio Charges Charging Currency - for file update
     C                   PARM                    P1PNBCGY
      *
      ** Portfolio Charges Charging Currency number of decimal
      ** positions - for file update
     C                   PARM                    P1PNBCGD
      *
      ** Update error information.
      *
     C     RETCODEOUT    IFNE      *BLANKS
     C                   EXSR      SrUpdatErr
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVCUSA - Validate Customer Settlement Account               *
      *                                                               *
      *****************************************************************
      *
     C     SRVCUSA       BEGSR
      *
      ** Reset error fields.
      *
     C                   EXSR      SRResetErr
      *
     C                   CALLB     'PMVCHAC'
      *                             ==========
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANKS       RETCODEOUT
      *
      ** Portfolio Charges Customer Settlement Currency
      ** - incoming
     C                   PARM                    DDCSCY
      *
      ** Portfolio Charges Customer Settlement Account
      ** - incoming
     C                   PARM                    DDCUSA
      *
      ** Portfolio Charges Customer Settlement Branch
      ** - incoming
     C                   PARM                    DDBRCA
      *
      ** SDPLCS - Portfolio Customer's Base Currency
     C                   PARM                    QBCSBY
      *
      ** Portfolio Charge Codes Exist indicator
     C                   PARM                    ChrgCodeExist
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** SDMMOD - Multi-branching Indicator
     C                   PARM                    BGMBIN
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FLDNAMXAR
     C                   PARM                    MSGIDXAR
     C                   PARM                    MSGDTAXAR
      *
      ** Portfolio Charges Customer Settlement Currency
      ** - OK indicator
     C                   PARM                    OKCSCY
      *
      ** Portfolio Charges Customer Settlement Account
      ** - OK indicator
     C                   PARM                    OKCUSA
      *
      ** Portfolio Charges Customer Settlement Branch
      ** - OK indicator
     C                   PARM                    OKBRCA
      *
      ** Portfolio Charges Customer Settlement Currency
      ** - for file update
     C                   PARM                    P1PNCSCY
      *
      ** Portfolio Charges Customer Settlement Currency
      ** number of decimal positions - for file update
     C                   PARM                    P1PNCSDP
      *
      ** Portfolio Charges Customer Settlement Account
      ** - for file update
     C                   PARM                    P1PNCUSA
      *
      ** Portfolio Charges Customer Settlement Branch
      ** - for file update
     C                   PARM                    P1PNCUSB
      *
      ** Update error information.
      *
     C     RETCODEOUT    IFNE      *BLANKS
     C                   EXSR      SrUpdatErr
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBLDCodesArr - Build the Charge Codes array                 *
      *                                                               *
      *****************************************************************
      *
     C     SRBLDCodesArr BEGSR
      *
     C                   Z-ADD     1             WCNTR             2 0
     C                   CLEAR                   ChrgCodeArr
     C                   MOVEL     *ALL'Y'       OKCGArr
     C                   MOVEL     *BLANK        ChrgCodeExist     1
      *
     C     WCNTR         DOUGT     MaxChrgArr
      *
      ** Move Portfolio Charges screen details from array to data
      ** structure.
      *
     C                   CLEAR                   ChrgScrnD
     C                   Eval      ChrgScrnD = NwChrgScrnArr(WCNTR)
      *
      ** Check if Charge Code from file was blanked out.
      *
     C     DDVALD        IFEQ      'Y'
     C     DDCGCO        ANDEQ     *BLANKS
     C     DDCGCH        ANDNE     *BLANKS
     C                   MOVE      'N'           OKCGArr(Wcntr)
     C                   MOVE      DDCGCH        DDCGCO
     C                   Eval      NwChrgScrnArr(WCNTR) = ChrgScrnD
     C                   ENDIF
      *
      ** Write Charge Code to array.
      *
     C                   Eval      ChrgCodeArr(WCNTR) = DDCGCO
      *
      ** If charge code exists, set indicator accordingly.
      *
     C     DDCGCO        IFNE      *BLANKS
     C                   MOVEL     'Y'           ChrgCodeExist
     C                   ENDIF
      *
     C                   ADD       1             WCNTR
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVVALD - Check if any previously inserted charge details    *
      *            were blanked out                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRVVALD       BEGSR
      *
      ** Reset error fields.
      *
     C                   EXSR      SRResetErr
      *
      ** Charge Code
      *
     C     OKCGArr(Wcntr)IFEQ      'N'
     C                   MOVE      'N'           OKCGCO
     C                   ENDIF
      *
      ** Effective Indicator
      *
     C     DDCGEI        IFEQ      *BLANKS
     C     DDCGEH        ANDNE     *BLANKS
     C                   MOVE      'N'           OKCGEI
     C                   MOVE      DDCGEH        DDCGEI
     C                   ENDIF
      *
      ** Accrual Frequency
      *
     C     DDCGFQ        IFEQ      *BLANKS
     C     DDCGFH        ANDNE     *BLANKS
     C                   MOVE      'N'           OKCGFQ
     C                   MOVE      DDCGFH        DDCGFQ
     C                   ENDIF
      *
      ** Accrual Day in Month
      *
     C     DDCGDY        IFEQ      *BLANKS
     C     DDCGDH        ANDNE     *BLANKS
     C     DDCGFQ        ANDNE     'W'
     C     DDCGFQ        ANDNE     'F'
     C                   MOVE      'N'           OKCGDY
     C                   MOVE      DDCGDH        DDCGDY
     C                   ENDIF
      *
      ** Charge Stopped Indicator
      *
     C     DDCGST        IFEQ      *BLANKS
     C     DDCGTH        ANDNE     *BLANKS
     C                   MOVE      'N'           OKCGST
     C                   MOVE      DDCGTH        DDCGST
     C                   ENDIF
      *
      ** Settlement Frequency
      *
     C     DDCSFQ        IFEQ      *BLANKS
     C     DDCSFH        ANDNE     *BLANKS
     C                   MOVE      'N'           OKCSFQ
     C                   MOVE      DDCSFH        DDCSFQ
     C                   ENDIF
      *
      ** Settlement Day in Month
      *
     C     DDCSDY        IFEQ      *BLANKS
     C     DDCSDH        ANDNE     *BLANKS
     C                   MOVE      'N'           OKCSDY
     C                   MOVE      DDCSDH        DDCSDY
     C                   ENDIF
      *
      ** If any of the error indicators were set on, display
      ** message 'Charge details cannot be deleted'.
      *
     C     OKCGCO        IFEQ      'N'
     C     OKCGEI        OREQ      'N'
     C     OKCGFQ        OREQ      'N'
     C     OKCGDY        OREQ      'N'
     C     OKCGST        OREQ      'N'
     C     OKCSFQ        OREQ      'N'
     C     OKCSDY        OREQ      'N'
      *
     C                   EVAL      FldNamXAr(1) = '*ANY'
     C                   EVAL      MsgIdXAr(1)  = 'PM11320'
      *
      ** Update error information.
      *
     C                   EXSR      SrUpdatErr
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVCGCO - Validate Charge Code                               *
      *                                                               *
      *****************************************************************
      *
     C     SRVCGCO       BEGSR
      *
      ** Reset error fields.
      *
     C                   EXSR      SRResetErr
      *
     C                   CALLB     'PMVCHCD'
      *                             =======
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANKS       RETCODEOUT
      *
      ** Portfolio Charges Charge Code - incoming
     C                   PARM                    DDCGCO
      *
      ** Portfolio Charges Hidden Charge Code
     C                   PARM                    DDCGCH
      *
      ** Portfolio Charges Charging Currency - incoming
     C                   PARM                    DDBCGY
      *
      ** Portfolio Charges details - incoming
     C                   PARM                    DDSCRN
      *
      ** New Portfolio Charges details array pointer
     C                   PARM                    WCntr
      *
      ** Charge Codes array
     C                   PARM                    ChrgCodeArr
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FLDNAMXAR
     C                   PARM                    MSGIDXAR
     C                   PARM                    MSGDTAXAR
      *
      ** Portfolio Charges Charge Code - OK indicator
     C                   PARM                    OKCGCO
      *
      ** Portfolio Charges Charge Code - for file update
     C                   PARM                    POCGCO
      *
      ** Portfolio Charges Charge Code - OK indicator2
     C                   PARM                    OKCGCO2           1
      *
      ** Update error information.
      *
     C     RETCODEOUT    IFNE      *BLANKS
     C                   EXSR      SrUpdatErr
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVCGSPSI - Validate Charge Spread and Indicator             *
      *                                                               *
      *****************************************************************
      *
     C     SRVCGSPSI     BEGSR
      *
      ** Reset error fields.
      *
     C                   EXSR      SRResetErr
      *
     C                   CALLB     'PMVSPDE'
      *                             =======
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANKS       RETCODEOUT
      *
      ** Portfolio Charges Charge Spread - incoming
     C                   PARM                    DDCGSP
      *
      ** Portfolio Charges Charge Spread Indicator - incoming
     C                   PARM                    DDCGSI
      *
      ** Portfolio Charges Charge Code - incoming
     C                   PARM                    DDCGCO
      *
      ** Portfolio Charges Charge Code - OK indicator
     C                   PARM                    OKCGCO2
      *
      ** Portfolio Charges Charging Currency - incoming
     C                   PARM                    DDBCGY
      *
      ** Portfolio Charges Charging Currency number of decimal
      ** positions - for file update
     C                   PARM                    P1PNBCGD
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FLDNAMXAR
     C                   PARM                    MSGIDXAR
     C                   PARM                    MSGDTAXAR
      *
      ** Portfolio Charges Charge Spread
      ** - OK indicator
     C                   PARM                    OKCGSP
      *
      ** Portfolio Charges Charge Spread Indicator
      ** - OK indicator
     C                   PARM                    OKCGSI
      *
      ** Portfolio Charges Charge Spread
      ** - for file update
     C                   PARM                    POCGSP
      *
      ** Portfolio Charges Charge Spread Indicator
      ** - for file update
     C                   PARM                    POCGSI
      *
      ** Portfolio Charges Hidden Charge Spread
     C                   PARM                    DDCGSH
      *
      ** Update error information.
      *
     C     RETCODEOUT    IFNE      *BLANKS
     C                   EXSR      SrUpdatErr
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVCGEI - Validate Effective Indicator                       *
      *                                                               *
      *****************************************************************
      *
     C     SRVCGEI       BEGSR
      *
      ** Reset error fields.
      *
     C                   EXSR      SRResetErr
      *
     C                   CALLB     'PMVINCH'
      *                             =======
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANKS       RETCODEOUT
      *
      ** Portfolio Charges Effective Indicator - incoming
     C                   PARM                    DDCGEI
      *
      ** Portfolio Charges Charge Code - incoming
     C                   PARM                    DDCGCO
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FLDNAMXAR
     C                   PARM                    MSGIDXAR
     C                   PARM                    MSGDTAXAR
      *
      ** Portfolio Charges Effective Indicator
      ** - OK indicator
     C                   PARM                    OKCGEI
      ** Portfolio Charges Effective Indicator
      ** - for file update
     C                   PARM                    POCGEI
      *
      ** Portfolio Charges Hidden Effective Indicator
     C                   PARM                    DDCGEH
      *
      ** Update error information.
      *
     C     RETCODEOUT    IFNE      *BLANKS
     C                   EXSR      SrUpdatErr
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVCGAFDN - Validate Accrual Frequency, Day in Month and     *
      *              Next Accrual Date                                *
      *                                                               *
      *****************************************************************
      *
     C     SRVCGAFDN     BEGSR
      *
      ** Reset error fields.
      *
     C                   EXSR      SRResetErr
      *
     C                   CALLB     'PMVARDT'
      *                             =======
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANKS       RETCODEOUT
      *
      ** Portfolio Charges Accrual Frequency
      ** - incoming
     C                   PARM                    DDCGFQ
      *
      ** Portfolio Charges Accrual Day in Month
      ** - incoming
     C                   PARM                    DDCGDY
      *
      ** Portfolio Charges Next Accrual Date
      ** - incoming
     C                   PARM                    DDCGND
      *
      ** Portfolio Charges Charges Code
      ** - incoming
     C                   PARM                    DDCGCO
      *
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Rundate
     C                   PARM                    BJRDNB
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT
      *
      ** SDBANK - Date Format
     C                   PARM                    BJDFIN
      *
      ** SDBANK - Base Currency
     C                   PARM                    BJCYCD
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FLDNAMXAR
     C                   PARM                    MSGIDXAR
     C                   PARM                    MSGDTAXAR
      *
      ** Portfolio Charges Accrual Frequency
      ** - OK indicator
     C                   PARM                    OKCGFQ
      *
      ** Portfolio Charges Accrual Day in Month
      ** - OK indicator
     C                   PARM                    OKCGDY
      *
      ** Portfolio Charges Next Accrual Date
      ** - OK indicator
     C                   PARM                    OKCGND
      *
      ** Portfolio Charges Accrual Frequency
      ** - for file update
     C                   PARM                    POCGFQ
      *
      ** Portfolio Charges Accrual Day in Month
      ** - for file update
     C                   PARM                    POCGDY
      *
      ** Portfolio Charges Next Accrual Date
      ** - for file update
     C                   PARM                    POCGND
      *
      ** Portfolio Charges Hidden Accrual Frequency
     C                   PARM                    DDCGFH
      *
      ** Portfolio Charges Hidden Accrual Day in Month
     C                   PARM                    DDCGDH
      *
      ** Portfolio Charges Hidden Next Accrual Date
     C                   PARM                    DDCGNH
      *
      ** Update error information.
      *
     C     RETCODEOUT    IFNE      *BLANKS
     C                   EXSR      SrUpdatErr
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVCGST - Validate Charge Stopped Indicator                  *
      *                                                               *
      *****************************************************************
      *
     C     SRVCGST       BEGSR
      *
      ** Reset error fields.
      *
     C                   EXSR      SRResetErr
      *
     C                   CALLB     'PMVCHIN'
      *                             =======
      *
      ** Input
      ** =====
      *
      ** Return code
     C                   PARM      *BLANKS       RETCODEOUT
      *
      ** Portfolio Charges Charge Stopped Indicator
      ** - incoming
     C                   PARM                    DDCGST
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FLDNAMXAR
     C                   PARM                    MSGIDXAR
     C                   PARM                    MSGDTAXAR
      *
      ** Portfolio Charges Charge Stopped Indicator
      ** - OK indicator
     C                   PARM                    OKCGST
      *
      ** Portfolio Charges Charge Stopped Indicator
      ** - for file update
     C                   PARM                    POCGST
      *
      ** Portfolio Charges Hidden Charge Stopped Indicator
     C                   PARM                    DDCGTH
      *
      ** Update error information.
      *
     C     RETCODEOUT    IFNE      *BLANKS
     C                   EXSR      SrUpdatErr
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVCGSFDN - Validate Settlement details                      *
      *                                                               *
      *****************************************************************
      *
     C     SRVCGSFDN     BEGSR
      *
      ** Reset error fields.
      *
     C                   EXSR      SRResetErr
      *
     C                   CALLB     'PMVSEDT'
      *                             =======
      *
      ** Input
      ** =====
      *
      ** Return code
     C                   PARM      *BLANKS       RETCODEOUT
      *
      ** Portfolio Charges Settlement Frequency
      ** - incoming
     C                   PARM                    DDCSFQ
      *
      ** Portfolio Charges Settlement Day in Month
      ** - incoming
     C                   PARM                    DDCSDY
      *
      ** Portfolio Charges Next Settlement Date
      ** - incoming
     C                   PARM                    DDCSND
      *
      ** Portfolio Charges Charges Code
      ** - incoming
     C                   PARM                    DDCGCO
      *
      ** Portfolio Charges Accrual Frequency
      ** - incoming
     C                   PARM                    DDCGFQ
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Rundate
     C                   PARM                    BJRDNB
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT
      *
      ** SDBANK - Date Format
     C                   PARM                    BJDFIN
      *
      ** SDBANK - Base Currency
     C                   PARM                    BJCYCD
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FLDNAMXAR
     C                   PARM                    MSGIDXAR
     C                   PARM                    MSGDTAXAR
      *
      ** Portfolio Charges Settlement Frequency
      ** - OK indicator
     C                   PARM                    OKCSFQ
      *
      ** Portfolio Charges Settlement Day in Month
      ** - OK indicator
     C                   PARM                    OKCSDY
      *
      ** Portfolio Charges Next Settlement Date
      ** - OK indicator
     C                   PARM                    OKCSND            1
      *
      ** Portfolio Charges Settlement Frequency
      ** - for file update
     C                   PARM                    POCSFQ
      *
      ** Portfolio Charges Settlement Day in Month
      ** - for file update
     C                   PARM                    POCSDY
      *
      ** Portfolio Charges Next Settlement Date
      ** - for file update
     C                   PARM                    POCSND
      *
      ** Portfolio Charges Hidden Settlement Frequency
     C                   PARM                    DDCSFH
      *
      ** Portfolio Charges Hidden Settlement Day in Month
     C                   PARM                    DDCSDH
      *
      ** Portfolio Charges Hidden Next Settlement Date
     C                   PARM                    DDCSNH
      *
      ** Update error information.
      *
     C     RETCODEOUT    IFNE      *BLANKS
     C                   EXSR      SrUpdatErr
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVPRFC - Validate Profit Centre                             *
      *                                                               *
      *****************************************************************
      *
     C     SRVPRFC       BEGSR
      *
      ** Reset error fields.
      *
     C                   EXSR      SRResetErr
      *
     C                   CALLB     'PMVCHPF'
      *                             =======
      *
      ** Input
      ** =====
      *
      ** Return code
     C                   PARM      *BLANKS       RETCODEOUT
      *
      ** Portfolio Charges Profit Centre
      ** - incoming
     C                   PARM                    DDPFRC
      *
      ** Portfolio Charges Charge Code
      ** - incoming
     C                   PARM                    DDCGCO
      *
      ** SDCUST - Incoming Customer
     C                   PARM                    BBCUST
      *
      ** SDCUST - Branch Code of incoming customer
     C                   PARM                    BBBRCD
      *
      ** SDCUST - Account Officer Code of incoming customer
     C                   PARM                    BBACOC
      *
      ** STANDING DATA
      ** =============
      *
      ** SDGELR - Profit Centre Defaults Used?
     C                   PARM                    BKPCDU
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FLDNAMXAR
     C                   PARM                    MSGIDXAR
     C                   PARM                    MSGDTAXAR
      *
      ** Portfolio Charges Profit Centre
      ** - OK indicator
     C                   PARM                    OKPFRC
      *
      ** Portfolio Charges Profit Centre
      ** - for file update
     C                   PARM                    POPFRC
      *
      ** Portfolio Charges Hidden Profit Centre
     C                   PARM                    DDPRFH
      *
      ** Update error information.
      *
     C     RETCODEOUT    IFNE      *BLANKS
     C                   EXSR      SrUpdatErr
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRResetErr - Routine to reset error information that          *
      *              is received from each validation module          *
      *                                                               *
      *****************************************************************
      *
     C     SRResetErr    BEGSR
      *
     C                   EVAL      RETCODEOUT = *BLANKS
      *
      ** Reset error and warning fields/message IDs/message
      ** data (arrays).
      *
     C                   MOVEL     *BLANKS       FLDNAMXAR
     C                   MOVEL     *BLANKS       MSGIDXAR
     C                   MOVEL     *BLANKS       MSGDTAXAR
      *
     C                   MOVEL     *BLANKS       WFLDNMXAR
     C                   MOVEL     *BLANKS       WMSGIDXAR
     C                   MOVEL     *BLANKS       WMSGDTXAR
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUPDATERR - Routine to update Error Information with that   *
      *               received back from each validation module       *
      *                                                               *
      *****************************************************************
      *
     C     SrUpdatErr    BEGSR
      *
      ** Update error fields/message IDs/message data (arrays).
      *
     C                   Z-ADD     1             Ix                3 0
     C     *BLANK        LOOKUP    FldNameArr(Ix)                         70
     C     *IN70         IFEQ      '1'
     C                   MOVEA     FLDNAMXAR     FldNameArr(Ix)
     C                   MOVEA     MSGIDXAR      MsgIdArr(Ix)
     C                   MOVEA     MSGDTAXAR     MsgDtaArr(Ix)
     C                   ENDIF
      *
      ** Set Error Index.
      *
     C                   Z-ADD     1             Ix
     C     *BLANK        LOOKUP    FLDNAMEARR(Ix)                         70
     C     *IN70         IFEQ      '1'
     C     Ix            SUB       1             IDX
     C                   ELSE
     C                   EVAL      Ix = Arraymax
     C                   MOVE      *BLANKS       FldNameArr(Ix)
     C                   MOVE      *BLANKS       MsgIdArr(Ix)
     C                   MOVE      *BLANKS       MsgDtaArr(Ix)
     C                   EVAL      IDX = Arraymax - 1
     C                   ENDIF
      *
      ** Update warning fields/message IDs/message data (arrays).
      *
     C                   Z-ADD     1             Ix
     C     *BLANK        LOOKUP    WFLDNAMARR(Ix)                         70
     C     *IN70         IFEQ      '1'
     C                   MOVEA     WFLDNMXAR     WFLDNAMARR(Ix)
     C                   MOVEA     WMSGIDXAR     WMSGIDARR(Ix)
     C                   MOVEA     WMSGDTXAR     WMSGDTAARR(Ix)
     C                   ENDIF
      *
      ** Set Warning Index.
      *
     C                   Z-ADD     1             Ix
     C     *BLANK        LOOKUP    WFLDNAMARR(Ix)                         70
     C     *IN70         IFEQ      '1'
     C     Ix            SUB       1             WIDX
     C                   ELSE
     C                   EVAL      Ix = Arraymax
     C                   MOVE      *BLANKS       WFLDNAMARR(Ix)
     C                   MOVE      *BLANKS       WMSGIDARR(Ix)
     C                   MOVE      *BLANKS       WMSGDTAARR(Ix)
     C                   EVAL      WIDX = Arraymax - 1
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Response Mode
      *
     C                   PARM                    PRespMode         1
      *
      ** Customer - incoming
     C                   PARM                    DDCSNM           10
      *
      ** New Portfolio Charges header details - screen format
     C                   PARM                    NwChrgScrnH
      *
      ** New Portfolio Charges details array - screen format
     C                   PARM                    NwChrgScrnArr
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Rundate
     C                   PARM                    BJRDNB            5 0
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT            7
      *
      ** SDBANK - Date Format
     C                   PARM                    BJDFIN            1
      *
      ** SDBANK - Base Currency
     C                   PARM                    BJCYCD            3
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC            3
      *
      ** SDGELR - Profit Centre Used
     C                   PARM                    BKPRCU            1
      *
      ** SDGELR - Profit Centre Defaults Used?
     C                   PARM                    BKPCDU            1
      *
      ** SDMMOD - Multi-branching Indicator
     C                   PARM                    BGMBIN            1
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDX
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFLDNAMARR
     C                   PARM                    WMSGIDARR
     C                   PARM                    WMSGDTAARR
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIDX
      *
      ** Error indicators - charges header
     C                   PARM                    OkChrg
      *
      ** Error indicators array - charges details
     C                   PARM                    OkChrgArr
      *
      ** Portfolio Definition Details - for file update
     C                   PARM                    NwDfFilFMt
      *
      ** Charges details array - for file update
     C                   PARM                    NwChrgFileArr
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
      ** Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,PMPFDCV043
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2001
