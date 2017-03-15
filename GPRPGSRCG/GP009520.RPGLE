     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2015')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Validate FATCA Report Version')               *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  GP009520 - Validate FATCA Report Version                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2015            *
      *                                                               *
      *  Last Amend No. CGL154  *CREATE    Date 13Oct14               *
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
     D  DataToVal              1      3

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Error message id in GPUSRMSG
     D ErrMsgId        S              7

      ** System value to be processed
     D SystemValue     S             20

      ** Processing mode
     D ProcMode        S            190

      ** General error indicator
     D GenError        S              1

      ** Define work for 1st Character
     D WNo1            S              1A
      ** Define work field for 2nd Character - Period
     D WPeriod         S              1A
      ** Define work for 2nd Character
     D WNo2            S              1A
      ** Define work field Work Input FATCA Version
     D WReptVer        S              3A

      ** Define constant for Period Separator
     D ConsPeriod      C                   CONST('.')

      ** Index for arrays of of error message ids etc
     D Idx             S              2P 0

      ** Array of error message IDs
     D MsgIDXArr       S                   DIM(99) LIKE(ErrMsgId)

      *****************************************************************
      /EJECT
      *****************************************************************

     C                   IF        DataToVal <> *BLANKS
     C                   MOVEL     DataToVal     WReptVer

      ** Get each character from the Input for FATCA Report Version

     C                   EVAL      WNo1 = %SUBST(WReptVer:1:1)
     C                   EVAL      WPeriod = %SUBST(WReptVer:2:1)
     C                   EVAL      WNo2  = %SUBST(WReptVer:3:1)

      ** Validate 2nd Character if Period

     C                   IF        WPeriod <> ConsPeriod

     C                   EVAL      GenError = 'Y'
     C                   EVAL       *INLR = *ON
     C                   RETURN

     C                   ENDIF

      ** Validate 1st and 3rd Character if Numeric

     C                   IF        %CHECK('0123456789':WNo1) <> 0 OR
     C                             %CHECK('0123456789':WNo2) <> 0

     C                   EVAL      GenError = 'Y'
     C                   EVAL       *INLR = *ON
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
