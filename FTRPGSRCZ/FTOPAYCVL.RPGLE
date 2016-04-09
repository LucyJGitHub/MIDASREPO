     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Outgoing Payments Validation Control 5')      *
      *****************************************************************
      *                                                               *
      *  Midas - API Funds Transfer Module                            *
      *                                                               *
      *  FTOPAYCVL - Outgoing Payments Validation Cover Message 2     *
      *                                                               *
      *  Function:  This API module will serve as the validation mo   *
      *             dule for all the Cover Message information fields *
      *             for screen 2.                                     *
      *                                                               *
      *  Called By: FTOPAY1SN                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CSF011A            Date 28Nov11               *
      *  Prev Amend No. CRE067             Date 05Oct10               *
      *                 BUG26775           Date 27Nov09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG26548           Date 23Oct09               *
      *                 BUG25085           Date 24Jul09               *
      *                 CSW209  *CREATE    Date 01Apr09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  BUG26775 - Validation error in Outgoing Validation Flag      *
      *  BUG26548 - Passed parm does not match entry parm for FTVXVXV *
      *  BUG25085 - Misleading error message for Sender to Receiver   *
      *             Cover                                             *
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
 
      ** Cover Message 1
     D NwOPAScnFmt   E DS                  EXTNAME(FTOPYAPD)
 
      ** Cover Message 2
     D NwOPCScnFmt   E DS                  EXTNAME(FTOPYCPD)
 
      ** Validation Work Fields
     D TranInPrim    E DS                  EXTNAME(FTOPY1PD)
     D TranInPrmB    E DS                  EXTNAME(FTOPY1APD)                               BUG26775
     D TranInSecA    E DS                  EXTNAME(FTOPY2PD)                                BUG26548
     D TranInSecB    E DS                  EXTNAME(FTOPY3PD)
     D TranInThir    E DS                  EXTNAME(FTOPY4PD)
     D NwOPFilFmt    E DS                  EXTNAME(FTVOPAYPD)
     D                                     Prefix(@X)
     D NwOPFilFmx    E DS                  EXTNAME(FTVOPY2PD)
 
      ** Flags to indicate whether transaction fields are valid
     D FTEOPYC       E DS                  EXTNAME(FTEOPYCPD)
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
      * Flags to indicate whether transaction fields are valid
     D FTEOPY2       E DS                  EXTNAME(FTEOPY2PD)
     D FTEOPY3       E DS                  EXTNAME(FTEOPY3PD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
      ** A code to indicate the calling function to the lower level modules
     D OPAY            S              4A   INZ('OPAY')
 
      ** Response Mode, received as a parameter from the common header
     D RespMode        S              1A
 
     D I               S              3  0
     D WPrgQ           S             10A
     D WSBBI1          S             35A
     D WSBBI2          S             35A
     D WSBBI3          S             35A
     D WSBBI4          S             35A
     D WSBBI5          S             35A
     D WSBBI6          S             35A
 
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
 
     C                   ExSr      SrValRemInfo
 
     C                   ExSr      SrValSndrRcvrB
 
     C                   ExSr      SrValInsCurAmt
 
     C                   ExSr      SrValSndrRcvrA
 
     C                   Return
 
      *****************************************************************
      /Title Sr/SrValRemInfo
      *****************************************************************
      *                                                               *
      * SR/SrValRemInfo - Validate Remittance Information (Cover)     *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      *  RESETERRS  - Resets variables updated by each modules        *
      *  UPDATERRS  - Updates error information                       *
      *                                                               *
      *****************************************************************
 
     C     SrValRemInfo  BegSr
 
      ** Reset variables updated by other modules
 
     C                   ExSr      ResetErrs
 
      ** Validate Remittance Information
 
     C                   CallB     'FTVOCDP'     PList01
 
      ** Update error info with that retured from the validation module
 
     C                   ExSr      UpdatErrs
 
     C                   EndSr
 
      *****************************************************************
      /Title Sr/SrValSndrRcvrB
      *****************************************************************
      *                                                               *
      * SR/SrValSndrRcvrB - Validate Sender to Receiver Info (Cover B)*
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      *  RESETERRS  - Resets variables updated by each modules        *
      *  UPDATERRS  - Updates error information                       *
      *                                                               *
      *****************************************************************
 
     C     SrValSndrRcvrBBegSr
 
      ** Reset variables updated by other modules
 
     C                   ExSr      ResetErrs
 
      ** Validate Sender to Receiver Info B
 
     C                   CallB     'FTVOCBB'     PList01
 
      ** Update error info with that retured from the validation module
 
     C                   ExSr      UpdatErrs
 
     C                   If        Idx = 0
 
     C                   Eval      WSBBI1 = SBBI1
     C                   Eval      WSBBI2 = SBBI2
     C                   Eval      WSBBI3 = SBBI3
     C                   Eval      WSBBI4 = SBBI4
     C                   Eval      WSBBI5 = SBBI5
     C                   Eval      WSBBI6 = SBBI6
     C                   Eval      SBBI1 =  SCBB1
     C                   Eval      SBBI2 =  SCBB2
     C                   Eval      SBBI3 =  SCBB3
     C                   Eval      SBBI4 =  SCBB4
     C                   Eval      SBBI5 =  SCBB5
     C                   Eval      SBBI6 =  SCBB6
     C                   EVAL      WPrgQ = *BLANKS                                          BUG25085
     C                   EVAL      WPrgQ = 'FTVOCBB'                                        BUG25085
     C                   ExSr      VXVAL
 
     C                   Eval      SBBI1 = WSBBI1
     C                   Eval      SBBI2 = WSBBI2
     C                   Eval      SBBI3 = WSBBI3
     C                   Eval      SBBI4 = WSBBI4
     C                   Eval      SBBI5 = WSBBI5
     C                   Eval      SBBI6 = WSBBI6
 
     C**********         If        OKBBI1 = 'N'                                             BUG25085
     C**********         Eval      OKCBB1 = 'N'                                             BUG25085
     C**********         EndIf                                                              BUG25085
 
     C**********         If        OKBBI2 = 'N'                                             BUG25085
     C**********         Eval      OKCBB2 = 'N'                                             BUG25085
     C**********         EndIf                                                              BUG25085
 
     C**********         If        OKBBI3 = 'N'                                             BUG25085
     C**********         Eval      OKCBB3 = 'N'                                             BUG25085
     C**********         EndIf                                                              BUG25085
 
     C**********         If        OKBBI4 = 'N'                                             BUG25085
     C**********         Eval      OKCBB4 = 'N'                                             BUG25085
     C**********         EndIf                                                              BUG25085
 
     C**********         If        OKBBI5 = 'N'                                             BUG25085
     C**********         Eval      OKCBB5 = 'N'                                             BUG25085
     C**********         EndIf                                                              BUG25085
 
     C**********         If        OKBBI6 = 'N'                                             BUG25085
     C**********         Eval      OKCBB6 = 'N'                                             BUG25085
     C**********         EndIf                                                              BUG25085
 
     C                   EndIf
 
     C                   EndSr
 
      *****************************************************************
      /Title Sr/SrValInsCurAmt
      *****************************************************************
      *                                                               *
      * SR/SrValInsCurAmt - Validate Instructed Currency/Amount       *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      *  RESETERRS  - Resets variables updated by each modules        *
      *  UPDATERRS  - Updates error information                       *
      *                                                               *
      *****************************************************************
 
     C     SrValInsCurAmtBegSr
 
      ** Reset variables updated by other modules
 
     C                   ExSr      ResetErrs
 
      ** Validate Instructed Currency/Amount
 
     C                   CallB     'FTVOCIC'     PList03
 
      ** Update error info with that retured from the validation module
 
     C                   ExSr      UpdatErrs
 
     C                   EndSr
 
      *****************************************************************
      /Title Sr/SrValSndrRcvrA
      *****************************************************************
      *                                                               *
      * SR/SrValSndrRcvrA - Validate Sender to Receiver Info (Cover A)*
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      *  RESETERRS  - Resets variables updated by each modules        *
      *  UPDATERRS  - Updates error information                       *
      *                                                               *
      *****************************************************************
 
     C     SrValSndrRcvrABegSr
 
      ** Reset variables updated by other modules
 
     C                   ExSr      ResetErrs
 
      ** Validate Sender to Receiver Info A
 
     C                   CallB     'FTVOCBA'     PList01
 
      ** Update error info with that retured from the validation module
 
     C                   ExSr      UpdatErrs
 
     C                   If        Idx = 0
 
     C                   Eval      WSBBI1 = SBBI1
     C                   Eval      WSBBI2 = SBBI2
     C                   Eval      WSBBI3 = SBBI3
     C                   Eval      WSBBI4 = SBBI4
     C                   Eval      WSBBI5 = SBBI5
     C                   Eval      WSBBI6 = SBBI6
     C                   Eval      SBBI1 =  SOCBB1
     C                   Eval      SBBI2 =  SOCBB2
     C                   Eval      SBBI3 =  SOCBB3
     C                   Eval      SBBI4 =  SOCBB4
     C                   Eval      SBBI5 =  SOCBB5
     C                   Eval      SBBI6 =  SOCBB6
     C                   EVAL      WPrgQ = *BLANKS                                          BUG25085
     C                   EVAL      WPrgQ = 'FTVOCBA'                                        BUG25085
 
     C                   ExSr      VXVAL
 
     C                   Eval      SBBI1 = WSBBI1
     C                   Eval      SBBI2 = WSBBI2
     C                   Eval      SBBI3 = WSBBI3
     C                   Eval      SBBI4 = WSBBI4
     C                   Eval      SBBI5 = WSBBI5
     C                   Eval      SBBI6 = WSBBI6
 
     C**********         If        OKBBI1 = 'N'                                             BUG25085
     C**********         Eval      OKOCB1 = 'N'                                             BUG25085
     C**********         EndIf                                                              BUG25085
 
     C**********         If        OKBBI2 = 'N'                                             BUG25085
     C**********         Eval      OKOCB2 = 'N'                                             BUG25085
     C**********         EndIf                                                              BUG25085
 
     C**********         If        OKBBI3 = 'N'                                             BUG25085
     C**********         Eval      OKOCB3 = 'N'                                             BUG25085
     C**********         EndIf                                                              BUG25085
 
     C**********         If        OKBBI4 = 'N'                                             BUG25085
     C**********         Eval      OKOCB4 = 'N'                                             BUG25085
     C**********         EndIf                                                              BUG25085
 
     C**********         If        OKBBI5 = 'N'                                             BUG25085
     C**********         Eval      OKOCB5 = 'N'                                             BUG25085
     C**********         EndIf                                                              BUG25085
 
     C**********         If        OKBBI6 = 'N'                                             BUG25085
     C**********         Eval      OKOCB6 = 'N'                                             BUG25085
     C**********         EndIf                                                              BUG25085
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
 
     C                   Parm                    RespMode
     C                   Parm                    NwOPFilFmt
     C                   Parm                    NwOPFilFmx
     C                   Parm                    TranInPrim
     C                   Parm                    TranInPrmB                                 BUG26775
     C                   Parm                    TranInSecA                                 BUG26548
     C                   Parm                    TranInSecB
     C                   Parm                    TranInThir
     C                   Parm                    NwOPAScnFmt
     C                   Parm                    NwOPCScnFmt
     C                   Parm                    FTEOPYC
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
     C                   Parm                    NwOPCScnFmt
     C                   Parm                    FTEOPYC
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr
 
     C     PList02       PList
     C                   Parm                    RetCodeOut
     C                   Parm                    NwOPAScnFmt
     C                   Parm                    NwOPCScnFmt
     C                   Parm                    FTEOPYC
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr
 
     C     PList03       PList
     C                   Parm                    RetCodeOut
     C                   Parm                    NwOPFilFmx
     C                   Parm                    NwOPAScnFmt
     C                   Parm                    NwOPCScnFmt
     C                   Parm                    FTEOPYC
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr
 
     C     PList04       PList
     C                   Parm                    RetCodeOut
     C                   Parm                    TranInPrim
     C                   Parm                    TranInPrmB                                 BUG26775
     C                   Parm                    TranInSecA                                 BUG26548
     C                   Parm                    TranInSecB
     C                   Parm                    TranInThir
     C**********         Parm      'FTOPAY3VL'   WPrgQ                                      BUG25085
     C                   Parm                    WPrgQ                                      BUG25085
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    FTEOPY2
     C                   Parm                    FTEOPY3
     C                   Parm                    Val@Fields
 
     C     *LOCK         In        LDA
     C                   Movel     'FTOPAYCVL'   DBPGM
     C                   Out       LDA
 
     C                   EndSr
 
      *****************************************************************
      ** VXVAL   - Validate Cross Validations
      *****************************************************************
     C     VXVAL         BegSr
 
     C                   Clear                   FTEOPY3
 
      * Reset variables updated by each module
     C                   Exsr      ResetErrs
 
      * Validate
     C                   CallB     'FTVXVXV'     PList04
 
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
 
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
