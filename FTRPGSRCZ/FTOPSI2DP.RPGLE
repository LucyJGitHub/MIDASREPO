     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      **********************************************************************
/*STD *  RPGBASEMOD                                                        *
/*EXI *  TEXT('Midas FT Outgoing Payments SSI Screen 2 Display')      *
      **********************************************************************
      *                                                                    *
      *  Midas - API Funds Transfer Module                                 *
      *                                                                    *
      *  FTOPSI2DP - Outgoing Payments SSI Secondary Screen                *
      *                                                                    *
      *  Function:  Secondary detail screen handling for Outgoing          *
      *             Payments Standard Settlement Instructions              *
      *                                                                    *
      *  (c) Finastra International Limited 2002                           *
      *                                                                    *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CFT120             Date 28Sep12               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG14716           Date 24Aug07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGL029             Date 01Sep03                    *
      *                 CFT018  *CREATE    Date 29Nov02                    *
      *                                                                    *
      **********************************************************************
      *                                                                    *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG14716 - CFT032 pre-req missing CFT018 OPSI Outgoing       *
      *             Payments Template (Recompile)                     *
      *  CGL029 - Increase Account Code to 10 digits                       *
      *  CFT018 - Standard Settlement Instructions for                     *
      *           Outgoing Payments                                        *
      *                                                                    *
      **********************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FFTOPSI2DF CF   E             WORKSTN INFSR(*PSSR)
      *
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
      *
      ********************************************************************
      *  +--------------------------------------+
      *  ¦ Automatically included D-specs       ¦
      *  ¦ ==============================       ¦
      *  +--------------------------------------+
      *
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      *
      *
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,APICTLARR
      **                                                                    ------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
     D/COPY ZACPYSRC,MSGHNDDCL
      **                                                                    ------------------------
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D SSIFileFmt    E DS                  EXTNAME(FTOSSIPD)
      * Current Outgoing Payment SSI in File Format
      *
     D SSIScrnFmt    E DS                  EXTNAME(FTOPSIPD)
      * Current Outgoing Payment SSI in Screen Format
      *
     D SSIValidFmt   E DS                  EXTNAME(FTVOPSIPD)
     D QQDRACX       E                     EXTFLD(QQDRAC)                                     CGL029
     D QQORBKX       E                     EXTFLD(QQORBK)                                     CGL029
     D QQCDROX       E                     EXTFLD(QQCDRO)                                     CGL029
      * New Outgoing Payment SSI in File Format
      *
     D WorkFields    E DS                  EXTNAME(FTV@OPSIPD)
      * Common Work Fields
      *
     D FTEOPSI       E DS                  EXTNAME(FTEOPSIPD)
      * Error indicators
      *
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      **********************************************************************
      /EJECT
      **********************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      **  Initialisation
     C                   Exsr      INIT
      *
      **  Display Screen
     C                   Exsr      DspScrn
      *
      **  Return to calling program
     C                   Return
      *
      /EJECT
      **********************************************************************
      * INIT - Initialisation Processing each time module is invoked
      **********************************************************************
     C     INIT          BEGSR
      *
      **  Reset all screen function indicator work fields which are
      **  returned to calling program
     C                   Move      '0'           @INKC
     C                   Move      '0'           @INKL
      *
      **  If action is enquiry, delete or authrise then protect fields
     C     SACTION       Ifeq      'E'
     C     SACTION       oreq      'D'
     C     SACTION       oreq      'X'
     C                   Move      *On           *IN70
     C                   Else
     C                   Move      *Off          *IN70
     C                   Endif
      *
     C                   Endsr
      /EJECT
      **********************************************************************
      * DspScrn - Display Primary Detail Screen
      **********************************************************************
     C     DspScrn       Begsr
      *
      **  Set screen error indictors for fields in error
     C                   Exsr      ChkErrors
      *
      ** Set up the customer reference to be used by the message handler
     C                   Eval      TranRef = SDRCY+SDRAC+SREF1+SREF2+SCRCY
     C                   Eval      ActionCode = SACTION
      *
      ** Send any error messages to the program message queue
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sends any error messages to the program
      ** message queue if there are any validation errors
     D/COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------
      *
      **  Reset error message arrays and fields
     C                   Z-add     *Zero         Idx               3 0
     C                   Z-add     *Zero         WIdx
     C                   Movel     *Blank        FldNameArr
     C                   Movel     *Blank        MsgIdArr
     C                   Movel     *Blank        MsgDtaArr
     C                   Movel     *Blank        WFldNamArr
     C                   Movel     *Blank        WMsgIdArr
     C                   Movel     *Blank        WMsgDtaArr
     C                   Move      *ALL'Y'       FTEOPSI
      *
      **  Retrieve time for display
     C                   Time                    DDTIME
      *
      **  Write out screen with message subfile and footer
     C                   Write     FTOPSI2F1
     C                   Write     FTOPSI2S0
     C                   Write     FTOPSI2D1
      *
      **  Read response from screen
     C                   Read      FTOPSI2D1
      *
      *
      **  Check screen repsonse
     C                   Select
      *
      **  F3 = Exit requested
     C     *INKC         Wheneq    *On
     C                   Movel     '1'           @INKC
     C                   Move      *On           *INLR
      *
      **  F12 = Previous screen requested
     C     *INKL         Wheneq    *On
     C                   Movel     '1'           @INKL
      *
      **  Otherwise enter must have been entered by user
     C                   Other
      *
     C                   Endsl
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * ChkErrors - Check Error Flags and Set Screen Indicators
      *****************************************************************
     C     ChkErrors     BEGSR
      *
      **  Bank Operation Code
     C     OKBOCD        COMP      'N'                                    12
      *
      **  Transaction type code
     C     OKTTCD        COMP      'N'                                    13
      *
      **  Receivers Correspondent
     C     OKRCO1        COMP      'N'                                    14
     C     OKRCO2        COMP      'N'                                    15
     C     OKRCO3        COMP      'N'                                    16
     C     OKRCO4        COMP      'N'                                    17
     C     OKRCO5        COMP      'N'                                    18
      *
      ** Third Reimbursement Institution
     C     OKTRI1        COMP      'N'                                    19
     C     OKTRI1        COMP      'N'                                    20
     C     OKTRI1        COMP      'N'                                    21
     C     OKTRI1        COMP      'N'                                    22
     C     OKTRI1        COMP      'N'                                    23
      *
      **  Intermediary Bank
     C     OKINB1        COMP      'N'                                    24
     C     OKINB2        COMP      'N'                                    25
     C     OKINB3        COMP      'N'                                    26
     C     OKINB4        COMP      'N'                                    27
     C     OKINB5        COMP      'N'                                    28
      *
      **  Account with Bank
     C     OKACB1        COMP      'N'                                    29
     C     OKACB2        COMP      'N'                                    30
     C     OKACB3        COMP      'N'                                    31
     C     OKACB4        COMP      'N'                                    32
     C     OKACB5        COMP      'N'                                    33
      *
      **  Beneficiary
     C     OKBNC1        COMP      'N'                                    34
     C     OKBNC2        COMP      'N'                                    35
     C     OKBNC3        COMP      'N'                                    36
     C     OKBNC4        COMP      'N'                                    37
     C     OKBNC5        COMP      'N'                                    38
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Program entry parameter list
     C     *Entry        Plist
      *    Return code
     C                   Parm      *Blank        RetCodeOut
      *    Common Work Fields
     C                   Parm                    WorkFields
      *    Transaction screen fields
     C                   Parm                    SSIScrnFmt
      *    Error flag indicators
     C                   Parm                    FTEOPSI
      *    Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNameArr
     C                   Parm                    MsgIDArr
     C                   Parm                    MsgDtaArr
     C                   Parm                    Idx
      *    Warning fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    WFldNamArr
     C                   Parm                    WMsgIDArr
     C                   Parm                    WMsgDtaArr
     C                   Parm                    WIdx
      *
      ** Initialize program name
     C                   Movel     'FTOPSI2DP'   DBPGM
      *
      ** Move workstation ID to screen field.
     C                   Movel     PsJobName     DDWID
     C                   Move      @MRDT         DDMRDT
      *
      * Message subfile control
     C                   Move      '1'           *IN97
     C                   Movel     '*'           DDPGMQ
      *
      *
      ** Display MT103 fields
     C                   If        @CFT014 = 'Y'
     C                   Eval      *IN87 = *On
     C                   EndIf
      *
      ** Message subfile control
     C                   Move      '1'           *IN97
     C                   Movel     '*'           DDPGMQ
      *
      **------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SD *DSP
      ** functions for the message handler, ZAMSGHNDLE.
      /COPY FTCPYSRC,MSGHNDDATA
      **------------------------------------------------------------------------
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP2
      **
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2002
