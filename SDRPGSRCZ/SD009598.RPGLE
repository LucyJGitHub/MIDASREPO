     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Validate SSIDefault_Sec_Check')               *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009598 - Midas SD Validate SSIDefault_Sec_Check            *
      *                                                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. CSD095  *CREATE    Date 09Apr14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *  U7+U8 - Database Error                                       *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR      - Initialisation                                 *
      *  *PSSR       - DB Error Processing                            *
      *                                                               *
      *****************************************************************
 
      ** New current value string
     D NewSysVal       S            200A
 
      ** Error message id in SDUSRMSG
     D ErrMsgId        S              7
 
      ** System value to be processed
     D SystemValue     S             20
 
      ** Processing mode
     D ProcMode        S            190
 
      ** Return Flag
     D Rflag           S              1
 
      ** Index for arrays of error message ids etc
     D Idx             S              2P 0
 
      ** Array of error message IDs
     D MsgIDXArr       S                   DIM(99) LIKE(ErrMsgId)
 
     D P@BRCA          C                   'SSIBranch'
     D P@STYP          C                   'SSIDealSubtype_Trans'
 
     D P@RTCD          S              7
     D P@OP01          S             20
     D P@VL01          S            200
     D P@OP02          S             20
     D P@VL02          S            200
     D P@OP03          S             20
     D P@VL03          S            200
     D P@OP04          S             20
     D P@VL04          S            200
     D P@OP05          S             20
     D P@VL05          S            200
     D P@OP06          S             20
     D P@VL06          S            200
     D P@OP07          S             20
     D P@VL07          S            200
     D P@OP08          S             20
     D P@VL08          S            200
     D P@OP09          S             20
     D P@VL09          S            200
     D P@OP10          S             20
     D P@VL10          S            200
 
     D WUseBR          S              1A
     D WUseST          S             20A
 
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** If new value of SSIDefault_Sec_Check is a non-blank
 
     C                   IF        NewSysVal <> *BLANKS
 
     C                   IF        WUseBR <> 'Y'
     C                             OR WUseST = *BLANKS
     C                   EVAL      Rflag = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXArr(Idx) = 'USR7004'
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   IF        WUseBR = 'Y'
     C                             AND WUseST <> *BLANKS
     C                             AND NewSysVal <> 'B'
     C                             AND NewSysVal <> 'S'
     C                   EVAL      Rflag = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXArr(Idx) = 'USR7005'
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDIF
 
      ** If new value of SSIDefault_Sec_Check is blanks
 
     C                   IF        NewSysVal = *BLANKS
     C                             AND WUseBR = 'Y'
     C                             AND WUseST <> *BLANKS
     C                   EVAL      Rflag = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXArr(Idx) = 'USR7005'
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
      ** Normal end processing
 
     C                   EVAL      RFlag = ' '
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** System value to be processed
     C                   PARM                    SystemValue
      ** Value entered by user
     C                   PARM                    NewSysVal
      ** Processing Mode
     C                   PARM                    ProcMode
      ** Return Flag
     C                   PARM                    RFlag
      ** Error message ID (number of entries)
     C                   PARM                    Idx
      ** Error message ID (array)
     C                   PARM                    MsgIDXArr
 
      ** Get system values for BRCA and STYP display
 
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      P@BRCA        P@OP01
     C                   PARM                    P@VL01
     C                   PARM      P@STYP        P@OP02
     C                   PARM                    P@VL02
     C                   PARM                    P@OP03
     C                   PARM                    P@VL03
     C                   PARM                    P@OP04
     C                   PARM                    P@VL04
     C                   PARM                    P@OP05
     C                   PARM                    P@VL05
     C                   PARM                    P@OP06
     C                   PARM                    P@VL06
     C                   PARM                    P@OP07
     C                   PARM                    P@VL07
     C                   PARM                    P@OP08
     C                   PARM                    P@VL08
     C                   PARM                    P@OP09
     C                   PARM                    P@VL09
     C                   PARM                    P@OP10
     C                   PARM                    P@VL10
      *
     C                   IF        P@RTCD = *BLANKS
     C                   EVAL      WUseBR = P@VL01
     C                   EVAL      WUseST = P@VL02
     C                   ENDIF
 
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
 
     C                   EVAL      RFlag = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
