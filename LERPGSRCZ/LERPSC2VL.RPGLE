     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Repayments Schedule - Add. val. for Settl')   *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LERPSC2VL - Midas LE Repayments Schedule - Add. Validations  *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE154             Date 02Aug12               *
      *                 MD039260           Date 07Jun16               *
      *                 MD039016           Date 26May16               *
      *                 CLE141A            Date 28Apr16               *
      *                 CLE141             Date 08Feb16               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 261070             Date 16Jul09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE031             Date 26Apr05               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG5863            Date 14Feb04               *
      *                 BUG4351 (reopen)   Date 12Oct04               *
      *                 BUG4351            Date 23Sep04               *
      *                 CAP079  *CREATE    Date 10Jul02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE154 - Loan Repayment Schedule Enhancement (Recompile)     *
      *  MD039260 - No error message related to Local currency if     *
      *             value date falls on holiday in Local currency     *
      *             and settlement method is 14                       *
      *  MD039016 - Different event codes for BDC validation in       *
      *             various Lending APIs                              *
      *  CLE141A - CLE141 Change Control 1                            *
      *  CLE141 - Currency and Location Business Day Convention       *
      *           for LE Transactions                                 *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  261070 - Warning message not shown when value date is on a   *
      *           holiday. Amend program such that correct validation *
      *           for value date would be done.                       *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager. (Recompiled)                  *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it (recompile)                              *
      *  BUG5863 - Index of Warning errors array (WId) should be      *
      *            reset to zero to prevent array index out of range. *
      *  BUG4351 - Index of Warning errors array WFldNmXAr should be  *
      *            different to the index for WFldNamArr.             *
      *  BUG4351 - Remove the use of work fields to suppress warning  *
      *            errors being re-displayed when data unchanged.     *
      *  CAP079 - Lending API enhancements - Repayments schedule      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
      *
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
      ***  Midas LE Loans details file
     F                                     IGNORE(CLOANHHF:CLOANZ1F)
     F                                     PREFIX(CL_)
      /COPY WNCPYSRC,LERPSCV201
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
     D WFldNmXAr       S             10A   DIM(XArrayMax)
      ***  Array of Fields with warnings.
      *
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)
      ***  Array of warning message IDs
      *
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
      ***  Array of warning message data.
      *
     D ##RECF        E DS                  EXTNAME(SDESFRPD)
      ***  File Receive Instructions
      *
     D ##PAYF        E DS                  EXTNAME(SDESFPPD)
      ***  File Payment Instructions
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for bank details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for access programs, short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ***  First DS for access programs, long data structure
      *
     D ValidRpSc     E DS                  EXTNAME(LEVRPSCPD)
      ***  Valid Repayment schedule in file format
      *
     D OKFlagsDS     E DS                  EXTNAME(LEERPSCPD)
      ***  Flags to indicate whether transaction fields are valid
      *
     D LoanBDC         DS            60                                                       CLE141
     D   CCY1                  1      3                                                       CLE141
     D   CCY2                  4      6                                                       CLE141
     D   CCY3                  7      9                                                       CLE141
     D   CCY4                 10     12                                                       CLE141
     D   CCY5                 13     15                                                       CLE141
     D   CCY6                 16     18                                                       CLE141
     D   CCY7                 19     21                                                       CLE141
     D   CCY8                 22     24                                                       CLE141
     D   CCY9                 25     27                                                       CLE141
     D   CCY0                 28     30                                                       CLE141
     D   LOC1                 31     33                                                       CLE141
     D   LOC2                 34     36                                                       CLE141
     D   LOC3                 37     39                                                       CLE141
     D   LOC4                 40     42                                                       CLE141
     D   LOC5                 43     45                                                       CLE141
     D   LOC6                 46     48                                                       CLE141
     D   LOC7                 49     51                                                       CLE141
     D   LOC8                 52     54                                                       CLE141
     D   LOC9                 55     57                                                       CLE141
     D   LOC0                 58     60                                                       CLE141
                                                                                              CLE141
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D WId             S              3P 0
     D WIdx            S              3P 0                                                   BUG4351
      ***  Index for arrays of of warning message ids etc
      *
     D RespMode        S              1A
      ***  Response Mode, received as a parameter from the common header
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
      *
      /COPY WNCPYSRC,LERPSCV202
      *****************************************************************
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      /COPY WNCPYSRC,LERPSCV203
      *
      ***  Additional validation
      *    =====================
      *
      ***  Reset variables updated by each module
      *
     C                   EXSR      RESETERRS
      *
      ***  Access the related loan
      *
     C                   MOVE      RPLNRF        K@LNRF
     C                   MOVE      'A'           K@RCDT
      *
     C     K@LOAN        CHAIN(N)  CLOAN                              99
     C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     'CLOANCL '    DBFILE                         *************
     C                   Z-ADD     1             DBASE                          * DBERR 001 *
     C                   MOVEL     RPLNRF        DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ***  Set up data from settlement instructions
      *
      /COPY WNCPYSRC,LERPSCV204
     C                   EXSR      SRSETT
      /COPY WNCPYSRC,LERPSCV205
      *
      ***  Perform the additional validations (Warning)
      *
      /COPY WNCPYSRC,LERPSCV206
     C                   EXSR      SRVALA
      /COPY WNCPYSRC,LERPSCV207
      *
      ***  Update error information with that received back
      ***  from each validation module.
      *
     C                   EXSR      UPDATERRS
      *
      ***  Save the loan reference for warning
      *
     C**********         MOVEL     RPLNRF        SaveRPLNRF        6 0                        CLE148
     C                   MOVEL     RPLNRF        SaveRPLNRF        6                          CLE148
     C                   MOVEL     RPVDAT        SaveRPVDAT        5 0
     C                   MOVEL     RPLASN        SaveRPLASN        3 0
      *
      ***  Return
      *    ======
     C                   RETURN
      *
      ***  Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,LERPSCV208
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SRSETT - Set up data from settlement instructions            *
      *****************************************************************
     C     SRSETT        BEGSR
      *
      ***  Move settlement details received
      *
     C     CL_PTYP       IFEQ      66
     C     CLE005        OREQ      'Y'
     C     CL_PTYP       ANDEQ     69
     C     CLE005        OREQ      'Y'
     C     CL_PTYP       ANDEQ     72
     C                   MOVEL     FLPSTM        WSETP             2
      *
     C     CLE031        IFNE      'Y'                                                        CLE031
     C     CEU004        IFEQ      'Y'
     C                   MOVE      FLPSCY        WSCCY             3
     C                   ENDIF
      *                                                                                       CLE031
     C                   ELSE                                                                 CLE031
     C     FLRSCY        IFNE      *BLANKS                                                    CLE031
     C                   MOVE      FLRSCY        WSCCY                                        CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
      *
     C                   ELSE
     C                   MOVEL     FLRSTM        WSETP
      *
     C     CEU004        IFEQ      'Y'
     C     CLE031        IFNE      'Y'                                                        CLE031
     C                   MOVE      FLRSCY        WSCCY
     C                   ENDIF
     C                   ELSE                                                                 CLE031
     C     FLRSCY        IFNE      *BLANKS                                                    CLE031
     C                   MOVE      FLRSCY        WSCCY                                        CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
      *
     C                   END
      *
     C                   MOVE      WSETP         WTYPE             2
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SRVALA - Additional validations (Warning)                    *
      *****************************************************************
     C     SRVALA        BEGSR
      *
      ***  Check that value date is not a holiday in the deal / local CCY
      *
     C     WTYPE         IFNE      '00'
     C     WTYPE         ANDNE     '  '
      *
     C                   Z-ADD     RPVDAT        ZDAYNO
     C                   MOVEL     *Blanks       ZLOC                                       MD039260
     C**********         EVAL      LoanBDC = *Blanks                                  CLE141 CLE141A
     C**********         EVAL      ZIND = *Blanks                                     CLE141 CLE141A
     C**********         EVAL      RetCode = *Blanks                                  CLE141 CLE141A
      *
      ***  Find currency to use
      *
     C     WTYPE         IFEQ      '01'
     C     WTYPE         OREQ      '07'
     C     WTYPE         OREQ      '08'
      *
     C**********         IF        CLE141 = 'Y'                                       CLE141 CLE141A
     C**********         EVAL      CCY1 = CL_C1PI                                     CLE141 CLE141A
     C**********         EVAL      CCY2 = CL_C2PI                                     CLE141 CLE141A
     C**********         EVAL      CCY3 = CL_C3PI                                     CLE141 CLE141A
     C**********         EVAL      CCY4 = CL_C4PI                                     CLE141 CLE141A
     C**********         EVAL      CCY5 = CL_C5PI                                     CLE141 CLE141A
     C**********         EVAL      CCY6 = CL_C6PI                                     CLE141 CLE141A
     C**********         EVAL      CCY7 = CL_C7PI                                     CLE141 CLE141A
     C**********         EVAL      CCY8 = CL_C8PI                                     CLE141 CLE141A
     C**********         EVAL      CCY9 = CL_C9PI                                     CLE141 CLE141A
     C**********         EVAL      CCY0 = CL_C0PI                                     CLE141 CLE141A
     C**********         EVAL      LOC1 = CL_L1PI                                     CLE141 CLE141A
     C**********         EVAL      LOC2 = CL_L2PI                                     CLE141 CLE141A
     C**********         EVAL      LOC3 = CL_L3PI                                     CLE141 CLE141A
     C**********         EVAL      LOC4 = CL_L4PI                                     CLE141 CLE141A
     C**********         EVAL      LOC5 = CL_L5PI                                     CLE141 CLE141A
     C**********         EVAL      LOC6 = CL_L6PI                                     CLE141 CLE141A
     C**********         EVAL      LOC7 = CL_L7PI                                     CLE141 CLE141A
     C**********         EVAL      LOC8 = CL_L8PI                                     CLE141 CLE141A
     C**********         EVAL      LOC9 = CL_L9PI                                     CLE141 CLE141A
     C**********         EVAL      LOC0 = CL_L0PI                                     CLE141 CLE141A
     C**********         ENDIF                                                        CLE141 CLE141A
                                                                                              CLE141
     C     CEU004        IFEQ      'Y'
     C     WSCCY         ANDNE     *BLANKS
     C     CLE031        OREQ      'Y'                                                        CLE031
     C     WSCCY         ANDNE     *BLANKS                                                    CLE031
     C                   MOVE      WSCCY         ZCCY
     C                   ELSE
     C                   MOVE      RPCCY         ZCCY
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVE      BJLCCY        ZCCY
     C                   MOVE      BJSLCD        ZLOC                                       MD039260
     C                   ENDIF
      *
      ***  If date is holiday send warning messages
      *
     C**********         Z-ADD     *ZEROS        ZDAYNO                                       261070
     C**********         IF        CLE141 = 'Y' and LoanBDC <> *Blanks                CLE141 CLE141A
     C**********         CALLB     'LEVBDYLE'                                         CLE141 CLE141A
     C**********         PARM      *BLANKS       RetCode           7                  CLE141 CLE141A
     C**********         PARM                    LoanBDC                              CLE141 CLE141A
     C**********         PARM                    ZDAYNO                               CLE141 CLE141A
     C**********         ELSE                                                         CLE141 CLE141A
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    ZCCY              3
     C                   PARM                    ZLOC              3
     C                   PARM      *BLANK        ZIND              1
     C**********         ENDIF                                                        CLE141 CLE141A
      *
     C     WTYPE         IFEQ      '01'
     C     WTYPE         OREQ      '07'
     C     WTYPE         OREQ      '08'
      *
     C**********         IF        CLE141 = 'Y' and RetCode <> *BLANKS                CLE141 CLE141A
     C**********         EVAL      WMsgIDXar = '5048508'                              CLE141 CLE141A
     C**********         EVAL      DDVDATOK = 'N'                                     CLE141 CLE141A
     C**********         ADD       1             WId                                  CLE141 CLE141A
     C**********         EVAL      WFldNmXAr(WId) = 'DDVDAT'                          CLE141 CLE141A
     C**********         ENDIF                                                        CLE141 CLE141A
                                                                                              CLE141
     C     ZIND          IFEQ      'H'
      *
     C     CEU004        IFEQ      'Y'
     C     CLE031        OREQ      'Y'                                                        CLE031
     C                   MOVEL     'LES0307'     WMsgIDXAr
     C                   ELSE
     C                   MOVEL     'LES0051'     WMsgIDXAr
     C                   ENDIF
      *
     C*****WEVDAT        IFEQ      *BLANK                                                    BUG4351
     C*****WEVDAT        OREQ      'Y'                                                       BUG4351
     C*****RPLNRF        ANDNE     W1LNRF                                                    BUG4351
     C*****WEVDAT        OREQ      'Y'                                                       BUG4351
     C*****RPVDAT        ANDNE     W1VDAT                                                    BUG4351
     C*****WEVDAT        OREQ      'Y'                                                       BUG4351
     C*****RPLASN        ANDNE     W1LASN                                                    BUG4351
     C**********         MOVE      RPLNRF        W1LNRF            6 0                       BUG4351
     C**********         MOVE      RPVDAT        W1VDAT            5 0                       BUG4351
     C**********         MOVE      RPLASN        W1LASN            3 0                       BUG4351
     C**********         MOVE      'Y'           WEVDAT                                      BUG4351
     C                   MOVE      'N'           DDVDATOK
     C                   ADD       1             WId
     C                   MOVEL     'DDVDAT'      WFldNmXAr(WId)
     C**********         ENDIF                                                               BUG4351
     C                   ENDIF
      *
     C                   ELSE
      *
     C     ZIND          IFEQ      'H'
      *
     C*****WEVDAT        IFEQ      *BLANK                                                    BUG4351
     C*****WEVDAT        OREQ      'Y'                                                       BUG4351
     C*****RPLNRF        ANDNE     W1LNRF                                                    BUG4351
     C*****WEVDAT        OREQ      'Y'                                                       BUG4351
     C*****RPVDAT        ANDNE     W1VDAT                                                    BUG4351
     C*****WEVDAT        OREQ      'Y'                                                       BUG4351
     C*****RPLASN        ANDNE     W1LASN                                                    BUG4351
     C**********         MOVE      RPLNRF        W1LNRF            6 0                       BUG4351
     C**********         MOVE      RPVDAT        W1VDAT            5 0                       BUG4351
     C**********         MOVE      RPLASN        W1LASN            3 0                       BUG4351
     C**********         MOVE      'Y'           WEVDAT                                      BUG4351
     C                   MOVEL     'LES0052'     WMsgIDXAr
     C                   MOVE      'N'           DDVDATOK
     C                   ADD       1             WId
     C                   MOVEL     'DDVDAT'      WFldNmXAr(WId)
     C**********         ENDIF                                                               BUG4351
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Check if Value Date is Holiday in Business Day Convention                           CLE141A
                                                                                             CLE141A
     C                   IF        CLE141 = 'Y'                                              CLE141A
     C                   EVAL      CCY1 = CL_C1PI                                            CLE141A
     C                   EVAL      CCY2 = CL_C2PI                                            CLE141A
     C                   EVAL      CCY3 = CL_C3PI                                            CLE141A
     C                   EVAL      CCY4 = CL_C4PI                                            CLE141A
     C                   EVAL      CCY5 = CL_C5PI                                            CLE141A
     C                   EVAL      CCY6 = CL_C6PI                                            CLE141A
     C                   EVAL      CCY7 = CL_C7PI                                            CLE141A
     C                   EVAL      CCY8 = CL_C8PI                                            CLE141A
     C                   EVAL      CCY9 = CL_C9PI                                            CLE141A
     C                   EVAL      CCY0 = CL_C0PI                                            CLE141A
     C                   EVAL      LOC1 = CL_L1PI                                            CLE141A
     C                   EVAL      LOC2 = CL_L2PI                                            CLE141A
     C                   EVAL      LOC3 = CL_L3PI                                            CLE141A
     C                   EVAL      LOC4 = CL_L4PI                                            CLE141A
     C                   EVAL      LOC5 = CL_L5PI                                            CLE141A
     C                   EVAL      LOC6 = CL_L6PI                                            CLE141A
     C                   EVAL      LOC7 = CL_L7PI                                            CLE141A
     C                   EVAL      LOC8 = CL_L8PI                                            CLE141A
     C                   EVAL      LOC9 = CL_L9PI                                            CLE141A
     C                   EVAL      LOC0 = CL_L0PI                                            CLE141A
                                                                                             CLE141A
     C                   IF        LoanBDC <> *Blanks                                        CLE141A
     C                   CALLB     'LEVBDYLE'                                                CLE141A
     C                   PARM      *BLANKS       RetCode           7                         CLE141A
     C                   PARM                    LoanBDC                                     CLE141A
     C                   PARM                    ZDAYNO                                      CLE141A
     C                   IF        RetCode <> *Blanks                                        CLE141A
     C                   EVAL      DDVDATOK = 'N'                                            CLE141A
     C                   EVAL      WId = WId + 1                                             CLE141A
     C**********         EVAL      WMsgIDXar(WId) = '5048508'                       CLE141A MD039016
     C                   EVAL      WMsgIDXar(WId) = '5048562'                               MD039016
     C                   EVAL      WFldNmXAr(WId) = 'DDVDAT'                                 CLE141A
     C                   ENDIF                                                               CLE141A
     C                   ENDIF                                                               CLE141A
     C                   ENDIF                                                               CLE141A
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
     C                   MOVEL     *BLANK        WFldNmXAr
     C                   MOVEL     *BLANK        WMsgIDXAr
     C                   MOVEL     *BLANK        WMsgDtXAr
                                                                                             BUG5863
      ** Reset Index of Warning errors.                                                      BUG5863
                                                                                             BUG5863
     C                   EVAL      WId = *ZERO                                               BUG5863
      *
      ***  Reset warning flags
      *
     C     SaveRPLNRF    IFNE      RPLNRF
     C     SaveRPVDAT    ORNE      RPVDAT
     C     SaveRPLASN    ORNE      RPLASN
     C**********         MOVE      *BLANK        WEVDAT            1                         BUG4351
     C                   ENDIF
      *
      /COPY WNCPYSRC,LERPSCV209
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  UPDATERRS - Update error information with that received back *
      *              from each validation module.                     *
      *****************************************************************
     C     UPDATERRS     BEGSR
      *
      ***  Update warning fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I                 2 0
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
     C*****I****         SUB       1             WId                                         BUG4351
     C     I             SUB       1             WIdx                                        BUG4351
      *
      /COPY WNCPYSRC,LERPSCV210
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
      ***  Valid Repayment layout (DS) from/to caller
     C                   PARM                    ValidRpSc
      *
      ***  Payment instructions
     C                   PARM                    ##PAYF
      *
      ***  Receive instructions
     C                   PARM                    ##RECF
      *
      ***  Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
      *
      ***  Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      ***  Array index (3P0) from/to caller
     C************       PARM                    WId                                         BUG4351
     C                   PARM                    WIdx                                        BUG4351
      *
      ***  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'LERPSC2VL'   DBPGM
     C                   OUT       LDA
      *
      ***  Define working fields
      *
      *
      ***  Access Bank details via access program
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
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
      ***  Check Feature is installed
      *
     C                   MOVE      'N'           CLE005            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005'      @SARD
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE005
     C                   END
      *
     C                   MOVE      'N'           CEU004            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU004'      @SARD
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CEU004
     C                   END
      *                                                                                       CLE031
      ** Determine if Settlement Currency is installed                                        CLE031
      *                                                                                       CLE031
     C                   MOVE      'N'           CLE031            1                          CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       @RTCD                                        CLE031
     C                   PARM      '*VERIFY'     @OPTN                                        CLE031
     C                   PARM      'CLE031'      @SARD                                        CLE031
                                                                                              CLE031
     C     @RTCD         IFEQ      *BLANKS                                                    CLE031
     C                   MOVE      'Y'           CLE031                                       CLE031
     C                   ENDIF                                                                CLE031
                                                                                              CLE141
      ** Determine if CLE141 is installed                                                     CLE141
                                                                                              CLE141
     C                   MOVE      'N'           CLE141            1                          CLE141
     C                   CALLB     'AOSARDR0'                                                 CLE141
     C                   PARM      *BLANKS       @RTCD                                        CLE141
     C                   PARM      '*VERIFY'     @OPTN                                        CLE141
     C                   PARM      'CLE141'      @SARD                                        CLE141
                                                                                              CLE141
     C     @RTCD         IFEQ      *BLANKS                                                    CLE141
     C                   MOVE      'Y'           CLE141                                       CLE141
     C                   ENDIF                                                                CLE141
      *
      ***  Determine whether program is running interactively or in batch
      ***   ( 0 = batch   1 = interactive)
      *
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    @RTCD
     C                   PARM                    PMODE             1
      *
      ***  set the message file
      *
     C                   EVAL      #MsgFile = 'LERMSGF'
      *
      ***  Key list for CLOAN
      *
     C     K@LOAN        KLIST
     C**********         KFLD                    K@LNRF            6 0                       CLE148
     C                   KFLD                    K@LNRF            6                         CLE148
     C                   KFLD                    K@RCDT            1
      *
      ***  Program, module and procedure names for database error processing.
      ***  =================================================================
      ***  The following /COPY sets these values, and also defines LDA as
      ***  an external data area
      *
      /COPY WNCPYSRC,LERPSCV211
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
**  CPY@
(c) Finastra International Limited 2002
