     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate FATCA Existing A/C Date')            *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009521 - Validate FATCA Existing A/C Date                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. CGL154   *CREATE   Date 13Oct14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL154 - FATCA Reporting                                     *
      *                                                               *
      *****************************************************************

     D/COPY ZACPYSRC,STD_D_SPEC
      ** =======
      ** D-specs
      ** =======

      ** Data structure for NewTrntVal string
     D NewTrnTVal      DS           200
     D  DataToVal              1      6

      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

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

      ** Define work field Return code
     D W0RTN           S              7
      ** Define work field Work Screen Date
     D WUWSDT          S              6  0
      ** Define work field Date format flag
     D WUDFF           S              1
      ** Define work field Work File Date
     D WUWFDT          S              5  0
      ** Define work field Work Year Characters
     D WYear           S              6A

      ** Index for arrays of of error message ids etc
     D Idx             S              2P 0

      ** Array of error message IDs
     D MsgIDXArr       S                   DIM(99) LIKE(ErrMsgId)

      *****************************************************************
      /EJECT
      *****************************************************************

     C                   IF        DataToVal <> *BLANKS

      ** Check input for last two chars, if numeric

     C                   EVAL      WYear = %SUBST(DataToVal:1:6)
     C                   TESTN                   WYear                20

     C                   IF        *IN20 = *OFF

     C                   EVAL      GenError = 'Y'
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF

     C                   MOVE      DataToVal     WUWSDT

      ** Check Input Date - Existing Account

     C                   CALL      'ZDATE1'                             90
     C     W0RTN         PARM                    W0RTN
     C     WUWSDT        PARM                    WUWSDT
     C     WUDFF         PARM                    WUDFF
     C     WUWFDT        PARM      *ZERO         WUWFDT

     C                   IF        *IN90 = *ON

      ** Send message '*Error occured on CALL...'

     C                   EVAL      GenError = 'Y'
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF

      ** Return code is an Error

     C                   IF        W0RTN = '*ERROR*'

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

     C                   CALLB     'AOBANKR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY

     C     @RTCD         IFNE      *BLANKS
     C                   EVAL      DBKEY = @OPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ENDIF

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
