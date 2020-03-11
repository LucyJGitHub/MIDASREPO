     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2019')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Validate MT94xFld25Dstn Sysval')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009587 - Validate MT94xFld25Dstn system value.             *
      *                                                               *
      *  (c) Finastra International Limited 2019                      *
      *                                                               *
      *  Last Amend No. CMG006  *CREATE    Date 14Jan20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CMG006 - Account identification of MT940 and MT942.          *
      *                                                               *
      *---------------------------------------------------------------*

      ** Customer Details File
     FSDCUSTL7  IF   E           K DISK    INFSR(*PSSR)

      *****************************************************************
      /EJECT
      *****************************************************************

      ** D-specs
      ** =======

      ** Data structure for NewDstnVal string
     D NewDstnVal      DS           200
     D  DataToVal              1     12

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

      ** Index for arrays of error message ids etc
     D Idx             S              2P 0

      ** Array of error message IDs
     D MsgIDXArr       S                   DIM(99) LIKE(ErrMsgId)
      ** Define work field SWIFT destination
     D WCSID           S             12

      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      * Key for SDCUSTL7
     C                   IF        DataToVal <> *BLANKS
     C                   MOVE      DataToVal     WCSID

     C     WCSID         Chain     SDCUSTL7

     C                   If        Not %Found(SDCUSTL7)
     C                   Add       1             Idx
     C                   Movel     'SDM0236'     MsgIDXArr(Idx)
     C                   Eval      GenError = 'Y'
     C                   Eval       *INLR = *ON
     C                   Return
     C                   Endif

     C                   ENDIF

      ** Normal end processing

     C                   Eval      GenError = ' '
     C                   Eval      *INLR = *ON

     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - Program Initialisation routine                      *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST

      ** System value to be processed
     C                   PARM                    SystemValue
      ** Value entered by user
     C                   PARM                    NewDstnVal
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
