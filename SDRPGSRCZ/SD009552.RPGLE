     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Dummy system value validation')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009552 - Dummy system value validation                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Note: This program is a dummy program to allow free format   *
      *        text to be entered into a system value.                *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSC018             Date 25Jun03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *  Prev Amend No. CSD013  *CREATE    Date 12Sep02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSC018 - High Availability Enhancements:                     *
      *           - Extend processing mode from 10 to 190.            *
      *  CSD013 - New program for the System Valuse Development.      *
      *                                                               *
      *****************************************************************
      ** D-specs
      ** =======
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Data structure for NewCurrVal string
     D NewCurrVal      S            200
 
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
