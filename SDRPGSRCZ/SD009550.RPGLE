     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Validate currency for a system value')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009550 - Validate a Midas System Value for the following:  *
      *             - A valid currency code (Mode = 'CURRENCY')       *
      *             - A valid dealing ccy (Mode = 'DLCURRENCY')       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSC018             Date 25Jun03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 CSD013   *CREATE   Date 12Sep02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSC018 - High Availability Enhancements:                     *
      *           - Extend processing mode from 10 to 190.            *
      *  CSD013 - New program for the System Values Development.      *
      *                                                               *
      *****************************************************************
      ** D-specs
      ** =======
 
      ** Midas Currency File
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Long Data Structure for Access Objects
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Data structure for NewCurrVal string
     D NewCurrVal      DS           200
     D  DataToVal              1      3
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message id in GBSDUSRMSG
     D ErrMsgId        S              7
 
      ** System value to be processed
     D SystemValue     S             20
 
      ** Processing mode
     D*ProcMode******  S             10                                                       CSC018
     D ProcMode        S            190                                                       CSC018
 
      ** General error indicator
     D GenError        S              1
 
      ** Index for arrays of of error message ids etc
     D Idx             S              2P 0
 
      ** Array of error message IDs
     D MsgIDXArr       S                   DIM(99) LIKE(ErrMsgId)
 
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Check if the currency code entered by the user is defined on
      ** the Midas currencies file
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM      DataToVal     @CCY              3
     C                   PARM      SDCURR        DSSDY
 
      ** If value entered by user is not found on the Midas currencies
      ** file then return an error
 
     C                   IF        @RTCD = '*NRF'
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'USR9524'     MsgIDXArr(Idx)
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
      ** If the record is present on the Midas currencies file then peform
      ** further checks
 
      ** Mode 'CURRENCY' - Valid currency (no further checking required)
 
     C                   IF        ProcMode = 'CURRENCY  '
     C                   EVAL      GenError = ' '
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
      ** Mode 'DLCURRENCY' - Valid dealing currency (check Dealing Ccy Flag)
      ** and return an error if the flag in not 'Y'
 
     C     ProcMode      IFEQ      'DLCURRENCY'
     C     A6DLCI        ANDNE     'Y'
     C                   EVAL      GenError = 'Y'
     C                   MOVEL     'USR9525'     MsgIDXArr(Idx)
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
      ** Catchall for unprocessed errors
 
     C                   IF        @RTCD <> *BLANKS
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Normal end processing
 
     C                   EVAL      GenError = ' '
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      /EJECT
      *****************************************************************
      *  *INZSR - Program Initialisation routine                      *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** System value to be processed
     C                   PARM                    SystemValue
      ** Value entered by user
     C                   PARM                    NewCurrVal
      ** Processing Mode
     C                   PARM                    ProcMode
      ** General Error Indicator
     C                   PARM                    GenError
      ** Error message ID (number of entries)
     C                   PARM                    Idx
      ** Error message ID (array)
     C                   PARM                    MsgIDXArr
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   EVAL      GenError = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
     C                   ENDSR
