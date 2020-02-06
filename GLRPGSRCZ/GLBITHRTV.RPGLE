     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL JE Retrieve')                                 *
      *****************************************************************
      *                                                               *
      *  Midas -  General Ledger ILE Module                           *
      *                                                               *
      *  GLBITHRTV - Batch Header RETRIEVE                            *
      *              (WITH ACTION CODE VERSUS Transact.NO. VALIDATION)*
      *                                                               *
      *  Function:  This module retrieves a transaction from          *
      *             the database. As it does so, it validates the     *
      *             action code and Transaction number.               *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD000091           Date 07May13               *
      *                 AR1078953          Date 18Jan13               *
      *                 CGL130             Date 28Sep12               *
      *                 AR1027164          Date 16Oct12               *
      *                 AR1005192          Date 16Jul12               *
      *                 AR787620           Date 10Jun11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG13869A          Date 10May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 237122             Date 01Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG7895            Date 19Jul05               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG6979            Date 04May05               *
      *                 CSW037A            Date 02May05               *
      *                 CSC024             Date 07Feb05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CAP084   *CREATE   Date 12Aug03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
      *  AR1078953 - Blank Batch Number is not accepted by the system *
      *  CGL130 - GL Batch Number Using Alphabetical Characters       *
      *  AR1027164 - Allow blank batch numbers if from 3rd party      *
      *              (Child: AR1027165)                               *
      *  AR1005192 - Correct error message must be prompted using     *
      *              same batch number                                *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,GLH00046                                 *
      *             WNCPYSRC,GLH00047                                 *
      *             WNCPYSRC,GLH00048                                 *
      *             WNCPYSRC,GLH00049                                 *
      *  BUG13869A - Error message change in GLBITHRTV.               *
      *  237122 - Only allow numeric batch number.                    *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG7895- Action code added to GLBITHPD                       *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it.                                         *
      *  BUG6979 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSC024 - Open Month End (Recompile)                          *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CAP084 - MidasPlus Changes                                   *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FGLJENHL1  IF   E           K DISK    INFSR(*PSSR)
 
     FGLJENHL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(@BRREMA:@BRREMAOI)
      * Batch Headers by Front Office Id
     FGLJENSL2  IF   E           K DISK    INFSR(*PSSR)                                      BUG7895
      * Batch summary records                                                                BUG7895
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
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
      *                                                                                       CGL130
      ** Valid Characters                                                                     CGL130
      *                                                                                       CGL130
     D #VLDVL          C                   CONST('ABCDEFGHIJKLMNOPQRSTUVWXYZ012-              CGL130
     D                                     3456789')                                          CGL130
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D DepotSn         S             10    DIM(10)
      ** Depot shortnames array
 
     D DepotNo         S              6    DIM(10)
      ** Depot customer numbers array
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for bank details ICD retrieval
 
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** External DS for API ICD
 
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      ** External DS for Securities ICD Details
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** EXTERNAL DS FOR CUSTOMER DETAILS
 
     D/COPY WNCPYSRC,GLH00441
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs, long data structure
 
     D BITHFilFmt    E DS                  EXTNAME(GLJENHPD)
      ** Transaction Details in File Format
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CGL130
      *                                                                                       CGL130
      ** External DS for SAR Details                                                          CGL130
      *                                                                                       CGL130
     D RUNDAT          DS
     D  @MBIN                 13     13
 
     D ZMUSER          DS
     D  DBRN                  11     13
     D  BANK                  17     17
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Ix              S              3P 0
 
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
                                                                                            MD000091
     D DDBCDASV        S              3                                                      BUG7895
     D MBRCH           S              1                                                      BUG7895
     D/COPY WNCPYSRC,GLH00046
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      **************************************************************
      *
      * Initialisation
      *
     C                   EXSR      INIT
      *
      * If the mode is 'Front Office Transaction Interface'
      * Do (Extra) Validation for Front Office Transaction Interface
      *
     C                   IF        ModeofOp = '*FRONT'
     C                   EXSR      VFRNT
      *
      **  Carry out no further validation if errors have occurred.
      *
     C                   IF        OKACTN = 'N'
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
                                                                                              CAP086
      ** If the mode is 'Front Office Transaction Interface'                                  CAP086
      ** Do authorisations are required                                                       CAP086
                                                                                              CAP086
     C                   IF        ModeofOp = '      '                                        CAP086
     C                   EVAL      BRAUTH = *BLANKS                                           CAP086
     C                   ENDIF                                                                CAP086
      *
      * Validate Action Code & Transaction Number
      *
     C                   EXSR      VAL
      *
      **  Carry out no further validation if errors have occurred.
      **  Or if DDACTN = 'U' (Unlock - Removes batch in use flag)                            BUG7895
      *
     C                   IF        OKACTN = 'N' OR
     C**********                   OKBTNB = 'N'                                              BUG7895
     C                             OKBTNB = 'N' OR                                           BUG7895
     C                             DDACTN = 'U'                                              BUG7895
     C                   RETURN
     C                   ENDIF
      *
      **********-----------------------------------------*                                   BUG7895
      *****Access*Security*Checking***********************                                   BUG7895
      **********-----------------------------------------*                                   BUG7895
      **********                                                                             BUG7895
     C**********         IF        RespMode = 'S'                                            BUG7895
     C**********         EVAL      ZACTN=DDACTN                                              BUG7895
      **********                                                                             BUG7895
      ***If*single branching                                                                 BUG7895
      ***Access*Security Checking - Single Branching                                         BUG7895
      **********                                                                             BUG7895
     C**********         IF        BJSBRC <> *BLANK AND                                      BUG7895
     C**********                   RESPMODE = 'S'                                            BUG7895
     C**********         EXSR      ACSSES                                                    BUG7895
     C**********         ENDIF                                                               BUG7895
      **********                                                                             BUG7895
      ***If*multibranching                                                                   BUG7895
      ***Access*Security Checking - Multi-Branching                                          BUG7895
      **********                                                                             BUG7895
     C**********         IF        BJSBRC = *BLANK AND                                       BUG7895
     C**********                   DDACTN <> 'I' AND                                         BUG7895
     C**********                   RESPMODE = 'S'                                            BUG7895
     C**********         EXSR      ACSSEM                                                    BUG7895
     C**********         ENDIF                                                               BUG7895
     C**********         ENDIF                                                               BUG7895
      **********                                                                             BUG7895
      ****Carry*out no further validation if errors have occurred.                           BUG7895
      **********                                                                             BUG7895
     C**********         IF        OKACTN = 'N'                                              BUG7895
     C**********         RETURN                                                              BUG7895
     C**********         ENDIF                                                               BUG7895
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'I' *
      *  *--------------------------------*
      *
     C                   IF        DDACTN = 'I'
     C                             AND DDBTNB <> *Blanks                                     BUG7895
     C                   EXSR      VALACI
     C                   ENDIF
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'E' *
      *  *--------------------------------*
      *
     C                   IF        DDACTN = 'E'
     C                   EXSR      RTVJENH
     C                   ENDIF
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'A' *
      *  *--------------------------------*
      *
     C                   IF        DDACTN = 'A'
     C                   EXSR      RTVJENH
     C                   ENDIF
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'D' *
      *  *--------------------------------*
      *
     C                   IF        DDACTN = 'D'
     C                   EXSR      RTVJENH
     C                   ENDIF
      *
      **  Carry out no further validation if errors occurred.
     C                   IF        OKACTN = 'N' OR
     C                             OKBTNB = 'N'
     C                   RETURN
     C                   ENDIF
      *                                                                                      BUG7895
      *  *-----------------------------------------------*                                   BUG7895
      *  * Access Security Checking                      *                                   BUG7895
      *  *-----------------------------------------------*                                   BUG7895
      *                                                                                      BUG7895
     C                   IF        RespMode = 'S'                                            BUG7895
     C                   EVAL      ZACTN=DDACTN                                              BUG7895
      *                                                                                      BUG7895
      ** If single branching                                                                 BUG7895
      ** Access Security Checking - Single Branching                                         BUG7895
      *                                                                                      BUG7895
     C                   IF        BJSBRC <> *BLANK                                          BUG7895
     C                   EXSR      ACSSES                                                    BUG7895
     C                   ENDIF                                                               BUG7895
      *                                                                                      BUG7895
      ** If multibranching                                                                   BUG7895
      ** Access Security Checking - Multi-Branching                                          BUG7895
      *                                                                                      BUG7895
     C                   IF        BJSBRC = *BLANK                                           BUG7895
      *                                                                                      BUG7895
     C                   IF        DDACTN = 'I'                                              BUG7895
     C                   If        DDBCDA <> *blanks                                         BUG7895
     C                   Eval      ZBR = DDBCDA                                              BUG7895
     C                   EXSR      ACSSEM                                                    BUG7895
     C                   EndIf                                                               BUG7895
     C                   ELSE                                                                BUG7895
     C                   EXSR      VALACT                                                    BUG7895
     C                   ENDIF                                                               BUG7895
      *                                                                                      BUG7895
     C                   ENDIF                                                               BUG7895
     C                   ENDIF                                                               BUG7895
 
      * Return
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * ACSSES - ACCESS SECURITY CHECKING - SINGLE BRANCHING
      *****************************************************************
     C     ACSSES        BEGSR
      *
      **  Check user's authority for the action.
      *
     C                   CALL      'ZVACTU'
     C                   PARM                    ZACTN             1
     C                   PARM                    ERR               1 0
      *
      **  If action invalid for user
      *
     C                   IF        ERR = 1
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'GLX0189'     MsgIdArr(Ix)                                BUG7895
     C**********         MOVEL     DDACTN        MsgDtaArr(Ix)                      BUG7895 MD000091
     C                   EVAL      BLen = %Len(%Trim(DDACTN))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(DDACTN)                    MD000091
     C**********         SELECT                                                              BUG7895
     C**********         WHEN      DDACTN='E'                                                BUG7895
     C**********         MOVEL     'RE7105B'     MsgIdArr(Ix)                                BUG7895
     C**********         WHEN      DDACTN='I'                                                BUG7895
     C**********         MOVEL     'RE7102B'     MsgIdArr(Ix)                                BUG7895
     C**********         WHEN      DDACTN='A'                                                BUG7895
     C**********         MOVEL     'RE7103B'     MsgIdArr(Ix)                                BUG7895
     C**********         WHEN      DDACTN='D'                                                BUG7895
     C**********         MOVEL     'RE7104B'     MsgIdArr(Ix)                                BUG7895
     C**********         ENDSL                                                               BUG7895
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ACSSEM - ACCESS SECURITY CHECKING - MULTI-BRANCHING
      *****************************************************************
     C     ACSSEM        BEGSR
      *
      **  Check user's authority for the action & Booking Branch.
      *
     C                   CALL      'ZVACTBU'
     C                   PARM                    ZACTN             1
     C**********         PARM      DBRN          ZBR               3                         BUG7895
     C                   PARM                    ZBR               3                         BUG7895
     C                   PARM                    ERR               1 0
      *
      **   If action invalid for user
      *
     C                   IF        ERR = 1
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C**********         MOVEL     'RE71070'     MsgIdArr(Ix)                                BUG7895
     C                   If        MBRCH <> 'Y'                                              BUG7895
     C                   MOVEL     'GLX0186'     MsgIdArr(Ix)                                BUG7895
     C**********         MOVEL     DDBCDA        MsgDtaArr(Ix)                      BUG7895 MD000091
     C                   EVAL      BLen = %Len(%Trim(DDBCDA))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(DDBCDA)                    MD000091
     C                   Else                                                                BUG7895
     C                   MOVEL     'GLX0190'     MsgIdArr(Ix)                                BUG7895
     C**********         Eval      MsgDtaArr(Ix) = DDACTN + DDBTNB                  BUG7895 MD000091
     C                   EVAL      BLen = %Len(%Trim(DDACTN))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(DDACTN)                    MD000091
     C                   EVAL      BLen = %Len(%Trim(DDBTNB))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = %TRIM(MsgDtaArr(Ix))                     MD000091
     C                                            + LenStr +%TRIM(DDBTNB)                   MD000091
     C                   EndIf                                                               BUG7895
      *                                                                                      BUG7895
     C                   ELSE
     C                   IF        ERR = 2
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
      *                                                                                      BUG7895
     C                   If        MBRCH <> 'Y'                                              BUG7895
     C**********         Eval      MsgDtaArr(Ix) = DDACTN + DDBCDA                  BUG7895 MD000091
     C                   EVAL      BLen = %Len(%Trim(DDACTN))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(DDACTN)                    MD000091
     C                   EVAL      BLen = %Len(%Trim(DDBCDA))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = %TRIM(MsgDtaArr(Ix))                     MD000091
     C                                            + LenStr +%TRIM(DDBCDA)                   MD000091
     C                   MOVEL     'GLX0191'     MsgIdArr(Ix)                                BUG7895
     C                   Else                                                                BUG7895
     C                   If        DDACTN <> 'C'                                             BUG7895
     C**********         Eval      MsgDtaArr(Ix) = DDACTN + DDBTNB                  BUG7895 MD000091
     C                   EVAL      BLen = %Len(%Trim(DDACTN))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(DDACTN)                    MD000091
     C                   EVAL      BLen = %Len(%Trim(DDBTNB))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = %TRIM(MsgDtaArr(Ix))                     MD000091
     C                                            + LenStr +%TRIM(DDBTNB)                   MD000091
     C                   MOVEl     'GLX0190'     MsgIdArr(Ix)                                BUG7895
     C                   Else                                                                BUG7895
     C                   MOVEL     'GLX0195'     MsgIdArr(Ix)                                BUG7895
     C                   EndIf                                                               BUG7895
     C                   EndIf                                                               BUG7895
      *                                                                                      BUG7895
     C**********         SELECT                                                              BUG7895
     C**********         WHEN      DDACTN='E'                                                BUG7895
     C**********         MOVEL     'RE7105B'     MsgIdArr(Ix)                                BUG7895
     C**********         WHEN      DDACTN='I'                                                BUG7895
     C**********         MOVEL     'RE7102B'     MsgIdArr(Ix)                                BUG7895
     C**********         WHEN      DDACTN='A'                                                BUG7895
     C**********         MOVEL     'RE7103B'     MsgIdArr(Ix)                                BUG7895
     C**********         WHEN      DDACTN='D'                                                BUG7895
     C**********         MOVEL     'RE7104B'     MsgIdArr(Ix)                                BUG7895
     C**********         ENDSL                                                               BUG7895
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************                      BUG7895
     C/EJECT                                                                                 BUG7895
      *****************************************************************                      BUG7895
      * VALACT - ACCESS SECURITY CHECKING - MULTI-BRANCHING                                  BUG7895
      *        - Checks action code and menu item for branch of batch                        BUG7895
      *          header and also reads through GLJENSPD to validate                          BUG7895
      *          against all branches that exist in the batch                                BUG7895
      *****************************************************************                      BUG7895
     C     VALACT        BEGSR                                                               BUG7895
      *                                                                                      BUG7895
      ** Reset 'More than one branch' indicator and save batch header branch                 BUG7895
     C                   Eval      MBRCH = *blanks                                           BUG7895
     C                   Eval      DDBCDASV = DDBCDA                                         BUG7895
      *                                                                                      BUG7895
      ** If DDBCDA is blank then use the value retrieved from file                           BUG7895
     C                   If        DDBCDA = *blanks                                          BUG7895
     C                   Eval      ZBR = BRBCDA                                              BUG7895
     C                   Else                                                                BUG7895
     C                   Eval      ZBR = DDBCDA                                              BUG7895
     C                   EndIf                                                               BUG7895
      *                                                                                      BUG7895
      ** Perform SR/ACSSEM using batch header branch                                         BUG7895
     C                   EXSR      ACSSEM                                                    BUG7895
      *                                                                                      BUG7895
      ** If batch is designated to be a multiple branch batch use GLJENSL2 to read           BUG7895
      ** all the branches that are part of this batch                                        BUG7895
     C                   If        DDMBRB = 'Y'                                              BUG7895
     C                             AND Ix = 0                                                BUG7895
     C     DDBTNB        SETLL     GLJENSL2                                                  BUG7895
     C     DDBTNB        READE     GLJENSL2                               90                 BUG7895
      *                                                                                      BUG7895
     C     *IN90         DOWEQ     '0'                                                       BUG7895
     C     Ix            ANDEQ     0                                                         BUG7895
      * If branch changes then check users authority to this branch                          BUG7895
     C                   If        DDBCDA <> BSBRCD                                          BUG7895
     C                   Eval      DDBCDA = BSBRCD                                           BUG7895
     C                   Eval      MBRCH = 'Y'                                               BUG7895
     C                   Eval      ZBR = DDBCDA                                              BUG7895
     C                   EXSR      ACSSEM                                                    BUG7895
     C                   EndIf                                                               BUG7895
     C     DDBTNB        READE     GLJENSL2                               90                 BUG7895
     C                   ENDDO                                                               BUG7895
      *                                                                                      BUG7895
     C                   EndIf                                                               BUG7895
      *                                                                                      BUG7895
     C                   Eval      DDBCDA = DDBCDASV                                         BUG7895
      *                                                                                      BUG7895
     C                   ENDSR                                                               BUG7895
      *****************************************************************
      /EJECT
      **********************************************************************
      * RTVJENH - RETRIEVE Transaction DETAILS IF ACTION CODE 'A', 'E' OR 'D'
      **********************************************************************
     C     RTVJENH       BEGSR
 
      * The front office can send us both Front Office ID and transaction ID;
      * When the RTV is called in the back office the transaction ID must be valid
     C                   IF        DDBTNB <> *BLANK
     C                             OR ModeofOp <> '*FRONT'
     C     DDBTNB        CHAIN     GLJENHL1                           99
 
      * Transaction details not found
     C                   IF        *IN99 = *ON
     C                   MOVEL     'N'           OKBTNB
     C                   ADD       1             Ix
     C                   MOVEL     'DDBTNB'      FldNameArr(Ix)
     C                   MOVEL     'USR4311'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
 
     C     EndRTV        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VFRNT - VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
      *****************************************************************
     C     VFRNT         BEGSR
      *
      * ERROR IF ACTION CODE IS NOT 'I','A','E' OR 'D'
      *
     C                   IF        DDACTN <> 'I' AND
     C                             DDACTN <> 'A' AND
     C                             DDACTN <> 'E' AND
     C                             DDACTN <> 'D'
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0200'     MsgIdArr(Ix)
     C                   ENDIF
      *
      * Error if Front Office Transaction ID is Blank
      *
     C                   IF        FOTRID = *BLANK
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0201'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   ENDIF
      *
      * Access Transaction with Front Office Transaction ID
      *
     C     FOTRID        CHAIN     GLJENHL3                           99
      *
      * If Insert
      *
     C                   IF        DDACTN = 'I'
      *
      * Front Office Transaction ID can't be Present already
      *
     C                   IF        *IN99 = *OFF
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0202'     MsgIdArr(Ix)
     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(FOTRID)                    MD000091
     C                   GOTO      EVFRNT
     C                   ENDIF
      *
     C                   ELSE
      *
      * If not insert, Front Office Transaction ID Must be Present
      *
     C                   IF        *IN99 = *ON
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0203'     MsgIdArr(Ix)
     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(FOTRID)                    MD000091
     C                   GOTO      EVFRNT
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     EVFRNT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL - VALIDATION OF ACTION CODE AND TRANSACTION NUMBER
      *****************************************************************
     C     VAL           BEGSR
 
      * Action Code
      *  .. must be 'I','A','D' or 'E'
      *  .. or 'C' (Accept) or 'U' (Unlock)                                                  BUG7895
      *
     C                   IF        DDACTN <> 'I' AND
     C                             DDACTN <> 'A' AND
     C                             DDACTN <> 'E' AND
     C**********                   DDACTN <> 'D'                                             BUG7895
     C                             DDACTN <> 'D' AND                                         BUG7895
     C                             DDACTN <> 'C' AND                                         BUG7895
     C                             DDACTN <> 'U'                                             BUG7895
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'SDA0001'     MsgIdArr(Ix)
     C                   ENDIF
 
      *
      *  Transaction number  required
      *
     C**********         IF        DDACTN <> 'I'                                      BUG7895 237122
      ** Allow blank batch number if from 3rd party                                        AR1027164
     C                   IF        FOTRID = *BLANKS                                        AR1027164
     C                   IF        DDBTNB = *BLANKS OR
     C                             DDBTNB = *ZEROS
     C                   MOVEL     'N'           OKBTNB
     C                   ADD       1             Ix
     C                   MOVEL     'DDBTNB'      FldNameArr(Ix)
     C                   MOVEL     'USR4312'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
     C                   ENDIF                                                             AR1027164
      *
      *  If the Transaction Number is not blank, check that it is numeric.
      *
     C                   IF        DDACTN =  'I' OR                                           237122
     C                             DDACTN =  'A' OR                                           237122
     C                             DDACTN =  'C'                                              237122
     C/COPY WNCPYSRC,GLH00047
      *                                                                                       CGL130
      ** If CGL130 is on                                                                      CGL130
      *                                                                                       CGL130
     C                   IF        CGL130 = 'Y'                                               CGL130
     C                   IF        FOTRID <> *BLANKS AND                                   AR1078953
     C                             DDBTNB =  *BLANKS                                       AR1078953
      ** Allow blank batch number if from 3rd party                                        AR1078953
     C                   ELSE                                                              AR1078953
      ** Validate batch number                                                             AR1078953
     C                   IF        DDBTNB = '000'                                             CGL130
     C                   EVAL      OKBTNB = 'N'                                               CGL130
     C                   ADD       1             Ix                                           CGL130
     C                   MOVEL     'DDBTNB'      FldNameArr(Ix)                               CGL130
     C**********         MOVEL     'GLX0431'     MsgIdArr(Ix)                       CGL130 AR1078953
     C                   MOVEL     '5045865'     MsgIdArr(Ix)                              AR1078953
     C                   GOTO      EVAL                                                       CGL130
     C                   ELSE                                                                 CGL130
      *                                                                                       CGL130
      ** Check if batch number is alpha numeric                                               CGL130
      *                                                                                       CGL130
     C                   MOVE      'Y'           #OK               1                          CGL130
     C                   Z-ADD     1             #X                1 0                        CGL130
     C                   DOW       (#OK = 'Y') AND (#X < 4)                                   CGL130
      *                                                                                       CGL130
      ** Check for valid values                                                               CGL130
      *                                                                                       CGL130
     C     1             SUBST     DDBTNB:#X     #CH               1                          CGL130
     C     #CH           SCAN      #VLDVL:1      #P                2 0    50                  CGL130
     C                   IF        *IN50 = *OFF                                               CGL130
     C                   MOVE      'N'           #OK                                          CGL130
     C                   ENDIF                                                                CGL130
     C                   ADD       1             #X                                           CGL130
     C                   ENDDO                                                                CGL130
      *                                                                                       CGL130
      ** Send error message if one of the characters is not valid                             CGL130
      *                                                                                       CGL130
     C                   IF        #OK = 'N'                                                  CGL130
     C                   EVAL      OKBTNB = 'N'                                               CGL130
     C                   ADD       1             Ix                                           CGL130
     C                   MOVEL     'DDBTNB'      FldNameArr(Ix)                               CGL130
     C**********         MOVEL     'GLX0431'     MsgIdArr(Ix)                       CGL130 AR1078953
     C                   MOVEL     '5045865'     MsgIdArr(Ix)                              AR1078953
     C                   GOTO      EVAL                                                       CGL130
     C                   ENDIF                                                                CGL130
     C                   ENDIF                                                                CGL130
     C                   ENDIF                                                             AR1078953
     C                   ELSE                                                                 CGL130
     C                   TESTN                   DDBTNB               98
     C                   MOVE      DDBTNB        @1BTNB            1
     C                   TESTZ                   @1BTNB                   99
     C                   IF        DDBTNB <> *BLANKS AND
     C                             *IN98 = *OFF OR
     C                             DDBTNB <> *BLANKS AND
     C                             *IN99 = *OFF
     C                   EVAL      OKBTNB = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDBTNB'      FldNameArr(Ix)
     C**********         MOVEL     'USR0822'     MsgIdArr(Ix)                                 237122
     C**********         MOVEL     'GLX0168'     MsgIdArr(Ix)                       237122 BUG13869A
     C                   MOVEL     'GLX0429'     MsgIdArr(Ix)                              BUG13869A
     C                   GOTO      EVAL
     C                   ENDIF
     C                   ENDIF                                                                CGL130
     C/COPY WNCPYSRC,GLH00048
     C                   ENDIF                                                                237122
     C**********         ENDIF                                                        BUG7895 237122
 
     C     EVAL          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACI - VALIDATION OF ACTION CODE 'I'
      *****************************************************************
     C     VALACI        BEGSR
 
      *
      * Access Transaction from the Transactions file
      *
     C     DDBTNB        CHAIN     GLJENHL1                           44
      *
      * Error if present already
      *
     C                   IF        *IN44 = *OFF
     C                   EVAL      OKBTNB = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDBTNB'      FldNameArr(Ix)
     C**********         MOVEL     'USR0542'     MsgIdArr(Ix)                              AR1005192
     C                   MOVEL     'GLX0421'     MsgIdArr(Ix)                              AR1005192
     C                   ENDIF
      *
      *
     C     EVALAI        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALISATION
      *****************************************************************
     C     INIT          BEGSR
 
      ** GET ZMUSER to access default branch.                                                BUG6979
                                                                                             BUG6979
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG6979
     C                   IN        ZMUSER                                                    BUG6979
                                                                                             BUG6979
      * Clear Outputs
     C                   CLEAR                   BITHFilFmt
     C                   EVAL      OKACTN = 'Y'
     C                   EVAL      OKBTNB = 'Y'
     C/COPY WNCPYSRC,GLH00442
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
 
      * Parameters
     C     *ENTRY        PLIST
 
      * Inputs
      *
      * Return code
     C                   PARM                    RetCodeIn
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    ModeofOp          6
      *
      * Response mode
     C                   PARM      'S'           RespMode          1
      *
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      *
      * (Midas) Transaction number
     C                   PARM                    DDBTNB            3
                                                                                             BUG7895
      * Multiple branch batch indicator                                                      BUG7895
     C                   PARM                    DDMBRB            1                         BUG7895
                                                                                             BUG7895
      * Batch Header Branch                                                                  BUG7895
     C                   PARM                    DDBCDA            3                         BUG7895
      *
      * Outputs
      *
      * Transaction Details in File Format
     C                   PARM                    BITHFilFmt
      *
      * OK - Action code
     C                   PARM                    OKACTN            1
      *
      * OK - Transaction Number
     C                   PARM                    OKBTNB            1
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Ix
      *
      ** Initialise program name
      *
     C                   EVAL      DBPGM = 'GLBITHRTV'
      *
      **  GET RUNDAT to access MULTI-BRANCHING flag.
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      **********                                                                             BUG6979
     C******DTAARA       DEFINE                  ZMUSER                                      BUG6979
     C**********         IN        ZMUSER                                                    BUG6979
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database Error
      *
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'                           ************
     C                   EVAL      DBASE  = 900                                  * DBERR 900*
     C                   EVAL      DBKEY = @OPTN                                 ************
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access API ICD via access program
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *                                                                                       CGL130
      ** Check if enhancement CGL130 is on                                                    CGL130
      *                                                                                       CGL130
     C                   MOVE      'N'           CGL130            1                          CGL130
      *                                                                                       CGL130
     C                   CALLB     'AOSARDR0'                                                 CGL130
     C                   PARM      *BLANKS       @RTCD                                        CGL130
     C                   PARM      '*VERIFY'     @OPTN                                        CGL130
     C                   PARM      'CGL130'      @SARD             6                          CGL130
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL130
      *                                                                                       CGL130
     C                   IF        (@RTCD <> *BLANKS) AND (@RTCD <> '*NRF')                   CGL130
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL130
     C                   EVAL      DBKEY = 'CGL130'                                           CGL130
     C                   EVAL      DBASE = 901                                                CGL130
     C                   EXSR      *PSSR                                                      CGL130
     C                   ENDIF                                                                CGL130
      *                                                                                       CGL130
     C                   IF        @RTCD = *BLANKS                                            CGL130
     C                   EVAL      CGL130 = 'Y'                                               CGL130
     C                   ENDIF                                                                CGL130
      *
     C/COPY WNCPYSRC,GLH00049
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
