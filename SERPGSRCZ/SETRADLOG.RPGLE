     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade Support Log Setup Module')              *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SETRADLOG - Trade Support Log Setup Module                   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      *                 AR698195B          Date 20Jan11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE065             Date 08Nov04               *
      *                 CSE071             Date 19Jul05               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  AR698195B - Added Front Office field on the buffer for TRADS *
      *             (Child: AR698196)                                 *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CGL031 - Taxation of Savings Income                          *
      *  CSE065 - Cost Yield Amort. on Mortgage Backed Assets         *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      * SRPROC - Detail Processing                                    *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
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
 
      ** SE Trades - Details
     D TradFilFmt    E DS                  EXTNAME(TRADSD)
 
      ** Trade in Screen Format - Primary Details
     D TranInPrim    E DS                  EXTNAME(SETRPRPD)
 
      ** Trade in Screen Format - Secondary Details
     D TranInSeco    E DS                  EXTNAME(SETRSEPD)
                                                                                              CAS006
      ** Trade in Screen Format - Third screen Details                                        CAS006
     D TranInThir    E DS                  EXTNAME(SETRTHPD)                                  CAS006
 
      ** Trade in Screen Format - Exchange Rates Details
     D TranInExch    E DS                  EXTNAME(SETREXPD)
 
      ** Trade in Screen Format - Settlement Instructions
     D TranInSett    E DS                  EXTNAME(SETRSTPD)
     D DDCLTY2       E                     EXTFLD(DDCLTY)
 
      ** Trade in Screen Format - Charges/Commissions
     D TranInChCm    E DS                  EXTNAME(SETRCCPD)
 
      ** Trade in Screen Format - SWIFT 'A' Details
     D TranInSwfA    E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(A)
 
      ** Trade in Screen Format - SWIFT 'B' Details
     D TranInSwfB    E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(B)
 
      ** SE Extra Data - Classe 1 Data - File (D/B) format
     D InfData       E DS                  EXTNAME(SETRIFPD)
 
      ** SE Trades Extra Data - File (D/B) format
     D ExtData       E DS                  EXTNAME(SETDEXPD)
 
      ** SE Securities - Details
     D SECTYDts      E DS                  EXTNAME(SECTYD)
     D                                     PREFIX(S_)
 
      ** SE Investment Type - Details
     D INVTPDts      E DS                  EXTNAME(INVTPD)
     D                                     PREFIX(I_)
 
      ** SE Trades Extension File
     D TX1AFilFmt    E DS                  EXTNAME(TRADSDX1)
     D                                     PREFIX(A_)
 
      ** SE Trades Extension File
     D TX1BFilFmt    E DS                  EXTNAME(TRADSDX1)
     D                                     PREFIX(B_)
 
      ** The following /COPY includes the customer details data structure
     D/COPY SECPYSRC,SE_CUSTDT
      ** The following /COPY includes the currency details data structures
     D/COPY SECPYSRC,SE_CCYDT
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D TRANSDTL        S           5800A
     D SecLegExcRat    S             13A
     D SecLegBuyCur    S              3A
     D SecLegEuyAmt    S             16A
     D SecLegSelCur    S              3A
     D SecLegSelAmt    S             16A
     D LoanIntAmt      S             17A
     D DepoIntAmt      S             17A
     D DealStatus      S             24A
     D DDSTAT          S              9A
     D DDAUTH          S             14A
     D DDSRNME         S             41A
     D DDCRNM          S             20A
     D DDCPNR          S             13A
     D DDCFCT          S             12A
     D DDMAMT          S             18A
     D DDSPXR          S             14A
     D DDSPMD          S             11A
     D DDTCTR          S             21A
     D DDWTAX          S             15A
     D DDPRICN         S             17A                                                      CAS006
     D A_DDROUS        S             16A
     D A_DDROTS        S             12A
     D A_DDROUC        S             16A
     D A_DDROTC        S             12A
     D B_DDROUS        S             16A
     D B_DDROTS        S             12A
     D B_DDROUC        S             16A
     D B_DDROTC        S             12A
     D PAction         S              1A
     D CAS006          S              1A                                                      CAS006
     D CGL031          S              1A                                                      CGL031
      ** Front office id variable.                                                         AR698195B
     D DDFRNT          S             20A                                                   AR698195B
 
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
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C                   EXSR      SRPROC
     C
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR/SRPROC - Detail Processing                                 *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SETRADCVT - Convert File to Screen Format              *
      *                                                               *
      *****************************************************************
 
     C     SRPROC        BEGSR
 
     C                   EVAL      TRANSDTL = *Blanks
     C                   EVAL      TranInPrim = *Blanks
     C                   EVAL      DDACTN = PAction
 
     C                   CALLB     'SETRADCVT'
 
     C                   PARM                    RetCodeOut
     C                   PARM                    TradFilFmt
     C                   PARM                    TX1AFilFmt
     C                   PARM                    TX1BFilFmt
                                                                                              CAS006
      ** Switchable features                                                                  CAS006
                                                                                              CAS006
     C                   PARM                    CAS006                                       CAS006
     C                   PARM                    CGL031                                       CGL031
                                                                                              CAS006
     C                   PARM                    TranInPrim
     C                   PARM      *BLANKS       TranInSeco
     C                   PARM      *BLANKS       TranInThir                                   CAS006
     C                   PARM      *BLANKS       TranInExch
     C                   PARM      *BLANKS       TranInSett
     C                   PARM      *BLANKS       TranInChCm
     C                   PARM      *BLANKS       TranInSwfA
     C                   PARM      *BLANKS       TranInSwfB
     C                   PARM                    SECTYDts
     C                   PARM                    INVTPDts
     C                   PARM                    NomCcyDts
     C                   PARM                    SetCcyDts
     C                   PARM                    CustDts
     C                   PARM                    DDSTAT
     C                   PARM                    DDAUTH
     C                   PARM                    DDSRNME
     C                   PARM                    DDCRNM
     C                   PARM                    DDCPNR
     C                   PARM                    DDCFCT
     C                   PARM                    DDMAMT
     C                   PARM                    DDSPXR
     C                   PARM                    DDSPMD
     C                   PARM                    DDTCTR
     C                   PARM                    DDWTAX
     C                   PARM                    DDPRICN                                      CAS006
     C                   PARM                    A_DDROUS
     C                   PARM                    A_DDROTS
     C                   PARM                    A_DDROUC
     C                   PARM                    A_DDROTC
     C                   PARM                    B_DDROUS
     C                   PARM                    B_DDROTS
     C                   PARM                    B_DDROUC
     C                   PARM                    B_DDROTC
     C                   PARM                    DDFRNT                                    AR698195B
 
     C                   IF        RetCodeOut <> *Blanks
     C                   EVAL      RetCodeIn = '*ERROR'
     C                   ENDIF
 
     C                   EVAL      TRANSDTL = TranInPrim
     C                                        + TranInSeco
     C                                        + TranInExch
     C                                        + TranInSett
     C                                        + TranInChCm
     C                                        + TranInSwfA
     C                                        + TranInSwfB
     C                                        + TranInThir                                    CAS006
     C                                        + InfData
     C                                        + ExtData
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    PAction
     C                   PARM                    CAS006                                       CAS006
     C                   PARM                    TradFilFmt
     C                   PARM                    TX1AFilFmt
     C                   PARM                    TX1BFilFmt
     C                   PARM                    TRANSDTL
 
      ** The following /COPY sets the program, module and procedure
      ** names for database error processing.
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **-------------------------------------------------------------------+
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **-------------------------------------------------------------------+
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
