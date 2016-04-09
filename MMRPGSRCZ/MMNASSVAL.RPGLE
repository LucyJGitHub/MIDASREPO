     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM NAs sold validation')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMNASSVAL - Validate Negotiable Assets Sold                  *
      *                                                               *
      *  Function: This module validates NAs Sold for Input into      *
      *            the Midas database.                                *
      *            The sequence of validation is based on subroutine  *
      *            #ZI in Midas program MM0027.                       *
      *            After validation the module  will return an array  *
      *            of fields in error to the caller, along with       *
      *            matching arrays containing the error messages and  *
      *            message data.                                      *
      *                                                               *
      *  Component of: MMVALIDATE - MM validation service program     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. AR569568           Date 22Nov12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 256564             Date 17Sep08               *
      *                 249967             Date 13Sep07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12582           Date 13Nov06               *
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 11Jul06               *
      *                 216117             Date 06Jun06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG9827            Date 13Jan06               *
      *                 BUG9711            Date 26Jan06               *
      *                 BUG9717            Date 29Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CAP086             Date 08Jun05               *
      *                 CDL033             Date 10Feb05               *
      *                 BUG7242            Date 06Jun05               *
      *                 CDL029A            Date 09May05               *
      *                 BUG6979            Date 04May05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CDL029             Date 23NOV04               *
      *                 BUG3131            Date 10Jun04               *
      *                 CLE025             Date 20Oct03               *
      *                 TCA090             Date 18Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 222373             Date 24Oct03               *
      *                 CDL011             Date 07Jul02               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 181274             Date 17Jul00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             Date 02Sep99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP004             Date 07Sep98               *
      *                 CAP002  *CREATE    Date 06OCT97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR569568 - CDL006 is not being passed causing zero amount to *
      *             be valid in Insert.  But in amendment, it will    *
      *             issue an error message MMM0372.(Child: AR569569)  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  249967 - Restrict validation of VDAT to insert               *
      *  BUG12582 - Additional validation during Authorize: Check if  *
      *             assoicated (purchase) deal is authorized.         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  216117 - Yield rate is an optional field for NAS deals with  *
      *           type equal to 'CS', 'BS' or 'BR'.                   *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG9827- Check that CDL006 is switched on                    *
      *  BUG9711- Changes to MMVNASPPD/MMVNASSPD (re-compile)         *
      *  BUG9717- Defaulting of class should be done when CDL038      *
      *           feature is currently ON.                            *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  CDL033 - Floating Rate CD Issued                             *
      *  BUG7242 - Yield rate should be optional for deal types CS,   *
      *            BS and BR Negotiable Assets Sold.  Also Yield rate *
      *            inserted as zero are output as blank on amendment  *
      *            and authorization rendering acceptance of the      *
      *            negotiable asset sold impossible.                  *
      *  CDL029A- Adding new field                                    *
      *  BUG6979 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CDL029 - Midas SD Authorised Booking Branches for Customers. *
      *  BUG3131 - Error message in Face Value during AMEND when      *
      *            field is actually not amendable.                   *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  TCA090 - User on NASSs sent through APISERVER is ignored     *
      *           Issuer returned as customer number not shortname    *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  222373 - Parameter Mismatch                                  *
      *  CDL011 - Expansion of Customer Number on Dealing Transactions*
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.                                     *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CSD006 - Use DSSDY as MMVCURCODE *ENTRY parm, not SDCURRPD   *
      *  181274 - Branch code  BRCA  not correctly initialised  and   *
      *           is  stopping  the input  of a  Deal Amendment  when *
      *           Settlement Method = 04  .   Error  msg   ESM0904 =  *
      *            'Must reference a Live Retail account '  issued  . *
      *  CPB001 - 'Private Banking' Module                            *
      *  CAP004 - API's Phase 3.                                      *
      *           Add extra parm for Extra Data                       *
      *           Remove unnecessary decalare of ZAFLDNPD             *
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
 
      ***Field*names/numbers*table*************************************         CAP004
     F*ZAFLDNPD**IT***F***15        DISK    INFSR(*PSSR)                        CAP004
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,MMNASSV040
 
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
      ** Flags to indicate whether transaction fields are valid
      ** These have been declared for all MM0027D2 fields, though some may
      ** not actually be needed if the field is not used/not validated
      ** The OKFlagsDS data structure is defined in the following /COPY
     D/COPY MMCPYSRC,MMNASSOK
      **--------------------------------------------------------------------------------------------
 
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
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** EXTERNAL DS FOR DEALING DETAILS
 
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
     D QQACC1        E                     EXTFLD(QQACCD)                                     CGL029
      ** EXTERNAL DS FOR TRADING DETAILS
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D QQACC2        E                     EXTFLD(QQACCD)                                     CGL029
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      **  Data structure for Portfolio Management ICD File
 
     D SDPLCS        E DS                  EXTNAME(SDPLCSPD)
      ** External data structure for portfolio management details
 
     D SDDLST        E DS                  EXTNAME(SDDLSTPD)
      ** EXTERNAL DS FOR DEAL SUBTYPE DETAILS
 
     D SDCUSTSold    E DS                  EXTNAME(SDCUSTPD)
      ** External data structure for sold to customer details
 
     D SDCUSTIsur    E DS                  EXTNAME(SDCUSTPD) PREFIX(I)
      ** External data structure for issued by customer details (renamed so
      ** as not to clash with sold to customer details)
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External data structure for currency details
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D QQDFC1        E                     EXTFLD(QQDFAC)                                     CGL029
      ** External data structure for branch details
 
     D SDBROK        E DS                  EXTNAME(SDBROKPD)
      ** External data structure for broker details
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC011
      ** Switchable features details                                                          CSC011
                                                                                              CSC011
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short data structure for access programs
                                                                                              CSD006
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CSD006
      ** Long data structure for access programs                                              CSD006
 
     D ValidDeal     E DS                  EXTNAME(MMVNASSPD)
      * Valid Deals layout
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status data area                                                                CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
                                                                                              CSC011
     D*ZMUSER**********DS************17    DTAARA(ZMUSER)                                     TCA090
     D ZMUSER          DS            17                                                       TCA090
      ** DS for ZMUSER data area, to get default branch (and department)
     D  ZUSER                  1     10                                                       CDL010
     D  BRC                   11     13
     D  DEPT                  14     16
 
     D TranIn        E DS                  EXTNAME(MMNASSPD)
      ** Incoming Transaction
 
     D MMDENBD0      E DS                  EXTNAME(MMDENBPP)
     D QQDOR1        E                     EXTFLD(DORIQQ)                                     CGL029
     D QQMOR1        E                     EXTFLD(MORIQQ)                                     CGL029
     D QQRON1        E                     EXTFLD(RONSQQ)                                     CGL029
     D QQPON1        E                     EXTFLD(PONSQQ)                                     CGL029
      ** External DS based on Negotiable assets purchased file
                                                                                CAP004
     D ExtData       E DS                  EXTNAME(MMNSEXPD)                    CAP004
      * MM NASS Extra Data - File (D/B) format                                  CAP004
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message fields returned from called procedures
     D     Msg1        S                   LIKE(#MsgID)
     D     Msg2        S                   LIKE(#MsgID)
     D     Msg2C       S                   LIKE(#MsgID)                                       CDL038
     D     Msg3        S                   LIKE(#MsgID)
     D     Msg4        S                   LIKE(#MsgID)
     D     Msg5        S                   LIKE(#MsgID)
     D     Msg6        S                   LIKE(#MsgID)
     D     Msg7        S                   LIKE(#MsgID)
 
      ** Warning error message fields returned from called procedures
     D     WMsgID1     S                   LIKE(#MsgID)
     D     WMsgID2     S                   LIKE(#MsgID)
     D     WMsgID3     S                   LIKE(#MsgID)
 
      ** Error message substitution data returned from called procedures
     D MsgData         S                   LIKE(#MsgData)
     D MsgData2        S                   LIKE(#MsgData)
     D MsgData3        S                   LIKE(#MsgData)
     D MsgData4        S                   LIKE(#MsgData)
 
      ** Index for arrays of error message IDs etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
      ** General-purpose OK flag, used as a dummy where a module requires
      ** the flag for a field that is not present in this type of
      ** transaction.
     D  OKFlag         S              1A   INZ('Y')
 
      ** Error flags from Dates validation routine
     D ErrDealDat      S              1A   INZ('N')
     D ErrValDate      S              1A   INZ('N')
 
      ** Overall Transaction status, to be passed to the Message Handler
     D TranStatus      S              1A
 
      ** Module ID, to be passed to the Message Handler
     D ModuleID        S              2A
 
      ** Portfolio reference (default value, returned from AOPLCSR1 in
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
 
      ** A code to indicate the calling function to the lower level modules
     D NASS            S              4A   INZ('NASS')
 
      ** Dummy field used to pass to book code validation, in place of
      ** DDPTFR (Portfolio Reference) which NAs don't have.
     D Dummy1          S              4A
 
      ** 14-alpha amount field for passing to MMVAMOUNT and MMVNASBRKG
      ** (because this module's fields are 15-alpha).
     D Amount14A       S             14A
 
      ** Response Mode, received as a parameter from the common header
     D RespMode        S              1A
 
      ** Fields defined for Enhancement CSC011                                                CSC011
     D CSC011          S              1A                                                      CSC011
     D PRtCd           S              7A                                                      CSC011
     D POptn           S              7A                                                      CSC011
     D PSard           S              6A                                                      CSC011
     D WRunDay         S                   LIKE(BJRDNB)                                       CSC011
                                                                                              CSC011
      ** Fields defined for Enhancement CDL010                                                CDL010
     D CDL010          S              1A                                                      CDL010
                                                                                              CDL010
      ** Fields defined for Enhancement CDL029                                                CDL029
     D CDL029          S              1A                                                      CDL029
                                                                                              CDL029
     D CDL038          S              1A                                                     BUG9717
     D CDL006          S              1A                                                     BUG9827
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,MMNASSV041
 
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
 
      /COPY WNCPYSRC,MMNASSV001
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
     C                   EXSR      ResetErrs
 
     C                   CALLB     'MMVDLTPSTP'
     C                   PARM                    ReturnCode
     C                   PARM                    Msg1
     C                   PARM                    Msg2
     C                   PARM                    MSG2C                                        CDL038
     C                   PARM                    Msg3
     C                   PARM                    DDMTypOK
     C                   PARM                    DDMTYP
     C                   PARM                    DDSTYP
     C                   PARM                    DDCLAS                                       CDL038
      ** Type of this transaction function (4A)
     C                   PARM                    NASS
     C                   PARM                    SDDLST
     ** Action code                                                                           222373
     C                   PARM      DDACTN        PActn             1                          222373
      ** Floating Rate CD Issued                                                              CDL033
     C                   PARM                    CDL033                                       CDL033
     ** Warning message ID                                                                    222373
     C                   PARM                    PWMsgID1          7                          222373
      ** Fiduciary deals                                                                      CDL033
     C                   PARM                    CDL006                                      BUG9827
 
      /COPY WNCPYSRC,MMNASSV002
 
     C     Msg1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMTYP'
     C                   EVAL      MsgIDArr(Idx) = Msg1
     C                   MOVE      'N'           DDMTypOK
     C                   ENDIF
     C     Msg2          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSTYP'
     C                   EVAL      MsgIDArr(Idx) = Msg2
     C                   MOVE      'N'           DDSTypOK
     C                   ENDIF
     C     Msg2C         IFNE      *BLANK                                       CDL038
     C                   ADD       1             Idx                            CDL038
     C                   EVAL      FldNameArr(Idx) = 'DDCLAS'                   CDL038
     C                   EVAL      MsgIDArr(Idx) = MSG2C                        CDL038
     C                   MOVE      'N'           DDClasOK                       CDL038
     C                   ENDIF                                                  CDL038
     C     Msg3          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMTYP'
     C                   EVAL      MsgIDArr(Idx) = Msg3
     C                   MOVE      'N'           DDMTypOK
     C                   MOVE      'N'           DDSTypOK
     C                   MOVE      'N'           DDClasOK                       CDL038
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDDltStpOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMNASSV003
 
      *  *----------------------------------*
      *  * Validate Federal funds indicator *  #02
      *  *----------------------------------*
     C                   EXSR      ResetErrs
     C                   CALLB     'MMVFEDFUND'
     C                   PARM                    ReturnCode
     C                   PARM                    Msg1
      ** Federal funds indicator
     C                   PARM                    DDFedf
      ** Currency code
     C                   PARM                    DDCcy
      ** US Currency code
     C                   PARM                    BLUSCY
 
      /COPY WNCPYSRC,MMNASSV004
 
     C     Msg1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFEDF'
     C                   EVAL      MsgIDArr(Idx) = Msg1
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDFedFOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMNASSV005
 
      *  *------------------------*
      *  * Validate All Dates     *  #03
      *  *------------------------*
 
     C                   EXSR      ResetErrs
     C                   CALLB     'MMVNASDATE'
     C                   PARM                    ReturnCode
      ** Message IDs 1 - 3 (Returned to caller)
     C                   PARM                    Msg1
     C                   PARM                    Msg2
     C                   PARM                    Msg3
      ** Warning message IDs 1 - 3 (Returned to caller)
     C                   PARM                    WMsgID1
     C                   PARM                    WMsgID2
     C                   PARM                    WMsgID3
      ** Error in deal date flag (1A, returned to caller; contains 'Y'
      ** if errors, 'W' if warnings ONLY)
     C                   PARM                    ErrDealDat
      ** Error in value date flag (1A, returned to caller; contains 'Y'
      ** if errors, 'W' if warnings ONLY)
     C                   PARM                    ErrValDate
      ** Standard deals file version of deal date (5,0P, returned from
      ** called module)
     C                   PARM                    ILDDND
      ** Standard deals file version of value date (5,0P, returned from
      ** called module)
     C                   PARM                    ILDVSD
      ** Standard deals file version of start/last interest date
      ** (5,0P, returned from called module)
     C                   PARM                    ILSLID
      ** Deal date (6A, from transaction)
     C                   PARM                    DDDLDT
      ** Value date (6A, from transaction)
     C                   PARM                    DDVDAT
      ** Run date (5,0P (Midas day number) from SDBANKPD via caller)
     C**********         PARM                    BJRDNB                                       CSC011
     C                   PARM                    WRunDay                                      CSC011
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
      ** Transaction type
     C                   PARM                    NASS
     C                   PARM                    DDACTN                                       249967
 
      /COPY WNCPYSRC,MMNASSV006
 
     C     Msg1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDLDT'
     C                   EVAL      MsgIDArr(Idx) = Msg1
     C                   ENDIF
     C     Msg2          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDLDT'
     C                   EVAL      MsgIDArr(Idx) = Msg2
     C                   ENDIF
     C     Msg3          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDVDAT'
     C                   EVAL      MsgIDArr(Idx) = Msg3
     C                   ENDIF
 
     C     WMsgID1       IFNE      *BLANK
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDDDAT'
     C                   EVAL      WMsgIDArr(WIdx) = WMsgID1
     C                   ENDIF
     C     WMsgID2       IFNE      *BLANK
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDVDAT'
     C                   EVAL      WMsgIDArr(WIdx) = WMsgID2
     C                   ENDIF
     C     WMsgID3       IFNE      *BLANK
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDVDAT'
     C                   EVAL      WMsgIDArr(WIdx) = WMsgID3
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
 
      ** Set the global warning flag if any warning messages were generated
     C                   IF        ReturnCode = 'Warning' OR
     C                             ReturnCode = 'ErrAndWarn'
     C                   EVAL      WarnGlobal = 'Y'
     C                   ENDIF
 
      /COPY WNCPYSRC,MMNASSV007
 
      *  *------------------------*
      *  * Validate Broker Code   *  #05
      *  *------------------------*
     C                   EXSR      ResetErrs
 
     C                   CALLB     'MMVBROKCDE'
     C                   PARM                    ReturnCode
     C                   PARM                    Msg1
     C                   PARM                    DDBKCD
     C                   PARM                    ILBKCY
     C                   PARM                    ILBCDP
     C                   PARM                    SDBROK
 
      /COPY WNCPYSRC,MMNASSV008
 
     C     Msg1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBKCD'
     C                   EVAL      MsgIDArr(Idx) = Msg1
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDBkCdOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMNASSV009
 
      *  *------------------------*
      *  * Validate Brokerage     *  #07
      *  *------------------------*
     C                   EXSR      ResetErrs
 
      ** Put the brokerage into a 14-alpha amount field for MMVNASBRKG,
      ** removing any leading or trailing blanks when doing so.
     C                   EVAL      Amount14A = %trim(DDBRKG)
 
     C                   CALLB     'MMVNASBRKG'
     C                   PARM                    ReturnCode
     C                   PARM                    Msg1
     C                   PARM                    ILBRKG
     C                   PARM                    ILBKCY
     C                   PARM                    DDBKCD
     C                   PARM                    Amount14A
     C                   PARM                    A9BRCY
      ** Decimal separator (1A, from SDDEALPD, via caller
     C                   PARM                    BNDCSP
     C                   PARM                    DDBkCdOK
 
      /COPY WNCPYSRC,MMNASSV010
 
     C     Msg1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBRKG'
     C                   EVAL      MsgIDArr(Idx) = Msg1
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDBrkgOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMNASSV011
 
      *  *-----------------------------*
      *  * Validate Issued by Customer *
      *  *-----------------------------*
     C                   EXSR      ResetErrs
 
     C                   CALLB     'MMVCUSNONP'
     C                   PARM                    ReturnCode
     C                   PARM                    Msg1
     C                   PARM                    CustFormat
     C                   PARM                    ILISUR
     C                   PARM                    ILISCN
     C                   PARM                    DDISUR
     C                   PARM                    SDCUSTIsur
 
      /COPY WNCPYSRC,MMNASSV012
 
     C     Msg1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDISUR'
     C                   EVAL      MsgIDArr(Idx) = Msg1
     C                   ENDIF
      *                                                                                       CDL029
     C                   IF        CDL029 ='Y'                                                CDL029
      *                                                                                       CDL029
     C                   MOVEL     *BLANKS       W0BRCD                                      CDL029A
     C                   MOVEL     ILISCN        W0CUST                                      CDL029A
      *                                                                                      CDL029A
     C     KBRANCHAUTH   CHAIN     SDABBCL0                           91                     CDL029A
      *                                                                                      CDL029A
     C                   IF        *IN91 = '1'                                               CDL029A
      *                                                                                      CDL029A
     C                   MOVEL     IBBBRCD       W0BRCD                                      CDL029A
     C                   MOVEL     *BLANKS       W0CUST                                      CDL029A
      *                                                                                      CDL029A
     C     KBRANCHAUTH   CHAIN     SDABBCL0                           91                      CDL029
      *                                                                                      CDL029A
     C                   ENDIF                                                               CDL029A
      *                                                                                      CDL029A
     C                   IF        *IN91 = '1'                                                CDL029
     C                   EVAL      ReturnCode = 'Error'                                       CDL029
     C                   ADD       1             Idx                                          CDL029
     C                   EVAL      FldNameArr(Idx) = 'DDIUSR'                                 CDL029
     C                   EVAL      MsgIDArr(Idx) = 'FXM7001'                                  CDL029
     C                   END                                                                  CDL029
      *                                                                                       CDL029
     C                   END                                                                  CDL029
      *                                                                                       CDL029
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDIsurOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMNASSV013
 
      *  *-----------------------------*
      *  * Validate Sold To Customer   *
      *  *-----------------------------*
     C                   EXSR      ResetErrs
 
     C                   CALLB     'MMVCUSNONP'
     C                   PARM                    ReturnCode
     C                   PARM                    Msg1
     C                   PARM                    CustFormat
     C                   PARM                    ILCSNM
     C                   PARM                    ILCNUM
     C                   PARM                    DDCSNM
     C                   PARM                    SDCUSTSold
 
      /COPY WNCPYSRC,MMNASSV014
 
     C     Msg1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCSNM'
     C                   EVAL      MsgIDArr(Idx) = Msg1
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDCsnmOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMNASSV015
 
      *  *-------------------*
      *  * Validate Currency *  #14
      *  *-------------------*
     C                   EXSR      ResetErrs
 
     C                   CALLB     'MMVCURCODE'
     C                   PARM                    ReturnCode
     C                   PARM                    Msg1
     C                   PARM                    DDCCY
     C                   PARM                    BGFIIN
     C                   PARM                    BGTRMG
     C****************** PARM                    SDCURR                                       CSD006
     C     SDCURR        PARM                    DSSDY                                        CSD006
 
      /COPY WNCPYSRC,MMNASSV016
 
     C     Msg1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCCY '
     C                   EVAL      MsgIDArr(Idx) = Msg1
     C                   ENDIF
 
      ** Set up the file version of the field, if no error.
     C                   IF        ReturnCode = *blank
     C                   Z-ADD     A6NBDP        ILCYDP
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDCcyOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMNASSV017
 
      *  *---------------------*
      *  * Validate Face Value *
      *  *---------------------*
     C                   EXSR      ResetErrs
 
      ** Put the face value into a 14-alpha amount field for MMVAMOUNT,
      ** removing any leading or trailing blanks when doing so.
     C                   EVAL      Amount14A = %trim(DDFVAL)
 
     C                   CALLB     'MMVAMOUNT'
     C                   PARM                    ReturnCode
     C                   PARM                    Msg1
     C                   PARM                    Amount14A
     C                   PARM                    DDCcyOK
     C                   PARM                    A6NBDP
     C                   PARM                    DDMTYP
     C                   PARM                    ILFVAL
      ** Currency separator (1A, from SDDEALPD, via caller)
     C                   PARM                    BNDCSP
     C                   PARM                    DDACTN                                     AR569568
     C                   PARM                    CDL006                                     AR569568
      *                                                                                      BUG3131
      ** MMVAMOUNT formats Amount14A in the correct decimal place. Move                      BUG3131
      ** this now to screen field DDFVAL.                                                    BUG3131
      *                                                                                      BUG3131
     C                   CLEAR                   DDFVAL                                      BUG3131
     C                   MOVE      Amount14A     DDFVAL                                      BUG3131
 
      /COPY WNCPYSRC,MMNASSV018
 
     C     Msg1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFVAL'
     C                   EVAL      MsgIDArr(Idx) = Msg1
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDFValOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMNASSV019
 
      *  *------------------------------*
      *  * Validate Sale of Deal Number *
      *  *------------------------------*
      ** Only perform this validation if the sale of deal number was
      ** flagged as OK by the caller.
     C                   IF        DDDADNOK = 'Y'
     C                   EXSR      ResetErrs
 
     C                   CALLB     'MMVSALEDNO'
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      ** Message ID 1 (7A, returned to caller)
     C                   PARM                    Msg1
      ** Standard deals file version of sale of deal number (6A, returned
      ** to caller)
     C                   PARM                    ILDADN
      ** Sale of deal number (6A, from transaction)
     C                   PARM                    DDDADN
      ** Deal type (2A, from transaction)
     C                   PARM                    DDMTYP
      ** Deal number (6A, from transaction (or from generator))
     C                   PARM                    DDDLNO
      ** Deal currency (3A, from transaction)
     C                   PARM                    DDCCY
      ** Face value amount field (15,0P, from caller)
     C                   PARM                    ILFVAL
      ** Issued by customer number (6,0S, from caller)
     C                   PARM                    ILISCN
      ** Value date of deal (5,0P, from caller)
     C                   PARM                    ILDVSD
      ** Currency OK flag (1A, from caller)
     C                   PARM                    DDCcyOK
      ** Face value OK flag (1A, from/to caller)
     C                   PARM                    DDFValOK
      ** Customer OK flag (1A, from caller)
     C                   PARM                    DDCSnmOK
      ** Value date OK flag (1A, from caller)
     C                   PARM                    DDVDatOK
      ** Currency separator character (1A, from SDCURRPD)
     C                   PARM                    BNDCSP
     ** Action code                                                                         BUG12582
     C                   PARM      DDACTN        PActn             1                        BUG12582
      ** Negotiable asset purchased data structure returned to caller
     C                   PARM                    MMDENBD0                       B*2
 
                                                                                              181274
      ** Move NA Bought deal's  Branch code  into the Data Structure                          181274
      ** used for the newly inserted  Sold  deal .   It will be used                          181274
      ** to validate the Account Code  for  Settlement Method = 04                            181274
     C                   EVAL      ILBRCA = HLBRCA                                            181274
                                                                                              181274
                                                                                              181274
      /COPY WNCPYSRC,MMNASSV020
 
     C     Msg1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDADN'
     C                   EVAL      MsgIDArr(Idx) = Msg1
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDDADNOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
     C                   ENDIF
 
      /COPY WNCPYSRC,MMNASSV021
 
      *  *------------------------*
      *  * Validate Parcel Size   *  #04.5
      *  *------------------------*
      ** Do not perform this validation if the sale of deal number was
      ** not OK, as the module may not have all the necessary data to do
      ** the validation.  Also only perform this validation on insert, as
      ** doing it on amends can give misleading results.
     C                   IF        DDDADNOK = 'Y' AND DDACTN = 'I'
     C                   EXSR      ResetErrs
 
     C                   CALLB     'MMVNASSPSZ'
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      ** Message ID 1 (7A, returned to caller)
     C                   PARM                    Msg1
      ** Standard deals file version of parcel size (5,0P, returned
      ** from this module)
     C                   PARM                    ILPSZE
      ** Standard deals file version of parcel indicator (1A, returned
      ** from this module)
     C                   PARM                    ILPCLI
      ** Parcel size (5A, from transaction)
     C                   PARM                    DDPSZE
      ** Parcel indicator of related deal (1A, from MMDENBPP, via caller)
     C                   PARM                    HLPCLI
      ** Decimal separator character (1A from SDDEALPD, via caller)
     C                   PARM                    BNDCSP
      ** Number of assets/parcels sold (5,0P, from MMDENBPP, via caller)
     C                   PARM                    HLNSLD
      ** Parcel size of related deal (5,0P, from MMDENBPP, via caller)
     C                   PARM                    HLPSZE
      ** Face value of this deal (15,0P, from caller)
     C                   PARM                    ILFVAL
      ** Face value of related deal (15,0P, from MMDENBPP, via caller)
     C                   PARM                    HLFVAL
      ** Number of decimal places in currency (1,0S from SDCURRPD, via caller)
     C                   PARM                    A6NBDP
      ** Face value OK flag (1A, from caller) NOTE: CAN ALSO BE CHANGED BY
      ** THE CALLED MODULE
     C                   PARM                    DDFValOK
 
      /COPY WNCPYSRC,MMNASSV022
 
     C     Msg1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPSZE'
     C                   EVAL      MsgIDArr(Idx) = Msg1
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDPSzeOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
     C                   ENDIF
 
      /COPY WNCPYSRC,MMNASSV023
 
      *  *---------------------*
      *  * Validate Sale Price *
      *  *---------------------*
     C                   EXSR      ResetErrs
 
     C                   CALLB     'MMVSALEPRC'
     C                   PARM                    ReturnCode
     C                   PARM                    Msg1
     C                   PARM                    ILAMNP
     C                   PARM                    DDAMNP
     C                   PARM                    A6NBDP
     C                   PARM                    BNDCSP
     C                   PARM                    DDCcyOK
 
      /COPY WNCPYSRC,MMNASSV024
 
     C     Msg1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDAMNP'
     C                   EVAL      MsgIDArr(Idx) = Msg1
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDAmnPOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMNASSV025
 
      *  *------------------------*
      *  * Validate Yield Rate    *  #04.5
      *  *------------------------*
     C                   EXSR      ResetErrs
 
      *                                                                                      BUG7242
      ** Validate deal type if eligible for yield rate validation                            BUG7242
      ** Optional for deal types CS, BS and BR.                                              BUG7242
      ** During non-insert validate only if non-blank.                                       BUG7242
      *                                                                                      BUG7242
     C                   IF        DDACTN = 'I' AND (                                        BUG7242
     C                             DDMTYP = 'TS'                                             BUG7242
     C                             OR DDMTYP = 'RA'                                          BUG7242
     C                             OR DDMTYP = 'TR'                                          BUG7242
     C                             OR DDINTR <> *BLANKS)                                     BUG7242
     C                             OR DDACTN <> 'I'                                          BUG7242
     C                             AND DDINTR <> *BLANKS                                     BUG7242
     C                   CALLB     'MMVYIELDRT'
     C                   PARM                    ReturnCode
      ** Message ID 1 (7A, returned to caller)
     C                   PARM                    Msg1
      ** Standard deals file version of yield rate (11,7P, returned         )
      ** to caller
     C                   PARM                    ILINTR
      ** Yield rate (12A, from caller)
     C                   PARM                    DDINTR
      ** Decimal separator character (1A from SDDEALPD, via caller)
     C                   PARM                    BNDCSP
      ** Deal Type                                                                            216117
     C                   PARM                    DDMTYP            2                          216117
 
      /COPY WNCPYSRC,MMNASSV026
 
     C     Msg1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDINTR'
     C                   EVAL      MsgIDArr(Idx) = Msg1
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDIntrOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *                                                                                      BUG7242
     C                   ENDIF                                                               BUG7242
 
      /COPY WNCPYSRC,MMNASSV027
 
      *  *------------------------*
      *  * Validate Book Code     *  #04.5
      *  *------------------------*
     C                   EXSR      ResetErrs
 
     C                   CALLB     'MMVBOOKCDE'
     C                   PARM                    ReturnCode
     C                   PARM                    Msg1
     C                   PARM                    Msg2
     C                   PARM                    Msg3
     C                   PARM                    Msg4
     C                   PARM                    MsgData2
     C                   PARM                    MsgData3
     C                   PARM                    MsgData4
     C                   PARM                    DDBOKC
     C                   PARM                    BNBCOP
     C                   PARM                    FCPORS
     C                   PARM                    BNBKCD
     C*******************PARM                    DDISUR                                       TCA090
     C                   PARM      DDISUR        W_Issuer         10                          TCA090
      ** The following parameter is passed as blanks, as this module does
      ** not have DDPTFR defined.
     C                   PARM                    Dummy1
     C                   PARM                    HLBRCA
     C                   PARM                    FCR997
     C                   PARM                    ERPLCS            7
     C                   PARM                    PortRef
     C                   PARM                    QBCUST
     C                   PARM                    BGPFMG                                       222373
     C                   PARM                    BGN4ST                                       222373
 
      /COPY WNCPYSRC,MMNASSV028
 
     C     Msg1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBOKC'
     C                   EVAL      MsgIDArr(Idx) = Msg1
     C                   ENDIF
 
     C     Msg2          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPTFR'
     C                   EVAL      MsgIDArr(Idx) = Msg2
     C                   ENDIF
     C     MsgData2      IFNE      *BLANK
     C                   MOVEA     MsgData2      MsgDtaArr(Idx)
     C                   ENDIF
 
     C     Msg3          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPTFR'
     C                   EVAL      MsgIDArr(Idx) = Msg3
     C                   ENDIF
     C     MsgData3      IFNE      *BLANK
     C                   MOVEA     MsgData3      MsgDtaArr(Idx)
     C                   ENDIF
 
     C     Msg4          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPTFR'
     C                   EVAL      MsgIDArr(Idx) = Msg4
     C                   ENDIF
     C     MsgData4      IFNE      *BLANK
     C                   MOVEA     MsgData4      MsgDtaArr(Idx)
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDBokcOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMNASSV029
 
      *  *----------------------------------*
      *  * Validate Linked Reference Number *  #04.7
      *  *----------------------------------*
     C                   EXSR      ResetErrs
 
     C                   CALLB     'MMVLINKREF'
     C                   PARM                    ReturnCode
     C                   PARM                    Msg1
     C                   PARM                    DDLnkN
      ** Decimal separator (1A, from SDDEALPD, via caller
     C                   PARM                    BNDCSP
 
      /COPY WNCPYSRC,MMNASSV030
 
     C     Msg1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDLNKN'
     C                   EVAL      MsgIDArr(Idx) = Msg1
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDLnkNOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMNASSV031
 
      *  *--------------------------------------------*
      *  * Validate Originating Branch                *  #34
      *  *--------------------------------------------*
     C                   EXSR      ResetErrs
 
     C                   CALLB     'ZAVORGBRCH'
     C                   PARM                    ReturnCode
     C                   PARM                    Msg1
     C                   PARM                    DDORBR
     C                   PARM                    OKFlag
     C                   PARM                    HLBRCA
     C                   PARM                    BGMBIN
     C                   PARM                    BKOBRU
     C                   PARM                    BKOBUV
     C                   PARM                    RespMode
 
      /COPY WNCPYSRC,MMNASSV032
 
     C     Msg1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDORBR'
     C                   EVAL      MsgIDArr(Idx) = Msg1
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDOrBrOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMNASSV033
 
      *  *--------------------------------------------*
      *  * Validate Profit Centre                     *  #35
      *  *--------------------------------------------*
     C                   EXSR      ResetErrs
 
     C                   CALLB     'ZAVPROFITC'
     C                   PARM                    ReturnCode
     C                   PARM                    Msg1
     C                   PARM                    DDPRFC
     C                   PARM                    BKPRCU
     C                   PARM                    BKPRCA
     C                   PARM                    BKPCDU
     C                   PARM                    DDMTYP
     C                   PARM                    BBACOC
     C                   PARM                    BBCUST
     C                   PARM                    DDBOKC
     C                   PARM                    DDSTYP
     C                   PARM                    HLBRCA
     C                   PARM                    DEPT
     C                   PARM                    PSUser
     C                   PARM                    DDIsurOK
     C                   PARM                    BGN0ST
 
      /COPY WNCPYSRC,MMNASSV034
 
     C     Msg1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPRFC'
     C                   EVAL      MsgIDArr(Idx) = Msg1
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDPrfCOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMNASSV035
 
     C*  *-----------------------------*
     C*  * Sale price cross validation *
     C*  *-----------------------------*
      ** Do not perform this validation if the sale of deal number was
      ** not OK, as the module may not have all the necessary data to do
      ** the validation
     C                   IF        DDDADNOK = 'Y'
     C                   EXSR      ResetErrs
 
     C                   CALLB     'MMVSALVPUR'
     C                   PARM                    ReturnCode
     C                   PARM                    WMsgID1
     C                   PARM                    MsgData
      ** Negotiable assets purchased data structure (MMDENBPP layout)
     C                   PARM                    MMDENBD0
      ** Value date in Midas day number format
     C                   PARM                    ILDVSD
      ** Number of decimal places in deal currency
     C                   PARM                    A6NBDP
      ** Decimal separator
     C                   PARM                    BNDCSP
      ** Formatted version of Yield Rate
     C                   PARM                    ILINTR
      ** Formatted version of Sale Price
     C                   PARM                    ILAMNP
      ** Formatted version of Face Value
     C                   PARM                    ILFVAL
      ** Associated deal number OK flag
     C                   PARM                    DDDADNOK                       B1
      ** Value date OK flag
     C                   PARM                    DDVDATOK                       B1
      ** Currency OK flag
     C                   PARM                    DDCCYOK                        B1
      ** Face value OK flag
     C                   PARM                    DDFVALOK                       B1
      ** Sale price OK flag
     C                   PARM                    DDAMNPOK                       B1
      ** Yield rate OK flag
     C                   PARM                    DDINTROK                       B1
 
      /COPY WNCPYSRC,MMNASSV036
 
     C     WMsgID1       IFNE      *BLANK
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDAMNP'
     C                   EVAL      WMsgIDArr(WIdx) = WMsgID1
     C                   EVAL      WMsgDtaArr(WIdx) = MsgData
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDAmnpOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
     C                   ENDIF
 
      /COPY WNCPYSRC,MMNASSV037
 
      *  *-------------------------------------------------------*
      *  * If no errors set up outstanding fields for valid file *
      *  *-------------------------------------------------------*
 
      /COPY WNCPYSRC,MMNASSV038
 
     C                   IF        Idx = 0
     C                   EXSR      SetupValid
     C                   ENDIF
 
      /COPY WNCPYSRC,MMNASSV039
 
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,MMNASSV042
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ResetErrs - Reset error information that is returned          *
      *             from each validation module.                      *
      *                                                               *
      * Called by: Main processing, before each validation module     *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     ResetErrs     BEGSR
 
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
 
     C                   RESET                   MsgData
 
     C                   EVAL      ReturnCode = *Blanks
 
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
     C                   PARM      *BLANK        @MaturityDate     6                          CDL038
     C                   PARM                    DDBOKC                                       CDL038
     C                   PARM                    DDPRFC                                       CDL038
     C                   PARM                    DDCCY                                        CDL038
     C                   PARM      *BLANK        @Currency2        3                          CDL038
     C                   PARM                    DDDADN                                       CDL038
      * Inputs/Outputs                                                                        CDL038
     C                   PARM                    DDSTYP                                       CDL038
     C                   PARM                    DDCLAS                                       CDL038
      *                                                                                       CDL038
     C                   ENDSR                                                                CDL038
      *****************************************************************                       CDL038
      /EJECT
      *****************************************************************
      *                                                               *
      * SetupValid - Set up additional fields that are needed on the  *
      *    Valid file record.                                         *
      *                                                               *
      *****************************************************************
 
     C     SetupValid    BEGSR
 
      ** This subroutine sets up the valid file fields which were not set
      ** up during the validation.
      ** Other ILxxxx fields are set up during the validation, such as the
      ** ones where the input & database formats are different, e.g. dates,
      ** amounts.
 
     C                   MOVE      DDMTYP        ILTYPE
     C                   MOVE      DDSTYP        ILSTYP
     C                   MOVE      DDFEDF        ILFEDF
     C                   MOVE      DDDADN        ILDADN
     C                   MOVE      DDBOKC        ILBOKC
     C                   MOVE      DDLNKN        ILLNKN
     C                   MOVE      DDBKCD        ILBKCD
     C                   MOVE      DDCCY         ILCCY
     C                   MOVE      DDPRFC        ILPRFC
     C                   MOVE      DDORBR        ILORBR
     C                   MOVE      DDACTN        ILLACT
                                                                                              CDL010
      ** Set up The user field from ZMUSER which is the front office                          CDL010
      ** user if sent . Only if CDL010 is installed                                           CDL010
                                                                                              CDL010
     C     CDL010        IFEQ      'Y'                                                        CDL010
     C                   MOVE      ZUSER         ILUSER                                       CDL010
     C                   END                                                                  CDL010
                                                                                              CDL038
      ** Set up Class                                                                         CDL038
                                                                                              CDL038
     C                   MOVE      DDCLAS        ILCLAS                                       CDL038
 
     C                   ENDSR
 
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
 
     C     *inzsr        BEGSR
 
     C     *ENTRY        PLIST
      * Response mode (1A), from source system common header
     C                   PARM                    RespMode
      * Transaction information (data structure, from source system)
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
      * Field OK flags (data structure, from/to caller)
     C                   PARM                    OKFlagsDS
      * Error fields/message IDs/message data (arrays, from/to caller)
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3,0P, from/to caller)
     C                   PARM                    Idx
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
      * Valid Deals layout (data structure, from/to caller)
     C                   PARM                    ValidDeal
                                                                                              CDL029
     C     KBRANCHAUTH   KLIST                                                                CDL029
     C******             KFLD                    IBBBRCD                               CDL029CDL029A
     C                   KFLD                    W0BRCD            3                         CDL029A
     C                   KFLD                    W0CUST            6                         CDL029A
     C                   KFLD                    HLBRCA                                       CDL029
      **********                                                                      TCA090 BUG6979
      ****GET*ZMUSER*to*access*default*branch.                                        TCA090 BUG6979
      **********                                                                      TCA090 BUG6979
     C******DTAARA       DEFINE                  ZMUSER                               TCA090 BUG6979
     C**********         IN        ZMUSER                                             TCA090 BUG6979
     C**********         UNLOCK    ZMUSER                                             TCA090 BUG6979
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
     C/COPY ZACPYSRC,DBFIELDS
 
      ** Clear the MMDENBD0 data structure, to ensure that the packed
      ** fields start at zero (without this they get blanks in them,
      ** causing decimal data errors).
     C                   CLEAR                   MMDENBD0
 
      * The Confirm Valid Trans to Front Office flag and the Return Code
      *  on the i/p Data Structure have to be renamed as they are
      *  already defined.
      * So simply move them from the renamed fields to the proper ones.
 
      * File / Data area Accesses required for calling parameters
      * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
     C**********         CALLB     'AODEALR0'                                                 CGL029
     C                   CALLB     'AODEALR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
      *
      ** Access General Ledger details via access program
      *  (database error handling done in access program)
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
 
      ** Access Bank details via access program
      ** (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Obtain TRADE details via access program                          S01194
      ** (database error handling done in access program)                 S01194
     C                   CALLB     'AOTRADR0'                                                  S0119
     C                   PARM      '*DBERR '     @RTCD             7                           S0119
     C                   PARM      '*FIRST '     @OPTN             7                           S0119
     C     SDTRAD        PARM      SDTRAD        DSFDY                                         S0119
 
      ** Access MIDAS Modules details via access program
      ** (database error handling done in access program)
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Access SAR details file to determine if CDL005 is on.
      ** (Customer format in input functions is shortname)
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDL005'      @SARD             6
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE                         * DBERROR 020 *
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     'CDL005'      DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'S'           CustFormat        1
     C                   ELSE
     C                   MOVEL     'N'           CustFormat
     C                   END
      *                                                                         CDL011
      ** Access SAR details file to determine if CDL005 is on.                  CDL011
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
     C                   MOVEL     '002'         DBASE                          CDL011
     C                   EXSR      *PSSR                                        CDL011
     C                   END                                                    CDL011
     C*                                                                         CDL011
     C     @RTCD         IFEQ      *BLANK                                       CDL011
     C                   MOVEL     'S'           CustFormat                     CDL011
     C                   END                                                    CDL011
 
      ** Set up the name of the message file from which the message handler
      ** will get the messages
     C                   EVAL      #MsgFile = 'DRSMM'
 
      ** Set up the Module ID, used to make the Transaction number unique
     C                   EVAL      ModuleID = 'DL'
 
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   EVAL      WRunDay = BJRDNB                                           CSC011
 
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRtCd                                        CSC011
     C                   PARM      '*VERIFY'     POptn                                        CSC011
     C                   PARM      'CSC011'      PSard                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRtCd = *Blanks                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   IF        S1SUPP = LIBR                                              CSC011
     C                   EVAL      WRunDay = S1DATE                                           CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C                   IF        PRtCd <> '*NRF'                                            CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 900                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
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
     C                   EVAL      DBASE = 901                                                CDL010
     C                   EVAL      DBKEY = 'CDL010'                                           CDL010
     C                   OUT       LDA                                                        CDL010
     C                   EXSR      *PSSR                                                      CDL010
     C                   ENDIF                                                                CDL010
     C                   IF        PRTCD = *BLANKS                                            CDL010
     C                   EVAL      CDL010 = 'Y'                                               CDL010
     C                   ELSE                                                                 CDL010
     C                   EVAL      CDL010 = 'N'                                               CDL010
     C                   ENDIF                                                                CDL010
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
     C                   EVAL      DBASE = 003                                                CDL029
     C                   EVAL      DBKEY = 'CDL029'                                           CDL029
     C                   OUT       LDA                                                        CDL029
     C                   EXSR      *PSSR                                                      CDL029
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
     C                   EVAL      DBASE = 004                                                CDL033
     C                   EVAL      DBKEY = PSARD                                              CDL033
     C                   OUT       LDA                                                        CDL033
     C                   EXSR      *PSSR                                                      CDL033
     C                   OTHER                                                                CDL033
     C                   MOVE      'N'           CDL033                                       CDL033
     C                   ENDSL                                                                CDL033
                                                                                              CDL010
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
                                                                                             BUG9717
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
     C                   EVAL      DBASE = 005                                               BUG9827
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
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,MMNASSV043
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      /COPY ZACPYSRC,DBERREXIT
      ********************************************************************
      /EJECT
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
