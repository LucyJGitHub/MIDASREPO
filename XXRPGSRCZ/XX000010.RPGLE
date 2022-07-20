     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2022')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas XX Validate EML115 Narrative Code')              *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  XX000010 - Midas XX Validate EML115 Narrative Code           *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. EML115  *CREATE    Date 13Jun22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  EML115 - Negative Credit Interest Narrative Change           *
      *                                                               *
      *****************************************************************
      ** D-specs
      ** =======
      ** DS for Access Objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      **  External data structure for Narrative Codes Details
     D SDNARR        E DS                  EXTNAME(SDNARRPD)

      ** Data structure for UserVal string
     D UserVal         DS           200
     D  Subsystem              1     10
     D  UserVal1_1             1      1
     D  UserVal2_1             2      2


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

     D NarrCodeSysVal  S             20    INZ('NegCredIntNarrCode')

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

      * Validate the system value only if not blanks

     C     UserVal       IFNE      *BLANKS
     C     SystemValue   CASEQ     NarrCodeSysValSRNarrCode
     C                   END
     C                   END

      ** Normal end processing

     C                   EVAL      GenError = ' '
     C                   EVAL      *INLR = *ON

     C                   RETURN
      /EJECT
      *****************************************************************
      *  SRNarrCode - Processing routine for NegCredIntNarrCode       *
      *****************************************************************
     C     SRNarrCode    BEGSR

     C                   IF        UserVal1_1 < 'A' or  UserVal1_1 > '9'
     C                             or UserVal2_1 < 'A' or  UserVal2_1 > '9'
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'XXX9066'     MsgIDXArr(Idx)
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ELSE
     C                   EVAL      PNRCD = UserVal
     C                   CALL      'AONARRR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM                    PNRCD             2
     C     SDNARR        PARM      SDNARR        DSFDY

     C                   IF        PRTCD = '*NRF   '
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'USR9742'     MsgIDXArr(Idx)
     C                   EVAL       *INLR = *ON
     C                   RETURN
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
