     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Validate variable range for system values')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009595 - Validate Variable Ranges for a System Value.      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSC018  *CREATE    Date 25Jun03               *
      *  Prev Amend No. XXXXXX             Date 00Xxx03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSC018 - New program to validate a system value with a       *
      *           variable range.                                     *
      *                                                               *
      *****************************************************************
      ** D-specs
      ** =======
 
      ** Data structure for UserVal string
     D UserVal         DS           200
     D  UserVal01N10           1     10S 0
 
      ** Data structure for AOSVALR0 string
     D SysVal001       DS           200
     D  SVAL001_01_01          1      1
 
      ** Processing mode
     D ProcMode        DS           190
     D  ProcMode11N20         11     20S 0
     D  ProcMode21N30         21     30S 0
     D  ProcMode31_31         31     31
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Program return code
     D @RTCD           S              7
 
      ** Error message id in GBSDUSRMSG
     D ErrMsgId        S              7
 
      ** System value to be processed
     D SystemValue     S             20
 
     D HighAvlJrnRcvT  S             20    INZ('HighAvlJrnRcvThld   ')
     D HighAvlRcvSize  S             20    INZ('HighAvlRcvSizeOption')
 
      ** Parameter variables for AOSVALR0 string
     DRTNCDE           S              7
     DSVALK2           S             20
     DSVAL2            S            200
     DSVALK3           S             20
     DSVAL3            S            200
     DSVALK4           S             20
     DSVAL4            S            200
     DSVALK5           S             20
     DSVAL5            S            200
     DSVALK6           S             20
     DSVAL6            S            200
     DSVALK7           S             20
     DSVAL7            S            200
     DSVALK8           S             20
     DSVAL8            S            200
     DSVALK9           S             20
     DSVAL9            S            200
     DSVALK0           S             20
     DSVAL10           S            200
 
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
 
      * Retrieve the system value
 
     C                   CALL      'AOSVALR0'
     C                   PARM                    RTNCDE
     C                   PARM                    HighAvlRcvSize
     C                   PARM                    SysVal001
     C                   PARM                    SVALK2
     C                   PARM                    SVAL2
     C                   PARM                    SVALK3
     C                   PARM                    SVAL3
     C                   PARM                    SVALK4
     C                   PARM                    SVAL4
     C                   PARM                    SVALK5
     C                   PARM                    SVAL5
     C                   PARM                    SVALK6
     C                   PARM                    SVAL6
     C                   PARM                    SVALK7
     C                   PARM                    SVAL7
     C                   PARM                    SVALK8
     C                   PARM                    SVAL8
     C                   PARM                    SVALK9
     C                   PARM                    SVAL9
     C                   PARM                    SVALK0
     C                   PARM                    SVAL10
 
      * If the system value is not found then issue a database error
 
     C     RTNCDE        IFNE      '       '
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     SystemValue   CASEQ     HighAvlJrnRcvTSRHighAvlJrnR
     C                   END
 
      ** Check for error
 
     C                   IF        @RTCD = '*ERROR'
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'USR4623'     MsgIDXArr(Idx)
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
      ** Catchall for unprocessed errors
 
     C                   IF        @RTCD <> *BLANKS
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Normal end processing
 
     C                   EVAL      GenError = ' '
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      /EJECT
      *****************************************************************
      *  SRHighAvlJrnR - Processing routine for HighAvlJrnRcvThld     *
      *****************************************************************
     C     SRHighAvlJrnR BEGSR
 
      * If the Receiver size option is 1 or 2.
 
     C     ProcMode31_31 IFEQ      'A'
 
     C     SVAL001_01_01 IFEQ      '1'
     C     SVAL001_01_01 OREQ      '2'
 
     C     UserVal01N10  IFLT      ProcMode11N20
     C     UserVal01N10  ORGT      ProcMode21N30
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'USR8852'     MsgIDXArr(Idx)
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      * If the Receiver size option is NOT 1 or 2.
 
     C     ProcMode31_31 IFEQ      'B'
 
     C     SVAL001_01_01 IFNE      '1'
     C     SVAL001_01_01 ANDNE     '2'
 
     C     UserVal01N10  IFLT      ProcMode11N20
     C     UserVal01N10  ORGT      ProcMode21N30
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'USR8853'     MsgIDXArr(Idx)
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *  *INZSR - Program Initialisation routine                      *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** System value to be processed
     C                   PARM                    SystemValue
      ** Value entered by user
     C                   PARM                    UserVal
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
