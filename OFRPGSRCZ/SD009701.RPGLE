     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2015')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Validate Contact Person System Value')        *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009701 - Validate a Midas System Value for the following:  *
      *             - A Contact Person                                *
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
 
      ** Data structure for NewCurrVal string
     D NewPerson       DS           200
     D  ConPerson              1     40
 
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
 
     D ALLOW           C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ +
     D                                      abcdefghijklmnopqrstuvwxyz'
 
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Special characters are not accepted
 
     C                   IF        %CHECK(ALLOW:%TRIM(ConPerson)) > 0
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'USS0603'     MsgIDXArr(Idx)
     C                   EVAL       *INLR = *ON
     C                   RETURN
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
     C                   PARM                    NewPerson
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
