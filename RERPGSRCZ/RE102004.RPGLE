     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Cash Mgt Process Incmg MT103-Direct Sweep')   *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE102004 - RE Cash Mgt Process Incmg MT103-Direct Sweep      *
      *                                                               *
      *  Function: This program creates the topping postings          *
      *            requested from Incoming MT103s.  It writes the     *
      *            entries to GLPSTTPD (with extension details written*
      *            to GLPSTZSPD).  It will then write a record to     *
      *            REICSDPD.                                          *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR676213           Date 19Nov10               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP205             Date 16Mar10               *
      *                 CAP204             Date 09Feb10               *
      *                 BUG24998           Date 17Jul09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 215582             Date 04Apr03               *
      *                 213572             Date 20Mar03               *
      *                 213569             Date 07Feb04               *
      *                 214360             Date 03Feb03               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  AR676213 - Incorrect definition of CLGLAI field (Recompile)  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *           (Recompile)                                         *
      *  CAP204 - Teller Related APIs - Account Transfer (Recompile)  *
      *  BUG24998 - Bank operation code is missing (Recompile)        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  215582 - Fld57  must be equal to Destination BIC in          *
      *           the hierarchy (Here, recompiled only due to changed *
      *           REZSHLJ1)                                           *
      *  213572 - Correct narratives for nostro/vostro entry          *
      *  213569 - Charges                                             *
      *  214360 - Cash Management Deferred Posting                    *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************

     FGLPSTTPD  O    E             DISK    INFSR(*PSSR)
     F                                     PREFIX(E_)
     F                                     COMMIT
     FGLPSTZSPD O    E             DISK    INFSR(*PSSR)
     F                                     COMMIT
     FRSACMTPD  O    E             DISK    INFSR(*PSSR)
     F                                     PREFIX(R_)
     F                                     COMMIT
     FREZSHLJ1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(J_)
     FREICSDL0  IF   E           K DISK    INFSR(*PSSR)
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     FSDCURRLD  IF   E           K DISK    INFSR(*PSSR)
      *****************************************************************

     D I_XRFN          S             10    DIM(6)
      *
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      * Incoming Message Data Structure
     D/COPY MECPYSRC,ME1100_ILE

     D O_ENTRY       E DS                  EXTNAME(APOSTPD)
     D                                     PREFIX(E_)
      * Output Entry
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** External DS for Branch details
     D SDACOD        E DS                  EXTNAME(SDACODPD)
      ** Externally described DS for account code details
     D SDCMAN        E DS                  EXTNAME(SDCMANPD)
      ** External DS for cash management details
     D O_CMHD        E DS                  EXTNAME(RECMHDPD)
      ** Externally described DS CM Hierarchy Details
     D O_ZSHD        E DS                  EXTNAME(REZSHDPD)
      ** Externally described DS for Zero Balancing/Sweeping Details
     D O_GAHD        E DS                  EXTNAME(REGAHDPD)
      ** Externally described DS for Group Account Details
     D O_CMHL        E DS                  EXTNAME(RECMHLPD)
      * Cash Management Hierarchy Links
     D O_ZSHL        E DS                  EXTNAME(REZSHLPD)
      * Zero Balancing/Sweeping Hierarchy Links
     D O_GAHL        E DS                  EXTNAME(REGAHLPD)
      * Group Account Hierarchy Links
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First  DS for access programs

     D X               S              3  0
     D Y               S              3  0

     D @DACNO          S             10  0
     D @DPRFC          S              4
     D @DACSC          S              2
     D @DATYP          S              1

     D @WACNO          S             10                                         213572
     D @CACNO          S             10  0
     D @CPRFC          S              4
     D @CACSC          S              2
     D @CATYP          S              1

     D*@ChgACNO********S             10  0                                      213569
     D*@ChgPRFC********S              4                                         213569
     D*@ChgACSC********S              2                                         213569
     D*@ChgATYP********S              1                                         213569

     D @ChIACNO        S             10  0
     D @ChIPRFC        S              4
     D @ChIACSC        S              2
     D @ChIATYP        S              1

     D WPSTA           S             15
     D @PSTA           S             15  0
     D WRCHGA          S             15
     D @RCHGA          S             15  0
     D @VALD           S              5  0
     D @DETP           S            105
     D @DETC           S              3
     D DateIn          S              6A
     D DaynoOut        S              5P 0
     D WDFIN           S              1A
     D ErrorFlag       S              1A
     D WString         S             65A
     D WCusRef         S             30A
     D WExtAcc         S             34A
     D WSMSR           S             16
     D WSMIR           S             28
     D WSNDR           S             11
     D WCCY            S              3
     D WVDATD          S              6

     D KHIER           S              9  0
     D KLINK           S              9  0
     D KPRCD           S              5  0
     D KSNUM           S              2  0

     D***@TOPAC*         DS            18                                                     CGL029
     D @TOPAC          DS            24                                                       CGL029
     D  @CBRCA                 1      3
     D**@CCNUM**               4      9  0                                                    CSD027
     D  @CCNUM                 4      9A                                                      CSD027
     D  @CCCY                 10     12
     D***@CACCD*               13     16  0                                                   CGL029
     D***@CACSQ*               17     18  0                                                   CGL029
     D  @CACCD                13     22  0                                                    CGL029
     D  @CACSQ                23     24  0                                                    CGL029

     D***@PACCT          DS            18                                                     CGL029
     D @PACCT          DS            24                                                       CGL029
     D  @DBRCA                 1      3
     D**@DCNUM**               4      9  0                                                    CSD027
     D  @DCNUM                 4      9A                                                      CSD027
     D  @DCCY                 10     12
     D***@DACCD                13     16  0                                                   CGL029
     D***@DACSQ                17     18  0                                                   CGL029
     D  @DACCD                13     22  0                                                    CGL029
     D  @DACSQ                23     24  0                                                    CGL029

     D*@ChgAcct********DS            18                                         213569
     D**@ChgBRCA*******        1      3                                         213569
     D**@ChgCNUM*******        4      9  0                                      213569
     D**@ChgCCY********       10     12                                         213569
     D**@ChgACCD*******       13     16  0                                      213569
     D**@ChgACSQ*******       17     18  0                                      213569

     D***@ChIAcct        DS            18                                                     CGL029
     D @ChIAcct        DS            24                                                       CGL029
     D  @ChIBRCA               1      3
     D**@ChICNUM               4      9  0                                                    CSD027
     D  @ChICNUM               4      9A                                                      CSD027
     D  @ChICCY               10     12
     D***@ChIACCD              13     16  0                                                   CGL029
     D***@ChIACSQ              17     18  0                                                   CGL029
     D  @ChIACCD              13     22  0                                                    CGL029
     D  @ChIACSQ              23     24  0                                                    CGL029

     D WVDAT           DS             6
     D  YY                     1      2
     D  MM                     3      4
     D  DD                     5      6

     D WDATA           DS           175
     D  WLine1                 1     35
     D  WLine2                36     70
     D  WLine3                71    105
     D  WLine4               106    140
     D  WLine5               141    175

     D WLongStr        DS           390
     D  WLongStr1              1     65
     D  WLongStr2             66    130
     D  WLongStr3            131    195
     D  WLongStr4            196    260
     D  WLongStr5            261    325
     D  WLongStr6            326    390

      *****************************************************************

     C                   EXSR      SRINIT

     C                   EXSR      SRPROC

     C                   RETURN

      ********************************************************************
      * Initial Processing
      ********************************************************************
     C     SRINIT        Begsr

     C     *ENTRY        Plist

      * Return code
     C                   Parm                    P@RTCD            7
     C                   Parm                    PHEAD
     C                   Parm                    PDATA
      * Message information
     C                   Parm                    P@INFO          256

     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   CALLB     'AOCMANR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDCMAN        PARM      SDCMAN        DSSDY

      * Key list
     C     KAccnt        Klist
     C                   Kfld                    @CCNUM
     C                   Kfld                    @CCCY
     C                   Kfld                    @CACCD
     C                   Kfld                    @CACSQ
     C                   Kfld                    @CBRCA
     C
     C*****KChgAccnt     Klist                                                  213569
     C*******************Kfld                    @ChgCNUM                       213569
     C*******************Kfld                    @ChgCCY                        213569
     C*******************Kfld                    @ChgACCD                       213569
     C*******************Kfld                    @ChgACSQ                       213569
     C*******************Kfld                    @ChgBRCA                       213569

     C     KReics        Klist
     C                   Kfld                    KHIER
     C                   Kfld                    KLINK
     C                   Kfld                    KPRCD
     C                   Kfld                    KSNUM

      * Count of entries
      * Extension Ref. Nos.
     C                   Z-ADD     0             C                 2 0
     C                   MOVEL     *BLANK        I_XRFN

     C                   Endsr
      ********************************************************************
      * SRPROC - Main Processing
      ********************************************************************
     C     SRPROC        Begsr

      *  Get relevant message details
     C                   Exsr      GetMsgDet

      *  Get Credit Account Details (top a/c in Midas)
     C                   Exsr      GetCrAcct

      *  Access Hierarchy Details
     C                   Exsr      GetHierDet

      *  Get Debit Account Details (nostro attached to top a/c)
     C                   Exsr      GetDrAcct

      * Get Next REICSDPD sequence no.
     C                   EXSR      Get_NxtSeqNo

      * Get Next Available Ref. No.
     C                   EXSR      Get_Apna

      * Write CREDIT extension record and entry (posted to top a/c)

     C                   Exsr      Wrt_CrExtsn
     C                   Exsr      Wrt_CrEntry

     C                   ADD       1             C
     C                   MOVEL     O_XRFN        I_XRFN(C)

      * Get Next Available Ref. No.
      *
     C                   EXSR      Get_Apna
      *
      * Write DEBIT extension record and entry (posted to nostro a/c)
      *
     C                   Exsr      Wrt_DrExtsn
     C                   Exsr      Wrt_DrEntry
      *
     C                   ADD       1             C
     C                   MOVEL     O_XRFN        I_XRFN(C)

      * Write charges entries only if Receiver's charge is given

     C                   If        @RCHGA <> 0

     C***********        If        ZDCAC3 <> *blank                             213569
     C***********        Exsr      GetChgAcDet                                  213569
     C***********        Endif                                                  213569
     C                   Exsr      GetChIAcDet

      **Get*Next*Available Ref. No.                                             213569
      *******************                                                       213569
     C*******************EXSR      Get_Apna                                     213569
     C*******************                                                       213569
      **Write*DEBIT*Charge Entry  (posted to charge a/c)                        213569
     C*******************Exsr      Wrt_DChgExtsn                                213569
     C*******************Exsr      Wrt_DChgEntry                                213569
      *******************                                                       213569
     C*******************ADD       1             C                              213569
     C*******************MOVEL     O_XRFN        I_XRFN(C)                      213569

      * Get Next Available Ref. No.
     C                   EXSR      Get_Apna

      * Write CREDIT Charge Entry (posted to charge income a/c)
     C                   Exsr      Wrt_CChgExtsn
     C                   Exsr      Wrt_CChgEntry

     C                   ADD       1             C
     C                   MOVEL     O_XRFN        I_XRFN(C)

     C                   Endif

      * Write record to REICSDPD

     C                   Exsr      Wrt_ICS

     C                   Endsr
      *******************************************************************
      * GetMsgDet  - Get MT101 Message Details                           *
      ********************************************************************
     C     GetMsgDet     BEGSR
      *
      * The MT103 message details are from DS/PDATA and PHEAD
      *
      *  Retrieve Message Input Reference
     C                   Movel     PHMIR         WSMIR
      *  Retrieve Message Transaction Reference
     C                   Movel     P20           DSTRAN
     C                   Movel     TMLIN         WSMSR
      *  Retrieve Message Sender
     C                   Movel     PSNDR         WSNDR
      *
      *  Retrieve Posting Value date
     C                   Movel     PDCA          DSTRAN
     C                   Movel     TVVDAT        WVDAT
     C                   Eval      WVDATD = DD + MM + YY
     C                   Callb     'ZDATE1'                             90
     C                   PARM      WVDATD        DateIn
     C                   PARM                    DayNoOut
     C                   PARM      'D'           WDFIN
     C                   PARM                    ErrorFlag
      *
     C                   If        *IN90 = *ON
     C     *LOCK         IN        LDA
     C                   Z-ADD     1             DBASE                            * * * * * * *
     C                   Movel     '*CALL   '    DBKEY                            * DBERR 001 *
     C                   MOVEL     'ZDATE1  '    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif
      *
     C                   Z-add     DayNoOut      @VALD
      *
      *  Retrieve Posting Currency
     C                   Eval      WCCY  = TVCCY
     C     WCCY          Chain     SDCURRLD                           60
     C                   If        *IN60 = *ON
     C     *LOCK         IN        LDA
     C                   Z-ADD     02            DBASE                            * * * * * * *
     C                   Movel     WCCY          DBKEY                            * DBERR 002 *
     C                   MOVEL     'SDCURRLD'    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif

      *  Retrieve Posting Amount
     C                   Movel     TVAMT         WPSTA
     C                   Eval      X=%scan(',' : WPSTA)
      *
     C                   If        X > 0
     C                   Eval      %Subst(WPSTA: X : 1) = '.'
     C                   Eval      ZFIELD = *blanks
     C                   Move      WPSTA         ZFIELD
     C                   Z-add     A6NBDP        ZADEC
     C                   Eval      ZADIG = 13 - A6NBDP
      *
     C                   Call      'ZALIGN'                             90
     C                   PARM      *BLANKS       ZRTN              7
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
     C                   PARM      *BLANKS       ZAFLD            16
      *
     C                   If        *IN90 = *ON
     C     *LOCK         IN        LDA
     C                   Z-ADD     03            DBASE                            * * * * * * *
     C                   Movel     '*CALL   '    DBKEY                            * DBERR 003 *
     C                   MOVEL     'ZALIGN  '    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif
      *
     C                   Move      ZAFLD         @PSTA
     C                   Endif

      *  Retrieve Receiver's Charge amount, if available
     C                   Z-add     0             @RCHGA
     C                   Eval      WRCHGA = %subst(P71G : 28: 15)
     C                   Eval      X=%scan(',' : WRCHGA)
      *
     C                   If        X > 0
     C                   Eval      %Subst(WRCHGA : X : 1) = '.'
     C                   Eval      ZFIELD = *blanks
     C                   Move      WRCHGA        ZFIELD
     C                   Z-add     A6NBDP        ZADEC
     C                   Eval      ZADIG = 13 - A6NBDP
      *
     C                   Call      'ZALIGN'                             90
     C                   PARM      *BLANKS       ZRTN              7
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
     C                   PARM      *BLANKS       ZAFLD            16
      *
     C                   If        *IN90 = *ON
     C     *LOCK         IN        LDA
     C                   Z-ADD     04            DBASE                            * * * * * * *
     C                   Movel     '*CALL   '    DBKEY                            * DBERR 004 *
     C                   MOVEL     'ZALIGN  '    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif
      *
     C                   Move      ZAFLD         @RCHGA
     C                   Endif
      *
      *  If Receiver's Charge is specified, this should be deducted from
      *  posting amount.
     C                   Sub       @RCHGA        @PSTA

      *  P70 = XXX/account number/customer reference
     C                   Movel     P70           DSTRAN
     C                   Movel     TMLIN         @DETP

      *  Retrieve Details of Charges
     C                   Movel     P71           DSTRAN
     C                   Movel     TMLIN         @DETC
      *
     C                   Endsr
      *******************************************************************
      * GetCrAcct  - Get Credit Account Details                          *
      ********************************************************************
     C     GetCrAcct     BEGSR

      * This is the Top account from the Incoming MT103

     C                   Eval      X = %scan('*TOPA' : P@INFO)
     C                   If        X > 0
     C                   Eval      Y = %scan('/' : P@INFO : X)
     C                   If        Y > 0
     C                   Eval      @TOPAC = %subst(P@INFO : X + 5 : Y - X - 5)
     C                   Endif
     C                   Endif

      * If top account not retrieved, error
     C                   IF        @TOPAC = *blank
     C     *LOCK         IN        LDA
     C                   Z-ADD     05            DBASE                            * * * * * * *
     C                   Eval      DBKEY = 'Top Account not retrieved'            * DBERR 005 *
     C                   MOVEL     'RE102004'    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif

      * Access account details

     C     Kaccnt        Chain     ACCNTABF                           60
     C                   IF        *IN60 = *ON  Or
     C                             RECI <> 'D'
     C     *LOCK         IN        LDA
     C                   Z-ADD     06            DBASE                            * * * * * * *
     C                   Eval      DBKEY = @TOPAC                                 * DBERR 006 *
     C                   MOVEL     'ACCNTAB '    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif

     C                   Eval      @CACNO = ACNO
     C                   Eval      @CPRFC = PRFC

      * Access account code details

     C                   MOVEL     @CACCD        X_ACCD
     C                   CALLB     'ZAACSACOD'
     C**********         PARM                    X_ACCD            4                          CGL029
     C                   PARM                    X_ACCD           10                          CGL029
     C                   PARM                    SDACOD
      *
     C                   IF        A5ACCD = *blank
     C     *LOCK         IN        LDA
     C                   Z-ADD     07            DBASE                            * * * * * * *
     C                   Movel     @CACCD        DBKEY                            * DBERR 007 *
     C                   MOVEL     'ZAACSACOD'   DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif
      *
     C                   MOVEL     A5ACSC        @CACSC
     C                   MOVEL     A5ACTY        @CATYP
      *
     C                   Endsr
      ********************************************************************
      * GetHierDet - Get Heirarchy Details                               *
      ********************************************************************
     C     GetHierDet    BEGSR

      ** Retrieve heirarchy number

     C     KAccnt        Chain     REZSHLJ1                           50
     C                   If        *IN50 = *ON
     C     *LOCK         IN        LDA
     C                   Z-ADD     08            DBASE                            * * * * * * *
     C                   Eval      DBKEY = @TOPAC                                 * DBERR 008 *
     C                   MOVEL     'REZSHLJ1'    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif


      ** Access hierarchy detail group detail record

     C                   CALLB     'RE100601'
      * Return code
      * Error Message
     C                   PARM                    X_RTCD
     C                   PARM                    X_ERMS
      * Option
     C                   PARM      '*ALL   '     X_OPTN
      * Hierarchy ID
     C                   PARM      J_CLHIER      I_HIER            9 0
      * Hierarchy Type
     C                   PARM      'ZS'          I_HTYP            2

     C                   PARM                    O_CMHD
     C                   PARM                    O_ZSHD
     C                   PARM                    O_GAHD

      ** Database error if record not found
     C                   IF        X_RTCD = '*NOREC'
     C     *LOCK         IN        LDA
     C                   Z-ADD     09            DBASE                            * * * * * * *
     C                   MOVEL     '*CALL  '     DBKEY                            * DBERR 009 *
     C                   MOVEL     'RE100601'    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif

      *  Get Link details
     C                   CALLB     'RE100602'
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
      * Option
     C                   PARM      '*ALL   '     X_OPTN            7
      * Hierarchy ID
     C                   PARM      J_CLHIER      I_HIER            9 0
      * Hierarchy Type
     C                   PARM      'ZS'          I_HTYP            2
      * Link ID
     C                   PARM      J_CLLINK      I_LINK            9 0
      * Child branch
      * Child customer
      * Child currency
      * Child a/c code
      * Child a/c seq.
     C                   PARM      J_CLCBRC      I_CBRC            3
     C**********         PARM      J_CLCCUS      I_CCUS            6 0                        CSD027
     C                   PARM      J_CLCCUS      I_CCUS            6                          CSD027
     C                   PARM      J_CLCCCY      I_CCCY            3
     C**********         PARM      J_CLCACD      I_CACD            4 0                        CGL029
     C                   PARM      J_CLCACD      I_CACD           10 0                        CGL029
     C                   PARM      J_CLCASN      I_CASN            2 0

     C                   PARM                    O_CMHL
     C                   PARM                    O_ZSHL
     C                   PARM                    O_GAHL

      ** Database error if record not found
     C                   IF        X_RTCD = '*NOREC'
     C     *LOCK         IN        LDA
     C                   Z-ADD     16            DBASE                            * * * * * * *
     C                   MOVEL     '*CALL  '     DBKEY                            * DBERR 016 *
     C                   MOVEL     'RE100602'    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif

     C                   ENDSR
      ********************************************************************
      *  GetDrAcct - Get Debit  Account                                  *
      ********************************************************************
     C     GetDrAcct     Begsr

     C                   CALLB     'REZDESTAC'

      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
      * INPUTS
      * Hierarchy ID
      * Child currency
     C                   PARM      CDHIER        I_HIER            9 0
     C                   PARM      J_CLCCCY      I_CCCY            3
      * Destination
      * Destination Type
      * Sender's Correspondent
     C                   PARM      ZDDEST        I_SDEST          18
     C                   PARM      ZDDSTT        I_SDSTT           1
     C                   PARM      ZDSNDC        I_SSNDC           2

      * OUTPUTS
      * Parent branch
      * Parent customer
      * Parent currency
      * Parent a/c code
      * Parent a/c seq.
     C                   PARM                    O_PBRC            3
     C**********         PARM                    O_PCUS            6 0                        CSD027
     C                   PARM                    O_PCUS            6                          CSD027
     C                   PARM                    O_PCCY            3
     C**********         PARM                    O_PACD            4 0                        CGL029
     C                   PARM                    O_PACD           10 0                        CGL029
     C                   PARM                    O_PASN            2 0
      * Parent retail no.
      * Parent a/c profit centre
      * Parent a/c account section
      * Parent a/c account type
     C                   PARM                    O_PRNO           10 0
     C                   PARM                    O_PPRF            4
     C                   PARM                    O_PACS            2
     C                   PARM                    O_PATY            1
      * Parent a/c status
     C                   PARM                    O_ParentSTAT     26

      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Ix                3 0

     C     X_RTCD        IFEQ      '*ERROR'
     C     *LOCK         IN        LDA
     C                   Z-ADD     10            DBASE                            * * * * * * *
     C                   Eval      DBKEY = 'Error on destination a/c:'            * DBERR 010 *
     C                                     + I_SDEST + I_SDSTT                    * * * * * * *
     C                   MOVEL     'REZDESTAC'   DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif

      * Parent branch
      * Parent customer
      * Parent currency
      * Parent a/c code
      * Parent a/c seq.
     C                   MOVEL     O_PBRC        @DBRCA
     C**********         Z-ADD     O_PCUS        @DCNUM                                       CSD027
     C                   EVAL      @DCNUM = O_PCUS                                            CSD027
     C                   MOVEL     O_PCCY        @DCCY
     C                   Z-ADD     O_PACD        @DACCD
     C                   Z-ADD     O_PASN        @DACSQ
      * Parent retail no.
      * Parent a/c profit centre
      * Parent a/c account section
      * Parent a/c account type
     C                   Z-ADD     O_PRNO        @DACNO
     C                   MOVEL     O_PPRF        @DPRFC
     C                   MOVEL     O_PACS        @DACSC
     C                   MOVEL     O_PATY        @DATYP

     C                   ENDSR
      ********************************************************************
      *  Get_Apna - Get next available reference number                  *
      ********************************************************************
     C     Get_Apna      Begsr

      * Get next number
     C                   CALLB     'ZAGETAPNA'

      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS

      * INPUTS
      * Ext.File Ref.ID
     C                   PARM      'ZS '         I_XRFI            3
      * OUTPUTS
      * Ext.File Ref.No.
     C                   PARM      *ZERO         O_XRFN           10 0

     C     X_RTCD        IFEQ      '*ERROR'
     C     *LOCK         IN        LDA
     C                   Z-ADD     11            DBASE                            * * * * * * *
     C                   Eval      DBKEY = 'No next available number'             * DBERR 011 *
     C                   MOVEL     'ZAGETAPNA'   DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif

     C                   ENDSR
      ********************************************************************
      *  Get_NxtSeqNo - Get next available sequence number               *
      ********************************************************************
     C     Get_NxtSeqNo  Begsr

      *  Get sequence number to be used as part of the sweep reference
      *  This number is taken from the first unused sequence no in descending
      *  sequence number.
     C                   Z-Add     CLHIER        KHIER
     C                   Z-Add     CLLINK        KLINK
     C                   Z-Add     BJRDNB        KPRCD
     C                   Z-Add     99            KSNUM

     C     KReics        Chain     REICSDD0                           60
     C                   Dow       *IN60 = *Off
     C                   Eval      KSNUM = KSNUM - 1
     C     KReics        Chain     REICSDD0                           60
     C                   Enddo
     C
     C                   Z-add     KSNUM         I_NASN

     C                   ENDSR
     C********************************************************************
      * Wrt_CrExtsn - Write credit extension record to GLPSTZSPD
      ********************************************************************
     C     Wrt_CrExtsn   Begsr

      * Ext.File Ref.ID
     C                   MOVEL     I_XRFI        AZXRFI
      * Ext.File Ref.No.
     C                   MOVEL     O_XRFN        AZXRFN
      * Account branch
      * Account customer
      * Account currency
      * Account a/c code
      * Account a/c seq.
     C                   MOVEL     @CBRCA        AZABRC
     C                   MOVEL     @CCNUM        AZACUS
     C                   MOVEL     @CCCY         AZACCY
     C                   MOVEL     @CACCD        AZAACD
     C                   MOVEL     @CACSQ        AZAASN
      * Account retail no.
     C                   MOVEL     @CACNO        AZARNO
      * A/c is source or destination
     C                   MOVEL     'S'           AZASDA
      * Contra posting amount
     C                   Z-ADD     @PSTA         AZCAMT
      * Sweep Type
     C                   MOVEL     'S'           AZSTYP
      * Top/Sweep
     C                   MOVEL     'S'           AZTPSW
      * Target Balance
     C                   MOVEL     'N'           AZTBAL
      * Shadow Entry
     C                   MOVEL     'N'           AZSHAD
      * Mode of Origin
     C                   MOVEL     *BLANK        AZMODO
      * Date Generated
     C                   Z-ADD     BJRDNB        AZDATG
      * Sequence Number
     C                   Z-Add     I_NASN        AZSNUM
      * MT94X Field 61 - 6
     C                   Eval      AZF616 = 'N' + %subst(@DETP : 1 : 3)
      * MT94X Field 61 - 7  (get customer reference part)
     C                   Movel     *Blank        WCusRef
     C                   Eval      X = %scan('/' : @DETP : 5)
     C                   If        X > 0
     C                   Eval      WCusRef = %subst(@DETP: X + 1 : 30)
     C                   Movel     WCusRef       AZF617
     C                   Endif
     C                   If        WCusRef = *blank
     C                   Eval      AZF617 = 'NONREF'
     C                   Endif
      * MT94X Field 61 - 8
     C                   Eval      AZF618 = *Blank
      * MT94X Field 61 - 9  (get external account from fld 70)
     C                   Movel     P50           DSTRAN
     C                   Movel     TMLIN         WDATA
     C                   If        %Subst(WLine1 : 1 : 1)  <> '/'
     C                   Movel     WLine1        AZF619
     C                   Else
     C                   Movel     WLine2        AZF619
     C                   Endif

      * For Fld 86, concatenate CMx + ext-acct + Customer ref + ext acct name on fld50
     C                   Eval      WExtAcc = *blank
     C                   Eval      X = %scan('/': @DETP : 5)
     C                   If        X > 0
     C                   Eval      WExtAcc = %subst(@DETP: 5 : X - 5)
     C                   Else
     C                   Eval      WExtAcc = %subst(@DETP: 5 : 34)
     C                   Endif
      *
     C                   Eval      WLongStr = *blank
     C                   Eval      WLongStr = %subst(@DETP: 1 : 3)
     C                   Cat       '/':0         WLongStr
     C                   Cat       WExtAcc:0     WLongStr
     C                   If        %Subst(AZF617 : 1 : 7) <> 'NONREF'
     C                   Cat       '/':0         WLongStr
     C                   Cat       WCusRef:0     WLongStr
     C                   EndIf
     C                   Cat       '/':0         WLongStr
     C                   Cat       AZF619:0      WlongStr

      *  Now distribute WLongStr  on Field 86
      * MT94X Field 86 - 1
     C                   Eval      AZF861 = WLongStr1
      * MT94X Field 86 - 2
     C                   Eval      AZF862 = WLongStr2
      * MT94X Field 86 - 3
     C                   Eval      AZF863 = WLongStr3
      * MT94X Field 86 - 4
     C                   Eval      AZF864 = WLongStr4
      * MT94X Field 86 - 5
     C                   Eval      AZF865 = WLongStr5
      * MT94X Field 86 - 6
     C                   Eval      AZF866 = WLongStr6

     C                   WRITE     GLAPZSD0

     C                   Endsr
     C********************************************************************
      * Wrt_CrEntry - Write credit posting entry to GLAPZSPD
      ********************************************************************
     C     Wrt_CrEntry   Begsr

      * Clear output entry

     C                   CLEAR                   O_ENTRY
      * Record ID
     C                   MOVEL     'P'           E_RECI

      * Customer, currency, a/c code and a/c seq.
      * Retail a/c no.
     C                   MOVEL     @CCNUM        E_CNUM
     C                   MOVEL     @CCCY         E_CCY
     C                   MOVEL     @CACCD        E_ACOD
     C                   MOVEL     @CACSQ        E_ACSQ
     C                   MOVEL     @CACNO        E_ACNO
      * Posting Date
     C                   Z-ADD     BJRDNB        E_PSTD
      * Value Date
     C                   Z-ADD     @VALD         E_VALD
      * Transaction Type
     C                   MOVEL     ZDTYPT        E_TRAT
      * Posting Narrative
     C                   If        WCusRef <>  *Blank
     C                   Movel     WCusRef       E_PNAR
     C                   Else
     C                   MOVEL     @DETP         E_PNAR
     C                   Endif
      * Posting Amount
     C                   Z-ADD     @PSTA         E_PSTA
      * DR/CR indicator
     C                   Z-ADD     1             E_DRCR
      * Source of Posting
     C                   MOVE      'GE-CX'       E_SPOS
      * Branch
     C                   MOVEL     @CBRCA        E_BRCA
      * Retail indicator
      * A/c type
     C                   MOVEL     @CATYP        E_ATYP
     C     E_ATYP        IFEQ      'R'
     C                   Z-ADD     1             E_RIND
     C                   ENDIF
      * Posting indicators
     C                   BITOFF    '01234567'    E_PRIN
      * Profit centre
      * Account section
     C                   MOVEL     @CPRFC        E_PRFC
     C                   MOVEL     @CACSC        E_ACSC
      * Original transaction sub-type
     C                   MOVEL     CLLINK        E_OTST
      * Original transaction type
     C                   MOVEL     CLHIER        E_OTTP
      * Ext.Fil Ref.ID
     C                   MOVEL     AZXRFI        E_XRFI
      * Ext.Fil Ref.No.
     C                   Z-ADD     AZXRFN        E_XRFN
      * Transaction Sub-type
     C                   MOVEL     CLLEVL        E_TRST

     C                   WRITE     APOSTPDF

      * Write shadow post entries
     C                   EXSR      Shp_Entry

     C                   Endsr
     C********************************************************************
      * Wrt_DrExtsn - Write debit extension record to GLPSTZSPD
      ********************************************************************
     C     Wrt_DrExtsn   Begsr

      * Ext.File Ref.ID
     C                   MOVEL     I_XRFI        AZXRFI
      * Ext.File Ref.No.
     C                   MOVEL     O_XRFN        AZXRFN
      * Account branch
      * Account customer
      * Account currency
      * Account a/c code
      * Account a/c seq.
     C                   MOVEL     @DBRCA        AZABRC
     C                   MOVEL     @DCNUM        AZACUS
     C                   MOVEL     @DCCY         AZACCY
     C                   MOVEL     @DACCD        AZAACD
     C                   MOVEL     @DACSQ        AZAASN
      * Account retail no.
     C                   MOVEL     @DACNO        AZARNO
      * A/c is source or destination
     C                   MOVEL     'D'           AZASDA
      * Contra posting amount
     C                   Z-ADD     @PSTA         AZCAMT
      *    debit receiver's charges as well                                     213569
     C                   If        @RCHGA <> 0                                  213569
     C                   Add       @RCHGA        AZCAMT                         213569
     C                   Endif                                                  213569
      * Sweep Type
     C                   MOVEL     'S'           AZSTYP
      * Top/Sweep
     C                   MOVEL     'S'           AZTPSW
      * Target Balance
     C                   MOVEL     'N'           AZTBAL
      * Shadow Entry
     C                   MOVEL     'N'           AZSHAD
      * Mode of Origin
     C                   MOVEL     *BLANK        AZMODO
      * Date Generated
     C                   Z-ADD     BJRDNB        AZDATG
      * Sequence Number
     C                   Z-add     I_NASN        AZSNUM
      * MT94X Field 61 - 6
     C                   Eval      AZF616 = *blank
      * MT94X Field 61 - 7
     C                   Eval      AZF617 = *blank
      * MT94X Field 61 - 8
     C                   Eval      AZF618 = *Blank
      * MT94X Field 61 - 9  (get Fld 59 account name, line 2)
     C                   Eval      AZF619 = *Blank
      * MT94X Field 86 - 1
     C                   Eval      AZF861 = *blank
      * MT94X Field 86 - 2
     C                   Eval      AZF862 = *blank
      * MT94X Field 86 - 3
     C                   Eval      AZF863 = *blank
      * MT94X Field 86 - 4
     C                   Eval      AZF864 = *Blank
      * MT94X Field 86 - 5
     C                   Eval      AZF865 = *Blank
      * MT94X Field 86 - 6
     C                   Eval      AZF866 = *Blank

     C                   WRITE     GLAPZSD0

     C                   Endsr
     C********************************************************************
      * Wrt_DrEntry - Write debit posting entry to GLPSTTPD
      ********************************************************************
     C     Wrt_DrEntry   Begsr

      * Clear output entry

     C                   CLEAR                   O_ENTRY
      * Record ID
     C                   MOVEL     'P'           E_RECI

      * Customer, currency, a/c code and a/c seq.
      * Retail a/c no.
     C                   MOVEL     @DCNUM        E_CNUM
     C                   MOVEL     @DCCY         E_CCY
     C                   MOVEL     @DACCD        E_ACOD
     C                   MOVEL     @DACSQ        E_ACSQ
     C                   MOVEL     @DACNO        E_ACNO
      * Posting Date
     C                   Z-ADD     BJRDNB        E_PSTD
      * Value Date
     C                   Z-ADD     @VALD         E_VALD
      * Transaction Type
     C                   MOVEL     ZDTYPS        E_TRAT
      * Posting Narrative
      * must be CM* from fld 70 + top account number                               213572
     C***********        If        WCusRef <>  *Blank                              213572
     C***********        Movel     WCusRef       E_PNAR                            213572
     C***********        Else                                                      213572
     C***********        MOVEL     @DETP         E_PNAR                            213572
     C***********        Endif                                                     213572
     C                   MOVEL     @CACNO        @WACNO                            213572
     C                   If        @WACNO <> *blank                                213572
     C                   Eval      E_PNAR = %subst(@DETP : 1 : 3) + ' ' + @WACNO   213572
     C                   Else                                                      213572
     C                   Eval      E_PNAR = %subst(@DETP : 1 : 3) + ' ' + @TOPAC   213572
     C                   Endif                                                     213572
     C*                                                                            213572
      * Posting Amount
     C                   Z-ADD     @PSTA         E_PSTA
      *    debit receiver's charges as well                                        213569
     C                   If        @RCHGA <> 0                                     213569
     C                   Add       @RCHGA        E_PSTA                            213569
     C                   Endif                                                     213569
      * DR/CR indicator
     C                   Z-ADD     0             E_DRCR
      * Source of Posting
     C                   MOVE      'GE-CX'       E_SPOS
      * Branch
     C                   MOVEL     @DBRCA        E_BRCA
      * Retail indicator
      * A/c type
     C                   MOVEL     @DATYP        E_ATYP
     C     E_ATYP        IFEQ      'R'
     C                   Z-ADD     1             E_RIND
     C                   ENDIF
      * Posting indicators
     C                   BITOFF    '01234567'    E_PRIN
      * Profit centre
      * Account section
     C                   MOVEL     @DPRFC        E_PRFC
     C                   MOVEL     @DACSC        E_ACSC
      * Original transaction sub-type
     C                   MOVEL     CLLINK        E_OTST
      * Original transaction type
     C                   MOVEL     CLHIER        E_OTTP
      * Ext.Fil Ref.ID
     C                   MOVEL     AZXRFI        E_XRFI
      * Ext.Fil Ref.No.
     C                   Z-ADD     AZXRFN        E_XRFN
      * Transaction Sub-type
     C                   MOVEL     CLLEVL        E_TRST

     C                   WRITE     APOSTPDF

      * Write shadow post entries
     C                   EXSR      Shp_Entry

     C                   Endsr
      *******************************************************************
      **GetChgAcDet**-*Get*Charge*Account*Details*************************      213569
      ********************************************************************      213569
     C*****0etChgAcDet***BEGSR********************************************      213569
      *******************                                                       213569
     C*******************Movel     ZDCAC3        @ChgAcct                       213569
      *******************                                                       213569
      **Access*account*details                                                  213569
      *******************                                                       213569
     C*****KChgaccnt*****Chain     ACCNTABF                           60        213569
     C*******************IF        *IN60 = *ON  Or                              213569
     C*******************          RECI <> 'D'                                  213569
     C******LOCK*********IN        LDA                                          213569
     C*******************Z-ADD     12            DBASE                          213569  * * * *
     C*******************Eval      DBKEY = @ChgAcct                             213569 RR 012 *
     C*******************MOVEL     'ACCNTAB'     DBFILE                         213569  * * * *
     C*******************OUT       LDA                                          213569
     C*******************EXSR      *PSSR                                        213569
     C*******************Endif                                                  213569
      *******************                                                       213569
     C*******************Eval      @ChgACNO = ACNO                              213569
     C*******************Eval      @ChgPRFC = PRFC                              213569
      *******************                                                       213569
      **Access*account*code details                                             213569
      *******************                                                       213569
     C*******************MOVEL     @ChgACCD      X_ACCD                         213569
     C*******************CALLB     'ZAACSACOD'                                  213569
     C*******************PARM                    X_ACCD            4            213569
     C*******************PARM                    SDACOD                         213569
      *******************                                                       213569
     C*******************IF        A5ACCD = *blank                              213569
     C******LOCK*********IN        LDA                                          213569
     C*******************Z-ADD     13            DBASE                          213569  * * * *
     C*******************Movel     @ChgACCD      DBKEY                          213569 RR 013 *
     C*******************MOVEL     'ZAACSACOD'   DBFILE                         213569  * * * *
     C*******************OUT       LDA                                          213569
     C*******************EXSR      *PSSR                                        213569
     C*******************Endif                                                  213569
      *******************                                                       213569
     C*******************MOVEL     A5ACSC        @ChgACSC                       213569
     C*******************MOVEL     A5ACTY        @ChgATYP                       213569
      *******************                                                       213569
     C*******************Endsr                                                  213569
      *******************************************************************
      * GetChIAcDet  - Get Charge Income Account Details                 *
      ********************************************************************
     C     GetChIAcDet   BEGSR
      *
      * Set Up charge income account:
      **Branch*is*Hierarcy*branch*                                              213569
     C***********        Eval      @ChIBRCA = CDBRCA                            213569
      * Branch is branch of the parent account (debited w/charge amt)           213569
     C                   Eval      @ChIBRCA = @DBRCA                            213569
      * Customer is Branch Internal Customer Number
     C                   CALLB     'ZAACSBRCH'
     C                   PARM      @ChIBRCA      PBRCA             3
     C                   PARM                    SDBRCH
     C                   Movel     A8BICN        @ChICNUM
      * Currency is the top account's currency
     C                   Eval      @ChICCY  = @CCCY
      * Account code is from ICD
     C                   Movel     CMCHAC        @ChIACCD
      * Account sequence is always 01
     C                   Eval       @ChIACSQ = 1
      *
     C                   Eval      @ChIACNO = 0
     C                   Eval      @ChIPRFC = CMCHPC

      * Access account code details

     C                   MOVEL     @ChIACCD      X_ACCD
     C                   CALLB     'ZAACSACOD'
     C**********         PARM                    X_ACCD            4                          CGL029
     C                   PARM                    X_ACCD                                       CGL029
     C                   PARM                    SDACOD
      *
     C                   IF        A5ACCD = *blank
     C     *LOCK         IN        LDA
     C                   Z-ADD     14            DBASE                            * * * * * * *
     C                   Movel     @ChIACCD      DBKEY                            * DBERR 014 *
     C                   MOVEL     'ZAACSACOD'   DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif
      *
     C                   MOVEL     A5ACSC        @ChIACSC
     C                   MOVEL     A5ACTY        @ChIATYP
      *
     C                   Endsr
     C********************************************************************
      **Wrt_DChgExtsn*-*Write*debit*charge*extension*record*to*GLPSTZSPD**      213569
      ********************************************************************      213569
     C*****Wrt_DChgExtsn Begsr                                                  213569
      *******************                                                       213569
      **Ext.File*Ref.ID**                                                       213569
     C*******************MOVEL     I_XRFI        AZXRFI                         213569
      **Ext.File*Ref.No.*                                                       213569
     C*******************MOVEL     O_XRFN        AZXRFN                         213569
      **Debit*Account****                                                       213569
      ****If*MT103*Charge a/c <> blank, use MT103 Charge a/c                    213569
      ****Otherwise,*use*top account                                            213569
     C*******************                                                       213569
     C*****ZDCAC3********IFNE      *BLANK                                       213569
     C*******************MOVEL     ZDCAC3        @ChgAcct                       213569
     C*******************MOVEL     @ChgBRCA      AZABRC                         213569
     C*******************MOVEL     @ChgCNUM      AZACUS                         213569
     C*******************MOVEL     @ChgCCY       AZACCY                         213569
     C*******************MOVEL     @ChgACCD      AZAACD                         213569
     C*******************MOVEL     @ChgACSQ      AZAASN                         213569
     C*******************Z-add     @ChgACNO      AZARNO                         213569
     C*******************ELSE                                                   213569
     C*******************MOVEL     @CBRCA        AZABRC                         213569
     C*******************MOVEL     @CCNUM        AZACUS                         213569
     C*******************MOVEL     @CCCY         AZACCY                         213569
     C***********        MOVEL     @CACCD        AZAACD                         213569
     C***********        MOVEL     @CACSQ        AZAASN                         213569
     C***********        Z-add     @CACNO        AZARNO                         213569
     C***********        ENDIF                                                  213569
      *******************                                                       213569
      **A/c*is*source*or*destination                                            213569
     C*******************MOVEL     *Blank        AZASDA                         213569
      **Contra*posting*amount                                                   213569
     C*******************Z-ADD     @RCHGA        AZCAMT                         213569
      **Sweep*Type*******                                                       213569
     C*******************MOVEL     *Blank        AZSTYP                         213569
      **Top/Sweep********                                                       213569
     C*******************MOVEL     *Blank        AZTPSW                         213569
      **Target*Balance***                                                       213569
     C*******************MOVEL     *Blank        AZTBAL                         213569
      **Shadow*Entry*****                                                       213569
     C*******************MOVEL     'N'           AZSHAD                         213569
      **Mode*of*Origin***                                                       213569
     C*******************MOVEL     *BLANK        AZMODO                         213569
      **Date*Generated***                                                       213569
     C*******************Z-ADD     BJRDNB        AZDATG                         213569
      **Sequence*Number**                                                       213569
     C*******************Z-Add     I_NASN        AZSNUM                         213569
      **MT94X*Field*61*-*6                                                      213569
     C*******************Eval      AZF616 = *blank                              213569
      **MT94X*Field*61*-*7                                                      213569
     C*******************Eval      AZF617 = *blank                              213569
      **MT94X*Field*61*-*8                                                      213569
     C*******************Eval      AZF618 = *Blank                              213569
      **MT94X*Field*61*-*9                                                      213569
     C*******************Eval      AZF619 = *Blank                              213569
      **MT94X*Field*86*-*1                                                      213569
     C*******************Eval      AZF861 = *blank                              213569
      **MT94X*Field*86*-*2                                                      213569
     C*******************Eval      AZF862 = *blank                              213569
      **MT94X*Field*86*-*3                                                      213569
     C*******************Eval      AZF863 = *blank                              213569
      **MT94X*Field*86*-*4                                                      213569
     C*******************Eval      AZF864 = *blank                              213569
      **MT94X*Field*86*-*5                                                      213569
     C*******************Eval      AZF865 = *blank                              213569
      **MT94X*Field*86*-*6                                                      213569
     C*******************Eval      AZF866 = *blank                              213569
      *******************                                                       213569
     C*******************WRITE     GLAPZSD0                                     213569
      *******************                                                       213569
     C*******************Endsr                                                  213569
     C********************************************************************      213569
      **Wrt_DChgEntry*-*Write*debit*charge*posting*entry*to**GLPSTTPD*****      213569
      ********************************************************************      213569
     C*****Wrt_DChgEntry*Begsr********************************************      213569
      *******************                                                       213569
      **Clear*output*entry                                                      213569
      *******************                                                       213569
     C*******************CLEAR                   O_ENTRY                        213569
      **Record*ID********                                                       213569
     C*******************MOVEL     'P'           E_RECI                         213569
      *******************                                                       213569
      **Customer,*currency, a/c code and a/c seq.                               213569
      **Retail*a/c*no.***                                                       213569
      ****If*MT103*Charge a/c <> blank, use MT103 Charge a/c                    213569
      ****Otherwise,*use*top account                                            213569
      *******************                                                       213569
     C*****ZDCAC3********IFNE      *BLANK                                       213569
     C*******************MOVEL     ZDCAC3        @ChgAcct                       213569
     C*******************MOVEL     @ChgCNUM      E_CNUM                         213569
     C*******************MOVEL     @ChgCCY       E_CCY                          213569
     C*******************MOVEL     @ChgACCD      E_ACOD                         213569
     C*******************MOVEL     @ChgACSQ      E_ACSQ                         213569
     C*******************Z-add     @ChgACNO      E_ACNO                         213569
     C*******************ELSE                                                   213569
     C***********        MOVEL     @CCNUM        E_CNUM                         213569
     C***********        MOVEL     @CCCY         E_CCY                          213569
     C***********        MOVEL     @CACCD        E_ACOD                         213569
     C***********        MOVEL     @CACSQ        E_ACSQ                         213569
     C***********        Z-add     @CACNO        E_ACNO                         213569
     C***********        ENDIF                                                  213569
      **Posting*Date*****                                                       213569
     C*******************Z-ADD     BJRDNB        E_PSTD                         213569
      **Value*Date*******                                                       213569
     C*******************Z-ADD     @VALD         E_VALD                         213569
      **Transaction*Type*                                                       213569
     C*******************If        E_ACNO <> 0                                  213569
     C*******************MOVEL     ZDTYPS        E_TRAT                         213569
     C*******************Endif                                                  213569
      **Posting*Narrative                                                       213569
     C*******************Eval      E_PNAR = 'Trf Charges T/S/ZB'                213569
      **Posting*Amount***                                                       213569
     C*******************Z-ADD     @RCHGA        E_PSTA                         213569
      **DR/CR*indicator**                                                       213569
     C*******************Z-ADD     0             E_DRCR                         213569
      **Source*of*Posting                                                       213569
     C*******************MOVE      'GE-CX'       E_SPOS                         213569
      **Branch***********                                                       213569
     C*****ZDCAC3********IFNE      *BLANK                                       213569
     C*******************MOVEL     @ChgBrca      E_BRCA                         213569
     C*******************ELSE                                                   213569
     C***********        MOVEL     @CBRCA        E_BRCA                         213569
     C***********        ENDIF                                                  213569
      *******************                                                       213569
      **Retail*indicator*                                                       213569
      **A/c*type*********                                                       213569
     C*****ZDCAC3********IFNE      *BLANK                                       213569
     C*******************MOVEL     @ChgATYP      E_ATYP                         213569
     C*******************ELSE                                                   213569
     C*******************MOVEL     @CATYP        E_ATYP                         213569
     C*******************ENDIF                                                  213569
     C*****E_ATYP********IFEQ      'R'                                          213569
     C*******************Z-ADD     1             E_RIND                         213569
     C*******************ENDIF                                                  213569
      **Posting*indicators                                                      213569
     C*******************BITOFF    '01234567'    E_PRIN                         213569
      **Profit*centre****                                                       213569
      **Account*section**                                                       213569
     C*****ZDCAC3********IFNE      *BLANK                                       213569
     C*******************MOVEL     @ChgPRFC      E_PRFC                         213569
     C*******************MOVEL     @ChgACSC      E_ACSC                         213569
     C*******************ELSE                                                   213569
     C*******************MOVEL     @CPRFC        E_PRFC                         213569
     C***********        MOVEL     @CACSC        E_ACSC                         213569
     C***********        ENDIF                                                  213569
      **Original*transaction sub-type                                           213569
     C*******************MOVEL     CLLINK        E_OTST                         213569
      **Original*transaction type                                               213569
     C*******************MOVEL     CLHIER        E_OTTP                         213569
      **Ext.Fil*Ref.ID***                                                       213569
     C*******************MOVEL     AZXRFI        E_XRFI                         213569
      **Ext.Fil*Ref.No.**                                                       213569
     C*******************Z-ADD     AZXRFN        E_XRFN                         213569
      **Transaction*Sub-type                                                    213569
     C*******************MOVEL     CLLEVL        E_TRST                         213569
      *******************                                                       213569
     C*******************WRITE     APOSTPDF                                     213569
      *******************                                                       213569
      **Write*shadow*post entries                                               213569
     C*******************EXSR      Shp_Entry                                    213569
      *******************                                                       213569
     C*******************Endsr                                                  213569
     C********************************************************************
      * Wrt_CChgExtsn  - Write credit charge extension record to GLPSTZSPD
      ********************************************************************
     C     Wrt_CChgExtsn Begsr

      * Ext.File Ref.ID
     C                   MOVEL     I_XRFI        AZXRFI
      * Ext.File Ref.No.
     C                   MOVEL     O_XRFN        AZXRFN
      * Credit Account is Charge Income
     C                   MOVEL     @ChIBRCA      AZABRC
     C                   MOVEL     @ChICNUM      AZACUS
     C                   MOVEL     @ChICCY       AZACCY
     C                   MOVEL     @ChIACCD      AZAACD
     C                   MOVEL     @ChIACSQ      AZAASN
     C                   MOVEL     @ChIACNO      AZARNO

      * A/c is source or destination
     C                   MOVEL     *Blank        AZASDA
      * Contra posting amount
     C                   Z-ADD     @RCHGA        AZCAMT
      * Sweep Type
     C                   MOVEL     *Blank        AZSTYP
      * Top/Sweep
     C                   MOVEL     *Blank        AZTPSW
      * Target Balance
     C                   MOVEL     *Blank        AZTBAL
      * Shadow Entry
     C                   MOVEL     'N'           AZSHAD
      * Mode of Origin
     C                   MOVEL     *BLANK        AZMODO
      * Date Generated
     C                   Z-ADD     BJRDNB        AZDATG
      * Sequence Number
     C                   Z-Add     I_NASN        AZSNUM
      * MT94X Field 61 - 6
     C                   Eval      AZF616 = *blank
      * MT94X Field 61 - 7
     C                   Eval      AZF617 = *blank
      * MT94X Field 61 - 8
     C                   Eval      AZF618 = *Blank
      * MT94X Field 61 - 9
     C                   Eval      AZF619 = *Blank
      * MT94X Field 86 - 1
     C                   Eval      AZF861 = *blank
      * MT94X Field 86 - 2
     C                   Eval      AZF862 = *blank
      * MT94X Field 86 - 3
     C                   Eval      AZF863 = *blank
      * MT94X Field 86 - 4
     C                   Eval      AZF864 = *blank
      * MT94X Field 86 - 5
     C                   Eval      AZF865 = *blank
      * MT94X Field 86 - 6
     C                   Eval      AZF866 = *blank

     C                   WRITE     GLAPZSD0

     C                   Endsr
     C********************************************************************
      * Wrt_CChgEntry - Write credit charge posting entry to GLAPZSPD
      ********************************************************************
     C     Wrt_CChgEntry Begsr

      * Clear output entry

     C                   CLEAR                   O_ENTRY
      * Record ID
     C                   MOVEL     'P'           E_RECI
      * Credit Account is Charge income
     C                   MOVEL     @ChICNUM      E_CNUM
     C                   MOVEL     @ChICCY       E_CCY
     C                   MOVEL     @ChIACCD      E_ACOD
     C                   MOVEL     @ChIACSQ      E_ACSQ
     C                   MOVEL     @ChIACNO      E_ACNO
     C
      * Posting Date
     C                   Z-ADD     BJRDNB        E_PSTD
      * Value Date
     C                   Z-ADD     BJRDNB        E_VALD
      * Transaction Type
     C                   MOVEL     *blanks       E_TRAT
      * Posting Narrative
     C                   Eval      E_PNAR = 'Trf Charges T/S/ZB'
      * Posting Amount
     C                   Z-ADD     @RCHGA        E_PSTA
      * DR/CR indicator
     C                   Z-ADD     1             E_DRCR
      * Source of Posting
     C                   MOVE      'GE-CX'       E_SPOS
      * Branch
     C                   MOVEL     @ChIBRCA      E_BRCA

      * Retail indicator
      * A/c type
     C                   Z-ADD     0             E_RIND
     C                   MOVEL     @ChIATYP      E_ATYP
      * Posting indicators
     C                   BITOFF    '01234567'    E_PRIN
      * Profit centre
      * Account section
     C                   MOVEL     @ChIPRFC      E_PRFC
     C                   MOVEL     @ChIACSC      E_ACSC
      * Original transaction sub-type
     C                   MOVEL     CLLINK        E_OTST
      * Original transaction type
     C                   MOVEL     CLHIER        E_OTTP
      * Ext.Fil Ref.ID
     C                   MOVEL     AZXRFI        E_XRFI
      * Ext.Fil Ref.No.
     C                   Z-ADD     AZXRFN        E_XRFN
      * Transaction Sub-type
     C                   MOVEL     CLLEVL        E_TRST

     C                   WRITE     APOSTPDF

     C                   Endsr
     C********************************************************************
      * Wrt_ICS - Write Record to REICSDPD
      ********************************************************************
     C     Wrt_ICS       Begsr

     C                   Eval      I_SAMT = @PSTA + @RCHGA
     C                   Eval      I_R3AM = I_SAMT
     C                   Eval      I_PSTA = @PSTA

     C                   CALLB     'REWRTICS'

      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS

      * INPUTS
      * Hierarchy ID
      * Hierarchy Shortname
     C                   PARM      CDHIER        I_HIER            9 0
     C                   PARM      CDHISN        I_HISN           10
      * Link ID
     C                   PARM      CLLINK        I_LINK            9 0
      * Child branch
      * Child customer
      * Child currency
      * Child a/c code
      * Child a/c seq.
     C                   PARM      @CBRCA        I_CBRC            3
     C**********         PARM      @CCNUM        I_CCUS            6 0                        CSD027
     C                   PARM      @CCNUM        I_CCUS            6                          CSD027
     C                   PARM      @CCCY         I_CCCY            3
     C**********         PARM      @CACCD        I_CACD            4 0                        CGL029
     C                   PARM      @CACCD        I_CACD                                       CGL029
     C                   PARM      @CACSQ        I_CASN            2 0
      * Child A/c Category
     C                   PARM      'T'           I_CCAT            1
      * Parent branch
      * Parent customer
      * Parent currency
      * Parent a/c code
      * Parent a/c seq.
     C                   PARM      @DBRCA        I_PBRC            3
     C**********         PARM      @DCNUM        I_PCUS            6 0                        CSD027
     C                   PARM      @DCNUM        I_PCUS            6                          CSD027
     C                   PARM      @DCCY         I_PCCY            3
     C**********         PARM      @DACCD        I_PACD            4 0                        CGL029
     C                   PARM      @DACCD        I_PACD           10 0                        CGL029
     C                   PARM      @DACSQ        I_PASN            2 0
      * Child Account Narrative
      * Parent Account Narrative
     C                   PARM      *BLANK        I_CNAR           30
     C                   PARM      WCusref       I_PNAR           30
      * Destination
      * Destination Type
      * Sender's Correspondent
      * Receiver's Correspondent
      * MT202 Cover Message Required
      * MT103 Value Date Offset
     C                   PARM      *blank        I_DEST           18
     C                   PARM      *blank        I_DSTT            1
     C                   PARM      *blank        I_SNDC            2
     C                   PARM      *blank        I_RCVC           11
     C                   PARM      *blank        I_MCMR            1
     C                   PARM      *blank        I_MVDO            1
      * MT101 Charges
      * MT101 Charges Account
      * MT101 Charges Amount
      * MT101 Instruction Code
      * MT103 Charges
      * MT103 Charges Account
      * MT103 Charges Amount
      * MT103 Instruction Code
      * MT103 Bank Operation Code
     C                   PARM      *blank        I_CHG1            3
     C**********         PARM      *blank        I_CAC1           18                          CGL029
     C                   PARM      *blank        I_CAC1           24                          CGL029
     C                   PARM      0             I_CAM1           15 0
     C                   PARM      *blank        I_ICD1            4
     C                   PARM      *blank        I_CHG3            3
     C**********         PARM      *blank        I_CAC3           18                          CGL029
     C                   PARM      *blank        I_CAC3           24                          CGL029
     C                   PARM      0             I_CAM3           15 0
     C                   PARM      *blank        I_ICD3            4
     C                   PARM      *blank        I_BOCD            4
      * External Account 1
      * External Account 2
      * External Account 3
      * External Account 4
      * External Account 5
     C                   PARM      *blank        I_EXA1           35
     C                   PARM      *blank        I_EXA2           35
     C                   PARM      *blank        I_EXA3           35
     C                   PARM      *blank        I_EXA4           35
     C                   PARM      *blank        I_EXA5           35
      * Shadow Posted
     C                   PARM      'Y'           I_SPTD            1
      * Incoming Msg SWIFT Reference (Incoming MT103)
     C                   PARM      WSMSR         I_SMSR           16
     C                   PARM      WSMIR         I_SMIR           28
      * Incoming Msg Sender and Amount
     C                   PARM      WSNDR         I_SNDR           11
     C                   PARM                    I_SAMT           15 0
      * Reply MT103 Reference
      * Reply MT103 Amount
      * Reply MT103 Action
     C                   PARM      *Blank        I_R3RF           16
     C                   PARM                    I_R3AM           15 0
     C                   PARM      *blank        I_R3AC            7
      * Next Available Seq No.
     C                   PARM                    I_NASN            2 0
      * Posting amount
      * Child A/c Debit/Credit ind
      * Value date
      * Sweep Description
      * Sweep Type     (Z or S)
     C                   PARM                    I_PSTA           13 0
     C                   PARM      'C'           I_CADC            1
     C                   PARM      @VALD         I_VALD            5 0
     C                   PARM      *BLANK        I_SDES           30
     C                   PARM      'S'           I_STYP            1

      * Extension Reference Numbers
     C                   PARM                    I_XRFN

     C     X_RTCD        IFEQ      '*ERROR'
     C     *LOCK         IN        LDA
     C                   Z-ADD     15            DBASE                            * * * * * * *
     C                   Eval      DBKEY = 'Error in write to REICSDPD'           * DBERR 015 *
     C                   MOVEL     'REWRTICS'    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif

     C                   Endsr
     C********************************************************************
      * Shp_Entry - Write Shadow Posting Entries
      ********************************************************************
     C     Shp_Entry     Begsr


     C                   CALLB     'RE100605'

      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
      * INPUTS
      * Entry
     C                   PARM                    O_ENTRY

     C                   IF        X_RTCD = '*ERROR'
     C     *LOCK         IN        LDA
     C                   Z-ADD     16            DBASE                            * * * * * * *
     C                   Eval      DBKEY = 'Error in Shadow Post Entry'           * DBERR 016 *
     C                   MOVEL     'RE100605'    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif

     C                   Endsr
     C********************************************************************
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   MOVEL     '*ERROR'      P@RTCD

     C                   DUMP

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   RETURN

     C                   ENDSR
