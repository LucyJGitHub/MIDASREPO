     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Validate interest rate calendars')
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS module                                       *
      *                                                               *
      *  IRVIRCVAL  - Validate Interest Rate Calendars                *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             Interest Rate Calendar dates and confirms whether *
      *             they are valid. Valid dates are converted from    *
      *             DDMMYY format to 5,0 Midas day numbers.           *
      *                                                               *
      *             If ALL dates are valid the module returns the     *
      *             valid converted dates as a single string parameter*
      *             and the 10A return code will be blank,            *
      *                                                               *
      *             If one or more errors are found the module will   *
      *             return the valid date string as blanks,           *
      *             an array containing the dates in error,           *
      *             the Calendar Dates OK flag is set to 'N',         *
      *             and the 10A return code will contain 'Error'.     *
      *                                                               *
      *             Up to 82 dates may be validated but the module will*
      *             discontinue the validation process once 10 errors *
      *             have been detected.                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. 222373             Date 31Oct03               *
      *  Prev Amend No. CAP043             Date 02May02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 167511             Date 14Sep99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP004  *CREATE    Date 02Dec97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  222373 - CAP043 source missed from Midasplus1 collection     *
      *  CAP043 - Additional APIs for IRS Schedules                   *
      *  167511 - FRA/IRS functions fail if dates contain invalid data*
      *           (also fix mistreatment of warning errors)           *
      *  CAP004 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
     FDLDETUL0  IF   E           K DISK    INFSR(*PSSR)                                       CAP043
 
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
   43D/COPY ZACPYSRC,ERR_ARRAYS
                                                                                              CAP043
  109D AmountIn1DS     DS                                                                     CAP043
      ** Amounts (14chars) received from calling module                                       CAP043
     D  WAmount1A                    14A   DIM(82) INZ(*BLANKS)                               CAP043
                                                                                              CAP043
     D AmountIn2DS     DS                                                                     CAP043
      ** Amounts (16chars) received from calling module                                       CAP043
     D  WAmount2A                    16A   DIM(82) INZ(*BLANKS)                               CAP043
                                                                                              CAP043
  109D ConfHolDS       DS                                                                     CAP043
      ** Confirmed Holiday indicators output field                                            CAP043
     D  WConfHol                      1A   DIM(82)                                            CAP043
                                                                                              CAP043
      ** Business Day Convention currencies                                                   CAP043
     D BDConvtnDS      DS                                                                     CAP043
     D  PBDCCcy                       3A   DIM(10)                                            CAP043
                                                                                              CAP043
      ** Increase/Decrease indicator                                                          CAP043
     D IDIndDS         DS                                                                     CAP043
     D  PIDInd                        1A   DIM(82)                                            CAP043
 
  109D InputDates      DS
      ** Dates in DDMMYY format received from calling module
     D  SDat                          6A   DIM(82) INZ(*ZEROS) ASCEND
     D  SDatDefine             1    492A
 
  109D OutputDate      DS
      ** Valid dates in dayno. format returned to calling module
     D  Dummy                  1     22A
     D  OutDate                       5P 0 DIM(82) INZ(*ZEROS)
     D  DatAlp                23    268A
 
     D FieldError      DS
      ** Dates in error
     D  FieldInErr             1     10
     D  FieldAlpha             1      4
     D  FieldIndex             5      6S 0
     D  FieldRight             7     10    INZ(*BLANKS)
                                                                                              CAP043
      ** Switchable features data structure                                                   CAP043
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAP043
                                                                                              CAP043
      ** Module Details Data Structure                                                        CAP043
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  CAP043
                                                                                              CAP043
      ** Data Structure used by Access Objects                                                CAP043
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CAP043
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      **
      ** Value date in 5,0 format                                               CAP004
     D   ValueDate     S              5P 0
 
      ** Maturity date in 5,0 format                                            CAP004
     D   MatDate       S              5P 0
 
      ** Date format indicator, received as a parameter                         CAP004
     D   BJDFIN        S              1A
 
      ** Date converted to Midas Dayno format
     D   InDateMDN     S              5P 0
 
      ** Date to be validated
     D   InDate        S              6
 
      ** Previous date for comparison
     D   PrevDate      S              5P 0 INZ(*ZEROS)
 
      ** Dates to be validated (max 82) DDMMYY format from calling module       CAP004
     D   DatesIn       S            492
 
      ** IRC Dates OK flag                                                      CAP004
     D   OKInRatCal    S              1A
 
      * Error Array index (3P0)                                                 CAP004
     D   Idx           S              3P 0
 
      * Date Array index (3P0)                                                  CAP004
     D   X             S              2P 0 INZ(*ZEROS)
 
      * First blank element in input dates array                                CAP004
     D   FirstBlank    S              2P 0 INZ(*ZEROS)
 
      ** Valid dates output (max 82)in daynumber format                         CAP004
     D  ValDateOut     S            246
 
      ** Error Flag for call to Standard routines (equates to *IN99)
     D ErrorFlag       S              1A   INZ('N')
                                                                                              CAP043
      ** Amounts to be validated (max 82)                                                     CAP043
     D PAmount1        S           1148A                                                      CAP043
                                                                                              CAP043
      ** Amounts to be validated (max 82)                                                     CAP043
     D PAmount2        S           1312A                                                      CAP043
                                                                                              CAP043
      ** Increase/Decrease indicator                                                          CAP043
     D PIncDecInd      S             82A                                                      CAP043
                                                                                              CAP043
      ** Business Day Convention currencies                                                   CAP043
     D PBDConvtn       S             30A                                                      CAP043
                                                                                              CAP043
      ** Confirmed Holiday Indicator                                                          CAP043
     D PConfHol        S             82A                                                      CAP043
                                                                                              CAP043
      ** Output amounts                                                                       CAP043
     D PValidAmnt      S            574A                                                      CAP043
     D PValidCAmt      S            656A                                                      CAP043
                                                                                              CAP043
      ** Other workfield used by CAP043                                                       CAP043
     D Y               S              2P 0                                                    CAP043
     D PAction         S              1A                                                      CAP043
     D PDealNo         S              6A                                                      CAP043
     D WDealNo         S              6  0                                                    CAP043
     D PPrevDate       S              5P 0                                                    CAP043
     D PValType        S              1A                                                      CAP043
     D POurTheir       S              1A                                                      CAP043
     D PCurrency       S              3A                                                      CAP043
     D PRtCd           S              7A                                                      CAP043
     D POptn           S              7A                                                      CAP043
     D PSard           S              6A                                                      CAP043
     D CAP043          S              1A                                                      CAP043
     D CIR005          S              1A                                                      CAP043
     D WRatePay        S              1A                                                      CAP043
     D PZDateIn        S              5P 0                                                    CAP043
     D PZCcy           S              3A                                                      CAP043
     D PZLoc           S              3A                                                      CAP043
     D PZHol           S              1A                                                      CAP043
     D WHoliday        S              1A                                                      CAP043
     D WRK153          S             15  3                                                    CAP043
     D WRK30           S              3  0                                                    CAP043
     D PBGN2ST         S              1A                                                      CAP043
     D WDTSCFound      S              1A                                                      CAP043
     D WCFSCFound      S              1A                                                      CAP043
     D WPCSCFound      S              1A                                                      CAP043
     D WCTLDYN         S              5P 0                                                    CAP043
     D PCtlDate        S              5P 0                                                    CAP043
     D WSAmount1       S             14A                                                      CAP043
     D WSAmount2       S             16A                                                      CAP043
     D WSIncDec        S              1A                                                      CAP043
 
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
      ** Reset the error flag to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
     C                   RESET                   PrevDate
 
      ** Clear Date data structures.
     C                   CLEAR                   InputDates
     C                   CLEAR                   OutputDate
     C                   CLEAR                   ValDateOut
     C                   CLEAR                   FieldError
 
      ** Clear Output Arrays.
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIDArr
 
      ** Set up array of input dates.
     C                   MOVEL     DatesIn       InputDates
                                                                                              CAP043
     C                   IF        CAP043 = 'Y'                                               CAP043
     C                   CLEAR                   PValidAmnt                                   CAP043
     C                   CLEAR                   PValidCAmt                                   CAP043
     C                   MOVEL     PAmount1      AmountIn1DS                                  CAP043
     C                   MOVEL     PAmount2      AmountIn2DS                                  CAP043
     C                   MOVEL     PConfHol      ConfHolDS                                    CAP043
     C                   MOVEL     PBDConvtn     BDConvtnDS                                   CAP043
     C                   MOVEL     PIncDecInd    IDIndDS                                      CAP043
     C                   MOVE      PDealNo       WDealno                                      CAP043
     C                   EVAL      PrevDate = PPrevDate                                       CAP043
     C                   IF        PValType = 'R'                                             CAP043
     C                   EVAL      WRatePay = 'R'                                             CAP043
     C                   ENDIF                                                                CAP043
     C                   IF        PValType = 'I'                                             CAP043
     C                   EVAL      WRatePay = 'P'                                             CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                CAP043
 
      ** Validate dates.
 
      ** First check array of input dates to ensure no embedded blanks
     C                   Z-ADD     1             X
     C     *BLANKS       LOOKUP    SDat(X)                                99
 
      ** If blank element found check further for non blank elements
      ** If any found then embedded blanks exist so report error and
      ** skip further processing
 
     C     *IN99         IFEQ      '1'
     C                   Z-ADD     X             FirstBlank
     C     *BLANKS       LOOKUP    SDat(X)                            99
 
     C     *IN99         IFEQ      '1'
     C                   ADD       1             Idx
     C                   MOVE      'Y'           Errorfound
     C                   MOVEL     'MMA0669'     MsgIDArr(Idx)
     C                   MOVE      'SDAT'        FieldAlpha
     C                   Z-ADD     FirstBlank    FieldIndex
     C                   EVAL      FldNameArr(Idx) = FieldInErr
     C                   GOTO      ErrorTag
     C                   END
     C                   END
 
      ** No embedded blanks exist so reset index and check individual dates
     C                   Z-ADD     1             X
     C                   MOVE      SDat(X)       InDate
                                                                                              CAP043
      ** Get principal change control date                                                    CAP043
                                                                                              CAP043
     C                   IF        PValType = 'P'                                             CAP043
     C                   EXSR      SRGetCtlDate                                               CAP043
     C                   ENDIF                                                                CAP043
 
      **  Validate each date in turn until either:
      **  a) a blank date is encountered, or
      **  b) 10 errors have been found, or
      **  c) all 82 dates have been processed
      ** Also, a cross validation against dates, amounts and increase decrease                CAP043
      ** indicator. If one of this field is blank and the others are not,                     CAP043
      ** an error will be sent                                                                CAP043
 
     C     InDate        DOWNE     *BLANKS
     C     Idx           ANDLT     10
     C     X             ANDLT     83
     C     WSAmount1     ORNE      *BLANKS                                                    CAP043
     C     Idx           ANDLT     10                                                         CAP043
     C     X             ANDLT     83                                                         CAP043
     C     WSAmount2     ORNE      *BLANKS                                                    CAP043
     C     Idx           ANDLT     10                                                         CAP043
     C     X             ANDLT     83                                                         CAP043
     C     WSIncDec      ORNE      *BLANKS                                                    CAP043
     C     Idx           ANDLT     10                                                         CAP043
     C     X             ANDLT     83                                                         CAP043
     C                   EXSR      Validate
     C                   END
                                                                                              CAP043
      ** Check if amounts and increase/decrease indicator entered are valid                   CAP043
                                                                                              CAP043
     C                   IF        (CAP043 = 'Y') AND (ErrorFound = 'N')                      CAP043
     C                   IF        (PValType = 'C') OR (PValType = 'P')                       CAP043
     C                   CALLB     'IRVIRCAMT'                                                CAP043
     C                   PARM      *BLANK        RetCodeOut                                   CAP043
     C                   PARM      BGN2ST        PBGN2ST                                      CAP043
     C                   PARM                    PValType                                     CAP043
     C                   PARM                    PCurrency                                    CAP043
     C                   PARM                    PAmount1                                     CAP043
     C                   PARM                    PAmount2                                     CAP043
     C                   PARM                    PIncDecInd                                   CAP043
     C                   PARM                    Idx                                          CAP043
     C                   PARM                    FldNameArr                                   CAP043
     C                   PARM                    MsgIDArr                                     CAP043
     C                   PARM                    MsgDtaArr                                    CAP043
     C                   PARM                    PValidAmnt                                   CAP043
     C                   PARM                    PValidCAmt                                   CAP043
                                                                                              CAP043
      ** Error found, set error field to 'Y'                                                  CAP043
                                                                                              CAP043
     C                   IF        RetCodeOut = '*ERROR'                                      CAP043
     C                   EVAL      ErrorFound = 'Y'                                           CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   ENDIF                                                                CAP043
 
      ** If no errors found write the array of valid dates to the
      ** output parameter, after filling any remaining array elements
      ** with zeros.
     C                   IF        ErrorFound = 'N'
 
     C     X             DOWLT     83
     C                   Z-ADD     *ZEROS        OutDate(X)
     C                   ADD       1             X
     C                   END
 
     C                   MOVE      DatAlp        ValDateOut
                                                                                              CAP043
      ** Set up confirmed holiday indicator                                                   CAP043
                                                                                              CAP043
     C                   IF        CAP043 = 'Y'                                               CAP043
     C                   EVAL      PConfHol = ConfHolDS                                       CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF
 
     C     ErrorTag      TAG
      ** Errors found
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   EVAL      OKInRatCal = 'N'
     C                   ENDIF
 
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Validate - Validate dates input                               *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     Validate      BEGSR
                                                                                              CAP043
     C                   EVAL      WHoliday = 'N'                                             CAP043
 
      ** Convert date from DDMMYY to Midas day number and check
      ** for valid date.
 
     C                   TESTN                   InDate               9798      167511
     C     *IN97         IFEQ      '1'                                          167511
     C     *IN98         OREQ      '1'                                          167511
     C                   CALLB     'ZDATE1'
     C                   PARM                    InDate
     C                   PARM                    InDateMDN
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
     C                   ENDIF                                                  167511
 
     C     ErrorFlag     IFEQ      'Y'
     C     *IN97         OREQ      '0'                                          167511
     C     *IN98         ANDEQ     '0'                                          167511
     C                   ADD       1             Idx
     C                   MOVE      'Y'           Errorfound
     C                   MOVEL     'DLM0142'     MsgIDArr(Idx)
     C                   MOVE      'SDAT'        FieldAlpha
     C                   Z-ADD     X             FieldIndex
     C                   EVAL      FldNameArr(Idx) = FieldInErr
     C                   GOTO      ValidEnd
     C                   END
 
      ** Date must be greater than previous date in sequence
 
     C     InDateMDN     IFLE      PrevDate
     C                   ADD       1             Idx
     C                   MOVE      'Y'           Errorfound
     C                   MOVEL     'DLM0145'     MsgIDArr(Idx)
     C                   MOVE      'SDAT'        FieldAlpha
     C                   Z-ADD     X             FieldIndex
     C                   EVAL      FldNameArr(Idx) = FieldInErr
     C                   GOTO      ValidEnd
     C                   END
 
     C* Date must be after the value date
 
     C*****InDateMDN     IFLE      ValueDate                                                  CAP043
     C     InDateMDN     IFLT      ValueDate                                                  CAP043
     C     InDateMDN     OREQ      ValueDate                                                  CAP043
     C     PValType      ANDEQ     'R'                                                        CAP043
     C     InDateMDN     OREQ      ValueDate                                                  CAP043
     C     PValType      ANDEQ     'P'                                                        CAP043
     C                   ADD       1             Idx
     C                   MOVE      'Y'           Errorfound
     C                   IF        PValType = 'P'                                             CAP043
     C                   MOVEL     'DLM0143'     MsgIDArr(Idx)                                CAP043
     C                   ELSE                                                                 CAP043
     C                   MOVEL     'DLM0167'     MsgIDArr(Idx)
     C                   ENDIF                                                                CAP043
     C                   MOVE      'SDAT'        FieldAlpha
     C                   Z-ADD     X             FieldIndex
     C                   EVAL      FldNameArr(Idx) = FieldInErr
     C                   GOTO      ValidEnd
     C                   END
 
     C* Date must be before the maturity date
 
     C*****InDateMDN     IFGE      MatDate                                                    CAP043
     C     InDateMDN     IFGT      MatDate                                                    CAP043
     C     InDateMDN     OREQ      MatDate                                                    CAP043
     C     PValType      ANDEQ     'R'                                                        CAP043
     C                   ADD       1             Idx
     C                   MOVE      'Y'           Errorfound
     C                   MOVEL     'DLM0168'     MsgIDArr(Idx)
     C                   MOVE      'SDAT'        FieldAlpha
     C                   Z-ADD     X             FieldIndex
     C                   EVAL      FldNameArr(Idx) = FieldInErr
     C                   GOTO      ValidEnd
     C                   END
                                                                                              CAP043
      ** Date cannot be less than the control date for principal                              CAP043
      ** change                                                                               CAP043
                                                                                              CAP043
     C     InDateMDN     IFLT      WCTLDYN                                                    CAP043
     C     PValType      ANDEQ     'P'                                                        CAP043
     C                   ADD       1             Idx                                          CAP043
     C                   MOVE      'Y'           Errorfound                                   CAP043
     C                   MOVEL     'DLM0176'     MsgIDArr(Idx)                                CAP043
     C                   MOVE      'SDAT'        FieldAlpha                                   CAP043
     C                   Z-ADD     X             FieldIndex                                   CAP043
     C                   EVAL      FldNameArr(Idx) = FieldInErr                               CAP043
     C                   GOTO      ValidEnd                                                   CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** Action code is 'I' and date already existing from file                               CAP043
                                                                                              CAP043
     C                   IF         PAction = 'I'                                             CAP043
     C                   EVAL       WDTSCFound = 'N'                                          CAP043
     C                   EVAL       WCFSCFound = 'N'                                          CAP043
     C                   EVAL       WPCSCFound = 'N'                                          CAP043
     C                   SELECT                                                               CAP043
     C                   WHEN      (PValType = 'R') OR (PValType = 'I')                       CAP043
     C     KIRSDV        CHAIN     DLDTSCD0                                                   CAP043
     C                   IF        %FOUND                                                     CAP043
     C                   EVAL      WDTSCFound = 'Y'                                           CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   WHEN      (PValType = 'C')                                           CAP043
     C     KCFPC         CHAIN     DLCFSCD0                                                   CAP043
     C                   IF        %FOUND                                                     CAP043
     C                   EVAL      WCFSCFound = 'Y'                                           CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   WHEN      (PValType = 'P')                                           CAP043
     C     KCFPC         CHAIN     DLPCSCD0                                                   CAP043
     C                   IF        %FOUND                                                     CAP043
     C                   EVAL      WPCSCFound = 'Y'                                           CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDSL                                                                CAP043
                                                                                              CAP043
     C                   IF        (WDTSCFound = 'Y') OR (WCFSCFound = 'Y') OR                CAP043
     C                             (WPCSCFound = 'Y')                                         CAP043
     C                   ADD       1             Idx                                          CAP043
     C                   MOVE      'Y'           Errorfound                                   CAP043
     C                   MOVEL     'DLM0150'     MsgIDArr(Idx)                                CAP043
     C                   MOVE      'SDAT'        FieldAlpha                                   CAP043
     C                   Z-ADD     X             FieldIndex                                   CAP043
     C                   EVAL      FldNameArr(Idx) = FieldInErr                               CAP043
     C                   GOTO      ValidEnd                                                   CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** If date is blank and amount is not blank for cash flow and principal                 CAP043
      ** change, error                                                                        CAP043
                                                                                              CAP043
     C                   IF        (PValType = 'C') OR (PValType = 'P')                       CAP043
     C                   IF        Indate = *BLANK                                            CAP043
     C                   IF        (PValType = 'C') AND (WAmount1A(X) <> *BLANK)              CAP043
     C                             OR (PValType = 'P') AND                                    CAP043
     C                             (WAmount2A(X) <> *BLANK)                                   CAP043
     C                   ADD       1             Idx                                          CAP043
     C                   MOVE      'Y'           Errorfound                                   CAP043
     C                   MOVEL     'DLM0141'     MsgIDArr(Idx)                                CAP043
     C                   MOVE      'SDAT'        FieldAlpha                                   CAP043
     C                   Z-ADD     X             FieldIndex                                   CAP043
     C                   EVAL      FldNameArr(Idx) = FieldInErr                               CAP043
     C                   GOTO      ValidEnd                                                   CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** If amount is blank and date or increase/decrease ind not blank for cash              CAP043
      ** flow or principal change, error                                                      CAP043
                                                                                              CAP043
     C                   IF        (WAmount1A(X) = *BLANK) AND (PValType = 'C')               CAP043
     C                             OR (WAmount2A(X) = *BLANK) AND                             CAP043
     C                             (PValType = 'P')                                           CAP043
     C                   IF        (Indate <> *BLANK) OR (PIDInd(X) <> *BLANK)                CAP043
     C                             AND (PValType = 'P')                                       CAP043
     C                   ADD       1             Idx                                          CAP043
     C                   MOVE      'Y'           Errorfound                                   CAP043
     C                   MOVEL     'DLM0148'     MsgIDArr(Idx)                                CAP043
     C                   MOVE      'SAMT'        FieldAlpha                                   CAP043
     C                   Z-ADD     X             FieldIndex                                   CAP043
     C                   EVAL      FldNameArr(Idx) = FieldInErr                               CAP043
     C                   GOTO      ValidEnd                                                   CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** If increase/decrease indicator is blank and amount is not blank and                  CAP043
      ** midas-plato is 'Y' for principal change, error                                       CAP043
                                                                                              CAP043
     C                   IF        (PIDInd(X) = *BLANK) AND                                   CAP043
     C                             (WAmount2A(X) <> *BLANK) AND                               CAP043
     C                             (PValType = 'P') AND                                       CAP043
     C                             (BGN2ST = 'Y')                                             CAP043
     C                   ADD       1             Idx                                          CAP043
     C                   MOVE      'Y'           Errorfound                                   CAP043
     C                   MOVEL     'DLM1022'     MsgIDArr(Idx)                                CAP043
     C                   MOVE      'SIND'        FieldAlpha                                   CAP043
     C                   Z-ADD     X             FieldIndex                                   CAP043
     C                   EVAL      FldNameArr(Idx) = FieldInErr                               CAP043
     C                   GOTO      ValidEnd                                                   CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** Check if date is a holiday                                                           CAP043
                                                                                              CAP043
                                                                                              CAP043
     C                   IF        (CIR005 = 'N') OR                                          CAP043
     C                             (CIR005 = 'Y') AND (PBDCCcy(1) = *BLANK)                   CAP043
     C                   Z-ADD     InDateMDN     PZDateIn                                     CAP043
     C                   CALLB     'ZCHKH'                                                    CAP043
     C                   PARM                    PZDateIn                                     CAP043
     C                   PARM      PCurrency     PZCcy                                        CAP043
     C                   PARM      *BLANK        PZLoc                                        CAP043
     C                   PARM      *BLANK        PZHol                                        CAP043
                                                                                              CAP043
      ** Set a flag to be use in updating 'Confirmed Holiday' indicator                       CAP043
      ** when the date is a holiday                                                           CAP043
                                                                                              CAP043
     C                   IF        PZHol = 'H'                                                CAP043
     C                   EVAL      WHoliday = 'Y'                                             CAP043
     C                   ELSE                                                                 CAP043
                                                                                              CAP043
      ** Else, if not a holiday, check if it is a saturday or a sunday                        CAP043
      ** and treat it as holiday                                                              CAP043
                                                                                              CAP043
     C                   EVAL      WRK153 = InDateMDN/7                                       CAP043
     C                   MOVE      WRK153        WRK30                                        CAP043
     C                   IF        (WRK30 = 142) OR (WRK30 = 285)                             CAP043
     C                   EVAL      WHoliday = 'Y'                                             CAP043
     C                   ENDIF                                                                CAP043
     C                                                                                        CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   ELSE                                                                 CAP043
                                                                                              CAP043
      ** Check date if holiday using business day convention currencies when                  CAP043
      ** CIR005 is on (for interest dates only)                                               CAP043
                                                                                              CAP043
     C                   IF        (PValType = 'I') OR (PValType = 'R')                       CAP043
     C     1             DO        10            Y                                            CAP043
     C                   EVAL      PZCcy = PBDCCcy(Y)                                         CAP043
     C                   IF        PZCcy <> *BLANK                                            CAP043
     C                   Z-ADD     InDateMDN     PZDateIn                                     CAP043
     C                   CALLB     'ZCHKH'                                                    CAP043
     C                   PARM                    PZDateIn                                     CAP043
     C                   PARM                    PZCcy                                        CAP043
     C                   PARM      *BLANK        PZLoc                                        CAP043
     C                   PARM      *BLANK        PZHol                                        CAP043
     C                   IF        PZHol = 'H'                                                CAP043
     C                   EVAL      WHoliday = 'Y'                                             CAP043
     C                   LEAVE                                                                CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   ENDDO                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   IF        WHoliday <> 'Y'                                            CAP043
     C                   Z-ADD     InDateMDN     PZDateIn                                     CAP043
     C                   CALLB     'ZCHKH'                                                    CAP043
     C                   PARM                    PZDateIn                                     CAP043
     C                   PARM      PCurrency     PZCcy                                        CAP043
     C                   PARM      *BLANK        PZLoc                                        CAP043
     C                   PARM      *BLANK        PZHol                                        CAP043
                                                                                              CAP043
     C                   IF        PZHol = 'H'                                                CAP043
     C                   EVAL      WHoliday = 'Y'                                             CAP043
     C                   ELSE                                                                 CAP043
                                                                                              CAP043
      ** Else, if not a holiday, check if it is a saturday or a sunday                        CAP043
      ** and treat it as holiday                                                              CAP043
                                                                                              CAP043
     C                   EVAL      WRK153 = InDateMDN/7                                       CAP043
     C                   MOVE      WRK153        WRK30                                        CAP043
     C                   IF        (WRK30 = 142) OR (WRK30 = 285)                             CAP043
     C                   EVAL      WHoliday = 'Y'                                             CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
 
     C     ValidEnd      TAG
 
      ** If dates are still all valid move current date to output area
     C     ErrorFound    IFEQ      'N'
     C                   Z-ADD     InDateMDN     OutDate(X)
                                                                                              CAP043
      ** Set Confirmed Holiday output parameter                                               CAP043
                                                                                              CAP043
     C                   IF        WHoliday = 'Y'                                             CAP043
     C                   EVAL      WConfHol(X) = 'Y'                                          CAP043
     C                   ELSE                                                                 CAP043
     C                   EVAL      WConfHol(X) = ' '                                          CAP043
     C                   ENDIF                                                                CAP043
     C                   END
 
      ** Current date becomes previous date
     C                   Z-ADD     InDateMDN     PrevDate
     C                   EVAL      PPrevDate = PrevDate                                       CAP043
 
      ** Read in the next date if less than maximum (82)
     C                   ADD       1             X
     C     X             IFLE      82
     C                   MOVE      SDat(X)       InDate
     C                   MOVE      WAmount1A(X)  WSAmount1                                    CAP043
     C                   MOVE      WAmount2A(X)  WSAmount2                                    CAP043
     C                   MOVE      PIDInd(X)     WSIncDec                                     CAP043
     C                   END
 
     C                   ENDSR
                                                                                              CAP043
      ********************************************************************                    CAP043
      /EJECT                                                                                  CAP043
      ********************************************************************                    CAP043
      *                                                                  *                    CAP043
      * SRGetCtlDate - Get Control Date                                  *                    CAP043
      *                                                                  *                    CAP043
      ********************************************************************                    CAP043
                                                                                              CAP043
     C     SRGetCtlDate  BEGSR                                                                CAP043
                                                                                              CAP043
      ** Get control date - the first non-processed date                                      CAP043
                                                                                              CAP043
     C                   EVAL      PRDT = *ZERO                                               CAP043
     C                   EVAL      WCTLDYN = *ZERO                                            CAP043
                                                                                              CAP043
     C     KIRSDL        SETLL     DLPCSCD0                                                   CAP043
     C     KIRSDP        READE     DLPCSCD0                               30                  CAP043
                                                                                              CAP043
     C                   DOW       (*IN30 = *OFF) AND                                         CAP043
     C                             (WCTLDYN = *ZERO)                                          CAP043
     C                   IF        DTPR <> 'Y'                                                CAP043
     C                   Z-ADD     PRDT          WCTLDYN                                      CAP043
     C                   ENDIF                                                                CAP043
     C     KIRSDP        READE     DLPCSCD0                               30                  CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
      ** If nothing was found, default control date to next principal                         CAP043
      ** change date                                                                          CAP043
                                                                                              CAP043
     C                   IF        (WCTLDYN = *ZERO) AND (PCtlDate <> *ZERO)                  CAP043
     C                   EVAL      WCTLDYN = PCtlDate                                         CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   ENDSR                                                                CAP043
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
      ** Return Code                                                            CAP004
     C                   PARM                    RetCodeIn
      ** Value date in 5,0 format                                               CAP004
     C                   PARM                    ValueDate                      CAP004
      ** Maturity date in 5,0 format                                            CAP004
     C                   PARM                    MatDate                        CAP004
     C                   PARM                    PCtlDate                                     CAP043
      ** Date format indicator
     C                   PARM                    BJDFIN
     C                   PARM                    PAction                                      CAP043
     C                   PARM                    PDealNo                                      CAP043
     C                   PARM                    PPrevDate                                    CAP043
     C                   PARM                    PValType                                     CAP043
     C                   PARM                    POurTheir                                    CAP043
     C                   PARM                    PCurrency                                    CAP043
      ** Date Array (max 82) DDMMYY format                                      CAP004
     C                   PARM                    DatesIn                        CAP004
      *                                                                         CAP004
     C                   PARM                    PAmount1                                     CAP043
     C                   PARM                    PAmount2                                     CAP043
     C                   PARM                    PIncDecInd                                   CAP043
     C                   PARM                    PConfHol                                     CAP043
     C                   PARM                    PBDConvtn                                    CAP043
      ** Following parameters are returned to calling module                    CAP004
      ** IRC Dates OK flag                                                      CAP004
     C                   PARM                    OKInRatCal                     CAP004
      * Error fields/message IDs (arrays)                                       CAP004
     C                   PARM                    FldNameArr                     CAP004
     C                   PARM                    MsgIDArr                       CAP004
      * Array index (3P0)                                                       CAP004
     C                   PARM                    Idx                            CAP004
      ** Valid dates output (max 82)in daynumber format                         CAP004
     C                   PARM                    ValDateOut                     CAP004
     C                   PARM                    PValidAmnt                                   CAP043
     C                   PARM                    PValidCAmt                                   CAP043
                                                                                              CAP043
     C     KIRSDV        KLIST                                                                CAP043
     C                   KFLD                    WDealNo                                      CAP043
     C                   KFLD                    POurTheir                                    CAP043
     C                   KFLD                    WRatePay                                     CAP043
     C                   KFLD                    InDateMDN                                    CAP043
                                                                                              CAP043
     C     KCFPC         KLIST                                                                CAP043
     C                   KFLD                    WDealNo                                      CAP043
     C                   KFLD                    POurTheir                                    CAP043
     C                   KFLD                    InDateMDN                                    CAP043
                                                                                              CAP043
     C     KIRSDL        KLIST                                                                CAP043
     C                   KFLD                    WDealNo                                      CAP043
     C                   KFLD                    POurTheir                                    CAP043
     C                   KFLD                    PRDT                                         CAP043
                                                                                              CAP043
     C     KIRSDP        KLIST                                                                CAP043
     C                   KFLD                    WDealNo                                      CAP043
     C                   KFLD                    POurTheir                                    CAP043
                                                                                              CAP043
      ** Access module details to see if Midas-Plato is installed                             CAP043
                                                                                              CAP043
     C                   CALLB     'AOMMODR0'                                                 CAP043
     C                   PARM      '*DBERR '     PRTCD                                        CAP043
     C                   PARM      '*FIRST '     POPTN                                        CAP043
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        CAP043
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values
 
     C/COPY ZACPYSRC,DBFIELDS
                                                                                              CAP043
      ** Check if CAP043 is installed                                                         CAP043
                                                                                              CAP043
     C                   CALL      'AOSARDR0'                                                 CAP043
     C                   PARM      *BLANKS       PRtCd                                        CAP043
     C                   PARM      '*VERIFY'     POptn                                        CAP043
     C                   PARM      'CAP043'      PSard                                        CAP043
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP043
                                                                                              CAP043
     C                   IF        PRtCd = *Blanks                                            CAP043
     C                   EVAL      CAP043 = 'Y'                                               CAP043
     C                   ELSE                                                                 CAP043
     C                   EVAL      CAP043 = 'N'                                               CAP043
                                                                                              CAP043
     C                   IF        PRtCd <> '*NRF'                                            CAP043
     C     *LOCK         IN        LDA                                                        CAP043
     C                   EVAL      DBKEY = 'CAP043'                                           CAP043
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAP043
     C                   EVAL      DBASE = 1                                                  CAP043
     C                   OUT       LDA                                                        CAP043
     C                   EXSR      *PSSR                                                      CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** Check if CIR005 is installed                                                         CAP043
                                                                                              CAP043
     C                   CALL      'AOSARDR0'                                                 CAP043
     C                   PARM      *BLANKS       PRtCd                                        CAP043
     C                   PARM      '*VERIFY'     POptn                                        CAP043
     C                   PARM      'CIR005'      PSard                                        CAP043
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP043
                                                                                              CAP043
     C                   IF        PRtCd = *Blanks                                            CAP043
     C                   EVAL      CIR005 = 'Y'                                               CAP043
     C                   ELSE                                                                 CAP043
     C                   EVAL      CIR005 = 'N'                                               CAP043
                                                                                              CAP043
     C                   IF        PRtCd <> '*NRF'                                            CAP043
     C     *LOCK         IN        LDA                                                        CAP043
     C                   EVAL      DBKEY = 'CIR005'                                           CAP043
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAP043
     C                   EVAL      DBASE = 2                                                  CAP043
     C                   OUT       LDA                                                        CAP043
     C                   EXSR      *PSSR                                                      CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   ENDIF                                                                CAP043
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
