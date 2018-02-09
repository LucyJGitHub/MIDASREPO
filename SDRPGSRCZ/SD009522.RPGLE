     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate FATCA End of Year')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009522 - Validate FATCA End of Year Component Run Date     *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL154  *CREATE    Date 13Oct14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL154 - FATCA Reporting                                     *
      *                                                               *
      *****************************************************************
 
     D/COPY ZACPYSRC,STD_D_SPEC
      ** =======
      ** D-specs
      ** =======
 
      ** Data structure for NewTrntVal string
     D NewTrnTVal      DS           200
     D  DataToVal              1      5
 
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
 
      ** Define work field for Day
     D WDay            S              2A
      ** Define work field for Month
     D WMonth          S              3A
      ** Define work field for Month in UpperCase
     D WMonthUp        S              3A
      ** Define work field Input for FATCA End of Year Run Date
     D WFEOYRunD       S              5A
      ** Define work field Month in Number
     D WMonthNo        S              2A
      ** Define work field Day and Month combo
     D WDayMonth       S              4A
      ** Define work field Work Day Characters
     D WDayInt         S              2A
 
      ** Define constant for UpperCase Alphabet
     D Up              C                   CONST('ABCDEFGHIJKLMNOPQRSTUVWXYZ')
      ** Define constant for LowerCase Alphabet
     D Lo              C                   CONST('abcdefghijklmnopqrstuvwxyz')
 
      ** Index for arrays of of error message ids etc
     D Idx             S              2P 0
 
      ** Array of error message IDs
     D MsgIDXArr       S                   DIM(99) LIKE(ErrMsgId)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C                   IF        DataToVal <> *BLANKS
 
      ** Check input for first two chars, if numeric
 
     C                   EVAL      WDayInt = %SUBST(DataToVal:1:2)
     C                   TESTN                   WDayInt              20
 
     C                   IF        *IN20 = *OFF
 
     C                   EVAL      GenError = 'Y'
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   MOVEL     DataToVal     WFEOYRunD
 
      ** Retrieve Input Date (Day and Month combination)
 
     C                   EVAL      WDay = %SUBST(WFEOYRunD:1:2)
     C                   EVAL      WMonth = %SUBST(WFEOYRunD:3:3)
 
     C     Lo:Up         XLATE     WMonth        WMonthUp
 
     C                   SELECT
     C     WMonthUp      WHENEQ    'JAN'
     C                   EVAL      WMonthNo = '01'
     C     WMonthUp      WHENEQ    'FEB'
     C                   EVAL      WMonthNo = '02'
     C     WMonthUp      WHENEQ    'MAR'
     C                   EVAL      WMonthNo = '03'
     C     WMonthUp      WHENEQ    'APR'
     C                   EVAL      WMonthNo = '04'
     C     WMonthUp      WHENEQ    'MAY'
     C                   EVAL      WMonthNo = '05'
     C     WMonthUp      WHENEQ    'JUN'
     C                   EVAL      WMonthNo = '06'
     C     WMonthUp      WHENEQ    'JUL'
     C                   EVAL      WMonthNo = '07'
     C     WMonthUp      WHENEQ    'AUG'
     C                   EVAL      WMonthNo = '08'
     C     WMonthUp      WHENEQ    'SEP'
     C                   EVAL      WMonthNo = '09'
     C     WMonthUp      WHENEQ    'OCT'
     C                   EVAL      WMonthNo = '10'
     C     WMonthUp      WHENEQ    'NOV'
     C                   EVAL      WMonthNo = '11'
     C     WMonthUp      WHENEQ    'DEC'
     C                   EVAL      WMonthNo = '12'
     C                   OTHER
     C                   EVAL      WMonthNo = '00'
     C                   ENDSL
 
      ** Validate Month entered
 
     C                   IF        WMonthNo = '00'
 
     C                   EVAL      GenError = 'Y'
     C                   EVAL       *INLR = *ON
     C                   RETURN
 
     C                   ELSE
 
      ** Concatenate Day / Month combo and proceed to Date check
 
     C                   EVAL      WDayMonth = WDay + WMonthNo
     C                   MOVEL     WDayMonth     WUWSDT
 
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
