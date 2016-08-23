     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Validate FTRetStatusOP and FTRetStatusIP sysvals')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009586 - Validate FTRetStatusOP and FTRetStatusIP          *
      *             system values.                                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. CFT158   *CREATE   Date 13Nov14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT158 - Return Status of Interfaced FT Payments             *
      *                                                               *
      *---------------------------------------------------------------*
 
      ** Deal type/subtype file
     FFDDTSTL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** SD Deal sub-types file
     FSDDLSTL0  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** D-specs
      ** =======
 
      ** Data structure for NewCurrVal string
     D NewCurrVal      DS           200
     D  UserVala               1    100
 
     D ArrStyp         S              2A   DIM(50)
 
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
 
      ** Index for arrays of error message ids etc
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
 
      * Key for SDDTSTL0
     C     KEY01         KLIST
     C                   KFLD                    KSTPE             2
 
      * Key for FDDTSTL0
     C     KEY02         KLIST
     C                   KFLD                    KTYPE             2
     C                   KFLD                    KSTPE             2
 
      * (1) Validate entry does not exceed 50 subtype values.
     C                   If        %len(%trim(NewCurrVal)) > 100
     C                   Eval      GenError = 'Y'
     C                   Add       1             Idx
     C                   Movel     'SDM0200'     MsgIDXArr(Idx)
     C                   Eval       *INLR = *ON
     C                   Return
     C                   Endif
 
     C                   Movea     UserVala      ArrStyp
 
     C                   Z-Add     1             Wctr              2 0
     C                   Z-Add     0             Wctr2             2 0
     C                   Z-Add     0             X                 2 0
 
      * Repeat for 50 times
     C                   Dow       Wctr <= 50
     C                   Move      ArrStyp(Wctr) KSTPE
 
     C                   IF        KSTPE = *BLANKS
     C                   EVAL      Wctr2 = Wctr2 + 1
     C                   ELSE
 
     C     KEY01         Chain     SDDLSTL0
 
     C                   If        Not %Found(SDDLSTL0)
     C                   Add       1             Idx
     C                   If        SystemValue = 'FTRetStatusOP'
     C                   Movel     'SDM0201'     MsgIDXArr(Idx)
     C                   Endif
     C                   If        SystemValue = 'FTRetStatusIP'
     C                   Movel     'SDM0202'     MsgIDXArr(Idx)
     C                   Endif
     C                   Eval      GenError = 'Y'
     C                   Eval       *INLR = *ON
     C                   Return
     C
     C                   Else
      * (2) Ensure valid type/subtype combination
     C                   If        SystemValue = 'FTRetStatusOP'
     C                   Eval      KTYPE = 'OP'
     C     KEY02         Chain     FDDTSTL0
     C                   Endif
     C                   If        SystemValue = 'FTRetStatusIP'
     C                   Eval      KTYPE = 'IN'
     C     KEY02         Chain     FDDTSTL0
     C                   Endif
 
     C                   If        Not %Found(FDDTSTL0)
     C                   Eval      GenError = 'Y'
     C                   Add       1             Idx
     C                   If        SystemValue = 'FTRetStatusOP'
     C                   Movel     'SDM0201'     MsgIDXArr(Idx)
     C                   Endif
     C                   If        SystemValue = 'FTRetStatusIP'
     C                   Movel     'SDM0202'     MsgIDXArr(Idx)
     C                   Endif
     C                   Eval       *INLR = *ON
     C                   Return
     C
     C                   Else
      * (3) Ensure no blank gap in entry
     C                   If        Wctr2 <> 0
     C                   Eval      GenError = 'Y'
     C                   Add       1             Idx
     C                   Movel     'SDM0204'     MsgIDXArr(Idx)
     C                   Eval       *INLR = *ON
     C                   Return
     C                   Else
     c                   If        Wctr > 1
     C                   Eval      X = %LOOKUP(KSTPE:ArrStyp:1:Wctr-1)
      * (3) Ensure no duplicate subtype has been entered.
     C                   If        X <> 0
     C                   Eval      GenError = 'Y'
     C                   Add       1             Idx
     C                   Movel     'SDM0203'     MsgIDXArr(Idx)
     C                   Eval       *INLR = *ON
     C                   Return
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Eval      Wctr2 = 0
     C                   Endif
     C                   Eval      Wctr = Wctr + 1
     C                   Enddo
 
 
      ** Normal end processing
 
     C                   Eval      GenError = ' '
     C                   Eval      *INLR = *ON
 
     C                   Return
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
     C                   PARM                    NewCurrVal
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
