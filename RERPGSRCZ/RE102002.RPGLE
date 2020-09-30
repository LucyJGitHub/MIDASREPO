     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Cash Mgt - Process Incoming MT101')           *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE102002 - RE Cash Mgt - Process Incoming MT101              *
      *                                                               *
      *  Function:  This program creates the sweeping postings        *
      *             requested from Incoming MT101s.  It receives      *
      *             the MT101 message from PDATA.  It writes the      *
      *             entries to  GLPSTTPD (with extension details      *
      *             written to GLAPSTZSPD).  It will then write a     *
      *             record to REICSDPD and then submit the job        *
      *             SWP_MSG to produce the Reply MT103.               *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. 239476             Date 28May12               *
      *  Prev Amend No. 223783             Date 28May12               *
      *                 AR928996A          Date 03May12               *
      *                 AR928996           Date 27Mar12               *
      *                 MD046248           Date 27Oct17               *
      *                 AR676213           Date 19Nov10               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP205             Date 22Mar10               *
      *                 CAP204             Date 09Feb10               *
      *                 BUG24998           Date 17Jul09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSC023             Date 28Jan04               *
      *                 CGL029             Date 01Sep03               *
      *                 215900             Date 08Apr03               *
      *                 213572             Date 20Mar03               *
      *                 213569             Date 10Feb03               *
      *                 214360             Date 03Feb03               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  239476 - Reverse fix 223783 for this program.                *
      *         - Correct field 61 sub7 and field 86                  *
      *         - Applied for AR973615 (Child: AR973617)              *
      *  223783 - Format field 61 and field 86.                       *
      *         - Applied for AR973615 (Child: AR973617)              *
      *  AR928996A- Data truncation error. Amended PDATA and PDAT2    *
      *             data structure field to have the correct length.  *
      *             (Child: AR928997A)                                *
      *  AR928996 - Data lost due to rate field :36: being truncated. *
      *             (Child: AR928997)                                 *
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
      *  CSC023 - SBMJOB output queue must be *JOBD.                  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  215900 - Correct narratives for master account               *
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
     F                                     IGNORE(ACCNTAAF: ACCNTACF)
     FSDCURRLD  IF   E           K DISK    INFSR(*PSSR)

      *****************************************************************
      *
     D I_XRFN          S             10    DIM(6)
     D #_ALCOBJ        S             60    DIM(1)  CTDATA PERRCD(1)
     D #_DLCOBJ        S             60    DIM(1)  CTDATA PERRCD(1)
     D #_SBMJOB        S             62    DIM(3)  CTDATA PERRCD(1)
      *
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      * Incoming Message Data Structure
     D/COPY MECPYSRC,ME1100_ILE
     D/COPY FTCPYSRC,FT0010D001                                                 213569

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

     D @CACNO          S             10  0
     D @CPRFC          S              4
     D @CACSC          S              2
     D @CATYP          S              1

     D @WACNO          S             10                                         213572
     D @DACNO          S             10  0
     D @DPRFC          S              4
     D @DACSC          S              2
     D @DATYP          S              1

     D @ChgACNO        S             10  0
     D @ChgPRFC        S              4
     D @ChgACSC        S              2
     D @ChgATYP        S              1

     D @ChIACNO        S             10  0
     D @ChIPRFC        S              4
     D @ChIACSC        S              2
     D @ChIATYP        S              1

     D WPSTA           S             15
     D @PSTA           S             15  0
     D @VALD           S              5  0
     D @DETP           S            105
     D @DETC           S              3
     D DateIn          S              6A
     D DaynoOut        S              5P 0
     D WDFIN           S              1A
     D ErrorFlag       S              1A
     D @DEST           S             11
     D WString         S             65A
     D WCusRef         S             30A
     D WSMSR           S             16
     D WSMIR           S             28
     D*WCMSR****       S             34                                                223783 239476
     D WSNDR           S             11
     D WCCY            S              3
     D WVDATD          S              6

     D KHIER           S              9  0
     D KLINK           S              9  0
     D KPRCD           S              5  0
     D KSNUM           S              2  0

     D***@TOPAC*         DS            18                                                     CGL029
     D @TOPAC          DS            24                                                       CGL029
     D  @DBRCA                 1      3
     D**@DCNUM**               4      9  0                                                    CSD027
     D  @DCNUM                 4      9A                                                      CSD027
     D  @DCCY                 10     12
     D***@DACCD*               13     16  0                                                   CGL029
     D***@DACSQ*               17     18  0                                                   CGL029
     D  @DACCD                13     22  0                                                    CGL029
     D  @DACSQ                23     24  0                                                    CGL029

     D***@PACCT*         DS            18                                                     CGL029
     D @PACCT          DS            24                                                       CGL029
     D  @CBRCA                 1      3
     D**@CCNUM**               4      9  0                                                    CSD027
     D  @CCNUM                 4      9A                                                      CSD027
     D  @CCCY                 10     12
     D***@CACCD*               13     16  0                                                   CGL029
     D***@CACSQ*               17     18  0                                                   CGL029
     D  @CACCD                13     22  0                                                    CGL029
     D  @CACSQ                23     24  0                                                    CGL029

     D***@ChgAcct        DS            18                                                     CGL029
     D @ChgAcct        DS            24                                                       CGL029
     D  @ChgBRCA               1      3
     D**@ChgCNUM               4      9  0                                                    CSD027
     D  @ChgCNUM               4      9A                                                      CSD027
     D  @ChgCCY               10     12
     D***@ChgACCD              13     16  0                                                   CGL029
     D***@ChgACSQ              17     18  0                                                   CGL029
     D  @ChgACCD              13     22  0                                                    CGL029
     D  @ChgACSQ              23     24  0                                                    CGL029

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

     D Reference       DS
     D  Ref_Link               1      9  0
     D  Ref_Nasn              10     11  0

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
      *
     C                   Eval      ZMDAY = BJRDNB
     C                   CALL      'ZM0060'                             15
     C                   PARM                    ZMDAY             5 0
     C                   PARM                    ZMDATE            6
      *
      ** If the program ends in error.
      *
     C     *IN15         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     01            DBASE                            * * * * * * *
     C                   MOVEL     '       '     DBKEY                            * DBERR 002 *
     C                   MOVEL     'ZM0060'      DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C                   MOVE      ZMDATE        Wmgde             6

     C                   CALLB     'AOCMANR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDCMAN        PARM      SDCMAN        DSSDY

      * Key list
     C     KAccnt        Klist
     C                   Kfld                    @DCNUM
     C                   Kfld                    @DCCY
     C                   Kfld                    @DACCD
     C                   Kfld                    @DACSQ
     C                   Kfld                    @DBRCA
     C
     C     KChgAccnt     Klist
     C                   Kfld                    @ChgCNUM
     C                   Kfld                    @ChgCCY
     C                   Kfld                    @ChgACCD
     C                   Kfld                    @ChgACSQ
     C                   Kfld                    @ChgBRCA

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

      *  Get Debit Account Details (top a/c in Midas)
     C                   Exsr      GetDrAcct

      *  Access Hierarchy Details
     C                   Exsr      GetHierDet

      *  Get Credit Account Details (nostro attached to top a/c)
     C                   Exsr      GetCrAcct
                                                                                213569
      *  Find out charges details if charge is applicable                       213569
                                                                                213569
     C                   If        ZDCAM3 <> 0                                  213569
     C                   Exsr      GetChgAcDet                                  213569
     C                   Exsr      GetChIAcDet                                  213569
     C                   Endif                                                  213569
                                                                                213569

      * Get Next REICSDPD sequence no.
     C                   EXSR      Get_NxtSeqNo

      * Get Next Available Ref. No.
     C                   EXSR      Get_Apna

      * Write DEBIT extension record
      * Write DEBIT entry

     C                   Exsr      Wrt_DrExtsn
     C                   Exsr      Wrt_DrEntry

     C                   ADD       1             C
     C                   MOVEL     O_XRFN        I_XRFN(C)

      * Get Next Available Ref. No.

     C                   EXSR      Get_Apna

      * Write CREDIT extension record
      * Write CREDIT entry

     C                   Exsr      Wrt_CrExtsn
     C                   Exsr      Wrt_CrEntry

     C                   ADD       1             C
     C                   MOVEL     O_XRFN        I_XRFN(C)

      * Write Charges entries only if charge is applicable

     C                   If        ZDCAM3 <> 0
                                                                                213569
     C***********                  and @DETC = 'BEN'                            213569
      ***********
     C***********        If        ZDCAC3 <> *blank
     C***********        Exsr      GetChgAcDet
     C***********        Endif
     C***********        Exsr      GetChIAcDet
      *                                                                         213569
      * If 'BEN' and charge account not defined, do not do debit charge posting 213569
      * as charge would have been deducted already from the nostro              213569
                                                                                213569
     C                   If        @DETC = 'BEN' And                            213569
     C                             ZDCAC3 = *blank                              213569
     C                   Goto      CrChg                                        213569
     C                   Endif                                                  213569

      * Get Next Available Ref. No.

     C                   EXSR      Get_Apna

     C                   Exsr      Wrt_DChgExtsn
     C                   Exsr      Wrt_DChgEntry

     C                   ADD       1             C
     C                   MOVEL     O_XRFN        I_XRFN(C)

     C     CrChg         Tag                                                    213569

      * Get Next Available Ref. No.

     C                   EXSR      Get_Apna

     C                   Exsr      Wrt_CChgExtsn
     C                   Exsr      Wrt_CChgEntry

     C                   ADD       1             C
     C                   MOVEL     O_XRFN        I_XRFN(C)

     C                   Endif

      * Write record to REICSDPD

     C                   Exsr      Wrt_ICS

      * Generate Reply MT103
     C                   EXSR      Gen_RepMT103

     C                   Endsr
      *******************************************************************
      * GetMsgDet  - Get MT101 Message Details                           *
      ********************************************************************
     C     GetMsgDet     BEGSR
      *
      * The MT101 message details are from DS/PDATA and PHEAD
      *
      *  Retrieve Message Input Reference
     C                   Movel     PHMIR         WSMIR
      *  Retrieve Message Transaction Reference
     C                   Movel     PH20          DSTRAN
     C                   Movel     TMLIN         WSMSR
      *                                                                                       223783
      ***Retrieve*Customer*Reference***********************************                223783 239476
      *                                                                                       223783
     C**********         Movel     PH21R         DSTRAN                                223783 239476
     C**********         Movel     TMLIN         WCMSR                                 223783 239476
      *  Retrieve Message Sender
     C                   Movel     PSNDR         WSNDR
      *
      *  Retrieve Posting Value date
     C                   Eval      WVDAT = %subst(PH30 : 25 : 6)
     C                   Eval      WVDATD = DD + MM + YY
     C                   Movel     WVDATD        DateIn
     C                   Callb     'ZDATE1'                             90
     C                   PARM                    DateIn
     C                   PARM                    DayNoOut
     C                   PARM      'D'           WDFIN
     C                   PARM                    ErrorFlag
      *
     C                   If        *IN90 = *ON
     C     *LOCK         IN        LDA
     C                   Z-ADD     2             DBASE                            * * * * * * *
     C                   Movel     '*CALL   '    DBKEY                            * DBERR 002 *
     C                   MOVEL     'ZDATE1  '    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif
      *
     C                   Z-add     DayNoOut      @VALD
      *
      *  Retrieve Posting Currency
     C                   Eval      WCCY  = %subst(P32B : 25 : 3)
     C     WCCY          Chain     SDCURRLD                           60
     C                   If        *IN60 = *ON
     C     *LOCK         IN        LDA
     C                   Z-ADD     3             DBASE                            * * * * * * *
     C                   Movel     WCCY          DBKEY                            * DBERR 003 *
     C                   MOVEL     'SDCURRLD'    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif

      *  Retrieve Posting Amount
     C                   Eval      WPSTA = %subst(P32B : 28 : 15)
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
     C                   Z-ADD     04            DBASE                            * * * * * * *
     C                   Movel     '*CALL   '    DBKEY                            * DBERR 004 *
     C                   MOVEL     'ZALIGN  '    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif
      *
     C                   Move      ZAFLD         @PSTA
     C                   Endif

      *  Retrieve Reply MT103 Destinatiom
     C                   Movel     P57           DSTRAN
     C                   Movel     TMLIN         @DEST

      *  P70 = XXX/account number/customer reference
     C                   Movel     P70           DSTRAN
     C                   Movel     TMLIN         @DETP

      *  Retrieve Details of Charges
     C                   Movel     P71           DSTRAN
     C                   Movel     TMLIN         @DETC
      *
     C                   Endsr
      *******************************************************************
      * GetDrAcct  - Get Debit Account Details                           *
      ********************************************************************
     C     GetDrAcct     BEGSR

      * This is the Top account from the Incoming MT101

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
     C                   MOVEL     'RE102002'    DBFILE                           * * * * * * *
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

     C                   Eval      @DACNO = ACNO
     C                   Eval      @DPRFC = PRFC

      * Access account code details

     C                   MOVEL     @DACCD        X_ACCD
     C                   CALLB     'ZAACSACOD'
     C**********         PARM                    X_ACCD            4                          CGL029
     C                   PARM                    X_ACCD           10                          CGL029
     C                   PARM                    SDACOD
      *
     C                   IF        A5ACCD = *blank
     C     *LOCK         IN        LDA
     C                   Z-ADD     07            DBASE                            * * * * * * *
     C                   Movel     @DACCD        DBKEY                            * DBERR 007 *
     C                   MOVEL     'ZAACSACOD'   DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif
      *
     C                   MOVEL     A5ACSC        @DACSC
     C                   MOVEL     A5ACTY        @DATYP
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
     C                   Z-ADD     8             DBASE                            * * * * * * *
     C                   Eval      DBKEY = @TOPAC                                 * DBERR 008 *
     C                   MOVEL     'REZSHLJ1'    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif

     C                   Z-add     J_CLHIER      I_HIER
     C                   Z-add     J_CLLINK      I_LINK


      ** Access hierarchy detail group detail record

     C                   CALLB     'RE100601'
      * Return code
      * Error Message
     C                   PARM                    X_RTCD
     C                   PARM                    X_ERMS
      * Option
     C                   PARM      '*ALL   '     X_OPTN
      * Hierarchy ID
     C                   PARM                    I_HIER            9 0
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
     C                   PARM                    I_HIER            9 0
      * Hierarchy Type
     C                   PARM      'ZS'          I_HTYP            2
      * Link ID
     C                   PARM                    I_LINK            9 0
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
     C                   Z-ADD     17            DBASE                            * * * * * * *
     C                   MOVEL     '*CALL  '     DBKEY                            * DBERR 017 *
     C                   MOVEL     'RE100602'    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif

     C                   ENDSR
      ********************************************************************
      *  GetCrAcct - Get Credit Account                                  *
      ********************************************************************
     C     GetCrAcct     Begsr

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
     C                   MOVEL     O_PBRC        @CBRCA
     C**********         Z-ADD     O_PCUS        @CCNUM                                       CSD027
     C                   EVAL      @CCNUM = O_PCUS                                            CSD027
     C                   MOVEL     O_PCCY        @CCCY
     C                   Z-ADD     O_PACD        @CACCD
     C                   Z-ADD     O_PASN        @CACSQ
      * Parent retail no.
      * Parent a/c profit centre
      * Parent a/c account section
      * Parent a/c account type
     C                   Z-ADD     O_PRNO        @CACNO
     C                   MOVEL     O_PPRF        @CPRFC
     C                   MOVEL     O_PACS        @CACSC
     C                   MOVEL     O_PATY        @CATYP

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
     C                   Eval      I_NASN = KSNUM

     C                   ENDSR
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
     C                   MOVEL     'S'           AZASDA
      * Contra posting amount
     C                   Z-ADD     @PSTA         AZCAMT
      * Sweep Type
     C                   MOVEL     'S'           AZSTYP
      * Top/Sweep
     C                   MOVEL     'T'           AZTPSW
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
     C**********         Movel     WCusRef       AZF617                                       223783
     C**********         Movel     WCMSR         AZF617                                223783 239476
     C                   MOVEL     WCusRef       AZF617                                       239476
     C                   Endif
     C**********         If        WCusRef = *blank                                           223783
     C**********         If        WCMSR = *blank                                      223783 239476
     C                   IF        WCusRef = *blank                                           239476
     C                   Eval      AZF617 = 'NONREF'
     C                   Endif
     C                   IF        %SUBST(ZLCNAR : 1 : 3)  = 'CMX'                            239476
     C                   EVAL      AZF617 = 'NONREF'                                          239476
     C                   ENDIF                                                                239476
     C                   IF        %SUBST(ZLCNAR : 1 : 3) <> 'CMX'                            239476
     C                   EVAL      AZF617 = ZLCNAR                                            239476
     C                   ENDIF                                                                239476
      * MT94X Field 61 - 8
     C                   Eval      AZF618 = *Blank
      * MT94X Field 61 - 9  (get Fld 59 account name, line 2)
     C                   Movel     P59           DSTRAN
     C                   Movel     TMLIN         WDATA
     C                   If        %Subst(WLine1 : 1 : 1)  <> '/'
     C                   Movel     WLine1        AZF619
     C                   Else
     C                   Movel     WLine2        AZF619
     C                   Endif

      * For Fld 86, concatenate CMx + ext-acct + Customer ref + ext acct name
     C                   Eval      WLongStr = *blank
     C                   Eval      WString  = *blank
     C                   Eval      WLongStr = %subst(@DETP: 1 : 3)
     C     WlongStr      Cat       WLine1:0      WLongStr

     C                   If        %Subst(AZF617 : 1 : 7) <> 'NONREF'
     C                   Cat       '/':0         WLongStr
     C*****WlongStr      Cat       WCusRef:0     WLongStr                                     223783
     C*****WlongStr      Cat       WCMSR:0       WLongStr                              223783 239476
     C*****WlongStr      Cat       WCusRef:0     WLongStr                                     239476
     C     WlongStr      CAT       AZF617:0      WLongStr                                     239476
     C                   Endif

     C     WlongStr      Cat       WString:0     WLongStr
     C                   Cat       '/':0         WLongStr
     C                   Cat       AZF619:0      WLongStr

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
     C**********         If        WCusRef <>  *Blank                           215900
     C                   If        %Subst(ZLCNAR : 1 : 3)  = 'CMX'              215900
     C                   Eval      E_PNAR = %subst(@DETP:1:3) + WLine1          215900
     C                   If        %subst(E_PNAR:4:1) = '/'                     215900
     C                   Eval      %subst(E_PNAR:4:1) = ' '                     215900
     C                   Endif                                                  215900
     C                   Else
     C**********         MOVEL     @DETP         E_PNAR                         215900
     C                   MOVEL     ZLCNAR        E_PNAR                         215900
     C                   Endif
      * Posting Amount
     C                   Z-ADD     @PSTA         E_PSTA
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
     C                   MOVEL     'D'           AZASDA
      * Contra posting amount
     C                   Z-ADD     @PSTA         AZCAMT
      *    If 'BEN', deduct charges                                             213569
     C                   If        @DETC =  'BEN' AND                           213569
     C                             ZDCAC3 = *blank                              213569
     C                   Sub       HChgAmt       AZCAMT                         213569
     C                   Endif                                                  213569
      * Sweep Type
     C                   MOVEL     'S'           AZSTYP
      * Top/Sweep
     C                   MOVEL     'T'           AZTPSW
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
      * Wrt_CrEntry - Write credit posting entry to GLPSTTPD
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
      * must be CM* from fld 70 + top account number                               213572
     C***********        If        WCusRef <>  *Blank                              213572
     C***********        Movel     WCusRef       E_PNAR                            213572
     C***********        Else                                                      213572
     C***********        MOVEL     @DETP         E_PNAR                            213572
     C***********        Endif                                                     213572
     C                   MOVEL     @DACNO        @WACNO                            213572
     C                   If        @WACNO <> *blank                                213572
     C                   Eval      E_PNAR = %subst(@DETP : 1 : 3) + ' ' + @WACNO   213572
     C                   Else                                                      213572
     C                   Eval      E_PNAR = %subst(@DETP : 1 : 3) + ' ' + @TOPAC   213572
     C                   Endif                                                     213572
     C*                                                                            213572
      * Posting Amount
     C                   Z-ADD     @PSTA         E_PSTA
      *    If 'BEN', deduct charges                                                213569
     C                   If        @DETC =  'BEN' AND                              213569
     C                             ZDCAC3 = *blank                                 213569
     C                   Sub       HChgAmt       E_PSTA                            213569
     C                   Endif                                                     213569
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
      *******************************************************************
      * GetChgAcDet  - Get Charge Account Details                        *
      ********************************************************************
     C     GetChgAcDet   BEGSR
      *
     C                   Z-ADD     ZDCAM3        HChgAmt          13 0          213569
      *
      *  Get charge account, if defined
      *
     C                   IF        ZDCAC3 <> *blank                             213569
      *
     C                   Movel     ZDCAC3        @ChgAcct

      * Access account details

     C     KChgaccnt     Chain     ACCNTABF                           60
     C                   IF        *IN60 = *ON  Or
     C                             RECI <> 'D'
     C     *LOCK         IN        LDA
     C                   Z-ADD     12            DBASE                            * * * * * * *
     C                   Eval      DBKEY = @ChgAcct                               * DBERR 012 *
     C                   MOVEL     'ACCNTAB '    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif
      *
     C                   Eval      @ChgACNO = ACNO
     C                   Eval      @ChgPRFC = PRFC

      * Access account code details

     C                   MOVEL     @ChgACCD      X_ACCD
     C                   CALLB     'ZAACSACOD'
     C**********         PARM                    X_ACCD            4                          CGL029
     C                   PARM                    X_ACCD                                       CGL029
     C                   PARM                    SDACOD
      *
     C                   IF        A5ACCD = *blank
     C     *LOCK         IN        LDA
     C                   Z-ADD     13            DBASE                            * * * * * * *
     C                   Movel     @ChgACCD      DBKEY                            * DBERR 013 *
     C                   MOVEL     'ZAACSACOD'   DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif
      *
     C                   MOVEL     A5ACSC        @ChgACSC
     C                   MOVEL     A5ACTY        @ChgATYP
      *                                                                         213569
      *                                                                         213569
      * Convert Charge Amount to charge accoutn currency if necessary           213569
      * (This happens when the MT101/3 Charge account is defined and it         213569
      * is in a different currency than that of the hierarchy's)                213569
      *                                                                         213569
     C                   If        @ChgCcy <> @DCCY                             213569
     C                   CLEAR                   P#0010                         213569
     C                   MOVEL     @ChgCcy       P#FRCY                         213569
     C                   Z-ADD     ZDCAM3        P#FRAM                         213569
     C                   MOVEL     @DCCY         P#TOCY                         213569
                                                                                213569
     C                   CALL      'FT0010'                                     213569
     C                   PARM                    P#0010                         213569
                                                                                213569
     C                   If        P#RTCD <> *blanks                            213569
     C     *LOCK         IN        LDA                                          213569
     C                   Z-ADD     18            DBASE                          213569
     C                   Eval      DBKEY = 'FT0010'                             213569
     C                   MOVEL     '*CALL   '    DBFILE                         213569
     C                   OUT       LDA                                          213569
     C                   EXSR      *PSSR                                        213569
     C                   Else                                                   213569
     C                   Z-add     P#TOAM        HChgAmt                        213569
     C                   ENDIF                                                  213569
                                                                                213569
     C                   ENDIF                                                  213569
                                                                                213569
     C                   ENDIF                                                  213569
      *
     C                   Endsr
      *******************************************************************
      * GetChIAcDet  - Get Charge Income Account Details                 *
      ********************************************************************
     C     GetChIAcDet   BEGSR
      *
      * Set Up charge income account:
      **Branch*is*Hierarcy*branch*                                              213569
     C***********        Eval      @ChIBRCA = CDBRCA                            213569
      * Branch Charge account branch                                            213569
     C     ZDCAC3        IFNE      *blank
     C                   MOVEL     @ChgBRCA      @ChIBRCA
     C                   ELSE
     C                   MOVEL     @DBRCA        @ChIBRCA
     C                   ENDIF
      * Customer is Branch Internal Customer Number
     C                   CALLB     'ZAACSBRCH'
     C                   PARM      @ChIBRCA      PBRCA             3
     C                   PARM                    SDBRCH
     C                   Movel     A8BICN        @ChICNUM
      * Currency is the same as Charge Account's
     C                   If        ZDCAC3 <> *blank                             213569
     C                   Eval      @ChICCY  = @ChgCCY
     C                   Else                                                   213569
     C                   Eval      @ChICCY  = @DCCY                             213569
     C                   Endif                                                  213569
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
      * Wrt_DChgExtsn  - Write debit charge extension record to GLPSTZSPD
      ********************************************************************
     C     Wrt_DChgExtsn Begsr

      * Ext.File Ref.ID
     C                   MOVEL     I_XRFI        AZXRFI
      * Ext.File Ref.No.
     C                   MOVEL     O_XRFN        AZXRFN
      * Debit Account
      *   If MT103 Charge a/c <> blank, use MT103 Charge a/c
      *   Otherwise, use top account
      *   for 'OUR' or 'SHA', if BEN, the charge amount has already been        213569
      *   debited together with the pay amount (earlier)                        213569
     C
     C     ZDCAC3        IFNE      *blank                                       213569
     C                   MOVEL     ZDCAC3        @ChgAcct                       213569
     C                   MOVEL     @ChgBRCA      AZABRC                         213569
     C                   MOVEL     @ChgCNUM      AZACUS                         213569
     C                   MOVEL     @ChgCCY       AZACCY                         213569
     C                   MOVEL     @ChgACCD      AZAACD
     C                   MOVEL     @ChgACSQ      AZAASN
     C                   Z-add     @ChgACNO      AZARNO
     C                   ELSE
     C*****@DETC*********IFEQ      'BEN'                                        213569
     C*******************MOVEL     @CBRCA        AZABRC                         213569
     C*******************MOVEL     @CCNUM        AZACUS                         213569
     C*******************MOVEL     @CCCY         AZACCY                         213569
     C*******************MOVEL     @CACCD        AZAACD                         213569
     C*******************MOVEL     @CACSQ        AZAASN                         213569
     C*******************MOVEL     @CACNO        AZARNO                         213569
     C*******************else                                                   213569
     C                   MOVEL     @DBRCA        AZABRC
     C                   MOVEL     @DCNUM        AZACUS
     C                   MOVEL     @DCCY         AZACCY
     C                   MOVEL     @DACCD        AZAACD
     C                   MOVEL     @DACSQ        AZAASN
     C                   MOVEL     @DACNO        AZARNO
     C*******************ENDIF                                                  213569
     C                   ENDIF

      * A/c is source or destination
     C                   MOVEL     *Blank        AZASDA
      * Contra posting amount
     C     ZDCAC3        IFNE      *blank                                       213569
     C                   Z-ADD     ZDCAM3        AZCAMT
     C                   Else                                                   213569
     C                   Z-ADD     HChgAmt       AZCAMT                         213569
     C                   Endif                                                  213569
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
      * Wrt_DChgEntry - Write debit charge posting entry to  GLPSTTPD
      ********************************************************************
     C     Wrt_DChgEntry Begsr

      * Clear output entry

     C                   CLEAR                   O_ENTRY
      * Record ID
     C                   MOVEL     'P'           E_RECI

      * Customer, currency, a/c code and a/c seq.
      * Retail a/c no.
      *    If MT103 Charge a/c <> blank, use MT103 Charge a/c
      *    Otherwise, use top account
      *   for 'OUR' or 'SHA', if BEN, the charge amount has already been        213569
      *   debited together with the pay amount (earlier)                        213569
     C
     C     ZDCAC3        IFNE      *blank
     C                   MOVEL     ZDCAC3        @ChgAcct
     C                   MOVEL     @ChgCNUM      E_CNUM
     C                   MOVEL     @ChgCCY       E_CCY
     C                   MOVEL     @ChgACCD      E_ACOD
     C                   MOVEL     @ChgACSQ      E_ACSQ
     C                   Z-add     @ChgACNO      E_ACNO
     C                   ELSE
     C*****@DETC*********IFEQ      'BEN'                                        213569
     C*******************MOVEL     @CCNUM        E_CNUM                         213569
     C*******************MOVEL     @CCCY         E_CCY                          213569
     C*******************MOVEL     @CACCD        E_ACOD                         213569
     C*******************MOVEL     @CACSQ        E_ACSQ                         213569
     C*******************Z-add     @CACNO        E_ACNO                         213569
     C*******************Else                                                   213569
     C                   MOVEL     @DCNUM        E_CNUM
     C                   MOVEL     @DCCY         E_CCY
     C                   MOVEL     @DACCD        E_ACOD
     C                   MOVEL     @DACSQ        E_ACSQ
     C                   Z-add     @DACNO        E_ACNO
     C*******************ENDIF                                                  213569
     C                   ENDIF
      * Posting Date
     C                   Z-ADD     BJRDNB        E_PSTD
      * Value Date
     C                   Z-ADD     @VALD         E_VALD
      * Transaction Type
     C                   If        E_ACNO <> 0
     C                   MOVEL     ZDTYPS        E_TRAT
     C                   Endif
      * Posting Narrative
     C                   Eval      E_PNAR = 'Trf Charges T/S/ZB'
      * Posting Amount
     C     ZDCAC3        IFNE      *blank                                       213569
     C                   Z-ADD     ZDCAM3        E_PSTA
     C                   Else                                                   213569
     C                   Z-ADD     HChgAmt       E_PSTA                         213569
     C                   Endif                                                  213569
      * DR/CR indicator
     C                   Z-ADD     0             E_DRCR
      * Source of Posting
     C                   MOVE      'GE-CX'       E_SPOS
      * Branch
     C     ZDCAC3        IFNE      *blank
     C                   MOVEL     @ChgBrca      E_BRCA
     C                   ELSE
     C                   MOVEL     @DBRCA        E_BRCA
     C                   ENDIF

      * Retail indicator
      * A/c type
     C     ZDCAC3        IFNE      *blank
     C                   MOVEL     @ChgATYP      E_ATYP
     C                   ELSE
     C                   MOVEL     @DATYP        E_ATYP
     C                   ENDIF
     C     E_ATYP        IFEQ      'R'
     C                   Z-ADD     1             E_RIND
     C                   ENDIF
      * Posting indicators
     C                   BITOFF    '01234567'    E_PRIN
      * Profit centre
      * Account section
     C     ZDCAC3        IFNE      *blank
     C                   MOVEL     @ChgPRFC      E_PRFC
     C                   MOVEL     @ChgACSC      E_ACSC
     C                   ELSE
     C                   MOVEL     @DPRFC        E_PRFC
     C                   MOVEL     @DACSC        E_ACSC
     C                   ENDIF
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
     C     ZDCAC3        IFNE      *blank                                       213569
     C                   Z-ADD     ZDCAM3        AZCAMT
     C                   Else                                                   213569
     C                   Z-ADD     HChgAmt       AZCAMT                         213569
     C                   Endif                                                  213569
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
     C     ZDCAC3        IFNE      *blank                                       213569
     C                   Z-ADD     ZDCAM3        E_PSTA
     C                   Else                                                   213569
     C                   Z-ADD     HChgAmt       E_PSTA                         213569
     C                   Endif                                                  213569
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

      *  If Details of Charges is 'BEN', charges must be deducted from
      *  posting amount.
     C                   Eval      I_SAMT = @PSTA
     C                   Eval      I_PSTA = @PSTA
      *  Reply MT103 Reference
     C                   Z-add     I_LINK        Ref_Link
     C                   Z-add     I_NASN        Ref_Nasn
     C                   Eval      I_R3RF  = 'RE' + %SUBST(Reference:4:6) +
     C                                       WMgde + %SUBST(Reference:10:2)

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
     C                   PARM      @DBRCA        I_CBRC            3
     C**********         PARM      @DCNUM        I_CCUS            6 0                        CSD027
     C                   PARM      @DCNUM        I_CCUS            6                          CSD027
     C                   PARM      @DCCY         I_CCCY            3
     C**********         PARM      @DACCD        I_CACD            4 0                        CGL029
     C                   PARM      @DACCD        I_CACD                                       CGL029
     C                   PARM      @DACSQ        I_CASN            2 0
      * Child A/c Category
     C                   PARM      'T'           I_CCAT            1
      * Parent branch
      * Parent customer
      * Parent currency
      * Parent a/c code
      * Parent a/c seq.
     C                   PARM      @CBRCA        I_PBRC            3
     C**********         PARM      @CCNUM        I_PCUS            6 0                        CSD027
     C                   PARM      @CCNUM        I_PCUS            6                          CSD027
     C                   PARM      @CCCY         I_PCCY            3
     C**********         PARM      @CACCD        I_PACD            4 0                        CGL029
     C                   PARM      @CACCD        I_PACD           10 0                        CGL029
     C                   PARM      @CACSQ        I_PASN            2 0
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
     C                   PARM      @DEST         I_DEST           18
     C                   PARM      'S'           I_DSTT            1
     C                   PARM      ZDSNDC        I_SNDC            2
     C                   PARM      ZDRCVC        I_RCVC           11
     C                   PARM      ZDMCMR        I_MCMR            1
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
     C                   PARM      ZDICD1        I_ICD1            4
     C                   PARM      @DETC         I_CHG3            3
     C**********         PARM      ZDCAC3        I_CAC3           18                          CGL029
     C                   PARM      ZDCAC3        I_CAC3           24                          CGL029
     C                   PARM      ZDCAM3        I_CAM3           15 0
     C                   PARM      ZDICD3        I_ICD3            4
     C                   PARM      ZDBOCD        I_BOCD            4
      * External Account 1
      * External Account 2
      * External Account 3
      * External Account 4
      * External Account 5
     C                   PARM      WLine1        I_EXA1           35
     C                   PARM      WLine2        I_EXA2           35
     C                   PARM      Wline3        I_EXA3           35
     C                   PARM      Wline4        I_EXA4           35
     C                   PARM      Wline5        I_EXA5           35
      * Shadow Posted
     C                   PARM      'Y'           I_SPTD            1
      * Incoming Msg SWIFT Reference (Incoming MT101)
     C                   PARM      WSMSR         I_SMSR           16
     C                   PARM      WSMIR         I_SMIR           28
      * Incoming Msg SWIFT Reference (Incoming MT101)
     C                   PARM      WSNDR         I_SNDR           11
     C                   PARM                    I_SAMT           15 0
      * Reply MT103 Reference
      * Reply MT103 Amount
      * Reply MT103 Action
     C                   PARM                    I_R3RF           16
     C                   PARM      I_PSTA        I_R3AM           15 0
     C                   PARM      *blank        I_R3AC            7
      * Next Available Seq No.
     C                   PARM                    I_NASN            2 0
      * Posting amount
      * Child A/c Debit/Credit ind
      * Value date
      * Sweep Description
      * Sweep Type     (Z or S)
     C                   PARM                    I_PSTA           13 0
     C                   PARM      'D'           I_CADC            1
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
      * Gen_RepMT103  -  Generate Reply MT103
      ********************************************************************
     C     Gen_RepMT103  Begsr

      *  First, check if it is not already running

     C                   CALL      'QCMDEXC'                            9999
     C                   PARM                    #_ALCOBJ
     C                   PARM      60            LEN              15 5

     C     *in99         CABEQ     '1'           ENDSBM

      * DLCOBJ
     C                   CALL      'QCMDEXC'                            9999
     C                   PARM                    #_DLCOBJ
     C                   PARM      60            LEN              15 5

      * SBMJOB
     C                   CALL      'QCMDEXC'
     C                   PARM                    #_SBMJOB
     C                   PARM      180           LEN              15 5

     C     ENDSBM        Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
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
      *****************************************************************
      /EJECT
      ********************************************************************
** #_ALCOBJ
ALCOBJ OBJ((RESWPMSG *DTAARA *EXCL)) WAIT(0)
** #_DLCOBJ
DLCOBJ OBJ((RESWPMSG *DTAARA *EXCL))
** #_SBMJOB
SBMJOB JOB(CM_SWP_MSG) JOBD(MBATCH) JOBQ(MICJOBQ) USER(*JOBD)
RTGDTA(*JOBD) RQSDTA('CALL REC101303') INLLIBL(*JOBD)                                         CSC023
MSGQ(MOPERQ) OUTQ(*JOBD)                                                                      CSC023
