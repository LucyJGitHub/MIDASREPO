     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM NA's Purchased post settlement validation')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMNASPVLP - NAs Bought (purchased) Post Settlement Validation*
      *                                                               *
      *  Function: This Program Processes Post Settlement Detail      *
      *            NASP date validation                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. 256564             Date 17Sep08               *
      *  Prev Amend No. 249967             Date 13Sep07               *
      *                 BUG12893A          Date 28Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 11Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 BUG11552           Date 22Jun06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG9711            Date 26Jan06               *
      *                 BUG8236            Date 06Sep05               *
      *                 CAP086             Date 08Jun05               *
      *                 CDL038             Date 10May05               *
      *                 BUG6979            Date 04May05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3992            Date 12Nov04               *
      *                 BUG3992  *CREATE   Date 01Oct04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  249967 - Restrict validation of VDAT to insert               *
      *  BUG12893A- Start/Last Int Date must not be entered for a     *
      *             a deal type not eq to 'C2','BP','BD'.(Recompile)  *
      *             Additional delivery for BUG12983.                 *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG11552 - Error message appears twice                       *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG9711- Changes to MMVNASPPD/MMVNASSPD (re-compile)         *
      *  BUG8236 - Negotiable Assets Purchased field validations      *
      *            and Contingent Delivery amount and Expiry time     *
      *            error message validation in Options                *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  CDL038 - Extended Deal Sub Type                              *
      *  BUG6979 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3992- Re-open - Suppress duplicate error messages.        *
      *           Some may already have been sent bu MMNASPVAL.       *
      *  BUG3992- New program based on MMNASPVAL to perform post      *
      *           settlement detail validation. Revalidate dates.     *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,MMNSPVP001
 
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
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
 
     D/COPY ZACPYSRC,PROCPARMS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
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
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
      *
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
     D QQACC1        E                     EXTFLD(QQACCD)
      ** EXTERNAL DS FOR DEALING DETAILS
 
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
     D QQACC2        E                     EXTFLD(QQACCD)
      ** EXTERNAL DS FOR Trading Data
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
      *
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      **  Data structure for Portfolio Management ICD File
 
     D SDPCAC        E DS                  EXTNAME(SDPCACPD)
      **  Data structure for Profit Centre Accounting ICD File
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D SDDLST        E DS                  EXTNAME(SDDLSTPD)
      ** EXTERNAL DS FOR DEAL SUBTYPE DETAILS
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External data structure for currency details
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** External data structure for branch details
 
     D SDBROK        E DS                  EXTNAME(SDBROKPD)
      ** External data structure for broker details
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D QQDFC1        E                     EXTFLD(QQDFAC)
      ** External data structure for customer details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
     D ValidDeal     E DS                  EXTNAME(MMVNASPPD)
      * Valid Deals layout
 
     D ZMUSER          DS            17
     D  ZUSER                  1     10
     D  BRC                   11     13
     D  DEPT                  14     16
 
     D TranIn        E DS                  EXTNAME(MMNASPPD)
      * Incoming Transaction
 
     D ExtData       E DS                  EXTNAME(MMNPEXPD)
      * MM Extra Data - File (D/B) format
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      ** 24X7 status dataarea
 
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** SD data area
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message fields received as parameters
     D     Msg1        S                   LIKE(#MsgID)
     D     Msg2        S                   LIKE(#MsgID)
     D     Msg3        S                   LIKE(#MsgID)
     D     Msg4        S                   LIKE(#MsgID)
     D     Msg5        S                   LIKE(#MsgID)
     D     Msg6        S                   LIKE(#MsgID)
     D     Msg7        S                   LIKE(#MsgID)
 
      ** Warning error message fields received as parameters
     D     WMSGID1     S                   LIKE(#MsgID)
     D     WMSGID2     S                   LIKE(#MsgID)
     D     WMSGID3     S                   LIKE(#MsgID)
     D     WMSGID4     S                   LIKE(#MsgID)
     D     WMSGID5     S                   LIKE(#MsgID)
 
      ** Error message substitution data received as a parameter
     D MSGDATA         S                   LIKE(#MsgData)
     D MSGDATA2        S                   LIKE(#MsgData)
     D MSGDATA3        S                   LIKE(#MsgData)
     D MSGDATA4        S                   LIKE(#MsgData)
 
      ** Warning message substitution data received as a parameter
     D WMSGDATA        S                   LIKE(#MsgData)
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
      ** Flags to indicate whether transaction fields are valid
      ** These have been declared for all MM0026D2 fields, some may not
      **  actually be needed if the field is not used/not validated
     D OKFlagsDS       DS
 
     D  DDActnOK                      1A
     D  DDDlnoOK                      1A
     D  DDMtypOK                      1A
     D  DDStypOK                      1A
     D  DDFedFOK                      1A
     D  DDDlDtOK                      1A
     D  DDBrCAOK                      1A
     D  DDBkCdOK                      1A
     D  DDBrkgOK                      1A
     D  DDIsurOK                      1A
     D  DDCsnmOK                      1A
     D  DDVDatOK                      1A
     D  DDMDatOK                      1A
     D  DDAcSqOK                      1A
     D  DDCcyOK                       1A
     D  DDFvalOK                      1A
     D  DDAmnpOK                      1A
     D  DDBokCOK                      1A
     D  DDLnkNOK                      1A
     D  DDBdidOK                      1A
     D  DDINTROK                      1A
     D  DDICMtOK                      1A
     D  DDIPFqOK                      1A
     D  DDNDatOK                      1A
     D  DDSlidOK                      1A
     D  DDDCRTOK                      1A
     D  DDIPDMOK                      1A
     D  DDmttiOK                      1A
     D  DDBRatOK                      1A
     D  DDCDRfOK                      1A
     D  DDRDFCOK                      1A
     D  DDPcliOK                      1A
     D  DDPSzeOK                      1A
     D  DDOrBrOK                      1A
     D  DDPrfCOK                      1A
     D  DDFsrpOK                      1A
     D  DDFprcOK                      1A
     D  DDOylcOK                      1A
     D  DDLQPROK                      1A
     D  DDLQPSOK                      1A
     D  DDClasOK                      1A                                                      CDL038
 
      ** Flags to indicate if combinations of transaction fields are valid
     D  DDDltStpOK                    1A
 
      ** Field used to initialise 'transaction field valid' fields
      ** These are passed from/to the controller and initialised fields
      ** cannot be on a parameter list
     D*FieldOKInz      C                   CONST('Y')
 
      ** Error flags from Dates validation routine
     D ErrDealDat      S              1A   INZ('N')
     D ErrValDate      S              1A   INZ('N')
     D ErrMatDate      S              1A   INZ('N')
     D ErrNxInDat      S              1A   INZ('N')
 
      ** Error flags from funding details validation routine
     D ErrFundRat      S              1A   INZ('N')
     D ErrFundSgn      S              1A   INZ('N')
     D ErrFundPrf      S              1A   INZ('N')
 
 
      ** Default Round Down indicators for Branch & Currency
     D BrRdfc          S              1A
 
      ** Portfolio reference (default value, received from AOPLCSR1 in
      ** MMVBOOKCDE)
     D PortRef         S              4A
 
      ** Extended Settlement fields used by MMVVALDATE
     D PMERCD          S            150A
 
      ** Receive / Pay Settlement Currency, Method & Nostro
     D RecSetCcy       S              3A
     D RecSetMeth      S              2S 0
     D RecNostro       S             18A
     D PaySetCcy       S              3A
     D PaySetMeth      S              2S 0
     D PayNostro       S             18A
 
      ** Flag for whether an error was found in the call to ZDATE1
     D ZDATE1Err       S              1A
 
      ** Numeric version of spread/rate
     D @SPRD           S             11P 7
 
      ** 14-alpha amount field for passing to MMVAMOUNT and MMVNASBRKG
      ** (because this module's fields are 15-alpha).
     D Amount14A       S             14A
 
      ** Response Mode, received as a parameter from the common header
     D RespMode        S              1A
 
     D CSC011          S              1A   INZ('N')
     D WProcDate       S                   LIKE(BJRDNB)
 
      ** Define fields used in CAS001
     D CAS001          S              1A
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
     D PYCFN           S              6A
     D PERTP           S              1A
 
      ** Fields defined for Enhancement CDL010
     D CDL010          S              1A
 
      ** Define fields used in CAS005
 
     D CAS005          S              1A
     D PFwRv           S              1A
     D PFwYC           S              5A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,MMNSPVP002
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
                                                                                             BUG6979
      ** GET ZMUSER to access default branch.                                                BUG6979
                                                                                             BUG6979
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG6979
     C                   IN        ZMUSER                                                    BUG6979
     C                   UNLOCK    ZMUSER                                                    BUG6979
 
      * Call Validation Modules in Sequence
 
      /COPY WNCPYSRC,MMNSPVP003
 
      *  *-------------------------------------*
      *  * Validate Deal Date and Value Date   *  #04
      *  *-------------------------------------*
 
     C                   EXSR      RESETERRS
 
     C                   CALLB     'MMVNASDATE'
     C                   PARM                    ReturnCode
      ** Message IDs 1 - 3 (Returned to caller)
     C                   PARM                    Msg1
     C                   PARM                    Msg2
     C                   PARM                    Msg3
      ** Warning message IDs 1 - 5 (Returned to caller)
     C                   PARM                    WMsgid1
     C                   PARM                    WMsgid2
     C                   PARM                    WMsgid3
      ** Error in deal date flag (1A, returned to caller; contains 'Y'
      ** if errors, 'W' if warnings ONLY)
     C                   PARM                    ErrDealDat
      ** Error in value date flag (1A, returned to caller; contains 'Y'
      ** if errors, 'W' if warnings ONLY)
     C                   PARM                    ErrValDate
      ** Standard deals file version of deal date (5,0P, returned from
      ** this module)
     C                   PARM                    IHDDND
      ** Standard deals file version of value date (5,0P, returned from
      ** this module)
     C                   PARM                    IHDVSD
      ** Standard deals file version of start/last interest date
      ** (5,0P, returned from this module)
     C                   PARM                    IHSLID
      ** Deal date (6A, from transaction)
     C                   PARM                    DDDLDT
      ** Value date (6A, from transaction)
     C                   PARM                    DDVDAT
      ** Processing Date (either from SDBANKPD or SC24X7)
     C                   PARM                    WProcDate
      ** Date format indicator (1A, from SDBANKPD via caller)
     C                   PARM                    BJDFIN
      ** Local Currency code (3A, from SDBANKPD via caller)
     C                   PARM                    BJLCCY
      ** Branch Location Code (3A, from SDBRCHPD)
     C                   PARM                    A8LCCD
      ** Deal currency (3A, from transaction)
     C                   PARM                    DDCCY
      ** Deal type (2A, from transaction)
     C                   PARM                    DDMTYP
      ** Error codes (150A, from caller)
     C                   PARM                    PMERCD
      ** Pay - settlement currency (3A, from caller)
     C                   PARM                    PaySetCcy
      ** Pay - our nostro (12A, from caller)
     C                   PARM                    PayNostro
      ** Pay - settlement method (2,0S, from caller)
     C                   PARM                    PaySetMeth
      ** Receive - settlement currency (3A, from caller)
     C                   PARM                    RecSetCcy
      ** Receive - our nostro (12A, from caller)
     C                   PARM                    RecNostro
      ** Receive - settlement method (2,0S, from caller)
     C                   PARM                    RecSetMeth
      ** Global warning flag (1A, from caller)
     C                   PARM                    WarnGlobal
      ** Type of this transaction function (4A)
     C                   PARM      'NASP'        TransType
     C                   PARM                    DDACTN                                       249967
 
      /COPY WNCPYSRC,MMNSPVP004
 
     C     MSG1          IFNE      *BLANK
     C     MSG1          LOOKUP    MsgIDArr                               99                 BUG8236
     C     *IN99         IFEQ      '0'                                                       BUG8236
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDLDT'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF                                                               BUG8236
     C                   ENDIF
     C     MSG2          IFNE      *BLANK
     C     MSG2          LOOKUP    MsgIDArr                               99                 BUG8236
     C     *IN99         IFEQ      '0'                                                       BUG8236
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDLDT'
     C                   EVAL      MsgIDArr(Idx) = MSG2
     C                   ENDIF                                                               BUG8236
     C                   ENDIF
     C     MSG3          IFNE      *BLANK
     C     MSG3          LOOKUP    MsgIDArr                               99                 BUG8236
     C     *IN99         IFEQ      '0'                                                       BUG8236
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDVDAT'
     C                   EVAL      MsgIDArr(Idx) = MSG3
     C                   ENDIF                                                               BUG8236
     C                   ENDIF
 
     C     WMSGID1       IFNE      *BLANK
     C     WMSGID1       LOOKUP    WMsgIDArr                              99                 BUG3992
     C     *IN99         IFEQ      '0'                                                       BUG3992
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDDLDT'
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID1
     C                   ENDIF                                                               BUG3992
     C                   ENDIF
     C     WMSGID2       IFNE      *BLANK
     C     WMSGID2       LOOKUP    WMsgIDArr                              99                 BUG3992
     C     *IN99         IFEQ      '0'                                                       BUG3992
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDVDAT'
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID2
     C                   ENDIF                                                               BUG3992
     C                   ENDIF
     C     WMSGID3       IFNE      *BLANK
     C     WMSGID3       LOOKUP    WMsgIDArr                              99                 BUG3992
     C     *IN99         IFEQ      '0'                                                       BUG3992
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDVDAT'
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID3
     C                   ENDIF                                                               BUG3992
     C                   ENDIF
 
      ** Convert the 'field in error' flags to set the 'field OK' flags
      ** N.B. This is non-standard processing and takes the place of the
      **  call(s) to ZASETOKFLG.
     C                   CALLB     'ZACVTFLG'
     C                   PARM                    DDDlDtOK
     C                   PARM                    ErrDealDat
 
     C                   CALLB     'ZACVTFLG'
     C                   PARM                    DDVDatOK
     C                   PARM                    ErrValDate
 
     C                   IF        WMSGID1 <> *BLANK OR WMSGID2 <> *BLANK
     C                             OR WMSGID3 <> *BLANK
     C                   EVAL      WarnGlobal = 'Y'
     C                   ENDIF
 
      /COPY WNCPYSRC,MMNSPVP005
 
      *  *------------------------*
      *  * Validate Maturity Date *  #09
      *  *------------------------*
 
     C                   EXSR      RESETERRS
 
     C                   CALLB     'MMVNABMDAT'
     C                   PARM                    ReturnCode
     C                   PARM                    Msg1
     C                   PARM                    WMsgID1
      ** Maturity Date
     C                   PARM                    DDMDAT
      ** Deal type
     C                   PARM                    DDMTYP
      ** Decimal separator (1A, from SDDEALPD)
     C                   PARM                    BNDCSP
      ** Maturity Date - Std. Deal file
     C                   PARM                    IHMATD                        12A
      ** Interest Rate, from transaction
     C                   PARM                    DDINTR                        12A
      ** Deal value date in Midas day number format
     C                   PARM                    IHDVSD                        12A
      ** Receive Nostro Location Code
     C                   PARM                    RLOC                          12A
      ** Deal currency (3A, from transaction)
     C                   PARM                    DDCCY                         12A
      ** Receive - settlement currency (3A)
     C                   PARM                    RecSetCcy
      ** Receive - settlement method (2,0S)
     C                   PARM                    RecSetMeth                    12A
      ** Receive - our nostro
     C                   PARM                    RecNostro                        12A
      ** Global Warning indicator
     C                   PARM                    WarnGlobal
      ** Local Currency code (3A, from SDBANKPD via caller)
     C                   PARM                    BJLCCY
      ** System Location Code from SDBANKPD received as paramater
     C                   PARM                    BJSLCD
      ** Date Format Ind. from SDBANKPD received as paramater
     C                   PARM                    BJDFIN
 
      /COPY WNCPYSRC,MMNSPVP006
 
     C     MSG1          IFNE      *BLANK
     C     MSG1          LOOKUP    MsgIDArr                               99                 BUG8236
     C     *IN99         IFEQ      '0'                                                       BUG8236
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMDAT'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF                                                               BUG8236
     C                   ENDIF
 
     C     MSG2          IFNE      *BLANK
     C     MSG2          LOOKUP    MsgIDArr                               99                 BUG8236
     C     *IN99         IFEQ      '0'                                                       BUG8236
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMDAT'
     C                   EVAL      MsgIDArr(Idx) = MSG2
     C                   ENDIF                                                               BUG8236
     C                   ENDIF
 
     C     WMSGID1       IFNE      *BLANK
     C     WMSGID1       LOOKUP    WMsgIDArr                              99                 BUG3992
     C     *IN99         IFEQ      '0'                                                       BUG3992
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDMDAT'
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID1
     C                   ENDIF                                                               BUG3992
     C                   ENDIF
 
     C     WMSGID2       IFNE      *BLANK
     C     WMSGID2       LOOKUP    WMsgIDArr                              99                 BUG3992
     C     *IN99         IFEQ      '0'                                                       BUG3992
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDMDAT'
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID2
     C                   ENDIF                                                               BUG3992
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDMdatOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMNSPVP007
 
      *  *-----------------------------*
      *  * Validate Next Interest Date *  #20
      *  *-----------------------------*
     C                   EXSR      RESETERRS
 
     C                   CALLB     'MMVNABNIDT'
     C                   PARM                    ReturnCode
     C                   PARM                    Msg1
      ** Warning ID (7A)
     C                   PARM                    WMsgID1
      ** Deal type (2A, from transaction)
     C                   PARM                    DDMTYP
      ** Deal value date in Midas day number format (5,0P, from caller)
     C                   PARM                    IHDVSD
      ** Local Currency code (3A, from SDBANKPD via caller)
     C                   PARM                    BJLCCY
      ** Deal currency (3A, from transaction)
     C                   PARM                    DDCCY                                  LIKE(BJLCCY)
      ** Receive - settlement currency (3A, from caller)
     C                   PARM                    RecSetCcy
      ** Receive - settlement method (2,0S, from caller)
     C                   PARM                    RecSetMeth
      ** Value date field OK (1A, from caller)
     C                   PARM                    DDVDATOK
      ** Maturity date in Midas day number format (5,0P, from caller)
     C                   PARM                    IHMATD
      ** Maturity date field OK (1A, from caller)
     C                   PARM                    DDMDATOK
      ** System Location Code from SDBANKPD received as paramater
     C                   PARM                    BJSLCD                         3A
      ** Date Fmt Ind. from SDBANKPD received as paramater
     C                   PARM                    BJDFIN                         3A
      ** Receive Nostro Location Code received as paramater
     C                   PARM                    RLOC              3            3A
     ** Int Rate OK
     C                   PARM                    DDINTROK                       1A
     ** Next Int Date
     C                   PARM                    DDNDAT                         6A
     ** Int Rate
     C                   PARM                    DDINTR                        12A
     ** Next Int Payment Date
     C                   PARM                    IHNIPD                        15A 0
 
      /COPY WNCPYSRC,MMNSPVP008
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNDAT'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
 
     C     WMSGID1       IFNE      *BLANK
     C     WMSGID1       LOOKUP    WMsgIDArr                              99                 BUG3992
     C     *IN99         IFEQ      '0'                                                       BUG3992
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDNDAT'
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID1
     C                   ENDIF                                                               BUG3992
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDNDatOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMNSPVP009
 
      ****-------------------------------------************************                     BUG11552
      *****Validate*Start/Last*Interest*Date******#21******************                     BUG11552
      ****-------------------------------------************************                     BUG11552
     C**********         EXSR      RESETERRS                                                BUG11552
 
     C**********         CALLB     'MMVSLINTDT'                                             BUG11552
     C**********         PARM                    ReturnCode                                 BUG11552
     C**********         PARM                    Msg1                                       BUG11552
     C**********         PARM                    WMsgid1                                    BUG11552
      ***Start/Last*Int*date*******************************************                     BUG11552
     C**********         PARM                    DDSLID            6                        BUG11552
      ***Action*Code***************************************************                     BUG11552
     C**********         PARM                    DDACTN            1                        BUG11552
      ***Deal*Type*****************************************************                     BUG11552
     C**********         PARM                    DDMTYP            2                        BUG11552
      ***Next*Interest*date********************************************                     BUG11552
     C**********         PARM                    DDNDAT            6                        BUG11552
      ***Value*date****************************************************                     BUG11552
     C**********         PARM                    DDVDAT            6                        BUG11552
      ***Value*date*OK*************************************************                     BUG11552
     C**********         PARM                    DDVdatOK          1                        BUG11552
      ***Value*date*(Midas*number*format)******************************                     BUG11552
     C**********         PARM                    IHDVSD                                     BUG11552
      ***Next*Interest*date*(Midas*number*format)**********************                     BUG11552
     C**********         PARM                    IHNIPD                                     BUG11552
     C**********         PARM                    RecSetCcy                                  BUG11552
     C**********         PARM                    RecSetMeth                                 BUG11552
      ***Receive*Nostro*Location***************************************                     BUG11552
     C**********         PARM                    RLOC              3                        BUG11552
     C**********         PARM                    BJSLCD            3                        BUG11552
     C**********         PARM                    BJLCCY            3                        BUG11552
      ***Date*format*indicator*(1A*from*SDBANKPD)**********************                     BUG11552
     C**********         PARM                    BJDFIN                                     BUG11552
      ***Start/Last*Int*date*(MMSTDBPP*-*Midas*number*format)**********                     BUG11552
     C**********         PARM                    IHSLID            5 0                      BUG11552
      ***Currency*Code*************************************************                     BUG11552
     C**********         PARM                    DDCCY             3                        BUG11552
 
      /COPY WNCPYSRC,MMNSPVP010
 
     C*****MSG1*         IFNE      *BLANK                                                   BUG11552
     C**********         ADD       1             Idx                                        BUG11552
     C**********         EVAL      FldNameArr(Idx) = 'DDSLID'                               BUG11552
     C**********         EVAL      MsgIDArr(Idx) = MSG1                                     BUG11552
     C**********         ENDIF                                                              BUG11552
     C*****MSG2*         IFNE      *BLANK                                                   BUG11552
     C**********         ADD       1             Idx                                        BUG11552
     C**********         EVAL      FldNameArr(Idx) = 'DDSLID'                               BUG11552
     C**********         EVAL      MsgIDArr(Idx) = MSG2                                     BUG11552
     C**********         ENDIF                                                              BUG11552
     C*****MSG3*         IFNE      *BLANK                                                   BUG11552
     C**********         ADD       1             Idx                                        BUG11552
     C**********         EVAL      FldNameArr(Idx) = 'DDSLID'                               BUG11552
     C**********         EVAL      MsgIDArr(Idx) = MSG3                                     BUG11552
     C**********         ENDIF                                                              BUG11552
     C*****WMSGID1       IFNE      *BLANK                                                   BUG11552
     C*****WMSGID1       LOOKUP    WMsgIDArr                              99        BUG3992 BUG11552
     C******IN99         IFEQ      '0'                                              BUG3992 BUG11552
     C**********         ADD       1             WIdx                                       BUG11552
     C**********         EVAL      WFldNamArr(WIdx) = 'DDSLID'                              BUG11552
     C**********         EVAL      WMsgIDArr(WIdx) = WMSGID1                                BUG11552
     C**********         ENDIF                                                      BUG3992 BUG11552
     C**********         ENDIF                                                              BUG11552
 
      ***Use*the*return*code's*value*to*set*the*field's*OK*flag********                     BUG11552
     C**********         CALLB     'ZASETOKFLG'                                             BUG11552
     C**********         PARM                    DDSlidOK                                   BUG11552
     C**********         PARM                    ReturnCode                                 BUG11552
     C**********         PARM                    WarnGlobal                                 BUG11552
 
      /COPY WNCPYSRC,MMNSPVP011
 
      *  *-------------------------------------------------------*
      *  * If no errors set up outstanding fields for valid file *
      *  *-------------------------------------------------------*
 
      /COPY WNCPYSRC,MMNSPVP012
 
     C                   IF        Idx = 0
     C                   EXSR      SetupValid
     C                   ENDIF
 
      /COPY WNCPYSRC,MMNSPVP013
 
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,MMNSPVP014
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      * Response mode (1A), from source system common header
     C                   PARM                    RespMode
      * Transaction information (DS) from source system
     C                   PARM                    TranIn
      * Receive Settlement Ccy, Method & Nostro and  Pay Settlement Ccy,
      * Method & Nostro, from default or valid deal
     C                   PARM                    RecSetCcy
     C                   PARM                    RecSetMeth
     C                   PARM                    RecNostro
     C                   PARM                    PaySetCcy
     C                   PARM                    PaySetMeth
     C                   PARM                    PayNostro
     C                   PARM                    ExtData
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
      * Valid Deals layout (DS) from/to caller
     C                   PARM                    ValidDeal
 
      **********                                                                             BUG6979
      ****GET*ZMUSER*to*access*default*branch.                                               BUG6979
      **********                                                                             BUG6979
     C******DTAARA       DEFINE                  ZMUSER                                      BUG6979
     C**********         IN        ZMUSER                                                    BUG6979
     C**********         UNLOCK    ZMUSER                                                    BUG6979
      **
      **  Move program name into *LDA field.
     C     *LOCK         IN        LDA
     C                   MOVEL     'MMNASPVAL'   DBPGM
     C                   OUT       LDA
 
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Access General Ledger details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOGELRR1'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDGELR        PARM      SDGELR        DSSDY
      *
      ** Access Dealing details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AODEALR1'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDDEAL        PARM      SDDEAL        DSSDY
      *
      ** Access Trading data via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOTRADR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDTRAD        PARM      SDTRAD        DSFDY
      *
      ** Access MIDAS Modules details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Access Portfolio Management details via access program
      *  (database error handling done in access program)
     C     BGPFMG        IFEQ      'Y'
     C                   CALLB     'AOPORTR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDPORT        PARM      SDPORT        DSFDY
     C                   ENDIF
 
      ** Access SAR details file to determine if CDE002 is switched on
 
     C                   CallB     'AOSARDR0'
     C                   Parm      *Blanks       PRTCD             7
     C                   Parm      '*VERIFY'     POPTN             7
     C                   Parm      'CDE002'      PSARD             6
     C     SCSARD        Parm      SCSARD        DSFDY
      *
     C                   Move      'N'           CDE002            1
     C                   If        PRTCD = *Blanks
     C                   Eval      CDE002 = 'Y'
     C                   Endif
 
     C                   EVAL      WProcDate = BJRDNB
 
      ** Check if CSC011 is installed
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSC011'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRTCD = *Blanks
 
     C                   EVAL      CSC011 = 'Y'
 
     C                   IN        SC24X7
     C                   IN        SDSTAT
 
      ** If 24X7 Midas availability is installed and support system is
      ** active, used processing date from dataarea SC24X7 as the
      ** rundate.
 
     C                   IF        S1SUPP = LIBR
     C                   EVAL      WProcDate = S1DATE
     C                   ENDIF
 
     C                   ELSE
 
      ** Database error
 
     C                   IF        PRTCD <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 900
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Access Profit Centre Accounting details via access program
      *  (database error handling done in access program)
     C     BGN0ST        IFEQ      'Y'
     C                   CALLB     'AOPCACR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDPCAC        PARM      SDPCAC        DSFDY
     C                   ENDIF
      *
      ** Access SAR details file to determine if CDL005 is on.
      ** (Customer format in input functions is shortname)
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDL005'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE                         * DBERROR 020 *
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     'CDL005'      DBKEY
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      #TERM
     C                   END
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'S'           CustFormat        1
     C                   ELSE
     C                   MOVEL     'N'           CustFormat
     C                   END
      *
      ** Access SAR details file to determine if CDL011 is on.
      ** (Expansion of Customer Number on Dealing Transactions)
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDL011'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CDL011'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '004'         DBASE
     C                   EXSR      *PSSR
     C                   END
     C*
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'S'           CustFormat
     C                   END
 
      ** Access SAR details file to determine if CAS001 is on.
      ** (Net Present Value Accounting)
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CAS001'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        PRTCD <> *BLANKS AND
     C                             PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 002
     C                   EVAL      DBKEY = 'CAS001'
     C                   OUT       LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   EXSR      #TERM
     C                   ENDIF
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CAS001 = 'Y'
     C                   ELSE
     C                   EVAL      CAS001 = 'N'
     C                   ENDIF
 
      ** Access SAR details file to determine if CDL010 is on.
      ** (Dealing Transaction Authorisation)
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CDL010'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        PRTCD <> *BLANKS AND
     C                             PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 003
     C                   EVAL      DBKEY = 'CDL010'
     C                   OUT       LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   EXSR      #TERM
     C                   ENDIF
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CDL010 = 'Y'
     C                   ELSE
     C                   EVAL      CDL010 = 'N'
     C                   ENDIF
 
      ** Access SAR details file to determine if CAS005 is on.
      ** (Enhancements to CAS001, CAS002 and CAS004)
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CAS005'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        PRTCD <> *BLANKS AND
     C                             PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 3
     C                   EVAL      DBKEY = 'CAS005'
     C                   OUT       LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   EXSR      #TERM
     C                   ENDIF
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CAS005 = 'Y'
     C                   ELSE
     C                   EVAL      CAS005 = 'N'
     C                   ENDIF
      *
      *  Set up the name of the MSGF from which the message handler will
      *   get the messages
     C                   EVAL      #MsgFile = 'DRSMM'
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,MMNSPVP015
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *                                                               *
      * Called by: Main processing, before each validation module     *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     RESETERRS     BEGSR
 
     C                   RESET                   Msg1
     C                   RESET                   Msg2
     C                   RESET                   Msg3
     C                   RESET                   Msg4
     C                   RESET                   Msg5
     C                   RESET                   Msg6
     C                   RESET                   Msg7
 
     C                   RESET                   WMsgID1
     C                   RESET                   WMsgID2
     C                   RESET                   WMsgID3
     C                   RESET                   WMsgID4
 
     C                   RESET                   MSGDATA
     C                   RESET                   WMSGDATA
 
     C                   EVAL      ReturnCode= *Blanks
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPVALID - Set up additional fields that are needed on the  *
      *    Valid file record.                                         *
      *                                                               *
      *****************************************************************
 
     C     SETUPVALID    BEGSR
 
      * Other IHxxxx fields are set up during the validation, such as the
      *  ones where the input & database formats are different, e.g. dates,
      *  amounts.
      * This SR sets up the fields with the same (or compatible) attributes
 
     C                   MOVE      DDMTYP        IHTYPE
     C                   MOVE      DDSTYP        IHSTYP
     C     DDMTYP        IFEQ      'C1'
     C                   MOVE      IHISUR        IHCSNM
     C                   MOVE      IHISCN        IHCNUM
     C                   END
     C                   MOVE      DDFEDF        IHFEDF
     C                   MOVE      DDBRCA        IHBRCA
     C                   MOVE      DDBKCD        IHBKCD
     C                   MOVE      DDACSQ        IHACSQ
     C                   MOVE      DDCCY         IHCCY
     C                   MOVE      DDBOKC        IHBOKC
     C                   MOVE      DDLNKN        IHLNKN
     C                   MOVE      DDICMT        IHICMT
     C                   MOVE      DDIPFQ        IHIPFQ
     C                   MOVE      DDIPDM        IHIPDM
     C                   MOVE      DDCDRF        IHCDRF
     C                   MOVE      DDRDFC        IHRDFC
     C                   MOVE      DDPCLI        IHPCLI
     C                   MOVE      DDORBR        IHORBR
     C                   MOVE      DDPRFC        IHPRFC
 
      ** Set up The user field from ZMUSER which is the front office
      ** user if sent . Only if CDL010 is installed
 
     C     CDL010        IFEQ      'Y'
     C                   MOVE      ZUSER         IHUSER
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * #TERM    - Termination processing.                            *
      *                                                               *
      *                                                               *
      *****************************************************************
     C     #TERM         BEGSR
      *
      **  Terminate program
      *
     C     *INU7         IFEQ      '1'
     C                   DUMP
     C                   END
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      /COPY ZACPYSRC,DBERREXIT
      ********************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      /EJECT
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
