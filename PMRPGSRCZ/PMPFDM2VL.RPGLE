     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas PM Portfolio Definition Validation Control')
      *****************************************************************
      *                                                               *
      *  Midas - Portfolio Management Module                          *
      *                                                               *
      *  PMPFDM2VL  - Portfolio Definition Validation Control         *
      *                                                               *
      *  Function: This module validates Portfolio Definition         *
      *            fields for input into the Midas database.          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CPB002             Date 13Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP033  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
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
      /COPY WNCPYSRC,PMPFDMV001
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
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Incoming Portfolio Definition Details - screen format
     D PTRANSIN      E DS                  EXTNAME(PMPFDMPD)
     D   PDDSTMTS0S9          77     86
      *
      ** Portfolio Definition Fields OK indicators
     D POKPORT       E DS                  EXTNAME(PMEPFDMPD)
     D   POKSTMTS0S9          17     26
      *
      ** Valid Portfolio Definition Details - for file update
     D PVALIDPORT    E DS                  EXTNAME(PMVPFDMPD)
     D  PP1PNSTMTS1S8         71     78
      *
      ** Incoming Extra Data
     D PExtData      E DS                  EXTNAME(PMPFEXPD)
      *
      ** DS for Access Programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** The Investment Policy Indicators are input-capable only
      ** on the Screen Input (*SIN) function:
      ** - (DDIPIN) Instrument Investment Policy Indicator
      ** - (DDCYIN) Currency Investment Policy Indicator
      ** - (DDYPIN) Country of Risk Investment Policy Indicator
      ** - (DDNPIN) Industry Investment Policy Indicator
      *
      ** Investment Policy Indicators from incoming transaction
     D PINVESTINDS     DS             4
     D   DDIPIN                1      1
     D   DDCYIN                2      2
     D   DDYPIN                3      3
     D   DDNPIN                4      4
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
      /COPY WNCPYSRC,PMPFDMV002
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
      /COPY WNCPYSRC,PMPFDMV003
 
      ** Validate Date Closed.
 
      /COPY WNCPYSRC,PMPFDMV004
 
     C                   EXSR      SRVDPCL
 
      /COPY WNCPYSRC,PMPFDMV005
 
      ** Bypass remaining validation if action code is Closure.
 
      /COPY WNCPYSRC,PMPFDMV006
 
     C     DDACTN        IFEQ      'C'
     C                   RETURN
     C                   ENDIF
 
      /COPY WNCPYSRC,PMPFDMV007
 
      ** Validate Portfolio Currency.
 
      /COPY WNCPYSRC,PMPFDMV008
 
     C                   EXSR      SRVPTCY
 
      /COPY WNCPYSRC,PMPFDMV009
 
      ** Validate Portfolio Narrative.
 
      /COPY WNCPYSRC,PMPFDMV010
 
     C                   EXSR      SRVPTFN
 
      /COPY WNCPYSRC,PMPFDMV011
 
      ** Validate Portfolio Type only if customer is a PM Customer.
 
      /COPY WNCPYSRC,PMPFDMV012
 
     C     PMCUST        IFEQ      'Y'
     C                   EXSR      SRVPTFT
     C                   ENDIF
 
      /COPY WNCPYSRC,PMPFDMV013
 
      ** Validate Portfolio Safe Custody Fee Group Code.
 
      /COPY WNCPYSRC,PMPFDMV014
 
     C     S01464        IFEQ      'Y'
     C     FBFGCP        ANDEQ     'Y'
      *
     C                   EXSR      SRVCFGC
     C                   ENDIF
 
      /COPY WNCPYSRC,PMPFDMV015
 
      ** Validate Portfolio Managed Indicator only if customer is
      ** a PM Customer.
 
      /COPY WNCPYSRC,PMPFDMV016
 
     C     PMCUST        IFEQ      'Y'
     C                   EXSR      SRVMNGI
     C                   ENDIF
 
      /COPY WNCPYSRC,PMPFDMV017
 
      ** Validate Portfolio FF Margin Account Sequence.
 
      /COPY WNCPYSRC,PMPFDMV018
 
     C     BGFUOP        IFEQ      'Y'
     C                   EXSR      SRVACSQ
     C                   ENDIF
 
      /COPY WNCPYSRC,PMPFDMV019
 
      ** Validate Pledge Start and Finish Dates only if
      ** Portfolio Lending and customer is a PM Customer.
 
      /COPY WNCPYSRC,PMPFDMV020
 
     C     BGLMCR        IFEQ      'N'
     C     PMCUST        ANDEQ     'Y'
     C                   EXSR      SRVPLEDGED
     C                   ENDIF
 
      /COPY WNCPYSRC,PMPFDMV021
 
      ** Validate Profit Centre.
 
      /COPY WNCPYSRC,PMPFDMV022
 
     C     CAC003        IFEQ      'Y'
     C     BGN0ST        ANDEQ     'Y'
     C                   EXSR      SRVPRF2
     C                   ENDIF
 
      /COPY WNCPYSRC,PMPFDMV023
 
      ** Continue validating other fields if customer is PM Customer.
 
     C     PMCUST        IFEQ      'Y'
 
      ** Validate Valuation Frequency, Day in Month and
      ** Next Valuation Date.
 
      /COPY WNCPYSRC,PMPFDMV024
 
     C                   EXSR      SRVVALDATE
 
      /COPY WNCPYSRC,PMPFDMV025
 
      ** Validate Valuation Statement Section Indicators.
 
      /COPY WNCPYSRC,PMPFDMV026
 
     C                   EXSR      SRVVALSTMT
 
      /COPY WNCPYSRC,PMPFDMV027
 
      ** Validate Performance Report Requirements.
 
      /COPY WNCPYSRC,PMPFDMV028
 
     C                   EXSR      SRVPERFORM
 
      /COPY WNCPYSRC,PMPFDMV029
 
      ** Validate Cashflow Frequency, Day in Month and
      ** Next Report Date.
 
      /COPY WNCPYSRC,PMPFDMV030
 
     C                   EXSR      SRVCSHFLOW
 
      /COPY WNCPYSRC,PMPFDMV031
 
      ** Validate:
      ** - Portfolio Bank Investment Policy Code
      ** - Instrument Investment Policy Indicator
      ** - Currency Investment Policy Indicator
      ** - Country of Risk Investment Policy Indicator
      ** - Industry Investment Policy Indicator.
 
      /COPY WNCPYSRC,PMPFDMV032
 
     C                   EXSR      SRVINVEST
 
     C                   ENDIF
 
      /COPY WNCPYSRC,PMPFDMV033
 
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,PMPFDMV034
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVDPCL - Routine to validate Date Closed                    *
      *                                                               *
      *****************************************************************
      *
     C     SRVDPCL       BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRRESETERR
      *
     C                   CALLB     'PMVPODT'
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RETCODEOUT
      *
      ** Date Portfolio Closed - incoming
     C                   PARM                    DDDPCL
      *
      ** Action Code - incoming
     C                   PARM                    DDACTN
      *
      ** Original Date Opened
      ** - for insert, rundate
      ** - for other action codes, value retrieved from file
     C                   PARM                    OP1PNDPOP
      *
      ** Original Pledge Finish Date
     C                   PARM                    OP1PNPDGF
      *
      ** Customer Number - incoming
     C                   PARM                    DDCSNM
      *
      ** Portfolio Reference - incoming
     C                   PARM                    DDPREF
      *
      ** SDCUST - Branch Code of incoming customer
     C                   PARM                    BBBRCD
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
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FLDNAMXAR
     C                   PARM                    MSGIDXAR
     C                   PARM                    MSGDTAXAR
      *
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFLDNMXAR
     C                   PARM                    WMSGIDXAR
     C                   PARM                    WMSGDTXAR
      *
      ** Portfolio Date Closed - OK indicator
     C                   PARM                    OKDPCL
      *
      ** Portfolio Date Closed - for file update
     C                   PARM                    P1PNDPCL
      *
      ** Update error information.
      *
     C                   EXSR      SRUPDATERR
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVPTCY - Routine to validate Portfolio Currency             *
      *                                                               *
      *****************************************************************
      *
     C     SRVPTCY       BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRRESETERR
      *
     C                   CALLB     'PMVPOCY'
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RETCODEOUT
      *
      ** Portfolio Currency - incoming
     C                   PARM                    DDPTCY
      *
      ** SDPLCS - Portfolio Customer's Base Currency
     C                   PARM                    QBCSBY
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*SIN  ' (SCREEN INPUT function)
     C                   PARM                    PMODE
      *
      ** Portfolio Management Customer flag
     C                   PARM                    PMCUST
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FLDNAMXAR
     C                   PARM                    MSGIDXAR
     C                   PARM                    MSGDTAXAR
      *
      ** Portfolio Currency - OK indicator
     C                   PARM                    OKPTCY
      *
      ** Portfolio Currency - for file update
     C                   PARM                    P1PNPTCY
      *
      ** Portfolio Currency decimal position - for file update
     C                   PARM                    P1PNPCDP
      *
      ** Update error information.
      *
     C                   EXSR      SRUPDATERR
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVPTFN - Routine to validate the Portfolio Narrative        *
      *                                                               *
      *****************************************************************
      *
     C     SRVPTFN       BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRRESETERR
      *
     C                   CALLB     'PMVPONA'
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RETCODEOUT
      *
      ** Portfolio Narrative - incoming
     C                   PARM                    DDPTFN
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FLDNAMXAR
     C                   PARM                    MSGIDXAR
     C                   PARM                    MSGDTAXAR
      *
      ** Portfolio Narrative - OK indicator
     C                   PARM                    OKPTFN
      *
      ** Portfolio Narrative - for file update
     C                   PARM                    P1PNPTFN
      *
      ** Update Error Information.
      *
     C                   EXSR      SRUPDATERR
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVPTFT - Routine to validate Portfolio Type                 *
      *                                                               *
      *****************************************************************
      *
     C     SRVPTFT       BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRRESETERR
      *
     C                   CALLB     'PMVPOTY'
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RETCODEOUT
      *
      ** Portfolio Type - incoming
     C                   PARM                    DDPTFT
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FLDNAMXAR
     C                   PARM                    MSGIDXAR
     C                   PARM                    MSGDTAXAR
      *
      ** Portfolio Type - OK indicator
     C                   PARM                    OKPTFT
      *
      ** Portfolio Type - for file update
     C                   PARM                    P1PNPTFT
      *
      ** Update error information.
      *
     C                   EXSR      SRUPDATERR
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVCFGC - Routine to validate Portfolio Safe Custody Fee     *
      *            Group Code                                         *
      *                                                               *
      *****************************************************************
      *
     C     SRVCFGC       BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRRESETERR
      *
     C                   CALLB     'PMVGPCD'
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RETCODEOUT
      *
      ** Portfolio Safe Custody Group Code - incoming
     C                   PARM                    DDCFGC
      *
      ** Customer - incoming
     C                   PARM                    DDCSNM
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FLDNAMXAR
     C                   PARM                    MSGIDXAR
     C                   PARM                    MSGDTAXAR
      *
      ** Portfolio Safe Custody Group Code - OK indicator
     C                   PARM                    OKCFGC
      *
      ** Portfolio Safe Custody Group Code - for file update
     C                   PARM                    P1PNCFGC
      *
      ** Update error information.
      *
     C                   EXSR      SRUPDATERR
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVMNGI - Routine to validate Portfolio Managed Indicator    *
      *                                                               *
      *****************************************************************
      *
     C     SRVMNGI       BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRRESETERR
      *
     C                   CALLB     'PMVPOIN'
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RETCODEOUT
      *
      ** Portfolio Managed Indicator - incoming
     C                   PARM                    DDMNGI
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FLDNAMXAR
     C                   PARM                    MSGIDXAR
     C                   PARM                    MSGDTAXAR
      *
      ** Portfolio Managed Indicator - OK indicator
     C                   PARM                    OKMNGI
      *
      ** Portfolio Managed Indicator - for file update
     C                   PARM                    P1PNMNGI
      *
      ** Update error information.
      *
     C                   EXSR      SRUPDATERR
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVACSQ - Routine to validate Portfolio FF Margin Account    *
      *            Sequence                                           *
      *                                                               *
      *****************************************************************
      *
     C     SRVACSQ       BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRRESETERR
      *
     C                   CALLB     'PMVMGSQ'
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RETCODEOUT
      *
      ** Portfolio FF Margin Account Sequence - incoming
     C                   PARM                    DDACSQ
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FLDNAMXAR
     C                   PARM                    MSGIDXAR
     C                   PARM                    MSGDTAXAR
      *
      ** Portfolio FF Margin Account Sequence - OK indicator
     C                   PARM                    OKACSQ
      *
      ** Portfolio FF Margin Account Sequence - for file update
     C                   PARM                    P1PNACSQ
      *
      ** Update error information.
      *
     C                   EXSR      SRUPDATERR
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVPLEDGED - Routine to Validate Pledge Start and Finish     *
      *               Dates                                           *
      *                                                               *
      *****************************************************************
      *
     C     SRVPLEDGED    BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRRESETERR
      *
     C                   CALLB     'PMVPLPL'
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RETCODEOUT
      *
      ** Portfolio Pledge Start Date - incoming
     C                   PARM                    DDPDGS
      *
      ** Portfolio Pledge Finish Date - incoming
     C                   PARM                    DDPDGF
      *
      ** Original Date Opened
      ** - for insert, rundate
      ** - for other action codes, value retrieved from file
     C                   PARM                    OP1PNDPOP
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Date Format
     C                   PARM                    BJDFIN
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FLDNAMXAR
     C                   PARM                    MSGIDXAR
     C                   PARM                    MSGDTAXAR
      *
      ** Portfolio Pledge Start Date - OK indicator
     C                   PARM                    OKPDGS
      *
      ** Portfolio Pledge Finish Date - OK indicator
     C                   PARM                    OKPDGF
      *
      ** Portfolio Pledge Start Date - for file update
     C                   PARM                    P1PNPDGS
      *
      ** Portfolio Pledge Finish Date - for file update
     C                   PARM                    P1PNPDGF          5 0
      *
      ** Update error information.
      *
     C                   EXSR      SRUPDATERR
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVPRF2 - Routine to validate the Portfolio Profit Centre    *
      *                                                               *
      *****************************************************************
      *
     C     SRVPRF2       BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRRESETERR
      *
     C                   CALLB     'PMVPFPF'
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RETCODEOUT
      *
      ** Portfolio Profit Centre - incoming
     C                   PARM                    DDPRF2
      *
      ** Customer - incoming
     C                   PARM                    DDCSNM
      *
      ** SDCUST - Branch Code of incoming customer
     C                   PARM                    BBBRCD
      *
      ** SDCUST - Account Officer Code of incoming customer
     C                   PARM                    BBACOC
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*SIN  ' (SCREEN INPUT function)
     C                   PARM                    PMODE
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
      ** Portfolio Profit Centre - OK indicator
     C                   PARM                    OKPRF2
      *
      ** Portfolio Profit Centre - for file update
     C                   PARM                    P1PNPRFC
      *
      ** Update error information.
      *
     C                   EXSR      SRUPDATERR
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVVALDATE - Routine to validate Portfolio Valuation         *
      *               Frequency, Day in Month and Next Valuation Date *
      *                                                               *
      *****************************************************************
      *
     C     SRVVALDATE    BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRRESETERR
      *
     C                   CALLB     'PMVVLDT'
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RETCODEOUT
      ** Portfolio Valuation Frequency - incoming
     C                   PARM                    DDVLFQ
      *
      ** Portfolio Valuation Day in Month - incoming
     C                   PARM                    DDVLDM
      *
      ** Portfolio Next Valuation Date - incoming
     C                   PARM                    DDVLND
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
      ** SDBANK - Local Currency Code
     C                   PARM                    BJLCCY
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FLDNAMXAR
     C                   PARM                    MSGIDXAR
     C                   PARM                    MSGDTAXAR
      *
      ** Portfolio Valuation Frequency - OK indicator
     C                   PARM                    OKVLFQ
      *
      ** Portfolio Valuation Day in Month - OK indicator
     C                   PARM                    OKVLDM
      *
      ** Portfolio Next Valuation Date - OK indicator
     C                   PARM                    OKVLND
      *
      ** Portfolio Valuation Frequency - for file update
     C                   PARM                    P1PNVLFQ
      *
      ** Portfolio Valuation Day in Month - for file update
     C                   PARM                    P1PNVLDM
      *
      ** Portfolio Next Valuation Date - for file update
     C                   PARM                    P1PNVLND
      *
      ** Update error information.
      *
     C                   EXSR      SRUPDATERR
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVVALSTMT - Routine to validate Portfolio Valuation         *
      *               Statement Section Indicators                    *
      *                                                               *
      *****************************************************************
      *
     C     SRVVALSTMT    BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRRESETERR
      *
     C                   CALLB     'PMVVLSM'
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RETCODEOUT
      *
      ** Portfolio Valuation Statement Section Indicators S0-S9
      ** - incoming
     C                   PARM                    PDDSTMTS0S9
      *
      ** Portfolio Valuation Frequency - incoming
     C                   PARM                    DDVLFQ
      *
      ** Portfolio Valuation Day in Month - incoming
     C                   PARM                    DDVLDM
      *
      ** Portfolio Next Valuation Date - incoming
     C                   PARM                    DDVLND
      *
      ** Portfolio Report Past Year Performance - incoming
     C                   PARM                    DDRPYP
      *
      ** Portfolio Tax Year Start Month - incoming
     C                   PARM                    DDTYSM
      *
      ** Portfolio Additional Performance Period - incoming
     C                   PARM                    DDADPP
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FLDNAMXAR
     C                   PARM                    MSGIDXAR
     C                   PARM                    MSGDTAXAR
      *
      ** Portfolio Valuation Statement Section Indicators S0-S9
      ** - OK indicators
     C                   PARM                    POKSTMTS0S9
      *
      ** Portfolio Instrument Summary Section (S9) - for file update
     C                   PARM                    P1PNS9VR
      *
      ** Portfolio Currency Summary Section (S0) - for file update
     C                   PARM                    P1PNS0VR
      *
      ** Portfolio Valuation Statement Section Indicators S1-S8
      ** - for file update
     C                   PARM                    PP1PNSTMTS1S8
      *
      ** Update error information.
      *
     C                   EXSR      SRUPDATERR
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVPERFORM - Routine to validate Portfolio Performance       *
      *               Report Requirements                             *
      *                                                               *
      *****************************************************************
      *
     C     SRVPERFORM    BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRRESETERR
      *
     C                   CALLB     'PMVREDE'
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RETCODEOUT
      *
      ** Portfolio Report Past Year Performance - incoming
     C                   PARM                    DDRPYP
      *
      ** Portfolio Tax Year Start Month - incoming
     C                   PARM                    DDTYSM
      *
      ** Portfolio Additional Performance Period - incoming
     C                   PARM                    DDADPP
      *
      ** Portfolio Performance Start Date - incoming
     C                   PARM                    DDPSDT
      *
      ** Portfolio Performance Net/Gross of Tax - incoming
     C                   PARM                    DDPMNG
      *
      ** Action Code - incoming
     C                   PARM                    DDACTN
      *
      ** Customer - incoming
     C                   PARM                    DDCSNM
      *
      ** Portfolio Reference - incoming
     C                   PARM                    DDPREF
      *
      ** Original Performance Start Date
     C                   PARM                    OP1PNPSDT
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
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FLDNAMXAR
     C                   PARM                    MSGIDXAR
     C                   PARM                    MSGDTAXAR
      *
      ** Portfolio Report Past Year Performance - OK indicator
     C                   PARM                    OKRPYP
      *
      ** Portfolio Tax Year Start Month - OK indicator
     C                   PARM                    OKTYSM
      *
      ** Portfolio Additional Performance Period - OK indicator
     C                   PARM                    OKADPP
      *
      ** Portfolio Performance Start Date - OK indicator
     C                   PARM                    OKPSDT
      *
      ** Portfolio Performance Net/Gross of Tax - OK indicator
     C                   PARM                    OKPMNG
      *
      ** Portfolio Report Past Year Performance - for file update
     C                   PARM                    P1PNRPYP
      *
      ** Portfolio Tax Year Start Month - for file update
     C                   PARM                    P1PNTYSM
      *
      ** Portfolio Additional Performance Period - for file update
     C                   PARM                    P1PNADPP
      *
      ** Portfolio Performance Start Date - for file update
     C                   PARM                    P1PNPSDT
      *
      ** Portfolio Performance Net/Gross of Tax - for file update
     C                   PARM                    P1PNPMNG
      *
      ** Update error information.
      *
     C                   EXSR      SRUPDATERR
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVCSHFLOW - Routine to validate Cashflow Frequency, Day in  *
      *               Month and Next Report Date.                     *
      *                                                               *
      *****************************************************************
      *
     C     SRVCSHFLOW    BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRRESETERR
      *
     C                   CALLB     'PMVCFFQ'
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RETCODEOUT
      *
      ** Portfolio Cashflow Frequency - incoming
     C                   PARM                    DDCASF
      *
      ** Portfolio Cashflow Day in Month - incoming
     C                   PARM                    DDCASD
      *
      ** Portfolio Next Report Date - incoming
     C                   PARM                    DDCASN
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
      ** SDBANK - Local Currency Code
     C                   PARM                    BJLCCY
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FLDNAMXAR
     C                   PARM                    MSGIDXAR
     C                   PARM                    MSGDTAXAR
      *
      ** Portfolio Cashflow Frequency - OK indicator
     C                   PARM                    OKCASF
      *
      ** Portfolio Cashflow Day in Month - OK indicator
     C                   PARM                    OKCASD
      *
      ** Portfolio Next Report Date - OK indicator
     C                   PARM                    OKCASN
      *
      ** Portfolio Cashflow Frequency - for file update
     C                   PARM                    P1PNCASF
      *
      ** Portfolio Cashflow Day in Month - for file update
     C                   PARM                    P1PNCASD
      *
      ** Portfolio Next Report Date - for file update
     C                   PARM                    P1PNCASN
      *
      ** Update error information.
      *
     C                   EXSR      SRUPDATERR
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVINVEST - Validate Portfolio Investment Policy Code and    *
      *              Indicators                                       *
      *                                                               *
      *****************************************************************
      *
     C     SRVINVEST     BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRRESETERR
      *
     C                   CALLB     'PMVIVCD'
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RETCODEOUT
      *
      ** Portfolio Bank Investment Policy Code - incoming
     C                   PARM                    DDPOLC
      *
      ** Portfolio Instrument Investment Policy Indicator - incoming
     C                   PARM                    DDIPIN
      *
      ** Portfolio Currency Investment Policy Indicator - incoming
     C                   PARM                    DDCYIN
      *
      ** Portfolio Country of Risk Investment Policy Indicator - incoming
     C                   PARM                    DDYPIN
      *
      ** Portfolio Industry Investment Policy Indicator - incoming
     C                   PARM                    DDNPIN
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FLDNAMXAR
     C                   PARM                    MSGIDXAR
     C                   PARM                    MSGDTAXAR
      *
      ** Portfolio Bank Investment Policy Code - OK indicator
     C                   PARM                    OKPOLC
      *
      ** Portfolio Instrument Investment Policy Indicator - OK indicator
     C                   PARM                    OKIPIN
      *
      ** Portfolio Currency Investment Policy Indicator - OK indicator
     C                   PARM                    OKCYIN
      *
      ** Portfolio Country of Risk Investment Policy Indicator - OK indicator
     C                   PARM                    OKYPIN
      *
      ** Portfolio Industry Investment Policy Indicator - OK indicator
     C                   PARM                    OKNPIN
      *
      ** Portfolio Bank Investment Policy Code - for file update
     C                   PARM                    P1PNPOLC
      *
      ** Portfolio Instrument Investment Policy Indicator - for file update
     C                   PARM                    P1PNIPIN
      *
      ** Portfolio Currency Investment Policy Indicator - for file update
     C                   PARM                    P1PNCYIN
      *
      ** Portfolio Country of Risk Investment Policy Indicator - for file update
     C                   PARM                    P1PNYPIN
      *
      ** Portfolio Industry Investment Policy Indicator - for file update
     C                   PARM                    P1PNNPIN
      *
      ** Update error information.
      *
     C                   EXSR      SRUPDATERR
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRESETERR - Routine to reset Error Information that is      *
      *               received from each validation module            *
      *                                                               *
      *****************************************************************
      *
     C     SRRESETERR    BEGSR
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
     C     SRUPDATERR    BEGSR
      *
      ** Update error fields/message IDs/message data (arrays).
      *
     C                   Z-ADD     1             I                 3 0
     C     *BLANK        LOOKUP    FLDNAMEARR(I)                          70
     C     *IN70         IFEQ      '1'
     C                   MOVEA     FLDNAMXAR     FLDNAMEARR(I)
     C                   MOVEA     MSGIDXAR      MSGIDARR(I)
     C                   MOVEA     MSGDTAXAR     MSGDTAARR(I)
     C                   ENDIF
      *
      ** Set Error Index.
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FLDNAMEARR(I)                          70
     C     *IN70         IFEQ      '1'
     C     I             SUB       1             IDX
     C                   ELSE
     C                   EVAL      I = ArrayMax
     C                   MOVE      *BLANKS       FLDNAMEARR(I)
     C                   MOVE      *BLANKS       MSGIDARR(I)
     C                   MOVE      *BLANKS       MSGDTAARR(I)
     C                   Eval      IDX = ArrayMax - 1
     C                   ENDIF
      *
      ** Update warning fields/message IDs/message data (arrays).
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFLDNAMARR(I)                          70
     C     *IN70         IFEQ      '1'
     C                   MOVEA     WFLDNMXAR     WFLDNAMARR(I)
     C                   MOVEA     WMSGIDXAR     WMSGIDARR(I)
     C                   MOVEA     WMSGDTXAR     WMSGDTAARR(I)
     C                   ENDIF
      *
      ** Set Warning Index.
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFLDNAMARR(I)                          70
     C     *IN70         IFEQ      '1'
     C     I             SUB       1             WIDX
     C                   ELSE
     C                   EVAL      I = ArrayMax
     C                   MOVE      *BLANKS       WFLDNAMARR(I)
     C                   MOVE      *BLANKS       WMSGIDARR(I)
     C                   MOVE      *BLANKS       WMSGDTAARR(I)
     C                   Eval      WIDX = ArrayMax - 1
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
     C                   PARM                    PRESPMODE         1
      *
      ** Incoming Portfolio Definition Details - screen format
     C                   PARM                    PTRANSIN
      *
      ** Investment Policy Indicators from incoming transaction
      ** - For *CTL function, the values are the same as those
      **   kept on file.
     C                   PARM                    PInvestInds
      *
      ** Incoming Extra Data
     C                   PARM                    PExtData
      *
      ** Original Date Opened
      ** - for insert, rundate
      ** - for other action codes, value retrieved from file
     C                   PARM                    OP1PNDPOP         5 0
      *
      ** Original Performance Start Date
     C                   PARM                    OP1PNPSDT         5 0
      *
      ** Original Pledge Finish Date
     C                   PARM                    OP1PNPDGF         5 0
      *
      ** SDPLCS - Portfolio Customer's Base Currency
     C                   PARM                    QBCSBY            3
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*SIN  ' (SCREEN INPUT function)
     C                   PARM                    PMODE             6
      *
      ** Portfolio Management Customer flag
     C                   PARM                    PMCUST            1
      *
      ** SDCUST - Branch Code of incoming customer
     C                   PARM                    BBBRCD            3
      *
      ** SDCUST - Account Officer Code of incoming customer
     C                   PARM                    BBACOC            2
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
      ** SDBANK - Local Currency Code
     C                   PARM                    BJLCCY            3
      *
      ** SDGELR - Profit Centre Defaults Used?
     C                   PARM                    BKPCDU            1
      *
      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST            1
      *
      ** SDMMOD - Future & Options
     C                   PARM                    BGFUOP            1
      *
      ** SDMMOD - Portfolio Lending
     C                   PARM                    BGLMCR            1
      *
      ** SDSCFE - Custody Fees Group for Portfolio
     C                   PARM                    FBFGCP            1
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Safe Custody Fees feature
     C                   PARM                    S01464            1
      *
      ** Profit Centre feature
     C                   PARM                    CAC003            1
      *
      ** OUTPUT
      ** ======
      *
      ** Portfolio Definition Fields OK indicators
     C                   PARM                    POKPORT
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FLDNAMEARR
     C                   PARM                    MSGIDARR
     C                   PARM                    MSGDTAARR
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
      ** Valid Portfolio Definition Details - for file update
     C                   PARM                    PVALIDPORT
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
      ** Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,PMPFDMV035
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
