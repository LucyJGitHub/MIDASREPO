000100190902     H DEBUG
000101190902     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2019')
000102190902      *****************************************************************
000103190902/*STD *  RPGBASEBND                                                   *
000104190902/*EXI *  TEXT('Midas UT Transfer Account Keys Setup')                 *
000105190902      *****************************************************************
000106190902      *                                                               *
000107190902      *  Midas - Standing Data                                        *
000108190902      *                                                               *
000109190912      *  UTMD53762D - Midas UT Transfer Account Keys Setup            *
000110190902      *                                                               *
000111190902      *  (c) Finastra Systems Technology, Inc. 2019                   *
000112190902      *                                                               *
000113190920      *  Last Amend No. MD053762  *CREATE    Date 16Jun19             *
000114190902      *                                                               *
000115190902      *---------------------------------------------------------------*
000116190902      *                                                               *
000117190902      *  MD053762 - Tiered Witholding Tax System Values               *
000118190902      *                                                               *
000119190902      *****************************************************************
000120190902      *                                                               *
000121190902      *  F U N C T I O N  O F  I N D I C A T O R S                    *
000122190902      *                                                               *
000123190912      *  10 - End of file XACKEYL1                                    *
000125190912      *  30 - Deals type indicator - LOKUP operation to TABA complete *
000126190912      *  70 - Output '*Continued*'                                    *
000127190912      *  99 - Overflow indicator                                      *
000128190912      *                                                               *
000130190902      *****************************************************************
000131190902      *                                                               *
000132190902      *  S U B R O U T I N E  I N D E X                               *
000133190902      *                                                               *
000134190912      *  *PSSR - Error processing                                     *
000135190912      *  *INZSR - Initialise                                          *
000136190912      *  SRAKEY - Account Key Processing                              *
000137190902      *                                                               *
000138190902      *****************************************************************
000139190912      /EJECT
000140190912      *****************************************************************
000152190912
000153190912     FUT53762DP1O    E             PRINTER OFLIND(*IN99)
000154190912
000155190912      ** Midas SD Account Keys Detail
000156190912
000157190902     FACKEYAL   IF   E             DISK    INFSR(*PSSR)
000158190902     F                                     USROPN
000159190912
000160190912      ** Midas SD Account Keys Header
000161190912
000162190902     FACKEYAK   UF   E           K DISK    INFSR(*PSSR)
000163190902     F                                     USROPN
000164190912
000165190912      ** Midas SD Account Keys Rtv
000166190912
000167190902     FACKEYL0   IF   E           K DISK    INFSR(*PSSR)
000168190902     F                                     USROPN
000169190902     F                                     RENAME(ACKEYALF:ACKEYALFD)
000170190902     F                                     PREFIX(D)
000171190912
000172190912      ** Midas SD Account Keys Update
000173190912
000174190902     FXACKEYAL  O    E             DISK    INFSR(*PSSR)
000175190902     F                                     USROPN
000176190902     F                                     RENAME(ACKEYALF:ACKEYALF2)
000177190902     F                                     PREFIX(X)
000178190912
000179190902     D @RUN            S              1
000180190902     D ZWDTIN          S              8S 0
000181190902     D DateOut         S              8S 0
000182190902     D @@DAYN          S              5P 0
000183190902     D TimeStamp       S               Z
000184190902     D DSAKEY          S             14
000185190912
000186190902     D SDBANK        E DS                  EXTNAME(SDBANKPD)
000187190902      ** Bank details
000188190912
000189190902     D DSFDY         E DS                  EXTNAME(DSFDY)
000190190902      ** First DS for access programs, short data structure
000191190912
000192190902     D DSSDY         E DS                  EXTNAME(DSSDY)
000193190902      ** First DS for access programs, long data structure
000194190912
000195190902     D LDA           E DS           256    EXTNAME(LDA)
000196190912
000197190902      ** Local data area for database error details
000198190902      ** *LOCK IN LDA immediately before and OUT LDA immediately
000199190902      ** after each database error handling.
000200190902      **
000201190902      **                                    134 141 DBFILE
000202190902      **       Defines:                     142 170 DBKEY
000203190902      **                                    171 180 DBPGM
000204190902      **                                    181 1830DBASE
000205190902
000206190902      ** Main Processing
000207190902     C                   Exsr      SRAKEY
000208190912
000209190912     C                   EVAL      *INLR = *ON
000210190912
000211190912      *****************************************************************
000212190902      /SPACE 5
000213190912      *****************************************************************
000214190912      *                                                               *
000215190912      *  SRAKEY - Account Key Processing                              *
000216190912      *                                                               *
000217190912      *****************************************************************
000218190912
000219190902     C     SRAKEY        BEGSR
000220190902
000221190902     C                   Z-ADD     0             COUNT             4 0
000222190902     C                   READ      ACKEYAL
000223190902     C                   DOW       NOT %EOF(ACKEYAL)
000224190912
000225190912      ** Only process keys for deal types TD, IT and CD
000226190912
000227190902     C                   IF        %SUBST(AKEY:1:2) = 'TD' or
000228190902     C                             %SUBST(AKEY:1:2) = 'IT' or
000229190902     C                             %SUBST(AKEY:1:2) = 'CD'
000230190912
000231190912      ** For existing Maturity Interest key, write new Interest Paid Separately
000232190912      ** key (so that it has same Dr side details as Maturity Interest key, and no CR details)
000233190912
000234190902     C                   IF        %SUBST(AKEY:3:1) = 'R' and
000235190902     C                             %SUBST(AKEY:10:1) = 'I' and
000236190902     C                             %SUBST(AKEY:6:1) = ' '
000237190902     C                   EXSR      SRMOVE
000238190902     C                   EVAL      %SUBST(XAKEY:8:1) = 'G'
000239190916     C                   EVAL      XEACC = 0
000240190902     C                   WRITE     ACKEYALF2
000241190902     C                   EXSR      SRMOVE2
000242190902     C                   ADD       1             COUNT
000243190902     C                   ENDIF
000244190912
000245190902     C                   ENDIF
000246190912
000247190902     C                   READ      ACKEYAL
000248190902     C                   ENDDO
000249190912
000250190902     C                   CLOSE     ACKEYAL
000251190902     C                   CLOSE     XACKEYAL
000252190902     C                   CLOSE     ACKEYL0
000253190902     C                   OPEN      ACKEYAK
000254190902     C                   READ      ACKEYAK
000255190902     C                   ADD       COUNT         NREC1
000256190902     C                   ADD       COUNT         NINS
000257190902     C                   UPDATE    ACKEYAKF
000258190902     C                   CLOSE     ACKEYAK
000259190912
000260190902     C                   IF        COUNT = 0
000261190902     C                   WRITE     FMTW02
000262190902     C                   ENDIF
000263190912
000264190902     C                   ENDSR
000265190902
000266190902      *****************************************************************
000267190902      /SPACE 5
000268190902      *****************************************************************
000269190912      *                                                               *
000270190912      *  SRMOVE - Subroutine to move fields from ACKEYAL to XACKEYAL  *
000271190912      *                                                               *
000272190902      *****************************************************************
000273190912
000274190902     C     SRMOVE        BEGSR
000275190912
000276190902     C                   EVAL      XRECI = RECI
000277190902     C                   EVAL      XQQAKEY =  QQAKEY
000278190902     C                   EVAL      XZZ002 = ZZ002
000279190902     C                   EVAL      XACD2QQ = ACD2QQ
000280190902     C                   EVAL      XACD3QQ = ACD3QQ
000281190902     C                   EVAL      XACD5QQ = ACD5QQ
000282190902     C                   EVAL      XACD6QQ = ACD6QQ
000283190902     C                   EVAL      XNCD2 = NCD2
000284190902     C                   EVAL      XNCD3 = NCD3
000285190902     C                   EVAL      XNCD5 = NCD5
000286190902     C                   EVAL      XNCD6 = NCD6
000287190902     C                   EVAL      XPRF2 = PRF2
000288190902     C                   EVAL      XPRF3 = PRF3
000289190902     C                   EVAL      XPRF5 = PRF5
000290190902     C                   EVAL      XPRF6 = PRF6
000291190902     C                   EVAL      XZZ034 = ZZ034
000292190902     C                   EVAL      XLCD = LCD
000293190902     C                   EVAL      XCHTP = CHTP
000294190902     C                   EVAL      XTNLU = TNLU
000295190902     C                   EVAL      XACD2 = ACD2
000296190902     C                   EVAL      XACD3 = ACD3
000297190902     C                   EVAL      XACD5 = ACD5
000298190902     C                   EVAL      XACD6 = ACD6
000299190902     C                   EVAL      XAKEY = AKEY
000300190902     C                   EVAL      XZONE = ZONE
000301190902     C                   EVAL      XIUSR = IUSR
000302190902     C                   EVAL      XAUSR = AUSR
000303190902     C                   EVAL      XXUSR = XUSR
000304190902     C                   EVAL      XAACC = AACC
000305190902     C                   EVAL      XEACC = EACC
000306190902     C                   EVAL      XGPDT = GPDT
000307190902     C                   EVAL      XASQ2 = ASQ2
000308190902     C                   EVAL      XASQ3 = ASQ3
000309190902     C                   EVAL      XASQ5 = ASQ5
000310190902     C                   EVAL      XASQ6 = ASQ6
000311190912
000312190902     C                   Eval      DSAKEY = *Blanks
000313190902     C                   Eval      DSAKEY = AKEY
000314190902     C                   Eval      %SUBST(DSAKEY:3:1) = 'M'
000315190902     C     DSAKEY        Chain     ACKEYL0                            70
000316190902     C     *In70         Ifeq      *Off
000317190902     C                   EVAL      XACD1QQ = DACD1QQ
000318190902     C                   EVAL      XNCD1 = DNCD1
000319190902     C                   EVAL      XPRF1 = DPRF1
000320190902     C                   EVAL      XACD1 = DACD1
000321190902     C                   EVAL      XASQ1 = DASQ1
000322190902     C                   else
000323190902     C                   EVAL      XACD1QQ = 0
000324190902     C                   EVAL      XNCD1 = *Blank
000325190902     C                   EVAL      XPRF1 = 0
000326190902     C                   EVAL      XACD1 = 0
000327190902     C                   EVAL      XASQ1 = *Blank
000328190902     C                   Endif
000329190912
000330190902     C                   Eval      %SUBST(DSAKEY:10:1) = 'T'
000331190902     C                   Eval      %SUBST(DSAKEY:8:1) = 'G'
000332190902     C     DSAKEY        Chain     ACKEYL0                            70
000333190902     C     *In70         Ifeq      *Off
000334190902     C                   EVAL      XACD4QQ = DACD1QQ
000335190902     C                   EVAL      XNCD4 = DNCD1
000336190902     C                   EVAL      XPRF4 = DPRF1
000337190902     C                   EVAL      XACD4 = DACD1
000338190902     C                   EVAL      XASQ4 = DASQ1
000339190902     C                   else
000340190902     C                   EVAL      XACD4QQ = 0
000341190902     C                   EVAL      XNCD4 = *Blank
000342190902     C                   EVAL      XPRF4 = 0
000343190902     C                   EVAL      XACD4 = 0
000344190902     C                   EVAL      XASQ4 = *Blank
000345190902     C                   Endif
000346190912
000347190902     C                   ENDSR
000348190912
000349190902      *****************************************************************
000350190902      /SPACE 5
000351190902      *****************************************************************
000352190912      *                                                               *
000353190912      *  *INZSR - Program Initialisation routine                      *
000354190912      *                                                               *
000355190902      *****************************************************************
000356190912
000357190902     C     *INZSR        BEGSR
000358190902
000359190912     C     *DTAARA       DEFINE                  LDA
000360190912
000361190902      ** Access Bank Details
000362190912
000363190902     C                   CALL      'AOBANKR0'
000364190902     C                   PARM      '*MSG   '     PRTCD             7
000365190902     C                   PARM      '*FIRST '     POPTN             7
000366190902     C     SDBANK        PARM      SDBANK        DSFDY
000367190912
000368190902     C     PRTCD         IFNE      *BLANKS
000369190902     C     *LOCK         IN        LDA
000370190902     C                   MOVEL     'SDBANKPD'    DBFILE
000371190902     C                   Z-ADD     001           DBASE
000372190902     C                   MOVEL     *BLANKS       DBKEY
000373190902     C                   MOVEL     'BANK'        DBKEY
000374190902     C                   MOVEL     'UTMD53762D'  DBPGM
000375190902     C                   MOVE      '1'           *INU7
000376190902     C                   MOVE      '1'           *INU8
000377190902     C                   MOVE      '1'           *INLR
000378190902     C                   OUT       LDA
000379190902     C                   EXSR      *PSSR
000380190902     C                   ENDIF
000381190912
000382190902     C                   OPEN      ACKEYAL
000383190902     C                   OPEN      XACKEYAL
000384190902     C                   OPEN      ACKEYL0
000385190912
000386190902     C                   WRITE     FMTW01
000387190902     C                   WRITE     FMTW04
000388190912
000389190902     C                   ENDSR
000390190912
000391190902      *****************************************************************
000392190902      /SPACE 5
000393190902      *****************************************************************
000394190902      *                                                               *
000395190912      *  *PSSR  - Program exception error routine                     *
000396190902      *                                                               *
000397190902      *****************************************************************
000398190912
000399190902     C     *PSSR         BEGSR
000400190902
000401190902     C                   IF        @RUN = *BLANK
000402190902     C                   EVAL      @RUN = 'Y'
000403190902     C                   DUMP
000404190902     C                   ENDIF
000405190902
000406190902     C                   EVAL      *INU7 = *ON
000407190902     C                   EVAL      *INU8 = *ON
000408190902     C                   EVAL      *INLR = *ON
000409190902     C                   RETURN
000410190902
000411190902     C                   ENDSR
000412190912
000413190912      *****************************************************************
000414190912      /SPACE 5
000415190902      *****************************************************************
000416190902      *                                                               *
000417190912      *  SRMOVE2 - Subroutine to move fields from XACKEYAL to         *
000418190912      *            Printer File                                       *
000419190912      *                                                               *
000420190902      *****************************************************************
000421190912
000422190902     C     SRMOVE2       BEGSR
000423190912
000424190912     C                   EVAL      XRNCDA1 = XNCD1
000425190912     C                   EVAL      XRNCDA2 = XNCD2
000426190912     C                   EVAL      XRNCDA3 = XNCD3
000427190912     C                   EVAL      XRNCDA4 = XNCD4
000428190912     C                   EVAL      XRNCDA5 = XNCD5
000429190912     C                   EVAL      XRNCDA6 = XNCD6
000430190912     C                   MOVE      XPRF1         XRPRFA1
000431190912     C                   MOVE      XPRF2         XRPRFA2
000432190912     C                   MOVE      XPRF3         XRPRFA3
000433190912     C                   MOVE      XPRF4         XRPRFA4
000434190912     C                   MOVE      XPRF5         XRPRFA5
000435190912     C                   MOVE      XPRF6         XRPRFA6
000436190912     C                   EVAL      XRAKEY = XAKEY
000442190912
000460190912      ** Overflow
000461190912
000462190902     C     *IN99         IFEQ      '1'
000463190902     C                   WRITE     FMTW01
000464190902     C                   WRITE     FMTW04
000465190902     C                   MOVE      '0'           *IN99
000466190902     C                   ENDIF
000467190912
000468190902     C                   WRITE     FMTW05
000469190912
000470190903     C                   ENDSR
000471190912
000472190912      *****************************************************************
