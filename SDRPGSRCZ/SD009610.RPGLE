     H DEBUG
     H COPYRIGHT('(c) Misys Wholesale Banking Systems 2006')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Validate Local Inst for a system value')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009610 - Validate a Midas System Value for the following:  *
      *             A valid local institution code                    *
      *                                                               *
      *  (c) Misys Wholesale Banking Systems 2006                     *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSC027 *Create     Date 27Feb06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL041  - Add VAT Details to DL Confirmations.               *
      *            Add a new Built in Function to test that the       *
      *            value entered is a valid Institution Code          *
      *                                                               *
      *****************************************************************
      ** D-specs
      ** =======
 
      ** Midas Institution Codes File
     D SDINST        E DS                  EXTNAME(SDINSTPD)
 
      ** Short Data Structure for Access Objects
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Data structure for NewInstVal string
     D NewInstVal      DS           200
     D  DataToVal              1      2
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message id in GBSDUSRMSG
     D ErrMsgId        S              7
 
      ** System value to be processed
     D SystemValue     S             20
 
      ** Processing mode
     D ProcMode        S            190
 
      ** General error indicator
     D GenError        S              1
 
      ** Index for arrays of of error message ids etc
     D Idx             S              2P 0
 
      ** Array of error message IDs
     D MsgIDXArr       S                   DIM(99) LIKE(ErrMsgId)
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
 
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Check if the Institution Code entered by the user is defined on
      ** the Midas Local Institution Code file.
 
     C                   CALL      'AOINSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM      DataToVal     @PFTC             2
     C                   PARM      SDINST        DSSDY
 
      ** If value entered by user is not found on the Midas Local Institution
      ** file then return an error
 
     C                   IF        @RTCD = '*NRF'
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'USR0027'     MsgIDXArr(Idx)
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
     C                   PARM                    NewInstVal
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
