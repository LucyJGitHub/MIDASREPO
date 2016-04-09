     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Check if Midas system ID is valid')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000000 - Validate a Midas System Value for the following:  *
      *             - Midas system prefix                             *
      *             - Global layer prefix                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CPK025  *MOVED     Date 16May06               *
      *  Prev Amend No. CUP099             Date 30May05               *
      *                 CPK018             Date 25Feb04               *
      *                 CUP024  *CREATE    Date 29Sep03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CPK025 - Handle 'Old' system prefixes and move to global     *
      *           layer.                                              *
      *  CUP099 - New system value for old zone (used for migration). *
      *  CPK018 - MidasPlus packaging.  Handle Global layer prefix    *
      *  CUP024 - Migration of Bridge ICD to the System Values file.  *
      *                                                               *
      *****************************************************************
      ** D-specs
      ** =======
     D SystemValData   DS           200
     D  SystemID               1      2
 
      ** Program Status Data Structure
     D*COPY*ZACPYSRC,PSDS*                                                                    CPK025
     D/COPY GPCPYSRCG,PSDS                                                                    CPK025
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
      *
      * Build CHKOBJ command.  This looks for an XLIB on the basis that if
      *  this does not exist then a Midas system does not exist.
     C                   IF        SystemID <> ' '
     C                   EVAL      Cmd_Len = 1160
     C                   EVAL      Cmd_String = *blanks
     C                   IF        SystemValue = 'BrgMidasSystemPrefix'                       CPK018
     C                             or Systemvalue = 'BrgOldZonePrefix'                        CUP099
     C                   EVAL      XLib = SystemID + 'XLIB'
     C                   ENDIF                                                                CPK018
     C                   IF        SystemValue = 'BrgMidasGlobalPrefix'                       CPK018
     C                   EVAL      XLib = SystemID + 'GXLIB'                                  CPK018
     C                   ENDIF                                                                CPK018
     C                   EVAL      Cmd_String = CHKOBJ_Cmd +
     C                             XLib +
     C                             OBJTYPEKwrd
     C                   CALL      'QCMDEXC'                            20
     C                   PARM                    Cmd_String
     C                   PARM                    Cmd_Len
      *
      * If the library was not found then send error message.
      *  file then retrieve error message.
     C     PSExcpNo      IFEQ      '9801'
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   IF        SystemValue = 'BrgMidasSystemPrefix'                       CPK018
     C                   MOVEL     'BRG0005'     MsgIDXArr(Idx)
     C                   ENDIF                                                                CPK018
     C                   IF        SystemValue = 'BrgOldZonePrefix'                           CPK025
     C                   MOVEL     'BRG0005'     MsgIDXArr(Idx)                               CPK025
     C                   ENDIF                                                                CPK025
     C                   IF        SystemValue = 'BrgMidasGlobalPrefix'                       CPK018
     C*****              MOVEL     'BRG0006'     MsgIDXArr(Idx)                        CPK018 CPK025
     C                   MOVEL     'BRG0005'     MsgIDXArr(Idx)                               CPK025
     C                   ENDIF                                                                CPK018
     C                   IF        SystemValue = 'BrgOldGlobalPrefix'                         CPK025
     C                   MOVEL     'BRG0005'     MsgIDXArr(Idx)                               CPK025
     C                   ENDIF                                                                CPK025
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
