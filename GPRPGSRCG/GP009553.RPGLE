     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Validation Program for System Value EqSumConAcType')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Processing Module                           *
      *                                                               *
      *  GP009553 - Validation program for System Value EqSumConAcType*
      *                                                               *
      *  Function: This program will call a new Access object         *
      *            GPAOINSTR0 and check if the value entered by the   *
      *            User in EqSumConAcType exists in Global instrument *
      *            Code file                                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE026 - Consumer Banking                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    U7+U8 -  Database Error                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR      -  Program exception error routine                *
      *  *INZSR     -  Initialisation Subroutine                      *
      *                                                               *
      *  The *INZSR subroutine will only get called automatically     *
      *  on entry to the module the first time it is run              *
      *  (unless you end the program with LR on).  Similarly          *
      *  D-spec initialisation only happens the first time.           *
      *                                                               *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      ** Midas GP Global Instruments code file
     D GPINST        E DS                  EXTNAME(GPINSTPD)
      ** Short Data Structure for Access Objects
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **
      ** Data structure for NewInstVal string
     D NewInstVal      DS           200
     D DataToVal               1     10
 
 
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
 
      ** Return Flag
     D Rflag           S              1
 
      ** Index for arrays of of error message ids etc
     D Idx             S              2P 0
 
      ** Array of error message IDs
     D MsgIDXArr       S                   DIM(99) LIKE(ErrMsgId)
 
     D @RTCD           S              7
     D @OPTN           S              7
     D @GINS           S             10
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - Main processing                                        *
      *                                                               *
      *****************************************************************
      *
      ** Check if the Instrument code entered by the user is defined on
      ** the Global Instrument code file
      *
     C                   CALL      'GPAOINSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      DataToVal     @GINS
     C                   PARM      GPINST        DSFDY
      *
      ** If value entered by user is not found on the Midas Instrument code
      ** file then return an error
      *
     C                   IF        @RTCD = '*NRF'
     C                   EVAL      Rflag = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'USR9006'     MsgIDXArr(Idx)
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
      ** Catch all for unprocessed errors
      *
     C                   IF        @RTCD <> *BLANKS
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Normal end processing
      *
     C                   EVAL      RFlag = ' '
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      *  *INZSR - Initial Subroutine                                 *
      *                                                              *
      *  Called by: Implicitly on program activation                 *
      *                                                              *
      *  Calls: None                                                 *
      *                                                              *
      ****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ** System value to be processed
      *
     C                   PARM                    SystemValue
      *
      ** Value entered by user
      *
     C                   PARM                    NewInstVal
      *
      ** Processing Mode
      *
     C                   PARM                    ProcMode
      *
      ** Return Flag
      *
     C                   PARM                    Rflag
      *
      ** Error message ID (number of entries)
      *
     C                   PARM                    Idx
      *
      ** Error message ID (array)
      *
     C                   PARM                    MsgIDXArr
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *PSSR  - Program exception error routine                     *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   EVAL      RFlag = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
     C                   ENDSR
      ****************************************************************
