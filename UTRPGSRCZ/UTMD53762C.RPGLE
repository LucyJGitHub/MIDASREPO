000100190719     H DEBUG
000200190719     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2019')
000300190719      *****************************************************************
000400190719/*STD *  RPGBASEBND                                                   *
000500190902/*EXI *  TEXT('Midas UT Transfer Account Keys Setup')                 *
000600190719      *****************************************************************
000700190719      *                                                               *
000800190719      *  Midas - Standing Data                                        *
000900190719      *                                                               *
001000190902      *  UTMD053762C - Midas UT Transfer Account Keys Setup           *
001100190719      *                                                               *
001200190719      *  (c) Finastra Systems Technology, Inc. 2019                   *
001300190719      *                                                               *
001400190920      *  Last Amend No. MD053762  *CREATE    Date 16Jun19             *
001500190830      *                                                               *
001600190912      *---------------------------------------------------------------*
001800190719      *                                                               *
001900190902      *  MD053762 - Tiered Witholding Tax System Values               *
002000190912      *                                                               *
002200190719      *****************************************************************
002201190912      *                                                               *
002203190912      *  Function of Indicators                                       *
002204190912      *                                                               *
002205190912      *  10 - End of file XACKEYL1                                    *
002206190912      *  30 - Deals type indicator - LOKUP operation to TABA complete *
002207190912      *  70 - Output '*Continued*'                                    *
002208190912      *  99 - Overflow indicator                                      *
002209190912      *                                                               *
002210190912      *****************************************************************
002300190912      *                                                               *
002900190719      *  S U B R O U T I N E  I N D E X                               *
003000190719      *                                                               *
003100190912      *  *PSSR - Error processing                                     *
003200190912      *  *INZSR - Initialise                                          *
003300190912      *  SRAKEY - Account Key Processing                              *
003400190719      *                                                               *
003500190719      *****************************************************************
003600190912     FUT53762CP1O    E             PRINTER OFLIND(*IN99)
003601190912
003606190912      ** Midas SD Account Keys Detail
003607190913
003608190913     FACKEYAL   IF   E             DISK    INFSR(*PSSR)
003609190913     F                                     USROPN
003610190912
003800190913     FACKEYL0   UF   E           K DISK    INFSR(*PSSR)
003900190913     F                                     RENAME(ACKEYALF:ACKEYALFD)
003902190913     F                                     PREFIX(D)
004000190912
004100190912      ** Midas SD Account Keys Header
004101190912
004200190916     FACKEYAK   UF   E           K DISK    INFSR(*PSSR)
004300190719     F                                     USROPN
004400190912
004500190912      ** Midas SD Account Keys Update
004501190912
004600190916     FXACKEYAL0 UF A E           K DISK    INFSR(*PSSR)
004700190830     F                                     USROPN
004800190719     F                                     RENAME(ACKEYALF:ACKEYALF2)
004900190719     F                                     PREFIX(X)
005000190912
005100190719     D @RUN            S              1
005200190719     D ZWDTIN          S              8S 0
005300190719     D DateOut         S              8S 0
005400190719     D @@DAYN          S              5P 0
005500190719     D TimeStamp       S               Z
005600190912
005700190719     D SDBANK        E DS                  EXTNAME(SDBANKPD)
005800190719      ** Bank details
005900190912
006000190719     D DSFDY         E DS                  EXTNAME(DSFDY)
006100190719      ** First DS for access programs, short data structure
006200190912
006300190719     D DSSDY         E DS                  EXTNAME(DSSDY)
006400190719      ** First DS for access programs, long data structure
006500190912
006600190719     D LDA           E DS           256    EXTNAME(LDA)
006700190912
006800190719      ** Local data area for database error details
006900190719      ** *LOCK IN LDA immediately before and OUT LDA immediately
007000190719      ** after each database error handling.
007100190719      **
007200190719      **                                    134 141 DBFILE
007300190719      **       Defines:                     142 170 DBKEY
007400190719      **                                    171 180 DBPGM
007500190719      **                                    181 1830DBASE
007600190719
007700190719      ** Main Processing
007701190912
007800190719     C                   Exsr      SRAKEY
007801190902     C                   WRITE     FMTW05
007900190912
008000190912     C                   EVAL      *INLR = *ON
008001190912
008002190912      *****************************************************************
008100190719      /SPACE 5
008200190912      *****************************************************************
008201190912      *                                                               *
008300190912      *  SRAKEY - Account Key Processing                              *
008301190912      *                                                               *
008400190912      *****************************************************************
008401190912
008500190719     C     SRAKEY        BEGSR
008600190719
008700190719     C                   Z-ADD     0             COUNT             4 0
008800190913     C                   READ      ACKEYAL
008900190913     C                   DOW       NOT %EOF(ACKEYAL)
009000190912
009001190913     C                   MOVE      AKEY          WKAKEY           14
009002190913
009003190913      ** Only process keys for deal types TD, IT and CD
009101190912
009200190719     C                   IF        %SUBST(AKEY:1:2) = 'TD' or
009300190719     C                             %SUBST(AKEY:1:2) = 'IT' or
009400190719     C                             %SUBST(AKEY:1:2) = 'CD'
009401190912
009500190912      ** For existing tax key, update to be 1 sided tax standard Tax key.
009600190912      ** Write a new new dual sided Gross tax key
009601190912
009700190719     C                   IF        (%SUBST(AKEY:3:1) = 'I' or
009800190719     C                             %SUBST(AKEY:3:1) = 'M') and
009900190719     C                             %SUBST(AKEY:10:1) = 'X'
010000190719     C                   EXSR      SRMOVE
010100190719     C                   EVAL      %SUBST(XAKEY:10:1) = 'T'
010200190719     C                   EVAL      %SUBST(XAKEY:8:1) = 'G'
010201190916     C     XAKEY         CHAIN     XACKEYAL0
010202190916     C                   IF        NOT %FOUND(XACKEYAL0)
010203190916     C                   EVAL      XEACC = 0
010300190719     C                   WRITE     ACKEYALF2
010301190902     C                   EXSR      SRMOVE2
010400190719     C                   ADD       1             COUNT
010401190916     C                   ENDIF
010500190719     C                   EVAL      %SUBST(AKEY:10:1) = 'T'
010501190913     C     AKEY          CHAIN     ACKEYL0
010502190916     C                   IF        %FOUND(ACKEYL0)
010600190913     C                   EVAL      DPRF1 = 0
010700190913     C                   EVAL      DNCD1 = *BLANKS
010800190913     C                   EVAL      DACD1 = 0
010900190913     C                   UPDATE    ACKEYALFD
010901190916     C                   ENDIF
011000190912
011100190719     C                   ENDIF
011200190912
011300190912      ** For existing Interest Date Payment key, write new Gross Interest
011400190912      ** Payment Key, write Taxable Interest Key, Write Net Interest key
011500190912      ** and Gross Interest key.
011600190912      ** Update existing key to be single sided debit only
011601190912
011700190719     C                   IF        %SUBST(AKEY:3:1) = 'I' and
011800190719     C                             %SUBST(AKEY:10:1) = 'I' and
011900190719     C                             %SUBST(AKEY:6:1) = ' '
011901190913
012000190719     C                   EXSR      SRMOVE
012100190719     C                   EVAL      %SUBST(XAKEY:9:1) = 'T'
012200190719     C                   EVAL      %SUBST(XAKEY:8:1) = 'G'
012201190916     C     XAKEY         CHAIN     XACKEYAL0
012202190916     C                   IF        NOT %FOUND(XACKEYAL0)
012203190916     C                   EVAL      XEACC = 0
012300190719     C                   WRITE     ACKEYALF2
012301190902     C                   EXSR      SRMOVE2
012400190719     C                   ADD       1             COUNT
012401190916     C                   ENDIF
012500190912
012600190719     C                   EXSR      SRMOVE
012700190719     C                   EVAL      %SUBST(XAKEY:9:1) = 'T'
012701190913     C                   EVAL      %SUBST(XAKEY:8:1) = ' '
012702190913     C     XAKEY         CHAIN     ACKEYL0
012703190913     C                   IF        NOT %FOUND(ACKEYL0)
012704190916     C     XAKEY         CHAIN     XACKEYAL0
012705190916     C                   IF        NOT %FOUND(XACKEYAL0)
012800190719     C                   EVAL      XPRF4 = 0
012900190719     C                   EVAL      XNCD4 = *BLANKS
013000190719     C                   EVAL      XACD4 = 0
013001190916     C                   EVAL      XEACC = 0
013100190719     C                   WRITE     ACKEYALF2
013101190910     C                   EXSR      SRMOVE2
013102190916     C                   ADD       1             COUNT
013103190916     C                   ENDIF
013105190910     C                   ELSE
013106190913     C     XAKEY         CHAIN     ACKEYL0
013107190916     C                   IF        %FOUND(ACKEYL0)
013108190913     C                   EVAL      DPRF4 = 0
013109190913     C                   EVAL      DNCD4 = *BLANKS
013110190913     C                   EVAL      DACD4 = 0
013111190913     C                   UPDATE    ACKEYALFD
013112190913     C                   EVAL      AKEY = WKAKEY
013113190916     C                   ENDIF
013114190911     C                   ENDIF
013200190916
013400190719     C                   EXSR      SRMOVE
013500190719     C                   EVAL      %SUBST(XAKEY:10:1) = 'N'
013501190913     C                   EVAL      %SUBST(XAKEY:9:1) = ' '
013502190913     C                   EVAL      %SUBST(XAKEY:8:1) = ' '
013600190910
013801190910      ** check if record exists in ACKEYALF
013802190912
013803190913     C     XAKEY         CHAIN     ACKEYL0
013804190913     C                   IF        NOT %FOUND(ACKEYL0)
013805190916     C     XAKEY         CHAIN     XACKEYAL0
013806190916     C                   IF        NOT %FOUND(XACKEYAL0)
013807190910     C                   EVAL      XPRF1 = 0
013808190910     C                   EVAL      XNCD1 = *BLANKS
013809190910     C                   EVAL      XACD1 = 0
013810190916     C                   EVAL      XEACC = 0
013811190910     C                   WRITE     ACKEYALF2
013812190910     C                   EXSR      SRMOVE2
013813190916     C                   ADD       1             COUNT
013814190916     C                   ENDIF
013815190910     C                   ELSE
013816190913     C     XAKEY         CHAIN     ACKEYL0
013817190916     C                   IF        %FOUND(ACKEYL0)
013818190913     C                   EVAL      DPRF1 = 0
013819190913     C                   EVAL      DNCD1 = *BLANKS
013820190913     C                   EVAL      DACD1 = 0
013821190913     C                   UPDATE    ACKEYALFD
013822190913     C                   EVAL      AKEY = WKAKEY
013823190916     C                   ENDIF
013824190910     C                   ENDIF
013900190916
014200190719     C                   EXSR      SRMOVE
014300190719     C                   EVAL      %SUBST(XAKEY:10:1) = 'N'
014301190913     C                   EVAL      %SUBST(XAKEY:9:1) = ' '
014400190719     C                   EVAL      %SUBST(XAKEY:8:1) = 'G'
014401190916     C     XAKEY         CHAIN     XACKEYAL0
014402190916     C                   IF        NOT %FOUND(XACKEYAL0)
014500190719     C                   EVAL      XPRF4 = 0
014600190719     C                   EVAL      XNCD4 = *BLANKS
014700190719     C                   EVAL      XACD4 = 0
014800190719     C                   EVAL      XPRF1 = 0
014900190719     C                   EVAL      XNCD1 = *BLANKS
015000190719     C                   EVAL      XACD1 = 0
015001190916     C                   EVAL      XEACC = 0
015100190719     C                   WRITE     ACKEYALF2
015101190902     C                   EXSR      SRMOVE2
015102190912     C                   ADD       1             COUNT
015103190916     C                   ENDIF
015300190912
015301190913     C     AKEY          CHAIN     ACKEYL0
015302190916     C                   IF        %FOUND(ACKEYL0)
015303190913     C                   EVAL      DPRF4 = 0
015304190913     C                   EVAL      DNCD4 = *BLANKS
015305190913     C                   EVAL      DACD4 = 0
015306190913     C                   UPDATE    ACKEYALFD
015307190916     C                   ENDIF
015308190913
015800190719     C                   ENDIF
015900190912
016000190912      ** For existing Maturity Settlement key, write new Gross Maturity
016100190912      ** Settlement key
016101190912
016200190719     C                   IF        %SUBST(AKEY:3:1) = 'M' and
016201190916     C                             %SUBST(AKEY:9:1) = ' ' and
016300190719     C                             %SUBST(AKEY:10:1) = 'B'
016400190719     C                   EXSR      SRMOVE
016500190719     C                   EVAL      %SUBST(XAKEY:8:1) = 'G'
016501190916     C     XAKEY         CHAIN     XACKEYAL0
016502190916     C                   IF        NOT %FOUND(XACKEYAL0)
016503190916     C                   EVAL      XEACC = 0
016600190719     C                   WRITE     ACKEYALF2
016601190902     C                   EXSR      SRMOVE2
016700190719     C                   ADD       1             COUNT
016800190719     C                   ENDIF
016801190916     C                   ENDIF
016900190912
017000190912      ** For existing Maturity Interest key, write new taxable interest key
017100190912      ** and update existing key to have credit side details removed
017101190912
017200190719     C                   IF        %SUBST(AKEY:3:1) = 'M' and
017300190719     C                             %SUBST(AKEY:10:1) = 'I' and
017301190916     C                             %SUBST(AKEY:9:1) = ' ' and
017400190719     C                             %SUBST(AKEY:6:1) = ' '
017500190719     C                   EXSR      SRMOVE
017600190719     C                   EVAL      %SUBST(XAKEY:9:1) = 'T'
017602190913     C     XAKEY         CHAIN     ACKEYL0
017603190913     C                   IF        NOT %FOUND(ACKEYL0)
017604190916     C     XAKEY         CHAIN     XACKEYAL0
017605190916     C                   IF        NOT %FOUND(XACKEYAL0)
017700190719     C                   EVAL      XPRF4 = 0
017800190719     C                   EVAL      XNCD4 = *BLANKS
017900190719     C                   EVAL      XACD4 = 0
017901190916     C                   EVAL      XEACC = 0
018000190719     C                   WRITE     ACKEYALF2
018001190902     C                   EXSR      SRMOVE2
018100190719     C                   ADD       1             COUNT
018101190916     C                   ENDIF
018200190910     C                   ELSE
018300190913     C                   EVAL      DPRF4 = 0
018400190913     C                   EVAL      DNCD4 = *BLANKS
018500190913     C                   EVAL      DACD4 = 0
018600190913     C                   UPDATE    ACKEYALFD
018601190913     C                   EVAL      AKEY = WKAKEY
018700190719     C                   ENDIF
018701190916
018702190916     C     AKEY          CHAIN     ACKEYL0
018703190916     C                   IF        %FOUND(ACKEYL0)
018704190916     C                   EVAL      DPRF4 = 0
018705190916     C                   EVAL      DNCD4 = *BLANKS
018706190916     C                   EVAL      DACD4 = 0
018707190916     C                   UPDATE    ACKEYALFD
018708190916     C                   ENDIF
018709190916
018710190911     C                   ENDIF
018711190913     C                   ENDIF
019000190912
019100190913     C                   READ      ACKEYAL
019200190719     C                   ENDDO
019201190913
019400190913     C                   CLOSE     ACKEYAL
019500190916     C                   CLOSE     XACKEYAL0
019600190719     C                   OPEN      ACKEYAK
019700190719     C                   READ      ACKEYAK
019800190719     C                   ADD       COUNT         NREC1
019900190719     C                   ADD       COUNT         NINS
020000190719     C                   UPDATE    ACKEYAKF
020100190719     C                   CLOSE     ACKEYAK
020200190912
020201190902     C                   IF        COUNT = 0
020202190902     C                   WRITE     FMTW02
020203190902     C                   ENDIF
020204190912
020300190719     C                   ENDSR
020400190719
020500190719      *****************************************************************
020600190719      /SPACE 5
020700190719      *****************************************************************
020701190912      *                                                               *
020800190912      *  SRMOVE - Subroutine to move fields from ACKEYAL to XACKEYAL  *
020801190912      *                                                               *
020900190719      *****************************************************************
020901190912
021000190719     C     SRMOVE        BEGSR
021100190912
021200190719     C                   EVAL      XRECI = RECI
021300190719     C                   EVAL      XQQAKEY =  QQAKEY
021400190719     C                   EVAL      XZZ002 = ZZ002
021500190719     C                   EVAL      XACD1QQ = ACD1QQ
021600190719     C                   EVAL      XACD2QQ = ACD2QQ
021700190719     C                   EVAL      XACD3QQ = ACD3QQ
021800190719     C                   EVAL      XACD4QQ = ACD4QQ
021900190719     C                   EVAL      XACD5QQ = ACD5QQ
022000190719     C                   EVAL      XACD6QQ = ACD6QQ
022100190719     C                   EVAL      XNCD1 = NCD1
022200190719     C                   EVAL      XNCD2 = NCD2
022300190719     C                   EVAL      XNCD3 = NCD3
022400190719     C                   EVAL      XNCD4 = NCD4
022500190719     C                   EVAL      XNCD5 = NCD5
022600190719     C                   EVAL      XNCD6 = NCD6
022700190719     C                   EVAL      XPRF1 = PRF1
022800190719     C                   EVAL      XPRF2 = PRF2
022900190719     C                   EVAL      XPRF3 = PRF3
023000190719     C                   EVAL      XPRF4 = PRF4
023100190719     C                   EVAL      XPRF5 = PRF5
023200190719     C                   EVAL      XPRF6 = PRF6
023300190719     C                   EVAL      XZZ034 = ZZ034
023400190719     C                   EVAL      XLCD = LCD
023500190719     C                   EVAL      XCHTP = CHTP
023600190719     C                   EVAL      XTNLU = TNLU
023700190719     C                   EVAL      XACD1 = ACD1
023800190719     C                   EVAL      XACD2 = ACD2
023900190719     C                   EVAL      XACD3 = ACD3
024000190719     C                   EVAL      XACD4 = ACD4
024100190719     C                   EVAL      XACD5 = ACD5
024200190719     C                   EVAL      XACD6 = ACD6
024300190719     C                   EVAL      XAKEY = AKEY
024400190719     C                   EVAL      XZONE = ZONE
024500190719     C                   EVAL      XIUSR = IUSR
024600190719     C                   EVAL      XAUSR = AUSR
024700190719     C                   EVAL      XXUSR = XUSR
024800190719     C                   EVAL      XAACC = AACC
024900190719     C                   EVAL      XEACC = EACC
025000190719     C                   EVAL      XGPDT = GPDT
025100190719     C                   EVAL      XASQ1 = ASQ1
025200190719     C                   EVAL      XASQ2 = ASQ2
025300190719     C                   EVAL      XASQ3 = ASQ3
025400190719     C                   EVAL      XASQ4 = ASQ4
025500190719     C                   EVAL      XASQ5 = ASQ5
025600190719     C                   EVAL      XASQ6 = ASQ6
025700190912
025800190719     C                   ENDSR
025801190912
025900190719      *****************************************************************
026000190719      /SPACE 5
026100190719      *****************************************************************
026101190912      *                                                               *
026200190912      *  *INZSR - Program Initialisation routine                      *
026201190912      *                                                               *
026300190719      *****************************************************************
026400190719     C     *INZSR        BEGSR
026500190719
026600190912     C     *DTAARA       DEFINE                  LDA
026800190912
026900190719      ** Access Bank Details
027000190912
027100190719     C                   CALL      'AOBANKR0'
027200190719     C                   PARM      '*MSG   '     PRTCD             7
027300190719     C                   PARM      '*FIRST '     POPTN             7
027400190719     C     SDBANK        PARM      SDBANK        DSFDY
027500190912
027600190719     C     PRTCD         IFNE      *BLANKS
027700190719     C     *LOCK         IN        LDA
027800190719     C                   MOVEL     'SDBANKPD'    DBFILE
027900190719     C                   Z-ADD     001           DBASE
028000190719     C                   MOVEL     *BLANKS       DBKEY
028100190719     C                   MOVEL     'BANK'        DBKEY
028200190719     C                   MOVEL     'XX000340'    DBPGM
028300190719     C                   MOVE      '1'           *INU7
028400190719     C                   MOVE      '1'           *INU8
028500190719     C                   MOVE      '1'           *INLR
028600190719     C                   OUT       LDA
028700190719     C                   EXSR      *PSSR
028800190719     C                   ENDIF
028900190912
029000190913     C                   OPEN      ACKEYAL
029100190916     C                   OPEN      XACKEYAL0
029200190912
029201190902     C                   WRITE     FMTW01
029202190902     C                   WRITE     FMTW04
029203190912
029204190902     C                   ENDSR
029205190902
029400190719      *****************************************************************
029500190719      /SPACE 5
029600190719      *****************************************************************
029700190719      *                                                               *
029800190912      *  *PSSR  - Program exception error routine                     *
029900190719      *                                                               *
030000190719      *****************************************************************
030100190719     C     *PSSR         BEGSR
030200190719
030300190719     C                   IF        @RUN = *BLANK
030400190719     C                   EVAL      @RUN = 'Y'
030500190719     C                   DUMP
030600190719     C                   ENDIF
030700190719
030800190719     C                   EVAL      *INU7 = *ON
030900190719     C                   EVAL      *INU8 = *ON
031000190719     C                   EVAL      *INLR = *ON
031100190719     C                   RETURN
031101190912
031300190719     C                   ENDSR
031301190912
031302190912      *****************************************************************
031303190912      /SPACE 5
031400190719      *****************************************************************
031401190902      *                                                               *
031402190912      *  SRMOVE2 - Subroutine to move fields from XACKEYAL to         *
031403190912      *            Printer File                                       *
031404190912      *                                                               *
031405190902      *****************************************************************
031406190912
031407190902     C     SRMOVE2       BEGSR
031408190912
031409190912     C                   EVAL      XRNCDA1 = XNCD1
031419190912     C                   EVAL      XRNCDA2 = XNCD2
031420190912     C                   EVAL      XRNCDA3 = XNCD3
031421190912     C                   EVAL      XRNCDA4 = XNCD4
031422190912     C                   EVAL      XRNCDA5 = XNCD5
031423190912     C                   EVAL      XRNCDA6 = XNCD6
031424190912     C                   MOVE      XPRF1         XRPRFA1
031425190912     C                   MOVE      XPRF2         XRPRFA2
031426190912     C                   MOVE      XPRF3         XRPRFA3
031427190912     C                   MOVE      XPRF4         XRPRFA4
031428190912     C                   MOVE      XPRF5         XRPRFA5
031429190912     C                   MOVE      XPRF6         XRPRFA6
031430190912     C                   EVAL      XRAKEY = XAKEY
031441190912
031459190912      ** Overflow
031460190912
031461190902     C     *IN99         IFEQ      '1'
031462190902     C                   WRITE     FMTW01
031463190902     C                   WRITE     FMTW04
031464190902     C                   MOVE      '0'           *IN99
031465190902     C                   ENDIF
031466190912
031467190902     C                   WRITE     FMTW05
031479190912
031481190902     C                   ENDSR
031482190902
031495190912      *****************************************************************
