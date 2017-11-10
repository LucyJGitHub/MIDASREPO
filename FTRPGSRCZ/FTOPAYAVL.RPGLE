     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Outgoing Payments Validation Control 5')      *
      *****************************************************************
      *                                                               *
      *  Midas - API Funds Transfer Module                            *
      *                                                               *
      *  FTOPAYAVL - Outgoing Payments Validation Cover Message 1     *
      *                                                               *
      *  Function:  This API module will serve as the validation mo   *
      *             dule for all the Cover Message information fields *
      *             for screen 1.                                     *
      *                                                               *
      *  Called By: FTOPAY1SN                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. CFT162             Date 08Sep17               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG25101           Date 03Sep09               *
      *                 CSW209  *CREATE    Date 01Apr09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT162 - MT900 and MT910 Message Generation (Recompile)      *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  BUG25101 - CSW209 FDS2.01 Changes                            *
      *  CSW209 - SWIFT 2009 Changes                                  *
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

      ** Array of Fields with warnings.
     D WFldNmXAr       S             10A   DIM(XArrayMax)

      ** Array of warning message IDs
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)

      ** Array of warning message data.
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)

      ** Cover Message
     D NwOPAScnFmt   E DS                  EXTNAME(FTOPYAPD)

      ** Screen fields (Initial Screen)
     D FTOPAY1       E DS                  EXTNAME(FTOPY1PD)

      ** Validation Work Fields
     D NwOPFilFmt    E DS                   EXTNAME(FTVOPAYPD)
     D                                     Prefix(@X)
     D NwOPFilFmx    E DS                   EXTNAME(FTVOPY2PD)

      ** Flags to indicate whether transaction fields are valid
     D FTEOPYA       E DS                  EXTNAME(FTEOPYAPD)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0

      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0

      ** Response Mode, received as a parameter from the common header
     D RespMode        S              1A

     D I               S              3  0

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

      ** Validate Margin fields

     C                   ExSr      SrNetwork

     C                   ExSr      SrInMsgType

     C                   ExSr      SrInValFlag

     C                   ExSr      SrOutValFlagM

     C**********         ExSr      SrOutValFlagC                                            BUG25101

     C                   ExSr      SrValOrdCus

     C                   ExSr      SrValOrdIns

     C                   ExSr      SrValIntIns

     C                   ExSr      SrValAccIns

     C                   ExSr      SrValBenCus

     C                   Return

      *****************************************************************
      /Title Sr/SrNetwork
      *****************************************************************
      *                                                               *
      * SR/SrNetwork - Validate Network                               *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      *  RESETERRS  - Resets variables updated by each modules        *
      *  UPDATERRS  - Updates error information                       *
      *                                                               *
      *****************************************************************

     C     SrNetwork     BegSr

      ** Reset variables updated by other modules

     C                   ExSr      ResetErrs

      ** Validate Network

     C                   CallB     'FTVONWK'     PList01

      ** Update error info with that retured from the validation module

     C                   ExSr      UpdatErrs

     C                   EndSr

      *****************************************************************
      /Title Sr/InMsgType
      *****************************************************************
      *                                                               *
      * SR/SrInMsgType - Validate Incoming Message Type               *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      *  RESETERRS  - Resets variables updated by each modules        *
      *  UPDATERRS  - Updates error information                       *
      *                                                               *
      *****************************************************************

     C     SrInMsgType   BegSr

      ** Reset variables updated by other modules

     C                   ExSr      ResetErrs

      ** Validate Incoming Message Type

     C                   CallB     'FTVOMTP'     PList01

      ** Update error info with that retured from the validation module

     C                   ExSr      UpdatErrs

     C                   EndSr

      *****************************************************************
      /Title Sr/InValFlag
      *****************************************************************
      *                                                               *
      * SR/SrInValFlag - Validate Incoming Validation Flag            *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      *  RESETERRS  - Resets variables updated by each modules        *
      *  UPDATERRS  - Updates error information                       *
      *                                                               *
      *****************************************************************

     C     SrInValFlag   BegSr

      ** Reset variables updated by other modules

     C                   ExSr      ResetErrs

      ** Validate Incoming Validation Flag

     C                   CallB     'FTVOVLF'     PList01

      ** Update error info with that retured from the validation module

     C                   ExSr      UpdatErrs

     C                   EndSr

      *****************************************************************
      /Title Sr/OutValFlagM
      *****************************************************************
      *                                                               *
      * SR/SrOutValFlagM - Validate Outgoing Validation Flag Main     *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      *  RESETERRS  - Resets variables updated by each modules        *
      *  UPDATERRS  - Updates error information                       *
      *                                                               *
      *****************************************************************

     C     SrOutValFlagM BegSr

      ** Reset variables updated by other modules

     C                   ExSr      ResetErrs

      ** Validate Outgoing Validation Flag Main

     C                   CallB     'FTVOMVF'     PList02

      ** Update error info with that retured from the validation module

     C                   ExSr      UpdatErrs

     C                   EndSr

      *****************************************************************
      /Title Sr/SrOutValFlagC
      *****************************************************************
      *                                                               *
      * SR/SrOutValFlagC - Validate Outgoing Validation Flag Cover    *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      *  RESETERRS  - Resets variables updated by each modules        *
      *  UPDATERRS  - Updates error information                       *
      *                                                               *
      *****************************************************************

     C     SrOutValFlagC BegSr

      ** Reset variables updated by other modules

     C                   ExSr      ResetErrs

      ** Validate Outgoing Validation Flag Cover

     C                   CallB     'FTVOCVF'     PList01

      ** Update error info with that retured from the validation module

     C                   ExSr      UpdatErrs

     C                   EndSr

      *****************************************************************
      /Title Sr/SrValOrdCus
      *****************************************************************
      *                                                               *
      * SR/SrValOrdCus - Validate Ordering Customer (Cover)           *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      *  RESETERRS  - Resets variables updated by each modules        *
      *  UPDATERRS  - Updates error information                       *
      *                                                               *
      *****************************************************************

     C     SrValOrdCus   BegSr

      ** Reset variables updated by other modules

     C                   ExSr      ResetErrs

      ** Validate Ordering Customer

     C                   CallB     'FTVOCOC'     PList01

      ** Update error info with that retured from the validation module

     C                   ExSr      UpdatErrs

     C                   EndSr

      *****************************************************************
      /Title Sr/SrValOrdIns
      *****************************************************************
      *                                                               *
      * SR/SrValOrdCus - Validate Ordering Institution (Cover)        *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      *  RESETERRS  - Resets variables updated by each modules        *
      *  UPDATERRS  - Updates error information                       *
      *                                                               *
      *****************************************************************

     C     SrValOrdIns   BegSr

      ** Reset variables updated by other modules

     C                   ExSr      ResetErrs

      ** Validate Ordering Institution

     C                   CallB     'FTVOCOB'     PList01

      ** Update error info with that retured from the validation module

     C                   ExSr      UpdatErrs

     C                   EndSr

      *****************************************************************
      /Title Sr/SrValIntIns
      *****************************************************************
      *                                                               *
      * SR/SrValIntIns - Validate Intermediary Institution (Cover)    *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      *  RESETERRS  - Resets variables updated by each modules        *
      *  UPDATERRS  - Updates error information                       *
      *                                                               *
      *****************************************************************

     C     SrValIntIns   BegSr

      ** Reset variables updated by other modules

     C                   ExSr      ResetErrs

      ** Validate Intermediary Institution

     C                   CallB     'FTVOCIN'     PList01

      ** Update error info with that retured from the validation module

     C                   ExSr      UpdatErrs

     C                   EndSr

      *****************************************************************
      /Title Sr/SrValAccIns
      *****************************************************************
      *                                                               *
      * SR/SrValAccIns - Validate Account with Institution (Cover)    *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      *  RESETERRS  - Resets variables updated by each modules        *
      *  UPDATERRS  - Updates error information                       *
      *                                                               *
      *****************************************************************

     C     SrValAccIns   BegSr

      ** Reset variables updated by other modules

     C                   ExSr      ResetErrs

      ** Validate Account with Institution

     C                   CallB     'FTVOCAB'     PList01

      ** Update error info with that retured from the validation module

     C                   ExSr      UpdatErrs

     C                   EndSr

      *****************************************************************
      /Title Sr/SrValBenCus
      *****************************************************************
      *                                                               *
      * SR/SrValBenCus - Validate Beneficiary Customer (Cover)        *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      *  RESETERRS  - Resets variables updated by each modules        *
      *  UPDATERRS  - Updates error information                       *
      *                                                               *
      *****************************************************************

     C     SrValBenCus   BegSr

      ** Reset variables updated by other modules

     C                   ExSr      ResetErrs

      ** Validate Beneficiary Customer

     C                   CallB     'FTVOCBN'     PList01

      ** Update error info with that retured from the validation module

     C                   ExSr      UpdatErrs

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

     C                   Parm                    RespMode
     C                   Parm                    FTOPAY1
     C                   Parm                    NwOPFilFmt
     C                   Parm                    NwOPFilFmx
     C                   Parm                    NwOPAScnFmt
     C                   Parm                    FTEOPYA
     C                   Parm                    FldNameArr
     C                   Parm                    MsgIDArr
     C                   Parm                    MsgDtaArr
     C                   Parm                    Idx
     C                   Parm                    WFldNamArr
     C                   Parm                    WMsgIDArr
     C                   Parm                    WMsgDtaArr
     C                   Parm                    WIdx

     C     PList01       PList
     C                   Parm                    RetCodeOut
     C                   Parm                    NwOPFilFmt
     C                   Parm                    NwOPFilFmx
     C                   Parm                    NwOPAScnFmt
     C                   Parm                    FTEOPYA
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr

     C     PList02       PList
     C                   Parm                    RetCodeOut
     C                   Parm                    FTOPAY1
     C                   Parm                    NwOPFilFmt
     C                   Parm                    NwOPFilFmx
     C                   Parm                    NwOPAScnFmt
     C                   Parm                    FTEOPYA
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr

     C     *LOCK         In        LDA
     C                   Movel     'FTOPAYAVL'   DBPGM
     C                   Out       LDA

     C                   EndSr

      *****************************************************************
      /Title Sr/Reseterrs
      *****************************************************************
      *                                                               *
      * SR/Reseterrs  - Reset information that is received back from  *
      *                 each validation module                        *
      *                                                               *
      * Called By: Validation subroutines                             *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************

     C     Reseterrs     BegSr

     C                   Eval      RetCodeOut = *Blanks

      ** Reset error & warning fields/message IDs/message data (arrays)

     C                   Eval      FldNamXAr = *BlankS
     C                   Eval      MsgIDXAr  = *BlankS
     C                   Eval      MsgDtaXAr = *BlankS
     C                   Eval      WFldNmXAr = *BlankS
     C                   Eval      WMsgIDXAr = *BlankS
     C                   Eval      WMsgDtXAr = *BlankS

     C                   EndSr

      *****************************************************************
      /Title Sr/Updaterrs
      *****************************************************************
      *                                                               *
      * SR/Updaterrs  - Update error information with that received   *
      *                 back from each validation module              *
      *                                                               *
      * Called By: Validation subroutines                             *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************

     C     Updaterrs     BegSr

      ** Update error fields/message IDs/message data (arrays)

     C                   Eval      I = 1
     C     *Blank        Lookup    FldNameArr(I)                          99
     C                   If        *IN99 = True
     C                   Movea     FldNamXar     FldNameArr(I)
     C                   Movea     MsgIDXAr      MsgIdArr(I)
     C                   Movea     MsgDtaXAr     MsgDtaArr(I)
     C                   EndIf

      ** Set Error Index

     C                   Eval      I = 1
     C     *Blank        Lookup    FldNameArr(I)                          99
     C                   Eval      Idx = I - 1

      ** Update warning fields/message IDs/message data (arrays)

     C                   Eval      I = 1
     C     *Blank        Lookup    WFldNamArr(I)                          99
     C                   If        *IN99 = True
     C                   Movea     WFldNmXAr     WFldNamArr(I)
     C                   Movea     WMsgIDXAr     WMsgIDArr(I)
     C                   Movea     WMsgDtXAr     WMsgDtaArr(I)
     C                   EndIf

      ** Set Warning Index

     C                   Eval      I = 1
     C     *Blank        Lookup    WFldNamArr(I)                          99
     C                   Eval      WIdx = I - 1

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
(c) Misys International Banking Systems Ltd. 2009
