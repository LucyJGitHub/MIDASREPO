     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate Margin Interest and Override')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVXRMG    - Validate Margin Interest and                    *
      *                Interest Margin Override                       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 225231             Date 24Feb04               *
      *                 208221             Date 11Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002  *CREATE    Date 01Feb00               *
      *                                                               *
      *---------------------------------------------------------------*
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  225231 - Allow zero rate as MidasPlus defaults it.           *
      *  208221 - Default Margin from Rate/Spread changes             *
      *  CDE002 - CCRM Revenue Analysis                               *
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
                                                                                              208221
      ** Array of Fields with warnings.                                                       208221
     D WFldNmXAr       S             10A   DIM(XArrayMax)                                     208221
                                                                                              208221
      ** Array of warning message IDs                                                         208221
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)                        208221
                                                                                              208221
      ** Array of warning message data.                                                       208221
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)                      208221
     D*                                                                                       208221
     D** Data structure for Margin Base Rate                                                  208221
     D*                                                                                       208221
     D                 DS                                                                     208221
     D WWMG                    1     12                                                       208221
     D WWMCCY                  1      3                                                       208221
     D WWMBR                   4      5                                                       208221
     D WWMBLK                  6     12                                                       208221
     D WWMQ1                   1      1                                                       208221
     D WWMQ2                   2      2                                                       208221
     D WWMQ3                   3      3                                                       208221
     D WWMQ4                   4      4                                                       208221
     D WWMQ5                   5      5                                                       208221
                                                                                              208221
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)                                  208221
      ** EXTERNAL DS FOR CURRENCY DETAILS                                                     208221
                                                                                              208221
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     208221
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE                                   208221

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
     D WIx             S              3P 0                                                    208221

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

     C                   EVAL      RetCodeIn = *BLANKS
     C                   EVAL      FldNamXAr = *BLANKS
     C                   EVAL      MsgIDXAr = *BLANKS
     C                   EVAL      MsgDtaXAr = *BLANKS
     C                   Eval      WFldNmXAr = *Blanks                                        208221
     C                   Eval      WMsgIDXAr  = *Blanks                                       208221
     C                   Eval      WMsgDtXAr = *Blanks                                        208221
     C                   EVAL      Idx = 0
     C                   EVAL      WIx = 0                                                    208221

     C                   IF        DDOVRx <> *BLANKS and
     C                             DDOVRx <> 'Y'

     C                   MOVE      'N'           DDOVRxOK
     C                   EVAL      Idx = Idx + 1
     C                   MOVEL     DDOVRxFLD     FldNamXAr(Idx)
     C                   MOVEL     'RE71409'     MsgIDXAr(Idx)

     C                   ENDIF

     C**********         IF        DDxRMG <> *BLANKS                                          225231
     C                   IF        DDxRMG <> *BLANKS and                                      225231
     C                             DDxRMG <>     '0.0000000   '                               225231

     C                   IF        DDOVRx <> 'Y'

     C                   EVAL      DDOVRxOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   MOVEL     DDxRMGFLD     FldNamXAr(Idx)
     C                   MOVEL     'RE71410'     MsgIDXAr(Idx)

     C                   ELSE

     C**************     EVAL      ZFIELD = *BLANKS                                           208221
     C**************     EVAL      ZFIELD = DDxRMG                                            208221
     C                   EVAL      ZADEC = 7
     C                   EVAL      ZADIG = 4
     C                   EVAL      ZFLD17 = *BLANKS                                           208221
     C                   EVAL      ZFLD17 = DDxRMG                                            208221

     C**************     CALLB     'ZALIGN'                                                   208221
     C**************     PARM                    ZAlignOK          1                          208221
     C**************     PARM                    ZField           16                          208221
     C**************     PARM                    ZADec             1 0                        208221
     C**************     PARM                    ZADig             2 0                        208221
     C                   CALLB     'ZASIGN'                                                   208221
     C                   PARM                    ZASIGNok          1                          208221
     C                   PARM                    ZFLD17           17                          208221
     C                   PARM                    ZADIG             2 0                        208221
     C                   PARM                    ZADEC             1 0                        208221
     C                   PARM      *BLANK        ZSDCSP            1                          208221
     C                   PARM      *BLANKS       ZOUT15           15                          208221
     C                   PARM      *BLANK        ZFSIGN            1                          208221

     C*****ZAlignOK      IFNE      'Y'                                                        208221
     C     ZASIGNOK      IFNE      'Y'                                                        208221
     C*                                                                                       208221
     C** Allow input of base rate                                                             208221
     C*                                                                                       208221
     C                   MOVEL     DDxRMG        WWMG                                         208221
     C     WWMBLK        IFEQ      *BLANKS                                                    208221
     C     WWMCCY        ANDNE     *BLANKS                                                    208221
     C     WWMBR         ANDNE     *BLANKS                                                    208221
     C     WWMQ1         OREQ      '?'                                                        208221
     C     WWMQ2         OREQ      '?'                                                        208221
     C     WWMQ3         OREQ      '?'                                                        208221
     C     WWMQ4         OREQ      '?'                                                        208221
     C     WWMQ5         OREQ      '?'                                                        208221
     C                   CALLB     'AOBSRTR0'                                                 208221
     C                   PARM      '*MSG   '     @RTCD                                        208221
     C                   PARM      '*KEY   '     @OPTN                                        208221
     C                   PARM      WWMCCY        @CYCD             3                          208221
     C                   PARM      WWMBR         @BSRC             2                          208221
     C     SDBSRT        PARM      SDBSRT        DSSDY                                        208221
     C*                                                                                       208221
     C     @RTCD         IFNE      *BLANKS                                                    208221
     C*                                                                                       208221
     C*412-DEBIT MARGIN BASE RATE DOESN'T EXIST IN FILE TABLE                                 208221
     C*                                                                                       208221
     C                   EVAL      DDxRMGOK = 'N'                                             208221
     C                   EVAL      Idx = Idx + 1                                              208221
     C                   MOVEL     DDxRMGFLD     FldNamXAr(Idx)                               208221
     C                   MOVEL     'RE71412'     MsgIDXAr(Idx)                                208221
     C*                                                                                       208221
     C                   ELSE                                                                 208221
     C                   MOVE      BABSRC        WWMBR                                        208221
     C*                                                                                       208221
     C** Check currency                                                                       208221
     C*                                                                                       208221
     C     BACYCD        IFNE      DDCCY                                                      208221
     C                   EVAL      DDxRMGOK = 'N'                                             208221
     C                   EVAL      Idx = Idx + 1                                              208221
     C                   MOVEL     DDxRMGFLD     FldNamXAr(Idx)                               208221
     C                   MOVEL     'RE71413'     MsgIDXAr(Idx)                                208221
     C                   ELSE                                                                 208221
      *                                                                                       208221
     C                   MOVEL     BACYCD        WWMCCY                                       208221
     C                   ENDIF                                                                208221
     C                   MOVEL     WWMG          DDxRMG                                       208221
     C                   MOVEL     WWMG          WKxMBR                                       208221
     C                   MOVEL     *BLANKS       WKxRMG                                       208221
     C                   ENDIF                                                                208221
     C                   ELSE                                                                 208221
     C                   EVAL      DDxRMGOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   MOVEL     DDxRMG        FldNamXAr(Idx)
     C                   MOVEL     'RE71411'     MsgIDXAr(Idx)
     C                   ENDIF                                                                208221

     C                   ELSE

     C************       MOVE      ZFIELD        WKxRMG                                       208221
     C                   MOVE      ZOUT15        WKxRMG                                       208221
     C                   MOVE      *BLANKS       WKxMBR                                       208221
     C*                                                                                       208221
     C     ZFSIGN        IFEQ      '-'                                                        208221
     C                   Z-SUB     WKxRMG        WKxRMG                                       208221
     C                   EVAL      WIx = WIx + 1                                              208221
     C                   MOVEL     DDxRMGFLD     WFldNmXAr(WIx)                               208221
     C                   MOVEL     'RE71414'     WMsgIDXAr(WIx)                               208221
     C                   EVAL      DDxRMGOK = 'W'                                             208221
     C                   ENDIF                                                                208221

     C                   ENDIF

     C                   ENDIF

     C                   ELSE

     C                   EVAL      WKxRMG = *ZEROS
     C                   EVAL      WKxMBR = *BLANKS                                           208221

     C                   ENDIF
     C*                                                                                       208221
     C** When account is amended, give warning message if the margin                          208221
     C** rate is different to the rate/spread                                                 208221
     C*                                                                                       208221
     C     DDACTN        IFEQ      'A'                                                        208221
     C     DDxRIB        IFNE      *BLANKS                                                    208221
     C     WKxRMG        ANDNE     DDxRIS                                                     208221
     C                   EVAL      WIx = WIx + 1                                              208221
     C                   MOVEL     DDxRMGFLD     WFldNmXAr(WIx)                               208221
     C                   MOVEL     'RE71415'     WMsgIDXAr(WIx)                               208221
     C                   EVAL      DDxRMGOK = 'W'                                             208221
     C                   ENDIF                                                                208221
     C                   ENDIF                                                                208221

      ** If an error was found, set the return code appropriately
      *
     C                   IF        DDOVRxOK = 'N' or
     C                             DDxRMGOK = 'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      ** Return
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
      ** Margin Override
     C                   Parm                    DDOVRx            1
      *
      ** Margin Rate
     C                   Parm                    DDxRMG           12
      *
      ** Margin Override Field Name
     C                   Parm                    DDOVRxFLD        10
      *
      ** Margin Rate Field Name
     C                   Parm                    DDxRMGFLD        10
      ** Action Code                                                            208221
     C                   Parm                    DDACTN            1            208221
      ** Currency                                                               208221
     C                   Parm                    DDCCY             3            208221
      ** Base Rate                                                              208221
     C                   Parm                    DDxRIB            2            208221
      ** Rate/Spread                                                            208221
     C                   Parm                    DDxRIS           11 7          208221
      *
      ** OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
      *                                                                                       208221
      * Warning message IDs/message data (arrays) from/to caller                              208221
     C                   Parm                    WFldNmXAr                                    208221
     C                   Parm                    WMsgIDXAr                                    208221
     C                   Parm                    WMsgDtXAr                                    208221
      *
      ** Margin Override - OK
     C                   Parm                    DDOVRxOK          1
      *
      ** Margin Rate - OK
     C                   Parm                    DDxRMGOK          1
      *
      ** Valid File field - Margin Rate
     C                   Parm                    WKxRMG           11 0
      ** Valid File field - Margin Base Rate                                    208221
     C                   Parm                    WKxMBR            5            208221
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
