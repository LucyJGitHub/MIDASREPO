     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Get settlement a/c given settlement inst')
      *****************************************************************
      *                                                               *
      *  Midas - General functions                                    *
      *                                                               *
      *  ZAGETSETAC - Get settlement account, given settlement        *
      *               instructions.                                   *
      *                                                               *
      *  Function:  This module returns the settlement account, given *
      *             the settlement instructions.  It also returns     *
      *             flags to indicate whether or not MEMOS and PRONO  *
      *             updating is required.                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 147775             Date 16Nov98               *
      *                 CAP004  *CREATE    Date 01Jun98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  147775 - General FF API fixes                                *
      *  CAP004 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Accounts by branch
     FACCBR     IF   E           K DISK    USROPN
 
      ** Retail accounts
     FACNUM     IF   E           K DISK    USROPN
     F                                     RENAME(ACCNTABF : ACNUMABF)
 
 
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
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
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
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--- Named indicators -------------------------------------------+
      ** ¦                                                                ¦
      ** ¦ Map variable names to indicators to allow use of names instead ¦
      ** ¦ of numbers; base the following data structure on a pointer to  ¦
      ** ¦ the indicator array.                                           ¦
     D Indicators      DS                  BASED(pIndicator)
      ** ¦                                                                ¦
     D  NoRecFound            99     99
      ** ¦                                                                ¦
      ** ¦                                                                ¦
      ** ¦ Set the indicator array pointer                                ¦
     D pIndicator      S               *   INZ(%Addr(*In))
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
      ** Retail ICD
 
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D SDNOACCD      E                     EXTFLD(QQACCD)                                     CGL029
      ** Nostros
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Access objects short data structure
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** --- Start of parameters -------------------------------------------------------------------
 
      ** Customer
     D*CustNo***       S              6S 0                                                    CSD027
     D CustNo          S              6A                                                      CSD027
 
      ** Account code
     D***AccCode         S              4S 0                                                  CGL029
     D AccCode         S             10S 0                                                    CGL029
 
      ** Account sequence
     D AccSeq          S              2S 0
 
      ** MEMOS update required
     D MemosInd        S              1A
 
      ** PRONO update required
     D PronoInd        S              1A
 
      ** Settlement type
     D SettleType      S              2S 0
 
      ** Settlement account
     D***SettleAcc       S             12A                                                    CGL029
     D SettleAcc       S             18A                                                      CGL029
 
      ** Settlement currency
     D Currency        S              3A
 
     D Branch          S                   LIKE(BRCA)
 
      ** --- End of parameters ---------------------------------------------------------------------
 
      ** --- Start of key fields for accounts ------------------------------------------------------
 
     D KeyBranch       S                   LIKE(BRCA)
     D KeyCustNo       S                   LIKE(CNUM)
     D KeyCurr         S                   LIKE(CCY)
     D KeyAccCode      S                   LIKE(ACOD)
     D KeyAccSeq       S                   LIKE(ACSQ)
 
      ** --- End of key fields for accounts --------------------------------------------------------
 
      ** --- Alpha versions of account key fields --------------------------------------------------
 
     D ACustNo         S              6A
     D***AAccCode        S              4A                                                    CGL029
     D AAccCode        S             10A                                                      CGL029
     D AAccSeq         S              2A
 
      ** -------------------------------------------------------------------------------------------
 
      ** Nostro number
     D NostroNo        S              2A
 
      ** Retail account number (numeric and alpha)
     D RetailNo        S             10S 0
     D RetailNoA       S             10A
 
      ** -------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C     Start         TAG
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Reset the MEMOS and PRONO update flags (this is done here rather
      ** than by the INZ keyword because they are on the entry parameter
      ** list.  Also clear some file fields which are tested later,
      ** as we do not want to pick up old values on subsequent calls.
     C                   EVAL      MemosInd = 'N'
     C                   EVAL      PronoInd = 'N'
     C                   CLEAR                   ATYP
     C                   CLEAR                   ACST
 
      ** Perform appropriate processing based on the settlement type
     C                   SELECT
      ** -------------------------------------------------------------------------------------------
      ** No settlement instructions - no account details
     C                   WHEN      SettleType = 00
     C                   EXSR      ClearAcc
 
      ** -------------------------------------------------------------------------------------------
      ** Through a nostro - retrieve and return the nostro account details
     C                   WHEN      SettleType = 01
     C                   EXSR      GetNostro
 
      ** -------------------------------------------------------------------------------------------
      ** Cheque collected - retrieve and return the nostro account details
     C                   WHEN      SettleType = 02
     C                   EXSR      GetNostro
 
      ** -------------------------------------------------------------------------------------------
      ** Compensated against another transaction - no account details
     C                   WHEN      SettleType = 03
     C                   EXSR      ClearAcc
 
      ** -------------------------------------------------------------------------------------------
      ** Prime retail account - get and return the prime retail account
      ** details
     C                   WHEN      SettleType = 04
     C                   EXSR      GetRetailP
 
      ** -------------------------------------------------------------------------------------------
      ** Any account - get and return details
     C                   WHEN      SettleType = 05
 
      ** Extract the account fields from the Settlement account field
     C                   EVAL      KeyBranch = Branch                           147775
     C                   EVAL      ACustNo = %subst(SettleAcc : 1 : 6)
     C                   MOVE      ACustNo       KeyCustNo
     C                   EVAL      KeyCurr = Currency                           147775
     C**********         EVAL      AAccCode = %subst(SettleAcc : 7 : 4)                       CGL029
     C                   EVAL      AAccCode = %subst(SettleAcc : 7 : 10)                      CGL029
     C                   MOVE      AAccCode      KeyAccCode
     C**********         EVAL      AAccSeq = %subst(SettleAcc : 11 : 2)                       CGL029
     C                   EVAL      AAccSeq = %subst(SettleAcc : 17 : 2)                       CGL029
     C                   MOVE      AAccSeq       KeyAccSeq
 
      ** Access the account details and return them to the caller
     C                   EXSR      AccChain
 
      ** -------------------------------------------------------------------------------------------
      ** Suspense account
     C                   WHEN      SettleType = 06
     C                   EXSR      ClearAcc
 
      ** -------------------------------------------------------------------------------------------
     C                   WHEN      SettleType = 07
     C                   EXSR      GetNostro
 
      ** -------------------------------------------------------------------------------------------
     C                   WHEN      SettleType = 08
     C                   EXSR      GetNostro
 
      ** -------------------------------------------------------------------------------------------
      ** Cheque sent - retrieve and return the nostro account details
     C                   WHEN      SettleType = 12
     C                   EXSR      GetNostro
 
      ** -------------------------------------------------------------------------------------------
      ** Any retail account - retrieve and return the retail account details
     C                   WHEN      SettleType = 14
     C                   EXSR      GetRetail
 
      ** -------------------------------------------------------------------------------------------
     C                   WHEN      SettleType = 15
     C                   EXSR      ClearAcc
 
     C                   ENDSL
      ** -------------------------------------------------------------------------------------------
 
      ** Set the flag to indicate whether or not MEMOS update is
      ** required.  Note: this processing is being done irrespective of
      ** whether retail is on.  The caller should determine whether
      ** or not it is appropriate to use the flag.
      ** If the account is retail, set the flag based on whether or
      ** not it is closed.
     C                   IF        ATYP = 'R'
 
     C                   IF        ACST = 'C' OR RECI = '*'
     C                   EVAL      MemosInd = 'E'
     C                   ELSE
     C                   EVAL      MemosInd = 'Y'
     C                   ENDIF
 
     C                   ENDIF
 
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ClearAcc - Clear account details                              *
      *                                                               *
      *****************************************************************
 
     C     ClearAcc      BEGSR
 
      ** No details allowed
     C                   CLEAR                   CustNo
     C                   CLEAR                   AccCode
     C                   CLEAR                   AccSeq
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * GetRetailP - Get prime retail account details                 *
      *                                                               *
      *****************************************************************
 
     C     GetRetailP    BEGSR
 
      ** Access retail ICD for current account default account code
     C                   CALLB     'AORETLR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDRETL        PARM      SDRETL        DSFDY
 
     C                   IF        @RTCD <> *blanks
     C                   EVAL      ReturnCode = 'Error'
     C                   EXSR      *pssr
     C                   ENDIF
 
      ***Set*up*the*account*key*with*this*account*code;*clear*the*account       147775
      ***Sequence*to*retrieve*the*first*account*for*the*remaining********       147775
      ***combination.****************************************************       147775
                                                                                147775
      ** Set up the account key with this account code                          147775
                                                                                147775
     C                   EVAL      KeyBranch = Branch
     C                   EVAL      KeyCustNo = CustNo
     C                   EVAL      KeyCurr = Currency
     C                   EVAL      AAccCode = BMACCD
     C                   MOVE      AAccCode      KeyAccCode
     C                   EVAL      KeyAccSeq = 1                                147775
                                                                                147775
     C*******************CLEAR                   KeyAccSeq                      147775
 
      ** Access the account details and return them to the caller...
     C                   EXSR      AccChain
 
      ** ... but if the account is not retail, clear the account fields
      ** and end in error.
     C                   IF        ATYP <> 'R'
     C                   EXSR      ClearAcc
     C                   EVAL      ReturnCode = 'Error'
     C                   EXSR      *pssr
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * AccChain - Access the accounts file                           *
      *                                                               *
      *****************************************************************
 
     C     AccChain      BEGSR
 
      ** Access the account details, the key fields having been set up
      ** in the calling routine.
     C                   OPEN      ACCBR
     C     KAccount      CHAIN     ACCBR                              99
     C                   CLOSE     ACCBR
 
      ** End in error if account not found
     C                   IF        NoRecFound = True
     C                   EVAL      ReturnCode = 'Error'
     C                   EXSR      *pssr
     C                   ENDIF
 
      ** Return a/c details                                                     147775
                                                                                147775
     C                   EVAL      Branch = BRCA                                147775
     C                   EVAL      CustNo = CNUM                                147775
     C                   EVAL      Currency = CCY                               147775
     C                   EVAL      AccCode = ACOD
     C                   EVAL      AccSeq = ACSQ
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * GetNostro - Get nostro details                                *
      *                                                               *
      *****************************************************************
 
     C     GetNostro     BEGSR
 
      ** Extract the nostro number from the settlement account field,
      ** and use the access object to rerieve the details from
      ** SDNOSTPD.
     C                   EVAL      NostroNo = %subst(SettleAcc : 1 : 2)
 
     C                   CALLB     'AONOSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      *BLANKS       @CUST             6
     C                   PARM                    Currency
     C**********         PARM      *BLANKS       @ACCD             4                          CGL029
     C                   PARM      *BLANKS       @ACCD            10                          CGL029
     C                   PARM      *BLANKS       @ACSN             2
     C                   PARM                    NostroNo
     C                   PARM      *BLANKS       @BRCD             3
     C                   PARM      *BLANKS       @CSSN            10
     C                   PARM      *BLANKS       @PNOI             1
     C     SDNOST        PARM      SDNOST        DSFDY
 
     C                   IF        @RTCD <> *blanks
     C                   EVAL      ReturnCode = 'Error'
     C                   EXSR      *pssr
     C                   ENDIF
 
     C*******************EVAL      Branch = A7BRCD                              147775
     C*******************EVAL      ACustNo = A7CUST                             147775
     C*******************MOVE      ACustNo       CustNo                         147775
     C*******************EVAL      Currency = A7CYCD                            147775
     C*******************EVAL      AAccCode = A7ACCD                            147775
     C*******************MOVE      AAccCode      AccCode                        147775
     C*******************EVAL      AccSeq = A7ACSN                              147775
 
      ** Set the flag to indicate that PRONO update is required
     C                   EVAL      PronoInd = 'Y'
                                                                                147775
      ** Set up the account key with the account details of the nostro          147775
                                                                                147775
     C                   EVAL      KeyBranch = A7BRCD                           147775
     C                   EVAL      ACustNo = A7CUST                             147775
     C                   MOVE      ACustNo       KeyCustNo                      147775
     C                   EVAL      KeyCurr = A7CYCD                             147775
     C                   EVAL      AAccCode = A7ACCD                            147775
     C                   MOVE      AAccCode      KeyAccCode                     147775
     C                   EVAL      KeyAccSeq = A7ACSN                           147775
                                                                                147775
      ** Access the account details and return them to the caller...            147775
     C                   EXSR      AccChain                                     147775
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * GetRetail - Get details of a retail account s                 *
      *                                                               *
      *****************************************************************
 
     C     GetRetail     BEGSR
 
      ** Extract the retail account number from the settlement account
      ** field, and use it to access the retail accounts file.
     C                   EVAL      RetailNoA = %subst(SettleAcc : 1 : 10)
     C                   MOVE      RetailNoA     RetailNo
 
     C                   OPEN      ACNUM
     C     RetailNo      CHAIN     ACNUM                              99
     C                   CLOSE     ACNUM
 
      ** End in error if account not found
     C                   IF        NoRecFound = True
     C                   EVAL      ReturnCode = 'Error'
     C                   EXSR      *pssr
     C                   ENDIF
 
     C                   EVAL      Branch = BRCA
     C                   EVAL      CustNo = CNUM
     C                   EVAL      Currency = CCY
     C                   EVAL      AccCode = ACOD
     C                   EVAL      AccSeq = ACSQ
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *inzsr        BEGSR
 
     C     *entry        PLIST
      ** Outputs
      ** -------
      ** Return code (10A)
     C                   PARM                    ReturnCode
      ** Account code (4,0S)
     C                   PARM                    AccCode
      ** Account sequence (2,0S)
     C                   PARM                    AccSeq
      ** MEMOS update required
     C                   PARM                    MemosInd
      ** PRONO update required
     C                   PARM                    PronoInd
      ** Input/output
      ** ------------
      ** Transaction branch (3A) (can also be returned)
     C                   PARM                    Branch
      ** Transaction customer (6,0S) (can also be returned)
     C                   PARM                    CustNo
      ** Settlement currency (3A) (can also be returned)
     C                   PARM                    Currency
      ** Inputs
      ** ------
      ** Settlement type (2,0S)
     C                   PARM                    SettleType
      ** Settlement account (12A)
     C                   PARM                    SettleAcc
 
 
      ** -------------------------------------------------------------------------------------------
      ** Key lists
      ** ---------
 
      ** Accounts
     C     KAccount      KLIST
     C                   KFLD                    KeyBranch
     C                   KFLD                    KeyCustNo
     C                   KFLD                    KeyCurr
     C                   KFLD                    KeyAccCode
     C                   KFLD                    KeyAccSeq
 
 
 
 
 
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
      /EJECT
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
