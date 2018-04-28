     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Fee input Extra validation for settlement')   *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LEFEEMEVL -  Customer Fee Extra validations for settlement   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CLE139             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG9496            Date 06Dec05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE031             Date 26Apr05               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP078  *CREATE    Date 31Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CLE139 - Lending Fee Capitalisation (Recompile)              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG9496- Include CAS011 changes in GZLEFEED to align valids  *
      *           file format.(Recompile)                             *
      *  CLE106 - Syndications Manager                                *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP078 - Conversion of LE inputs into modular structure to   *
      *           use as APIs. Fee input Transaction Details          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
      *
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,LEFEEMEV01
      *
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
      *
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
      *
     D/COPY ZACPYSRC,PROCPARMS
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
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
     D XArrayMax       C                   CONST(40)
      ***  The maximum size of the appended error arrays
 
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D FldNamXAr       S             10A   DIM(XArrayMax)
      ***  Array of Fields in error.
      *
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
      ***  Array of error message IDs
      *
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
      ***  Array of error message data.
      *
     D WFldNmXAr       S             10A   DIM(XArrayMax)
      ***  Array of Fields with warnings.
      *
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)
      ***  Array of warning message IDs
      *
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
      ***  Array of warning message data.
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for bank details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ***  External DS for general ledger details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D QQACCD1       E                     EXTFLD(QQACCD)                                     CGL029
      ***Nostro details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for access programs, short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ***  First DS for access programs, long data structure
      *
     D CrFeFilFmt    E DS                  EXTNAME(LEFEED)
      ***  Current Fee in File Format
 
     D NwFeScnFmt    E DS                  EXTNAME(LEFEEMPD)
      ***  New Fee in Screen Format
 
     D ValidFeem     E DS                  EXTNAME(LEVFEEMPD)
     D QQOURS1       E                     EXTFLD(QQOURS)                                     CGL029
      ***  New Fee in file format
     D***VFRec**              294    362                                                      CGL029
     D***VFPay**              363    921                                                      CGL029
     D  VFRec                308    362                                                       CGL029
     D  VFPay                377    921                                                       CGL029
     D  VFRecEx             1076   1093                                                       CGL029
     D  VFPayEx             1094   1111                                                       CGL029
 
     D F_REC         E DS                  EXTNAME(SDESFRPD)
      * File Receive instructions
     D***FLREC**                1     69                                                      CGL029
     D  FLREC                  1     75                                                       CGL029
 
     D F_PAY         E DS                  EXTNAME(SDESFPPD)
      * File Payment instructions
     D***FLPAY**                1    559                                                      CGL029
     D  FLPAY                  1    565                                                       CGL029
 
     D F_FRI         E DS                  EXTNAME(SDESFFPD)
      * File Fra/irs instructions
 
      *
     D OKFee         E DS                  EXTNAME(LEEFEEMPD)
      ***  Error indicators Screen
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D RespMode        S              1A
      ** Response Mode, received as a parameter from the common header
 
     D Idx             S              3P 0
      ** Index for arrays of error message ids etc
 
      *
     D WId             S              3P 0
      ***  Index for arrays of of warning message ids etc
      *
      *
      ** +--------------------------------------+
      ** ¦ Rename fields                        ¦
      ** ¦ =============                        ¦
      ** +--------------------------------------+
      *
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,LEFEEMEV02
 
      *****************************************************************
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
 
      /COPY WNCPYSRC,LEFEEMVE03
 
      *
      ***  Extra Validation after Extended Settlement
      *    ==========================================
 
      *
      ***  Reset variables updated by each module
      *
     C                   EXSR      RESETERRS
      *
     C     CEU004        IFEQ      'Y'
     C     CLE031        OREQ      'Y'                                                        CLE031
     C     VFPTFI        IFEQ      *BLANKS
     C                   MOVE      FLRSCY        WSCCY             3
     C                   ENDIF
     C     VFPTFI        IFEQ      'P'
     C     VFPTFI        OREQ      'S'                                                        CLE106
     C     VFPTFI        OREQ      'R'                                                        CLE106
     C                   MOVE      FLPSCY        WSCCY
     C                   ENDIF
     C                   ENDIF
      *
      ** If settlement is start date and method is either 01 07 or 08,
      ** then check date for a holiday in both local and fee ccy.
      *
     C     DDEPSDOK      IFEQ      'Y'
     C     DDEPON        IFEQ      'S'
     C     DDEPON        OREQ      ' '
     C                   Z-ADD     VFPSTD        ZDAYNO
     C     FESTTL        IFEQ      01
     C     FESTTL        OREQ      07
     C     FESTTL        OREQ      08
      *
      ** Fee Ccy check
      *
     C     CEU004        IFEQ      'Y'
     C     WSCCY         ANDNE     *BLANKS
     C                   MOVE      WSCCY         ZCCY
     C                   ELSE
     C                   MOVE      DDECUR        ZCCY              3
     C                   ENDIF
     C                   MOVE      '*BLANKS'     ZLOC              3
 
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY              3
     C                   PARM                    BJSLCD
     C                   PARM                    HolidayInd        1
     C*
     C*   If HolidayInd = 'H' then the date is a holiday.
     C     HolidayInd    IFEQ      'H'
     C                   MOVE      'W'           DDEPSDOK
     C                   ADD       1             WId
     C                   MOVEL     'DDEPSD'      WFldNmXAr(WId)
     C     CEU004        IFEQ      'Y'
     C     WSCCY         ANDNE     *BLANKS
     C                   MOVEL     'LER0225'     WMsgIdXAr(WId)
     C                   ELSE
     C                   MOVEL     'LER0024'     WMsgIdXAr(WId)
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Local Ccy check
      *
     C                   MOVE      BJLCCY        ZCCY
 
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    ZCCY
     C                   PARM                    BJSLCD
     C                   PARM                    HolidayInd
     C*
     C*   If HolidayInd = 'H' then the date is a holiday.
     C     HolidayInd    IFEQ      'H'
     C                   MOVE      'W'           DDEPSDOK
     C                   ADD       1             WId
     C                   MOVEL     'DDEPSD'      WFldNmXAr(WId)
     C                   MOVEL     'LER0032'     WMsgIdXAr(WId)
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** If settlement is end date and method is either 01 07 or 08,
      ** then check date for a holiday in both local and fee ccy.
      *
     C     DDEPEDOK      IFEQ      'Y'
     C     DDEPON        IFEQ      'E'
     C                   Z-ADD     VFPEND        ZDAYNO
     C     FESTTL        IFEQ      01
     C     FESTTL        OREQ      07
     C     FESTTL        OREQ      08
      *
     C     CEU004        IFEQ      'Y'
     C     WSCCY         ANDNE     *BLANKS
     C                   MOVE      WSCCY         ZCCY
     C                   ELSE
     C                   MOVE      DDECUR        ZCCY
     C                   ENDIF
      *
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    BJSLCD
     C                   PARM                    HolidayInd
     C*
     C*   If HolidayInd = 'H' then the date is a holiday.
     C     HolidayInd    IFEQ      'H'
     C                   MOVE      'W'           DDEPEDOK
     C                   ADD       1             WId
     C                   MOVEL     'DDEPED'      WFldNmXAr(WId)
     C     CEU004        IFEQ      'Y'
     C     WSCCY         ANDNE     *BLANKS
     C                   MOVEL     'LER0216'     WMsgIdXAr(WId)
     C                   ELSE
     C                   MOVEL     'LER0031'     WMsgIdXAr(WId)
     C                   ENDIF
     C                   ENDIF
      *
      ** Fee Ccy check
      *
     C                   ELSE
      *
      ** Local Ccy check
      *
     C                   MOVE      BJLCCY        ZCCY
      *
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    BJSLCD
     C                   PARM                    HolidayInd
     C*
     C*   If HolidayInd = 'H' then the date is a holiday.
     C     HolidayInd    IFEQ      'H'
     C                   MOVE      'W'           DDEPEDOK
     C                   ADD       1             WId
     C                   MOVEL     'DDEPED'      WFldNmXAr(WId)
     C                   MOVEL     'LER0033'     WMsgIdXAr(WId)
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If settlement is next payment date and method is either 01 07
      ** or 08, then check date for a holiday in both local and fee ccy.
      *
     C     DDNPYDOK      IFEQ      'Y'
     C     DDEPON        IFEQ      'N'
     C                   Z-ADD     VFNPYD        ZDAYNO
 
     C     FESTTL        IFEQ      01
     C     FESTTL        OREQ      07
     C     FESTTL        OREQ      08
      *
     C                   MOVE      DDECUR        ZCCY              3
      *
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    BJSLCD
     C                   PARM                    HolidayInd
     C*
     C*   If HolidayInd = 'H' then the date is a holiday.
     C     HolidayInd    IFEQ      'H'
     C                   MOVE      'W'           DDNPYDOK
     C                   ADD       1             WId
     C                   MOVEL     'DDNPYD'      WFldNmXAr(WId)
     C                   MOVEL     'LER0229'     WMsgIdXAr(WId)
     C                   ENDIF
      ** Fee Ccy check
      *
     C                   ELSE
      *
      ** Local Ccy check
      *
     C                   MOVE      BJLCCY        ZCCY              3
      *
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    BJSLCD
     C                   PARM                    HolidayInd
     C*
     C*   If HolidayInd = 'H' then the date is a holiday.
     C     HolidayInd    IFEQ      'H'
     C                   MOVE      'W'           DDNPYDOK
     C                   ADD       1             WId
     C                   MOVEL     'DDNPYD'      WFldNmXAr(WId)
     C                   MOVEL     'LER0230'     WMsgIdXAr(WId)
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ***  Update error information with that received back
      ***  from each validation module.
      *
     C                   EXSR      UPDATERRS
      *
      ***  Return
      *    ======
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  #TERM - Termination processing.                              *
      *****************************************************************
     C     #TERM         BEGSR
      *
      ***  Terminate program
      *
     C                   MOVE      '1'           *INLR
      *
     C     *INU7         IFEQ      '1'
     C                   DUMP
     C                   END
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  RESETERRS - Reset error information that is received back    *
      *              from each validation module.                     *
      *****************************************************************
      *
     C     RESETERRS     BEGSR
      *
     C                   EVAL      RetCodeOut = *BLANKS
      *
      ***  Reset error & warning fields/message IDs/message data (arrays)
      *
     C                   MOVEL     *BLANK        FldNamXAr
     C                   MOVEL     *BLANK        MsgIDXAr
     C                   MOVEL     *BLANK        MsgDtaXAr
     C                   MOVEL     *BLANK        WFldNmXAr
     C                   MOVEL     *BLANK        WMsgIDXAr
     C                   MOVEL     *BLANK        WMsgDtXAr
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  UPDATERRS - Update error information with that received back *
      *              from each validation module.                     *
      *****************************************************************
     C     UPDATERRS     BEGSR
      *
      ***  Update error fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I                 3 0
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   END
      *
      ***  Set Error Index
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx
      *
      ***  Update warning fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   END
      *
      ***  Set Warning Index
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     I             SUB       1             WId
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - Program Initialisation routine                      *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ***  Response mode (1A), from source system common header
     C                   PARM                    RespMode
      *
      * Fee detail file
     C                   PARM                    CrFeFilFmt
      * Fee detail screen
     C                   PARM                    NwFeScnFmt
      *
      * Fee Valid file
     C                   PARM                    ValidFeem
      ***  CEU004
     C                   PARM                    CEU004            1
      * Payment instructions
     C                   PARM                    F_Pay
      *
      *  Receive instructions
     C                   PARM                    F_REC
      *
      *  FRA/IRS instructions
     C                   PARM                    F_FRI
 
      *
      ***  Field OK flags (DS) from/to caller
     C                   PARM                    OKFee
      *
      ***  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
      ***  Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      ***  Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      ***  Array index (3P0) from/to caller
     C                   PARM                    WId
 
      ***  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'LEFEEMEVL'   DBPGM
     C                   OUT       LDA
      *
      *
      ***  Access Bank details via access program
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   Z-ADD     1             DBASE                          * DBERR 001 *
     C                   MOVEL     '*FIRST'      DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ***  Access General Ledger details
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDGELRPD'    DBFILE                         *************
     C                   Z-ADD     2             DBASE                          * DBERR 002 *
     C                   MOVEL     '*FIRST'      DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
E004 C                   ENDIF
      *
      ** Determine if EMU LE Settlement Currency Conversion
      ** Upgrade feature is installed
      *
     C                   MOVE      'N'           CEU004            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU004'      @SARD             6
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CEU004
     C                   END
                                                                                              CLE031
      ** Determine if Settlement Currency is installed                                        CLE031
                                                                                              CLE031
     C                   MOVE      'N'           CLE031            1                          CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       @RTCD                                        CLE031
     C                   PARM      '*VERIFY'     @OPTN                                        CLE031
     C                   PARM      'CLE031'      @SARD                                        CLE031
                                                                                              CLE031
     C     @RTCD         IFEQ      *BLANKS                                                    CLE031
     C                   MOVE      'Y'           CLE031                                       CLE031
     C                   ENDIF                                                                CLE031
      *
      ***  Determine whether program is running interactively or in batch
      ***   ( 0 = batch   1 = interactive)
      *
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    @RTCD
     C                   PARM                    PMODE             1
      *
      ***  Program, module and procedure names for database error processing.
      ***  =================================================================
      ***  The following /COPY sets these values, and also defines LDA as
      ***  an external data area
      *
      /COPY WNCPYSRC,LEFEEMEV08
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
