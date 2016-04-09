     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Submit Forward Account Transfer')             *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL004604 - Midas GL Submit Forward Account Transfers         *
      *                                                               *
      *  Function:  This program will submit forward account          *
      *             transfers that are due for next CoB run for       *
      *             PDC validation.                                   *
      *                                                               *
      *  Called By: GLC004604 - Submit Forward Account                *
      *                         Transfers Control                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. AR1075388          Date 21Nov13               *
      *  Prev Amend No. AR845655           Date 06Oct11               *
      *                 CRE067             Date 05Oct10               *
      *                 BUG28072A          Date 29Aug10               *
      *                 BUG28072           Date 26Aug10               *
      *                 BUG28036           Date 16Aug10               *
      *                 BUG27831B          Date 09Aug10               *
      *                 BUG27831A *CREATE  Date 03Aug10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1075388 - Account transfer fees - net (Child:AR1075389)    *
      *              Applied for MD-23536 (Recompile)                 *
      *  AR845655 - Update datatype of Paying Bank to Alphanumeric    *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  BUG28072A - Remove MQ user and password in AOSVALR0          *
      *  BUG28072 - Password not needed for MQ. User authentication   *
      *             was removed.                                      *
      *  BUG28036 - Only send forward transfers with value date       *
      *             within the period of balances                     *
      *  BUG27831B - Define Messge Queue Manager                      *
      *  BUG27831A - Forward Account Transfer Processing              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRWrtExtract - List records sent to an extract file          *
      *  SRSetWIPMsg - Set GLATMIPD WIP message                       *
      *  SRFmtWMsg - Format the WIP message                           *
      *  SRPutMQIO - Put message to MQ Series queue                   *
      *  SRGetDecimal - Get number of decimal places for given ccy    *
      *  SRBlanks - Blank out field details                           *
      * *PSSR    - Error processing                                   *
      * *INZSR   - Initialise                                         *
      *                                                               *
      *****************************************************************
 
     F*GLATMIL6*IF   E           K DISK    INFSR(*PSSR)                                     BUG28036
     FGLATMIL5  IF   E           K DISK    INFSR(*PSSR)                                     BUG28036
      ** GL Account Transfer Manual Input File
 
     FSDABCIPD  IF   E           K DISK    INFSR(*PSSR)
      ** Retail Account Balance Check ICD File
 
     F*GLFTRVPD*O    E             DISK    RENAME(GLFTRVD0:GLFTRVF) INFSR(*PSSR)            BUG28036
     F**********                           PREFIX(O_)                                       BUG28036
     FGLFTRVL2  UF   E           K DISK    INFSR(*PSSR) COMMIT                              BUG28036
      ** GL Forward Transfer List File
 
      *****************************************************************
      /EJECT
      *****************************************************************
     D LDA           E DS           256    EXTNAME(LDA)
 
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** External DS for General Ledger Details
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank ICD Details
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      **  External data structures for Currency Details
 
     D***GLFTRV        E DS                  EXTNAME(GLFTRVPD:*OUTPUT)                      BUG28036
      **  External data structures for Forward Transfer List
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long Data Structure for Access Programs
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short Data Structure for Access Programs
 
     D ArrCcy          S              3A   DIM(100)
     D ArrDec          S              1  0 DIM(100)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PRtCd           S              7
     D POptn           S              7
     D PKey            S              3
     D PErrMsg         S             30A
     D PRequest        S             10A
     D PQueueNm        S             48A
     D PMQMgr          S             48A                                                   BUG27831B
     D PMsgBuf         S          32000A
     D P@Key           S              4A
     D PMode           S             10A
     D PAPIName        S            100A
     D Pformat         S            100A
     D PfldTag         S             10A
     D PfldData        S           1000A
     D PfldType        S             10A
     D PfldAttr        S             10A
 
     D                 DS
     D PGlobal                 1      2
     D PZonal                 18     19
     D PWipQueue               1     48
 
     D P@OP01          S             20
     D P@VL01          S            200
     D P@OP02          S             20
     D P@VL02          S            200
     D P@OP03          S             20
     D P@VL03          S            200
     D P@OP04          S             20
     D P@VL04          S            200
     D P@OP05          S             20
     D P@VL05          S            200
     D P@OP06          S             20
     D P@VL06          S            200
     D P@OP07          S             20
     D P@VL07          S            200
     D P@OP08          S             20
     D P@VL08          S            200
     D P@OP09          S             20
     D P@VL09          S            200
     D P@OP10          S             20
     D P@VL10          S            200
 
     D WRun            S              1
     D X               S              3  0
     D WkCcy           S              3A
     D WkFeeCcyEq      S              3A
     D WCtrDt          S              5P 0
     D WCcyCounter     S              3  0 INZ(0)
     D WkRespQ         S             40
     D WkMQUsr         S             20
     D WkMQUsrP        S             20
     D WkMQMgr         S             48                                                    BUG27831B
 
     D ZFLD15          S             15  0
     D ZDECS           S              1  0
     D ZECODE          S              1
     D ZOUT21          S             21
 
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
      *********************************************************************                 BUG28036
     C**********         EVAL      WCtrDt = BJDNWD - 1                                      BUG28036
      *********************************************************************                 BUG28036
     C**********         IF        WCtrDt > BKAPDT                                          BUG28036
     C**********         EVAL      WCtrDt = BKAPDT                                          BUG28036
     C**********         ENDIF                                                              BUG28036
      *********************************************************************                 BUG28036
     C**********         READ      SDABCIPD                                                 BUG28036
     C**********         IF        ABTFDR <> 4                                              BUG28036
     C**********                   OR ABTFCR <> 4                                           BUG28036
      *********************************************************************                 BUG28036
     C******LOVAL        SETLL     GLATMIL6                                                 BUG28036
     C**********         READ      GLATMIL6                                                 BUG28036
      *********************************************************************                 BUG28036
      ***Process*only*records*that*are*due*for*next*CoB*run.***************                 BUG28036
      *********************************************************************                 BUG28036
     C**********         DOW       NOT %EOF( GLATMIL6 )                                     BUG28036
     C**********                   AND R1EXDT <= WCtrDt                                     BUG28036
                                                                                            BUG28036
     C     *LOVAL        SETLL     GLFTRVL2                                                 BUG28036
     C                   READ      GLFTRVL2                                                 BUG28036
     C                   DOW       NOT %EOF(GLFTRVL2)                                       BUG28036
                                                                                            BUG28036
     C     KyATMI        CHAIN     GLATMIL5                                                 BUG28036
     C                   IF        NOT %FOUND(GLATMIL5)                                     BUG28036
     C                   MOVEL     'GLATMIPD'    DBFILE                                     BUG28036
     C                   Z-ADD     1             DBASE                                      BUG28036
     C                   MOVEL     TRTREF        DBKEY                                      BUG28036
     C                   EXSR      *PSSR                                                    BUG28036
     C                   ENDIF                                                              BUG28036
 
     C                   IF        R1RECI = 'D'
     C                   EXSR      SRSetWIPMsg
 
      ** Send message to MQ series queue
 
     C                   EVAL      PRequest = '*OPEN_PUT'
     C                   EXSR      SRPutMQIO
 
     C                   EVAL      PRequest = '*PUT'
     C                   EXSR      SRPutMQIO
 
     C                   EVAL      PRequest = '*CLOSE'
     C                   EXSR      SRPutMQIO
 
     C**********         EXSR      SRWrtExtract                                             BUG28036
     C                   EVAL      TRTSNT = 'Y'                                             BUG28036
     C                   UPDATE    GLFTRVD0                                                 BUG28036
     C                   COMMIT                                                             BUG28036
     C                   ENDIF
 
     C**********         READ      GLATMIL6                                                 BUG28036
     C                   READ      GLFTRVL2                                                 BUG28036
     C                   ENDDO
     C**********         ENDIF                                                              BUG28036
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************                     BUG28036
      ***SRWrtExtract*-*List*records*sent*to*an*extract*file***********                     BUG28036
      *****************************************************************                     BUG28036
      *****************************************************************
     C*****SRWrtExtract  BEGSR                                                              BUG28036
      *****************************************************************                     BUG28036
     C**********         EVAL      TRTREF = R1TREF                                          BUG28036
     C**********         EVAL      TREXDT = R1EXDT                                          BUG28036
     C**********         EVAL      TRRCVD = *BLANK                                          BUG28036
     C**********         EVAL      TRRERR = *BLANK                                          BUG28036
      *****************************************************************                     BUG28036
      ***List*of*forward*account*transfers*for*validation.*************                     BUG28036
     C**********         WRITE     GLFTRVF       GLFTRV                                     BUG28036
      *****************************************************************                     BUG28036
     C**********         ENDSR                                                              BUG28036
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetWIPMsg - Set GLATMIPD WIP message                       *
      *                                                               *
      *****************************************************************
     C     SRSetWIPMsg   BEGSR
 
     C                   EVAL      PMode    = '*CLEAR'
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PMode    = '*ENTER'
     C                   EVAL      PAPIName = 'SHADOWPOSTWRITE!MIDAS.RATM'
     C                   EVAL      PFormat  = 'RATM'
 
     C                   EVAL      PFldTag  = 'APTGTTYPE'
     C                   EVAL      PFldData = 'RATM'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'APTGTSYS'
     C                   EVAL      PFldData = 'MIDAS'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'APFOTRANID'
     C                   IF        R1FRNT = *BLANKS                                         BUG28072
     C                   EVAL      PFldData = R1TREF
     C                   ELSE                                                               BUG28072
     C                   EVAL      PFldData = R1FRNT                                        BUG28072
     C                   ENDIF                                                              BUG28072
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'APCNFVALFO'
     C                   EVAL      PFldData = 'Y'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'APRPRLOCN'
     C                   EVAL      PFldData = 'B'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C**********         EVAL      PFldTag  = 'APUSERID'                                    BUG28072
     C**********         EVAL      PFldData = WkMQUsr                                       BUG28072
     C**********         EVAL      PFldType = *BLANK                                        BUG28072
     C**********         EVAL      PFldAttr = *BLANK                                        BUG28072
     C**********         EXSR      SRFmtWMsg                                                BUG28072
 
     C**********         EVAL      PFldTag  = 'APPASSWORD'                                  BUG28072
     C**********         EVAL      PFldData = WkMQUsrP                                      BUG28072
     C**********         EVAL      PFldType = *BLANK                                        BUG28072
     C**********         EVAL      PFldAttr = *BLANK                                        BUG28072
     C**********         EXSR      SRFmtWMsg                                                BUG28072
 
     C                   EVAL      PFldTag  = 'APRPYQUEUE'
     C                   EVAL      PFldData = WkRespQ
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'AUTOAUTH'
     C                   EVAL      PFldData = 'Y'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'ACTIONCODEFIELD'
     C                   EVAL      PFldData = 'S'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1RECI'
     C                   EVAL      PFldData = R1RECI
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1TREF'
     C                   EVAL      PFldData = R1TREF
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1TRTY'
     C                   EVAL      PFldData = R1TRTY
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1TRST'
     C                   EVAL      PFldData = R1TRST
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1BRCA'
     C                   EVAL      PFldData = R1BRCA
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1DBBR'
     C                   EVAL      PFldData = R1DBBR
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1DBCU'
     C                   EVAL      PFldData = R1DBCU
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1DBCY'
     C                   EVAL      PFldData = R1DBCY
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1DBAC'
     C                   MOVEL     R1DBAC        PFldData
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1DBSQ'
     C                   MOVEL     R1DBSQ        PFldData
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1DBRE'
     C                   MOVEL     R1DBRE        PFldData
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1DBAI'
     C                   EVAL      PFldData = R1DBAI
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1DAMT'
     C                   MOVEL     R1DAMT        PFldData
     C                   EVAL      PFldType = '*AMOUNT'
     C                   EVAL      WkCcy = R1DBCY
     C                   EXSR      SrGetDecimal
     C                   MOVEL     ArrDec(X)     PFldAttr
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1DRTT'
     C                   EVAL      PFldData = R1DRTT
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1DRVL'
     C                   MOVEL     R1DRVL        PFldData
     C                   EVAL      PFldType = '*DATE'
     C                   EVAL      PFldAttr = BJDFIN
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1DBVD'
     C                   MOVEL     R1DBVD        PFldData
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1DBVS'
     C                   EVAL      PFldData = R1DBVS
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1CRBR'
     C                   EVAL      PFldData = R1CRBR
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1CRCU'
     C                   EVAL      PFldData = R1CRCU
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1CRCY'
     C                   EVAL      PFldData = R1CRCY
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1CRAC'
     C                   MOVEL     R1CRAC        PFldData
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1CRSQ'
     C                   MOVEL     R1CRSQ        PFldData
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1CRRE'
     C                   MOVEL     R1CRRE        PFldData
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1CRAI'
     C                   EVAL      PFldData = R1CRAI
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1CAMT'
     C                   MOVEL     R1CAMT        PFldData
     C                   EVAL      PFldType = '*AMOUNT'
     C                   EVAL      WkCcy = R1CRCY
     C                   EXSR      SrGetDecimal
     C                   MOVEL     ArrDec(X)     PFldAttr
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1CRTT'
     C                   EVAL      PFldData = R1CRTT
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1CRVL'
     C                   MOVEL     R1CRVL        PFldData
     C                   EVAL      PFldType = '*DATE'
     C                   EVAL      PFldAttr = BJDFIN
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1CRVD'
     C                   MOVEL     R1CRVD        PFldData
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1CRVS'
     C                   EVAL      PFldData = R1CRVS
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1EXCH'
     C                   MOVEL     R1EXCH        PFldData
     C                   EVAL      PFldType = '*AMOUNT'
     C                   MOVEL     8             PFldAttr
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1MDIN'
     C                   EVAL      PFldData = R1MDIN
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1INDT'
     C                   MOVEL     R1INDT        PFldData
     C                   EVAL      PFldType = '*DATE'
     C                   EVAL      PFldAttr = BJDFIN
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1EXDT'
     C                   MOVEL     R1EXDT        PFldData
     C                   EVAL      PFldType = '*DATE'
     C                   EVAL      PFldAttr = BJDFIN
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1CHNO'
     C                   IF        R1CHNO <> *ZERO
     C                   MOVEL     R1CHNO        PFldData
     C                   ELSE
     C                   EVAL      PFldData = *BLANK
     C                   ENDIF
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1CHBR'
     C                   EVAL      PFldData = R1CHBR
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1CHCU'
     C                   IF        R1CHCU <> '000000'                                       BUG28036
     C                   EVAL      PFldData = R1CHCU
     C                   ELSE                                                               BUG28036
     C                   EVAL      PFldData = *BLANK                                        BUG28036
     C                   ENDIF                                                              BUG28036
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1CHCY'
     C                   EVAL      PFldData = R1CHCY
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1CHAC'
     C                   IF        R1CHAC <> *ZERO
     C                   MOVEL     R1CHAC        PFldData
     C                   ELSE
     C                   EVAL      PFlddata = *BLANK
     C                   ENDIF
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1CHSQ'
     C                   IF        R1CHSQ <> *ZERO
     C                   MOVEL     R1CHSQ        PFldData
     C                   ELSE
     C                   EVAL      PFlddata = *BLANK
     C                   ENDIF
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1CHRE'
     C                   IF        R1CHRE <> *ZERO
     C                   MOVEL     R1CHRE        PFldData
     C                   ELSE
     C                   EVAL      PFlddata = *BLANK
     C                   ENDIF
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C**********         EVAL      PFldTag  = 'R1PAYB'                                      AR845655
     C**********         IF        R1PAYB <> *ZERO                                          AR845655
     C**********         MOVEL     R1PAYB        PFldData                                   AR845655
     C                   EVAL      PFldTag  = 'R1PYBK'                                      AR845655
     C                   IF        R1PYBK <> *BLANKS                                        AR845655
     C                   MOVEL     R1PYBK        PFldData                                   AR845655
     C                   ELSE
     C                   EVAL      PFlddata = *BLANK
     C                   ENDIF
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1DBSN'
     C                   EVAL      PFldData = R1DBSN
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1CRSN'
     C                   EVAL      PFldData = R1CRSN
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1FPAY'
     C                   EVAL      PFldData = R1FPAY
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
      ** If Paying Fee A/C is blank, then no fees were defined for the transaction
 
     C                   EVAL      *IN60 = *OFF
     C                   IF        R1FPAY = *BLANKS
     C                   EVAL      *IN60 = *ON
     C                   ELSE
     C                   IF        R1FPAY = 'D'
     C                   EVAL      WkFeeCcyEq = R1DBCY
     C                   ELSE
     C                   EVAL      WkFeeCcyEq = R1DBCY
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      PFldTag  = 'R1FGRS'
     C                   EVAL      PFldData = R1FGRS
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1F1AM'
     C                   MOVEL     R1F1AM        PFldData
     C                   EVAL      WkCcy = R1F1CU
     C                   IF        *IN60 = *OFF OR
     C                             R1F1AM <> *ZERO AND
     C                             R1F1CU <> *BLANK
     C                   EVAL      PFldType = '*AMOUNT'
     C                   EXSR      SrGetDecimal
     C                   MOVEL     ArrDec(X)     PFldAttr
     C                   ELSE
     C                   EXSR      SRBlanks
     C                   ENDIF
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1F1CU'
     C                   EVAL      PFldData = R1F1CU
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1F1CE'
     C                   MOVEL     R1F1CE        PFldData
     C                   EVAL      WkCcy = WkFeeCcyEq
     C                   IF        *IN60 = *OFF OR
     C                             R1F1AM <> *ZERO AND
     C                             R1F1CU <> *BLANK
     C                   EVAL      PFldType = '*AMOUNT'
     C                   EXSR      SrGetDecimal
     C                   MOVEL     ArrDec(X)     PFldAttr
     C                   ELSE
     C                   EXSR      SRBlanks
     C                   ENDIF
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1F1EX'
     C                   MOVEL     R1F1EX        PFldData
     C                   EVAL      PFldType = '*AMOUNT'
     C                   MOVEL     8             PFldAttr
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1F2AM'
     C                   MOVEL     R1F2AM        PFldData
     C                   EVAL      WkCcy = R1F2CU
     C                   IF        *IN60 = *OFF OR
     C                             R1F2AM <> *ZERO AND
     C                             R1F2CU <> *BLANK
     C                   EVAL      PFldType = '*AMOUNT'
     C                   EXSR      SrGetDecimal
     C                   MOVEL     ArrDec(X)     PFldAttr
     C                   ELSE
     C                   EXSR      SRBlanks
     C                   ENDIF
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1F2CU'
     C                   EVAL      PFldData = R1F2CU
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1F2CE'
     C                   MOVEL     R1F2CE        PFldData
     C                   EVAL      WkCcy = WkFeeCcyEq
     C                   IF        *IN60 = *OFF OR
     C                             R1F2AM <> *ZERO AND
     C                             R1F2CU <> *BLANK
     C                   EVAL      PFldType = '*AMOUNT'
     C                   EXSR      SrGetDecimal
     C                   MOVEL     ArrDec(X)     PFldAttr
     C                   ELSE
     C                   EXSR      SRBlanks
     C                   ENDIF
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1F2EX'
     C                   MOVEL     R1F2EX        PFldData
     C                   EVAL      PFldType = '*AMOUNT'
     C                   MOVEL     8             PFldAttr
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1F3AM'
     C                   MOVEL     R1F3AM        PFldData
     C                   EVAL      WkCcy = R1F3CU
     C                   IF        *IN60 = *OFF OR
     C                             R1F3AM <> *ZERO AND
     C                             R1F3CU <> *BLANK
     C                   EVAL      PFldType = '*AMOUNT'
     C                   EXSR      SrGetDecimal
     C                   MOVEL     ArrDec(X)     PFldAttr
     C                   ELSE
     C                   EXSR      SRBlanks
     C                   ENDIF
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1F3CU'
     C                   EVAL      PFldData = R1F3CU
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1F3CE'
     C                   MOVEL     R1F3CE        PFldData
     C                   EVAL      WkCcy = WkFeeCcyEq
     C                   IF        *IN60 = *OFF OR
     C                             R1F3AM <> *ZERO AND
     C                             R1F3CU <> *BLANK
     C                   EVAL      PFldType = '*AMOUNT'
     C                   EXSR      SrGetDecimal
     C                   MOVEL     ArrDec(X)     PFldAttr
     C                   ELSE
     C                   EXSR      SRBlanks
     C                   ENDIF
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1F3EX'
     C                   MOVEL     R1F3EX        PFldData
     C                   EVAL      PFldType = '*AMOUNT'
     C                   MOVEL     8             PFldAttr
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1F4AM'
     C                   MOVEL     R1F4AM        PFldData
     C                   EVAL      WkCcy = R1F4CU
     C                   IF        *IN60 = *OFF OR
     C                             R1F4AM <> *ZERO AND
     C                             R1F4CU <> *BLANK
     C                   EVAL      PFldType = '*AMOUNT'
     C                   EXSR      SrGetDecimal
     C                   MOVEL     ArrDec(X)     PFldAttr
     C                   ELSE
     C                   EXSR      SRBlanks
     C                   ENDIF
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1F4CU'
     C                   EVAL      PFldData = R1F4CU
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1F4CE'
     C                   MOVEL     R1F4CE        PFldData
     C                   EVAL      WkCcy = WkFeeCcyEq
     C                   IF        *IN60 = *OFF OR
     C                             R1F4AM <> *ZERO AND
     C                             R1F4CU <> *BLANK
     C                   EVAL      PFldType = '*AMOUNT'
     C                   EXSR      SrGetDecimal
     C                   MOVEL     ArrDec(X)     PFldAttr
     C                   ELSE
     C                   EXSR      SRBlanks
     C                   ENDIF
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1F4EX'
     C                   MOVEL     R1F4EX        PFldData
     C                   EVAL      PFldType = '*AMOUNT'
     C                   MOVEL     8             PFldAttr
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1F5AM'
     C                   MOVEL     R1F5AM        PFldData
     C                   EVAL      WkCcy = R1F2CU
     C                   IF        *IN60 = *OFF OR
     C                             R1F5AM <> *ZERO AND
     C                             R1F5CU <> *BLANK
     C                   EVAL      PFldType = '*AMOUNT'
     C                   EXSR      SrGetDecimal
     C                   MOVEL     ArrDec(X)     PFldAttr
     C                   ELSE
     C                   EXSR      SRBlanks
     C                   ENDIF
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1F5CU'
     C                   EVAL      PFldData = R1F5CU
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1F5CE'
     C                   MOVEL     R1F5CE        PFldData
     C                   EVAL      WkCcy = WkFeeCcyEq
     C                   IF        *IN60 = *OFF OR
     C                             R1F5AM <> *ZERO AND
     C                             R1F5CU <> *BLANK
     C                   EVAL      PFldType = '*AMOUNT'
     C                   EXSR      SrGetDecimal
     C                   MOVEL     ArrDec(X)     PFldAttr
     C                   ELSE
     C                   EXSR      SRBlanks
     C                   ENDIF
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1F5EX'
     C                   MOVEL     R1F5EX        PFldData
     C                   EVAL      PFldType = '*AMOUNT'
     C                   MOVEL     8             PFldAttr
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1F6AM'
     C                   MOVEL     R1F6AM        PFldData
     C                   EVAL      WkCcy = R1F6CU
     C                   IF        *IN60 = *OFF OR
     C                             R1F6AM <> *ZERO AND
     C                             R1F6CU <> *BLANK
     C                   EVAL      PFldType = '*AMOUNT'
     C                   EXSR      SrGetDecimal
     C                   MOVEL     ArrDec(X)     PFldAttr
     C                   ELSE
     C                   EXSR      SRBlanks
     C                   ENDIF
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1F6CU'
     C                   EVAL      PFldData = R1F6CU
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1F6CE'
     C                   MOVEL     R1F6CE        PFldData
     C                   EVAL      WkCcy = WkFeeCcyEq
     C                   IF        *IN60 = *OFF OR
     C                             R1F6AM <> *ZERO AND
     C                             R1F6CU <> *BLANK
     C                   EVAL      PFldType = '*AMOUNT'
     C                   EXSR      SrGetDecimal
     C                   MOVEL     ArrDec(X)     PFldAttr
     C                   ELSE
     C                   EXSR      SRBlanks
     C                   ENDIF
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1F6EX'
     C                   MOVEL     R1F6EX        PFldData
     C                   EVAL      PFldType = '*AMOUNT'
     C                   MOVEL     8             PFldAttr
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1EXT1'
     C                   EVAL      PFldData = R1EXT1
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1EXT2'
     C                   EVAL      PFldData = R1EXT2
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1EXT3'
     C                   EVAL      PFldData = R1EXT3
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1EXT4'
     C                   EVAL      PFldData = R1EXT4
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1EXT5'
     C                   EVAL      PFldData = R1EXT5
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1EXT6'
     C                   EVAL      PFldData = R1EXT6
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1FRNT'
     C                   EVAL      PFldData = R1FRNT
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1REPL'
     C                   EVAL      PFldData = R1REPL
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1TMST'
     C                   EVAL      PFldData = R1TMST
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1ORED'
     C                   MOVEL     R1ORED        PFldData
     C                   EVAL      PFldType = '*DATE'
     C                   EVAL      PFldAttr = BJDFIN
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1LCTM'
     C                   MOVEL     R1LCTM        PFldData
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1LCDT'
     C                   MOVEL     R1LCDT        PFldData
     C                   EVAL      PFldType = '*DATE'
     C                   EVAL      PFldAttr = BJDFIN
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1CHTP'
     C                   EVAL      PFldData = R1CHTP
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1USER'
     C                   EVAL      PFldData = R1USER
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1AUTH'
     C                   EVAL      PFldData = R1AUTH
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1APRV'
     C                   EVAL      PFldData = R1APRV
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'R1STAT'
     C                   EVAL      PFldData = R1STAT
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
 
     C                   EVAL      PMode    = '*RETURN'
     C                   EXSR      SRFmtWMsg
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtWMsg - Format the WIP message                           *
      *                                                               *
      *****************************************************************
     C     SRFmtWMsg     BEGSR
 
     C                   CALL      'GPFMT4WIP'
     C                   PARM                    PMode
     C                   PARM                    PAPIName
     C                   PARM                    Pformat
     C                   PARM                    PfldTag
     C                   PARM                    PfldData
     C                   PARM                    PfldType
     C                   PARM                    PfldAttr
     C                   PARM                    PMsgBuf
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPutMQIO - Put message to MQ Series queue                   *
      *                                                               *
      *****************************************************************
     C     SRPutMQIO     BEGSR
 
     C                   CALL      'GPMQMIO'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM                    PErrMsg
     C                   PARM                    PRequest
     C                   PARM      PWIPQueue     PQueueNm
     C                   PARM                    PMsgBuf
     C                   PARM                    P@Key
     C                   PARM      WkMQMgr       PMQMgr                                    BUG27831B
 
     C                   IF        PRtCd <> *BLANKS OR PErrMsg <> *BLANKS
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetDecimal - Get number of decimal places for              *
      *                 given currency                                *
      *                                                               *
      *****************************************************************
     C     SRGetDecimal  BEGSR
 
     C                   EVAL      X = %LOOKUP(WkCcy:ArrCcy)
 
     C                   IF        X = 0
     C                   EVAL      WCcyCounter = WCcyCounter + 1
     C                   EVAL      X = WCcyCounter
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY    '    POptn
     C                   PARM      WkCcy         PKey
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C     PRtCd         IFNE      *BLANKS
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     99            DBASE
     C                   MOVEL     WkCcy         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      ArrCcy(X) = WkCcy
     C                   EVAL      ArrDec(X) = A6NBDP
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBlanks - Blank out field details                           *
      *                                                               *
      *****************************************************************
     C     SRBlanks      BEGSR
 
     C                   EVAL      PFldData = *BLANK
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
 
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
 
      ** Access General Ledger details
 
     C                   CALL      'AOGELRR1'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDGELR        PARM      SDGELR        DSSDY
 
      ** Database Error
 
     C                   IF        PRtCd <>  *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   MOVEL     POptn         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRtCd <>  *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     2             DBASE
     C                   MOVEL     POptn         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Use queue name defined in system values.
 
     C                   EVAL      P@OP01 = 'MQTransSdrQueue'
     C                   EVAL      P@OP02 = 'MQJMSResponseQueue'
     C                   EVAL      P@OP03 = 'MQQueueMgr'                                   BUG28072A
     C**********         EVAL      P@OP03 = 'MQUsername'                                   BUG28072A
     C**********         EVAL      P@OP04 = 'MQUserPassword'                               BUG28072A
     C**********         EVAL      P@OP05 = 'MQQueueMgr'                         BUG27831B BUG28072A
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM                    P@OP01
     C                   PARM      *BLANKS       P@VL01
     C                   PARM                    P@OP02
     C                   PARM      *BLANKS       P@VL02
     C                   PARM                    P@OP03
     C                   PARM      *BLANKS       P@VL03
     C                   PARM                    P@OP04
     C                   PARM      *BLANKS       P@VL04
     C**********         PARM      *BLANKS       P@OP05                                    BUG27831B
     C                   PARM                    P@OP05                                    BUG27831B
     C                   PARM      *BLANKS       P@VL05
     C                   PARM      *BLANKS       P@OP06
     C                   PARM      *BLANKS       P@VL06
     C                   PARM      *BLANKS       P@OP07
     C                   PARM      *BLANKS       P@VL07
     C                   PARM      *BLANKS       P@OP08
     C                   PARM      *BLANKS       P@VL08
     C                   PARM      *BLANKS       P@OP09
     C                   PARM      *BLANKS       P@VL09
     C                   PARM      *BLANKS       P@OP10
     C                   PARM      *BLANKS       P@VL10
 
     C                   IF        PRtCd <>  *BLANKS
     C                   MOVEL     'SDSVALPD'    DBFILE
     C                   Z-ADD     3             DBASE                U7U8
     C                   MOVEL     P@OP01        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      PWIPQueue = P@VL01
     C                   EVAL      WkRespQ   = P@VL02
     C                   EVAL      WkMQMgr   = P@VL03                                      BUG28072A
     C**********         EVAL      WkMQUsr   = P@VL03                                      BUG28072A
     C**********         EVAL      WkMQUsrP  = P@VL04                                      BUG28072A
     C**********         EVAL      WkMQMgr   = P@VL05                            BUG27831B BUG28072A
 
     C     KyAcctDB      KLIST
     C                   KFLD                    R1DBCU
     C                   KFLD                    R1DBCY
     C                   KFLD                    R1DBAC
     C                   KFLD                    R1DBSQ
     C                   KFLD                    R1DBBR
 
     C     KyAcctCR      KLIST
     C                   KFLD                    R1CRCU
     C                   KFLD                    R1CRCY
     C                   KFLD                    R1CRAC
     C                   KFLD                    R1CRSQ
     C                   Kfld                    R1CRBR
 
     C     KyATMI        KLIST                                                              BUG28036
     C                   KFLD                    TRTREF                                     BUG28036
     C                   KFLD                    TREXDT                                     BUG28036
                                                                                            BUG28036
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
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
