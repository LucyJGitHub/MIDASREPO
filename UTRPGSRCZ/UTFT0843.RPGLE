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
000140200320     FUTFT0843P1O    E             PRINTER OFLIND(*IN66)
000141200320     FUTFT0843AUO    E             PRINTER
000142200320     D SDBANK        E DS                  EXTNAME(SDBANKPD)
000143200320     D DSRUN           DS
000144200320      **  RUNDAT data area data structure (date format -ddmmmyy)
000145200320     D  RDAT                   1      7
000146200320     D  @DD                    1      2
000147200320     D  @MMM                   3      5
000148200320     D  @YY                    6      7
000149200320     D  RUND                   8     10P 0
000150200320     D  SSF                   11     11
000151200320     D  DATF                  12     12
000152200320     D  MBIN                  13     13
000153200320      *****************************************************************
000154200320      /EJECT
000155200320      *****************************************************************
000156200320      ** +--------------------------------------+
000157200320      ** ¦ D-specs                              ¦
000158200320      ** ¦ =======                              ¦
000159200320      ** +--------------------------------------+
000160200320     D ACTION          S              6
000161200320     D X1Counter       S              6  0
000162200320     D RCOUNT          S              6  0
000163200320     D DCOUNT          S              6  0
000164200320     D KEY             S              1
000165200320      ** The following /COPY line includes all the defined fields in the
000166200320      ** Program Status Data Structures.  They have meaningful
000167200320      ** names, prefixed by 'PS'.
000168200320     D/COPY ZACPYSRC,PSDS
000169200320      ** The following /COPY line includes (among others) the LDA layout
000170200320      ** and the copyright array definition:
000171200320     D/COPY ZACPYSRC,STD_D_SPEC
000172200320      **--------------------------------------------------------------------------------------------
000173200320      ** Short Data Structure
000174200320     D DSFDY         E DS                  EXTNAME(DSFDY)
000175200320      ** Mode Parameter
000176200320     D ModeParm        S              1A
000177200320     D Mode            S              6A
000178200320     D                 DS
000179200320     D WPLISTDD                1     15
000180200320     D WPREFDD                 1     13
000181200320     D BUFFER                 14     15
000182200320     D                 DS
000183200320     D WPLISTDQD               1     15
000184200320     D WPREFDQD                1     13
000185200320     DDDS1             DS
000186200320
000187200320     D RUNDT           DS
000188200320      *
000189200320      **  Access sdbankpd (via aobankr0)
000190200320      *
000191200320     C     PLIST1        PLIST
000192200320     C                   PARM      '*DBMSG  '    @RTCD             7
000193200320     C                   PARM      '*FIRST  '    @OPTN             7
000194200320     C     SDBANK        PARM      SDBANK        DSFDY
000195200320     C                   CALL      'AOBANKR0'    PLIST1
000196200320      *
000197200320      *   Retrieve rundate
000198200320      *
000199200320      *
000200200320     C     *DTAARA       DEFINE    RUNDAT        DSRUN
000201200320     C                   IN        DSRUN
000202200320     ******************************************************************
000203200320      /EJECT
000204200320      *****************************************************************
000205200320      *                                                               *
000206200320      * MAIN - Main Processing                                        *
000207200320      *                                                               *
000208200320      *****************************************************************
000209200320     C                   EXSR      *INZSR
000210200320     C
000211200320     C*    PKey          KLIST
000212200320     C*                  KFLD                    OTPREF
000213200320      * (UPDATE RECORDS) READ OTPAYDQD
000214200320     C                   MOVE      *BLANKS       BUFFER
000215200320     C     *LOVAL        SETLL     OTPAYQL0
000216200320     C                   READ      OTPAYQL0                               10
000217200320     C     *IN10         DOWEQ     '0'
000218200320      * Get 1st 13 characters
000219200320     C                   EVAL      NPREF = *BLANKS
000220200320     C                   MOVEL     OTPREF        WPREFDQD         13
000221200320      ** CHAIN NEW FILE BASED FROM OTPAYDQD
000222200320     C     WPLISTDQD     SETLL     OTPAY
000223200320     C                   READ      OTPAY                                  20
000224200320     C                   IF        NOT %EOF(OTPAY)
000225200320     C                   MOVEL     PREF          WPREFDD          13
000226200320     C                   IF        WPREFDD = WPREFDQD
000227200320     C                   IF        OTPREF <> PREF
000228200320     C                   Eval      NPREF = PREF
000229200320     C                   Eval      ACTION = 'UPDATE'
000230200320     C                   EVAL      STYPE = %SUBST(PREF:14:2)
000231200320     C                   ADD       1             NUPDTEDQD
000232200320     C                   EXSR      PRINTP1
000233200320     C                   EVAL      OTPREF = PREF
000234200320     C                   IF        *IN30 = *ON
000235200320     C                   UPDATE    OTPAYQD0
000236200320     C                   ENDIF
000237200320     C                   ENDIF
000238200320     C                   ELSE
000239200320     C                   EVAL      ACTION = 'DELETE'
000240200320     C                   EVAL      STYPE = %SUBST(OTPREF:14:2)
000241200320     C                   ADD       1             NDELDQD
000242200320     C                   EXSR      PRINTP1
000243200320     C                   IF        *IN30 = *ON
000244200320     C                   DELETE    OTPAYQL0
000245200320     C                   ENDIF
000246200320     C                   ENDIF
000247200320      *
000248200320     C                   ELSE
000249200320     C                   EVAL      ACTION = 'DELETE'
000250200320     C                   EVAL      STYPE = %SUBST(OTPREF:14:2)
000251200320     C                   EXSR      PRINTP1
000252200320     C                   IF        *IN30 = *ON
000253200320     C                   DELETE    OTPAYQL0
000254200320     C                   ENDIF
000255200320     C                   ENDIF
000256200320     C                   READ      OTPAYQL0                               10
000257200320     C                   ENDDO
000258200320     C
000259200320      * READ OTPAYDD
000260200320     C
000261200320     C     *LOVAL        SETLL     OTPAY
000262200320     C                   READ      OTPAY                                  40
000263200320     C     *IN40         DOWEQ     '0'
000264200320      * Get 1st 13 characters
000265200320     C                   MOVEL     PREF          WPREFDD
000266200320      ** CHAIN FILE
000267200320     C     PREF          CHAIN     OTPAYQL0
000268200320     C                   IF        NOT %FOUND(OTPAYQL0)
000269200320     C                   MOVE      PREF          OTPREF
000270200320     C                   Eval      ACTION = 'INSERT'
000271200320     C                   EVAL      STYPE = %SUBST(OTPREF:14:2)
000272200320     C                   ADD       1             NINSERTDD
000273200420     C                   EXSR      PRINTP1
000274200320     C                   IF        *IN30 = *ON
000275200320     C                   WRITE     OTPAYQD0
000276200320     C                   ENDIF
000277200320     C                   ENDIF
000278200320     C                   READ      OTPAY                                  40
000279200320     C                   ENDDO
000280200320     C                   EXSR      SRAUDIT
000281200320     C                   MOVE      '1'           *INLR
000282200320     C                   RETURN
000283200320     *****************************************************************
000284200320      /EJECT
000285200320      *****************************************************************
000286200320      *                                                               *
000287200320      *  PRINT SUBROUTINE                                             *
000288200320      *                                                               *
000289200320      *****************************************************************
000290200320     C     PRINTP1       BEGSR
000291200320      ** Print header on every start of page
000292200320      *
000293200320     C                   If        *IN66 = *On and X1Counter = 0
000294200320     C                   Write     HEADER1
000295200320     C                   Eval      *IN66 = *Off
000296200320     C                   Endif
000297200320      *
000298200320      ** Print Title Lines
000299200320      *
000300200320     C                   If        X1Counter = 0
000301200320     C                   Endif
000302200320      *
000303200320      ** If next page, write header and title line again
000304200320      *
000305200320     C                   If        X1Counter > 0 and *IN66 = *On
000306200320     C                   Eval      *IN66 = *Off
000307200320     C                   Endif
000308200320      *
000309200320      ** Print account details
000310200320      *
000311200320     C                   WRITE     DETAIL1
000312200320     C                   Eval      X1Counter += 1
000313200320     C                   ENDSR
000314200320     *****************************************************************
000315200320      /EJECT
000316200320      *****************************************************************
000317200320      *                                                               *
000318200320      *  SRAUDIT - Subroutine to Output Audit report and End Program. *
000319200320      *                                                               *
000320200320      *****************************************************************
000321200320     C     SRAUDIT       BEGSR
000322200320
000323200320      ** Output Report Header and File Controls.
000324200320     C                   WRITE     HEADAU
000325200320     C                   WRITE     CONTROL
000326200320
000327200320      ** If there is a DB Error, Output the DB Error Information.
000328200320     C     *INU7         IFEQ      *ON
000329200320     C                   WRITE     DBERROR
000330200320     C                   ELSE
000331200320
000332200320      ** Or, if no records read, Output "No Details" message.
000333200320     C     NINSERTDD     IFEQ      *ZERO
000334200320     C     NUPDTEDD      ANDEQ     *ZERO
000335200320     C     NDELDD        ANDEQ     *ZERO
000336200320     C     NINSERTDQD    ANDEQ     *ZERO
000337200320     C     NUPDTEDQD     ANDEQ     *ZERO
000338200320     C                   WRITE     NODTLS
000339200320     C                   ENDIF
000340200320     C                   ENDIF
000341200320
000342200320      ** End Program and Return.
000343200320     C                   SETON                                        LR
000344200320     C                   RETURN
000345200320
000346200320     C                   ENDSR
000347200320      *****************************************************************
000348200320      /EJECT
000349200320      *****************************************************************
000350200320      *
000351200320      *   INIT SUBROUTINE
000352200320      *
000353200320      *****************************************************************
000354200320     C     *INZSR        BEGSR
000355200320     C
000356200320     C     *ENTRY        PLIST
000357200320     C                   PARM                    ModeParm
000358200320     C                   EVAL      *IN30 = *ON
000359200320      *
000360200320     C                   If        ModeParm = 'U' or ModeParm = 'u'
000361200320     C                   Eval      Mode = 'UPDATE'
000362200320     C                   Eval      *IN30 = *ON
000363200320     C                   ELSE
000364200320     C                   If        ModeParm = 'A' or ModeParm = 'a'
000365200320     C                   Eval      Mode = 'AUDIT'
000366200320     C                   Eval      *IN30 = *OFF
000367200320     C                   Endif
000368200320     C                   Endif
000369200320      *  Seton overflow indicator to write the header on first print
000370200320      *
000371200320     C                   Eval      *IN66 = *On
000372200320     C                   Eval      *IN67 = *Off
000373200320     C                   ENDSR
000374200320      *
000375200320      /EJECT
000376200320      *
000377200320      *
000378200320** WCPY@
000379200420(c) Finastra International Limited 2020
