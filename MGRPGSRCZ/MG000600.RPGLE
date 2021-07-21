000100210712     H DEBUG FTRANS
000200210712     H COPYRIGHT('(c) Finastra International Limited 2012')
000300210712      *****************************************************************
000400210712/*STD *  RPGBASEBND                                                   *
000500210712/*EXI *  TEXT('Midas MG Format Commodity Trade(Consolidate Fixes)')   *
000600210712      *****************************************************************
000700210712      *                                                               *
000800210712      *  Midas - Message Generation                                   *
000900210712      *                                                               *
001000210712      *  MG000600  - Midas MG Format Commodity Trade Confirmation     *
001100210712      *                                                               *
001200210712      *  (c) Finastra International Limited 2012                      *
001300210712      *                                                               *
001400210712      *  Last Amend No. MD057682           Date 12Apr21               *
001500210712      *  Prev Amend No. MD055694           Date 09Mar20               *
001600210712      *                 MD046248           Date 27Oct17               *
001700210712      *                 CDL099             Date 06Oct17               *
001800210712      *                 CSW216             Date 14Mar16               *
001900210712      *                 MD035515           Date 19Aug15               *
002000210712      *                 MD033754           Date 21Apr15               *
002100210712      *                 CGL165             Date 17Feb15               *
002200210712      *                 MD026953           Date 25Nov14               *
002300210712      *                 MD030922           Date 25Nov14               *
002400210712      *                 MD030880           Date 25Nov14               *
002500210712      *                 CSW214             Date 25Nov14               *
002600210712      *                 CDL096             Date 22Sep14               *
002700210712      *                 CDL094             Date 11Jun14               *
002800210712      *                 MD024078           Date 13Dec13               *
002900210712      *                 MD024068           Date 12Dec13               *
003000210712      *                 MD022425           Date 03Jun13               *
003100210712      *                 AR1097200          Date 05Apr13               *
003200210712      *                 AR1097109          Date 04Apr13               *
003300210712      *                 AR1097406          Date 27Mar13               *
003400210712      *                 AR1094963          Date 12Mar13               *
003500210712      *                 AR1053647          Date 06Nov12               *
003600210712      *                 CMG003  *CREATE    Date 04Oct12               *
003700210712      *                                                               *
003800210712      *---------------------------------------------------------------*
003900210712      *                                                               *
004000210712      *  MD057682 - Populate Seq C tag 34R with buy ccy and buy amt.  *
004100210712      *             Map Seq C tag 57 with correct values (same as in  *
004200210712      *             Seq B1 tag 57 in MT300).                          *
004300210712      *  MD055694 - SWIFT Changes 2021                                *
004400210712      *  MD046248 - Finastra Rebranding                               *
004500210712      *  CDL099 - Split Value Date (Recompile)                        *
004600210712      *  CSW216 - SWIFT Changes 2016                                  *
004700210712      *  MD035515 - No MT600 generated if branch internal customer is *
004800210712      *             alphanumeric                                      *
004900210712      *  MD033754 - SWIFT MT600 not displayed in MMM even when data   *
005000210712      *             record has been successfully transmitted in       *
005100210712      *             I-series                                          *
005200210712      *  CGL165 - Dual Withholding Tax (Recompile)                    *
005300210712      *  MD026953 - MGOREFPF is not updating                          *
005400210712      *  MD030922 - Line 7 displayed for field tag 72                 *
005500210712      *  MD030880 - Field 81J is generated in MT600 if the transaction*
005600210712      *             was inserted via interface                        *
005700210712      *  CSW214 - SWIFT Changes 2014                                  *
005800210712      *  CDL096 - Business Day Conventions on MM Deals                *
005900210712      *           (Recompile)                                         *
006000210712      *  CDL094 - Enhance  Receive Settlement Instructions            *
006100210712      *           (Recompiled)                                        *
006200210712      *  MD024078 - No field tags 83J and 87J for a trade repository  *
006300210712      *             confirmation                                      *
006400210712      *  MD024068 - Error on Code Common Reference Field Tag 22 in    *
006500210712      *             MT600 in MMM                                      *
006600210712      *  MD022425 - Additional deliveries for CSW213                  *
006700210712      *  AR1097200 - job DLC0210A in MSGW status                      *
006800210712      *  AR1097109 - No MT600 generated in Mgorefpd and MMM England   *
006900210712      *              zone; A character representation of a numeric    *
007000210712      *              value is in error                                *
007100210712      *  AR1097406 - A character representation of a numeric value is *
007200210712      *              in error                                         *
007300210712      *  AR1094963 - MT600 clashes to BF2.1                           *
007400210712      *  AR1053647 - Wrong sequence for Commodity Sold                *
007500210712      *  CMG003 - SWIFT MT600 Message Generation                      *
007600210712      *                                                               *
007700210712      *****************************************************************
007800210712      *                                                               *
007900210712      * ID C  F  H  L    FUNCTION OF INDICATORS                       *
008000210712      *                                                               *
008100210712      *    05            Error on write to PF/MGOREFPD                *
008200210712      *    06            Error on write to PF/MGOMSGPD                *
008300210712      *    10            EOF MGF600PD                                 *
008400210712      *    11            CHAIN to MGOREFL0 (TRN unique ?)             *
008500210712      *    15            Error in call to standard program (ZMxxxx)   *
008600210712      *    16            Error on delete of GDF record.               *
008700210712      *    22            LOKUP operation for determining the codeword *
008800210712      *    23            LOKUP operation for settlement code          *
008900210712      *    24            Error on call of MG5000                      *
009000210712      *    25            ConCord Interface is ON.                     *
009100210712      *    30            Feedback record not generated                *
009200210712      *    50            MG000600P1 open                              *
009300210712      *    55            Tag 53A already generated                    *
009400210712      *    U7U8          Database error                               *
009500210712      *                                                               *
009600210712     ******************************************************************
009700210712      *                                                               *
009800210712      *  S U B R O U T I N E  I N D E X                               *
009900210712      *                                                               *
010000210712      *   Main process                                                *
010100210712      *   SRINIT  - Initial process                                   *
010200210712      *   SRINTF  - Initialise non-constant fields                    *
010300210712      *   SRROUT  - Determine message routing                         *
010400210712      *   SRFMTA  - Format message detail - Sequence A                *
010500210712      *   SRFMTB  - Format message detail - Sequence B                *
010600210712      *   SRFMTC  - Format message detail - Sequence C                *
010700210712      *   SRFMTD  - Format message detail - Sequence D                *                     MD022425
010800210712      *   SRFMPY  - Format message - Cust. Extension SWIFT Details    *                     MD022425
010900210712      *   SRCODE  - Calculate codeword for fields 21/22               *
011000210712      *   SRPAYE  - Pay side field 57 (KNOWN or UNKNOWN)              *
011100210712      *   FSWAD - Format SWIFT address                                *
011200210712      *   FMT72 - Format Field 72                                     *
011300210712      *   FMT53 - Format Field 53  sequence B                         *
011400210712      *   FMTX1 - Format fields 56/57 or 86/87 for FMTB FMTC          *
011500210712      *   SRREPT  - Print incorrectly generated messages              *
011600210712      *   SROMSG  - Output correctly generated messages               *
011700210712      *   SRWREF  - Write reference record to PF/MGOREFPD             *
011800210712      *   *PSSR - Error handling                                      *
011900210712      *                                                               *
012000210712      *   NOTE:   A multiple occurrence data structure is used to     *
012100210712      *           store up the records that make up the SWIFT message *
012200210712      *           before writing the whole message to file.           *
012300210712      *           To store the records of the message, you must       *
012400210712      *           first access an OCUR record, obtain the Message Tag *
012500210712      *           & Message field data values for this OCUR record,   *
012600210712      *           then go on to the next OCUR record and continue     *
012700210712      *           this process until the SWIFT message is complete.   *
012800210712      *****************************************************************
012900210712
013000210712      ** +--------------------------------------+
013100210712      ** ¦ F-specs                              ¦
013200210712      ** ¦ =======                              ¦
013300210712      ** +--------------------------------------+
013400210712
013500210712     FMGF600PD  UF   E             DISK
013600210712     F                                     COMMIT
013700210712      ** MT600 Generation Driver File
013800210712
013900210712     FMGOREFL0  IF   E           K DISK
014000210712     F                                     RENAME(MGOREFD0:MGREFL0)
014100210712      ** MG Message Reference by TRNO
014200210712
014300210712     FMGOREFPD  O    E             DISK
014400210712     F                                     COMMIT
014500210712      ** MG Master Messages Reference File
014600210712
014700210712     F***DEALS**   IF   E           K DISK    USROPN                                       AR1097200
014800210712     FDEALALL   IF   E           K DISK    USROPN                                          AR1097200
014900210712     F                                     IGNORE(DEALSDAF)
015000210712     F                                     IGNORE(DEALSDCF)
015100210712     F                                     IGNORE(DEALSDDF)
015200210712     F                                     IGNORE(DEALSDEF)
015300210712     F                                     IGNORE(DEALSDGF)
015400210712     F                                     IGNORE(DEALSDFF)
015500210712      ** Midas DL Deals File
015600210712
015700210712     FSDCMDTL0  IF   E           K DISK
015800210712      ** Midas SD Commodity details
015900210712
016000210712     FMGOMSGPD  O    E             DISK
016100210712     F                                     COMMIT
016200210712      ** MG Master Message Data File
016300210712
016400210712     FDLRPIFL1  IF   E           K DISK    USROPN                                           MD024078
016500210712                                                                                            MD024078
016600210712     F***MGHISTL0  UF A E           K DISK                                                  MD022425
016700210712     FMGHISTL7  UF A E           K DISK                                                     MD022425
016800210712     F                                     COMMIT
016900210712      ** MG Transaction history file
017000210712                                                                                            MD057682
017100210712     FSDCUSTL7  IF   E           K DISK                                                     MD057682
017200210712                                                                                            MD057682
017300210712     F/COPY WNCPYSRC,MG0600F001
017400210712
017500210712     FMGOEXTPD  O    E             DISK
017600210712     F                                     COMMIT
017700210712      ** Midas MGS MG Message Data extension file
017800210712
017900210712     FMG000600P1O    E             PRINTER USROPN
018000210712     F                                     OFLIND(*IN99)                                    MD022425
018100210712      ** MG Confirmation Formatting Error Report
018200210712
018300210712     FMG000600AUO    E             PRINTER USROPN
018400210712      ** MG Confirmation Formatting Audit Report
018500210712
018600210712     F/COPY WNCPYSRC,MG0600FFP1
018700210712
018800210712      ********************************************************************
018900210712      /EJECT
019000210712      *****************************************************************
019100210712      ** +--------------------------------------+
019200210712      ** ¦ D-specs                              ¦
019300210712      ** ¦ =======                              ¦
019400210712      ** +--------------------------------------+
019500210712
019600210712      ** Array Containing Copyright statement
019700210712     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
019800210712      ** Array Containing Copyright statement
019900210712
020000210712     D MSGA            S             60    DIM(9) CTDATA PERRCD(1)
020100210712      ** Array Containing Messages
020200210712
020300210712     D TABS96          S             22    DIM(18) CTDATA PERRCD(1)
020400210712     D TABR96          S             10    DIM(18) ALT(TABS96)
020500210712      ** Selection Criteria for the codewrod (SWIFT96)
020600210712
020700210712     D TABNST          S              2    DIM(5) CTDATA PERRCD(1)
020800210712      ** Codes indicating settlement via nostro
020900210712
021000210712     D TABINT          S              2    DIM(5) CTDATA PERRCD(1)
021100210712     D/COPY WNCPYSRC,MG0300AE01
021200210712     D VALUNI          S              3    DIM(13) CTDATA PERRCD(1)
021300210712      ** Codes indicating settlement via internal
021400210712
021500210712     D/COPY WNCPYSRC,MG0600E001
021600210712
021700210712     D @WRK            S              1    DIM(50)
021800210712     D @BTB            S             35    DIM(6)
021900210712
022000210712     D AR8XJ           S             40    DIM(5)                                           MD055694
022100210712     D AN8X            S             40    DIM(5)                                           MD055694
022200210712                                                                                            MD055694
022300210712     D AJFORM          C                   CONST('ReplaceJFormatSlash')                     MD055694
022400210712     D SWIFT           C                   CONST('SWIFTACTV')                               MD055694
022500210712     D JFRMAT          C                   CONST('MG001003')                                MD055694
022600210712                                                                                            MD055694
022700210712     D/COPY WNCPYSRC,MG0600IIP2
022800210712
022900210712     D MULT            DS                  OCCURS(95)
023000210712     D  MTAG                   1      5
023100210712     D  MFLD                   6     55
023200210712     D  MERR                  56    105
023300210712      **  Multiple occurrence data structure for message
023400210712
023500210712     D EXTN            DS                  OCCURS(45)
023600210712     D  MPSN                   1      2  0
023700210712     D  MTG                    3      7
023800210712     D  MCSI                   8     15
023900210712      ** Multiple occurrence data structure for extension file
024000210712
024100210712     D                 DS
024200210712     D  @MTG                   1      5
024300210712     D  FLDTYP                 2      2
024400210712     D  FLDTAG                 4      4
024500210712      ** Field tag data structure
024600210712
024700210712     D @TRN            DS                  OCCURS(16)
024800210712     D  @TR1                   1      2
024900210712     D  @TR2                   3      8
025000210712     D  @TR3                   9     11  0
025100210712     D  @TR4                  12     16
025200210712      **  Data structure build transaction reference number
025300210712
025400210712     D @TRN1           DS                  OCCURS(16)                                       MD022425
025500210712     D  @TRN11                 1      2                                                     MD022425
025600210712     D  @TRN21                 3      8                                                     MD022425
025700210712     D  @TRN31                 9     14                                                     MD022425
025800210712     D  @TRN41                15     16  0                                                  MD022425
025900210712     D  @TRNID                 3     14                                                     MD022425
026000210712      **  Data structure build transaction reference number CSW213                          MD022425
026100210712                                                                                            MD022425
026200210712     D SEARCH          DS                  OCCURS(22)
026300210712     D  @MGST                  1      6
026400210712     D  @LSCC                  8     15
026500210712     D  @OF87                 17     17
026600210712     D  @NOST                 19     22
026700210712      **  Data structure to build key to determine codeword
026800210712
026900210712     D CODEWD          DS                  OCCURS(22)
027000210712     D  CWRD                   1      8
027100210712     D  F57U                  10     10
027200210712      **  Data structure containing codeword for the new message
027300210712
027400210712     D FLD2N           DS                  OCCURS(18)
027500210712     D  ZSCCY                  1      3
027600210712     D  ZSAMNT                 4     18
027700210712     D FLD3N           DS                  OCCURS(24)
027800210712     D  ZSDAT1                 1      6
027900210712     D  ZSCCY1                 7      9
028000210712     D  ZSAMN1                10     24
028100210712      **  Data structure containing codeword for FieldS 32B/32B
028200210712
028300210712     D ERR3N           DS                  OCCURS(24)
028400210712     D  ZCCY                   1      3
028500210712     D  ZAMT                   5     17
028600210712      **  Erroneous currency & amounts
028700210712
028800210712     D @MTAG           DS                  OCCURS(5)
028900210712     D  COLON1                 1      1
029000210712     D  FLDNO                  2      3
029100210712     D  TAG                    4      4
029200210712     D  COLON2                 5      5
029300210712      **  Data structure constructing message field tag
029400210712
029500210712     D MPHAS           DS
029600210712     D  STATUS                 1      1
029700210712      **  Data structure to check MPHAS for Close of Business
029800210712
029900210712     D P@IN            DS           256
030000210712     D  I@SNBR                 1      3
030100210712     D  I@DSCN                 4      9
030200210712     D  I@MTPY                10     12
030300210712     D  I@SETT                13     14  0
030400210712     D  I@CONC                15     15
030500210712     D  I@FTCS                16     16
030600210712     D  I@MMOD                17     18
030700210712      ** Data structure for input parameter
030800210712
030900210712     D P@OUT           DS           256
031000210712     D  O@CNSN                 1      6  0
031100210712     D  O@SWSN                 7     18
031200210712     D  O@NWSN                19     38
031300210712     D  O@SWDS                39     49
031400210712     D  W@96CN                46     46
031500210712     D  W@BIC                 47     49
031600210712     D  O@NWDS                50     69
031700210712     D  O@NWRK                70     75
031800210712     D  O@MGSG                76     76
031900210712     D  O@MGST                77     80
032000210712     D  O@PAIN                81     81
032100210712     D  O@PCNB                82     87
032200210712     D  O@SPRS                88     90
032300210712      ** Data structure for ouput parameter
032400210712
032500210712     D P@BTB           DS
032600210712     D  MGBTB1                 1     35
032700210712     D  MGBTB2                36     70
032800210712     D  MGBTB3                71    105
032900210712     D  MGBTB4               106    140
033000210712     D  MGBTB5               141    175
033100210712     D  MGBTB6               176    210
033200210712
033300210712     D @HREF           DS                  OCCURS(16)
033400210712     D  HSMODI                 1      2
033500210712     D  HSTRAN                 3      8
033600210712     D  HSSEQ                  9     11
033700210712      **  Data structure for related reference
033800210712
033900210712     D @HREF1          DS                  OCCURS(16)                                       MD022425
034000210712     D  H1MODI                 1      2                                                     MD022425
034100210712     D  H1TRAN                 3      8                                                     MD022425
034200210712     D  HSDEST                 9     14                                                     MD022425
034300210712     D  @SSEQ                 15     16                                                     MD022425
034400210712      **  Data structure for related reference CSW213                                       MD022425
034500210712                                                                                            MD022425
034600210712     D RPPT            DS                  OCCURS(5)                                        MD022425
034700210712     D  MGRJXX                 1     35                                                     MD022425
034800210712     D  MGRPXX                36     41                                                     MD022425
034900210712     D  MGRNXX                42     61                                                     MD022425
035000210712     D  MGRCXX                62     71                                                     MD022425
035100210712     D  MGRSXX                72     82                                                     MD022425
035200210712     D  MGRLXX                83    102                                                     MD022425
035300210712     D  MGRAXX               103    136                                                     MD022425
035400210712     D***MGUTXX*              137    146                                             MD022425 CSW214
035500210712     D***MGTNXX*              147    178                                             MD022425 CSW214
035600210712     D***MGTIXX*              179    179                                             MD022425 CSW214
035700210712     D***MGETXX*              180    180                                             MD022425 CSW214
035800210712     D***MGUTXX*              137    156                                               CSW214 CSW216
035900210712     D***MGTNXX*              157    188                                               CSW214 CSW216
036000210712     D***MGTIXX*              189    189                                               CSW214 CSW216
036100210712     D***MGETXX*              190    190                                               CSW214 CSW216
036200210712     D  MGUTXX               137    166                                                       CSW216
036300210712     D  MGTNXX               167    198                                                       CSW216
036400210712     D  MGTIXX               199    199                                                       CSW216
036500210712     D  MGETXX               200    200                                                       CSW216
036600210712                                                                                            MD055694
036700210712     D D87CDE          DS                                                                   MD055694
036800210712     D  DSRI01                 1     40                                                     MD055694
036900210712     D  DSRI02                41     80                                                     MD055694
037000210712     D  DSRI03                81    120                                                     MD055694
037100210712     D  DSRI04               121    160                                                     MD055694
037200210712     D  DSRI05               161    200                                                     MD055694
037300210712                                                                                            MD055694
037400210712      **  Multiple occurrence data structure for reporting party                            MD022425
037500210712                                                                                            MD022425
037600210712     D/COPY WNCPYSRC,MG0600I001
037700210712
037800210712     D SDCSSW        E DS                  EXTNAME(SDCSSWPD)                                MD022425
037900210712      **  Data structure for Customer Extensions SWIFT Details                              MD022425
038000210712                                                                                            MD022425
038100210712     D SDBANK        E DS                  EXTNAME(SDBANKPD)
038200210712      **  Data structure for bank file
038300210712
038400210712     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
038500210712      **  Data structure for trading file
038600210712
038700210712     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
038800210712     D  D83CDE               917   1116                                                     MD055694
038900210712      **  Data structure for customer file
039000210712
039100210712     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
039200210712     D  DFACQQ       E                     EXTFLD(QQDFAC)
039300210712      **  Data structure for branch file
039400210712
039500210712     D SDBROK        E DS                  EXTNAME(SDBROKPD)
039600210712      **  Data structure for broker file
039700210712
039800210712     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
039900210712      **  Data structure for module ICD file
040000210712
040100210712     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
040200210712     D  ACCDQQ       E                     EXTFLD(QQACCD)
040300210712      **  Data structure for nostro file
040400210712
040500210712     D SDCURR        E DS                  EXTNAME(SDCURRPD)
040600210712      **  Data structure for Currency File
040700210712
040800210712     D SDMGME        E DS                  EXTNAME(SDMGMEPD)
040900210712      **  Data structure for message management data.
041000210712
041100210712     D SCSARD        E DS                  EXTNAME(SCSARDPD)
041200210712      **  Data structure for SAR - Switchable features file
041300210712
041400210712     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
041500210712      **  Data structure for counterparty nostro file
041600210712
041700210712     D DSFDY         E DS                  EXTNAME(DSFDY)
041800210712      **  Short data structure for access programs
041900210712
042000210712     D DSSDY         E DS                  EXTNAME(DSSDY)
042100210712      **  Long data structure for access programs
042200210712
042300210712     D DSLDY         E DS                  EXTNAME(DSLDY)
042400210712      ** Third data structure for access programs
042500210712
042600210712     D LDA             DS           256
042700210712     D  DBFILE               134    141
042800210712     D  DBKEY                142    170
042900210712     D  DBPGM                171    180
043000210712     D  DBASE                181    183  0
043100210712      **  Local data area
043200210712
043300210712     I/COPY WNCPYSRC,MG0600IIP2
043400210712
043500210712      **  Rename conflicting MGOREFL0 fields
043600210712
043700210712     IMGREFL0
043800210712     I              SYTM                        MSYTM
043900210712     I              NWRK                        MNWRK
044000210712     I              SECN                        MSECN
044100210712     I              NWSN                        MNWSN
044200210712     I              DECN                        MDECN
044300210712     I              NWDS                        MNWDS
044400210712     I              MGSG                        MMGSG
044500210712     I              MGST                        MMGST
044600210712     I              F57U                        MF57U
044700210712     I              LSCC                        MLSCC
044800210712     I              HRDT                        MHRDT
044900210712     I              MGDE                        MMGDE
045000210712     I              MGTM                        MMGTM
045100210712     I              LADT                        MLADT
045200210712     I              RELD                        MRELD
045300210712     I              RELT                        MRELT
045400210712     I              CFPF                        MCFPF
045500210712     I              TODY                        MTODY
045600210712     I              CLSS                        MCLSS
045700210712
045800210712     I/COPY WNCPYSRC,MG0600IIP1
045900210712
046000210712      *****************************************************************
046100210712      /EJECT
046200210712      *****************************************************************
046300210712
046400210712      ** +--- Start of Main processing -------------------------------+
046500210712      ** ¦                                                            ¦
046600210712      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
046700210712      ** ¦ is executed at program activation.                         ¦
046800210712      ** ¦                                                            ¦
046900210712      ** +------------------------------------------------------------+
047000210712
047100210712      ** Initial process
047200210712
047300210712     C/COPY WNCPYSRC,MG0600CCP3
047400210712
047500210712     C                   EXSR      SRINIT
047600210712
047700210712     C/COPY WNCPYSRC,MG0600C012
047800210712
047900210712      ** Read the first record from the MT600 extract file
048000210712
048100210712     C                   READ      MGF600PD                               10
048200210712
048300210712      ** Do While records found on the MT600 extract file
048400210712
048500210712     C     *IN10         DOWEQ     '0'
048600210712
048700210712     C/COPY WNCPYSRC,MG0600C013
048800210712
048900210712      ** If DEALING MSG and NETTING access DEALS file
049000210712
049100210712     C     CDL002        IFEQ      'Y'
049200210712     C     MGMODI        ANDEQ     'DL'
049300210712     C                   MOVEL     MGTNUM        KYDLNO            6 0
049400210712     C*****KYDLNO        CHAIN     DEALS                              40                   AR1097200
049500210712     C     KYDLNO        CHAIN     DEALALL                            40                   AR1097200
049600210712     C     *IN40         IFEQ      '1'
049700210712     C     RECI          OREQ      'N'                                                     AR1097200
049800210712     C                   MOVE      *BLANKS       NETBY
049900210712     C                   MOVE      *BLANKS       NETSL
050000210712     C                   ENDIF
050100210712     C                   ELSE
050200210712     C                   MOVE      *BLANKS       NETBY
050300210712     C                   MOVE      *BLANKS       NETSL
050400210712     C                   ENDIF
050500210712
050600210712      ** Initialise non-constant fields
050700210712
050800210712     C                   EXSR      SRINTF
050900210712
051000210712      ** Determine message routing
051100210712
051200210712     C                   EXSR      SRROUT
051300210712
051400210712      ** Format message detail - Sequence A
051500210712
051600210712     C                   EXSR      SRFMTA
051700210712
051800210712     C                   MOVE      'N'           SEQ15C            1                        MD033754
051900210712      ** Format message detail - Sequence B
052000210712
052100210712     C     MGPMBC        IFEQ      'Y'
052200210712     C                   EXSR      SRFMTB
052300210712     C                   ELSE
052400210712
052500210712      ** Format message detail - Sequence C
052600210712
052700210712     C                   EXSR      SRFMTC
052800210712     C                   ENDIF
052900210712                                                                                            MD022425
053000210712      ** Format message detail - Sequence D                                                 MD022425
053100210712                                                                                            MD022425
053200210712     C     CSW213        IFEQ      'Y'                                                      MD022425
053300210712     C                   MOVEL     MGTTYP        KDTYP             2                        MD024078
053400210712     C                   MOVEL     MGTNUM        KDLNO            16                        MD024078
053500210712     C     RPIFKY        CHAIN     DLRPIFL1                           20                    MD024078
053600210712     C     *IN20         IFEQ      '0'                                                      MD024078
053700210712     C                   EXSR      SRFMTD                                                   MD022425
053800210712     C                   ENDIF                                                              MD024078
053900210712     C                   ENDIF                                                              MD022425
054000210712
054100210712      ** Print incorrectly generated message
054200210712
054300210712     C     @ERR          IFEQ      'Y'
054400210712     C                   EXSR      SRREPT
054500210712     C                   ELSE
054600210712
054700210712     C/COPY WNCPYSRC,MG0600CCP5
054800210712
054900210712      ** Output correctly generated message
055000210712
055100210712     C                   EXSR      SROMSG
055200210712
055300210712      ** If confirmation matching switched on, generate feedback record
055400210712      ** (at present only produced for dealing)
055500210712
055600210712     C     BGCFMT        IFEQ      'Y'
055700210712     C     MGMODI        ANDEQ     'DL'
055800210712     C                   EXSR      CFMAT
055900210712     C                   ENDIF
056000210712
056100210712     C                   ENDIF
056200210712
056300210712      ** Delete the processed GDF record.
056400210712
056500210712     C                   DELETE    MGF600PD                             16
056600210712
056700210712      **  Error on delete of record.
056800210712
056900210712     C     *IN16         IFEQ      '1'
057000210712     C     *LOCK         IN        LDA
057100210712     C                   MOVE      '001'         DBASE
057200210712     C                   MOVEL     MGTNUM        DBKEY
057300210712     C                   MOVEL     'MGF600PD'    DBFILE
057400210712     C                   OUT       LDA
057500210712     C                   EXSR      *PSSR
057600210712     C                   ENDIF
057700210712
057800210712      **  Update sequence numbers on transaction record
057900210712      **  if no errors have occurred
058000210712
058100210712     C     @ERR          IFNE      'Y'
058200210712     C     MGACMI        IFEQ      'Y'                                                      MD022425
058300210712     C                   CALL      'MG5000'                             24                  MD022425
058400210712     C                   PARM      MGTTYP        @MODI             2                        MD022425
058500210712     C                   PARM      MGTNUM        @TRAN            15                        MD022425
058600210712     C                   PARM      'CE'          @PROG             2                        MD022425
058700210712     C                   PARM      'U'           @MODE             1                        MD022425
058800210712     C                   PARM      *ZEROS        MGLSWC            3 0                      MD022425
058900210712     C                   PARM      *ZEROS        MGLSWS            3 0                      MD022425
059000210712     C                   PARM      *BLANKS       @ERCD             1                        MD022425
059100210712     C                   ELSE                                                               MD022425
059200210712     C                   CALL      'MG5000'                             24
059300210712     C                   PARM      MGMODI        @MODI             2
059400210712     C                   PARM      MGTNUM        @TRAN            15
059500210712     C                   PARM      'CE'          @PROG             2
059600210712     C                   PARM      'U'           @MODE             1
059700210712     C                   PARM      *ZEROS        MGLSWC            3 0
059800210712     C                   PARM      *ZEROS        MGLSWS            3 0
059900210712     C                   PARM      *BLANKS       @ERCD             1
060000210712     C                   ENDIF                                                              MD022425
060100210712
060200210712      **  Error on access for sequence number
060300210712
060400210712     C     @ERCD         IFEQ      'Y'
060500210712     C     *LOCK         IN        LDA
060600210712     C                   OUT       LDA
060700210712     C                   EXSR      *PSSR
060800210712     C                   ENDIF
060900210712
061000210712      **  Program missing on call
061100210712
061200210712     C     *IN24         IFEQ      '1'
061300210712     C     *LOCK         IN        LDA
061400210712     C                   MOVE      '002'         DBASE
061500210712     C                   MOVE      'MG5000'      DBKEY
061600210712     C                   OUT       LDA
061700210712     C                   EXSR      *PSSR
061800210712     C                   ENDIF
061900210712
062000210712     C                   ENDIF
062100210712
062200210712     C     *LOCK         IN        LDA
062300210712     C                   MOVEL     'MG000600'    DBPGM
062400210712     C                   OUT       LDA
062500210712
062600210712     C/COPY WNCPYSRC,MG0600C023
062700210712
062800210712      ** COMIT all changes since no error on writing the message
062900210712
063000210712     C                   COMMIT
063100210712
063200210712      ** Read next MT600 extract record
063300210712
063400210712     C                   READ      MGF600PD                               10
063500210712
063600210712     C                   ENDDO
063700210712
063800210712      ** Write end of report, only if the printer file is open
063900210712
064000210712     C     *IN50         IFEQ      '1'
064100210712     C                   WRITE     EOREPT
064200210712     C                   ENDIF
064300210712
064400210712     C/COPY WNCPYSRC,MG0600C034
064500210712
064600210712     C                   SETON                                        LR
064700210712
064800210712      *****************************************************************
064900210712     C/EJECT
065000210712      *****************************************************************
065100210712      *                                                               *
065200210712      *   SRINIT - Inital process                                     *
065300210712      *                                                               *
065400210712      *****************************************************************
065500210712      *
065600210712     C     SRINIT        BEGSR
065700210712
065800210712     C                   MOVEA     CPY@          BIS@             80
065900210712
066000210712     C/COPY WNCPYSRC,MG0600C014
066100210712
066200210712      ** Set up LDA
066300210712
066400210712     C     *DTAARA       DEFINE                  LDA
066500210712     C     *LOCK         IN        LDA
066600210712     C                   MOVE      *BLANKS       DBFILE
066700210712     C                   MOVE      *BLANKS       DBKEY
066800210712     C                   MOVEL     'MG000600'    DBPGM
066900210712     C                   MOVE      *BLANKS       DBASE
067000210712     C                   OUT       LDA
067100210712
067200210712      ** Set up MPHAS data area
067300210712
067400210712     C     *DTAARA       DEFINE                  MPHAS
067500210712     C     *LOCK         IN        MPHAS
067600210712     C                   MOVE      STATUS        COB               1
067700210712     C                   OUT       MPHAS
067800210712
067900210712     C     HSKEY         KLIST
068000210712     C                   KFLD                    MGMODI
068100210712     C                   KFLD                    HSTRAN
068200210712     C                   KFLD                    HSDEST                                     MD022425
068300210712     C                   KFLD                    HSMTPY
068400210712
068500210712      ** Access SDBANKPD for report title
068600210712
068700210712     C                   CALL      'AOBANKR0'
068800210712     C                   PARM      '*MSG   '     @RTCD             7
068900210712     C                   PARM      '*FIRST '     @OPTN             7
069000210712     C     SDBANK        PARM      SDBANK        DSFDY
069100210712
069200210712     C     @RTCD         IFNE      *BLANKS
069300210712     C     *LOCK         IN        LDA
069400210712     C                   MOVE      '003'         DBASE
069500210712     C                   MOVEL     'FIRST'       DBKEY
069600210712     C                   MOVEL     'SDBANKPD'    DBFILE
069700210712     C                   OUT       LDA
069800210712     C                   EXSR      *PSSR
069900210712     C                   ENDIF
070000210712
070100210712      ** Access SDTRADPD for trading information
070200210712
070300210712     C                   CALL      'AOTRADR0'
070400210712     C                   PARM      '*MSG   '     @RTCD             7
070500210712     C                   PARM      '*FIRST '     @OPTN             7
070600210712     C     SDTRAD        PARM      SDTRAD        DSFDY
070700210712
070800210712     C     @RTCD         IFNE      *BLANKS
070900210712     C     *LOCK         IN        LDA
071000210712     C                   MOVE      '004'         DBASE
071100210712     C                   MOVEL     'FIRST'       DBKEY
071200210712     C                   MOVEL     'SDTRADPD'    DBFILE
071300210712     C                   OUT       LDA
071400210712     C                   EXSR      *PSSR
071500210712     C                   ENDIF
071600210712
071700210712      ** Access SDMMODPD for modules available
071800210712
071900210712     C                   CALL      'AOMMODR0'
072000210712     C                   PARM      '*MSG   '     @RTCD
072100210712     C                   PARM      '*FIRST '     @OPTN
072200210712     C     SDMMOD        PARM      SDMMOD        DSFDY
072300210712
072400210712     C     @RTCD         IFNE      *BLANKS
072500210712     C     *LOCK         IN        LDA
072600210712     C                   MOVE      '005'         DBASE
072700210712     C                   MOVEL     'FIRST'       DBKEY
072800210712     C                   MOVEL     'SDMMODPD'    DBFILE
072900210712     C                   OUT       LDA
073000210712     C                   EXSR      *PSSR
073100210712     C                   ENDIF
073200210712
073300210712      ** Access SDMGMEPD for message management data.
073400210712
073500210712     C                   CALL      'AOMGMER0'
073600210712     C                   PARM      '*MSG   '     @RTCD
073700210712     C                   PARM      '*FIRST '     @OPTN
073800210712     C     SDMGME        PARM      SDMGME        DSFDY
073900210712
074000210712     C     @RTCD         IFNE      *BLANKS
074100210712     C     *LOCK         IN        LDA
074200210712     C                   MOVE      '006'         DBASE
074300210712     C                   MOVEL     'FIRST'       DBKEY
074400210712     C                   MOVEL     'SDMGMEPD'    DBFILE
074500210712     C                   OUT       LDA
074600210712     C                   EXSR      *PSSR
074700210712     C                   ENDIF
074800210712
074900210712      ** Access Switchable Features file for
075000210712
075100210712     C                   CALL      'AOSARDR0'
075200210712     C                   PARM      *BLANKS       @RTCD
075300210712     C                   PARM      '*VERIFY'     @OPTN
075400210712     C                   PARM      'CSW012'      @SARD             6
075500210712     C     SCSARD        PARM      SCSARD        DSFDY
075600210712
075700210712     C     @RTCD         IFNE      *BLANKS
075800210712     C     @RTCD         ANDNE     '*NRF   '
075900210712     C     *LOCK         IN        LDA
076000210712     C                   MOVE      '007'         DBASE
076100210712     C                   MOVEL     @SARD         DBKEY
076200210712     C                   MOVEL     'SCSARDPD'    DBFILE
076300210712     C                   OUT       LDA
076400210712     C                   EXSR      *PSSR
076500210712     C                   ENDIF
076600210712
076700210712     C     @RTCD         IFEQ      *BLANKS
076800210712     C                   MOVEL     'Y'           CSW012            1
076900210712     C                   ELSE
077000210712     C                   MOVEL     'N'           CSW012
077100210712     C                   ENDIF
077200210712     C/COPY WNCPYSRC,MG0600C018
077300210712
077400210712      ** Access SAR Details file to determine if CDL002 installed
077500210712      *
077600210712     C                   CALL      'AOSARDR0'
077700210712     C                   PARM      '       '     @RTCD             7
077800210712     C                   PARM      '*VERIFY'     @OPTN             7
077900210712     C                   PARM      'CDL002'      @SARD             6
078000210712     C     SCSARD        PARM      SCSARD        DSFDY
078100210712     C     @RTCD         IFNE      *BLANK
078200210712     C     @RTCD         ANDNE     '*NRF   '
078300210712     C                   MOVEL     'SCSARDPD'    DBFILE
078400210712     C                   MOVEL     '023'         DBASE
078500210712     C                   MOVEL     @RTCD         DBKEY
078600210712     C                   SETON                                        U7U8
078700210712     C                   EXSR      *PSSR
078800210712     C                   ENDIF
078900210712     C     @RTCD         IFEQ      *BLANK
079000210712     C                   MOVE      'Y'           CDL002            1
079100210712     C**********         OPEN      DEALS                                                   AR1097200
079200210712     C                   OPEN      DEALALL                                                 AR1097200
079300210712     C                   MOVEL     'TO BE '      NETTXT           12
079400210712     C                   MOVE      'NETTED'      NETTXT
079500210712     C                   ENDIF
079600210712
079700210712      ** Check if Enhanced Receive Settlement Instructions feature                          MD057682
079800210712      ** is installed                                                                       MD057682
079900210712                                                                                            MD057682
080000210712     C                   MOVE      'N'           CDL094            1                        MD057682
080100210712     C                   CALL      'AOSARDR0'                                               MD057682
080200210712     C                   PARM      *BLANKS       @RTCD                                      MD057682
080300210712     C                   PARM      '*VERIFY'     @OPTN                                      MD057682
080400210712     C                   PARM      'CDL094'      @SARD                                      MD057682
080500210712     C     SCSARD        PARM      SCSARD        DSFDY                                      MD057682
080600210712                                                                                            MD057682
080700210712     C     @RTCD         IFEQ      *BLANKS                                                  MD057682
080800210712     C                   MOVE      'Y'           CDL094                                     MD057682
080900210712     C                   ENDIF                                                              MD057682
081000210712                                                                                            MD057682
081100210712      **  Initialise constant fields
081200210712
081300210712     C                   MOVE      *LOVAL        CR                1
081400210712     C                   BITON     '457'         CR
081500210712     C                   MOVE      *LOVAL        LF                1
081600210712     C                   BITON     '257'         LF
081700210712     C                   MOVEL     CR            CRLF              2
081800210712     C                   MOVE      LF            CRLF
081900210712     C                   MOVE      *BLANKS       @TR4
082000210712     C                   MOVE      ':'           COLON1
082100210712     C                   MOVE      ':'           COLON2
082200210712
082300210712      ** CRLF Control Character for message data records
082400210712
082500210712     C                   MOVE      CRLF          CTRC
082600210712
082700210712      ** Convert run date to YYMMDD, for Message Generation Date
082800210712
082900210712     C                   CALL      'ZM0060'                             15
083000210712     C                   PARM      BJRDNB        ZMDAY             5 0
083100210712     C                   PARM                    ZMDATE            6
083200210712
083300210712     C     *IN15         IFEQ      '1'
083400210712     C     *LOCK         IN        LDA
083500210712     C                   MOVE      '008'         DBASE
083600210712     C                   MOVEL     '       '     DBKEY
083700210712     C                   MOVEL     'ZM0060'      DBFILE
083800210712     C                   OUT       LDA
083900210712     C                   EXSR      *PSSR
084000210712     C                   ENDIF
084100210712     C                   MOVE      ZMDATE        MGDE
084200210712
084300210712      ** Set-up Message Generation Century flag
084400210712
084500210712     C                   MOVEL     MGDE          YY                2 0
084600210712     C     YY            IFLT      72
084700210712     C                   MOVE      '2'           CIND
084800210712     C                   ELSE
084900210712     C                   MOVE      '1'           CIND
085000210712     C                   ENDIF
085100210712
085200210712      ** Convert history retention date to YYMMDD
085300210712
085400210712     C     BJRDNB        ADD       ENDSMN        ZMDAY
085500210712     C                   CALL      'ZM0060'                             15
085600210712     C                   PARM                    ZMDAY
085700210712     C                   PARM                    ZMDATE            6
085800210712
085900210712     C     *IN15         IFEQ      '1'
086000210712     C     *LOCK         IN        LDA
086100210712     C                   MOVE      '009'         DBASE
086200210712     C                   MOVEL     '       '     DBKEY
086300210712     C                   MOVEL     'ZM0060'      DBFILE
086400210712     C                   OUT       LDA
086500210712     C                   EXSR      *PSSR
086600210712     C                   ENDIF
086700210712     C                   MOVE      ZMDATE        @HRDT             6
086800210712
086900210712      ** Check if SWIFT Changes 1996 (CSW096) is installed
087000210712
087100210712     C                   CALL      'SWIFT96'
087200210712     C                   PARM      *BLANKS       @RTCD             7
087300210712
087400210712     C     @RTCD         IFEQ      'CSW096'
087500210712     C                   MOVE      'Y'           CSW096            1
087600210712     C                   ELSE
087700210712     C                   MOVE      'N'           CSW096
087800210712     C                   ENDIF
087900210712
088000210712      ** Access Switchable Features file for CEU003
088100210712
088200210712     C                   CALL      'AOSARDR0'
088300210712     C                   PARM      *BLANKS       @RTCD
088400210712     C                   PARM      '*VERIFY'     @OPTN
088500210712     C                   PARM      'CEU003'      @SARD             6
088600210712     C     @RTCD         IFEQ      *BLANKS
088700210712     C                   MOVEL     'Y'           CEU003            1
088800210712     C                   ELSE
088900210712     C                   MOVEL     'N'           CEU003
089000210712     C                   ENDIF
089100210712
089200210712     C/COPY WNCPYSRC,MG0600AC24
089300210712
089400210712      ** Check if switchable feature CDL008 is switched on
089500210712
089600210712     C                   CALL      'AOSARDR0'
089700210712     C                   PARM      *BLANKS       @RTCD
089800210712     C                   PARM      '*VERIFY'     @OPTN
089900210712     C                   PARM      'CDL008'      @SARD
090000210712     C     SCSARD        PARM      SCSARD        DSFDY
090100210712
090200210712     C     @RTCD         IFNE      *BLANK
090300210712     C     @RTCD         ANDNE     '*NRF   '
090400210712     C     *LOCK         IN        LDA
090500210712     C                   MOVEL     'SCSARDPD'    DBFILE
090600210712     C                   MOVEL     'CDL008'      DBKEY
090700210712     C                   MOVEL     '026'         DBASE
090800210712     C                   OUT       LDA
090900210712     C                   EXSR      *PSSR
091000210712     C                   ENDIF
091100210712
091200210712     C     @RTCD         IFEQ      *BLANK
091300210712     C                   MOVE      'Y'           CDL008            1
091400210712     C                   ELSE
091500210712     C                   MOVE      'N'           CDL008
091600210712     C                   ENDIF
091700210712
091800210712      ** Check if switchable feature CSW024 is switched on
091900210712
092000210712     C                   CALL      'AOSARDR0'
092100210712     C                   PARM      *BLANKS       @RTCD
092200210712     C                   PARM      '*VERIFY'     @OPTN
092300210712     C                   PARM      'CSW024'      @SARD
092400210712     C     SCSARD        PARM      SCSARD        DSFDY
092500210712
092600210712     C     @RTCD         IFNE      *BLANK
092700210712     C     @RTCD         ANDNE     '*NRF   '
092800210712     C     *LOCK         IN        LDA
092900210712     C                   MOVEL     'SCSARDPD'    DBFILE
093000210712     C                   MOVEL     'CSW024'      DBKEY
093100210712     C                   MOVEL     '028'         DBASE
093200210712     C                   OUT       LDA
093300210712     C                   EXSR      *PSSR
093400210712     C                   ENDIF
093500210712
093600210712     C     @RTCD         IFEQ      *BLANK
093700210712     C                   MOVE      'Y'           CSW024            1
093800210712     C                   ELSE
093900210712     C                   MOVE      'N'           CSW024
094000210712     C                   ENDIF
094100210712
094200210712      ** Access Switchable features file to see if ConCord is switched
094300210712      ** ON.
094400210712
094500210712     C                   CALL      'AOSARDR0'
094600210712     C                   PARM      '       '     RTCDA             7
094700210712     C                   PARM      '*VERIFY'     RTCDB             7
094800210712     C                   PARM      'CCF001'      RTCDC             6
094900210712
095000210712     C     RTCDA         IFEQ      *BLANK
095100210712     C                   MOVE      *ON           *IN25
095200210712     C                   ENDIF
095300210712      *                                                                                     MD024078
095400210712      ** Setup Key Field for DLRPIFPD                                                       MD024078
095500210712      *                                                                                     MD024078
095600210712     C     RPIFKY        KLIST                                                              MD024078
095700210712     C                   KFLD                    KDTYP                                      MD024078
095800210712     C                   KFLD                    KDLNO                                      MD024078
095900210712      *                                                                                     MD024078
096000210712      ** Check if switchable feature CSW213 is switched on                                  MD024078
096100210712      *                                                                                     MD024078
096200210712     C                   CALL      'SWIF2013'                                               MD024078
096300210712     C                   PARM      *BLANKS       @RTCD                                      MD024078
096400210712      *                                                                                     MD024078
096500210712     C     @RTCD         IFEQ      'CSW2013'                                                MD024078
096600210712     C                   MOVE      'Y'           CSW213            1                        MD024078
096700210712     C                   OPEN      DLRPIFL1                                                 MD024078
096800210712     C                   ELSE                                                               MD024078
096900210712     C                   MOVE      'N'           CSW213                                     MD024078
097000210712     C                   ENDIF                                                              MD024078
097100210712                                                                                              CSW214
097200210712      ** Check if switchable feature CSW214 is switched on                                    CSW214
097300210712                                                                                              CSW214
097400210712     C                   CALL      'SWIF2014'                                                 CSW214
097500210712     C                   PARM      *BLANKS       PRTCD             7                          CSW214
097600210712                                                                                              CSW214
097700210712     C                   MOVEL     'N'           CSW214            1                          CSW214
097800210712     C                   IF        PRTCD = 'CSW2014'                                          CSW214
097900210712     C                   MOVEL     'Y'           CSW214                                       CSW214
098000210712     C                   ENDIF                                                                CSW214
098100210712                                                                                              CSW214
098200210712      *                                                                                     MD055694
098300210712      ** Check if switchable feature CSW221 is switched on                                  MD055694
098400210712      *                                                                                     MD055694
098500210712     C                   CALL      SWIFT                                                    MD055694
098600210712     C                   PARM      'CSW221'      PSWIFT            6                        MD055694
098700210712     C                   PARM      *BLANKS       PRTCD                                      MD055694
098800210712      *                                                                                     MD055694
098900210712     C                   IF        PRTCD = 'CSWACTV'                                        MD055694
099000210712     C                   MOVEL     'Y'           CSW221            1                        MD055694
099100210712     C                   MOVEL     '/NOSI/'      NOSTXU           10                        MD055694
099200210712     C                   MOVE      'UKWN'        NOSTXU                                     MD055694
099300210712     C                   MOVEL     '/NOSI/'      NOSTXN           10                        MD057682
099400210712     C                   MOVE      'NETS'        NOSTXN                                     MD057682
099500210712     C                   ELSE                                                               MD055694
099600210712     C                   MOVEL     'N'           CSW221                                     MD055694
099700210712     C                   ENDIF                                                              MD055694
099800210712                                                                                            MD055694
099900210712     C                   CALL      'AOSVALR0'                                               MD055694
100000210712     C                   PARM      *BLANKS       PRTCD                                      MD055694
100100210712     C                   PARM      AJFORM        P@OP01           20                        MD055694
100200210712     C                   PARM      *BLANKS       P@VL01          200                        MD055694
100300210712     C                   PARM      *BLANKS       P@OP02           20                        MD055694
100400210712     C                   PARM      *BLANKS       P@VL02          200                        MD055694
100500210712     C                   PARM      *BLANKS       P@OP03           20                        MD055694
100600210712     C                   PARM      *BLANKS       P@VL03          200                        MD055694
100700210712     C                   PARM      *BLANKS       P@OP04           20                        MD055694
100800210712     C                   PARM      *BLANKS       P@VL04          200                        MD055694
100900210712     C                   PARM      *BLANKS       P@OP05           20                        MD055694
101000210712     C                   PARM      *BLANKS       P@VL05          200                        MD055694
101100210712     C                   PARM      *BLANKS       P@OP06           20                        MD055694
101200210712     C                   PARM      *BLANKS       P@VL06          200                        MD055694
101300210712     C                   PARM      *BLANKS       P@OP07           20                        MD055694
101400210712     C                   PARM      *BLANKS       P@VL07          200                        MD055694
101500210712     C                   PARM      *BLANKS       P@OP08           20                        MD055694
101600210712     C                   PARM      *BLANKS       P@VL08          200                        MD055694
101700210712     C                   PARM      *BLANKS       P@OP09           20                        MD055694
101800210712     C                   PARM      *BLANKS       P@VL09          200                        MD055694
101900210712     C                   PARM      *BLANKS       P@OP10           20                        MD055694
102000210712     C                   PARM      *BLANKS       P@VL10          200                        MD055694
102100210712                                                                                            MD055694
102200210712     C                   MOVEL     ' '           WS                1                        MD055694
102300210712     C                   IF        PRTCD = *BLANKS                                          MD055694
102400210712     C                   EVAL      WS = P@VL01                                              MD055694
102500210712     C                   ENDIF                                                              MD055694
102600210712     C                   ENDSR
102700210712      *****************************************************************
102800210712     C/EJECT
102900210712      *****************************************************************
103000210712      *                                                               *
103100210712      *   SRINTF - Initalise non-constant fields                      *
103200210712      *                                                               *
103300210712      *****************************************************************
103400210712     C     SRINTF        BEGSR
103500210712
103600210712     C                   MOVE      *BLANKS       AWBA6             6
103700210712     C                   MOVEL     MGAWBA        AWBA6
103800210712
103900210712     C                   MOVE      *BLANKS       TRNO
104000210712     C                   MOVE      '      '      NWRK
104100210712     C**********         Z-ADD     0             SECN                                      AR1094963
104200210712     C                   MOVE      *BLANKS       SECN                                      AR1094963
104300210712     C                   MOVE      *BLANKS       NWSN
104400210712     C**********         Z-ADD     0             DECN                                      AR1094963
104500210712     C                   MOVE      *BLANKS       DECN                                      AR1094963
104600210712     C                   MOVE      *BLANKS       NWDS
104700210712     C                   MOVE      *BLANKS       MGSG
104800210712     C                   MOVE      *BLANKS       MGST
104900210712     C                   MOVE      *BLANKS       LSCC
105000210712     C                   MOVE      *BLANKS       F57U
105100210712     C                   Z-ADD     0             MGTM
105200210712     C                   Z-ADD     0             LATM
105300210712     C                   MOVE      *BLANKS       RELD
105400210712     C                   Z-ADD     0             RELT
105500210712     C                   MOVE      *BLANKS       AMTS
105600210712     C                   MOVE      *BLANKS       SVDT
105700210712     C                   MOVE      *BLANKS       CINDV
105800210712     C                   MOVE      *BLANKS       CLSS
105900210712
106000210712     C                   MOVE      *BLANKS       @TRN
106100210712     C                   MOVE      *BLANKS       @ERR              1
106200210712     C                   MOVE      *BLANKS       STELX            10
106300210712     C                   MOVE      *BLANKS       SSTTX            12
106400210712     C                   MOVE      *BLANKS       SCRNM            20
106500210712     C                   MOVE      *BLANKS       SPCNB             6
106600210712     C                   MOVE      *BLANKS       SPAIN             1
106700210712      *                                                                                     MD024078
106800210712     C                   MOVE      *BLANKS       WRKMRJ                                     MD024078
106900210712     C                   MOVE      *BLANKS       WRKMRP                                     MD024078
107000210712     C                   MOVE      *BLANKS       WRKMRN                                     MD024078
107100210712     C                   MOVE      *BLANKS       WRKMRC                                     MD024078
107200210712     C                   MOVE      *BLANKS       WRKMRS                                     MD024078
107300210712     C                   MOVE      *BLANKS       WRKMRL                                     MD024078
107400210712     C                   MOVE      *BLANKS       WRKMRA                                     MD024078
107500210712
107600210712     C/COPY WNCPYSRC,MG0600C025
107700210712
107800210712      ** Initialise field to indicate that the current position
107900210712      ** for outputting field :72:, is at line 1
108000210712
108100210712     C                   MOVE      'N'           LINE2             1
108200210712
108300210712      ** Clear multiple occurrence data structure
108400210712
108500210712     C                   Z-ADD     1             X                 2 0
108600210712     C     X             OCCUR     MULT
108700210712
108800210712     C     X             DOWLE     95
108900210712     C     MULT          ANDNE     *BLANKS
109000210712     C                   MOVE      *BLANKS       MULT
109100210712     C                   ADD       1             X
109200210712     C     X             OCCUR     MULT
109300210712     C                   ENDDO
109400210712
109500210712      ** Clear multiple occurrence DS for the extension file.
109600210712
109700210712     C                   Z-ADD     1             V                 2 0
109800210712     C     V             OCCUR     EXTN
109900210712     C     V             DOWLE     20
110000210712     C     MCSI          ANDNE     *BLANKS
110100210712     C                   Z-ADD     *ZEROS        MPSN
110200210712     C                   MOVE      *BLANKS       MTG
110300210712     C                   MOVE      *BLANKS       MCSI
110400210712     C                   ADD       1             V
110500210712     C     V             OCCUR     EXTN
110600210712     C                   ENDDO
110700210712     C                   Z-ADD     0             V
110800210712
110900210712      ** Check if switchable feature CSW213 is switched on                                  MD022425
111000210712                                                                                            MD022425
111100210712     C**********         CALL      'SWIF2013'                                      MD022425 MD024078
111200210712     C**********         PARM      *BLANKS       @RTCD                             MD022425 MD024078
111300210712     C*****@RTCD         IFEQ      'CSW2013'                                       MD022425 MD024078
111400210712     C**********         MOVE      'Y'           CSW213            1               MD022425 MD024078
111500210712     C**********         ELSE                                                      MD022425 MD024078
111600210712     C**********         MOVE      'N'           CSW213                            MD022425 MD024078
111700210712     C**********         ENDIF                                                     MD022425 MD024078
111800210712      **********                                                                   MD022425 MD024078
111900210712      ** Obtain sequence numbers from transaction record
112000210712
112100210712     C     MGACMI        IFEQ      'Y'                                                      MD022425
112200210712     C                   CALL      'MG5000'                             24                  MD022425
112300210712     C                   PARM      MGTTYP        @MODI             2                        MD022425
112400210712     C                   PARM      MGTNUM        @TRAN            15                        MD022425
112500210712     C                   PARM      'CE'          @PROG             2                        MD022425
112600210712     C                   PARM      *BLANKS       @MODE             1                        MD022425
112700210712     C                   PARM      *ZEROS        MGLSWC            3 0                      MD022425
112800210712     C                   PARM      *ZEROS        MGLSWS            3 0                      MD022425
112900210712     C                   PARM      *BLANKS       @ERCD             1                        MD022425
113000210712     C                   ELSE                                                               MD022425
113100210712     C                   CALL      'MG5000'                             24
113200210712     C                   PARM      MGMODI        @MODI             2
113300210712     C                   PARM      MGTNUM        @TRAN            15
113400210712     C                   PARM      'CE'          @PROG             2
113500210712     C                   PARM      *BLANKS       @MODE             1
113600210712     C                   PARM      *ZEROS        MGLSWC            3 0
113700210712     C                   PARM      *ZEROS        MGLSWS            3 0
113800210712     C                   PARM      *BLANKS       @ERCD             1
113900210712     C                   ENDIF                                                              MD022425
114000210712
114100210712      ** Error on access for sequence number
114200210712
114300210712     C     @ERCD         IFEQ      'Y'
114400210712     C     *LOCK         IN        LDA
114500210712     C                   OUT       LDA
114600210712     C                   EXSR      *PSSR
114700210712     C                   ENDIF
114800210712
114900210712      ** Program missing on call
115000210712
115100210712     C     *IN24         IFEQ      '1'
115200210712     C     *LOCK         IN        LDA
115300210712     C                   MOVE      '010'         DBASE
115400210712     C                   MOVE      'MG5000'      DBKEY
115500210712     C                   OUT       LDA
115600210712     C                   EXSR      *PSSR
115700210712     C                   ENDIF
115800210712     C     *LOCK         IN        LDA
115900210712     C                   MOVEL     'MG000600'    DBPGM
116000210712     C                   OUT       LDA
116100210712
116200210712      **  To ensure field 53 if generated when required
116300210712
116400210712     C                   SETOFF                                       55
116500210712
116600210712     C                   ENDSR
116700210712     C/EJECT                                                                                MD024078
116800210712      *****************************************************************                     MD024078
116900210712      *                                                               *                     MD024078
117000210712      *  GETRCL- Get record length                                    *                     MD024078
117100210712      *                                                               *                     MD024078
117200210712      *****************************************************************                     MD024078
117300210712      *                                                                                     MD024078
117400210712     C     GETRCL        BEGSR                                                              MD024078
117500210712      *                                                                                     MD024078
117600210712     C                   CALL      'UTGETRCDLN'                                             MD024078
117700210712     C                   PARM                    P#RTCD           10                        MD024078
117800210712     C                   PARM                    P#RCDL            5 0                      MD024078
117900210712     C                   PARM                    P#FILN           10                        MD024078
118000210712     C                   PARM      '*LIBL'       P#LIBN           10                        MD024078
118100210712      *                                                                                     MD024078
118200210712     C     P#RTCD        IFNE      *BLANK                                                   MD024078
118300210712     C                   EXSR      *PSSR                                                    MD024078
118400210712     C                   ENDIF                                                              MD024078
118500210712      *                                                                                     MD024078
118600210712     C                   ENDSR                                                              MD024078
118700210712      *****************************************************************
118800210712     C/EJECT
118900210712      *****************************************************************
119000210712      *                                                               *
119100210712      *   SRROUT - determine message routing                          *
119200210712      *                                                               *
119300210712      *****************************************************************
119400210712     C     SRROUT        BEGSR
119500210712
119600210712     C                   MOVE      MGBRCA        I@SNBR
119700210712     C                   MOVE      *BLANKS       I@DSCN
119800210712     C                   MOVE      MGCNUM        I@DSCN
119900210712     C                   MOVE      '600'         I@MTPY
120000210712     C                   MOVE      'Y'           I@CONC
120100210712     C                   Z-ADD     0             I@SETT
120200210712     C                   MOVE      *BLANK        I@FTCS
120300210712     C                   MOVE      MGMODI        I@MMOD
120400210712
120500210712      ** Below are two copy sources intended for setting up the custom
120600210712      ** parameter (P@ZZ) in the call to MG9900.
120700210712      ** One (MG9900CALL) is in ALL MG generation programs and is for use
120800210712      ** when a change is required to all of them.
120900210712      ** The other is only in this program.
121000210712
121100210712     C/COPY WNCPYSRC,MG9900CALL
121200210712     C/COPY WNCPYSRC,MG0600ROUT
121300210712
121400210712     C                   CALL      'MG9900'
121500210712     C                   PARM      *BLANKS       @RTCD
121600210712     C                   PARM                    P@IN
121700210712     C                   PARM      *BLANKS       P@OUT
121800210712     C                   PARM                    P@ZZ            256
121900210712
122000210712     C     @RTCD         IFNE      *BLANKS
122100210712     C     *LOCK         IN        LDA
122200210712     C                   MOVE      '011'         DBASE
122300210712     C                   MOVEL     '*CALL  '     DBKEY
122400210712     C                   MOVEL     'MG9900'      DBFILE
122500210712     C                   OUT       LDA
122600210712     C                   EXSR      *PSSR
122700210712     C                   ELSE
122800210712     C                   MOVE      O@NWRK        NWRK
122900210712     C**********         Z-ADD     O@CNSN        SECN                                      AR1094963
123000210712     C                   MOVEL     O@CNSN        SECN                                      AR1094963
123100210712     C                   MOVE      O@NWSN        NWSN
123200210712     C**********         Z-ADD     MGCNUM        DECN                                      AR1094963
123300210712     C                   MOVEL     MGCNUM        DECN                                      AR1094963
123400210712     C                   MOVE      O@NWDS        NWDS
123500210712     C                   MOVE      O@MGSG        MGSG
123600210712     C                   MOVE      O@MGST        MGST
123700210712     C                   MOVE      O@PCNB        SPCNB
123800210712     C                   MOVE      O@PAIN        SPAIN
123900210712     C                   ENDIF
124000210712
124100210712     C/COPY WNCPYSRC,MG0600C026
124200210712
124300210712     C                   MOVEL     *BLANKS       @KEY1
124400210712     C     MGACMI        IFEQ      'Y'                                                      MD022425
124500210712     C                   MOVEL     MGPTYA        @KEY1                                      MD022425
124600210712     C                   ELSE                                                               MD022425
124700210712     C                   MOVEL     MGCNUM        @KEY1
124800210712     C                   ENDIF                                                              MD022425
124900210712     C                   CALL      'AOCUSTR1'
125000210712     C                   PARM      '*MSG   '     @RTCD
125100210712     C                   PARM      '*KEY   '     @OPTN
125200210712     C                   PARM                    @KEY1
125300210712     C                   PARM      *BLANKS       @KYST
125400210712     C     SDCUST        PARM      SDCUST        DSLDY
125500210712
125600210712     C     @RTCD         IFNE      *BLANKS
125700210712     C     *LOCK         IN        LDA
125800210712     C                   MOVEL     'AOCUSTR0'    DBFILE
125900210712     C                   MOVE      '029'         DBASE
126000210712     C                   MOVEL     MGCNUM        DBKEY
126100210712     C                   OUT       LDA
126200210712     C                   EXSR      *PSSR
126300210712     C                   ELSE
126400210712     C                   MOVE      BBCNA1        DSCNA1           35
126500210712     C                   MOVE      BBCNA2        DSCNA2           35
126600210712     C                   MOVE      BBCNA3        DSCNA3           35
126700210712     C                   MOVE      BBCNA4        DSCNA4           35
126800210712     C                   MOVE      BBCORP        DSCORP            1
126900210712     C                   MOVE      BBCBEI        DSCBEI           11
127000210712     C                   MOVE      BBRI01        DSRI01           40
127100210712     C                   MOVE      BBRI02        DSRI02           40
127200210712     C                   MOVE      BBRI03        DSRI03           40
127300210712     C                   MOVE      BBRI04        DSRI04           40
127400210712     C                   MOVE      BBRI05        DSRI05           40
127500210712     C                   MOVE      BBFUND        DSFUND           34
127600210712     C                   ENDIF
127700210712
127800210712     C                   ENDSR
127900210712      *****************************************************************
128000210712     C/EJECT
128100210712      *****************************************************************
128200210712      *                                                               *
128300210712      *   SRFMTA - Format message detail - Sequence A                 *
128400210712      *                                                               *
128500210712      *****************************************************************
128600210712     C     SRFMTA        BEGSR
128700210712     C                   MOVEL     *BLANKS       MGUNIT            3
128800210712     C                   MOVEL     *BLANKS       MGDENO            4
128900210712     C                   MOVEL     *BLANKS       MGFORM            8
129000210712     C                   MOVEL     *BLANKS       MGDELV            3
129100210712     C                   MOVEL     *BLANKS       MGALOC            5
129200210712     C                   MOVEL     *BLANKS       MGCREF           29
129300210712     C                   MOVEL     *BLANKS       MGCMSH           10
129400210712     C                   MOVEL     *BLANKS       MGCMUD           30
129500210712     C                   MOVEL     *BLANKS       W87SEQA           1                        MD055694
129600210712
129700210712     C                   Z-ADD     *ZERO         X
129800210712
129900210712      ** Field :15A: General Information
130000210712
130100210712     C                   ADD       1             X
130200210712     C     X             OCCUR     MULT
130300210712     C                   MOVE      ':15A:'       MTAG
130400210712     C                   MOVEL     *BLANK        MFLD
130500210712
130600210712      ** Field :20:  Transaction reference number
130700210712
130800210712     C                   ADD       1             X
130900210712     C     X             OCCUR     MULT
131000210712                                                                                            MD022425
131100210712     C     MGACMI        IFEQ      'Y'                                                      MD022425
131200210712     C                   MOVE      MGMODI        @TRN11                                     MD022425
131300210712     C                   MOVEL     MGTNUM        @TRN21                                     MD022425
131400210712     C                   MOVEL     MGCNUM        @TRN31                                     MD022425
131500210712     C     MGLSWS        ADD       1             @TRN41                                     MD022425
131600210712     C                   MOVE      ':20: '       MTAG                                       MD022425
131700210712     C                   MOVEL     @TRN1         MFLD                                       MD022425
131800210712                                                                                            MD022425
131900210712      ** Store the TRN of the new confirmation message                                      MD022425
132000210712                                                                                            MD022425
132100210712     C                   MOVEL     @TRN1         @TRNO            16                        MD022425
132200210712                                                                                            MD022425
132300210712     C                   ELSE                                                               MD022425
132400210712     C                   MOVE      MGMODI        @TR1
132500210712     C                   MOVEL     MGTNUM        @TR2
132600210712     C     MGLSWS        ADD       1             @TR3
132700210712
132800210712     C/COPY WNCPYSRC,MG0600C027
132900210712
133000210712     C                   MOVE      ':20: '       MTAG
133100210712     C                   MOVEL     @TRN          MFLD
133200210712
133300210712      ** Store the TRN of the new confirmation message
133400210712
133500210712     C                   MOVEL     @TRN          @TRNO            16
133600210712     C                   ENDIF                                                              MD022425
133700210712
133800210712      ** Determine if the TRN is unique
133900210712
134000210712     C     @TRNO         CHAIN     MGREFL0                            11
134100210712
134200210712      ** Cannot have duplicate keys, hence error
134300210712
134400210712     C     *IN11         IFEQ      '0'
134500210712     C                   MOVEL     MSGA(8)       MERR
134600210712     C                   MOVE      'Y'           @ERR
134700210712     C                   ENDIF
134800210712
134900210712      ** Field :21:  Related reference
135000210712      ** Determine the message codeword
135100210712
135200210712     C                   EXSR      SRCODE
135300210712
135400210712     C/COPY WNCPYSRC,MG0600AC28
135500210712
135600210712     C                   ADD       1             X
135700210712     C     X             OCCUR     MULT
135800210712
135900210712     C     CWRD          IFNE      'NEW'
136000210712     C                   MOVE      MGLSWC        @TR3
136100210712     C                   MOVEL     @TRN          MFLD
136200210712
136300210712     C     MGACMI        IFEQ      'Y'                                                      MD022425
136400210712     C                   MOVEL     MGCNUM        WDEST             6                        MD022425
136500210712     C                   MOVEL     @TRN1         MFLD                                       MD024078
136600210712     C                   ELSE                                                               MD022425
136700210712     C                   MOVEL     *BLANKS       WDEST                                      MD022425
136800210712     C                   ENDIF                                                              MD022425
136900210712                                                                                            MD022425
137000210712      ** Obtain transaction reference of previous MT600
137100210712
137200210712     C                   MOVEL     MGTNUM        HSTRAN
137300210712     C                   MOVE      '600'         HSMTPY
137400210712
137500210712     C                   MOVE      HSTRAN        @HTRN             6
137600210712
137700210712     C*****HSKEY         SETGT     MGHISTL0                                                 MD022425
137800210712     C**********         READP     MGHISTL0                               56                MD022425
137900210712     C     HSKEY         SETGT     MGHISTL7                                                 MD022425
138000210712     C                   READP     MGHISTL7                               56                MD022425
138100210712
138200210712     C     *IN56         IFEQ      '0'
138300210712     C     HSMODI        ANDEQ     MGMODI
138400210712     C     HSTRAN        ANDEQ     @HTRN
138500210712     C     HSDEST        ANDEQ     WDEST                                                    MD022425
138600210712     C     HSMTPY        ANDEQ     '600'
138700210712     C     MGACMI        IFEQ      'Y'                                                      MD022425
138800210712     C**********         MOVE      HSSEQ         @SSEQ                             MD022425 MD024078
138900210712     C**********         MOVEL     @HREF1        MFLD                              MD022425 MD024078
139000210712     C                   MOVEL     HSMODI        @TRN11                                     MD024078
139100210712     C                   MOVEL     HSTRAN        @TRN21                                     MD024078
139200210712     C                   MOVEL     @TRN1         MFLD                                       MD024078
139300210712     C                   ELSE                                                               MD022425
139400210712     C                   MOVEL     @HREF         MFLD
139500210712     C                   ENDIF                                                              MD022425
139600210712     C                   END
139700210712
139800210712     C                   MOVE      ':21: '       MTAG
139900210712     C                   ELSE
140000210712     C                   MOVEL     'NEW'         MFLD
140100210712     C                   MOVE      ':21: '       MTAG
140200210712
140300210712     C                   ENDIF
140400210712
140500210712     C/COPY WNCPYSRC,MG0600C029
140600210712
140700210712      ** Field :22: Code/Common Reference
140800210712
140900210712     C                   ADD       1             X
141000210712     C     X             OCCUR     MULT
141100210712
141200210712     C                   MOVE      *BLANKS       W22                                        MD024068
141300210712      *                                                                                     MD024068
141400210712     C                   SELECT
141500210712     C     MGCHTP        WHENEQ    'C'
141600210712     C                   MOVEL     'CANCEL'      W22              25
141700210712     C     CWRD          WHENEQ    'AMEND'
141800210712     C                   MOVEL     'COMPLETE'    W22
141900210712     C     MGTTYP        WHENEQ    'OT'
142000210712     C                   MOVEL     'EXOPTION'    W22
142100210712     C     CWRD          WHENEQ    'NEW'
142200210712     C                   MOVEL     'NEW'         W22
142300210712     C                   ENDSL
142400210712
142500210712     C     MGTTYP        IFEQ      'OP'
142600210712     C     COB           ANDEQ     'C'
142700210712     C                   MOVEL     'EXOPTION'    W22
142800210712     C                   ENDIF
142900210712
143000210712      ** Codeword blank
143100210712
143200210712     C     CWRD          IFEQ      *BLANKS
143300210712     C                   MOVE      'Y'           @ERR
143400210712     C                   MOVEA     MSGA(7)       MERR
143500210712     C                   ENDIF
143600210712
143700210712     C                   MOVEL     ':22:'        MTAG
143800210712
143900210712     C/COPY WNCPYSRC,MG0600C049
144000210712
144100210712     C                   MOVE      *BLANKS       ZCREF
144200210712
144300210712      ** If SWIFT network, use sender & destination customer
144400210712      ** SWIFT address, and the exchange rate to produce
144500210712      ** common reference field;  Else use the message TRN
144600210712
144700210712     C     NWRK          IFEQ      'SWIFT'
144800210712     C     NWRK          OREQ      'STTX'
144900210712
145000210712     C     NWRK          IFEQ      'SWIFT'
145100210712     C                   MOVEL     NWSN          ZSSWI
145200210712     C                   MOVEL     NWDS          ZDSWI
145300210712     C                   ENDIF
145400210712     C/COPY WNCPYSRC,MG0600C040
145500210712     C                   MOVE      MGEXRT        ZRATE
145600210712
145700210712      **  Format SWIFT common reference
145800210712
145900210712     C                   CALL      'ZM0020'                             15
146000210712     C                   PARM                    ZSSWI            12
146100210712     C                   PARM                    ZDSWI            12
146200210712     C                   PARM                    ZRATE            13 8
146300210712     C                   PARM                    ZCREF            16
146400210712
146500210712     C     *IN15         IFEQ      '1'
146600210712     C     *LOCK         IN        LDA
146700210712     C                   MOVE      '012'         DBASE
146800210712     C                   MOVEL     '       '     DBKEY
146900210712     C                   MOVEL     'ZM0020'      DBFILE
147000210712     C                   OUT       LDA
147100210712     C                   EXSR      *PSSR
147200210712     C                   ENDIF
147300210712
147400210712     C                   ENDIF
147500210712
147600210712     C     O@SWSN        IFNE      *BLANKS
147700210712     C     O@SWDS        ANDNE     *BLANKS
147800210712
147900210712     C                   MOVE      MGEXRT        ZRATE
148000210712     C                   MOVEL     O@SWSN        ZSSWI
148100210712     C                   MOVEL     O@SWDS        ZDSWI
148200210712
148300210712      **  Format SWIFT common reference
148400210712
148500210712     C                   CALL      'ZM0020'                             15
148600210712     C                   PARM                    ZSSWI            12
148700210712     C                   PARM                    ZDSWI            12
148800210712     C                   PARM                    ZRATE            13 8
148900210712     C                   PARM                    ZCREF            16
149000210712
149100210712     C     *IN15         IFEQ      '1'
149200210712     C     *LOCK         IN        LDA
149300210712     C                   MOVE      '013'         DBASE
149400210712     C                   MOVE      '      '      DBKEY
149500210712     C                   MOVEL     'ZM0020'      DBFILE
149600210712     C                   OUT       LDA
149700210712     C                   EXSR      *PSSR
149800210712     C                   ENDIF
149900210712
150000210712     C/COPY WNCPYSRC,MG0600C041
150100210712
150200210712     C                   ENDIF
150300210712
150400210712     C     W22           CAT       '/':0         W22
150500210712     C     ZCREF         IFNE      *BLANKS
150600210712     C     W22           CAT       ZCREF:0       MFLD
150700210712     C                   ELSE
150800210712     C     W22           CAT       @TRNO:0       MFLD
150900210712     C                   ENDIF
151000210712
151100210712      ** Field :94A: Scope of Operation
151200210712
151300210712     C     CSW024        IFEQ      'Y'
151400210712     C     DSCORP        ANDEQ     'Y'
151500210712     C                   ADD       1             X
151600210712     C     X             OCCUR     MULT
151700210712     C                   MOVE      *BLANK        MFLD
151800210712     C                   MOVEL     'AGNT'        MFLD
151900210712     C                   MOVE      ':94A:'       MTAG
152000210712     C                   ELSE
152100210712     C                   ADD       1             X
152200210712     C     X             OCCUR     MULT
152300210712     C                   MOVE      *BLANK        MFLD
152400210712     C                   MOVEL     'BILA'        MFLD
152500210712     C                   MOVE      ':94A:'       MTAG
152600210712     C                   ENDIF
152700210712
152800210712      ** Field :82a: Party A
152900210712
153000210712     C                   ADD       1             X
153100210712     C     X             OCCUR     MULT
153200210712
153300210712     C                   CALL      'AOBRCHR0'
153400210712     C                   PARM      '*MSG   '     @RTCD
153500210712     C                   PARM      '*KEY   '     @OPTN
153600210712     C                   PARM      MGBRCA        @BRCD             3
153700210712     C     SDBRCH        PARM      SDBRCH        DSSDY
153800210712
153900210712      ** Branch record not found - DB Error
154000210712
154100210712     C     @RTCD         IFNE      *BLANKS
154200210712     C     *LOCK         IN        LDA
154300210712     C                   MOVE      '014'         DBASE
154400210712     C                   MOVEL     MGBRCA        DBKEY
154500210712     C                   MOVEL     'SDBRCHPD'    DBFILE
154600210712     C                   OUT       LDA
154700210712     C                   EXSR      *PSSR
154800210712     C                   ENDIF
154900210712
155000210712     C**********         MOVE      *BLANKS       WBICN             6 0                      MD035515
155100210712     C                   MOVE      *BLANKS       WBICN             6                        MD035515
155200210712     C                   MOVEL     A8BICN        WBICN
155300210712
155400210712     C                   MOVE      *BLANKS       ZDEST
155500210712     C                   MOVEL     WBICN         ZDEST
155600210712     C                   MOVE      *BLANKS       ACLINE
155700210712     C                   MOVE      ' '           TAG
155800210712     C                   MOVE      '82'          FLDNO
155900210712     C                   EXSR      FSWAD
156000210712
156100210712      ** If corporate customer...
156200210712
156300210712     C     CSW024        IFEQ      'Y'
156400210712     C     DSCORP        ANDEQ     'Y'
156500210712
156600210712      ** If BEI output :87A:
156700210712
156800210712     C     DSCBEI        IFNE      *BLANK
156900210712     C                   ADD       1             X
157000210712     C     X             OCCUR     MULT
157100210712     C                   MOVE      *BLANK        MFLD
157200210712     C                   MOVEL     DSCBEI        MFLD
157300210712     C                   MOVE      ':87A:'       MTAG
157400210712
157500210712      ** If receiver party info output :87J:
157600210712
157700210712     C                   ELSE
157800210712                                                                                            MD055694
157900210712     C                   IF        CSW221 = 'Y'                                             MD055694
158000210712     C                   MOVEA     D87CDE        AR8XJ                                      MD055694
158100210712     C                   EXSR      SWF8XJ                                                   MD055694
158200210712     C                   MOVEA     AN8X          D87CDE                                     MD055694
158300210712     C                   ENDIF                                                              MD055694
158400210712                                                                                            MD055694
158500210712     C*****DSRI01        IFNE      *BLANK                                                   MD055694
158600210712     C*****DSRI02        ORNE      *BLANK                                                   MD055694
158700210712     C*****DSRI03        ORNE      *BLANK                                                   MD055694
158800210712     C*****DSRI04        ORNE      *BLANK                                                   MD055694
158900210712     C*****DSRI05        ORNE      *BLANK                                                   MD055694
159000210712     C     D87CDE        IFNE      *BLANKS                                                  MD055694
159100210712     C     CSW221        ANDEQ     'N'                                                      MD055694
159200210712     C     D87CDE        ORNE      *BLANKS                                                  MD055694
159300210712     C     CSW221        ANDEQ     'Y'                                                      MD055694
159400210712     C     WOUT8X        ANDEQ     'Y'                                                      MD055694
159500210712
159600210712     C                   MOVE      *BLANK        DN87              1
159700210712     C     DSRI01        IFNE      *BLANK
159800210712     C                   ADD       1             X
159900210712     C     X             OCCUR     MULT
160000210712     C     DN87          IFNE      'Y'
160100210712     C                   MOVE      ':87J:'       MTAG
160200210712     C                   MOVE      'Y'           DN87
160300210712     C                   ENDIF
160400210712     C                   MOVE      *BLANK        MFLD
160500210712     C                   MOVEL     DSRI01        MFLD
160600210712     C                   ENDIF
160700210712     C     DSRI02        IFNE      *BLANK
160800210712     C                   ADD       1             X
160900210712     C     X             OCCUR     MULT
161000210712     C     DN87          IFNE      'Y'
161100210712     C                   MOVE      ':87J:'       MTAG
161200210712     C                   MOVE      'Y'           DN87
161300210712     C                   ENDIF
161400210712     C                   MOVE      *BLANK        MFLD
161500210712     C                   MOVEL     DSRI02        MFLD
161600210712     C                   ENDIF
161700210712     C     DSRI03        IFNE      *BLANK
161800210712     C                   ADD       1             X
161900210712     C     X             OCCUR     MULT
162000210712     C     DN87          IFNE      'Y'
162100210712     C                   MOVE      ':87J:'       MTAG
162200210712     C                   MOVE      'Y'           DN87
162300210712     C                   ENDIF
162400210712     C                   MOVE      *BLANK        MFLD
162500210712     C                   MOVEL     DSRI03        MFLD
162600210712     C                   ENDIF
162700210712     C     DSRI04        IFNE      *BLANK
162800210712     C                   ADD       1             X
162900210712     C     X             OCCUR     MULT
163000210712     C     DN87          IFNE      'Y'
163100210712     C                   MOVE      ':87J:'       MTAG
163200210712     C                   MOVE      'Y'           DN87
163300210712     C                   ENDIF
163400210712     C                   MOVE      *BLANK        MFLD
163500210712     C                   MOVEL     DSRI04        MFLD
163600210712     C                   ENDIF
163700210712     C     DSRI05        IFNE      *BLANK
163800210712     C                   ADD       1             X
163900210712     C     X             OCCUR     MULT
164000210712     C     DN87          IFNE      'Y'
164100210712     C                   MOVE      ':87J:'       MTAG
164200210712     C                   MOVE      'Y'           DN87
164300210712     C                   ENDIF
164400210712     C                   MOVE      *BLANK        MFLD
164500210712     C                   MOVEL     DSRI05        MFLD
164600210712     C                   ENDIF
164700210712
164800210712      ** Else output :87D:
164900210712
165000210712     C                   ELSE
165100210712      *                                                                                     MD055694
165200210712      ** If CSW221 is ON, process format J instead of D                                     MD055694
165300210712     C                   IF        CSW221 = 'Y'                                             MD055694
165400210712     C                   ADD       1             X                                          MD055694
165500210712     C     X             OCCUR     MULT                                                     MD055694
165600210712     C                   MOVEL     MGCNUM        ZDEST                                      MD055694
165700210712     C                   MOVE      *BLANKS       ACLINE                                     MD055694
165800210712     C                   MOVE      ' '           TAG                                        MD055694
165900210712     C                   MOVE      '87'          FLDNO                                      MD055694
166000210712     C                   EXSR      SRFMTJ                                                   MD055694
166100210712                                                                                            MD055694
166200210712     C                   ELSE                                                               MD055694
166300210712                                                                                            MD055694
166400210712     C                   ADD       1             X
166500210712     C     X             OCCUR     MULT
166600210712     C                   MOVE      ':87D:'       MTAG
166700210712     C                   MOVEL     DSCNA1        MFLD
166800210712
166900210712      ** Address 2
167000210712
167100210712     C     DSCNA2        IFNE      *BLANKS
167200210712     C                   ADD       1             X
167300210712     C     X             OCCUR     MULT
167400210712     C                   MOVEL     DSCNA2        MFLD
167500210712     C                   ENDIF
167600210712
167700210712      ** Address 3
167800210712
167900210712     C     DSCNA3        IFNE      *BLANKS
168000210712     C                   ADD       1             X
168100210712     C     X             OCCUR     MULT
168200210712     C                   MOVEL     DSCNA3        MFLD
168300210712     C                   ENDIF
168400210712
168500210712      ** Address 4
168600210712
168700210712     C     DSCNA4        IFNE      *BLANKS
168800210712     C                   ADD       1             X
168900210712     C     X             OCCUR     MULT
169000210712     C                   MOVEL     DSCNA4        MFLD
169100210712     C                   ENDIF
169200210712
169300210712     C                   ENDIF                                                              MD055694
169400210712     C                   ENDIF
169500210712     C                   ENDIF
169600210712
169700210712     C                   ELSE
169800210712
169900210712      ** Field :87a: Party B
170000210712
170100210712     C                   ADD       1             X
170200210712     C     X             OCCUR     MULT
170300210712
170400210712     C                   MOVE      *BLANKS       ZDEST
170500210712     C                   MOVEL     MGCNUM        ZDEST
170600210712     C                   MOVE      *BLANKS       ACLINE
170700210712     C                   MOVE      ' '           TAG
170800210712     C                   MOVE      '87'          FLDNO
170900210712     C                   IF        CSW221 = 'Y'                                             MD055694
171000210712     C                   MOVEL     'Y'           W87SEQA                                    MD055694
171100210712     C                   ENDIF                                                              MD055694
171200210712     C                   EXSR      FSWAD
171300210712     C                   MOVEL     *BLANKS       W87SEQA                                    MD055694
171400210712
171500210712     C                   ENDIF
171600210712
171700210712      ** Format Field :83a
171800210712
171900210712     C/COPY WNCPYSRC,MG0600C044
172000210712
172100210712     C                   EXSR      FMT83
172200210712
172300210712      ** Field :30:  Trade Date (YYMMDD format)
172400210712
172500210712     C                   ADD       1             X
172600210712     C     X             OCCUR     MULT
172700210712     C     CWRD          IFEQ      'NEW'
172800210712     C                   MOVE      MGTDAT        ZMDAY
172900210712     C                   ELSE
173000210712     C                   MOVE      BJRDNB        ZMDAY
173100210712     C                   ENDIF
173200210712
173300210712      ** Convert Midas date to SWIFT date format
173400210712
173500210712     C                   CALL      'ZM0065'                             15
173600210712     C                   PARM                    ZMDAY             5 0
173700210712     C                   PARM                    ZSDATE            6
173800210712     C                   PARM                    ZSDATC            8
173900210712
174000210712     C     *IN15         IFEQ      '1'
174100210712     C     *LOCK         IN        LDA
174200210712     C                   MOVE      '015'         DBASE
174300210712     C                   MOVEL     '       '     DBKEY
174400210712     C                   MOVEL     'ZM0065'      DBFILE
174500210712     C                   OUT       LDA
174600210712     C                   EXSR      *PSSR
174700210712     C                   ENDIF
174800210712
174900210712     C                   MOVEL     ':30:'        MTAG
175000210712     C                   MOVEL     ZSDATE        MFLD
175100210712
175200210712     C/COPY WNCPYSRC,MG0600C043
175300210712
175400210712     C                   MOVE      *BLANKS       WCRTN
175500210712     C                   MOVE      *BLANKS       @NSKYB
175600210712     C                   MOVE      *BLANKS       @NSKYE
175700210712
175800210712      ** Field :26C: Identification of the Commodity
175900210712
176000210712     C                   EVAL      MGALOC = 'UNALL'
176100210712     C                   EXSR      SRBTB
176200210712     C                   Z-ADD     0             I
176300210712     C     I             DOWLT     6
176400210712     C                   ADD       1             I
176500210712     C                   MOVEL     @BTB(I)       @WRK07            7
176600210712     C                   MOVEL     @BTB(I)       @WRK10           10
176700210712     C                   MOVEL     @BTB(I)       @WRK12           12
176800210712     C                   IF        @WRK07 = '/DELIV/'
176900210712     C                   MOVE      @WRK10        MGDELV
177000210712     C                   ENDIF
177100210712
177200210712     C                   IF        @WRK07 = '/ALLOC/'
177300210712     C                             AND %SUBST(@WRK12:8:5) <> *BLANKS
177400210712     C                   MOVE      @WRK12        MGALOC
177500210712     C                   ENDIF
177600210712
177700210712     C                   ENDDO
177800210712
177900210712     C     MGPMSC        IFEQ      'Y'
178000210712     C                   MOVE      MGPUCY        @UNITC            3
178100210712     C                   MOVE      MGPSTM        @STM
178200210712     C     @STM          LOOKUP    TABNST                                 23
178300210712
178400210712     C     MGPONS        IFNE      *BLANKS
178500210712     C     *IN23         ANDEQ     '1'
178600210712
178700210712      ** Use payment settlement currency to access nostro if not blank.
178800210712      ** Otherwise use sell currency.
178900210712
179000210712     C     CEU003        IFEQ      'Y'
179100210712     C     MGPYCY        ANDNE     *BLANKS
179200210712     C                   MOVE      MGPYCY        @NSKYB
179300210712     C                   ELSE
179400210712     C                   MOVE      MGSLCY        @NSKYB
179500210712     C                   ENDIF
179600210712     C                   MOVEL     MGPONS        @NSKYE
179700210712     C                   ENDIF
179800210712     C                   ELSE
179900210712
180000210712      ** Test if settlement via nostro
180100210712
180200210712     C                   MOVE      MGSLCY        @UNITC            3
180300210712     C                   MOVE      MGRSTM        @STM              2
180400210712     C     @STM          LOOKUP    TABNST                                 23
180500210712     C     MGRONS        IFNE      *BLANKS
180600210712     C     *IN23         ANDEQ     '1'
180700210712     C     CEU003        IFEQ      'Y'
180800210712     C     MGRCCY        ANDNE     *BLANKS
180900210712     C                   MOVE      MGRCCY        @NSKYB
181000210712     C                   ELSE
181100210712     C                   MOVE      MGPUCY        @NSKYB
181200210712     C                   ENDIF
181300210712     C                   MOVEL     MGRONS        @NSKYE
181400210712     C                   ENDIF
181500210712     C                   ENDIF
181600210712
181700210712     C     @NSKYE        IFNE      *BLANKS
181800210712     C                   CALL      'AONOSTR0'
181900210712     C                   PARM      '*MSG   '     @RTCD
182000210712     C                   PARM      '*KEY   '     @OPTN
182100210712     C                   PARM      *BLANKS       @NSKYA
182200210712     C                   PARM                    @NSKYB
182300210712     C                   PARM      *BLANKS       @NSKYC
182400210712     C                   PARM      *BLANKS       @NSKYD
182500210712     C                   PARM                    @NSKYE
182600210712     C                   PARM      *BLANKS       @KEYF
182700210712     C                   PARM      *BLANKS       @KEYG
182800210712     C                   PARM      *BLANKS       @KEYH
182900210712     C     SDNOST        PARM      SDNOST        DSFDY
183000210712
183100210712     C     @RTCD         IFEQ      *BLANKS
183200210712     C                   MOVE      *BLANKS       @KEY1
183300210712     C                   MOVEL     A7CUST        @KEY1
183400210712
183500210712     C                   CALL      'AOCUSTR0'
183600210712     C                   PARM      '*MSG   '     @RTCD
183700210712     C                   PARM      '*KEY   '     @OPTN
183800210712     C                   PARM                    @KEY1            10
183900210712     C                   PARM      *BLANKS       @KYST             7
184000210712     C     SDCUST        PARM      SDCUST        DSSDY
184100210712
184200210712     C     '/'           CAT       BBCRTN        WCRTN            17
184300210712     C                   ELSE
184400210712     C     '/'           CAT       'UNKNOWN'     WCRTN
184500210712     C                   ENDIF
184600210712     C                   ELSE
184700210712     C     '/'           CAT       'UNKNOWN'     WCRTN
184800210712     C                   ENDIF
184900210712
185000210712     C     WCRTN         CAT       '/'           WCRTN
185100210712
185200210712     C                   CALL      'AOCURRR0'
185300210712     C                   PARM      '*MSG   '     @RTCD
185400210712     C                   PARM      '*KEY   '     @OPTN
185500210712     C                   PARM      @NSKYB        @KEY3             3
185600210712     C     SDCURR        PARM      SDCURR        DSSDY
185700210712
185800210712     C                   EVAL      MGCMSH = A6CYCD + '-' + A6SWCY
185900210712     C     MGCMSH        SETLL     SDCMDTL0
186000210712     C     MGCMSH        CHAIN     SDCMDTL0                           90
186100210712     C                   IF        *IN90 = '0'
186200210712     C                   EVAL      MGDENO = A6CMDN
186300210712     C                   EVAL      MGUNIT = A6CMUN
186400210712     C                   EVAL      MGFORM = A6CMFM
186500210712     C                   EVAL      MGCMUD = A6CMUD
186600210712     C     MGUNIT        LOOKUP    VALUNI                                 90
186700210712     C     *IN90         IFEQ      '0'
186800210712     C                   MOVEL     *BLANKS       MGUNIT
186900210712     C                   ENDIF
187000210712     C                   ENDIF
187100210712
187200210712     C                   MOVE      *BLANKS       WMPTP
187300210712
187400210712     C                   SELECT
187500210712     C     A6SWCY        WHENEQ    'XAU'
187600210712     C                   MOVEL     'GOLD'        WMPTP             8
187700210712     C     A6SWCY        WHENEQ    'XPT'
187800210712     C                   MOVEL     'PLAT'        WMPTP
187900210712     C     A6SWCY        WHENEQ    'XAG'
188000210712     C                   MOVEL     'SILV'        WMPTP
188100210712     C     A6SWCY        WHENEQ    'XPD'
188200210712     C                   MOVEL     'PALL'        WMPTP
188300210712     C     A6SWCY        WHENEQ    'XCO'
188400210712     C                   MOVEL     'COPP'        WMPTP
188500210712     C     A6SWCY        WHENEQ    'XIR'
188600210712     C                   MOVEL     'IRID'        WMPTP
188700210712     C     A6SWCY        WHENEQ    'XLE'
188800210712     C                   MOVEL     'LEAD'        WMPTP
188900210712     C     A6SWCY        WHENEQ    'XNI'
189000210712     C                   MOVEL     'NICK'        WMPTP
189100210712     C     A6SWCY        WHENEQ    'XOS'
189200210712     C                   MOVEL     'OSMI'        WMPTP
189300210712     C     A6SWCY        WHENEQ    'XOT'
189400210712     C                   MOVEL     'OTHR'        WMPTP
189500210712     C     A6SWCY        WHENEQ    'XPO'
189600210712     C                   MOVEL     'POIL'        WMPTP
189700210712     C     A6SWCY        WHENEQ    'XRH'
189800210712     C                   MOVEL     'RHOD'        WMPTP
189900210712     C     A6SWCY        WHENEQ    'XRU'
190000210712     C                   MOVEL     'RUTH'        WMPTP
190100210712     C     A6SWCY        WHENEQ    'XST'
190200210712     C                   MOVEL     'STEE'        WMPTP
190300210712     C     A6SWCY        WHENEQ    'XTN'
190400210712     C                   MOVEL     'TINA'        WMPTP
190500210712     C     A6SWCY        WHENEQ    'XTI'
190600210712     C                   MOVEL     'TITA'        WMPTP
190700210712     C     A6SWCY        WHENEQ    'XZN'
190800210712     C                   MOVEL     'ZINC'        WMPTP
190900210712     C     A6SWCY        WHENEQ    'CA1'
191000210712     C                   MOVEL     'AMEG50'      WMPTP
191100210712     C     A6SWCY        WHENEQ    'CA2'
191200210712     C                   MOVEL     'AMEG25'      WMPTP
191300210712     C     A6SWCY        WHENEQ    'CA3'
191400210712     C                   MOVEL     'AMEG10'      WMPTP
191500210712     C     A6SWCY        WHENEQ    'CA4'
191600210712     C                   MOVEL     'AMEG5 '      WMPTP
191700210712     C     A6SWCY        WHENEQ    'CU1'
191800210712     C                   MOVEL     'ANUG1/1'     WMPTP
191900210712     C     A6SWCY        WHENEQ    'CU2'
192000210712     C                   MOVEL     'ANUG1/2'     WMPTP
192100210712     C     A6SWCY        WHENEQ    'CU3'
192200210712     C                   MOVEL     'ANUG1/4'     WMPTP
192300210712     C     A6SWCY        WHENEQ    'CU4'
192400210712     C                   MOVEL     'ANUG1/10'    WMPTP
192500210712     C     A6SWCY        WHENEQ    'CB1'
192600210712     C                   MOVEL     'BRIT1/1'     WMPTP
192700210712     C     A6SWCY        WHENEQ    'CB2'
192800210712     C                   MOVEL     'BRIT1/2'     WMPTP
192900210712     C     A6SWCY        WHENEQ    'CB3'
193000210712     C                   MOVEL     'BRIT1/4'     WMPTP
193100210712     C     A6SWCY        WHENEQ    'CB4'
193200210712     C                   MOVEL     'BRIT1/10'    WMPTP
193300210712     C     A6SWCY        WHENEQ    'CCN'
193400210712     C                   MOVEL     'COIN    '    WMPTP
193500210712     C     A6SWCY        WHENEQ    'CC1'
193600210712     C                   MOVEL     'CORO100'     WMPTP
193700210712     C     A6SWCY        WHENEQ    'CC2'
193800210712     C                   MOVEL     'CORO20 '     WMPTP
193900210712     C     A6SWCY        WHENEQ    'CC3'
194000210712     C                   MOVEL     'CORO10 '     WMPTP
194100210712     C     A6SWCY        WHENEQ    'CD1'
194200210712     C                   MOVEL     'DUCA4  '     WMPTP
194300210712     C     A6SWCY        WHENEQ    'CD2'
194400210712     C                   MOVEL     'DUCA1  '     WMPTP
194500210712     C     A6SWCY        WHENEQ    'CF1'
194600210712     C                   MOVEL     'FRFR20 '     WMPTP
194700210712     C     A6SWCY        WHENEQ    'CG1'
194800210712     C                   MOVEL     'GECU50 '     WMPTP
194900210712     C     A6SWCY        WHENEQ    'CK1'
195000210712     C                   MOVEL     'KRUG1/1'     WMPTP
195100210712     C     A6SWCY        WHENEQ    'CK2'
195200210712     C                   MOVEL     'KRUG1/2'     WMPTP
195300210712     C     A6SWCY        WHENEQ    'CK3'
195400210712     C                   MOVEL     'KRUG1/4'     WMPTP
195500210712     C     A6SWCY        WHENEQ    'CK4'
195600210712     C                   MOVEL     'KRUG1/10'    WMPTP
195700210712     C     A6SWCY        WHENEQ    'CL1'
195800210712     C                   MOVEL     'LBTY20 '     WMPTP
195900210712     C     A6SWCY        WHENEQ    'CL2'
196000210712     C                   MOVEL     'LBTY10 '     WMPTP
196100210712     C     A6SWCY        WHENEQ    'CL3'
196200210712     C                   MOVEL     'LBTY5  '     WMPTP
196300210712     C     A6SWCY        WHENEQ    'CM1'
196400210712     C                   MOVEL     'MAPL1/1'     WMPTP
196500210712     C     A6SWCY        WHENEQ    'CM2'
196600210712     C                   MOVEL     'MAPL1/2'     WMPTP
196700210712     C     A6SWCY        WHENEQ    'CM3'
196800210712     C                   MOVEL     'MAPL1/4'     WMPTP
196900210712     C     A6SWCY        WHENEQ    'CM4'
197000210712     C                   MOVEL     'MAPL1/10'    WMPTP
197100210712     C     A6SWCY        WHENEQ    'CX1'
197200210712     C                   MOVEL     'MEXP50'      WMPTP
197300210712     C     A6SWCY        WHENEQ    'CX2'
197400210712     C                   MOVEL     'MEXP20'      WMPTP
197500210712     C     A6SWCY        WHENEQ    'CX3'
197600210712     C                   MOVEL     'MEXP10'      WMPTP
197700210712     C     A6SWCY        WHENEQ    'CX4'
197800210712     C                   MOVEL     'MEXP5 '      WMPTP
197900210712     C     A6SWCY        WHENEQ    'CU1'
198000210712     C                   MOVEL     'NBUF50'      WMPTP
198100210712     C     A6SWCY        WHENEQ    'CN1'
198200210712     C                   MOVEL     'NOBL1/1'     WMPTP
198300210712     C     A6SWCY        WHENEQ    'CW1'
198400210712     C                   MOVEL     'NSOV1/1'     WMPTP
198500210712     C     A6SWCY        WHENEQ    'CW2'
198600210712     C                   MOVEL     'NSOV1/2'     WMPTP
198700210712     C     A6SWCY        WHENEQ    'CO1'
198800210712     C                   MOVEL     'OSOV1/1'     WMPTP
198900210712     C     A6SWCY        WHENEQ    'CO2'
199000210712     C                   MOVEL     'OSOV1/2'     WMPTP
199100210712     C     A6SWCY        WHENEQ    'CS1'
199200210712     C                   MOVEL     'SAEG1/1'     WMPTP
199300210712     C     A6SWCY        WHENEQ    'CE1'
199400210712     C                   MOVEL     'SECU5  '     WMPTP
199500210712     C     A6SWCY        WHENEQ    'CT1'
199600210712     C                   MOVEL     'STAT20 '     WMPTP
199700210712     C     A6SWCY        WHENEQ    'CT2'
199800210712     C                   MOVEL     'STAT10 '     WMPTP
199900210712     C     A6SWCY        WHENEQ    'CT3'
200000210712     C                   MOVEL     'STAT5  '     WMPTP
200100210712     C     A6SWCY        WHENEQ    'CV1'
200200210712     C                   MOVEL     'VREN20 '     WMPTP
200300210712     C     A6SWCY        WHENEQ    'CV2'
200400210712     C                   MOVEL     'VREN10 '     WMPTP
200500210712     C                   ENDSL
200600210712
200700210712     C                   IF        MGDELV <> *BLANKS
200800210712     C                   EVAL      WIDCOM = MGDELV
200900210712     C     WIDCOM        CAT       WCRTN:0       WIDCOM
201000210712     C     WIDCOM        CAT       '/':0         WIDCOM           45
201100210712     C                   ELSE
201200210712     C     WCRTN         CAT       '/':0         WIDCOM           45
201300210712     C                   ENDIF
201400210712
201500210712     C     WIDCOM        CAT       MGALOC:0      WIDCOM
201600210712     C     WIDCOM        CAT       WMPTP:0       WIDCOM
201700210712     C     WIDCOM        CAT       MGDENO:0      WIDCOM
201800210712
201900210712     C                   IF        MGFORM <> *BLANKS
202000210712     C     WIDCOM        CAT       '//':0        WIDCOM
202100210712     C     WIDCOM        CAT       MGFORM:0      WIDCOM
202200210712     C                   ENDIF
202300210712
202400210712     C                   ADD       1             X
202500210712     C     X             OCCUR     MULT
202600210712
202700210712     C                   MOVEL     ':26C:'       MTAG
202800210712     C                   MOVEL     WIDCOM        MFLD
202900210712
203000210712      ** Field 26H Counterparty's reference not output
203100210712
203200210712     C                   IF        %SUBST(MGBTB1:1:6) = '/CREF/'
203300210712     C                   EVAL      MGCREF = %SUBST(MGBTB1:7:29)
203400210712     C                   ADD       1             X
203500210712     C     X             OCCUR     MULT
203600210712     C                   MOVEL     ':26H:'       MTAG
203700210712     C                   MOVEL     MGCREF        MFLD
203800210712     C                   ENDIF
203900210712
204000210712      ** Price by Unit 33G
204100210712
204200210712     C                   ADD       1             X
204300210712     C     X             OCCUR     MULT
204400210712
204500210712     C/COPY WNCPYSRC,MG0600C042
204600210712
204700210712     C                   MOVE      MGEXRT        ZEXRT
204800210712
204900210712     C/COPY WNCPYSRC,MG0600C001
205000210712
205100210712      ** Exchange rate conversion
205200210712
205300210712     C                   CALL      'ZM0030'                             15
205400210712     C                   PARM                    ZEXRT            13 8
205500210712     C                   PARM                    ZSEXRT           12
205600210712
205700210712     C/COPY WNCPYSRC,MG0600C037
205800210712
205900210712     C     *IN15         IFEQ      '1'
206000210712     C     *LOCK         IN        LDA
206100210712     C                   MOVE      '017'         DBASE
206200210712     C                   MOVEL     '       '     DBKEY
206300210712     C                   MOVEL     'ZM0030'      DBFILE
206400210712     C                   OUT       LDA
206500210712     C                   EXSR      *PSSR
206600210712     C                   ENDIF
206700210712
206800210712     C/COPY WNCPYSRC,MG0600C003
206900210712
207000210712     C                   EXSR      SRBTB
207100210712
207200210712     C                   Z-ADD     1             I
207300210712     C                   MOVE      *BLANKS       @WRK33            5
207400210712
207500210712     C     I             DOUGT     6
207600210712     C     @BTB(I)       IFNE      *BLANKS
207700210712     C     6             SUBST     @BTB(I)       WCHK33            6
207800210712     C     WCHK33        IFEQ      '/UNIT/'
207900210712     C                   MOVE      'SEE72'       @WRK33
208000210712     C                   LEAVE
208100210712     C                   ENDIF
208200210712     C                   ENDIF
208300210712     C                   ADD       1             I
208400210712     C                   ENDDO
208500210712
208600210712     C                   CALL      'AOCURRR0'
208700210712     C                   PARM      '*MSG   '     @RTCD
208800210712     C                   PARM      '*KEY   '     @OPTN
208900210712     C                   PARM      @UNITC        @KEY3             3
209000210712     C     SDCURR        PARM      SDCURR        DSSDY
209100210712
209200210712     C                   MOVE      ':33G:'       MTAG
209300210712     C     A6SWCY        CAT       ZSEXRT:0      MFLD
209400210712
209500210712     C     MFLD          CAT       @WRK33:0      MFLD
209600210712
209700210712      ** Field 71C Not output
209800210712      ** Field 77H - Agreement
209900210712
210000210712     C     MGAGTY        IFNE      *BLANKS
210100210712     C                   ADD       1             X
210200210712     C     X             OCCUR     MULT
210300210712     C                   MOVE      ':77H:'       MTAG
210400210712
210500210712     C                   MOVEA     *BLANKS       @WRK
210600210712     C                   MOVEA     MGAGTY        @WRK
210700210712     C                   Z-ADD     1             Z                 3 0
210800210712     C     ' '           LOOKUP    @WRK(Z)                                31
210900210712
211000210712     C     MGAGDT        IFNE      *ZEROS
211100210712     C                   MOVEA     '/'           @WRK(Z)
211200210712     C                   ADD       1             Z
211300210712     C                   MOVE      MGAGDT        WNAGDT            8
211400210712     C                   MOVEA     WNAGDT        @WRK(Z)
211500210712
211600210712     C     MGAGVV        IFNE      *ZEROS
211700210712     C     ' '           LOOKUP    @WRK(Z)                                31
211800210712     C                   MOVEA     '//'          @WRK(Z)
211900210712     C                   ADD       2             Z
212000210712     C                   MOVE      MGAGVV        WNAGVV            4
212100210712     C                   MOVEA     WNAGVV        @WRK(Z)
212200210712     C                   ENDIF
212300210712
212400210712     C                   ENDIF
212500210712
212600210712     C                   MOVEA     @WRK          MFLD
212700210712
212800210712     C                   ENDIF
212900210712
213000210712      ** Format field :77D: - Conditions.
213100210712
213200210712     C     MGCON1        IFNE      *BLANKS
213300210712
213400210712      ** Store the CONDITIONS information for easier use.
213500210712
213600210712     C                   MOVE      MGCON1        @BTB(1)
213700210712     C                   MOVE      MGCON2        @BTB(2)
213800210712     C                   MOVE      MGCON3        @BTB(3)
213900210712     C                   MOVE      MGCON4        @BTB(4)
214000210712     C                   MOVE      MGCON5        @BTB(5)
214100210712     C                   MOVE      MGCON6        @BTB(6)
214200210712
214300210712     C                   Z-ADD     0             I
214400210712     C                   MOVE      'N'           FLD77O            1
214500210712
214600210712      ** Search through all six fields & output if not blank.
214700210712
214800210712     C     I             DOWLT     6
214900210712
215000210712     C                   ADD       1             I
215100210712
215200210712     C     @BTB(I)       IFNE      *BLANKS
215300210712     C                   ADD       1             X
215400210712     C     X             OCCUR     MULT
215500210712     C     FLD77O        IFEQ      'N'
215600210712     C                   MOVE      ':77D:'       MTAG
215700210712     C                   MOVE      'Y'           FLD77O
215800210712     C                   ENDIF
215900210712
216000210712     C                   MOVEL     @BTB(I)       MFLD
216100210712     C                   ENDIF
216200210712
216300210712     C                   ENDDO
216400210712
216500210712     C                   ENDIF
216600210712
216700210712      ** Field 14C - Year Definitions
216800210712
216900210712     C     MGAGTY        IFEQ      'ISDA'
217000210712     C                   ADD       1             X
217100210712     C     X             OCCUR     MULT
217200210712     C                   MOVE      ':14C:'       MTAG
217300210712     C                   MOVEL     MGISDA        MFLD
217400210712     C                   ENDIF
217500210712
217600210712      * Field 72 formatting
217700210712
217800210712     C                   EXSR      FLD72
217900210712
218000210712     C                   ENDSR
218100210712      *****************************************************************
218200210712     C/EJECT
218300210712      *****************************************************************
218400210712      *                                                               *
218500210712      *   FLD72 - Calculate field 72                                  *
218600210712      *                                                               *
218700210712      *****************************************************************
218800210712      *
218900210712     C     FLD72         BEGSR
219000210712
219100210712     C                   MOVE      *BLANKS       @WRK
219200210712
219300210712      ** Store the Sender to Receiver information for easier use.
219400210712
219500210712     C                   EXSR      SRBTB
219600210712
219700210712     C                   Z-ADD     0             I
219800210712     C                   MOVE      'N'           FLD72O            1
219900210712
220000210712      ** Search through all six fields & output if not blank.
220100210712
220200210712     C     I             DOWLT     6
220300210712
220400210712     C                   ADD       1             I
220500210712     C                   MOVEL     @BTB(I)       @WRK06            6
220600210712     C                   MOVEL     @BTB(I)       @WRK07            7
220700210712     C                   MOVEL     @BTB(I)       @WRK10           10
220800210712
220900210712     C     @BTB(I)       IFNE      *BLANKS
221000210712     C     @WRK07        IFNE      '/DELIV/'
221100210712     C     @WRK07        ANDNE     '/ALLOC/'
221200210712     C     @WRK06        ANDNE     '/CREF/'
221300210712
221400210712     C     @WRK06        IFEQ      '/UNIT/'
221500210712     C     @WRK10        OREQ      MSGA(9)
221600210712     C                   MOVEL     *BLANKS       @UNIT
221700210712     C     @WRK06        IFEQ      '/UNIT/'
221800210712     C     3             SUBST     @WRK10:7      @UNIT             3
221900210712     C     @UNIT         LOOKUP    VALUNI                                 90
222000210712     C     *IN90         IFEQ      '1'
222100210712     C                   ADD       1             X
222200210712     C     X             OCCUR     MULT
222300210712     C     FLD72O        IFEQ      'N'
222400210712     C                   MOVE      ':72: '       MTAG
222500210712     C                   MOVE      'Y'           FLD72O
222600210712     C                   ENDIF
222700210712
222800210712     C                   IF        @UNIT = 'OTH'
222900210712     C                   EVAL      MFLD = '/UNIT/' + MGCMUD
223000210712     C                   ELSE
223100210712     C                   EVAL      MFLD = @BTB(I)
223200210712     C                   ENDIF
223300210712     C                   ENDIF
223400210712     C
223500210712     C                   ENDIF
223600210712
223700210712     C                   ELSE
223800210712     C                   ADD       1             X
223900210712     C     X             OCCUR     MULT
224000210712
224100210712     C     FLD72O        IFEQ      'N'
224200210712     C                   MOVE      ':72: '       MTAG
224300210712     C                   MOVE      'Y'           FLD72O
224400210712     C                   ENDIF
224500210712
224600210712     C                   MOVEL     @BTB(I)       MFLD
224700210712     C                   ENDIF
224800210712     C                   ELSE
224900210712
225000210712     C                   LEAVE
225100210712
225200210712     C                   ENDIF
225300210712     C                   ENDIF
225400210712
225500210712     C                   ENDDO
225600210712
225700210712     C/COPY WNCPYSRC,MG0600CCP3
225800210712
225900210712      ** Output /TELEX/
226000210712
226100210712     C/COPY WNCPYSRC,MG0600CCP4
226200210712
226300210712     C*****MGBRKC        IFEQ      'TELX'                                                   MD030922
226400210712     C**********         MOVEA     '/TELEX/'     @WRK(1)                                    MD030922
226500210712     C**********         END                                                                MD030922
226600210712
226700210712      ** Output /PHON/
226800210712
226900210712     C/COPY WNCPYSRC,MG0600CCP5
227000210712
227100210712     C*****MGBRKC        IFEQ      'PHON'                                                   MD030922
227200210712     C**********         MOVEA     '/PHON/'      @WRK(1)                                    MD030922
227300210712     C**********         END                                                                MD030922
227400210712      **********                                                                            MD030922
227500210712     C*****MGBRKC        IFNE      'TELX'                                                   MD030922
227600210712     C*****MGBRKC        ANDNE     'PHON'                                                   MD030922
227700210712     C*****MGBRKC        ANDNE     'MAIL'                                                   MD030922
227800210712     C*****MGBRKC        ANDNE     'SWAP'                                                   MD030922
227900210712     C*****MGBRKC        ANDNE     *BLANKS                                                  MD030922
228000210712      **********                                                                            MD030922
228100210712      ***Access*the*broker*file*                                                            MD030922
228200210712      **********                                                                            MD030922
228300210712     C**********         CALL      'AOBROKR0'                                               MD030922
228400210712     C**********         PARM      '*MSG   '     @RTCD             7                        MD030922
228500210712     C**********         PARM      '*KEY   '     @OPTN             7                        MD030922
228600210712     C**********         PARM      MGBRKC        @BROKY            4                        MD030922
228700210712     C*****SDBROK        PARM      SDBROK        DSFDY                                      MD030922
228800210712      **********                                                                            MD030922
228900210712      ***If*the*broker*code*is*not*found.*                                                  MD030922
229000210712      **********                                                                            MD030922
229100210712     C*****@RTCD         IFNE      *BLANKS                                                  MD030922
229200210712     C**********         MOVE      'Y'           @ERR                                       MD030922
229300210712     C**********         MOVEL     MSGA(4)       MERR                                       MD030922
229400210712     C**********         MOVEA     MGBRKC        @WRK(1)                                    MD030922
229500210712      **********                                                                            MD030922
229600210712      ***Format*the*broker*field.*                                                          MD030922
229700210712      **********                                                                            MD030922
229800210712     C**********         ELSE                                                               MD030922
229900210712      **********                                                                            MD030922
230000210712     C/COPY WNCPYSRC,MG0600CCP6
230100210712      **********                                                                            MD030922
230200210712     C**********         MOVEA     '/BROKER/'    @WRK(1)                                    MD030922
230300210712     C**********         MOVEA     A9BKNM        @WRK(9)                                    MD030922
230400210712      **********                                                                            MD030922
230500210712     C/COPY WNCPYSRC,MG0600CCP7
230600210712      **********                                                                            MD030922
230700210712     C**********         END                                                                MD030922
230800210712     C**********         END                                                                MD030922
230900210712      **********                                                                            MD030922
231000210712      ***Maximum*length*of*field*is*35*                                                     MD030922
231100210712      **********                                                                            MD030922
231200210712     C**********         MOVEA     @WRK(36)      @WRK15           15                        MD030922
231300210712     C*****@WRK15        IFNE      *BLANK                                                   MD030922
231400210712     C**********         Z-ADD     36            J                 2 0                      MD030922
231500210712     C**********         MOVEA     *BLANK        @WRK(J)                                    MD030922
231600210712     C**********         END                                                                MD030922
231700210712      **********                                                                            MD030922
231800210712      ****Output*Field*:72:*as*constructed*from*above*                                      MD030922
231900210712      **********                                                                            MD030922
232000210712     C*****@WRK(1)       IFNE      *BLANK                                                   MD030922
232100210712     C*****I****         ANDLE     6                                                        MD030922
232200210712     C**********         ADD       1             I                                          MD030922
232300210712     C**********         ADD       1             X                                          MD030922
232400210712     C*****X****         OCCUR     MULT                                                     MD030922
232500210712     C*****FLD72O        IFEQ      'N'                                                      MD030922
232600210712     C**********         MOVE      ':72: '       MTAG                                       MD030922
232700210712     C**********         MOVE      'Y'           FLD72O                                     MD030922
232800210712     C**********         ENDIF                                                              MD030922
232900210712     C**********         MOVEA     @WRK          MFLD                                       MD030922
233000210712     C**********         END                                                                MD030922
233100210712      **********                                                                            MD030922
233200210712      ***Wrap*round*to*the*next*line*the*remainder*of*the*BROKER*info.*                     MD030922
233300210712      **********                                                                            MD030922
233400210712     C*****@WRK15        IFNE      *BLANK                                                   MD030922
233500210712     C*****I****         ANDLE     6                                                        MD030922
233600210712     C**********         ADD       1             I                                          MD030922
233700210712     C**********         MOVEA     *BLANK        @WRK                                       MD030922
233800210712     C**********         MOVEA     '//'          @WRK(1)                                    MD030922
233900210712     C**********         MOVEA     @WRK15        @WRK(3)                                    MD030922
234000210712     C**********         ADD       1             X                                          MD030922
234100210712     C*****X****         OCCUR     MULT                                                     MD030922
234200210712     C**********         MOVEA     @WRK          MFLD                                       MD030922
234300210712     C/COPY WNCPYSRC,MG0600C040
234400210712     C**********         END                                                                MD030922
234500210712      **********                                                                            MD030922
234600210712     C/COPY WNCPYSRC,MG0600CCP8
234700210712
234800210712
234900210712     C                   ENDSR
235000210712      *****************************************************************
235100210712     C/EJECT
235200210712      *****************************************************************
235300210712      *                                                               *
235400210712      *   SRFMTB - Format message detail - Sequence B                 *
235500210712      *                                                               *
235600210712      *****************************************************************
235700210712      *
235800210712     C     SRFMTB        BEGSR
235900210712
236000210712      **  Field :15B: Transaction Details
236100210712
236200210712     C                   ADD       1             X
236300210712     C     X             OCCUR     MULT
236400210712     C                   MOVE      ':15B:'       MTAG
236500210712     C                   MOVEL     *BLANK        MFLD
236600210712
236700210712      ** 1. Sequence B - Quantity of Commodity - Bought
236800210712      ** ------------------------------
236900210712
237000210712      ** Field :32F:  Unit, Amount Bought
237100210712
237200210712     C                   ADD       1             X
237300210712     C     X             OCCUR     MULT
237400210712
237500210712      ** Format purchase currency and amount
237600210712
237700210712     C                   MOVE      MGPUCY        ZCCY
237800210712     C                   MOVE      MGPAMT        ZAMNT
237900210712
238000210712     C/COPY WNCPYSRC,MG0600C038
238100210712
238200210712     C                   CALL      'ZM0040'                             15
238300210712     C                   PARM                    ZAMNT            13 0
238400210712     C                   PARM                    ZCCY              3
238500210712     C                   PARM                    ZSAMNT           15
238600210712     C                   PARM                    ZSCCY             3
238700210712     C                   PARM      ' '           ZERR              1
238800210712
238900210712     C     *IN15         IFEQ      '1'
239000210712     C     *LOCK         IN        LDA
239100210712     C                   MOVE      '018'         DBASE
239200210712     C                   MOVEL     '       '     DBKEY
239300210712     C                   MOVEL     'ZM0040'      DBFILE
239400210712     C                   OUT       LDA
239500210712     C                   EXSR      *PSSR
239600210712     C                   ENDIF
239700210712
239800210712     C                   MOVE      MGUNIT        ZSCCY
239900210712     C                   MOVE      ':32F:'       MTAG
240000210712
240100210712      ** Error - indicate erroneous fields
240200210712
240300210712     C     ZERR          IFEQ      '1'
240400210712     C                   MOVE      'Y'           @ERR
240500210712     C                   MOVE      MGPAMT        ZAMT
240600210712     C                   MOVEL     ERR3N         MFLD
240700210712     C                   MOVEL     MSGA(5)       MERR
240800210712     C                   ELSE
240900210712     C                   MOVEL     FLD2N         MFLD
241000210712     C                   ENDIF
241100210712
241200210712      ** Field :86a:  Intermediary
241300210712
241400210712     C/COPY WNCPYSRC,MG0600C022
241500210712
241600210712      ** Intermediary not blank; retrieve customer address
241700210712
241800210712     C     MGRIBN        IFNE      *BLANKS
241900210712     C                   ADD       1             X
242000210712     C     X             OCCUR     MULT
242100210712     C                   MOVE      *BLANKS       ZDEST
242200210712     C                   MOVEL     MGRIBN        ZDEST
242300210712     C                   MOVE      *BLANKS       ACLINE           35
242400210712     C                   MOVEL     MGRIBA        ACLINE
242500210712     C                   MOVE      ' '           TAG
242600210712     C                   MOVE      '86'          FLDNO
242700210712     C                   MOVE      NETBY         CKNETI
242800210712     C                   EXSR      FSWAD
242900210712     C                   ENDIF
243000210712
243100210712      ** Field :87a: Receiver of the Commodity
243200210712
243300210712     C/COPY WNCPYSRC,MG0600C007
243400210712
243500210712     C                   ADD       1             X
243600210712     C     X             OCCUR     MULT
243700210712
243800210712      ** Test if settlement via nostro
243900210712
244000210712     C                   MOVE      MGRSTM        @STM              2
244100210712     C     @STM          LOOKUP    TABNST                                 23
244200210712     C     MGRONS        IFNE      *BLANKS
244300210712     C     *IN23         ANDEQ     '1'
244400210712
244500210712      ** Use receipt settlement currency to access nostro if not blank.
244600210712      ** Otherwise use purchase currency.
244700210712
244800210712     C     CEU003        IFEQ      'Y'
244900210712     C     MGRCCY        ANDNE     *BLANKS
245000210712     C                   MOVE      MGRCCY        @NSKYB
245100210712     C                   ELSE
245200210712     C                   MOVE      MGPUCY        @NSKYB
245300210712     C                   ENDIF
245400210712
245500210712     C                   MOVEL     MGRONS        @NSKYE
245600210712     C                   CALL      'AONOSTR0'
245700210712     C                   PARM      '*MSG   '     @RTCD             7
245800210712     C                   PARM      '*KEY   '     @OPTN             7
245900210712     C                   PARM      *BLANKS       @NSKYA            6
246000210712     C                   PARM                    @NSKYB            3
246100210712     C                   PARM      *BLANKS       @NSKYC            4
246200210712     C                   PARM      *BLANKS       @NSKYD            2
246300210712     C                   PARM                    @NSKYE            2
246400210712     C                   PARM      *BLANKS       @KEYF             3
246500210712     C                   PARM      *BLANKS       @KEYG            10
246600210712     C                   PARM      *BLANKS       @KEYH             1
246700210712     C     SDNOST        PARM      SDNOST        DSFDY
246800210712
246900210712     C     @RTCD         IFNE      *BLANKS
247000210712     C                   MOVE      'Y'           @ERR
247100210712     C                   MOVEL     MGRONS        MFLD
247200210712     C                   MOVEL     MSGA(3)       MERR
247300210712     C                   MOVE      ':87 :'       MTAG
247400210712     C                   ELSE
247500210712
247600210712     C                   MOVE      *BLANKS       ZDEST
247700210712     C                   MOVEL     A7CUST        ZDEST
247800210712
247900210712     C/COPY WNCPYSRC,MG0600CCP1
248000210712
248100210712     C                   MOVEL     *BLANKS       ACLINE
248200210712     C                   MOVE      ' '           TAG
248300210712     C                   MOVE      '87'          FLDNO
248400210712     C                   MOVE      NETBY         CKNETI            1
248500210712
248600210712     C/COPY WNCPYSRC,MG0600C015
248700210712
248800210712     C                   EXSR      FSWAD
248900210712     C                   ENDIF
249000210712
249100210712      ** Our receive nostro is blank or settlement internal
249200210712
249300210712     C                   ELSE
249400210712
249500210712      ** Test if settlement internal
249600210712
249700210712     C                   MOVE      MGRSTM        @STM
249800210712     C     @STM          LOOKUP    TABINT                                 23
249900210712
250000210712     C     *IN23         IFEQ      '1'
250100210712     C                   MOVE      *BLANKS       ZDEST
250200210712     C                   MOVEL     SECN          ZDEST
250300210712     C                   MOVEL     *BLANKS       ACLINE
250400210712     C                   MOVE      ' '           TAG
250500210712     C                   MOVE      '87'          FLDNO
250600210712     C                   MOVE      NETBY         CKNETI
250700210712     C                   EXSR      FSWAD
250800210712
250900210712     C                   ELSE
251000210712     C                   MOVE      ':87D:'       MTAG
251100210712     C                   MOVEL     'UNKNOWN'     MFLD
251200210712     C                   ENDIF
251300210712
251400210712     C                   ENDIF
251500210712
251600210712     C/COPY WNCPYSRC,MG0600C008
251700210712
251800210712      ** 2. 34P Consideration
251900210712      ** ----------------------------
252000210712
252100210712      **  Field :34P: Value date, currency code and the consideration paid by the Sender
252200210712
252300210712     C                   ADD       1             X
252400210712     C     X             OCCUR     MULT
252500210712
252600210712      **  Format value date to SWIFT standard
252700210712
252800210712     C     MGTTYP        IFEQ      'OP'
252900210712     C     COB           ANDEQ     'C'
253000210712     C                   MOVE      MGOTDT        ZMDAY
253100210712     C                   ELSE
253200210712     C     CWRD          IFEQ      'AMEND'
253300210712     C                   MOVE      BJRDNB        ZMDAY
253400210712     C                   ELSE
253500210712     C                   MOVE      MGVDAT        ZMDAY
253600210712     C                   ENDIF
253700210712     C                   ENDIF
253800210712     C                   CALL      'ZM0065'                             15
253900210712     C                   PARM                    ZMDAY             5 0
254000210712     C                   PARM                    ZSDAT1            6
254100210712     C                   PARM                    ZSDATC            8
254200210712
254300210712     C     *IN15         IFEQ      '1'
254400210712     C     *LOCK         IN        LDA
254500210712     C                   MOVE      '016'         DBASE
254600210712     C                   MOVEL     '       '     DBKEY
254700210712     C                   MOVEL     'ZM0065'      DBFILE
254800210712     C                   OUT       LDA
254900210712     C                   EXSR      *PSSR
255000210712     C                   ENDIF
255100210712
255200210712     C     X             OCCUR     MULT
255300210712     C                   MOVE      MGSLCY        ZCCY
255400210712     C                   MOVE      MGSAMT        ZAMNT
255500210712
255600210712     C/COPY WNCPYSRC,MG0600C039
255700210712
255800210712     C                   CALL      'ZM0040'                             15
255900210712     C                   PARM                    ZAMNT            13 0
256000210712     C                   PARM                    ZCCY              3
256100210712     C                   PARM                    ZSAMN1           15
256200210712     C                   PARM                    ZSCCY1            3
256300210712     C                   PARM      ' '           ZERR              1
256400210712
256500210712     C     *IN15         IFEQ      '1'
256600210712     C     *LOCK         IN        LDA
256700210712     C                   MOVE      '019'         DBASE
256800210712     C                   MOVEL     '       '     DBKEY
256900210712     C                   MOVEL     'ZM0040'      DBFILE
257000210712     C                   OUT       LDA
257100210712     C                   EXSR      *PSSR
257200210712     C                   ENDIF
257300210712
257400210712      ** Error - indicate erroneous fields;
257500210712
257600210712     C     ZERR          IFEQ      '1'
257700210712     C                   MOVE      'Y'           @ERR
257800210712     C                   MOVE      MGSAMT        ZAMT
257900210712     C                   MOVE      MGSLCY        ZCCY
258000210712     C                   MOVEL     ERR3N         MFLD
258100210712     C                   MOVEL     MSGA(4)       MERR
258200210712
258300210712     C                   ELSE
258400210712     C                   MOVE      ':34P:'       MTAG
258500210712     C                   MOVEL     FLD3N         MFLD
258600210712     C                   ENDIF
258700210712
258800210712     C/COPY WNCPYSRC,MG0600C009
258900210712
259000210712      ** Field :53a: Sender's Correspondent
259100210712      ** Test if settlement via nostro
259200210712
259300210712     C                   MOVE      MGPSTM        @STM
259400210712     C     @STM          LOOKUP    TABNST                                 23
259500210712
259600210712     C     MGPONS        IFNE      *BLANKS
259700210712     C     *IN23         ANDEQ     '1'
259800210712
259900210712      ** either A/C with Bank or Receipient entered
260000210712      ** or A/C with A/c line = 'DIRECT'
260100210712
260200210712     C     MGAWBN        IFNE      *BLANKS
260300210712     C     MGRVNO        ORNE      *BLANKS
260400210712     C     AWBA6         ANDNE     'DIRECT'
260500210712
260600210712      ** Use payment settlement currency to access nostro if not blank.
260700210712      ** Otherwise use sell currency.
260800210712
260900210712     C     CEU003        IFEQ      'Y'
261000210712     C     MGPYCY        ANDNE     *BLANKS
261100210712     C                   MOVE      MGPYCY        @NSKYB
261200210712     C                   ELSE
261300210712     C                   MOVE      MGSLCY        @NSKYB
261400210712     C                   ENDIF
261500210712
261600210712     C                   MOVEL     MGPONS        @NSKYE
261700210712     C                   CALL      'AONOSTR0'
261800210712     C                   PARM      '*MSG   '     @RTCD             7
261900210712     C                   PARM      '*KEY   '     @OPTN             7
262000210712     C                   PARM      *BLANKS       @NSKYA            6
262100210712     C                   PARM                    @NSKYB            3
262200210712     C                   PARM      *BLANKS       @NSKYC            4
262300210712     C                   PARM      *BLANKS       @NSKYD            2
262400210712     C                   PARM                    @NSKYE            2
262500210712     C                   PARM      *BLANKS       @KEYF             3
262600210712     C                   PARM      *BLANKS       @KEYG            10
262700210712     C                   PARM      *BLANKS       @KEYH             1
262800210712     C     SDNOST        PARM      SDNOST        DSFDY
262900210712
263000210712      **  Nostro customer not found
263100210712
263200210712     C     @RTCD         IFNE      *BLANKS
263300210712     C                   ADD       1             X
263400210712     C     X             OCCUR     MULT
263500210712     C                   MOVE      'Y'           @ERR
263600210712     C                   MOVE      ':53 :'       MTAG
263700210712     C                   MOVEL     MGPONS        MFLD
263800210712     C                   MOVEL     MSGA(3)       MERR
263900210712     C                   ELSE
264000210712
264100210712      ** Branch Internal Customer cf. Customer number of Our Pay Nostro
264200210712
264300210712     C                   MOVEL     SECN          @SECN             6
264400210712     C     @SECN         IFNE      A7CUST
264500210712     C     MGAWBN        ANDNE     A7CUST
264600210712     C                   ADD       1             X
264700210712     C     X             OCCUR     MULT
264800210712     C                   MOVE      *BLANKS       ZDEST
264900210712     C     MGRVNO        IFEQ      *BLANKS
265000210712     C                   MOVEL     A7CUST        ZDEST
265100210712     C                   ELSE
265200210712     C                   MOVEL     MGRVNO        ZDEST
265300210712
265400210712     C/COPY WNCPYSRC,MG0600C002
265500210712
265600210712     C                   ENDIF
265700210712     C                   CALL      'ZM0050'                             15
265800210712     C                   PARM                    ZDEST            12
265900210712     C                   PARM                    ZSADD1           35
266000210712     C                   PARM                    ZSADD2           35
266100210712     C                   PARM                    ZSADD3           35
266200210712     C                   PARM                    ZSADD4           35
266300210712     C                   PARM                    ZSTAG             1
266400210712     C                   PARM                    ZSTYPE            1
266500210712     C                   PARM      ' '           ZERR              1
266600210712     C                   PARM                    ZDBEI             1
266700210712
266800210712     C     *IN15         IFEQ      '1'
266900210712     C     *LOCK         IN        LDA
267000210712     C                   MOVE      '020'         DBASE
267100210712     C                   MOVEL     '       '     DBKEY
267200210712     C                   MOVEL     'ZM0050'      DBFILE
267300210712     C                   OUT       LDA
267400210712     C                   EXSR      *PSSR
267500210712     C                   ENDIF
267600210712
267700210712      **  Error when formating address
267800210712
267900210712     C     ZERR          IFEQ      '1'
268000210712     C                   MOVE      'Y'           @ERR
268100210712     C                   MOVE      ':53 :'       MTAG
268200210712     C                   MOVEL     ZDEST         MFLD
268300210712     C                   MOVEL     MSGA(6)       MERR
268400210712     C                   ELSE
268500210712     C                   EXSR      FMT53
268600210712     C                   ENDIF
268700210712     C                   ENDIF
268800210712     C                   ENDIF
268900210712     C                   ENDIF
269000210712     C                   ENDIF
269100210712
269200210712     C/COPY WNCPYSRC,MG0600C010
269300210712
269400210712      ** Field :56a: and :57a: Intermediary and Accnt with Institution
269500210712      ** Nostro field blank
269600210712
269700210712     C     MGPSTM        IFEQ      00
269800210712     C                   ADD       1             X
269900210712     C     X             OCCUR     MULT
270000210712                                                                                            MD055694
270100210712     C                   IF        CSW221 = 'Y'                                             MD055694
270200210712     C                   MOVE      ':57J:'       MTAG                                       MD055694
270300210712     C                   MOVEL     NOSTXU        MFLD                                       MD055694
270400210712     C                   ELSE                                                               MD055694
270500210712     C                   MOVE      ':57D:'       MTAG
270600210712     C                   MOVEL     'UNKNOWN'     MFLD
270700210712     C                   ENDIF                                                              MD055694
270800210712     C                   MOVE      'Y'           FLD57U            1
270900210712     C                   END
271000210712
271100210712      ** Field 57 Seq C is not UNKNOWN
271200210712
271300210712     C     FLD57U        IFNE      'Y'
271400210712
271500210712      ** Field 56 and Field 57  intermediary and account with inst.
271600210712
271700210712     C                   MOVEL     '56'          @TAGI             2
271800210712     C                   MOVEL     '57'          @TAGD             2
271900210712     C                   EXSR      FMTX1
272000210712     C                   END
272100210712     C                   MOVE      'N'           FLD57U
272200210712
272300210712     C                   MOVE      *BLANK        ZDBEI
272400210712
272500210712     C/COPY WNCPYSRC,MG0600C050
272600210712
272700210712     C                   ENDSR
272800210712      *****************************************************************
272900210712     C/EJECT
273000210712      *****************************************************************
273100210712      *                                                               *
273200210712      *   SRFMTC - Format message detail - Sequence C                 *
273300210712      *                                                               *
273400210712      *****************************************************************
273500210712     C     SRFMTC        BEGSR
273600210712
273700210712      **  Field :15C: New Sequence
273800210712
273900210712     C                   ADD       1             X
274000210712     C     X             OCCUR     MULT
274100210712     C                   MOVE      ':15C:'       MTAG
274200210712     C                   MOVEL     *BLANK        MFLD
274300210712
274400210712      ** 1. Sequence C - Quantity of Commodity - Sold
274500210712      ** ------------------------------
274600210712
274700210712      **  Field :32F:  Currency, Amount Bought
274800210712
274900210712     C                   ADD       1             X
275000210712     C     X             OCCUR     MULT
275100210712
275200210712      ** Format purchase currency and amount
275300210712
275400210712     C                   MOVE      MGSLCY        ZCCY
275500210712     C                   MOVE      MGSAMT        ZAMNT
275600210712
275700210712     C/COPY WNCPYSRC,MG0600C038
275800210712
275900210712     C                   CALL      'ZM0040'                             15
276000210712     C                   PARM                    ZAMNT            13 0
276100210712     C                   PARM                    ZCCY              3
276200210712     C                   PARM                    ZSAMNT           15
276300210712     C                   PARM                    ZSCCY             3
276400210712     C                   PARM      ' '           ZERR              1
276500210712
276600210712     C     *IN15         IFEQ      '1'
276700210712     C     *LOCK         IN        LDA
276800210712     C                   MOVE      '018'         DBASE
276900210712     C                   MOVEL     '       '     DBKEY
277000210712     C                   MOVEL     'ZM0040'      DBFILE
277100210712     C                   OUT       LDA
277200210712     C                   EXSR      *PSSR
277300210712     C                   ENDIF
277400210712
277500210712     C                   MOVE      ':32F:'       MTAG
277600210712
277700210712      ** Error - indicate erroneous fields
277800210712
277900210712     C     ZERR          IFEQ      '1'
278000210712     C                   MOVE      'Y'           @ERR
278100210712     C                   MOVE      MGPAMT        ZAMT
278200210712     C                   MOVEL     ERR3N         MFLD
278300210712     C                   MOVEL     MSGA(5)       MERR
278400210712     C                   ELSE
278500210712     C                   MOVE      MGUNIT        ZSCCY
278600210712     C                   MOVEL     FLD2N         MFLD
278700210712     C                   ENDIF
278800210712
278900210712     C/COPY WNCPYSRC,MG0600C010
279000210712
279100210712      ** Field :86a: and :87a: Intermediary and deliverer of the commodity
279200210712      ** Nostro field blank
279300210712
279400210712     C     MGPSTM        IFEQ      00
279500210712     C                   ADD       1             X
279600210712     C     X             OCCUR     MULT
279700210712     C                   MOVE      ':87D:'       MTAG
279800210712     C                   MOVEL     'UNKNOWN'     MFLD
279900210712     C                   MOVE      'Y'           FLD57U            1
280000210712     C                   END
280100210712
280200210712      ** Field 87 Seq C is not UNKNOWN
280300210712
280400210712     C                   MOVE      'Y'           SEQ15C                                     MD033754
280500210712                                                                                            MD033754
280600210712     C     FLD87O        IFNE      'Y'
280700210712
280800210712      ** Field 86 and Field 87  intermediary and account with inst.
280900210712
281000210712     C                   MOVEL     '86'          @TAGI             2
281100210712     C                   MOVEL     '87'          @TAGD             2
281200210712     C                   EXSR      FMTX1
281300210712     C                   END
281400210712     C                   MOVE      'N'           FLD57U
281500210712
281600210712     C                   MOVE      *BLANK        ZDBEI
281700210712
281800210712     C/COPY WNCPYSRC,MG0600C008
281900210712
282000210712      ***2.*34P*Consideration                                                              AR1053647
282100210712      ** 2. 34R Consideration                                                              AR1053647
282200210712      ** ----------------------------
282300210712
282400210712      ***Field*:34P:*Value*date,*currency*code*and*the*consideration*paid*by*the*Sender    AR1053647
282500210712      ** Field :34R: Value date, currency code and the consideration paid by the Sender    AR1053647
282600210712
282700210712     C                   ADD       1             X
282800210712     C     X             OCCUR     MULT
282900210712
283000210712      ** Format value date to SWIFT standard
283100210712
283200210712     C     MGTTYP        IFEQ      'OP'
283300210712     C     COB           ANDEQ     'C'
283400210712     C                   MOVE      MGOTDT        ZMDAY
283500210712     C                   ELSE
283600210712     C     CWRD          IFEQ      'AMEND'
283700210712     C                   MOVE      BJRDNB        ZMDAY
283800210712     C                   ELSE
283900210712     C                   MOVE      MGVDAT        ZMDAY
284000210712     C                   ENDIF
284100210712     C                   ENDIF
284200210712     C                   CALL      'ZM0065'                             15
284300210712     C                   PARM                    ZMDAY             5 0
284400210712     C                   PARM                    ZSDAT1            6
284500210712     C                   PARM                    ZSDATC            8
284600210712
284700210712     C     *IN15         IFEQ      '1'
284800210712     C     *LOCK         IN        LDA
284900210712     C                   MOVE      '016'         DBASE
285000210712     C                   MOVEL     '       '     DBKEY
285100210712     C                   MOVEL     'ZM0065'      DBFILE
285200210712     C                   OUT       LDA
285300210712     C                   EXSR      *PSSR
285400210712     C                   ENDIF
285500210712
285600210712     C     X             OCCUR     MULT
285700210712     C**********         MOVE      MGSLCY        ZCCY                                       MD057682
285800210712     C**********         MOVE      MGSAMT        ZAMNT                                      MD057682
285900210712     C                   MOVE      MGPUCY        ZCCY                                       MD057682
286000210712     C                   MOVE      MGPAMT        ZAMNT                                      MD057682
286100210712
286200210712     C/COPY WNCPYSRC,MG0600C039
286300210712
286400210712     C                   CALL      'ZM0040'                             15
286500210712     C                   PARM                    ZAMNT            13 0
286600210712     C                   PARM                    ZCCY              3
286700210712     C                   PARM                    ZSAMN1           15
286800210712     C                   PARM                    ZSCCY1            3
286900210712     C                   PARM      ' '           ZERR              1
287000210712
287100210712     C     *IN15         IFEQ      '1'
287200210712     C     *LOCK         IN        LDA
287300210712     C                   MOVE      '019'         DBASE
287400210712     C                   MOVEL     '       '     DBKEY
287500210712     C                   MOVEL     'ZM0040'      DBFILE
287600210712     C                   OUT       LDA
287700210712     C                   EXSR      *PSSR
287800210712     C                   ENDIF
287900210712
288000210712      ** Error - indicate erroneous fields;
288100210712
288200210712     C     ZERR          IFEQ      '1'
288300210712     C                   MOVE      'Y'           @ERR
288400210712     C                   MOVE      MGSAMT        ZAMT
288500210712     C                   MOVE      MGSLCY        ZCCY
288600210712     C                   MOVEL     ERR3N         MFLD
288700210712     C                   MOVEL     MSGA(4)       MERR
288800210712
288900210712     C                   ELSE
289000210712     C**********         MOVE      ':34P:'       MTAG                                      AR1053647
289100210712     C                   MOVE      ':34R:'       MTAG                                      AR1053647
289200210712     C                   MOVEL     FLD3N         MFLD
289300210712     C                   END
289400210712
289500210712     C/COPY WNCPYSRC,MG0600C010
289600210712
289700210712      ***Field*:86a:*and*:87a:*Intermediary*and*Accnt*with*Institution                     AR1053647
289800210712      ** Field :56a: and :57a: Intermediary and Accnt with Institution                     AR1053647
289900210712      ** Nostro field blank
290000210712
290100210712     C                   ADD       1             X                                          MD057682
290200210712     C     X             OCCUR     MULT                                                     MD057682
290300210712     C                   MOVE      MGRSTM        @STM              2                        MD057682
290400210712     C     @STM          LOOKUP    TABNST                                 23                MD057682
290500210712                                                                                            MD057682
290600210712     C                   IF        MGRONS <> *BLANKS AND *IN23 = '1'                        MD057682
290700210712                                                                                            MD057682
290800210712      ** Use receipt settlement currency to access nostro if not blank.                     MD057682
290900210712      ** Otherwise, use purchase currency.                                                  MD057682
291000210712                                                                                            MD057682
291100210712     C                   IF        CEU003 = 'Y' AND MGRCCY <> *BLANKS                       MD057682
291200210712     C                   MOVE      MGRCCY        @NSKYB                                     MD057682
291300210712     C                   ELSE                                                               MD057682
291400210712     C                   MOVE      MGPUCY        @NSKYB                                     MD057682
291500210712     C                   ENDIF                                                              MD057682
291600210712                                                                                            MD057682
291700210712     C                   MOVEL     MGRONS        @NSKYE                                     MD057682
291800210712     C                   CALL      'AONOSTR1'                                               MD057682
291900210712     C                   PARM      '*MSG   '     @RTCD                                      MD057682
292000210712     C                   PARM      '*KEY   '     @OPTN                                      MD057682
292100210712     C                   PARM      *BLANKS       @NSKYA                                     MD057682
292200210712     C                   PARM                    @NSKYB                                     MD057682
292300210712     C                   PARM      *BLANKS       @NSKYC                                     MD057682
292400210712     C                   PARM      *BLANKS       @NSKYD                                     MD057682
292500210712     C                   PARM                    @NSKYE                                     MD057682
292600210712     C                   PARM      *BLANKS       @KEYF                                      MD057682
292700210712     C                   PARM      *BLANKS       @KEYG                                      MD057682
292800210712     C                   PARM      *BLANKS       @KEYH                                      MD057682
292900210712     C     SDNOST        PARM      SDNOST        DSSDY                                      MD057682
293000210712                                                                                            MD057682
293100210712     C                   IF        @RTCD <> *BLANKS                                         MD057682
293200210712     C                   MOVE      'Y'           @ERR                                       MD057682
293300210712     C                   MOVE      MGRONS        MFLD                                       MD057682
293400210712     C                   MOVEL     MSGA(3)       MERR                                       MD057682
293500210712     C                   MOVE      ':57 :'       MTAG                                       MD057682
293600210712     C                   ELSE                                                               MD057682
293700210712                                                                                            MD057682
293800210712      ** If CDL094 is On and Delivery Agent details have been defined for                   MD057682
293900210712      ** the Nostro, use these and not the Customer of the Nostro details                   MD057682
294000210712     C                   IF        CDL094 = 'Y' AND A7RF57 <> *BLANKS                       MD057682
294100210712                                                                                            MD057682
294200210712      ** If SWIFT BIC defined as the Delivery Agent then obtain related                     MD057682
294300210712      ** customer number                                                                    MD057682
294400210712     C                   MOVE      *IN80         IN80              1                        MD057682
294500210712     C                   MOVEL     A7RF57        WSWID            12                        MD057682
294600210712     C     WSWID         CHAIN     SDCUSTL7                           80                    MD057682
294700210712     C                   IF        *IN80 = *OFF                                             MD057682
294800210712     C                   MOVEL     *BLANKS       ZDEST                                      MD057682
294900210712     C                   MOVEL     BBCUST        ZDEST                                      MD057682
295000210712     C                   ELSE                                                               MD057682
295100210712     C                   MOVEL     *BLANKS       ZDEST                                      MD057682
295200210712     C                   MOVEL     A7RF57        ZDEST                                      MD057682
295300210712     C                   ENDIF                                                              MD057682
295400210712     C                   MOVEL     *BLANKS       ACLINE                                     MD057682
295500210712     C                   MOVEL     A7RA57        ACLINE                                     MD057682
295600210712     C                   MOVE      IN80          *IN80                                      MD057682
295700210712                                                                                            MD057682
295800210712     C                   ELSE                                                               MD057682
295900210712     C                   MOVEL     *BLANKS       ZDEST                                      MD057682
296000210712     C                   MOVEL     A7CUST        ZDEST                                      MD057682
296100210712     C                   MOVEL     *BLANKS       ACLINE                                     MD057682
296200210712     C                   MOVE      *BLANKS       @OANN            36                        MD057682
296300210712     C                   IF        A7OACN <> *BLANKS                                        MD057682
296400210712     C                   MOVE      A7OACN        @OANN                                      MD057682
296500210712     C                   MOVEL     '/'           @OANN                                      MD057682
296600210712     C                   ENDIF                                                              MD057682
296700210712     C                   MOVEL     @OANN         ACLINE                                     MD057682
296800210712     C                   ENDIF                                                              MD057682
296900210712     C                   MOVE      ' '           TAG                                        MD057682
297000210712     C                   MOVE      '57'          FLDNO                                      MD057682
297100210712     C                   MOVE      NETBY         CKNETI            1                        MD057682
297200210712     C                   EXSR      FSWAD                                                    MD057682
297300210712     C                   ENDIF                                                              MD057682
297400210712                                                                                            MD057682
297500210712      ** Our receive nostro is blank or settlement internal                                 MD057682
297600210712     C                   ELSE                                                               MD057682
297700210712      ** Test if settlement internal                                                        MD057682
297800210712     C                   MOVE      MGRSTM        @STM                                       MD057682
297900210712     C     @STM          LOOKUP    TABINT                                 23                MD057682
298000210712                                                                                            MD057682
298100210712     C                   IF        *IN23 = '1'                                              MD057682
298200210712     C                   MOVE      *BLANKS       ZDEST                                      MD057682
298300210712     C                   MOVEL     SECN          ZDEST                                      MD057682
298400210712     C                   MOVEL     *BLANKS       ACLINE                                     MD057682
298500210712     C                   MOVE      ' '           TAG                                        MD057682
298600210712     C                   MOVE      '57'          FLDNO                                      MD057682
298700210712     C                   MOVE      NETBY         CKNETI                                     MD057682
298800210712     C                   EXSR      FSWAD                                                    MD057682
298900210712                                                                                            MD057682
299000210712     C                   ELSE                                                               MD057682
299100210712                                                                                            MD057682
299200210712     C                   IF        CSW221 = 'Y'                                             MD057682
299300210712     C                   MOVE      ':57J:'       MTAG                                       MD057682
299400210712                                                                                            MD057682
299500210712     C                   IF        NETBY <> 'Y'                                             MD057682
299600210712     C                   MOVEL     NOSTXU        MFLD                                       MD057682
299700210712     C                   ELSE                                                               MD057682
299800210712     C                   MOVEL     NOSTXN        MFLD                                       MD057682
299900210712     C                   ENDIF                                                              MD057682
300000210712                                                                                            MD057682
300100210712     C                   ELSE                                                               MD057682
300200210712     C                   MOVE      ':57D:'       MTAG                                       MD057682
300300210712                                                                                            MD057682
300400210712      ** If BUY NET deal set MFLD to 'TO BE NETTED'                                         MD057682
300500210712     C                   IF        NETBY <> 'Y'                                             MD057682
300600210712     C                   MOVEL     'UNKNOWN'     MFLD                                       MD057682
300700210712     C                   ELSE                                                               MD057682
300800210712     C                   MOVEL     NETTXT        MFLD                                       MD057682
300900210712     C                   ENDIF                                                              MD057682
301000210712     C                   ENDIF                                                              MD057682
301100210712     C                   ENDIF                                                              MD057682
301200210712     C                   ENDIF                                                              MD057682
301300210712      *                                                                                     MD057682
301400210712     C*****MGPSTM        IFEQ      00                                                       MD057682
301500210712     C**********         ADD       1             X                                          MD057682
301600210712     C*****X****         OCCUR     MULT                                                     MD057682
301700210712     C**********         IF        CSW221 = 'Y'                                    MD055694 MD057682
301800210712     C**********         MOVE      ':57J:'       MTAG                              MD055694 MD057682
301900210712     C**********         MOVEL     NOSTXU        MFLD                              MD055694 MD057682
302000210712     C**********         ELSE                                                      MD055694 MD057682
302100210712     C**********         MOVE      ':57D:'       MTAG                                       MD057682
302200210712     C**********         MOVEL     'UNKNOWN'     MFLD                                       MD057682
302300210712     C**********         ENDIF                                                     MD055694 MD057682
302400210712     C**********         MOVE      'Y'           FLD57U            1                        MD057682
302500210712     C**********         END                                                                MD057682
302600210712
302700210712      ** Field 57 Seq C is not UNKNOWN
302800210712
302900210712     C*****FLD57U        IFNE      'Y'                                                      MD057682
303000210712
303100210712      ***Field*86*and*Field*87**intermediary*and*account*with inst.                        AR1053647
303200210712      ** Field 56 and Field 57 intermediary and account with inst.                         AR1053647
303300210712
303400210712     C**********         MOVEL     '56'          @TAGI                            AR1053647 MD057682
303500210712     C**********         MOVEL     '57'          @TAGD                            AR1053647 MD057682
303600210712     C**********         EXSR      FMTX1                                                    MD057682
303700210712     C**********         END                                                                MD057682
303800210712     C**********         MOVE      'N'           FLD57U                                     MD057682
303900210712
304000210712     C**********         MOVE      *BLANK        ZDBEI                                      MD057682
304100210712
304200210712     C/COPY WNCPYSRC,MG0600C033
304300210712
304400210712     C                   ENDSR
304500210712      *****************************************************************
304600210712     C/EJECT
304700210712      *****************************************************************
304800210712      *                                                               *
304900210712      *   SRCODE - Calculate codework                                 *
305000210712      *                                                               *
305100210712      *****************************************************************
305200210712      *
305300210712     C     SRCODE        BEGSR
305400210712
305500210712     C                   MOVE      *BLANKS       PRNOUT            4
305600210712     C                   MOVE      *BLANKS       CODEWD
305700210712
305800210712      ** Determine the state of the pay side of the transaction
305900210712
306000210712     C                   EXSR      SRPAYE
306100210712
306200210712      ** Pay field 87 & Rec our-nostro are BOTH not blank
306300210712
306400210712     C     PAY87         IFNE      *BLANK
306500210712     C     MGRONS        ANDNE     *BLANK
306600210712     C                   MOVE      'BOTH'        PRNOST            4
306700210712     C                   ENDIF
306800210712
306900210712      ** pay field 87 & rec our-nostro; Both blank/One blank
307000210712
307100210712     C     PAY87         IFEQ      *BLANK
307200210712     C     MGRONS        OREQ      *BLANK
307300210712     C                   MOVE      'B/O '        PRNOST
307400210712     C                   ENDIF
307500210712
307600210712      ** If sequence number zero (NEW message)
307700210712
307800210712     C     MGLSWC        IFEQ      0
307900210712     C                   MOVEL     'NEW'         CWRD
308000210712
308100210712      ** If both our-nostro fields non-blank the 87 fields are Known
308200210712
308300210712     C     PRNOST        IFEQ      'BOTH'
308400210712     C                   MOVE      'K'           F57U
308500210712
308600210712      ** Both or one our-nostro field(s) are blank, Unknown
308700210712
308800210712     C                   ELSE
308900210712     C                   MOVE      'U'           F57U
309000210712     C                   ENDIF
309100210712
309200210712      **  For SWIFT Changes 1996, the two new tables TABS96 and
309300210712      **  TABR96 are used to create the CONDITION and RESULT,
309400210712      **  as shown in the table below.  The position of the
309500210712      **  ONDITION on TABS96, is the same equivalent position
309600210712      **  for the RESULT on TABR96.  Hence when a LOKUP is performed
309700210712      **  on TABS96, using the CONDITION as the key, the equivalent
309800210712      **  positional RESULT value is placed in TABR96.
309900210712
310000210712      **  To retrieve the first 3 fields for the CONDITION, the
310100210712      **  last confrimation created for the Transaction number
310200210712      **  is accessed.
310300210712      **  <----------------CONDITION------------------->  <--RESULT-->
310400210712      **  Status   Old Code  Old F57U  Rec Our-Nostro     Code     F57U
310500210712      **           LF/MGOREFL0         Pay Our-Nostro
310600210712      **  ----------------------------------------------------------------
310700210712      **      No record found          Both non-blank     AMEND     K
310800210712      **      No record found          One or both blank  AMEND     U
310900210712      **  NONREC   NEW          U      Both non-blank     NEW       K
311000210712      **  NONREC   NEW          U      One or both blank  NEW       U
311100210712      **  NONREC   NEW          K      Both non-blank     NEW       K
311200210712      **  NONREC   NEW          K      One or both blank  NEW       K
311300210712      **  SENT     NEW          U      Both non-blank     AMEND     K
311400210712      **  SENT     NEW          U      One or both blank  AMEND     U
311500210712      **  SENT     NEW          K      Both non-blank     AMEND     K
311600210712      **  SENT     NEW          K      One or both blank  AMEND     K
311700210712      **  NONREC   AMEND        U      Both non-blank     AMEND     K
311800210712      **  NONREC   AMEND        U      One or both blank  AMEND     U
311900210712      **  NONREC   AMEND        K      Both non-blank     AMEND     K
312000210712      **  NONREC   AMEND        K      One or both blank  AMEND     K
312100210712      **  SENT     AMEND        U      Both non-blank     AMEND     K
312200210712      **  SENT     AMEND        U      One or both blank  AMEND     U
312300210712      **  SENT     AMEND        K      Both non-blank     AMEND     K
312400210712      **  SENT     AMEND        K      One or both blank  AMEND     K
312500210712
312600210712     C                   ELSE
312700210712     C                   MOVE      *BLANKS       SEARCH
312800210712
312900210712      ** Retrieve last confirmation for this tranaction number
313000210712
313100210712     C     MGACMI        IFEQ      'Y'                                                      MD022425
313200210712     C**********         ADD       1             MGLSWC                            MD022425 MD024078
313300210712     C                   MOVE      MGLSWC        @TRN41                                     MD022425
313400210712     C                   ELSE                                                               MD022425
313500210712     C                   MOVE      MGLSWC        @TR3
313600210712     C                   ENDIF                                                              MD022425
313700210712     C     @TRN          CHAIN     MGREFL0                            10
313800210712
313900210712      ** If a message found build the selection key
314000210712
314100210712     C     *IN10         IFEQ      '0'
314200210712
314300210712     C     MMGSG         IFEQ      '2'
314400210712     C     MMGSG         OREQ      '3'
314500210712     C                   MOVEL     'SENT'        @MGST
314600210712     C                   ELSE
314700210712     C                   MOVEL     'NONREC'      @MGST
314800210712     C                   ENDIF
314900210712
315000210712     C                   MOVEL     MLSCC         @LSCC
315100210712     C                   MOVE      MF57U         @OF87
315200210712     C                   MOVE      MCLSS         WCLSS             1
315300210712     C                   ENDIF
315400210712     C                   MOVE      PRNOST        @NOST
315500210712
315600210712      ** Use select table to point to the result table
315700210712
315800210712     C     SEARCH        LOOKUP    TABS96        TABR96                   22
315900210712
316000210712      ** Key matches select table, outputs the corresponding
316100210712      ** result table value to 'TABR96'
316200210712
316300210712     C     *IN22         IFEQ      '1'
316400210712
316500210712     C                   MOVE      TABR96        CODEWD
316600210712
316700210712     C                   ELSE
316800210712     C                   MOVEL     'AMEND   '    CWRD
316900210712     C                   ENDIF
317000210712
317100210712     C                   ENDIF
317200210712
317300210712     C                   ENDSR
317400210712      *****************************************************************
317500210712     C/EJECT
317600210712      *****************************************************************
317700210712      *                                                               *
317800210712      *   SRPAYE - Pay side field 87 (KNOWN or UNKNOWN)               *
317900210712      *                                                               *
318000210712      *****************************************************************
318100210712     C     SRPAYE        BEGSR
318200210712
318300210712     C                   MOVE      *BLANKS       PAY87             5
318400210712
318500210712      ** Known when settlement via nostro (MGAWBN is blank)
318600210712
318700210712     C     MGPSTM        IFEQ      02
318800210712     C     MGPSTM        OREQ      12
318900210712     C                   MOVE      'KNOWN'       PAY87
319000210712     C                   ENDIF
319100210712
319200210712      ** Known when settlement internal (branch internal customer)
319300210712
319400210712     C                   MOVE      MGPSTM        @STM              2
319500210712     C     @STM          LOOKUP    TABINT                                 23
319600210712     C     *IN23         IFEQ      '1'
319700210712     C                   MOVE      'KNOWN'       PAY87
319800210712     C                   ENDIF
319900210712
320000210712      ** Known when settlement via nostro and MGAWBN entered
320100210712
320200210712     C     MGPSTM        IFEQ      01
320300210712     C     MGPSTM        OREQ      07
320400210712     C     MGPSTM        OREQ      08
320500210712     C     MGAWBN        IFNE      *BLANKS
320600210712     C     MGAWBN        OREQ      *BLANKS
320700210712     C     AWBA6         ANDEQ     'DIRECT'
320800210712     C                   MOVE      'KNOWN'       PAY87
320900210712     C                   ENDIF
321000210712     C                   ENDIF
321100210712
321200210712      ** Unknown when settlement internal
321300210712
321400210712     C     MGPSTM        IFEQ      00
321500210712     C                   MOVE      *BLANKS       PAY87
321600210712     C                   ENDIF
321700210712
321800210712     C                   ENDSR
321900210712      *****************************************************************
322000210712     C/EJECT
322100210712      *****************************************************************
322200210712      *                                                               *
322300210712      *   FSWAD - Format SWIFT address                                *
322400210712      *                                                               *
322500210712      *****************************************************************
322600210712     C     FSWAD         BEGSR
322700210712
322800210712      ** If NET deal set MFLD to 'TO BE NETTED'
322900210712
323000210712     C     CKNETI        IFEQ      'Y'
323100210712     C     FLDNO         ANDEQ     '87'
323200210712     C                   MOVEL     NETTXT        MFLD
323300210712     C                   MOVE      'D'           TAG
323400210712     C                   MOVE      @MTAG         MTAG
323500210712     C                   ELSE
323600210712     C                   CALL      'ZM0050'                             15
323700210712     C                   PARM                    ZDEST            12
323800210712     C                   PARM                    ZSADD1           35
323900210712     C                   PARM                    ZSADD2           35
324000210712     C                   PARM                    ZSADD3           35
324100210712     C                   PARM                    ZSADD4           35
324200210712     C                   PARM                    ZSTAG             1
324300210712     C                   PARM                    ZSTYPE            1
324400210712     C                   PARM      ' '           ZERR              1
324500210712     C                   PARM      'Y'           ZDBEI             1
324600210712
324700210712     C     *IN15         IFEQ      '1'
324800210712     C     *LOCK         IN        LDA
324900210712     C                   MOVE      '021'         DBASE
325000210712     C                   MOVEL     '       '     DBKEY
325100210712     C                   MOVEL     'ZM0050'      DBFILE
325200210712     C                   OUT       LDA
325300210712     C                   EXSR      *PSSR
325400210712     C                   ENDIF
325500210712
325600210712      **  Error ?
325700210712
325800210712     C     ZERR          IFEQ      '1'
325900210712     C                   MOVE      'Y'           @ERR
326000210712     C                   MOVE      ZSTAG         TAG
326100210712     C                   MOVE      @MTAG         MTAG
326200210712     C                   MOVEL     ZDEST         MFLD
326300210712     C                   MOVEL     MSGA(6)       MERR
326400210712     C                   ELSE
326500210712
326600210712      ** Address 1
326700210712
326800210712     C     ACLINE        IFNE      *BLANKS
326900210712     C                   MOVEL     ACLINE        MFLD
327000210712     C                   ELSE
327100210712     C                   MOVEL     ZSADD1        MFLD
327200210712     C                   ENDIF
327300210712
327400210712      ** SWIFT address;  Else full address
327500210712
327600210712     C     ZSTAG         IFEQ      'A'
327700210712
327800210712     C/COPY WNCPYSRC,MG0600C045
327900210712
328000210712     C                   MOVE      'A'           TAG
328100210712     C                   MOVE      @MTAG         MTAG
328200210712     C                   MOVE      *BLANKS       SAVMTG            5
328300210712
328400210712     C/COPY WNCPYSRC,MG0600C046
328500210712
328600210712     C     ACLINE        IFNE      *BLANKS
328700210712     C                   MOVE      MTAG          SAVMTG
328800210712     C                   ADD       1             X
328900210712     C     X             OCCUR     MULT
329000210712     C                   MOVEL     ZSADD1        MFLD
329100210712     C                   ENDIF
329200210712     C                   EXSR      SEXTN
329300210712
329400210712     C/COPY WNCPYSRC,MG0600C016
329500210712
329600210712     C                   ELSE
329700210712
329800210712     C/COPY WNCPYSRC,MG0600C047
329900210712
330000210712      ** If SWIFT 2021 is installed, tag D should be replaced by tag J.                     MD055694
330100210712      ** This is true for tags 82, 87, 83, 53, 56, 57                                       MD055694
330200210712                                                                                            MD055694
330300210712     C                   IF        CSW221 = 'Y' AND                                         MD055694
330400210712     C                             (FLDNO = '82'                                            MD055694
330500210712     C                              OR FLDNO = '83'                                         MD055694
330600210712     C                              OR FLDNO = '87' AND W87SEQA = 'Y'                       MD055694
330700210712     C                              OR FLDNO = '53'                                         MD055694
330800210712     C                              OR FLDNO = '56'                                         MD055694
330900210712     C                              OR FLDNO = '57')                                        MD055694
331000210712                                                                                            MD055694
331100210712     C                   EXSR      SRFMTJ                                                   MD055694
331200210712                                                                                            MD055694
331300210712     C                   ELSE                                                               MD055694
331400210712                                                                                            MD055694
331500210712     C                   MOVE      'D'           TAG
331600210712     C                   MOVE      @MTAG         MTAG
331700210712
331800210712     C/COPY WNCPYSRC,MG0600C048
331900210712
332000210712     C     ACLINE        IFNE      *BLANKS
332100210712     C                   ADD       1             X
332200210712     C     X             OCCUR     MULT
332300210712     C                   MOVEL     ZSADD1        MFLD
332400210712     C                   ENDIF
332500210712
332600210712      ** Address 2
332700210712
332800210712     C     ZSADD2        IFNE      *BLANKS
332900210712     C                   ADD       1             X
333000210712     C     X             OCCUR     MULT
333100210712     C                   MOVEL     ZSADD2        MFLD
333200210712     C                   ENDIF
333300210712
333400210712      ** Address 3
333500210712
333600210712     C     ZSADD3        IFNE      *BLANKS
333700210712     C                   ADD       1             X
333800210712     C     X             OCCUR     MULT
333900210712     C                   MOVEL     ZSADD3        MFLD
334000210712     C                   ENDIF
334100210712
334200210712      ** Address 4
334300210712
334400210712     C     ZSADD4        IFNE      *BLANKS
334500210712     C                   ADD       1             X
334600210712     C     X             OCCUR     MULT
334700210712     C                   MOVEL     ZSADD4        MFLD
334800210712     C                   ENDIF
334900210712     C                   ENDIF                                                              MD055694
335000210712     C                   ENDIF
335100210712
335200210712     C                   ENDIF
335300210712     C                   ENDIF
335400210712
335500210712     C/COPY WNCPYSRC,MG0600C017
335600210712
335700210712     C                   ENDSR
335800210712      *****************************************************************
335900210712      /EJECT
336000210712      *****************************************************************
336100210712      *                                                               *
336200210712      *   SEXTN - Store customer with SWIFT address to data structure *
336300210712      *                                                               *
336400210712      *   Called by: FSWAD, FMT53, FMT83                              *
336500210712      *   Calls    : None                                             *
336600210712      *                                                               *
336700210712      *****************************************************************
336800210712     C     SEXTN         BEGSR
336900210712
337000210712     C     SAVMTG        IFNE      *BLANKS
337100210712     C                   MOVE      SAVMTG        @MTG
337200210712     C                   ELSE
337300210712     C                   MOVEL     MTAG          @MTG
337400210712     C                   ENDIF
337500210712     C     FLDTYP        IFEQ      '5'
337600210712     C     FLDTAG        ANDEQ     'A'
337700210712     C     FLDTYP        OREQ      '8'
337800210712     C     FLDTAG        ANDEQ     'A'
337900210712     C                   ADD       1             V
338000210712     C     V             OCCUR     EXTN
338100210712     C                   Z-ADD     X             MPSN
338200210712     C                   MOVEL     @MTG          MTG
338300210712     C                   MOVEL     ZDEST         MCSI
338400210712     C                   ENDIF
338500210712
338600210712     C     SEXT9         ENDSR
338700210712      *****************************************************************
338800210712     C/EJECT
338900210712      *****************************************************************
339000210712      *                                                               *
339100210712      *   FMT83 - Format Field 83 address   - Sequence A              *
339200210712      *   Called by   SRFMTA  Format message details Sequence A       *
339300210712      *                                                               *
339400210712      *****************************************************************
339500210712     C     FMT83         BEGSR
339600210712
339700210712     C**********         Z-ADD     0             WFLD83            6 0                      MD026953
339800210712     C                   MOVEL     *BLANKS       WFLD83            6                        MD026953
339900210712     C                   Z-ADD     0             WBCUST            6 0
340000210712     C                   MOVE      *BLANKS       BBCUST
340100210712
340200210712     C     CSW024        IFEQ      'Y'
340300210712     C     DSFUND        ANDNE     *BLANK
340400210712     C                   ADD       1             X
340500210712     C     X             OCCUR     MULT
340600210712     C     CSW221        IFEQ      'Y'                                                      MD055694
340700210712     C     '/':WS        XLATE     DSFUND        DSFUND                                     MD055694
340800210712     C                   ENDIF                                                              MD055694
340900210712     C     '/NAME/'      CAT       DSFUND        MFLD
341000210712     C                   MOVE      ':83J:'       MTAG
341100210712
341200210712     C                   ELSE
341300210712
341400210712      ** Access customer file for Beneficiary Customer Number
341500210712
341600210712     C     MGBENN        IFNE      *BLANKS
341700210712     C**********         CALL      'AOCUSTR0'                                               MD055694
341800210712     C                   CALL      'AOCUSTR1'                                               MD055694
341900210712     C                   PARM      '*MSG   '     @RTCD
342000210712     C                   PARM      '*KEY   '     @OPTN
342100210712
342200210712     C/COPY WNCPYSRC,MG0600C030
342300210712
342400210712     C                   PARM      MGBENN        @KEY2            10
342500210712
342600210712     C/COPY WNCPYSRC,MG0600C031
342700210712
342800210712     C                   PARM      *BLANKS       @KYST             7
342900210712     C*****SDCUST        PARM      SDCUST        DSSDY                                      MD055694
343000210712     C     SDCUST        PARM      SDCUST        DSLDY                                      MD055694
343100210712
343200210712      ** Customer Not found on SDCUSTPD, check the counterparty
343300210712      ** Nostro file.
343400210712
343500210712     C     @RTCD         IFNE      *BLANKS
343600210712     C                   CALL      'AOCNSTR0'
343700210712     C                   PARM      *BLANKS       @RTCD             7
343800210712     C                   PARM      '*KEY'        @OPTN             7
343900210712     C                   PARM      MGBENN        @CNCD             8
344000210712     C     SDCNST        PARM      SDCNST        DSFDY
344100210712
344200210712      ** Customer record not found - database error
344300210712
344400210712     C     @RTCD         IFNE      *BLANKS
344500210712     C     *LOCK         IN        LDA
344600210712     C                   MOVE      '022'         DBASE
344700210712     C                   MOVEL     MGBENN        DBKEY
344800210712     C                   MOVEL     'SDCUSTPD'    DBFILE
344900210712     C                   OUT       LDA
345000210712     C                   EXSR      *PSSR
345100210712     C                   ELSE
345200210712     C                   Z-ADD     999999        WBCUST
345300210712     C                   ENDIF
345400210712     C                   ELSE
345500210712     C                   MOVE      BBCUST        WBCUST
345600210712     C                   ENDIF
345700210712     C                   ENDIF
345800210712
345900210712      ** Output this field only if Pay Ordering Bank/Customer
346000210712      ** is not the same as Sender, Receiver and Beneficiary
346100210712      ** Also, Pay Ordering Customer/Bank must have SWIFT address.
346200210712
346300210712     C*****MGPOBN        IFNE      *ZERO                                                   AR1094963
346400210712     C*****MGPOBN        ANDNE     WBICN                                                   AR1094963
346500210712     C*****MGPOBN        ANDNE     MGCNUM                                                  AR1094963
346600210712     C*****MGPOBN        ANDNE     WBCUST                                                  AR1094963
346700210712     C**********         Z-ADD     MGPOBN        WFLD83                                    AR1094963
346800210712     C**********         ENDIF                                                             AR1094963
346900210712      *                                                                                    AR1094963
347000210712     C**********         IF        MGPOBN <> *ZERO AND MGPOBN <> %CHAR(WBICN)    AR1094963 AR1097109
347100210712     C**********         IF        MGPOBN <> *BLANKS AND MGPOBN <> %CHAR(WBICN)   AR1097109 MD035515
347200210712     C                   IF        MGPOBN <> *BLANKS AND MGPOBN <> WBICN                    MD035515
347300210712     C                             AND MGPOBN <> MGCNUM                                    AR1094963
347400210712     C                             AND MGPOBN <> %CHAR(WBCUST)                             AR1094963
347500210712     C**********         EVAL      WFLD83 = %DEC(MGPOBN:6:0)                      AR1094963 MD026953
347600210712     C                   EVAL      WFLD83 = MGPOBN                                          MD026953
347700210712     C                   ENDIF                                                             AR1094963
347800210712
347900210712     C*****MGPOCN        IFNE      *ZERO                                                   AR1094963
348000210712     C*****MGPOCN        ANDNE     WBICN                                                   AR1094963
348100210712     C*****MGPOCN        ANDNE     MGCNUM                                                  AR1094963
348200210712     C*****MGPOCN        ANDNE     WBCUST                                                  AR1094963
348300210712     C**********         Z-ADD     MGPOCN        WFLD83                                    AR1094963
348400210712     C**********         ENDIF                                                             AR1094963
348500210712      *                                                                                    AR1094963
348600210712     C**********         IF        MGPOCN <> *ZERO AND MGPOCN <> %CHAR(WBICN)    AR1094963 AR1097406
348700210712     C**********         IF        MGPOCN <> *BLANKS AND MGPOCN <> %CHAR(WBICN)   AR1097406 MD035515
348800210712     C                   IF        MGPOCN <> *BLANKS AND MGPOCN <> WBICN                    MD035515
348900210712     C                             AND MGPOCN <> MGCNUM                                    AR1094963
349000210712     C                             AND MGPOCN <> %CHAR(WBCUST)                             AR1094963
349100210712     C**********         EVAL      WFLD83 = %DEC(MGPOCN:6:0)                      AR1094963 MD026953
349200210712     C                   EVAL      WFLD83 = MGPOCN                                          MD026953
349300210712     C                   ENDIF                                                             AR1094963
349400210712
349500210712     C*****WFLD83        IFNE      *ZERO                                                    MD026953
349600210712     C     WFLD83        IFNE      *BLANKS                                                  MD026953
349700210712     C                   MOVE      *BLANKS       ZDEST
349800210712     C                   MOVEL     WFLD83        ZDEST
349900210712
350000210712     C                   CALL      'ZM0050'                             15
350100210712     C                   PARM                    ZDEST            12
350200210712     C                   PARM                    ZSADD1           35
350300210712     C                   PARM                    ZSADD2           35
350400210712     C                   PARM                    ZSADD3           35
350500210712     C                   PARM                    ZSADD4           35
350600210712     C                   PARM                    ZSTAG             1
350700210712     C                   PARM                    ZSTYPE            1
350800210712     C                   PARM      ' '           ZERR              1
350900210712     C                   PARM                    ZDBEI             1
351000210712
351100210712     C     *IN15         IFEQ      '1'
351200210712     C     *LOCK         IN        LDA
351300210712     C                   MOVE      '023'         DBASE
351400210712     C                   MOVEL     '       '     DBKEY
351500210712     C                   MOVEL     'ZM0050'      DBFILE
351600210712     C                   OUT       LDA
351700210712     C                   EXSR      *PSSR
351800210712     C                   ENDIF
351900210712
352000210712      ** Error ?
352100210712
352200210712     C     ZERR          IFEQ      '1'
352300210712     C                   MOVE      'Y'           @ERR
352400210712     C                   MOVE      ZSTAG         TAG
352500210712     C                   MOVE      @MTAG         MTAG
352600210712     C                   MOVEL     ZDEST         MFLD
352700210712     C                   MOVEL     MSGA(6)       MERR
352800210712
352900210712     C                   ELSE
353000210712
353100210712      ** Output only if with SWIFT address.
353200210712
353300210712     C     ZSTAG         IFEQ      'A'
353400210712     C                   ADD       1             X
353500210712     C     X             OCCUR     MULT
353600210712     C                   MOVE      *BLANKS       ACLINE
353700210712     C                   MOVE      ' '           TAG
353800210712     C                   MOVE      '83'          FLDNO
353900210712     C                   MOVE      'A'           TAG
354000210712     C                   MOVE      @MTAG         MTAG
354100210712
354200210712      ** Address 1
354300210712
354400210712     C                   MOVE      *BLANKS       SAVMTG            5
354500210712     C     ACLINE        IFNE      *BLANKS
354600210712     C                   MOVE      MTAG          SAVMTG
354700210712     C                   MOVEL     ACLINE        MFLD
354800210712     C                   ADD       1             X
354900210712     C     X             OCCUR     MULT
355000210712     C                   MOVEL     ZSADD1        MFLD
355100210712     C                   ELSE
355200210712     C                   MOVEL     ZSADD1        MFLD
355300210712     C                   ENDIF
355400210712                                                                                            MD055694
355500210712     C                   ELSE                                                               MD055694
355600210712     C                   IF        CSW024 = 'Y' AND DSCORP = 'Y'                            MD055694
355700210712                                                                                            MD055694
355800210712     C                   IF        CSW221 = 'Y'                                             MD055694
355900210712     C                   MOVEA     D83CDE        AR8XJ                                      MD055694
356000210712     C                   EXSR      SWF8XJ                                                   MD055694
356100210712     C                   MOVEA     AN8X          D83CDE                                     MD055694
356200210712     C                   ENDIF                                                              MD055694
356300210712                                                                                            MD055694
356400210712     C                   IF        D83CDE <> *BLANKS AND CSW221 = 'N'                       MD055694
356500210712     C                             OR D83CDE <> *BLANKS AND CSW221 = 'Y'                    MD055694
356600210712     C                                AND WOUT8X = 'Y'                                      MD055694
356700210712     C                   EVAL      WOUT8X = 'Y'                                             MD055694
356800210712     C                   MOVE      *BLANK        DN83              1                        MD055694
356900210712     C                   IF        BBRI01 <> *BLANK                                         MD055694
357000210712     C                   ADD       1             X                                          MD055694
357100210712     C     X             OCCUR     MULT                                                     MD055694
357200210712     C                   IF        DN83 <> 'Y'                                              MD055694
357300210712     C                   MOVE      ':83J:'       MTAG                                       MD055694
357400210712     C                   MOVE      'Y'           DN83                                       MD055694
357500210712     C                   ENDIF                                                              MD055694
357600210712     C                   MOVEL     *BLANK        MFLD                                       MD055694
357700210712     C                   MOVEL     BBRI01        MFLD                                       MD055694
357800210712     C                   ENDIF                                                              MD055694
357900210712     C                   IF        BBRI02 <> *BLANK                                         MD055694
358000210712     C                   ADD       1             X                                          MD055694
358100210712     C     X             OCCUR     MULT                                                     MD055694
358200210712     C                   IF        DN83 <> 'Y'                                              MD055694
358300210712     C                   MOVE      ':83J:'       MTAG                                       MD055694
358400210712     C                   MOVE      'Y'           DN83                                       MD055694
358500210712     C                   ENDIF                                                              MD055694
358600210712     C                   MOVE      *BLANK        MFLD                                       MD055694
358700210712     C                   MOVEL     BBRI02        MFLD                                       MD055694
358800210712     C                   ENDIF                                                              MD055694
358900210712     C                   IF        BBRI03 <> *BLANK                                         MD055694
359000210712     C                   ADD       1             X                                          MD055694
359100210712     C     X             OCCUR     MULT                                                     MD055694
359200210712     C                   IF        DN83 <> 'Y'                                              MD055694
359300210712     C                   MOVE      ':83J:'       MTAG                                       MD055694
359400210712     C                   MOVE      'Y'           DN83                                       MD055694
359500210712     C                   ENDIF                                                              MD055694
359600210712     C                   MOVE      *BLANK        MFLD                                       MD055694
359700210712     C                   MOVEL     BBRI03        MFLD                                       MD055694
359800210712     C                   ENDIF                                                              MD055694
359900210712     C                   IF        BBRI04 <> *BLANK                                         MD055694
360000210712     C                   ADD       1             X                                          MD055694
360100210712     C     X             OCCUR     MULT                                                     MD055694
360200210712     C                   IF        DN83 <> 'Y'                                              MD055694
360300210712     C                   MOVE      ':83J:'       MTAG                                       MD055694
360400210712     C                   MOVE      'Y'           DN83                                       MD055694
360500210712     C                   ENDIF                                                              MD055694
360600210712     C                   MOVE      *BLANK        MFLD                                       MD055694
360700210712     C                   MOVEL     BBRI04        MFLD                                       MD055694
360800210712     C                   ENDIF                                                              MD055694
360900210712     C                   IF        BBRI05 <> *BLANK                                         MD055694
361000210712     C                   ADD       1             X                                          MD055694
361100210712     C     X             OCCUR     MULT                                                     MD055694
361200210712     C                   IF        DN83 <> 'Y'                                              MD055694
361300210712     C                   MOVE      ':83J:'       MTAG                                       MD055694
361400210712     C                   MOVE      'Y'           DN83                                       MD055694
361500210712     C                   ENDIF                                                              MD055694
361600210712     C                   MOVE      *BLANK        MFLD                                       MD055694
361700210712     C                   MOVEL     BBRI05        MFLD                                       MD055694
361800210712     C                   ENDIF                                                              MD055694
361900210712     C                   ENDIF                                                              MD055694
362000210712     C                   ENDIF                                                              MD055694
362100210712                                                                                            MD055694
362200210712      ** If CSW221 is ON and tag is format D, process SWIFT 2020 J format                   MD055694
362300210712                                                                                            MD055694
362400210712     C                   IF        WOUT8X <> 'Y' AND ZSTAG = 'D'                            MD055694
362500210712     C                   IF        CSW221 = 'Y'                                             MD055694
362600210712     C                   ADD       1             X                                          MD055694
362700210712     C     X             OCCUR     MULT                                                     MD055694
362800210712     C                   MOVE      *BLANKS       ACLINE                                     MD055694
362900210712     C                   MOVE      '83'          FLDNO                                      MD055694
363000210712     C                   EXSR      SRFMTJ                                                   MD055694
363100210712                                                                                            MD055694
363200210712     C                   ELSE                                                               MD055694
363300210712     C                   ADD       1             X                                          MD055694
363400210712     C     X             OCCUR     MULT                                                     MD055694
363500210712     C                   MOVE      *BLANKS       ACLINE                                     MD055694
363600210712     C                   MOVE      ' '           TAG                                        MD055694
363700210712     C                   MOVE      '83'          FLDNO                                      MD055694
363800210712     C                   MOVE      'D'           TAG                                        MD055694
363900210712     C                   MOVE      @MTAG         MTAG                                       MD055694
364000210712                                                                                            MD055694
364100210712      ** Address 1                                                                          MD055694
364200210712                                                                                            MD055694
364300210712     C                   MOVE      *BLANKS       SAVMTG            5                        MD055694
364400210712     C     ACLINE        IFNE      *BLANKS                                                  MD055694
364500210712     C                   MOVE      MTAG          SAVMTG                                     MD055694
364600210712     C                   MOVEL     ACLINE        MFLD                                       MD055694
364700210712     C                   ADD       1             X                                          MD055694
364800210712     C     X             OCCUR     MULT                                                     MD055694
364900210712     C                   MOVEL     ZSADD1        MFLD                                       MD055694
365000210712     C                   ELSE                                                               MD055694
365100210712     C                   MOVEL     ZSADD1        MFLD                                       MD055694
365200210712     C                   ENDIF                                                              MD055694
365300210712     C                   ENDIF                                                              MD055694
365400210712     C                   ENDIF                                                              MD055694
365500210712
365600210712     C                   EXSR      SEXTN
365700210712     C                   ENDIF
365800210712     C                   ENDIF
365900210712     C                   ENDIF
366000210712     C                   ENDIF
366100210712
366200210712      *****************************************************************
366300210712     C                   ENDSR
366400210712     C/EJECT
366500210712      *****************************************************************
366600210712      *                                                               *
366700210712      *   FMT53 - Format Field 53 address   - Sequence C              *
366800210712      *   Called by   SRFMTC  Format message details Sequence C       *
366900210712      *                                                               *
367000210712      *****************************************************************
367100210712     C     FMT53         BEGSR
367200210712
367300210712      **  A Type address
367400210712
367500210712     C     ZSTAG         IFEQ      'A'
367600210712     C                   MOVE      ':53A:'       MTAG
367700210712     C                   MOVEL     ZSADD1        MFLD
367800210712     C                   EXSR      SEXTN
367900210712     C                   MOVE      '1'           *IN55
368000210712
368100210712     C                   ELSE
368200210712
368300210712      ** Access SDCUSTPD using our pay nostro customer number
368400210712
368500210712     C                   MOVE      *BLANKS       @KEY1
368600210712     C                   MOVEL     A7CUST        @KEY1
368700210712     C                   CALL      'AOCUSTR0'
368800210712     C                   PARM      '*MSG   '     @RTCD
368900210712     C                   PARM      '*KEY   '     @OPTN
369000210712     C                   PARM                    @KEY1            10
369100210712     C                   PARM      *BLANKS       @KYST             7
369200210712     C     SDCUST        PARM      SDCUST        DSSDY
369300210712
369400210712      ** Customer record not found - Error
369500210712
369600210712     C     @RTCD         IFNE      *BLANKS
369700210712     C                   MOVE      'Y'           @ERR
369800210712     C                   MOVE      ':53 :'       MTAG
369900210712     C                   MOVEL     A7CUST        MFLD
370000210712     C                   MOVE      MSGA(2)       MERR
370100210712
370200210712     C                   ELSE
370300210712
370400210712      ** B Type address
370500210712
370600210712     C                   MOVE      BBPCNB        @PCNB             6 0
370700210712     C*****SPAIN         IFEQ      'P'                                                     AR1094963
370800210712     C*****@PCNB         ANDEQ     SECN                                                    AR1094963
370900210712     C*****BBPAIN        OREQ      'P'                                                     AR1094963
371000210712     C*****A7CUST        ANDEQ     SPCNB                                                   AR1094963
371100210712     C*****BBPCNB        OREQ      SPCNB                                                   AR1094963
371200210712     C*****BBPCNB        ANDNE     *BLANKS                                                 AR1094963
371300210712      *                                                                                    AR1094963
371400210712     C                   IF        SPAIN = 'P' AND %CHAR(@PCNB) = SECN                     AR1094963
371500210712     C                             OR BBPAIN = 'P' AND A7CUST = SPCNB                      AR1094963
371600210712     C                             OR BBPCNB = SPCNB AND BBPCNB <> *BLANKS                 AR1094963
371700210712
371800210712     C                   MOVE      ':53B:'       MTAG
371900210712     C                   MOVE      *BLANKS       @WRK
372000210712     C                   MOVEA     BBCRNM        @WRK(1)
372100210712     C                   Z-ADD     22            J                 2 0
372200210712     C                   MOVEA     BBCRTN        @WRK(J)
372300210712     C                   MOVEA     @WRK          MFLD
372400210712
372500210712      ** D Type address
372600210712
372700210712     C                   ELSE
372800210712                                                                                            MD055694
372900210712      ** If CSW221 is ON, process format J instead of D.                                    MD055694
373000210712                                                                                            MD055694
373100210712     C                   IF        CSW221 = 'Y'                                             MD055694
373200210712     C                   MOVE      '53'          FLDNO                                      MD055694
373300210712     C                   MOVEL     *BLANKS       ACLINE                                     MD055694
373400210712     C                   EXSR      SRFMTJ                                                   MD055694
373500210712                                                                                            MD055694
373600210712     C                   ELSE                                                               MD055694
373700210712     C                   MOVE      ':53D:'       MTAG
373800210712     C                   MOVEL     ZSADD1        MFLD
373900210712
374000210712      ** Address 2
374100210712
374200210712     C     ZSADD2        IFNE      *BLANKS
374300210712     C                   ADD       1             X
374400210712     C     X             OCCUR     MULT
374500210712     C                   MOVEL     ZSADD2        MFLD
374600210712
374700210712      ** Address 3
374800210712
374900210712     C     ZSADD3        IFNE      *BLANKS
375000210712     C                   ADD       1             X
375100210712     C     X             OCCUR     MULT
375200210712     C                   MOVEL     ZSADD3        MFLD
375300210712
375400210712      ** Address 4
375500210712
375600210712     C     ZSADD4        IFNE      *BLANKS
375700210712     C                   ADD       1             X
375800210712     C     X             OCCUR     MULT
375900210712     C                   MOVEL     ZSADD4        MFLD
376000210712     C                   ENDIF
376100210712     C                   ENDIF
376200210712     C                   ENDIF
376300210712     C                   ENDIF                                                              MD055694
376400210712     C                   ENDIF
376500210712
376600210712     C                   ENDIF
376700210712
376800210712     C                   ENDIF
376900210712
377000210712     C                   ENDSR
377100210712      *****************************************************************
377200210712     C/EJECT
377300210712      *****************************************************************
377400210712      *                                                               *
377500210712      *   FMTX1 - Format Fields 86 & 87 - Sequence C                  *
377600210712      *   Called by   SRFMTC format message details Sequence C        *
377700210712      *   Calls       FSWAD  format SWIFT address                     *
377800210712      *                                                               *
377900210712      *****************************************************************
378000210712     C     FMTX1         BEGSR
378100210712
378200210712     C                   MOVE      'N'           FLD87O            1
378300210712
378400210712      **  Field :87:  A/C with institution non-blank
378500210712
378600210712     C     MGAWBN        IFNE      *BLANKS
378700210712
378800210712      **  Field :86:  Pay Intermediary bank
378900210712
379000210712     C     MGPIBN        IFNE      *BLANKS
379100210712     C                   ADD       1             X
379200210712     C     X             OCCUR     MULT
379300210712     C                   MOVE      *BLANKS       ZDEST
379400210712     C                   MOVEL     MGPIBN        ZDEST
379500210712     C                   MOVEL     *BLANKS       ACLINE
379600210712     C                   MOVEL     MGPIBA        ACLINE
379700210712     C                   MOVE      ' '           TAG
379800210712     C                   MOVE      @TAGI         FLDNO
379900210712     C                   EXSR      FSWAD
380000210712     C                   ENDIF
380100210712
380200210712      ** Format Account with institution
380300210712
380400210712     C                   ADD       1             X
380500210712     C     X             OCCUR     MULT
380600210712     C                   MOVE      *BLANKS       ZDEST
380700210712     C                   MOVEL     MGAWBN        ZDEST
380800210712     C                   MOVEL     *BLANKS       ACLINE
380900210712
381000210712     C/COPY WNCPYSRC,MG0600C051
381100210712
381200210712     C                   MOVEL     MGBENA        ACLINE
381300210712     C                   MOVE      ' '           TAG
381400210712     C                   MOVE      @TAGD         FLDNO
381500210712
381600210712     C/COPY WNCPYSRC,MG0600C004
381700210712
381800210712     C                   MOVE      NETSL         CKNETI
381900210712     C                   EXSR      FSWAD
382000210712     C                   MOVE      'Y'           FLD87O            1
382100210712
382200210712      ** A/C with Inst. blank
382300210712
382400210712     C                   ELSE
382500210712
382600210712      **  Field 87 = pay nostro customer if settlement via '02' or '12'
382700210712      **  OR if A/c with Bank Account line set up as 'DIRECT'
382800210712
382900210712     C     MGPSTM        IFEQ      02
383000210712     C     MGPSTM        OREQ      12
383100210712     C     AWBA6         OREQ      'DIRECT'
383200210712     C                   MOVEL     MGPONS        @NONB
383300210712
383400210712      ** Use payment settlement currency to access nostro if not blank.
383500210712      ** Otherwise use sell currency.
383600210712
383700210712     C     CEU003        IFEQ      'Y'
383800210712     C     MGPYCY        ANDNE     *BLANKS
383900210712     C                   MOVE      MGPYCY        @CYCD
384000210712     C                   ELSE
384100210712     C                   MOVE      MGSLCY        @CYCD
384200210712     C                   ENDIF
384300210712
384400210712     C                   CALL      'AONOSTR0'
384500210712     C                   PARM      '*MSG   '     @RTCD             7
384600210712     C                   PARM      '*KEY   '     @OPTN             7
384700210712     C                   PARM      *BLANKS       @CUST             6
384800210712     C                   PARM                    @CYCD             3
384900210712     C                   PARM      *BLANKS       @ACCD             4
385000210712     C                   PARM      *BLANKS       @ACSN             2
385100210712     C                   PARM                    @NONB             2
385200210712     C                   PARM      *BLANKS       @BRCD             3
385300210712     C                   PARM      *BLANKS       @CSSN            10
385400210712     C                   PARM      *BLANKS       @PNOI             1
385500210712     C     SDNOST        PARM      SDNOST        DSFDY
385600210712
385700210712      ** Nostro customer not found
385800210712
385900210712     C     @RTCD         IFNE      *BLANKS
386000210712     C                   MOVE      'Y'           @ERR
386100210712     C                   ADD       1             X
386200210712     C     X             OCCUR     MULT
386300210712     C                   MOVEL     MGPONS        HLD2              2
386400210712     C                   MOVEL     MGSLCY        HLD5
386500210712     C                   MOVE      HLD2          HLD5              5
386600210712     C                   MOVEL     HLD5          MFLD
386700210712     C                   MOVEL     MSGA(3)       MERR
386800210712     C     @TAGD         IFEQ      '57'
386900210712     C                   MOVE      ':57 :'       MTAG
387000210712     C                   ELSE
387100210712     C                   MOVE      ':87 :'       MTAG
387200210712     C                   ENDIF
387300210712     C                   ELSE
387400210712
387500210712      ** Format our Pay Nostro Customer Address
387600210712
387700210712     C                   ADD       1             X
387800210712     C     X             OCCUR     MULT
387900210712     C                   MOVE      *BLANKS       ZDEST
388000210712     C     MGRVNO        IFEQ      *BLANKS
388100210712     C                   MOVEL     A7CUST        ZDEST
388200210712     C                   ELSE
388300210712     C                   MOVEL     MGRVNO        ZDEST
388400210712     C                   ENDIF
388500210712     C                   MOVEL     *BLANKS       ACLINE
388600210712     C                   MOVE      ' '           TAG
388700210712     C                   MOVE      @TAGD         FLDNO
388800210712     C                   MOVE      NETSL         CKNETI
388900210712     C                   EXSR      FSWAD
389000210712     C                   ENDIF
389100210712
389200210712     C                   ELSE
389300210712     C                   MOVE      MGPSTM        @STM
389400210712     C     @STM          LOOKUP    TABINT                                 23
389500210712
389600210712     C     *IN23         IFEQ      '1'
389700210712     C                   ADD       1             X
389800210712     C     X             OCCUR     MULT
389900210712     C                   MOVE      *BLANKS       ZDEST
390000210712     C                   MOVEL     SECN          ZDEST
390100210712     C                   MOVEL     *BLANKS       ACLINE
390200210712     C                   MOVE      ' '           TAG
390300210712     C                   MOVE      @TAGD         FLDNO
390400210712     C                   MOVE      NETSL         CKNETI
390500210712     C                   EXSR      FSWAD
390600210712
390700210712     C                   ELSE
390800210712
390900210712      ** Use payment settlement currency to access nostro if not blank.
391000210712      ** Otherwise use sell currency.
391100210712
391200210712     C     CEU003        IFEQ      'Y'
391300210712     C     MGPYCY        ANDNE     *BLANKS
391400210712     C                   MOVE      MGPYCY        @NSKYB
391500210712     C                   ELSE
391600210712     C                   MOVE      MGSLCY        @NSKYB
391700210712     C                   ENDIF
391800210712
391900210712      ** Tag 53 should not be included inside 15C Sequence                                  MD033754
392000210712     C     SEQ15C        IFNE      'Y'                                                      MD033754
392100210712      ** Field 53 is equal to Our Pay Nostro
392200210712
392300210712     C                   MOVEL     MGPONS        @NSKYE
392400210712     C                   CALL      'AONOSTR0'
392500210712     C                   PARM      '*MSG   '     @RTCD             7
392600210712     C                   PARM      '*KEY   '     @OPTN             7
392700210712     C                   PARM      *BLANKS       @NSKYA            6
392800210712     C                   PARM                    @NSKYB            3
392900210712     C                   PARM      *BLANKS       @NSKYC            4
393000210712     C                   PARM      *BLANKS       @NSKYD            2
393100210712     C                   PARM                    @NSKYE            2
393200210712     C                   PARM      *BLANKS       @KEYF             3
393300210712     C                   PARM      *BLANKS       @KEYG            10
393400210712     C                   PARM      *BLANKS       @KEYH             1
393500210712     C     SDNOST        PARM      SDNOST        DSFDY
393600210712
393700210712      ** Nostro customer not found
393800210712
393900210712     C     @RTCD         IFNE      *BLANKS
394000210712     C                   ADD       1             X
394100210712     C     X             OCCUR     MULT
394200210712     C                   MOVE      'Y'           @ERR
394300210712     C                   MOVE      ':53 :'       MTAG
394400210712     C                   MOVEL     MGPONS        MFLD
394500210712     C                   MOVEL     MSGA(3)       MERR
394600210712     C                   ELSE
394700210712
394800210712      ** Format our Pay Nostro Customer Address
394900210712      ** ( only if Tag 53A not yet generated )
395000210712
395100210712     C     *IN55         IFEQ      '1'
395200210712     C                   MOVE      '0'           *IN55
395300210712     C                   ELSE
395400210712
395500210712     C                   ADD       1             X
395600210712     C     X             OCCUR     MULT
395700210712     C                   MOVE      *BLANKS       ZDEST
395800210712     C                   MOVEL     A7CUST        ZDEST
395900210712     C                   MOVEL     *BLANKS       ACLINE
396000210712     C                   MOVE      ' '           TAG
396100210712     C                   MOVE      '53'          FLDNO
396200210712     C                   EXSR      FSWAD
396300210712     C                   ENDIF
396400210712
396500210712     C                   ENDIF
396600210712                                                                                            MD033754
396700210712     C                   ENDIF                                                              MD033754
396800210712
396900210712      ** Settlement 01,07 or 08 with MGAWBN blank or settlement 00
397000210712
397100210712     C                   ADD       1             X
397200210712     C     X             OCCUR     MULT
397300210712     C     @TAGD         IFEQ      '57'
397400210712     C                   IF        CSW221 = 'Y'                                             MD055694
397500210712     C                   MOVE      ':57J:'       MTAG                                       MD055694
397600210712     C                   MOVEL     NOSTXU        MFLD                                       MD055694
397700210712     C                   ELSE                                                               MD055694
397800210712     C                   MOVE      ':57D:'       MTAG
397900210712     C                   MOVEL     'UNKNOWN'     MFLD                                       MD055694
398000210712     C                   ENDIF                                                              MD055694
398100210712     C                   ELSE
398200210712     C                   MOVE      ':87D:'       MTAG
398300210712     C                   MOVEL     'UNKNOWN'     MFLD                                       MD055694
398400210712     C                   ENDIF
398500210712     C**********         MOVEL     'UNKNOWN'     MFLD                                       MD055694
398600210712
398700210712     C/COPY WNCPYSRC,MG0600CCP2
398800210712
398900210712     C                   ENDIF
399000210712     C                   ENDIF
399100210712     C                   ENDIF
399200210712
399300210712     C                   ENDSR
399400210712      *****************************************************************
399500210712     C/EJECT
399600210712      *****************************************************************
399700210712      *                                                               *
399800210712      *   SRREPT - print incorrectly generated messages               *
399900210712      *   Called by   Main process                                    *
400000210712      *                                                               *
400100210712      *****************************************************************
400200210712     C     SRREPT        BEGSR
400300210712
400400210712     C     *IN50         IFEQ      '0'
400500210712     C                   OPEN      MG000600P1
400600210712     C                   SETON                                        50
400700210712     C                   ENDIF
400800210712
400900210712      ** Set up headings and sender/customer information
401000210712      ** for the error report
401100210712
401200210712     C                   MOVE      '0'           *IN30
401300210712     C     @FEED         IFEQ      ' '
401400210712     C                   MOVE      '1'           *IN30
401500210712     C                   ENDIF
401600210712     C                   MOVEL     MGTNUM        TNUM              6 0
401700210712     C                   WRITE     HEADER
401800210712     C                   WRITE     TEXT
401900210712
402000210712      ** Process multiple occurrence data structure
402100210712
402200210712     C                   Z-ADD     0             I                 2 0
402300210712     C     I             DOWLE     X
402400210712     C                   ADD       1             I
402500210712     C     I             OCCUR     MULT
402600210712     C     *IN99         IFEQ      '1'                                                      MD022425
402700210712     C                   WRITE     HEADER                                                   MD022425
402800210712     C                   WRITE     TEXT                                                     MD022425
402900210712     C                   WRITE     LINE                                                     MD022425
403000210712     C                   MOVE      '0'           *IN99                                      MD022425
403100210712     C                   ELSE                                                               MD022425
403200210712     C                   WRITE     LINE
403300210712     C                   ENDIF                                                              MD022425
403400210712     C                   ENDDO
403500210712
403600210712     C                   ENDSR
403700210712      *****************************************************************
403800210712     C/EJECT
403900210712      *****************************************************************
404000210712      *                                                               *
404100210712      *   SROMSG - output correctly generated messages                *
404200210712      *   Called by   Main process                                    *
404300210712      *                                                               *
404400210712      *****************************************************************
404500210712      *
404600210712     C     SROMSG        BEGSR
404700210712
404800210712      ** Write reference record  (PF/MGOREFPD)
404900210712
405000210712     C                   EXSR      SRWREF
405100210712
405200210712     C/COPY WNCPYSRC,MG0600CCP6
405300210712
405400210712      ** Write multiple occurrence data structure to MGOMSGPD
405500210712
405600210712     C                   Z-ADD     1             X
405700210712     C     X             OCCUR     MULT
405800210712
405900210712     C     X             DOWLE     95
406000210712     C     MULT          ANDNE     *BLANKS
406100210712     C                   WRITE     MGOMSGD0                             06
406200210712
406300210712     C/COPY WNCPYSRC,MG0600CCP7
406400210712
406500210712      **  Error on write to PF/MGOMSGPD (message data file)
406600210712
406700210712     C     *IN06         IFEQ      '1'
406800210712     C     *LOCK         IN        LDA
406900210712     C                   MOVE      '024'         DBASE
407000210712     C                   MOVEL     '        '    DBKEY
407100210712     C                   MOVEL     'MGOMSGPD'    DBFILE
407200210712     C                   OUT       LDA
407300210712     C                   EXSR      *PSSR
407400210712     C                   ENDIF
407500210712
407600210712     C/COPY WNCPYSRC,MG0600C005
407700210712
407800210712     C                   ADD       1             X
407900210712     C     X             OCCUR     MULT
408000210712     C                   ENDDO
408100210712
408200210712      ** Write multiple occurrence data structure to MGOEXTPD
408300210712
408400210712     C                   Z-ADD     1             V                 2 0
408500210712     C     V             OCCUR     EXTN
408600210712     C     V             DOWLE     20
408700210712     C     MCSI          ANDNE     *BLANKS
408800210712     C                   WRITE     MGOEXTD0                             06
408900210712
409000210712      ** Error on write to PF/MGOEXTPD (message data extension file)
409100210712
409200210712     C     *IN06         IFEQ      '1'
409300210712     C     *LOCK         IN        LDA
409400210712     C                   MOVE      '027'         DBASE
409500210712     C                   MOVEL     '        '    DBKEY
409600210712     C                   MOVEL     'MGOEXTPD'    DBFILE
409700210712     C                   OUT       LDA
409800210712     C                   EXSR      *PSSR
409900210712     C                   ENDIF
410000210712     C                   ADD       1             V
410100210712     C     V             OCCUR     EXTN
410200210712     C                   ENDDO
410300210712
410400210712     C                   ENDSR
410500210712      *****************************************************************
410600210712     C/EJECT
410700210712      *****************************************************************
410800210712      *                                                               *
410900210712      *   CFMAT - produce confirmation matching feedback record       *
411000210712      *   Called by   Main process                                    *
411100210712      *                                                               *
411200210712      *****************************************************************
411300210712     C     CFMAT         BEGSR
411400210712
411500210712     C                   CALL      'MG5001'
411600210712     C                   PARM      TRNO          @TRNM            16
411700210712     C                   PARM      MGBRCA        @BRCA             3
411800210712     C                   PARM      *BLANK        @FEED             1
411900210712
412000210712     C     @FEED         IFEQ      'Y'
412100210712
412200210712     C     *IN50         IFEQ      '0'
412300210712     C                   OPEN      MG000600P1
412400210712     C                   SETON                                        50U7
412500210712     C                   ENDIF
412600210712
412700210712      ** Set up headings and sender/customer information
412800210712      ** for the error report
412900210712
413000210712     C                   MOVE      '1'           *IN30
413100210712     C                   MOVEL     MGTNUM        TNUM              6 0
413200210712     C                   WRITE     HEADER
413300210712     C                   WRITE     TEXT
413400210712     C                   WRITE     FEED
413500210712     C                   MOVE      '0'           *IN30
413600210712     C                   ENDIF
413700210712
413800210712     C                   ENDSR
413900210712      *****************************************************************
414000210712     C/EJECT
414100210712      *****************************************************************
414200210712      *                                                               *
414300210712      *   SRWREF - Write reference record to PF/MGOREFPD              *
414400210712      *   Called by   SROMSG  output message PF/MGOMSGPD              *
414500210712      *                                                               *
414600210712      *****************************************************************
414700210712     C     SRWREF        BEGSR
414800210712
414900210712     C                   MOVE      *BLANKS       SYTM
415000210712     C                   MOVE      MGMODI        MODI
415100210712     C                   MOVEL     @TRNO         TRNO
415200210712     C                   MOVE      *BLANKS       TRNF
415300210712     C                   MOVE      *BLANKS       TRNM
415400210712     C     MGACMI        IFEQ      'Y'                                                      MD022425
415500210712     C                   MOVEL     @TRNID        MTRN                                       MD022425
415600210712     C                   ELSE                                                               MD022425
415700210712     C                   MOVEL     @TR2          MTRN
415800210712     C                   ENDIF                                                              MD022425
415900210712     C                   MOVE      MGTTYP        TNTP
416000210712     C                   MOVE      MGTSTP        SBTP
416100210712     C                   MOVE      *BLANKS       EVTP
416200210712     C                   MOVEL     *BLANKS       NWBN
416300210712     C                   MOVE      '600'         MTPY
416400210712     C                   MOVE      'N'           MPRY
416500210712     C                   MOVEL     CWRD          LSCC
416600210712     C                   MOVEL     *BLANKS       PTST
416700210712     C                   MOVEL     *BLANKS       CARQ
416800210712     C                   MOVEL     *BLANKS       MPDE
416900210712     C                   MOVEL     @HRDT         HRDT
417000210712     C                   TIME                    MGTM
417100210712     C                   MOVE      BJMRDT        LADT
417200210712     C                   MOVE      MGTM          LATM
417300210712
417400210712     C     MGST          IFEQ      'RSND'
417500210712     C                   MOVE      BJMRDT        RELD
417600210712     C                   MOVE      MGTM          RELT
417700210712     C                   ENDIF
417800210712
417900210712     C                   MOVEL     *BLANKS       RUSR
418000210712     C                   MOVEL     *BLANKS       RWSN
418100210712     C                   MOVEL     *BLANKS       AMTS
418200210712     C                   MOVEL     *BLANKS       AMTX
418300210712     C                   MOVEL     *BLANKS       SVDT
418400210712     C                   MOVEL     *BLANKS       CINDV
418500210712     C                   MOVEL     *BLANKS       CCY
418600210712     C                   MOVEL     *BLANKS       NSNO
418700210712     C                   MOVEL     *BLANKS       SACN
418800210712     C                   MOVEL     *BLANKS       AORR
418900210712     C                   MOVEL     *BLANKS       DESI
419000210712
419100210712      ** Branch details
419200210712
419300210712     C                   MOVE      MGBRCA        BRCA
419400210712     C                   MOVE      MGPOBR        OTHB
419500210712     C     OTHB          IFNE      *BLANKS
419600210712     C                   MOVEL     MSGA(1)       OTHT
419700210712     C                   ENDIF
419800210712     C                   MOVE      MGROBR        RCBR
419900210712
420000210712     C                   MOVE      *BLANKS       NETI
420100210712     C                   MOVE      *BLANKS       DELC
420200210712     C                   MOVE      *BLANKS       DYST
420300210712     C                   MOVE      *BLANKS       RSID
420400210712     C                   MOVE      *BLANKS       MSE1
420500210712     C                   MOVE      *BLANKS       ELIN
420600210712     C                   MOVE      *BLANKS       SSAC
420700210712     C                   MOVE      *BLANKS       MIR
420800210712     C                   MOVE      *BLANKS       TSKS
420900210712     C                   MOVE      *BLANKS       TSKY
421000210712
421100210712      ** Set up CLS field when CDL002 is switched on
421200210712
421300210712     C     CDL002        IFEQ      'Y'
421400210712     C                   MOVE      MGCLSS        CLSS
421500210712     C                   ENDIF
421600210712     C                   MOVE      MGCHTP        AORR
421700210712
421800210712     C/COPY WNCPYSRC,MG0600C035
421900210712
422000210712     C                   WRITE     MGOREFD0                             05
422100210712
422200210712      ** Error on write to PF/MGOREFPD (message reference file)
422300210712
422400210712     C     *IN05         IFEQ      '1'
422500210712     C     *LOCK         IN        LDA
422600210712     C                   MOVE      '025'         DBASE
422700210712     C                   MOVEL     '       '     DBKEY
422800210712     C                   MOVEL     'MGOREFPD'    DBFILE
422900210712     C                   OUT       LDA
423000210712     C                   EXSR      *PSSR
423100210712     C                   ENDIF
423200210712
423300210712      ** Write transaction history record
423400210712
423500210712     C     MGACMI        IFEQ      'Y'                                                      MD022425
423600210712     C                   MOVEL     TRNO          @HREF1                                     MD022425
423700210712     C                   MOVEL     @HREF1        @HREF                                      MD024078
423800210712     C                   MOVE      '000'         HSSEQ                                      MD022425
423900210712     C                   MOVE      @SSEQ         HSSEQ                                      MD022425
424000210712     C                   ELSE                                                               MD022425
424100210712     C                   MOVEL     TRNO          @HREF
424200210712     C                   ENDIF                                                              MD022425
424300210712     C                   MOVE      '600'         HSMTPY
424400210712
424500210712     C                   WRITE     MGHISTD0                             56
424600210712
424700210712      **  Error on write to PF/MGHISTPD
424800210712
424900210712     C     *IN56         IFEQ      '1'
425000210712     C     *LOCK         IN        LDA
425100210712     C                   MOVE      '027'         DBASE
425200210712     C                   MOVEL     '       '     DBKEY
425300210712     C                   MOVEL     'MGHISTPD'    DBFILE
425400210712     C                   OUT       LDA
425500210712     C                   EXSR      *PSSR
425600210712     C                   END
425700210712
425800210712     C/COPY WNCPYSRC,MG0600C006
425900210712
426000210712     C                   ENDSR
426100210712      *****************************************************************
426200210712     C/EJECT
426300210712      *****************************************************************
426400210712      *                                                               *
426500210712      *   SRBTB - Store Sender to Receiver Information to temp work   *
426600210712      *           fields                                              *
426700210712      *                                                               *
426800210712      *****************************************************************
426900210712     C     SRBTB         BEGSR
427000210712     C                   MOVEA     *BLANKS       @BTB
427100210712     C                   MOVE      MGBTB1        @BTB(1)
427200210712     C                   MOVE      MGBTB2        @BTB(2)
427300210712     C                   MOVE      MGBTB3        @BTB(3)
427400210712     C                   MOVE      MGBTB4        @BTB(4)
427500210712     C                   MOVE      MGBTB5        @BTB(5)
427600210712     C                   MOVE      MGBTB6        @BTB(6)
427700210712     C                   ENDSR
427800210712     C/EJECT                                                                                MD022425
427900210712      *****************************************************************                     MD022425
428000210712      *   SRFMTD - Format message detail - Sequence D                 *                     MD022425
428100210712      *   Called by   Main process                                    *                     MD022425
428200210712      *   Calls                                                       *                     MD022425
428300210712      *****************************************************************                     MD022425
428400210712                                                                                            MD022425
428500210712     C     SRFMTD        BEGSR                                                              MD022425
428600210712      *                                                                                     MD022425
428700210712      **  Field :15D: New Sequence                                                          MD022425
428800210712      *                                                                                     MD022425
428900210712     C                   ADD       1             X                                          MD022425
429000210712     C     X             OCCUR     MULT                                                     MD022425
429100210712     C                   MOVE      ':15D:'       MTAG                                       MD022425
429200210712     C                   MOVEL     *BLANK        MFLD                                       MD022425
429300210712     C                   Z-ADD     X             X15D              2 0                      MD024078
429400210712      *                                                                                     MD022425
429500210712      **  Clear multiple occurrence DS for the RPPT                                         MD022425
429600210712      *                                                                                     MD022425
429700210712     C                   Z-ADD     1             Y                 1 0                      MD022425
429800210712     C     Y             OCCUR     RPPT                                                     MD022425
429900210712     C     Y             DOWLE     4                                                        MD022425
430000210712      *                                                                                     MD022425
430100210712     C                   CLEAR                   RPPT                                       MD022425
430200210712      *                                                                                     MD022425
430300210712      **  This will clear the RPPT Multi-Occurence DS for the ff fields                     MD022425
430400210712      **  MGRJXX - Reporting Jurisdiction    MGUTXX - UTI Namespace/Issuer Code             MD022425
430500210712      **  MGRPXX - Reporting Party           MGTNXX - Transaction Identifier                MD022425
430600210712      **  MGRNXX - Reporting Party Name      MGTIXX - Transaction Identifier Type           MD022425
430700210712      **  MGRCXX - Reporting Party City      MGETXX - Event Type                            MD022425
430800210712      **  MGRSXX - Reporting Party SWIFT identification                                     MD022425
430900210712      **  MGRLXX - Reporting Party LEI                                                      MD022425
431000210712      **  MGRAXX - Reporting Party Account                                                  MD022425
431100210712      *                                                                                     MD022425
431200210712     C                   ADD       1             Y                                          MD022425
431300210712     C     Y             OCCUR     RPPT                                                     MD022425
431400210712     C                   ENDDO                                                              MD022425
431500210712     C                   Z-ADD     0             Y                                          MD022425
431600210712      *                                                                                     MD022425
431700210712      **  Initialize multioccurence DS RPPT with the 4 set of fields                        MD022425
431800210712      *                                                                                     MD022425
431900210712     C                   Z-ADD     1             Y1                1 0                      MD022425
432000210712     C     Y1            OCCUR     RPPT                                                     MD022425
432100210712     C     Y1            DOWLE     4                                                        MD022425
432200210712     C     Y1            IFEQ      1                                                        MD022425
432300210712     C                   MOVE      MGRJ01        MGRJXX                                     MD022425
432400210712     C                   MOVE      MGRP01        MGRPXX                                     MD022425
432500210712     C                   MOVE      MGRN01        MGRNXX                                     MD022425
432600210712     C                   MOVE      MGRC01        MGRCXX                                     MD022425
432700210712     C                   MOVE      MGRS01        MGRSXX                                     MD022425
432800210712     C                   MOVE      MGRL01        MGRLXX                                     MD022425
432900210712     C                   MOVE      MGRA01        MGRAXX                                     MD022425
433000210712     C                   MOVE      MGUT01        MGUTXX                                     MD022425
433100210712     C                   MOVE      MGTN01        MGTNXX                                     MD022425
433200210712     C                   MOVE      MGTI01        MGTIXX                                     MD022425
433300210712     C                   MOVE      MGET01        MGETXX                                     MD022425
433400210712     C                   ENDIF                                                              MD022425
433500210712     C     Y1            IFEQ      2                                                        MD022425
433600210712     C                   MOVE      MGRJ02        MGRJXX                                     MD022425
433700210712     C                   MOVE      MGRP02        MGRPXX                                     MD022425
433800210712     C                   MOVE      MGRN02        MGRNXX                                     MD022425
433900210712     C                   MOVE      MGRC02        MGRCXX                                     MD022425
434000210712     C                   MOVE      MGRS02        MGRSXX                                     MD022425
434100210712     C                   MOVE      MGRL02        MGRLXX                                     MD022425
434200210712     C                   MOVE      MGRA02        MGRAXX                                     MD022425
434300210712     C                   MOVE      MGUT02        MGUTXX                                     MD022425
434400210712     C                   MOVE      MGTN02        MGTNXX                                     MD022425
434500210712     C                   MOVE      MGTI02        MGTIXX                                     MD022425
434600210712     C                   MOVE      MGET02        MGETXX                                     MD022425
434700210712     C                   ENDIF                                                              MD022425
434800210712     C     Y1            IFEQ      3                                                        MD022425
434900210712     C                   MOVE      MGRJ03        MGRJXX                                     MD022425
435000210712     C                   MOVE      MGRP03        MGRPXX                                     MD022425
435100210712     C                   MOVE      MGRN03        MGRNXX                                     MD022425
435200210712     C                   MOVE      MGRC03        MGRCXX                                     MD022425
435300210712     C                   MOVE      MGRS03        MGRSXX                                     MD022425
435400210712     C                   MOVE      MGRL03        MGRLXX                                     MD022425
435500210712     C                   MOVE      MGRA03        MGRAXX                                     MD022425
435600210712     C                   MOVE      MGUT03        MGUTXX                                     MD022425
435700210712     C                   MOVE      MGTN03        MGTNXX                                     MD022425
435800210712     C                   MOVE      MGTI03        MGTIXX                                     MD022425
435900210712     C                   MOVE      MGET03        MGETXX                                     MD022425
436000210712     C                   ENDIF                                                              MD022425
436100210712     C     Y1            IFEQ      4                                                        MD022425
436200210712     C                   MOVE      MGRJ04        MGRJXX                                     MD022425
436300210712     C                   MOVE      MGRP04        MGRPXX                                     MD022425
436400210712     C                   MOVE      MGRN04        MGRNXX                                     MD022425
436500210712     C                   MOVE      MGRC04        MGRCXX                                     MD022425
436600210712     C                   MOVE      MGRS04        MGRSXX                                     MD022425
436700210712     C                   MOVE      MGRL04        MGRLXX                                     MD022425
436800210712     C                   MOVE      MGRA04        MGRAXX                                     MD022425
436900210712     C                   MOVE      MGUT04        MGUTXX                                     MD022425
437000210712     C                   MOVE      MGTN04        MGTNXX                                     MD022425
437100210712     C                   MOVE      MGTI04        MGTIXX                                     MD022425
437200210712     C                   MOVE      MGET04        MGETXX                                     MD022425
437300210712     C                   ENDIF                                                              MD022425
437400210712     C                   ADD       1             Y1                                         MD022425
437500210712     C     Y1            OCCUR     RPPT                                                     MD022425
437600210712     C                   ENDDO                                                              MD022425
437700210712     C                   Z-ADD     0             Y1                                         MD022425
437800210712      *                                                                                     MD022425
437900210712     C                   Z-ADD     0             WRKIX             1 0                      MD022425
438000210712     C                   MOVEL     'N'           WRKFLG            1                        MD022425
438100210712      *                                                                                     MD022425
438200210712      **  Do Loop for 4 times                                                               MD022425
438300210712      *                                                                                     MD022425
438400210712     C     WRKIX         DOWLT     4                                                        MD022425
438500210712     C                   ADD       1             WRKIX                                      MD022425
438600210712     C     WRKIX         OCCUR     RPPT                                                     MD022425
438700210712      *                                                                                     MD022425
438800210712      **  Reporting Jurisdiction                                                            MD022425
438900210712      *                                                                                     MD022425
439000210712     C     MGRJXX        IFEQ      *BLANKS                                                  MD022425
439100210712     C                   ADD       5             WRKIX                                      MD022425
439200210712     C                   ELSE                                                               MD022425
439300210712     C*****MGRJXX        IFNE      *BLANKS                                         MD022425 MD024078
439400210712     C*****MGRPXX        ANDNE     *BLANKS                                         MD022425 MD024078
439500210712     C*****MGRNXX        ANDNE     *BLANKS                                         MD022425 MD024078
439600210712     C*****MGRCXX        ANDNE     *BLANKS                                         MD022425 MD024078
439700210712     C*****MGRSXX        ANDNE     *BLANKS                                         MD022425 MD024078
439800210712     C*****MGRLXX        ANDNE     *BLANKS                                         MD022425 MD024078
439900210712     C*****MGRAXX        ANDNE     *BLANKS                                         MD022425 MD024078
440000210712     C     MGRJXX        IFNE      WRKMRJ                                                   MD024078
440100210712     C     MGRPXX        ORNE      WRKMRP                                                   MD024078
440200210712     C     MGRNXX        ORNE      WRKMRN                                                   MD024078
440300210712     C     MGRCXX        ORNE      WRKMRC                                                   MD024078
440400210712     C     MGRSXX        ORNE      WRKMRS                                                   MD024078
440500210712     C     MGRLXX        ORNE      WRKMRL                                                   MD024078
440600210712     C     MGRAXX        ORNE      WRKMRA                                                   MD024078
440700210712     C                   ADD       1             X                                          MD022425
440800210712     C     X             OCCUR     MULT                                                     MD022425
440900210712     C                   MOVEL     ':22L:'       MTAG                                       MD022425
441000210712     C                   MOVEL     MGRJXX        MFLD                                       MD022425
441100210712     C                   MOVEL     'N'           WRKFLG                                     MD022425
441200210712     C**********         ENDIF                                                     MD022425 MD024078
441300210712      *                                                                                     MD022425
441400210712      **  Reporting Party                                                                   MD022425
441500210712      *                                                                                     MD022425
441600210712     C     MGRPXX        IFNE      *BLANKS                                                  MD022425
441700210712     C                   MOVEL     MGRPXX        WRKMRP            6                        MD024078
441800210712     C                   MOVEL     MGRJXX        WRKMRJ           35                        MD024078
441900210712     C                   MOVEL     MGRNXX        WRKMRN           20                        MD024078
442000210712     C                   MOVEL     MGRCXX        WRKMRC           10                        MD024078
442100210712     C                   MOVEL     MGRSXX        WRKMRS           11                        MD024078
442200210712     C                   MOVEL     MGRLXX        WRKMRL           20                        MD024078
442300210712     C                   MOVEL     MGRAXX        WRKMRA           34                        MD024078
442400210712     C                   MOVE      *BLANKS       ZDEST                                      MD022425
442500210712     C                   MOVEL     MGRPXX        ZDEST                                      MD022425
442600210712     C                   MOVEL     MGRAXX        ACLINE                                     MD022425
442700210712     C                   MOVEL     '91'          FLDNO                                      MD022425
442800210712     C                   MOVE      *BLANKS       TAG                                        MD022425
442900210712     C                   EXSR      SRFMPY                                                   MD022425
443000210712     C                   ELSE                                                               MD022425
443100210712     C     MGRLXX        IFEQ      *BLANKS                                                  MD022425
443200210712     C     MGRNXX        ANDEQ     *BLANKS                                                  MD022425
443300210712     C     MGRSXX        IFNE      *BLANKS                                                  MD022425
443400210712     C                   ADD       1             X                                          MD022425
443500210712     C     X             OCCUR     MULT                                                     MD022425
443600210712     C                   MOVEL     ':91A:'       MTAG                                       MD022425
443700210712     C                   MOVEL     *BLANKS       MFLD                                       MD022425
443800210712     C                   MOVEL     MGRSXX        MFLD                                       MD022425
443900210712     C                   ENDIF                                                              MD022425
444000210712     C                   ELSE                                                               MD022425
444100210712     C                   MOVEL     MGRPXX        WRKMRP                                     MD024078
444200210712     C                   MOVEL     MGRJXX        WRKMRJ                                     MD024078
444300210712     C                   MOVEL     MGRNXX        WRKMRN                                     MD024078
444400210712     C                   MOVEL     MGRCXX        WRKMRC                                     MD024078
444500210712     C                   MOVEL     MGRSXX        WRKMRS                                     MD024078
444600210712     C                   MOVEL     MGRLXX        WRKMRL                                     MD024078
444700210712     C                   MOVEL     MGRAXX        WRKMRA                                     MD024078
444800210712     C     MGRNXX        IFNE      *BLANKS                                                  MD022425
444900210712     C     MGRSXX        ANDNE     *BLANKS                                                  MD022425
445000210712     C     MGRNXX        ORNE      *BLANKS                                                  MD022425
445100210712     C     MGRLXX        ANDNE     *BLANKS                                                  MD022425
445200210712     C                   ADD       1             X                                          MD022425
445300210712     C     X             OCCUR     MULT                                                     MD022425
445400210712     C                   MOVEL     ':91J:'       MTAG                                       MD022425
445500210712     C     MGRSXX        IFNE      *BLANKS                                                  MD022425
445600210712     C     '/ABIC/'      CAT       MGRSXX        MFLD                                       MD022425
445700210712     C                   ELSE                                                               MD022425
445800210712     C     '/ABIC'       CAT       '/UKWN'       MFLD                                       MD022425
445900210712     C                   ENDIF                                                              MD022425
446000210712     C                   ADD       1             X                                          MD022425
446100210712     C     X             OCCUR     MULT                                                     MD022425
446200210712     C     MGRLXX        IFNE      *BLANKS                                                  MD022425
446300210712     C     '/LEIC/'      CAT       MGRLXX        MFLD                                       MD022425
446400210712     C                   ELSE                                                               MD022425
446500210712     C     '/NAME/'      CAT       MGRNXX        MFLD                                       MD022425
446600210712     C                   ENDIF                                                              MD022425
446700210712     C     MGRCXX        IFNE      *BLANKS                                                  MD022425
446800210712     C                   ADD       1             X                                          MD022425
446900210712     C     X             OCCUR     MULT                                                     MD022425
447000210712     C     '/NAME/'      CAT       MGRCXX        MFLD                                       MD022425
447100210712     C                   ENDIF                                                              MD022425
447200210712     C                   ELSE                                                               MD022425
447300210712     C     MGRNXX        IFNE      *BLANKS                                                  MD022425
447400210712     C                   ADD       1             X                                          MD022425
447500210712     C     X             OCCUR     MULT                                                     MD022425
447600210712     C                   MOVEL     ':91D:'       MTAG                                       MD022425
447700210712     C                   MOVEL     MGRNXX        MFLD                                       MD022425
447800210712     C     MGRCXX        IFNE      *BLANKS                                                  MD022425
447900210712     C                   ADD       1             X                                          MD022425
448000210712     C     X             OCCUR     MULT                                                     MD022425
448100210712     C                   MOVEL     MGRCXX        MFLD                                       MD022425
448200210712     C                   ENDIF                                                              MD022425
448300210712     C                   ENDIF                                                              MD022425
448400210712     C                   ENDIF                                                              MD022425
448500210712     C                   ENDIF                                                              MD022425
448600210712     C                   ENDIF                                                              MD022425
448700210712     C                   ENDIF                                                              MD024078
448800210712      *                                                                                     MD022425
448900210712      **  Unique Transaction Identifier/Prior Unique Transaction Identifier                 MD022425
449000210712      *                                                                                     MD022425
449100210712     C     MGUTXX        IFNE      *BLANKS                                                  MD022425
449200210712     C     MGTNXX        ANDNE     *BLANKS                                                  MD022425
449300210712     C     MGTIXX        IFEQ      '0'                                                      MD022425
449400210712     C                   ADD       1             X                                          MD022425
449500210712     C     X             OCCUR     MULT                                                     MD022425
449600210712     C                   MOVEL     ':22M:'       MTAG                                       MD022425
449700210712     C                   MOVEL     MGUTXX        MFLD                                       MD022425
449800210712     C                   ADD       1             X                                          MD022425
449900210712     C     X             OCCUR     MULT                                                     MD022425
450000210712     C                   MOVEL     ':22N:'       MTAG                                       MD022425
450100210712     C                   MOVEL     MGTNXX        MFLD                                       MD022425
450200210712     C                   MOVEL     'Y'           WRKFLG                                     MD022425
450300210712     C                   ELSE                                                               MD022425
450400210712     C     WRKFLG        IFEQ      'Y'                                                      MD022425
450500210712     C                   ADD       1             X                                          MD022425
450600210712     C     X             OCCUR     MULT                                                     MD022425
450700210712     C                   MOVEL     ':22P:'       MTAG                                       MD022425
450800210712     C                   MOVEL     MGUTXX        MFLD                                       MD022425
450900210712     C                   ADD       1             X                                          MD022425
451000210712     C     X             OCCUR     MULT                                                     MD022425
451100210712     C                   MOVEL     ':22R:'       MTAG                                       MD022425
451200210712     C                   MOVEL     MGTNXX        MFLD                                       MD022425
451300210712     C                   ELSE                                                               MD022425
451400210712     C                   ADD       1             X                                          MD022425
451500210712     C     X             OCCUR     MULT                                                     MD022425
451600210712     C                   MOVEL     ':22M:'       MTAG                                       MD022425
451700210712     C                   MOVEL     MGUTXX        MFLD                                       MD022425
451800210712     C                   ADD       1             X                                          MD022425
451900210712     C     X             OCCUR     MULT                                                     MD022425
452000210712     C                   MOVEL     ':22N:'       MTAG                                       MD022425
452100210712     C                   MOVEL     MGTNXX        MFLD                                       MD022425
452200210712     C                   MOVEL     'Y'           WRKFLG                                     MD022425
452300210712     C                   ENDIF                                                              MD022425
452400210712     C                   ENDIF                                                              MD022425
452500210712     C                   ENDIF                                                              MD022425
452600210712     C                   ENDIF                                                              MD022425
452700210712      *                                                                                     MD022425
452800210712     C                   ENDDO                                                              MD022425
452900210712      **********                                                                   MD022425 MD030880
453000210712      ****Central Counterparty Clearing House                                      MD022425 MD030880
453100210712      **********                                                                   MD022425 MD030880
453200210712     C*****MGCCPI        IFNE      *BLANKS                                         MD022425 MD030880
453300210712     C**********         MOVE      *BLANKS       ZDEST                             MD022425 MD030880
453400210712     C**********         MOVEL     MGCCPI        ZDEST                             MD022425 MD030880
453500210712     C**********         MOVEL     MGCCPA        ACLINE                            MD022425 MD030880
453600210712     C**********         MOVEL     '81'          FLDNO                             MD022425 MD030880
453700210712     C**********         MOVE      *BLANKS       TAG                               MD022425 MD030880
453800210712     C**********         EXSR      SRFMPY                                          MD022425 MD030880
453900210712     C**********         ENDIF                                                     MD022425 MD030880
454000210712      *                                                                                     MD022425
454100210712      **  Clearing Exception Party                                                          MD022425
454200210712      *                                                                                     MD022425
454300210712     C     MGCEPI        IFNE      *BLANKS                                                  MD022425
454400210712     C                   MOVE      *BLANKS       ZDEST                                      MD022425
454500210712     C                   MOVEL     MGCEPI        ZDEST                                      MD022425
454600210712     C                   MOVEL     MGCEPA        ACLINE                                     MD022425
454700210712     C                   MOVEL     '96'          FLDNO                                      MD022425
454800210712     C                   MOVE      *BLANKS       TAG                                        MD022425
454900210712     C                   EXSR      SRFMPY                                                   MD022425
455000210712     C                   ENDIF                                                              MD022425
455100210712      *                                                                                     MD022425
455200210712      **  Clearing Broker Identification                                                    MD022425
455300210712      *                                                                                     MD022425
455400210712     C     MGCBCI        IFNE      *BLANKS                                                  MD022425
455500210712     C                   ADD       1             X                                          MD022425
455600210712     C     X             OCCUR     MULT                                                     MD022425
455700210712     C                   MOVEL     ':22S:'       MTAG                                       MD022425
455800210712     C     'C/'          CAT       MGCBCI        MFLD                                       MD022425
455900210712     C                   ENDIF                                                              MD022425
456000210712     C     MGCBPI        IFNE      *BLANKS                                                  MD022425
456100210712     C                   ADD       1             X                                          MD022425
456200210712     C     X             OCCUR     MULT                                                     MD022425
456300210712     C                   MOVEL     ':22S:'       MTAG                                       MD022425
456400210712     C     'P/'          CAT       MGCBPI        MFLD                                       MD022425
456500210712     C                   ENDIF                                                              MD022425
456600210712      *                                                                                     MD022425
456700210712      **  Cleared Product Identification                                                    MD022425
456800210712      *                                                                                     MD022425
456900210712     C     MGPRID        IFNE      *BLANKS                                                  MD022425
457000210712     C                   ADD       1             X                                          MD022425
457100210712     C     X             OCCUR     MULT                                                     MD022425
457200210712     C                   MOVEL     ':22T:'       MTAG                                       MD022425
457300210712     C                   MOVEL     MGPRID        MFLD                                       MD022425
457400210712     C                   ENDIF                                                              MD022425
457500210712      *                                                                                     MD022425
457600210712      **  Clearing Threshold Indicator                                                      MD022425
457700210712      *                                                                                     MD022425
457800210712     C     MGCGTI        IFNE      *BLANKS                                                  MD022425
457900210712     C                   ADD       1             X                                          MD022425
458000210712     C     X             OCCUR     MULT                                                     MD022425
458100210712     C                   MOVEL     ':17E:'       MTAG                                       MD022425
458200210712     C                   MOVEL     MGCGTI        MFLD                                       MD022425
458300210712     C                   ENDIF                                                              MD022425
458400210712      *                                                                                     MD022425
458500210712      **  Underlying Product Identifier                                                     MD022425
458600210712      *                                                                                     MD022425
458700210712     C     MGUPID        IFNE      *BLANKS                                                  MD022425
458800210712     C                   ADD       1             X                                          MD022425
458900210712     C     X             OCCUR     MULT                                                     MD022425
459000210712     C                   MOVEL     ':22U:'       MTAG                                       MD022425
459100210712     C                   MOVEL     MGUPID        MFLD                                       MD022425
459200210712     C                   ENDIF                                                              MD022425
459300210712      *                                                                                     MD022425
459400210712      **  Allocation Indicator                                                              MD022425
459500210712      *                                                                                     MD022425
459600210712     C     MGALLI        IFNE      *BLANKS                                                  MD022425
459700210712     C                   ADD       1             X                                          MD022425
459800210712     C     X             OCCUR     MULT                                                     MD022425
459900210712     C                   MOVEL     ':17H:'       MTAG                                       MD022425
460000210712     C                   MOVEL     MGALLI        MFLD                                       MD022425
460100210712     C                   ENDIF                                                              MD022425
460200210712      *                                                                                     MD022425
460300210712      **  Collateralisation Indicator                                                       MD022425
460400210712      *                                                                                     MD022425
460500210712     C     MGCLLI        IFNE      *BLANKS                                                  MD022425
460600210712     C                   ADD       1             X                                          MD022425
460700210712     C     X             OCCUR     MULT                                                     MD022425
460800210712     C                   MOVEL     ':17P:'       MTAG                                       MD022425
460900210712     C                   MOVEL     MGCLLI        MFLD                                       MD022425
461000210712     C                   ENDIF                                                              MD022425
461100210712      *                                                                                     MD022425
461200210712      **  Execution Venue                                                                   MD022425
461300210712      *                                                                                     MD022425
461400210712     C     MGEXVE        IFNE      *BLANKS                                                  MD022425
461500210712     C                   ADD       1             X                                          MD022425
461600210712     C     X             OCCUR     MULT                                                     MD022425
461700210712     C                   MOVEL     ':22V:'       MTAG                                       MD022425
461800210712     C                   MOVEL     MGEXVE        MFLD                                       MD022425
461900210712     C                   ENDIF                                                              MD022425
462000210712      *                                                                                     MD022425
462100210712      **  Execution Timestamp                                                               MD022425
462200210712      *                                                                                     MD022425
462300210712     C     MGUTCT        IFNE      *ZEROS                                                   MD022425
462400210712     C     MGGEDT        ORNE      *ZEROS                                                   MD024078
462500210712     C     MGGETM        ORNE      *ZEROS                                                   MD024078
462600210712     C                   ADD       1             X                                          MD022425
462700210712     C     X             OCCUR     MULT                                                     MD022425
462800210712     C                   MOVEL     ':98D:'       MTAG                                       MD022425
462900210712     C                   MOVE      MGGEDT        DNGEDT            8                        MD022425
463000210712     C                   MOVE      MGGETM        DNGETM            6                        MD022425
463100210712     C                   MOVE      MGUTCT        DNUTCT            4                        MD022425
463200210712     C     MGUSGN        IFEQ      'N'                                                      MD022425
463300210712     C     DNGEDT        CAT       DNGETM        ETIME1           14                        MD022425
463400210712     C     '/N'          CAT       DNUTCT        ETIME2            6                        MD022425
463500210712     C     ETIME1        CAT       ETIME2        MFLD                                       MD022425
463600210712     C                   ELSE                                                               MD022425
463700210712     C     DNGEDT        CAT       DNGETM        ETIME1           14                        MD022425
463800210712     C     ETIME1        CAT       DNUTCT        MFLD                                       MD022425
463900210712     C                   ENDIF                                                              MD022425
464000210712     C                   ENDIF                                                              MD022425
464100210712      *                                                                                     MD022425
464200210712      **  Non Standard Flag                                                                 MD022425
464300210712      *                                                                                     MD022425
464400210712     C     MGNORS        IFNE      *BLANKS                                                  MD022425
464500210712     C                   ADD       1             X                                          MD022425
464600210712     C     X             OCCUR     MULT                                                     MD022425
464700210712     C                   MOVEL     ':17W:'       MTAG                                       MD022425
464800210712     C                   MOVEL     MGNORS        MFLD                                       MD022425
464900210712     C                   ENDIF                                                              MD022425
465000210712      *                                                                                     MD022425
465100210712      **  Link Swap Identification                                                          MD022425
465200210712      *                                                                                     MD022425
465300210712     C     MGLSID        IFNE      *BLANKS                                                  MD022425
465400210712     C                   ADD       1             X                                          MD022425
465500210712     C     X             OCCUR     MULT                                                     MD022425
465600210712     C                   MOVEL     ':22W:'       MTAG                                       MD022425
465700210712     C                   MOVEL     MGLSID        MFLD                                       MD022425
465800210712     C                   ENDIF                                                              MD022425
465900210712                                                                                              CSW214
466000210712     C                   IF        CSW214 = 'Y'                                               CSW214
466100210712                                                                                              CSW214
466200210712      ** Financial Nature of the Counterparty Indicator                                       CSW214
466300210712                                                                                              CSW214
466400210712     C                   IF        MGFNCI <> *BLANKS                                          CSW214
466500210712     C                   ADD       1             X                                            CSW214
466600210712     C     X             OCCUR     MULT                                                       CSW214
466700210712     C                   MOVEL     ':17Y:'       MTAG                                         CSW214
466800210712     C                   MOVEL     MGFNCI        MFLD                                         CSW214
466900210712     C                   ENDIF                                                                CSW214
467000210712                                                                                              CSW214
467100210712      ** Collateral Portfolio Indicator                                                       CSW214
467200210712                                                                                              CSW214
467300210712     C                   IF        MGCOPI <> *BLANKS                                          CSW214
467400210712     C                   ADD       1             X                                            CSW214
467500210712     C     X             OCCUR     MULT                                                       CSW214
467600210712     C                   MOVEL     ':17Z:'       MTAG                                         CSW214
467700210712     C                   MOVEL     MGCOPI        MFLD                                         CSW214
467800210712     C                   ENDIF                                                                CSW214
467900210712                                                                                              CSW214
468000210712      ** Collateral Portfolio Code                                                            CSW214
468100210712                                                                                              CSW214
468200210712     C                   IF        MGCOPI = 'Y' AND                                           CSW214
468300210712     C                             MGCOPC <> *BLANKS                                          CSW214
468400210712     C                   ADD       1             X                                            CSW214
468500210712     C     X             OCCUR     MULT                                                       CSW214
468600210712     C                   MOVEL     ':22Q:'       MTAG                                         CSW214
468700210712     C                   MOVEL     MGCOPC        MFLD                                         CSW214
468800210712     C                   ENDIF                                                                CSW214
468900210712                                                                                              CSW214
469000210712      ** Portfolio Compression Indicator                                                      CSW214
469100210712                                                                                              CSW214
469200210712     C                   IF        MGPOCI <> *BLANKS                                          CSW214
469300210712     C                   ADD       1             X                                            CSW214
469400210712     C     X             OCCUR     MULT                                                       CSW214
469500210712     C                   MOVEL     ':17L:'       MTAG                                         CSW214
469600210712     C                   MOVEL     MGPOCI        MFLD                                         CSW214
469700210712     C                   ENDIF                                                                CSW214
469800210712                                                                                              CSW214
469900210712      ** Corporate Sector Indicator                                                           CSW214
470000210712                                                                                              CSW214
470100210712     C                   IF        MGCOSI <> *BLANKS                                          CSW214
470200210712     C                   ADD       1             X                                            CSW214
470300210712     C     X             OCCUR     MULT                                                       CSW214
470400210712     C                   MOVEL     ':17M:'       MTAG                                         CSW214
470500210712     C                   MOVEL     MGCOSI        MFLD                                         CSW214
470600210712     C                   ENDIF                                                                CSW214
470700210712                                                                                              CSW214
470800210712      ** Trade with Non-EEA Counterparty Indicator                                            CSW214
470900210712                                                                                              CSW214
471000210712     C                   IF        MGTNEI <> *BLANKS                                          CSW214
471100210712     C                   ADD       1             X                                            CSW214
471200210712     C     X             OCCUR     MULT                                                       CSW214
471300210712     C                   MOVEL     ':17Q:'       MTAG                                         CSW214
471400210712     C                   MOVEL     MGTNEI        MFLD                                         CSW214
471500210712     C                   ENDIF                                                                CSW214
471600210712                                                                                              CSW214
471700210712      ** Intragroup Trade Indicator                                                           CSW214
471800210712                                                                                              CSW214
471900210712     C                   IF        MGIGTI <> *BLANKS                                          CSW214
472000210712     C                   ADD       1             X                                            CSW214
472100210712     C     X             OCCUR     MULT                                                       CSW214
472200210712     C                   MOVEL     ':17S:'       MTAG                                         CSW214
472300210712     C                   MOVEL     MGIGTI        MFLD                                         CSW214
472400210712     C                   ENDIF                                                                CSW214
472500210712                                                                                              CSW214
472600210712      ** Commercial or Treasury Financial Indicator                                           CSW214
472700210712                                                                                              CSW214
472800210712     C                   IF        MGCTFI <> *BLANKS                                          CSW214
472900210712     C                   ADD       1             X                                            CSW214
473000210712     C     X             OCCUR     MULT                                                       CSW214
473100210712     C                   MOVEL     ':17X:'       MTAG                                         CSW214
473200210712     C                   MOVEL     MGCTFI        MFLD                                         CSW214
473300210712     C                   ENDIF                                                                CSW214
473400210712                                                                                              CSW214
473500210712     C                   ENDIF                                                                CSW214
473600210712      *                                                                                     MD022425
473700210712      **  Additional Reporting Information                                                  MD022425
473800210712      *                                                                                     MD022425
473900210712     C     MGAR01        IFNE      *BLANKS                                                  MD022425
474000210712     C     MGAR02        ORNE      *BLANKS                                                  MD022425
474100210712     C     MGAR03        ORNE      *BLANKS                                                  MD022425
474200210712     C     MGAR04        ORNE      *BLANKS                                                  MD022425
474300210712     C     MGAR05        ORNE      *BLANKS                                                  MD022425
474400210712     C     MGAR06        ORNE      *BLANKS                                                  MD022425
474500210712     C     MGAR07        ORNE      *BLANKS                                                  MD022425
474600210712     C     MGAR08        ORNE      *BLANKS                                                  MD022425
474700210712     C     MGAR09        ORNE      *BLANKS                                                  MD022425
474800210712     C     MGAR10        ORNE      *BLANKS                                                  MD022425
474900210712     C     MGAR11        ORNE      *BLANKS                                                  MD022425
475000210712     C     MGAR12        ORNE      *BLANKS                                                  MD022425
475100210712     C     MGAR13        ORNE      *BLANKS                                                  MD022425
475200210712     C     MGAR14        ORNE      *BLANKS                                                  MD022425
475300210712     C     MGAR15        ORNE      *BLANKS                                                  MD022425
475400210712     C     MGAR16        ORNE      *BLANKS                                                  MD022425
475500210712     C     MGAR17        ORNE      *BLANKS                                                  MD022425
475600210712     C     MGAR18        ORNE      *BLANKS                                                  MD022425
475700210712     C     MGAR19        ORNE      *BLANKS                                                  MD022425
475800210712     C     MGAR20        ORNE      *BLANKS                                                  MD022425
475900210712      *                                                                                     MD022425
476000210712     C                   MOVE      *BLANK        DN77              1                        MD022425
476100210712     C     MGAR01        IFNE      *BLANK                                                   MD022425
476200210712     C                   ADD       1             X                                          MD022425
476300210712     C     X             OCCUR     MULT                                                     MD022425
476400210712     C     DN77          IFNE      'Y'                                                      MD022425
476500210712     C                   MOVE      ':77A:'       MTAG                                       MD022425
476600210712     C                   MOVE      'Y'           DN77                                       MD022425
476700210712     C                   ENDIF                                                              MD022425
476800210712     C                   MOVE      *BLANK        MFLD                                       MD022425
476900210712     C                   MOVEL     MGAR01        MFLD                                       MD022425
477000210712     C                   ENDIF                                                              MD022425
477100210712     C     MGAR02        IFNE      *BLANK                                                   MD022425
477200210712     C                   ADD       1             X                                          MD022425
477300210712     C     X             OCCUR     MULT                                                     MD022425
477400210712     C     DN77          IFNE      'Y'                                                      MD022425
477500210712     C                   MOVE      ':77A:'       MTAG                                       MD022425
477600210712     C                   MOVE      'Y'           DN77                                       MD022425
477700210712     C                   ENDIF                                                              MD022425
477800210712     C                   MOVE      *BLANK        MFLD                                       MD022425
477900210712     C                   MOVEL     MGAR02        MFLD                                       MD022425
478000210712     C                   ENDIF                                                              MD022425
478100210712     C     MGAR03        IFNE      *BLANK                                                   MD022425
478200210712     C                   ADD       1             X                                          MD022425
478300210712     C     X             OCCUR     MULT                                                     MD022425
478400210712     C     DN77          IFNE      'Y'                                                      MD022425
478500210712     C                   MOVE      ':77A:'       MTAG                                       MD022425
478600210712     C                   MOVE      'Y'           DN77                                       MD022425
478700210712     C                   ENDIF                                                              MD022425
478800210712     C                   MOVE      *BLANK        MFLD                                       MD022425
478900210712     C                   MOVEL     MGAR03        MFLD                                       MD022425
479000210712     C                   ENDIF                                                              MD022425
479100210712     C     MGAR04        IFNE      *BLANK                                                   MD022425
479200210712     C                   ADD       1             X                                          MD022425
479300210712     C     X             OCCUR     MULT                                                     MD022425
479400210712     C     DN77          IFNE      'Y'                                                      MD022425
479500210712     C                   MOVE      ':77A:'       MTAG                                       MD022425
479600210712     C                   MOVE      'Y'           DN77                                       MD022425
479700210712     C                   ENDIF                                                              MD022425
479800210712     C                   MOVE      *BLANK        MFLD                                       MD022425
479900210712     C                   MOVEL     MGAR04        MFLD                                       MD022425
480000210712     C                   ENDIF                                                              MD022425
480100210712     C     MGAR05        IFNE      *BLANK                                                   MD022425
480200210712     C                   ADD       1             X                                          MD022425
480300210712     C     X             OCCUR     MULT                                                     MD022425
480400210712     C     DN77          IFNE      'Y'                                                      MD022425
480500210712     C                   MOVE      ':77A:'       MTAG                                       MD022425
480600210712     C                   MOVE      'Y'           DN77                                       MD022425
480700210712     C                   ENDIF                                                              MD022425
480800210712     C                   MOVE      *BLANK        MFLD                                       MD022425
480900210712     C                   MOVEL     MGAR05        MFLD                                       MD022425
481000210712     C                   ENDIF                                                              MD022425
481100210712     C     MGAR06        IFNE      *BLANK                                                   MD022425
481200210712     C                   ADD       1             X                                          MD022425
481300210712     C     X             OCCUR     MULT                                                     MD022425
481400210712     C     DN77          IFNE      'Y'                                                      MD022425
481500210712     C                   MOVE      ':77A:'       MTAG                                       MD022425
481600210712     C                   MOVE      'Y'           DN77                                       MD022425
481700210712     C                   ENDIF                                                              MD022425
481800210712     C                   MOVE      *BLANK        MFLD                                       MD022425
481900210712     C                   MOVEL     MGAR06        MFLD                                       MD022425
482000210712     C                   ENDIF                                                              MD022425
482100210712     C     MGAR07        IFNE      *BLANK                                                   MD022425
482200210712     C                   ADD       1             X                                          MD022425
482300210712     C     X             OCCUR     MULT                                                     MD022425
482400210712     C     DN77          IFNE      'Y'                                                      MD022425
482500210712     C                   MOVE      ':77A:'       MTAG                                       MD022425
482600210712     C                   MOVE      'Y'           DN77                                       MD022425
482700210712     C                   ENDIF                                                              MD022425
482800210712     C                   MOVE      *BLANK        MFLD                                       MD022425
482900210712     C                   MOVEL     MGAR07        MFLD                                       MD022425
483000210712     C                   ENDIF                                                              MD022425
483100210712     C     MGAR08        IFNE      *BLANK                                                   MD022425
483200210712     C                   ADD       1             X                                          MD022425
483300210712     C     X             OCCUR     MULT                                                     MD022425
483400210712     C     DN77          IFNE      'Y'                                                      MD022425
483500210712     C                   MOVE      ':77A:'       MTAG                                       MD022425
483600210712     C                   MOVE      'Y'           DN77                                       MD022425
483700210712     C                   ENDIF                                                              MD022425
483800210712     C                   MOVE      *BLANK        MFLD                                       MD022425
483900210712     C                   MOVEL     MGAR08        MFLD                                       MD022425
484000210712     C                   ENDIF                                                              MD022425
484100210712     C     MGAR09        IFNE      *BLANK                                                   MD022425
484200210712     C                   ADD       1             X                                          MD022425
484300210712     C     X             OCCUR     MULT                                                     MD022425
484400210712     C     DN77          IFNE      'Y'                                                      MD022425
484500210712     C                   MOVE      ':77A:'       MTAG                                       MD022425
484600210712     C                   MOVE      'Y'           DN77                                       MD022425
484700210712     C                   ENDIF                                                              MD022425
484800210712     C                   MOVE      *BLANK        MFLD                                       MD022425
484900210712     C                   MOVEL     MGAR09        MFLD                                       MD022425
485000210712     C                   ENDIF                                                              MD022425
485100210712     C     MGAR10        IFNE      *BLANK                                                   MD022425
485200210712     C                   ADD       1             X                                          MD022425
485300210712     C     X             OCCUR     MULT                                                     MD022425
485400210712     C     DN77          IFNE      'Y'                                                      MD022425
485500210712     C                   MOVE      ':77A:'       MTAG                                       MD022425
485600210712     C                   MOVE      'Y'           DN77                                       MD022425
485700210712     C                   ENDIF                                                              MD022425
485800210712     C                   MOVE      *BLANK        MFLD                                       MD022425
485900210712     C                   MOVEL     MGAR10        MFLD                                       MD022425
486000210712     C                   ENDIF                                                              MD022425
486100210712     C     MGAR11        IFNE      *BLANK                                                   MD022425
486200210712     C                   ADD       1             X                                          MD022425
486300210712     C     X             OCCUR     MULT                                                     MD022425
486400210712     C     DN77          IFNE      'Y'                                                      MD022425
486500210712     C                   MOVE      ':77A:'       MTAG                                       MD022425
486600210712     C                   MOVE      'Y'           DN77                                       MD022425
486700210712     C                   ENDIF                                                              MD022425
486800210712     C                   MOVE      *BLANK        MFLD                                       MD022425
486900210712     C                   MOVEL     MGAR11        MFLD                                       MD022425
487000210712     C                   ENDIF                                                              MD022425
487100210712     C     MGAR12        IFNE      *BLANK                                                   MD022425
487200210712     C                   ADD       1             X                                          MD022425
487300210712     C     X             OCCUR     MULT                                                     MD022425
487400210712     C     DN77          IFNE      'Y'                                                      MD022425
487500210712     C                   MOVE      ':77A:'       MTAG                                       MD022425
487600210712     C                   MOVE      'Y'           DN77                                       MD022425
487700210712     C                   ENDIF                                                              MD022425
487800210712     C                   MOVE      *BLANK        MFLD                                       MD022425
487900210712     C                   MOVEL     MGAR12        MFLD                                       MD022425
488000210712     C                   ENDIF                                                              MD022425
488100210712     C     MGAR13        IFNE      *BLANK                                                   MD022425
488200210712     C                   ADD       1             X                                          MD022425
488300210712     C     X             OCCUR     MULT                                                     MD022425
488400210712     C     DN77          IFNE      'Y'                                                      MD022425
488500210712     C                   MOVE      ':77A:'       MTAG                                       MD022425
488600210712     C                   MOVE      'Y'           DN77                                       MD022425
488700210712     C                   ENDIF                                                              MD022425
488800210712     C                   MOVE      *BLANK        MFLD                                       MD022425
488900210712     C                   MOVEL     MGAR13        MFLD                                       MD022425
489000210712     C                   ENDIF                                                              MD022425
489100210712     C     MGAR14        IFNE      *BLANK                                                   MD022425
489200210712     C                   ADD       1             X                                          MD022425
489300210712     C     X             OCCUR     MULT                                                     MD022425
489400210712     C     DN77          IFNE      'Y'                                                      MD022425
489500210712     C                   MOVE      ':77A:'       MTAG                                       MD022425
489600210712     C                   MOVE      'Y'           DN77                                       MD022425
489700210712     C                   ENDIF                                                              MD022425
489800210712     C                   MOVE      *BLANK        MFLD                                       MD022425
489900210712     C                   MOVEL     MGAR14        MFLD                                       MD022425
490000210712     C                   ENDIF                                                              MD022425
490100210712     C     MGAR15        IFNE      *BLANK                                                   MD022425
490200210712     C                   ADD       1             X                                          MD022425
490300210712     C     X             OCCUR     MULT                                                     MD022425
490400210712     C     DN77          IFNE      'Y'                                                      MD022425
490500210712     C                   MOVE      ':77A:'       MTAG                                       MD022425
490600210712     C                   MOVE      'Y'           DN77                                       MD022425
490700210712     C                   ENDIF                                                              MD022425
490800210712     C                   MOVE      *BLANK        MFLD                                       MD022425
490900210712     C                   MOVEL     MGAR15        MFLD                                       MD022425
491000210712     C                   ENDIF                                                              MD022425
491100210712     C     MGAR16        IFNE      *BLANK                                                   MD022425
491200210712     C                   ADD       1             X                                          MD022425
491300210712     C     X             OCCUR     MULT                                                     MD022425
491400210712     C     DN77          IFNE      'Y'                                                      MD022425
491500210712     C                   MOVE      ':77A:'       MTAG                                       MD022425
491600210712     C                   MOVE      'Y'           DN77                                       MD022425
491700210712     C                   ENDIF                                                              MD022425
491800210712     C                   MOVE      *BLANK        MFLD                                       MD022425
491900210712     C                   MOVEL     MGAR16        MFLD                                       MD022425
492000210712     C                   ENDIF                                                              MD022425
492100210712     C     MGAR17        IFNE      *BLANK                                                   MD022425
492200210712     C                   ADD       1             X                                          MD022425
492300210712     C     X             OCCUR     MULT                                                     MD022425
492400210712     C     DN77          IFNE      'Y'                                                      MD022425
492500210712     C                   MOVE      ':77A:'       MTAG                                       MD022425
492600210712     C                   MOVE      'Y'           DN77                                       MD022425
492700210712     C                   ENDIF                                                              MD022425
492800210712     C                   MOVE      *BLANK        MFLD                                       MD022425
492900210712     C                   MOVEL     MGAR17        MFLD                                       MD022425
493000210712     C                   ENDIF                                                              MD022425
493100210712     C     MGAR18        IFNE      *BLANK                                                   MD022425
493200210712     C                   ADD       1             X                                          MD022425
493300210712     C     X             OCCUR     MULT                                                     MD022425
493400210712     C     DN77          IFNE      'Y'                                                      MD022425
493500210712     C                   MOVE      ':77A:'       MTAG                                       MD022425
493600210712     C                   MOVE      'Y'           DN77                                       MD022425
493700210712     C                   ENDIF                                                              MD022425
493800210712     C                   MOVE      *BLANK        MFLD                                       MD022425
493900210712     C                   MOVEL     MGAR18        MFLD                                       MD022425
494000210712     C                   ENDIF                                                              MD022425
494100210712     C     MGAR19        IFNE      *BLANK                                                   MD022425
494200210712     C                   ADD       1             X                                          MD022425
494300210712     C     X             OCCUR     MULT                                                     MD022425
494400210712     C     DN77          IFNE      'Y'                                                      MD022425
494500210712     C                   MOVE      ':77A:'       MTAG                                       MD022425
494600210712     C                   MOVE      'Y'           DN77                                       MD022425
494700210712     C                   ENDIF                                                              MD022425
494800210712     C                   MOVE      *BLANK        MFLD                                       MD022425
494900210712     C                   MOVEL     MGAR19        MFLD                                       MD022425
495000210712     C                   ENDIF                                                              MD022425
495100210712     C     MGAR20        IFNE      *BLANK                                                   MD022425
495200210712     C                   ADD       1             X                                          MD022425
495300210712     C     X             OCCUR     MULT                                                     MD022425
495400210712     C     DN77          IFNE      'Y'                                                      MD022425
495500210712     C                   MOVE      ':77A:'       MTAG                                       MD022425
495600210712     C                   MOVE      'Y'           DN77                                       MD022425
495700210712     C                   ENDIF                                                              MD022425
495800210712     C                   MOVE      *BLANK        MFLD                                       MD022425
495900210712     C                   MOVEL     MGAR20        MFLD                                       MD022425
496000210712     C                   ENDIF                                                              MD022425
496100210712     C                   ENDIF                                                              MD022425
496200210712      *                                                                                     MD022425
496300210712     C     X             IFEQ      X15D                                                     MD024078
496400210712     C                   MOVE      *BLANKS       MTAG                                       MD024078
496500210712     C                   SUB       1             X                                          MD024078
496600210712     C                   ENDIF                                                              MD024078
496700210712      *                                                                                     MD024078
496800210712     C                   ENDSR                                                              MD022425
496900210712     C/EJECT                                                                                MD022425
497000210712      *****************************************************************                     MD022425
497100210712      *   SRFMPY - Format message - Cust. Extension SWIFT Details     *                     MD022425
497200210712      *   Called by   Main process                                    *                     MD022425
497300210712      *   Calls - None                                                *                     MD022425
497400210712      *****************************************************************                     MD022425
497500210712      *                                                                                     MD022425
497600210712     C     SRFMPY        BEGSR                                                              MD022425
497700210712      *                                                                                     MD022425
497800210712     C     ACLINE        IFNE      *BLANKS                                                  MD022425
497900210712     C     1             SUBST     ACLINE:1      ACTEMP            1                        MD022425
498000210712     C     ACTEMP        IFNE      '/'                                                      MD022425
498100210712     C     '/'           CAT       ACLINE        ACLINE                                     MD022425
498200210712     C                   ENDIF                                                              MD022425
498300210712      *                                                                                     MD022425
498400210712      **  Access Customer for with ZDEST (10 first characters) field using                  MD022425
498500210712      **  AOCSSWR0 - Customer Extension SWIFT Details                                       MD022425
498600210712      *                                                                                     MD022425
498700210712     C                   CALL      'AOCSSWR0'                                               MD022425
498800210712     C                   PARM      '*MSG   '     @RTCD             7                        MD022425
498900210712     C                   PARM      '*KEY   '     @OPTN             7                        MD022425
499000210712     C                   PARM      ZDEST         @KEY1            10                        MD022425
499100210712     C                   PARM      *BLANKS       @KYST             7                        MD022425
499200210712     C                   PARM                    DSLDY                                      MD022425
499300210712      *                                                                                     MD022425
499400210712      ** Extract SDCUSTPD and SDCSSWPD                                                      MD024078
499500210712      *                                                                                     MD024078
499600210712     C                   MOVEL     'SDCUSTPD'    P#FILN                                     MD024078
499700210712     C                   EXSR      GETRCL                                                   MD024078
499800210712     C     P#RCDL        SUBST     DSLDY         SDCUST                                     MD024078
499900210712     C     P#RCDL        ADD       1             WLEN              5 0                      MD024078
500000210712      *                                                                                     MD024078
500100210712     C                   MOVEL     'SDCSSWPD'    P#FILN                                     MD024078
500200210712     C                   EXSR      GETRCL                                                   MD024078
500300210712     C     P#RCDL        SUBST     DSLDY:WLEN    SDCSSW                                     MD024078
500400210712      *                                                                                     MD024078
500500210712     C     BBCSID        IFNE      *BLANKS                                                  MD022425
500600210712     C                   ADD       1             X                                          MD022425
500700210712     C     X             OCCUR     MULT                                                     MD022425
500800210712     C                   MOVEL     'A'           TAG                                        MD022425
500900210712     C                   MOVEL     @MTAG         MTAG                                       MD022425
501000210712     C     ACLINE        IFNE      *BLANKS                                                  MD022425
501100210712     C                   MOVEL     ACLINE        MFLD                                       MD022425
501200210712     C                   ENDIF                                                              MD022425
501300210712     C                   ADD       1             X                                          MD022425
501400210712     C     X             OCCUR     MULT                                                     MD022425
501500210712     C                   MOVEL     BBCSID        MFLD                                       MD022425
501600210712     C                   ELSE                                                               MD022425
501700210712     C                   ADD       1             X                                          MD022425
501800210712     C     X             OCCUR     MULT                                                     MD022425
501900210712     C                   MOVEL     'J'           TAG                                        MD022425
502000210712     C                   MOVEL     @MTAG         MTAG                                       MD022425
502100210712     C     '/ABIC'       CAT       '/UKWN'       ABIUKW           10                        MD022425
502200210712     C                   MOVEL     ABIUKW        MFLD                                       MD022425
502300210712     C     CSCLID        IFNE      *BLANKS                                                  MD022425
502400210712     C     CSCLSY        IFNE      *BLANKS                                                  MD022425
502500210712     C                   ADD       1             X                                          MD022425
502600210712     C     X             OCCUR     MULT                                                     MD022425
502700210712     C     '/CLRC/'      CAT       CSCLSY        CLRTMP           10                        MD022425
502800210712     C     CLRTMP        CAT       CSCLID        MFLD                                       MD022425
502900210712     C                   ELSE                                                               MD022425
503000210712     C                   ADD       1             X                                          MD022425
503100210712     C     X             OCCUR     MULT                                                     MD022425
503200210712     C     '/CLRC/'      CAT       CSCLID        MFLD                                       MD022425
503300210712     C                   ENDIF                                                              MD022425
503400210712     C                   ELSE                                                               MD022425
503500210712     C     BBCHID        IFNE      *ZEROS                                                   MD022425
503600210712     C                   ADD       1             X                                          MD022425
503700210712     C     X             OCCUR     MULT                                                     MD022425
503800210712     C     '/CLRC'       CAT       '/CH'         CLRCH             8                        MD022425
503900210712     C                   MOVE      BBCHID        DNCHID            6                        MD022425
504000210712     C     CLRCH         CAT       DNCHID        MFLD                                       MD022425
504100210712     C                   ENDIF                                                              MD022425
504200210712     C     BBCHSC        IFNE      *ZEROS                                                   MD022425
504300210712     C                   ADD       1             X                                          MD022425
504400210712     C     X             OCCUR     MULT                                                     MD022425
504500210712     C     '/CLRC'       CAT       '/SC'         CLRSC             8                        MD022425
504600210712     C                   MOVE      BBCHSC        DNCHSC            6                        MD022425
504700210712     C     CLRSC         CAT       DNCHSC        MFLD                                       MD022425
504800210712     C                   ENDIF                                                              MD022425
504900210712     C     BBCABA        IFNE      *ZEROS                                                   MD022425
505000210712     C                   ADD       1             X                                          MD022425
505100210712     C     X             OCCUR     MULT                                                     MD022425
505200210712     C     '/CLRC'       CAT       '/CP'         CLRCP             8                        MD022425
505300210712     C                   MOVE      BBCABA        DNCABA            3                        MD022425
505400210712     C     CLRCP         CAT       DNCABA        MFLD                                       MD022425
505500210712     C                   ENDIF                                                              MD022425
505600210712     C     BBBFIC        IFNE      *BLANKS                                                  MD022425
505700210712     C                   ADD       1             X                                          MD022425
505800210712     C     X             OCCUR     MULT                                                     MD022425
505900210712     C     '/CLRC'       CAT       '/BJ'         CLRBJ             8                        MD022425
506000210712     C     CLRBJ         CAT       BBBFIC        MFLD                                       MD022425
506100210712     C                   ENDIF                                                              MD022425
506200210712     C     BBBLCD        IFNE      *BLANKS                                                  MD022425
506300210712     C                   ADD       1             X                                          MD022425
506400210712     C     X             OCCUR     MULT                                                     MD022425
506500210712     C     '/CLRC'       CAT       '/BL'         CLRBL             8                        MD022425
506600210712     C     CLRBL         CAT       BBBLCD        MFLD                                       MD022425
506700210712     C                   ENDIF                                                              MD022425
506800210712     C     BBFWCD        IFNE      *ZEROS                                                   MD022425
506900210712     C                   ADD       1             X                                          MD022425
507000210712     C     X             OCCUR     MULT                                                     MD022425
507100210712     C     '/CLRC'       CAT       '/FW'         CLRFW             8                        MD022425
507200210712     C                   MOVE      BBFWCD        DNFWCD            9                        MD022425
507300210712     C     CLRFW         CAT       DNFWCD        MFLD                                       MD022425
507400210712     C                   ENDIF                                                              MD022425
507500210712     C                   ENDIF                                                              MD022425
507600210712     C     CSLEIC        IFNE      *BLANKS                                                  MD022425
507700210712     C                   ADD       1             X                                          MD022425
507800210712     C     X             OCCUR     MULT                                                     MD022425
507900210712     C     '/LEIC/'      CAT       CSLEIC        MFLD                                       MD022425
508000210712     C                   ENDIF                                                              MD022425
508100210712     C                   ADD       1             X                                          MD022425
508200210712     C     X             OCCUR     MULT                                                     MD022425
508300210712     C     '/NAME/'      CAT       BBCNA1        MFLD                                       MD022425
508400210712     C                   ENDIF                                                              MD022425
508500210712     C                   ELSE                                                               MD022425
508600210712     C                   ADD       1             X                                          MD024078
508700210712     C     X             OCCUR     MULT                                                     MD024078
508800210712     C                   EXSR      FSWAD                                                    MD022425
508900210712     C                   ENDIF                                                              MD022425
509000210712     C                   ENDSR                                                              MD022425
509100210712     C/EJECT                                                                                MD022425
509200210712      *****************************************************************                     MD055694
509300210712      *   SRFMTJ - Format message detail - Sequence J                 *                     MD055694
509400210712      *   Called by   Main process                                    *                     MD055694
509500210712      *   Calls                                                       *                     MD055694
509600210712      *****************************************************************                     MD055694
509700210712                                                                                            MD055694
509800210712     C     SRFMTJ        BEGSR                                                              MD055694
509900210712                                                                                            MD055694
510000210712     C                   CALL      JFRMAT                                                   MD055694
510100210712     C                   PARM      ZDEST         PCUST            12                        MD055694
510200210712     C                   PARM      FLDNO         PTAG              2                        MD055694
510300210712     C                   PARM      ACLINE        PACLNE           35                        MD055694
510400210712     C                   PARM      *BLANKS       PLINE1           40                        MD055694
510500210712     C                   PARM      *BLANKS       PLINE2           40                        MD055694
510600210712     C                   PARM      *BLANKS       PLINE3           40                        MD055694
510700210712     C                   PARM      *BLANKS       PLINE4           40                        MD055694
510800210712     C                   PARM      *BLANKS       PLINE5           40                        MD055694
510900210712                                                                                            MD055694
511000210712     C                   MOVEL     *BLANKS       MFLD                                       MD055694
511100210712     C                   MOVE      'J'           TAG                                        MD055694
511200210712     C                   MOVE      @MTAG         MTAG                                       MD055694
511300210712     C                   MOVEL     PLINE1        MFLD                                       MD055694
511400210712                                                                                            MD055694
511500210712     C                   MOVEL     *BLANKS       RESULT           34                        MD055694
511600210712     C                   EVAL      RESULT = %SUBST(PLINE2:7)                                MD055694
511700210712     C                   IF        RESULT <> *BLANKS                                        MD055694
511800210712     C                   ADD       1             X                                          MD055694
511900210712     C     X             OCCUR     MULT                                                     MD055694
512000210712     C                   MOVEL     *BLANKS       MFLD                                       MD055694
512100210712     C                   MOVEL     PLINE2        MFLD                                       MD055694
512200210712     C                   ENDIF                                                              MD055694
512300210712                                                                                            MD055694
512400210712     C                   MOVEL     *BLANKS       RESULT                                     MD055694
512500210712     C                   EVAL      RESULT = %SUBST(PLINE3:7)                                MD055694
512600210712     C                   IF        RESULT <> *BLANKS                                        MD055694
512700210712     C                   ADD       1             X                                          MD055694
512800210712     C     X             OCCUR     MULT                                                     MD055694
512900210712     C                   MOVEL     *BLANKS       MFLD                                       MD055694
513000210712     C                   MOVEL     PLINE3        MFLD                                       MD055694
513100210712     C                   ENDIF                                                              MD055694
513200210712                                                                                            MD055694
513300210712     C                   MOVEL     *BLANKS       RESULT                                     MD055694
513400210712     C                   EVAL      RESULT = %SUBST(PLINE4:7)                                MD055694
513500210712     C                   IF        RESULT <> *BLANKS                                        MD055694
513600210712     C                   ADD       1             X                                          MD055694
513700210712     C     X             OCCUR     MULT                                                     MD055694
513800210712     C                   MOVEL     *BLANKS       MFLD                                       MD055694
513900210712     C                   MOVEL     PLINE4        MFLD                                       MD055694
514000210712     C                   ENDIF                                                              MD055694
514100210712                                                                                            MD055694
514200210712     C                   MOVEL     *BLANKS       RESULT                                     MD055694
514300210712     C                   EVAL      RESULT = %SUBST(PLINE5:7)                                MD055694
514400210712     C                   IF        RESULT <> *BLANKS                                        MD055694
514500210712     C                   ADD       1             X                                          MD055694
514600210712     C     X             OCCUR     MULT                                                     MD055694
514700210712     C                   MOVEL     *BLANKS       MFLD                                       MD055694
514800210712     C                   MOVEL     PLINE5        MFLD                                       MD055694
514900210712     C                   ENDIF                                                              MD055694
515000210712                                                                                            MD055694
515100210712     C                   ENDSR                                                              MD055694
515200210712     C/EJECT                                                                                MD055694
515300210712      ****************************************************************                      MD055694
515400210712      *                                                              *                      MD055694
515500210712      *  SWF8XJ - Remove invalid codes from MT3xx Receiver Party     *                      MD055694
515600210712      *                                                              *                      MD055694
515700210712      ****************************************************************                      MD055694
515800210712      *                                                                                     MD055694
515900210712     C     SWF8XJ        BEGSR                                                              MD055694
516000210712                                                                                            MD055694
516100210712     C                   MOVEL     'N'           WOUT8X            1                        MD055694
516200210712     C                   Z-ADD     0             WPos              2 0                      MD055694
516300210712     C                   EVAL      AN8X = *BLANKS                                           MD055694
516400210712     C                   IF        AR8XJ(1) <> *BLANKS                                      MD055694
516500210712                                                                                            MD055694
516600210712     C                   Z-ADD     1             W                 1 0                      MD055694
516700210712     C                   Z-ADD     1             Q                 1 0                      MD055694
516800210712                                                                                            MD055694
516900210712     C                   DOW       W < 6                                                    MD055694
517000210712     C                   EVAL      WPos = %SCAN('/ABIC/UKWN':AR8XJ(W):1)                    MD055694
517100210712     C                   IF        WPos = 0                                                 MD055694
517200210712     C                   EVAL      WPos = %SCAN('/GBSC/':AR8XJ(W):1)                        MD055694
517300210712     C                   IF        WPos = 0                                                 MD055694
517400210712     C                   EVAL      WPos = %SCAN('/USCH/':AR8XJ(W):1)                        MD055694
517500210712     C                   IF        WPos = 0                                                 MD055694
517600210712     C                   EVAL      WPos = %SCAN('/USFW/':AR8XJ(W):1)                        MD055694
517700210712     C                   ENDIF                                                              MD055694
517800210712     C                   ENDIF                                                              MD055694
517900210712     C                   ENDIF                                                              MD055694
518000210712                                                                                            MD055694
518100210712     C                   IF        WPos = 0                                                 MD055694
518200210712     C                   EVAL      AN8X(Q) = AR8XJ(W)                                       MD055694
518300210712     C                   ADD       1             Q                                          MD055694
518400210712     C                   ENDIF                                                              MD055694
518500210712                                                                                            MD055694
518600210712     C                   ADD       1             W                                          MD055694
518700210712                                                                                            MD055694
518800210712     C                   ENDDO                                                              MD055694
518900210712                                                                                            MD055694
519000210712     C                   IF        AN8X(1) = *BLANKS                                        MD055694
519100210712     C                             OR AN8X(1) = '/ABIC/' AND AN8X(2) = *BLANKS              MD055694
519200210712     C                   EVAL      WOUT8X = 'N'                                             MD055694
519300210712     C                   ELSE                                                               MD055694
519400210712     C                   EVAL      WOUT8X = 'Y'                                             MD055694
519500210712     C                   ENDIF                                                              MD055694
519600210712      *                                                                                     MD055694
519700210712     C                   ELSE                                                               MD055694
519800210712     C                   EVAL      AN8X = *BLANKS                                           MD055694
519900210712      *                                                                                     MD055694
520000210712     C                   ENDIF                                                              MD055694
520100210712      *                                                                                     MD055694
520200210712     C                   ENDSR                                                              MD055694
520300210712      ****************************************************************                      MD055694
520400210712     C/EJECT                                                                                MD055694
520500210712      *****************************************************************
520600210712     C/COPY WNCPYSRC,MG0600C036
520700210712      *****************************************************************
520800210712     C/EJECT
520900210712      *****************************************************************
521000210712      *                                                               *
521100210712      *   *PSSR - Error handling                                      *
521200210712      *                                                               *
521300210712      *****************************************************************
521400210712      *
521500210712     C     *PSSR         BEGSR
521600210712
521700210712      **  Write database error to report
521800210712
521900210712     C                   OPEN      MG000600AU
522000210712     C                   WRITE     HEAD
522100210712     C                   WRITE     DBERROR
522200210712
522300210712     C                   SETON                                        U7U8LR
522400210712     C                   DUMP
522500210712     C                   RETURN
522600210712
522700210712     C                   ENDSR
522800210712      *****************************************************************
522900210712     C/EJECT
523000210712      *****************************************************************
523100210712     C/COPY MGCPYSRC,MGSWIFTRAN
523200210712** CPY@   Object Copyright
523300210712(c) Finastra International Limited 2012
523400210712** MSGA   Messages
523500210712Settlement - pay
523600210712Customer details not found on SDCUSTPD
523700210712Nostro customer not found on SDNOSTPD
523800210712Broker code not found on SDBROKPD
523900210712ZM0040 (format ccy and amount) call ended in error
524000210712ZM0050 (format SWIFT address) call ended in error
524100210712Codeword was not found for this message
524200210712Duplicate TRN (ref.) key built for this message
524300210712/UNIT/OTH/
524400210712** TABS96 - selection criteria for the codeword
524500210712                  BOTHAMEND    K
524600210712                  B/O AMEND    U
524700210712NONREC NEW      U BOTHNEW      K
524800210712NONREC NEW      U B/O NEW      U
524900210712NONREC NEW      K BOTHNEW      K
525000210712NONREC NEW      K B/O NEW      K
525100210712SENT   NEW      U BOTHAMEND    K
525200210712SENT   NEW      U B/O AMEND    U
525300210712SENT   NEW      K BOTHAMEND    K
525400210712SENT   NEW      K B/O AMEND    K
525500210712NONREC AMEND    U BOTHAMEND    K
525600210712NONREC AMEND    U B/O AMEND    U
525700210712NONREC AMEND    K BOTHAMEND    K
525800210712NONREC AMEND    K B/O AMEND    K
525900210712SENT   AMEND    U BOTHAMEND    K
526000210712SENT   AMEND    U B/O AMEND    U
526100210712SENT   AMEND    K BOTHAMEND    K
526200210712SENT   AMEND    K B/O AMEND    K
526300210712** TABNST - Codes indicating settlement via nostro
52640021071201
52650021071202
52660021071207
52670021071208
52680021071212
526900210712** TABINT - Codes indicating settlement via internal
52700021071203
52710021071204
52720021071205
52730021071206
52740021071214
527500210712** VALUNI
527600210712FOZ
527700210712GOZ
527800210712GRM
527900210712KLO
528000210712LIT
528100210712LOT
528200210712OTH
528300210712PND
528400210712TAL
528500210712TOL
528600210712TON
528700210712TOZ
528800210712UNT
