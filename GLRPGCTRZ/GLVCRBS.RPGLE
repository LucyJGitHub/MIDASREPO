     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate credit base rate type')              *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVCRBS    - Validate Credit Base Rate Type                  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR944106           Date 30Mar12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 215884             Date 04Jun03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 15May01               *
      *                 180721             Date 16Nov00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP035  *CREATE    Date 19Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  AR944106 - Incorrect spread as calculated by the system      *
      *  215884 - Wrong error message shown when amending/inserting   *
      *           an account with Base Rate type that doesn't exist.  *
      *  CSD006 - Use long DS with SDBSRTPD.                          *
      *  180721 - Review Validation of Base Rate Type (DR & CR)       *
      *           for PB Customer's retail accounts                   *
      *  CAP035 - Midas/ToF Interface                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)

      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)

      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)

      ** Base Rate Code Details
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)

      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Second DS for access programs, long data structure                     CSD006
     D DSSDY         E DS                  EXTNAME(DSSDY)                       CSD006

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      ** Initialization

     C                   MoveL     *Blanks       RetCodeIn
     C                   MoveL     *Blanks       FldNamXAr
     C                   MoveL     *Blanks       MsgIDXAr
     C                   MoveL     *Blanks       MsgDtaXAr
     C                   Z-Add     0             Idx
      *
     C                   CallB     'ZDATE1'
     C                   Parm      DDDAcO        DateIn            6
     C                   Parm      *Zero         DaynoOut          5 0
     C                   Parm                    BJDFIN
     C                   Parm                    ErrorFlag         1
      *
     C                   Z-Add     DaynoOut      WWVCRC            5 0
      *
     C     DDCRIB        IFNE      *BLANKS
     C     DDCICT        IfEq      *BLANKS
     C     DDCCST        AndEq     *BLANKS
      *
      ** Get Base Rate Codes
      *
     C                   CALL      'AOBSRTR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    DDCCY
     C                   PARM                    DDCRIB
     C*****SDBSRT        PARM      SDBSRT        DSFDY                          CSD006
     C     SDBSRT        PARM      SDBSRT        DSSDY                          CSD006
     C*
     C     @RTCD         IFNE      *BLANKS
      *
      ** CREDIT BASE RATE DOESN'T EXIST IN FILE TABLE
      *
     C                   Move      'N'           DDCRIBOk
     C                   Add       1             Idx
     C                   MoveL     'DDCRIB'      FldNamXAr(Idx)
     C**********         MoveL     'RE71301'     MsgIDXAr(Idx)                                215884
     C                   MoveL     'RE71337'     MsgIDXAr(Idx)                                215884
      *
     C                   ELSE
     C                   MOVE      BABSRC        DDCRIB
      *
      ** Check currency
     C     BACYCD        IFNE      DDCCY
     C                   Move      'N'           DDCRIBOk
     C                   Add       1             Idx
     C                   MoveL     'DDCRIB'      FldNamXAr(Idx)
     C                   MoveL     'RE71300'     MsgIDXAr(Idx)
     C                   ELSE
      *
     C                   Z-Add     BANBRT        WWCBRT
     C                   Z-ADD     BACBSR        WWBRTT                                     AR944106
      *
      ** Set control date limit for rate value date
     C     BAVDRC        IFGT      WWVCRC
     C                   Z-ADD     BAVDRC        WWVCRC
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ELSE                                                   180721
     C     WValforPB     IfEq      'Y'                                          180721
      *                                                                         180721
     C     DDCICT        IfEq      *BLANKS                                      180721
     C     DDCCST        AndEq     *BLANKS                                      180721
     C     DDCRIS        Orne      *BLANKS                                      180721
     C     DDCICT        AndEq     *BLANKS                                      180721
     C     DDCCST        AndEq     *BLANKS                                      180721
     C                   Move      'N'           DDCRIBOk                       180721
     C                   Add       1             Idx                            180721
     C                   MoveL     'DDCRIB'      FldNamXAr(Idx)                 180721
     C                   MoveL     'RE73000'     MsgIDXAr(Idx)                  180721
     C                   ENDIF                                                  180721
      *                                                                         180721
     C                   ENDIF                                                  180721
     C                   EndIf
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDCRIBOk      IfEq      'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   EndIf
      *
      ** RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *Entry        Plist
      *
      ** INPUTS
      *
      ** Return Code
     C                   Parm                    RetCodeIn
      *
      ** Account Screen fields
     C                   Parm                    DDCRIB            2
     C                   Parm                    DDCCY             3
     C                   Parm                    DDDACO            6
     C                   Parm                    DDCICT            2
     C                   Parm                    DDCCST            5
     C                   Parm                    DDCRIS           12            180721
      *
      ** ICD
     C                   Parm                    BJDFIN            1
      *                                                                         180721
      ** Supplemental Validation for PB Customer (Y/N)                          180721
     C                   Parm                    WValforPB         1            180721
      *
      ** OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
      *
     C                   Parm                    WWVCRC            5 0
     C                   Parm                    WWCBRT           11 7
     C                   PARM                    WWBRTT           11 7                      AR944106
      *
      ** Base Rate Type - OK
     C                   Parm                    DDCRIBOk          1
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

     C/COPY ZACPYSRC,DBFIELDS

     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
