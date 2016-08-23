     H DEBUG FTRANS
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas MT950 Messages linked to Deal Type Sub-Type')    *
      *****************************************************************
      *                                                               *
      *  Midas - Automatic Reconciliations II module                  *
      *                                                               *
      *  RC2012 - MT950 Messages linked to Deal Type Sub-Type         *
      *                                                               *
      *                                                               *
      *  Close of Business                                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 BUG7752            Date 27Jun05               *
      *                 BUG7594            Date 17Jun05               *
      *                 BUG6174            Date 18May05               *
      *                 BUG6199            Date 25Apr05               *
      *                 BUG6739            Date 25Apr05               *
      *                 BUG6547            Date 08Apr05               *
      *                 CDL030  CHG001     Date 23Mar05               *
      *                 BUG6174            Date 11Mar05               *
      *                 CDL030             Date 15Feb05               *
      *                 CDL030  *CREATE    Date 08Dec04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG7752- Opening statement always Debit                      *
      *  BUG7594- MT950 statement missing                             *
      *  BUG6174- Increase Account Code to 10 (revisited)             *
      *  BUG6199- Sequence No error on FLD20.                         *
      *  BUG6739 - RCC2010 fails with RC2012 program dump             *
      *  BUG6547- Field 61 not being generated                        *
      *  CDL030 - CHG001 Remove the frequency of 'D' condition.       *
      *  BUG6174- Increase Account Code to 10                         *
      *  CDL030 - Additional fix for CDL030                           *
      *         - previously coded as BUG5931 (NWRK s/b 'PAPER')      *
      *  CDL030 - MT950 Messages Linked to Deal Type / Sub type       *
      *                                                               *
      *****************************************************************
      *                                                               *
      ** Midas RC II - Accs master file
     FRCACMSL1  IF   E           K DISK
 
     ** Midas GL Account Balances Today
     FGLACBTL0  IF   E           K DISK
 
      ** Midas RC Complete postings
     FRCPOSTL0  IF   E           K DISK
 
     ** Midas MG Master Messages Reference File
     FMGOREFPD  O    E             DISK
 
      ** Midas MG Master Message Data file
     FMGOMSGPD  O    E             DISK
 
     FRC2010AU  O    E             PRINTER USROPN
      /EJECT
      *****************************************************************
      *                                                               *
      *   Indicator Usage                                             *
      *                                                               *
      *   U7 & U8   Database error                                    *
      *   nn        X                                                 *
      *                                                               *
      *****************************************************************
      /EJECT
 
      **------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------------------------------
 
      **------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------------------------------
      /EJECT
 
      ** Arrays used to compress data in field :61:
     D @FM             S              1    DIM(256)
     D @TO             S              1    DIM(256)
     D @WRK            S              1    DIM(50)
 
      ** Data Area giving Installation Control Details
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
 
      **  Data structure for bank details table
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      **  Data structure for Branch details table
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      **  Data structure for Customer details table
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D  QXDFAC       E                     EXTFLD(QQDFAC)
 
      **  Data structure for MESSAGE MANAGEMENT file
     D SDMGME        E DS                  EXTNAME(SDMGMEPD)
 
      ** Data structure for Switchable Features file                                         BUG6739
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                 BUG6739
                                                                                             BUG6739
      ** Data structure for Currency Details file                                            BUG6739
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                 BUG6739
                                                                                             BUG6739
     D**  1st DS for Access Programs, Short DS
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D**  2nd DS for Access Programs, Long DS
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** TRN data structure
     D @TRN            DS
     D  @PFX                   1      2
     D  @DAT                   3      8  0
     D******                                  9  140@TIM
     D  @SEQ                   9     12  0
 
      ** Full account i/d
     D                 DS
     D  @SACN                  1     21
     D**@ACID***************** 1     18                                                      BUG6174
     D  @ACID                  1     24                                                      BUG6174
     D**CNUM****               1      6  0                                                    CSD027
     D  CNUM                   1      6A                                                      CSD027
     D  CCY                    7      9
     D**@ACOD**************** 10     13  0                                                   BUG6174
     D**ACSQ***************** 14     15  0                                                   BUG6174
     D**BRCA***************** 16     18                                                      BUG6174
     D  ACOD                  10     19  0                                                   BUG6174
     D  ACSQ                  20     21  0                                                   BUG6174
     D  BRCA                  22     24                                                      BUG6174
 
      ** Source of posting
     D                 DS
     D  SPOS                   1      7
     D  @SPID                  6      7
 
      ** Field :28:
     D                 DS
     D  @28                    1     11
     D  @28S1                  1      5
     D  @28SL                  6      6    INZ('/')
     D  @28S2                  7     11
 
      ** Field :60F:
     D                 DS
     D***@60F***                1     25                                                     BUG6739
     D  @60F                   1     27                                                      BUG6739
     D  @60FS1                 1      1
     D  @60FS2                 2      7
     D  @60FS3                 8     10
     D***@60FS4*               11     25                                                     BUG6739
     D  @60FS4                11     27                                                      BUG6739
 
      ** Field :60M:
     D                 DS
     D***@60M***                1     25                                                     BUG6739
     D  @60M                   1     27                                                      BUG6739
     D  @60MS1                 1      1
     D  @60MS2                 2      7
     D  @60MS3                 8     10
     D***@60MS4*               11     25                                                     BUG6739
     D  @60MS4                11     27                                                      BUG6739
 
      ** Field :61: subfields 1 to 8
     D                 DS
     D***@61****                1     71                                                     BUG6739
     D  @61                    1     74                                                      BUG6739
     D  @61S1                  1      6
     D  @61S2                  7     10
     D  @61S3                 11     12
     D  @61S4                 13     13
     D***@61S5**               14     28                                                     BUG6739
     D***@61S6**               29     32                                                     BUG6739
     D***@61S6A*               29     29                                                     BUG6739
     D***@61S6B*               30     32                                                     BUG6739
     D***@61S6C*               29     30                                                     BUG6739
     D***@61S6D*               31     32                                                     BUG6739
     D***@61S7**               33     48                                                     BUG6739
     D***@61S8**               49     66                                                     BUG6739
     D***@61S8A*               49     50                                                     BUG6739
     D***@61S8B*               51     52                                                     BUG6739
     D***@61S8C*               53     72                                                     BUG6739
     D***@61S8F*               51     66                                                     BUG6739
     D  @61S5                 14     30                                                      BUG6739
     D  @61S6                 31     34                                                      BUG6739
     D  @61S6A                31     31                                                      BUG6739
     D  @61S6B                32     34                                                      BUG6739
     D  @61S6C                31     32                                                      BUG6739
     D  @61S6D                33     34                                                      BUG6739
     D  @61S7                 35     50                                                      BUG6739
     D  @61S8                 51     68                                                      BUG6739
     D  @61S8A                51     52                                                      BUG6739
     D  @61S8B                53     54                                                      BUG6739
     D  @61S8C                55     74                                                      BUG6739
     D  @61S8F                53     68                                                      BUG6739
 
      ** Field :62F:
     D                 DS
     D***@62F***                1     25                                                     BUG6739
     D  @62F                   1     27                                                      BUG6739
     D  @62FS1                 1      1
     D  @62FS2                 2      7
     D  @62FS3                 8     10
     D***@62FS4*               11     25                                                     BUG6739
     D  @62FS4                11     27                                                      BUG6739
 
      ** Field :62M:
     D                 DS
     D***@62M***                1     25                                                     BUG6739
     D  @62M                   1     27                                                      BUG6739
     D  @62MS1                 1      1
     D  @62MS2                 2      7
     D  @62MS3                 8     10
     D***@62MS4*               11     25                                                     BUG6739
     D  @62MS4                11     27                                                      BUG6739
 
      ** Field :64:
     D                 DS
     D***@64****                1     25                                                     BUG6739
     D  @64                    1     27                                                      BUG6739
     D  @64S1                  1      1
     D  @64S2                  2      7
     D  @64S3                  8     10
     D***@64S4**               11     25                                                     BUG6739
     D  @64S4                 11     27                                                      BUG6739
 
      ** GL posting reference for field :61: subfield 8
     D                 DS
     D  @GLREF                 1     13
     D  @BRCA                  1      3
     D  @DPMT                  4      6
     D  @SPOS                  7     13
 
      * Sender's Address
     D @NWDS           C                   CONST('SENDCARS')
 
     D @RUN            S              1
 
     D PRtCd           S              7A
     D POptn           S             10A
     D PDSNB           S              3A
     D***W#Balance       S             13S 0                                                 BUG6739
     D W#Balance       S             15S 0                                                   BUG6739
     D @WKAMT          S             15  0                                                   BUG6739
     D ZAMNT           S             15  0                                                   BUG6739
     D ZCDP            S              1  0                                                   BUG6739
     D ZSCCY           S              3                                                      BUG6739
     D ZSAMNT          S             17                                                      BUG6739
     D ZOAMNT          S             21                                                      BUG6739
     D CSW020          S              3                                                      BUG6739
     D X               S              1  0                                                   BUG6739
     D Y               S              4  0                                                   BUG6739
     D PSARD           S              6                                                      BUG6739
     D/COPY WNCPYSRC,RCH00004
     D W#StSeq         S              5S 0
     D W#MsgCnt        S              3S 0
     D WRK50           S             50A
     D YY              S              2S 0
     D S               S              5S 0
     D T               S              5S 0
     D W               S              3S 0
     D OKX             S               N
 
     D/COPY WNCPYSRC,RCH00005
      ** Rename opening account balances
     IGLACBLF
     I              LDBL                        LDBLO
     I              CLBL                        CLBLO
 
      /EJECT
      *****************************************************************
      *                                                               *
      *   Index to subroutines                                        *
      *   --------------------                                        *
      *                                                               *
      *   INIT      Initial process                                   *
      *   CREATE    Create ISO MT950                                  *
      *   REFR      Create reference record                           *
      *   FLD20     Create field :20: (Transaction Reference Number)  *
      *   FLD25     Create field :25: (Account i/d)                   *
      *   FLD28     Create field :28C: (Statement number/sequence)    *
      *   FLD60F    Create field :60F: (Opening Balance)              *
      *   FLD60M    Create field :60M: (Opening Intermediate Balance) *
      *   FLD61     Create all field :61:s (Postings)                 *
      *   SF7       Format field :61:, subfield 7                     *
      *   SF8       Format field :61:, subfield 8                     *
      *   FLD62F    Create field :62F: (Closing Balance)              *
      *   FLD62M    Create field :62M: (Closing Intermediate Balance) *
      *   FLD64     Create field :64: (Closing Available Balance)     *
      *   *PSSR     Process errors                                    *
      *                                                               *
      *****************************************************************
      *
      /EJECT
 
      ** Execute initial process
     C                   Exsr      INIT
 
      ** Access reconciliation account record
     C                   Read      RCACMSL1
 
      ** DoWhile not end-of-file
     C                   DoW       Not %Eof
     C**********         If        STFQ = 'D'                                                 CDL030
 
      ** If opening balance exists (i.e. not newly opened nostro)
      ** create ledger details, else read next record
     C     KEY1          Chain     GLACBTL0
     C                   If        %Found
 
      ** Create 950 message for account
     C                   Exsr      CREATE
 
     C                   EndIf
     C**********         EndIf                                                                CDL030
 
      ** Access next account
     C                   Read      RCACMSL1
     C                   EndDo
 
      ** Terminate RPG program
     C                   Eval      *InLR = *On
     C                   Return
      /EJECT
      *****************************************************************
      * Subroutine  :  CREATE                                         *
      * Function    :  Create ISO MT950 message for account           *
      *                                                               *
      * Called by   :  Main process                                   *
      * Calls       :  REFR       Create reference record             *
      *                FLD20      Create field :20:                   *
      *                FLD25      Create field :25:                   *
      *                FLD28      Create field :28C:                  *
      *                FLD60F     Create field :60F:                  *
      *                FLD61      Create all field :61:s              *
      *                FLD62F     Create field :62F:                  *
      *                FLD64      Create field :64:                   *
      *****************************************************************
      *
     C     CREATE        BEGSR
 
      ** Access first posting for this account
     C*****KEY1*         ReadE     APOSTPDF                                                  BUG6547
     C     KEY1          Chain     APOSTPDF                                                  BUG6547
 
      ** If postings exist, create MT950
     C                   If        %Found
 
      ** Reset Message and Statement count
     C                   Eval      W#StSeq = 1
     C                   Eval      W#MsgCnt = 0
 
      ** Create reference record
     C                   Exsr      REFR
 
      ** Create field :20: (Transaction Reference Number)
     C                   Exsr      FLD20
 
      ** Create field :25: (Account i/d)
     C                   Exsr      FLD25
 
      ** Create field :28C: (Statement number/sequence)
     C                   Exsr      FLD28
 
      ** Create field :60F: (Opening Balance)
     C                   Exsr      FLD60F
 
      ** Create all field :61:s (Postings)
     C                   Exsr      FLD61
 
      ** Create field :62F: (Closing Balance)
     C                   Exsr      FLD62F
 
      ** If Retail account and cleared balance is not zero, create
      ** field :64: (Closing Available Balance)
     C                   If        ATYP = 'R' and CLBL <> 0
     C                   Exsr      FLD64
     C                   EndIf
 
     C                   EndIf
 
     C                   ENDSR                                                  CREATE
      /EJECT
      *****************************************************************
      * Subroutine  :  INTERM                                         *
      * Function    :  Create ISO MT950 Intermediate Messages         *
      *                                                               *
      * Called by   :  Main process                                   *
      * Calls       :  FLD20      Create field :20:                   *
      *                FLD25      Create field :25:                   *
      *                FLD28      Create field :28C:                  *
      *                FLD60M     Create field :60M:                  *
      *                FLD62M     Create field :62M:                  *
      *****************************************************************
      *
     C     INTERM        BEGSR
 
      ** Create field :62F: (Intermediate Closing Balance)
     C                   Exsr      FLD62M
 
      ** Create reference record                                                             BUG7594
     C                   Exsr      REFR                                                      BUG7594
                                                                                             BUG7594
      ** Output field :20: (Transaction Reference Number)
     C***********        Eval      @SEQ = @SEQ + 1                                   BUG6199 BUG7594
     C                   Exsr      FLD20
 
      ** Create field :25: (Account i/d)
     C                   Exsr      FLD25
 
      ** Create field :28C: (Statement number/sequence)
     C                   Eval      W#StSeq = W#StSeq + 1
     C                   Exsr      FLD28
 
      ** Create field :60M: (Intermediate Opening balance)
     C                   Exsr      FLD60M
 
     C                   ENDSR                                                  CREATE
      /EJECT
      *****************************************************************
      * Subroutine  :  REFR                                           *
      * Function    :  Create reference record                        *
      *                                                               *
      * Called by   :  CREATE                                         *
      * Calls       :  -                                              *
      *****************************************************************
      *
     C     REFR          BEGSR
 
      ** Create Transaction Reference Number for this MT950.
     C                   Eval      @SEQ = @SEQ + 1
     C                   Eval      TRNO = @TRN
 
      ** Access Branch Code file to find Sender's Cust. No.
     C                   Call      'AOBRCHR1'
     C                   Parm      '*MSG   '     PRtCd
     C                   Parm      '*KEY   '     POptn
     C                   Parm      BRCA          PDSNB
     C     SDBRCH        Parm      SDBRCH        DSSDY
 
     C                   If        PRtcd <> *BLANK
     C     *Lock         In        LDA
     C                   Eval      DBFILE= 'SDBRCHPD'
     C                   Eval      DBKEY = POptn
     C                   Eval      DBASE = 003
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf
 
     C                   Move      A8BICN        SECN
     C                   Eval      NWSN = A8BTID
     C                   Eval      DECN = CNUM
     C                   Movel     CNUM          @KEY1
 
     C** Access Customer Details
     C                   Call      'AOCUSTR0'
     C                   Parm      '*MSG   '     PRtCd
     C                   Parm      '*KEY   '     @Optn
     C                   Parm                    @KEY1            10
     C                   Parm                    @KYST             7
     C     SDCUST        Parm      SDCUST        DSSDY
 
     C                   If        PRtcd <> *BLANK
     C     *Lock         In        LDA
     C                   Eval      DBFILE= 'SDCUSTPD'
     C                   Eval      DBKEY = POptn
     C                   Eval      DBASE = 004
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf
 
     C                   Eval      NWDS = @NWDS
 
     C                   If        ATYP = 'R'
     C                   Eval      AORR = 'R'
     C                   Eval      SACN = *Blanks
     C                   If        ACNO <> 0
     C                   Movel     ACNO          SACN
     C                   Else
     C                   Move      @SACN         SACN
     C                   EndIf
 
     C                   Else
     C                   Eval      AORR = 'A'
     C                   Move      @SACN         SACN
     C                   EndIf
 
     C                   Eval      DESI = 'N'
 
     C                   Write     MGOREFD0
 
     C                   ENDSR                                                  REFR
      /EJECT
      *****************************************************************
      * Subroutine  :  FLD20                                          *
      * Function    :  Create field :20: (Transaction Reference       *
      *                Number)                                        *
      *                                                               *
      * Called by   :  CREATE                                         *
      * Calls       :  -                                              *
      *****************************************************************
      *
     C     FLD20         BEGSR
 
      ** Set up reference for key
     C                   Eval      MTAG = ':20: '
 
     C                   Clear                   MFLD
      ** Set up field tag and data
     C                   Movel     @TRN          MFLD
     C                   Movel     CR            CTRC
     C                   Move      LF            CTRC
     C                   Movel     @TRN          TRNO
 
      ** Write record to file
     C                   Write     MGOMSGD0
 
     C                   ENDSR                                                  FLD20
      /EJECT
      *****************************************************************
      * Subroutine  :  FLD25                                          *
      * Function    :  Create field :25: (Account i/d)                *
      *                                                               *
      * Called by   :  CREATE                                         *
      * Calls       :  -                                              *
      *****************************************************************
      *
     C     FLD25         BEGSR
 
      ** Set up reference for key
     C                   Eval      MTAG = ':25: '
 
      ** Set up field tag and data
     C                   Clear                   MFLD
     C**********         If        ATYP = 'R' and ACNO = 0                                   BUG6174
     C**********         Move      ACOD          @ACOD                                       BUG6174
     C                   If        ATYP = 'R'                                                BUG6174
     C                   If        ACNO = 0                                                  BUG6174
     C                   Movel     @ACID         MFLD
     C                   Else
     C                   Movel     ACNO          MFLD
     C                   EndIf
     C                   Else                                                                BUG6174
     C                   Movel     @ACID         MFLD                                        BUG6174
     C                   EndIf                                                               BUG6174
 
     C                   Movel     CR            CTRC
     C                   Move      LF            CTRC
     C                   Movel     @TRN          TRNO
 
      ** Write record to file
     C                   Write     MGOMSGD0
 
     C                   ENDSR                                                  FLD25
      /EJECT
      *****************************************************************
      * Subroutine  :  FLD28                                          *
      * Function    :  Create field :28: (Statement number/Sequence)  *
      *                                                               *
      * Called by   :  CREATE                                         *
      * Calls       :  -                                              *
      *****************************************************************
      *
     C     FLD28         BEGSR
 
      ** Set up reference for key
     C                   Eval      MTAG = ':28C:'
 
      ** Set up field tag and data
     C                   Clear                   MFLD
     C                   Movel     '00001'       @28S1
     C                   Movel     W#StSeq       @28S2
     C                   Movel     @28           MFLD
 
     C                   Movel     CR            CTRC
     C                   Move      LF            CTRC
     C                   Movel     @TRN          TRNO
 
      ** Write record to file
     C                   Write     MGOMSGD0
 
     C                   ENDSR                                                  FLD28
      /EJECT
      *****************************************************************
      * Subroutine  :  FLD60F                                         *
      * Function    :  Create field :60F: (Opening balance)           *
      *                                                               *
      * Called by   :  CREATE                                         *
      * Calls       :  ZM0060     Return date in ISO format           *
      *                ZM0040     Return ccy/amount in ISO format     *
      *****************************************************************
      *
     C     FLD60F        BEGSR
 
      ** Set up reference for key
     C                   Eval      MTAG = ':60F:'
 
      ** Set up field tag and data
     C                   Clear                   MFLD
 
      ** Set up subfield 1 (Debit/Credit indicator) nb. zero = credit
     C*********          If        LDBLO = 0                                                 BUG7752
     C                   If        LDBLO <= 0                                                BUG7752
     C                   Eval      @60FS1 = 'C'
     C**********         Z-Sub     LDBLO         @WKAMT           13 0                       BUG6739
     C                   Z-Sub     LDBLO         @WKAMT                                      BUG6739
     C                   Else
     C                   Eval      @60FS1 = 'D'
     C                   Z-Add     LDBLO         @WKAMT
     C                   EndIf
 
      ** Set Balance
     C*********          Eval      W#Balance = @WKAMT                                        BUG7752
     C                   Eval      W#Balance = LDBLO                                         BUG7752
 
      ** Set up subfield 2 (date) and store for later use
     C                   Call      'ZM0060'
     C                   Parm      BJRDNB        ZMDAY             5 0
     C     @60FS2        Parm                    ZMDATE            6
     C                   Move      ZMDATE        @RUND             6
 
      ** Set up subfields 3 and 4 (Currency and Amount) nb. use
      ** currency code returned by ZM0040 in s/f 3 because this should
      ** be ISO standard value
                                                                                             BUG6739
     C                   EVAL      ZAMNT = @WKAMT                                            BUG6739
     C                   EXSR      SRCurrency                                                BUG6739
     C                   EVAL      @60FS3 = ZSCCY                                            BUG6739
                                                                                             BUG6739
     C**********         Call      'ZM0040'                                                  BUG6739
     C**********         Parm      @WKAMT        ZAMNT            13 0                       BUG6739
     C**********         Parm      CCY           ZCCY              3                         BUG6739
     C*****@60FS4        Parm                    ZSAMNT           15                         BUG6739
     C*****@60FS3        Parm                    ZSCCY             3                         BUG6739
     C**********         Parm      *BLANKS       ZERR              1                         BUG6739
     C**********         Parm                    ZSWDPC            1                         BUG6739
     C                   CALL      'ZM1140'                             85                   BUG6739
     C                   PARM                    ZAMNT                                       BUG6739
     C                   PARM                    ZCDP                                        BUG6739
     C     @60FS4        PARM                    ZSAMNT                                      BUG6739
     C                   PARM                    ZOAMNT                                      BUG6739
 
      ** If program fails, report database error
     C**********         If        ZERR <> *BLANK                                            BUG6739
     C                   If        *IN85 = *ON                                               BUG6739
     C     *Lock         In        LDA
     C**********         Eval      DBFILE= 'ZM0040'                                          BUG6739
     C                   Eval      DBFILE = 'ZM1140'                                         BUG6739
     C                   Eval      DBKEY = 'PROGRAM'
     C                   Eval      DBASE = 005
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf
 
      ** move data to output record
     C                   Movel     @60F          MFLD
     C                   Movel     CR            CTRC
     C                   Move      LF            CTRC
     C                   Movel     @TRN          TRNO
 
      ** Write record to file
     C                   Write     MGOMSGD0
 
     C                   ENDSR                                                  FLD60F
      /EJECT
      *****************************************************************
      * Subroutine  :  FLD60M                                         *
      * Function    :  Create field :60M: (Intermediate Balance)      *
      *                                                               *
      * Called by   :  CREATE                                         *
      * Calls       :  ZM0060     Return date in ISO format           *
      *                ZM0040     Return ccy/amount in ISO format     *
      *****************************************************************
      *
     C     FLD60M        BEGSR
 
      ** Set up reference for key
     C                   Eval      MTAG = ':60M:'
 
      ** Set up field tag and data
     C                   Clear                   MFLD
 
      ** Set up subfield 1 (Debit/Credit indicator) nb. zero = credit
     C                   If        W#Balance <= 0
     C                   Move      'C'           @60MS1
     C                   Z-Sub     W#Balance     @WKAMT
     C                   Else
     C                   Move      'D'           @60MS1
     C                   Z-Add     W#Balance     @WKAMT
     C                   EndIf
 
      ** Set up subfield 2 (date) and store for later use
     C                   Call      'ZM0060'
     C                   Parm      BJRDNB        ZMDAY             5 0
     C     @60MS2        Parm                    ZMDATE            6
     C                   Move      ZMDATE        @RUND             6
 
      ** Set up subfields 3 and 4 (Currency and Amount) nb. use
      ** currency code returned by ZM0040 in s/f 3 because this should
      ** be ISO standard value
                                                                                             BUG6739
     C                   EVAL      ZAMNT = @WKAMT                                            BUG6739
     C                   EXSR      SRCurrency                                                BUG6739
     C                   EVAL      @60MS3 = ZSCCY                                            BUG6739
                                                                                             BUG6739
     C**********         Call      'ZM0040'                                                  BUG6739
     C**********         Parm      @WKAMT        ZAMNT            13 0                       BUG6739
     C**********         Parm      CCY           ZCCY              3                         BUG6739
     C*****@60MS4        Parm                    ZSAMNT           15                         BUG6739
     C*****@60MS3        Parm                    ZSCCY             3                         BUG6739
     C**********         Parm      *BLANKS       ZERR              1                         BUG6739
     C**********         Parm                    ZSWDPC            1                         BUG6739
     C                   CALL      'ZM1140'                             85                   BUG6739
     C                   PARM                    ZAMNT                                       BUG6739
     C                   PARM                    ZCDP                                        BUG6739
     C     @60MS4        PARM                    ZSAMNT                                      BUG6739
     C                   PARM                    ZOAMNT                                      BUG6739
 
      ** If program fails, report database error
     C**********         If        ZERR <> *BLANK                                            BUG6739
     C                   If        *IN85 = *ON                                               BUG6739
     C     *Lock         In        LDA
     C**********         Eval      DBFILE= 'ZM0040'                                          BUG6739
     C                   Eval      DBFILE = 'ZM1140'                                         BUG6739
     C                   Eval      DBKEY = 'PROGRAM'
     C                   Eval      DBASE = 005
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf
 
      ** move data to output record
     C                   Movel     @60M          MFLD
     C                   Movel     CR            CTRC
     C                   Move      LF            CTRC
     C                   Movel     @TRN          TRNO
 
      ** Write record to file
     C                   Write     MGOMSGD0
 
     C                   ENDSR                                                  FLD60F
      /EJECT
      *****************************************************************
      * Subroutine  :  FLD61                                          *
      * Function    :  Create all field :61:s (postings)              *
      *                                                               *
      * Called by   :  CREATE                                         *
      * Calls       :  ZM0060     Return date in ISO format           *
      *                ZM0040     Return ccy/amount in ISO format     *
      *                SF7        Create subfield 7                   *
      *                SF8        Create subfield 8                   *
      *****************************************************************
      *
     C     FLD61         BEGSR
 
      ** Format all field :61:s
     C                   DoW       Not %Eof(RCPOSTL0)
 
      ** Increment Message Count
     C                   Eval      W#MsgCnt = W#MsgCnt +1
 
      ** Write out Intermediate Details
     C                   If        W#MsgCnt = 17
     C                   Exsr      INTERM
     C                   Eval      W#MsgCnt = 1
     C                   EndIf
 
     C                   Clear                   MFLD
     C                   Clear                   @61
 
      ** Set up field tag and data
     C                   Eval      MTAG = ':61: '
 
      ** Set up subfield 1 (date)
     C                   Call      'ZM0060'
     C                   Parm      VALD          ZMDAY
     C     @61S1         Parm                    ZMDATE
 
      ** Set up subfield 2 (entry date, MMDD)
     C                   If        PSTD <> 0
     C                   Call      'ZM0060'
     C                   Parm      PSTD          ZMDAY             5 0
     C                   Parm                    ZMDATE            6
     C                   Move      ZMDATE        @61S2
     C                   EndIf
 
      ** Set up subfield 3 (debit/credit indicator)
     C                   If        DRCR = 0
     C                   Eval      @61S3 = 'D'
     C                   Eval      W#Balance = W#Balance + PSTA
     C                   Else
     C                   Eval      @61S3 = 'C'
     C                   Eval      W#Balance = W#Balance - PSTA
     C                   EndIf
 
      ** Set up subfields 4 and 5 (funds code; last char of ISO ccy
      ** code and posting amount)
     C                   Eval      @WKAMT = PSTA
     C                   EVAL      ZAMNT = @WKAMT                                            BUG6739
     C                   EXSR      SRCurrency                                                BUG6739
                                                                                             BUG6739
     C**********         Call      'ZM0040'                                                  BUG6739
     C**********         Parm      @WKAMT        ZAMNT                                       BUG6739
     C**********         Parm      CCY           ZCCY                                        BUG6739
     C*****@61S5         Parm                    ZSAMNT                                      BUG6739
     C**********         Parm                    ZSCCY                                       BUG6739
     C**********         Parm      *BLANKS       ZERR                                        BUG6739
     C**********         Parm                    ZSWDPC                                      BUG6739
     C                   CALL      'ZM1140'                             85                   BUG6739
     C                   PARM                    ZAMNT                                       BUG6739
     C                   PARM                    ZCDP                                        BUG6739
     C     @61S5         PARM                    ZSAMNT                                      BUG6739
     C                   PARM                    ZOAMNT                                      BUG6739
 
      ** If program fails, report database error
     C**********         If        ZERR <> *BLANK                                            BUG6739
     C                   If        *IN85 = *ON                                               BUG6739
     C     *Lock         In        LDA
     C**********         Eval      DBFILE= 'ZM0040'                                          BUG6739
     C                   Eval      DBFILE = 'ZM1140'                                         BUG6739
     C                   Eval      DBKEY = 'PROGRAM'
     C                   Eval      DBASE = 006
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf
 
     C                   Move      ZSCCY         @61S4
 
      ** Format subfield 6
     C                   Movel     DLREF         DLIND             1
     C                   If        DLIND = 'D'
     C                   Movel     OTTP          @61S6C
     C                   Movel     OTST          @61S6D
     C                   Else
     C                   Exsr      SF6
     C                   EndIF
 
      ** Format subfield 7
     C                   Exsr      SF7
 
      ** Format subfield 8
     C                   Exsr      SF8
 
      ** When all subfields for this line formatted, compress and
      ** output to file.
     C                   Eval      T= 0
     C                   Clear                   @FM
     C                   MoveA     @61           @FM
     C     1             Do        71            S
     C                   If        @FM(S) <> ' '
     C                   Eval      T = T + 1
     C                   Eval      @TO(T) = @FM(S)
     C                   EndIf
     C                   EndDo
 
      **  Copy field to work on (if subfield 8 crosses over 50 chars.)
      **  Initialise W to start of new line (over the 50 chars. mark)
     C                   MoveA     @TO           @WRK
     C                   Eval      W = 51
 
      **  Initialise CR/LF field
     C                   Movel     CR            CTRC
     C                   Move      LF            CTRC
     C                   Movel     @TRN          TRNO
 
      **  If message is longer than 50 characters,CRLF not needed;
      ** Also if subfield 8 should cross over the 50 character mark,
      ** write the whole of subfield 8 to the message file on a new
      ** line (previously it was being split between the two lines).
     C                   If        @TO(51) <> *Blanks
     C                   Eval      CTRC = *Blanks
     C                   MoveA     @TO           WRK50
     C     '//'          Scan      WRK50         W                        80
     C                   If        *IN80 = *On and W <= 50
     C                   MoveA     *Blanks       @WRK(W)
     C                   EndIf
     C                   EndIF
 
      **  Move first 50 characters of array into MFLD
     C                   Eval      MTAG = ':61: '
     C                   MoveA     @WRK(1)       MFLD
 
     C                   Write     MGOMSGD0
 
      **  If message greater than 50 characters long,output
      **  rest of array to next line
      ** Or output to a new line subfield 8  (positional value W)
     C                   If        @TO(51) <> *Blanks
      ** The first character should not be ' ' or ':' or '-'
     C                   Eval      OKX = *Off
     C                   DoU       OKX = *On
     C                   If        @TO(W) = ':' or @TO(W) = '-' or
     C                             @TO(W) = ' '
     C                   Eval      W = W + 1
     C                   Else
     C                   Eval      OKX = *On
     C                   EndIF
     C                   EndDo
 
     C                   Eval      MTAG = *Blanks
     C                   MoveA     @TO(W)        MFLD
     C                   Movel     CR            CTRC
     C                   Move      LF            CTRC
     C                   Movel     @TRN          TRNO
 
      ** Write record to file
     C                   Write     MGOMSGD0
     C                   EndIf
 
      ** Format subfield 9 - use posting narrative, but exclude any
      ** ':'s or '-'s. Also, s/f 9 only allows 34 chars, and PNAR is
      ** 44 long, so only use first 34 valid characters.
     C                   Clear                   @FM
     C                   Clear                   @TO
     C                   MoveA     PNAR          @FM
 
     C                   Eval      T = 1
     C                   Eval      S = 1
 
     C                   DoW       T < 35 and S < 45
     C                   If        @FM(S) <> '-' and @FM(S) <> ':'
     C                   Eval      @TO(T) = @FM(S)
     C                   Eval      T = T + 1
     C                   EndIf
     C                   Eval      S = S + 1
     C                   EndDo
 
      ** If data in subfield 9, write to file
     C                   If        T > 1
     C                   Eval      MTAG = *Blanks
     C                   MoveA     @TO           MFLD
     C                   Movel     CR            CTRC
     C                   Move      LF            CTRC
     C                   Movel     @TRN          TRNO
     C                   Write     MGOMSGD0
     C                   EndIf
 
      ** Read next posting for this account
     C     KEY1          ReadE     APOSTPDF
 
     C                   EndDo
 
     C                   ENDSR                                                  FLD61
      /EJECT
      *****************************************************************
      * Subroutine  :  SF6                                            *
      * Function    :  Create subfield 6 for field :61:               *
      *                                                               *
      * Called by   :  FLD61                                          *
      * Calls       :  -                                              *
      *****************************************************************
      *
     C     SF6           BEGSR
 
      ** First character of subfield 6 should always be 'F'
     C                   Eval      @61S6A = 'F'
 
      ** Remaining characters depend on source of posting. If possible
      ** use correct codeword:
      **   o  If Funds Transfer (PREF *ne blank), if type CP use code
      **      for cash/cheque remittance (CLR), else collection (COL)
     C                   If        PREF <> *Blanks
     C                   Movel     PREF          @WK9A             9
     C                   Move      @WK9A         @WK2A             2
     C                   If        @WK2A = 'CP'
     C                   Move      'CLR'         @61S6B
     C                   Else
     C                   Move      'COL'         @61S6B
     C                   EndIf
     C                   EndIf
 
      **   o  If Foreign exchange transaction use code 'FEX'
     C                   If        @SPID = 'XF' or @SPID = 'XB'
     C                   Move      'FEX'         @61S6B
     C                   EndIf
 
      **   o  If Standing order use code 'STO'
     C                   If        @SPID = 'SO'
     C                   Move      'STO'         @61S6B
     C                   EndIf
 
      **   o  If Interest use code 'INT'
     C                   If        @SPID = 'IC'
     C                   Move      'INT'         @61S6B
     C                   EndIf
 
      **   o  If Cheque use code 'CHK'
     C                   If        CHQN <> 0
     C                   Move      'CHK'         @61S6B
     C                   EndIf
 
      ** If unable to set up code, default to 'MSC' - miscellaneous
     C                   If        @61S6B = *Blanks
     C                   Move      'MSC'         @61S6B
     C                   EndIf
 
     C                   ENDSR                                                  SF6
      /EJECT
      *****************************************************************
      * Subroutine  :  SF7                                            *
      * Function    :  Create subfield 7 for field :61:               *
      *                                                               *
      * Called by   :  FLD61                                          *
      * Calls       :  -                                              *
      *****************************************************************
      *
     C     SF7           BEGSR
 
      ** Use SWIFT common reference if available
     C                   If        SWCR <> *Blanks
     C                   Movel     SWCR          @61S7
     C                   Else
 
      ** else if characters 1-6 of 'source of posting' are numeric
      ** use this...
     C                   Movel     SPOS          @WK6              6
     C                   TESTN                   @WK6                 50
     C/COPY WNCPYSRC,RCH00006
     C                   If        *In50 = *On
     C                   Movel     @WK6          @61S7
 
      ** else if source of posting is CHIPS, use SPOS
     C                   Else
     C                   If        @SPID = 'CM'
     C                   Movel     SPOS          @61S7
 
      ** else - if nothing else - use 16 characters of Posting
      ** Narrative
     C                   Else
     C                   Movel     PNAR          @61S7
     C                   EndIf
 
     C                   EndIf
     C                   EndIf
 
     C                   ENDSR                                                  SF7
      /EJECT
      *****************************************************************
      * Subroutine  :  SF8                                            *
      * Function    :  Create subfield 8 for field :61:               *
      *                                                               *
      * Called by   :  FLD61                                          *
      * Calls       :  -                                              *
      *****************************************************************
      *
     C     SF8           BEGSR
 
      ** Subfield 8 should always begin with '//'
     C                   Move      '//'          @61S8A
 
      ** If GL posting, use branch, department, source of posting
     C                   If        @SPID = 'XF' or @SPID = 'XB'
     C                   Move      'GL'          @61S8B
     C                   Movel     BRCA          @BRCA
     C                   Movel     DPMT          @DPMT
     C                   Movel     SPOS          @SPOS
     C                   Movel     @GLREF        @61S8C
 
      ** else if CHIPS, use 'CH' plus source of posting
     C                   Else
     C                   If        @SPID = 'CM'
     C                   Move      'CH'          @61S8B
     C                   Movel     SPOS          @61S8C
 
      ** else if Funds Transfer, use Payment Reference
     C                   Else
     C                   If        PREF <> *Blanks
     C                   Movel     PREF          @61S8F
 
      ** else if generated entry use type of entry and original
      ** tranasction reference
     C                   Else
     C     'GE'          SCAN      SPOS                                   50
     C                   If        *In50 = *On
     C                   Movel     @SPID         @61S8B
     C                   Movel     OTRF          @61S8C
 
      ** else just use source of posting
     C                   Else
     C                   Movel     SPOS          @61S8F
     C                   EndIf
     C                   EndIf
     C                   EndIf
     C                   EndIf
 
     C                   ENDSR                                                  SF8
      /EJECT
      *****************************************************************
      * Subroutine  :  FLD62F                                         *
      * Function    :  Create field :62F: (closing balance)           *
      *                                                               *
      * Called by   :  CREATE                                         *
      * Calls       :  ZM0040     Return ccy/amount in ISO format     *
      *****************************************************************
      *
     C     FLD62F        BEGSR
 
      ** Set up reference for key
     C                   Eval      MTAG = ':62F:'
 
      ** Set up field tag and data
     C                   Clear                   MFLD
 
      ** Set up subfield 1 (Debit/Credit indicator) nb. zero = credit
     C                   If        LDBL <= 0
     C                   Move      'C'           @62FS1
     C                   Z-Sub     LDBL          @WKAMT
     C                   Else
     C                   Move      'D'           @62FS1
     C                   Z-Add     LDBL          @WKAMT
     C                   EndIf
 
      ** Set up subfield 2 (date)
     C                   Move      @RUND         @62FS2
 
      ** Set up subfields 3 and 4 (Currency and Amount) nb. use
      ** currency code returned by ZM0040 in s/f 3 because this should
      ** be ISO standard value
                                                                                             BUG6739
     C                   EVAL      ZAMNT = @WKAMT                                            BUG6739
     C                   EXSR      SRCurrency                                                BUG6739
     C                   EVAL      @62FS3 = ZSCCY                                            BUG6739
                                                                                             BUG6739
     C**********         Call      'ZM0040'                                                  BUG6739
     C**********         Parm      @WKAMT        ZAMNT                                       BUG6739
     C**********         Parm      CCY           ZCCY                                        BUG6739
     C*****@62FS4        Parm                    ZSAMNT                                      BUG6739
     C*****@62FS3        Parm                    ZSCCY                                       BUG6739
     C**********         Parm      *BLANKS       ZERR                                        BUG6739
     C**********         Parm                    ZSWDPC                                      BUG6739
     C                   CALL      'ZM1140'                             85                   BUG6739
     C                   PARM                    ZAMNT                                       BUG6739
     C                   PARM                    ZCDP                                        BUG6739
     C     @62FS4        PARM                    ZSAMNT                                      BUG6739
     C                   PARM                    ZOAMNT                                      BUG6739
 
      ** If program fails, report database error
     C**********         If        ZERR <> *BLANK                                            BUG6739
     C                   If        *IN85 = *ON                                               BUG6739
     C     *Lock         In        LDA
     C**********         Eval      DBFILE= 'ZM0040'                                          BUG6739
     C                   Eval      DBFILE = 'ZM1140'                                         BUG6739
     C                   Eval      DBKEY = 'PROGRAM'
     C                   Eval      DBASE = 007
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf
 
      ** move data to output record
     C                   Movel     @62F          MFLD
     C                   Movel     CR            CTRC
     C                   Move      LF            CTRC
     C                   Movel     @TRN          TRNO
 
      ** Write record to file
     C                   Write     MGOMSGD0
 
     C                   ENDSR                                                  FLD62F
      /EJECT
      *****************************************************************
      * Subroutine  :  FLD62M                                         *
      * Function    :  Create field :62M: (Intermediate Balance)      *
      *                                                               *
      * Called by   :  CREATE                                         *
      * Calls       :  ZM0040     Return ccy/amount in ISO format     *
      *****************************************************************
      *
     C     FLD62M        BEGSR
 
      ** Set up reference for key
     C                   Eval      MTAG = ':62M:'
 
      ** Set up field tag and data
     C                   Clear                   MFLD
 
      ** Set up subfield 1 (Debit/Credit indicator) nb. zero = credit
     C                   If        W#Balance <= 0
     C                   Move      'C'           @62MS1
     C                   Z-Sub     W#Balance     @WKAMT
     C                   Else
     C                   Move      'D'           @62MS1
     C                   Z-Add     W#Balance     @WKAMT
     C                   EndIf
 
      ** Set up subfield 2 (date)
     C                   Move      @RUND         @62MS2
 
      ** Set up subfields 3 and 4 (Currency and Amount) nb. use
      ** currency code returned by ZM0040 in s/f 3 because this should
      ** be ISO standard value
                                                                                             BUG6739
     C                   EVAL      ZAMNT = @WKAMT                                            BUG6739
     C                   EXSR      SRCurrency                                                BUG6739
     C                   EVAL      @62MS3 = ZSCCY                                            BUG6739
                                                                                             BUG6739
     C**********         Call      'ZM0040'                                                  BUG6739
     C**********         Parm      @WKAMT        ZAMNT                                       BUG6739
     C**********         Parm      CCY           ZCCY                                        BUG6739
     C*****@62MS4        Parm                    ZSAMNT                                      BUG6739
     C*****@62MS3        Parm                    ZSCCY                                       BUG6739
     C**********         Parm      *BLANKS       ZERR                                        BUG6739
     C**********         Parm                    ZSWDPC                                      BUG6739
     C                   CALL      'ZM1140'                             85                   BUG6739
     C                   PARM                    ZAMNT                                       BUG6739
     C                   PARM                    ZCDP                                        BUG6739
     C     @62MS4        PARM                    ZSAMNT                                      BUG6739
     C                   PARM                    ZOAMNT                                      BUG6739
 
      ** If program fails, report database error
     C**********         If        ZERR <> *BLANK                                            BUG6739
     C                   If        *IN85 = *ON                                               BUG6739
     C     *Lock         In        LDA
     C**********         Eval      DBFILE= 'ZM0040'                                          BUG6739
     C                   Eval      DBFILE = 'ZM1140'                                         BUG6739
     C                   Eval      DBKEY = 'PROGRAM'
     C                   Eval      DBASE = 007
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf
 
      ** move data to output record
     C                   Movel     @62M          MFLD
     C                   Movel     CR            CTRC
     C                   Move      LF            CTRC
     C                   Movel     @TRN          TRNO
 
      ** Write record to file
     C                   Write     MGOMSGD0
 
     C                   ENDSR                                                  FLD62F
      /EJECT
      *****************************************************************
      * Subroutine  :  FLD64                                          *
      * Function    :  Create field :64: (closing available balance)  *
      *                                                               *
      * Called by   :  CREATE                                         *
      * Calls       :  ZM0040     Return ccy/amount in ISO format     *
      *****************************************************************
      *
     C     FLD64         BEGSR
 
      ** Set up reference for key
     C                   Eval      MTAG = ':64: '
 
      ** Set up field tag and data
     C                   Clear                   MFLD
 
      ** Set up subfield 1 (Debit/Credit indicator) nb. zero = credit
     C                   If        CLBL <= 0
     C                   Move      'C'           @64S1
     C                   Z-Sub     CLBL          @WKAMT
     C                   Else
     C                   Move      'D'           @64S1
     C                   Z-Add     CLBL          @WKAMT
     C                   EndIf
 
      ** Set up subfield 2 (date)
     C                   Move      @RUND         @64S2
 
      ** Set up subfields 3 and 4 (Currency and Amount) nb. use
      ** currency code returned by ZM0040 in s/f 3 because this should
      ** be ISO standard value
                                                                                             BUG6739
     C                   EVAL      ZAMNT = @WKAMT                                            BUG6739
     C                   EXSR      SRCurrency                                                BUG6739
     C                   EVAL      @64S3 = ZSCCY                                             BUG6739
                                                                                             BUG6739
     C**********         Call      'ZM0040'                                                  BUG6739
     C**********         Parm      @WKAMT        ZAMNT                                       BUG6739
     C**********         Parm      CCY           ZCCY                                        BUG6739
     C*****@64S4         Parm                    ZSAMNT                                      BUG6739
     C*****@64S3         Parm                    ZSCCY                                       BUG6739
     C**********         Parm      *BLANKS       ZERR                                        BUG6739
     C**********         Parm                    ZSWDPC                                      BUG6739
     C                   CALL      'ZM1140'                             85                   BUG6739
     C                   PARM                    ZAMNT                                       BUG6739
     C                   PARM                    ZCDP                                        BUG6739
     C     @64S4         PARM                    ZSAMNT                                      BUG6739
     C                   PARM                    ZOAMNT                                      BUG6739
 
      ** If program fails, report database error
     C**********         If        ZERR <> *BLANK                                            BUG6739
     C                   If        *IN85 = *ON                                               BUG6739
     C     *Lock         In        LDA
     C**********         Eval      DBFILE= 'ZM0040'                                          BUG6739
     C                   Eval      DBFILE = 'ZM1140'                                         BUG6739
     C                   Eval      DBKEY = 'PROGRAM'
     C                   Eval      DBASE = 008
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf
 
      ** move data to output record
     C                   Movel     @64           MFLD
     C                   Movel     CR            CTRC
     C                   Move      LF            CTRC
     C                   Movel     @TRN          TRNO
 
      ** Write record to file
     C                   Write     MGOMSGD0
 
     C                   ENDSR                                                  FLD64
      /EJECT
      *****************************************************************                      BUG6739
      *                                                               *                      BUG6739
      *  SRCurrency - Access Currency Details                         *                      BUG6739
      *                                                               *                      BUG6739
      *****************************************************************                      BUG6739
                                                                                             BUG6739
     C     SRCurrency    BEGSR                                                               BUG6739
                                                                                             BUG6739
     C                   CALL      'AOCURRR0'                                                BUG6739
     C                   PARM      *BLANKS       PRTCD                                       BUG6739
     C                   PARM      '*KEY   '     POPTN                                       BUG6739
     C                   PARM                    CCY                                         BUG6739
     C     SDCURR        PARM      SDCURR        DSSDY                                       BUG6739
                                                                                             BUG6739
     C                   IF        PRTCD <> *BLANKS                                          BUG6739
     C     *LOCK         IN        LDA                                                       BUG6739
     C                   EVAL      DBFILE= 'SDCURRPD'                                        BUG6739
     C                   EVAL      DBKEY = CCY                                               BUG6739
     C                   EVAL      DBASE = 10                                                BUG6739
     C                   OUT       LDA                                                       BUG6739
     C                   EXSR      *PSSR                                                     BUG6739
     C                   ENDIF                                                               BUG6739
                                                                                             BUG6739
     C                   IF        PRTCD = *BLANKS                                           BUG6739
                                                                                             BUG6739
     C                   EVAL      ZSCCY = A6SWCY                                            BUG6739
     C                   EVAL      ZCDP = A6NBDP                                             BUG6739
                                                                                             BUG6739
     C                   IF        CSW020 = 'Y' and A6NBDP <> A6SWDP                         BUG6739
     C                             and A6SWDT <= BJRDNB                                      BUG6739
                                                                                             BUG6739
     C                   IF        A6SWDP < ZCDP                                             BUG6739
     C                   EVAL      X = ZCDP - A6SWDP                                         BUG6739
     C                   ELSE                                                                BUG6739
     C                   EVAL      X = A6SWDP - ZCDP                                         BUG6739
     C                   ENDIF                                                               BUG6739
                                                                                             BUG6739
     C                   IF        X = 1                                                     BUG6739
     C                   EVAL      Y = 10                                                    BUG6739
     C                   ENDIF                                                               BUG6739
                                                                                             BUG6739
     C                   IF        X = 2                                                     BUG6739
     C                   EVAL      Y = 100                                                   BUG6739
     C                   ENDIF                                                               BUG6739
                                                                                             BUG6739
     C                   IF        X = 3                                                     BUG6739
     C                   EVAL      Y = 1000                                                  BUG6739
     C                   ENDIF                                                               BUG6739
                                                                                             BUG6739
     C                   IF        X = 4                                                     BUG6739
     C                   EVAL      Y = 10000                                                 BUG6739
     C                   ENDIF                                                               BUG6739
                                                                                             BUG6739
     C                   IF        A6SWDP < ZCDP                                             BUG6739
     C                   EVAL      ZAMNT = ZAMNT / Y                                         BUG6739
     C                   ELSE                                                                BUG6739
     C                   EVAL      ZAMNT = ZAMNT * Y                                         BUG6739
     C                   ENDIF                                                               BUG6739
                                                                                             BUG6739
     C                   EVAL      ZCDP = A6SWDP                                             BUG6739
                                                                                             BUG6739
     C                   ENDIF                                                               BUG6739
                                                                                             BUG6739
     C                   ENDIF                                                               BUG6739
                                                                                             BUG6739
     C                   ENDSR                                                               BUG6739
                                                                                             BUG6739
      *****************************************************************                      BUG6739
      /EJECT                                                                                 BUG6739
      *****************************************************************
      * Subroutine  :  INIT                                           *
      * Function    :  Perform initial processing                     *
      *                                                               *
      * Called by   :  Main process                                   *
      * Calls       :  AOBANKR0                                       *
      *****************************************************************
      *
     C     INIT          BEGSR
 
      ** Initialise object copyright statement
     C                   MOVEA     CPY@          BIS@             80
 
      ** Initialise LDA
     C     *Lock         In        LDA
     C                   Eval      DBPGM = 'RC2012'
     C                   Eval      DBFILE = *BLANKS
     C                   Eval      DBKEY =  *BLANKS
     C                   Eval      DBASE = 0
     C                   Out       LDA
 
      ** Access bank details.
     C                   Call      'AOBANKR0'
     C                   Parm      *BLANKS       PRtcd
     C                   Parm      '*FIRST '     POptn
     C     SDBANK        Parm      SDBANK        DSFDY
 
      ** Database error
     C                   If        PRtcd <> *BLANK
     C     *Lock         In        LDA
     C                   Eval      DBFILE= 'SDBANKPD'
     C                   Eval      DBKEY = POptn
     C                   Eval      DBASE = 001
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf
                                                                                             BUG6739
      ** Access Switchable Features                                                          BUG6739
                                                                                             BUG6739
     C                   CALL      'AOSARDR0'                                                BUG6739
     C                   PARM      *BLANKS       PRTCD                                       BUG6739
     C                   PARM      '*VERIFY'     POPTN                                       BUG6739
     C                   PARM      'CSW020'      PSARD                                       BUG6739
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG6739
                                                                                             BUG6739
      ** Database error                                                                      BUG6739
                                                                                             BUG6739
     C                   IF        PRTCD <> *BLANKS and PRTCD <> '*NRF   '                   BUG6739
     C     *LOCK         IN        LDA                                                       BUG6739
     C                   EVAL      DBFILE= 'SCSARDPD'                                        BUG6739
     C                   EVAL      DBKEY = PSARD                                             BUG6739
     C                   EVAL      DBASE = 9                                                 BUG6739
     C                   OUT       LDA                                                       BUG6739
     C                   EXSR      *PSSR                                                     BUG6739
     C                   ENDIF                                                               BUG6739
                                                                                             BUG6739
     C                   IF        PRTCD = *BLANKS                                           BUG6739
     C                   EVAL      CSW020 = 'Y'                                              BUG6739
     C                   ELSE                                                                BUG6739
     C                   EVAL      CSW020 = 'N'                                              BUG6739
     C                   ENDIF                                                               BUG6739
     C/COPY WNCPYSRC,RCH00007
 
      **  Convert run date to YYMMDD for Transaction Reference Number
     C                   Call      'ZM0060'
     C                   Parm      BJRDNB        ZMDAY             5 0
     C                   Parm                    ZMDATE            6
     C                   Move      ZMDATE        @DAT
 
      ** Key list for full account i/d
     C     KEY1          KList
     C                   KFld                    CNUM
     C                   KFld                    CCY
     C                   KFld                    ACOD
     C                   KFld                    ACSQ
     C                   KFld                    BRCA
 
      ** Set up fields which are constant in Message Reference File
     C                   Eval      MODI = 'GL'
     C**********         Eval      NWRK = 'SWIFT'                                             CDL030
     C                   Eval      NWRK = 'PAPER'                                             CDL030
     C                   Eval      MTPY = '950'
     C                   Eval      MPRY = 'N'
     C                   Eval      MGSG = '1'
     C                   Eval      MGST = 'CRTD'
     C                   Eval      LADT = BJMRDT
     C                   Eval      DELC = *Blanks
     C                   Move      ZMDATE        MGDE
     C                   Time                    MGTM
     C                   Time                    LATM
 
      ** Set-up Message Generation  Century flag
     C                   Movel     MGDE          YY
     C                   If        YY < 72
     C                   Eval      CIND = '2'
     C                   Else
     C                   Eval      CIND = '1'
     C                   EndIf
 
      **  Access SDMGMEPD for drop SWIFT msg. no. days
     C                   Call      'AOMGMER0'
     C                   Parm      '*MSG   '     PRtCd
     C                   Parm      '*FIRST '     POptn
     C     SDMGME        Parm      SDMGME        DSFDY
 
      ** Database error
     C                   If        PRtcd <> *BLANK
     C     *Lock         In        LDA
     C                   Eval      DBFILE= 'SDMGMEPD'
     C                   Eval      DBKEY = POptn
     C                   Eval      DBASE = 002
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf
 
      **  Convert history retention date to YYMMDD
     C                   Eval      ZDAYNO = BJRDNB + ENDSMN
     C                   Call      'ZM0060'
     C                   Parm                    ZDAYNO            5 0
     C                   Parm                    ZMDATE            6
 
     C                   Eval      HRDT = ZMDATE
 
      ** Initialise transaction reference subfields
     C                   Eval      @PFX = 'RC'
     C                   Eval      @SEQ = 0
 
     C*********          TIME           @TIM
 
     C** Set up Special Message characters
     C                   BITOFF    '01234567'    CR                1
     C                   BITOFF    '01234567'    LF                1
     C                   BITON     '457'         CR                             CARRIAGE RTN
     C                   BITON     '257'         LF                             LINE FEED
 
     C                   ENDSR                                                  INIT
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR   -  Error Handling Subroutine                         *
      *                                                               *
      *  Called by: Various                                           *
      *                                                               *
      *  Calls    : DBERRCTL - Database Error Control                 *
      *                                                               *
      *****************************************************************
     C     *PSSR         BegSr
 
     C                   Dump
 
     C                   If        @RUN = *BLANK
     C                   Eval      @RUN = 'Y'
      ** DUMP and write database error report
     C                   Open      RC2010AU
     C                   Write     RC2010F1
     C                   Close     RC2010AU
     C                   Call      'DBERRCTL'
     C                   EndIf
 
     C                   Eval      *InU7 = *ON
     C                   Eval      *InU8 = *ON
     C                   Eval      *InLR = *ON
     C                   Return
 
     C                   EndSr
      /EJECT
      ********************************************************************
** File translation table to prevent use of invalid ISO characters
*EQUATE   MGOMSGPD
*EQUATE   4E504B5E7D7F4DC05DD060CD6F5A6F5B6F4A6F6C6F5C6F4C6F7E6F6E6F7C61E0
*EQUATE   D57B6FA6
*EQUATE   6F4F6F5F7D7960A1606D4000
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
