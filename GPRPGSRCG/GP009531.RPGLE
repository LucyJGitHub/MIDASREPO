     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2015')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Validate CRS High Value Currency')            *
      *****************************************************************
      *                                                               *
      *  Midas -  Global Processing Module                            *
      *                                                               *
      *  GP009531 - Validate CRS High Value Currency                  *
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *  Last Amend No. CGL157   *CREATE   Date 17Aug15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL157 - CRS Reporting                                       *
      *                                                               *
      *****************************************************************

     D/COPY ZACPYSRC,STD_D_SPEC
      ** =======
      ** D-specs
      ** =======

      ** Data structure for NewTrntVal string
     D NewTrnTVal      DS           200
     D  DataToVal              1      3

      ** Midas Global Currency File
     D GPCURR        E DS                  EXTNAME(GPCURRPD)

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

      ** Define work field Parameters
     D PRtcd           S              7A
     D POptn           S              7A
     D PCurr           S              3A
      ** Define work field Work Currency
     D WCCY            S              3A

      ** Parameters for GPACSCURR
     D I#RTCD          S              7A
     D I#ERMS          S             50A
     D I#CCY           S              3A

      ** Index for arrays of of error message ids etc
     D Idx             S              2P 0

      ** Array of error message IDs
     D MsgIDXArr       S                   DIM(99) LIKE(ErrMsgId)

      *****************************************************************
      /EJECT
      *****************************************************************

     C                   IF        DataToVal <> *BLANKS

      ** Check input, if numeric send error

     C                   EVAL      WCCY = %SUBST(DataToVal:1:3)
     C                   TESTN                   WCCY                 20

     C                   IF        *IN20 = *ON

     C                   EVAL      GenError = 'Y'
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF

      ** Check if the currency code entered by the user is defined on
      ** the Midas Global currencies file
     C                   CALL      'GPACSCURR'
     C                   PARM      *BLANKS       I#RTCD
     C                   PARM                    I#ERMS
     C                   PARM      DataToVal     I#CCY
     C                   PARM                    GPCURR

      ** If value entered by user is not found on the Midas Global
      ** currencies file then return an error
     C                   IF        GCSPRT = 0
     C                   EVAL      GenError = 'Y'
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF

     C                   ELSE

      ** Send message when field for date is blank

     C                   EVAL      GenError = 'Y'
     C                   EVAL       *INLR = *ON
     C                   RETURN

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

      *****************************************************************
      /EJECT
      *****************************************************************
