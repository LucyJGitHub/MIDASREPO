     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Settlement details validate')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDSETLVU - SD Settlement Details Validate                    *
      *                                                               *
      *  Function: This Program Validates SD SETL for                 *
      *            Input into the Midas database.                     *
      *            Processes executed controlled by input Action Code *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the Transaction details fields        *
      *            - For A (=AMEND),                                  *
      *              - if transaction is a partial amendment, call a  *
      *                separate function to complete the transaction  *
      *                details.                                       *
      *              - if transaction is valid, call a separate       *
      *                function to check whether it is a valid        *
      *                amendment.                                     *
      *            - For D (=DELETE), call a separate function to     *
      *              process the transaction and bypass the rest of   *
      *              the validation.                                  *
      *                                                               *
      *            For all action codes, the decision to as to        *
      *            whether to write to the Valid or Invalid file and  *
      *            the call to the Message Handler will take place    *
      *            in this module                                     *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD052610           Date 04Feb19               *
      *                 MD046248           Date 27Oct17               *
      *                 MD046115           Date 28Jul17               *
      *                 CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244915             Date 05Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 03May06               *
      *                 CLE031             Date 26Apr05               *
      *                 CLE106 *CREATE     Date 01Aug04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD-52610 - when ddactn=action/enquire stop doung CovertSt    *
      *             querying of cust details is already done on java  *
      *  MD046248 - Finastra Rebranding                               *
      *  MD046115 - The settlements were blanks out when there is no  *
      *             record in LESTALPD.                               *
      *  CDL094 - Enhance Receive Settlement Instructions (Recompile) *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            CCR016: Settlement Allocation                      *
      *  244915 - Participant settlement is not defaulting            *
      *  CSD027A - Conversion of customer number to alpha (post       *
      *            build 103). Recompiled.                            *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CLE106 - Syndication Manager. Validate Wrapper for Settle-   *
      *           ment Details.                                       *
      *                                                               *
      *****************************************************************

     FLESTALLD  IF   E           K DISK    INFSR(*PSSR)                                      CSF011A
                                                                                             CSF011A
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
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
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.

     D/COPY ZACPYSRC,PROCPARMS

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

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

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      * Incoming Header
     D HeadIn        E DS                  EXTNAME(APHEADPD)

     D Trans1        E DS                  EXTNAME(SDESSXPD)
      * First Incoming Transaction
     D Trans2        E DS                  EXTNAME(SDESSRPD)
      * Second Incoming Transaction
     D Trans3        E DS                  EXTNAME(SDESSPPD)
      * Third Incoming Transaction
     D TranIn1       E DS                  EXTNAME(SDESSXPD)
     D                                     PREFIX(C_)
      * First Incoming Transaction
     D TranIn2       E DS                  EXTNAME(SDESSRPD)
     D                                     PREFIX(C_)
      * Second Incoming Transaction
     D TranIn3       E DS                  EXTNAME(SDESSPPD)
     D                                     PREFIX(C_)
      * Third Incoming Transaction
     D DBPaySttmt    E DS                  EXTNAME(SDESFPPD)

     D DBRecSttmt    E DS                  EXTNAME(SDESFRPD)

     D ##FRIS        E DS                  EXTNAME(SDESSFPD)
      * FRA/IRS Settlement Instructions - Input
     D ##FRIF        E DS                  EXTNAME(SDESSFPD)
     D                                     PREFIX(C_)
      * FRA/IRS Settlement Instructions - Input

     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for Access programs - short data structure

     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for Access programs - long data structure

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
                                                                                             CSF011A
     D DsStal        E DS                  EXTNAME(LESTALPD)                                 CSF011A
      ** External DS for Settlement Allocation                                               CSF011A
                                                                                             CSF011A
     D DDPYDT          S              5  0
     D DDRCDT          S              5  0
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Error message field(s)
     D     Msg1        S                   LIKE(#MsgID)

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0

      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0

      ** Index for arrays of error message ids etc in Amend validation
     D AmIdx           S              3P 0

      ** Field (500A) to receive the incoming transaction

      ** Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A

      ** Flags to indicate whether transaction fields are valid

      ** Flags to indicate whether Pay Settlement instruction fields
      **  are valid
     D OKPayInsDS      DS
     D  DDPscyOK                      1A   INZ('Y')
     D  DDPstmOK                      1A   INZ('Y')
     D  DDPonxOK                      1A   INZ('Y')
     D  DDRvnoOK                      1A   INZ('Y')
     D  DDCvmrOK                      1A   INZ('Y')
     D  DDPocnOK                      1A   INZ('Y')
     D  DDPobnOK                      1A   INZ('Y')
     D  DDRcrnOK                      1A   INZ('Y')
     D  DDRcraOK                      1A   INZ('Y')
     D  DDPibnOK                      1A   INZ('Y')
     D  DDPibaOK                      1A   INZ('Y')
     D  DDAwbnOK                      1A   INZ('Y')
     D  DDAwbaOK                      1A   INZ('Y')
     D  DDBennOK                      1A   INZ('Y')
     D  DDBenaOK                      1A   INZ('Y')
     D  DDDtp1OK                      1A   INZ('Y')
     D  DDDtp2OK                      1A   INZ('Y')
     D  DDDtp3OK                      1A   INZ('Y')
     D  DDDtp4OK                      1A   INZ('Y')
     D  DDDchgOK                      1A   INZ('Y')
     D  DDIc72OK                      1A   INZ('Y')
     D  DDBtb1OK                      1A   INZ('Y')
     D  DDBtb2OK                      1A   INZ('Y')
     D  DDBtb3OK                      1A   INZ('Y')
     D  DDBtb4OK                      1A   INZ('Y')
     D  DDBtb5OK                      1A   INZ('Y')
     D  DDBtb6OK                      1A   INZ('Y')

      ** Flags to indicate whether Receive Settlement instruction fields
      **  are valid
     D OKRecInsDS      DS
     D  DDRscyOK                      1A   INZ('Y')
     D  DDRstmOK                      1A   INZ('Y')
     D  DDRonxOK                      1A   INZ('Y')
     D  DDRocnOK                      1A   INZ('Y')
     D  DDRobnOK                      1A   INZ('Y')
     D  DDRibnOK                      1A   INZ('Y')
     D  DDRibaOK                      1A   INZ('Y')

      ** Flags to indicate whether FRA/IRS instruction fields are valid
     D OKFRAInsDS      DS
     D  DDDsr1OK                      1A   INZ('Y')
     D  DDDsr2OK                      1A   INZ('Y')
     D  DDDsr3OK                      1A   INZ('Y')
     D  DDDsr4OK                      1A   INZ('Y')
     D  DDDsr5OK                      1A   INZ('Y')
     D  DDDsr6OK                      1A   INZ('Y')
     D  DDSsr1OK                      1A   INZ('Y')
     D  DDSsr2OK                      1A   INZ('Y')
     D  DDSsr3OK                      1A   INZ('Y')
     D  DDSsr4OK                      1A   INZ('Y')
     D  DDSsr5OK                      1A   INZ('Y')
     D  DDSsr6OK                      1A   INZ('Y')
     D  DDCnd1OK                      1A   INZ('Y')
     D  DDCnd2OK                      1A   INZ('Y')
     D  DDCnd3OK                      1A   INZ('Y')
     D  DDCnd4OK                      1A   INZ('Y')
     D  DDCnd5OK                      1A   INZ('Y')
     D  DDCnd6OK                      1A   INZ('Y')
     D  DDIsdaOK                      1A   INZ('Y')
     D  DDAgtyOK                      1A   INZ('Y')
     D  DDAgdtOK                      1A   INZ('Y')
     D  DDAgvvOK                      1A   INZ('Y')

      ** A code to indicate the calling function to the lower level modules
     D LEND            S              4A   INZ('LEND')

      ** Payment & Receipt dates, passed to Settlements Validation routine.
      ** spaces in parameter list not used by this function
     D PayDat          S              5P 0 INZ(99999)
     D RecDat          S              5P 0 INZ(99999)

      ** Value Date as a Midas Day Number to be placed in either Payment
      **  or Receipt Date
     D ValDateMDN      S              5P 0

      ** Error Flag for call to Standard routines (equates to *IN99)
     D ErrorFlag       S              1A   INZ('N')
     ** Additional parameters for Settlement defaulting module
     D Blank4          S              4A
     D Blank6          S              6A
     D Blank6X         S              6A
     D Blank2          S              2A
     D Blank2X         S              2A
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095
                                                                                              CSD095
     D ##FFND          S              1A
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
     D ##REXR          S                   LIKE(FLREXR)                                      CSF011A
     D ##PEXR          S                   LIKE(FLPEXR)                                      CSF011A

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

     C                   MOVEL     Trans1        TranIn1
     C                   MOVEL     Trans2        TranIn2
     C                   MOVEL     Trans3        TranIn3

      * Reset variables gradually updated

     C                   EXSR      RESETCYCLE

     C                   IF        DDPSTM = *BLANKS
     C                   EVAL      C_DDPSTM = '00'
     C                   ENDIF
     C                   IF        DDRSTM = *BLANKS
     C                   EVAL      C_DDRSTM = '00'
     C                   ENDIF
     C                   SELECT
     C                   WHEN      DDPVAL = 'Y' AND DDRVAL <> 'Y'
     C                   EVAL      ##PREC = 'Y'
     C                   EVAL      ##PPAY = ' '                                              CSF011A
     C                   WHEN      DDRVAL = 'Y' AND DDPVAL <> 'Y'
     C                   EVAL      ##PPAY = 'Y'
     C                   EVAL      ##PREC = ' '                                              CSF011A
     C                   WHEN      DDRVAL = 'Y' AND DDPVAL = 'Y'
     C                   EVAL      ##PPAY = *BLANKS
     C                   EVAL      ##PREC = *BLANKS
     C                   ENDSL

      *  Processing depends upon Action Code

     C                   SELECT

     C                   WHEN      DDACTN = 'I'
      *                                                                                       244915
      ** Set payment and receipt settlement method to blanks instead                          244915
      ** of '00' to execute settle instruction defaulting module                              244915
      *                                                                                       244915
     C                   If        C_DDRSTM = '00'                                            244915
     C                             And C_DDPSTM = '00'                                        244915
     C                   Eval      C_DDRSTM = *Blanks                                         244915
     C                   Eval      C_DDPSTM = *Blanks                                         244915
     C                   EndIf                                                                244915
      *  Processing for Inserts
     C                   EXSR      DftSettmts
      *                                                                                       244915
      ** Old payment and receive method was passed to buffer, override                        244915
      **  new payment and receive method                                                      244915
      *                                                                                       244915
     C                   Eval      DDRSTM = C_DDRSTM                                          244915
     C                   Eval      DDPSTM = C_DDPSTM                                          244915
     C                   EXSR      ValidateSt

     C                   WHEN      DDACTN = 'A'
      *  Processing for Amends
     C                   EXSR      ValidateSt
      *                                                                                      CSF011A
     C                   WHEN      DDACTN = ' '                                              CSF011A
      *                                                                                      CSF011A
      *  Processing for Action and Enquire                                                   CSF011A
      *                                                                                      CSF011A
     C**********         EXSR      ConvertSt                                        CSF011A MD052610
      *                                                                                      CSF011A
     C                   EXSR      ValidateSt                                               MD052610
     C                   ENDSL
      *
     C     INVALID       TAG
     C                   SETON                                        LR

      ** Move back the value of settlement method
     C                   EVAL      C_DDPSTM = DDPSTM
     C                   EVAL      C_DDRSTM = DDRSTM

     C                   EVAL      Buffer = TranIn1 + TranIn2 + TranIn3

     C                   RETURN

      *****************************************************************
      *                                                               *
      * DftSettmts - Routine to apply default settlement instructions *
      *    if none have been supplied                                 *
      *                                                               *
      *****************************************************************

     C     DftSettmts    BEGSR

     C                   IF            (TranIn2 = *blank)
     C                             AND (TranIn3 = *blank)

     C                   CALLB     'ZASETINDFT'

      ** Output
      ** Calling function type
     C                   PARM                    LEND
      ** Payment currency
     C                   PARM                    C_DDTCUR
      ** Receive currency
     C                   PARM                    C_DDTCUR
      ** Customer (shortname or number)
     C                   PARM                    DDCUST
      ** Deal type
     C                   PARM                    DDLTYP
      ** Federal Funds Ind.
     C                   PARM      *BLANK        ##FFND
      ** ISDA Rules for FRA/IRS deals only
      ** Version of ISDA Rules govern
     C                   PARM                    Blank4
      ** Type of ISDA agreement
     C                   PARM                    Blank6
      ** Date of ISDA Agreement
     C                   PARM                    Blank6X           6
      ** Version of ISDA Agreement
     C                   PARM                    Blank2
      *
      ** Version century of ISDA Agreement
     C                   PARM                    Blank2X           2
                                                                                              CSD095
      ** Deal Subtype                                                                         CSD095
     C                   PARM      *BLANK        BlankSTYP                                    CSD095
                                                                                              CSD095
      ** Branch                                                                               CSD095
     C                   PARM      *BLANK        BlankBRCA                                    CSD095
      *
      ** Return
      ** Defaulted Payment Settlement Instruction in file format
     C                   PARM                    DBPaySttmt
      ** Defaulted Receipt Settlement Instruction in file format
     C                   PARM                    DBRecSttmt
      ** Defaulted FRA/IRS Settlement Instruction in file format
     C                   PARM                    ##FRIF

      *  The defaulted instructions are in file format, but the
      *   Settlements validation requires that they are in the input format.
      *  Therefore run them through a conversion module.

     C                   CALLB     'ZASETINCVT'
      ** Defaulted Settlement Instructions in file format
     C                   PARM                    DBPaySttmt
     C                   PARM                    DBRecSttmt
     C                   PARM                    ##FRIF

      ** Defaulted Settlement Instruction in input format
     C                   PARM                    TranIn3
     C                   PARM                    TranIn2
     C                   PARM                    ##FRIS
     C                   PARM      C_DDTCUR      #TRCCY                                      CSF011A
     C                   PARM      C_DDTCUR      #TPCCY                                      CSF011A

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateSt - Routine to validate the settlemnt instructions   *
      *                                                               *
      *****************************************************************

     C     ValidateSt    BEGSR

     C                   EVAL      DDRCDT = 99999
     C                   EVAL      DDPYDT = 99999

     C                   RESET                   ReturnCode
     C                   CALLB     'ZASETINVAL'

      ** Return Code
     C                   PARM                    ReturnCode
      ** Following parameters are output to called module
      ** Calling function type
     C                   PARM                    LEND
      ** Transaction Fields
      ** Payment currency
     C                   PARM                    DDTCUR
      ** Receive currency
     C                   PARM                    DDTCUR
      ** Customer (shortname or number)
     C                   PARM                    DDCUST
      ** Deal type
     C                   PARM                    DDLTYP
      ** Federal Funds Ind.
     C                   PARM                    ##FFND
      ** Booking Branch
     C                   PARM                    DDBRCA
      ** Receipt Date
     C                   PARM                    DDRCDT
      ** Payment Date
     C                   PARM                    DDPYDT
      ** Input (or Defaulted) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    TranIn3
     C                   PARM                    TranIn2
     C                   PARM                    ##FRIS

      * Action Code
     C                   PARM                    DDACTN
      * Protect Payment Field
     C                   PARM                    ##PPAY            1
      * Protect Receipt Field
     C                   PARM                    ##PREC            1

      ** Following parameters are returned by called module
      ** Payment Instruction OK flag
     C                   PARM                    OKPayInsDS
      ** Receive Instruction OK flag
     C                   PARM                    OKRecInsDS
      ** FRA/IRS Instruction OK flag
     C                   PARM                    OKFRAInsDS
      * Error fields/message IDs (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx
      ** File (D/B) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    DBPaySttmt
     C                   PARM                    DBRecSttmt
     C                   PARM                    ##FRIF
      ** Action Code used
     C                   PARM      DDACTN        ##ACTN            1
      ** Validation Iteration
     C                   PARM      '1ST'         ##ValIter         3

     C                   EVAL      DDPEXI = FLPEXI
     C     ValSetExit    TAG

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                      CSF011A
      *                                                               *                      CSF011A
      * ConvertSt - Routine to convert the settlemnt instructions     *                      CSF011A
      *             to its screen format                              *                      CSF011A
      *                                                               *                      CSF011A
      *****************************************************************                      CSF011A
                                                                                             CSF011A
     C     ConvertSt     BEGSR                                                               CSF011A
                                                                                             CSF011A
      ** Key list for access to LESTALPD file                                                CSF011A
                                                                                             CSF011A
     C     @KEY1         KLIST                                                               CSF011A
     C                   KFLD                    DDPTRF                                      CSF011A
     C                   KFLD                    DDPSTM                                      CSF011A
     C                   KFLD                    DDRSTM                                      CSF011A
     C                                                                                       CSF011A
                                                                                             CSF011A
      ** Retrieve Settlement Instructions                                                    CSF011A
                                                                                             CSF011A
     C     @KEY1         CHAIN     LESTALLD                                                  CSF011A
     C                   IF        %FOUND(LESTALLD)                                          CSF011A
                                                                                             CSF011A
      ** Payment Settlement Instructions                                                     CSF011A
                                                                                             CSF011A
     C                   IF        DDPSTM <> *BLANKS                                         CSF011A
     C                   EVAL      FLPSTM = %INT(PSTM)                                       CSF011A
     C                   EVAL      FLPONS = PONS                                             CSF011A
     C                   EVAL      %SUBST(DBPaySttmt:21) =                                   CSF011A
     C                             %SUBST(DsStal:188:555)                                    CSF011A
     C                   EVAL      FLPEXR = PEXR                                             CSF011A
     C                   EVAL      FLPEXI = PEXI                                             CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
      ** Receipt Settlement Instructions                                                     CSF011A
                                                                                             CSF011A
     C                   IF        DDRSTM <> *BLANKS                                         CSF011A
     c                   EVAL      FLRSTM = %INT(RSTM)                                       CSF011A
     C                   EVAL      FLRONS = RONS                                             CSF011A
     C                   EVAL      %SUBST(DBRecSttmt:21) =                                   CSF011A
     C                             %SUBST(DsStal:98:61)                                      CSF011A
     C                   EVAL      FLREXR = REXR                                             CSF011A
     C                   EVAL      FLREXI = REXI                                             CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
     C**********         ENDIF                                                      CSF011A MD046115
                                                                                             CSF011A
     C                   CALLB     'ZASETINCVT'                                              CSF011A
                                                                                             CSF011A
     C                   PARM                    DBPaySttmt                                  CSF011A
     C                   PARM                    DBRecSttmt                                  CSF011A
     C                   PARM                    ##FRIF                                      CSF011A
     C                   PARM                    TranIn3                                     CSF011A
     C                   PARM                    TranIn2                                     CSF011A
     C                   PARM                    ##FRIS                                      CSF011A
     C                   PARM      C_DDTCUR      #TRCCY                                      CSF011A
     C                   PARM      C_DDTCUR      #TPCCY                                      CSF011A
     C                   ENDIF                                                              MD046115
      *                                                                                     MD046115
     C                   EXSR      ValidateSt                                               MD046115
                                                                                             CSF011A
     C                   ENDSR                                                               CSF011A
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RESETCYCLE- Reset error information that is gradually         *
      *    updated during each run of this program                    *
      *                                                               *
      *****************************************************************

     C     RESETCYCLE    BEGSR

     C                   RESET                   FldNameArr
     C                   RESET                   MsgIDArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   Idx

     C                   RESET                   WFldNamArr
     C                   RESET                   WMsgIDArr
     C                   RESET                   WMsgDtaArr
     C                   RESET                   WIdx


     C                   RESET                   OKPayInsDS
     C                   RESET                   OKRecInsDS
     C                   RESET                   OKFRAInsDS

     C                   RESET                   PayDat
     C                   RESET                   RecDat

      ** Have to clear the settlement data structure, or the packed numeric
      ** fields are not initialised correctly.
     C                   CLEAR                   DBPaySttmt
     C                   CLEAR                   DBRecSttmt
     C                   CLEAR                   ##FRIF
     C                   CLEAR                   DsStal                                      CSF011A

     C                   EVAL      ##PPAY = ' '                                              CSF011A
     C                   EVAL      ##PREC = ' '                                              CSF011A
                                                                                             CSF011A
     C                   IF        (C_DDPSTM <> '01' AND                                     CSF011A
     C                              C_DDPSTM <> '07' AND                                     CSF011A
     C                              C_DDPSTM <> '08') AND                                    CSF011A
     C                              C_DDCVMR = 'N'                                           CSF011A
     C                   EVAL      C_DDCVMR = *BLANKS                                        CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
     C                   ENDSR
      *****************************************************************
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
      * Common header information (DS) from source system
     C                   PARM                    HeadIn
      * Transaction information in a single large field from source system
     C                   PARM                    Trans1
      * Transaction information in a single large field from source system
     C                   PARM                    Trans2
      * Transaction information in a single large field from source system
     C                   PARM                    Trans3
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN          1
     C                   PARM                    Buffer         6000
     C                   PARM                    APIRetc           1

      * Set up the names of the message files from which the message handler
      * will get the messages
     C                   EVAL      MsgFArray(1) = 'DRSMM'

      * Hook to enable non-core message files to be included


     C                   ENDSR
      /EJECT
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   EVAL      APIRETC = '0'
     C                   RETURN
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2005
