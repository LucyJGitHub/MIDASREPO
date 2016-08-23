     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Cash Mgt - Process Incoming Reply MT103')     *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE102003 - RE Cash Mgt - Process Incoming Reply MT103        *
      *                                                               *
      *  Function:  This program updates the REICSDPD record          *
      *             that matches the MT101 external topping request.  *
      *             It will also update the postings in               *
      *             GLPSTTPD and extension GLPSTZSPD if the           *
      *             requested and recieved amounts/dates are not the  *
      *             same  then write the shadow postings.             *
      *             Finally, it will write further postings for       *
      *             entries relating to charges.                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. AR676213           Date 19Nov10               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG24998           Date 17Jul09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 215582             Date 04Apr03               *
      *                 215901             Date 01Apr03               *
      *                 213569             Date 07Feb04               *
      *                 214360             Date 03Feb03               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR676213 - Incorrect definition of CLGLAI field (Recompile)  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  BUG24998 - Bank operation code is missing (Recompile)        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  215582 - Fld57  must be equal to Destination BIC in          *
      *           the hierarchy (Here, recompiled only due to changed *
      *           REZSHLJ1)                                           *
      *  215901 - Principal amount and charges must be posted in one  *
      *           go to the nostro/vostro.                            *
      *  213569 - Charges                                             *
      *  214360 - Cash Management Deferred Posting                    *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FGLPSTTL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(E_)
     F                                     COMMIT
     FGLPSTZSL0 UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     FREICSDL3  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     FREICSIL1  IF   E           K DISK    INFSR(*PSSR)
     FREZSHLJ1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(J_)
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(ACCNTAAF: ACCNTACF)
     FSDCURRLD  IF   E           K DISK    INFSR(*PSSR)
     FREICSIPD  O    E             DISK    INFSR(*PSSR)                         215901
     F                                     RENAME(REICSID0:REICSIDX)            216421
     F                                     PREFIX(O_)                           216421
     F                                     COMMIT                               215901
      ********************************************************************
 
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
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)                    213569
     D  QQACD1       E                     EXTFLD (QQACCD)                                    CGL029
      * External DS for Nostro details                                          213569
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
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First  DS for access programs
 
     D X               S              3  0
     D Y               S              3  0
 
     D*@ChgACNO********S             10  0                                      215901
     D*@ChgACSC********S              2                                         215901
     D*@ChgPRFC********S              4                                         215901
     D*@ChgATYP********S              1                                         215901
 
     D @ChIACNO        S             10  0
     D @ChIACSC        S              2
     D @ChIPRFC        S              4
     D @ChIATYP        S              1
 
     D @ACNO           S             10  0
     D @PRFC           S              4
     D @ACSC           S              2
     D @ATYP           S              1
 
     D WPSTA           S             15
     D @PSTA           S             15  0
     D XPSTA           S             15  0
     D @VALD           S              5  0
     D XVALD           S              5  0
     D WRCHGA          S             15
     D @RCHGA          S             15  0
     D @DETP           S            105
     D @DETC           S              3
     D DateIn          S              6A
     D DaynoOut        S              5P 0
     D WDFIN           S              1A
     D ErrorFlag       S              1A
     D WSMSR           S             16
     D WSMIR           S             28
     D WSNDR           S             11
     D XTRNO           S             16
     D UPDATE          S              1
     D WCCY            S              3
     D WVDATD          S              6
     D KXRFI           S              3
     D KXRFN           S             10  0
 
     D*@TOPAC***       DS            18                                                       CGL029
     D @TOPAC          DS            24                                                       CGL029
     D  @BRCA                  1      3
     D**@CNUM***               4      9  0                                                    CSD027
     D  @CNUM                  4      9A                                                      CSD027
     D  @CCY                  10     12
     D**@ACCD***              13     16  0                                                    CGL029
     D**@ACSQ***              17     18  0                                                    CGL029
     D  @ACCD                 13     22  0                                                    CGL029
     D  @ACSQ                 23     24  0                                                    CGL029
 
     D*@ChgAcct*       DS            18                                                       CGL029
     D @ChgAcct        DS            24                                                       CGL029
     D  @ChgBRCA               1      3
     D**@ChgCNUM               4      9  0                                                    CSD027
     D  @ChgCNUM               4      9A                                                      CSD027
     D  @ChgCCY               10     12
     D**@ChgACCD              13     16  0                                                    CGL029
     D**@ChgACSQ              17     18  0                                                    CGL029
     D  @ChgACCD              13     22  0                                                    CGL029
     D  @ChgACSQ              23     24  0                                                    CGL029
     D                                                                          215901
     D*XGLPAcct*       DS            18                                                215901 CGL029
     D XGLPAcct        DS            24                                                       CGL029
     D  X_BRCA                 1      3                                         215901
     D**X_CNUM**               4      9  0                                             215901 CSD027
     D  X_CNUM                 4      9A                                                      CSD027
     D  X_CCY                 10     12                                         215901
     D**X_ACOD**              13     16  0                                             215901 CGL029
     D**X_ACSQ**              17     18  0                                             215901 CGL029
     D  X_ACOD                13     22  0                                                    CGL029
     D  X_ACSQ                23     24  0                                                    CGL029
                                                                                215901
     D*@ChIAcct*       DS            18                                                       CGL029
     D @ChIAcct        DS            24                                                       CGL029
     D  @ChIBRCA               1      3
     D**@ChICNUM               4      9  0                                                    CSD027
     D  @ChICNUM               4      9A                                                      CSD027
     D  @ChICCY               10     12
     D**@ChIACCD              13     16  0                                                    CGL029
     D**@ChIACSQ              17     18  0                                                    CGL029
     D  @ChIACCD              13     22  0                                                    CGL029
     D  @ChIACSQ              23     24  0                                                    CGL029
 
     D WVDAT           DS             6
     D  YY                     1      2
     D  MM                     3      4
     D  DD                     5      6
 
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
 
      * Key lists
     C
     C     KAccnt        Klist
     C                   Kfld                    @CNUM
     C                   Kfld                    @CCY
     C                   Kfld                    @ACCD
     C                   Kfld                    @ACSQ
     C                   Kfld                    @BRCA
     C
     C*****KChgAccnt     Klist                                                  215901
     C************       Kfld                    @ChgCNUM                       215901
     C************       Kfld                    @ChgCCY                        215901
     C************       Kfld                    @ChgACCD                       215901
     C************       Kfld                    @ChgACSQ                       215901
     C************       Kfld                    @ChgBRCA                       215901
 
     C     KReicsi       Klist
     C                   Kfld                    IDHIER
     C                   Kfld                    IDLINK
     C                   Kfld                    IDPRCD
     C                   Kfld                    IDSNUM
 
     C     KGlpst        Klist
     C                   Kfld                    KXRFI
     C                   Kfld                    KXRFN
 
      * Count of entries
      * Extension Ref. Nos.
     C                   Z-ADD     0             C                 2 0
     C                   MOVEL     *BLANK        I_XRFN
 
     C                   Endsr
      ********************************************************************
      * SRPROC - Main Processing
      ********************************************************************
     C     SRPROC        Begsr
 
      *  Get heirarchy details
     C                   Exsr      GetHierDet
 
      *  Get top a/c details
     C                   Exsr      GetTopAcct
 
      *  Get relevant MT103 Details
     C                   Exsr      GetMT103Det
 
      *  Get request MT101 details from REICSDPD
     C                   Exsr      GetMT101Det
 
      *  Update Posting entries in GLPSTTPD and GLPSTZSPD
 
     C                   Exsr      Upd_Post
 
      * Update REICSDPD record to flag the MT101 request as matched.
 
     C                   Exsr      Upd_ICS
 
 
     C**********         ADD       1             C                              215901
     C**********         MOVEL     O_XRFN        I_XRFN(C)                      215901
      **********                                                                215901
      **Write*Charges entries only if Receiver's charge is given                215901
 
     C                   If        @RCHGA <> 0
 
     C***********        If        ZDCAC3 <> *blank                             213569
     C***********        Exsr      GetChgAcDet                                  215901
     C***********        Endif                                                  213569
     C                   Exsr      GetChIAcDet
 
      **Get*Next*Available Ref. No.                                             215901
      ***********                                                               215901
     C***********        EXSR      Get_Apna                                     215901
      ***********                                                               215901
      **Write*Debit Charge Entry  (posted to charge a/c)                        215901
     C***********        Exsr      Wrt_DChgExtsn                                215901
     C***********        Exsr      Wrt_DChgEntry                                215901
      ***********                                                               215901
     C***********        ADD       1             C                              215901
     C***********        MOVEL     O_XRFN        I_XRFN(C)                      215901
 
      * Get Next Available Ref. No.
     C                   EXSR      Get_Apna
 
      * Write Credit Charge Entry (posted to charge income)
     C                   Exsr      Wrt_CChgExtsn
     C                   Exsr      Wrt_CChgEntry
                                                                                215901
      * Write Item Record to REICSIPD                                           215901
     C                   Exsr      Wrt_ICSI                                     215901
 
     C                   ADD       1             C
     C                   MOVEL     O_XRFN        I_XRFN(C)
 
     C                   Endif
 
     C                   Endsr
      *******************************************************************
      * GetMT103Det - Get MT103 Message Details                          *
      ********************************************************************
     C     GetMT103Det   BEGSR
      *
      * The MT103 message details are from DS/PDATA, PHEAD, P@INFO
 
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
     C                   Eval      WCCY  = TVCCY
     C     WCCY          Chain     SDCURRLD                           60
     C     *LOCK         IN        LDA
     C                   If        *IN60 = *ON
     C                   Z-ADD     03            DBASE                            * * * * * * *
     C                   Movel     WCCY          DBKEY                            * DBERR 003 *
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
     C                   Z-ADD     04            DBASE                            * * * * * * *
     C                   Movel     '*CALL   '    DBKEY                            * DBERR 004 *
     C                   MOVEL     'ZALIGN  '    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif
      *
     C                   Move      ZAFLD         @PSTA
     C                   Endif
 
      *  Retrieve Receiver's Charge amount, if available
     C                   Z-add     0             @RCHGA
     C                   Eval      WRCHGA = %subst(P71G : 28 : 15)
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
     C                   Z-ADD     05            DBASE                            * * * * * * *
     C                   Movel     '*CALL   '    DBKEY                            * DBERR 005 *
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
      * GetMT101Det - Get Request MT101 details from REICSDPD            *
      ********************************************************************
     C     GetMT101Det   BEGSR
      *
      * First, get Transaction number of MT101 request
      *
     C                   Eval      X = %scan('*TRNO' : P@INFO : 1)
     C                   If        X > 0
     C                   Eval      Y = %scan('/' : P@INFO : X)
     C                   If        Y > 0
     C                   Eval      XTRNO  = %subst(P@INFO : X + 5 : Y - X - 5)
     C                   Endif
     C                   Endif
 
      * If transaction number not retrieved, error
     C                   IF        XTRNO = *blank
     C     *LOCK         IN        LDA
     C                   Z-ADD     06            DBASE                            * * * * * * *
     C                   Eval      DBKEY = 'MT101 TRNO not retrieved'             * DBERR 006 *
     C                   MOVEL     'RE102003'    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif
 
      * Access REICSDL3 using TRNO
     C     XTRNO         Chain     REICSDL3                           60
     C                   IF        *IN60 = *ON
     C     *LOCK         IN        LDA
     C                   Z-ADD     07            DBASE                            * * * * * * *
     C                   Eval      DBKEY = XTRNO                                  * DBERR 007 *
     C                   MOVEL     'REICSDL3'    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif
      *
      * Get MT101 amount
     C                   Eval      XPSTA = IDSWFA
      * Get MT101 Value date
     C                   Eval      XVALD = IDVALD
      *
     C                   Endsr
      ********************************************************************
      * GetHierDet - Get Heirarchy Details                               *
      ********************************************************************
     C     GetHierDet    BEGSR
      *
      *  Get Top Account Number
      *
     C                   Eval      X = %scan('*TOPA' : P@INFO : 1)
     C                   If        X > 0
     C                   Eval      Y = %scan('/' : P@INFO : X)
     C                   If        Y > 0
     C                   Eval      @TOPAC = %subst(P@INFO : X + 5 : Y - X - 5)
     C                   Endif
     C                   Endif
 
      * If top account not retrieved, error
     C                   IF        @TOPAC = *blank
     C     *LOCK         IN        LDA
     C                   Z-ADD     01            DBASE                            * * * * * * *
     C                   Eval      DBKEY = 'Top Account not retrieved'            * DBERR 001 *
     C                   MOVEL     'RE102003'    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif
 
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
     C                   Z-ADD     15            DBASE                            * * * * * * *
     C                   MOVEL     '*CALL  '     DBKEY                            * DBERR 015 *
     C                   MOVEL     'RE100602'    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif
 
     C                   ENDSR
      ********************************************************************
      * GetTopAcct - Get Top Account Details                             *
      ********************************************************************
     C     GetTopAcct    BEGSR
 
      * Access account
 
     C     Kaccnt        Chain     ACCNTABF                           60
     C                   IF        *IN60 = *ON  Or
     C                             RECI <> 'D'
     C     *LOCK         IN        LDA
     C                   Z-ADD     40            DBASE                            * * * * * * *
     C                   Eval      DBKEY = @TOPAC                                 * DBERR 006 *
     C                   MOVEL     'ACCNTAB '    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif
      *
     C                   Eval      @ACNO = ACNO
     C                   Eval      @PRFC = PRFC
 
      * Access account code details
 
     C                   MOVEL     @ACCD         X_ACCD
     C                   CALLB     'ZAACSACOD'
     C**********         PARM                    X_ACCD            4                          CGL029
     C                   PARM                    X_ACCD           10                          CGL029
     C                   PARM                    SDACOD
      *
     C                   IF        A5ACCD = *blank
     C     *LOCK         IN        LDA
     C                   Z-ADD     41            DBASE                            * * * * * * *
     C                   Movel     @ACCD         DBKEY                            * DBERR 007 *
     C                   MOVEL     'ZAACSACOD'   DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif
      *
     C                   MOVEL     A5ACSC        @ACSC
     C                   MOVEL     A5ACTY        @ATYP
      *
     C                   Endsr
      *******************************************************************
      * Upd_Post- Update Posting Details in GLPSTTPD and extension       *
      *           GLPSTZSPD then write shadow postings                   *
      ********************************************************************
     C     Upd_Post      BEGSR
      *
      *  First, access REICSIPD (there should be 2 records
     C     KReicsi       Setll     REICSIL1
     C     KReicsi       READE     REICSIL1                               60
 
     C                   DOW       *IN60 = *OFF
     C
      *  Update GLPSTTPD
     C                   EVAL      KXRFI = 'ZS '
     C                   EVAL      KXRFN = IIXRFN
      *
     C     KGlpst        Chain     APOSTPDF                           61
     C                   If        *IN61 =  *ON
     C     *LOCK         IN        LDA
     C                   Z-ADD     16            DBASE                            * * * * * * *
     C                   MOVEL     '*CALL  '     DBKEY                            * DBERR 016 *
     C                   MOVEL     'GLPSTTL0 '   DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif
     C                                                                          215901
     C                   Exsr      GetChgAcDet                                  215901
     C                   Eval      X_BRCA = E_BRCA                              215901
     C                   Eval      X_CNUM = E_CNUM                              215901
     C                   Eval      X_CCY  = E_CCY                               215901
     C                   Eval      X_ACOD = E_ACOD                              215901
     C                   Eval      X_ACSQ = E_ACSQ                              215901
      *
      *  Update only if this posting record is for top/sweep amount and not
      *  for charge.
     C                   If        XPSTA = E_PSTA
      *
     C                   Eval      Update = 'N'
      *
      *  Transfer new amount/date fields then upate GLPSTTPD
     C                   If        @PSTA <> XPSTA
     C                   Z-add     @PSTA         E_PSTA
     C                   IF        @ChgAcct = XGLPAcct                          215901
     C                   Add       @RCHGA        E_PSTA                         215901
     C                   ENDIF                                                  215901
     C                   Eval      Update = 'Y'
     C                   Endif
      *                                                                         215901
     C* If payment amts   are equal and receiver's charge > 0 and account is    215901
     C* nostro/vostro, do update to consolidate the debit of charge             215901
     C                   If        @RCHGA > 0                                   215901
     C                   If        @PSTA = XPSTA    AND                         215901
     C                             @ChgAcct = XGLPAcct                          215901
     C                   Add       @RCHGA        E_PSTA                         215901
     C                   Eval      Update = 'Y'                                 215901
     C                   Endif                                                  215901
     C                   Endif                                                  215901
      *
     C                   If        @VALD <> XVALD
     C                   Z-add     @VALD         E_VALD
     C                   Eval      Update = 'Y'
     C                   Endif
      *
     C                   If        Update = 'Y'
     C                   Update    APOSTPDF
     C                   Else
     C                   Unlock    GLPSTTL0
     C                   Endif
      *
      *  Update corresponding Extension record GLPSTZSPD
      *
     C     KGlpst        Chain     GLPSTZSL0                          61
      *
     C                   If        *IN61 =  *ON
     C     *LOCK         IN        LDA
     C                   Z-ADD     17            DBASE                            * * * * * * *
     C                   MOVEL     '*CALL  '     DBKEY                            * DBERR 017 *
     C                   MOVEL     'GLPSTZSL0'   DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif
      *
     C                   Eval      Update = 'N'
      *
      *  Update amount if it changed
     C                   If        @PSTA <> XPSTA
     C                   Z-add     @PSTA         AZCAMT
     C                   IF        @ChgAcct = XGLPAcct                          215901
     C                   Add       @RCHGA        AZCAMT                         215901
     C                   ENDIF                                                  215901
     C                   Eval      Update = 'Y'
     C                   Endif
      *                                                                         215901
     C* If payment amts   are equal and receiver's charge > 0 and account is    215901
     C* nostro/vostro, do update to consolidate the debit of charge             215901
     C                   If        @RCHGA > 0                                   215901
     C                   If        @PSTA = XPSTA    AND                         215901
     C                             @ChgAcct = XGLPAcct                          215901
     C                   Add       @RCHGA        AZCAMT                         215901
     C                   Eval      Update = 'Y'                                 215901
     C                   Endif                                                  215901
     C                   Endif                                                  215901
      *
     C                   If        Update = 'Y'
     C                   Update    GLAPZSD0
     C                   Else
     C                   Unlock    GLPSTZSL0
     C                   Endif
      *
      *  Create Shadow Postings
      *
     C                   Exsr      Shp_Entry
      *
     C                   Endif
      *
     C     KReicsi       READE     REICSIL1                               60
      *
     C                   Enddo
      *
     C                   Endsr
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
     C                   Z-ADD     10            DBASE                            * * * * * * *
     C                   Eval      DBKEY = 'No next available number'             * DBERR 010 *
     C                   MOVEL     'ZAGETAPNA'   DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif
 
     C                   ENDSR
      *******************************************************************
      * GetChgAcDet  - Get Charge Account Details
      ********************************************************************
     C     GetChgAcDet   BEGSR
 
     C***********        Movel     ZDCAC3        @ChgAcct                213569 215901
     C* First, get nostro of top account                                 213569 215901
     C***********        CALL      'AONOSTR0'                            213569 215901
     C***********        PARM      *BLANK        @RTCD             7     213569 215901
     C***********        PARM      '*KEY   '     @OPTN             7     213569 215901
     C***********        PARM      *BLANK        @CUST             6     213569 215901
     C***********        PARM      @CCY          @CYCD             3     213569 215901
     C***********        PARM      *BLANK        @ACOD             4     213569 215901
     C***********        PARM      *BLANK        @ACSN             2     213569 215901
     C***********        PARM      IDSNDC        @NONB             2     213569 215901
     C***********        PARM      *BLANK        @BRCD             3     213569 215901
     C***********        PARM      *BLANK        @CSSN            10     213569 215901
     C***********        PARM      *BLANK        @PNOI             1     213569 215901
     C*****SDNOST        PARM      SDNOST        DSFDY                   213569 215901
     C***********                                                        213569 215901
     C***********        IF        @RTCD <> *BLANK                       213569 215901
     C******LOCK         IN        LDA                                   213569 215901
     C***********        Z-ADD     42            DBASE                   213569 215901
     C***********        MOVEL     '*CALL  '     DBKEY                   213569 215901
     C***********        MOVEL     'RE102003'    DBFILE                  213569 215901
     C***********        OUT       LDA                                   213569 215901
     C***********        EXSR      *PSSR                                 213569 215901
     C***********        Endif                                           213569 215901
      ***********                                                        213569 215901
     C***********        Eval      @ChgBRCA = A7BRCD                     213569 215901
     C***********        Movel     A7CUST        @CHGCNUM                213569 215901
     C***********        Eval      @ChgCCY  = A7CYCD                     213569 215901
     C***********        Movel     A7ACCD        @CHGACCD                213569 215901
     C***********        Eval      @ChgACSQ = A7ACSN                     213569 215901
      ***********                                                        213569 215901
      **Get*retail account number                                        213569 215901
     C*****KChgaccnt     Chain     ACCNTABF                           60 213569 215901
     C***********        IF        *IN60 = *ON  Or                       213569 215901
     C***********                  RECI <> 'D'                           213569 215901
     C******LOCK         IN        LDA                                   213569 215901
     C***********        Z-ADD     11            DBASE                   213569 215901* * * * *
     C***********        Eval      DBKEY = @ChgAcct                      213569 215901ERR 011 *
     C***********        MOVEL     'ACCNTAB '    DBFILE                  213569 215901* * * * *
     C***********        OUT       LDA                                   213569 215901
     C***********        EXSR      *PSSR                                 213569 215901
     C***********        Endif                                           213569 215901
      ***********                                                        213569 215901
     C***********        Eval      @ChgACNO = ACNO                       213569 215901
     C***********        Eval      @ChgPRFC = PRFC                       213569 215901
      ***********                                                        213569 215901
      **Get*account section and account type                             213569 215901
      ***********                                                        213569 215901
     C***********        MOVEL     @ChgACCD      X_ACCD                  213569 215901
     C***********        CALLB     'ZAACSACOD'                           213569 215901
     C***********        PARM                    X_ACCD            4     213569 215901
     C***********        PARM                    SDACOD                  213569 215901
      ***********                                                        213569 215901
     C***********        IF        A5ACCD = *blank                       213569 215901
     C******LOCK         IN        LDA                                   213569 215901
     C***********        Z-ADD     12            DBASE                   213569 215901* * * * *
     C***********        Movel     @ChgACCD      DBKEY                   213569 215901ERR 012 *
     C***********        MOVEL     'ZAACSACOD'   DBFILE                  213569 215901* * * * *
     C***********        OUT       LDA                                   213569 215901
     C***********        EXSR      *PSSR                                 213569 215901
     C***********        Endif                                           213569 215901
      ***********                                                        213569 215901
     C***********        MOVEL     A5ACSC        @ChgACSC                213569 215901
     C***********        MOVEL     A5ACTY        @ChgATYP                213569 215901
      ***********                                                        213569 215901
                                                                                215901
     C                   CALLB     'REZDESTAC'                                  215901
                                                                                215901
      * Return code                                                             215901
      * Error Message                                                           215901
     C                   PARM      *BLANK        X_RTCD                         215901
     C                   PARM      *BLANK        X_ERMS                         215901
      * INPUTS                                                                  215901
      * Hierarchy ID                                                            215901
      * Child currency                                                          215901
     C                   PARM      CDHIER        I_HIER            9 0          215901
     C                   PARM      @CCY          I_CCCY            3            215901
      * Destination                                                             215901
      * Destination Type                                                        215901
      * Sender's*Correspondent                                                  215901
     C                   PARM      IDDEST        I_SDEST          18            215901
     C                   PARM      IDDSTT        I_SDSTT           1            215901
     C                   PARM      IDSNDC        I_SSNDC           2            215901
      *                                                                         215901
      * OUTPUTS                                                                 215901
      * Parent branch                                                           215901
      * Parent customer                                                         215901
      * Parent currency                                                         215901
      * Parent a/c code                                                         215901
      * Parent a/c seq.                                                         215901
     C                   PARM                    O_PBRC            3            215901
     C**********         PARM                    O_PCUS            6 0                 215901 CSD027
     C                   PARM                    O_PCUS            6                          CSD027
     C                   PARM                    O_PCCY            3            215901
     C**********         PARM                    O_PACD            4 0                 215901 CGL029
     C                   PARM                    O_PACD           10 0                        CGL029
     C                   PARM                    O_PASN            2 0          215901
      * Parent retail no.                                                       215901
      * Parent a/c profit centre                                                215901
      * Parent a/c account section                                              215901
      * Parent a/c account type                                                 215901
     C                   PARM                    O_PRNO           10 0          215901
     C                   PARM                    O_PPRF            4            215901
     C                   PARM                    O_PACS            2            215901
     C                   PARM                    O_PATY            1            215901
      * Parent*a/c status                                                       215901
     C                   PARM                    O_ParentSTAT     26            215901
      *                                                                         215901
      * Error fields/message IDs/message data (arrays) from/to caller           215901
     C                   PARM                    FldNameArr                     215901
     C                   PARM                    MsgIDArr                       215901
     C                   PARM                    MsgDtaArr                      215901
      * Array index (3P0) from/to caller                                        215901
     C                   PARM      *ZERO         Ix                3 0          215901
      *                                                                         215901
     C     X_RTCD        IFEQ      '*ERROR'                                     215901
     C     *LOCK         IN        LDA                                          215901
     C                   Z-ADD     42            DBASE                          215901
     C                   Eval      DBKEY = 'Error on destination a/c:'          215901
     C                                     + I_SDEST + I_SDSTT                  215901
     C                   MOVEL     'REZDESTAC'   DBFILE                         215901
     C                   OUT       LDA                                          215901
     C                   EXSR      *PSSR                                        215901
     C                   Endif                                                  215901
      *                                                                         215901
      **Parent*branch                                                           215901
      **Parent*customer                                                         215901
      **Parent*currency                                                         215901
      **Parent*a/c code                                                         215901
      * Parent a/c seq.                                                         215901
     C                   MOVEL     O_PBRC        @ChgBRCA                       215901
     C**********         Z-ADD     O_PCUS        @ChgCNUM                              215901 CSD027
     C                   EVAL      @ChgCNUM = O_PCUS                                          CSD027
     C                   MOVEL     O_PCCY        @ChgCCY                        215901
     C                   Z-ADD     O_PACD        @ChgACCD                       215901
     C                   Z-ADD     O_PASN        @ChgACSQ                       215901
      *                                                                         215901
     C                   Endsr
      *******************************************************************
      * GetChIAcDet  - Get Charge Income Account Details                 *
      ********************************************************************
     C     GetChIAcDet   BEGSR
      *
      * Set Up charge income account:
      **Branch*is*Hierarcy*branch*                                              213569
     C***********        Eval      @ChIBRCA = CDBRCA                            213569
      * Branch is branch of charge account                                      213569
     C                   Eval      @ChIBRCA = @ChgBRCA                          213569
      * Customer is Branch Internal Customer Number
     C                   CALLB     'ZAACSBRCH'
     C                   PARM      @ChIBRCA      PBRCA             3
     C                   PARM                    SDBRCH
     C                   MOVEL     A8BICN        @ChICNUM
      * Currency is the same as Charge Account's
     C***********        Eval      @ChICCY  = @ChgCCY                           215901
     C                   Eval      @ChICCY  = @CCY                              215901
      * Account code is from ICD
     C                   Movel     CMCHAC        @ChIACCD
      * Account sequence is always 01
     C                   Eval       @ChIACSQ = 1
      *
     C                   Eval      @ChIACNO = 0
     C                   Eval      @ChIPRFC = CMCHPC
      *
      * Get account section and account type
      *
     C                   MOVEL     @ChIACCD      X_ACCD
     C                   CALLB     'ZAACSACOD'
     C**********         PARM                    X_ACCD            4                          CGL029
     C                   PARM                    X_ACCD                                       CGL029
     C                   PARM                    SDACOD
      *
     C                   IF        A5ACCD = *blank
     C     *LOCK         IN        LDA
     C                   Z-ADD     13            DBASE                            * * * * * * *
     C                   Movel     @ChIACCD      DBKEY                            * DBERR 013 *
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
      **Wrt_DChgExtsn**-*Write*debit*charge*extension*record*to*GLPSTZSPD*      215901
      ********************************************************************
     C*****Wrt_DChgExtsn Begsr                                                  215901
      ***********                                                               215901
      **Ext.File*Ref.ID                                                         215901
     C***********        MOVEL     I_XRFI        AZXRFI                         215901
      **Ext.File*Ref.No.                                                        215901
     C***********        MOVEL     O_XRFN        AZXRFN                         215901
     C**Debit*Account                                                           215901
      ****If*MT103*Charge*a/c <> blank, use MT103 Charge a/c                    215901
      ****Otherwise,*use*top account                                            215901
     C***********                                                               215901
     C*****ZDCAC3        IFNE      *BLANK                                       213569
     C***********        MOVEL     ZDCAC3        @ChgAcct                       213569
     C***********        MOVEL     @ChgBRCA      AZABRC                         215901
     C***********        MOVEL     @ChgCNUM      AZACUS                         215901
     C***********        MOVEL     @ChgCCY       AZACCY                         215901
     C***********        MOVEL     @ChgACCD      AZAACD                         215901
     C***********        MOVEL     @ChgACSQ      AZAASN                         215901
     C***********        Z-add     @ChgACNO      AZARNO                         215901
     C***********        ELSE                                                   213569
     C***********        MOVEL     @BRCA         AZABRC                         213569
     C***********        MOVEL     @CNUM         AZACUS                         213569
     C***********        MOVEL     @CCY          AZACCY                         213569
     C***********        MOVEL     @ACCD         AZAACD                         213569
     C***********        MOVEL     @ACSQ         AZAASN                         213569
     C***********        Z-add     @ACNO         AZARNO                         213569
     C***********        ENDIF                                                  213569
      ***********                                                               215901
      **A/c*is*source or destination                                            215901
     C***********        MOVEL     *Blank        AZASDA                         215901
      **Contra*posting amount                                                   215901
     C***********        Z-ADD     @RCHGA        AZCAMT                         215901
      **Sweep*Type                                                              215901
     C***********        MOVEL     *Blank        AZSTYP                         215901
      **Top/Sweep                                                               215901
     C***********        MOVEL     *Blank        AZTPSW                         215901
      **Target Balance                                                          215901
     C***********        MOVEL     *Blank        AZTBAL                         215901
      **Shadow*Entry                                                            215901
     C***********        MOVEL     'N'           AZSHAD                         215901
      **Mode*of*Origin                                                          215901
     C***********        MOVEL     *BLANK        AZMODO                         215901
      **Date*Generated                                                          215901
     C***********        Z-ADD     BJRDNB        AZDATG                         215901
      **Sequence Number                                                         215901
     C***********        Z-Add     IISNUM        AZSNUM                         215901
      **MT94X*Field 61 - 6                                                      215901
     C***********        Eval      AZF616 = *blank                              215901
      **MT94X*Field 61 - 7                                                      215901
     C***********        Eval      AZF617 = *blank                              215901
      **MT94X*Field 61 - 8                                                      215901
     C***********        Eval      AZF618 = *Blank                              215901
      **MT94X*Field 61 - 9                                                      215901
     C***********        Eval      AZF619 = *Blank                              215901
      **MT94X*Field 86 - 1                                                      215901
     C***********        Eval      AZF861 = *blank                              215901
      *MT94X**Field 86 - 2                                                      215901
     C***********        Eval      AZF862 = *blank                              215901
      **MT94X*Field 86 - 3                                                      215901
     C***********        Eval      AZF863 = *blank                              215901
      **MT94X*Field 86 - 4                                                      215901
     C***********        Eval      AZF864 = *blank                              215901
      **MT94X*Field 86 - 5                                                      215901
     C***********        Eval      AZF865 = *blank                              215901
      **MT94X*Field 86 - 6                                                      215901
     C***********        Eval      AZF866 = *blank                              215901
      ***********                                                               215901
     C***********        WRITE     GLAPZSD0                                     215901
      ***********                                                               215901
     C***********        Endsr                                                  215901
     C********************************************************************
      **Wrt_DChgEntry*-*Write*debit*charge*posting*entry*to**GLPSTTPD*****      215901
      ********************************************************************
     C*****Wrt_DChgEntry Begsr                                                  215901
      **********                                                                215901
      **Clear*output entry                                                      215901
      **********                                                                215901
     C**********         CLEAR                   O_ENTRY                        215901
      **Record*ID                                                               215901
     C**********         MOVEL     'P'           E_RECI                         215901
      **********                                                                215901
      **Customer, currency, a/c code and a/c seq.                               215901
      **Retail*a/c no.                                                          215901
      ****If*MT103*Charge a/c <> blank, use MT103 Charge a/c                    215901
      ****Otherwise,*use top account                                            215901
     C**********                                                                215901
     C*****ZDCAC3        IFNE      *BLANK                                       213569
     C***********        MOVEL     ZDCAC3        @ChgAcct                       213569
     C**********         MOVEL     @ChgCNUM      E_CNUM                         215901
     C**********         MOVEL     @ChgCCY       E_CCY                          215901
     C**********         MOVEL     @ChgACCD      E_ACOD                         215901
     C**********         MOVEL     @ChgACSQ      E_ACSQ                         215901
     C**********         Z-add     @ChgACNO      E_ACNO                         215901
     C***********        ELSE                                                   213569
     C***********        MOVEL     @CNUM         E_CNUM                         213569
     C***********        MOVEL     @CCY          E_CCY                          213569
     C***********        MOVEL     @ACCD         E_ACOD                         213569
     C***********        MOVEL     @ACSQ         E_ACSQ                         213569
     C***********        Z-add     @ACNO         E_ACNO                         213569
     C***********        ENDIF                                                  213569
      **Posting*Date                                                            215901
     C**********         Z-ADD     BJRDNB        E_PSTD                         215901
      **Value*Date                                                              215901
     C**********         Z-ADD     @VALD         E_VALD                         215901
      **Transaction Type                                                        215901
     C**********         If        E_ACNO <> 0                                  215901
     C**********         MOVEL     ZDTYPS        E_TRAT                         215901
     C**********         Endif                                                  215901
      **Posting*Narrative                                                       215901
     C**********         Eval      E_PNAR = 'Trf Charges T/S/ZB'                215901
      **Posting*Amount                                                          215901
     C**********         Z-ADD     @RCHGA        E_PSTA                         215901
      **DR/CR*indicator                                                         215901
     C**********         Z-ADD     0             E_DRCR                         215901
      **Source*of Posting                                                       215901
     C**********         MOVE      'GE-CX'       E_SPOS                         215901
      **Branch**                                                                215901
     C*****ZDCAC3        IFNE      *BLANK                                       213569
     C**********         MOVEL     @ChgBrca      E_BRCA                         215901
     C***********        ELSE                                                   213569
     C***********        MOVEL     @BRCA         E_BRCA                         213569
     C***********        ENDIF                                                  213569
      **********                                                                215901
      **Retail*indicator                                                        215901
      **A/c*type                                                                215901
     C*****ZDCAC3        IFNE      *BLANK                                       215901
     C**********         MOVEL     @ChgATYP      E_ATYP                         215901
     C***********        ELSE                                                   215901
     C***********        MOVEL     @ATYP         E_ATYP                         215901
     C***********        ENDIF                                                  215901
     C**** E_ATYP        IFEQ      'R'                                          215901
     C**********         Z-ADD     1             E_RIND                         215901
     C**********         ENDIF                                                  215901
      * Posting indicators                                                      215901
     C**********         BITOFF    '01234567'    E_PRIN                         215901
      **Profit*centre                                                           215901
      **Account*section                                                         215901
     C*****ZDCAC3        IFNE      *BLANK                                       213569
     C**********         MOVEL     @ChgPRFC      E_PRFC                         215901
     C**********         MOVEL     @ChgACSC      E_ACSC                         215901
     C***********        ELSE                                                   213569
     C***********        MOVEL     @PRFC         E_PRFC                         213569
     C***********        MOVEL     @ACSC         E_ACSC                         213569
     C***********        ENDIF                                                  213569
      **Original transaction sub-type                                           215901
     C**********         MOVEL     CLLINK        E_OTST                         215901
      **Original transaction type                                               215901
     C**********         MOVEL     CLHIER        E_OTTP                         215901
      **Ext.Fil*Ref.ID                                                          215901
     C**********         MOVEL     AZXRFI        E_XRFI                         215901
      **Ext.Fil*Ref.No.                                                         215901
     C**********         Z-ADD     AZXRFN        E_XRFN                         215901
      **Transaction Sub-type                                                    215901
     C**********         MOVEL     CLLEVL        E_TRST                         215901
      **********                                                                215901
     C**********         WRITE     APOSTPDF                                     215901
      **********                                                                215901
      **Write*shadow post entries                                               215901
     C**********         EXSR      Shp_Entry                                    215901
      **********                                                                215901
     C**********         Endsr                                                  215901
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
     C                   Z-Add     IISNUM        AZSNUM
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
      * Wrt_CChgEntry - Write credit charge posting entry to  GLPSTTPD
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
     C                   Z-ADD     14            DBASE                            * * * * * * *
     C                   Eval      DBKEY = 'Error in Shadow Post Entry'           * DBERR 014 *
     C                   MOVEL     'RE100605'    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif
 
     C                   Endsr
     C********************************************************************
      * Upd_ICS - Update REICSDPD record
      ********************************************************************
     C     Upd_ICS       Begsr
 
      *  Shadow Posted
     C                   Movel     'Y'           IDSPTD
      *  Matched?
     C                   Movel     'Y'           IDMTYN
      *  Incoming Message Reference
     C                   Movel     WSMIR         IDSMIR
     C                   Movel     WSMSR         IDSMSR
 
     C                   Update    REICSDD0
 
     C                   Endsr
      ********************************************************************      215901
      * Write Item records                                                      215901
      ********************************************************************      215901
     C     Wrt_ICSI      BEGSR                                                  215901
                                                                                215901
      * Hierarchy ID                                                            215901
     C                   MOVEL     IDHIER        O_IIHIER                       215901
      * Link ID                                                                 215901
     C                   MOVEL     IDLINK        O_IILINK                       215901
      * Processing Date                                                         215901
     C                   Z-ADD     IDPRCD        O_IIPRCD                       215901
      * Sequence Number                                                         215901
     C                   MOVEL     IDSNUM        O_IISNUM                       215901
      * Extension File Ref. No.                                                 215901
     C                   MOVEL     O_XRFN        O_IIXRFN                       215901
                                                                                215901
     C                   WRITE     REICSIDX                                     215901
                                                                                215901
     C                   ENDSR                                                  215901
      ********************************************************************
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
