     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM NAs sold post settlement validation')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMNASSVLP - Negotiable Assets Sold Post Settlement Validation*
      *                                                               *
      *  Function: This Program Processes Post Settlement Detail      *
      *            NASS date validation                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. 256564             Date 17Sep08               *
      *  Prev Amend No. 249967             Date 13Sep07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG9711            Date 26Jan06               *
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
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG9711- Changes to MMVNASPPD/MMVNASSPD (re-compile)         *
      *  CDL038 - Extended Deal Sub Type                              *
      *  BUG6979 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3992- Re-open - Suppress duplicate error messages.        *
      *           Some may already have been sent bu MMNASSVAL.       *
      *  BUG3992- New program based on MMNASSVAL to perform post      *
      *           settlement detail validation. Revalidate dates.     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,MMNSSVP001
 
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
     D QQACC1        E                     EXTFLD(QQACCD)
      ** EXTERNAL DS FOR TRADING DETAILS
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D QQACC2        E                     EXTFLD(QQACCD)
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
     D QQDFC1        E                     EXTFLD(QQDFAC)
      ** External data structure for branch details
 
     D SDBROK        E DS                  EXTNAME(SDBROKPD)
      ** External data structure for broker details
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** Switchable features details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short data structure for access programs
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long data structure for access programs
 
     D ValidDeal     E DS                  EXTNAME(MMVNASSPD)
      * Valid Deals layout
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      ** 24X7 status data area
 
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** SD data area
 
     D ZMUSER          DS            17
      ** DS for ZMUSER data area, to get default branch (and department)
     D  ZUSER                  1     10
     D  BRC                   11     13
     D  DEPT                  14     16
 
     D TranIn        E DS                  EXTNAME(MMNASSPD)
      ** Incoming Transaction
 
     D MMDENBD0      E DS                  EXTNAME(MMDENBPP)
     D QQDOR1        E                     EXTFLD(DORIQQ)
     D QQMOR1        E                     EXTFLD(MORIQQ)
     D QQRON1        E                     EXTFLD(RONSQQ)
     D QQPON1        E                     EXTFLD(PONSQQ)
      ** External DS based on Negotiable assets purchased file
 
     D ExtData       E DS                  EXTNAME(MMNSEXPD)
      * MM NASS Extra Data - File (D/B) format
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message fields returned from called procedures
     D     Msg1        S                   LIKE(#MsgID)
     D     Msg2        S                   LIKE(#MsgID)
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
     D RecNostro       S             18A
     D PaySetCcy       S              3A
     D PaySetMeth      S              2S 0
     D PayNostro       S             18A
 
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
 
      ** Fields defined for Enhancement CSC011
     D CSC011          S              1A
     D PRtCd           S              7A
     D POptn           S              7A
     D PSard           S              6A
     D WRunDay         S                   LIKE(BJRDNB)
 
      ** Fields defined for Enhancement CDL010
     D CDL010          S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,MMNSSVP002
 
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
 
      /COPY WNCPYSRC,MMNSSVP003
 
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
     C                   PARM                    WRunDay
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
 
      /COPY WNCPYSRC,MMNSSVP004
 
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
     C     WMsgID1       LOOKUP    WMsgIDArr                              99                 BUG3992
     C     *IN99         IFEQ      '0'                                                       BUG3992
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDDDAT'
     C                   EVAL      WMsgIDArr(WIdx) = WMsgID1
     C                   ENDIF                                                               BUG3992
     C                   ENDIF
     C     WMsgID2       IFNE      *BLANK
     C     WMsgID2       LOOKUP    WMsgIDArr                              99                 BUG3992
     C     *IN99         IFEQ      '0'                                                       BUG3992
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDVDAT'
     C                   EVAL      WMsgIDArr(WIdx) = WMsgID2
     C                   ENDIF                                                               BUG3992
     C                   ENDIF
     C     WMsgID3       IFNE      *BLANK
     C     WMsgID3       LOOKUP    WMsgIDArr                              99                 BUG3992
     C     *IN99         IFEQ      '0'                                                       BUG3992
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDVDAT'
     C                   EVAL      WMsgIDArr(WIdx) = WMsgID3
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
 
      ** Set the global warning flag if any warning messages were generated
     C                   IF        ReturnCode = 'Warning' OR
     C                             ReturnCode = 'ErrAndWarn'
     C                   EVAL      WarnGlobal = 'Y'
     C                   ENDIF
 
      /COPY WNCPYSRC,MMNSSVP005
 
      *  *-------------------------------------------------------*
      *  * If no errors set up outstanding fields for valid file *
      *  *-------------------------------------------------------*
 
      /COPY WNCPYSRC,MMNSSVP006
 
     C                   IF        Idx = 0
     C                   EXSR      SetupValid
     C                   ENDIF
 
      /COPY WNCPYSRC,MMNSSVP007
 
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,MMNSSVP008
 
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
 
      ** Set up The user field from ZMUSER which is the front office
      ** user if sent . Only if CDL010 is installed
 
     C     CDL010        IFEQ      'Y'
     C                   MOVE      ZUSER         ILUSER
     C                   END
 
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
     C                   PARM                    ExtData
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
      **********                                                                             BUG6979
      ****GET*ZMUSER*to*access*default*branch.                                               BUG6979
      **********                                                                             BUG6979
     C******DTAARA       DEFINE                  ZMUSER                                      BUG6979
     C**********         IN        ZMUSER                                                    BUG6979
     C**********         UNLOCK    ZMUSER                                                    BUG6979
 
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
 
     C                   CALLB     'AODEALR1'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDDEAL        PARM      SDDEAL        DSSDY
      *
      ** Access General Ledger details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOGELRR1'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDGELR        PARM      SDGELR        DSSDY
 
      ** Access Bank details via access program
      ** (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Obtain TRADE details via access program
      ** (database error handling done in access program)
     C                   CALLB     'AOTRADR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDTRAD        PARM      SDTRAD        DSFDY
 
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
      *
      ** Access SAR details file to determine if CDL005 is on.
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
     C                   MOVEL     '002'         DBASE
     C                   EXSR      *PSSR
     C                   END
     C*
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'S'           CustFormat
     C                   END
 
      ** Set up the name of the message file from which the message handler
      ** will get the messages
     C                   EVAL      #MsgFile = 'DRSMM'
 
      ** Set up the Module ID, used to make the Transaction number unique
     C                   EVAL      ModuleID = 'DL'
 
      ** Check if CSC011 is installed
 
     C                   EVAL      WRunDay = BJRDNB
 
      ** Check if CSC011 is installed
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSC011'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtCd = *Blanks
     C                   EVAL      CSC011 = 'Y'
     C                   IN        SC24X7
     C                   IN        SDSTAT
     C                   IF        S1SUPP = LIBR
     C                   EVAL      WRunDay = S1DATE
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      CSC011 = 'N'
     C                   IF        PRtCd <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 900
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
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
     C                   EVAL      DBASE = 901
     C                   EVAL      DBKEY = 'CDL010'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CDL010 = 'Y'
     C                   ELSE
     C                   EVAL      CDL010 = 'N'
     C                   ENDIF
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,MMNSSVP009
 
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
(c) Misys International Banking Systems Ltd. 2004
