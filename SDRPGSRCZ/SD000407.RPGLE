     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2019')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Validate PEA System Username system value')   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000407 - Validate a Midas PEA System Username system value *
      *                                                               *
      *  (c) Finastra International Limited 2019                      *
      *                                                               *
      *  Last Amend No. CSD101             Date 07Dec18               *
      *  Prev Amend No. MDnnnnn            Date ddMmmyy               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD101 - Password Encryption                                 *
      *                                                               *
      *****************************************************************

      ** =======
      ** D-specs
      ** =======

      ** SD data area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)

      ** Short Data Structure for Access Objects
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Data structure for NewTrntVal string
     D NewTrnTVal      DS           200
     D  DataToVal              1     25

     D PReturnCode     S              7A
     D PAction         S              1A
     D PValidList      S             10A   INZ('SDINTFVL')
     D PLibrary        S             10A
     D PIDName         S            100A
     D PPass1          S            128A
     D PDescr          S           1000A
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

     D @RTCD           S              7
     D @OPTN           S              7
     D @PFTC           S              5

      *****************************************************************
      /EJECT
      *****************************************************************

      ** Check if the PEA User is defined in Validation List
     C                   IF        DataToVal <> *Blanks
     C                   EVAL      PLibrary = LIBR + 'DMLIB'
     C                   EVAL      PIDName = 'PEA_' + DataToVal

     C                   CALL      'SD000404'
     C                   PARM      *Blanks       PReturnCode
     C                   PARM      'F'           PAction
     C                   PARM                    PValidList
     C                   PARM                    PLibrary
     C                   PARM                    PIDName
     C                   PARM      *Blanks       PPass1
     C                   PARM      *Blanks       PDescr

      ** Return an error if PEA User is not found from Validation List
     C                   IF        PReturnCode <> *Blanks
     C                   ADD       1             Idx
     C                   MOVEL     'PWD0015'     MsgIDXArr(Idx)
     C                   EVAL      GenError = 'Y'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF

      ** Catch all for unprocessed errors
     C                   IF        PReturnCode <> *Blanks
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF

      ** Normal end processing

     C                   EVAL      GenError = ' '
     C                   EVAL      *INLR = *ON

     C                   RETURN

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
     C                   PARM                    NewTrntVal
      ** Processing Mode
     C                   PARM                    ProcMode
      ** General Error Indicator
     C                   PARM                    GenError
      ** Error message ID (number of entries)
     C                   PARM                    Idx
      ** Error message ID (array)
     C                   PARM                    MsgIDXArr

     C                   IN        SDSTAT

     C                   ENDSR

      *****************************************************************
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

