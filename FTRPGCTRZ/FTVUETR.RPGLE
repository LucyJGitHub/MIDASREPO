     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate Unique End-to-End Reference')        *
      *****************************************************************
      *                                                               *
      *  Midas - Standard Subprograms                                 *
      *                                                               *
      *  FTVUETR   - Validate Unique End-to-End Reference             *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  (c) Finastra International Limited 2019                      *
      *                                                               *
      *  Last Amend No. ERZ248  *Create    Date 18Nov19               *
      *  Prev Amend No.                    Date DDMMMYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  ERZ248 - SWIFT UETR via OPAY API                             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
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

      ** Include the standard declares
     D/COPY ZACPYSRC,STDDECLARE

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.

     D/COPY ZACPYSRC,PROCPARMS

      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS

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
     D UETRHex         C                   CONST('abcdef0123456789')
     D UETRCap         C                   CONST('ABCDEFGHIJKLMNOPQRSTUVWXYZ')
     D UETRPos20       C                   CONST('89ab')
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      ** Array of Fields in error.
     D UETRAr          S              1A   DIM(36)

      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)

      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)

      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)

      ** Incoming Transaction (Original Rate)
     D TranInPrmX    E DS                  EXTNAME(FTOPY1APD)

      ** Flags to indicate whether transaction fields are valid
     D OKFlagsDS     E DS                  EXTNAME(FTEOPY1PD)

      ** Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)

      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      **
     D ExtData       E DS                  EXTNAME(FTOPEXPD)
      * FT (OPAY) Extra Data - File (D/B) format
      *
     D UETR_DS         DS
     D  UETR_01                1      1
     D  UETR_02                2      2
     D  UETR_03                3      3
     D  UETR_04                4      4
     D  UETR_05                5      5
     D  UETR_06                6      6
     D  UETR_07                7      7
     D  UETR_08                8      8
     D  UETR_09                9      9
     D  UETR_10               10     10
     D  UETR_11               11     11
     D  UETR_12               12     12
     D  UETR_13               13     13
     D  UETR_14               14     14
     D  UETR_15               15     15
     D  UETR_16               16     16
     D  UETR_17               17     17
     D  UETR_18               18     18
     D  UETR_19               19     19
     D  UETR_20               20     20
     D  UETR_21               21     21
     D  UETR_22               22     22
     D  UETR_23               23     23
     D  UETR_24               24     24
     D  UETR_25               25     25
     D  UETR_26               26     26
     D  UETR_27               27     27
     D  UETR_28               28     28
     D  UETR_29               29     29
     D  UETR_30               30     30
     D  UETR_31               31     31
     D  UETR_32               32     32
     D  UETR_33               33     33
     D  UETR_34               34     34
     D  UETR_35               35     35
     D  UETR_36               36     36
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

     C                   Eval      RetCodeIn = *Blanks
     C                   Eval      FldNamXAr = *Blanks
     C                   Eval      MsgIDXAr  = *Blanks
     C                   Eval      MsgDtaXAr = *Blanks
     C                   Eval      Idx = 0

      ** Unique End-to-End Reference validation

     C                   ExSr      SrUETR

      ** If an error was found, set the return code appropriately

     C                   If        OKUETR = 'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   EndIf

     C                   Return

      *****************************************************************
      /Title Sr/SrOXRate
      *****************************************************************
      *                                                               *
      * SR/SrUETR  - Validate Unique End-to-End Reference             *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      *                                                               *
      *****************************************************************

     C     SrUETR        BegSr

      ** Validate UETR if entered.
     C                   Move      'N'           Err               1
     C                   Z-Add     0             I                 2 0

     C                   If        SUETR <> *Blank
      * Test that no position is blank
     C                   Movea     SUETR         UETRAr
     C                   Move      SUETR         UETR_Ds
     C     ' '           Lookup    UETRAr                                 50
     C     *IN50         Ifeq      *On
     C                   Eval      Err = 'Y'
     C                   EndIf
      *
      * Test that there are no capital letters
     C     UETR_01       Scan      UETRHex       I                        50
     C                   If        *In50 = *Off
     C                   Eval      Err = 'Y'
     C                   EndIf
     C     UETR_02       Scan      UETRHex       I                        50
     C                   If        *In50 = *Off
     C                   Eval      Err = 'Y'
     C                   EndIf
     C     UETR_03       Scan      UETRHex       I                        50
     C                   If        *In50 = *Off
     C                   Eval      Err = 'Y'
     C                   EndIf
     C     UETR_04       Scan      UETRHex       I                        50
     C                   If        *In50 = *Off
     C                   Eval      Err = 'Y'
     C                   EndIf
     C     UETR_05       Scan      UETRHex       I                        50
     C                   If        *In50 = *Off
     C                   Eval      Err = 'Y'
     C                   EndIf
     C     UETR_06       Scan      UETRHex       I                        50
     C                   If        *In50 = *Off
     C                   Eval      Err = 'Y'
     C                   EndIf
     C     UETR_07       Scan      UETRHex       I                        50
     C                   If        *In50 = *Off
     C                   Eval      Err = 'Y'
     C                   EndIf
     C     UETR_08       Scan      UETRHex       I                        50
     C                   If        *In50 = *Off
     C                   Eval      Err = 'Y'
     C                   EndIf
     C     UETR_10       Scan      UETRHex       I                        50
     C                   If        *In50 = *Off
     C                   Eval      Err = 'Y'
     C                   EndIf
     C     UETR_11       Scan      UETRHex       I                        50
     C                   If        *In50 = *Off
     C                   Eval      Err = 'Y'
     C                   EndIf
     C     UETR_12       Scan      UETRHex       I                        50
     C                   If        *In50 = *Off
     C                   Eval      Err = 'Y'
     C                   EndIf
     C     UETR_13       Scan      UETRHex       I                        50
     C                   If        *In50 = *Off
     C                   Eval      Err = 'Y'
     C                   EndIf
     C     UETR_16       Scan      UETRHex       I                        50
     C                   If        *In50 = *Off
     C                   Eval      Err = 'Y'
     C                   EndIf
     C     UETR_17       Scan      UETRHex       I                        50
     C                   If        *In50 = *Off
     C                   Eval      Err = 'Y'
     C                   EndIf
     C     UETR_18       Scan      UETRHex       I                        50
     C                   If        *In50 = *Off
     C                   Eval      Err = 'Y'
     C                   EndIf
     C     UETR_21       Scan      UETRHex       I                        50
     C                   If        *In50 = *Off
     C                   Eval      Err = 'Y'
     C                   EndIf
     C     UETR_22       Scan      UETRHex       I                        50
     C                   If        *In50 = *Off
     C                   Eval      Err = 'Y'
     C                   EndIf
     C     UETR_23       Scan      UETRHex       I                        50
     C                   If        *In50 = *Off
     C                   Eval      Err = 'Y'
     C                   EndIf
     C     UETR_25       Scan      UETRHex       I                        50
     C                   If        *In50 = *Off
     C                   Eval      Err = 'Y'
     C                   EndIf
     C     UETR_26       Scan      UETRHex       I                        50
     C                   If        *In50 = *Off
     C                   Eval      Err = 'Y'
     C                   EndIf
     C     UETR_27       Scan      UETRHex       I                        50
     C                   If        *In50 = *Off
     C                   Eval      Err = 'Y'
     C                   EndIf
     C     UETR_28       Scan      UETRHex       I                        50
     C                   If        *In50 = *Off
     C                   Eval      Err = 'Y'
     C                   EndIf
     C     UETR_29       Scan      UETRHex       I                        50
     C                   If        *In50 = *Off
     C                   Eval      Err = 'Y'
     C                   EndIf
     C     UETR_30       Scan      UETRHex       I                        50
     C                   If        *In50 = *Off
     C                   Eval      Err = 'Y'
     C                   EndIf
     C     UETR_31       Scan      UETRHex       I                        50
     C                   If        *In50 = *Off
     C                   Eval      Err = 'Y'
     C                   EndIf
     C     UETR_32       Scan      UETRHex       I                        50
     C                   If        *In50 = *Off
     C                   Eval      Err = 'Y'
     C                   EndIf
      *
     C     UETR_33       Scan      UETRHex       I                        50
     C                   If        *In50 = *Off
     C                   Eval      Err = 'Y'
     C                   EndIf
      *
     C     UETR_34       Scan      UETRHex       I                        50
     C                   If        *In50 = *Off
     C                   Eval      Err = 'Y'
     C                   EndIf
      *
     C     UETR_35       Scan      UETRHex       I                        50
     C                   If        *In50 = *Off
     C                   Eval      Err = 'Y'
     C                   EndIf
      *
     C     UETR_36       Scan      UETRHex       I                        50
     C                   If        *In50 = *Off
     C                   Eval      Err = 'Y'
     C                   EndIf
      *
      * Test that positions 9, 14, 19, 24 are '-'
     C     UETR_09       Ifne      '-'
     C                   Eval      Err = 'Y'
     C                   EndIf
     C     UETR_14       Ifne      '-'
     C                   Eval      Err = 'Y'
     C                   EndIf
     C     UETR_19       Ifne      '-'
     C                   Eval      Err = 'Y'
     C                   EndIf
     C     UETR_24       Ifne      '-'
     C                   Eval      Err = 'Y'
     C                   EndIf
      *
      * Test that position 15 is '4'
     C     UETR_15       Ifne      '4'
     C                   Eval      Err = 'Y'
     C                   EndIf
      *
      * Test that position 20 is '8', '9', 'a' or 'b'
     C     UETR_20       Scan      UETRPos20     I                        50
     C                   If        *In50 = *Off
     C                   Eval      Err = 'Y'
     C                   EndIf
     C                   EndIf
      *
     C                   If        Err = 'Y'
     C                   Move      'N'           OKUETR
     C                   Add       1             Idx
     C                   Movel     'SUETR'       FldNamXAr(Idx)
     C                   Movel     'XXX1111'     MsgIdXAr(Idx)
     C                   EndIf

     C                   EndSr

      *****************************************************************
      /Title Sr/*InzSr
      *****************************************************************
      *                                                               *
      * SR/*InzSr     - Program Initialisation Routine                *
      *                                                               *
      * Called By: Automatically executed when program starts.        *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************

     C     *InzSr        BegSr

     C     *Entry        Plist
     C                   Parm                    RetCodeIn
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    ExtData
     C                   Parm                    OKUETR            1

     C                   EndSr

      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2019
