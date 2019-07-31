     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2018')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Validate BankFusion User Name')               *
      *****************************************************************
      *                                                               *
      *  Midas - Global processing                                    *
      *                                                               *
      *  GP000401 - Validate BankFusion User Name                     *
      *                                                               *
      *  (c) Finastra International Limited 2018                      *
      *                                                               *
      *  Last Amend No. CSD101  *CREATE    Date 07Dec18               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD101 - Password Encryption                                 *
      *                                                               *
      *****************************************************************

     D/COPY ZACPYSRC,STD_D_SPEC
      ** =======
      ** D-specs
      ** =======

      ** SD data area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)

      ** Data structure for NewTrntVal string
     D NewTrnTVal      DS           200
     D  DataToVal              1     50

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

     D PReturnCode     S              7A
     D PAction         S              1A
     D PValidList      S             10A   INZ('SDINTFVL')
     D PLibrary        S             10A
     D PIDName         S            100A
     D PPass1          S            128A
     D PDescr          S           1000A

      *****************************************************************
      /EJECT
      *****************************************************************

      ** Check if ID exists

     C                   IF        DataToVal <> *BLANKS
     C                   EVAL      PLibrary = LIBR + 'DMLIB'
     C                   EVAL      PIDName = 'BANKFUSION_' + DataToVal

     C                   CALL      'SD000404'
     C                   PARM      *Blanks       PReturnCode
     C                   PARM      'F'           PAction
     C                   PARM                    PValidList
     C                   PARM                    PLibrary
     C                   PARM                    PIDName
     C                   PARM      *Blanks       PPass1
     C                   PARM      *Blanks       PDescr

     C                   IF        PReturnCode <> *Blanks
     C                   EVAL      GenError = 'Y'
     C                   EVAL       *INLR = *ON
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXArr(Idx) = 'PWD0020'
     C                   RETURN
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
