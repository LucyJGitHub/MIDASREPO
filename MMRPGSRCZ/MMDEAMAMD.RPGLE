     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Deal Amendments Amend Checking')              *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMDEAMAMD - Processing for Action Code 'A' for               *
      *               Deal Amendments.                                *
      *                                                               *
      *  Function:  This module compares the fields of an amended     *
      *             Deal Amendment against those currently on file.   *
      *             It checks whether all fields amended are          *
      *             amendable, and if not returns error messages to   *
      *             the calling process.                              *
      *             If can optionally reset fields wrongly amended.   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CGL014             Date 20Oct03               *
      *                 CDL022             Date 03Feb04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 07Sep03               *
      *                 222727             Date 05Nov03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 03Apr00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP051             Date 12Nov99               *
      *                 CDL007             Date 12Oct99               *
      *                 CPB001             Date 01Jun99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 22Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CDL022 - Deal Amendment Changes                              *
      *  CDL020 - Apply Base Rate at Value Date                       *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - API wrapper project                                 *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CDE002 - Revenue Analysis                                    *
      *  CAP051 - Automatic Authorisation (MM Part)                   *
      *           Recompiled due to changes in MMDELDPP               *
      *  CDL007 - Deposit Breakdown Penalty                           *
      *           Recompiled due to changes in MMDELDPP               *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to changes in MMDELDPP               *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
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
 
      * New Deal in Screen Format
     D NwDlScnFmt    E DS                  EXTNAME(MMDEAMPD)
 
      * (Current) Deal in File Format
     D DealFilFmt    E DS                  EXTNAME(MMDEAMPP)
 
      * (Current) Deal in Screen Format
     D DealScnFmt    E DS                  EXTNAME(MMDEAMPD)
     D                                     PREFIX(@)
 
     D RUNDAT          DS
     D  @MBIN                 13     13
     D*
     D                 DS
     D**  Data structure for date in, to change format.
     D  DateIn                 1      8  0
     D  @@YY                   1      4  0
     D  @@MM                   5      6  0
     D  @@DD                   7      8  0
     D*
     D @DLDS         E DS                  EXTNAME(MMDELDPP)
     D**  Data structure of the MM Loan/Deposit deal.
     D  QQDORI1      E                     EXTFLD(QQDORI)                                     CGL029
     D  QQMORI1      E                     EXTFLD(QQMORI)                                     CGL029
     D  QQDOPI1      E                     EXTFLD(QQDOPI)                                     CGL029
     D  QQMOPI1      E                     EXTFLD(QQMOPI)                                     CGL029
     D  QQRONS1      E                     EXTFLD(QQRONS)                                     CGL029
     D  QQPONS1      E                     EXTFLD(QQPONS)                                     CGL029
     D*
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
      *
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
     D**  Data structure for Portfolio Management ICD File
     D*
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External data structure for currency details
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** EXTERNAL DS FOR DEALING DETAILS
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D** EXTERNAL DS FOR GENERAL LEDGER DETAILS
     D  QQACCD1      E                     EXTFLD(QQACCD)                                     CGL029
     D*
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D** EXTERNAL DS FOR SAR DETAILS
     D*
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D* FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D*
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D* SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
     D*
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ****** Include in /Copy statement ********
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Flags to indicate whether transaction fields are valid
     D OKFlagsDS       DS
     D  DDActnOK                      1A
     D  DDDlnoOK                      1A
     D  DDVDatOK                      1A
     D  DDDS38OK                      1A
     D  DDCsnmOK                      1A
     D  DDMTypOK                      1A
     D  DDIntrOK                      1A
     D  DDCcyOK                       1A
     D  DDAmnpOK                      1A
     D  DDFsrpOK                      1A
     D  DDPenPOK                      1A                                                      CDL017
     D  DDEmdtOK                      1A                                                      CDL017
     D  DDBsrtOK                      1A                                                      CDL022
     D  DDAirOK                       1A                                                      CDL020
 
      ** Overall Transaction status, to be passed back to calling program
     D AmendOK         S              1A
 
      ** Date out
     D DateOut         S              6P 0
 
      ** Deal Date in Midas Dayno. format
     D DealDate        S              5P 0
 
      ** Value Date in Midas Dayno. format
     D ValDate         S              5P 0
 
      ** Deal Transaction Date in Midas Dayno. format
     D TranDate        S              5P 0
 
      ** Formatted Amount field from ZA0920
     D AmountOut       S             14A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      **  Convert the dates on the current live deal
      **  from YYYYMMDD format to Midas day number format
      *
     C                   EXSR      FMATDATES
      *
      **  Compare fields with amended values.
      *
     C                   EXSR      COMPFLDS
 
      *  If any errors were found:
      *    Set Amendments OK Indicator to 'N'
 
     C     Idx           IFGT      0
     C                   EVAL      AmendOK = 'N'
     C                   ELSE
     C                   EVAL      AmendOK = 'Y'
     C                   ENDIF
 
      *  If any errors were found:
      *  - and reset of fields in error required, do this
      *
     C     Idx           IFGT      0
     C     ResetErrs     ANDEQ     'Y'
     C                   EXSR      RESETFLDS
     C                   ENDIF
      *
      * Return
      *
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * FMATDATES  - Convert date fields from MMDEAMPP from DDMMYYYY  *
      *              to Midas Dayno (5,0) format for comparison       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     FMATDATES     BEGSR
 
     C***********************************************
     C**  Format the DEAM deal date.                *
     C***********************************************
     C*
     C                   Z-ADD     HNDMDY        @@YY
     C                   Z-ADD     HNDMDM        @@MM
     C                   Z-ADD     HNDMDD        @@DD
     C*
     C     DateIn        IFEQ      0
     C                   Z-ADD     0             DealDate
     C                   ELSE
     C                   CALLB     'ZDATE10'
     C                   PARM                    DateIn
     C                   PARM                    ZZMDNO
     C                   MOVE      ZZMDNO        DealDate
     C                   END
     C*
     C***********************************************
     C**  Format the value date.                    *
     C***********************************************
     C*
     C                   Z-ADD     HNVDYY        @@YY
     C                   Z-ADD     HNVDMM        @@MM
     C                   Z-ADD     HNVDDD        @@DD
     C*
     C     DateIn        IFEQ      0
     C                   Z-ADD     0             ValDate
     C                   ELSE
     C                   CALLB     'ZDATE10'
     C                   PARM                    DateIn
     C                   PARM                    ZZMDNO
     C                   MOVE      ZZMDNO        ValDate
     C                   END
     C*
     C***********************************************
     C**  Format the Transaction Date               *
     C***********************************************
     C*
     C                   Z-ADD     HNDTYY        @@YY
     C                   Z-ADD     HNDTMM        @@MM
     C                   Z-ADD     HNDTDD        @@DD
     C*
     C     DateIn        IFEQ      0
     C                   Z-ADD     0             TranDate
     C                   ELSE
     C                   CALLB     'ZDATE10'
     C                   PARM                    DateIn
     C                   PARM                    ZZMDNO
     C                   MOVE      ZZMDNO        TranDate
     C                   END
     C*
     C     FMTEND        TAG
     C*
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * COMPFLDS  - Compare the details of the record on file with    *
      *             the amended deam details.                         *
      *                                                               *
      * CALLS             - None                                      *
      *                                                               *
      * CALLED BY  MAIN                                               *
      *                                                               *
      * FLDS USED         -                                           *
      *                                                               *
      *****************************************************************
     C     COMPFLDS      BEGSR
 
     C*-----------------------------------------*
     C* Deal Number                             *
     C*-----------------------------------------*
     C*
     C*-----------------------------------------*
     C* Value Date                              *
     C*-----------------------------------------*
     C*
     C** This field is NOT AMENDABLE.
     C*
     C     DDVDAT        IFNE      @DDVDAT
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDVDAT'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0386'
     C                   EVAL      ddVDATok        = 'N'
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Deal Sequence Number                    *
     C*-----------------------------------------*
     C*
     C** This field is NOT AMENDABLE.
     C*
     C     DDDS38        IFNE      @DDDS38
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDS38'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0501'
     C                   EVAL      ddDS38ok        = 'N'
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Deal Amendment Type                     *
     C*-----------------------------------------*
     C*
     C** This field is NOT AMENDABLE.
     C*
     C     DDMTYP        IFNE      @DDMTYP
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMTYP'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0502'
     C                   EVAL      ddMTYPok        = 'N'
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Currency                                *
     C*-----------------------------------------*
     C*
     C** This field is NOT AMENDABLE.
     C*
     C     DDCCY         IFNE      @DDCCY
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCCY '
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0370'
     C                   EVAL      ddCCYok         = 'N'
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Deal Amount                             *
     C*-----------------------------------------*
     C*
     C** This field is NOT AMENDABLE.
     C*
     C*****DDAMNP        IFNE      @DDAMNP                                      CAP084
     C                   CALLB     'ZCMPAMTS'                                   CAP084
     C                   PARM      DDAMNP        ZCMPAMT1         25            CAP084
     C                   PARM      @DDAMNP       ZCMPAMT2         25            CAP084
     C                   PARM      'N'           ZCMPAMTDif        1            CAP084
                                                                                CAP084
     C     ZCMPAMTDif    IFEQ      'Y'                                          CAP084
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDAMNP'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0372'
     C                   EVAL      ddAMNPok        = 'N'
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Interest Rate/Spread                    *
     C*-----------------------------------------*
     C*
     C** This field is NOT AMENDABLE.
     C*
     C*****DDINTR********IFNE      @DDINTR                                      CAP084
     C                   CALLB     'ZCMPAMTS'                                   CAP084
     C                   PARM      DDINTR        ZCMPAMT1         25            CAP084
     C                   PARM      @DDINTR       ZCMPAMT2         25            CAP084
     C                   PARM      'N'           ZCMPAMTDif        1            CAP084
                                                                                CAP084
     C     ZCMPAMTDif    IFEQ      'Y'                                          CAP084
 
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDINTR'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0374'
     C                   EVAL      ddINTRok        = 'N'
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Customer                                *
     C*-----------------------------------------*
     C*
     C** This field is NOT AMENDABLE.
     C*
     C     DDCSNM        IFNE      @DDCSNM
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCSNM'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0387'
     C                   EVAL      ddCSNMok        = 'N'
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Funding Rate/Spread                     *
     C*-----------------------------------------*
     C*
      **  Process Funding Spread/Rate only if Analytical Accounting
      **  or Revenue Analysis is installed.                                     CDE002
     C****is*installed.************************************************         CDE002
     C     BGN0ST        IFEQ      'Y'
     C     CDE002        OREQ      'Y'                                          CDE002
      *
     C     DDFSRP        IFNE      @DDFSRP
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFSRP'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0374'
     C                   EVAL      ddFSRPok        = 'N'
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C     COMPFLDS9     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RESETFLDS - Reset fields in Error                             *
      *****************************************************************
     C     RESETFLDS     BEGSR
      *
      * Reset fields in error to 'current' values
      *
     C* Value Date
     C     ddVDATOK      IFEQ      'N'
     C                   MOVEL     @DDVDAT       DDVDAT
     C                   END
      *
     C* Deal Sequence Number
     C     ddDS38ok      IFEQ      'N'
     C                   MOVEL     @DDDS38       DDDS38
     C                   END
      *
     C* Deal Amendment Type
     C     ddMTYPok      IFEQ      'N'
     C                   MOVEL     @DDMTYP       DDMTYP
     C                   END
      *
     C* Currency
     C     ddCCYok       IFEQ      'N'
     C                   MOVEL     @DDCCY        DDCCY
     C                   END
      *
     C* Deal Amount
     C     ddAMNPok      IFEQ      'N'
     C                   MOVEL     @DDAMNP       DDAMNP
     C                   END
      *
     C* Interest Rate/Spread
     C     ddINTRok      IFEQ      'N'
     C                   MOVEL     @DDINTR       DDINTR
     C                   END
      *
     C* Customer
     C     ddCSNMok      IFEQ      'N'
     C                   MOVEL     @DDCSNM       DDCSNM
     C                   END
      *
     C* Funding Rate/Spread
     C     ddFSRPok      IFEQ      'N'
     C                   MOVEL     @DDFSRP       DDFSRP
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
     C*****************************************************************
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
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * New Deal in Screen Format
     C                   PARM                    NwDlScnFmt
      *
      * Current Deal in Screen Format
     C                   PARM                    DealScnFmt
      *
      * Current Deal in file format
     C                   PARM                    DealFilFmt
      *
      * OUTPUTS
      *
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      * Amendments OK
     C                   PARM                    AmendOk
 
      * Reset of Fields in Error Required (Y/N)
     C                   PARM                    ResetErrs         1
      *
     C     *LIKE         DEFINE    HNDVSD        ZZMDNO
 
      ** Initialize program name
      *
     C                   MOVEL     'MMDEAMAMD'   DBPGM
      *
     C**  GET RUNDAT to access MULTI-BRANCHING flag.
     C**
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C*
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      **
      ** Access MIDAS Modules details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      **
      ** Access Dealing ICD file via access program
      *  (database error handling done in access program)
     C**********         CALLB     'AODEALR0'                                                 CGL029
     C                   CALLB     'AODEALR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
      *
     C** Access General Ledger details via access program
      *  (database error handling done in access program)
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
     C*
     C** Access Portfolio Management ICD details if PM swithed on.
     C*
     C     BGPFMG        IFEQ      'Y'
     C                   CALLB     'AOPORTR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDPORT        PARM      SDPORT        DSFDY
     C                   END
     C*
      ** Access SAR details file to determine if Australian Brokerage
      ** is switched on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'AUS007'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C*
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           AUS007            1
     C                   SETON                                        14
     C                   ELSE
     C                   MOVEL     'N'           AUS007
     C                   END
      *
      ** ACCESS SAR DETAILS FILE TO DETERMINE IF BRT SAR IS INSTALLED
      ** (DATABASE ERROR HANDLING DONE IN ACCESS PROGRAM)
      **
     C                   CALLB     'AOSARDR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01383'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C*
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01383            1
     C                   END
     C*
     C** ACCESS SAR DETAILS FILE TO DETERMINE IF JSM SAR IS INSTALLED
     C** (DATABASE ERROR HANDLING DONE IN ACCESS PROGRAM)
     C**
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01391'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C*
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01391            1
     C                   END
      *
     C** Access SAR details file to determine if Enhanced Rollovers
     C** is switched on
     C*
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01434'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C*
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01434            1
     C                   SETON                                        78
     C                   ELSE
     C                   MOVEL     'N'           S01434
     C                   END
     C*
      ** Access SAR details file to determine if CDE002 is switched on          CDE002
      *                                                                         CDE002
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
                                                                                CDE002
     C                   ENDSR
 
      *****************************************************************
     C*
      /EJECT
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
