     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate interest rate calendars')            *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Module                                  *
      *                                                               *
      *  MMVRCHG - Midas MM Validate Interest Rate Calendar           *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             Interest Rate Calendar dates and confirms whether *
      *             they are valid. Valid dates are converted from    *
      *             screen format to 5,0 Midas day numbers.           *
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
      *             Up to 600 dates may be validated but the module   *
      *             will discontinue the validation process once 10   *
      *             errors have been detected.                        *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR1076900          Date 08Feb13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL033  *CREATE    Date 10Feb05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1076900 - Update scheduled rate change error               *
      *  CDL033 - Floating Rate CDs Issued                            *
      *                                                               *
      *****************************************************************
     FDLFRSCL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
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
 
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      ** Data Structure for Rundate                                                       AR1076900
     D RUNDAT          DS                                                                 AR1076900
     D  Rundate                8     10P 0                                                AR1076900
     D  MBIN                  13     13                                                   AR1076900
                                                                                          AR1076900
     D BDConvtnDS      DS
      ** Business Day Convention currencies
 
     D InputDates      DS
      ** Dates in DDMMYY format received from calling module
 
     D  SDat                          6A   DIM(600) INZ(*ZEROS)
     D  OKarr                         1A   DIM(600)
 
     D OutputDate      DS
      ** Valid dates in dayno. format returned to calling module
 
     D  Dummy                  1     22A
     D  OutDate                       5P 0 DIM(600) INZ(*ZEROS)
     D  DatAlp                23   1822A
 
     D FieldError      DS
      ** Dates in error
     D  FieldInErr             1     10
     D  FieldAlpha             1      4
     D  FieldIndex             5      6S 0
     D  FieldRight             7     10    INZ(*BLANKS)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Value date in 5,0 format
     D   PValDte       S              5P 0
 
      ** Maturity date in 5,0 format
     D   PMatDte       S              5P 0
 
      ** Date format indicator, received as a parameter
     D   BJDFIN        S              1A
 
      ** Date converted to Midas Dayno format
     D   InDateMDN     S              5P 0
 
      ** Date to be validated
     D   InDate        S              6
 
      ** Previous date for comparison
     D   PrevDate      S              5P 0 INZ(*ZEROS)
 
      ** Dates to be validated (max 600) DDMMYY format from calling module
     D   PDatesIn      S           3600
 
      ** IRC Dates OK flag
     D   OKInRatCal    S            600A
 
      ** Error Array index (3P0)
     D   Idx           S              3P 0
 
      ** Date Array index (3P0)
     D   X             S              3P 0 INZ(*ZEROS)
 
      ** First blank element in input dates array
     D   FirstBlank    S              3P 0 INZ(*ZEROS)
 
      ** Last non-blank element in input dates array
     D   LastElem      S              3P 0 INZ(*ZEROS)
 
      ** Valid dates output (max 600) in daynumber format
     D  PValidDteOut   S           1800
 
      ** Error Flag for call to Standard routines (equates to *IN99)
     D ErrorFlag       S              1A   INZ('N')
 
      ** Business Day Convention currencies
     D PBDConvtn       S             30A
 
      ** Confirmed Holiday Indicator
     D PConfHol        S            600A
 
      ** Interest Payment or Interest Rate Change indicator
     D PRtePayInd      S              1A
 
      ** Other workfield
     D PAction         S              1A
     D PDealNo         S              6A
     D WDealNo         S                   LIKE(HHDLNO)
     D WPRDT           S                   LIKE(HHPRDT)
     D PPrevDate       S              5P 0
     D POurTheir       S              1A
     D PCurrency       S              3A
     D PRtCd           S              7A
     D POptn           S              7A
     D PZDateIn        S              5P 0
     D PZCcy           S              3A
     D PZLoc           S              3A
     D PZHol           S              1A
     D WHoliday        S              1A
     D WRK153          S             15  3
     D WRK30           S              3  0
     D WCTLDYN         S              5P 0
     D PCtlDate        S              5P 0
 
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
      *
      ** Reset the error flag to prevent problems on subsequent calls
      *
     C                   RESET                   ErrorFound
     C                   RESET                   PrevDate
      *
      ** Clear Date data structures.
      *
     C                   CLEAR                   InputDates
     C                   CLEAR                   OutputDate
     C                   CLEAR                   OutDate
     C                   CLEAR                   PValidDteOut
     C                   CLEAR                   FieldError
     C                   MOVEA     *ALL'Y'       OKarr
      *
      ** Set up array of input dates.
      *
     C                   MOVEL     PDatesIn      InputDates
      *
     C                   MOVE      PDealNo       WDealno
     C                   EVAL      PrevDate = PPrevDate
      *                                                                                    AR1076900
     C                   EVAL      POurTheir  = 'P'                                        AR1076900
     C                   IF        PRtePayInd = 'Y'                                        AR1076900
     C                   EVAL      POurTheir  = 'R'                                        AR1076900
     C                   ENDIF                                                             AR1076900
      *
      ** Find the first blank element starting from element 1.
     C                   Z-ADD     1             X
     C     *BLANKS       LOOKUP    SDat(X)                                89
     C     *IN89         IFEQ      '1'
     C                   Z-ADD     X             FirstBlank
     C                   ENDIF
      *
      ** Last non-blank element
     C                   Z-ADD     600           X
     C     SDAT(X)       DOWEQ     *BLANKS
     C                   SUB       1             X
     C     X             IFLE      0
     C                   GOTO      EndTag
     C                   ENDIF
     C                   ENDDO
     C                   Z-ADD     X             LastElem
      *
      ** Validate dates.
      ** Ensure no embedded blanks, i.e., no non-blank element
      ** beyond the first blank element.
      *
     C     LastElem      IFGT      FirstBlank
      ** - Starting with the last non-blank element, scan through
      **   the array in descending order and tag each blank element
      **   as invalid.
     C                   Z-ADD     LastElem      X
     C     X             DOWGE     FirstBlank
     C     SDAT(X)       IFEQ      *BLANKS
     C                   ADD       1             Idx
     C                   MOVE      'Y'           Errorfound
     C                   MOVEL     'MMA0669'     MsgIDArr(Idx)
     C                   MOVE      'SDAT'        FieldAlpha
     C                   Z-ADD     X             FieldIndex
     C                   EVAL      OKarr(X)='N'
     C                   EVAL      FldNameArr(Idx) = FieldInErr
     C                   ENDIF
     C                   SUB       1             X
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** Get principal change control date
      *
     C                   EXSR      SRGetCtlDate
      *
      **  Validate each date in turn until either:
      **  a) 20 errors have been found, or
      **  b) all dates have been processed
      *
     C                   Z-ADD     1             X
     C                   MOVE      SDat(X)       InDate
      *
     C     Idx           DOWLT     20
     C     X             ANDLE     LastElem
      *
     C     InDate        IFNE      *BLANKS
     C                   EXSR      SRValidate
     C                   ENDIF
      *
      ** Read in the next date if less than maximum (600)
     C                   ADD       1             X
     C     X             IFLE      600
     C                   MOVE      SDat(X)       InDate
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** Valid output dates either non-zero or zero for invalid
      ** dates
     C                   MOVE      DatAlp        PValidDteOut
 
     C     EndTag        TAG
      *
      ** Errors found
      *
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
     C                   MOVEA     OKarr         OKInRatCal
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValidate - Validate dates input                             *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRValidate    BEGSR
      *
      ** Convert date from DDMMYY to Midas day number and check
      ** for valid date.
      *
     C                   TESTN                   InDate               8788
     C     *IN87         IFEQ      '1'
     C     *IN88         OREQ      '1'
     C                   CALLB     'ZDATE1'
     C                   PARM                    InDate
     C                   PARM                    InDateMDN
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
     C                   ENDIF
 
     C     ErrorFlag     IFEQ      'Y'
     C     *IN87         OREQ      '0'
     C     *IN88         ANDEQ     '0'
     C                   ADD       1             Idx
     C                   MOVE      'Y'           Errorfound
     C                   MOVEL     'DLM0142'     MsgIDArr(Idx)
     C                   MOVE      'SDAT'        FieldAlpha
     C                   Z-ADD     X             FieldIndex
     C                   EVAL      FldNameArr(Idx) = FieldInErr
     C                   EVAL      OKarr(X)='N'
     C                   GOTO      ValidEnd
     C                   ENDIF
      *
      ** Date must be greater than previous date in sequence
      *
     C     InDateMDN     IFLE      PrevDate
     C     InDateMDN     ANDNE     PCtlDate
     C                   ADD       1             Idx
     C                   MOVE      'Y'           Errorfound
     C                   MOVEL     'DLM0145'     MsgIDArr(Idx)
     C                   MOVE      'SDAT'        FieldAlpha
     C                   Z-ADD     X             FieldIndex
     C                   EVAL      FldNameArr(Idx) = FieldInErr
     C                   EVAL      OKarr(X)='N'
     C                   GOTO      ValidEnd
     C                   ENDIF
      *
      ** Date must be after the value date
      *
     C     InDateMDN     IFLE      PValDte
     C                   ADD       1             Idx
     C                   MOVE      'Y'           Errorfound
      *
     C     PRtePayInd    Ifeq      'Y'
     C                   MOVEL     'DLM0167'     MsgIDArr(Idx)
     C                   ELSE
     C                   MOVEL     'DLM0177'     MsgIDArr(Idx)
     C                   ENDIF
      *
     C                   MOVE      'SDAT'        FieldAlpha
     C                   Z-ADD     X             FieldIndex
     C                   EVAL      FldNameArr(Idx) = FieldInErr
     C                   EVAL      OKarr(X)='N'
     C                   GOTO      ValidEnd
     C                   ENDIF
      *
      ** Date must be before the maturity date
      *
     C     InDateMDN     IFGE      PMatDte
     C                   ADD       1             Idx
     C                   MOVE      'Y'           Errorfound
      *
     C     PRtePayInd    Ifeq      'Y'
     C                   MOVEL     'DLM0168'     MsgIDArr(Idx)
     C                   ELSE
     C                   MOVEL     'DLM0178'     MsgIDArr(Idx)
     C                   ENDIF
      *
     C                   MOVE      'SDAT'        FieldAlpha
     C                   Z-ADD     X             FieldIndex
     C                   EVAL      FldNameArr(Idx) = FieldInErr
     C                   EVAL      OKarr(X)='N'
     C                   GOTO      ValidEnd
     C                   ENDIF
      *
      ** Date cannot be less than the control date for principal
      ** change
      *
     C     InDateMDN     IFLT      WCTLDYN
     C     WCTLDYN       ANDGT     0
     C     InDateMDN     ANDGE     Rundate                                                 AR1076900
     C                   ADD       1             Idx
     C                   MOVE      'Y'           Errorfound
     C                   MOVEL     'DLM0176'     MsgIDArr(Idx)
     C                   MOVE      'SDAT'        FieldAlpha
     C                   Z-ADD     X             FieldIndex
     C                   EVAL      FldNameArr(Idx) = FieldInErr
     C                   EVAL      OKarr(X)='N'
     C                   GOTO      ValidEnd
     C                   ENDIF
      *
      ** Action code is 'I' and date already existing on file
      *
     C                   IF         PAction = 'I'
     C     KFRSDV        CHAIN     DLFRSCL0
     C                   IF        %FOUND
     C                   ADD       1             Idx
     C                   MOVE      'Y'           Errorfound
     C                   MOVEL     'DLM0150'     MsgIDArr(Idx)
     C                   MOVE      'SDAT'        FieldAlpha
     C                   Z-ADD     X             FieldIndex
     C                   EVAL      FldNameArr(Idx) = FieldInErr
     C                   EVAL      OKarr(X)='N'
     C                   GOTO      ValidEnd
     C                   ENDIF
     C                   ENDIF
      *
      ** Check if date is a holiday
      *
     C                   Z-ADD     InDateMDN     PZDateIn
     C                   CALLB     'ZCHKH'
     C                   PARM                    PZDateIn
     C                   PARM      PCurrency     PZCcy
     C                   PARM      *BLANK        PZLoc
     C                   PARM      *BLANK        PZHol
      *
      ** If input date is holiday, then 'Confirmed Holiday' indicator must be 'Y'
      ** Else if working day, then 'Confirmed Holiday' indicator must be blank.
      *
     C                   IF        ((PZHol='H') AND (%SUBST(PConfHol:X:1)<>'Y'))
     C                             OR((PZHol='W')AND(%SUBST(PConfHol:X:1)<>' '))
     C                   ADD       1             Idx
     C                   MOVE      'Y'           Errorfound
     C                   MOVEL     'DLM0146'     MsgIDArr(Idx)
     C                   MOVE      'SDAT'        FieldAlpha
     C                   Z-ADD     X             FieldIndex
     C                   EVAL      FldNameArr(Idx) = FieldInErr
     C                   EVAL      OKarr(X)='N'
     C                   GOTO      ValidEnd
     C                   ENDIF
      *
     C     ValidEnd      TAG
      *
      ** If date is valid,
     C     OKarr(X)      IFEQ      'Y'
     C                   Z-ADD     InDateMDN     OutDate(X)
      ** Current date becomes previous date
     C                   Z-ADD     InDateMDN     PrevDate
     C                   EVAL      PPrevDate = PrevDate
     C                   ENDIF
      *
     C                   ENDSR
 
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                                  *
      * SRGetCtlDate - Get Control Date                                  *
      *                                                                  *
      ********************************************************************
 
     C     SRGetCtlDate  BEGSR
      *
      ** Get control date - the first non-processed date
      *
     C                   EVAL      WPRDT = *ZERO
     C                   EVAL      WCTLDYN = *ZERO
      *
     C     KFRSDL        SETLL     DLFRSCD0
     C     KFRSDP        READE     DLFRSCD0                               30
     C                   DOW       (*IN30 = *OFF) AND
     C                             (WCTLDYN = *ZERO)
     C                   IF        HHDTPR <> 'Y'
     C                   Z-ADD     HHPRDT        WCTLDYN
     C                   LEAVE
     C                   ENDIF
     C     KFRSDP        READE     DLFRSCD0                               30
     C                   ENDDO
      *
      ** If nothing was found, default control date to next principal
      ** change date
      *
     C                   IF        (WCTLDYN = *ZERO) AND (PCtlDate <> *ZERO)
     C                   EVAL      WCTLDYN = PCtlDate
     C                   ENDIF
      *
     C                   ENDSR
 
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
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Value date in 5,0 format
     C                   PARM                    PValDte
      *
      ** Maturity date in 5,0 format
     C                   PARM                    PMatDte
      *
      ** Control date in 5,0 format
     C                   PARM                    PCtlDate
      *
      ** Date format indicator
     C                   PARM                    BJDFIN
      *
      ** Action code
     C                   PARM                    PAction
      *
      ** Deal number
     C                   PARM                    PDealNo
      *
      ** Previous date
     C                   PARM                    PPrevDate
      *
      ** Currency
     C                   PARM                    PCurrency
      *
      ** Date Array (max 600) DDMMYY format
     C                   PARM                    PDatesIn
      *
      ** Confirmed Holiday indicator (max 600)
     C                   PARM                    PConfHol
      *
      ** Following parameters are returned to calling module
      ** IRC Dates OK flag
     C                   PARM                    OKInRatCal
      *
      ** Error fields/message IDs (arrays)
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
      *
      ** Array index (3P0)
     C                   PARM                    Idx
      *
      ** Interest Payment or Interest Rate Change
     C                   PARM                    PRtePayInd
      *
      ** Valid dates output (max 600)in daynumber format
     C                   PARM                    PValidDteOut
 
     C     KFRSDV        KLIST
     C                   KFLD                    WDealNo
     C                   KFLD                    POurTheir
     C                   KFLD                    InDateMDN
 
     C     KFRSDL        KLIST
     C                   KFLD                    WDealNo
     C                   KFLD                    POurTheir
     C                   KFLD                    WPRDT
 
     C     KFRSDP        KLIST
     C                   KFLD                    WDealNo
     C                   KFLD                    POurTheir
                                                                                           AR1076900
      **  Get Rundate                                                                      AR1076900
     C     *DTAARA       DEFINE                  RUNDAT                                    AR1076900
     C                   IN        RUNDAT                                                  AR1076900
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values
      *
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2005
