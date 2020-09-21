     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Get Location Code')                           *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTRTVLOC : Retrieve location code for a nostro               *
      *                                                               *
      *  Function : This function will retrieve the location code for *
      *             a nostro.                                         *
      *                                                               *
      *  a) Called by FT000980                                        *
      *  b)                                                           *
      *                   Outgoing Payments      Incoming Payments    *
      *    Settle Date    1. Ordering Bank       1. 3rd Rec Corr      *
      *                   2. Ordering Customer   2. Receivers Corr    *
      *                                          3. Sender            *
      *                                                               *
      *                                                               *
      *    Pay Date       1. Senders Corr        1. Account With Bank *
      *                   2. Destination         2. Beneficiary       *
      *                                                               *
      *  c) If account entered (GL,Retail, IBAN, is a nostro,         *
      *     (convert to full GL account and then call AONOSTR0),      *
      *     retrieve location code as in b) above.                    *
      *                                                               *
      *  d) Return location code (x2) to FT000980.                    *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CDL049             Date 06Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009  *CREATE    Date 15Feb01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  CFT032 - Account line in field 50X in MT103                  *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CFT009 - FT Fees and Charges                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      *                                                               *
      *                  FUNCTION OF INDICATORS                       *
      *                                                               *
      *       80  CHAIN indicator                                     *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
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
     D P_TransDet      S           3000A
     D P_TransExt      S           3000A
 
     D InPay         E DS                  EXTNAME(INPAYDD)  PREFIX(I_)
     D InPayEx       E DS                  EXTNAME(INPAYXPD) PREFIX(I_)
 
     D OutPay        E DS                  EXTNAME(OTPAYDD)  PREFIX(O_)
     D OtPayEx       E DS                  EXTNAME(OTPAYXPD) PREFIX(O_)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D P@FMT         E DS                  EXTNAME(DSFDY)
     D N@FMT         E DS                  EXTNAME(SDNOSTPD)
     D ACCNT         E DS                  EXTNAME(ACCNTAB)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D TransType       S              2
 
     D SettDateLoc     S              3
     D PayDateLoc      S                   Like(SettDateLoc)
 
     D N_Return        S              7
     D N_Optn          S              7
     D N_Cust          S              6
     D N_Ccy           S              3
     D*N_Accd***       S              4                                                       CGL029
     D N_Accd          S             10                                                       CGL029
     D N_Acsn          S              2
     D N_Nonb          S              2
     D N_Brcd          S              3
     D N_Cssn          S             10
     D N_PNoi          S              1
 
     D Account         S                   Like(O_DST1)
     D Branch          S                   Like(O_BRCA)
     D N_Retl          S             10
     D Nostro          S              1
     D Type            S              1
 
     D*Orbk_W***       S             10                                                       CGL029
     D Orbk_W          S             16                                                       CGL029
     D Snco_W          S             10
     D Rcco_W          S             10
     D IbanAcc         S             34
 
 
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
      *****************************************************************
 
     C                   Exsr      ResetVar
 
      * Move data to apprppriate datastructure
     C                   Select
     C                   When      TransType = 'OP'
     C                   Eval      OutPay    = P_TransDet
     C                   Eval      OtPayEx   = P_TransExt
 
     C                   Exsr      GetOPLoc
 
     C                   When      TransType = 'IN'
     C                   Eval      InPay     = P_TransDet
     C                   Eval      InPayEx   = P_TransExt
 
     C                   Exsr      GetINLoc
 
     C                   Endsl
 
     C                   Return
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * GetOPLoc - Get Outgoing Payments Location Codes
      *****************************************************************
     C     GetOPLOc      Begsr
 
      * Get Settle Date Location Code
      * Ordering Bank     = ORBT ORBK
      * Ordering Customer = ORCT ORC1
 
     C                   Select
     C                   When      O_Orbt  <> *Blanks
     C                   Eval      Type    =  O_Orbt
     C                   Movel     O_Orbk        Orbk_W
     C                   Eval      Account =  Orbk_W
     C                   Eval      Ccy     =  O_SMCY
     C                   Eval      Branch  =  O_BRCA
     C                   Exsr      FormatAccount
 
     C                   When      O_Orct  <> *Blanks
     C                   Eval      Type    =  O_Orct
                                                                                             CFT032
      ** If first character of O_Orc1 is a '/', then strip it first.                         CFT032
      ** Otherwise, the whole field is the account number.                                   CFT032
                                                                                             CFT032
     C                   If        %Subst(O_Orc1:1:1) = '/'                                  CFT032
     C                   Eval      Account = %Subst(O_Orc1:2)                                CFT032
     C                   Else                                                                CFT032
     C                   Eval      Account =  O_Orc1
     C                   EndIf                                                               CFT032
                                                                                             CFT032
     C                   Eval      Ccy     =  O_SMCY
     C                   Eval      Branch  =  O_BRCA
     C                   Exsr      FormatAccount
     C                   EndSl
 
      * If nostro, move to settle date location
     C                   If        Nostro = 'Y'
     C                   Eval      SettDateLoc = %Subst(A7NOSN:8:3)
     C                   Endif
 
      * Get Payment Date Location Code
      * Senders Correspondent : SNCT SNCO
      * Destination           : DSTT DST1
 
     C                   Select
     C                   When      O_Snct  <> *Blanks
     C                   Eval      Type    =  O_Snct
     C                   Movel     O_Snco        Snco_W
     C                   Eval      Account =  Snco_W
     C                   Eval      Ccy     =  O_PCCY
     C                   Eval      Branch  =  O_BRCA
     C                   Exsr      FormatAccount
 
     C                   When      O_Dstt  <> *Blanks
     C                   Eval      Type    =  O_Dstt
     C                   Eval      Account =  O_Dst1
     C                   Eval      Ccy     =  O_PCCY
     C                   Eval      Branch  =  O_BRCA
     C                   Exsr      FormatAccount
     C                   EndSl
 
      * If nostro, move to payment date location
     C                   If        Nostro = 'Y'
     C                   Eval      PayDateLoc = %Subst(A7NOSN:8:3)
     C                   Endif
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * GetINLoc - Get Incoming Payments Location Codes
      *****************************************************************
     C     GetINLOc      Begsr
 
      * Settlement date location code
     C                   Select
     C                   When      I_INTRIT <> *Blank
     C                   Eval      Type    =  I_INTRIT
     C                   Eval      Account =  I_INTRIB
     C                   Eval      Ccy     =  I_SMCY
     C                   Eval      Branch  =  I_BRCA
     C                   Exsr      FormatAccount
 
     C                   When      I_INRCRT <> *Blank
     C                   Eval      Type    =  I_INRCRT
     C                   Eval      Account =  I_INRCO1
     C                   Eval      Ccy     =  I_SMCY
     C                   Eval      Branch  =  I_BRCA
     C                   Exsr      FormatAccount
 
     C                   When      I_SNTP   <> *Blank
     C                   Eval      Type    =  I_SNTP
     C                   Eval      Account =  I_SND1
     C                   Eval      Ccy     =  I_SMCY
     C                   Eval      Branch  =  I_BRCA
     C                   Exsr      FormatAccount
 
     C                   Endsl
 
      * If nostro, move to settle date location
     C                   If        Nostro = 'Y'
     C                   Eval      SettDateLoc = %Subst(A7NOSN:8:3)
     C                   Endif
 
 
      * Payment date location code
     C                   Select
     C                   When      I_ACBT   <> *Blank
     C                   Eval      Type    =  I_ACBT
     C                   Eval      Account =  I_ACBK
     C                   Eval      Ccy     =  I_PCCY
     C                   Eval      Branch  =  I_BRCA
     C                   If        I_ACBB <> *Blanks
     C                   Eval      Branch = I_ACBB
     C                   Endif
     C                   Exsr      FormatAccount
 
     C                   When      I_BNCT   <> *Blank
     C                   Eval      Type    =  I_BNCT
     C                   Eval      Account =  I_BNC1
     C                   Eval      Ccy     =  I_PCCY
     C                   Eval      Branch  =  I_BRCA
     C                   Exsr      FormatAccount
 
     C                   Endsl
 
      * If nostro, move to payment date location
     C                   If        Nostro = 'Y'
     C                   Eval      PayDateLoc = %Subst(A7NOSN:8:3)
     C                   Endif
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * FormatAccount - Formats account (according to account type)
      *  to get nostro code.
      *****************************************************************
     C     FormatAccount Begsr
 
     C                   Exsr      ResetVar
 
     C                   Select
 
     C                   When      Type  = 'G'
     C                   Eval      N_Cust = %Subst(Account:1:6)
     C**********         Eval      N_Accd = %Subst(Account:10:4)                              CGL029
     C**********         Eval      N_Acsn = %Subst(Account:14:2)                              CGL029
     C                   Eval      N_Accd = %Subst(Account:10:10)                             CGL029
     C                   Eval      N_Acsn = %Subst(Account:20:2)                              CGL029
     C                   Eval      N_Ccy  = %Subst(Account:7:3)
     C**********         Eval      N_Brcd = %Subst(Account:16:3)                              CGL029
     C                   Eval      N_Brcd = %Subst(Account:22:3)                              CGL029
 
     C                   When      Type  = 'P'
     C                   Eval      N_Cust = %Subst(Account:1:6)
     C**********         Eval      N_Accd = %Subst(Account:7:4)                               CGL029
     C**********         Eval      N_Acsn = %Subst(Account:11:2)                              CGL029
     C                   Eval      N_Accd = %Subst(Account:7:10)                              CGL029
     C                   Eval      N_Acsn = %Subst(Account:17:2)                              CGL029
     C                   Eval      N_Ccy  = Ccy
     C**********         Eval      N_Brcd = %Subst(Account:13:3)                              CGL029
     C                   Eval      N_Brcd = %Subst(Account:19:3)                              CGL029
 
     C                   If        N_Brcd = *Blanks
     C                   Eval      N_Brcd = Branch
     C                   Endif
 
     C                   When      Type  = 'N'
     C                   Eval      N_Ccy  = Ccy
     C                   Eval      N_Nonb = Account
 
     C                   When      Type  = 'F'
     C                   Eval      N_Ccy  = %Subst(Account:1:3)
     C                   Eval      N_Nonb = %Subst(Account:4:2)
 
     C                   When      Type  = 'R'
     C                   Eval      N_Retl = Account
     C                   Eval      N_Cust = *Blanks
     C                   Eval      N_Ccy  = *Blanks
     C                   Eval      N_Accd = *Blanks
     C                   Eval      N_Acsn = *Blanks
     C                   Eval      N_Brcd = *Blanks
 
     C                   Exsr      Get_Retail
 
     C                   When      Type  = 'I'
     C                   If        %Subst(Account:1:1) = '/'
     C                   Eval      IbanAcc = %Subst(Account:2:34)
     C                   Else
     C                   Eval      IbanAcc = Account
     C                   Endif
 
     C                   Exsr      Get_Iban
 
     C                   Endsl
 
      * Call AONOSTR0 to see if nostro account
     C                   CallB     'AONOSTR0'
     C                   Parm      *Blanks       N_Return                       B:Return code
     C                   Parm      '*KEY   '     N_Optn                         I:Option
     C                   Parm                    N_Cust                         I:Customer No
     C                   Parm                    N_Ccy                          I:Currency
     C                   Parm                    N_Accd                         I:A/c Code
     C                   Parm                    N_Acsn                         I:A/c Seq
     C                   Parm                    N_Nonb                         I:Nostro No
     C                   Parm                    N_Brcd                         I:Branch Code
     C                   Parm                    N_Cssn                         I:Cust ShortN
     C                   Parm                    N_PNoi                         I:Prime Nost In
     C     N@FMT         Parm      *Blanks       P@FMT                          O:Format
 
     C                   If        N_Return = *Blanks
     C                   Eval      Nostro = 'Y'
     C                   Endif
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * Get_Retail  - Retrieve account details
      *****************************************************************
     C     Get_Retail    Begsr
 
     C                   CallB     'AOACCTR0'
     C                   Parm      *Blanks       N_Return
     C                   Parm      '*KEY   '     N_Optn
     C                   Parm                    N_RETL
     C                   Parm                    N_Cust
     C                   Parm                    N_Ccy
     C                   Parm                    N_Accd
     C                   Parm                    N_Acsn
     C                   Parm                    N_Brcd
     C     ACCNT         Parm      *Blanks       P@FMT
 
     C                   If        N_Return = *Blanks
     C                   Movel     CNUM          N_Cust
     C                   Move      ACOD          N_Accd
     C                   Movel     ACSQ          N_Acsn
     C                   Eval      N_Ccy  = CCY
     C                   Eval      N_Brcd = BRCA
     C                   Else
     C                   Eval      N_Cust = *Blanks
     C                   Eval      N_Accd = *Blanks
     C                   Eval      N_Acsn = *Blanks
     C                   Eval      N_Ccy  = *Blanks
     C                   Eval      N_Brcd = *Blanks
     C                   Endif
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * Get_Iban - Get IBAN account Details
      *****************************************************************
     C     Get_Iban      Begsr
 
     C                   CallB     'AOIBANR4'
     C                   Parm      *Blanks       N_Return
     C                   Parm      '*KEY'        N_Optn
     C                   Parm                    IbanAcc
     C     ACCNT         Parm      *Blanks       P@FMT                          O:Format
 
     C                   If        N_Return = *Blanks
     C                   Movel     CNUM          N_Cust
     C                   Move      ACOD          N_Accd
     C                   Movel     ACSQ          N_Acsn
     C                   Eval      N_Ccy  = CCY
     C                   Eval      N_Brcd = BRCA
     C                   Else
     C                   Eval      N_Cust = *Blanks
     C                   Eval      N_Accd = *Blanks
     C                   Eval      N_Acsn = *Blanks
     C                   Eval      N_Ccy  = *Blanks
     C                   Eval      N_Brcd = *Blanks
     C                   Endif
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * ResetVar  - Resets call to AONOST variables
      *****************************************************************
     C     ResetVar      Begsr
     C                   Eval      Nostro    = *Blank
     C                   Eval      N_Return  = *Blanks
     C                   Eval      N_Optn    = *Blanks
     C                   Eval      N_Cust    = *Blanks
     C                   Eval      N_Ccy     = *Blanks
     C                   Eval      N_Accd    = *Blanks
     C                   Eval      N_Acsn    = *Blanks
     C                   Eval      N_Nonb    = *Blanks
     C                   Eval      N_Brcd    = *Blanks
     C                   Eval      N_Cssn    = *Blanks
     C                   Eval      N_PNoi    = *Blanks
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Entry parameters:
     C     *ENTRY        PLIST
      *
      * INPUTS:
      ** Return Code (10A)
      ** Transaction Type (IN/OP)
      ** Incoming / Outgoing payment data structure (x2)
     C                   Parm                    ReturnCode
     C                   Parm                    TransType
     C                   Parm                    P_TransDet
     C                   Parm                    P_TransExt
      ** OUTPUTS:
      ** Settlement date location code
      ** Payment date location code
     C                   Parm                    SettDateLoc
     C                   Parm                    PayDateLoc
 
     C                   Endsr
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
