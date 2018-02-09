     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Outgoing Payments Insert Screen')             *
      *****************************************************************
      *                                                               *
      *  Midas - API Funds Transfer Module                            *
      *                                                               *
      *  FTOPAY7DP - Outgoing Payments SSI Initial Insert Screen      *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD035776           Date 10Sep15               *
      *                 MD027047           Date 19Aug14               *
      *                 CFT120             Date 28Sep12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CFT018  *CREATE    Date 29Nov02               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD035776 - User need to press twice on input screen          *
      *           - Remove unsupported keywords of HATS from dspf     *
      *             (Recompile)                                       *
      *  MD027047 - Avoid HATS issue with redisplaying previous screen*
      *             on the stack. End program with SETON LR with no   *
      *             RETURN.                                           *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  CFT018 - Standard Settlement Instructions for                *
      *           Outgoing Payments                                   *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FFTOPAY7DF CF   E             WORKSTN INFSR(*pssr)
      *
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
      *
      *****************************************************************
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
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
     D Idx             S              3P 0
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
     D FTEOPY7       E DS                  EXTNAME(FTEOPY7PD)
      * Error indicators - SSI Payment Insert Screen
      *
     D NewPmtScn7    E DS                  EXTNAME(FTOPY8PD)
      *  New Payment in Screen Format (SSI Insert Screen)
      *
     D SSIScrnFmt    E DS                  EXTNAME(FTOPSIPD) PREFIX(S)
      * Current Outgoing Payment SSI in Screen Format
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
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
      *
      **  Initialisation
     C                   Exsr      INIT
      *
      **  Display Screen
     C                   Exsr      DspScrn
      *
      **  Return to calling program
     C**********         Return                                                             MD027047
     C                   SETON                                        LR                    MD027047
      *
      /EJECT
      **********************************************************************
      * INIT - Initialisation Processing each time module is invoked
      **********************************************************************
     C     INIT          BEGSR
      *
      **  Reset all screen function indicator work fields which are
      **  returned to calling program
     C                   Move      '0'           @INKC             1
     C                   Move      '0'           @INKF             1
     C                   Move      '0'           @INKL             1
      *
      **  If payment being created from SSI then protect fields from input
     C     @CrtPmnt      Ifeq      'Y'
     C                   Move      *On           *IN69
     C                   Else
     C                   Move      *Off          *IN69
     C                   Endif
      *
      **  If payment being created from SSI and is valid then
      **  display screen with F6 enabled to confirm the payment
     C     @ValidPay     Ifeq      'Y'
     C                   Move      *On           *IN68
     C                   Else
     C                   Move      *Off          *IN68
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
     C                   Eval      TranRef = SSDRCY+SSDRAC+SSREF1+
     C                                       SSREF2+SSCRCY
     C                   Eval      ActionCode = 'I'
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
     C                   Move      *ALL'Y'       FTEOPY7
      *
      **  Retrieve time for display
     C                   Time                    DDTIME
      *
      **  Write out screen with message subfile and footer
     C                   Write     FTOPAY7F1
     C                   Write     FTOPAY7S0
     C                   Write     FTOPAY7D1
      *
      **  Read response from screen
     C                   Read      FTOPAY7D1
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
      **  F6 = Insert Payment
     C     *INKF         Wheneq    *On
     C                   Movel     '1'           @INKF
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
      ** Debit Account
     C     OKDRAC        COMP      'N'                                    11
      *
      ** Credit Account
     C     OKCRAC        COMP      'N'                                    12
      *
      ** Settle/Debit Ccy
     C     OKDRCY        COMP      'N'                                    13
      *
      ** Pay/Credit Ccy
     C     OKCRCY        COMP      'N'                                    14
      *
      ** Settle Amount
     C     OKSMAM        COMP      'N'                                    15
      *
      ** Pay Amount
     C     OKPYAM        COMP      'N'                                    16
      *
      ** Settle Value date
     C     OKPYDT        COMP      'N'                                    17
      *
      ** Pay Value Date
     C     OKPYVD        COMP      'N'                                    18
      *
      ** Rate
     C     OKRATE        COMP      'N'                                    19
      *
      ** Override
     C     OKOVRD        COMP      'N'                                    20
      *
      ** Details of Payment
     C     OKDTP1        COMP      'N'                                    21
     C     OKDTP2        COMP      'N'                                    22
     C     OKDTP3        COMP      'N'                                    23
     C     OKDTP4        COMP      'N'                                    24
      *
      ** Bank to Bank Information
     C     OKBBI1        COMP      'N'                                    25
     C     OKBBI2        COMP      'N'                                    26
     C     OKBBI3        COMP      'N'                                    27
     C     OKBBI4        COMP      'N'                                    28
     C     OKBBI5        COMP      'N'                                    29
     C     OKBBI6        COMP      'N'                                    30
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
      *    Create new payment from SSI indicator
     C                   Parm                    @CrtPmnt          1
      *    Flag to indicate new payment from SSI is valid
     C                   PARM                    @ValidPay         1
      *    Screen format details for display
     C                   Parm                    NewPmtScn7
      *    SSI details in screen format
     C                   Parm                    SSIScrnFmt
      **   OK inds
     C                   Parm                    FTEOPY7
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
      *    Function Keys
     C                   Parm                    @INKC
     C                   Parm                    @INKF
     C                   Parm                    @INKL
      *
      ** Initialize program name
     C                   Movel     'FTOPAY7DP'   DBPGM
      *
      ** Get Bank Details
     C                   Call      'AOBANKR0'
     C                   Parm      *BLANKS       @RTCD             7
     C                   Parm      '*FIRST '     @OPTN             7
     C     SDBANK        Parm      SDBANK        DSFDY
      *
      ** Database error if record not found
     C     @RTCD         Ifne      *BLANKS
     C                   Movel     'SDBANKPD'    DBFILE
     C                   Movel     '901'         DBASE
     C                   Movel     @OPTN         DBKEY
     C                   Exsr      *PSSR
     C                   End
      *
      ** Move workstation ID to screen field.
     C                   Movel     PsJobName     DDWID
     C                   Move      BJMRDT        DDMRDT
      *
      * Message subfile control
     C                   Move      '1'           *IN94
     C                   Movel     '*'           DDPGMQ
      *
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SD *DSP
      ** functions for the message handler, ZAMSGHNDLE.
      /COPY FTCPYSRC,MSGHNDDATA
      **--------------------------------------------------------------------------------------------
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP2
      **                                                                    ------------------------
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
