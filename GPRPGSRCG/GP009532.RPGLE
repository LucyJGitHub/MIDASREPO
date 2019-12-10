     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2015')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Validate CRS High/Low Value Amount')          *
      *****************************************************************
      *                                                               *
      *  Midas -  Global Processing Module                            *
      *                                                               *
      *  GP009532 - Validate CRS High/Low Value Amount                *
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *  Last Amend No. MD054605           Date 17Oct19               *
      *  Prev Amend No. CGL157   *CREATE   Date 19Aug15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054605 - Deliverable Data Split for SDSVALPD               *
      *  CGL157 - CRS Reporting                                       *
      *                                                               *
      *****************************************************************

     D/COPY ZACPYSRC,STD_D_SPEC
      ** =======
      ** D-specs
      ** =======

      ** Data structure for NewTrntVal string
     D NewTrnTVal      DS           200
     D  DataToVal              1     13

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
     D POptn           S              7A
     D PCurr           S              3A

      ** Define work field Work Amount
     D WDataToVal      S             13A

      ** Define work field Work High Value
     D WHighVal        S             13A

      ** Define work field Work High Value
     D WLowVal         S             13A

      ** Define work field Work Retrieved Value
     D WRtvVal1        S             13A

      ** Parameters for GPAOSVALR0
     D PRtcd           S              7A
     D PSValK1         S             20A
     D PSValK2         S             20A
     D PSValK3         S             20A
     D PSValK4         S             20A
     D PSValK5         S             20A
     D PSValK6         S             20A
     D PSValK7         S             20A
     D PSValK8         S             20A
     D PSValK9         S             20A
     D PSValK10        S             20A
     D PSVal3          S            200A
     D PSVal4          S            200A
     D PSVal5          S            200A
     D PSVal6          S            200A
     D PSVal7          S            200A
     D PSVal8          S            200A
     D PSVal9          S            200A
     D PSVal10         S            200A
      *
     D PSVal1          DS           200
     D  PSVal113               1     13
     D PSVal2          DS           200
     D  PSVal213               1     13

      ** Parameters for ZALIGN
     D ZRTN            S              7
     D ZFIELD          S             16
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
     D ZAFLD           S             16

      ** Index for arrays of of error message ids etc
     D Idx             S              2P 0

      ** Array of error message IDs
     D MsgIDXArr       S                   DIM(99) LIKE(ErrMsgId)

      *****************************************************************
      /EJECT
      *****************************************************************

      ** Check Input System Value if Low Value

     C                   EVAL      ZADIG = 13
     C                   EVAL      ZADEC = 0
     C                   EVAL      WLowVal = *ZERO
     C                   EVAL      WHighVal = *ZERO
     C                   EVAL      WRtvVal1 = *BLANKS
     C                   EVAL      WRtvVal1 = *ZERO

      ** Check amount, if not numeric send error
     C                   EVAL      ZFIELD = DataToVal
     C                   EXSR      SRAlgAmount

      ** Invalid amount
     C                   IF        ZRTN <> *BLANKS
     C                   EVAL      GenError = 'Y'
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF

     C                   IF        ZFIELD <> *ZERO

     C                   IF        SystemValue = 'CRSLowValAmount'

     C                   EVALR     WLowVal =  %TRIM(DataToVal)

      ** Validate against CRS High Value Amount - Entity

     C                   EVAL      PSValK1 = 'CRSHighValAmtEnt'
     C                   EXSR      SrRtvSVAL
     C                   IF        WLowVal >= WRtvVal1
     C                   EVAL      GenError = 'Y'
     C                   EVAL      Idx = 1
     C                   MOVEL     'GPM0513'     MsgIDXArr(Idx)
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF

      ** Validate against CRS High Value Amount - Individual

     C                   EVAL      PSValK1 = 'CRSHighValAmtInd'
     C                   EXSR      SrRtvSVAL
     C                   IF        WLowVal >= WRtvVal1
     C                   EVAL      GenError = 'Y'
     C                   EVAL      Idx = 1
     C                   MOVEL     'GPM0513'     MsgIDXArr(Idx)
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF

     C                   ELSE

      ** Check Input System Value if High Value

     C                   EVALR     WHighVal = %TRIM(DataToVal)
     C                   EVAL      PSValK1 = 'CRSLowValAmount'
     C                   EXSR      SrRtvSVAL
     C                   IF        WHighVal <= WRtvVal1
     C                   EVAL      GenError = 'Y'
     C                   EVAL      Idx = 1
     C                   MOVEL     'GPM0512'     MsgIDXArr(Idx)
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF

      ** Normal end processing

     C                   EVAL      GenError = ' '
     C                   EVAL      *INLR = *ON

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAlgAmount - Align amount                                   *
      *                                                               *
      *  Called by: MAIN                                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRAlgAmount   BEGSR
      *
      ** Align amount
     C                   CALL      'ZALIGN'
     C                   PARM      *BLANKS       ZRTN
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
     C                   PARM                    ZAFLD
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRtvSVAL - Subroutine to get the High or Low Value Amount   *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls    : AOSVALR0                                          *
      *                                                               *
      *****************************************************************

     C     SrRtvSVAL     BEGSR

      ** Call Access Program for System Value


     C                   CALL      'GPAOSVALR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM                    PSValK1
     C                   PARM                    PSVal1
     C                   PARM      *BLANKS       PSValK2
     C                   PARM                    PSVal2
     C                   PARM      *BLANKS       PSValK3
     C                   PARM                    PSVal3
     C                   PARM      *BLANKS       PSValK4
     C                   PARM                    PSVal4
     C                   PARM      *BLANKS       PSValK5
     C                   PARM                    PSVal5
     C                   PARM      *BLANKS       PSValK6
     C                   PARM                    PSVal6
     C                   PARM      *BLANKS       PSValK7
     C                   PARM                    PSVal7
     C                   PARM      *BLANKS       PSValK8
     C                   PARM                    PSVal8
     C                   PARM      *BLANKS       PSValK9
     C                   PARM                    PSVal9
     C                   PARM      *BLANKS       PSValK10
     C                   PARM                    PSVal10

      ** Handle Database Error

     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 2
     C**********         EVAL      DBFILE = 'GPSVALPD'                                      MD054605
     C                   EVAL      DBFILE = 'GPSVLJW0'                                      MD054605
     C                   EVAL      DBKEY = PSValK1
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   ELSE

      ** Retrieve value amount
     C                   EVALR     WRtvVal1 =  %TRIM(PSVal113)
     C                   ENDIF

     C                   ENDSR

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
