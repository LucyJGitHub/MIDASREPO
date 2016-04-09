     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Global Check if Midas system ID is valid')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GP009550 - Global Validation of Midas System Value for the   *
      *             Midas system prefix                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. BUG6598            Date 19May05               *
      *  Prev Amend No. CGP001  *CREATE    Date 26Mar04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG6598 - Changed XLIB to GXLIB to indicate global library   *
      *  CGP001 - Global Layer processing                             *
      *                                                               *
      *****************************************************************
      ** D-specs
      ** =======
     D SystemValData   DS           200
     D  SystemID               1      2
 
      ** Program Status Data Structure
     D*COPY*ZACPYSRC,PSDS*
     D/COPY GPCPYSRCG,PSDS
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D Cmd_String      S           1160
     D Cmd_Len         S             15  5
     D XLib            S             10
 
      ** Error message id in GPUSRMSG
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
 
     D CHKOBJ_Cmd      C                   'CHKOBJ OBJ('
      *
     D OBJTYPEKwrd     C                   ') OBJTYPE(*LIB)'
      *
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      * Build CHKOBJ command.  This looks for an XLIB on the basis that if
      *  this does not exist then a Midas system does not exist.
     C                   IF        SystemID <> ' '
     C                   EVAL      Cmd_Len = 1160
     C                   EVAL      Cmd_String = *blanks
     C**********         EVAL      XLib = SystemID + 'XLIB'                                  BUG6598
     C                   EVAL      XLib = SystemID + 'GXLIB'                                 BUG6598
     C                   EVAL      Cmd_String = CHKOBJ_Cmd +
     C                             XLib +
     C                             OBJTYPEKwrd
     C                   CALL      'QCMDEXC'                            20
     C                   PARM                    Cmd_String
     C                   PARM                    Cmd_Len
      *
      * If the library was not found then send error message.
      *  file then retrieve error message.
     C     PSExcpNo      IFNE      ' '
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'GPM1000'     MsgIDXArr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      /EJECT
      *****************************************************************
      *  *INZSR - Program Initialisation routine                      *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      * System value to be processed
     C                   PARM                    SystemValue
      * Value entered by user
     C                   PARM                    SystemValData
      * Processing Mode
     C                   PARM                    ProcMode
      * General Error Indicator
     C                   PARM                    GenError
      * Error message ID (number of entries)
     C                   PARM                    Idx
      * Error message ID (array)
     C                   PARM                    MsgIDXArr
      *
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
      *
     C                   DUMP
      *
     C                   EVAL      GenError = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
