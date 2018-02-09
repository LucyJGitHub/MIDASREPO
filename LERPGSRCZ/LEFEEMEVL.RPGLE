     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Fee input Extra validation for settlement')   *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LEFEEMEVL -  Customer Fee Extra validations for settlement   *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD039016           Date 26May16               *
      *                 CLE141A            Date 28Apr16               *
      *                 MD038457           Date 28Apr16               *
      *                 CLE141             Date 08Feb16               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
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
      *  MD046248 - Finastra Rebranding                               *
      *  MD039016 - Different event codes for BDC validation in       *
      *             various Lending APIs                              *
      *  CLE141A - CLE141 Change Control 1                            *
      *  MD038457 - When initial settlement type is 08 and no         *
      *             amendments on settlement type system did not      *
      *             generate warning message related to holidays      *
      *  CLE141 - Currency and Location Business Day Convention       *
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
     FCLOANL4   IF   E           K DISK    INFSR(*PSSR)                                       CLE141
     F                                     PREFIX(pd_)                                        CLE141
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
     D Kpd_LNRF        S                   INZ LIKE(pd_LNRF)                                  CLE141
     D Kpd_RECI        S                   INZ LIKE(pd_RECI)                                  CLE141
     D WFSTTL          S                   INZ LIKE(FLRSTM)                                   CLE141
 
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
 
     D CLE141          S              1A                                                      CLE141
     D CurLocArr       S              3    DIM(20)                                            CLE141
     D CurLocDS        S             60                                                      CLE141A
     D RetCode         S              7A                                                      CLE141
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
      *                                                                                      CLE141A
     C     CLE141        IFEQ      'Y'                                                       CLE141A
     C     VFLOAN        ANDNE     *blanks                                                   CLE141A
     C                   Eval      Kpd_RECI = 'D'                                            CLE141A
     C                   Eval      Kpd_LNRF = VFLOAN                                         CLE141A
     C     KCLOANL4      CHAIN     CLOANL4                                                   CLE141A
     C                   IF        %FOUND(CLOANL4)                                           CLE141A
      ** Set the value for Business Day Convention Fields                                    CLE141A
     C                   EVAL      CurLocArr(1) = PD_C1PI                                    CLE141A
     C                   EVAL      CurLocArr(2) = PD_C2PI                                    CLE141A
     C                   EVAL      CurLocArr(3) = PD_C3PI                                    CLE141A
     C                   EVAL      CurLocArr(4) = PD_C4PI                                    CLE141A
     C                   EVAL      CurLocArr(5) = PD_C5PI                                    CLE141A
     C                   EVAL      CurLocArr(6) = PD_C6PI                                    CLE141A
     C                   EVAL      CurLocArr(7) = PD_C7PI                                    CLE141A
     C                   EVAL      CurLocArr(8) = PD_C8PI                                    CLE141A
     C                   EVAL      CurLocArr(9) = PD_C9PI                                    CLE141A
     C                   EVAL      CurLocArr(10) = PD_C0PI                                   CLE141A
     C                   EVAL      CurLocArr(11) = PD_L1PI                                   CLE141A
     C                   EVAL      CurLocArr(12) = PD_L2PI                                   CLE141A
     C                   EVAL      CurLocArr(13) = PD_L3PI                                   CLE141A
     C                   EVAL      CurLocArr(14) = PD_L4PI                                   CLE141A
     C                   EVAL      CurLocArr(15) = PD_L5PI                                   CLE141A
     C                   EVAL      CurLocArr(16) = PD_L6PI                                   CLE141A
     C                   EVAL      CurLocArr(17) = PD_L7PI                                   CLE141A
     C                   EVAL      CurLocArr(18) = PD_L8PI                                   CLE141A
     C                   EVAL      CurLocArr(19) = PD_L9PI                                   CLE141A
     C                   EVAL      CurLocArr(20) = PD_L0PI                                   CLE141A
     C                   MOVEA     CURLOCARR     CURLOCDS                                    CLE141A
 
     C                   ENDIF                                                               CLE141A
     C                   ENDIF                                                               CLE141A
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
 
      ** use the receipt settlement method from sceen on                                      CLE141
      ** checking if the date should be validated based on business day convention            CLE141
 
     C     VFPTFI        IFEQ      *blanks                                                    CLE141
     C                   EVAl      WFSTTL = FLRSTM                                            CLE141
     C                   ELSE                                                                 CLE141
     C                   EVAl      WFSTTL = FLPSTM                                            CLE141
     C                   ENDIF                                                                CLE141
     C                   Eval      DDEPON = VFPYON                                            CLE141
 
      *
      ** If settlement is start date and method is either 01 07 or 08,
      ** then check date for a holiday in both local and fee ccy.
      *
     C     DDEPSDOK      IFEQ      'Y'
     C     DDEPON        IFEQ      'S'
     C     DDEPON        OREQ      ' '
     C                   Z-ADD     VFPSTD        ZDAYNO
 
     C*****FESTTL        IFEQ      01                                                         CLE141
     C*****FESTTL        OREQ      07                                                         CLE141
     C*****FESTTL        OREQ      08                                                         CLE141
 
     C     WFSTTL        IFEQ      01                                                         CLE141
     C     WFSTTL        OREQ      07                                                         CLE141
     C     WFSTTL        OREQ      08                                                         CLE141
     C
      *
      ** Fee Ccy check
      *
     C     CEU004        IFEQ      'Y'
     C     WSCCY         ANDNE     *BLANKS
     C                   MOVE      WSCCY         ZCCY
     C                   ELSE
     C**********         MOVE      DDECUR        ZCCY              3                         CLE141A
     C                   MOVE      VFFCCY        ZCCY              3                         CLE141A
     C                   ENDIF
     C                   MOVE      '*BLANKS'     ZLOC              3
 
     C*****CLE141        IFEQ      'Y'                                                CLE141 CLE141A
     C*****VFLOAN        ANDNE     *blanks                                            CLE141 CLE141A
 
     C**********         CALLB     'LEVBDYLE'                                         CLE141 CLE141A
     C**********         PARM      *BLANKS       RetCode                              CLE141 CLE141A
     C**********         PARM                    CurLocArr                            CLE141 CLE141A
     C**********         PARM                    ZDAYNO                               CLE141 CLE141A
 
     C*****RetCode       IFEQ      'HOLIDAY'                                          CLE141 CLE141A
     C**********         EVAL      WMsgIDXAr = '5048508'                             CLE141 MD038457
     C**********         EVAL      DDEPSDOK = 'W'                                     CLE141 CLE141A
     C**********         EVAL      WId = WId + 1                                      CLE141 CLE141A
     C**********         EVAL      WMsgIDXAr(WId) = '5048508'                       MD038457 CLE141A
     C**********         EVAL      WFldNmXAr(WId) = 'DDEPSD'                          CLE141 CLE141A
     C**********         ENDIF                                                        CLE141 CLE141A
 
     C**********         ELSE                                                         CLE141 CLE141A
 
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
                                                                                              CLE141
     C**********         ENDIF                                                        CLE141 CLE141A
                                                                                              CLE141
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
      *                                                                                      CLE141A
     C     CLE141        IFEQ      'Y'                                                       CLE141A
     C     VFLOAN        ANDNE     *Blanks                                                   CLE141A
     C     CurLocDS      ANDNE     *Blanks                                                   CLE141A
      *                                                                                      CLE141A
     C                   CALLB     'LEVBDYLE'                                                CLE141A
     C                   PARM      *BLANKS       RetCode                                     CLE141A
     C                   PARM                    CurLocDS                                    CLE141A
     C                   PARM                    ZDAYNO                                      CLE141A
      *                                                                                      CLE141A
     C     RetCode       IFEQ      'HOLIDAY'                                                 CLE141A
     C                   EVAL      DDEPSDOK = 'W'                                            CLE141A
     C                   EVAL      WId = WId + 1                                             CLE141A
     C                   EVAL      WFldNmXAr(WId) = 'DDEPSD'                                 CLE141A
     C**********         EVAL      WMsgIDXAr(WId) = '5048508'                       CLE141A MD039016
     C                   EVAL      WMsgIDXAr(WId) = '5048565'                               MD039016
     C                   ENDIF                                                               CLE141A
      *                                                                                      CLE141A
     C                   ENDIF                                                               CLE141A
     C                   ENDIF
     C                   ENDIF
      *
      ** If settlement is end date and method is either 01 07 or 08,
      ** then check date for a holiday in both local and fee ccy.
      *
     C     DDEPEDOK      IFEQ      'Y'
     C     DDEPEDOK      OREQ      'W'                                                      MD038457
     C     DDEPON        IFEQ      'E'
     C                   Z-ADD     VFPEND        ZDAYNO
 
     C*****FESTTL        IFEQ      01                                                         CLE141
     C*****FESTTL        OREQ      07                                                         CLE141
     C*****FESTTL        OREQ      08                                                         CLE141
 
     C     WFSTTL        IFEQ      01                                                         CLE141
     C     WFSTTL        OREQ      07                                                         CLE141
     C     WFSTTL        OREQ      08                                                         CLE141
      *
     C     CEU004        IFEQ      'Y'
     C     WSCCY         ANDNE     *BLANKS
     C                   MOVE      WSCCY         ZCCY
     C                   ELSE
     C**********         MOVE      DDECUR        ZCCY                                        CLE141A
     C                   MOVE      VFFCCY        ZCCY                                        CLE141A
     C                   ENDIF
 
     C*****CLE141        IFEQ      'Y'                                                CLE141 CLE141A
     C*****VFLOAN        ANDNE     *blanks                                            CLE141 CLE141A
 
     C**********         CALLB     'LEVBDYLE'                                         CLE141 CLE141A
     C**********         PARM      *BLANKS       RetCode                              CLE141 CLE141A
     C**********         PARM                    CurLocArr                            CLE141 CLE141A
     C**********         PARM                    ZDAYNO                               CLE141 CLE141A
 
     C*****RetCode       IFEQ      'HOLIDAY'                                          CLE141 CLE141A
     C**********         EVAL      WMsgIDXAr = '5048508'                             CLE141 MD038457
     C**********         EVAL      DDEPSDOK = 'W'                                    CLE141 MD038457
     C**********         EVAL      DDEPEDOK = 'W'                                   MD038457 CLE141A
     C**********         EVAL      WId = WId + 1                                      CLE141 CLE141A
     C**********         EVAL      WMsgIDXAr(WId) = '5048508'                       MD038457 CLE141A
     C**********         EVAL      WFldNmXAr(WId) = 'DDEPED'                          CLE141 CLE141A
     C**********         ENDIF                                                        CLE141 CLE141A
 
     C**********         ELSE                                                         CLE141 CLE141A
 
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
                                                                                              CLE141
     C**********         ENDIF                                                        CLE141 CLE141A
                                                                                              CLE141
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
      *                                                                                      CLE141A
     C     CLE141        IFEQ      'Y'                                                       CLE141A
     C     VFLOAN        ANDNE     *Blanks                                                   CLE141A
     C     CurLocDS      ANDNE     *Blanks                                                   CLE141A
      *                                                                                      CLE141A
     C                   CALLB     'LEVBDYLE'                                                CLE141A
     C                   PARM      *BLANKS       RetCode                                     CLE141A
     C                   PARM                    CurLocDS                                    CLE141A
     C                   PARM                    ZDAYNO                                      CLE141A
      *                                                                                      CLE141A
     C     RetCode       IFEQ      'HOLIDAY'                                                 CLE141A
     C                   EVAL      DDEPEDOK = 'W'                                            CLE141A
     C                   EVAL      WId = WId + 1                                             CLE141A
     C                   EVAL      WFldNmXAr(WId) = 'DDEPED'                                 CLE141A
     C**********         EVAL      WMsgIDXAr(WId) = '5048508'                       CLE141A MD039016
     C                   EVAL      WMsgIDXAr(WId) = '5048566'                               MD039016
     C                   ENDIF                                                               CLE141A
      *                                                                                      CLE141A
     C                   ENDIF                                                               CLE141A
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
 
     C*****FESTTL        IFEQ      01                                                         CLE141
     C*****FESTTL        OREQ      07                                                         CLE141
     C*****FESTTL        OREQ      08                                                         CLE141
 
     C     WFSTTL        IFEQ      01                                                         CLE141
     C     WFSTTL        OREQ      07                                                         CLE141
     C     WFSTTL        OREQ      08                                                         CLE141
      *
     C**********         MOVE      DDECUR        ZCCY              3                         CLE141A
     C                   MOVE      VFFCCY        ZCCY                                        CLE141A
 
     C*****CLE141        IFEQ      'Y'                                                CLE141 CLE141A
     C*****VFLOAN        ANDNE     *blanks                                            CLE141 CLE141A
 
     C**********         CALLB     'LEVBDYLE'                                         CLE141 CLE141A
     C**********         PARM      *BLANKS       RetCode                              CLE141 CLE141A
     C**********         PARM                    CurLocArr                            CLE141 CLE141A
     C**********         PARM                    ZDAYNO                               CLE141 CLE141A
 
     C*****RetCode       IFEQ      'HOLIDAY'                                          CLE141 CLE141A
     C**********         EVAL      WMsgIDXAr = '5048508'                             CLE141 MD038457
     C**********         EVAL      DDEPSDOK = 'W'                                    CLE141 MD038457
     C**********         EVAL      DDNPYDOK = 'W'                                   MD038457 CLE141A
     C**********         EVAL      WId = WId + 1                                      CLE141 CLE141A
     C**********         EVAL      WMsgIDXAr(WId) = '5048508'                       MD038457 CLE141A
     C**********         EVAL      WFldNmXAr(WId) = 'DDNPYD'                          CLE141 CLE141A
     C**********         ENDIF                                                        CLE141 CLE141A
 
     C**********         ELSE                                                         CLE141 CLE141A
 
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
                                                                                              CLE141
     C**********         ENDIF                                                        CLE141 CLE141A
                                                                                              CLE141
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
      *                                                                                      CLE141A
     C     CLE141        IFEQ      'Y'                                                       CLE141A
     C     VFLOAN        ANDNE     *Blanks                                                   CLE141A
     C     CurLocDS      ANDNE     *Blanks                                                   CLE141A
      *                                                                                      CLE141A
     C                   CALLB     'LEVBDYLE'                                                CLE141A
     C                   PARM      *BLANKS       RetCode                                     CLE141A
     C                   PARM                    CurLocDS                                    CLE141A
     C                   PARM                    ZDAYNO                                      CLE141A
      *                                                                                      CLE141A
     C     RetCode       IFEQ      'HOLIDAY'                                                 CLE141A
     C                   EVAL      DDNPYDOK = 'W'                                            CLE141A
     C                   EVAL      WId = WId + 1                                             CLE141A
     C                   EVAL      WFldNmXAr(WId) = 'DDNPYD'                                 CLE141A
     C**********         EVAL      WMsgIDXAr(WId) = '5048508'                       CLE141A MD039016
     C                   EVAL      WMsgIDXAr(WId) = '5048567'                               MD039016
     C                   ENDIF                                                               CLE141A
      *                                                                                      CLE141A
     C                   ENDIF                                                               CLE141A
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
     C                   EVAL      WId = *Zero                                             MD038457
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
                                                                                              CLE141
      ** Check if CLE141 - Business day Convention is on                                      CLE141
                                                                                              CLE141
     C                   CALLB     'AOSARDR0'                                                 CLE141
     C                   PARM      *BLANKS       @RTCD                                        CLE141
     C                   PARM      '*VERIFY '    @OPTN                                        CLE141
     C                   PARM      'CLE141'      @SARD                                        CLE141
                                                                                              CLE141
     C     @RTCD         IFEQ      *BLANKS                                                    CLE141
     C                   MOVEL     'Y'           CLE141                                       CLE141
     C                   ELSE                                                                 CLE141
     C                   MOVEL     'N'           CLE141                                       CLE141
     C                   ENDIF                                                                CLE141
 
     C*****CLE141        IFEQ      'Y'                                                CLE141 CLE141A
     C*****VFLOAN        ANDNE     *blanks                                            CLE141 CLE141A
     C**********         Eval      Kpd_RECI = 'D'                                     CLE141 CLE141A
     C**********         Eval      Kpd_LNRF = VFLOAN                                  CLE141 CLE141A
     C*****KCLOANL4      CHAIN     CLOANL4                                            CLE141 CLE141A
     C**********         IF        %FOUND(CLOANL4)                                    CLE141 CLE141A
      ***Set*the value for Business Day Convention Fields                             CLE141 CLE141A
     C**********         EVAL      CurLocArr(1) = PD_C1PI                             CLE141 CLE141A
     C**********         EVAL      CurLocArr(2) = PD_C2PI                             CLE141 CLE141A
     C**********         EVAL      CurLocArr(3) = PD_C3PI                             CLE141 CLE141A
     C**********         EVAL      CurLocArr(4) = PD_C4PI                             CLE141 CLE141A
     C**********         EVAL      CurLocArr(5) = PD_C5PI                             CLE141 CLE141A
     C**********         EVAL      CurLocArr(6) = PD_C6PI                             CLE141 CLE141A
     C**********         EVAL      CurLocArr(7) = PD_C7PI                             CLE141 CLE141A
     C**********         EVAL      CurLocArr(8) = PD_C8PI                             CLE141 CLE141A
     C**********         EVAL      CurLocArr(9) = PD_C9PI                             CLE141 CLE141A
     C**********         EVAL      CurLocArr(10) = PD_C0PI                            CLE141 CLE141A
     C**********         EVAL      CurLocArr(11) = PD_L1PI                            CLE141 CLE141A
     C**********         EVAL      CurLocArr(12) = PD_L2PI                            CLE141 CLE141A
     C**********         EVAL      CurLocArr(13) = PD_L3PI                            CLE141 CLE141A
     C**********         EVAL      CurLocArr(14) = PD_L4PI                            CLE141 CLE141A
     C**********         EVAL      CurLocArr(15) = PD_L5PI                            CLE141 CLE141A
     C**********         EVAL      CurLocArr(16) = PD_L6PI                            CLE141 CLE141A
     C**********         EVAL      CurLocArr(17) = PD_L7PI                            CLE141 CLE141A
     C**********         EVAL      CurLocArr(18) = PD_L8PI                            CLE141 CLE141A
     C**********         EVAL      CurLocArr(19) = PD_L9PI                            CLE141 CLE141A
     C**********         EVAL      CurLocArr(20) = PD_L0PI                            CLE141 CLE141A
 
     C**********         ENDIF                                                        CLE141 CLE141A
     C**********         ENDIF                                                        CLE141 CLE141A
      *
      ***  Program, module and procedure names for database error processing.
      ***  =================================================================
      ***  The following /COPY sets these values, and also defines LDA as
      ***  an external data area
      *
      /COPY WNCPYSRC,LEFEEMEV08
      *
     C     KCLOANL4      KLIST                                                                CLE141
     C                   KFLD                    Kpd_RECI                                     CLE141
     C                   KFLD                    Kpd_LNRF                                     CLE141
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
**  CPY@
(c) Finastra International Limited 2002
