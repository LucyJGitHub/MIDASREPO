     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX Val deal date, value date, option date')      *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FXVDATES - Validate Deal Date, Value Date, Option To Date    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD055571           Date 21May20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CDL099             Date 06Oct17               *
      *                 MD008008           Date 24Apr14               *
      *                 MD000091           Date 07May13               *
      *                 207288             Date 10Jun03               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 254420             Date 20May08               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG17088           Date 19Mar08               *
      *                 248269             Date 25Jun07               *
      *                 BUG13284           Date 09Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 235667             Date 26Aug05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209009             Date 02Sep02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 141077             Date 21Aug98               *
      *                 CAP002  *CREATE    Date 08Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055571 - Check new System Value when Validating OptnToDTE  *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date                                    *
      *  MD008008 - Deal Date validation does not take into account   *
      *            local holidays. (Applied for MD026390)             *
      *  MD000091 - Event Codes Substitution                          *
      *  207288 - Check spot indicator for deal type/subtype          *
      *           combination and issue warning message when needed.  *
      *           Applied for AR999664 (Child: AR999668)              *
      *  254420 - Validate value date against the back value period   *
      *           defined in PF/SDBANKPD.                             *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG17088 - Error message line appeared twice in FXDL input.  *
      *  248269 - Use original spot rate in validating the exchange   *
      *           rate of an Option takedown deal.                    *
      *  BUG13284 - Error Msg appears when authorising trades         *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  235667 - System not accepting deal insertion when option to  *
      *           date is a holiday in local currency.  Show warning  *
      *           message instead of error when option to date is a   *
      *           local currency holiday.                             *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  209009 - STDDECLARE should be in ZACPYSRC and not in         *
      *           FXCPYSRC.                                           *
      *  141077 - Holiday validation of value date & option to date   *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
     FFDDTSTYT  IF   E           K DISK    INFSR(*PSSR)                                       207288
 
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
 
      ** Include the FX standard declares
     D*/COPY*FXCPYSRC,STDDECLARE***                                                           209009
     D/COPY ZACPYSRC,STDDECLARE                                                               209009
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  207288
      ** External DS for Midas modules details                                                207288
     D SDTOF         E DS                  EXTNAME(SDTOFPD)                                   207288
      ** External data structure for TOF ICD file.                                            207288
 
      ** External data structure for branch codes file                                      MD008008
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                                MD008008
      *                                                                                     MD008008
      ** Second DS for access programs, long data structure                                 MD008008
     D DSSDY         E DS                  EXTNAME(DSSDY)                                   MD008008
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
                                                                                141077
      ** Array of Fields with warnings.                                         141077
     D WFldNmXAr       S             10A   DIM(XArrayMax)                       141077
                                                                                141077
      ** Array of warning message IDs                                           141077
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)          141077
                                                                                141077
      ** Array of warning message data.                                         141077
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)        141077
 
 
     D*RelDealDts      DS           100                                                       248269
     D RelDealDts      DS           113                                                       248269
      ** Related Deal Details (when deal is option takedown or swap.
      ** Thus related deal will be other leg of swap or option).
     D  RelDDYY               56     59  0                                      deal date - year
     D  RelDDMM               60     61  0                                      deal date - mnth
     D  RelDDDD               62     63  0                                      deal date - day
     D  RelVDYY               64     67  0                                      val date - year
     D  RelVDMM               68     69  0                                      val date - mnth
     D  RelVDDD               70     71  0                                      val date - day
     D  RelDOEY               72     75  0                                      opt date - year
     D  RelDOEM               76     77  0                                      opt date - mnth
     D  RelDOED               78     79  0                                      opt date - day
 
 
     D                 DS
      **  Data structure for date in, to change format.
     D  DateIn                 1      8  0
     D  @@YY                   1      4  0
     D  @@MM                   5      6  0
     D  @@DD                   7      8  0
 
                                                                                141077
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)                    141077
      ** EXTERNAL DS FOR NOSTRO DETAILS                                         141077
     D DSFDY         E DS                  EXTNAME(DSFDY)                       141077
      ** EXTERNAL DS FOR SHORT DUMMY DATA STRUCTURE                             141077
     D SDBANK        E DS                  EXTNAME(SDBANKPD) PREFIX(XX:2)                     254420
      ** EXTERNAL DS FOR BANK DETAILS                                                         254420
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CDL099
      ** External DS Fof SAR Details
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
      ** Index for arrays of warning message ids etc                            141077
     D WIx             S              3P 0                                      141077
 
 
     D ZNRDYS          S              2S 0
 
 
     D RecSetCcy       S              3A
     D RecSetMeth      S              2S 0
     D***RecNostro       S             12A                                                    CGL029
     D RecNostro       S             18A                                                      CGL029
     D PaySetCcy       S              3A
     D PaySetMeth      S              2S 0
     D***PayNostro       S             12A                                                    CGL029
     D PayNostro       S             18A                                                      CGL029
     D @DAT            S              6P 0                                                    254420
     D @RTCDE          S              1A                                                      254420
     D BVDYNO          S                   LIKE(BJRDNB)                                       254420
     D @VDYNO          S              5P 0                                                    254420
 
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091

     D PSYSVAL1        C                   CONST('AlwOptDteEqValDte')                       MD055571
     D PRETURN         S              7A                                                    MD055571
     D POP01           S             20A                                                    MD055571
     D PVL01           S            200A                                                    MD055571
     D POP02           S             20A                                                    MD055571
     D PVL02           S            200A                                                    MD055571
     D POP03           S             20A                                                    MD055571
     D PVL03           S            200A                                                    MD055571
     D POP04           S             20A                                                    MD055571
     D PVL04           S            200A                                                    MD055571
     D POP05           S             20A                                                    MD055571
     D PVL05           S            200A                                                    MD055571
     D POP06           S             20A                                                    MD055571
     D PVL06           S            200A                                                    MD055571
     D POP07           S             20A                                                    MD055571
     D PVL07           S            200A                                                    MD055571
     D POP08           S             20A                                                    MD055571
     D PVL08           S            200A                                                    MD055571
     D POP09           S             20A                                                    MD055571
     D PVL09           S            200A                                                    MD055571
     D POP10           S             20A                                                    MD055571
     D PVL10           S            200A                                                    MD055571
     D AODEVD          S              1A                                                    MD055571
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialization
 
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   MOVE      *BLANK        WFldNmXAr                      141077
     C                   MOVE      *BLANK        WMsgIDXAr                      141077
     C                   MOVE      *BLANK        WMsgDtXAr                      141077
     C                   Z-ADD     0             WIx                            141077
 
      *                                                                                     MD008008
      ** Get the Booking Branch Location Code                                               MD008008
      *                                                                                     MD008008
     C     DDBrsnOK      IFEQ      'Y'                                                      MD008008
     C                   CALL      'AOBRCHR1'                                               MD008008
     C                   PARM      *BLANKS       @RTCD                                      MD008008
     C                   PARM      '*KEY   '     @OPTN                                      MD008008
     C                   PARM      DDBRSN        @DSNB             3                        MD008008
     C     SDBRCH        PARM      SDBRCH        DSSDY                                      MD008008
      *                                                                                     MD008008
     C     @RTCD         IFEQ      *BLANKS                                                  MD008008
     C                   MOVEL     A8LCCD        BkBrnLoc                                   MD008008
     C                   ENDIF                                                              MD008008
     C                   ENDIF                                                              MD008008
      *                                                                         141077
      * GETNOSDTS - GET NOSTRO DETAILS                                          141077
      *                                                                         141077
     C                   EXSR      GETNOSDTS                                    141077
      *                                                                                       207288
      ** Access Midas module details.                                                         207288
      *                                                                                       207288
     C                   CALL      'AOMMODR0'                                                 207288
     C                   PARM      *BLANKS       @RTCD                                        207288
     C                   PARM      '*FIRST '     @OPTN                                        207288
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        207288
      *                                                                                       207288
      ** Database error.                                                                      207288
      *                                                                                       207288
     C     @RTCD         IFNE      *BLANK                                                     207288
     C                   MOVEL     @OPTN         DBKEY                                        207288
     C                   MOVEL     'SDMMODPD'    DBFILE                                       207288
     C                   MOVEL     '902'         DBASE                                        207288
     C                   EXSR      *PSSR                                                      207288
     C                   ENDIF                                                                207288
      *                                                                                       207288
      ** Retrieve spot period, spot indicator.                                                207288
      *                                                                                       207288
      *                                                                                       207288
     C     DDDltpOK      IFNE      'N'                                                        207288
     C     DDDlstOK      ANDNE     'N'                                                        207288
     C     BGN4ST        ANDEQ     'Y'                                                        207288
     C                   EXSR      GETSPOT                                                    207288
     C                   ENDIF                                                                207288
      *
      * DLDTV - DEAL DATE VALIDATION
      *
     C                   EXSR      DLDTV
      *
      * VDATV - VALUE DATE VALIDATION
      *
     C                   EXSR      VDATV
      *
      * ODATV - OPTION TO DATE VALIDATION
      *
     C                   EXSR      ODATV
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDDldtOK      IFEQ      'N'
     C     DDVdatOK      OREQ      'N'
     C     DDOdatOK      OREQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * DLDTV - DEAL DATE VALIDATION
      *****************************************************************
     C     DLDTV         BEGSR
      *
      * If Deal date is blank, default it to run date
      *
     C     DDDLDT        IFEQ      *BLANKS
     C                   CALLB     'ZDATE2'
     C                   PARM      BJRDNB        ZDAYNO            5 0          Value date
     C                   PARM                    BJDFIN                         Date format ind
     C                   PARM      *ZEROS        ZDATE             6 0          Value date
     C                   PARM      *BLANK        ZADATE            7            Run-date in DDM
     C                   MOVE      ZDATE         DDDLDT
     C                   END
      *
      * Test if deal date is numeric
      * If it is, convert it to a day number
      *
     C                   TESTN                   DDDLDT               9798
     C     *IN97         IFEQ      '1'
     C     *IN98         OREQ      '1'
     C                   CALLB     'ZAVDATE'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM      DDDLDT        @@DATE            6
     C                   PARM                    BJDFIN
     C                   PARM                    DealDtDN          5 0
     C                   END
      *
      * Deal date is invalid
      * or is not numeric
      *
     C     RetCodeOut    IFEQ      'Error'
     C     *IN97         OREQ      '0'
     C     *IN98         ANDEQ     '0'
     C                   MOVE      'N'           DDDldtOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDDLDT'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0124'     MsgIdXAr(Idx)
     C                   END
      *
      * If Deal date is valid so far
      *
     C     DDDldtOK      IFEQ      'Y'
      *
      * Deal date can't be in the future
      *
     C     DealDtDN      IFGT      BJRDNB
     C                   MOVE      'N'           DDDldtOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDDLDT'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0249'     MsgIdXAr(Idx)
     C                   END
      *
      * Test if value date is numeric
      * If it is, convert it to a day number
      *
     C                   TESTN                   DDVDAT               9798
     C     *IN97         IFEQ      '1'
     C     *IN98         OREQ      '1'
     C                   CALLB     'ZAVDATE'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM      DDVDAT        @@DATE            6
     C                   PARM                    BJDFIN
     C                   PARM                    ValuDtDN          5 0
     C                   END
      *
      * Deal date can't be greater than value date
      *
     C     RetCodeOut    IFNE      'Error'
     C     *IN98         IFEQ      '1'
     C     *IN97         OREQ      '1'
      *
     C     DealDtDN      IFGT      ValuDtDN
     C                   MOVE      'N'           DDDldtOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDDLDT'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0250'     MsgIdXAr(Idx)
     C                   END
      *
     C                   END                                                    *IN98  IFEQ 1
     C                   END                                                    RTCDO  IFNE E
     C                   END                                                    DLDT   IFEQ 0
      *
      * If deal is a swap, deal dates of two deals must match
      *
     C     DDSdnoOk      IFEQ      'Y'                                                      BUG13284
     C     DDDldtOK      IFEQ      'Y'
     C     DDDLTP        ANDEQ     'SW'
     C     DDDldtOK      OREQ      'Y'
     C     DDBRKR        ANDEQ     'SWAP'
      *
     C                   Z-ADD     RelDDYY       @@YY
     C                   Z-ADD     RelDDMM       @@MM
     C                   Z-ADD     RelDDDD       @@DD
      *
     C                   CALLB     'ZDATE10'
     C                   PARM                    DateIn
     C                   PARM      *ZERO         @@MDNO            5 0
      *
     C     @@MDNO        IFNE      DealDtDN
     C                   MOVE      'N'           DDDldtOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDDLDT'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0192'     MsgIdXAr(Idx)
     C                   END
     C                   END
     C                   END                                                                BUG13284
      *
      ** If deal date is valid, system is single-branching
      ** only if not settled through a nostro
      ** check that deal date is not a holiday in local currency
      *
     C     DDDldtOK      IFEQ      'Y'
     C     BJSBRC        ANDNE     *BLANK
     C     RecSetMeth    ANDNE     01
     C     RecSetMeth    ANDNE     07
     C     RecSetMeth    ANDNE     08
     C     PaySetMeth    ANDNE     01
     C     PaySetMeth    ANDNE     07
     C     PaySetMeth    ANDNE     08
      *
     C                   CALLB     'ZCHKH'
     C                   PARM      DealDtDN      ZDAYNO            5 0
     C                   PARM      BJLCCY        ZCCY              3
     C                   PARM      BJSLCD        ZLOC              3
     C                   PARM      *BLANK        ZIND              1
      *
     C     ZIND          IFEQ      'H'
     C**********         MOVE      'N'           DDDldtOK                                   MD008008
     C**********         ADD       1             Idx                                        MD008008
     C**********         MOVEL     'DDDLDT'      FldNamXAr(Idx)                             MD008008
     C**********         MOVEL     'FXM0251'     MsgIdXAr(Idx)                              MD008008
     C                   MOVE      'W'           DDDldtOK                                   MD008008
     C                   ADD       1             WIx                                        MD008008
     C                   MOVEL     'DDDLDT'      WFldNmXAr(WIx)                             MD008008
     C                   MOVEL     '5046270'     WMsgIdXAr(WIx)                             MD008008
     C                   END
     C                   END
      *
      ** If deal date is valid, system is multi-branching
      ** and if booking branch is valid,
      ** Check that deal date is not a holiday in branch location
      *
     C     DDDldtOK      IFEQ      'Y'
     C     BJSBRC        ANDEQ     *BLANK
     C     DDBrsnOK      ANDEQ     'Y'
     C                   CALLB     'ZCHKH'
     C                   PARM      DealDtDN      ZDAYNO            5 0
     C                   PARM      BJLCCY        ZCCY              3
     C                   PARM      BkBrnLoc      ZLOC              3
     C                   PARM      *BLANK        ZIND              1
     C     ZIND          IFEQ      'H'
     C**********         MOVE      'N'           DDDldtOK                                   MD008008
     C**********         ADD       1             Idx                                        MD008008
     C**********         MOVEL     'DDDLDT'      FldNamXAr(Idx)                             MD008008
     C**********         MOVEL     'FXM0251'     MsgIdXAr(Idx)                              MD008008
     C                   MOVE      'W'           DDDldtOK                                   MD008008
     C                   ADD       1             WIx                                        MD008008
     C                   MOVEL     'DDDLDT'      WFldNmXAr(WIx)                             MD008008
     C                   MOVEL     '5046270'     WMsgIdXAr(WIx)                             MD008008
     C                   END
     C                   END
      *
      * If valid, output deal date day number
      *
     C*****DDDldtOK      IFEQ      'Y'                                                      MD008008
     C     DDDldtOK      IFNE      'N'                                                      MD008008
     C                   Z-ADD     DealDtDN      F3DDDN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * VDATV - VALUE DATE VALIDATION
      *****************************************************************
     C     VDATV         BEGSR
      *****************************************************************                       207288
      ***If*value*date*is*not*defined,*default*it*to*run*date*+*2*days                        207288
      *****************************************************************                       207288
      *                                                                                       207288
      ** If value date is not defined, default it to:                                         207288
      ** spot deal - run date + spot period from ICD                                          207288
      ** forward deal - run date + spot period from ICD + 1 day                               207288
      *                                                                                       207288
     C     DDVDAT        IFEQ      *BLANKS
      *
     C                   Z-ADD     2             ZNRDYS                                       207288
     C     DDDltpOK      IFNE      'N'                                                        207288
     C     DDDlstOK      ANDNE     'N'                                                        207288
     C     BGN4ST        ANDEQ     'Y'                                                        207288
     C     WSPOT         IFEQ      'Y'                                                        207288
     C                   Z-ADD     TQSPOT        ZNRDYS                                       207288
     C                   ELSE                                                                 207288
     C     TQSPOT        ADD       1             ZNRDYS                                       207288
     C                   ENDIF                                                                207288
     C                   ENDIF                                                                207288
     C                   CALLB     'ZF2C'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM      BJRDNB        ZDAYNO            5 0
     C                   PARM      BJLCCY        ZCCY1             3
     C                   PARM      BJSLCD        ZLOC1             3
     C                   PARM      BJHOCY        ZCCY2             3
     C                   PARM      *BLANKS       ZLOC2             3
     C**********         PARM      2             ZNRDYS                                       207288
     C                   PARM                    ZNRDYS                                       207288
     C                   PARM      *ZERO         ZDYNBR            5 0
      *
     C                   CALLB     'ZDATE2'
     C                   PARM      ZDYNBR        ZDAYNO            5 0          Value date
     C                   PARM                    BJDFIN                         Date format ind
     C                   PARM      *ZEROS        ZDATE             6 0          Value date
     C                   PARM      *BLANK        ZADATE            7            Run-date in DDM
     C                   MOVE      ZDATE         DDVDAT
     C                   END
      *
      *  If value date is numeric, convert it to a day number
      *
     C                   TESTN                   DDVDAT               9798
     C     *IN97         IFEQ      '1'
     C     *IN98         OREQ      '1'
     C                   CALLB     'ZAVDATE'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM      DDVDAT        @@DATE            6
     C                   PARM                    BJDFIN
     C                   PARM                    ValuDtDN          5 0
     C                   END
      *
      *  Error if value date is not numeric or is an invalid date
      *
     C     *IN97         IFEQ      '0'
     C     *IN98         ANDEQ     '0'
     C     RetCodeOut    OREQ      'Error'
     C                   MOVE      'N'           DDVdatOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDVDAT'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0125'     MsgIdXAr(Idx)
     C                   MOVE      *BLANKS       MsgDtaXAr(Idx)
     C     BJDFIN        IFEQ      'D'
     C**********         MOVEL     'DDMMYY'      MsgDtaXAr(Idx)                             MD000091
     C                   MOVEL     'DDMMYY'      MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(MsgDtaTmp)                MD000091
     C                   ELSE
     C**********         MOVEL     'MMDDYY'      MsgDtaXAr(Idx)                             MD000091
     C                   MOVEL     'MMDDYY'      MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(MsgDtaTmp)                MD000091
     C                   END
      *                                                                                       254420
      ** If value date is valid, carry out for further validation                             254420
      *                                                                                       254420
     C                   ELSE                                                                 254420
      *                                                                                       254420
      ** Get the day number format of the value date into @@VDYNO                             254420
      *                                                                                       254420
     C                   MOVE      DDVDAT        @DAT                                         254420
     C                   CALLB     'ZA0270'                                                   254420
     C                   PARM                    @DAT                                         254420
     C                   PARM                    BJDFIN                                       254420
     C                   PARM                    @RTCDE                                       254420
     C                   PARM                    @VDYNO                                       254420
      *                                                                                       254420
      ** Access Bank details via access program                                               254420
      *                                                                                       254420
     C                   CALLB     'AOBANKR0'                                                 254420
     C                   PARM      '*DBERR '     @RTCD             7                          254420
     C                   PARM      '*FIRST '     @OPTN             7                          254420
     C     SDBANK        PARM      SDBANK        DSFDY                                        254420
      *                                                                                       254420
      ** Check if value date is within back-value period                                      254420
      *                                                                                       254420
     C                   EVAL      BVDYNO = BJRDNB - XXBVPD                                   254420
     C                   IF        @VDYNO  < BVDYNO                                           254420
     C                             AND DDACTN = 'I'                                           254420
     C                   MOVE      'N'           DDVdatOK                                     254420
     C                   ADD       1             Idx                                          254420
     C                   MOVEL     'DDVDAT'      FldNamXAr(Idx)                               254420
     C                   MOVEL     'MMM2625'     MsgIdXAr(Idx)                                254420
     C                   MOVE      *BLANKS       MsgDtaXAr(Idx)                               254420
     C                   ENDIF                                                                254420
      *                                                                                       254420
     C                   END
      *
      *  If value date is OK and SW/OP deal number is defined and valid
      *
     C     DDVdatOK      IFEQ      'Y'
     C     DDSDNO        ANDNE     *BLANKS
     C     DDSdnoOK      ANDEQ     'Y'
      *
      *  If deal type is option takedown
      *
     C     DDDLTP        IFEQ      'OT'
      *
      * Convert value date of option from YYYYMMDD to day number
      *
      *
     C                   Z-ADD     RelVDYY       @@YY
     C                   Z-ADD     RelVDMM       @@MM
     C                   Z-ADD     RelVDDD       @@DD
      *
     C                   CALLB     'ZDATE10'
     C                   PARM                    DateIn
     C                   PARM      *ZERO         @@MDNO            5 0
      *
      * Value date can't be less than the value date of the option
      *
     C     ValuDtDN      IFLT      @@MDNO
     C                   MOVE      'N'           DDVdatOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDVDAT'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0126'     MsgIdXAr(Idx)
     C                   END
      *
      * Convert option to date of option from YYYYMMDD to day number
      *
     C                   Z-ADD     RelDOEY       @@YY
     C                   Z-ADD     RelDOEM       @@MM
     C                   Z-ADD     RelDOED       @@DD
      *
     C                   CALLB     'ZDATE10'
     C                   PARM                    DateIn
     C                   PARM      *ZERO         @@MDNO            5 0
      *
      * Value date can't be greater than the option to date of the option
      *
     C     ValuDtDN      IFGT      @@MDNO
     C                   MOVE      'N'           DDVdatOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDVDAT'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0127'     MsgIdXAr(Idx)
     C                   END
     C                   END                                                    DDDLTP IFEQ OT
      *
      *  If deal type is swap and this is an insertion
      *
     C     DDDLTP        IFEQ      'SW'
     C     DDACTN        ANDEQ     'I'
     C     DDBRKR        OREQ      'SWAP'
     C     DDACTN        ANDEQ     'I'
      *
      * Convert value date of other leg from YYYYMMDD to day number
      *
     C                   Z-ADD     RelVDYY       @@YY
     C                   Z-ADD     RelVDMM       @@MM
     C                   Z-ADD     RelVDDD       @@DD
      *
     C                   CALLB     'ZDATE10'
     C                   PARM                    DateIn
     C                   PARM      *ZERO         @@MDNO            5 0
      *
      * Value date can't be equal to value date of other leg
      *
     C     ValuDtDN      IFEQ      @@MDNO
     C                   MOVE      'N'           DDVdatOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDVDAT'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0128'     MsgIdXAr(Idx)
     C                   END
     C                   END                                                    DDDLTP IFEQ SW
      *
     C                   END                                                    VDAT   IFEQ 'Y'
      *                                                                         141077
      * If valid, do holiday validation                                         141077
      *                                                                         141077
     C     DDVdatOK      IFNE      'N'                                          141077
     C                   EXSR      VDATV_HOL                                    141077
     C                   END                                                    141077
      *
      * If valid, output value date day number
      *
     C*****DDVdatOK      IFEQ      'Y'                                          141077
     C     DDVdatOK      IFNE      'N'                                          141077
     C                   Z-ADD     ValuDtDN      F3VDDN
     C                   END
      *                                                                                       207288
      ** Check spot indicator.                                                                207288
      *                                                                                       207288
     C     DDVdatOK      IFNE      'N'                                                        207288
     C     DDDldtOK      ANDNE     'N'                                                        207288
     C     DDDltpOK      ANDNE     'N'                                                        207288
     C     DDDlstOK      ANDNE     'N'                                                        207288
     C     BGN4ST        ANDEQ     'Y'                                                        207288
     C                   EXSR      CHKSPT                                                     207288
     C                   ENDIF                                                                207288
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************         141077
      * VDATV_HOL - VALUE DATE HOLIDAY VALIDATION                               141077
      *****************************************************************         141077
     C     VDATV_HOL     BEGSR                                                  141077
      *                                                                         141077
      ** If purchase currency settled through a nostro                          141077
      ** Check that value date is not a holiday in in purchase currency         141077
      *                                                                         141077
     C     RecSetMeth    IFEQ      01                                           141077
     C     RecSetMeth    OREQ      07                                           141077
     C     RecSetMeth    OREQ      08                                           141077
     C                   CALLB     'ZCHKH'                                      141077
     C                   PARM      ValuDtDN      ZDAYNO                         141077
     C                   PARM      EffBuySetc    ZCCY                           141077
     C                   PARM      RecLoc        ZLOC                           141077
     C                   PARM      *BLANK        ZIND                           141077
     C     ZIND          IFEQ      'H'                                          141077
     C                   MOVE      'W'           ddVDATok                       141077
     C                   ADD       1             WIx                            141077
     C                   MOVEL     'DDVDAT'      WFldNmXAr(WIx)                 141077
     C                   MOVEL     'FXM0417'     WMsgIdXAr(WIx)                 141077
     C                   END                                                    141077
     C                   END                                                    141077
      *                                                                         141077
      ** If sell currency settled through a nostro                              141077
      ** Check that value date is not a holiday in in sell currency             141077
      *                                                                         141077
     C                   IF        CDL099 <> 'Y'                                              CDL099
     C     PaySetMeth    IFEQ      01                                           141077
     C     PaySetMeth    OREQ      07                                           141077
     C     PaySetMeth    OREQ      08                                           141077
     C                   CALLB     'ZCHKH'                                      141077
     C                   PARM      ValuDtDN      ZDAYNO                         141077
     C                   PARM      EffSelSetc    ZCCY                           141077
     C                   PARM      PayLoc        ZLOC                           141077
     C                   PARM      *BLANK        ZIND                           141077
     C     ZIND          IFEQ      'H'                                          141077
     C                   MOVE      'W'           ddVDATok                       141077
     C                   ADD       1             WIx                            141077
     C                   MOVEL     'DDVDAT'      WFldNmXAr(WIx)                 141077
     C                   MOVEL     'FXM0418'     WMsgIdXAr(WIx)                 141077
     C                   END                                                    141077
     C                   END                                                    141077
     C                   ENDIF                                                                CDL099
      *                                                                         141077
      ** If purchase or sell currency not settled through a nostro              141077
      ** Check that value date is not a holiday in local currency               141077
      *                                                                         141077
     C     RecSetMeth    IFNE      01                                           141077
     C     RecSetMeth    ANDNE     07                                           141077
     C     RecSetMeth    ANDNE     08                                           141077
     C     PaySetMeth    ORNE      01                                           141077
     C     PaySetMeth    ANDNE     07                                           141077
     C     PaySetMeth    ANDNE     08                                           141077
     C                   CALLB     'ZCHKH'                                      141077
     C                   PARM      ValuDtDN      ZDAYNO                         141077
     C                   PARM      BJLCCY        ZCCY                           141077
     C                   PARM      BJSLCD        ZLOC                           141077
     C                   PARM      *BLANK        ZIND                           141077
     C     ZIND          IFEQ      'H'                                          141077
     C                   MOVE      'W'           ddVDATok                       141077
     C                   ADD       1             WIx                            141077
     C                   MOVEL     'DDVDAT'      WFldNmXAr(WIx)                 141077
     C                   MOVEL     'FXM0419'     WMsgIdXAr(WIx)                 141077
     C                   END                                                    141077
     C                   END                                                    141077
      *                                                                         141077
     C                   ENDSR                                                  141077
      *****************************************************************         141077
     C/EJECT                                                                    141077
      *****************************************************************
      * ODATV - OPTION TO DATE VALIDATION
      *****************************************************************
     C     ODATV         BEGSR
      *
      * Option to Date can't be blank for options
      *
     C     DDODAT        IFEQ      *BLANKS
     C     DDDLTP        ANDEQ     'OP'
     C                   MOVE      'N'           DDOdatOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDODAT'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0132'     MsgIdXAr(Idx)
     C                   END
      *
      * Option to Date can't be defined if the deal is not an option
      *
     C     DDOdatOK      IFEQ      'Y'                                                      BUG17088
     C     DDODAT        IFNE      *BLANKS
     C     DDDLTP        ANDNE     'OP'
     C                   MOVE      'N'           DDOdatOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDODAT'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0133'     MsgIdXAr(Idx)
     C                   END
     C                   ENDIF                                                              BUG17088
      *
      * If option to date is OK and defined
      * Check that it is a valid date
      *
     C     DDOdatOK      IFEQ      'Y'
     C     DDODAT        ANDNE     *BLANKS
     C                   TESTN                   DDODAT               9798
     C     *IN97         IFEQ      '1'
     C     *IN98         OREQ      '1'
     C                   CALLB     'ZAVDATE'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM      DDODAT        @@DATE            6
     C                   PARM                    BJDFIN
     C                   PARM                    OptoDtDN          5 0
     C                   END
     C     *IN97         IFEQ      '0'
     C     *IN98         ANDEQ     '0'
     C     RetCodeOut    OREQ      'Error'
     C                   MOVE      'N'           DDOdatOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDODAT'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0134'     MsgIdXAr(Idx)
     C                   MOVE      *BLANKS       MsgDtaXAr(Idx)
     C     BJDFIN        IFEQ      'D'
     C**********         MOVEL     'DDMMYY'      MsgDtaXAr(Idx)                             MD000091
     C                   MOVEL     'DDMMYY'      MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(MsgDtaTmp)                MD000091
     C                   ELSE
     C**********         MOVEL     'MMDDYY'      MsgDtaXAr(Idx)                             MD000091
     C                   MOVEL     'MMDDYY'      MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(MsgDtaTmp)                MD000091
     C                   END
     C                   ELSE
      *
      * Option to date can't be less than or equal to the value date
      *
     C*****OptoDtDN***** IFLE      ValuDtDN                                                 MD055571
     C     OptoDtDN      IFLT      ValuDtDN                                                 MD055571
     C     OptoDtDN      OREQ      ValuDtDN                                                 MD055571
     C     AODEVD        ANDEQ     'N'                                                      MD055571
     C                   MOVE      'N'           DDOdatOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDODAT'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0135'     MsgIdXAr(Idx)
     C                   END
     C                   END
     C                   END
      *                                                                         141077
      * If valid, and deal is an option, do holiday validation                  141077
      *                                                                         141077
     C     DDOdatOK      IFNE      'N'                                          141077
     C     DDDLTP        ANDEQ     'OP'                                         141077
     C                   EXSR      ODATV_HOL                                    141077
     C                   END                                                    141077
      *
      * If valid, and defined, output option to date day number
      *
     C*****DDOdatOK      IFEQ      'Y'                                          141077
     C     DDOdatOK      IFNE      'N'                                          141077
     C     DDODAT        ANDNE     *BLANKS
     C                   Z-ADD     OptoDtDN      F3OTDN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT                                                                    141077
      *****************************************************************         141077
      * ODATV_HOL - OPTION TO DATE HOLIDAY VALIDATION                           141077
      *****************************************************************         141077
     C     ODATV_HOL     BEGSR                                                  141077
      *                                                                         141077
      ** If purchase currency settled through a nostro                          141077
      ** Check that option to date is not a holiday in in purchase currency     141077
      *                                                                         141077
     C     RecSetMeth    IFEQ      01                                           141077
     C     RecSetMeth    OREQ      07                                           141077
     C     RecSetMeth    OREQ      08                                           141077
     C                   CALLB     'ZCHKH'                                      141077
     C                   PARM      OptoDtDN      ZDAYNO                         141077
     C                   PARM      EffBuySetc    ZCCY                           141077
     C                   PARM      RecLoc        ZLOC                           141077
     C                   PARM      *BLANK        ZIND                           141077
     C     ZIND          IFEQ      'H'                                          141077
     C                   MOVE      'N'           ddODATok                       141077
     C                   ADD       1             Idx                            141077
     C                   MOVEL     'DDODAT'      FldNamXAr(Idx)                 141077
     C                   MOVEL     'FXM0136'     MsgIdXAr(Idx)                  141077
     C                   END                                                    141077
     C                   END                                                    141077
      *                                                                         141077
      ** If sell currency settled through a nostro                              141077
      ** Check that value date is not a holiday in in sell currency             141077
      *                                                                         141077
     C     PaySetMeth    IFEQ      01                                           141077
     C     PaySetMeth    OREQ      07                                           141077
     C     PaySetMeth    OREQ      08                                           141077
     C                   CALLB     'ZCHKH'                                      141077
     C                   PARM      OptoDtDN      ZDAYNO                         141077
     C                   PARM      EffSelSetc    ZCCY                           141077
     C                   PARM      PayLoc        ZLOC                           141077
     C                   PARM      *BLANK        ZIND                           141077
     C     ZIND          IFEQ      'H'                                          141077
     C                   MOVE      'N'           ddODATok                       141077
     C                   ADD       1             Idx                            141077
     C                   MOVEL     'DDODAT'      FldNamXAr(Idx)                 141077
     C                   MOVEL     'FXM0137'     MsgIdXAr(Idx)                  141077
     C                   END                                                    141077
     C                   END                                                    141077
      *                                                                         141077
      ** If purchase or sell currency not settled through a nostro              141077
      ** Check that option to date is not a holiday in local currency           141077
      *                                                                         141077
     C     RecSetMeth    IFNE      01                                           141077
     C     RecSetMeth    ANDNE     07                                           141077
     C     RecSetMeth    ANDNE     08                                           141077
     C     PaySetMeth    ORNE      01                                           141077
     C     PaySetMeth    ANDNE     07                                           141077
     C     PaySetMeth    ANDNE     08                                           141077
     C                   CALLB     'ZCHKH'                                      141077
     C                   PARM      OptoDtDN      ZDAYNO                         141077
     C                   PARM      BJLCCY        ZCCY                           141077
     C                   PARM      BJSLCD        ZLOC                           141077
     C                   PARM      *BLANK        ZIND                           141077
      *                                                                                       235667
      ** If settlement is not via nostro, show warning message and                            235667
      ** not error message if Option To Date is a local currency                              235667
      ** holiday.                                                                             235667
      *                                                                                       235667
     C     ZIND          IFEQ      'H'                                          141077
     C**********         MOVE      'N'           ddODATok                              141077 235667
     C**********         ADD       1             Idx                                   141077 235667
     C**********         MOVEL     'DDODAT'      FldNamXAr(Idx)                        141077 235667
     C**********         MOVEL     'FXM0138'     MsgIdXAr(Idx)                         141077 235667
     C                   MOVE      'W'           ddODATok                                     235667
     C                   ADD       1             WIx                                          235667
     C                   MOVEL     'DDODAT'      WFldNmXAr(WIx)                               235667
     C                   MOVEL     'FXM0252'     WMsgIdXAr(WIx)                               235667
     C                   END                                                    141077
     C                   END                                                    141077
      *                                                                         141077
     C                   ENDSR                                                  141077
      *****************************************************************         141077
     C/EJECT                                                                    141077
      *****************************************************************         141077
      * GETNOSDTS - GET NOSTRO DETAILS                                          141077
      *****************************************************************         141077
     C     GETNOSDTS     BEGSR                                                  141077
      *                                                                         141077
      ** Determine effective buy settlement currency.                           141077
      *                                                                         141077
     C     RecSetCcy     IFNE      *BLANKS                                      141077
     C                   MOVE      RecSetCcy     EffBuySetc        3            141077
     C                   ELSE                                                   141077
     C                   MOVE      DDBCCY        EffBuySetc                     141077
     C                   ENDIF                                                  141077
      *                                                                         141077
      ** Access nostros file for buy currency nostro location                   141077
      ** - last 3 characters of customer shortname                              141077
      *                                                                         141077
     C     RecSetMeth    IFEQ      01                                           141077
     C     RecSetMeth    OREQ      07                                           141077
     C     RecSetMeth    OREQ      08                                           141077
     C                   MOVEL     RecNostro     @NONB                          141077
     C                   CALL      'AONOSTR0'                                   141077
     C                   PARM      *BLANKS       @RTCD             7            141077
     C                   PARM      '*KEY   '     @OPTN             7            141077
     C                   PARM      *BLANKS       @CSTN             6            141077
     C                   PARM      EffBuySetc    @CYCD             3            141077
     C**********         PARM      *BLANKS       @ACCD             4                   141077 CGL029
     C                   PARM      *BLANKS       @ACCD            10                          CGL029
     C                   PARM      *BLANKS       @ACSN             2            141077
     C                   PARM                    @NONB             2            141077
     C                   PARM      *BLANKS       @BRCD             3            141077
     C                   PARM      *BLANKS       @CSSN            10            141077
     C                   PARM      *BLANKS       @PNOI             1            141077
     C     SDNOST        PARM      SDNOST        DSFDY                          141077
     C                   MOVE      A7NOSN        RecLoc            3            141077
     C                   END                                                    141077
      *                                                                         141077
      ** Determine effective sell settlement currency.                          141077
      *                                                                         141077
     C     PaySetCcy     IFNE      *BLANKS                                      141077
     C                   MOVE      PaySetCcy     EffSelSetc        3            141077
     C                   ELSE                                                   141077
     C                   MOVE      DDSCCY        EffSelSetc                     141077
     C                   ENDIF                                                  141077
      *                                                                         141077
      ** Access nostros file for sell currency nostro location                  141077
      ** - last 3 characters of customer shortname                              141077
      *                                                                         141077
     C     PaySetMeth    IFEQ      01                                           141077
     C     PaySetMeth    OREQ      07                                           141077
     C     PaySetMeth    OREQ      08                                           141077
     C                   MOVEL     PayNostro     @NONB                          141077
     C                   CALL      'AONOSTR0'                                   141077
     C                   PARM      *BLANKS       @RTCD             7            141077
     C                   PARM      '*KEY   '     @OPTN             7            141077
     C                   PARM      *BLANKS       @CSTN             6            141077
     C                   PARM      EffSelSetc    @CYCD             3            141077
     C**********         PARM      *BLANKS       @ACCD             4                   141077 CGL029
     C                   PARM      *BLANKS       @ACCD                                        CGL029
     C                   PARM      *BLANKS       @ACSN             2            141077
     C                   PARM                    @NONB             2            141077
     C                   PARM      *BLANKS       @BRCD             3            141077
     C                   PARM      *BLANKS       @CSSN            10            141077
     C                   PARM      *BLANKS       @PNOI             1            141077
     C     SDNOST        PARM      SDNOST        DSFDY                          141077
     C                   MOVE      A7NOSN        PayLoc            3            141077
     C                   END                                                    141077
      *                                                                         141077
     C                   ENDSR                                                  141077
      *****************************************************************                       207288
      /EJECT                                                                                  207288
      *****************************************************************                       207288
      * GETSPOT - Retrieve spot period, spot indicator                *                       207288
      *****************************************************************                       207288
     C     GETSPOT       BEGSR                                                                207288
      *                                                                                       207288
     C                   CALL      'AOTOFR0'                                                  207288
     C                   PARM      *BLANKS       @RTCD                                        207288
     C                   PARM      '*FIRST '     @OPTN                                        207288
     C     SDTOF         PARM      SDTOF         DSFDY                                        207288
      *                                                                                       207288
      ** If Private Banking details do not exist, handle Database Error.                      207288
      *                                                                                       207288
     C     @RTCD         IFNE      *BLANK                                                     207288
     C                   MOVEL     @OPTN         DBKEY                                        207288
     C                   MOVEL     'SDTOFPD'     DBFILE                                       207288
     C                   MOVEL     '903'         DBASE                                        207288
     C                   EXSR      *PSSR                                                      207288
     C                   ENDIF                                                                207288
      *                                                                                       207288
      ** Retrieve the deal type/subtype indicator.                                            207288
      *                                                                                       207288
     C                   MOVE      ' '           WSPOT             1                          207288
     C                   MOVEL     DDDLTP        TFDTPE                                       207288
     C                   MOVEL     DDDLST        TFDLST                                       207288
     C     KSECU         KLIST                                                                207288
     C                   KFLD                    TFDTPE                                       207288
     C                   KFLD                    TFDLST                                       207288
     C     KSECU         CHAIN     FDDTSTD0                           90                      207288
     C     *IN90         IFEQ      '0'                                                        207288
     C                   MOVE      TFSPOT        WSPOT                                        207288
     C                   ENDIF                                                                207288
      *                                                                                       207288
     C                   ENDSR                                                                207288
      *****************************************************************                       207288
      /EJECT                                                                                  207288
      *****************************************************************                       207288
      * CHKSPT - Check spot Indicator                                 *                       207288
      *****************************************************************                       207288
     C     CHKSPT        BEGSR                                                                207288
      *                                                                                       207288
      ** Compute for the 'valid' value date given the deal date and                           207288
      ** number of days in the ICD.                                                           207288
      *                                                                                       207288
     C                   Z-ADD     TQSPOT        ZNRDYS                                       207288
     C                   CALLB     'ZF2C'                                                     207288
     C                   PARM      *BLANK        RetCodeOut                                   207288
     C                   PARM      F3DDDN        ZDAYNO            5 0                        207288
     C                   PARM      BJLCCY        ZCCY1             3                          207288
     C                   PARM      BJSLCD        ZLOC1             3                          207288
     C                   PARM      BJHOCY        ZCCY2             3                          207288
     C                   PARM      *BLANKS       ZLOC2             3                          207288
     C                   PARM                    ZNRDYS                                       207288
     C                   PARM      *ZERO         ZDYNBR            5 0                        207288
      *                                                                                       207288
      ** If computed value date is less than the inserted value date                          207288
      ** and spot indicator is 'Y', issue warning message.                                    207288
      *                                                                                       207288
     C     WSPOT         IFEQ      'Y'                                                        207288
     C     F3VDDN        IFGT      ZDYNBR                                                     207288
     C                   MOVE      'W'           ddVDATok                                     207288
     C                   ADD       1             WIx                                          207288
     C                   MOVEL     'DDVDAT'      WFldNmXAr(WIx)                               207288
     C                   MOVEL     'FXM5061'     WMsgIdXAr(WIx)                               207288
     C                   ENDIF                                                                207288
      *                                                                                       207288
      ** If inserted value date is less than or equal to computed                             207288
      ** value date and spot indicator is 'N', issue warning                                  207288
      ** message.                                                                             207288
      *                                                                                       207288
     C                   ELSE                                                                 207288
     C     F3VDDN        IFLE      ZDYNBR                                                     207288
     C                   MOVE      'W'           ddVDATok                                     207288
     C                   ADD       1             WIx                                          207288
     C                   MOVEL     'DDVDAT'      WFldNmXAr(WIx)                               207288
     C                   MOVEL     'FXM5062'     WMsgIdXAr(WIx)                               207288
     C                   ENDIF                                                                207288
     C                   ENDIF                                                                207288
      *                                                                                       207288
     C                   ENDSR                                                                207288
      *****************************************************************         141077
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Deal Screen fields
     C                   PARM                    DDACTN            1            action code
     C                   PARM                    DDDLTP            2            deal type
     C                   PARM                    DDDLST            2                          207288
     C                   PARM                    DDBRSN            3            booking branch
     C                   PARM                    DDDLDT            6            deal date
     C                   PARM                    DDVDAT            6            value date
     C                   PARM                    DDODAT            6            option to date
     C                   PARM                    DDBRKR            4            broker
     C                   PARM                    DDSDNO            6            SW/OP deal no.
     C                   PARM                    DDBCCY            3            141077
     C                   PARM                    DDSCCY            3            141077
      *
      ** Deal settlement instruction fields
     C                   PARM                    RecSetCcy
     C                   PARM                    RecSetMeth                     rec settle meth
     C                   PARM                    RecNostro
     C                   PARM                    PaySetCcy
     C                   PARM                    PaySetMeth                     pay settle meth
     C                   PARM                    PayNostro
      *
      ** Booking branch OK
      ** Swap/Opt Deal no OK
     C                   PARM                    DDBrsnOK          1            booking branch
     C                   PARM                    DDSdnoOK          1            SW/OP deal no.
     C                   PARM                    DDDltpOK          1                          207288
     C                   PARM                    DDDlstOK          1                          207288
      *
      ** Related deal details
     C                   PARM                    RelDealDts                     SW/OP branch
      *
      * Booking branch loc
     C                   PARM                    BkBrnLoc          3            book. branch loc
      *
      * ICD
      *
     C                   PARM                    BJRDNB            5 0
     C                   PARM                    BJDFIN            1
     C                   PARM                    BJSBRC            3
     C                   PARM                    BJLCCY            3
     C                   PARM                    BJSLCD            3
     C                   PARM                    BJHOCY            3
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr                      141077
     C                   PARM                    WMsgIDXAr                      141077
     C                   PARM                    WMsgDtXAr                      141077
      *
      ** Date date - OK
      ** Value date - OK
      ** Option to date - OK
     C                   PARM                    DDDldtOK          1            deal date
     C                   PARM                    DDVdatOK          1            value date
     C                   PARM                    DDOdatOK          1            option to date
      *
      ** Deal deal date, value date, option to date
      *
     C                   PARM                    F3DDDN            5 0          deal date
     C                   PARM                    F3VDDN            5 0          deal date
     C                   PARM                    F3OTDN            5 0          deal date
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *                                                                                       CDL099
      ** Check to see if Split Value Date processing is on                                    CDL099
     C                   CALLB     'AOSARDR0'                                                 CDL099
     C                   PARM      *BLANKS       PRTCD             7                          CDL099
     C                   PARM      '*VERIFY'     POPTN             7                          CDL099
     C                   PARM      'CDL099'      PSARD             6                          CDL099
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL099
                                                                                              CDL099
     C                   IF        PRTCD = *BLANKS                                            CDL099
     C                   MOVE      'Y'           CDL099            1                          CDL099
     C                   ELSE                                                                 CDL099
     C                   MOVE      'N'           CDL099                                       CDL099
     C                   ENDIF                                                                CDL099

     C                   CALL      'AOSVALR0'                                               MD055571
     C                   PARM      *BLANKS       PRETURN                                    MD055571
     C                   PARM      PSYSVAL1      POP01                                      MD055571
     C                   PARM      *BLANKS       PVL01                                      MD055571
     C                   PARM      *BLANKS       POP02                                      MD055571
     C                   PARM      *BLANKS       PVL02                                      MD055571
     C                   PARM      *BLANKS       POP03                                      MD055571
     C                   PARM      *BLANKS       PVL03                                      MD055571
     C                   PARM      *BLANKS       POP04                                      MD055571
     C                   PARM      *BLANKS       PVL04                                      MD055571
     C                   PARM      *BLANKS       POP05                                      MD055571
     C                   PARM      *BLANKS       PVL05                                      MD055571
     C                   PARM      *BLANKS       POP06                                      MD055571
     C                   PARM      *BLANKS       PVL06                                      MD055571
     C                   PARM      *BLANKS       POP07                                      MD055571
     C                   PARM      *BLANKS       PVL07                                      MD055571
     C                   PARM      *BLANKS       POP08                                      MD055571
     C                   PARM      *BLANKS       PVL08                                      MD055571
     C                   PARM      *BLANKS       POP09                                      MD055571
     C                   PARM      *BLANKS       PVL09                                      MD055571
     C                   PARM      *BLANKS       POP10                                      MD055571
     C                   PARM      *BLANKS       PVL10                                      MD055571
      *                                                                                     MD055571
     C                   EVAL      AODEVD = 'N'                                             MD055571
     C                   IF        PRETURN <> *BLANKS                                       MD055571
     C                   EVAL      DBFILE = 'SDSVALPD'                                      MD055571
     C                   EVAL      DBKEY = PSYSVAL1                                         MD055571
     C                   EVAL      DBASE = 918                                              MD055571
     C                   OUT       LDA                                                      MD055571
     C                   EXSR      *PSSR                                                    MD055571
     C                   ENDIF                                                              MD055571
      *                                                                                     MD055571
     C                   MOVEL     PVL01         AODEVD                                     MD055571
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
