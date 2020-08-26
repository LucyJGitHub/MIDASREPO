     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*OVRF*: OVRDBF FILE(REIACXX) TOFILE(REIAC) SHARE(*NO)              : *                    MD054211A
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate debit interest calc. type/subtyp')   *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVDBIT02  - Validate Debit Interest Calc. Type/Subtype      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD054211A          Date 02Oct19               *
      *                 MD053611           Date 19Oct19               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG5525            Date 26Jan05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 15May01               *
      * Midas DBA 3.02 -----------------------------------------------*
      *  Prev Amend No. CAP035  *CREATE    Date 19Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD054211A - Use OVRDBF for REIAC in GLVDBIT02.               *
      *  MD053611 - Add validation when changing the interest         *
      *             calculation type.                                 *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG5525 - Check for Spread rate not equal to blank only since*
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
      **
      *****FREIAC     IF   E           K DISK    INFSR(*PSSR)                     MD053611 MD054211A
     FREIACXX   IF   E           K DISK    INFSR(*PSSR)                                    MD054211A
     F                                           IGNORE(REIACAF)                  MD053611 MD054211A
     F                                           IGNORE(REIACZF)                  MD053611 MD054211A


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
     D MegDtaXAr       S                   like(#msgdata)

      ** Array of Fields in Warning.                                                        MD053611
     D WFldNmXAr       S             10A   DIM(XArrayMax)                                   MD053611

      ** Array of warning message IDs                                                       MD053611
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)                      MD053611

      ** Array of warning message data.                                                     MD053611
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)                    MD053611

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
      **
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
     C                   Z-ADD     1             WIx                                        MD053611
     C     *BLANKS       LOOKUP    WFldNmXAr(WIx)                         99                MD053611
     C     *IN99         IFEQ      '1'                                                      MD053611
     C                   SUB       1             WIx                                        MD053611
     C                   ENDIF                                                              MD053611
      *
     C     DDDICT        IFNE      *BLANKS
     C     DDDCST        ORNE      *BLANKS
      *
      **  NOT ALLOWED IF BASE RATE TYPE IS NOT BLANKS
     C     DDDRIB        IFNE      *BLANKS
     C                   Move      'N'           DDDICTOk
     C                   Move      'N'           DDDCSTOk
     C                   Add       1             Idx
     C                   MoveL     'DDDICT'      FldNamXAr(Idx)
     C                   MoveL     'RE71216'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      **  NOT ALLOWED IF RATE/SPREAD IS NOT BLANKS
     C     DDDRIS        IFNE      *BLANKS
     C*****DDDSIG        ORNE      *BLANKS                                                   BUG5525
     C                   Move      'N'           DDDICTOk
     C                   Move      'N'           DDDCSTOk
     C                   Add       1             Idx
     C                   MoveL     'DDDICT'      FldNamXAr(Idx)
     C                   MoveL     'RE71206'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      **  MANDATORY IF INTEREST CALC. TYPE IS ENTERED.
     C     DDDCST        IFEQ      *BLANKS
     C                   Move      'N'           DDDICTOk
     C                   Move      'N'           DDDCSTOk
     C                   Add       1             Idx
     C                   MoveL     'DDDICT'      FldNamXAr(Idx)
     C                   MoveL     'RE71207'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      **  IF INTEREST CALC. TYPE IS NOT BLANK.   - START
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
     C**********Key_REIAC     CHAIN     REIAC                                     MD053611 MD054211A
     C**********         IF        %FOUND(REIAC)                                  MD053611 MD054211A
     C     Key_REIAC     CHAIN     REIACXX                                                 MD054211A
     C                   IF        %FOUND(REIACXX)                                         MD054211A
     C                   MOVE      DICT          TDICT             2                        MD053611
     C     DDDICT        IFNE      TDICT                                                    MD053611
      **                                                                                    MD053611
     C     DICT          IFEQ      1                                                        MD053611
     C     DICT          OREQ      2                                                        MD053611
     C     DDDICT        IFEQ      '03'                                                     MD053611
     C     DDDICT        OREQ      '04'                                                     MD053611
     C                   MOVE      'N'           DDDICTOk                                   MD053611
     C                   MOVE      'N'           DDDCSTOk                                   MD053611
     C                   ADD       1             WIx                                        MD053611
     C                   MOVEL     'DDDICT'      WFldNmXAr(WIx)                             MD053611
     C                   MOVEL     'RET1557'     WMsgIDXAr(WIx)                             MD053611
     C                   EVAL      BLen = %Len(%Trim(TDICT))                                MD053611
     C                   EVAL      MsgDtaTmp = LenStr +%Trim(TDICT)                         MD053611
     C                   EVAL      BLen = %Len(%Trim(DDDICT))                               MD053611
     C                   EVAL      WMsgDtXAr(WIx) = %TRIM(MsgDtaTmp) + LenStr               MD053611
     C                             +%TRIM(DDDICT)                                           MD053611
     C                   ENDIF                                                              MD053611
     C                   ELSE                                                               MD053611
     C                   MOVE      'N'           DDDICTOk                                   MD053611
     C                   MOVE      'N'           DDDCSTOk                                   MD053611
     C                   ADD       1             WIx                                        MD053611
     C                   MOVEL     'DDDICT'      WFldNmXAr(WIx)                             MD053611
     C                   MoveL     'RET1557'     WMsgIDXAr(WIx)                             MD053611
     C                   EVAL      BLen = %Len(%Trim(TDICT))                                MD053611
     C                   EVAL      MsgDtaTmp = LenStr +%Trim(TDICT)                         MD053611
     C                   EVAL      BLen = %Len(%Trim(DDDICT))                               MD053611
     C                   EVAL      WMsgDtXAr(WIx) = %TRIM(MsgDtaTmp) + LenStr               MD053611
     C                             +%TRIM(DDDICT)                                           MD053611
     C                   ENDIF                                                              MD053611
      **                                                                                    MD053611
     C                   ENDIF                                                              MD053611
      *                                                                                     MD053611
     C                   ENDIF                                                              MD053611
      *END
      *
      *
      **      MUST BE VALID ON FILE.
     C                   MOVE      DDDICT        ICTYPE
     C                   MOVE      DDDCST        ICSTYP
     C                   MOVE      DDCCY         ICCCY
     C     KEY           CHAIN     REINT                              50
     C     *IN50         IFEQ      '1'
     C                   Move      'N'           DDDICTOk
     C                   Move      'N'           DDDCSTOk
     C                   Add       1             Idx
     C                   MoveL     'DDDICT'      FldNamXAr(Idx)
     C                   MoveL     'RE71208'     MsgIDXAr(Idx)
     C                   ELSE
      *
      ** Set control date limit for rate value date
     C     VDTC          IFGT      WWVDRC
     C                   Z-ADD     VDTC          WWVDRC
     C                   END
      *
     C*****BRT**         IFNE      0                                                          CSD103
     C     BRT           IFNE      *BLANKS                                                    CSD103
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
     C     BAVDRC        IFGT      WWVDRC
     C                   Z-ADD     BAVDRC        WWVDRC
     C                   END
     C                   Z-ADD     BANBRT        WWDBRT
     C                   END
     C                   END
     C                   END
     C                   END
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDDICTOk      IfEq      'N'
     C     DDDCSTOk      OrEq      'N'
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
     C                   Parm                    DDDICT            2
     C                   Parm                    DDDCST            5
     C                   Parm                    DDDRIB            2
     C                   Parm                    DDDRIS           12
     C                   Parm                    DDDSIG            1
     C                   Parm                    DDCCY             3
     C                   PARM                    DDCUSN            6                        MD053611
     C                   PARM                    DDACOD           10                        MD053611
     C                   PARM                    DDBRCA            3                        MD053611
     C                   PARM                    DDACSQ            2                        MD053611
      *
     C                   Parm                    WWVDRC            5 0
     C                   Parm                    WWDBRT           11 7
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
     C                   Parm                    DDDICTOk          1
     C                   Parm                    DDDCSTOk          1
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