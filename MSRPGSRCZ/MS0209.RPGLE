000100220112     H DEBUG
000101220112      *****************************************************************
000102220112/*STD *  RPGBASEBND                                                   *
000103220112/*EXI *  TEXT('Midas MS 2780 outgoing message compression')           *
000104220112      *****************************************************************
000105220112      *                                                               *
000106220112      *  Midas - SWIFT Direct Link Module                             *
000107220112      *                                                               *
000108220112      *   MS0209 - Outgoing Message Compression (2780 Protocol)       *
000109220112      *            Specifically for Corona Interface                  *
000110220112      *                                                               *
000111220112      *  (c) Finastra International Limited 2021                      *
000112220112      *                                                               *
000113220112      *  Last Amend No. CGL094   *CREATE   Date 02Nov21               *
000114220112      *                                                               *
000115220112      *****************************************************************
000116220112      *                                                               *
000117220112      *  CGL094 - MT940 Interface to Corona (External Network         *
000118220112      *           Destination)                                        *
000119220112      *         - MT940 messages specified with a Destination of      *
000120220112      *           Corona are extracted in MS2780 format for the       *
000121220112      *           Corona system.                                      *
000122220112      *         - Allow details from field :86: to be the second      *
000123220112      *           line for field :61:                                 *
000124220112      *         - Ref. number is truncated on MS2780C (now MS940XPD)  *
000125220112      *           when it is on the second record on MGOMSGPD         *
000126220112      *         - Data base error if no records for CORONA            *
000127220112      *         - This program is a copy of the MS0208 modified for   *
000128220112      *           the General Bank system including the specials      *
000129220112      *           characters and record layout for the PC DOS file    *
000130220112      *           Midas MT940 Interface to CORONA                     *
000131220112      *         - Chg 'ä' to '{' and 'ü' to '}'.                      *
000132220112      *                                                               *
000133220112      *****************************************************************
000134220112     FMGOREF11  UF   E           K DISK
000135220112     FMGOMSGPD  IF   E           K DISK
000136220112     FSDBANKPD  IF   E             DISK
000137220112     FMS940XPD  UF A E             DISK
000138220112     FMS0209AU  O    E             PRINTER INFDS(SPOOLU)
000139220112     F                                     USROPN
000140220112      *****************************************************************
000141220112      *   Index to subroutines                                        *
000142220112      *   INIT  - Initial process                                     *
000143220112      *   REPT  - Process error report                                *
000144220112      *   WRIT  - Output record                                       *
000145220112      *   *PSSR - Error handling                                      *
000146220112      *****************************************************************
000147220112      * ID F  C  H  L    Function of indicators
000148220112      * 10               EOF MGOREF11
000149220112      * 15               EOF MGOMSGPD
000150220112      * 16               1 Record written to MS940XPD
000151220112      * 30               MS0209AU open
000152220112      * 99               EOF SDBANKPD
000153220112      * U7U8LR           DB error
000154220112      *
000155220112      ********************************************************************
000156220112     D FLDA            S              1    DIM(398)
000157220112     D IMSG            S              1    DIM(256)                             Incoming msg
000158220112     D OMSG            S              1    DIM(9999)                            Compressed msg
000159220112     D TMSG            S              1    DIM(9999)
000160220112     D AFD             S              1    DIM(50)                              Corona work array
000161220112     D AFB             S              1    DIM(51)                              Corona work array
000162220112     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
000163220112     D ARH             S             80    DIM(3) CTDATA PERRCD(1)
000164220112      ********************************************************************
000165220112     D SCSARD        E DS                  EXTNAME(SCSARDPD)
000166220112      **  SAR File Details Accessed via Access Program AOSARDR0
000167220112      *
000168220112     D DSFDY         E DS                  EXTNAME(DSFDY)
000169220112     D* FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
000170220112      *
000171220112     D SPOOLU          DS
000172220112     D  SFILEU                83     92
000173220112     D  SFNUMU               123    124B 0
000174220112      ** File Information DS
000175220112      *
000176220112     D MSSTAT          DS           256
000177220112     D  PDEIND                24     24
000178220112      **  MSSTAT data structure
000179220112      *
000180220112     D LDA             DS           256
000181220112     D  DBFILE               134    141
000182220112     D  DBKEY                142    170
000183220112     D  DBPGM                171    180
000184220112     D  DBASE                181    183  0
000185220112      **  Local data area data structure
000186220112      *
000187220112     D                 DS
000188220112     D  @DST1                 32     43
000189220112     D  @WK4                  40     43
000190220112     D  @WK3                  41     43
000191220112     D  @WL3                  40     42
000192220112     D  @WK1                  43     43
000193220112      **  Destination address data structure
000194220112      *
000195220112     D                 DS
000196220112     D  @SW2                   1     49
000197220112     D  TXT1                   1      6
000198220112     D  @SND2                  7     18
000199220112     D  @TNG                  14     14
000200220112     D  TXT2                  19     33
000201220112     D  MTPY                  34     36
000202220112     D  @DST2                 37     48
000203220112     D  MPRY                  49     49
000204220112      **  SWIFT II message header
000205220112      *
000206220112     D                 DS
000207220112     D  MTAG                   1      5
000208220112     D  @WL1                   5      5
000209220112      **  Fields for CORONA records
000210220112     D                 DS
000211220112     D  RECZ                   1     84
000212220112     D  Z1                     1      5
000213220112     D  Z2                     5     80
000214220112     D  Z2MLP                  5     80
000215220112     D  Z2A                    6     80
000216220112     D  Z2B                    1     80
000217220112     D  Z3                    81     82
000218220112     D  Z4                    83     84
000219220112      *
000220220112     D                 DS
000221220112     D  COM1                   1     55
000222220112     D  IAZ                    1      5
000223220112     D  IFD                    6     55
000224220112     D  NY3                   16     55
000225220112      *
000226220112     D                 DS
000227220112     D  COM2                   1     55
000228220112     D  ZAZ                    1      5
000229220112     D  Z2Z                    6     55
000230220112      *
000231220112      *****************************************************************
000232220112      **  Execute initial process
000233220112     C                   EXSR      INIT
000234220112      *
000235220112      **  Read message reference file
000236220112     C     *LOVAL        SETLL     MGOREF11
000237220112     C                   READ      MGOREF11                               10
000238220112      *
000239220112      **  Do until EOF message reference file
000240220112     C     *IN10         DOWEQ     '0'
000241220112      *
000242220112      **  Process message
000243220112     C     TRNO          SETLL     MGOMSGPD
000244220112     C     PTDL          DOUNE     'D'
000245220112     C     *IN15         OREQ      '1'
000246220112     C     TRNO          READE     MGOMSGPD                               15
000247220112     C                   END
000248220112      *
000249220112     C     *IN15         IFEQ      '1'
000250220112     C     *LOCK         IN        LDA
000251220112     C                   MOVE      'MGOMSGPD'    DBFILE
000252220112     C                   MOVEL     TRNO          DBKEY
000253220112     C                   Z-ADD     02            DBASE
000254220112     C                   OUT       LDA
000255220112     C                   WRITE     DBERROR
000256220112     C                   EXSR      *PSSR
000257220112     C                   END
000258220112      *
000259220112      **  Expand address to 12 characters with Xs
000260220112     C                   MOVEL     NWDS          @DST1
000261220112     C     @WK4          IFEQ      '    '
000262220112     C                   MOVE      @DST1         @DST2
000263220112     C                   MOVE      'XXXX'        @DST2
000264220112     C                   ELSE
000265220112     C     @WK3          IFEQ      '   '
000266220112     C                   MOVE      @DST1         @DST2
000267220112     C                   MOVE      'XXX'         @DST2
000268220112     C                   ELSE
000269220112     C     @WK1          IFEQ      ' '
000270220112     C                   MOVEL     'X'           @WL4              4
000271220112     C                   MOVE      @WL3          @WL4
000272220112     C                   MOVE      @DST1         @DST2
000273220112     C                   MOVE      @WL4          @DST2
000274220112     C                   ELSE
000275220112     C                   MOVE      @DST1         @DST2
000276220112     C                   END
000277220112     C                   END
000278220112     C                   END
000279220112      *
000280220112      **  Write SWIFT II header to message array
000281220112     C                   MOVEL     NWSN          @SND2
000282220112     C                   MOVEA     @SW2          OMSG(O)
000283220112     C                   ADD       49            O
000284220112      *
000285220112      **  Write delivery notification to message array if not blank
000286220112     C     DELC          IFNE      *BLANKS
000287220112     C                   MOVE      DELC          OMSG(O)
000288220112     C                   ADD       1             O
000289220112     C                   END
000290220112     C                   MOVEA     TXT3          OMSG(O)
000291220112     C                   ADD       6             O
000292220112      *
000293220112      **  Process rest
000294220112     C     *IN15         DOWEQ     '0'
000295220112      *
000296220112      **  Write field tag to message array if not blank
000297220112     C     MTAG          IFNE      *BLANKS
000298220112     C                   MOVEA     MTAG          OMSG(O)
000299220112     C     @WL1          IFEQ      *BLANKS
000300220112     C                   ADD       4             O
000301220112     C                   ELSE
000302220112     C                   ADD       5             O
000303220112     C                   END
000304220112     C                   END
000305220112      *
000306220112      **  Write all non blank characters in field to message array
000307220112     C                   MOVE      *BLANKS       IMSG
000308220112     C     MFLD          IFNE      *BLANKS
000309220112     C                   MOVEA     MFLD          IMSG
000310220112     C                   Z-ADD     50            I                 4 0
000311220112     C     IMSG(I)       DOWEQ     ' '
000312220112     C                   SUB       1             I
000313220112     C                   END
000314220112     C                   ELSE
000315220112     C                   Z-ADD     0             I
000316220112     C                   END
000317220112      *
000318220112     C                   Z-ADD     I             S                 4 0
000319220112     C                   Z-ADD     1             I
000320220112     C     S             DOWGE     I
000321220112     C                   MOVE      IMSG(I)       OMSG(O)
000322220112     C                   ADD       1             I
000323220112     C                   ADD       1             O
000324220112     C                   END
000325220112      *
000326220112      **  Write CRLF to message array if not blank
000327220112      *
000328220112     C                   EXSR      COROSR
000329220112      *
000330220112      **  Read outgoing messages file but ignore deleted parts.
000331220112     C     PTDL          DOUNE     'D'
000332220112     C     *IN15         OREQ      '1'
000333220112     C     TRNO          READE     MGOMSGPD                               15
000334220112     C                   END
000335220112     C                   END
000336220112      *
000337220112      **  Write end of text block
000338220112     C                   MOVEA     '-ü'          OMSG(O)
000339220112     C                   ADD       2             O
000340220112      *
000341220112      **  Add trailer block (block 5)
000342220112      **  PDE (possible duplicate) trailer...
000343220112     C                   SETOFF                                       14
000344220112      *
000345220112     C     *DTAARA       DEFINE                  MSSTAT
000346220112     C                   IN        MSSTAT
000347220112     C     PDEIND        IFEQ      'Y'
000348220112     C                   SETON                                        14
000349220112     C                   MOVEA     'ä5:'         OMSG(O)
000350220112     C                   ADD       3             O
000351220112     C                   MOVEA     'äPDE:ü'      OMSG(O)
000352220112     C                   ADD       6             O
000353220112     C                   END
000354220112      *
000355220112      **  ...and TNG (training) trailer as required
000356220112     C     @TNG          IFEQ      '0'
000357220112     C     *IN14         IFEQ      '0'
000358220112     C                   MOVEA     'ä5:'         OMSG(O)
000359220112     C                   ADD       3             O
000360220112     C                   END
000361220112     C                   SETON                                        14
000362220112     C                   MOVEA     'äTNG:ü'      OMSG(O)
000363220112     C                   ADD       6             O
000364220112     C                   END
000365220112      *
000366220112      **  End trailer block
000367220112     C     *IN14         IFEQ      '1'
000368220112     C                   MOVE      'ü'           OMSG(O)
000369220112     C                   ADD       1             O
000370220112     C                   END
000371220112      *
000372220112      **  Add hash
000373220112     C                   MOVEA     HSH           OMSG(O)
000374220112     C     O             DIV       398           Y                 2 0
000375220112     C                   ADD       1             O
000376220112      *
000377220112      **  If compressed msg is greater than 2000 bytes output report
000378220112     C     O             IFGT      8100
000379220112     C                   EXSR      REPT
000380220112     C                   END
000381220112      *
000382220112      **  If ready output records
000383220112     C     Y             IFGT      0
000384220112     C                   EXSR      WRIT
000385220112     C                   END
000386220112      *
000387220112      **  Update status on Message Reference file
000388220112     C                   MOVE      'TRAN'        MGST
000389220112     C                   MOVE      '3'           MGSG
000390220112     C                   UPDATE    MGOREFD0
000391220112      *
000392220112      **  Read message reference file
000393220112     C                   READ      MGOREF11                               10
000394220112     C                   ENDDO
000395220112      *
000396220112      **  Output remaining record
000397220112     C     O             IFGT      1
000398220112     C                   Z-ADD     1             Y
000399220112     C                   EXSR      WRIT
000400220112     C                   END
000401220112      *
000402220112      ** If *IN16 is off, no records output to MS940XPD, Set on U8 to
000403220112      ** ensure CL does not transmit empty file
000404220112      *
000405220112     C                   SETON                                        LR
000406220112      *
000407220112      *  Trailer record for Corona
000408220112      *
000409220112     CLR 16              READ      MS940XPD                               33
000410220112     CLR 16              CLEAR                   MSREC
000411220112     CLR 16              MOVEL     '-}'          MSREC
000412220112     CLR 16              WRITE     MS940XD0
000413220112     CLR                 WRITE     ENDRPT
000414220112     CLR 30              CLOSE     MS0209AU
000415220112     CLR                 RETURN
000416220112      *
000417220112      *****************************************************************
000418220112      *   INIT - inital process                                       *
000419220112      *   Called by - main process                                    *
000420220112      *****************************************************************
000421220112     C     INIT          BEGSR
000422220112      *
000423220112     C                   MOVEA     CPY@          BIS@             80
000424220112      *
000425220112      **  Set up LDA
000426220112     C     *DTAARA       DEFINE                  LDA
000427220112     C     *LOCK         IN        LDA
000428220112     C                   MOVE      *BLANKS       DBFILE
000429220112     C                   MOVE      *BLANKS       DBKEY
000430220112     C                   MOVEL     'MS0209'      DBPGM
000431220112     C                   MOVE      *BLANKS       DBASE
000432220112     C                   OUT       LDA
000433220112      *
000434220112      **  Access SDBANKL0 to find run date
000435220112     C                   READ      SDBANKPD                               99
000436220112     C                   MOVE      BJURPT        #URPT            53
000437220112     C                   MOVE      BJMRDT        #MRDT             7
000438220112      *
000439220112      ** Ensure audit report is recorded by RCF
000440220112     C                   EXSR      RECRCF
000441220112      *
000442220112     C     *IN99         IFEQ      '1'
000443220112     C     *LOCK         IN        LDA
000444220112     C                   MOVE      'SDBANKPD'    DBFILE
000445220112     C                   MOVEL     'FIRST'       DBKEY
000446220112     C                   Z-ADD     01            DBASE
000447220112     C                   OUT       LDA
000448220112     C                   WRITE     DBERROR
000449220112     C                   EXSR      *PSSR
000450220112     C                   END
000451220112      *
000452220112      **  Initialise 'CR' and 'LF' fields
000453220112     C                   MOVE      *LOVAL        CR                1
000454220112     C                   BITON     '457'         CR
000455220112     C                   MOVE      *LOVAL        LF                1
000456220112     C                   BITON     '257'         LF
000457220112     C                   MOVE      *LOVAL        HSH               1
000458220112     C                   BITON     '13467'       HSH
000459220112     C                   MOVEL     CR            CRLF              2
000460220112     C                   MOVE      LF            CRLF
000461220112      *
000462220112      **  Initialise X'00' field
000463220112     C                   BITOFF    '01234567'    #00               1
000464220112      *
000465220112      **  Initialise text fields
000466220112     C                   MOVE      'ä1:F01'      TXT1
000467220112     C                   MOVEL     '99999999'    TXT2
000468220112     C                   MOVE      '99üä2:I'     TXT2
000469220112     C                   MOVEL     'üä4:'        TXT3              4
000470220112      *
000471220112     C                   Z-ADD     1             O                 4 0
000472220112      *
000473220112      * Access SAR details to see if CSW001 is switched on
000474220112      *
000475220112     C                   CALL      'AOSARDR0'
000476220112     C                   PARM      *BLANKS       @RTCD             7
000477220112     C                   PARM      '*VERIFY'     @OPTN             7
000478220112     C                   PARM      'CSW001'      @SARD             6
000479220112     C     SCSARD        PARM      SCSARD        DSFDY
000480220112      *
000481220112     C                   MOVE      *BLANKS       CSW001            1
000482220112     C     @RTCD         IFEQ      *BLANKS
000483220112     C                   MOVEL     'Y'           CSW001
000484220112     C                   ELSE
000485220112     C     @RTCD         IFNE      '*NRF   '                                    B2
000486220112     C     *LOCK         IN        LDA
000487220112     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
000488220112     C                   MOVEL     '*VERIFY'     DBKEY                          * DBERR 03 *
000489220112     C                   MOVE      '03'          DBASE                          ************
000490220112     C                   OUT       LDA
000491220112     C                   WRITE     DBERROR
000492220112     C                   EXSR      *PSSR
000493220112     C                   ENDIF                                                  E2
000494220112     C                   ENDIF
000495220112      *
000496220112     C                   ENDSR
000497220112      *****************************************************************
000498220112      /EJECT
000499220112      *****************************************************************
000500220112      *                                                               *
000501220112      *  RECRCF - RCF processing                                      *
000502220112      *                                                               *
000503220112      *****************************************************************
000504220112     C     RECRCF        BEGSR
000505220112      *
000506220112     C                   OPEN      MS0209AU                             30
000507220112     C                   WRITE     HEADER
000508220112      *
000509220112      ** Ensure Detail Spool File recorded by RCF.
000510220112      *
000511220112     C                   Z-ADD     SFNUMU        ZSNUMU            6 0
000512220112     C                   CALL      'ZSFILE'
000513220112     C                   PARM                    PSEQ              5
000514220112     C                   PARM                    PENTY             3
000515220112     C                   PARM                    SFILEU
000516220112     C                   PARM                    ZSNUMU
000517220112     C                   PARM      *BLANK        ZSERR             1
000518220112      *
000519220112      ** If Error occurs during ZSFILE processing, then return to the
000520220112      ** Calling Program.
000521220112      *
000522220112     C     ZSERR         IFEQ      'Y'
000523220112     C                   MOVE      *ON           *INU7
000524220112     C                   MOVE      *ON           *INU8
000525220112     C                   MOVE      *ON           *INLR
000526220112     C                   RETURN
000527220112     C                   ENDIF
000528220112      *
000529220112     C                   ENDSR
000530220112      *****************************************************************
000531220112     C/EJECT
000532220112      *****************************************************************
000533220112      *   WRIT - output record                                        *
000534220112      *   Called by - main process                                    *
000535220112      *****************************************************************
000536220112     C     WRIT          BEGSR
000537220112      *
000538220112     C                   DO        Y
000539220112      *
000540220112      **  Move remaining data forward in array
000541220112      *
000542220112     C                   MOVEA     *BLANKS       TMSG
000543220112     C                   MOVEA     OMSG(399)     TMSG
000544220112     C                   MOVEA     *BLANKS       OMSG
000545220112     C                   MOVEA     TMSG          OMSG
000546220112     C                   SUB       398           O
000547220112     C                   END
000548220112      *
000549220112     C                   ENDSR
000550220112      *****************************************************************
000551220112     C/EJECT
000552220112      *****************************************************************
000553220112      *   REPT - process error report                                 *
000554220112      *   Called by - main process                                    *
000555220112      *****************************************************************
000556220112     C     REPT          BEGSR
000557220112      *
000558220112      **  Update message reference record to 'A' if message > 2000
000559220112     C                   MOVE      'AMND'        MGST
000560220112     C                   MOVE      '1'           MGSG
000561220112     C                   UPDATE    MGOREFD0
000562220112      *
000563220112      * Output error report
000564220112     C                   WRITE     DETAIL
000565220112      *
000566220112     C                   ENDSR
000567220112      *****************************************************************
000568220112     C/EJECT
000569220112      *****************************************************************
000570220112      *   *PSSR - error handling                                      *
000571220112      *   Called by - main process                                    *
000572220112      *****************************************************************
000573220112      *
000574220112     C     *PSSR         BEGSR
000575220112      *
000576220112     C                   SETON                                        U7U8LR
000577220112     C                   DUMP
000578220112     C                   RETURN
000579220112      *
000580220112     C                   ENDSR
000581220112      ********************************************************************
000582220112      * IGM002 Oct 98 MKI/Belgium - Corona File Creation
000583220112      *
000584220112      * This routine is written specifically for GENERAL BANK in KOLN.
000585220112      * The format used for record layout is MERVE . To copy this file
000586220112      * CORONA Pc only one procedure is permitted the FTP not in Binary
000587220112      * mode .
000588220112      * If this program is modified again take care to the CCSID 273 in
000589220112      * Germany country the EBCDIC value is different than the original.
000590220112      *
000591220112      ********************************************************************
000592220112     C     COROSR        BEGSR
000593220112      *
000594220112     C     *IN35         IFEQ      *ON
000595220112     C                   CLEAR                   AFD
000596220112     C                   CLEAR                   AFB
000597220112     C                   Z-ADD     1             WW                2 0
000598220112     C                   Z-ADD     1             YY                2 0
000599220112     C                   MOVEA     MFLD          AFD
000600220112     C                   MOVEL     Z2Z           MLPFL1           51
000601220112     C                   MOVEA     MLPFL1        AFB
000602220112     C     AFB(YY)       DOWNE     *BLANK
000603220112     C                   ADD       1             YY
000604220112     C                   ENDDO
000605220112     C     YY            SUB       1             YY
000606220112     C     WW            DOWLE     50
000607220112     C     AFD(WW)       IFNE      *BLANKS
000608220112     C                   ADD       1             YY
000609220112     C                   MOVE      AFD(WW)       AFB(YY)
000610220112     C     YY            IFEQ      51
000611220112     C                   Z-ADD     50            WW
000612220112     C                   ENDIF
000613220112     C                   ENDIF
000614220112     C                   ADD       1             WW
000615220112     C                   ENDDO
000616220112     C                   MOVEA     AFB           Z2MLP
000617220112     C                   MOVE      *ON           *IN36
000618220112     C                   MOVE      RECZ          MSREC
000619220112     C                   WRITE     MS940XD0
000620220112     C                   MOVE      '1'           *IN16
000621220112     C                   CLEAR                   RECZ
000622220112     C                   ENDIF
000623220112     C                   MOVE      *OFF          *IN35
000624220112      *
000625220112     C     *IN36         IFEQ      *OFF
000626220112      *  HEADER
000627220112     C     *IN17         IFEQ      *ON
000628220112     C     MTAG          ANDEQ     ':20:'
000629220112     C                   MOVEL     *BLANKS       OLTTAG
000630220112     C                   MOVEL     ARH(3)        RECZ
000631220112     C                   READ      MS940XPD                               18
000632220112     C                   MOVEL     RECZ          MSREC
000633220112     C                   WRITE     MS940XD0
000634220112     C                   MOVE      '1'           *IN16
000635220112     C                   CLEAR                   RECZ
000636220112      *
000637220112     C                   MOVEL     ARH(2)        RECZ
000638220112     C                   MOVE      '{4'          Z3
000639220112     C                   MOVEL     ':'           Z4
000640220112     C                   READ      MS940XPD                               18
000641220112     C                   MOVEL     RECZ          MSREC
000642220112     C                   WRITE     MS940XD0
000643220112     C                   CLEAR                   RECZ
000644220112     C                   ENDIF
000645220112     C     *IN17         IFEQ      *OFF
000646220112     C                   CLEAR                   RECZ
000647220112     C                   MOVE      *ON           *IN17
000648220112     C                   MOVEL     ARH(1)        RECZ
000649220112     C                   MOVE      '{4'          Z3
000650220112     C                   MOVEL     ':'           Z4
000651220112     C                   READ      MS940XPD                               18
000652220112     C                   MOVEL     RECZ          MSREC
000653220112     C                   WRITE     MS940XD0
000654220112     C                   ENDIF
000655220112     C                   MOVE      MTAG          IAZ
000656220112     C                   MOVE      MFLD          IFD
000657220112      *
000658220112      *  No blank characters bewteen the fields are allowed.
000659220112      *  The message fields cannot begin with special characters .
000660220112      *
000661220112     C     COM1          IFNE      COM2
000662220112     C                   CLEAR                   RECZ
000663220112     C                   MOVE      *OFF          *IN34
000664220112     C                   MOVEL     MTAG          TTAG              4
000665220112     C                   MOVEL     MFLD          TMF               3
000666220112     C     TTAG          IFEQ      ':86:'
000667220112     C     TMF           ANDEQ     '///'
000668220112     C                   MOVE      *ON           *IN34
000669220112     C                   MOVE      TTAG          OLTTAG            4
000670220112     C                   ENDIF
000671220112     C     OLTTAG        IFEQ      ':86:'
000672220112     C     TTAG          ANDEQ     '    '
000673220112     C                   MOVE      *ON           *IN34
000674220112     C                   END
000675220112     C     *IN34         IFEQ      *OFF
000676220112     C                   READ      MS940XPD                               18
000677220112     C                   MOVEL     *BLANKS       OLTTAG
000678220112     C                   CLEAR                   Z2
000679220112     C                   CLEAR                   Z2A
000680220112     C                   CLEAR                   Z2B
000681220112     C                   MOVE      MTAG          Z1
000682220112     C                   MOVEL     MTAG          Z0                1
000683220112     C                   MOVE      MTAG          Z000              1
000684220112     C                   MOVE      MTAG          ZWK               2
000685220112     C                   MOVEL     ZWK           Z00               1
000686220112     C     Z0            IFEQ      ':'
000687220112     C     Z00           ANDEQ     ':'
000688220112     C                   MOVEL     MFLD          Z2
000689220112     C                   MOVEL     Z2            TIR               1
000690220112     C     TIR           IFEQ      '-'
000691220112     C                   MOVEL     '.'           Z2
000692220112     C                   ENDIF
000693220112     C                   ENDIF
000694220112     C     Z0            IFEQ      ':'
000695220112     C     Z000          ANDEQ     ':'
000696220112     C                   MOVEL     MFLD          Z2A
000697220112     C                   MOVEL     Z2A           TIR
000698220112     C     TIR           IFEQ      '-'
000699220112     C                   MOVEL     '.'           Z2A
000700220112     C                   ENDIF
000701220112     C                   ENDIF
000702220112     C     Z2            IFEQ      *BLANK
000703220112     C     Z2A           ANDEQ     *BLANK
000704220112     C                   CLEAR                   AFD
000705220112     C                   CLEAR                   AFB
000706220112     C                   Z-ADD     *ZERO         WW                2 0
000707220112     C                   Z-ADD     *ZERO         YY                2 0
000708220112     C                   MOVEA     MFLD          AFD
000709220112     C                   ADD       1             WW
000710220112     C     WW            DOWLE     50
000711220112     C     AFD(WW)       IFNE      *BLANKS
000712220112     C                   ADD       1             YY
000713220112     C                   MOVE      AFD(WW)       AFB(YY)
000714220112     C                   ENDIF
000715220112     C                   ADD       1             WW
000716220112     C                   ENDDO
000717220112     C                   MOVEA     AFB           Z2B
000718220112     C                   MOVEL     Z2B           TIR
000719220112     C     TIR           IFEQ      '-'
000720220112     C                   MOVEL     '.'           Z2B
000721220112     C                   ENDIF
000722220112     C                   ENDIF
000723220112     C                   MOVE      MFLD          Z2Z
000724220112     C                   MOVEL     MTAG          ZAZ
000725220112     C                   CLEAR                   Z3
000726220112      *  COMPLEMENT
000727220112     C     TTAG          IFEQ      ':61:'
000728220112     C     CTRC          ANDEQ     *BLANK
000729220112     C                   MOVE      *ON           *IN35
000730220112     C                   ENDIF
000731220112      *  TRAILER
000732220112     C     *IN35         IFEQ      *OFF
000733220112     C                   MOVEL     RECZ          MSREC
000734220112     C                   WRITE     MS940XD0
000735220112     C                   ENDIF
000736220112     C                   ENDIF
000737220112     C                   ENDIF
000738220112     C                   ENDIF
000739220112      * Reset Indicator
000740220112     C                   MOVE      *OFF          *IN36
000741220112      *
000742220112     C                   ENDSR
000743220112      ********************************************************************
000744220112** CPY@   **      OBJECT COPYRIGHT
000745220112(C) Copyright Finastra International Limited 2021
000746220112** HEADER RECORD FOR CORONA
000747220112{1:F01HELAUS33AXXX0000000000}{2:O9401214991207HELAUS33AXXX00000000009912071214N}
000748220112{1:F01HELAUS33AXXX0000000000}{2:O9401214991207HELAUS33AXXX00000000009912071214N}
000749220112-}
