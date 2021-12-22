000100211109     H DEBUG
000200211109      *****************************************************************
000300211110/*STD *  RPGBASEBND                                                   *
000400211109/*EXI *  TEXT('Midas MS 2780 outgoing message compression')           *
000500211109      *****************************************************************
000600211109      *                                                               *
000700211109      *  Midas - SWIFT Direct Link Module                             *
000800211109      *                                                               *
000900211109      *   MS0209 - Outgoing Message Compression (2780 Protocol)       *
001000211109      *            Specifically for Corona Interface                  *
001100211109      *                                                               *
001200211221      *  (c) Finastra International Limited 2021                      *
001300211109      *                                                               *
001400211109      *  Last Amend No. CGL094   *CREATE   Date 02Nov21               *
001500211109      *                                                               *
001600211109      *****************************************************************
001700211109      *                                                               *
001800211109      *  CGL094 - MT940 Interface to Corona (External Network         *
001900211109      *           Destination)                                        *
002000211109      *         - MT940 messages specified with a Destination of      *
002100211109      *           Corona are extracted in MS2780 format for the       *
002200211109      *           Corona system.                                      *
002300211109      *         - Allow details from field :86: to be the second      *
002400211109      *           line for field :61:                                 *
002500211109      *         - Ref. number is truncated on MS2780C (now MS940XPD)  *
002600211109      *           when it is on the second record on MGOMSGPD         *
002700211109      *         - Data base error if no records for CORONA            *
002800211109      *         - This program is a copy of the MS0208 modified for   *
002900211109      *           the General Bank system including the specials      *
003000211109      *           characters and record layout for the PC DOS file    *
003100211109      *           Midas MT940 Interface to CORONA                     *
003200211109      *         - Chg 'ä' to '{' and 'ü' to '}'.                      *
003300211109      *                                                               *
003400211109      *****************************************************************
003500211109     FMGOREF11  UF   E           K DISK
003600211109     FMGOMSGPD  IF   E           K DISK
003700211109     FSDBANKPD  IF   E             DISK
003800211109     FMS940XPD  UF A E             DISK
003900211109     FMS0209AU  O    E             PRINTER INFDS(SPOOLU)
004000211109     F                                     USROPN
004100211109      *****************************************************************
004200211109      *   Index to subroutines                                        *
004300211109      *   INIT  - Initial process                                     *
004400211109      *   REPT  - Process error report                                *
004500211109      *   WRIT  - Output record                                       *
004600211109      *   *PSSR - Error handling                                      *
004700211109      *****************************************************************
004800211109      * ID F  C  H  L    Function of indicators
004900211109      * 10               EOF MGOREF11
005000211109      * 15               EOF MGOMSGPD
005100211109      * 16               1 Record written to MS940XPD
005200211109      * 30               MS0209AU open
005300211109      * 99               EOF SDBANKPD
005400211109      * U7U8LR           DB error
005500211109      *
005600211109      ********************************************************************
005700211109     D FLDA            S              1    DIM(398)
005800211109     D IMSG            S              1    DIM(256)                             Incoming msg
005900211109     D OMSG            S              1    DIM(9999)                            Compressed msg
006000211109     D TMSG            S              1    DIM(9999)
006100211109     D AFD             S              1    DIM(50)                              Corona work array
006200211109     D AFB             S              1    DIM(51)                              Corona work array
006300211109     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
006400211109     D ARH             S             80    DIM(3) CTDATA PERRCD(1)
006500211109      ********************************************************************
006600211109     D SCSARD        E DS                  EXTNAME(SCSARDPD)
006700211109      **  SAR File Details Accessed via Access Program AOSARDR0
006800211109      *
006900211109     D DSFDY         E DS                  EXTNAME(DSFDY)
007000211109     D* FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
007100211109      *
007200211109     D SPOOLU          DS
007300211109     D  SFILEU                83     92
007400211109     D  SFNUMU               123    124B 0
007500211109      ** File Information DS
007600211109      *
007700211109     D MSSTAT          DS           256
007800211109     D  PDEIND                24     24
007900211109      **  MSSTAT data structure
008000211109      *
008100211109     D LDA             DS           256
008200211109     D  DBFILE               134    141
008300211109     D  DBKEY                142    170
008400211109     D  DBPGM                171    180
008500211109     D  DBASE                181    183  0
008600211109      **  Local data area data structure
008700211109      *
008800211109     D                 DS
008900211109     D  @DST1                 32     43
009000211109     D  @WK4                  40     43
009100211109     D  @WK3                  41     43
009200211109     D  @WL3                  40     42
009300211109     D  @WK1                  43     43
009400211109      **  Destination address data structure
009500211109      *
009600211109     D                 DS
009700211109     D  @SW2                   1     49
009800211109     D  TXT1                   1      6
009900211109     D  @SND2                  7     18
010000211109     D  @TNG                  14     14
010100211109     D  TXT2                  19     33
010200211109     D  MTPY                  34     36
010300211109     D  @DST2                 37     48
010400211109     D  MPRY                  49     49
010500211109      **  SWIFT II message header
010600211109      *
010700211109     D                 DS
010800211109     D  MTAG                   1      5
010900211109     D  @WL1                   5      5
011000211109      **  Fields for CORONA records
011100211109     D                 DS
011200211109     D  RECZ                   1     84
011300211109     D  Z1                     1      5
011400211109     D  Z2                     5     80
011500211109     D  Z2MLP                  5     80
011600211109     D  Z2A                    6     80
011700211109     D  Z2B                    1     80
011800211109     D  Z3                    81     82
011900211109     D  Z4                    83     84
012000211109      *
012100211109     D                 DS
012200211109     D  COM1                   1     55
012300211109     D  IAZ                    1      5
012400211109     D  IFD                    6     55
012500211109     D  NY3                   16     55
012600211109      *
012700211109     D                 DS
012800211109     D  COM2                   1     55
012900211109     D  ZAZ                    1      5
013000211109     D  Z2Z                    6     55
013100211109      *
013200211109      *****************************************************************
013300211109      **  Execute initial process
013400211109     C                   EXSR      INIT
013500211109      *
013600211109      **  Read message reference file
013700211109     C     *LOVAL        SETLL     MGOREF11
013800211109     C                   READ      MGOREF11                               10
013900211109      *
014000211109      **  Do until EOF message reference file
014100211109     C     *IN10         DOWEQ     '0'
014200211109      *
014300211109      **  Process message
014400211109     C     TRNO          SETLL     MGOMSGPD
014500211109     C     PTDL          DOUNE     'D'
014600211109     C     *IN15         OREQ      '1'
014700211109     C     TRNO          READE     MGOMSGPD                               15
014800211109     C                   END
014900211109      *
015000211109     C     *IN15         IFEQ      '1'
015100211109     C     *LOCK         IN        LDA
015200211109     C                   MOVE      'MGOMSGPD'    DBFILE
015300211109     C                   MOVEL     TRNO          DBKEY
015400211109     C                   Z-ADD     02            DBASE
015500211109     C                   OUT       LDA
015600211109     C                   WRITE     DBERROR
015700211109     C                   EXSR      *PSSR
015800211109     C                   END
015900211109      *
016000211109      **  Expand address to 12 characters with Xs
016100211109     C                   MOVEL     NWDS          @DST1
016200211109     C     @WK4          IFEQ      '    '
016300211109     C                   MOVE      @DST1         @DST2
016400211109     C                   MOVE      'XXXX'        @DST2
016500211109     C                   ELSE
016600211109     C     @WK3          IFEQ      '   '
016700211109     C                   MOVE      @DST1         @DST2
016800211109     C                   MOVE      'XXX'         @DST2
016900211109     C                   ELSE
017000211109     C     @WK1          IFEQ      ' '
017100211109     C                   MOVEL     'X'           @WL4              4
017200211109     C                   MOVE      @WL3          @WL4
017300211109     C                   MOVE      @DST1         @DST2
017400211109     C                   MOVE      @WL4          @DST2
017500211109     C                   ELSE
017600211109     C                   MOVE      @DST1         @DST2
017700211109     C                   END
017800211109     C                   END
017900211109     C                   END
018000211109      *
018100211109      **  Write SWIFT II header to message array
018200211109     C                   MOVEL     NWSN          @SND2
018300211109     C                   MOVEA     @SW2          OMSG(O)
018400211109     C                   ADD       49            O
018500211109      *
018600211109      **  Write delivery notification to message array if not blank
018700211109     C     DELC          IFNE      *BLANKS
018800211109     C                   MOVE      DELC          OMSG(O)
018900211109     C                   ADD       1             O
019000211109     C                   END
019100211109     C                   MOVEA     TXT3          OMSG(O)
019200211109     C                   ADD       6             O
019300211109      *
019400211109      **  Process rest
019500211109     C     *IN15         DOWEQ     '0'
019600211109      *
019700211109      **  Write field tag to message array if not blank
019800211109     C     MTAG          IFNE      *BLANKS
019900211109     C                   MOVEA     MTAG          OMSG(O)
020000211109     C     @WL1          IFEQ      *BLANKS
020100211109     C                   ADD       4             O
020200211109     C                   ELSE
020300211109     C                   ADD       5             O
020400211109     C                   END
020500211109     C                   END
020600211109      *
020700211109      **  Write all non blank characters in field to message array
020800211109     C                   MOVE      *BLANKS       IMSG
020900211109     C     MFLD          IFNE      *BLANKS
021000211109     C                   MOVEA     MFLD          IMSG
021100211109     C                   Z-ADD     50            I                 4 0
021200211109     C     IMSG(I)       DOWEQ     ' '
021300211109     C                   SUB       1             I
021400211109     C                   END
021500211109     C                   ELSE
021600211109     C                   Z-ADD     0             I
021700211109     C                   END
021800211109      *
021900211109     C                   Z-ADD     I             S                 4 0
022000211109     C                   Z-ADD     1             I
022100211109     C     S             DOWGE     I
022200211109     C                   MOVE      IMSG(I)       OMSG(O)
022300211109     C                   ADD       1             I
022400211109     C                   ADD       1             O
022500211109     C                   END
022600211109      *
022700211109      **  Write CRLF to message array if not blank
022800211109      *
022900211109     C                   EXSR      COROSR
023000211109      *
023100211109      **  Read outgoing messages file but ignore deleted parts.
023200211109     C     PTDL          DOUNE     'D'
023300211109     C     *IN15         OREQ      '1'
023400211109     C     TRNO          READE     MGOMSGPD                               15
023500211109     C                   END
023600211109     C                   END
023700211109      *
023800211109      **  Write end of text block
023900211109     C                   MOVEA     '-ü'          OMSG(O)
024000211109     C                   ADD       2             O
024100211109      *
024200211109      **  Add trailer block (block 5)
024300211109      **  PDE (possible duplicate) trailer...
024400211109     C                   SETOFF                                       14
024500211109      *
024600211109     C     *DTAARA       DEFINE                  MSSTAT
024700211109     C                   IN        MSSTAT
024800211109     C     PDEIND        IFEQ      'Y'
024900211109     C                   SETON                                        14
025000211109     C                   MOVEA     'ä5:'         OMSG(O)
025100211109     C                   ADD       3             O
025200211109     C                   MOVEA     'äPDE:ü'      OMSG(O)
025300211109     C                   ADD       6             O
025400211109     C                   END
025500211109      *
025600211109      **  ...and TNG (training) trailer as required
025700211109     C     @TNG          IFEQ      '0'
025800211109     C     *IN14         IFEQ      '0'
025900211109     C                   MOVEA     'ä5:'         OMSG(O)
026000211109     C                   ADD       3             O
026100211109     C                   END
026200211109     C                   SETON                                        14
026300211109     C                   MOVEA     'äTNG:ü'      OMSG(O)
026400211109     C                   ADD       6             O
026500211109     C                   END
026600211109      *
026700211109      **  End trailer block
026800211109     C     *IN14         IFEQ      '1'
026900211109     C                   MOVE      'ü'           OMSG(O)
027000211109     C                   ADD       1             O
027100211109     C                   END
027200211109      *
027300211109      **  Add hash
027400211109     C                   MOVEA     HSH           OMSG(O)
027500211109     C     O             DIV       398           Y                 2 0
027600211109     C                   ADD       1             O
027700211109      *
027800211109      **  If compressed msg is greater than 2000 bytes output report
027900211109     C     O             IFGT      8100
028000211109     C                   EXSR      REPT
028100211109     C                   END
028200211109      *
028300211109      **  If ready output records
028400211109     C     Y             IFGT      0
028500211109     C                   EXSR      WRIT
028600211109     C                   END
028700211109      *
028800211109      **  Update status on Message Reference file
028900211109     C                   MOVE      'TRAN'        MGST
029000211109     C                   MOVE      '3'           MGSG
029100211109     C                   UPDATE    MGOREFD0
029200211109      *
029300211109      **  Read message reference file
029400211109     C                   READ      MGOREF11                               10
029500211109     C                   ENDDO
029600211109      *
029700211109      **  Output remaining record
029800211109     C     O             IFGT      1
029900211109     C                   Z-ADD     1             Y
030000211109     C                   EXSR      WRIT
030100211109     C                   END
030200211109      *
030300211109      ** If *IN16 is off, no records output to MS940XPD, Set on U8 to
030400211109      ** ensure CL does not transmit empty file
030500211109      *
030600211109     C                   SETON                                        LR
030700211109      *
030800211109      *  Trailer record for Corona
030900211109      *
031000211109     CLR 16              READ      MS940XPD                               33
031100211109     CLR 16              CLEAR                   MSREC
031200211109     CLR 16              MOVEL     '-}'          MSREC
031300211109     CLR 16              WRITE     MS940XD0
031400211109     CLR                 WRITE     ENDRPT
031500211109     CLR 30              CLOSE     MS0209AU
031600211109     CLR                 RETURN
031700211109      *
031800211109      *****************************************************************
031900211109      *   INIT - inital process                                       *
032000211109      *   Called by - main process                                    *
032100211109      *****************************************************************
032200211109     C     INIT          BEGSR
032300211109      *
032400211109     C                   MOVEA     CPY@          BIS@             80
032500211109      *
032600211109      **  Set up LDA
032700211109     C     *DTAARA       DEFINE                  LDA
032800211109     C     *LOCK         IN        LDA
032900211109     C                   MOVE      *BLANKS       DBFILE
033000211109     C                   MOVE      *BLANKS       DBKEY
033100211109     C                   MOVEL     'MS0209'      DBPGM
033200211109     C                   MOVE      *BLANKS       DBASE
033300211109     C                   OUT       LDA
033400211109      *
033500211109      **  Access SDBANKL0 to find run date
033600211109     C                   READ      SDBANKPD                               99
033700211109     C                   MOVE      BJURPT        #URPT            53
033800211109     C                   MOVE      BJMRDT        #MRDT             7
033900211109      *
034000211109      ** Ensure audit report is recorded by RCF
034100211109     C                   EXSR      RECRCF
034200211109      *
034300211109     C     *IN99         IFEQ      '1'
034400211109     C     *LOCK         IN        LDA
034500211109     C                   MOVE      'SDBANKPD'    DBFILE
034600211109     C                   MOVEL     'FIRST'       DBKEY
034700211109     C                   Z-ADD     01            DBASE
034800211109     C                   OUT       LDA
034900211109     C                   WRITE     DBERROR
035000211109     C                   EXSR      *PSSR
035100211109     C                   END
035200211109      *
035300211109      **  Initialise 'CR' and 'LF' fields
035400211109     C                   MOVE      *LOVAL        CR                1
035500211109     C                   BITON     '457'         CR
035600211109     C                   MOVE      *LOVAL        LF                1
035700211109     C                   BITON     '257'         LF
035800211109     C                   MOVE      *LOVAL        HSH               1
035900211109     C                   BITON     '13467'       HSH
036000211109     C                   MOVEL     CR            CRLF              2
036100211109     C                   MOVE      LF            CRLF
036200211109      *
036300211109      **  Initialise X'00' field
036400211109     C                   BITOFF    '01234567'    #00               1
036500211109      *
036600211109      **  Initialise text fields
036700211109     C                   MOVE      'ä1:F01'      TXT1
036800211109     C                   MOVEL     '99999999'    TXT2
036900211109     C                   MOVE      '99üä2:I'     TXT2
037000211109     C                   MOVEL     'üä4:'        TXT3              4
037100211109      *
037200211109     C                   Z-ADD     1             O                 4 0
037300211109      *
037400211109      * Access SAR details to see if CSW001 is switched on
037500211109      *
037600211109     C                   CALL      'AOSARDR0'
037700211109     C                   PARM      *BLANKS       @RTCD             7
037800211109     C                   PARM      '*VERIFY'     @OPTN             7
037900211109     C                   PARM      'CSW001'      @SARD             6
038000211109     C     SCSARD        PARM      SCSARD        DSFDY
038100211109      *
038200211109     C                   MOVE      *BLANKS       CSW001            1
038300211109     C     @RTCD         IFEQ      *BLANKS
038400211109     C                   MOVEL     'Y'           CSW001
038500211109     C                   ELSE
038600211109     C     @RTCD         IFNE      '*NRF   '                                    B2
038700211109     C     *LOCK         IN        LDA
038800211109     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
038900211109     C                   MOVEL     '*VERIFY'     DBKEY                          * DBERR 03 *
039000211109     C                   MOVE      '03'          DBASE                          ************
039100211109     C                   OUT       LDA
039200211109     C                   WRITE     DBERROR
039300211109     C                   EXSR      *PSSR
039400211109     C                   ENDIF                                                  E2
039500211109     C                   ENDIF
039600211109      *
039700211109     C                   ENDSR
039800211109      *****************************************************************
039900211109      /EJECT
040000211109      *****************************************************************
040100211109      *                                                               *
040200211109      *  RECRCF - RCF processing                                      *
040300211109      *                                                               *
040400211109      *****************************************************************
040500211109     C     RECRCF        BEGSR
040600211109      *
040700211109     C                   OPEN      MS0209AU                             30
040800211109     C                   WRITE     HEADER
040900211109      *
041000211109      ** Ensure Detail Spool File recorded by RCF.
041100211109      *
041200211214     C                   Z-ADD     SFNUMU        ZSNUMU            6 0
041201211214     C                   CALL      'ZSFILE'
041300211109     C                   PARM                    PSEQ              5
041400211109     C                   PARM                    PENTY             3
041500211109     C                   PARM                    SFILEU
041600211214     C                   PARM                    ZSNUMU
041700211109     C                   PARM      *BLANK        ZSERR             1
041800211109      *
041900211109      ** If Error occurs during ZSFILE processing, then return to the
042000211109      ** Calling Program.
042100211109      *
042200211109     C     ZSERR         IFEQ      'Y'
042300211109     C                   MOVE      *ON           *INU7
042400211109     C                   MOVE      *ON           *INU8
042500211109     C                   MOVE      *ON           *INLR
042600211109     C                   RETURN
042700211109     C                   ENDIF
042800211109      *
042900211109     C                   ENDSR
043000211109      *****************************************************************
043100211109     C/EJECT
043200211109      *****************************************************************
043300211109      *   WRIT - output record                                        *
043400211109      *   Called by - main process                                    *
043500211109      *****************************************************************
043600211109     C     WRIT          BEGSR
043700211109      *
043800211109     C                   DO        Y
043900211109      *
044000211109      **  Move remaining data forward in array
044100211109      *
044200211109     C                   MOVEA     *BLANKS       TMSG
044300211109     C                   MOVEA     OMSG(399)     TMSG
044400211109     C                   MOVEA     *BLANKS       OMSG
044500211109     C                   MOVEA     TMSG          OMSG
044600211109     C                   SUB       398           O
044700211109     C                   END
044800211109      *
044900211109     C                   ENDSR
045000211109      *****************************************************************
045100211109     C/EJECT
045200211109      *****************************************************************
045300211109      *   REPT - process error report                                 *
045400211109      *   Called by - main process                                    *
045500211109      *****************************************************************
045600211109     C     REPT          BEGSR
045700211109      *
045800211109      **  Update message reference record to 'A' if message > 2000
045900211109     C                   MOVE      'AMND'        MGST
046000211109     C                   MOVE      '1'           MGSG
046100211109     C                   UPDATE    MGOREFD0
046200211109      *
046300211109      * Output error report
046400211109     C                   WRITE     DETAIL
046500211109      *
046600211109     C                   ENDSR
046700211109      *****************************************************************
046800211109     C/EJECT
046900211109      *****************************************************************
047000211109      *   *PSSR - error handling                                      *
047100211109      *   Called by - main process                                    *
047200211109      *****************************************************************
047300211109      *
047400211109     C     *PSSR         BEGSR
047500211109      *
047600211109     C                   SETON                                        U7U8LR
047700211109     C                   DUMP
047800211109     C                   RETURN
047900211109      *
048000211109     C                   ENDSR
048100211109      ********************************************************************
048200211109      * IGM002 Oct 98 MKI/Belgium - Corona File Creation
048300211109      *
048400211109      * This routine is written specifically for GENERAL BANK in KOLN.
048500211109      * The format used for record layout is MERVE . To copy this file
048600211109      * CORONA Pc only one procedure is permitted the FTP not in Binary
048700211109      * mode .
048800211109      * If this program is modified again take care to the CCSID 273 in
048900211109      * Germany country the EBCDIC value is different than the original.
049000211109      *
049100211109      ********************************************************************
049200211109     C     COROSR        BEGSR
049300211109      *
049400211109     C     *IN35         IFEQ      *ON
049500211109     C                   CLEAR                   AFD
049600211109     C                   CLEAR                   AFB
049700211109     C                   Z-ADD     1             WW                2 0
049800211109     C                   Z-ADD     1             YY                2 0
049900211109     C                   MOVEA     MFLD          AFD
050000211109     C                   MOVEL     Z2Z           MLPFL1           51
050100211109     C                   MOVEA     MLPFL1        AFB
050200211109     C     AFB(YY)       DOWNE     *BLANK
050300211109     C                   ADD       1             YY
050400211109     C                   ENDDO
050500211109     C     YY            SUB       1             YY
050600211109     C     WW            DOWLE     50
050700211109     C     AFD(WW)       IFNE      *BLANKS
050800211109     C                   ADD       1             YY
050900211109     C                   MOVE      AFD(WW)       AFB(YY)
051000211109     C     YY            IFEQ      51
051100211109     C                   Z-ADD     50            WW
051200211109     C                   ENDIF
051300211109     C                   ENDIF
051400211109     C                   ADD       1             WW
051500211109     C                   ENDDO
051600211109     C                   MOVEA     AFB           Z2MLP
051700211109     C                   MOVE      *ON           *IN36
051800211109     C                   MOVE      RECZ          MSREC
051900211109     C                   WRITE     MS940XD0
052000211109     C                   MOVE      '1'           *IN16
052100211109     C                   CLEAR                   RECZ
052200211109     C                   ENDIF
052300211109     C                   MOVE      *OFF          *IN35
052400211109      *
052500211109     C     *IN36         IFEQ      *OFF
052600211109      *  HEADER
052700211109     C     *IN17         IFEQ      *ON
052800211109     C     MTAG          ANDEQ     ':20:'
052900211109     C                   MOVEL     *BLANKS       OLTTAG
053000211109     C                   MOVEL     ARH(3)        RECZ
053100211109     C                   READ      MS940XPD                               18
053200211109     C                   MOVEL     RECZ          MSREC
053300211109     C                   WRITE     MS940XD0
053400211109     C                   MOVE      '1'           *IN16
053500211109     C                   CLEAR                   RECZ
053600211109      *
053700211109     C                   MOVEL     ARH(2)        RECZ
053800211109     C                   MOVE      '{4'          Z3
053900211109     C                   MOVEL     ':'           Z4
054000211109     C                   READ      MS940XPD                               18
054100211109     C                   MOVEL     RECZ          MSREC
054200211109     C                   WRITE     MS940XD0
054300211109     C                   CLEAR                   RECZ
054400211109     C                   ENDIF
054500211109     C     *IN17         IFEQ      *OFF
054600211109     C                   CLEAR                   RECZ
054700211109     C                   MOVE      *ON           *IN17
054800211109     C                   MOVEL     ARH(1)        RECZ
054900211109     C                   MOVE      '{4'          Z3
055000211109     C                   MOVEL     ':'           Z4
055100211109     C                   READ      MS940XPD                               18
055200211109     C                   MOVEL     RECZ          MSREC
055300211109     C                   WRITE     MS940XD0
055400211109     C                   ENDIF
055500211109     C                   MOVE      MTAG          IAZ
055600211109     C                   MOVE      MFLD          IFD
055700211109      *
055800211109      *  No blank characters bewteen the fields are allowed.
055900211109      *  The message fields cannot begin with special characters .
056000211109      *
056100211109     C     COM1          IFNE      COM2
056200211109     C                   CLEAR                   RECZ
056300211109     C                   MOVE      *OFF          *IN34
056400211109     C                   MOVEL     MTAG          TTAG              4
056500211109     C                   MOVEL     MFLD          TMF               3
056600211109     C     TTAG          IFEQ      ':86:'
056700211109     C     TMF           ANDEQ     '///'
056800211109     C                   MOVE      *ON           *IN34
056900211109     C                   MOVE      TTAG          OLTTAG            4
057000211109     C                   ENDIF
057100211109     C     OLTTAG        IFEQ      ':86:'
057200211109     C     TTAG          ANDEQ     '    '
057300211109     C                   MOVE      *ON           *IN34
057400211109     C                   END
057500211109     C     *IN34         IFEQ      *OFF
057600211109     C                   READ      MS940XPD                               18
057700211109     C                   MOVEL     *BLANKS       OLTTAG
057800211109     C                   CLEAR                   Z2
057900211109     C                   CLEAR                   Z2A
058000211109     C                   CLEAR                   Z2B
058100211109     C                   MOVE      MTAG          Z1
058200211109     C                   MOVEL     MTAG          Z0                1
058300211109     C                   MOVE      MTAG          Z000              1
058400211109     C                   MOVE      MTAG          ZWK               2
058500211109     C                   MOVEL     ZWK           Z00               1
058600211109     C     Z0            IFEQ      ':'
058700211109     C     Z00           ANDEQ     ':'
058800211109     C                   MOVEL     MFLD          Z2
058900211109     C                   MOVEL     Z2            TIR               1
059000211109     C     TIR           IFEQ      '-'
059100211109     C                   MOVEL     '.'           Z2
059200211109     C                   ENDIF
059300211109     C                   ENDIF
059400211109     C     Z0            IFEQ      ':'
059500211109     C     Z000          ANDEQ     ':'
059600211109     C                   MOVEL     MFLD          Z2A
059700211109     C                   MOVEL     Z2A           TIR
059800211109     C     TIR           IFEQ      '-'
059900211109     C                   MOVEL     '.'           Z2A
060000211109     C                   ENDIF
060100211109     C                   ENDIF
060200211109     C     Z2            IFEQ      *BLANK
060300211109     C     Z2A           ANDEQ     *BLANK
060400211109     C                   CLEAR                   AFD
060500211109     C                   CLEAR                   AFB
060600211109     C                   Z-ADD     *ZERO         WW                2 0
060700211109     C                   Z-ADD     *ZERO         YY                2 0
060800211109     C                   MOVEA     MFLD          AFD
060900211109     C                   ADD       1             WW
061000211109     C     WW            DOWLE     50
061100211109     C     AFD(WW)       IFNE      *BLANKS
061200211109     C                   ADD       1             YY
061300211109     C                   MOVE      AFD(WW)       AFB(YY)
061400211109     C                   ENDIF
061500211109     C                   ADD       1             WW
061600211109     C                   ENDDO
061700211109     C                   MOVEA     AFB           Z2B
061800211109     C                   MOVEL     Z2B           TIR
061900211109     C     TIR           IFEQ      '-'
062000211109     C                   MOVEL     '.'           Z2B
062100211109     C                   ENDIF
062200211109     C                   ENDIF
062300211109     C                   MOVE      MFLD          Z2Z
062400211109     C                   MOVEL     MTAG          ZAZ
062500211109     C                   CLEAR                   Z3
062600211109      *  COMPLEMENT
062700211109     C     TTAG          IFEQ      ':61:'
062800211109     C     CTRC          ANDEQ     *BLANK
062900211109     C                   MOVE      *ON           *IN35
063000211109     C                   ENDIF
063100211109      *  TRAILER
063200211109     C     *IN35         IFEQ      *OFF
063300211109     C                   MOVEL     RECZ          MSREC
063400211109     C                   WRITE     MS940XD0
063500211109     C                   ENDIF
063600211109     C                   ENDIF
063700211109     C                   ENDIF
063800211109     C                   ENDIF
063900211109      * Reset Indicator
064000211109     C                   MOVE      *OFF          *IN36
064100211109      *
064200211109     C                   ENDSR
064300211109      ********************************************************************
064400211109** CPY@   **      OBJECT COPYRIGHT
064500211109(C) Copyright Finastra International Limited 2021
064600211109** HEADER RECORD FOR CORONA
064700211109{1:F01HELAUS33AXXX0000000000}{2:O9401214991207HELAUS33AXXX00000000009912071214N}
064800211109{1:F01HELAUS33AXXX0000000000}{2:O9401214991207HELAUS33AXXX00000000009912071214N}
064900211109-}
