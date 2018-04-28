     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate Debit This Change Value Date')       *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVDBDT    - Validate Debit This Change Value Date           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD000091           Date 07May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CGL029             Date 01Sep03               *
      *                 215208             Date 13Mar03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 180721             Date 03May00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP035  *CREATE    Date 19Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD000091 - Event Codes Substitution                          *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  215208 - The change value date was not updated for retail    *
      *           a/c. Should prevent change value date entry which   *
      *           is earlier than the previous change value date.     *
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
     DAMDRIB           S              2S 0
     DRIDICT           S              2S 0
     DRIDCST           S              5S 0
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
                                                                                            MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
 
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
     C                   Move      DDDRIB        SADRIB            2 0
     C                   MOVE      DDDICT        SADICT            2 0
     C                   MOVE      DDDCST        SADCST            5 0
      *
     C                   ExSr      SrVDRCD
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDDRCDOk      IfEq      'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   EndIf
      *
      ** RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrVDRCD - Validate This Change Value Date                    *
      *****************************************************************
     C     SRVDRCD       BEGSR
      *
     C     SADRIB        IFEQ      AMDRIB
     C     SADRIS        ANDEQ     AMDRIS
     C     SADICT        ANDEQ     RIDICT
     C     SADCST        ANDEQ     RIDCST
      *
      **  MUST NOT BE ENTERED IF NO INTEREST DETAILS AMENDED
     C     DDDRCD        IFNE      *BLANKS
                                                                                180721
     C     WWID          Ifne      'TO'                                         180721
     C     WWID          Oreq      'TO'                                         180721
     C     DDACTN        Andne     'I'                                          180721
     C                   Move      'N'           DDDRCDOk
     C                   Add       1             Idx
     C                   MoveL     'DDDRCD'      FldNamXAr(Idx)
     C                   MoveL     'RE71209'     MsgIDXAr(Idx)
     C                   ENDIF                                                  180721
     C                   ENDIF
      *
     C                   ELSE
      *
     C     SADRIB        IFNE      AMDRIB
     C     SADRIS        ORNE      AMDRIS
     C     SADICT        ORNE      RIDICT
     C     SADCST        ORNE      RIDCST
      *
      ** IF DATE IS NOT ENTERED CHECK ACTION
      ** IF ACTION CODE IS INSERT, USE DDDACO FOR DDDRCD
     C     DDDRCD        IFEQ      *BLANKS
      *
     C     DDACTN        IFEQ      'I'
     C                   CallB     'ZDATE1'
     C                   Parm      DDDACO        DateIn            6
     C                   Parm                    ZDAYNO            5 0
     C                   Parm                    BJDFIN
     C                   Parm                    ErrorFlag         1
     C                   ENDIF
      *
      ** IF ACTION CODE IS AMEND, USE RUNDATE FOR DDDRCD
     C     DDACTN        IFEQ      'A'
     C                   CallB     'ZDATE2'
     C                   Parm      BJRDNB        ZDAYNO
     C                   Parm                    BJDFIN
     C                   Parm      0             ZDATE             6 0
     C                   Parm      *Blanks       ZADATE            7
     C                   MOVE      ZDATE         DDDRCD
     C                   ENDIF
      *
     C                   ELSE
     C                   CallB     'ZDATE1'
     C                   Parm      DDDRCD        DateIn            6
     C                   Parm                    ZDAYNO
     C                   Parm                    BJDFIN
     C                   Parm                    ErrorFlag         1
     C                   END
      *
     C     ErrorFlag     IfEq      'Y'
     C                   Move      'N'           DDDRCDOk
     C                   Add       1             Idx
     C                   MoveL     'DDDRCD'      FldNamXAr(Idx)
     C                   MoveL     'RE71210'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ** CAN NOT BE FORWARD VALUE DATE.
     C     ZDAYNO        IFGT      BJRDNB
     C                   Move      'N'           DDDRCDOk
     C                   Add       1             Idx
     C                   MoveL     'DDDRCD'      FldNamXAr(Idx)
     C                   MoveL     'RE71211'     MsgIDXAr(Idx)
     C                   END
      *
      ** CAN NOT BE EARLIER BACK VALUE PERIOD ON TABLE FILE.
     C     ZDAYNO        IFLT      WWBKVD
     C                   Move      'N'           DDDRCDOk
     C                   Add       1             Idx
     C                   MoveL     'DDDRCD'      FldNamXAr(Idx)
     C                   MoveL     'RE71215'     MsgIDXAr(Idx)
     C                   END
      *
      ** CANNOT BE LOWER THAN LIMIT DATE
     C*****ZDAYNO        IFLT      WWVDRC                                                     215208
     C     ZDAYNO        IFLT      AMOLDR                                                     215208
     C                   Add       1             Idx
     C                   MoveL     'RE71213'     MsgIDXAr(Idx)
      *
      ** This change value date cannot be earlier than base rate chg date
      *
     C     WWVDRC        IFGT      AMOLDR
     C     SADICT        IFNE      RIDICT
     C     SADCST        ORNE      RIDCST
     C     SADRIB        ORNE      AMDRIB
      * Setup message data for message
     C                   CallB     'ZDATE2'
     C                   Parm      WWVDRC        ZDAYNO            5 0
     C                   Parm                    BJDFIN
     C                   Parm      0             ZDATE             6 0
     C                   Parm      *Blanks       ZADATE            7
     C**********         MoveL     ZDATE         MsgDtaXAr(Idx)                             MD000091
     C                   MoveL     ZDATE         MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(MsgDtaTmp)                MD000091
     C                   MoveL     'RE71239'     MsgIDXAr(Idx)
     C                   END
     C                   END
     C                   Move      'N'           DDDRCDOk
     C                   MoveL     'DDDRCD'      FldNamXAr(Idx)
     C                   END
      *
     C                   END
     C                   END
     C     DDDRCDOk      IfEq      'Y'
     C                   Z-Add     ZDAYNO        WNDRCD
     C                   EndIf
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
     C                   Parm                    DDDRCD            6
     C                   Parm                    DDACTN            1
     C                   Parm                    DDDRIB            2
     C                   Parm                    SADRIS           11 7
     C                   Parm                    DDDICT            2
     C                   Parm                    DDDCST            5
     C                   Parm                    DDDACO            6
      *
     C                   Parm                    WWVDRC            5 0
      *
     C                   Parm                    AMDRIB
     C                   Parm                    AMDRIS           11 7
     C                   Parm                    AMOLDR            5 0
     C                   Parm                    RIDICT
     C                   Parm                    RIDCST
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
     C                   Parm                    WNDRCD            5 0
      *
      ** This Change Value Date - Ok
     C                   Parm                    DDDRCDOk          1
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
(c) Misys International Banking Systems Ltd. 2001
