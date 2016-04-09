     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2015')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Validate Branch for Tax Return Sys Value')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009702 - Validate a Midas System Value for the following:  *
      *             - A valid branch code                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2015            *
      *                                                               *
      *  Last Amend No. CRE104  *CREATE    Date 04Mar15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE104 - Modelo 123 and 193 Reports                          *
      *                                                               *
      *****************************************************************
      ** D-specs
      ** =======
 
      ** Midas Branch Codes File
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** Short Data Structure for Access Objects
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Data structure for NewCurrVal string
     D NewBrchVal      DS           200
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
     D ProcMode        S            190
 
      ** General error indicator
     D GenError        S              1
 
      ** Index for arrays of of error message ids etc
     D Idx             S              2P 0
 
      ** Array of error message IDs
     D MsgIDXArr       S                   DIM(99) LIKE(ErrMsgId)
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** AOBRCHR1 parameters
     D @RTCD           S              7A
     D @OPTN           S              7A
     D @PFTC           S              3A
 
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Check if the branch entered by the user is defined on
      ** the Midas branch codes file
 
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      DataToVal     @PFTC
     C                   PARM      SDBRCH        DSSDY
 
      ** If value entered by user is not found on the Midas branch
      ** file then return an error
 
     C                   IF        @RTCD = '*NRF'
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'USS0602'     MsgIDXArr(Idx)
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
      ** If user entered '?', move selected Branch Code back to the
      ** calling program
 
     C                   IF        DataToVal = '? ' OR
     C                             DataToVal = ' ?'
     C                   EVAL      NewBrchVal = @PFTC
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
     C                   PARM                    NewBrchVal
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
