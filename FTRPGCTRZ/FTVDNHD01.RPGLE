     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate destination header')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVDNHD01  - Validate Destination Header                     *
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
      *                 BUG8579            Date 20Sep05               *
      *                 CLE025             Date 20Oct03               *
      *                 221760             Date 01Apr04               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      *                 184060             Date 22Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 177668             Date 10Apr00               *
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
      *  BUG8579- Customer number with a swift ID is valid            *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  221760 - Do not validate SWIFT ID if MEBICDPD is empty.      *
      *  CSW201 - SWIFT 2001 Standards Update (Recompiled)            *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  184060 - No transaction type code in detail screen -Recompile*
      *  177668 - GEMS Fix number- Incorrect validation/not allowing  *
      *           BIC entry                                           *
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

     D N@FMT         E DS                  EXTNAME(SDNOSTPD)
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D wvalid          S              1
     D wsvld           S              1
     D wrvld           S              1
     D CFT004          S              1
     D XCCTDST         S                   Like(PCCTDST)

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
     C                   Eval      GenOkFlag2 = 'Y'
     C                   Eval      wsvld = 'Y'
     C                   Eval      wrvld = 'Y'
     C                   Eval      PDstTyp = *Blanks

     C                   If        PCCTTYP = 'BI'  AND
     C                             PCCTDST <> *Blanks
     C                   Eval      GenOkFlag2 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      RetCodeIn = 'Error'
     C                   Eval      FldNamXAr(Idx) = DDSName
     C                   Eval      MsgIdXAr(Idx) = 'RFV0211'
     C                   Endif

     C                   If        PCCTTYP = 'BO'  AND
     C                             PCCTDST = *Blanks
     C                   Eval      GenOkFlag2 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      RetCodeIn = 'Error'
     C                   Eval      FldNamXAr(Idx) = DDSName
     C                   Eval      MsgIdXAr(Idx) = 'RFV0365'
     C                   Return
     C                   Endif

     C                   If        PCCTTYP = 'BO' and
     C                             PCCTDST <> *Blanks

     C                   Eval      wsvld = 'Y'
     C                   Eval      wrvld = 'Y'
      *
      ** Check to see if sender's correspondent has a valid account
      *
     C                   Eval      PACCT = PSndCor
     C                   Exsr      SrAcct
      *
      ** Account invalid for senders correspondent
     C                   If        wvalid = 'N'
     C                   Eval      wsvld = 'N'
     C                   Endif
      *
      ** Check to see if Receiver's correspondent has a valid account
      *
     C                   Eval      PACCT = PRcvCor
     C                   Exsr      SrAcct
      *
      ** Account invalid for receivers correspondent
     C                   If        wvalid = 'N'
     C                   Eval      wrvld = 'N'
     C                   Endif
      *
     C                   Select
      *
      ** Both sender and receivers correspondent have a invalid account
     C                   When      wsvld = 'N' and
     C                             wrvld = 'N'
      ** Mandatory
     C                   If        PCCTDST = *Blanks
     C                   Eval      GenOkFlag2 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      RetCodeIn = 'Error'
     C                   Eval      FldNamXAr(Idx) = DDSName
     C                   Eval      MsgIdXAr(Idx) = 'RFV0212'
     C                   Endif
      *
     C                   If        PCCTDST <> *Blanks
     C                   Eval      PACCT = PCCTDST
     C                   Exsr      SrAcct
      *
      ** Account invalid
     C                   If        wvalid = 'N'
     C                   Eval      GenOkFlag2 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      RetCodeIn = 'Error'
     C                   Eval      FldNamXAr(Idx) = DDSName
     C                   Eval      MsgIdXAr(Idx) = 'RFV0213'
     C                   Else

     C                   Select
     C                   When      PTYPE = 'IBAN'
     C                   Eval      PDSTTYP = 'I'
     C                   When      PTYPE = '*LEDGER'
     C                   Eval      PDSTTYP = 'G'
     C                   When      PTYPE = '*NOSTRO'
     C                   Eval      PDSTTYP = 'F'
     C                   When      PTYPE = '*RETAIL'
     C                   Eval      PDSTTYP = 'R'
     C                   Endsl
      *
     C                   Endif
      *
     C                   Endif
      *
      ** Either sender or receivers correspondent has a valid account
      *
     C****               When      PCCTDST <> *blanks                                177668
     C****               Eval      XCCTDST = PCCTDST                                 177668
     C****               CallB     'AOBICV0M'                                        177668
     C****               Parm                    RetCodeIn                           177668
     C****               Parm                    XCCTDST                             177668
     C****               Parm                    PTType            7                 177668
     C****               Parm                    Dssdy                               177668
      ****                                                                           177668
     C****               If        PTType = '*BIC   ' or                             177668
     C****                         PTType =  '*NUMBER'  and                          177668
     C****                         RetCodeIn = '*BICFND' or                          177668
     C****                         PTType =  '*SHNAME' and                           177668
     C****                         RetCodeIn = '*BICFND'                             177668
     C****               Else                                                        177668
     C****               Eval      PACCT = PCCTDST                                   177668
     C****               Exsr      SrAcct                                            177668
      ****                                                                           177668
      ***Must be BIC, customer number, shortname or valid account                    177668
     C****               If        wvalid = 'N'                                      177668
     C****               Eval      GenOkFlag2 = 'N'                                  177668
     C****               Eval      Idx = Idx + 1                                     177668
     C****               Eval      RetCodeIn = 'Error'                               177668
     C****               Eval      FldNamXAr(Idx) = DDSName                          177668
     C****               Eval      MsgIdXAr(Idx) = 'RFV0214'                         177668
     C****               Else                                                        177668
      ****                                                                           177668
     C****               Select                                                      177668
     C****               When      PTYPE = 'IBAN'                                    177668
     C****               Eval      PDSTTYP = 'I'                                     177668
     C****               When      PTYPE = '*LEDGER'                                 177668
     C****               Eval      PDSTTYP = 'G'                                     177668
     C****               When      PTYPE = '*NOSTRO'                                 177668
     C****               Eval      PDSTTYP = 'F'                                     177668
     C****               When      PTYPE = '*RETAIL'                                 177668
     C****               Eval      PDSTTYP = 'R'                                     177668
     C****               Endsl                                                       177668
     C****               Endif                                                       177668
      ****                                                                           177668
     C****               Endif                                                       177668
     C                   Endsl
     C                   Endif                                                       177668

     C                   If        PCCTDST <> *blanks                                177668
     C                   Eval      XCCTDST = PCCtDst
     C**********         CallB     'AOBICDV0'                                          177668 221760
     C                   CallB     'AOBICDV01'                                                221760
     C                   Parm                    RetCodeIn                           177668
     C                   Parm                    XCCTDST                             177668
     C                   Parm                    PTType            7                 177668
     C                   Parm                    Dssdy                               177668

     C                   If        PTType <> '*BIC   '                               177668
     C                   Eval      PACCT = PCCtDst
     C                   Exsr      SrAcct                                            177668
      *                                                                              177668
      ** Account invalid                                                             177668
     C                   If        wvalid = 'N'                                      177668
     C                   IF        Ptype <> '*CUSTNO' AND                            177668
     C                             Ptype <> '*SHNAME'                                177668
     C                   Eval      GenOkFlag2 = 'N'                                  177668
     C                   Eval      Idx = Idx + 1                                     177668
     C                   Eval      RetCodeIn = 'Error'                               177668
     C                   Eval      FldNamXAr(Idx) = DDSName                          177668
     C                   Eval      MsgIdXAr(Idx) = 'RFV0214'                         177668
     C                   Else                                                        177668
     C                   Eval      XCCTDST = PCCTDST                                 177668
     C**********         CallB     'AOBICDV0'                                          177668 221760
     C                   Call      'AOBICDV01'                                                221760
     C                   Parm                    RetCodeIn                           177668
     C                   Parm                    XCCTDST                             177668
     C                   Parm                    PTType            7                 177668
     C                   Parm                    Dssdy                               177668
                                                                                     177668
     C                   If        RetCodeIN <> '*BICFND'                            177668
     C                             and RetCodeIN <> *blanks                                  BUG8579
     C                   Eval      GenOkFlag2 = 'N'                                  177668
     C                   Eval      Idx = Idx + 1                                     177668
     C                   Eval      RetCodeIn = 'Error'                               177668
     C                   Eval      FldNamXAr(Idx) = DDSName                          177668
     C                   Eval      MsgIdXAr(Idx) = 'RFV0214'                         177668
     C                   Endif                                                       177668
     C                   Endif                                                       177668
     C                   Else                                                        177668
     C                   Eval      XcctDst = *Blanks                                 177668
     C                   MOVEL     CNUM          XCCTDST                             177668
     C**********         CallB     'AOBICDV0'                                          177668 221760
     C                   Call      'AOBICDV01'                                                221760
     C                   Parm                    RetCodeIn                           177668
     C                   Parm                    XCCTDST                             177668
     C                   Parm                    PTType            7                 177668
     C                   Parm      *Blanks       Dssdy                               177668
                                                                                     177668
     C                   If        RetCodeIN <> '*BICFND'                            177668
     C                             and RetCodeIN <> *blanks                                  BUG8579
     C                   Eval      GenOkFlag2 = 'N'                                  177668
     C                   Eval      Idx = Idx + 1                                     177668
     C                   Eval      RetCodeIn = 'Error'                               177668
     C                   Eval      FldNamXAr(Idx) = DDSName                          177668
     C                   Eval      MsgIdXAr(Idx) = 'RFV0214'                         177668
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
      * Now validate that all data entered is OK for SWIFT

     C                   If        PCCTDST <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      PCCTDST       Swift_Text       50
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
     C                   Parm      *Blanks       DSSDY                          I:A/c code
     C                   Endif

      ** Invalid Account
     C                   If        PTYPE <> 'IBAN' and
     C                             PTYPE <> '*NOSTRO'  and
     C                             PTYPE <> '*RETAIL'  and
     C                             PTYPE <> '*LEDGER' or
     C                             PRTCD <> *Blanks
     C                   Eval      wvalid = 'N'
     C                   Else
     C                   Select
     C                   When      PTYPE = '*NOSTRO'
     C                   Eval      N@FMT = DSSDY
     C                   Movel     A7CUST        CNUM
     C                   When      PTYPE = '*RETAIL'
     C                   Eval      ACCNT = DSSDY
     C                   When      PTYPE = '*LEDGER'
     C                   Eval      ACCNT = DSSDY
     C                   Endsl
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
