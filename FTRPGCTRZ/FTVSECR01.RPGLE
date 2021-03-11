     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate senders correspondent header')       *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVSECR01  - Validate Sender's Correspondent                 *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CSW207             Date 07Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 221760             Date 01Apr04               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      *                 184060             Date 22Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT008  *CREATE    Date 17Nov99               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - Swift 2007 Changes (Recompiled)                     *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  221760 - Do not validate SWIFT ID if MEBICDPD is empty.      *
      *  CSW201 - SWIFT 2001 Standards Update (Recompiled)            *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  184060 - No transaction type code in detail screen -Recompile*
      *  CFT008 - Funds Transfer/Swift Messages MT102                 *
      *                                                               *
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

      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** Program, procedure and module names for parameters
      ** ==================================================

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      * Header record datastructure
     D HdrRcdIn      E DS                  EXTNAME(FT102HSPD)
     D DtlRcdIn      E DS                  EXTNAME(FT102DSPD) PREFIX(D)

      *  External Data structure to hold the outgoing record format
     D ACCNT         E DS                  EXTNAME(ACCNTAB)
     D   ACBRCA      E                     EXTFLD(BRCA)
     D   ACPRFC      E                     EXTFLD(PRFC)

      ** External data structure for access programs (Long)
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D wvalid          S              1
     D wivld           S              1
     D wdvld           S              1
     D wsvld           S              1
     D wrvld           S              1
     D CFT004          S              1
     D XSINST          S                   Like(PSINST)

      * OK Flags for first screen - Header
     D OKFlagHs1     E DS                  EXTNAME(FTE102H1PD)

     D GenOkFlag2      S              1    Import
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

     C                   Eval      RetCodeIn  = *Blanks
     C                   Eval      Idx        = 0
     C                   Eval      WIdx       = 0
     C                   Eval      PTType = *Blanks
     C                   Eval      PType = *Blanks
     C                   Eval      PSndTyp = *Blanks
     C                   Eval      GenOkFlag2 = 'Y'

     C                   Eval      wsvld = 'Y'
     C                   Eval      wrvld = 'Y'
     C                   Eval      wdvld = 'Y'
     C                   Eval      wivld = 'Y'
      *
      ** Check to see if sending institution has a valid field
      *
     C                   Eval      PACCT = PSinst
     C                   Exsr      SrAcct

      ** Account invalid for Sending Institution
     C                   If        wvalid = 'N'
     C                   Eval      wivld = 'N'
     C                   Endif

      *
      ** Check to see if destination has a valid entry
      *
     C                   Eval      PACCT = PCctDst
     C                   Exsr      SrAcct

      ** Account invalid for destination
     C                   If        wvalid = 'N'
     C                   Eval      wdvld = 'N'
     C                   Endif

      *
      ** Check to see if receiver's correspondent has a valid entry
      *
     C                   Eval      PACCT = PRCVCOR
     C                   Exsr      SrAcct

      ** Account invalid for receivers correspondent
     C                   If        wvalid = 'N'
     C                   Eval      wrvld = 'N'
     C                   Endif

     C                   Select
     C                   When      PCCTTYP = 'BO' and
     C                             wdvld = 'N' and
     C                             wrvld = 'N'
     C                   If        PsndCor = *blanks
     C                   Eval      GenOkFlag2 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      RetCodeIn = 'Error'
     C                   Eval      FldNamXAr(Idx) = DDSName
     C                   Eval      MsgIdXAr(Idx) = 'RFV0344'
     C                   Else
     C                   Eval      PACCT = PSNDCOR
     C                   Exsr      SrAcct
      ** Account invalid
     C                   If        wvalid = 'N'
     C                   Eval      GenOkFlag2 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      RetCodeIn = 'Error'
     C                   Eval      FldNamXAr(Idx) = DDSName
     C                   Eval      MsgIdXAr(Idx) = 'RFV0344'
     C                   Else
      *
      *
      ** If a valid account and starts with a '/', remove it.
      *
     C                   If        %Subst(PSNDCOR:1:1) = '/'
     C                   Eval      PSNDCOR = %Subst(PSNDCOR:2)
     C                   Endif

     C                   Select
     C                   When      PTYPE = 'IBAN'
     C                   Eval      PSNDTYP = 'I'
     C                   When      PTYPE = '*LEDGER'
     C                   Eval      PSNDTYP = 'G'
     C                   When      PTYPE = '*NOSTRO'
     C                   Eval      PSNDTYP = 'F'
     C                   When      PTYPE = '*RETAIL'
     C                   Eval      PSNDTYP = 'R'
     C                   Endsl
      *
     C                   Endif
      *
     C                   Endif
      *
     C                   WHEN      PCCTTYP = 'BI' and
     C                             wivld = 'N' and
     C                             wrvld = 'N'
      *
     C                   If        PsndCor = *blanks
     C                   Eval      GenOkFlag2 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      RetCodeIn = 'Error'
     C                   Eval      FldNamXAr(Idx) = DDSName
     C                   Eval      MsgIdXAr(Idx) = 'RFV0345'
     C                   Else
     C                   Eval      PACCT = PSNDCOR
     C                   Exsr      SrAcct
      *
      ** Account invalid
     C                   If        wvalid = 'N'
     C                   Eval      GenOkFlag2 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      RetCodeIn = 'Error'
     C                   Eval      FldNamXAr(Idx) = DDSName
     C                   Eval      MsgIdXAr(Idx) = 'RFV0345'
     C                   Else
      *
      *
      ** If a valid account and starts with a '/', remove it.
      *
     C                   If        %Subst(PSNDCOR:1:1) = '/'
     C                   Eval      PSNDCOR = %Subst(PSNDCOR:2)
     C                   Endif

     C                   Select
     C                   When      PTYPE = 'IBAN'
     C                   Eval      PSNDTYP = 'I'
     C                   When      PTYPE = '*LEDGER'
     C                   Eval      PSNDTYP = 'G'
     C                   When      PTYPE = '*NOSTRO'
     C                   Eval      PSNDTYP = 'F'
     C                   When      PTYPE = '*RETAIL'
     C                   Eval      PSNDTYP = 'R'
     C                   Endsl
      *
     C                   Endif
      *
     C                   Endif
      *
      ** If these fields do contain valid account then entry can be
      ** swift B.I.C, customer number or shortname.
      *
     C                   Other
      *
     C                   If        PSNDCOR <> *Blanks
     C**********         CallB     'AOBICDV0'                                                 221760
     C                   CallB     'AOBICDV01'                                                221760
     C                   Parm                    RetCodeIn
     C                   Parm                    PSNDCOR
     C                   Parm                    PTType            7
     C                   Parm                    Dssdy

     C                   If        PTType = '*BIC   ' or
     C                             PTType =  '*NUMBER'  and
     C                             RetCodeIn = '*BICFND' or
     C                             PTType =  '*SHNAME' and
     C                             RetCodeIn = '*BICFND'
     C                   Eval      PACCT = PSNDCOR
     C                   Exsr      SrAcct
     C                   Select
     C                   When      PTYPE = 'IBAN'
     C                   Eval      PSNDTYP = 'I'
     C                   When      PTYPE = '*LEDGER'
     C                   Eval      PSNDTYP = 'G'
     C                   When      PTYPE = '*NOSTRO'
     C                   Eval      PSNDTYP = 'F'
     C                   When      PTYPE = '*RETAIL'
     C                   Eval      PSNDTYP = 'R'
     C                   Endsl

     C                   Else

     C                   Eval      PACCT = PSNDCOR
     C                   Exsr      SrAcct
      *
      ** Must be BIC, customer number, shortname or valid account
      *
     C                   If        wvalid = 'N'
     C                   Eval      GenOkFlag2 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      RetCodeIn = 'Error'
     C                   Eval      FldNamXAr(Idx) = DDSName
     C                   Eval      MsgIdXAr(Idx) = 'RFV0220'
     C                   Else

      *
      ** If a valid account and starts with a '/', remove it.
      *
     C                   If        %Subst(PSNDCOR:1:1) = '/'
     C                   Eval      PSNDCOR = %Subst(PSNDCOR:2)
     C                   Endif

     C                   Select
     C                   When      PTYPE = 'IBAN'
     C                   Eval      PSNDTYP = 'I'
     C                   When      PTYPE = '*LEDGER'
     C                   Eval      PSNDTYP = 'G'
     C                   When      PTYPE = '*NOSTRO'
     C                   Eval      PSNDTYP = 'F'
     C                   When      PTYPE = '*RETAIL'
     C                   Eval      PSNDTYP = 'R'
     C                   Endsl

     C                   Endif
     C                   Endif

     C                   Endif
     C                   Endsl

      * Now validate that all data entered is OK for SWIFT

     C                   If        PSNDCOR <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      PSNDCOR       Swift_Text       50
     C                   If        RetCdeIn = 'Error'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'
     C                   Eval      FldNamXAr(Idx) =  DDSName
     C                   Eval      GenOkFlag2 = 'N'
     C                   Endif
     C                   Endif


     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrAcct - Checks for valid account                             *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: AOIBANR2, AOACCTV1                                     *
      *                                                               *
      *****************************************************************
     C     SrAcct        Begsr

     C                   Eval      PTYPE = *Blanks
     C                   Eval      wvalid = 'Y'

      ** CFT is switched on
     C                   If        CFT004 = 'Y'

      ** Validate Account
     C                   CallB     'AOIBANR2'
     C                   Parm      *Blanks       PRTCD
     C                   Parm                    PACCT            35
     C     ACCNT         Parm      ACCNT         DSSDY

     C                   If        PRTCD = *Blanks
     C                   Eval      PTYPE = 'IBAN'
     C                   Endif
     C                   Endif

     C                   If        PTYPE <> 'IBAN'

      ** Validate Account
     C                   CallB     'AOACCTV1'
     C                   Parm      *Blanks       PRTCD             7            B:Return code
     C                   Parm                    PTYPE             7            I:A/c ID
     C                   Parm                    PACCT                          I:A/c Currency
     C                   Parm                    DSSDY                          I:A/c code
     C                   Endif

      ** Invalid Account
     C                   If        PTYPE <> 'IBAN' and
     C                             PTYPE <> '*NOSTRO'  and
     C                             PTYPE <> '*RETAIL'  and
     C                             PTYPE <> '*LEDGER' or
     C                             PRTCD <> *Blanks
     C                   Eval      wvalid = 'N'
     C                   Endif

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        Begsr

     C     *Entry        PLIST

      ** INPUTS

     C                   Parm                    RetCodeIn
     C                   Parm                    RespMode          1
     C                   Parm                    ActionCode        1

      ** Screen fields
     C                   Parm                    HdrRcdIn
     C                   Parm                    DtlRcdIn
     C                   PARM                    OKFlagHS1

      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr
     C                   Parm                    DDSName          10

      ** Access SAR file to see if CFT004 is present
     C                   CallB     'AOSARDR0'
     C                   Parm      *Blanks       PRTCD
     C                   Parm      '*VERIFY'     POPTN             7
     C                   Parm      'CFT004'      PSARD             6
     C                   Parm                    DSSDY
      *
     C                   Eval      CFT004 = 'N'
     C                   If        PRTCD = *Blanks
     C                   Eval      CFT004 = 'Y'
     C                   Endif

      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

     C/COPY ZACPYSRC,DBFIELDS

     C                   Endsr                                                  *** InzEnd ***

      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
