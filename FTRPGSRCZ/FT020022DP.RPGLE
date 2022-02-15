000100220214     H DEBUG
000200220214      *****************************************************************
000300220214/*STD *  RPGBASEBND                                                   *
000400220214/*EXI *  TEXT('Midas MX Element Enquiry')                             *
000500220214      *****************************************************************
000600220214      *                                                               *
000700220214      *  Midas - Funds Transfer Module                                *
000800220214      *                                                               *
000900220214      *  FT020022DP - MX Element Data Enquiry                         *
001000220214      *                                                               *
001100220214      *  (c) Finastra International Limited 2021                      *
001200220214      *                                                               *
001300220214      *  Last Amend No. CSW122  *CREATE    Date 04Oct21               *
001400220214      *                                                               *
001500220214      *****************************************************************
001600220214      *                                                               *
001700220214      *  CSW122 - SWIFT ISO 20022                                     *
001800220214      *                                                               *
001900220214      *****************************************************************
002000220214      *
002100220214     FFT020022DFCF   E             WORKSTN INFSR(*PSSR)
002200220214     F                                     INFDS(INFDS1)
002300220214     F                                     SFILE(FT020022S0:S0RRN)
002400220214     FMEISOML1  IF   E           K DISK    INFSR(*PSSR)
002500220214     FMEDESCL1  IF   E           K DISK    INFSR(*PSSR)
002600220214     FMEISODL1  IF   E           K DISK    INFSR(*PSSR)
002700220214     FMEINDTL0  IF   E           K DISK    INFSR(*PSSR)
002800220214     FMEIN35L0  IF   E           K DISK    INFSR(*PSSR)
002900220214
003000220214      *****************************************************************
003100220214      *                                                               *
003200220214      *  F U N C T I O N   O F   I N D I C A T O R S                  *
003300220214      *                                                               *
003400220214      *   KC - F3  Exit                                               *
003500220214      *   KL - F12 Previous                                           *
003600220214      *                                                               *
003700220214      *   30 - S0 SFLDSPCTL                                           *
003800220214      *   31 - S0 SFLDSP                                              *
003900220214      *   32 - S0 SFLEND                                              *
004000220214      *   33 - S0 SFLNXTCHG                                           *
004100220214      *   39 - S0 ROLLUP                                              *
004200220214      *                                                               *
004300220214      *****************************************************************
004400220214      *
004500220214      ** File Information Data structure for Display file
004600220214      *
004700220214     D INFDS1          DS
004800220214     D  INSFRC               378    379B 0
004900220214      *
005000220214      ** Program status data structure
005100220214      *
005200220214     D PSDS           SDS
005300220214     D  PGM              *PROC
005400220214     D  WSID                 244    253
005500220214     D  USER                 254    263
005600220214      *
005700220214      ** Data Structure to pass parameters to Access programs
005800220214      *
005900220214     D*AOFMTS        E DS                  EXTNAME(DSFDY)
006000220214      *
006100220214     D LDA           E DS           256    EXTNAME(LDA)
006200220214      *
006300220214     D RUNDAT        E DS                  EXTNAME(RUNDAT)
006400220214      *
006500220214      ** Work Variables
006600220214     D PMTAG1          S              5A
006700220214     D PMTAG2          S              5A
006800220214     D PMSGRF          S              8S 0
006900220214     D PREF            S             15A
007000220214     D PEXIT           S              1A
007100220214     D PCANC           S              1A
007200220214     D WrkUETR         S             36A
007300220214     D WrkF20          S             20A
007400220214     D WrkLen          S              3S 0
007500220214     D WFound          S              1A
007600220214     D WMXRef          S              8S 0
007700220214     D WSeqNo          S              4S 0
007800220214     D WrkENAM         S            100A
007900220214     D ZAPGM           S             10A
008000220214     D ZAPGRL          S              5A
008100220214     D ZAMSID          S              7A
008200220214     D ZAMSGF          S             10A
008300220214     D ZAMSDA          S            132A
008400220214     D ZAMSTP          S              7A
008500220214     D S0RRN           S              5S 0
008600220214     D LINENO          S              2S 0
008700220214     D @RUN            S              1A
008800220214      /EJECT
008900220214
009000220214      ** Main Processing
009100220214     C                   EXSR      SRINIT
009200220214
009300220214     C     PMSGRF        IFNE      *ZERO
009400220214     C                   MOVE      '1'           *INKE
009500220214
009600220214     C     *INKC         DOWEQ     '0'
009700220214     C     *INKL         ANDEQ     '0'
009800220214
009900220214      ** Initialize and Load subfile if *INKE has been set on
010000220214      ** (First time through or change of SETLL fields)
010100220214
010200220214     C   KE              EXSR      SrInsSUBF
010300220214     C   KE              EXSR      SrLoadSUBF
010400220214
010500220214      ** Display screen
010600220214
010700220214     C                   EXSR      SrDisplay
010800220214
010900220214      ** Process screen if F3 and F12 not taken
011000220214
011100220214     C     *INKC         IFEQ      '0'
011200220214     C     *INKL         ANDEQ     '0'
011300220214
011400220214     C     *IN39         CASEQ     '1'           SrLoadSUBF
011500220214     C                   END
011600220214     C                   END
011700220214
011800220214     C                   ENDDO
011900220214     C                   ELSE
012000220214     C                   WRITE     FT020022C2
012100220214     C                   EXFMT     FT020022F3
012200220214     C                   ENDIF
012300220214
012400220214      ** F3 is pressed
012500220214
012600220214     C                   IF        *INKC = *ON
012700220214     C                   EVAL      PEXIT = 'Y'
012800220214     C                   ELSEIF    *INKL = *ON
012900220214     C                   EVAL      PCANC = 'Y'
013000220214     C                   ENDIF
013100220214     C                   SETON                                        LR
013200220214     C                   RETURN
013300220214      /EJECT
013400220214      *******************************************************************
013500220214      *                                                                 *
013600220214      * SrInsSUBF - Initialize Subfile                                  *
013700220214      *                                                                 *
013800220214      *******************************************************************
013900220214
014000220214     C     SrInsSUBF     BEGSR
014100220214      *
014200220214      ** Clear subfile
014300220214      *
014400220214     C                   MOVEA     '0000'        *IN(30)
014500220214     C                   WRITE     FT020022C0
014600220214     C                   MOVE      '1'           *IN30
014700220214     C                   Z-ADD     *ZERO         WSeqNo
014800220214
014900220214     C                   Z-ADD     0             S0RRN
015000220214     C                   Z-ADD     0             X0RRN
015100220214
015200220214     C                   IF        WFound  = 'Y'
015300220214
015400220214      ** Get MX Message Reference
015500220214
015600220214     C     KMEISOM       CHAIN     MEISOML1
015700220214     C                   IF        %FOUND(MEISOML1)
015800220214     C                   EVAL      WMXRef = OMMSGR
015900220214     C                   Z-ADD     1             WSeqNo
016000220214     C     KMEISOD       SETLL     MEISODL1
016100220214     C     KMEISOD       READE     MEISODL1                               32
016200220214     C                   EVAL      WrkENAM = MEENAM
016300220214     C                   ELSE
016400220214     C                   EVAL      WMXRef = *ZERO
016500220214     C                   EVAL      WFound = 'N'
016600220214     C                   ENDIF
016700220214
016800220214     C                   ENDIF
016900220214      *
017000220214     C                   ENDSR
017100220214      /EJECT
017200220214      *******************************************************************
017300220214      *                                                                 *
017400220214      * SrLoadSUBF - Load Subfile                                       *
017500220214      *                                                                 *
017600220214      *******************************************************************
017700220214      *
017800220214     C     SrLoadSUBF    BEGSR
017900220214
018000220214     C                   Z-ADD     0             LINENO
018100220214     C                   Z-ADD     X0RRN         S0RRN
018200220214
018300220214      ** Load SFL page until SFL page full or end of file
018400220214
018500220214     C     *IN32         DOWEQ     '0'
018600220214     C     LINENO        ANDLE     17
018700220214     C     WFound        ANDEQ     'Y'
018800220214
018900220214     C                   ADD       1             LINENO
019000220214
019100220214     C     LINENO        IFLE      17
019200220214
019300220214      ** Element Value with more than 60 char
019400220214
019500220214     C                   IF        WrkLen > 60
019600220214     C                   EVAL      S0EVAL = %SUBST(MEEVAL:66)
019700220214     C                   EVAL      S0ELEM = *BLANKS
019800220214     C                   ADD       1             S0RRN                31
019900220214     C                   Z-ADD     S0RRN         C0SFRC
020000220214     C                   Z-ADD     0             WrkLen
020100220214     C                   WRITE     FT020022S0
020200220214
020300220214     C                   ELSE
020400220214
020500220214      ** First 60 char of Element Value
020600220214
020700220214     C                   EVAL      S0EVAL = MEEVAL
020800220214     C                   EXSR      SrEName
020900220214     C                   ADD       1             S0RRN                31
021000220214
021100220214      ** Write subfile record number
021200220214
021300220214     C                   Z-ADD     S0RRN         C0SFRC
021400220214     C                   WRITE     FT020022S0
021500220214     C                   ADD       1             WSeqNo
021600220214
021700220214      ** Check the length of Element Value
021800220214
021900220214     C                   EVAL      WrkLen = %LEN(%TRIM(MEEVAL))
022000220214     C                   ENDIF
022100220214
022200220214     C                   ENDIF
022300220214
022400220214      ** Read next record
022500220214
022600220214     C     LINENO        IFLE      17
022700220214     C     WrkLen        ANDLE     60
022800220214     C                   EVAL      WrkENAM = *BLANKS
022900220214     C     KMEISOD       READE     MEISODL1                               32
023000220214     C                   EVAL      WrkENAM = MEENAM
023100220214     C                   ENDIF
023200220214     C                   ENDDO
023300220214
023400220214      ** Set Subfile Record Number and Save
023500220214
023600220214     C                   Z-ADD     S0RRN         X0RRN
023700220214     C                   EVAL      X0ELEM = DEDESC
023800220214     C                   EVAL      X0EVAL = MEEVAL
023900220214
024000220214     C                   ENDSR
024100220214      /EJECT
024200220214      *******************************************************************
024300220214      *                                                                 *
024400220214      * SrDisplay - Display Subfile                                     *
024500220214      *                                                                 *
024600220214      *******************************************************************
024700220214      *
024800220214     C     SrDisplay     BEGSR
024900220214
025000220214      ** If no records displayed, output message
025100220214
025200220214     C     S0RRN         IFEQ      0
025300220214     C                   MOVEL     'Y2USRMSG'    ZAMSGF
025400220214     C                   MOVEL     'Y2U0008'     ZAMSID
025500220214     C                   EXSR      ZASNMS
025600220214     C                   ENDIF
025700220214
025800220214     C                   IF        WFound = 'Y'
025900220214     C                   WRITE     FT020022C2
026000220214     C                   WRITE     FT020022F2
026100220214     C                   EXFMT     FT020022C0
026200220214     C                   ELSE
026300220214     C                   WRITE     FT020022C2
026400220214     C                   EXFMT     FT020022F3
026500220214     C                   ENDIF
026600220214
026700220214      ** Clear messages from program message queue
026800220214
026900220214     C                   CALL      'Y2CLMSC'
027000220214     C                   PARM                    ZAPGM
027100220214     C                   PARM      '*SAME'       ZAPGRL
027200220214
027300220214     C                   ENDSR
027400220214      /EJECT
027500220214      *******************************************************************
027600220214      *                                                                 *
027700220214      * ZASNMS - Send Message to Program Message Queue                  *
027800220214      *                                                                 *
027900220214      *******************************************************************
028000220214      *
028100220214     C     ZASNMS        BEGSR
028200220214
028300220214     C     ZAMSGF        IFEQ      *BLANKS
028400220214     C                   MOVEL     'XXUSRMSG'    ZAMSGF
028500220214     C                   ENDIF
028600220214
028700220214     C                   CALL      'Y2SNMGC'
028800220214     C                   PARM                    ZAPGM
028900220214     C                   PARM                    ZAPGRL
029000220214     C                   PARM                    ZAMSID
029100220214     C                   PARM                    ZAMSGF
029200220214     C                   PARM                    ZAMSDA
029300220214     C                   PARM                    ZAMSTP
029400220214
029500220214     C                   MOVEL     *BLANKS       ZAMSGF
029600220214     C                   MOVEL     *BLANK        ZAMSID
029700220214     C                   MOVEL     *BLANK        ZAPGRL
029800220214
029900220214     C                   ENDSR
030000220214      /EJECT
030100220214      *******************************************************************
030200220214      *                                                                 *
030300220214      * SRINIT - Initial Program Subroutine                             *
030400220214      *                                                                 *
030500220214      *******************************************************************
030600220214      *
030700220214     C     SRINIT        BEGSR
030800220214
030900220214     C     *ENTRY        PLIST
031000220214     C                   PARM                    PMSGRF
031100220214     C                   PARM                    PREF
031200220214     C                   PARM                    PEXIT
031300220214     C                   PARM                    PCANC
031400220214
031500220214      ** Define Key Lists
031600220214
031700220214     C     KMEINDT       KLIST
031800220214     C                   KFLD                    PMSGRF
031900220214     C                   KFLD                    PMTAG1
032000220214
032100220214     C     KMEIN35       KLIST
032200220214     C                   KFLD                    PMSGRF
032300220214     C                   KFLD                    PMTAG2
032400220214
032500220214     C     KMEISOM       KLIST
032600220214     C                   KFLD                    WrkF20
032700220214     C                   KFLD                    WrkUETR
032800220214
032900220214     C     KMEISOD       KLIST
033000220214     C                   KFLD                    WMXRef
033100220214     C                   KFLD                    WSeqNo
033200220214
033300220214      ** Define all program work fields
033400220214
033500220214     C     *LIKE         DEFINE    S0RRN         X0RRN
033600220214     C     *LIKE         DEFINE    S0ELEM        X0ELEM
033700220214     C     *LIKE         DEFINE    S0EVAL        X0EVAL
033800220214      *
033900220214     C                   EVAL      ZAPGM = *BLANKS
034000220214     C                   EVAL      ZAPGRL = *BLANKS
034100220214     C                   EVAL      ZAMSID = *BLANKS
034200220214     C                   EVAL      ZAMSGF = *BLANKS
034300220214     C                   EVAL      ZAMSDA = *BLANKS
034400220214     C                   EVAL      ZAMSTP = *BLANKS
034500220214     C                   EVAL      WrkF20 = *BLANKS
034600220214     C                   EVAL      WrkUETR = *BLANKS
034700220214
034800220214     C                   Z-ADD     0             S0RRN
034900220214     C                   Z-ADD     0             LINENO
035000220214     C                   Z-ADD     0             WrkLen
035100220214
035200220214     C                   EVAL      *IN77 = *OFF
035300220214
035400220214      ** Get Rundate
035500220214
035600220214     C     *DTAARA       DEFINE                  RUNDAT
035700220214     C                   IN        RUNDAT
035800220214     C     *DTAARA       DEFINE                  LDA
035900220214     C     *LOCK         IN        LDA
036000220214
036100220214     C                   MOVEL     PGM           ZAPGM
036200220214
036300220214      ** Set screen constants and output header
036400220214
036500220214     C                   MOVEL     PGM           SPGM
036600220214     C                   MOVEL     WSID          SWSID
036700220214     C                   MOVEL     USER          SUSER
036800220214     C                   MOVEL     AGMRDT        SRUNA
036900220214     C                   MOVEL     PREF          SPREF
037000220214
037100220214     C                   EVAL      PMTAG1 = '121:'
037200220214     C                   EVAL      PMTAG2 = ':20:'
037300220214
037400220214     C     KMEINDT       CHAIN     MEINDTL0
037500220214     C                   IF        %FOUND(MEINDTL0)
037600220214     C                   EVAL      WrkUETR = DTMFLD
037700220214     C                   EVAL      WFound = 'Y'
037800220214     C                   EVAL      *IN77 = *ON
037900220214     C                   EVAL      SUETR = DTMFLD
038000220214
038100220214     C     KMEIN35       CHAIN     MEIN35L0
038200220214     C                   IF        %FOUND(MEIN35L0)
038300220214     C                   EVAL      WrkF20 = DSMF35
038400220214     C                   EVAL      SMSGID = DSMF35
038500220214     C                   ENDIF
038600220214
038700220214     C                   ELSE
038800220214     c                   EVAL      WFound = 'N'
038900220214     C                   ENDIF
039000220214
039100220214     C                   WRITE     FT020022F1
039200220214
039300220214     C                   ENDSR
039400220214      /EJECT
039500220214      *******************************************************************
039600220214      *                                                                 *
039700220214      * SrEName - Get the Element Description                           *
039800220214      *                                                                 *
039900220214      *******************************************************************
040000220214      *
040100220214     C     SrEName       BEGSR
040200220214
040300220214     C     WrkENAM       CHAIN     MEDESCL1
040400220214     C                   IF        %FOUND(MEDESCL1) AND DEDESC <> *BLANKS
040500220214     C                   EVAL      S0ELEM = DEDESC
040600220214     C                   ELSE
040700220214     C                   EVAL      S0ELEM = WrkENAM
040800220214     C                   ENDIF
040900220214
041000220214     C                   ENDSR
041100220214      /EJECT
041200220214      *******************************************************************
041300220214      *                                                                 *
041400220214      * *PSSR  - Program Exception Error Routine                        *
041500220214      *                                                                 *
041600220214      *******************************************************************
041700220214      *
041800220214     C     *PSSR         BEGSR
041900220214
042000220214     C     @RUN          IFEQ      *BLANK
042100220214     C                   MOVE      'Y'           @RUN
042200220214     C                   MOVEL     'FT020022DF'  DBPGM
042300220214     C                   OUT       LDA
042400220214     C                   DUMP
042500220214     C                   CALL      'DBERRCTL'
042600220214     C                   ENDIF
042700220214
042800220214     C                   EVAL      *INU7 = *ON
042900220214     C                   EVAL      *INU8 = *ON
043000220214     C                   EVAL      *INLR = *ON
043100220214     C                   RETURN
043200220214
043300220214     C                   ENDSR
043400220214      *
043500220214      *******************************************************************
