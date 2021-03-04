     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2009')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas ER Transaction/Account Bal. Extract Report')     *
      *****************************************************************
      *                                                               *
      *  Midas - European Reporting Module                            *
      *                                                               *
      *  ER000197 - Midas ER Bundesbank Transaction/Account Balance   *
      *             Extract Report                                    *
      *                                                               *
      *  Function: This program generates report of Transaction/      *
      *            Account Balance detail.                            *
      *                                                               *
      *  (c) Finastra International Limited 2009                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD030247           Date 26Jan15               *
      *                 CER070             Date 19Aug14               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26308           Date 06Oct09               *
      *                 CER045  *CREATE    Date 20Jul09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  MD030247 - Increase size of GSRE to 21.                      *
      *             Applied for MD032081                              *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *         - LT062: Changed Customer No. to alphanumeric.        *
      *  BUG26308 - Change Request - BAIS Mapping table enhancement   *
      *             (Recompile)                                       *
      *  CER045 - German Features - Reporting Bundesbank              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    02         End of file for ERGSTIL1                        *
      *    03         Record not found in ERGSTIL1                    *
      *    20         Audit mode, use for header                      *
      *    21         Out of balance, difference in number of records *
      *    22         Space between different Country of Security     *
      *               Issues                                          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRPrint   - Print details                                     *
      * SREnd     - Write trailer in report                           *
      * SRAudit   - Write audit report                                *
      * SRConvert - Convert currency                                  *
      * SRZedit   - Format amount                                     *
      * *INZSR    - Initialise                                        *
      * *PSSR     - Error processing                                  *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Midas ER GRI Transaction/Account Balances

     FERGSTSL0  IF   E           K DISK    INFSR(*PSSR)

      ** Midas ER GRI Master Account/Transaction File

     FERGSTIL1  IF   E           K DISK    INFSR(*PSSR)

      ** Midas ER Bundesbank Transaction/Account Balance
      ** Extract Report - Details

     FER000197P1O    E             PRINTER INFDS(SPOOL1)
     F                                     USROPN
     F                                     INFSR(*PSSR)

      ** Midas ER Bundesbank Transaction/Account Balance
      ** Extract Report - Audit

     FER000197AUO    E             PRINTER INFDS(SPOOLU)
     F                                     USROPN
     F                                     INFSR(*PSSR)

      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+

      ** Array containing Copyright statement

     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)

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

      ** Externally described DS for bank details

     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Externally described DS for Customer Details

     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      ** Externally described DS for Currency Codes

     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** Externally described DS for GL Accounts master detail

     D SDACCT        E DS                  EXTNAME(ACCNTAB)

      ** DS for access objects - short data structure

     D DSSDY         E DS                  EXTNAME(DSSDY)
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** File Information Data Structure for ER000197P1

     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0

      ** File Information Data Structure for ER000197AU

     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0

      ** Indicator Array

     D Indicators      DS                  BASED(IndicatorP)
     D  EndOfFile             02     02
     D  RecNotFnd             03     03

      ** Decimal Alignment DS

     D AlignAmt        DS
     D  TBVal                  1     18S 2
     D  TChr                   1     18
     D  TNum                   1     18S 0

      ** +--------------------------------------+
      ** ¦ D-specs: Named constants             ¦
      ** ¦ =======  ===============             ¦
      ** +--------------------------------------+

      ** True and False can be used for indicators being on or off.

     D True            C                   *On
     D False           C                   *Off

      ** Constants for decimal alignment.

     D NDec            C                   CONST('00')
     D MaxDec          C                   CONST('000000000')

      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+

      ** Parameters for ZSEDITL

     D ZFLd            S             19  0
     D ZDec            S              2  0
     D ZEdtC           S              1
     D ZOut22          S             22

      ** Parameters for ZSFILE

     D PSeq            S              5
     D SEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1

      ** Parameters for AOCUSTR1

     D PKey            S             10
     D PKyst           S              7

      ** Parameter for AOCURRR0

     D PCurr           S              3

      ** Parameters for access object programs

     D PRtcd           S              7
     D POptn           S              7

      ** Parameters for AOACCTR0

     D ZGSRE           DS
     D  PCNUM                  1      6
     D  PCUCD                  7      9
     D**ZACCD***              10     18  0                                                  MD030247
     D**PACSQ***              19     20                                                     MD030247
     D  ZACCD                 10     19  0                                                  MD030247
     D  PACSQ                 20     21                                                     MD030247

     D PRETL           S             10
     D PACCD           S             10
     D PBRCA           S              3

      ** Convert Variables

     D WINAMT          S             15  0
     D WRATE           S             13  8
     D WSPRT1          S             13  8
     D WSPRT2          S             13  8
     D WMDIN           S              1
     D WMDIN1          S              1
     D WMDIN2          S              1
     D WCCY1           S              3
     D WCCY2           S              3
     D WNBDP1          S              1  0
     D WNBDP2          S              1  0
     D WOUTAMT         S             15  0
     D WEAmt           S             18  2
     D ZOut21          S             21
     D Wfld            S             19  0

      ** Other fields used

     D WRun            S              1
     D WOpen           S              1    INZ('N')
     D WFirst          S              1    INZ('Y')
     D WNoRec          S              5  0 INZ(0)
     D RqdLn1          S              3  0
     D DifLn1          S              4  0
     D WPos            S              2  0
     D WDec            S              2  0

      ** Pointer for the indicator Array

     D IndicatorP      S               *   INZ(%Addr(*IN))

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

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

      ** Set file pointer to first record and do initial read.

     C     *LOVAL        SETLL     ERGSTIL1
     C                   READ      ERGSTIL1                               02

     C                   IF        EndOfFile = True
     C                   EXSR      SRAudit
     C                   ENDIF

     C                   DOU       EndOfFile = True

      ** Count no. of records processed.

     C                   EVAL      WNoRec = WNoRec + 1

      ** Process Report Lines.

     C                   EXSR      SRPrint

      ** Read next record.

     C                   READ      ERGSTIL1                               02
     C                   ENDDO

     C                   EXSR      SREnd

      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************

      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrint - Print details                                      *
      *                                                               *
      *****************************************************************

     C     SRPrint       BEGSR

     C                   IF        WOpen <> 'Y'
     C                   EVAL      WOpen = 'Y'
     C                   OPEN      ER000197P1

      ** Ensure Detail Spool File recorded by RCF.

     C                   EVAL      ZSnum = SFNUM1

     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       SEnty
     C                   PARM                    SFILE1
     C                   PARM                    ZSnum
     C                   PARM      *Blank        ZSerr

      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.

     C                   IF        ZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF

     C                   ENDIF

     C                   EVAL      RqdLn1 = 2
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1

      ** For initial print of details or overflow has occured, print the Header
      ** of the report.

     C                   IF        DifLn1 <= RqdLn1 OR
     C                             WFirst = 'Y'
     C                   WRITE     HEADP1
     C                   EVAL      WFIRST = 'N'
     C                   ENDIF

      ** Write details to printer fields.

     C                   EVAL      RGSRE = B3GSRE
     C     B3GSRE        CHAIN     ERGSTSL0
     C                   IF        NOT %FOUND()
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'ERGSTSPD'
     C                   EVAL      DBKEY  = B3GSRE
     C                   EVAL      DBPGM  = 'ER000197'
     C                   EVAL      DBASE  = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        B3MODU = 'KK'

     C                   CLEAR                   ZGSRE
     C                   EVAL      PACCD = '0000000000'
     C                   MOVE      B4KTON        PRETL
     C                   IF        B4KTON = 0
     C                   EVAL      ZGSRE = B4GSRE
     C                   EVAL      PBRCA = B4FILN
     C                   MOVE      ZACCD         PACCD
     C                   ENDIF

     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PRETL
     C                   PARM                    PCNUM
     C                   PARM                    PCUCD
     C                   PARM                    PACCD
     C                   PARM                    PACSQ
     C                   PARM                    PBRCA
     C     SDACCT        PARM      SDACCT        DSSDY

     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'ACCNTAB'
     C                   EVAL      DBKEY  = PRETL
     C                   EVAL      DBPGM  = 'ER000197'
     C                   EVAL      DBASE  = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVEL     PACCD         RACOD
     C                   ENDIF

     C                   ENDIF

      ** Get number of decimal places for the currency.

     C                   EVAL      RWHIS = B3WHIS
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      B3WHIS        PCurr
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   IF        PRtcd <> *BLANKS AND
     C                             PRtcd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY  = PCurr
     C                   EVAL      DBPGM  = 'ER000197'
     C                   EVAL      DBASE  = 004
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   ELSE
     C                   EVAL      ZDec   = A6NBDP
     C                   ENDIF

      ** Get Customer Details

     C**********         MOVE      B3KDNR        KDNR              6                          CER059
     C                   MOVEL     B3KDNR        KDNR              6                          CER059
     C                   CALL      'AOCUSTR1'
     C                   PARM      *Blanks       PRtCd
     C                   PARM      '*KEY        'POptn
     C                   PARM      KDNR          PKey
     C                   PARM      *Blanks       PKyst
     C     SDCUST        PARM      SDCUST        DSSDY

     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBKEY  = PKey
     C                   EVAL      DBPGM  = 'ER000197'
     C                   EVAL      DBASE  = 005
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      RKDNR = BBCUST
     C                   EVAL      RCOLC = BBCOLC
     C                   EVAL      RCRNM = BBCRNM
     C                   ENDIF

      ** Populate Debit/Credit Indicator.
     C                   IF        B4SLDU < 0
     C                   EVAL      RDCIN = '-'
     C                   ELSE
     C                   EVAL      RDCIN = '+'
     C                   ENDIF

      ** Convert balance in Local Currency
     C                   EVAL      B4SLDU = %ABS(B4SLDU)
     C                   MOVE      B4SLDU        Wfld
     C                   MOVE      Wfld          WINAMT
     C                   EVAL      WCCY1  = B3WHIS
     C                   EVAL      WCCY2  = BJLCCY
     C                   IF        WCCY1 <> WCCY2
     C                   EXSR      SRCONVERT
     C                   MOVE      WOUTAMT       TBVal
     C                   ELSE
     C                   MOVE      WINAMT        TBVal
     C                   ENDIF
     C                   EXSR      SRZEdit
     C                   EVALR     RALCY  = %TRIM(ZOut22)

      ** Convert balance in BASE Currency
     C                   EVAL      WCCY2  = BJCYCD
     C                   IF        WCCY1 <> WCCY2
     C                   EXSR      SRCONVERT
     C                   MOVE      WOUTAMT       TBVal
     C                   ELSE
     C                   MOVE      WINAMT        TBVal
     C                   ENDIF
     C                   EXSR      SRZEdit
     C                   EVALR     RABCY  = %TRIM(ZOut22)

     C                   EVAL      RGSKL = B3GSKL
     C                   EVAL      RRSUKL = B3SUKL

      ** Write Detail

     C                   WRITE     DETAIL

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREnd - Write trailer in report                              *
      *                                                               *
      *****************************************************************

     C     SREnd         BEGSR

     C                   EVAL      RqdLn1 = 4
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF

      ** Write out report trailer.

     C                   WRITE     TRAILP1

      ** Write audit report.

     C                   EXSR      SRAudit

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Write audit report                                 *
      *                                                               *
      *****************************************************************

     C     SRAudit       BEGSR

     C                   IF        *INU7   = *ON OR
     C                             WNoRec  = 0

     C                   OPEN      ER000197AU

      ** Ensure Audit Spool File recorded by RCF.

     C                   EVAL      ZSnumU = SFNUMU

     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       SEnty
     C                   PARM                    SFILEU
     C                   PARM                    ZSnumU
     C                   PARM      *Blank        ZSerr

      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.

     C                   IF        ZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF

     C                   WRITE     HEADAU

      ** If there is a DB Error, Output the DB Error Information.

     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ELSE

     C                   IF        WNoRec  = 0

      ** Or, if no records read, Output "No Details" message.

     C                   WRITE     NODTLS
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   EVAL      *INLR ='1'
     C                   RETURN

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCONVERT - Convert Currency                                  *
      *                                                               *
      *****************************************************************

     C     SRCONVERT     BEGSR

      ** From currency

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    WCCY1
     C     SDCURR        PARM      SDCURR        DSSDY

      ** Database error

     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY = WCCY1
     C                   EVAL      DBPGM  = 'ER000197'
     C                   EVAL      DBASE = 006
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Save necessary details

     C                   EVAL      WSPRT1 = A6SPRT
     C                   EVAL      WMDIN1 = A6MDIN
     C                   EVAL      WNBDP1 = A6NBDP

      ** To currency

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    WCCY2
     C     SDCURR        PARM      SDCURR        DSSDY

      ** Database error

     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY = WCCY2
     C                   EVAL      DBPGM  = 'ER000197'
     C                   EVAL      DBASE = 007
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Save necessary details

     C                   EVAL      WSPRT2 = A6SPRT
     C                   EVAL      WMDIN2 = A6MDIN
     C                   EVAL      WNBDP2 = A6NBDP

      ** Get exchange rate

     C                   CALL      'ZXRATE'
     C                   PARM                    WSPRT1
     C                   PARM                    WMDIN1
     C                   PARM                    WSPRT2
     C                   PARM                    WMDIN2
     C                   PARM                    WRATE
     C                   PARM                    WMDIN

      ** Convert amount

     C                   CALL      'ZCONVZ1'
     C                   PARM                    WINAMT
     C                   PARM                    WRATE
     C                   PARM                    WMDIN
     C                   PARM                    WCCY1
     C                   PARM                    WCCY2
     C                   PARM                    WNBDP1
     C                   PARM                    WNBDP2
     C                   PARM                    WOUTAMT

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZedit - Format Amount                                      *
      *                                                               *
      *****************************************************************

     C     SRZEdit       BEGSR

      ** Align Decimal position (from 2 to 0 DP)

     C                   EVAL      WPos  = ZDec + 1
     C                   EVAL      TChr =  %SUBST(NDec+TChr+MaxDec:WPos:18)
     C                   EVAL      ZFld  = TNum

      ** Format Input Amount field

     C                   CALL      'ZSEDITL'
     C                   PARM                    ZFLd
     C                   PARM                    ZDec
     C                   PARM      *BLANK        ZEdtC
     C                   PARM                    ZOut22

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

     C     *DTAARA       DEFINE                  LDA

     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA

     C                   CALL      'AOBANKR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database error.

     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Report Work fields.

     C                   EVAL      RqdLn1 = 0
     C                   EVAL      DifLn1 = 0
     C                   EVAL      PRTLN1 = 0
     C                   EVAL      WNoRec = 0
     C                   EVAL      ZDec   = 0
     C                   EVAL      *INU7  = *OFF

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

     C                   IF        WRun = *Blank
     C                   EVAL      WRun = 'Y'
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
     C                   DUMP
     C                   EXSR      SRAudit
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2009
