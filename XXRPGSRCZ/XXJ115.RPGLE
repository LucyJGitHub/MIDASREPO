     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2018')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Pooling Accounts Outgoing Details')           *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      ***GLJ105*-*Midas*GL*Outgoing Account Pooling Details************         JMI108
      *  XXJ115 - Midas GL Outgoing Account Pooling Details           *         JMI108
      *                                                               *
      *  Function:  This program will set up the active pooling       *
      *             account details requiring sent by FTP to the head *
      *             office server.                                    *
      *                                                               *
      ***Called By:*GLJ103*-*Account Pooling Send**********************         JMI108
      **************GLJ107*-*Account Pooling COB Send******************         JMI108
      *  Called By: XXJ113 - Account PoolingfSend                     *
      *             XXJ117 - Account Pooling COB Send                 *
      *                                                               *
      ***(c)*Misys*International*Banking*Systems*Ltd.*2007*************         JMI108
      *  (c) Finastra International Limited 2018                      *         JMI108
      *                                                               *
      *  Last Amend No. JMI108             Date 31May18               *
      *  Prev Amend No. TFJ011             Date 21Nov07               *
      *                 TFJ011             Date 23Jan07               *
      *                 TFJ011  *CREATE    Date 10Mar05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI108 - Account Balance Pooling. Upgrade to FBM 2.1         *
      *  TFJ011 - Initialize DS/DETAILS                               *
      *  TFJ011 - Amenda Account Code size from 4 to 10               *
      *           Account Balance Pooling                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *****35*********Error in reading file SDPLACV0                  *         JMI108
      *****45*********End of file for SDPLACV0                        *         JMI108
      *    35         Error in reading file XXPLACV0                  *         JMI108
      *    45         End of file for XXPLACV0                        *         JMI108
      *    60         CHAIN Indicator                                 *
      *    98         Date Format                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      * Pooling Account Details
     F***SDPLACV0  IF   E           K DISK    INFSR(*PSSR)                      JMI108
     FXXPLACV0  IF   E           K DISK    INFSR(*PSSR)                         JMI108

      * Shadow balances by account details
     FMEMOSL1   IF   E           K DISK    INFSR(*PSSR)

      * Accounts by Branch
     FACCBR     IF   E           K DISK    INFSR(*PSSR)

      * Account Outgoing Details
     F***GLPODLPP  O    E             DISK    INFSR(*PSSR)                      JMI108
     FXXPODLPP  O    E             DISK    INFSR(*PSSR)                         JMI108
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      ** Data Area giving Rundate

      ** Data structure for Header record
     DHEADER           DS
     D JRECH                   1      1  0                                      Header = 1
     D JCC                     2      3  0                                      Century
     D JYY                     4      5  0                                      Year
     D JMO                     6      7  0                                      Month
     D JDD                     8      9  0                                      Day
     D JHH                    10     11  0                                      Hour
     D JMM                    12     13  0                                      Minute
     D JCBRCH                 14     16                                         Sender's branch code
     D FILLER1                17    200                                         Filler

      ** Data structure for Detail
     DDETAIL           DS
     D JREC                    1      1  0                                      Detail = 2
     D JDBRCH                  2      4                                         Internal Branch Code
     D JBRCA                   5      7                                         Midas Branch code
     D*JCNUM*******************8     13  0                                      CustomerJMI108
     D JCNUM                   8     13                                         Cust Nb JMI108
     D JSWCY                  14     16                                         Swift Currency Code
     D*JACOD*********         17     20  0                                      Account Code  TFJ011
     D @@JACOD                17     20  0                                      Account Code  TFJ011
     D JACSQ                  21     22  0                                      Account Sequence No.
     D JACNO                  23     32  0                                      Retail Accnt No.
     D JANAM                  33     52                                         Account Name
     D JCRNM                  53     72                                         Customer Report Name
     D JCRTN                  73     82                                         Customer Report Town
     D JACCN                  83    107                                         Account Code Name
     D JLDBLS                108    108                                         Ledger Balance Sign
     D JLDBL                 109    123  0                                      Ledger Balance
     D JCLBLS                124    124                                         Cleared Balance Sign
     D JCLBL                 125    139  0                                      Cleared Balance
     D JDHH                  140    141  0                                      Hour
     D JDMM                  142    143  0                                      Minute
      *
     D JACOD                 144    153  0                                      Account Code  TFJ011
      *
     D*FILLER2*********      144    200                                         Filler        TFJ011
     D FILLER2               154    200                                         Filler        TFJ011

      ** Data structure for Trailer record
     DTRAILER          DS
     D TRECI                   1      1  0                                      Trailer = 9
     D TCC                     2      3  0                                      Century
     D TYY                     4      5  0                                      Year
     D TMO                     6      7  0                                      Month
     D TDD                     8      9  0                                      Day
     D THH                    10     11  0                                      Hour
     D TMM                    12     13  0                                      Minute
     D TIBRCH                 14     16                                         Sender's branch code
     D TNOREC                 17     21  0                                      Number of records
     D FILLER3                22    200                                         Filler

      ** Data structure for Date
     D@YDATE           DS
     D @CC                     1      2  0
     D @YY                     3      4  0
     D @MM                     5      6  0
     D @DD                     7      8  0

      ** Data structure for Time
     DWTime            DS
     D @THH                    1      2
     D @TMM                    3      4

      ** Data structure for MEMOS Key
     DKMEMKey          DS
     D*KMCNUM******************1      6  0                                      Customer      JMI108
     D KMCNUM                  1      6                                         Customer      JMI108
     D KMCCY                   7      9                                         Currency
     D*KMACOD*********        10     13  0                                      Account Code  TFJ011
     D*KMACSQ*********        14     15  0                                      Account Seq   TFJ011
     D*KMBRCA*********        16     18                                         Branch        TFJ011
     D KMACOD                 10     19  0                                      Account Code  TFJ011
     D KMACSQ                 20     21  0                                      Account Seq   TFJ011
     D KMBRCA                 22     24                                         Branch        TFJ011
      *
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  ErrorOnFl             35     35
     D  EndOfFile             45     45

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** True and False can be used for indicators being on or off.
     D True            C                   *On
     D False           C                   *Off


      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS for Currency Details

     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** External DS for Customer Details

     D SDACOD        E DS                  EXTNAME(SDACODPD)
      ** External DS for Account Code Details

     D*** SDPICD        E DS                  EXTNAME(SDPICDPP)                 JMI108
     D XXPICD        E DS                  EXTNAME(XXPICDPP)                    JMI108
      ** External DS for Pooling ICD Details

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS for Access Programs, Short Data Structure

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** DS for access objects - long data structure

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D @RUN            S              1
     D RCount          S              5  0

      ** Define fields for ZDATE9
     D @DAYN           S              5P 0
     D @YMD            S              8S 0
     D @RETN           S              1A

      ** Parameters for access object programs
     D PRtcd           S              7A
     D POptn           S              7A
     D PCust           S             10A
     D PStKey          S              7A

      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))

      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
      ** Populate Header
     C                   CLEAR                   HEADER

     C                   EVAL      JRECH = 1
     C                   MOVE      @YMD          @YDATE
     C                   EVAL      JCC   = @CC
     C                   EVAL      JYY   = @YY
     C                   EVAL      JMO   = @MM
     C                   EVAL      JDD   = @DD
     C                   MOVE      @THH          JHH
     C                   MOVE      @TMM          JMM
     C                   EVAL      JCBRCH = JIBRCH
     C                   EVAL      FILLER1 = *BLANKS
     C                   MOVEL     HEADER        JOTDL
      *
      ** Write Header
     C*******************WRITE     GLPODLD0                                     JMI108
     C                   WRITE     XXPODLD0                                     JMI108
      *
      ** Read through Pooling Accounts
     C                   Z-ADD     0             RCOUNT
     C                   MOVEL     *BLANKS       JBRCA                          Branch
     C*******************Z-ADD     *ZEROS        JCNUM                          Customer  JMI108
     C                   MOVEL     *BLANKS       JCNUM                          Customer  JMI108
     C                   MOVEL     *BLANKS       JCCY                           Currency
     C                   Z-ADD     *ZEROS        JACOD                          Account Code
     C                   Z-ADD     *ZEROS        JACSQ                          Account Seq
     C*****KPOS          SETLL     SDPLACV0                                     JMI108
     C*****              READ      SDPLACV0                             3545    JMI108
     C     KPOS          SETLL     XXPLACV0                                     JMI108
     C                   READ      XXPLACV0                             3545    JMI108
      *
     C                   DOU       EndOfFile = True

     C     KPOS          CHAIN     ACCBR                              60
     C                   IF        (*IN60 = '0') and (RECI = 'D')
      *
      ** Populate Detail
     C**********         Clear                   DETAIL                                TFJ011 TFJ011
     C                   Clear                   @@JACOD                               TFJ011 TFJ011
      ** CLEAR initialize numerice fields in DS/DETAIL                                 TFJ011 TFJ011
      ** CLEAR initialize @@JAOCD in DS/DETAIL                                         TFJ011 TFJ011
      *
     C                   EVAL      JREC  = 2
     C                   EVAL      JDBRCH = JIBRCH
      *
      ** Get Currency Details
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      JCCY          @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY

     C     PRtcd         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDCURRPD'                          *************
     C                   EVAL      DBase = 001                                  * DBERR 001 *
     C                   EVAL      DBKey = @AJCD                                *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      JSWCY = A6SWCY
      *
      ** Get Customer details
     C                   MOVE      *Blanks       PCust
     C                   MOVE      JCNUM         PCust
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM                    PCust
     C                   PARM      *Blanks       PStKey
     C     SDCUST        PARM      SDCUST        DSSDY

     C                   IF        PRtcd <> *Blanks OR
     C                             PStKey = 'ERROR'
     C     *LOCK         IN        LDA
     C                   MOVE      PCust         DBKEY
     C                   EVAL      DBFile = 'SDCUSTPD'                          *************
     C                   EVAL      DBase = 002                                  * DBERR 002 *
     C                   OUT       LDA                                          *************
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      JCRNM = BBCRNM
     C                   EVAL      JCRTN = BBCRTN
      *
      ** Get Account Code Details
     C                   MOVE      JACOD         @ACOD
     C                   CALL      'AOACODR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn                                        TFJ011
     C**********         PARM                    @ACOD             4                          TFJ011
     C                   PARM                    @ACOD            10
     C     SDACOD        PARM      SDACOD        DSFDY

     C     PRtcd         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDACODPD'                          *************
     C                   EVAL      DBase = 003                                  * DBERR 003 *
     C                   MOVE      @ACOD         DBKey                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      JACCN = A5ACCN
      *
     C                   MOVEL     JCNUM         KMCNUM                         Customer
     C                   MOVEL     JCCY          KMCCY                          Currency
     C                   MOVEL     JACOD         KMACOD                         Account Code
     C                   MOVEL     JACSQ         KMACSQ                         Account Seq
     C                   MOVEL     JBRCA         KMBRCA                         Branch

     C                   IF        WTime <> '9999'
     C     KMEMOS        CHAIN     MEMOSL1                            60

     C                   IF        *IN60 = '0'
     C     LDBLN         IFLE      0
     C                   Z-SUB     LDBLN         JLDBL
     C                   MOVE      *BLANKS       JLDBLS
     C                   ELSE
     C                   EVAL      JLDBL = LDBLN
     C                   MOVE      '1'           JLDBLS
     C                   ENDIF
     C     CLBLN         IFLE      0
     C                   Z-SUB     CLBLN         JCLBL
     C                   MOVE      *BLANKS       JCLBLS
     C                   ELSE
     C                   EVAL      JCLBL = CLBLN
     C                   MOVE      '1'           JCLBLS
     C                   ENDIF
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'MEMOSL1 '                          *************
     C                   EVAL      DBase = 004                                  * DBERR 004 *
     C                   EVAL      DBKey = KMEMKey                              *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF

     C                   IF        WTime = '9999'

     C     LDBL          IFLE      0
     C                   Z-SUB     LDBL          JLDBL
     C                   MOVE      *BLANKS       JLDBLS
     C                   ELSE
     C                   EVAL      JLDBL = LDBL
     C                   MOVE      '1'           JLDBLS
     C                   ENDIF
     C     CLBL          IFLE      0
     C                   Z-SUB     CLBL          JCLBL
     C                   MOVE      *BLANKS       JCLBLS
     C                   ELSE
     C                   EVAL      JCLBL = CLBL
     C                   MOVE      '1'           JCLBLS
     C                   ENDIF
     C                   ENDIF

     C                   MOVE      @THH          JDHH
     C                   MOVE      @TMM          JDMM
     C                   EVAL      FILLER2 = *BLANKS
      *
      ** Count Number of Records outputted in GLPODLPP
     C                   ADD       1             RCOUNT
     C                   MOVEL     DETAIL        JOTDL
     C****************** WRITE     GLPODLD0                                     JMI108
     C                   WRITE     XXPODLD0                                     JMI108
     C                   ENDIF
      *
      ** Read next record.
      *
     C****************** READ      SDPLACV0                             3545    JMI108
     C                   READ      XXPLACV0                             3545    JMI108
      *
     C                   ENDDO
      *
      ** Populate Trailer
     C                   EVAL      TRECI = 9
     C                   MOVE      @YMD          @YDATE
     C                   EVAL      TCC   = @CC
     C                   EVAL      TYY   = @YY
     C                   EVAL      TMO   = @MM
     C                   EVAL      TDD   = @DD
     C                   MOVE      @THH          THH
     C                   MOVE      @TMM          TMM
     C                   EVAL      TIBRCH = JIBRCH
     C                   EVAL      TNOREC = RCOUNT
     C                   EVAL      FILLER3 = *BLANKS
     C                   MOVEL     TRAILER       JOTDL
      *
      ** Write Trailer
     C****************** WRITE     GLPODLD0                                     JMI108
     C                   WRITE     XXPODLD0                                     JMI108

      *
     C                   SETON                                        LR
     C                   RETURN
      **********************************************************************
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

     C     *entry        PLIST
     C                   PARM                    Ret_Code          7
     C                   PARM                    INTime            4 0

     C                   MOVE      INTime        WTime

     C     *DTAARA       DEFINE                  LDA

     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA

     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** Convert Runday into YYYYMMDD format
     C                   CALLB     'ZDATE9'
     C                   PARM      AGRDNB        @DAYN
     C                   PARM      *ZERO         @YMD
     C                   PARM                    @RETN
      *
      ** Obtain the FTP incoming times from the Pooling ICD
     C****************** CALL      'AOPICDR0'                                   JMI108
     C                   CALL      'XXPICDR0'                                   JMI108
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C*****SDPICD        PARM      SDPICD        DSSDY                          JMI108
     C     XXPICD        PARM      XXPICD        DSSDY                          JMI108

     C     PRtcd         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C****************** MOVEL     'SDPICDPP'    DBFILE                         JMI108
     C                   MOVEL     'XXPICDPP'    DBFILE                         JMI108
     C                   MOVEL     POptn         DBKEY                      ************
     C                   Z-ADD     005           DBASE                      * DBERR 005*
     C                   OUT       LDA                                      ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Set up Key Lists
     C     KPOS          KLIST
     C                   KFLD                    JBRCA                          Branch
     C                   KFLD                    JCNUM                          Customer
     C                   KFLD                    JCCY                           Currency
     C                   KFLD                    JACOD                          Account Code
     C                   KFLD                    JACSQ                          Account Seq
      *
      ** Set up Key Lists
     C     KMEMOS        KLIST
     C****************** KFLD                    KMCNUM            6 0          Customer      JMI108
     C                   KFLD                    KMCNUM            6            Customer      JMI108
     C                   KFLD                    KMCCY             3            Currency
     C**********         KFLD                    KMACOD            4 0          Account Code  TFJ011
     C                   KFLD                    KMACOD           10 0          Account Code  TFJ011
     C                   KFLD                    KMACSQ            2 0          Account Seq
     C                   KFLD                    KMBRCA            3            Branch

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   EVAL      Ret_Code = '*Error'
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2018
