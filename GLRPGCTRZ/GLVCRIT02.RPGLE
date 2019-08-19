     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate credit interest calc. type/subtp')   *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVCRIT02  - Validate Credit Interest Calc. Type/Subtype     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD053611           Date 19Aug19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CER055             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG5525            Date 26Jan05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 15May01               *
      * Midas DBA 3.02 -----------------------------------------------*
      *  Prev Amend No. CAP035  *CREATE    Date 19Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD053611 - Add validation when changing the interest         *
      *             calculation type.                                 *
      *  MD046248 - Finastra Rebranding                               *
      *  CER055 - Penalty Interest on Exceeding Overdraft Limit       *
      *  BUG5525 - Check for Spread Rate not equal to blank only since*
      *            sign is always defaulted to '+' by BUG4859.        *
      *  CSD006 - Use long DS with SDBSRTPD.                          *
      *  CAP035 - Midas/ToF Interface                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************

      ** RE Interest Sub-types file
     FREINT     IF   E           K DISK    INFSR(*PSSR)
     FREIAC     IF   E           K DISK    INFSR(*PSSR)                                     MD053611
     F                                     IGNORE(REIACAF)                                  MD053611
     F                                     IGNORE(REIACZF)                                  MD053611

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
                                                                                              CER055
      ** REINT Balance array                                                                  CER055
     D BAL             DS                                                                     CER055
     D  ZIBC                   1     88P 0 DIM(11)                                            CER055

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
     D MegDtaXAr       S                   like(#msgdata)

      ** Array of Fields in Warning.                                            MD053611
     D WFldNmXAr       S             10A   DIM(XArrayMax)                       MD053611

      ** Array of warning message IDs                                           MD053611
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)          MD053611

      ** Array of warning message data.                                         MD053611
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)        MD053611

     D                 DS
     D  KEY                    1     12
     D  BLANC                  1      1    INZ(' ')
     D  ICTYPE                 2      3
     D  ICSTYP                 4      8
     D  ICCCY                  9     11
     D  D                     12     12    INZ('D')

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
     D WIx             S              3P 0                                                  MD053611
      **                                                                                    MD053611
     D BChar           DS                                                                   MD053611
     D   BLen                  1      2B 0                                                  MD053611
     D   LenStr                1      2                                                     MD053611
     D   MsgDtaTmp                   99                                                     MD053611

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
     C                   Z-Add     0             Idx
     C                   Z-Add     1             WIx                                       MD053611
     C     *BLANKS       LOOKUP    WFldNmXAr(WIx)                         99               MD053611
     C     *IN99         IFEQ      '1'                                                     MD053611
     C                   SUB       1             WIx                                       MD053611
     C                   ENDIF                                                             MD053611
      *
     C     DDCICT        IFNE      *BLANKS
     C     DDCCST        ORNE      *BLANKS
      *
      **  NOT ALLOWED IF BASE RATE TYPE IS NOT BLANKS
     C     DDCRIB        IFNE      *BLANKS
     C                   Move      'N'           DDCICTOk
     C                   Move      'N'           DDCCSTOk
     C                   Add       1             Idx
     C                   MoveL     'DDCICT'      FldNamXAr(Idx)
     C                   MoveL     'RE71305'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      **  NOT ALLOWED IF RATE/SPREAD IS NOT BLANKS
     C     DDCRIS        IFNE      *BLANKS
     C*****DDCSIG        ORNE      *BLANKS                                                   BUG5525
     C                   Move      'N'           DDCICTOk
     C                   Move      'N'           DDCCSTOk
     C                   Add       1             Idx
     C                   MoveL     'DDCICT'      FldNamXAr(Idx)
     C                   MoveL     'RE71306'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      **  MANDATORY IF INTEREST CALC. TYPE IS ENTERED.
     C     DDCCST        IFEQ      *BLANKS
     C                   Move      'N'           DDCICTOk
     C                   Move      'N'           DDCCSTOk
     C                   Add       1             Idx
     C                   MoveL     'DDCICT'      FldNamXAr(Idx)
     C                   MoveL     'RE71307'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      **  IF INTEREST CALC. TYPE IS NOT BLANK.                                              MD053611
     C     Key_REIAC     KLIST                                                              MD053611
     C                   KFLD                    CNUM                                       MD053611
     C                   KFLD                    CCY                                        MD053611
     C                   KFLD                    ACOD                                       MD053611
     C                   KFLD                    ACSQ                                       MD053611
     C                   KFLD                    BRCA                                       MD053611
      *                                                                                     MD053611
     C                   MOVE      DDCUSN        CNUM                                       MD053611
     C                   MOVE      DDCCY         CCY                                        MD053611
     C                   MOVE      DDACOD        ACOD                                       MD053611
     C                   MOVE      DDACSQ        ACSQ                                       MD053611
     C                   MOVE      DDBRCA        BRCA                                       MD053611
      *                                                                                     MD053611
     C     Key_REIAC     CHAIN     REIAC                                                    MD053611
     C                   IF        %FOUND(REIAC)                                            MD053611
     C                   MOVE      CICT          TCICT             2                        MD053611
     C     DDCICT        IFNE      TCICT                                                    MD053611
      **                                                                                    MD053611
     C     CICT          IFEQ      1                                                        MD053611
     C     CICT          OREQ      2                                                        MD053611
     C     DDCICT        IFEQ      '03'                                                     MD053611
     C     DDCICT        OREQ      '04'                                                     MD053611
     C                   MOVE      'N'           DDCICTOk                                   MD053611
     C                   MOVE      'N'           DDCCSTOk                                   MD053611
     C                   ADD       1             WIx                                        MD053611
     C                   MOVEL     'RET1557'     WMsgIDXAr(WIx)                             MD053611
     C                   MOVEL     'DDCICT'      WFldNmXAr(WIx)                             MD053611
     C                   EVAL      BLen = %Len(%Trim(TCICT))                                MD053611
     C                   EVAL      MsgDtaTmp = LenStr +%Trim(TCICT)                         MD053611
     C                   EVAL      BLen = %Len(%Trim(DDCICT))                               MD053611
     C                   EVAL      WMsgDtXAr(WIx) = %TRIM(MsgDtaTmp) + LenStr               MD053611
     C                             +%TRIM(DDCICT)                                           MD053611
     C                   ENDIF                                                              MD053611
     C                   ELSE                                                               MD053611
     C                   Move      'N'           DDCICTOk                                   MD053611
     C                   Move      'N'           DDCCSTOk                                   MD053611
     C                   ADD       1             WIx                                        MD053611
     C                   MOVEL     'DDCICT'      WFldNmXAr(WIx)                             MD053611
     C                   MOVEL     'RET1557'     WMsgIDXAr(WIx)                             MD053611
     C                   EVAL      BLen = %Len(%Trim(TCICT))                                MD053611
     C                   EVAL      MsgDtaTmp = LenStr +%Trim(TCICT)                         MD053611
     C                   EVAL      BLen = %Len(%Trim(DDCICT))                               MD053611
     C                   EVAL      WMsgDtXAr(WIx) = %TRIM(MsgDtaTmp) + LenStr               MD053611
     C                             +%TRIM(DDCICT)                                           MD053611
     C                   ENDIF                                                              MD053611
      **                                                                                    MD053611
     C                   ENDIF                                                              MD053611
      *                                                                                     MD053611
     C                   ENDIF                                                              MD053611
      *
      **      MUST BE VALID ON FILE.
     C                   MOVE      DDCICT        ICTYPE
     C                   MOVE      DDCCST        ICSTYP
     C                   MOVE      DDCCY         ICCCY
     C     KEY           CHAIN     REINT                              50
     C     *IN50         IFEQ      *On
     C                   Move      'N'           DDCICTOk
     C                   Move      'N'           DDCCSTOk
     C                   Add       1             Idx
     C                   MoveL     'DDCICT'      FldNamXAr(Idx)
     C                   MoveL     'RE71308'     MsgIDXAr(Idx)
     C                   ELSE
      *                                                                                       CER055
     C     CER055        IFEQ      'Y'                                                        CER055
     C     BAL2          ANDNE     *BLANKS                                                    CER055
     C                   MOVEL     BAL2          BAL                                          CER055
     C                   Z-ADD     1             X                 2 0                        CER055
     C     X             DOWLE     11                                                         CER055
      *                                                                                       CER055
      ** Check if an OVERDRAFT is attached                                                    CER055
      *                                                                                       CER055
     C     ZIBC(X)       COMP      -2                                     40                  CER055
     C     *IN40         IFEQ      *ON                                                        CER055
      *                                                                                       CER055
     C                   Move      'N'           DDCICTOk                                     CER055
     C                   Move      'N'           DDCCSTOk                                     CER055
     C                   Add       1             Idx                                          CER055
     C                   MoveL     'DDCICT'      FldNamXAr(Idx)                               CER055
     C                   MoveL     'RE71078'     MsgIDXAr(Idx)                                CER055
     C                   LEAVE                                                                CER055
     C                                                                                        CER055
     C                   ENDIF                                                                CER055
     C                   EVAL      X = X + 1                                                  CER055
     C                   ENDDO                                                                CER055
     C                                                                                        CER055
     C                   ENDIF                                                                CER055
      *
      ** Set control date limit for rate value date
     C     VDTC          IFGT      WWVCRC
     C                   Z-ADD     VDTC          WWVCRC
     C                   END
      *
     C     BRT           IFNE      0
     C                   MOVE      BRT           WWRIB             2
      *
      ** Get Base Rate Codes
      *
     C                   CALL      'AOBSRTR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    DDCCY
     C                   PARM                    WWRIB
     C*****SDBSRT        PARM      SDBSRT        DSFDY                          CSD006
     C     SDBSRT        PARM      SDBSRT        DSSDY                          CSD006
     C*
     C     @RTCD         IFEQ      *BLANKS
     C     BAVDRC        IFGT      WWVCRC
     C                   Z-ADD     BAVDRC        WWVCRC
     C                   END
     C                   Z-ADD     BANBRT        WWCBRT
     C                   END
     C                   END
     C                   END
     C                   END
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDCICTOk      IfEq      'N'
     C     DDCCSTOk      OrEq      'N'
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
     C                   Parm                    DDCICT            2
     C                   Parm                    DDCCST            5
     C                   Parm                    DDCRIB            2
     C                   Parm                    DDCRIS           12
     C                   Parm                    DDCSIG            1
     C                   Parm                    DDCCY             3
     C                   Parm                    DDCUSN            6                        MD053611
     C                   Parm                    DDACOD           10                        MD053611
     C                   Parm                    DDBRCA            3                        MD053611
     C                   Parm                    DDACSQ            2                        MD053611
      *
     C                   Parm                    WWVCRC            5 0
     C                   Parm                    WWCBRT           11 7
     C                   Parm                    CER055            1                          CER055
      *
      ** OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
      * Warning fields/message IDs/message data (arrays) from/to caller                     MD053611
     C                   PARM                    WFldNmXAr                                  MD053611
     C                   PARM                    WMsgIDXAr                                  MD053611
     C                   PARM                    WMsgDtXAr                                  MD053611
      *
      ** Interest Calc. Type - Ok
      ** Interest Calc. Subtype - Ok
     C                   Parm                    DDCICTOk          1
     C                   Parm                    DDCCSTOk          1
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
