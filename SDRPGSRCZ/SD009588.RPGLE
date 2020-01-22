     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2019')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Validate MT94xFld25Prefix Sysval')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009588 - Validate MT94xFld25Prefix System value.             *
      *                                                               *
      *  (c) Finastra International Limited 2019                      *
      *                                                               *
      *  Last Amend No. CMG006  *CREATE    Date 15Oct19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CMG006 - MT940, 941, 942 & 950 Field 25 Account              *
      *           Identification.                                     *
      *                                                               *
      *---------------------------------------------------------------*
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+ *
 
      ** D-specs
      ** =======
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Valid Alpha Numeric Codes
     D AlpNumChar      S              1    DIM(36) CTDATA PERRCD(36) 
     
      ** Data structure for NewDstnVal string
     D NewFld25Prfx    DS           200
     D  DataToVal              1      4
 
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
      ** Define work field 
     D WCPREF          S              4A   
     D WWrk            S              1A
     D I               S              3S 0
 
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      * Key for SDCUSTL7
     C                   IF        DataToVal <> *BLANKS
     C                   MOVE      DataToVal     WCPREF
     
      ** Check WAlpNum for alphanumeric codes and no embedded blanks
     C                   Z-ADD     1             I 
     C                   DOW       I <= 3
     C                   EVAL      WWrk = %SUBST(WCPREF:I:1)
     C                   If        %LOOKUP(WWrk:AlpNumChar) = 0
     C                   EVAL      Idx = Idx + 1
     C                   MOVEL     'SDM0235'     MsgIDXArr(Idx)
     C                   Eval      GenError = 'Y'
     C                   Eval       *INLR = *ON
     C                   Return
     C                   ENDIF
     C                   EVAL      I = I + 1
     C                   ENDDO                
     
     C                   EVAL      WWrk = %SUBST(WCPREF:4:1)
     C                   If        WWrk <> '-'
     C                   Add       1             Idx
     C                   Movel     'SDM0235'     MsgIDXArr(Idx)
     C                   Eval      GenError = 'Y'
     C                   Eval       *INLR = *ON
     C                   Return
     C                   Endif
 
     C                   ENDIF 
     
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
     C                   PARM                    NewFld25Prfx
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
      *****************************************************************
      /EJECT
      *****************************************************************   
**  AlpNumChar
ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
