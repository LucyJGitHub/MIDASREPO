000100200320     H DEBUG
000101200320     H COPYRIGHT('(c) Finastra International Limited 2004')
000102200320      *****************************************************************
000103200320/*STD *  RPGBASEBND                                                   *
000104200320/*EXI *  TEXT('Midas LE CLE025 Aggregated Facility Initialisation')   *
000105200320      *****************************************************************
000106200320      *                                                               *
000107200320      *  Midas - Customer Funds Transfer Module                       *
000108200320      *                                                               *
000109200320      *  PRTF/UTFT0843P1 - FT MD045410 Utility Program                *
000110200320      *                                                               *
000111200320      *  (c) Finastra International Limited 2020                      *
000112200320      *                                                               *
000113200320      *  Last Amend No.   MD045410 *CREATE   Date 06Mar20             *
000114200320      *****************************************************************
000115200320      *                                                               *
000116200320      *  MD045410  - Some FT Outgoing Payments are missing their      *
000117200320      *              UDF records in T_GZOPAYEX.                       *
000118200320      *            - Corrected Payment Reference Field in OTPAYDQD    *
000119200320      *              to match records in OTPAYDD.                     *
000120200320      *                                                               *
000121200320      *****************************************************************
000122200320      *                                                               *
000123200320      *  Use of Indicators                                            *
000124200320      *                                                               *
000125200320      *                                                               *
000126200320      *****************************************************************
000127200320      /SPACE
000128200320      *****************************************************************
000129200320      *                                                               *
000130200320      *  Subroutine Index                                             *
000131200320      *                                                               *
000132200320      *****************************************************************
000133200320      ** +--------------------------------------+
000134200320      ** ¦ F-specs                              ¦
000135200320      ** ¦ =======                              ¦
000136200320      ** +--------------------------------------+
000137200320     FOTPAY     IF   E           K DISK
000139200320     FOTPAYQL0  UF A E           K DISK
000140200526     FTGZOPAYEX UF A E           K DISK
000141200320     FUTFT0843P1O    E             PRINTER OFLIND(*IN66)
000142200526     FUTFT0843P2O    E             PRINTER OFLIND(*IN68)
000143200320     FUTFT0843AUO    E             PRINTER
000144200320     D SDBANK        E DS                  EXTNAME(SDBANKPD)
000145200320     D DSRUN           DS
000146200320      **  RUNDAT data area data structure (date format -ddmmmyy)
000147200320     D  RDAT                   1      7
000148200320     D  @DD                    1      2
000149200320     D  @MMM                   3      5
000150200320     D  @YY                    6      7
000151200320     D  RUND                   8     10P 0
000152200320     D  SSF                   11     11
000153200320     D  DATF                  12     12
000154200320     D  MBIN                  13     13
000155200320      *****************************************************************
000156200320      /EJECT
000157200320      *****************************************************************
000158200320      ** +--------------------------------------+
000159200320      ** ¦ D-specs                              ¦
000160200320      ** ¦ =======                              ¦
000161200320      ** +--------------------------------------+
000162200320     D ACTION          S              6
000163200320     D X1Counter       S              6  0
000164200526     D X2Counter       S              6  0
000165200320     D RCOUNT          S              6  0
000166200320     D DCOUNT          S              6  0
000167200320     D KEY             S              1
000168200320      ** The following /COPY line includes all the defined fields in the
000169200320      ** Program Status Data Structures.  They have meaningful
000170200320      ** names, prefixed by 'PS'.
000171200320     D/COPY ZACPYSRC,PSDS
000172200320      ** The following /COPY line includes (among others) the LDA layout
000173200320      ** and the copyright array definition:
000174200320     D/COPY ZACPYSRC,STD_D_SPEC
000175200320      **--------------------------------------------------------------------------------------------
000176200320      ** Short Data Structure
000177200320     D DSFDY         E DS                  EXTNAME(DSFDY)
000178200320      ** Mode Parameter
000179200320     D ModeParm        S              1A
000180200320     D Mode            S              6A
000181200320     D                 DS
000182200320     D WPLISTDD                1     15
000183200320     D WPREFDD                 1     13
000184200320     D BUFFER                 14     15
000185200320     D                 DS
000186200320     D WPLISTDQD               1     15
000187200320     D WPREFDQD                1     13
000188200526     DDDS1             DS
000189200526     D TSPREF                         2
000190200320
000191200320     D RUNDT           DS
000192200320      *
000193200320      **  Access sdbankpd (via aobankr0)
000194200320      *
000195200320     C     PLIST1        PLIST
000196200320     C                   PARM      '*DBMSG  '    @RTCD             7
000197200320     C                   PARM      '*FIRST  '    @OPTN             7
000198200320     C     SDBANK        PARM      SDBANK        DSFDY
000199200320     C                   CALL      'AOBANKR0'    PLIST1
000200200320      *
000201200320      *   Retrieve rundate
000202200320      *
000203200320      *
000205200320     C     *DTAARA       DEFINE    RUNDAT        DSRUN
000206200320     C                   IN        DSRUN
000207200528     C
000222200320     ******************************************************************
000223200320      /EJECT
000224200320      *****************************************************************
000225200320      *                                                               *
000226200320      * MAIN - Main Processing                                        *
000227200320      *                                                               *
000228200320      *****************************************************************
000229200320     C                   EXSR      *INZSR
000230200320     C
000231200320     C*    PKey          KLIST
000232200320     C*                  KFLD                    OTPREF
000233200320      * (UPDATE RECORDS) READ OTPAYDQD
000234200320     C                   MOVE      *BLANKS       BUFFER
000235200320     C     *LOVAL        SETLL     OTPAYQL0
000236200320     C                   READ      OTPAYQL0                               10
000237200320     C     *IN10         DOWEQ     '0'
000238200320      * Get 1st 13 characters
000239200320     C                   EVAL      NPREF = *BLANKS
000240200320     C                   MOVEL     OTPREF        WPREFDQD         13
000241200320      ** CHAIN NEW FILE BASED FROM OTPAYDQD
000242200320     C     WPLISTDQD     SETLL     OTPAY
000243200320     C                   READ      OTPAY                                  20
000244200320     C                   IF        NOT %EOF(OTPAY)
000245200320     C                   MOVEL     PREF          WPREFDD          13
000246200320     C                   IF        WPREFDD = WPREFDQD
000247200320     C                   IF        OTPREF <> PREF
000248200320     C                   Eval      ACTION = 'UPDATE'
000249200527     C                   IF        ACTION = 'UPDATE'
000250200527     C                   MOVE      PREF          NPREF
000251200320     C                   EVAL      STYPE = %SUBST(PREF:14:2)
000252200320     C                   ADD       1             NUPDTEDQD
000253200320     C                   EXSR      PRINTP1
000254200527     C                   ENDIF
000255200320     C                   EVAL      OTPREF = PREF
000256200320     C                   IF        *IN30 = *ON
000257200320     C                   UPDATE    OTPAYQD0
000258200320     C                   ENDIF
000259200320     C                   ENDIF
000260200527     C
000261200320     C                   ELSE
000262200320     C                   EVAL      ACTION = 'DELETE'
000263200320     C                   EVAL      STYPE = %SUBST(OTPREF:14:2)
000264200320     C                   ADD       1             NDELDQD
000265200320     C                   EXSR      PRINTP1
000266200320     C                   IF        *IN30 = *ON
000267200320     C                   DELETE    OTPAYQL0
000268200320     C                   ENDIF
000269200320     C                   ENDIF
000270200320      *
000271200320     C                   ELSE
000272200320     C                   EVAL      ACTION = 'DELETE'
000273200320     C                   EVAL      STYPE = %SUBST(OTPREF:14:2)
000274200527     C                   ADD       1             NDELDQD
000275200320     C                   EXSR      PRINTP1
000276200320     C                   IF        *IN30 = *ON
000277200320     C                   DELETE    OTPAYQL0
000278200320     C                   ENDIF
000279200320     C                   ENDIF
000280200320     C                   READ      OTPAYQL0                               10
000281200320     C                   ENDDO
000282200320     C
000283200320      * READ OTPAYDD
000284200320     C
000285200320     C     *LOVAL        SETLL     OTPAY
000286200320     C                   READ      OTPAY                                  40
000287200320     C     *IN40         DOWEQ     '0'
000288200320      * Get 1st 13 characters
000289200320     C                   MOVEL     PREF          WPREFDD
000290200320      ** CHAIN FILE
000291200320     C     PREF          CHAIN     OTPAYQL0
000292200320     C                   IF        NOT %FOUND(OTPAYQL0)
000293200320     C                   MOVE      PREF          OTPREF
000294200320     C                   Eval      ACTION = 'INSERT'
000295200320     C                   EVAL      STYPE = %SUBST(OTPREF:14:2)
000296200320     C                   ADD       1             NINSERTDD
000297200420     C                   EXSR      PRINTP1
000298200320     C                   IF        *IN30 = *ON
000299200320     C                   WRITE     OTPAYQD0
000300200320     C                   ENDIF
000301200320     C                   ENDIF
000302200320     C                   READ      OTPAY                                  40
000303200320     C                   ENDDO
000304200520      ** INSERT MISSING RECORDS FROM OTPAYDD TO T_GZOPAYEX
000305200520     C
000306200526     C     *LOVAL        SETLL     OTPAY
000307200526     C                   READ      OTPAY                                  50
000308200526     C     *IN50         DOWEQ     '0'
000309200520      ** CHAIN FILE
000310200520     C     PREF          CHAIN     TGZOPAYEX
000311200520     C                   IF        NOT %FOUND(TGZOPAYEX)
000312200520     C                   MOVE      PREF          SPREF
000313200520     C                   Eval      ACTION = 'INSERT'
000314200527     C                   EVAL      PTYPE = %SUBST(SPREF:14:2)
000315200520     C                   ADD       1             NINSERTEXT
000316200526     C                   EXSR      PRINTP2
000317200526     C                   IF        *IN30 = *ON
000318200526     C                   WRITE     T_GZOPAYEX
000319200520     C                   ENDIF
000320200520     C                   ENDIF
000321200526     C                   READ      OTPAY                                  50
000322200526     C                   ENDDO
000323200520     C                   EXSR      SRAUDIT
000324200520     C                   MOVE      '1'           *INLR
000325200520     C                   RETURN
000326200320     *****************************************************************
000327200320      /EJECT
000328200320      *****************************************************************
000329200320      *                                                               *
000330200320      *  PRINT SUBROUTINE                                             *
000331200320      *                                                               *
000332200320      *****************************************************************
000333200320     C     PRINTP1       BEGSR
000334200320      ** Print header on every start of page
000335200320      *
000336200320     C                   If        *IN66 = *On and X1Counter = 0
000337200320     C                   Write     HEADER1
000338200320     C                   Eval      *IN66 = *Off
000339200320     C                   Endif
000340200320      *
000341200320      ** Print Title Lines
000342200320      *
000343200320     C                   If        X1Counter = 0
000344200320     C                   Endif
000345200320      *
000346200320      ** If next page, write header and title line again
000347200320      *
000348200320     C                   If        X1Counter > 0 and *IN66 = *On
000349200320     C                   Eval      *IN66 = *Off
000350200320     C                   Endif
000351200320      *
000352200320      ** Print account details
000353200320      *
000354200320     C                   WRITE     DETAIL1
000355200320     C                   Eval      X1Counter += 1
000356200320     C                   ENDSR
000357200526     C
000358200526      *****************************************************************
000359200526      *                                                               *
000360200526      *  PRINT SUBROUTINE                                             *
000361200526      *                                                               *
000362200526      *****************************************************************
000363200526     C     PRINTP2       BEGSR
000364200526      ** Print header on every start of page
000365200526      *
000366200526     C                   If        *IN68 = *On and X2Counter = 0
000367200526     C                   Write     HEADER2
000368200526     C                   Eval      *IN68 = *Off
000369200526     C                   Endif
000370200526      *
000371200526      ** Print Title Lines
000372200526      *
000373200526     C                   If        X2Counter = 0
000374200526     C                   Endif
000375200526      *
000376200526      ** If next page, write header and title line again
000377200526      *
000378200526     C                   If        X2Counter > 0 and *IN68 = *On
000379200526     C                   Eval      *IN68 = *Off
000380200526     C                   Endif
000381200526      *
000382200526      ** Print account details
000383200526      *
000384200526     C                   WRITE     DETAIL2
000385200526     C                   Eval      X2Counter += 1
000386200526     C                   ENDSR
000387200320     *****************************************************************
000388200320      /EJECT
000389200320      *****************************************************************
000390200320      *                                                               *
000391200320      *  SRAUDIT - Subroutine to Output Audit report and End Program. *
000392200320      *                                                               *
000393200320      *****************************************************************
000394200320     C     SRAUDIT       BEGSR
000395200320
000396200320      ** Output Report Header and File Controls.
000397200320     C                   WRITE     HEADAU
000398200320     C                   WRITE     CONTROL
000399200320
000400200320      ** If there is a DB Error, Output the DB Error Information.
000401200320     C     *INU7         IFEQ      *ON
000402200320     C                   WRITE     DBERROR
000403200320     C                   ELSE
000404200320
000405200320      ** Or, if no records read, Output "No Details" message.
000406200320     C     NINSERTDD     IFEQ      *ZERO
000407200320     C     NUPDTEDQD     ANDEQ     *ZERO
000408200526     C     NINSERTEXT    ANDEQ     *ZERO
000409200320     C                   WRITE     NODTLS
000410200320     C                   ENDIF
000411200320     C                   ENDIF
000412200320
000413200320      ** End Program and Return.
000414200320     C                   SETON                                        LR
000415200320     C                   RETURN
000416200320
000417200320     C                   ENDSR
000418200320      *****************************************************************
000419200320      /EJECT
000420200320      *****************************************************************
000421200320      *
000422200320      *   INIT SUBROUTINE
000423200320      *
000424200320      *****************************************************************
000425200320     C     *INZSR        BEGSR
000426200320     C
000427200320     C     *ENTRY        PLIST
000428200320     C                   PARM                    ModeParm
000429200320     C                   EVAL      *IN30 = *ON
000430200320      *
000431200320     C                   If        ModeParm = 'U' or ModeParm = 'u'
000432200320     C                   Eval      Mode = 'UPDATE'
000433200320     C                   Eval      *IN30 = *ON
000434200320     C                   ELSE
000435200320     C                   If        ModeParm = 'A' or ModeParm = 'a'
000436200320     C                   Eval      Mode = 'AUDIT'
000437200320     C                   Eval      *IN30 = *OFF
000438200320     C                   Endif
000439200320     C                   Endif
000440200320      *  Seton overflow indicator to write the header on first print
000441200320      *
000442200320     C                   Eval      *IN66 = *On
000443200320     C                   Eval      *IN67 = *Off
000444200526     C                   Eval      *IN68 = *On
000445200526     C                   Eval      *IN69 = *Off
000446200320     C                   ENDSR
000447200320      *
000448200320      /EJECT
000449200320      *
000450200320      *
000451200320** WCPY@
000452200420(c) Finastra International Limited 2020
