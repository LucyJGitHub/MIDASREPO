     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM NAs Purchased Validation')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMNASPVAL - NAs Bought (purchased) Validation                *
      *                                                               *
      *  Function: This Program Validates NA Deals for Input into     *
      *            the Midas database.                                *
      *            The sequence of validation is based on subroutine  *
      *            #ZI in Midas program MM0026.                       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL015             Date 27Aug13               *
      *                 245692             Date 12Dec13               *
      *                 AR569568           Date 22Nov12               *
      *                 235508             Date 20Nov12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 249967             Date 13Sep07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 11Jul06               *
      *                 BUG10704           Date 13Mar06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG9827            Date 13Jan05               *
      *                 BUG9711            Date 26Jan06               *
      *                 BUG9717            Date 29Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CAP086             Date 08Jun05               *
      *                 CDL033             Date 10Feb05               *
      *                 CDL029A            Date 09May05               *
      *                 BUG6979            Date 04May05               *
      *                 CSW037A            Date 02May05               *
      *                 CAS008             Date 16Jun04               *
      *                 224961             Date 10Feb04               *
      *                 224867             Date 06Feb04               *
      *                 BUG6124            Date 03Mar05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CDL029             Date 23NOV04               *
      *                 BUG629             Date 19Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 24Oct03               *
      *                 CAS005             Date 16Dec02               *
      *                 CDL011             Date 07Jul02               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 191138             Date 10Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      *                 191947             Date 14Sep01               *
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 03Apr00               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             Date 02Sep99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP004             Date 07Sep98               *
      *                 140930             Date 17Aug98               *
      *                 136430             Date 10Jun98               *
      *                 CAP002  *CREATE    Date 01DEC97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL015 - Daily Compounding of Interest                       *
      *  245692 - Incorrect validation of rates when the decimal se-  *
      *           parator in the Dealing ICD was defined as "," ins-  *
      *           tead of ".".                                        *
      *         - Applied for MD23981.                                *
      *  AR569568 - CDL006 is not being passed causing zero amount to *
      *             be valid in Insert.  But in amendment, it will    *
      *             issue an error message MMM0372.(Child: AR569569)  *
      *  235508 - Call to MMVLIQR by CAS005 should only be done when  *
      *           feature is *ON to prevent warning msg MMA1307.      *
      *           Applied for AR948938 (Child: AR948940)              *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  249967 - Restrict validation of VDAT to insert               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field                  *
      *  BUG10704 - If entered transaction customer is not valid      *
      *             or does not exist in file, validation of          *
      *             customer VS branch must not be carried out.       *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG9827- Check if CDl006 is switched on                      *
      *  BUG9711- Changes to MMVNASPPD/MMVNASSPD (re-compile)         *
      *  BUG9717- Defaulting of class should be done when CDL038      *
      *           feature is currently ON.                            *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  CDL033 - Floating Rate CD Issued                             *
      *  CDL029A- Adding new field                                    *
      *  BUG6979 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CAS008 - IAS 39 Enhancements                                 *
      *  224961 - Do not call MMVLIQR when an error is detected in    *
      *           MMVNABIRAT. Calling it causes a divide by zero.     *
      *  224867 - Do not call MMVLIQR when an error is detected in    *
      *           MMVDISRATE. MMVDISRATE sets IHINTR to zero when it  *
      *           encounters an error and this causes a divide by     *
      *           zero error in MMVLIQR.                              *
      *  BUG6124 - Branch code error when CDL029 is set on.           *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CDL029 - Midas SD Authorised Booking Branches for Customers  *
      *  BUG629 - Pass correct Deal Date field (DDDLDT instead of     *
      *           DDDDAT) to Midasplus when field is in error or      *
      *           warning to highlight in input JSP.                  *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Parameter Mismatch                                  *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *  CDL011 - Expansion of Customer Number on Dealing Transactions*
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.                                     *
      *  191138 - System validates base currency rate in amend mode   *
      *           but field is unamendable.  Validate this field only *
      *           when in insert mode.                                *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *  191947 - Bill Depot ID not properly passed.                  *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CDE002 - Revenue Analysis                                    *
      *  CSD006 - Use DSSDY as MMVCURCODE *ENTRY parm, not SDCURRPD   *
      *  CPB001 - 'Private Banking' Module                            *
      *  CAP004 - API's Phase 3.                                      *
      *           Add extra parm for Extra Data                       *
      *  140930 - Counterparty of primary CD purchased should be      *
      *           issuer.                                             *
      *  136430 - Amendment of NA purchased deal disallowed           *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
                                                                                              CDL029
     FSDABBCL0  IF   E           K DISK    INFSR(*PSSR)                                       CDL029
      ** Midas SD Authorised Booking Branches for Customers)                                  CDL029

      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,MMNASPV065

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
     D QQACC1        E                     EXTFLD(QQACCD)                                     CGL029
      ** EXTERNAL DS FOR DEALING DETAILS

     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
     D QQACC2        E                     EXTFLD(QQACCD)                                     CGL029
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
     D QQDFC1        E                     EXTFLD(QQDFAC)                                     CGL029
      ** External data structure for customer details

     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE

     D ValidDeal     E DS                  EXTNAME(MMVNASPPD)
      * Valid Deals layout

     D ZMUSER          DS            17
     D  ZUSER                  1     10                                                       CDL010
     D  BRC                   11     13
     D  DEPT                  14     16

     D TranIn        E DS                  EXTNAME(MMNASPPD)
      * Incoming Transaction
                                                                                CAP004
     D ExtData       E DS                  EXTNAME(MMNPEXPD)                    CAP004
      * MM Extra Data - File (D/B) format                                       CAP004
                                                                                              CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status dataarea                                                                 CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Error message fields received as parameters
     D     Msg1        S                   LIKE(#MsgID)
     D     Msg2        S                   LIKE(#MsgID)
     D     Msg2C       S                   LIKE(#MsgID)                                       CDL038
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
     D  DDOylcOK                      1A                                                      CAS001
     D  DDLQPROK                      1A                                                      CAS005
     D  DDLQPSOK                      1A                                                      CAS005
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
     D***RecNostro       S             12A                                                    CGL029
     D RecNostro       S             18A                                                      CGL029
     D PaySetCcy       S              3A
     D PaySetMeth      S              2S 0
     D***PayNostro       S             12A                                                    CGL029
     D PayNostro       S             18A                                                      CGL029

      ** Flag for whether an error was found in the call to ZDATE1
     D ZDATE1Err       S              1A

      ** Redefine external field as a Zoned decimal to prevent errors
     D*IKACSQ          S              2S 0
     D*IKDN38          S              6S 0
     D*IKCNUM          S              6S 0

      ** Numeric version of spread/rate
     D @SPRD           S             11P 7

      ** 14-alpha amount field for passing to MMVAMOUNT and MMVNASBRKG
      ** (because this module's fields are 15-alpha).
     D Amount14A       S             14A

      ** Response Mode, received as a parameter from the common header
     D RespMode        S              1A
                                                                                              CSC011
     D CSC011          S              1A   INZ('N')                                           CSC011
     D WProcDate       S                   LIKE(BJRDNB)                                       CSC011
                                                                                              CAS001
      ** Define fields used in CAS001                                                         CAS001
     D CAS001          S              1A                                                      CAS001
     D PRTCD           S              7A                                                      CAS001
     D POPTN           S              7A                                                      CAS001
     D PSARD           S              6A                                                      CAS001
     D PYCFN           S              6A                                                      CAS001
     D PERTP           S              1A                                                      CAS001
                                                                                              CDL010
      ** Fields defined for Enhancement CDL010                                                CDL010
     D CDL010          S              1A                                                      CDL010
                                                                                              CAS005
      ** Define fields used in CAS005                                                         CAS005
                                                                                              CAS005
     D CAS005          S              1A                                                      CAS005
     D PFwRv           S              1A                                                      CAS005
     D PFwYC           S              5A                                                      CAS005
                                                                                              CAS008
     D PFCRv           S              1A                                                      CAS008
                                                                                              CDL029
      ** Fields defined for Enhancement CDL029                                                CDL029
     D CDL029          S              1A                                                      CDL029
                                                                                              CDL029
     D CDL038          S              1A                                                     BUG9717
     D CDL006          S              1A                                                     BUG9827
     D CDL049          S              1A                                                      CDL049

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,MMNASPV066

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

      /COPY WNCPYSRC,MMNASPV001
      *                                                                         CDL038
      *  *-------------------------------*                                      CDL038
      *  * Default Sub Type and Class                                           CDL038
      *  *-------------------------------*                                      CDL038
      *                                                                         CDL038
     C                   IF        CDL038 = 'Y'                                              BUG9717
     C                   EXSR      DSUBTCLAS                                    CDL038
     C                   ENDIF                                                               BUG9717

      * Call Validation Modules in Sequence

      *  *-------------------------------*
      *  * Validate Deal Type / Sub-Type *  #01
      *  *-------------------------------*

      * Reset variables updated by each module before each call
     C                   EXSR      RESETERRS

     C                   CALLB     'MMVDLTPSTP'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    MSG2
     C                   PARM                    MSG2C                                        CDL038
     C                   PARM                    MSG3
     C                   PARM                    DDmtypOK
     C                   PARM                    DDmtyp
     C                   PARM                    DDSTYP
     C                   PARM                    DDCLAS                                       CDL038
      ** Type of this transaction function (4A)
     C                   PARM      'NASP'        TransType
     C                   PARM                    SDDLST
      ** Action code                                                                          222373
     C                   PARM      DDACTN        PActn             1                          222373
      ** Floating Rate CD Issued                                                              CDL033
     C                   PARM                    CDL033                                       CDL033
      ** Warning message ID                                                                   222373
     C                   PARM                    PWMsgID1          7                          222373
      ** Fiduciary deals                                                                     BUG9827
     C                   PARM                    CDL006                                      BUG9827

      /COPY WNCPYSRC,MMNASPV002

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMTYP'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   MOVE      'N'           DDMTYPOK
     C                   ENDIF
     C     MSG2          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSTYP'
     C                   EVAL      MsgIDArr(Idx) = MSG2
     C                   MOVE      'N'           DDSTypOK
     C                   ENDIF
     C     MSG2C         IFNE      *BLANK                                       CDL038
     C                   ADD       1             Idx                            CDL038
     C                   EVAL      FldNameArr(Idx) = 'DDCLAS'                   CDL038
     C                   EVAL      MsgIDArr(Idx) = MSG2C                        CDL038
     C                   MOVE      'N'           DDClasOK                       CDL038
     C                   ENDIF                                                  CDL038
     C     MSG3          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMTYP'
     C                   EVAL      MsgIDArr(Idx) = MSG3
     C                   MOVE      'N'           DDMTYPOK
     C                   MOVE      'N'           DDSTypOK
     C                   MOVE      'N'           DDClasOK                       CDL038
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDDltStpOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,MMNASPV003

      *  *----------------------------------*
      *  * Validate Federal funds indicator *  #02
      *  *----------------------------------*
     C                   EXSR      RESETERRS
     C                   CALLB     'MMVFEDFUND'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
      ** Federal funds indicator
     C                   PARM                    DDFedf
      ** Currency code
     C                   PARM                    DDCcy
      ** US Currency code
     C                   PARM                    BLUSCY

      /COPY WNCPYSRC,MMNASPV004

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFEDF'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDFedFOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,MMNASPV005

      *  *------------------------*
      *  * Validate Branch Code   *  #03
      *  *------------------------*
     C                   EXSR      RESETERRS

     C                   CALLB     'MMVBKGBRCH'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    BJSBRC
     C                   PARM                    BRC
     C                   PARM                    BRRDFC
     C                   PARM                    DDACTN
     C                   PARM                    DDBRCA
     C                   PARM                    RESPMODE
     C                   PARM                    IHDBRC
     C                   PARM                    SDBRCH

      /COPY WNCPYSRC,MMNASPV006

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBRCA'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *****                                                                           CDL029 BUG6124
     C*****              IF        CDL029 ='Y'                                        CDL029 BUG6124
      *****                                                                           CDL029 BUG6124
     C*****KBRANCHAUTH   CHAIN     SDABBCL0                           91              CDL029 BUG6124
     C*****              IF        *IN91 = '1'                                        CDL029 BUG6124
     C*****              EVAL      ReturnCode = 'Error'                               CDL029 BUG6124
     C*****              ADD       1             Idx                                  CDL029 BUG6124
     C*****              EVAL      FldNameArr(Idx) = 'DDBRCA'                         CDL029 BUG6124
     C*****              EVAL      MsgIDArr(Idx) = 'FXM7001'                          CDL029 BUG6124
     C*****              END                                                          CDL029 BUG6124
      *****                                                                           CDL029 BUG6124
     C*****              END                                                          CDL029 BUG6124
      *****                                                                           CDL029 BUG6124

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDBRCAOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,MMNASPV007

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
      ***Run*date*(5,0P*(Midas*day*number)*from*SDBANKPD*via*caller)***                       CSC011
     C**********         PARM                    BJRDNB                                       CSC011
      ** Processing Date (either from SDBANKPD or SC24X7)                                     CSC011
     C                   PARM                    WProcDate                                    CSC011
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

      /COPY WNCPYSRC,MMNASPV008

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDLDT'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
     C     MSG2          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDLDT'
     C                   EVAL      MsgIDArr(Idx) = MSG2
     C                   ENDIF
     C     MSG3          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDVDAT'
     C                   EVAL      MsgIDArr(Idx) = MSG3
     C                   ENDIF

     C     WMSGID1       IFNE      *BLANK
     C                   ADD       1             WIdx
     C***********        EVAL      WFldNamArr(WIdx) = 'DDDDAT'                                BUG629
     C                   EVAL      WFldNamArr(WIdx) = 'DDDLDT'                                BUG629
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID1
     C                   ENDIF
     C     WMSGID2       IFNE      *BLANK
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDVDAT'
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID2
     C                   ENDIF
     C     WMSGID3       IFNE      *BLANK
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDVDAT'
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID3
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

      /COPY WNCPYSRC,MMNASPV009

      *  *------------------------*
      *  * Validate Broker Code   *  #05
      *  *------------------------*
     C                   EXSR      RESETERRS

     C                   CALLB     'MMVBROKCDE'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    DDBKCD
     C                   PARM                    IHBKCY
     C                   PARM                    IHBCDP
     C                   PARM                    SDBROK

      /COPY WNCPYSRC,MMNASPV010

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBKCD'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDBkCdOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,MMNASPV011

      *  *------------------------*
      *  * Validate Brokerage     *  #06
      *  *------------------------*
     C                   EXSR      RESETERRS

     C                   CALLB     'MMVNASBRKG'
     C                   PARM                    ReturnCode
     C                   PARM                    Msg1
      ** Standard deals file version of brokerage amount (15,0P)
     C                   PARM                    IHBRKG
      ** Standard deals file version of broker currency (3A)
     C                   PARM                    IHBKCY
      ** Broker code (4A, from transaction)
     C                   PARM                    DDBKCD
      ** Brokerage (15A, from transaction)
     C                   PARM                    DDBRKG
      ** Broker currency (3A, from SDBROKPD, via caller)
     C                   PARM                    A9BRCY
      ** Decimal separator (1A, from SDDEALPD, via caller
     C                   PARM                    BNDCSP
      ** Broker OK flag (1A, from caller)
     C                   PARM                    DDBKCDOK

      /COPY WNCPYSRC,MMNASPV012

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBRKG'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDBrkgOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal


      /COPY WNCPYSRC,MMNASPV013

      *  *------------------------*
      *  * Validate NAB Issuer    *  #07
      *  *------------------------*
     C                   EXSR      ResetErrs

     C                   CALLB     'MMVCUSNONP'
     C                   PARM                    ReturnCode
     C                   PARM                    Msg1
     C                   PARM                    CustFormat
     C                   PARM                    IHISUR
     C                   PARM                    IHISCN
     C                   PARM                    DDISUR
     C                   PARM                    SDCUST

      /COPY WNCPYSRC,MMNASPV014

     C     Msg1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDISUR'
     C                   EVAL      MsgIDArr(Idx) = Msg1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDIsurOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *                                                                                      BUG6124
     C                   IF        CDL029 ='Y'                                               BUG6124
     C                             AND DDIsurOK = 'Y'                                       BUG10704
      *                                                                                      BUG6124
     C                   MOVEL     *BLANKS       W0BRCD                                      CDL029A
     C                   MOVEL     BBCUST        W0CUST                                      CDL029A
      *                                                                                      CDL029A
     C     KBRANCHAUTH   CHAIN     SDABBCL0                           91                     CDL029A
      *                                                                                      CDL029A
     C                   IF        *IN91 = '1'                                               CDL029A
      *                                                                                      CDL029A
     C                   MOVEL     BBBRCD        W0BRCD                                      CDL029A
     C                   MOVEL     *BLANKS       W0CUST                                      CDL029A
      *                                                                                      CDL029A
     C     KBRANCHAUTH   CHAIN     SDABBCL0                           91                     BUG6124
      *                                                                                      CDL029A
     C                   ENDIF                                                               CDL029A
      *                                                                                      CDL029A
     C                   IF        *IN91 = '1'                                               BUG6124
     C                   EVAL      ReturnCode = 'Error'                                      BUG6124
     C                   ADD       1             Idx                                         BUG6124
     C                   EVAL      FldNameArr(Idx) = 'DDBRCA'                                BUG6124
     C                   EVAL      MsgIDArr(Idx) = 'FXM7001'                                 BUG6124
     C                   END                                                                 BUG6124
      *                                                                                      BUG6124
      ** Use the return code's value to set the field's OK flag                              CDL029A
     C                   CALLB     'ZASETOKFLG'                                              CDL029A
     C                   PARM                    DDBRCAOK                                    CDL029A
     C                   PARM                    ReturnCode                                  CDL029A
     C                   PARM                    WarnGlobal                                  CDL029A
                                                                                             CDL029A
     C                   END                                                                 BUG6124
      *                                                                                      BUG6124

      /COPY WNCPYSRC,MMNASPV015

      *  *------------------------*
      *  * Validate Customer      *  #08
      *  *------------------------*
     C                   EXSR      RESETERRS

     C                   CALLB     'MMVNABCUST'
     C                   PARM                    ReturnCode
     C                   PARM                    Msg1
     C                   PARM                    CustFormat
      ** Bought From Customer
     C                   PARM                    DDCSNM           10
      ** Deal Type
     C                   PARM                    DDMTYP            2
      ** Bought From Customer Number
     C                   PARM                    IHCNUM
      ** Bought From Customer Shortname
     C                   PARM                    IHCSNM           10

      /COPY WNCPYSRC,MMNASPV016


     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCSNM'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDCsnmOK                       * NB
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,MMNASPV017

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

      /COPY WNCPYSRC,MMNASPV018

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMDAT'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

     C     MSG2          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMDAT'
     C                   EVAL      MsgIDArr(Idx) = MSG2
     C                   ENDIF

     C     WMSGID1       IFNE      *BLANK
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDMDAT'
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID1
     C                   ENDIF

     C     WMSGID2       IFNE      *BLANK
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDMDAT'
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID2
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDMdatOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,MMNASPV019

      *  *-------------------------------*
      *  * Validate Account Sequence No. *  #10
      *  *-------------------------------*
     C                   EXSR      RESETERRS

     C                   CALLB     'MMVACSEQ'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    DDACSQ
     C                   PARM                    IHACSQ
      ** Decimal separator (1A, from SDDEALPD, via caller
     C                   PARM                    BNDCSP

      /COPY WNCPYSRC,MMNASPV020

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDACSQ'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDAcSqOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,MMNASPV021

      *  *-------------------*
      *  * Validate Currency *  #11
      *  *-------------------*
     C                   EXSR      RESETERRS

     C                   CALLB     'MMVCURCODE'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    DDCCY
     C                   PARM                    BGFIIN
     C                   PARM                    BGTRMG
     C****************** PARM                    SDCURR                                       CSD006
     C     SDCURR        PARM                    DSSDY                                        CSD006

      /COPY WNCPYSRC,MMNASPV022

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCCY '
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      ** Set up the file version of the field, if no error.
     C                   IF        ReturnCode = *blank
     C                   Z-ADD     A6NBDP        IHCYDP
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDCcyOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,MMNASPV023

      *  *------------------------------*
      *  * Validate Face Value Amount   *  #12
      *  *------------------------------*
     C                   EXSR      RESETERRS
      ** Put the brokerage into a 14-alpha amount field for MMVNASBRKG,
      ** removing any leading or trailing blanks when doing so.
     C                   EVAL      Amount14A = %trim(DDFVAL)

     C                   CALLB     'MMVAMOUNT'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    Amount14A
     C                   PARM                    DDCcyOK
     C                   PARM                    IHCYDP
     C                   PARM                    DDMTYP
     C                   PARM                    IHFVAL
      ** Currency separator (1A, from SDDEALPD, via caller)
     C                   PARM                    BNDCSP
     C                   PARM                    DDACTN                                     AR569568
     C                   PARM                    CDL006                                     AR569568
     C                   CLEAR                   DDFVAL
     C                   MOVE      Amount14A     DDFVAL

      /COPY WNCPYSRC,MMNASPV024

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFVAL'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDFValOK                       * NB
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,MMNASPV025

      *  *------------------------*
      *  * Validate Book Code     *  #13
      *  *------------------------*
     C                   EXSR      RESETERRS

     C                   CALLB     'MMVBOOKCDE'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    MSG2
     C                   PARM                    MSG3
     C                   PARM                    MSG4
     C                   PARM                    MSGDATA2
     C                   PARM                    MSGDATA3
     C                   PARM                    MSGDATA4
     C                   PARM                    DDBOKC
     C                   PARM                    BNBCOP
     C                   PARM                    FCPORS
     C                   PARM                    BNBKCD
     C                   PARM                    DDCSNM
     C                   PARM                    DDPTFR            4
     C                   PARM                    DDBRCA
     C                   PARM                    FCR997
     C                   PARM                    ERPLCS            7
     C                   PARM                    PortRef
     C                   PARM                    QBCUST            6
     C                   PARM                    BGPFMG                         CPB001
     C                   PARM                    BGN4ST                                       222373

      /COPY WNCPYSRC,MMNASPV026

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBOKC'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

     C     MSG2          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPTFR'
     C                   EVAL      MsgIDArr(Idx) = MSG2
     C                   ENDIF
     C     MSGDATA2      IFNE      *BLANK
     C                   MOVEA     MSGDATA2      MsgDtaArr(Idx)
     C                   ENDIF

     C     MSG3          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPTFR'
     C                   EVAL      MsgIDArr(Idx) = MSG3
     C                   ENDIF
     C     MSGDATA3      IFNE      *BLANK
     C                   MOVEA     MSGDATA3      MsgDtaArr(Idx)
     C                   ENDIF

     C     MSG4          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPTFR'
     C                   EVAL      MsgIDArr(Idx) = MSG4
     C                   ENDIF
     C     MSGDATA4      IFNE      *BLANK
     C                   MOVEA     MSGDATA4      MsgDtaArr(Idx)
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDBokcOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,MMNASPV027

      *  *----------------------------------*
      *  * Validate Linked Reference Number *  #14
      *  *----------------------------------*
     C                   EXSR      RESETERRS

     C                   CALLB     'MMVLINKREF'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    DDLnkN
      ** Decimal separator (1A, from SDDEALPD, via caller
     C                   PARM                    BNDCSP

      /COPY WNCPYSRC,MMNASPV028

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDLNKN'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDLnkNOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,MMNASPV029

      *  *-------------------------*
      *  * Validate Bill Depot Id. *  #15
      *  *-------------------------*

     C                   EXSR      RESETERRS

     C                   CALLB     'MMVBLDEPOT'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    DDBDID
     C                   PARM                    DDMTYP
      * Futures & Options Flag (from SDMMODPD)
     C                   PARM                    BGFUOP
     C**********         PARM                    IRBDID            6 0                 191947 CSD027
     C                   PARM                    IRBDID            6                          CSD027

      /COPY WNCPYSRC,MMNASPV030

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBDID'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDBDIDOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,MMNASPV031

      *  *----------------------------------------*
      *  * Validate Round Down Interest Indicator *  #16
      *  *----------------------------------------*
     C                   EXSR      RESETERRS

     C                   CALLB     'MMVRNDDOWN'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    DDRdfc
     C                   PARM                    A6Rdfc
     C                   PARM                    BrRdfc

      /COPY WNCPYSRC,MMNASPV032

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRDFC'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDRDFCOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,MMNASPV033

      *  *------------------------*
      *  * Validate Interest Rate *  #17
      *  *------------------------*
     C                   EXSR      RESETERRS

     C                   CALLB     'MMVNABIRAT'
     C                   PARM                    ReturnCode
     C                   PARM                    Msg1
      ** Deal type (2A, from transaction)
     C                   PARM                    DDMTYP
      ** Interest Rate, from transaction
     C                   PARM                    DDINTR                        12A
      ** Decimal separator (1A, from SDDEALPD)
     C                   PARM                    BNDCSP
      **
     C                   PARM                    IHFRAT

      /COPY WNCPYSRC,MMNASPV034

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDINTR'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDINTROK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,MMNASPV035

      *  *-----------------------------*
      *  * Validate Calculation Method *  #18
      *  *-----------------------------*
     C                   EXSR      RESETERRS

     C                   CALLB     'ZAVINTCALC'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    DDICMT
     C                   PARM                    A6DICB

      /COPY WNCPYSRC,MMNASPV036

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDICMT'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDICMTOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,MMNASPV037

      *  *-------------------------------------*
      *  * Validate Interest Payment Frequency *  #19
      *  *-------------------------------------*
     C                   EXSR      RESETERRS

     C                   CALLB     'MMVNABIPFQ'
     C                   PARM                    ReturnCode
     C                   PARM                    Msg1
     C                   PARM                    DDIPFQ
     C                   PARM                    DDNDAT
     C                   PARM                    DDINTR

      /COPY WNCPYSRC,MMNASPV038

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDIPFQ'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDIPFQOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,MMNASPV039

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

      /COPY WNCPYSRC,MMNASPV040

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNDAT'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

     C     WMSGID1       IFNE      *BLANK
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDNDAT'
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDNDatOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,MMNASPV041

      *  *-------------------------------------*
      *  * Validate Start/Last Interest Date   *  #21
      *  *-------------------------------------*
     C                   EXSR      RESETERRS

     C                   CALLB     'MMVSLINTDT'
     C                   PARM                    ReturnCode
     C                   PARM                    Msg1
     C                   PARM                    WMsgid1
      ** Start/Last Int date
     C                   PARM                    DDSLID            6
      ** Action Code                                                            136430
     C                   PARM                    DDACTN            1            136430
      ** Deal Type
     C                   PARM                    DDMTYP            2
      ** Next Interest date
     C                   PARM                    DDNDAT            6
      ** Value date
     C                   PARM                    DDVDAT            6
      ** Value date OK
     C                   PARM                    DDVdatOK          1
      ** Value date (Midas number format)
     C                   PARM                    IHDVSD
      ** Next Interest date (Midas number format)
     C                   PARM                    IHNIPD
     C                   PARM                    RecSetCcy
     C                   PARM                    RecSetMeth
      ** Receive Nostro Location
     C                   PARM                    RLOC              3
     C                   PARM                    BJSLCD            3
     C                   PARM                    BJLCCY            3
      ** Date format indicator (1A from SDBANKPD)
     C                   PARM                    BJDFIN
      ** Start/Last Int date (MMSTDBPP - Midas number format)
     C                   PARM                    IHSLID            5 0
      ** Currency Code
     C                   PARM                    DDCCY             3

      /COPY WNCPYSRC,MMNASPV042

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSLID'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
     C     MSG2          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSLID'
     C                   EVAL      MsgIDArr(Idx) = MSG2
     C                   ENDIF
     C     MSG3          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSLID'
     C                   EVAL      MsgIDArr(Idx) = MSG3
     C                   ENDIF
     C     WMSGID1       IFNE      *BLANK
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDSLID'
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDSlidOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,MMNASPV043

      *  *--------------------------*
      *  * Validate Discount Rate   *  #22
      *  *--------------------------*
     C                   EXSR      RESETERRS

     C                   CALLB     'MMVDISRATE'
     C                   PARM                    ReturnCode
     C                   PARM                    Msg1
      ** Discount rate
     C                   PARM                    DDDCRT           11
      ** Deal Type
     C                   PARM                    DDMTYP            2
      ** Interest rate -      (Std. Deals file MMSTDBPP)
     C                   PARM                    IHINTR           11 7
      ** Discount rate -      (Std. Deals file MMSTDBPP)
     C                   PARM                    IHDCRT           11 7
      ** Face rate     -      (Std. Deals file MMSTDBPP)
     C                   PARM                    IHFRAT           11 7
      ** Decimal separator
     C                   PARM                    BNDCSP            1

      /COPY WNCPYSRC,MMNASPV044

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDCRT'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDDCRTOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,MMNASPV045

      *  *------------------------------------------*
      *  * Validate Interest Frequency Day in Month *  #23
      *  *------------------------------------------*
     C                   EXSR      RESETERRS

     C                   CALLB     'MMVNXINTDY'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    DDIPDM
     C                   PARM                    DDIPFQ
     C                   PARM                    DDNDAT
     C                   PARM                    DDNDatOK
     C                   PARM                    BJDFIN
     C                   PARM      'N'           W#CDL015          1                          CDL015

      /COPY WNCPYSRC,MMNASPV046

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDIPDM'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

     C     ReturnCode    IFNE      'Error'
     C     ReturnCode    ANDNE     'ErrAndWarn'
     C                   MOVE      DDIPDM        IHIPDM
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDIPDMOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,MMNASPV047

      *  *-------------------------*
      *  * Validate Purchase Price *  #24
      *  *-------------------------*

      ** Don't do this validation if the interest calculation method
      ** was not valid
     C                   IF        DDICMTOK <> 'N'
     C                   EXSR      RESETERRS

     C                   CALLB     'MMVNABPPRC'
     C                   PARM                    ReturnCode
     C                   PARM                    Msg1
     C                   PARM                    WMsgid1
     C                   PARM                    WMsgData
     C                   PARM                    DDAMNP
     C                   PARM                    DDMTYP
     C                   PARM                    IHCYDP
     C                   PARM                    BNDCSP
     C                   PARM                    IHNIPD
     C                   PARM                    IHSLID
     C                   PARM                    IHAMNP
     C                   PARM                    IHNANV
     C                   PARM                    IHINTR
     C                   PARM                    IHDCRT
     C                   PARM                    IHFRAT
     C                   PARM                    IHFVAL
     C                   PARM                    DDICMT
     C                   PARM                    IHMTYP
     C                   PARM                    DDIPFQ
     C                   PARM                    IHIPDM
     C                   PARM                    DDCCY
     C                   PARM                    IHMATD
     C                   PARM                    IHDVSD
     C                   PARM                    DDMtypOK
     C                   PARM                    DDCcyOK
     C                   PARM                    DDVdatOK
     C                   PARM                    DDMdatOK
     C                   PARM                    DDFvalOK
     C                   PARM                    DDIntrOK
     C                   PARM                    DDIcmtOK
     C                   PARM                    DDSlidOK
     C                   PARM                    DDipfqOK
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,MMNASPV048

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDAMNP'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
     C     WMSGID1       IFNE      *BLANK
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDAMNP'
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID1
     C                   ENDIF
     C     WMSGDATA      IFNE      *BLANK
     C                   EVAL      WMsgDtaArr(WIdx) = WMSGDATA
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDAMNPOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

     C                   ENDIF

      /COPY WNCPYSRC,MMNASPV049

      *  *--------------------------------------*
      *  * Validate Base Currency Exchange Rate *  #25
      *  *--------------------------------------*
     C                   EXSR      RESETERRS

     C                   CALLB     'MMVBCURRAT'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    MSGDATA
     C                   PARM                    DDBRAT
     C                   PARM                    DDCCY
     C                   PARM                    DDCCYOK
     C                   PARM                    A6SPRT
     C                   PARM                    A6SCEX
     C                   PARM                    A6MDIN
      ** Decimal separator (1A, from SDDEALPD, via caller
     C                   PARM                    BNDCSP
     C                   PARM                    BJCYCD
     C                   PARM                    IHBRAT
     C                   PARM                    IHMMDI
     C                   PARM                    DDACTN                                       191138

      /COPY WNCPYSRC,MMNASPV050

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBRAT'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
     C     MSGDATA       IFNE      *BLANK
     C                   MOVEA     MSGDATA       MsgDtaArr(Idx)
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDBRatOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,MMNASPV051

      *  *---------------------------------*
      *  * Validate Total Intererst Amount *  #26
      *  *---------------------------------*
     C                   EXSR      RESETERRS

     C                   CALLB     'MMVNABTOTI'
     C                   PARM                    ReturnCode
     C                   PARM                    Msg1
      ** Message data (45A)
     C                   PARM                    MsgData
      ** Total interest amount (14A, from transaction)
     C                   PARM                    DDMTTI
      ** Deal type (2A, from transaction)
     C                   PARM                    DDMTYP
      ** Interest calculation method (1A, from transaction)
     C                   PARM                    DDICMT
      ** Deal value date in Midas day number format (5,0P, from caller)
     C                   PARM                    IHDVSD
      ** Currency field OK flag (1A, from caller)
     C                   PARM                    DDCcyOK
      ** Number of decimal places in deal currency (1,0S, from SDCURRPD)
     C                   PARM                    IHCYDP
      ** Value date field OK (1A, from caller)
     C                   PARM                    DDVDatOK
      ** Maturity date in Midas day number format (5,0P, from caller)
     C                   PARM                    IHMATD
      ** Maturity date field OK (1A, from caller)
     C                   PARM                    DDMDATOK
      ** Round-down interest flag (1A, from transaction)
     C                   PARM                    DDRDFC
      ** Decimal separator (1A, from SDDEALPD)
     C                   PARM                    BNDCSP
      ** Global Warning indicator
     C                   PARM                    WarnGlobal
      ** Face value OK flag
     C                   PARM                    DDFValOK
      ** Interest OK flag
     C                   PARM                    DDIntrOK
      * Face Value
     C                   PARM                    IHFVAL
      * Face Rate
     C                   PARM                    IHFRAT
      * Midas Total Interest
     C                   PARM                    IHMTTI

      /COPY WNCPYSRC,MMNASPV052

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMTTI'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
     C     MSGDATA       IFNE      *BLANK
     C                   MOVEA     MSGDATA       MsgDtaArr(Idx)
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDMTTIOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,MMNASPV053

      *  *---------------------------*
      *  * Validate Parcel Indicator *  #27
      *  *---------------------------*
     C                   EXSR      RESETERRS

     C                   CALLB     'MMVPARCIND'
     C                   PARM                    ReturnCode
     C                   PARM                    Msg1
     C                   PARM                    DDPCLI

      /COPY WNCPYSRC,MMNASPV054

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPCLI'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDPCLIOK          1
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,MMNASPV055

      *  *----------------------*
      *  * Validate Parcel Size *  #28
      *  *----------------------*
     C                   EXSR      RESETERRS

     C                   CALLB     'MMVNABPSIZ'
     C                   PARM                    ReturnCode
     C                   PARM                    Msg1
     C                   PARM                    DDPSZE
     C                   PARM                    DDPCLI
     C                   PARM                    DDPcliOK
     C                   PARM                    DDFvalOK
     C                   PARM                    IHFVAL
     C                   PARM                    IHAMNP
     C                   PARM                    IHPSZE
     C                   PARM                    DDAmnpOK
     C                   PARM                    BNDCSP

      /COPY WNCPYSRC,MMNASPV056

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPSZE'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDPSZEOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,MMNASPV057

      *  *--------------------------------------------*
      *  * Validate Originating Branch                *  #29
      *  *--------------------------------------------*
     C                   EXSR      RESETERRS

     C                   CALLB     'ZAVORGBRCH'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    DDORBR
     C                   PARM                    DDBrCAOK
     C                   PARM                    DDBRCA
     C                   PARM                    BGMBIN
     C                   PARM                    BKOBRU
     C                   PARM                    BKOBUV
     C                   PARM                    RESPMODE

      /COPY WNCPYSRC,MMNASPV058

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDORBR'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDOrBrOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,MMNASPV059

      *  *--------------------------------------------*
      *  * Validate Profit Centre                     *  #30
      *  *--------------------------------------------*
     C                   EXSR      RESETERRS

     C                   CALLB     'ZAVPROFITC'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    DDPRFC
     C                   PARM                    BKPRCU
     C                   PARM                    BKPRCA
     C                   PARM                    BKPCDU
     C                   PARM                    DDMTYP
     C                   PARM                    BBACOC            2
     C                   PARM                    BBCUST            6
     C                   PARM                    DDBOKC
     C                   PARM                    DDSTYP
     C                   PARM                    DDBRCA
     C                   PARM                    DEPT
     C                   PARM                    PSUser
     C                   PARM                    DDCsnmOK
     C                   PARM                    BGN0ST

      /COPY WNCPYSRC,MMNASPV060

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPRFC'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDPrfCOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      /COPY WNCPYSRC,MMNASPV061

      *  *-------------------------------*
      *  * Validate Funding Details      *  #31
      *  *-------------------------------*

     C     BGN0ST        IFEQ      'Y'
     C     CDE002        OREQ      'Y'                                          CDE002

      * Reset variables updated by each module before each call
     C                   EXSR      RESETERRS

     C                   CALLB     'MMVFUNDDTS'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    MSG2
     C                   PARM                    MSG3
     C                   PARM                    WMSGID1
     C                   PARM                    ErrFundRat
     C                   PARM                    ErrFundSgn
     C                   PARM                    ErrFundPrf
     C                   PARM                    DDFSRP
     C                   PARM      *BLANK        DDFSGN            1
     C                   PARM                    DDFPRC
     C                   PARM      DDCCY         TranCCY           3
     C                   PARM      DDPRFC        TranPCCD          4
     C                   PARM      IHINTR        TranINTR         11 7
     C                   PARM                    BJLCCY
     C                   PARM                    FTTFRT
     C                   PARM                    IHFSRP
     C                   PARM                    IHFSGN
     C                   PARM                    IHFPRC
     C                   PARM                    BGN0ST                         CDE002
     C                   PARM                    BNDCSP                                       245692

      /COPY WNCPYSRC,MMNASPV062

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFSRP'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
     C     MSG3          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFPRC'
     C                   EVAL      MsgIDArr(Idx) = MSG3
     C                   ENDIF
     C     WMSGID1       IFNE      *BLANK
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDFSRP'
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID1
     C                   ENDIF

      ** Convert the 'field in error' flags to set the 'field OK' flags
      ** N.B. This is non-standard processing and takes the place of the
      **  call(s) to ZASETOKFLG.
     C                   CALLB     'ZACVTFLG'
     C                   PARM                    ddFSRPok
     C                   PARM                    ErrFundRat

     C                   CALLB     'ZACVTFLG'
     C                   PARM                    ddFPRCok
     C                   PARM                    ErrFundPrf

     C                   ENDIF

      *  *------------------------*                                                           CAS001
      *  * Validate Yield Rate    *                                                           CAS001
      *  *------------------------*                                                           CAS001
                                                                                              CAS001
     C                   IF        CAS001 = 'Y' AND                                           CAS001
     C                             DDMtypOK = 'Y' AND                                         CAS001
     C                             DDStypOK = 'Y' AND                                         CDL038
     C                             DDClasOK = 'Y'                                             CDL038
     C*****************************DDStypOK = 'Y'                                      CAS001 CDL038
                                                                                              CAS001
     C                   EXSR      RESETERRS                                                  CAS001
                                                                                              CAS001
     C                   CALLB     'ZAVYLDC01'                                                CAS001
                                                                                              CAS001
      ** Return Code                                                                          CAS001
     C                   PARM                    ReturnCode                                   CAS001
      ** Deal Screen fields                                                                   CAS001
     C                   PARM                    DDMTYP                                       CAS001
     C                   PARM                    DDSTYP                                       CAS001
     C                   PARM                    DDCLAS                                       CDL038
     C                   PARM                    DDOYLC                                       CAS001
      ** Field name                                                                           CAS001
     C                   PARM      'DDOYLC'      PYCFN                                        CAS001
                                                                                              CAS005
      ** Forward/Revaluation Flag                                                             CAS005
                                                                                              CAS005
     C                   PARM      *BLANKS       PFwRv                                        CAS005
                                                                                              CAS005
      ** Forward Yield Curve, to be checked if validating Reval Yield Curve                   CAS005
                                                                                              CAS005
     C                   PARM      *BLANKS       PFwYC                                        CAS005
                                                                                              CAS005
      ** Forward Commitment/Revaluation Flag                                                  CAS008
                                                                                              CAS008
     C                   PARM      *BLANKS       PFCRv                                        CAS008
                                                                                              CAS008
     C                   PARM                    DDOylcOK                                     CAS001
     C                   PARM      *BLANKS       PERTP                                        CAS001
     C                   PARM                    IHOYLC                                       CAS001
                                                                                              CAS001
     C                   IF        ReturnCode <> *Blanks                                      CAS001
     C                   EVAL      Idx = Idx + 1                                              CAS001
     C                   EVAL      FldNameArr(Idx) = 'DDOYLC'                                 CAS001
     C                   IF        PERTP = '1'                                                CAS001
     C                   EVAL      MsgIDArr(Idx) = 'FXM5055'                                  CAS001
     C                   ELSE                                                                 CAS001
     C                   EVAL      MsgIDArr(Idx) = 'FXM5057'                                  CAS001
     C                   ENDIF                                                                CAS001
     C                   ENDIF                                                                CAS001
                                                                                              CAS001
      ** Use the return code's value to set the field's OK flag                               CAS001
     C                   CALLB     'ZASETOKFLG'                                               CAS001
     C                   PARM                    DDOylcOK                                     CAS001
     C                   PARM                    ReturnCode                                   CAS001
     C                   PARM                    WarnGlobal                                   CAS001
                                                                                              CAS001
     C                   ENDIF                                                                CAS001
                                                                                              CAS005
      *  *-------------------------------------------*                                        CAS005
      *  * Validate Liquidity Premium                *                                        CAS005
      *  *-------------------------------------------*                                        CAS005
                                                                                              CAS005
     C                   IF        DDDCRTOK <> 'N'                                            224867
     C                             AND DDINTROK <> 'N'                                        224961
     C                             AND CAS005 = 'Y'                                           235508
                                                                                              224867
     C                   EXSR      RESETERRS                                                  CAS005
                                                                                              CAS005
     C                   CALLB     'MMVLIQR'                                                  CAS005
     C                   PARM                    ReturnCode                                   CAS005
     C                   PARM                    IHINTR                                       CAS005
     C                   PARM                    DDLQPR                                       CAS005
     C                   PARM                    DDLQPS                                       CAS005
     C                   PARM                    IHMTTI                                       CAS005
     C                   PARM                    MSG1                                         CAS005
     C                   PARM                    MSG2                                         CAS005
     C                   PARM                    DDLQPROK                                     CAS005
     C                   PARM                    DDLQPSOK                                     CAS005
     C                   PARM                    IHLQPR                                       CAS005
     C                   PARM                    IHLQPS                                       CAS005
     C                   PARM                    IHTNTR                                       CAS005
     C                   PARM                    BNDCSP                                       245692
                                                                                              CAS005
     C     MSG1          IFNE      *BLANK                                                     CAS005
     C                   ADD       1             Idx                                          CAS005
     C                   EVAL      FldNameArr(Idx) = 'DDLQPR'                                 CAS005
     C                   EVAL      MsgIDArr(Idx) = MSG1                                       CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C     MSG2          IFNE      *BLANK                                                     CAS005
     C                   ADD       1             Idx                                          CAS005
     C                   EVAL      FldNameArr(Idx) = 'DDLQPS'                                 CAS005
     C                   EVAL      MsgIDArr(Idx) = MSG2                                       CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** Use the return code's value to set the field's OK flag                               CAS005
                                                                                              CAS005
     C                   CALLB     'ZASETOKFLG'                                               CAS005
     C                   PARM                    DDLQPROK                                     CAS005
     C                   PARM                    ReturnCode                                   CAS005
     C                   PARM                    WarnGlobal                                   CAS005
                                                                                              CAS005
     C                   CALLB     'ZASETOKFLG'                                               CAS005
     C                   PARM                    DDLQPSOK                                     CAS005
     C                   PARM                    ReturnCode                                   CAS005
     C                   PARM                    WarnGlobal                                   CAS005

     C                   ENDIF                                                                224867
                                                                                              224867
      *  *-------------------------------------------*                                        CDL049
      *  * Validate Reference Rate                   *                                        CDL049
      *  *-------------------------------------------*                                        CDL049
                                                                                              CDL049
     C                   IF        CDL049 = 'Y'                                               CDL049
                                                                                              CDL049
     C                   EXSR      RESETERRS                                                  CDL049
      *                                                                                       CDL049
     C                   CALLB     'MMVNARRAT'                                                CDL049
     C                   PARM                    RETURNCODE                                   CDL049
     C                   PARM                    TRANIN                                       CDL049
     C                   PARM                    MSG1                                         CDL049
     C                   PARM      *BLANKS       PWMsgID1                                     CDL049
     C                   PARM                    IHINTR                                       CDL049
     C                   PARM                    IHRRAT                                       CDL049
      *                                                                                       CDL049
      * Update error fields/message IDs/message data (arrays)                                 CDL049
     C     MSG1          IFNE      *BLANK                                                     CDL049
     C                   ADD       1             Idx                                          CDL049
     C                   EVAL      FldNameArr(Idx) = 'DDRRAT'                                 CDL049
     C                   EVAL      MsgIDArr(Idx) = MSG1                                       CDL049
     C                   ENDIF                                                                CDL049
      *                                                                                       CDL049
      * Update warning fields/message IDs/message data (arrays)                               CDL049
     C     PWMsgID1      IFNE      *BLANKS                                                    CDL049
     C                   ADD       1             WIdx                                         CDL049
     C                   EVAL      WFldNamArr(WIdx) = 'DDRRAT'                                CDL049
     C                   EVAL      WMsgIDArr(WIdx) = PWMsgID1                                 CDL049
     C                   ENDIF                                                                CDL049
      *                                                                                       CDL049
     C                   ENDIF                                                                CDL049
                                                                                              CDL049
      *  *-------------------------------------------------------*
      *  * If no errors set up outstanding fields for valid file *
      *  *-------------------------------------------------------*

      /COPY WNCPYSRC,MMNASPV063

     C                   IF        Idx = 0
     C                   EXSR      SetupValid
     C                   ENDIF

      /COPY WNCPYSRC,MMNASPV064

     C                   RETURN

      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,MMNASPV067

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
     C                   PARM                    ExtData                        CAP004
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
                                                                                              CDL029
     C     KBRANCHAUTH   KLIST                                                                CDL029
     C**********         KFLD                    BBBRCD                               CDL029 CDL029A
     C                   KFLD                    W0BRCD            3                         CDL029A
     C                   KFLD                    W0CUST            6                         CDL029A
     C                   KFLD                    DDBRCA                                       CDL029

      **********                                                                             BUG6979
      ****GET*ZMUSER*to*access*default*branch.*************************                      BUG6979
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
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      ** Access Dealing details via access program
      *  (database error handling done in access program)
     C**********         CALLB     'AODEALR0'                                                 CGL029
     C                   CALLB     'AODEALR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
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
                                                                                CDE002
      ** Access SAR details file to determine if CDE002 is switched on          CDE002
                                                                                CDE002
     C                   CallB     'AOSARDR0'                                   CDE002
     C                   Parm      *Blanks       PRTCD             7            CDE002
     C                   Parm      '*VERIFY'     POPTN             7            CDE002
     C                   Parm      'CDE002'      PSARD             6            CDE002
     C     SCSARD        Parm      SCSARD        DSFDY                          CDE002
      *                                                                         CDE002
     C                   Move      'N'           CDE002            1            CDE002
     C                   If        PRTCD = *Blanks                              CDE002
     C                   Eval      CDE002 = 'Y'                                 CDE002
     C                   Endif                                                  CDE002
                                                                                              CSC011
     C                   EVAL      WProcDate = BJRDNB                                         CSC011
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRTCD                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *Blanks                                            CSC011
                                                                                              CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
                                                                                              CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
                                                                                              CSC011
      ** If 24X7 Midas availability is installed and support system is                        CSC011
      ** active, used processing date from dataarea SC24X7 as the                             CSC011
      ** rundate.                                                                             CSC011
                                                                                              CSC011
     C                   IF        S1SUPP = LIBR                                              CSC011
     C                   EVAL      WProcDate = S1DATE                                         CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ELSE                                                                 CSC011
                                                                                              CSC011
      ** Database error                                                                       CSC011
                                                                                              CSC011
     C                   IF        PRTCD <> '*NRF'                                            CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 900                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
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
      *                                                                         CDL011
      ** Access SAR details file to determine if CDL011 is on.                  CDL011
      ** (Expansion of Customer Number on Dealing Transactions)                 CDL011
      *                                                                         CDL011
     C                   CALLB     'AOSARDR0'                                   CDL011
     C                   PARM      *BLANKS       @RTCD                          CDL011
     C                   PARM      '*VERIFY'     @OPTN                          CDL011
     C                   PARM      'CDL011'      @SARD                          CDL011
     C     SCSARD        PARM      SCSARD        DSFDY                          CDL011
      *                                                                         CDL011
     C     @RTCD         IFNE      *BLANKS                                      CDL011
     C     @RTCD         ANDNE     '*NRF   '                                    CDL011
     C                   MOVEL     'CDL011'      DBKEY                          CDL011
     C                   MOVEL     'SCSARDPD'    DBFILE                         CDL011
     C                   MOVEL     '004'         DBASE                          CDL011
     C                   EXSR      *PSSR                                        CDL011
     C                   END                                                    CDL011
     C*                                                                         CDL011
     C     @RTCD         IFEQ      *BLANK                                       CDL011
     C                   MOVEL     'S'           CustFormat                     CDL011
     C                   END                                                    CDL011
                                                                                              CAS001
      ** Access SAR details file to determine if CAS001 is on.                                CAS001
      ** (Net Present Value Accounting)                                                       CAS001
                                                                                              CAS001
     C                   CALLB     'AOSARDR0'                                                 CAS001
     C                   PARM      *BLANKS       PRTCD                                        CAS001
     C                   PARM      '*VERIFY'     POPTN                                        CAS001
     C                   PARM      'CAS001'      PSARD                                        CAS001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS001
     C                   IF        PRTCD <> *BLANKS AND                                       CAS001
     C                             PRTCD <> '*NRF   '                                         CAS001
     C     *LOCK         IN        LDA                                                        CAS001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS001
     C                   EVAL      DBASE = 002                                                CAS001
     C                   EVAL      DBKEY = 'CAS001'                                           CAS001
     C                   OUT       LDA                                                        CAS001
     C                   EVAL      *INU7 = *ON                                                CAS001
     C                   EVAL      *INU8 = *ON                                                CAS001
     C                   EVAL      *INLR = *ON                                                CAS001
     C                   EXSR      #TERM                                                      CAS001
     C                   ENDIF                                                                CAS001
     C                   IF        PRTCD = *BLANKS                                            CAS001
     C                   EVAL      CAS001 = 'Y'                                               CAS001
     C                   ELSE                                                                 CAS001
     C                   EVAL      CAS001 = 'N'                                               CAS001
     C                   ENDIF                                                                CAS001
                                                                                              CDL010
      ** Access SAR details file to determine if CDL010 is on.                                CDL010
      ** (Dealing Transaction Authorisation)                                                  CDL010
                                                                                              CDL010
     C                   CALLB     'AOSARDR0'                                                 CDL010
     C                   PARM      *BLANKS       PRTCD                                        CDL010
     C                   PARM      '*VERIFY'     POPTN                                        CDL010
     C                   PARM      'CDL010'      PSARD                                        CDL010
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL010
     C                   IF        PRTCD <> *BLANKS AND                                       CDL010
     C                             PRTCD <> '*NRF   '                                         CDL010
     C     *LOCK         IN        LDA                                                        CDL010
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CDL010
     C                   EVAL      DBASE = 003                                                CDL010
     C                   EVAL      DBKEY = 'CDL010'                                           CDL010
     C                   OUT       LDA                                                        CDL010
     C                   EVAL      *INU7 = *ON                                                CDL010
     C                   EVAL      *INU8 = *ON                                                CDL010
     C                   EVAL      *INLR = *ON                                                CDL010
     C                   EXSR      #TERM                                                      CDL010
     C                   ENDIF                                                                CDL010
     C                   IF        PRTCD = *BLANKS                                            CDL010
     C                   EVAL      CDL010 = 'Y'                                               CDL010
     C                   ELSE                                                                 CDL010
     C                   EVAL      CDL010 = 'N'                                               CDL010
     C                   ENDIF                                                                CDL010
                                                                                              CAS005
      ** Access SAR details file to determine if CAS005 is on.                                CAS005
      ** (Enhancements to CAS001, CAS002 and CAS004)                                          CAS005
                                                                                              CAS005
     C                   CALLB     'AOSARDR0'                                                 CAS005
     C                   PARM      *BLANKS       PRTCD                                        CAS005
     C                   PARM      '*VERIFY'     POPTN                                        CAS005
     C                   PARM      'CAS005'      PSARD                                        CAS005
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS005
     C                   IF        PRTCD <> *BLANKS AND                                       CAS005
     C                             PRTCD <> '*NRF   '                                         CAS005
     C     *LOCK         IN        LDA                                                        CAS005
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS005
     C                   EVAL      DBASE = 3                                                  CAS005
     C                   EVAL      DBKEY = 'CAS005'                                           CAS005
     C                   OUT       LDA                                                        CAS005
     C                   EVAL      *INU7 = *ON                                                CAS005
     C                   EVAL      *INU8 = *ON                                                CAS005
     C                   EVAL      *INLR = *ON                                                CAS005
     C                   EXSR      #TERM                                                      CAS005
     C                   ENDIF                                                                CAS005
     C                   IF        PRTCD = *BLANKS                                            CAS005
     C                   EVAL      CAS005 = 'Y'                                               CAS005
     C                   ELSE                                                                 CAS005
     C                   EVAL      CAS005 = 'N'                                               CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CDL029
     C                   CALLB     'AOSARDR0'                                                 CDL029
     C                   PARM      *BLANKS       PRTCD                                        CDL029
     C                   PARM      '*VERIFY'     POPTN                                        CDL029
     C                   PARM      'CDL029'      PSARD                                        CDL029
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL029
     C                   IF        PRTCD <> *BLANKS AND                                       CDL029
     C                             PRTCD <> '*NRF   '                                         CDL029
     C     *LOCK         IN        LDA                                                        CDL029
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CDL029
     C                   EVAL      DBASE = 014                                                CDL029
     C                   EVAL      DBKEY = 'CDL029'                                           CDL029
     C                   OUT       LDA                                                        CDL029
     C                   EVAL      *INU7 = *ON                                                CDL029
     C                   EVAL      *INU8 = *ON                                                CDL029
     C                   EVAL      *INLR = *ON                                                CDL029
     C                   EXSR      #TERM                                                      CDL029
     C                   ENDIF                                                                CDL029
     C                   IF        PRTCD = *BLANKS                                            CDL029
     C                   EVAL      CDL029 = 'Y'                                               CDL029
     C                   ELSE                                                                 CDL029
     C                   EVAL      CDL029 = 'N'                                               CDL029
     C                   ENDIF                                                                CDL029
                                                                                              CDL029
     C                   CALLB     'AOSARDR0'                                                 CDL033
     C                   PARM      *BLANKS       PRTCD                                        CDL033
     C                   PARM      '*VERIFY'     POPTN                                        CDL033
     C                   PARM      'CDL033'      PSARD                                        CDL033
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL033
     C                   SELECT                                                               CDL033
     C                   WHEN      PRTCD = *BLANKS                                            CDL033
     C                   MOVE      'Y'           CDL033            1                          CDL033
     C                   WHEN      PRTCD <> '*NRF   '                                         CDL033
     C     *LOCK         IN        LDA                                                        CDL033
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CDL033
     C                   EVAL      DBASE = 015                                                CDL033
     C                   EVAL      DBKEY = PSARD                                              CDL033
     C                   OUT       LDA                                                        CDL033
     C                   EVAL      *INU7 = *ON                                                CDL033
     C                   EVAL      *INU8 = *ON                                                CDL033
     C                   EVAL      *INLR = *ON                                                CDL033
     C                   EXSR      #TERM                                                      CDL033
     C                   OTHER                                                                CDL033
     C                   MOVE      'N'           CDL033                                       CDL033
     C                   ENDSL                                                                CDL033
                                                                                             BUG9717
      ** Access SAR details file to determine if CDL038 is switched on                       BUG9717
                                                                                             BUG9717
     C                   CALLB     'AOSARDR0'                                                BUG9717
     C                   PARM      *BLANKS       PRTCD                                       BUG9717
     C                   PARM      '*VERIFY'     POPTN                                       BUG9717
     C                   PARM      'CDL038'      PSARD                                       BUG9717
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG9717
                                                                                             BUG9717
     C                   IF        PRTCD <> *BLANKS AND                                      BUG9717
     C                             PRTCD <> '*NRF   '                                        BUG9717
     C     *LOCK         IN        LDA                                                       BUG9717
     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG9717
     C                   EVAL      DBASE = 908                                               BUG9717
     C                   EVAL      DBKEY = 'CDL038'                                          BUG9717
     C                   OUT       LDA                                                       BUG9717
     C                   EXSR      *PSSR                                                     BUG9717
     C                   ENDIF                                                               BUG9717
                                                                                             BUG9717
     C                   IF        PRTCD = *BLANKS                                           BUG9717
     C                   EVAL      CDL038 = 'Y'                                              BUG9717
     C                   ELSE                                                                BUG9717
     C                   EVAL      CDL038 = 'N'                                              BUG9717
     C                   ENDIF                                                               BUG9717
                                                                                             BUG9827
      ** Access SAR details file to determine if CDL006 is switched on                       BUG9827
                                                                                             BUG9827
     C                   CALLB     'AOSARDR0'                                                BUG9827
     C                   PARM      *BLANKS       PRTCD                                       BUG9827
     C                   PARM      '*VERIFY'     POPTN                                       BUG9827
     C                   PARM      'CDL006'      PSARD                                       BUG9827
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG9827
                                                                                             BUG9827
     C                   IF        PRTCD <> *BLANKS AND                                      BUG9827
     C                             PRTCD <> '*NRF   '                                        BUG9827
     C     *LOCK         IN        LDA                                                       BUG9827
     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG9827
     C                   EVAL      DBASE = 909                                               BUG9827
     C                   EVAL      DBKEY = 'CDL006'                                          BUG9827
     C                   OUT       LDA                                                       BUG9827
     C                   EXSR      *PSSR                                                     BUG9827
     C                   ENDIF                                                               BUG9827
                                                                                             BUG9827
     C                   IF        PRTCD = *BLANKS                                           BUG9827
     C                   EVAL      CDL006 = 'Y'                                              BUG9827
     C                   ELSE                                                                BUG9827
     C                   EVAL      CDL006 = 'N'                                              BUG9827
     C                   ENDIF                                                               BUG9827
                                                                                             BUG9827
                                                                                             BUG9717
      ** Access SAR details file to determine if CDL049 is switched on                        CDL049
                                                                                              CDL049
     C                   CALLB     'AOSARDR0'                                                 CDL049
     C                   PARM      *BLANKS       PRTCD                                        CDL049
     C                   PARM      '*VERIFY'     POPTN                                        CDL049
     C                   PARM      'CDL049'      PSARD                                        CDL049
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL049
      *                                                                                       CDL049
     C                   IF        PRTCD = *BLANKS                                            CDL049
     C                   EVAL      CDL049 = 'Y'                                               CDL049
     C                   ELSE                                                                 CDL049
     C                   EVAL      CDL049 = 'N'                                               CDL049
     C                   ENDIF                                                                CDL049
      *
      *  Set up the name of the MSGF from which the message handler will
      *   get the messages
     C                   EVAL      #MsgFile = 'DRSMM'

      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,MMNASPV068

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
     C                   RESET                   Msg2C                                        CDL038
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
      /EJECT                                                                                  CDL038
      *****************************************************************                       CDL038
      * Default Sub Type and Class                                                            CDL038
      *****************************************************************                       CDL038
     C     DSUBTCLAS     BEGSR                                                                CDL038
      *                                                                                       CDL038
     C                   CALL      'DL002000'                                                 CDL038
      * Inputs                                                                                CDL038
     C                   PARM                    DDACTN                                       CDL038
     C                   PARM                    DDMTYP                                       CDL038
     C                   PARM                    DDISUR                                       CDL038
     C                   PARM                    DDVDAT                                       CDL038
     C                   PARM                    DDMDAT                                       CDL038
     C                   PARM                    DDBOKC                                       CDL038
     C                   PARM                    DDPRFC                                       CDL038
     C                   PARM                    DDCCY                                        CDL038
     C                   PARM      *BLANK        @Currency2        3                          CDL038
     C                   PARM      *BLANK        @RelatedDeal      6                          CDL038
      * Inputs/Outputs                                                                        CDL038
     C                   PARM                    DDSTYP                                       CDL038
     C                   PARM                    DDCLAS                                       CDL038
      *                                                                                       CDL038
     C                   ENDSR                                                                CDL038
      *****************************************************************                       CDL038
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
     C     DDMTYP        IFEQ      'C1'                                         140930
     C                   MOVE      IHISUR        IHCSNM                         140930
     C                   MOVE      IHISCN        IHCNUM                         140930
     C                   END                                                    140930
     C                   MOVE      DDFEDF        IHFEDF
     C                   MOVE      DDBRCA        IHBRCA
     C                   MOVE      DDBKCD        IHBKCD
     C                   MOVE      DDACSQ        IHACSQ
     C                   MOVE      DDCCY         IHCCY
     C                   MOVE      DDBOKC        IHBOKC
     C                   MOVE      DDLNKN        IHLNKN
     C**********         MOVE      DDBDID        IHBDID                                       191947
     C**********         Z-ADD     IRBDID        IHBDID                                191947 CSD027
     C                   Eval      IHBDID = IRBDID                                            CSD027
     C                   MOVE      DDICMT        IHICMT
     C                   MOVE      DDIPFQ        IHIPFQ
     C                   MOVE      DDIPDM        IHIPDM
     C                   MOVE      DDCDRF        IHCDRF
     C                   MOVE      DDRDFC        IHRDFC
     C                   MOVE      DDPCLI        IHPCLI
     C                   MOVE      DDORBR        IHORBR
     C                   MOVE      DDPRFC        IHPRFC
                                                                                              CDL010
      ** Set up The user field from ZMUSER which is the front office                          CDL010
      ** user if sent . Only if CDL010 is installed                                           CDL010
                                                                                              CDL010
     C     CDL010        IFEQ      'Y'                                                        CDL010
     C                   MOVE      ZUSER         IHUSER                                       CDL010
     C                   END                                                                  CDL010
                                                                                              CDL038
      ** Set up Class                                                                         CDL038
                                                                                              CDL038
     C                   MOVE      DDCLAS        IHCLAS                                       CDL038

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
(c) Finastra International Limited 2001
