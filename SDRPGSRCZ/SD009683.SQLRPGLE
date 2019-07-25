     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2016')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SD Access Audit system value valdn')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009683 - SD Access Audidt system value validation          *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Note: This program validates UserEnqAccessAudit system value *
      *                                                               *
      *  Last Amend No. CGL183  *Create    Date 09Dec16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL183 - User Access Audit of Account Enquiry functions      *
      *                                                               *
      *****************************************************************
      ** D-specs
      ** =======
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Data structure for NewCurrVal string
     D                 DS
     D NewCurrVal              1    200
     D DataToVal               1      4
     D DataToVl1               1      1
     D DataToVl2               2      2
     D DataToVl3               3      3
     D DataToVl4               4      4
     D DataToValO              5    200

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

      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

     C                   Eval      GenError = ' '

     C                   If        DataToVal = *BLANKS

     C                   Eval      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'USR4617'     MsgIDXArr(Idx)
     C                   Eval       *INLR = *On

     C                   Else

     C                   If        DataToVl1 <> 'Y' and
     C                             DataToVl1 <> 'N'
     C                             or DataToVl2 <> 'Y' and
     C                             DataToVl2 <> 'N'
     C                             or DataToVl3 <> 'Y' and
     C                             DataToVl3 <> 'N'
     C                             or DataToVl4 <> 'Y' and
     C                             DataToVl4 <> 'N'
     C                   Eval      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'USR4237'     MsgIDXArr(Idx)
     C                   Eval       *INLR = *On
     C                   Return
     C                   Endif

     C                   Endif

     C                   If        DataToValO <> *BLANKS
     C                   Eval      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'USR9625'     MsgIDXArr(Idx)
     C                   Eval       *INLR = *On
     C                   Endif

      ** End processing

     C                   Eval      *INLR = *On

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
     C                   PARM                    PNewCurrVal     200
      ** Processing Mode
     C                   PARM                    ProcMode
      ** General Error Indicator
     C                   PARM                    GenError
      ** Error message ID (number of entries)
     C                   PARM                    Idx
      ** Error message ID (array)
     C                   PARM                    MsgIDXArr

     C                   Eval       NewCurrVal = PNewCurrVal

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
