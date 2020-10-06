     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate Credit This Change Value Date')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVCRDT    - Validate Credit This Change Value Date          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR836982           Date 16May04               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGL029             Date 01Sep03               *
      *                 215208             Date 13Mar03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 180721             Date 03May00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP035  *CREATE    Date 19Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  AR836982 - COB component REC62N failed due to inserted       *
      *             accounts with back valued rate change date.       *
      *             Applied 261452 to prevent rate change date later  *
      *             than date account opened.                         *
      *           - Applied for MD-021848                             *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  215208 - Change value date was not updated for retail a/c.   *
      *           The change value date should be prevented from      *
      *           being earlier than the previous change value date.  *
      *  180721 - Default "Next Statement Date" when opening          *
      *           Account coming from interface                       *
      *         - Retail Account Number must be calculated            *
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

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D*AMCRIB**        S              2S 0                                      CSD103
     DAMCRIB           S              2A                                        CSD103
     DRICICT           S              2S 0
     DRICCST           S              5S 0

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
     C                   Move      DDCRIB        SACRIB            2 0
     C                   MOVE      DDCICT        SACICT            2 0
     C                   MOVE      DDCCST        SACCST            5 0
      *
     C                   ExSr      SrVCRCD
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDCRCDOk      IfEq      'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   EndIf
      *
      ** RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrVCRCD - Validate This Change Value Date                    *
      *****************************************************************
     C     SRVCRCD       BEGSR
      *
     C     SACRIB        IFEQ      AMCRIB
     C     SACRIS        ANDEQ     AMCRIS
     C     SACICT        ANDEQ     RICICT
     C     SACCST        ANDEQ     RICCST
      *
      **  MUST NOT BE ENTERED IF NO INTEREST DETAILS AMENDED
     C     DDCRCD        IFNE      *BLANKS
                                                                                180721
     C     WWID          Ifne      'TO'                                         180721
     C     WWID          Oreq      'TO'                                         180721
     C     DDACTN        Andne     'I'                                          180721
     C                   Move      'N'           DDCRCDOk
     C                   Add       1             Idx
     C                   MoveL     'DDCRCD'      FldNamXAr(Idx)
     C                   MoveL     'RE71309'     MsgIDXAr(Idx)
     C                   ENDIF                                                  180721
     C                   ENDIF
      *
     C                   ELSE
      *
     C     SACRIB        IFNE      AMCRIB
     C     SACRIS        ORNE      AMCRIS
     C     SACICT        ORNE      RICICT
     C     SACCST        ORNE      RICCST
      *                                                                                     AR836982
      ** Convert Date Account Open for validation                                           AR836982
      *                                                                                     AR836982
     C                   CallB     'ZDATE1'                                                 AR836982
     C                   Parm      DDDACO        DateIn            6                        AR836982
     C                   Parm                    ZDAYNO            5 0                      AR836982
     C                   Parm                    BJDFIN                                     AR836982
     C                   Parm                    ErrorFlag         1                        AR836982
     C                   Z-ADD     ZDAYNO        ZDACO             5 0                      AR836982
      *
      ** IF DATE IS NOT ENTERED CHECK ACTION
      ** IF ACTION CODE IS INSERT, USE DDDACO FOR DDCRCD
     C     DDCRCD        IFEQ      *BLANKS
      *
     C     DDACTN        IFEQ      'I'
     C                   Move      DDDACO        DDCRCD
     C                   CallB     'ZDATE1'
     C                   Parm      DDCRCD        DateIn            6
     C                   Parm                    ZDAYNO            5 0
     C                   Parm                    BJDFIN
     C                   Parm                    ErrorFlag         1
     C                   ENDIF
      *
      ** IF ACTION CODE IS AMEND, USE RUNDATE FOR DDCRCD
     C     DDACTN        IFEQ      'A'
     C                   CallB     'ZDATE2'
     C                   Parm      BJRDNB        ZDAYNO            5 0
     C                   Parm                    BJDFIN
     C                   Parm      0             ZDATE             6 0
     C                   Parm      *Blanks       ZADATE            7
     C                   MOVE      ZDATE         DDCRCD
     C                   ENDIF
      *
     C                   ELSE
     C                   CallB     'ZDATE1'
     C                   Parm      DDCRCD        DateIn            6
     C                   Parm                    ZDAYNO
     C                   Parm                    BJDFIN
     C                   Parm                    ErrorFlag         1
     C                   END
      *
     C     ErrorFlag     IfEq      'Y'
     C                   Move      'N'           DDCRCDOk
     C                   Add       1             Idx
     C                   MoveL     'DDCRCD'      FldNamXAr(Idx)
     C                   MoveL     'RE71310'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ** CAN NOT BE FORWARD VALUE DATE.
     C     ZDAYNO        IFGT      BJRDNB
     C                   Move      'N'           DDCRCDOk
     C                   Add       1             Idx
     C                   MoveL     'DDCRCD'      FldNamXAr(Idx)
     C                   MoveL     'RE71311'     MsgIDXAr(Idx)
     C                   END
      *
      ** CAN NOT BE EARLIER BACK VALUE PERIOD ON TABLE FILE.
     C     ZDAYNO        IFLT      WWBKVD
     C                   Move      'N'           DDCRCDOk
     C                   Add       1             Idx
     C                   MoveL     'DDCRCD'      FldNamXAr(Idx)
     C                   MoveL     'RE71315'     MsgIDXAr(Idx)
     C                   END
      *                                                                                     AR836982
      ** Cannot be lower than the Date account opened                                       AR836982
      *                                                                                     AR836982
     C     ZDAYNO        IFLT      ZDACO                                                    AR836982
     C     DDACTN        ANDEQ     'I'                                                      AR836982
     C                   Add       1             Idx                                        AR836982
     C                   MoveL     'DDCRCD'      FldNamXAr(Idx)                             AR836982
     C                   Move      'N'           DDCRCDOk                                   AR836982
     C                   MoveL     'RE71314'     MsgIDXAr(Idx)                              AR836982
     C                   ENDIF                                                              AR836982
      *
      ** CANNOT BE LOWER THAN LIMIT DATE
     C*****ZDAYNO        IFLT      WWVCRC                                                     215208
     C     ZDAYNO        IFLT      AMOLCR                                                     215208
     C                   Add       1             Idx
     C                   MoveL     'RE71313'     MsgIDXAr(Idx)
      *
      ** This change value date cannot be earlier than base rate chg date
      *
     C     WWVCRC        IFGT      AMOLCR
     C     SACICT        IFNE      RICICT
     C     SACCST        ORNE      RICCST
     C     SACRIB        ORNE      AMCRIB
      * Setup message data for message
     C                   CallB     'ZDATE2'
     C                   Parm      WWVCRC        ZDAYNO            5 0
     C                   Parm                    BJDFIN
     C                   Parm      0             ZDATE             6 0
     C                   Parm      *Blanks       ZADATE            7
     C                   MoveL     ZDATE         MsgDtaXAr(Idx)
     C                   MoveL     'RE71239'     MsgIDXAr(Idx)
     C                   END
     C                   END
     C                   Move      'N'           DDCRCDOk
     C                   MoveL     'DDCRCD'      FldNamXAr(Idx)
     C                   END
      *
     C                   END
     C     DDCRCDOk      IfEq      'Y'
     C                   Z-Add     ZDAYNO        WNCRCD
     C                   EndIf
     C                   END
      *
     C                   ENDSR
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
     C                   Parm                    DDCRCD            6
     C                   Parm                    DDACTN            1
     C                   Parm                    DDCRIB            2
     C                   Parm                    SACRIS           11 7
     C                   Parm                    DDCICT            2
     C                   Parm                    DDCCST            5
     C                   Parm                    DDDACO            6
      *
     C                   Parm                    WWVCRC            5 0
      *
     C                   Parm                    AMCRIB
     C                   Parm                    AMCRIS           11 7
     C                   Parm                    AMOLCR            5 0
     C                   Parm                    RICICT
     C                   Parm                    RICCST
      *
      ** ICD
     C                   Parm                    BJRDNB            5 0
     C                   Parm                    BJDFIN            1
     C                   Parm                    WWBKVD            5 0
      * Front Office ID                                                         180721
     C**********         PARM                    APFOTranID       20                   180721 CGL029
     C                   PARM                    APFOTran40       40                          CGL029
      *
      ** OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
      *
     C                   Parm                    WNCRCD            5 0
      *
      ** This Change Value Date - Ok
     C                   Parm                    DDCRCDOk          1
      *                                                                         180721
     C**********         Movel     APFOTranID    WWID              2                   180721 CGL029
     C                   Movel     APFOTran40    WWID              2                          CGL029
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
