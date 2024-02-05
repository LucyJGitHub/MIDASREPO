     H DEBUG
     H COPYRIGHT('(c) Finastra Systems Technology Inc. 2024')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Validate length of MT202DLFld53B_72')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  XX116001 - Validate a Midas System Value for the following:  *
      *             - Length of field = 8                             *
      *                                                               *
      *  (c) Finastra Systems Technology Inc. 2024                    *
      *                                                               *
      *  Last Amend No. EML116   *Create   Date 30Jan24               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  EML116 - MT202 Field 53B Update                              *
      *                                                               *
      *****************************************************************
      ** D-specs
      ** =======

      ** Long Data Structure for Access Objects
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** Data structure for NewCurrVal string
     D NewCurrVal      DS           200
     D  DataToVal              1      8

      ** +--------------------------------------+
      ** ? Declared variables                   ?
      ** ? ==================                   ?
      ** +--------------------------------------+

      ** Error message id in GBSDUSRMSG
     D ErrMsgId        S              7

      ** System value to be processed
     D SystemValue     S             20

      ** Processing mode
     D ProcMode        S            190                                                       CSC018

      ** General error indicator
     D GenError        S              1

      ** Index for arrays of of error message ids etc
     D Idx             S              2P 0

      ** Array of error message IDs
     D MsgIDXArr       S                   DIM(99) LIKE(ErrMsgId)

     D @DTA            S              1    DIM(8) CTDATA PERRCD(1)

      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ?                                                                ?
      ** ? Initial processing is performed automatically: the *INZSR is   ?
      ** ? executed at program activation.                                ?
      ** ?                                                                ?
      ** +----------------------------------------------------------------+

     C                   MoveA     DatatoVal     @DTA
     C     ' '           LOOKUP    @DTA                                   26

     C                   If        DataToVal = *Blanks
     C                             Or *IN26 = *On
     C                   Eval      GenError = 'Y'
     C                   Add       1             Idx
     C                   Movel     'XXX1160'     MsgIDXArr(Idx)
     C                   Eval       *INLR = *ON
     C                   Return
     C                   Endif


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
