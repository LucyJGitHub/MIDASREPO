     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Outgoing Reconcile Data Details')             *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      ***GLJ108*-*Midas*GL*Outgoing*Reconcile*Data Details*************         JMI108
      *  XXJ118 - Midas GL Outgoing Reconcile Data Details            *         JMI108
      *                                                               *
      *  Function:  This program will run in COB extracting posting   *
      *             details requiring sent by FTP to the head office  *
      *             server.                                           *
      *                                                               *
      ***Called*By:*GLCJ108*-*Outgoing Reconcile Data Details**********         JMI108
      *  Called By: XXCJ118 - Outgoing Reconcile Data Details         *         JMI108
      *                                                               *
      ***(c)*Misys*International*Banking*Systems*Ltd.*2005*************         JMI108
      *  (c) Finastra International Limited 2018                      *         JMI108
      *                                                               *
      *  Last Amend No. JMI108             Date 31May18               *
      *  Prev Amend No. TFJ11A             Date 1Oct057               *
      *                 TFJ011  (CHG001)   Date 12Aug05               *
      *                 TFJ011  *CREATE    Date 10Mar05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI108 - Account Balance Pooling. Upgrade to FBM 2.1         *
      *  TFJ11A - Account Transfer Service                            *
      *  TFJ011 - (CHG001) Changes due to Difference of the File      *
      *           System                                              *
      *  TFJ011 - Account Balance Pooling                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *****35*********Error in reading file SDPLACV0*******************         JMI108
      *****45*********End of file for SDPLACV0*************************         JMI108
      *    35         Error in reading file XXPLACV0                  *         JMI108
      *    45         End of file for XXPLACV0                        *         JMI108
      *    60         CHAIN Indicator                                 *
      *    61         CHAIN Indicator                                 *
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

      * COB Postings Details
     FEODPOPD   IF   E             DISK    INFSR(*PSSR)

      * Pooling Account Details
     F***SDPLACV0  IF   E           K DISK    INFSR(*PSSR)                      JMI108
     FXXPLACV0  IF   E           K DISK    INFSR(*PSSR)                         JMI108
     F                                     PREFIX(A_)

      * Journal Entry Extension file
     F***GLJEIPYC  IF   E           K DISK    INFSR(*PSSR)                      JMI108
     FXXJEIPYC  IF   E           K DISK    INFSR(*PSSR)                         JMI108

      * Account Outgoing Details
     F***GLRODLPP  O    E             DISK    INFSR(*PSSR)                      JMI108
     FXXRODLPP  O    E             DISK    INFSR(*PSSR)                         JMI108

      * Account Pooling FTP command details
     F***GLPSINPP  O    E             DISK    INFSR(*PSSR)                      JMI108
     FXXPSINPP  O    E             DISK    INFSR(*PSSR)                         JMI108
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

     D*** SDPFTPDA      E DS                  EXTNAME(SDPFTPDA)                 JMI108
     D XXPFTPDA      E DS                  EXTNAME(XXPFTPDA)                    JMI108
      ** Data Area giving Pooling ICD FTP details

      ** Data structure for Header record
     DHEADER           DS
     D JRECH                   1      1  0                                      Header = 1
     D JCC                     2      3  0                                      Century
     D JYY                     4      5  0                                      Year
     D JMM                     6      7  0                                      Month
     D JDD                     8      9  0                                      Day
     D JHBRCH                 10     12                                         Sender's branch code
     D FILL1                  13    150                                         Filler

      ** Data structure for Detail
     DDETAIL           DS
     D JREC                    1      1  0                                      Detail = 2
     D JVCC                    2      3  0                                      Value Date Century
     D JVYY                    4      5  0                                      Value Date Year
     D JVMM                    6      7  0                                      Value Date Month
     D JVDD                    8      9  0                                      Value Date Day
     D JDBRCH                 10     12                                         Sender's branch code
     D JSCHEM                 13     22                                         Scheme Number
     D JINSEQ                 23     27  0                                      Transaction Sequence
     D JINTYP                 28     30                                         Transaction Type
      * Start of TFJ11A
     D JEXHH                  31     32  0                                      Execution Hour
     D JEXMIN                 33     34  0                                      Execution Minute
     D JEXCC                  35     36  0                                      Execution Century
     D JEXYY                  37     38  0                                      Execution Year
     D JEXMM                  39     40  0                                      Execution Month
     D JEXDD                  41     42  0                                      Execution Day
     D*JFILL1                 31     57                                         Filler 1
     D JFILL1                 43     57                                         Filler 1
      * End of TFJ11A
     D JACCOD                 58     58                                         Accounting Code
     D JNBRCH                 59     61                                         Internal Branch Code
     D JDRCR                  62     62                                         Dr/Cr Indicator
     D JCACNO                 63     82                                         Account Number
     D JSCCY                  83     85                                         Swift Currency Code
     D JAMNT                  86    100  0                                      Amount
     D JFILL2                101    150                                         Filler 2

      ** Data structure for Trailer record
     DTRAILER          DS
     D TRECI                   1      1  0                                      Trailer = 9
     D TCC                     2      3  0                                      Century
     D TYY                     4      5  0                                      Year
     D TMM                     6      7  0                                      Month
     D TDD                     8      9  0                                      Day
     D TIBRCH                 10     12                                         Sender's branch code
     D TNOREC                 13     17  0                                      Number of records
     D FILL3                  18    150                                         Filler

      ** Data structure for Date
     D@YDATE           DS
     D @CC                     1      2  0
     D @YY                     3      4  0
     D @MM                     5      6  0
     D @DD                     7      8  0

      ** Data structure for User ID on PF/GLPSINPD
     D@USRID           DS
     D USER                    1     20
     D @1                     21     21
     D PASW                   22     41

      ** Data Structure for PUT write to PF/GLPSINPD
     D@PUT             DS
     D PUT                     1      3
     D @2                      4      4
     D LIBNM                   5     14
     D @3                     15     15
     D FILNM                  16     25
     D @4                     26     26
     D PATH                   27     57

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

      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))

     D PATHA           S              1    DIM(31)
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
     C                   EVAL      JMM   = @MM
     C                   EVAL      JDD   = @DD
     C                   EVAL      JHBRCH = JIBRCH
     C                   EVAL      FILL1 = *BLANKS
     C                   MOVEL     HEADER        JOTDL
      *
      ** Write Header
     C****************** WRITE     GLRODLD0                                     JMI108
     C                   WRITE     XXRODLD0                                     JMI108
      *
      ** Read through COB Postings Details File
     C                   Z-ADD     0             RCOUNT
     C     1             SETLL     EODPOPD
     C                   READ      EODPOPD                              3545
      *
     C                   DOU       EndOfFile = True

     C     3             SUBST     SPOS:1        KBTNB
     C     3             SUBST     SPOS:4        WBINB             3
     C                   MOVE      WBINB         KBINB
     C**** KJEIP         CHAIN     GLJEIPYC                           60        JMI108
     C     KJEIP         CHAIN     XXJEIPYC                           60        JMI108

     C                   EVAL      KBRCA = BRCA
     C                   EVAL      KCNUM = CNUM
     C                   EVAL      KCCY  = CCY
     C                   EVAL      KACOD = ACOD
     C                   EVAL      KACSQ = ACSQ
     C**** KEOD          CHAIN     SDPLACV0                           61        JMI108
     C     KEOD          CHAIN     XXPLACV0                           61        JMI108
      *
      * If a non-commission pooling record
     C     *IN60         IFEQ      '0'
     C     JACOD         ANDNE     2
      *
      * Or commission pooling record to an Inter-office account
     C     *IN60         OREQ      '0'
     C     JACOD         ANDEQ     2
     C     *IN61         ANDEQ     '0'
     C     A_JSCHMI      ANDEQ     'I'
     C
     C                   EXSR      SROutInter

     C                   Else

     C                   IF        (*IN61 = '0') and (A_JSCHMI = 'I')
     C                   EXSR      SROutIntra
     C                   ENDIF
     C
     C                   ENDIF
      *
      ** Read next record.
      *
     C                   READ      EODPOPD                              3545
      *
     C                   ENDDO
      *
      ** Populate Trailer
     C                   EVAL      TRECI = 9
     C                   EVAL      TCC   = JCC
     C                   EVAL      TYY   = JYY
     C                   EVAL      TMM   = JMM
     C                   EVAL      TDD   = JDD
     C                   EVAL      TIBRCH = JIBRCH
     C                   EVAL      TNOREC = RCOUNT
     C                   EVAL      FILL3  = *BLANKS
     C                   MOVEL     TRAILER       JOTDL
      *
      ** Write Trailer
     C****************** WRITE     GLRODLD0                                     JMI108
     C                   WRITE     XXRODLD0                                     JMI108

      *
      ** Setup FTP Details
     C                   EXSR      SRPutFTP

      *
     C                   SETON                                        LR
     C                   RETURN
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SROutInter - Output Interoffice Extension File                *
      *                                                               *
      * Called by: Main Program                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SROutInter    BEGSR
      *
      ** Populate Detail
     C                   EVAL      JREC = 2
      *
      ** Convert Value Date into YYYYMMDD format
     C                   CALLB     'ZDATE9'
     C                   PARM      VALD          @DAYN
     C                   PARM      *ZERO         @YMD
     C                   PARM                    @RETN
     C                   MOVE      @YMD          @YDATE
     C                   EVAL      JVCC = @CC
     C                   EVAL      JVYY = @YY
     C                   EVAL      JVMM = @MM
     C                   EVAL      JVDD = @DD

     C                   EVAL      JDBRCH = JIBRCH
     C                   EVAL      JSCHEM = JSHMN
     C                   EVAL      JINSEQ = JINSS
     C                   EVAL      JINTYP = JINST
     C                   MOVE      JACOD         JACCOD
     C                   EVAL      JNBRCH = JBRCH
     C                   IF        DRCR = 0
     C                   EVAL      JDRCR  = '1'
     C                   ENDIF
     C                   IF        DRCR = 1
     C                   EVAL      JDRCR  = '2'
     C                   ENDIF
     C                   MOVEL     ACNO          JCACNO
      *
      ** Get Currency Details
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      CCY           @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY

     C     PRtcd         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDCURRPD'                          *************
     C                   EVAL      DBase = 002                                  * DBERR 002 *
     C                   EVAL      DBKey = @AJCD                                *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      JSCCY  = A6SWCY
     C                   EVAL      JAMNT  = PSTA
      *
      * Execution Time and Date                                                               TFJ11A
     C                   EVAL      JEXHH = JEHH                                               TFJ11A
     C                   EVAL      JEXMIN = JEMIN                                             TFJ11A
     C                   EVAL      JEXCC = JECC                                               TFJ11A
     C                   EVAL      JEXYY = JEYY                                               TFJ11A
     C                   EVAL      JEXMM = JEMM                                               TFJ11A
     C                   EVAL      JEXDD = JEDD                                               TFJ11A
      *                                                                                       TFJ11A
      ** Count Number of Records outputted in GLRODLPP
     C                   ADD       1             RCOUNT
     C                   MOVEL     DETAIL        JOTDL
     C****************** WRITE     GLRODLD0                                     JMI108
     C                   WRITE     XXRODLD0                                     JMI108

     C                   ENDSR

      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SROutIntra - Output Inter-office Account                      *
      *                                                               *
      * Called by: Main Program                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SROutIntra    BEGSR
      *
      ** Populate Detail
     C                   EVAL      JREC = 2
      *
      ** Convert Value Date into YYYYMMDD format
     C                   CALLB     'ZDATE9'
     C                   PARM      VALD          @DAYN
     C                   PARM      *ZERO         @YMD
     C                   PARM                    @RETN
     C                   MOVE      @YMD          @YDATE
     C                   EVAL      JVCC = @CC
     C                   EVAL      JVYY = @YY
     C                   EVAL      JVMM = @MM
     C                   EVAL      JVDD = @DD

     C                   EVAL      JDBRCH = JIBRCH
     C                   EVAL      JSCHEM = '9999999999'
     C                   EVAL      JINSEQ = 99999
     C                   EVAL      JINTYP = *Blanks
     C                   EVAL      JACCOD = '1'
     C                   EVAL      JNBRCH = A_JBRCH
     C                   IF        DRCR = 0
     C                   EVAL      JDRCR  = '1'
     C                   ENDIF
     C                   IF        DRCR = 1
     C                   EVAL      JDRCR  = '2'
     C                   ENDIF
     C                   MOVEL     ACNO          JCACNO
      *
      ** Get Currency Details
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      CCY           @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY

     C     PRtcd         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDCURRPD'                          *************
     C                   EVAL      DBase = 003                                  * DBERR 003 *
     C                   EVAL      DBKey = @AJCD                                *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      JSCCY  = A6SWCY
     C                   EVAL      JAMNT  = PSTA
      *
      * Execution Time and Date set as 9s                                                     TFJ11A
     C                   EVAL      JEXHH = 99                                                 TFJ11A
     C                   EVAL      JEXMIN = 99                                                TFJ11A
     C                   EVAL      JEXCC = 99                                                 TFJ11A
     C                   EVAL      JEXYY = 99                                                 TFJ11A
     C                   EVAL      JEXMM = 99                                                 TFJ11A
     C                   EVAL      JEXDD = 99                                                 TFJ11A
      *                                                                                       TFJ11A
      ** Count Number of Records outputted in GLRODLPP
     C                   ADD       1             RCOUNT
     C                   MOVEL     DETAIL        JOTDL
     C****************** WRITE     GLRODLD0                                     JMI108
     C                   WRITE     XXRODLD0                                     JMI108

     C                   ENDSR

      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      **SRPutFTP*-*Setup*FTP*File Details on GLPSINPP******************         JMI108
      * SRPutFTP - Setup FTP File Details on XXPSINPP                 *         JMI108
      *                                                               *
      * Called by: Main Program                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRPutFTP      BEGSR

      ** Write user id for Transfer Request to PF/GLPSINPP
     C                   MOVEL     JUSER         USER
     C                   MOVEL     *BLANKS       @1
     C                   MOVEL     JPWORD        PASW
      *
     C                   CLEAR                   JSIDTA
     C                   MOVEL     @USRID        JSIDTA
     C****************** WRITE     GLPSIND0                                     JMI108
     C                   WRITE     XXPSIND0                                     JMI108
                                                                                              CHG001
      ** Write 'cd ..' transfer request to PF/GLPSINPP                                        CHG001
     C                   CLEAR                   JSIDTA                                       CHG001
     C                   MOVEL     'cd ..'       JSIDTA                                       CHG001
     C****************** WRITE     GLPSIND0                                     CHG001 JMI108
     C                   WRITE     XXPSIND0                                     JMI108

     C                   MOVEL     'PUT'         PUT
     C                   MOVEL     *BLANKS       @2
      *
     C                   MOVE      *BLANKS       PATH
      *
     C                   MOVEL     *BLANKS       @4
     C                   MOVEL     '/'           @3
      *
      ** Set up file name
     C                   MOVEL     JOTREC        File_Name
     C                   MOVEL     File_Name     FILNM
      *
     C                   MOVEA     JDIR          PATHA
     C                   Z-ADD     1             X                 2 0
     C     PATHA(X)      DOWNE     ' '
     C                   ADD       1             X
     C                   ENDDO
      *
     C**********         MOVE      '/'           PATHA(X)                                     CHG001
     C**********         ADD       1             X                                            CHG001
     C                   MOVEA     File_Name     PATHA(X)
      *
     C                   MOVEA     PATHA         PATH
      *
      ** Library name parameter
     C                   MOVE      Lib_Name      LIBNM
      *
      ** Output to file.
      *
     C                   CLEAR                   JSIDTA
     C                   MOVEL     @PUT          JSIDTA
     C****************** WRITE     GLPSIND0                                     JMI108
     C                   WRITE     XXPSIND0                                     JMI108

      ***Write*quit*for*transfer*request*to*PF/GLPSINPP********                 JMI108
      ** Write quit for transfer request to PF/XXPSINPP                         JMI108
     C                   CLEAR                   JSIDTA
     C                   MOVEL     'QUIT'        JSIDTA
     C****************** WRITE     GLPSIND0                                     JMI108
     C                   WRITE     XXPSIND0                                     JMI108

     C                   ENDSR

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
     C                   PARM                    Lib_Name          7
     C                   PARM                    File_Name        10

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
      ** Define data area for Pooling Account FTP details
     C**** *DTAARA       DEFINE                  SDPFTPDA                       JMI108
     C****               IN        SDPFTPDA                                     JMI108
     C     *DTAARA       DEFINE                  XXPFTPDA                       JMI108
     C                   IN        XXPFTPDA                                     JMI108
      *
      ** Obtain the FTP incoming times from the Pooling ICD
     C****************** CALL      'AOPICDR0'                                   JMI108
     C                   CALL      'XXPICDR0'                                   JMI108
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C**** SDPICD        PARM      SDPICD        DSSDY                          JMI108
     C     XXPICD        PARM      XXPICD        DSSDY                          JMI108

     C     PRtcd         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C****************** MOVEL     'SDPICDPP'    DBFILE                         JMI108
     C                   MOVEL     'XXPICDPP'    DBFILE                         JMI108
     C                   MOVEL     POptn         DBKEY                      ************
     C                   Z-ADD     001           DBASE                      * DBERR 001*
     C                   OUT       LDA                                      ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Set up Key Lists
     C     KJEIP         KLIST
     C                   KFLD                    KBTNB             3            Batch Number
     C                   KFLD                    KBINB             3 0          Batch Item Number
      *
      ** Set up Key Lists
     C     KEOD          KLIST
     C                   KFLD                    KBRCA             3            Branch
     C****************** KFLD                    KCNUM             6 0          Customer      JMI108
     C                   KFLD                    KCNUM             6            Customer      JMI108
     C                   KFLD                    KCCY              3            Currency
     C                   KFLD                    KACOD            10 0          Account Code
     C                   KFLD                    KACSQ             2 0          Account Sequence

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
     C                   EVAL      Ret_Code = 'DBASE'
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2018
