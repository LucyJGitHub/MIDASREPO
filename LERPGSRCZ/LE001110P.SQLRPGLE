000100210302     H DEBUG
000101210302     H COPYRIGHT('(c) Finastra International Limited 2020')
000102210302      *****************************************************************
000103210305/*STD *  RPGSQLMOD                                                    *
000104210309/*EXI *  TEXT('Midas LE Daily Rate Calculation Report')               *
000105210302      *****************************************************************
000106210302      *                                                               *
000107210302      *  Midas - Lending Module                                       *
000108210302      *                                                               *
000109210309      *  LE001110  - Midas LE Daily Rate Calculation Report           *
000110210302      *                                                               *
000111210302      *  (c) Finastra International Limited 2020                      *
000112210302      *                                                               *
000113210302      *  Last Amend No. CLE172    *CREATE  Date 01Oct20               *
000114210302      *                                                               *
000115210302      *---------------------------------------------------------------*
000116210302      *                                                               *
000117210302      *  CLE172 - LIBOR Deregulation - Lending                        *
000118210302      *                                                               *
000119210302      *****************************************************************
000120210302     FLE001110P1O    E             PRINTER OFLIND(*IN50)
000121210302      ** Midas SD Compounding Rate History Details Report
000124210302     FLECLIPL2  IF   E           K DISK    INFSR(*PSSR)
000125210302     F                                     IGNORE(CLOANCKF)
000126210302      ** Loan Details
000127210302
000128210302      **---------------------------------------------------------------
000129210302      ** The following /COPY line includes all the defined fields in
000130210302      ** the Program Status Data Structures.  They have meaningful
000131210302      ** names, prefixed by 'PS'.
000132210302     D/COPY ZACPYSRC,PSDS
000133210302     D/COPY ZACPYSRC,STD_D_SPEC
000134210302
000135210302      ** +--------------------------------------+
000136210302      ** ¦ Program Prototypes                   ¦
000137210302      ** ¦ ==================                   ¦
000138210302      ** +--------------------------------------+
000139210302     D RetrieveBANK    PR                  EXTPGM('AOBANKR0')
000140210302     D  pReturnCode                   7A
000141210302     D  pOption                       7A
000142210302     D  pDSSDY                      200A
000143210302
000144210302      ** +--------------------------------------+
000145210302      ** ¦ Manually included D-specs            ¦
000146210302      ** ¦ =========================            ¦
000147210302      ** +--------------------------------------+
000148210302     D SDBANK        E DS                  EXTNAME(SDBANKPD)
000149210302     D pDSSDY          S            200A
000150210302
000151210302      ** Parameters for ZDATE2
000152210302     D ZDayNo          S              5P 0
000153210302     D ZDate           S              6P 0
000154210302     D ZADate          S              7A
000155210302
000156210302      ** Indicator Array
000157210302     D Indicators      DS                  BASED(IndicatorP)
000158210302     D  ErrorOnFl             35     35
000159210302     D  EndOfFile             45     45
000160210302
000161210302      ** Pointer for the indicator Array
000162210302     D IndicatorP      S               *   INZ(%Addr(*IN))
000163210302
000164210302      ** +--------------------------------------+
000165210302      ** ¦ Variable declaration                 ¦
000166210302      ** ¦ ====================                 ¦
000167210302      ** +--------------------------------------+
000168210302     D pReturnCode     S              7A
000169210302     D pOption         S              7A
000170210304
000171210304      ** Temporary DS for SDHSDRTD
000172210304
000173210304     D DlyDS           DS
000178210304     D Dintd                          5p 0
000179210324     D Dindy                          5p 0
000180210304     D Dobdt                          5p 0
000181210324     D Dobdy                          5p 0
000182210308     D Dbrfr                         17p 2
000183210308     D Drtap                         17p 2
000184210308     D Davcr                         17p 2
000185210302
000186210302      ** +--------------------------------------+
000187210302      ** ¦ End of D-specs                       ¦
000188210302      ** ¦ ==============                       ¦
000189210302      ** +--------------------------------------+
000190210302
000191210302      *****************************************************************
000192210302      /EJECT
000193210302      *****************************************************************
000194210302      ** +--- Start of Main processing -------------------------------+
000195210302      ** ¦                                                            ¦
000196210302      ** ¦ *INZSR is executed at program activation.                  ¦
000197210302      ** ¦                                                            ¦
000198210302      ** +------------------------------------------------------------+
000199210302
000200210302      *****************************************************************
000201210302      * MAIN PROCEDURE                                                *
000202210302      *****************************************************************
000203210302
000204210302     C                   ADD       1             PGENUM
000205210302     C                   WRITE     LE001110H1
000206210302      *
000207210302     C     *LOVAL        SETLL     LECLIPL2
000208210302     C                   READ      LECLIPL2                             3545
000209210302      *
000210210302      ** Database error
000211210302      *
000212210302     C                   IF        ErrorOnFl = True
000213210302     C     *LOCK         IN        LDA
000214210302     C                   EVAL      DBKey = '*FIRST'
000215210302     C                   EVAL      DBFile = 'LECLIPL2'
000216210302     C                   EVAL      DBase = 1
000217210302     C                   OUT       LDA
000218210302     C                   EXSR      *PSSR
000219210302     C                   ENDIF
000220210302      *
000221210302      ** Start loop
000222210302      *
000223210302     C                   DOW       EndOfFile = False
000224210302      *
000225210302      ** Process Report Lines
000226210302      *
000227210302     C                   EXSR      SRPrint
000228210302      *
000229210302      ** Read next record
000230210302      *
000231210302     C                   READ      LECLIPL2                             3545
000232210302      *
000233210302     C                   IF        ErrorOnFl = True
000234210302     C     *LOCK         IN        LDA
000235210302     C                   EVAL      DBKey = '*NEXT'
000236210302     C                   EVAL      DBFile = 'LECLIPL2'
000237210302     C                   EVAL      DBase = 2
000238210302     C                   OUT       LDA
000239210302     C                   EXSR      *PSSR
000240210302     C                   ENDIF
000241210302      *
000242210302     C                   ENDDO
000243210302      *
000244210302     C                   WRITE     LE001110T1
000245210302      *
000246210302     C                   EVAL      *INLR = *ON
000247210302
000248210302      *****************************************************************
000249210302      *  P R O G R A M   E N D                                        *
000250210302      *****************************************************************
000251210302      /EJECT
000252210302      *****************************************************************
000253210302      *                                                               *
000254210302      * SRPrint - Print details report                                *
000255210302      *                                                               *
000256210302      * Called by: Main Processing                                    *
000257210302      *                                                               *
000258210302      * Calls: None                                                   *
000259210302      *                                                               *
000260210302      *****************************************************************
000261210302
000262210302     C     SRPrint       BEGSR
000263210302      *
000264210302      ** CHECK IF OVERFLOW
000265210302      *
000266210302     C                   IF        *IN50 = '1'
000267210302     C                   ADD       1             PGENUM
000268210302     C                   WRITE     LE001110H1
000269210302     C                   EVAL      *IN50 = '0'
000270210302     C                   ENDIF
000271210302      *
000272210302      ** Write details to printer fields
000273210302      *
000274210302      * Loan Details
000275210302     C                   EVAL      P1LNRF = LNRF
000276210302      *
000277210302     C                   EVAL      ZDayNo = VDAT
000278210302     C                   CALLB     'ZDATE2'
000279210302     C                   PARM                    ZDayNo
000280210302     C                   PARM                    BJDFIN
000281210302     C                   PARM      *Zero         ZDate
000282210302     C                   PARM      *BLanks       ZADate
000283210302      *
000284210304     C                   EVAL      P1VLDT = ZADate
000285210302     C                   EVAL      P1INFR = IPFR
000286210302      *
000287210302     C                   EVAL      ZDayNo = MDAT
000288210302     C                   CALLB     'ZDATE2'
000289210302     C                   PARM                    ZDayNo
000290210302     C                   PARM                    BJDFIN
000291210302     C                   PARM      *Zero         ZDate
000292210302     C                   PARM      *BLanks       ZADate
000293210302      *
000294210304     C                   EVAL      P1MTDT = ZADate
000295210302     C                   EVAL      P1BRAT = BRTT
000296210302     C                   EVAL      P1CUPR = CPAM
000297210302     C                   EVAL      P1SPRD = SPIN
000298210302     C                   EVAL      P1BADJ = BADJ
000299210302      *
000300210302     C                   EVAL      P1RFRT = RFRR
000301210302     C                   EVAL      P1LKBD = LBDY
000302210302     C                   EVAL      P1LOUT = LODY
000303210302     C                   EVAL      P1RTRO = RRDP
000304210302     C                   EVAL      P1DBFA = DBAV
000305210302     C                   EVAL      P1OBSP = OPSH
000306210302     C                   EVAL      P1RAKI = RTKN
000307210302     C                   EVAL      P1FLOR = FLOR
000308210302      *
000309210302      ** Daily Details
000310210302      *
000316210304     C/exec SQL
000317210304     C+ declare SDHS cursor for
000318210304     C+ select
000319210304     C+   CMINPD
000320210304     C+ , CINPDY
000321210304     C+ , CMOBPD
000322210304     C+ , COBPDY
000323210304     C+ , CPBRFR
000324210304     C+ , CRTEAP
000325210305     C+ , CAVCRT
000326210305     C+ from SDHSDRTD
000327210304     C+ where
000328210304     C+     CMODID = 'LE'
000329210304     C+ and CTRNID = :P1LNRF
000330210305     C+ order by
000331210305     C+     CTIMST desc
000332210304     C/end-exec
000333210304      *
000334210304     C/exec SQL
000335210304     C+ open SDHS
000336210304     C/end-exec
000337210304      *
000338210304     C/exec SQL
000339210304     C+ fetch next
000340210304     C+ from SDHS
000341210304     C+ into :DlyDS
000342210304     C/end-exec
000343210304      *
000344210305     C                   IF        SQLCODE = 0
000345210304      *
000346210304     C                   EVAL      ZDayNo = Dintd
000347210304     C                   CALLB     'ZDATE2'
000348210304     C                   PARM                    ZDayNo
000349210304     C                   PARM                    BJDFIN
000350210304     C                   PARM      *Zero         ZDate
000351210304     C                   PARM      *BLanks       ZADate
000352210304      *
000353210304     C                   EVAL      P1INDT = ZADate
000354210304     C                   EVAL      P1INDY = Dindy
000355210304      *
000356210304     C                   EVAL      ZDayNo = Dobdt
000357210304     C                   CALLB     'ZDATE2'
000358210304     C                   PARM                    ZDayNo
000359210304     C                   PARM                    BJDFIN
000360210304     C                   PARM      *Zero         ZDate
000361210304     C                   PARM      *BLanks       ZADate
000362210304      *
000363210304     C                   EVAL      P1OBDT = ZADate
000364210304     C                   EVAL      P1OBDY = Dobdy
000365210304     C                   EVAL      P1PRFR = Dbrfr
000366210304     C                   EVAL      P1RTAP = Drtap
000367210304     C                   EVAL      P1AVCM = Davcr
000371210304      *
000372210305     C                   ENDIF
000373210308     C/exec SQL
000374210308     C+ close SDHS
000375210308     C/end-exec
000376210302      *
000377210302      ** Write Detail Format
000378210302      *
000379210302     C                   WRITE     LE001110H2
000380210304     C                   WRITE     LE001110D2
000381210302     C                   WRITE     LE001110H3
000382210304     C                   WRITE     LE001110D3
000383210304     C                   WRITE     LE001110H4
000384210304     C                   WRITE     LE001110D4
000385210308     C                   EVAL      P1INDT = *Blanks
000386210308     C                   EVAL      P1INDY = 0
000387210308     C                   EVAL      P1OBDT = *Blanks
000388210308     C                   EVAL      P1OBDY = 0
000389210308     C                   EVAL      P1PRFR = 0
000390210308     C                   EVAL      P1RTAP = 0
000391210308     C                   EVAL      P1AVCM = 0
000392210302      *
000393210302     C                   ENDSR
000394210302      *****************************************************************
000395210302      /EJECT
000396210302      *****************************************************************
000397210302      *                                                               *
000398210302      * *INZSR - Program Initialisation routine                       *
000399210302      *                                                               *
000400210302      * Called by: Implicitly on program activation                   *
000401210302      *                                                               *
000402210302      * Calls: AOBANKR0                                               *
000403210302      *                                                               *
000404210302      *****************************************************************
000405210302     C     *INZSR        BEGSR
000406210302     C                   EVAL      pOption = '*FIRST'
000407210302     C                   CALLP     RetrieveBANK(pReturnCode: pOption: pDSSDY)
000408210302     C                   EVAL      SDBANK = pDSSDY
000409210302     C                   ENDSR
000410210302      *****************************************************************
000411210302      /EJECT
000412210302      *****************************************************************
000413210302      *                                                               *
000414210302      * *PSSR  - Program exception error routine                      *
000415210302      *          Called automatically if a program error occurs,      *
000416210302      *          or directly by the program code using EXSR.          *
000417210302      *          This subroutine DUMPs the program just once.         *
000418210302      *                                                               *
000419210302      * Called by: (**calling routines**)                             *
000420210302      *                                                               *
000421210302      * Calls: None                                                   *
000422210302      *                                                               *
000423210302      *****************************************************************
000424210302     C     *PSSR         BEGSR
000425210302      *
000426210302     C                   EVAL      *INU7 = *ON
000427210302     C                   EVAL      *INU8 = *ON
000428210302     C                   EVAL      *INLR = *ON
000429210302     C                   RETURN
000430210302      *
000431210302     C                   ENDSR
000432210302      *****************************************************************
000433210302      /EJECT
000434210302      *****************************************************************
000435210302**  CPY@
000436210302(c) Finastra International Limited 2020
