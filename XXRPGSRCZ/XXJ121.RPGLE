     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Pooling Accounts List MM')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      ***GLJ111*-*Midas*GL*Pooling Instructions Proof list -***********         EML110
      *  XXJ121 - Midas GL Pooling Instructions Proof list -          *         EML110
      *           Money Market                                        *
      *                                                               *
      *  Function:  This program reports the Pooling Instructions     *
      *             Proof list by Pooling File Sequence               *
      *                                                               *
      ***(c)*Misys*International*Banking*Systems*Ltd.*2007*************         EML110
      *  (c) Finastra International Limited 2018                      *         EML110
      *                                                               *
      *  Last Amend No. EML110             Date 20Jan20               *
      *  Prev Amend No. TFJ011  (CHG006)   Date 23Jan07               *
      *                 TFJ011  (CHG005)   Date 29Jul05               *
      *                 TFJ011  (CHG004)   Date 27Jul05               *
      *                 TFJ011  (CHG003)   Date 28Jun05               *
      *                 TFJ011  (CHG002)   Date 28Jun05               *
      *                 TFJ011  (CHG001)   Date 28Jun05               *
      *                 TFJ011  *CREATE    Date 21Mar05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  EML110 - Account Balance Pooling. Upgrade to FBM 2.1         *
      *  TFJ011 - (CHG006) No Details to report is outputted after    *
      *           an empty File Sequence                              *
      *  TFJ011 - (CHG005) Unnecessary fields are written             *
      *  TFJ011 - (CHG004) Program ends when there is no record in    *
      *           GLPLDTPP thus, other records are not reported       *
      *  TFJ011 - (CHG003) Problem on Indicator 38.                   *
      *  TFJ011 - (CHG002) Record is not found in GLPLDTPP but        *
      *           program still continues to print, thus Decimal      *
      *           Data Error                                          *
      *  TFJ011 - (CHG001) Retail Number is formatted as GL Account   *
      *  TFJ011 - Account Balance Pooling                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    35         Error in reading file GLPLDTV0                  *
      *    45         End of file for GLPLDTV0                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRPrint - Print details                                       *
      * SREnd   - Write trailer in report                             *
      * SRAudit - Write audit report                                  *
      * *INZSR  - Initialise                                          *
      * *PSSR   - Error processing                                    *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** SD Pooling Account Details
     F***GLPLDTV0  IF   E           K DISK    INFSR(*PSSR)                      EML110
     FXXPLDTV0  IF   E           K DISK    INFSR(*PSSR)                         EML110
      *
      ** SD Pooling Accounts Status
     F***SDPSTSV0  IF   E           K DISK    INFSR(*PSSR)                      EML110
     FXXPSTSV0  IF   E           K DISK    INFSR(*PSSR)                         EML110
     F                                     PREFIX(S_)
      *
      ** Pooling Account List printer file - Detail
     F***GLJ111P1  O    E             PRINTER INFDS(SPOOL1)                     EML110
     FXXJ121P1  O    E             PRINTER INFDS(SPOOL1)                        EML110
     F                                     USROPN
     F                                     INFSR(*PSSR)
      *
      ** Pooling Account List printer file - Audit
     F***GLJ111AU  O    E             PRINTER INFDS(SPOOLU)                     EML110
     FXXJ121AU  O    E             PRINTER INFDS(SPOOLU)                        EML110
     F                                     USROPN
     F                                     INFSR(*PSSR)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
      *
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** DS for access objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Externally described DS for Pooling Details
     D*** GLPLDT        E DS                  EXTNAME(GLPLDTV0)                 EML110
     D XXPLDT        E DS                  EXTNAME(XXPLDTV0)                    EML110
      *                                                                                       TFJ011
     D   WJDate                1      8                                                       TFJ011
     D   WJSchem               9     18                                                       TFJ011
     D   WTime                22     25                                                       TFJ011
     D   WISeq                26     28                                                       TFJ011
     D   WPool                32     32                                                       TFJ011
     D   WRev                 33     33                                                       TFJ011
     D   WVlDate              74     81                                                       TFJ011
     D   WDuDate              91     98                                                       TFJ011
     D   WRate                99    100                                                       TFJ011
     D   WDrAmt              176    183                                                       TFJ011
     D   WCrAmt              216    223                                                       TFJ011
      *                                                                                       TFJ011
     D***WJDate*               1      8                                                       TFJ011
     D***WJSchem               9     17                                                       TFJ011
     D***WTime**              18     21                                                       TFJ011
     D***WISeq**              22     24                                                       TFJ011
     D***WPool**              28     28                                                       TFJ011
     D***WRev***              29     29                                                       TFJ011
     D***WVlDate              79     86                                                       TFJ011
     D***WDuDate              87     94                                                       TFJ011
     D***WRate**              95     96                                                       TFJ011
     D***WDrAmt*             167    174                                                       TFJ011
     D***WCrAmt*             203    210                                                       TFJ011
      *
      ***File*Information*Data*Structure*for*GLJ111P1.*********                 EML110
      ** File Information Data Structure for XXJ121P1.                          EML110
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0
      *
      ***File*Information*Data*Structure*for*GLJ111P1.*********                 EML110
      ** File Information Data Structure for XXJ121P1.                          EML110
     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0
      *
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  ErrorOnFl             35     35
     D  EndOfFile             45     45
      *
     D WRKDAT          DS
     D   WCC                   1      2
     D   WYY                   3      4
     D   WMM                   5      6
     D   WDD                   7      8
      *
     D WRKTIM          DS
     D   WHH                   1      2
     D   W1                    3      3
     D   WMIN                  4      5
      *
      ** Data Structure for Account
     D                 DS
     D  RACCOUNT               1     28                                                       TFJ011
     D**RACCOUNT               1     22                                                       TFJ011
     D   WBRCA                 1      3
     D   DASH1                 4      4
     D   WCNUM                 5     10
     D   DASH2                11     11
     D   WCCY                 12     14
     D   DASH3                15     15
     D   WACOD                16     25                                                       TFJ011
     D   DASH4                26     26                                                       TFJ011
     D   WACSQ                27     28                                                       TFJ011
     D   WATRSK               26     28                                                       TFJ011
      *                                                                                       TFJ011
     D***WACOD**              16     19                                                       TFJ011
     D***DASH4**              20     20                                                       TFJ011
     D***WACSQ**              21     22                                                       TFJ011
     D***WATRSK*              20     22                                                       TFJ011
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Named constants             ¦
      ** ¦ =======  ===============             ¦
      ** +--------------------------------------+
      *
      ** True and False can be used for indicators being on or off.
     D True            C                   *On
     D False           C                   *Off
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
      *
      ** Parameters for ZDATE9
     D ZDayNo          S              5P 0
     D ZDateOut        S              8S 0
     D ZReturn         S              1A
      *
      ** Parameters for ZSFILE
     D PSeq            S              5
     D SEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1
      *
      ** Parameters for access object programs
     D PRtcd           S              7
     D POptn           S              7
      *
      ** Parameter list fields
     D PMode           S              1
     D PLevl           S              1
     D PEnty           S              3
     D PAPSeq          S              3
      *
      ** Other fields used
     D WRun            S              1
     D WOpen           S              1    INZ('N')
     D WFirst          S              1    INZ('Y')
     D WNoRec          S              5  0 INZ(0)
     D RqdLn1          S              3  0
     D DifLn1          S              3  0
      *
     D ZFld15          S             15  0
     D ZDecs           S              1  0
     D ZEcode          S              1
     D ZOut21          S             21
     D @CYCD           S              3
      *
     D KSeq            S              3
     D KRcv            S              1    INZ('R')
     D DateNum         S              8  0
     D WJSEQ           S              3    INZ(' ')
     D WJSEQ2          S              3    INZ(' ')
     D WNBDP           S              1  0 INZ(0)
      ** Array containing Account number
     D ARRACCT         S              1    DIM(24)                                            TFJ011
     D*ARRACCT**       S              1    DIM(18)                                            TFJ011
     D ARRBRCA         S              1    DIM(3)
     D ARRCNUM         S              1    DIM(6)
     D ARRCCY          S              1    DIM(3)
     D ARRACOD         S              1    DIM(10)                                            TFJ011
     D*ARRACOD**       S              1    DIM(4)                                             TFJ011
     D ARRACSQ         S              1    DIM(2)
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** If no File Sequence number passed
     C     PAPSeq        IFEQ      *BLANKS
     C                   EVAL      *IN40 = '1'
      *
     C**** *LOVAL        SETLL     SDPSTSV0                                     EML110
     C****               READ      SDPSTSV0                               46    EML110
     C     *LOVAL        SETLL     XXPSTSV0                                     EML110
     C                   READ      XXPSTSV0                               46    EML110
     C                   MOVE      S_JNUM        WJSEQ
      *
     C                   IF        *IN46 = *ON
      ** End Program
     C                   EXSR      SRAudit
     C                   EVAL      *INLR ='1'
     C                   RETURN
     C                   ENDIF
      *
     C                   Z-ADD     0             StsCount          1 0
     C                   DOW       *IN46 = *OFF
     C                   IF        S_JNUM <> WJSEQ
     C                   MOVE      S_JNUM        WJSEQ
     C                   ENDIF
      *
     C     S_JINST       IFEQ      '002'
     C     S_JTYPE       ANDEQ     'R'
     C                   EVAL      StsCount = 1
     C                   EVAL      WNoRec = 0
      *
     C**** S_JNUM        SETLL     GLPLDTV0                                     EML110
     C**** S_JNUM        READE     GLPLDTV0                             3545    EML110
     C     S_JNUM        SETLL     XXPLDTV0                                     EML110
     C     S_JNUM        READE     XxPLDTV0                             3545    EML110
      *
      ** Database error
      *
     C                   IF        ErrorOnFl = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*FIRST'
     C****************** EVAL      DBFile = 'GLPLDTV0'                          EML110
     C                   EVAL      DBFile = 'XXPLDTV0'                          EML110
     C                   EVAL      DBase = 005
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   If        EndOfFile = False                                          CHG002
     C                   DOW       EndOfFile = False
      *
      ** Process Report Lines only for records with Transaction type = 002
      *
     C     JTYPE         IFEQ      '002'
      *
      ** Count no. of records processed.
      *
     C                   EVAL      WNoRec = WNoRec + 1
     C                   EXSR      SRPrint
      *
     C                   ENDIF
      ** Read next record.
      *
     C**** S_JNUM        READE     GLPLDTV0                             3545    EML110
     C     S_JNUM        READE     XXPLDTV0                             3545    EML110
      *
     C                   IF        ErrorOnFl = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*NEXT'
     C****************** EVAL      DBFile = 'GLPLDTV0'                          EML110
     C                   EVAL      DBFile = 'XXPLDTV0'                          EML110
     C                   EVAL      DBase = 006
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDDO
      ** If no records on Pooling Details file                                                CHG004
     C                   ELSE                                                                 CHG004
     C                   EXSR      SRPrint1                                                   CHG004
     C                   ENDIF                                                                CHG002
      ** If no records on Pooling Details file
     C**********         IF        WNoRec = 0                                                 CHG004
     C**********         EXSR      SRPrint                                                    CHG004
     C**********         ENDIF                                                                CHG004
     C                   ENDIF
      *
     C****************** READ      SDPSTSV0                               46    EML110
     C                   READ      XXPSTSV0                               46    EML110
     C                   ENDDO
     C**********         IF        WNoRec = 0                                          CHG004 CHG006
     C                   IF        (WNoRec = 0) and (RSEQ = *Blanks)                          CHG006
     C                   EVAL      S_JNUM = *BLANKS                                           CHG005
     C                   EVAL      S_JINST = *BLANKS                                          CHG005
     C                   EVAL      S_JIBRCH = *BLANKS                                         CHG005
     C                   EXSR      SRPrint                                                    CHG004
     C                   ENDIF                                                                CHG004
      *
     C                   ELSE
     C                   EVAL      *IN40 = '0'
      ** File Sequence number passed
     C                   EVAL      KSeq = PAPSeq
     C**** KSeqRcv       CHAIN     SDPSTSV0                           39        EML110
     C     KSeqRcv       CHAIN     XXPSTSV0                           39        EML110
      *
     C                   IF        *IN39 = *ON
      ** End Program
     C                   EXSR      SRAudit
     C                   EVAL      *INLR ='1'
     C                   RETURN
     C                   ENDIF
      *
     C     *IN39         IFEQ      *OFF
     C     S_JINST       IFEQ      '002'
     C     S_JTYPE       ANDEQ     'R'
     C                   EVAL      StsCount = 1
      *
     C**** S_JNUM        SETLL     GLPLDTV0                                     EML110
     C**** S_JNUM        READE     GLPLDTV0                             3545    EML110
     C     S_JNUM        SETLL     XXPLDTV0                                     EML110
     C     S_JNUM        READE     XXPLDTV0                             3545    EML110
      *
      ** Database error
      *
     C                   IF        ErrorOnFl = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*FIRST'
     C****************** EVAL      DBFile = 'GLPLDTV0'                          EML110
     C                   EVAL      DBFile = 'XXPLDTV0'                          EML110
     C                   EVAL      DBase = 007
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   If        EndOfFile = False                                          CHG002
     C                   DOW       EndOfFile = False
      *
      ** Process Report Lines only for records with Transaction type = 002
      *
     C     JTYPE         IFEQ      '002'
      *
      ** Count no. of records processed.
      *
     C                   EVAL      WNoRec = WNoRec + 1
     C                   EXSR      SRPrint
      *
     C                   ENDIF
      ** Read next record.
      *
     C**** S_JNUM        READE     GLPLDTV0                             3545    EML110
     C     S_JNUM        READE     XXPLDTV0                             3545    EML110
      *
     C                   IF        ErrorOnFl = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*NEXT'
     C****************** EVAL      DBFile = 'GLPLDTV0'                          EML110
     C                   EVAL      DBFile = 'XXPLDTV0'                          EML110
     C                   EVAL      DBase = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDDO
     C                   ENDIF                                                                CHG002
      ** If no records on Pooling Details file
     C                   IF        WNoRec = 0
     C                   EXSR      SRPrint
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
     C                   EXSR      SREnd
      *
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrnt - Print details                                       *
      *                                                               *
      *****************************************************************

     C     SRPrint       BEGSR

     C                   CLEAR                   DETAIL
     C                   CLEAR                   HEADP2
     C                   IF        WOpen <> 'Y'
     C                   EVAL      WOpen = 'Y'
     C****************** OPEN      GLJ111P1                                     EML110
     C                   OPEN      XXJ121P1                                     EML110
      *
      ** Ensure Detail Spool File recorded by RCF.
      *
     C                   EVAL      ZSnum = SFNUM1
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       SEnty
     C                   PARM                    SFILE1
     C                   PARM                    ZSnum
     C                   PARM      *Blank        ZSerr
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** File Sequence
     C                   EVAL      RSEQ = S_JNUM
      ** Transaction Type
     C                   EVAL      RTYPE = S_JINST
      *
      ** Transaction Type Description
     C                   IF        RTYPE = '002'
     C                   EVAL      RTypDesc = 'SWEEP'
     C                   ENDIF
      *
      ** Receiver's Internal Branch
     C                   EVAL      RIBRCH = S_JIBRCH
      *
      ** If details found on first read of the file
     C**********         IF        *IN38 = *OFF                                               CHG003
     C                   IF        WNoRec > 0                                                 CHG003
      *
     C                   EVAL      RqdLn1 = 1
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
      *
     C                   IF        DifLn1 <= RqdLn1 OR
     C                             DifLn1 <= 7 OR
     C                             WFirst = 'Y' OR
     C                             S_JNUM <> WJSEQ2
     C                   WRITE     HEADP1
     C                   MOVE      S_JNUM        WJSEQ2
     C                   WRITE     HEADP2
     C                   EVAL      WFIRST = 'N'
     C                   ENDIF
      *
      ** Write details to printer fields.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     POptn         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Get Dates
     C                   EXSR      GetDates
      *
      ** Execution time
     C                   IF        WTime <> *BLANKS
     C                   MOVE      JHH           WHH
     C                   MOVE      JMIN          WMIN
     C                   MOVE      ':'           W1
     C                   MOVE      WRKTIM        RHHMM
     C                   ENDIF
      *
      ** Scheme Number
     C                   EVAL      RSCHEM = JSCHEM
      *
      ** Scheme Name
     C                   EVAL      RSCHNAM = JSCHMN
      *
      ** Instruction Sequence
     C                   MOVE      JISEQ         RISEQ
      *
      ** Status Code
     C                   EVAL      RSTAT = JSTAT
      *
      ** Base Rate Code
     C                   MOVE      JRATE         RRATE
      *
      ** Debit Accounting Code
     C                   EVAL      RDACOD = JDACOD
      *
      ** Credit Accounting Code
     C                   EVAL      RCACOD = JCACOD
      *
      ** Spread
     C                   MOVE      JSPRD         RSPRD
      *
      ** Calculation Method
     C                   EVAL      RCALC = JCALC
      *
      ** Debit Currency
     C                   MOVEL     JDCCY         RDCCY
     C     JDCYER        IFEQ      'Y'
     C                   MOVE      '***'         RDCCY
     C                   ENDIF
      *
      ** Credit Currency
     C                   MOVEL     JCCCY         RCCCY
     C     JCCYER        IFEQ      'Y'
     C                   MOVE      '***'         RCCCY
     C                   ENDIF
      *
      ** Debit Internal Branch Code
     C                   EVAL      RDBRCH = JDBRCH
      *
      ** Credit Internal Branch Code
     C                   EVAL      RCBRCH = JCBRCH
      *
      ** Remarks
     C                   EVAL      RREMK = JREMK
      *
      ** Debit Account Number
      *  this value goes to Receipt column
     C                   EXSR      SRDACNO
      *
      ** Credit Account Number
      *  payment account on incoming details will always be blank,
      *  therefore, value of this field will be the same as that of
      *  the Receipt column
     C                   EXSR      SRCACNO
      *
      ** Result Code
     C                   EVAL      RREST = JREST
      *
      ** Debit Amount
     C                   IF        WDrAmt <> *BLANKS
     C                   EVAL      @CYCD = *BLANKS
     C                   EVAL      @CYCD = JDCCY
     C                   EXSR      SRCurDec
     C                   Z-ADD     JDAMT         ZFld15
     C                   EVAL      ZDecs = WNBDP
     C                   EXSR      SRFmtAmt
     C                   MOVE      ZOut21        RDAMT
     C                   ENDIF
      *
      * Flag if 14 or 15 long
     C                   IF        JDAMER = 'Y'
     C                   MOVE      '***'         RDAME
     C                   ELSE
     C                   MOVE      '   '         RDAME
     C                   ENDIF
      *
      ** Credit Amount
     C                   IF        WCrAmt <> *BLANKS
     C                   EVAL      @CYCD = *BLANKS
     C                   EVAL      @CYCD = JCCCY
     C                   EXSR      SRCurDec
     C                   Z-ADD     JCAMT         ZFld15
     C                   EVAL      ZDecs = WNBDP
     C                   EXSR      SRFmtAmt
     C                   MOVE      ZOut21        RCAMT
     C                   ENDIF
      *
      * Flag if 14 or 15 long
     C                   IF        JCAMER = 'Y'
     C                   MOVE      '***'         RCAME
     C                   ELSE
     C                   MOVE      '   '         RCAME
     C                   ENDIF
      *
      ** Write Detail
      *
     C                   IF        WNoRec <> 0
     C                   WRITE     DETAIL
     C                   ELSE
     C                   WRITE     NODTLS
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If no details found on first read of the file
      *
     C**********         IF        *IN38 = *ON                                                CHG003
     C                   IF        WNoRec = 0                                                 CHG003
      *
     C                   WRITE     HEADP1
     C                   WRITE     HEADP2
     C                   WRITE     NODTLS
     C                   WRITE     TRAILP1
      *
      ** End Program
     C                   EVAL      *INLR ='1'
     C                   RETURN
     C                   ENDIF

     C                   ENDSR
      *
      /EJECT
      *****************************************************************                       CHG004
      *                                                               *                       CHG004
      *  SRPrint1 - Print No Details                                  *                       CHG004
      *                                                               *                       CHG004
      *****************************************************************                       CHG004
                                                                                              CHG004
     C     SRPrint1      BEGSR                                                                CHG004
                                                                                              CHG004
     C                   CLEAR                   DETAIL                                       CHG004
     C                   CLEAR                   HEADP2                                       CHG004
     C                   IF        WOpen <> 'Y'                                               CHG004
     C                   EVAL      WOpen = 'Y'                                                CHG004
     C****************** OPEN      GLJ111P1                                            CHG004 EML110
     C                   OPEN      XXJ121P1                                                   EML110
      *                                                                                       CHG004
      ** Ensure Detail Spool File recorded by RCF.                                            CHG004
      *                                                                                       CHG004
     C                   EVAL      ZSnum = SFNUM1                                             CHG004
      *                                                                                       CHG004
     C                   CALL      'ZSFILE'                                                   CHG004
     C                   PARM                    PSeq                                         CHG004
     C                   PARM      *Blanks       SEnty                                        CHG004
     C                   PARM                    SFILE1                                       CHG004
     C                   PARM                    ZSnum                                        CHG004
     C                   PARM      *Blank        ZSerr                                        CHG004
      *                                                                                       CHG004
      ** If Error occurs during ZSFILE processing, then return to the                         CHG004
      ** Calling Program.                                                                     CHG004
      *                                                                                       CHG004
     C     ZSERR         IFEQ      'Y'                                                        CHG004
     C                   SETON                                        U7U8LR                  CHG004
     C                   RETURN                                                               CHG004
     C                   ENDIF                                                                CHG004
      *                                                                                       CHG004
     C                   ENDIF                                                                CHG004
      *                                                                                       CHG004
      ** File Sequence                                                                        CHG004
     C                   EVAL      RSEQ = S_JNUM                                              CHG004
      ** Transaction Type                                                                     CHG004
     C                   EVAL      RTYPE = S_JINST                                            CHG004
      *                                                                                       CHG004
      ** Transaction Type Description                                                         CHG004
     C                   IF        RTYPE = '002'                                              CHG004
     C                   EVAL      RTypDesc = 'SWEEP'                                         CHG004
     C                   ENDIF                                                                CHG004
      *                                                                                       CHG004
      ** Receiver's Internal Branch                                                           CHG004
     C                   EVAL      RIBRCH = S_JIBRCH                                          CHG004
                                                                                              CHG004
      *                                                                                       CHG004
      ** If no details found on first read of the file                                        CHG004
      *                                                                                       CHG004
      *                                                                                       CHG004
     C                   WRITE     HEADP1                                                     CHG004
     C                   WRITE     HEADP2                                                     CHG004
     C                   WRITE     NODTLS                                                     CHG004
                                                                                              CHG004
     C                   ENDSR                                                                CHG004
      *                                                                                       CHG004
      /EJECT                                                                                  CHG004
      *****************************************************************
      *                                                               *
      *  SRDACNO - determine debit accounting code                    *
      *                                                               *
      *****************************************************************
     C     SRDACNO       BEGSR

     C                   CLEAR                   ARRACCT
      *
     C                   SELECT
     C                   WHEN      RDACOD = '0'
     C                   MOVEL     JDACNO        RDACNO
     C                   IF        JDACER = 'Y'
     C                   MOVE      '***'         RDACNO
     C                   ENDIF
      *
     C                   WHEN      RDACOD = '1'
     C                   MOVEA     JDACNO        ARRACCT
      *
     C                   IF        ARRACCT(11) = ' '
     C                   EVAL      RDACNO =  JDACNO
     C                   ELSE
     C                   EXSR      SRFMTGL
     C                   EVAL      RDACNO =  RACCOUNT
     C                   ENDIF
     C                   IF        JDACER = 'Y'
     C                   MOVE      *BLANKS       RDACNO
     C                   MOVE      '***'         RDACNO
     C                   ENDIF
      *
     C                   WHEN      RDACOD = '2'
     C                   MOVEA     JDACNO        ARRACCT
      *                                                                                       CHG001
     C                   IF        ARRACCT(11) = ' '                                          CHG001
     C                   EVAL      RDACNO =  JDACNO                                           CHG001
     C                   ELSE                                                                 CHG001
     C                   EXSR      SRFMTGL
     C                   EVAL      RDACNO =  RACCOUNT
     C                   ENDIF                                                                CHG001
     C                   IF        JDACER = 'Y'
     C                   MOVE      *BLANKS       RDACNO
     C                   MOVE      '***'         RDACNO
     C                   ENDIF
      *
     C                   ENDSL
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCACNO - determine credit accounting code                   *
      *                                                               *
      *****************************************************************
     C     SRCACNO       BEGSR

     C                   CLEAR                   ARRACCT
      *
     C                   SELECT
     C                   WHEN      RDACOD = '0'
     C                   MOVEL     JDACNO        RCACNO
     C                   IF        JDACER = 'Y'
     C                   MOVE      '***'         RCACNO
     C                   ENDIF
      *
     C                   WHEN      RDACOD = '1'
     C                   MOVEA     JDACNO        ARRACCT
      *
     C                   IF        ARRACCT(11) = ' '
     C                   EVAL      RCACNO =  JDACNO
     C                   ELSE
     C                   EXSR      SRFMTGL
     C                   EVAL      RCACNO =  RACCOUNT
     C                   ENDIF
     C                   IF        JDACER = 'Y'
     C                   MOVE      *BLANKS       RCACNO
     C                   MOVE      '***'         RCACNO
     C                   ENDIF
      *
     C                   WHEN      RDACOD = '2'
     C                   MOVEA     JDACNO        ARRACCT
      *                                                                                       CHG001
     C                   IF        ARRACCT(11) = ' '                                          CHG001
     C                   EVAL      RCACNO =  JDACNO                                           CHG001
     C                   ELSE                                                                 CHG001
     C                   EXSR      SRFMTGL
     C                   EVAL      RCACNO =  RACCOUNT
     C                   ENDIF                                                                CHG001
     C                   IF        JDACER = 'Y'
     C                   MOVE      *BLANKS       RCACNO
     C                   MOVE      '***'         RCACNO
     C                   ENDIF
      *
     C                   ENDSL
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFMTGL - Format GL Account                                  *
      *                                                               *
      *****************************************************************
     C     SRFMTGL       BEGSR
     C                   CLEAR                   RACCOUNT
     C                   EVAL      DASH1 = '-'
     C                   EVAL      DASH2 = '-'
     C                   EVAL      DASH3 = '-'
     C                   EVAL      DASH4 = '-'
     C                   Z-ADD     1             X                 2 0
     C                   Z-ADD     0             Y                 1 0
     C                   EVAL      Y = 1
     C                   DOU       X = 4
     C                   MOVEA     ARRACCT(X)    ARRBRCA(Y)
     C                   EVAL      X = X + 1
     C                   EVAL      Y = Y + 1
     C                   ENDDO
     C                   IF        JDACER <> 'Y' OR
     C                             JCACER <> 'Y'
     C                   MOVEA     ARRBRCA       WBRCA
     C                   ELSE
     C                   IF        JDACOD = '1' OR
     C                             JCACOD = '1'
     C                   MOVEA     ARRBRCA       WBRCA
     C                   ENDIF
     C                   IF        JDACOD = '2' OR
     C                             JCACOD = '2'
     C                   MOVE      *BLANKS       WBRCA
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      Y = 1
     C                   DOU       X = 10
     C                   MOVEA     ARRACCT(X)    ARRCNUM(Y)
     C                   EVAL      X = X + 1
     C                   EVAL      Y = Y + 1
     C                   ENDDO
     C                   IF        JDACER <> 'Y' OR
     C                             JCACER <> 'Y'
     C                   MOVEA     ARRCNUM       WCNUM
     C                   ELSE
     C                   MOVE      *BLANKS       WCNUM
     C                   ENDIF
     C                   EVAL      Y = 1
     C                   DOU       X = 13
     C                   MOVEA     ARRACCT(X)    ARRCCY(Y)
     C                   EVAL      X = X + 1
     C                   EVAL      Y = Y + 1
     C                   ENDDO
     C                   MOVEA     ARRCCY        WCCY
     C                   EVAL      Y = 1
     C                   DOU       X = 17
     C                   MOVEA     ARRACCT(X)    ARRACOD(Y)
     C                   EVAL      X = X + 1
     C                   EVAL      Y = Y + 1
     C                   ENDDO
     C                   IF        JDACER <> 'Y' OR
     C                             JCACER <> 'Y'
     C                   MOVEA     ARRACOD       WACOD
     C                   ELSE
     C                   MOVE      *BLANKS       WACOD
     C                   ENDIF
     C                   EVAL      Y = 1
     C                   DOU       X = 19
     C                   MOVEA     ARRACCT(X)    ARRACSQ(Y)
     C                   EVAL      X = X + 1
     C                   EVAL      Y = Y + 1
     C                   ENDDO
     C                   IF        JDACER <> 'Y' OR
     C                             JCACER <> 'Y'
     C                   MOVEA     ARRACSQ       WACSQ
     C                   ELSE
     C                   MOVE      *BLANKS       WACSQ
     C                   ENDIF
     C                   IF        JDACER = 'Y' OR
     C                             JCACER = 'Y'
     C                   MOVE      '***'         WATRSK
     C                   ENDIF
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCurDec - determine currency number of decimal places       *
      *                                                               *
      *****************************************************************
     C     SRCurDec      BEGSR
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    @CYCD
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     PRtcd         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = @CYCD
     C                   EVAL      DBFile = 'SDCURRPD'
     C                   EVAL      DBase = 004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WNBDP = A6NBDP
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtAmt - format amount based on currency                   *
      *                                                               *
      *****************************************************************
     C     SRFmtAmt      BEGSR

     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFld15
     C                   PARM                    ZDecs
     C                   PARM      'J'           ZEcode
     C                   PARM      *BLANK        ZOut21
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  GetDates- Process dates                                      *
      *                                                               *
      *****************************************************************
     C     GetDates      BEGSR
      * Scheme Date
     C                   IF        WJDate <> *BLANKS
     C                   EVAL      WRKDAT = *BLANKS
     C                   MOVE      JCC           WCC
     C                   MOVE      JYY           WYY
     C                   MOVE      JMM           WMM
     C                   MOVE      JDD           WDD
     C                   MOVE      WRKDAT        DateNum
     C                   EVAL      RSCHDAT = DateNum
     C                   ENDIF
      *
      * Value Date
     C                   IF        WVlDate <> *BLANKS
     C                   EVAL      WRKDAT = *BLANKS
     C                   MOVE      JVCC          WCC
     C                   MOVE      JVYY          WYY
     C                   MOVE      JVMM          WMM
     C                   MOVE      JVDD          WDD
     C                   MOVE      WRKDAT        DateNum
     C                   EVAL      RVALDAT = DateNum
     C                   ENDIF
      *
      * Due Date
     C                   IF        WDuDate <>  *BLANKS
     C                   EVAL      WRKDAT = *BLANKS
     C                   MOVE      JDCC          WCC
     C                   MOVE      JDYY          WYY
     C                   MOVE      JDMM          WMM
     C                   MOVE      JDDD          WDD
     C                   MOVE      WRKDAT        DateNum
     C                   EVAL      RDUEDAT = DateNum
     C                   ENDIF
      *
      * Creation Date
     C                   IF        WJDate <> *BLANKS
     C                   EVAL      WRKDAT = *BLANKS
     C                   MOVE      JCCC          WCC
     C                   MOVE      JCYY          WYY
     C                   MOVE      JCMM          WMM
     C                   MOVE      JCDD          WDD
     C                   MOVE      WRKDAT        DateNum
     C                   EVAL      RCREADT = DateNum
     C                   ENDIF

     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREnd - Write trailer in report                              *
      *                                                               *
      *****************************************************************

     C     SREnd         BEGSR
      *
     C                   IF        StsCount <= 0
     C****************** OPEN      GLJ111AU                                     EML110
     C                   OPEN      XXJ121AU                                     EML110
     C                   WRITE     HEADAU
     C                   WRITE     NODTLS2
     C                   WRITE     TRAILAU
     C                   ELSE
      *
     C                   EVAL      RqdLn1 = 4
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
      *
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
     C                   WRITE     TRAILP1
     C                   ENDIF
      *
      ** End Program
      *
     C                   EVAL      *INLR ='1'
     C                   RETURN


     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Write audit report                                 *
      *                                                               *
      *****************************************************************

     C     SRAudit       BEGSR
      *
     C****************** OPEN      GLJ111AU                                     EML110
     C                   OPEN      XXJ121AU                                     EML110
      *
      ** Ensure Audit Spool File recorded by RCF.
      *
     C                   EVAL      ZSnumU = SFNUMU
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       SEnty
     C                   PARM                    SFILEU
     C                   PARM                    ZSnumU
     C                   PARM      *Blank        ZSerr
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
      *
     C                   WRITE     HEADAU
      *
      ** If there is a DB Error, Output the DB Error Information.
      *
     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ELSE
      *
     C                   IF        WNoRec = 0
      *
      ** Or, if no records read, Output "No Details" message.
      *
     C                   WRITE     NODTLS2
     C                   WRITE     TRAILAU
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   EVAL      *INLR ='1'
     C                   RETURN

     C                   ENDSR
      *
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
      *
     C     *ENTRY        PLIST
     C                   PARM                    PAPSeq
     C                   PARM                    PSeq
     C                   PARM                    PLevl
     C                   PARM                    PEnty
      *
     C     *DTAARA       DEFINE                  LDA
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error.
      *
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Report Work fields.
      *
     C                   EVAL      RqdLn1 = 0
     C                   EVAL      DifLn1 = 0
     C                   EVAL      PRTLN1 = 0

     C     KSeqRcv       KLIST
     C                   KFLD                    KSeq
     C                   KFLD                    KRcv

     C**********         EVAL      *IN38 = *OFF                                               CHG003
      *
     C                   ENDSR
      *
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

     C     *PSSR         BEGSR

     C                   IF        WRun = *Blank
     C                   EVAL      WRun = 'Y'
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
     C                   DUMP
     C                   EXSR      SRAudit
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2018
