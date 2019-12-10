     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate Charges Account')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVCHAC01 - Validate Charges Account                         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. 259576             Date 02Apr14               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 221761             Date 01Apr04               *
      *                 221776             Date 01Apr04               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT006  *CREATE    Date 08Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  259576 - Remove warning message for Inactive accounts.       *
      *           Applied for MD-26109                                *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  221761 - Recompiled due to change made in PF/FT101HPD.       *
      *  221776 - Ensure account conditions are also validated.       *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  CFT006 - Funds Transfer addition of MT101 messages           *
      *                                                               *
      *****************************************************************
 
      * RFT Header file (keyed on RFTID)
     FFT101HL3  IF   E           K Disk    INFSR(*PSSR)
 
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
 
      * Header record in screen format
     D HdrRcdIn      E DS                  EXTNAME(FT101HSPD)
     D  PSNDREF_H    E                     EXTFLD(PSNDREF)
 
      * Detail record in screen format
     D DtlRcdIn      E DS                  EXTNAME(FT101DSPD)
 
      * OK Flags for second screen
     D OKFlags       E DS                  EXTNAME(FTE101S2PD)
 
      * Incoming account details from access objects
     D AccRecord     E DS                  EXTNAME(ACCNTAB)
 
     D N@FMT         E DS                  EXTNAME(SDNOSTPD)
     D C@FMT         E DS                  EXTNAME(SDCUSTPD)
 
      ** External DS for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      * DS to split account identifier into components
     D AccntCode       DS
     D  CustNo                 1      6
     D  Currcy                 7      9
     D  AccCode               10     19  0                                                    CGL029
     D  AccSeq                20     21  0                                                    CGL029
     D  Branch                22     24                                                       CGL029
     D**AccCode*              10     13  0                                                    CGL029
     D**AccSeq**              14     15  0                                                    CGL029
     D**Branch**              16     18                                                       CGL029
 
      * DS to split account identifier into components
     D WorkAccId       DS
     D**W#CNUM**               1      6  0                                                    CSD027
     D  W#CNUM                 1      6                                                       CSD027
     D  W#CCY                  7      9
     D  W#ACOD                10     19  0                                                    CGL029
     D  W#ACSQ                20     21  0                                                    CGL029
     D  W#BRCA                22     24                                                       CGL029
     D**W#ACOD**              10     13  0                                                    CGL029
     D**W#ACSQ**              14     15  0                                                    CGL029
     D**W#BRCA**              16     18                                                       CGL029
 
      * DS to save account identifier
     D SaveAccId       DS
     D**X#CNUM**               1      6  0                                                    CSD027
     D  X#CNUM                 1      6                                                       CSD027
     D  X#CCY                  7      9
     D  X#ACOD                10     19  0                                                    CGL029
     D  X#ACSQ                20     21  0                                                    CGL029
     D  X#BRCA                22     24                                                       CGL029
     D**X#ACOD**              10     13  0                                                    CGL029
     D**X#ACSQ**              14     15  0                                                    CGL029
     D**X#BRCA**              16     18                                                       CGL029
 
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
 
      ** Index for arrays of of warning message ids etc
     D WIx             S              3P 0
 
     D CFT004          S              1    INZ('N')
 
      ** Index for arrays of of warning message ids etc
     D W#OrdCust       S                   LIKE(POCUS1)
 
     D W#AccNum        S                   LIKE(PCHGACC)
     D IBANRetCde      S              7
     D P@IBAN          S             34
 
     D ACCTRetCde      S              7
     D P@ACID          S             10
     D P@CYCD          S              3
     D P@ACCD          S             34
     D P@ACSN          S              2
     D P@BRCA          S             33
     D P@TYPE          S              7
     D P@NOSN          S              2
 
     D RespMode        S              1
 
     D DDSName         S             10
 
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
 
      ** Initialise
     C                   EVAL      Idx     = 0
     C                   EVAL      WIx     = 0
     C                   EVAL      OKCGAC  = 'Y'
 
      ** Main processing
 
     C                   EXSR      VALIDATE
 
      * Now validate that all data entered is OK for SWIFT
 
     C                   If        PCHGACC <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      PCHGACC       Swift_Text       50
     C                   If        RetCdeIn = 'Error'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'
     C                   Eval      FldNamXAr(Idx) =  DDSName
     C                   EVAL      OKCGAC  = 'N'
     C                   Endif
     C                   Endif
 
 
      ** Return
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * VALIDATE - Main validation processing                         *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: AOIBANR2, AOACCTV1                                     *
      *                                                               *
      *****************************************************************
     C     VALIDATE      BEGSR
      *
      ** Field can only be entered if 'RO' or 'RI' and Details of Charges
      ** is 'OUR' or 'SHA'.
     C                   IF        PCHGACC <> *Blanks
      *
     C                   IF        PPTYP = 'RI'  and  PTDCHGS <> 'OUR'  and
     C                             PTDCHGS <> 'SHA'
     C                   MOVE      'N'           OKCGAC
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0174'     MsgIdXAr(Idx)
     C                   ENDIF
      *
      ** The Charges Account must begin with '/'
     C                   IF        %SUBST(PCHGACC:1:1) <> '/' AND
     C                             PPTYP = 'RO'
     C                   MOVE      'N'           OKCGAC
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0175'     MsgIdXAr(Idx)
     C                   Return
     C                   ENDIF
 
     C                   IF        PPTYP = 'RI'
      *
      * If charges account begins with a '/', remove it
      *
     C                   If        %Subst(PCHGACC:1:1) = '/'
     C                   Eval      PCHGACC = %Subst(PCHGACC:2)
     C                   Endif
      *
      ** First line must contain a valid account - nostro, GL, retail or
      ** an IBAN.
     C                   EVAL      P@IBAN = PCHGACC
      *
     C                   Eval      W#AccNum = PCHGACC
     C                   EXSR      ValAccnt
      *
     C                   IF        IBANRetCde <> *Blanks  and
     C                             ACCTRetCde <> *Blanks  and
     C                             ACCTRetCde <> '*KEY' or
     C                             P@TYPE <> '*NOSTRO'  and
     C                             P@TYPE <> '*SHNAME'  and
     C                             P@TYPE <> '*RETAIL'  and
     C                             P@TYPE <> '*LEDGER'
     C                   MOVE      'N'           OKCGAC
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0176'     MsgIdXAr(Idx)
     C                   ELSE
      *                                                                                       221776
     C                   IF        P@TYPE = '*NOSTRO'  OR                                     221776
     C                             P@TYPE = '*RETAIL'  OR                                     221776
     C                             P@TYPE = '*LEDGER'                                         221776
      *                                                                                       221776
     C                   MOVE      RETB          WRETB             1                          221776
      *                                                                                       221776
      ** Bankrupt/Liquidated                                                                  221776
      *                                                                                       221776
     C                   TESTB     '6'           WRETB                    48                  221776
     C                   If        *IN48 = '1'                                                221776
     C                   Eval      Idx = Idx + 1                                              221776
     C                   Eval      RetCodeIn       =   'Error'                                221776
     C                   Eval      MsgIdXAr(Idx)   =  'FTM0015'                               221776
     C                   Eval      FldNamXAr(Idx)  =  DDSName                                 221776
     C                   Eval      OKCGAC = 'N'                                               221776
     C                   Endif                                                                221776
      *                                                                                       221776
      ** Bad Debt                                                                             221776
      *                                                                                       221776
     C                   TESTB     '7'           WRETB                    48                  221776
     C                   If        *IN48 = '1'                                                221776
     C                   Eval      Idx = Idx + 1                                              221776
     C                   Eval      RetCodeIn       =   'Error'                                221776
     C                   Eval      MsgIdXAr(Idx)   =  'FTM0016'                               221776
     C                   Eval      FldNamXAr(Idx)  =  DDSName                                 221776
     C                   Eval      OKCGAC = 'N'                                               221776
     C                   Endif                                                                221776
      *                                                                                       221776
      ** Blocked Debit                                                                        221776
      *                                                                                       221776
     C                   TESTB     '2'           WRETB                    48                  221776
     C                   If        *IN48 = '1'                                                221776
     C                   Eval      Idx = Idx + 1                                              221776
     C                   Eval      RetCodeIn       =   'Error'                                221776
     C                   Eval      MsgIdXAr(Idx)   =  'FTM0014'                               221776
     C                   Eval      FldNamXAr(Idx)  =  DDSName                                 221776
     C                   Eval      OKCGAC = 'N'                                               221776
     C                   Endif                                                                221776
      *                                                                                       221776
      ** Inactive                                                                             221776
      *                                                                                       221776
     C**********         TESTB     '4'           WRETB                    48           221776 259576
     C**********         If        *IN48 = '1'                                         221776 259576
     C**********         Eval      WIx              =   WIx + 1                        221776 259576
     C**********         Eval      RetCodeIn        =   'Error'                        221776 259576
     C**********         Eval      WMsgIdXAr(WIx)   =   'FTM0017'                      221776 259576
     C**********         Eval      WFldNmXAr(WIx)   =   DDSName                        221776 259576
     C**********         Eval      OKCGAC = 'W'                                        221776 259576
     C**********         Endif                                                         221776 259576
      *                                                                                       221776
      ** Referred Debit                                                                       221776
      *                                                                                       221776
     C                   TESTB     '0'           WRETB                    48                  221776
     C                   If        *IN48 = '1'                                                221776
     C                   Eval      WIx              =   WIx + 1                               221776
     C                   Eval      RetCodeIn        =   'Error'                               221776
     C                   Eval      WMsgIdXAr(WIx)   =   'FTM0018'                             221776
     C                   Eval      WFldNmXAr(WIx)   =   DDSName                               221776
     C                   Eval      OKCGAC = 'W'                                               221776
     C                   Endif                                                                221776
      *                                                                                       221776
     C                   Endif                                                                221776
      *
      ** The currency of the A/C entered must equal the Transfer Currency
     C                   IF        CCY <> PTRNCCY  and  PTRNCCY <> *Blanks      I:A/c Currency
     C                   MOVE      'N'           OKCGAC
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0177'     MsgIdXAr(Idx)
     C                   ENDIF
      *
      ** The Charges Account must be different from the Ordering Customer's
      ** payment account.  Save full account code of Charges Account.
     C                   EVAL      SaveAccId = WorkAccId
     C                   CLEAR                   WorkAccId
     C                   EXSR      ChkOrdCust
      *
     C                   IF        WorkAccId = SaveAccId
     C                   MOVE      'N'           OKCGAC
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0178'     MsgIdXAr(Idx)
     C                   ENDIF
      *
      *
     C                   ENDIF
      *
     C                   ELSE
 
     C                   EVAL      @TYPE = 'RO'
     C                   EVAL      IBAN = PCHGACC
 
     C                   CALLB     'FTVIBNB01'
     C                   PARM      *Blanks       IRetCde          10
     C                   PARM                    @TYPE             2
     C                   PARM                    IBAN
 
     C                   IF        IRetCde = '*INVALIDOT'
     C                   MOVE      'N'           OKCGAC
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0306'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValAccnt - Validate/retreive details of account entered       *
      *            in Ordering Customer field.                        *
      *                                                               *
      * Called by: VALIDATE                                           *
      *                                                               *
      * Calls: AOIBANR2, AOACCTV1                                     *
      *                                                               *
      *****************************************************************
     C     ValAccnt      BEGSR
      *
     C                   CLEAR                   AccRecord                      O:ACCNT Format
      *
      ** If CFT004 present, IBANs are allowed.  Else send dummy return code.
     C                   IF        CFT004 = 'Y'
      *
     C                   CALLB     'AOIBANR2'
     C                   PARM      *Blanks       IBANRetCde                     B:Return code
     C                   PARM                    P@IBAN                         I:Option
     C                   PARM      *Blanks       AccRecord                      O:Data Structure
      *
     C                   ELSE
     C                   MOVEL     'Dummy'       IBANRetCde                     B:Return code
     C                   MOVEL     *Blanks       P@IBAN                         I:Option
     C                   ENDIF                                                  I:Option
 
     C                   CallB     'AOACCTV1'
     C                   Parm                    ACCTRetCde
     C                   Parm                    P@TYPE
     C                   Parm                    W#AccNum
     C                   Parm                    DSSDY
      *
      ** If entry was account, load work fields
     C                   IF        P@TYPE = '*RETAIL' or                        I:Option
     C                             P@TYPE = '*LEDGER' or                        I:Option
     C                             P@TYPE = '*NOSTRO' or                        I:Option
     C                             P@IBAN <> *Blanks                            I:Option
 
     C                   Select
     C                   When      P@TYPE = '*NOSTRO'
     C                   Eval      N@FMT = DSSDY
     C                   EVAL      W#CCY  = A7CYCD                              O:ACCNT Format
     C                   EVAL      CCY    = A7CYCD                              O:ACCNT Format
     C                   MOVEL     A7ACCD        W#ACOD
     C                   EVAL      W#ACSQ = 01                                  O:ACCNT Format
     C                   EVAL      W#BRCA = A7BRCD                              O:ACCNT Format
     C                   MOVEL     A7CUST        W#CNUM
     C                   When      P@TYPE = '*RETAIL'
     C                   Eval      ACCRECORD = DSSDY
     C                   EVAL      W#CCY  = CCY                                 O:ACCNT Format
     C                   EVAL      W#ACOD = ACOD                                O:ACCNT Format
     C                   EVAL      W#ACSQ = ACSQ                                O:ACCNT Format
     C                   EVAL      W#BRCA = BRCA                                O:ACCNT Format
     C                   EVAL      W#CNUM = CNUM
     C                   Eval      P@ACID = W#AccNum                                          221776
     C                   Call      'AOACCTV0'                                                 221776
     C                   Parm      *blanks       ACCTRetCde                                   221776
     C                   Parm                    P@ACID                                       221776
     C                   Parm      *blanks       P@CYCD                                       221776
     C                   Parm      *blanks       P@ACCD                                       221776
     C                   Parm      *blanks       P@ACSN                                       221776
     C                   Parm      *blanks       P@BRCA                                       221776
     C                   Parm      *blanks       P@TYPE2           7                          221776
     C                   Parm      *blanks       P@NOSN                                       221776
     C     ACCRECORD     Parm      ACCRECORD     DSSDY                                        221776
     C                   EVAL      W#CCY  = CCY                                               221776
     C                   EVAL      W#ACOD = ACOD                                              221776
     C                   EVAL      W#ACSQ = ACSQ                                              221776
     C                   EVAL      W#BRCA = BRCA                                              221776
     C                   EVAL      W#CNUM = CNUM                                              221776
     C                   When      P@TYPE = '*LEDGER'
     C                   Eval      ACCRECORD = DSSDY
     C                   EVAL      W#CCY  = CCY                                 O:ACCNT Format
     C                   EVAL      W#ACOD = ACOD                                O:ACCNT Format
     C                   EVAL      W#ACSQ = ACSQ                                O:ACCNT Format
     C                   EVAL      W#BRCA = BRCA                                O:ACCNT Format
     C                   EVAL      W#CNUM = CNUM
     C                   Endsl
 
     C                   ENDIF                                                  I:Option
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ChkOrdCust - Compare Charges Account with the one in Ordering *
      *              Customer.                                        *
      *                                                               *
      * Called by: VALIDATE                                           *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     ChkOrdCust    BEGSR
      *
      ** If Ordering Customer on screen 1 has not been entered, it will
      ** exist on the header record.
     C                   IF        POCUS1 = *Blanks
     C**** PRFTID        CHAIN     FT101HL3                           80                      221776
      *****************************************************************                       221776
      ***Database*error************************************************                       221776
     C**********         IF        *IN80 = *On                                                221776
     C**********         MOVEL     'FT101HL3'    DBFILE                         ************  221776
     C**********         MOVEL     '004'         DBASE                          * DBERR 902*  221776
     C**********         MOVEL     PRFTID        DBKEY                          ************  221776
     C**********         EXSR      *PSSR                                                      221776
     C**********         ELSE                                                                 221776
     C                   EVAL      W#OrdCust = PHOCUS1
     C**********         ENDIF                                                                221776
      *
     C                   ENDIF
      *
      ** If Ordering Customer on screen 1 has been entered:
     C                   IF        POCUS1 <> *Blanks
     C                   EVAL      W#OrdCust = POCUS1
     C                   ENDIF
      *
      ** Now have Ordering Customer in a work field.  Determine account
      ** code that has been entered.
     C                   IF        %SUBST(W#OrdCust:1:1) = '/'
      *
     C                   EVAL      P@IBAN = %SUBST(W#OrdCust:2)
      *
     C                   ELSE
     C                   EVAL      P@IBAN = W#OrdCust
      *
     C                   ENDIF
      *
      ** Convert Ordering Customer to full GL account format
     C                   Eval      W#AccNum = W#OrdCust
     C                   EXSR      ValAccnt
      *
     C                   ENDSR
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
 
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
 
      * INPUTS
     C                   PARM                    RetCodeIn
     C                   PARM                    RespMode
     C                   PARM                    ActionCode
 
      *  Screen fields
     C                   PARM                    HdrRcdIn
     C                   PARM                    DtlRcdIn
 
      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDSName
     C                   PARM                    OKFlags
 
      ** Access SAR file to see if CFT004 is present
     C                   CALLB     'AOSARDR0'
     C                   PARM      *Blanks       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CFT004'      @SARD
     C                   PARM                    DSFDY
      *
     C                   IF        @RTCD = *Blank
     C                   EVAL      CFT004 = 'Y'
     C                   ELSE
      *
     C                   IF        @RTCD = '*NRF'
     C                   EVAL      CFT004 = 'N'
     C                   ELSE
      *
      ** Database Error
     C                   Eval      DBKey  =  CFT004
     C                   Eval      DBFile = 'AOSARDR0'
     C                   Eval      DBPgm  = PSProcPgm
     C                   Eval      Dbase  = 1
     C                   Eval      DBMod  = PSProcMod
     C                   Eval      DBProc = '*Inzsr'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
      *  Program, module and procedure names for database error processing.*
      *  The following /COPY sets these values, and also defines LDA as    *
      *  an external data area                                             *
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      **********************************************************************
 
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
