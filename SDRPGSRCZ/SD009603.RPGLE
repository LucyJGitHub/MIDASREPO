     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Validate SSIDealsubtype Check')               *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009603 - Midas SD Validate SSIDealsubtype Check            *
      *                                                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2016            *
      *                                                               *
      *  Last Amend No. CSD095CC1 *CREATE   Date 13Sep16              *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD095CC1 - Allow Deal Sub-Type and Branch for IRS, FRA and  *
      *              CCF SSIs                                         *
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
      ** System value to be processed
     D SystemValue     S             20
      ** New current value string
     D NewSysVal       S            200A

      ** Error message id in SDUSRMSG
     D ErrMsgId        S              7

      ** Processing mode
     D ProcMode        S            190

      ** Return Flag
     D Rflag           S              1

      ** Index for arrays of error message ids etc
     D Idx             S              2P 0

      ** Array of error message IDs
     D MsgIDXArr       S                   DIM(99) LIKE(ErrMsgId)

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

     D WSTYPV          DS            20
     D WSTYP1                  1      2
     D WSTYP2                  3      4
     D WSTYP3                  5      6
     D WSTYP4                  7      8
     D WSTYP5                  9     10
     D WSTYP6                 11     12
     D WSTYP7                 13     14
     D WSTYP8                 15     16
     D WSTYP9                 17     18
     D WSTY10                 19     20
      /EJECT

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      ** If value of SSIDealsubtype_trans is a non-blank
     C                   IF        WSTYPV <> *BLANKS
      ** Check for 1st value
     C                   IF        WSTYP1 <> '  '
     C                   IF        WSTYP1 <> 'FX'
     C                              AND WSTYP1 <> 'MM'
     C                              AND WSTYP1 <> 'RS'
     C                              AND WSTYP1 <> 'RX'
     C                              AND WSTYP1 <> 'FR'
     C                              AND WSTYP1 <> 'RF'
     C                              AND WSTYP1 <> 'RP'
     C                              AND WSTYP1 <> 'RR'
     C                   EVAL      Rflag = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXArr(Idx) = 'USR7005'
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C                   ELSE
     C                   EVAL      Rflag = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXArr(Idx) = 'USR7006'
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
      ** Check for 2nd value
     C                   IF        WSTYP2 <> '  '
     C                   IF        WSTYP2 = WSTYP1
     C                   EVAL      Rflag = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXArr(Idx) = 'USR7007'
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ELSE
     C                   IF        WSTYP2 <> 'FX'
     C                              AND WSTYP2 <> 'MM'
     C                              AND WSTYP2 <> 'RS'
     C                              AND WSTYP2 <> 'RX'
     C                              AND WSTYP2 <> 'FR'
     C                              AND WSTYP2 <> 'RF'
     C                              AND WSTYP2 <> 'RP'
     C                              AND WSTYP2 <> 'RR'
     C                   EVAL      Rflag = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXArr(Idx) = 'USR7005'
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C                   MOVE      WSTYPV        WSTY16           16
     C                   IF        WSTY16 <> *BLANKS
     C                   EVAL      Rflag = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXArr(Idx) = 'USR7006'
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
      *
      ** Check for 3rd value
     C                   IF        WSTYP3 <> '  '
     C                   IF        WSTYP3 = WSTYP1
     C                              OR WSTYP3 = WSTYP2
     C                   EVAL      Rflag = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXArr(Idx) = 'USR7007'
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ELSE
     C                   IF        WSTYP1 = *BLANKS
     C                              OR WSTYP2 = *BLANKS
     C                   EVAL      Rflag = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXArr(Idx) = 'USR7006'
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ELSE
     C                   IF        WSTYP3 <> 'FX'
     C                              AND WSTYP3 <> 'MM'
     C                              AND WSTYP3 <> 'RS'
     C                              AND WSTYP3 <> 'RX'
     C                              AND WSTYP3 <> 'FR'
     C                              AND WSTYP3 <> 'RF'
     C                              AND WSTYP3 <> 'RP'
     C                              AND WSTYP3 <> 'RR'
     C                   EVAL      Rflag = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXArr(Idx) = 'USR7005'
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C                   MOVE      WSTYPV        WSTY14           14
     C                   IF        WSTY14 <> *BLANKS
     C                   EVAL      Rflag = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXArr(Idx) = 'USR7006'
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
      *
      ** Check for 4th value
     C                   IF        WSTYP4 <> '  '
     C                   IF        WSTYP4 = WSTYP1
     C                              OR WSTYP4 = WSTYP2
     C                              OR WSTYP4 = WSTYP3
     C                   EVAL      Rflag = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXArr(Idx) = 'USR7007'
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ELSE
     C                   IF        WSTYP1 = *BLANKS
     C                              OR WSTYP2 = *BLANKS
     C                              OR WSTYP3 = *BLANKS
     C                   EVAL      Rflag = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXArr(Idx) = 'USR7006'
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ELSE
     C                   IF        WSTYP4 <> 'FX'
     C                              AND WSTYP4 <> 'MM'
     C                              AND WSTYP4 <> 'RS'
     C                              AND WSTYP4 <> 'RX'
     C                              AND WSTYP4 <> 'FR'
     C                              AND WSTYP4 <> 'RF'
     C                              AND WSTYP4 <> 'RP'
     C                              AND WSTYP4 <> 'RR'
     C                   EVAL      Rflag = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXArr(Idx) = 'USR7005'
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C                   MOVE      WSTYPV        WSTY12           12
     C                   IF        WSTY12 <> *BLANKS
     C                   EVAL      Rflag = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXArr(Idx) = 'USR7006'
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
      *
     ** Check for 5th value
     C                   IF        WSTYP5 <> '  '
     C                   IF        WSTYP5 = WSTYP1
     C                              OR WSTYP5 = WSTYP2
     C                              OR WSTYP5 = WSTYP3
     C                              OR WSTYP5 = WSTYP4
     C                   EVAL      Rflag = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXArr(Idx) = 'USR7007'
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ELSE
     C                   IF        WSTYP1 = *BLANKS
     C                              OR WSTYP2 = *BLANKS
     C                              OR WSTYP3 = *BLANKS
     C                              OR WSTYP4 = *BLANKS
     C                   EVAL      Rflag = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXArr(Idx) = 'USR7006'
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ELSE
     C                   IF        WSTYP5 <> 'FX'
     C                              AND WSTYP5 <> 'MM'
     C                              AND WSTYP5 <> 'RS'
     C                              AND WSTYP5 <> 'RX'
     C                              AND WSTYP5 <> 'FR'
     C                              AND WSTYP5 <> 'RF'
     C                              AND WSTYP5 <> 'RP'
     C                              AND WSTYP5 <> 'RR'
     C                   EVAL      Rflag = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXArr(Idx) = 'USR7005'
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C                   MOVE      WSTYPV        WSTP10           10
     C                   IF        WSTY10 <> *BLANKS
     C                   EVAL      Rflag = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXArr(Idx) = 'USR7006'
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
      *
      ** Check for 6th value
     C                   IF        WSTYP6 <> '  '
     C                   IF        WSTYP6 = WSTYP1
     C                              OR WSTYP6 = WSTYP2
     C                              OR WSTYP6 = WSTYP3
     C                              OR WSTYP6 = WSTYP4
     C                              OR WSTYP6 = WSTYP5
     C                   EVAL      Rflag = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXArr(Idx) = 'USR7007'
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ELSE
     C                   IF        WSTYP1 = *BLANKS
     C                              OR WSTYP2 = *BLANKS
     C                              OR WSTYP3 = *BLANKS
     C                              OR WSTYP4 = *BLANKS
     C                              OR WSTYP5 = *BLANKS
     C                   EVAL      Rflag = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXArr(Idx) = 'USR7006'
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ELSE
     C                   IF        WSTYP6 <> 'FX'
     C                              AND WSTYP6 <> 'MM'
     C                              AND WSTYP6 <> 'RS'
     C                              AND WSTYP6 <> 'RX'
     C                              AND WSTYP6 <> 'FR'
     C                              AND WSTYP6 <> 'RF'
     C                              AND WSTYP6 <> 'RP'
     C                              AND WSTYP6 <> 'RR'
     C                   EVAL      Rflag = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXArr(Idx) = 'USR7005'
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C                   MOVE      WSTYPV        WSTY8             8
     C                   IF        WSTY8 <> *BLANKS
     C                   EVAL      Rflag = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXArr(Idx) = 'USR7006'
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
      *
      ** Check for 7th value
     C                   IF        WSTYP7 <> '  '
     C                   IF        WSTYP7 = WSTYP1
     C                              OR WSTYP7 = WSTYP2
     C                              OR WSTYP7 = WSTYP3
     C                              OR WSTYP7 = WSTYP4
     C                              OR WSTYP7 = WSTYP5
     C                              OR WSTYP7 = WSTYP6
     C                   EVAL      Rflag = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXArr(Idx) = 'USR7007'
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ELSE
     C                   IF        WSTYP1 = *BLANKS
     C                              OR WSTYP2 = *BLANKS
     C                              OR WSTYP3 = *BLANKS
     C                              OR WSTYP4 = *BLANKS
     C                              OR WSTYP5 = *BLANKS
     C                              OR WSTYP6 = *BLANKS
     C                   EVAL      Rflag = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXArr(Idx) = 'USR7006'
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ELSE
     C                   IF        WSTYP7 <> 'FX'
     C                              AND WSTYP7 <> 'MM'
     C                              AND WSTYP7 <> 'RS'
     C                              AND WSTYP7 <> 'RX'
     C                              AND WSTYP7 <> 'FR'
     C                              AND WSTYP7 <> 'RF'
     C                              AND WSTYP7 <> 'RP'
     C                              AND WSTYP7 <> 'RR'
     C                   EVAL      Rflag = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXArr(Idx) = 'USR7005'
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C                   MOVE      WSTYPV        WSTY6             6
     C                   IF        WSTY6 <> *BLANKS
     C                   EVAL      Rflag = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXArr(Idx) = 'USR7006'
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
      *
      ** Check for 8th value
     C                   IF        WSTYP8 <> '  '
     C                   IF        WSTYP8 = WSTYP1
     C                              OR WSTYP8 = WSTYP2
     C                              OR WSTYP8 = WSTYP3
     C                              OR WSTYP8 = WSTYP4
     C                              OR WSTYP8 = WSTYP5
     C                              OR WSTYP8 = WSTYP6
     C                              OR WSTYP8 = WSTYP7
     C                   EVAL      Rflag = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXArr(Idx) = 'USR7007'
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ELSE
     C                   IF        WSTYP1 = *BLANKS
     C                              OR WSTYP2 = *BLANKS
     C                              OR WSTYP3 = *BLANKS
     C                              OR WSTYP4 = *BLANKS
     C                              OR WSTYP5 = *BLANKS
     C                              OR WSTYP6 = *BLANKS
     C                              OR WSTYP7 = *BLANKS
     C                   EVAL      Rflag = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXArr(Idx) = 'USR7006'
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ELSE
     C                   IF        WSTYP8 <> 'FX'
     C                              AND WSTYP8 <> 'MM'
     C                              AND WSTYP8 <> 'RS'
     C                              AND WSTYP8 <> 'RX'
     C                              AND WSTYP8 <> 'FR'
     C                              AND WSTYP8 <> 'RF'
     C                              AND WSTYP8 <> 'RP'
     C                              AND WSTYP8 <> 'RR'
     C                   EVAL      Rflag = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXArr(Idx) = 'USR7005'
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C                   MOVE      WSTYPV        WSTY4             4
     C                   IF        WSTY4 <> *BLANKS
     C                   EVAL      Rflag = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXArr(Idx) = 'USR7006'
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
      *
      ** Check for 9th value
     C                   IF        WSTYP9 <> '  '
     C                   IF        WSTYP9 = WSTYP1
     C                              OR WSTYP9 = WSTYP2
     C                              OR WSTYP9 = WSTYP3
     C                              OR WSTYP9 = WSTYP4
     C                              OR WSTYP9 = WSTYP5
     C                              OR WSTYP9 = WSTYP6
     C                              OR WSTYP9 = WSTYP7
     C                              OR WSTYP9 = WSTYP8
     C                   EVAL      Rflag = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXArr(Idx) = 'USR7007'
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ELSE
     C                   IF        WSTYP1 = *BLANKS
     C                              OR WSTYP2 = *BLANKS
     C                              OR WSTYP3 = *BLANKS
     C                              OR WSTYP4 = *BLANKS
     C                              OR WSTYP5 = *BLANKS
     C                              OR WSTYP6 = *BLANKS
     C                              OR WSTYP7 = *BLANKS
     C                              OR WSTYP8 = *BLANKS
     C                   EVAL      Rflag = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXArr(Idx) = 'USR7006'
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ELSE
     C                   IF        WSTYP9 <> 'FX'
     C                              AND WSTYP9 <> 'MM'
     C                              AND WSTYP9 <> 'RS'
     C                              AND WSTYP9 <> 'RX'
     C                              AND WSTYP9 <> 'FR'
     C                              AND WSTYP9 <> 'RF'
     C                              AND WSTYP9 <> 'RP'
     C                              AND WSTYP9 <> 'RR'
     C                   EVAL      Rflag = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXArr(Idx) = 'USR7005'
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C                   MOVE      WSTYPV        WSTY2             2
     C                   IF        WSTY2 <> *BLANKS
     C                   EVAL      Rflag = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXArr(Idx) = 'USR7006'
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
      *
      ** Check for 10th value
     C                   IF        WSTY10 <> '  '
     C                   IF        WSTY10 = WSTYP1
     C                              OR WSTY10 = WSTYP2
     C                              OR WSTY10 = WSTYP3
     C                              OR WSTY10 = WSTYP4
     C                              OR WSTY10 = WSTYP5
     C                              OR WSTY10 = WSTYP6
     C                              OR WSTY10 = WSTYP7
     C                              OR WSTY10 = WSTYP8
     C                              OR WSTY10 = WSTYP9
     C                   EVAL      Rflag = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXArr(Idx) = 'USR7007'
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ELSE
     C                   IF        WSTYP1 = *BLANKS
     C                              OR WSTYP2 = *BLANKS
     C                              OR WSTYP3 = *BLANKS
     C                              OR WSTYP4 = *BLANKS
     C                              OR WSTYP5 = *BLANKS
     C                              OR WSTYP6 = *BLANKS
     C                              OR WSTYP7 = *BLANKS
     C                              OR WSTYP8 = *BLANKS
     C                              OR WSTYP9 = *BLANKS
     C                   EVAL      Rflag = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXArr(Idx) = 'USR7006'
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ELSE
     C                   IF        WSTYP9 <> 'FX'
     C                              AND WSTYP9 <> 'MM'
     C                              AND WSTYP9 <> 'RS'
     C                              AND WSTYP9 <> 'RX'
     C                              AND WSTYP9 <> 'FR'
     C                              AND WSTYP9 <> 'RF'
     C                              AND WSTYP9 <> 'RP'
     C                              AND WSTYP9 <> 'RR'
     C                   EVAL      Rflag = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXArr(Idx) = 'USR7005'
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
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

      ** Value entered by user
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

      ** Get system values for STYP display

     C*                  CALL      'AOSVALR0'
     C*                  PARM      *BLANKS       P@RTCD
     C*                  PARM      P@STYP        P@OP01
     C*                  PARM                    P@VL01
     C*                  PARM                    P@OP02
     C*                  PARM                    P@VL02
     C*                  PARM                    P@OP03
     C*                  PARM                    P@VL03
     C*                  PARM                    P@OP04
     C*                  PARM                    P@VL04
     C*                  PARM                    P@OP05
     C*                  PARM                    P@VL05
     C*                  PARM                    P@OP06
     C*                  PARM                    P@VL06
     C*                  PARM                    P@OP07
     C*                  PARM                    P@VL07
     C*                  PARM                    P@OP08
     C*                  PARM                    P@VL08
     C*                  PARM                    P@OP09
     C*                  PARM                    P@VL09
     C*                  PARM                    P@OP10
     C*                  PARM                    P@VL10
      *
     C*                  IF        P@RTCD = *BLANKS
     C                   EVAL      WSTYPV = NewSysval
     C*                  ENDIF

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
