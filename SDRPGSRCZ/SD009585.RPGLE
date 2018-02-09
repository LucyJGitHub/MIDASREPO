     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Validate system value ProjectedDaysRetail')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009585 - Validate a Midas System Value for the following:  *
      *             - System value is a number between 1 and 999 incl.*
      *             - System value is <= No of Days Forward.          *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CRE009  *CREATE    Date 12Sep02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE025 - Credit Lines                                        *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CRE009 - Projected Account Movements for RE accounts         *
      *                                                               *
      *****************************************************************
      ** D-specs
      ** =======
 
      ** GL Installation Control Data
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
                                                                                              CLE025
      ** Switchable features                                                                  CLE025
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CLE025
 
      ** Short Data Structure for Access Objects
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Data structure for NewCurrVal string
     D NewCurrVal      DS           200
     D  DataToVal              1      3  0
 
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
                                                                                              CLE025
     D CLE025          S              1                                                       CLE025
     D PRTCD           S              7                                                       CLE025
     D POPTN           S              7                                                       CLE025
     D PSARD           S              6                                                       CLE025
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
 
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** If value entered by user is not in the range 0 to 999 incl
      ** then return an error
 
     C     DataToVal     IFLT      001
     C     DataToVal     ORGT      999
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'USR9516'     MsgIDXArr(Idx)
     C                   ENDIF
 
      ** If value entered by user is not less than or equal to the
      ** 'No of Days Forward' value on GL ICD then return an error
 
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
 
     C                   IF        @RTCD <> *BLANKS
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                              CLE025
     C     CLE025        IFEQ      'Y'                                                        CLE025
                                                                                              CLE025
      ** If number of days forward is less than 9, value entered                              CLE025
      ** by user must be equal to 9                                                           CLE025
                                                                                              CLE025
     C     BKNDFV        IFLT      9                                                          CLE025
     C     DataToVal     IFNE      9                                                          CLE025
     C                   EVAL      GenError = 'Y'                                             CLE025
     C                   ADD       1             Idx                                          CLE025
     C                   MOVEL     'USR4039'     MsgIDXArr(Idx)                               CLE025
     C                   ENDIF                                                                CLE025
                                                                                              CLE025
      ** If number of days forward is greater than or equal to 9,                             CLE025
      ** value entered by user must be between 9 and number of days                           CLE025
      ** forward (inclusive)                                                                  CLE025
                                                                                              CLE025
     C                   ELSE                                                                 CLE025
     C     DataToVal     IFLT      9                                                          CLE025
     C     DataToVal     ORGT      BKNDFV                                                     CLE025
     C                   EVAL      GenError = 'Y'                                             CLE025
     C                   ADD       1             Idx                                          CLE025
     C                   MOVEL     'USR4039'     MsgIDXArr(Idx)                               CLE025
     C                   ENDIF                                                                CLE025
     C                   ENDIF                                                                CLE025
                                                                                              CLE025
      ** CLE025 off                                                                           CLE025
                                                                                              CLE025
     C                   ELSE                                                                 CLE025
 
     C     DataToVal     IFGT      BKNDFV
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'USR9517'     MsgIDXArr(Idx)
     C                   ENDIF
                                                                                              CLE025
     C                   ENDIF                                                                CLE025
 
     C                   EVAL       *INLR = *ON
 
     C                   RETURN
 
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
      *  *INZSR - Program Initialisation routine                      *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** System value to be processed
     C                   PARM                    SystemValue
      ** Value entered by user
     C                   PARM                    NewCurrVal
      ** Processing Mode
     C                   PARM                    ProcMode
      ** General Error Indicator
     C                   PARM                    GenError
      ** Error message ID (number of entries)
     C                   PARM                    Idx
      ** Error message ID (array)
     C                   PARM                    MsgIDXArr
                                                                                              CLE025
      ** Check if enhancement CLE025 (Credit Lines) is on                                     CLE025
                                                                                              CLE025
     C                   CALL      'AOSARDR0'                                                 CLE025
     C                   PARM      *BLANKS       PRTCD                                        CLE025
     C                   PARM      '*VERIFY'     POPTN                                        CLE025
     C                   PARM      'CLE025'      PSARD                                        CLE025
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE025
      *                                                                                       CLE025
     C                   IF        PRTCD = *BLANKS                                            CLE025
     C                   EVAL      CLE025 = 'Y'                                               CLE025
     C                   ELSE                                                                 CLE025
     C                   EVAL      CLE025 = 'N'                                               CLE025
     C                   ENDIF                                                                CLE025
 
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
