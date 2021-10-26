     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Check if Midas libraries exist')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000087 - Validate libraries exists for System Value        *
      *             - BrgADBUSystemRefer                              *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. CUT017 *CREATE     Date 17Mar20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUT017 - Adaptive Database Upgrade                           *
      *                                                               *
      *****************************************************************
      ** D-specs
      ** =======
     D SystemValData   DS           200
     D  SystemID               1      2

      ** Program Status Data Structure
     D/COPY GPCPYSRCG,PSDS
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D Cmd_String      S           1160
     D Cmd_Len         S             15  5
     D XLib            S             10

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

      * Build CHKOBJ command.  This looks for DMLIB, DPLIB, DTALIB and DVLIB
     C                   IF        SystemID <> ' '
     C                   EVAL      Cmd_Len = 1160
     C                   EVAL      Cmd_String = *blanks
     C                   EVAL      XLib = SystemID + 'DMLIB'
     C                   EVAL      Cmd_String = CHKOBJ_Cmd +
     C                             XLib +
     C                             OBJTYPEKwrd
     C                   CALL      'QCMDEXC'                            20
     C                   PARM                    Cmd_String
     C                   PARM                    Cmd_Len

      * If the library was not found then send error message.
      *  file then retrieve error message.
     C     PSExcpNo      IFEQ      '9801'
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'BRG0011'     MsgIDXArr(Idx)
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF

     C                   EVAL      XLib = SystemID + 'DPLIB'
     C                   EVAL      Cmd_String = CHKOBJ_Cmd +
     C                             XLib +
     C                             OBJTYPEKwrd
     C                   CALL      'QCMDEXC'                            20
     C                   PARM                    Cmd_String
     C                   PARM                    Cmd_Len

      * If the library was not found then send error message.
      *  file then retrieve error message.
     C     PSExcpNo      IFEQ      '9801'
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'BRG0011'     MsgIDXArr(Idx)
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF

     C                   EVAL      XLib = SystemID + 'DTALIB'
     C                   EVAL      Cmd_String = CHKOBJ_Cmd +
     C                             XLib +
     C                             OBJTYPEKwrd
     C                   CALL      'QCMDEXC'                            20
     C                   PARM                    Cmd_String
     C                   PARM                    Cmd_Len

      * If the library was not found then send error message.
      *  file then retrieve error message.
     C     PSExcpNo      IFEQ      '9801'
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'BRG0011'     MsgIDXArr(Idx)
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF

     C                   EVAL      XLib = SystemID + 'DVLIB'
     C                   EVAL      Cmd_String = CHKOBJ_Cmd +
     C                             XLib +
     C                             OBJTYPEKwrd
     C                   CALL      'QCMDEXC'                            20
     C                   PARM                    Cmd_String
     C                   PARM                    Cmd_Len

      * If the library was not found then send error message.
      *  file then retrieve error message.
     C     PSExcpNo      IFEQ      '9801'
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'BRG0011'     MsgIDXArr(Idx)
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF

     C                   ENDIF

     C                   EVAL      *INLR = *ON

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
