     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2015')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate CRS Effective Start Date')           *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009530 - Validate CRS Effective Start Date                 *
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
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SC Switchable features descriptions
     FSCSARDL0  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
      ** =======
      ** D-specs
      ** =======
 
      ** Data structure for NewTrntVal string
     D NewTrnTVal      DS           200
     D  DataToVal              1      6
 
      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
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
 
      ** Define work field Switch Feature
     D CGL157          S              1A
     D WCGL157         S              6A
 
      ** Define work field Return code
     D W0RTN           S              7
      ** Define work field Work Screen Date
     D WUWSDT          S              6  0
      ** Define work field Date format flag
     D WUDFF           S              1
      ** Define work field Work File Date
     D WUWFDT          S              5  0
 
      ** Index for arrays of of error message ids etc
     D Idx             S              2P 0
 
      ** Array of error message IDs
     D MsgIDXArr       S                   DIM(99) LIKE(ErrMsgId)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C                   IF        DataToVal <> *BLANKS
     C                   MOVE      DataToVal     WUWSDT
 
      ** Check Screen Date - CRS Effective Start Date
 
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
 
      ** Validate input versus core feature implementation date
 
     C                   IF        CGL157 = 'Y'
 
      ** Retrieve Switchable feature CGL157's LCD
 
     C                   EVAL      WCGL157 = 'CGL157'
 
     C     WCGL157       CHAIN     SCSARDL0
 
     C                   IF        ABLCD <> *ZERO
     C                   IF        WUWFDT < ABLCD
 
     C                   EVAL      GenError = 'Y'
     C                   EVAL      Idx = 1
     C                   MOVEL     'USS0581'     MsgIDXArr(Idx)
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
      ** Validate input versus Midas Run Day
 
     C                   ELSE
     C                   IF        WUWFDT < BJRDNB
 
     C                   EVAL      GenError = 'Y'
     C                   EVAL      Idx = 1
     C                   MOVEL     'USS0581'     MsgIDXArr(Idx)
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
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
 
     C                   EVAL      CGL157 = 'N'
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      'CGL157'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   EVAL      DBKEY = @OPTN
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      CGL157 = 'Y'
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
