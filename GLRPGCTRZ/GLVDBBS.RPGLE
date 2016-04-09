     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate debit base rate type')               *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVDBBS    - Validate Debit Base Rate Type                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. AR944106           Date 30Mar12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prev Amend No. CSD006             Date 15May01               *
      *                 180721             Date 16Nov00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP035  *CREATE    Date 19Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR944106 - Incorrect spread as calculated by the system      *
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
     C                   Z-Add     DaynoOut      WWVDRC            5 0
      *
     C     DDDRIB        IFNE      *BLANKS
     C     DDDICT        IfEq      *BLANKS
     C     DDDCST        AndEq     *BLANKS
      *
      ** Get Base Rate Codes
      *
     C                   CALL      'AOBSRTR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    DDCCY
     C                   PARM                    DDDRIB
     C*****SDBSRT        PARM      SDBSRT        DSFDY                          CSD006
     C     SDBSRT        PARM      SDBSRT        DSSDY                          CSD006
     C*
     C     @RTCD         IFNE      *BLANKS
      *
      ** DEBIT BASE RATE DOESN'T EXIST IN FILE TABLE
      *
     C                   Move      'N'           DDDRIBOk
     C                   Add       1             Idx
     C                   MoveL     'DDDRIB'      FldNamXAr(Idx)
     C                   MoveL     'RE71201'     MsgIDXAr(Idx)
      *
     C                   ELSE
     C                   MOVE      BABSRC        DDDRIB
      *
      ** Check currency
     C     BACYCD        IFNE      DDCCY
     C                   Move      'N'           DDDRIBOk
     C                   Add       1             Idx
     C                   MoveL     'DDDRIB'      FldNamXAr(Idx)
     C                   MoveL     'RE71300'     MsgIDXAr(Idx)
     C                   ELSE
      *
     C                   Z-Add     BANBRT        WWDBRT
     C                   Z-ADD     BACBSR        WWBRTT                                     AR944106
      *
      ** Set control date limit for rate value date
     C     BAVDRC        IFGT      WWVDRC
     C                   Z-ADD     BAVDRC        WWVDRC
     C                   END
     C                   END
     C                   END
     C                   END
     C                   ELSE                                                   180721
     C     WValforPB     IfEq      'Y'                                          180721
      *                                                                         180721
     C     DDDICT        IfEq      *BLANKS                                      180721
     C     DDDCST        AndEq     *BLANKS                                      180721
     C     DDDRIS        Orne      *BLANKS                                      180721
     C     DDDICT        AndEq     *BLANKS                                      180721
     C     DDDCST        AndEq     *BLANKS                                      180721
     C                   Move      'N'           DDDRIBOk                       180721
     C                   Add       1             Idx                            180721
     C                   MoveL     'DDDRIB'      FldNamXAr(Idx)                 180721
     C                   MoveL     'RE73000'     MsgIDXAr(Idx)                  180721
     C                   ENDIF                                                  180721
      *                                                                         180721
     C                   ENDIF                                                  180721
     C                   ENDIF                                                  EN01
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDDRIBOk      IfEq      'N'
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
     C                   Parm                    DDDRIB            2
     C                   Parm                    DDCCY             3
     C                   Parm                    DDDACO            6
     C                   Parm                    DDDICT            2
     C                   Parm                    DDDCST            5
     C                   Parm                    DDDRIS           12            180721
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
     C                   Parm                    WWVDRC            5 0
     C                   Parm                    WWDBRT           11 7
     C                   PARM                    WWBRTT           11 7                      AR944106
      *
      ** Base Rate Type - OK
     C                   Parm                    DDDRIBOk          1
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
(c) Misys International Banking Systems Ltd. 2001
