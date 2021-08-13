000100000000     H DEBUG
000200000000      *****************************************************************
000300000000/*STD *  RPGBASEMOD                                                   *
000400000000/*EXI *  TEXT('Midas FN TakeOn Trades for Consolidated Brch 2 & 3')   *
000500000000      *****************************************************************
000600000000      *                                                               *
000700000000      *  Midas - Private Banking Module                               *
000800000000      *                                                               *
000900210604      *  A1008008 - Midas FN TakeOn Trades for Consolidated Brch 2 & 3*
001000000000      *                                                               *
001100000000      *  Function:    This module Calls the  transaction  for         *
001200000000      *               Consolidated Branch                             *
001300000000      *         - It need to retrive the TRADE Entry queue fo Midas   *
001400210604      *         = The UDF field for decissions                        *
001500000000      *         = the Market customer and the Consolidated branch     *
001600210604      *         : Settlement qre Blank but Auto settled always Yes    *
001700210604      *         = Auto authorise is As per setup                      *
001800000000      *                                                               *
001900210604      *  Component of: A1008008 Takeon Trades for conso branches      *
002100000000      *                                                               *
002200210604      *  (c) Finantia International Limited 2021                      *
002300000000      *                                                               *
002400210604      *  Last Amend No. BA1008   *CREATE   Date 09Nov20               *
002500000000      *                                                               *
002600000000      *---------------------------------------------------------------*
002700000000      *                                                               *
002701210604      *  BA1008 - Replication of Trades to consolidated branches      *
003100000000      *                                                               *
003200000000      *****************************************************************
003300000000      ** +--------------------------------------+
003400000000      ** ¦ F-specs                              ¦
003500000000      ** ¦ =======                              ¦
003600000000      ** +--------------------------------------+
003700000000      **  STANDARD SETTLEMENT
003800000000     FSTDSED    IF   E           K DISK    USROPN  Prefix(S_)
003900000000      **  Midas API ICD
004000000000     FSDAPIPD   IF   E             Disk    USROPN
004300000000      **  Midas Trade details
004400000000     FTRADSDT   IF   E             Disk    USROPN
004500000000      *
004600210604      **  Midas FN Consolidated Branches
004700210604     FA1CONBL2  IF   E           K Disk    USROPN
004800210604     F                                     Infsr(*Pssr)
004900210604      *
005000000000      /Eject
005100000000      *****************************************************************
005200000000      *                                                               *
005300000000      *          F U N C T I O N   O F   I N D I C A T O R S          *
005400000000      *          -------------------------------------------          *
005500210604      *  55  -  Work Indicator used in array FNbrcaA                  *
005600210604      *                                                               *
005700210604      *---------------------------------------------------------------*
005800210604      *                                                               *
005900000000      *                  *************************                    *
006000000000      *                  ** INDICATORS NOT USED **                    *
006100000000      *                  *************************                    *
006200000000      *                                                               *
006300000000      *       ***************************************************     *
006400000000      *       * 01   02   03   04   05   06   07   08   09   10 *     *
006500000000      *       * 11   12   13   14   15   16   17   18   19   20 *     *
006600000000      *       * 21   22   23   24   25   26   27   28   29   30 *     *
006700000000      *       * 31   32   33   34   35   36   37   38   39   40 *     *
006800000000      *       * 41   42   43   44   45   46   47   48   49   50 *     *
007000210604      *       * 51   52   53   54   XX   56   57   58   59   60 *     *
007100000000      *       * 61   62   63   64   65   66   67   68   69   70 *     *
007200000000      *       * 71   72   73   74   75   76   77   78   79   80 *     *
007300000000      *       * xx   xx   83   84   85   86   87   88   89   90 *     *
007400000000      *       * 91   92   93   94   95   96   97   98   99      *     *
007500000000      *       ***************************************************     *
007600000000      *                                                               *
007700000000      *****************************************************************
007800000000      /Space 3
007900000000      *****************************************************************
008000000000      *                                                               *
008100000000      *                S U B R O U T I N E   I N D E X                *
008200000000      *                -------------------------------                *
008300000000      *                                                               *
008400000000      *  RtvPos   - retrieve position in Meridian message.            *
008500000000      *  Repair   - Repair process                                    *
008600000000      *  APDataI  - Prepare Insert message                            *
008700000000      *  APHeader = Prepare header message
008800000000      *  *Pssr    - Program exception error routine                   *
008900000000      *  *Inzsr   - Program Initialization routine.                   *
009000000000      *                                                               *
009100000000      *****************************************************************
009200000000
009300000000      ** +--------------------------------------+
009400000000      ** ¦ Automatically included D-specs       ¦
009500000000      ** ¦ ==============================       ¦
009600000000      ** +--------------------------------------+
009700000000     D W_Currency      S              3
009800000000     D Traderef        S              6
009900000000     D TradeRTN        S              6
010000000000     D TradeFOI        S             20
010100000000     D TradeOri        S              6
010200000000     D ReturnCodex     S              7
010300000000     D RtnCons         S              1
010400000000     D RtnBook         S              2
010500000000     D WrSUBS          S            100
010600000000     D i               S              3S 0
010700000000     D Pos             S              2S 0
010800210604      *
010900210604     D WrkBook         S              2
011000210604     D RtnCons2        S              1
011100210604     D RtnBook2        S              2
011200210604     D RtnCons3        S              1
011300210604     D RtnBook3        S              2
011400210604     D TradeRTN2       S              6
011500210604     D ReturnCodex2    S              7
011600210604     D TradeRTN3       S              6
011700210604     D ReturnCodex3    S              7
011800210604     D TradeFOI2       S             20
011900210604     D TradeFOI3       S             20
012000210604     D Z               S              1S 0
012100210604     D FNsetup         S              1A
012200210604     D FNudfE1         S              9A   INZ('UDFTRAD07')
012300210604     D FNudfE2         S              9A   INZ('UDFTRAD12')
012400210604     D FNudfE3         S              9A   INZ('UDFTRAD15')
012500000000      **--------------------------------------------------------------------------------------------
012600000000      ** The following /COPY line includes all the defined fields in the
012700000000      ** Program Status Data Structures.  They have meaningful
012800000000      ** names, prefixed by 'PS'.
012900000000     D/COPY ZACPYSRC,PSDS
013000000000      **--------------------------------------------------------------------------------------------
013100000000
013200000000      ** The following /COPY contains various standard declares
013300000000     C/COPY RPCPYSRC,STD_DCL
013400000000
013500000000      ** The following /COPY contains the layout of the Meridian header as
013600000000      ** a data structure
013700000000     C/COPY RPCPYSRC,MDN_HD_DS
013800000000
013900000000      ** Following /COPY is the declares for fields passed to the formatting
014000000000      ** routines
014100000000     C/COPY RPCPYSRC,RPFMTDCL
014200000000
014300000000      ** Following /COPY is the procedure prototype for the Packed routine
014400000000     C/COPY RPCPYSRC,RPFMTPPP
014500000000
014600000000      ** Following /COPY is the procedure prototype for the Signed routine
014700000000     C/COPY RPCPYSRC,RPFMTPPS
014800000000
014900000000      ** +--------------------------------------+
015000000000      ** ¦ End of automatically included D-specs¦
015100000000      ** ¦ =====================================¦
015200000000      ** +--------------------------------------+
015300000000
015400000000      *****************************************************************
015500000000      /Eject
015600000000      *****************************************************************
015700000000
015800000000      ** +--------------------------------------+
015900000000      ** ¦ Manually included D-specs            ¦
016000000000      ** ¦ =========================            ¦
016100000000      ** +--------------------------------------+
016200000000
016300000000      ** +--------------------------------------+
016400000000      ** ¦ Arrays and Data Structures           ¦
016500000000      ** ¦ ==========================           ¦
016600000000      ** +--------------------------------------+
016700000000
016800000000      **  Array containing Copyright statement.
016900000000     D Cpy@            S             80    Dim(1) Ctdata Perrcd(1)
017000000000
017100000000      ** Midas Local Data Area for database error reporting; based on
017200000000      ** external file
017300000000     D Lda           E DS           256    Extname(LDA) DTAARA(LDA)
017400000000      ** The following fields are defined in the external file:
017500000000      **                                    134 141 DBFile
017600000000      **                                    142 170 DBKey
017700000000      **                                    171 180 DBPgm
017800000000      **                                    181 1830DBase
017900000000      **                                    184 193 DBMod
018000000000      **                                    194 203 DBProc
018100000000
018200000000      **  Arrays used to store Position and Length of each fields
018300000000     D ArrFld          S              6    Dim(100)
018400000000     D ArrPos          S              7  0 Dim(100)
018500000000     D ArrLen          S              4  0 Dim(100)
018600000000
018700210604      ** Setup Array to store details of the 3 consolidated branches
018800210604     D FNbrcaA         S              3A   DIM(3) INZ(*Blanks)
018900210604     D FNfoirA         S             14A   DIM(3) INZ(*Blanks)
019000210604
019100000000      ** Replication Defaults Data Area; based on external file.
019200000000     D RPDftsDa      E DS           256    Extname(RPDFTSDA) DTAARA(RPDFTSDA)
019300000000
019400000000      ** API DUMP Information Data Area for database error reporting;
019500000000      ** based on external file
019600000000     D Apdump        E DS                  Extname(APDUMP) DTAARA(APDUMP)
019700000000
019800000000      **  Data structure used to group settlement account details.
019900000000     D W_NOML          DS            11
020000000000     D   W_N1                  1      1
020100000000     D   W_N2                  2      2
020200000000     D   W_N3                  3      3
020300000000     D   W_N4                  4      4
020400000000     D   W_N5                  5      5
020500000000     D   W_N6                  6      6
020600000000     D   W_N7                  7      7
020700000000     D   W_N8                  8      8
020800000000     D   W_N9                  9      9
020900000000     D   W_N10                10     10
021000000000     D   W_N11                11     11
021100000000     D   W_NOML0               1     11
021200000000     D   W_NOML1               1     10
021300000000     D   W_NOML2               1      9
021400000000     D   W_NOML3               1      8
021500000000     D   W_NOML4               1      7
021600000000     D   W_NDec1              11     11
021700000000     D   W_NDec2              10     11
021800000000     D   W_NDec3               9     11
021900000000     D   W_NDec4               8     11
022000000000      *
022100000000     D W_ChgL          DS            13
022200000000     D   W_ChgL0               1     13
022300000000     D   W_ChgL1               1     12
022400000000     D   W_ChgL2               1     11
022500000000     D   W_ChgL3               1     10
022600000000     D   W_CDec1              13     13
022700000000     D   W_CDec2              12     13
022800000000     D   W_CDec3              11     13
022900000000      *
023000000000     D W_1508          DS            15
023100000000     D   W_I1                  1      1
023200000000     D   W_I2                  2      2
023300000000     D   W_I3                  3      3
023400000000     D   W_I4                  4      4
023500000000     D   W_I5                  5      5
023600000000     D   W_I6                  6      6
023700000000     D   W_1308                3     15
023800000000     D   W_Int05               3      7
023900000000     D   W_Int07               1      7
024000000000     D   W_Dec08               8     15
024100000000      *
024200000000     D W_0905          DS             9
024300000000     D   W_RALLI               1      4
024400000000     D   W_RALLD               5      9
024500000000     D SettldO       E DS                  Extname(STDSED)  Prefix(S_)
024600000000      ** Data Structure for Original trade details
024700000000     D TradsdO       E DS                  Extname(TRADSDT) Prefix(O_)
024800000000     D TradsdC       E DS                  Extname(TRADSDT) Prefix(C_)
024900000000     D Tradsd        E DS                  Extname(TRADSDT)
025000000000      ** Data Structure for access to Customer Details.
025100000000     D Sdsecs        E DS                  Extname(SDSECSPD)
025200000000
025300000000      ** Data Structure for access to Currency Details.
025400000000     D Sdcurr        E DS                  Extname(SDCURRPD)
025500000000
025600000000      ** Data Structure for access to Securities I.C.D. details
025700000000     D Sdstrd        E DS                  Extname(SDSTRDPD)
025800000000
025900000000      ** Data Structure for access to Private Banking I.C.D. details
026000000000     D Sdtofd        E DS                  Extname(SDTOFPD)
026100000000
026200000000      **  First Data Structure for Access Programs, short Data Structure.
026300000000     D Dsfdy         E DS                  Extname(DSFDY)
026400000000
026500000000      **  Second Data Structure foR Access Programs, long Data Structure.
026600000000     D Dssdy         E DS                  Extname(DSSDY)
026700000000
026800000000     D Dsldy         E DS                  Extname(DSLDY)
026900000000      ** DS for Access Programs, Extend Data Structure
027000000000
027100000000      ** +--------------------------------------+
027200000000      ** ¦ Declared variables                   ¦
027300000000      ** ¦ ==================                   ¦
027400000000      ** +--------------------------------------+
027500000000
027600000000      **-------------------- Start of Parameters --------------------**
027700000000      **  Output queue name.
027800000000     D OutQueue        S                   LIKE(MQSQueue)
027900000000     D OutQueueB       S                   LIKE(MQSQueue)
028000000000      **--------------------- End of Parameters ---------------------**
028100000000
028200000000      **-------------- Start of Parameters for RPC1305 --------------**
028300000000      **  Script Name.
028400000000     D ScriptName      S             10A
028500000000      **  Image Name.
028600000000     D ImageName       S             32A
028700000000      **  Field Name.
028800000000     D FieldName       S             10A
028900000000      **  Field Type.
029000000000     D FieldType       S              1A
029100000000      **  Field Value.
029200000000     D FieldValue      S           9999A
029300000000      **  Field Position.
029400000000     D FieldPosition   S              7S 0
029500000000      **  Field Length
029600000000     D FieldLength     S              4S 0
029700000000      **--------------- End of Parameters for RPC1305 ---------------**
029800000000      **---------------- start of Parameters for CPB010 --------------**
029900000000     D MessageInd      S              1A
030000000000
030100000000     D RAMSGOLD        S                   LIKE(RAMSGTYPE)
030200000000
030300000000      **   Database Error Messsage Text
030400000000     D DBErrText       S            256A
030500000000
030600000000      **   Transaction Data of associated transaction
030700000000     D AssocData       S                   LIKE(TransData)
030800000000     D AssocDataB      S                   LIKE(TransData)
030900210604     D TransDataB      S                   LIKE(TransData)
031000210604     D AssocDataB2     S                   LIKE(TransData)
031100210604     D AssocDataB3     S                   LIKE(TransData)
031200210604
031300000000      **   Meridian header Layout of associated transaction
031400000000     D MdHdAssoc       S                   LIKE(MdnHeadDs)
031500000000     D MdHdAssocB      S                   LIKE(MdnHeadDs)
031600000000     D MdnHeadDsB      S                   LIKE(MdnHeadDs)
031700000000     D CommitCtlB      S                   LIKE(CommitCtl)
031800210604     D MdHdAssocB2     S                   LIKE(MdnHeadDs)
031900210604     D MdHdAssocB3     S                   LIKE(MdnHeadDs)
032000000000     D ApHdmsg         DS           200
032100000000     D   ApMSGT                1     32
032200000000     D   ApSRCS               33     40
032300000000     D   ApORIG               41     72
032400000000     D   ApTGTS               73     80
032500000000     D   ApUSER               81     90
032600000000     D   ApPASS               91    100
032700000000     D   ApFORM              101    108
032800000000     D   ApVERS              109    116
032900000000     D   ApRPYQ              117    136
033000000000     D   ApRESP              137    137
033100000000     D   ApMAPL              138    138
033200000000     D   ApFRNT              139    158
033300000000     D   ApASOC              159    178
033400000000     D   ApRESPN             179    179
033500000000     D   ApMAPLB             180    180
033600000000     D   APFIL               181    200
033700000000     D ApDtmsg         DS          8000
033800000000     D   A_DDACTN              1      1
033900000000     D   A_DDTDRF              2      7
034000000000     D   A_DDBLKR              8     13
034100000000     D   A_DDSESN             14     23
034200000000     D   A_DDCNUM             24     33
034300000000     D   A_DDCSSN             34     43
034400000000     D   A_DDCRNM             44     63
034500000000     D   A_DDCRTN             64     73
034600000000     D   A_DDINCS             74     74
034700000000     D   A_DDTDTP             75     76
034800000000     D   A_DDNOML             77     88
034900000000     D   A_DDTPDY             89    104
035000000000     D   A_DDTDVD            105    111
035100000000     D   A_DDBRCD            112    114
035200000000     D   A_DDBPBK            115    116
035300000000     D   A_DDCLTY            117    117
035400000000     D   A_DDSETC            118    120
035500000000     D   A_DDRALL            121    131
035600000000     D   A_DDMRKT            132    133
035700000000     D   A_DDCPCY            134    134
035800000000     D   A_DDPRIC            135    151
035900000000     D   A_DDEXDV            152    152
036000000000     D   A_DDFSPR            153    168
036100000000     D   A_DDBPRC            169    172
036200000000     D   A_DDTPRC            173    176
036300000000     D   A_DDTDID            177    179
036400000000     D   A_DDTDDT            180    186
036500000000     D   A_DDTSUB            187    188
036600000000     D   A_DDLKRF            189    194
036700000000     D   A_DDTDMI            195    195
036800000000     D   A_DDAIIP            196    196
036900000000     D   A_DDTDNR            197    231
037000000000     D   A_DDORDE            232    237
037100000000     D   A_DDACIN            238    238
037200000000     D   A_DDDADJ            239    243
037300000000     D   A_DDACTD            244    244
037400000000     D   A_DDITRA            245    259
037500000000     D   A_DDINOR            260    265
037600000000     D   A_DDMSGK            266    305
037700000000     D   A_DDNTMT            306    312
037800000000     D   A_DDNOM1            313    324
037900000000     D   A_DDTDV1            325    331
038000000000     D   A_DDACI1            332    332
038100000000     D   A_DDDAD1            333    337
038200000000     D   A_DDACT1            338    338
038300000000     D   A_DDITR1            339    353
038400000000     D   A_DDTDER            354    368
038500000000     D   A_DDSMDI            369    369
038600000000     D   A_DDFXMP            370    377
038700000000     D   A_DDBRTE            378    392
038800000000     D   A_DDSMTH            393    394
038900000000     D   A_DDORBR            395    397
039000000000     D   A_DDPYFM            398    415
039100000000     D   A_DDPFSN            416    425
039200000000     D   A_DDPFNM            426    445
039300000000     D   A_DDPFTN            446    455
039400000000     D   A_DDPFAN            456    475
039500000000     D   A_DDPFSW            476    487
039600000000     D   A_DDPYFB            488    490
039700000000     D   A_DDPAYT            491    508
039800000000     D   A_DDPTSN            509    518
039900000000     D   A_DDPTNM            519    538
040000000000     D   A_DDPTTN            539    548
040100000000     D   A_DDPTAN            549    568
040200000000     D   A_DDPTSI            569    580
040300000000     D   A_DDPYTB            581    583
040400000000     D   A_DDTDFA            584    593
040500000000     D   A_DDFASN            594    603
040600000000     D   A_DDFANM            604    623
040700000000     D   A_DDFATN            624    633
040800000000     D   A_DDFASW            634    645
040900000000     D   A_DDASNM            646    647
041000000000     D   A_DDDELF            648    657
041100000000     D   A_DDDFSN            658    667
041200000000     D   A_DDDFNM            668    687
041300000000     D   A_DDDFTN            688    697
041400000000     D   A_DDDFSI            698    709
041500000000     D   A_DDDELT            710    719
041600000000     D   A_DDDTSN            720    729
041700000000     D   A_DDDTNM            730    749
041800000000     D   A_DDDTTN            750    759
041900000000     D   A_DDDTSI            760    771
042000000000     D   A_DDDFFA            772    781
042100000000     D   A_DDD1SN            782    791
042200000000     D   A_DDD1NM            792    811
042300000000     D   A_DDD1TN            812    821
042400000000     D   A_DDD1SI            822    833
042500000000     D   A_DDDTFA            834    843
042600000000     D   A_DDD2SN            844    853
042700000000     D   A_DDD2NM            854    873
042800000000     D   A_DDD2TN            874    883
042900000000     D   A_DDD2SI            884    895
043000000000     D   A_DDTDSI            896    928
043100000000     D   A_DDCLTY2           929    929
043200000000     D   A_DDICCY            930    932
043300000000     D   A_DDPRFC            933    936
043400000000     D   A_DDPRYC            937    937
043500000000     D   A_DDPCOD            938    938
043600000000     D   A_DDAUTS            939    939
043700000000     D   A_DDTBCC            940    941
043800000000     D   A_DDTBCA            942    955
043900000000     D   A_DDTCCC            956    957
044000000000     D   A_DDTCCA            958    971
044100000000     D   A_DDTCC1            972    973
044200000000     D   A_DDTCA1            974    987
044300000000     D   A_DDTCC2            988    989
044400000000     D   A_DDTCA2            990   1003
044500000000     D   A_DDTCC3           1004   1005
044600000000     D   A_DDTCA3           1006   1019
044700000000     D   A_DDTCC4           1020   1021
044800000000     D   A_DDTCA4           1022   1035
044900000000     D   A_DDTCC5           1036   1037
045000000000     D   A_DDTCA5           1038   1051
045100000000     D   A_DDTCC6           1052   1053
045200000000     D   A_DDTCA6           1054   1067
045300000000     D   A_DDTCC7           1068   1069
045400000000     D   A_DDTCA7           1070   1083
045500000000     d   A_DDTAXA           1084   1097
045600000000     D   A_DDEUTX           1098   1113
045700000000     D   A_DDBCMR           1114   1127
045800000000     D   A_DDCCMR           1128   1141
045900000000     D   A_DDTXRB           1142   1155
046000000000     D   A_DDPTFR           1156   1159
046100000000     D   A_ADDGMES          1160   1160
046200000000     D   A_ADDTRTT          1161   1164
046300000000     D   A_ADDINST          1165   1167
046400000000     D   A_ADDINSS          1168   1172
046500000000     D   A_ADDEUCL          1173   1182
046600000000     D   A_ADDSAFA          1183   1188
046700000000     D   A_ADDRPTY          1189   1189
046800000000     D   A_ADDGDEL          1190   1190
046900000000     D   A_ADDSROL          1191   1194
047000000000     D   A_ADDFCOD          1195   1195
047100000000     D   A_ADDFTID          1196   1196
047200000000     D   A_ADDGMEC          1197   1197
047300000000     D   A_ADDCCID          1198   1198
047400000000     D   A_ADDFID1          1199   1206
047500000000     D   A_ADDIORA          1207   1207
047600000000     D   A_ADDSNEW          1208   1208
047700000000     D   A_ADDSTMP          1209   1212
047800000000     D   A_ADDCHID          1213   1242
047900000000     D   A_ADDTRRM          1243   1246
048000000000     D   A_BDDGMES          1247   1247
048100000000     D   A_BDDTRTT          1248   1251
048200000000     D   A_BDDINST          1252   1254
048300000000     D   A_BDDINSS          1255   1259
048400000000     D   A_BDDEUCL          1260   1269
048500000000     D   A_BDDSAFA          1270   1275
048600000000     D   A_BDDRPTY          1276   1276
048700000000     D   A_BDDGDEL          1277   1277
048800000000     D   A_BDDSROL          1278   1281
048900000000     D   A_BDDFCOD          1282   1282
049000000000     D   A_BDDFTID          1283   1283
049100000000     D   A_BDDGMEC          1284   1284
049200000000     D   A_BDDCCID          1285   1285
049300000000     D   A_BDDFID1          1286   1293
049400000000     D   A_BDDIORA          1294   1294
049500000000     D   A_BDDSNEW          1295   1295
049600000000     D   A_BDDSTMP          1296   1299
049700000000     D   A_BDDCHID          1300   1329
049800000000     D   A_BDDTRRM          1330   1333
049900000000     D   A_AESAP1N          1334   1343
050000000000     D   A_DDA1SN           1344   1353
050100000000     D   A_DDA1NM           1354   1373
050200000000     D   A_DDA1TN           1374   1383
050300000000     D   A_DDA1SI           1384   1395
050400000000     D   A_AESAP1L          1396   1430
050500000000     D   A_AESAP2N          1431   1440
050600000000     D   A_DDA2SN           1441   1450
050700000000     D   A_DDA2NM           1451   1470
050800000000     D   A_DDA2TN           1471   1480
050900000000     D   A_DDA2SI           1481   1492
051000000000     D   A_AESAP2L          1493   1527
051100000000     D   A_AESAWIN          1528   1537
051200000000     D   A_DDAISN           1538   1547
051300000000     D   A_DDAINM           1548   1567
051400000000     D   A_DDAITN           1568   1577
051500000000     D   A_DDAISI           1578   1589
051600000000     D   A_AESAWIL          1590   1624
051700000000     D   A_AESBOFN          1625   1634
051800000000     D   A_DDBMSN           1635   1644
051900000000     D   A_DDBMNM           1645   1664
052000000000     D   A_DDBMTN           1665   1674
052100000000     D   A_DDBMSI           1675   1686
052200000000     D   A_AESBOF1          1687   1721
052300000000     D   A_AESBOF2          1722   1756
052400000000     D   A_AESACL1          1757   1791
052500000000     D   A_AESACL2          1792   1826
052600000000     D   A_AESSRL1          1827   1861
052700000000     D   A_AESSRL2          1862   1896
052800000000     D   A_AESSRL3          1897   1931
052900000000     D   A_AESFIN1          1932   1966
053000000000     D   A_AESFIN2          1967   2001
053100000000     D   A_AESRED1          2002   2036
053200000000     D   A_AESRED2          2037   2071
053300000000     D   A_AESNAL1          2072   2106
053400000000     D   A_AESNAL2          2107   2141
053500000000     D   A_AESIPYN          2142   2151
053600000000     D   A_DDIPSN           2152   2161
053700000000     D   A_DDIPNM           2162   2181
053800000000     D   A_DDIPTN           2182   2191
053900000000     D   A_DDIPSI           2192   2203
054000000000     D   A_AESIPYL          2204   2238
054100000000     D   A_AESCTYN          2239   2248
054200000000     D   A_AESCTYL          2249   2283
054300000000     D   A_AESSA1N          2284   2293
054400000000     D   A_DDCZSN           2294   2303
054500000000     D   A_DDCSNM           2304   2323
054600000000     D   A_DDCSTN           2324   2333
054700000000     D   A_DDCSSI           2334   2345
054800000000     D   A_AESSA1L          2346   2380
054900000000     D   A_AESSKAN          2381   2390
055000000000     D   A_DDUSSN           2391   2400
055100000000     D   A_DDUSNM           2401   2420
055200000000     D   A_DDUSTN           2421   2430
055300000000     D   A_DDUSSI           2431   2442
055400000000     D   A_AESSKAL          2443   2477
055500000000     D   A_AESCCTN          2478   2489
055600000000     D   A_DDCCSN           2490   2499
055700000000     D   A_DDCCNM           2500   2519
055800000000     D   A_DDCCTN           2520   2529
055900000000     D   A_DDCCSI           2530   2541
056000000000     D   A_AESDCTL          2542   2547
056100000000     D   A_AESRSSN          2548   2557
056200000000     D   A_DDRSSN           2558   2567
056300000000     D   A_DDRSNM           2568   2587
056400000000     D   A_DDRSTN           2588   2597
056500000000     D   A_DDRSSI           2598   2609
056600000000     D   A_AESRSS1          2610   2644
056700000000     D   A_AESRSS2          2645   2679
056800000000     D   A_AESRSS3          2680   2714
056900000000     D   A_AESRSS4          2715   2749
057000000000     D   A_AESDSSN          2750   2759
057100000000     D   A_AESDSS1          2760   2794
057200000000     D   A_AESDSS2          2795   2829
057300000000     D   A_AESDSS3          2830   2864
057400000000     D   A_AESDSS4          2865   2899
057500000000     D   A_AESBSSN          2900   2909
057600000000     D   A_AESBSS1          2910   2944
057700000000     D   A_AESBSS2          2945   2979
057800000000     D   A_AESINVE          2980   2989
057900000000     D   A_DDIOSN           2990   2999
058000000000     D   A_DDIONM           3000   3019
058100000000     D   A_DDIOTN           3020   3029
058200000000     D   A_DDIOSI           3030   3041
058300000000     D   A_AESIMMD1         3042   3053
058400000000     D   A_DDI1SN           3054   3063
058500000000     D   A_DDI1NM           3064   3083
058600000000     D   A_DDI1TN           3084   3093
058700000000     D   A_DDI1SI           3094   3105
058800000000     D   A_AESIMSA1         3106   3125
058900000000     D   A_AESIMMD2         3126   3137
059000000000     D   A_DDI2SN           3138   3147
059100000000     D   A_DDI2NM           3148   3167
059200000000     D   A_DDI2TN           3168   3177
059300000000     D   A_DDI2SI           3178   3189
059400000000     D   A_AESIMSA2         3190   3209
059500000000     D   A_AESIMMD3         3210   3221
059600000000     D   A_AESIMSA3         3222   3241
059700000000     D   A_AESIMMD4         3242   3253
059800000000     D   A_AESIMSA4         3254   3273
059900000000     D   A_AESIMMD5         3274   3285
060000000000     D   A_AESIMSA5         3286   3305
060100000000     D   A_AESIMMD6         3306   3317
060200000000     D   A_AESIMSA6         3318   3337
060300000000     D   A_AESIMMD7         3338   3349
060400000000     D   A_AESIMSA7         3350   3369
060500000000     D   A_AESIMMD8         3370   3381
060600000000     D   A_AESIMSA8         3382   3401
060700000000     D   A_AESIMMD9         3402   3413
060800000000     D   A_AESIMSA9         3414   3433
060900000000     D   A_AESPSET          3434   3445
061000000000     D   A_DDPSSN           3446   3455
061100000000     D   A_DDPSNM           3456   3475
061200000000     D   A_DDPSTN           3476   3485
061300000000     D   A_DDPSSI           3486   3497
061400000000     D   A_AESNAC1          3498   3532
061500000000     D   A_AESNAC2          3533   3567
061600000000     D   A_AESDIDN          3568   3577
061700000000     D   A_AESDAD1          3578   3612
061800000000     D   A_AESDAD2          3613   3647
061900000000     D   A_AESDAD3          3648   3682
062000000000     D   A_AESDAD4          3683   3717
062100000000     D   A_AESDLIN          3718   3752
062200000000     D   A_AESQFIN          3753   3762
062300000000     D   A_AESPCLR          3763   3772
062400000000     D   A_BESAP1N          3773   3782
062500000000     D   A_BDA1SN           3783   3792
062600000000     D   A_BDA1NM           3793   3812
062700000000     D   A_BDA1TN           3813   3822
062800000000     D   A_BDA1SI           3823   3834
062900000000     D   A_BESAP1L          3835   3869
063000000000     D   A_BESAP2N          3870   3879
063100000000     D   A_BDA2SN           3880   3889
063200000000     D   A_BDA2NM           3890   3909
063300000000     D   A_BDA2TN           3910   3919
063400000000     D   A_BDA2SI           3920   3931
063500000000     D   A_BESAP2L          3932   3966
063600000000     D   A_BESAWIN          3967   3976
063700000000     D   A_BDAISN           3977   3986
063800000000     D   A_BDAINM           3987   4006
063900000000     D   A_BDAITN           4007   4016
064000000000     D   A_BDAISI           4017   4028
064100000000     D   A_BESAWIL          4029   4063
064200000000     D   A_BESBOFN          4064   4073
064300000000     D   A_BDBMSN           4074   4083
064400000000     D   A_BDBMNM           4084   4103
064500000000     D   A_BDBMTN           4104   4113
064600000000     D   A_BDBMSI           4114   4125
064700000000     D   A_BESBOF1          4126   4160
064800000000     D   A_BESBOF2          4161   4195
064900000000     D   A_BESACL1          4196   4230
065000000000     D   A_BESACL2          4231   4265
065100000000     D   A_BESSRL1          4266   4300
065200000000     D   A_BESSRL2          4301   4335
065300000000     D   A_BESSRL3          4336   4370
065400000000     D   A_BESFIN1          4371   4405
065500000000     D   A_BESFIN2          4406   4440
065600000000     D   A_BESRED1          4441   4475
065700000000     D   A_BESRED2          4476   4510
065800000000     D   A_BESNAL1          4511   4545
065900000000     D   A_BESNAL2          4546   4580
066000000000     D   A_BESIPYN          4590   4590
066100000000     D   A_BDIPSN           4600   4600
066200000000     D   A_BDIPNM           4620   4620
066300000000     D   A_BDIPTN           4630   4630
066400000000     D   A_BDIPSI           4642   4642
066500000000     D   A_BESIPYL          4677   4677
066600000000     D   A_BESCTYN          4687   4687
066700000000     D   A_BESCTYL          4722   4722
066800000000     D   A_BESSA1N          4732   4732
066900000000     D   A_BDCZSN           4742   4742
067000000000     D   A_BDCSNM           4762   4762
067100000000     D   A_BDCSTN           4772   4772
067200000000     D   A_BDCSSI           4784   4784
067300000000     D   A_BESSA1L          4819   4819
067400000000     D   A_BESSKAN          4829   4829
067500000000     D   A_BDUSSN           4839   4839
067600000000     D   A_BDUSNM           4859   4859
067700000000     D   A_BDUSTN           4869   4869
067800000000     D   A_BDUSSI           4881   4881
067900000000     D   A_BESSKAL          4916   4916
068000000000     D   A_BESCCTN          4928   4928
068100000000     D   A_BDCCSN           4938   4938
068200000000     D   A_BDCCNM           4958   4958
068300000000     D   A_BDCCTN           4959   4968
068400000000     D   A_BDCCSI           4969   4980
068500000000     D   A_BESDCTL          4981   4986
068600000000     D   A_BESRSSN          4987   4996
068700000000     D   A_BDRSSN           4997   5006
068800000000     D   A_BDRSNM           5007   5026
068900000000     D   A_BDRSTN           5027   5036
069000000000     D   A_BDRSSI           5037   5048
069100000000     D   A_BESRSS1          5049   5083
069200000000     D   A_BESRSS2          5084   5118
069300000000     D   A_BESRSS3          5119   5153
069400000000     D   A_BESRSS4          5154   5188
069500000000     D   A_BESDSSN          5189   5198
069600000000     D   A_BESDSS1          5199   5233
069700000000     D   A_BESDSS2          5234   5268
069800000000     D   A_BESDSS3          5269   5303
069900000000     D   A_BESDSS4          5304   5338
070000000000     D   A_BESBSSN          5339   5348
070100000000     D   A_BESBSS1          5349   5383
070200000000     D   A_BESBSS2          5384   5418
070300000000     D   A_BESINVE          5419   5428
070400000000     D   A_BDIOSN           5429   5438
070500000000     D   A_BDIONM           5439   5458
070600000000     D   A_BDIOTN           5459   5468
070700000000     D   A_BDIOSI           5469   5480
070800000000     D   A_BESIMMD1         5481   5492
070900000000     D   A_BDI1SN           5493   5502
071000000000     D   A_BDI1NM           5503   5522
071100000000     D   A_BDI1TN           5523   5532
071200000000     D   A_BDI1SI           5533   5544
071300000000     D   A_BESIMSA1         5545   5564
071400000000     D   A_BESIMMD2         5565   5576
071500000000     D   A_BDI2SN           5577   5586
071600000000     D   A_BDI2NM           5587   5606
071700000000     D   A_BDI2TN           5607   5616
071800000000     D   A_BDI2SI           5617   5628
071900000000     D   A_BESIMSA2         5629   5648
072000000000     D   A_BESIMMD3         5649   5660
072100000000     D   A_BESIMSA3         5661   5680
072200000000     D   A_BESIMMD4         5681   5692
072300000000     D   A_BESIMSA4         5693   5712
072400000000     D   A_BESIMMD5         5713   5724
072500000000     D   A_BESIMSA5         5725   5744
072600000000     D   A_BESIMMD6         5745   5756
072700000000     D   A_BESIMSA6         5757   5776
072800000000     D   A_BESIMMD7         5777   5788
072900000000     D   A_BESIMSA7         5789   5808
073000000000     D   A_BESIMMD8         5809   5820
073100000000     D   A_BESIMSA8         5821   5840
073200000000     D   A_BESIMMD9         5841   5852
073300000000     D   A_BESIMSA9         5853   5872
073400000000     D   A_BESPSET          5873   5884
073500000000     D   A_BDPSSN           5885   5894
073600000000     D   A_BDPSNM           5895   5914
073700000000     D   A_BDPSTN           5915   5924
073800000000     D   A_BDPSSI           5925   5936
073900000000     D   A_BESNAC1          5937   5971
074000000000     D   A_BESNAC2          5972   6006
074100000000     D   A_BESDIDN          6007   6016
074200000000     D   A_BESDAD1          6017   6051
074300000000     D   A_BESDAD2          6052   6086
074400000000     D   A_BESDAD3          6087   6121
074500000000     D   A_BESDAD4          6122   6156
074600000000     D   A_BESDLIN          6157   6191
074700000000     D   A_BESQFIN          6192   6201
074800000000     D   A_BESPCLR          6202   6211
074900000000     D   A_DDCRSK           6212   6228
075000000000     D   A_DDLQPR           6229   6245
075100000000     D   A_DDITRN           6246   6260
075200000000     D   A_TMSP             6261   6286
075300000000     D   A_BDSPBS           6287   6287
075400000000     D   A_STBS             6288   6288
075500000000     D   A_PROT             6289   6289
075600000000     D   A_NMCY             6290   6292
075700000000     D   A_C1DI             6293   6293
075800000000     D   A_BVAUTH           6294   6295
075900000000     D   A_DDCPNR           6296   6308
076000000000     D   A_DDTCTR           6309   6329
076100000000     D   A_DDCFCT           6330   6341
076200000000     D   A_ADDROUS          6342   6347
076300000000     D   A_ADDROTS          6348   6359
076400000000     D   A_ADDROUC          6360   6365
076500000000     D   A_ADDROTC          6366   6377
076600000000     D   A_BDDROUS          6378   6383
076700000000     D   A_BDDROTS          6384   6395
076800000000     D   A_BDDROUC          6396   6401
076900000000     D   A_BDDROTC          6402   6413
077000000000     D   A_DDSPXR           6414   6427
077100000000     D   A_DDSPMD           6428   6428
077200000000     D   A_DDWTAX           6429   6443
077300000000     D   A_BKEURO           6444   6446
077400000000     D   A_DDSTAT           6447   6455
077500000000     D   A_DDAUTH           6456   6469
077600000000     D   A_SITP             6470   6472
077700000000     D   A_DDPRICN          6473   6489
077800000000     D   A_DDHACR           6490   6502
077900000000     D   A_DDTCSR           6503   6517
078000000000     D   A_DDDAYS           6518   6520
078100000000     D   A_DDFOID           6521   6540
078200000000     D   A_TQTAX            6541   6541
078300000000     D   A_TQSTAF           6542   6554
078400000000     D   A_TQCDTE           6555   6560
078500000000     D   A_AUTH             6561   6561
078600000000     D   A_TOFfil           6562   6610
078700000000      **   Image Type - Amend Before, Amend After or Insert
078800000000     D ImageType       S             20A
078900000000     D ImageTypeB      S             20A
079000210604     D ImageTypeB2     S             20A
079100210604     D ImageTypeB3     S             20A
079200000000      **----------------  End of Parameters for CPB010  --------------**
079300000000
079400000000      **------------ Start of parameters for ZAGETSETAC -------------**
079500000000      **  -------
079600000000      **  Outputs
079700000000      **  -------
079800000000      **  Account code.
079900000000     D AccCode         S             10S 0
080000000000      **  Account sequence.
080100000000     D AccSeq          S              2S 0
080200000000      **  MEMOS update required.
080300000000     D MemosInd        S              1A
080400000000      **  PRONO update required.
080500000000     D PronoInd        S              1A
080600000000      **  ------------
080700000000      **  Input/output
080800000000      **  ------------
080900000000      **  Transaction branch.
081000000000     D Branch          S              3A
081100000000      **  Tansaction customer.
081200000000     D CustNo          S              6A
081300000000      **  Settlement currency.
081400000000     D Currency        S              3A
081500000000      **  ------
081600000000      **  Inputs
081700000000      **  ------
081800000000      **  Settlement type.
081900000000     D SettleType      S              2S 0
082000000000      **  Settlement account.
082100000000     D SettleAcc       DS            18
082200000000     D   WW_AccNum             1      6
082300000000     D   WW_AccCode            7     16
082400000000     D   WW_AccSeq            17     18
082500000000
082600000000      **------------- End of parameters for ZAGETSETAC --------------**
082700000000
082800000000      ** --------- Start of fields used by access programs ----------**
082900000000      **  Return code.
083000000000     D P_RtCd          S              7A
083100000000     D ReturnCodeB     S              7A
083200000000      **  Option.
083300000000     D P_Optn          S              7A
083400000000      **  Customer.
083500000000     D P_Cust          S              6A
083600000000      **  Key status.
083700000000     D P_Kyst          S              7A
083800000000      ** ---------- End of fields used by access programs -----------**
083900000000
084000000000      **  Work Field used as position for each numeric fields
084100000000     D W_PosDebut      S              2S 0
084200000000     D fmDpLen         S              1A
084300000000
084400000000      **  End Position.
084500000000     D EndPosition     S              7S 0
084600000000
084700000000      **  Work Field used as key to access to Customer PB Details.
084800000000     D K_CustNum       S              6A
084900000000
085000000000      **  Work field used to access to SE Trade Authorization.
085100000000     D K_TradeRef      S              6A
085200000000
085300000000      **  Work field used to access to SE Trade incomplete/complete indicator
085400000000     D K_Tinc          S              1A
085500000000
085600000000      **  Work field used to access to SE Trade RECI
085700000000     D K_Reci          S              1A
085800000000
085900000000      **  Work field used to store Incomplete Ind before update
086000000000     D B_Tinc          S              1A
086100000000      **  Work field used to store If 1st authorisation is done
086200000000     D W_OneAut        S              1A
086300000000      **  Work field used to store Private Banking Order Number.
086400000000     D W_OrderNumber   S              6S 0
086500000000
086600000000      **  Work field used to retrieve Trade type
086700000000     D W_Type          S              2A
086800000000
086900000000      **----------------  Start of additional fields ----------------**
087000000000     D W_NomCcyNbdp    S              1A
087100000000     D W_PayFrSettAcc  S             24A
087200000000     D W_PayFrSettPor  S              4A
087300000000     D W_PayToSettAcc  S             24A
087400000000     D W_PayToSettPor  S              4A
087500000000      **-----------------  End of additional fields -----------------**
087600000000
087700000000      **  Work Field used to condition Meridian message sending.
087800000000     D W_SendMsg       S              1A
087900000000
088000000000      **   Composite Data
088100000000     D CompData        S                   LIKE(TransData)
088200000000     D CompDataB       S                   LIKE(TransData)
088300000000
088400000000      ** True and False can be used for indicators being on or off.
088500000000     D True            C                   *On
088600000000     D False           C                   *Off
088700000000
088800000000      **  Work Field used to produce only one dump.
088900000000     D W_RunBefore     S              1A
089000000000
089100000000      **  Work field used to set up return code when no record found.
089200000000     D W_NoRcdFnd      C                   CONST('*NoRcdFnd')
089300000000
089400000000      **  Work field used for change message type
089500000000     D W_PosFin        S              3S 0
089600000000
089700000000      ** +--------------------------------------+
089800000000      ** ¦ End of D-specs                       ¦
089900000000      ** ¦ ==============                       ¦
090000000000      ** +--------------------------------------+
090100000000
090200000000      /Eject
090300000000      *****************************************************************
090400000000     C     Start         Tag
090500000000
090600000000      ** Note: the above tag is only there to force the first comments in
090700000000      ** the C-specs to appear after the D- or I-specs in compiled listings.
090800000000
090900000000      *****************************************************************
091000000000      *                                                               *
091100000000      *                  M A I N  P R O C E S S I N G                 *
091200000000      **   +------------------------------------------------------+   *
091300000000      **   ¦                                                      ¦   *
091400000000      **   ¦ Initial processing is performed automatically: the   ¦   *
091500000000      **   ¦ *inzsr is executed at program activation.            ¦   *
091600000000      **   ¦                                                      ¦   *
091700000000      **   +------------------------------------------------------+   *
091800000000      *                                                               *
091900000000      *****************************************************************
092000000000      *  Access first record in file
092100000000     C                   OPEN      TRADSDT
092200000000     C                   READ      TRADSDT
092300000000      *  Process whole file
092400000000     C                   DOW       NOT %EOF(TRADSDT)                                   D1
092500000000      * Save last record read
092600000000     C                   Eval      TradsdO = Tradsd
092700210604      * Clear work fields
092800210604     C                   Eval      ImageTypeB  = '                    '
092900210604     C                   Eval      ImageTypeB2 = '                    '
093000210604     C                   Eval      ImageTypeB3 = '                    '
093100210604      *
093200000000      *  Continue further only if  not consolidated branch   and not deleted record
093300000000      *  and trade is complete
093400210604      *
093500210604     C                   SETOFF                                       55
093600210604     C                   Z-Add     1             Z
093700210604     C     O_TDBA        LOOKUP    FNbrcaA(Z)                             55
093800210604      *
094100210604     C                   IF        FNsetup <> ' '     and                                       iFNB
094200000000     C                             *IN55   = *Off     and
094300000000     C                             O_RECI <> 'R'      and
094400000000     C                             O_RECI <> 'C'      and
094500000000     C                             O_TINC =  'C'
094600000000      * set key for further access
094700000000     C                   Eval      K_TradeRef = O_TDRF
094800000000      * retrieve if consolidated branch replication is required.  RtnCons = 'C'
094900000000     C                   MOVEL     K_TradeRef    Traderef
095100210604     C                   CALL      'A1008006'
095200000000     C                   PARM                    Traderef
095300000000     C                   PARM                    RtnCons
095400000000     C                   PARM                    RtnBook
095500210604     C                   PARM                    RtnCons2
095600210604     C                   PARM                    RtnBook2
095700210604     C                   PARM                    RtnCons3
095800210604     C                   PARM                    RtnBook3
095900210604     C                   PARM      *BLANKs       ReturnCodex
096000000000      * do not process if not Intragroup
096100210604      * Assumption Conso Branch 1 already take on, so ignore conso branch 1.
096200210604      * If Conso Branch 2 Ind <> C and Conso branch Ind 3 <> C, goto Next
096400210604     C                   If        RtnCons2 <>  'C'                                            i2
096500210604     C                             and RtnCons3 <>  'C'
096600000000     C                   Eval      MessageInd = 'N'
096700000000     C                   goto      NEXT
096800000000     C                   Endif                                                                 e2
096900000000      * Now check if the trade has already been replicated
097000000000      * It may not if trade was incomplete previously.
098300000000      *
098400210604      * Consolidate Branch 2
098500210604      *
098600210604     C                   If        RtnCons2 =   'C'
098700210604     C                             and FNbrcaA(2) <> '   '
098800210604     C                   Eval      TradeFOI2 = %trim(FNfoirA(2)) + K_TradeRef
098900210604     C                   CALL      'A1008007'
099000210604     C                   PARM                    TradeFOI2
099100210604     C                   PARM                    FNbrcaA(2)
099200210604     C                   PARM      *blank        TradeRTN2
099300210604     C                   PARM      *blank        ReturnCodex2
099400210604      *
099500210604      *
099600000000      *  If No records  exist with FRNT = FNROIR + TDRF and It is an AMend RECI is do insert
099700210604     C                   If        ReturnCodex2  = 'NRF    '
099800210604     C                   Eval      ImageTypeB2 = 'Insert              '
099900210604     C                   Eval      AssocDataB2 = *Blanks
100000210604     C                   Eval      MdHdAssocB2 = *Blanks
100100210604      *
100200210604     C                   ENDIF
100300210604     C                   ENDIF
100400000000      *
100500000000      * Consolidate Branch 3
100600000000      *
100700210604     C                   If        RtnCons3 =   'C'
100800210604     C                             and FNbrcaA(3) <> '   '
100900210604     C                   Eval      TradeFOI3 = %trim(FNfoirA(3)) + K_TradeRef
101000210604     C                   CALL      'A1008007'
101100210604     C                   PARM                    TradeFOI3
101200210604     C                   PARM                    FNbrcaA(3)
101300210604     C                   PARM      *blank        TradeRTN3
101400210604     C                   PARM      *blank        ReturnCodex3
101500210604      *
101600000000      *  If No records  exist with FRNT = FNROIR + TDRF and It is an AMend RECI is do insert
101700210604     C                   If        ReturnCodex3  = 'NRF    '
101800210604     C                   Eval      ImageTypeB3 = 'Insert              '
101900210604     C                   Eval      AssocDataB3 = *Blanks
102000210604     C                   Eval      MdHdAssocB3 = *Blanks
102100210604      *
102200210604     C                   ENDIF
102300210604     C                   ENDIF
102500000000      *  If Found already skip processing ( In case of rerun for example)
102600210604      *  In found in both conso branch2 and conso branch 3, goto Next                         i2
102700210604     C                   If        ImageTypeB2 <> 'Insert              '
102800210604     C                             and ImageTypeB3 <> 'Insert              '
102900210604     C                   Goto      NEXT
103000210604     C                   Endif                                                                e2
103100210604      **  Process further if not in conso branch 2 or not in conso branch 3
103200210604      **  or not in both conso branches:
103300210604      **  Enter the processing to read the additional files and produce a
103400210604      **  composite message here.
103500000000     C                   EVAL      P_Cust = O_TCNR
103600000000
103700000000      **  Access Security Customer Details by using Access Object
103800000000      **  to retrieve Safe Custody
103900000000     C                   CALL      'AOSECSR0'
104000000000     C                   Parm      *blank        P_Rtcd                         B:Return code
104100000000     C                   Parm      '*KEY   '     P_Optn                         I:Option
104200000000     C                   Parm                    P_Cust                         I:Key field
104300000000     C     Sdsecs        Parm      Sdsecs        Dssdy                          O:Format
104400000000
104500000000      **  If Customer Details do not exist, handle Database Error.
104600000000     C     P_Rtcd        Ifne      *blanks                                      Begin P_Rtcd  i2
104700000000     C     *lock         In        Lda
104800000000     C                   Eval      DBpgm  = PSProcName
104900000000     C                   Eval      DBfile = 'SDSECSPD'                          ***************
105000000000     C                   Eval      DBase  = 01                                  * Db Error 01 *
105100000000     C                   Eval      DBkey  = P_Cust                              ***************
105200000000     C                   Out       Lda
105300000000     C                   Goto      Next
105400000000     C                   Endif                                                  End P_Rtcd    e2
105500000000      *
105600000000      **  Initialize work field used to condition Meridian message sending.
105700000000     C                   Clear                   W_SendMsg
105800000000      *
105900000000      *  Setup Api message header for  SETRAD
106000000000      *
106200000000     C                   Exsr      APHeader
106300000000      * Retieve information needed to format Amounts
106400000000      **---------------- Start of Nominal Currency ---------------**
106500000000      **                   Number of Decimal Places                  **
106600000000
106700000000     C                   Eval      W_Currency = O_TNMC
106800000000
106900000000      **  Get Nominal Currency number of decimal places.
107000000000     C                   Eval      P_Curr = W_Currency
107100000000     C                   Exsr      GetDecPl
107200000000     C                   Move      A6NBDP        W_NomCcyNbdp
107300000000
107400000000      **                  End of Nominal Currency                 **
107500000000      **-----------------  Number of Decimal Places  ----------------**
107600000000      *
107700000000      *  Setup Api message details     SETRAD
107800000000      *
107900210604      *  Need to consider conso branch 2 and conso branch 3 for a trade
108000210604     C                   Z-add     1             Z
108100210604     C     Z             DOWLE     2                                                          iDowZ
108200210604     C                   Clear                   W_SendMsg
108300210604     C                   Eval      WrkBook = '  '
108400210604     C                   Clear                   SettldO
108500210604      * Send Conso Branch 2 trade
108600210604      *
108700210604     C                   If        RtnCons2 =   'C'                                           iCON2
108800210604     C                             and ImageTypeB2 =  'Insert              '
108900210604     C                             and Z = 1
109000210604     C                   Eval      WrkBook = RtnBook2
109100210604     C                   OPEN      A1CONBL2
109200210604     C     FNudfE2       CHAIN     A1CONBPF                           99
109300210604     C                   CLOSE     A1CONBL2
109400210604     C                   IF        *IN99 = *off                                               iUDF2
109500210604     C                   Eval      W_SendMsg = 'Y'
109600210604     C                   Eval      ApUSER = FNUSER
109700210604     C                   Eval      ApFRNT = TradeFOI2
109800000000     C                   Exsr      APDataI
109900210604     C                   Endif                                                                eUDF2
110000210604     C                   Endif                                                                eCON2
110100210604      *
110200210604
110300210604      * Send Conso Branch 3 trade
110400210604      *
110500210604     C                   If        RtnCons3 =   'C'                                           icon3
110600210604     C                             and ImageTypeB3 =  'Insert              '
110700210604     C                             and Z = 2
110800210604     C                   Eval      WrkBook = RtnBook3
110900210604     C                   OPEN      A1CONBL2
111000210604     C     FNudfE3       CHAIN     A1CONBPF                           99
111100210604     C                   CLOSE     A1CONBL2
111200210604     C                   IF        *IN99 = *off                                               iUDF3
111300210604     C                   Eval      W_SendMsg = 'Y'
111400210604     C                   Eval      ApUSER = FNUSER
111500210604     C                   Eval      ApFRNT = TradeFOI3
111600210604     C                   Exsr      APDataI
111700210604     C                   Endif                                                                eUDF3
111800210604     C                   Endif                                                                econ3
111900000000      *
112100000000      **  If Meridian message has to be sent.
112200000000     C     W_SendMsg     Ifeq      'Y'                                          Begin         iSndM
112300000000
112400000000      **----------------- Start of Additionnal fields ---------------**
112500000000
112600000000      **  Extract Trade Type.
112700000000     C                   Eval      W_Type = O_TDTP
112800000000
112900000000      **  Determine Image Type.
113000000000
113100000000      **  Place the result in field CompData.
113200000000
113300000000     C                   Movel     ApHdmsg       MdnHeadDSb
113400000000     C                   Movel     ApDtmsg       CompDatab
113500000000
113600000000      **  Call a standard routine to actually send the message.
113800210604     C                   Callb     'A1008009'
113900000000     C                   Parm                    FNQUEUE
114000000000     C                   Parm                    ApHdmsg         200
114100000000     C                   Parm                    ApDtmsg        8000
114200000000     C                   Parm                    CommitCtl
114300210604     C** /COPY STD_DCL declares ReturnCode as 10 which matches A1008009
114500210604     C                   Parm      *BLANKs       ReturnCode
114600000000
114700000000      ** If error then perform any special processing and exit
114800000000     C                   If        ReturnCodex  <> *blank                         Begin Rtn   iRtn
114900000000     C                   DUMP
115000000000     C     *Lock         In        Lda
115200210604     C                   Move      'A1008009  '  DBpgm
115300000000     C                   Out       Lda
115400000000     C                   goto      NEXT
115500000000
115600000000      **  If no error, commit the unit of work so that messages that have
115700000000      **  been got from a queue would be permanently deleted and put
115800000000      **  operations would be made permanent.
115900000000     C                   Else                                                   Else ReturnCod xRtn
116000000000
116100000000     C                   Commit
116200000000
116300000000     C                   Endif                                                  End ReturnCode eRtn
116400000000
116500000000     C                   Endif                                                  End W_SendMsg  eSndM
116600210604      * Increase counter for DO loop
116700210604     C                   Eval      Z=Z+1
116800210604     C                   ENDDO                                                                 eDowZ
116900000000     C                   Endif                                                  End FNBRCA     eFNB
117000000000     C     NEXT          TAG
117100000000      * retrieve full format of TRADSD and ensure it is refreshed at every run.
117200000000     C                   Clear                   W_SendMsg
117300000000     C                   Clear                   TradsdO
117400000000     C                   Clear                   TradsdC
117500000000     C                   Clear                   SettldO
117600000000     C                   READ      TRADSDT
117700000000     C                   EnDDO
117800000000     C                   CLOSE     TRADSDT                                                     ed1
117900000000     C                   Seton                                        LR
118000000000     C                   Return
118100000000      /Eject
118200000000      *****************************************************************
118300000000      *                                                               *
118400000000      *  GetDecPl - get number of decimal places.                     *
118500000000      *                                                               *
118600000000      *  Called by : Main processing.                                 *
118700000000      *                                                               *
118800000000      *  Calls     : None.                                            *
118900000000      *                                                               *
119000000000      *****************************************************************
119100000000
119200000000     C     GetDecPl      Begsr
119300000000
119400000000      **  Access to Currency Details, by using access object.
119500000000     C                   Callb     'AOCURRR0'
119600000000     C                   Parm      *blank        P_Rtcd                         B:Return code
119700000000     C                   Parm      '*KEY   '     P_Optn                         I:Option
119800000000     C                   Parm                    P_Curr            3            I:Key field
119900000000     C     Sdcurr        Parm      Sdcurr        Dssdy                          O:Format
120000000000
120100000000      **  If currency does not exist, handle database error.
120200000000     C     P_Rtcd        Ifne      *blanks                                      Begin P_Rtcd
120300000000     C     *lock         In        Lda
120400000000     C                   Eval      Dbpgm  = PSProcName
120500000000     C                   Eval      Dbfile = 'SDCURRPD'                          *************
120600000000     C                   Eval      Dbase  = 09                                  * Db Error 09
120700000000     C                   Eval      Dbkey  = P_Curr                              *************
120800000000     C                   Out       LDA
120900000000     C                   Eval      ReturnCode  = P_RTCD
121000000000
121100000000     C                   Endif                                                  End  P_Rtcd
121200000000
121300000000     C                   Endsr
121400000000
121500000000      /Eject
121600000000      *****************************************************************
121700000000      *                                                               *
121800000000      * *Pssr  - Program exception error routine                      *
121900000000      *          Called automatically if a program error occurs,      *
122000000000      *          or directly by the program code using EXSR.          *
122100000000      *          This subroutine DUMPs the program just once.         *
122200000000      *                                                               *
122300000000      * Called by: (**calling routines**)                             *
122400000000      *                                                               *
122500000000      * Calls: None                                                   *
122600000000      *                                                               *
122700000000      *                                                               *
122800000000      *****************************************************************
122900000000
123000000000     C     *Pssr         Begsr
123100000000
123200000000     C     W_RunBefore   Ifeq      *blank                                       Begin W_RunBefore
123300000000
123400000000      **  If commitment control required, back out the unit of work so
123500000000      **  that current message could be available again.
123600000000     C                   If        CommitCtl = 'Y'                              Begin CommiCtl
123700000000     C                   Rolbk
123800000000
123900000000     C                   Endif                                                  End CommitCtl
124000000000
124100000000     C     *Lock         In        Lda
124200000000     C     DBpgm         Ifeq      *blanks                                      Begin DBpgm
124300000000     C                   Move      PSProcName    DBpgm
124400000000     C                   Out       Lda
124500000000
124600000000     C                   Endif                                                  End DBpgm
124700000000
124800000000     C                   Move      'Y'           W_RunBefore
124900000000     C                   Dump
125000000000
125100000000     C                   Endif                                                  End W_RunBefore
125200000000
125300000000     C     ReturnCode    Ifeq      *blank                                       Begin ReturnCode
125400000000     C                   Eval      ReturnCode = '*PSSR'
125500000000     C                   Endif                                                  End ReturnCode
125600000000
125700000000     C                   Seton                                        U7U8LR
125800000000     C                   Return
125900000000
126000000000     C                   Endsr
126100000000      /Eject
126200000000      *****************************************************************
126300000000      *                                                               *
126400000000      * *Inzsr - Program Initialisation routine                       *
126500000000      *                                                               *
126600000000      * Called at : program initialization time.                      *
126700000000      *                                                               *
126800000000      *****************************************************************
126900000000
127000000000     C     *Inzsr        Begsr
127100000000      *
127200000000     C     KLSTD1        KLIST
127300000000     C                   KFLD                    FNBRCA
127400000000     C                   KFLD                    FNCUST
127500000000     C                   KFLD                    S_SIBK
127600000000     C                   KFLD                    O_TNMC
127700000000      *
127800000000     C                   Eval      MessageInd = 'Y'
127900000000
128000000000      **  Set up work fields for formatting that will not change if
128100000000      **  Replication formatting is required.
128200000000      **     - signs are not shown for Positive numbers.
128300000000      **     - get decimal separator from Replication data area RPDFTSDA.
128400000000     C                   In        RPDftsDa
128500000000     C                   Eval      fmDecSep   = RCDECSEP
128600000000     C                   Eval      fmDpLen  = %Subst(RCZEROFLD:2:1)
128700000000     C                   Move      fmDpLen       W_PosDebut
128800000000     C                   Eval      fmShwPsSgn = 'N'
128900000000
129000000000      **  Set up work fields that will not change if retrieve
129100000000      **  function is to be used.
129200000000     C                   Eval      ScriptName = 'RP' + RATGTSYS
129300000000
129400000000      **  Get Securities Trading Data by using Access Object.
129500000000     C                   Callb     'AOSTRDR0'
129600000000     C                   Parm      *Blanks       P_Rtcd
129700000000     C                   Parm      '*FIRST '     P_Optn
129800000000     C     Sdstrd        Parm      Sdstrd        Dssdy
129900000000
130000000000      **  If Securities Trading Details do not exist, handle Database Error.
130100000000     C     P_Rtcd        Ifne      *blanks                                      Begin P_Rtcd
130200000000     C                   Eval      DBpgm  = PSProcName
130300000000     C                   Eval      DBfile = 'SDSTRDPD'                          ***************
130400000000     C                   Eval      DBase  = 10                                  * Db Error 10 *
130500000000     C                   Eval      DBkey  = '*FIRST'                            ***************
130600000000     C                   Out       Lda
130700000000
130800000000     C                   Endif                                                  End P_Rtcd
130900000000
131000000000     C                   Z-add     0             X                 3 0
131100000000
131200210604      ** Introduce SubRoutine FNDataD
132000210604
132100210604     C                   Exsr      FNDataD
132200210604
132300000000      * retrieve  substitution character
132400000000     C                   OPEN      SDAPIPD
132500000000     C                   READ      SDAPIPD
132600000000     C                   CLOSE     SDAPIPD
132700000000      * fill WrSUBS withn substitution cahracter
132800000000     C                   Movel     GHSUBS        WrSUBS
132900000000     C                   FOR       i = 1 to 99
133000000000     C                   eval      WrSUBS   = %trim(WrSUBS) + GHSUBS
133100000000     C                   ENDFOR
133200000000     C                   Endsr
133300000000      /Eject
133400000000      *****************************************************************
133500000000     C     APHeader      Begsr
133600000000     C                   Eval      ApMSGT = 'SETRAD                          '
133700000000     C                   Eval      ApSRCS = 'Midas   '
133800000000     C                   Eval      ApORIG = *blank
133900000000     C                   Eval      ApTGTS = 'MIDAS   '
134100000000     C                   Eval      ApPASS = *Blank
134200000000     C                   Eval      ApFORM = 'Fixed   '
134300000000     C                   Eval      ApVERS = 'JMSMQ   '
134400000000     C                   Eval      ApRPYQ = 'REPLY               '
134500000000     C                   Eval      ApRESP = 'A'
134600000000     C                   Eval      ApMAPL = *blank
134700000000      ** - Front Office transaction ID
134900000000     C                   Eval      ApASOC = *blank
135000000000     C                   Eval      ApRESPN = 'N'
135100000000     C                   Eval      ApMAPLB = 'B'
135200000000     C                   Eval      APFIL = *blank
135300000000     C                   Endsr
135400000000      /Eject
135500000000      *****************************************************************
135600000000     C     APDataI       Begsr
135700000000     C                   Clear                   ApDtmsg
135800000000      *  Get Default fo settlement
135900000000     C                   IF        FNBRCA  <> *blank
136000000000     C                   OPEN      STDSED
136100000000     C     KLSTD1        CHAIN     STDSEDF                            99
136200000000     C                   CLOSE     STDSED
136300000000     C                   Endif
136400000000      ** - API action
136500000000     C                   Eval      A_DDACTN  = 'I'
136600000000      *
136700000000      ** - Trade reference
136800000000      *
136900000000     C                   Eval      A_DDTDRF  = *Blank
137000000000      *
137100000000      ** - Bulk reference
137200000000     C                   Eval      A_DDBLKR  = O_BLKR
137300000000      *
137400000000      ** - Security short name
137500000000     C                   Eval      A_DDSESN  = O_TDSS
137600000000      *
137700000000      ** - Client Number
137800000000      * if safe custody use FNCUST   else use Trade customer
137900000000     C                   If        BFCLAS = 'D' or BFCLAS = 'S'
138000000000     C                   Eval      A_DDCNUM  = FNCUST
138100000000     C                   Else
138200000000     C                   Eval      A_DDCNUM  = O_TCNR
138300000000     C                   Endif
138400000000      *
138500000000      ** - Customer shortname
138600000000     C                   Eval      A_DDCSSN  = *Blank
138700000000      *
138800000000      ** - Customer report name
138900000000     C                   Eval      A_DDCRNM  = *Blank
139000000000      *
139100000000      ** - Customer report town
139200000000     C                   Eval      A_DDCRTN  = *Blank
139300000000      *
139400000000      ** - Incomplete indicator
139500000000     C                   Eval      A_DDINCS  = O_TINC
139600000000      *
139700000000      ** - Trade type
139800000000     C                   Eval      A_DDTDTP  = O_TDTP
139900000000      *
140000000000      ** - Nominal
140100000000      * Format nominal amount based on Nominal decimal plases
140200000000     C                   Move      O_NOML        W_NOML
140300000000      *                  Remove leading Zero
140400000000     C                   If        W_N1 = '0' or W_N1 = ' '
140500000000     C                   Eval      W_N1 = *blank
140600000000     C                   If        W_N2 = '0' or W_N2 = ' '
140700000000     C                   Eval      W_N2 = *blank
140800000000     C                   If        W_N3 = '0' or W_N3 = ' '
140900000000     C                   Eval      W_N3 = *blank
141000000000     C                   If        W_N4 = '0' or W_N4 = ' '
141100000000     C                   Eval      W_N4 = *blank
141200000000     C                   If        W_N5 = '0' or W_N5 = ' '
141300000000     C                   Eval      W_N5 = *blank
141400000000     C                   If        W_N6 = '0' or W_N6 = ' '
141500000000     C                   Eval      W_N6 = *blank
141600000000     C                   If        W_N7 = '0' or W_N7 = ' '
141700000000     C                   Eval      W_N7 = *blank
141800000000     C                   If        W_N8 = '0' or W_N8 = ' '
141900000000     C                   Eval      W_N8 = *blank
142000000000     C                   If        W_N9 = '0' or W_N9 = ' '
142100000000     C                   Eval      W_N9 = *blank
142200000000     C                   If        W_N10 = '0' or W_N10 = ' '
142300000000     C                   Eval      W_N10 = *blank
142400000000     C                   If        W_N11 = '0' or W_N11 = ' '
142500000000     C                   Eval      W_N11 = *blank
142600000000     C                   Endif
142700000000     C                   Endif
142800000000     C                   Endif
142900000000     C                   Endif
143000000000     C                   Endif
143100000000     C                   Endif
143200000000     C                   Endif
143300000000     C                   Endif
143400000000     C                   Endif
143500000000     C                   Endif
143600000000     C                   Endif
143700000000     C                   If        TNMD = 0
143800000000     C                   If        W_N11 = ' '
143900000000     C                   Eval      W_N11 = *ZERO
144000000000     C                   Endif
144100000000     C                   Eval      A_DDNOML  = %trim(W_NOML0)
144200000000     C                   Endif
144300000000     C                   If        TNMD = 1
144400000000     C                   If        W_N11 = ' '
144500000000     C                   Eval      W_N11 = *ZERO
144600000000     C                   Endif
144700000000     C                   Eval      A_DDNOML =  %trim(W_NOML1) + '.' + W_NDec1
144800000000     C                   Endif
144900000000     C                   If        TNMD = 2
145000000000     C                   If        W_N10 = ' '
145100000000     C                   Eval      W_N10 = *ZERO
145200000000     C                   Endif
145300000000     C                   Eval      A_DDNOML = %trim(W_NOML2) + '.' + W_NDec2
145400000000     C                   Endif
145500000000     C                   If        TNMD = 3
145600000000     C                   If        W_N9 = ' '
145700000000     C                   Eval      W_N9 = *ZERO
145800000000     C                   If        W_N10 = ' '
145900000000     C                   Eval      W_N10 = *ZERO
146000000000     C                   Endif
146100000000     C                   Endif
146200000000     C                   Eval      A_DDNOML = %trim(W_NOML3) + '.' + W_NDec3
146300000000     C                   Endif
146400000000     C                   If        TNMD = 4
146500000000     C                   If        W_N8 = ' '
146600000000     C                   Eval      W_N8 = *ZERO
146700000000     C                   If        W_N9  = ' '
146800000000     C                   Eval      W_N9  = *ZERO
146900000000     C                   If        W_N10 = ' '
147000000000     C                   Eval      W_N10 = *ZERO
147100000000     C                   Endif
147200000000     C                   Endif
147300000000     C                   Endif
147400000000     C                   Eval      A_DDNOML = %trim(W_NOML4) + '.' + W_NDec4
147500000000     C                   Endif
147600000000      *
147700000000      ** - Price/Disc/Yield
147800000000      * If not nil format with Price Decimal places  (15,8)
147900000000     C                   If        O_TPDY  > 0
148000000000     C                   Movel     O_TPDY        W_1508
148100000000      *                  Remove leading Zero
148200000000     C                   If        W_I1 = '0' or W_I1 = ' '
148300000000     C                   Eval      W_I1 = *blank
148400000000     C                   If        W_I2 = '0' or W_I2 = ' '
148500000000     C                   Eval      W_I2 = *blank
148600000000     C                   If        W_I3 = '0' or W_I3 = ' '
148700000000     C                   Eval      W_I3 = *blank
148800000000     C                   If        W_I4 = '0' or W_I4 = ' '
148900000000     C                   Eval      W_I4 = *blank
149000000000     C                   If        W_I5 = '0' or W_I5 = ' '
149100000000     C                   Eval      W_I5 = *blank
149200000000     C                   If        W_I6 = '0' or W_I6 = ' '
149300000000     C                   Eval      W_I6 = *blank
149400000000     C                   Endif
149500000000     C                   Endif
149600000000     C                   Endif
149700000000     C                   Endif
149800000000     C                   Endif
149900000000     C                   Endif
150000000000     C                   Eval      A_DDTPDY  = %trim(W_Int07) + '.' +  W_Dec08
150100000000     c                   Eval      W_1508  = *blank
150200000000     C                   Endif
150300000000      *
150400000000      ** - Value Date
150500000000      * Format Date as DDMMYY
150600000000     C                   Eval      ZDATFM = 'D'
150700000000     C                   CALLB     'ZDATE2'
150800000000     C                   PARM                    O_TDVD
150900000000     C                   PARM                    ZDATFM            1
151000000000     C                   PARM                    ZDATE             6 0
151100000000     C                   PARM                    ZADATE            7
151200000000     C                   Movel     ZDATE         A_DDTDVD
151300000000      *
151400000000      ** - Booking Branch
151500000000      * Overwrite branch to consolidated branch
151600000000     C                   Eval      A_DDBRCD  = FNBRCA
151700000000      *
151800000000      ** - Book
152000210604     C                   If        WrkBook = *Blank
152100000000     C                   Eval      A_DDBPBK  = O_TDBK
152200000000     C                   else
152400210604     C                   Eval      A_DDBPBK  = WrkBook
152500000000     C                   endif
152600000000      *
152700000000      ** - Clearance type
152800000000     C                   If        O_TDTP    = 'TS'
152900000000     C                   Eval      A_DDCLTY  = S_SCLS
153000000000     C                   Eval      A_DDCLTY2 = S_SCLS
153100000000     C                   Else
153200000000     C                   Eval      A_DDCLTY  = S_SCLP
153300000000     C                   Eval      A_DDCLTY2 = S_SCLP
153400000000     C                   endif
153500000000      *
153600000000      ** - Settlement Currency
153700000000     C                   Eval      A_DDSETC  = S_SCCY                                       O_SETC
153800000000      *
153900000000      ** - REALLOWANCE
154000000000      * If not nil format with Price Decimal places  (9,5)  ????
154100000000     C                   If        O_RALL  > 0
154200000000     C                   Movel     O_RALL        W_0905
154300000000     C                   Eval      A_DDRALL  = W_RALLI + '.' +  W_RALLD
154400000000     c                   Eval      W_0905  = *blank
154500000000     C                   Endif
154600000000     c                   Eval      A_DDRALL = *blank                                          ???
154700000000      *
154800000000      ** - Market Center
154900000000     C                   Eval      A_DDMRKT  = O_TMKC
155000000000      *
155100000000      ** - Capacity
155200000000      * Capacity May not be required ????
155300000000     C                   Movel     O_TCAP        A_DDCPCY
155400000000     c                   Eval      A_DDCPCY = *blank                                          ???
155500000000      *
155600000000      ** - Price
155700000000      * If not nil format with Price Decimal places  (15,8) ???
155800000000     C                   If        O_PRIC > 0
155900000000     C                   Movel     O_PRIC        W_1508
156000000000     C                   If        W_I1 = '0' or W_I1 = ' '
156100000000     C                   Eval      W_I1 = *blank
156200000000     C                   If        W_I2 = '0' or W_I2 = ' '
156300000000     C                   Eval      W_I2 = *blank
156400000000     C                   If        W_I3 = '0' or W_I3 = ' '
156500000000     C                   Eval      W_I3 = *blank
156600000000     C                   If        W_I4 = '0' or W_I4 = ' '
156700000000     C                   Eval      W_I4 = *blank
156800000000     C                   If        W_I5 = '0' or W_I5 = ' '
156900000000     C                   Eval      W_I5 = *blank
157000000000     C                   If        W_I6 = '0' or W_I6 = ' '
157100000000     C                   Eval      W_I6 = *blank
157200000000     C                   Endif
157300000000     C                   Endif
157400000000     C                   Endif
157500000000     C                   Endif
157600000000     C                   Endif
157700000000     C                   Endif
157800000000     C                   Eval      A_DDPRIC  = %trim(W_Int07) + '.' +  W_Dec08
157900000000     c                   Eval      W_1508  = *blank
158000000000     C                   Endif
158100000000     c                   Eval      A_DDPRIC = *blank                                          ???
158200000000      *
158300000000      ** - Ex Dividend
158400000000     C                   Eval      A_DDEXDV = *Blank                                          O_EXDV
158500000000      *
158600000000      ** - Fiscal Price
158700000000      * If not nil format with Price Decimal places  (15,8)    ???
158800000000     C                   If        O_FSPR > 0
158900000000     C                   Movel     O_FSPR        W_1508
159000000000     C                   If        W_I1 = '0' or W_I1 = ' '
159100000000     C                   Eval      W_I1 = *blank
159200000000     C                   If        W_I2 = '0' or W_I2 = ' '
159300000000     C                   Eval      W_I2 = *blank
159400000000     C                   If        W_I3 = '0' or W_I3 = ' '
159500000000     C                   Eval      W_I3 = *blank
159600000000     C                   If        W_I4 = '0' or W_I4 = ' '
159700000000     C                   Eval      W_I4 = *blank
159800000000     C                   If        W_I5 = '0' or W_I5 = ' '
159900000000     C                   Eval      W_I5 = *blank
160000000000     C                   If        W_I6 = '0' or W_I6 = ' '
160100000000     C                   Eval      W_I6 = *blank
160200000000     C                   Endif
160300000000     C                   Endif
160400000000     C                   Endif
160500000000     C                   Endif
160600000000     C                   Endif
160700000000     C                   Endif
160800000000     C                   Eval      A_DDFSPR  = %trim(W_Int07) + '.' +  W_Dec08
160900000000     c                   Eval      W_1508  = *blank
161000000000     C                   Endif
161100000000     c                   Eval      A_DDFSPR = *blank                                            ???
161200000000      *
161300000000      ** - Book profit center
161400000000     C                   Eval      A_DDBPRC  = O_BPRC
161500000000      *
161600000000      ** - Trans profit center
161700000000     C                   Eval      A_DDTPRC  = O_TPRC
161800000000      *
161900000000      ** - Trader ID
162000000000     C                   Eval      A_DDTDID  = O_TDID
162100000000      *
162200000000      ** - Trade date
162300000000      * Format Date as DDMMYY
162400000000     C                   Eval      ZDATFM = 'D'
162500000000     C                   CALLB     'ZDATE2'
162600000000     C                   PARM                    O_TDDT
162700000000     C                   PARM                    ZDATFM            1
162800000000     C                   PARM                    ZDATE             6 0
162900000000     C                   PARM                    ZADATE            7
163000000000     C                   Movel     ZDATE         A_DDTDDT
163100000000      *
163200000000      ** - Trade Sub type
163300000000     C                   Eval      A_DDTSUB  = O_TSUB
163400000000      *
163500000000      ** - Link Ref  Never on duplication
163600000000     C                   Eval      A_DDLKRF = *blank                                          O_LKRF
163700000000      *
163800000000      ** - Market indicator  ????
163900000000     C                   Eval      A_DDTDMI = O_TDMI
164000000000      *
164100000000      ** - ISMA / IPMA
164200000000      *  Not sure AIIP must be taken ????
164300000000     C                   Eval      A_DDAIIP = O_AIIP
164400000000      *
164500000000      ** - Narrative
164600000000     C                   Eval      A_DDTDNR = O_TDNR
164700000000      *
164800000000      ** - P order number never on replication
164900000000      * Will never be from TOF
165000000000     C                   Eval      A_DDORDE  = *Blank
165100000000      *
165200000000      ** - Accrued indicator
165300000000     C                   Eval      A_DDACIN  = *blank                                         O_ACIN
165400000000      *
165500000000      ** - Days Adj/sign
165600000000     C                   If        O_DADJ > 0
165700000000     C                   Movel     O_DADJ        A_DDDADJ
165800000000     C                   Endif
165900000000     C                   Eval      A_DDDADJ  = *blank                                         O_DADJ
166000000000      *
166100000000      ** - Act/Diff Ind
166200000000     C                   Eval      A_DDACTD  =  *Blank
166300000000      *
166400000000      ** - Int Amnr/Sign
166500000000      * If not nil format with Nominal currncy position ????
166600000000     C                   If        O_ITRA > 0
166700000000     C                   Move      O_ITRA        W_ChgL
166800000000     C                   If        A6NBDP = 0
166900000000     C                   Eval      A_DDITRA  = W_ChgL
167000000000     C                   Endif
167100000000     C                   If        A6NBDP = 1
167200000000     C                   Eval      A_DDITRA  = W_ChgL1 + '.' + W_CDec1
167300000000     C                   Endif
167400000000     C                   If        A6NBDP = 2
167500000000     C                   Eval      A_DDITRA  = W_ChgL2 + '.' + W_CDec2
167600000000     C                   Endif
167700000000     C                   If        A6NBDP = 3
167800000000     C                   Eval      A_DDITRA  = W_ChgL3 + '.' + W_CDec3
167900000000     C                   Endif
168000000000     C                   Endif
168100000000     C                   Eval      A_DDITRA  = *blank                                          ????
168200000000     C                   clear                   W_ChgL
168300000000      *
168400000000      ** - Origin
168500000000     C                   Eval      A_DDINOR  = *Blank
168600000000      *
168700000000      ** - Message Key
168800000000     C                   Eval      A_DDMSGK  = *Blank
168900000000      *
169000000000      ** - Notification method
169100000000     C                   Eval      A_DDNTMT  = *Blank
169200000000      *
169300000000      * Ignoring following block
169400000000     C                   Eval      A_DDNOM1  = *Blank
169500000000     C                   Eval      A_DDTDV1  = *Blank
169600000000     C                   Eval      A_DDACI1  = *Blank
169700000000     C                   Eval      A_DDDAD1  = *Blank
169800000000     C                   Eval      A_DDACT1  = *Blank
169900000000     C                   Eval      A_DDITR1  = *Blank
170000000000      *
170100000000      ** - Exchange rate
170200000000      * If not nil format with rate Decimal places  (13,8)
170300000000     C                   If        O_TDER > 0
170400000000     C                   Movel     O_TDER        W_1308
170500000000     C                   If        W_I1 = '0' or W_I1 = ' '
170600000000     C                   Eval      W_I1 = *blank
170700000000     C                   If        W_I2 = '0' or W_I2 = ' '
170800000000     C                   Eval      W_I2 = *blank
170900000000     C                   If        W_I3 = '0' or W_I3 = ' '
171000000000     C                   Eval      W_I3 = *blank
171100000000     C                   If        W_I4 = '0' or W_I4 = ' '
171200000000     C                   Eval      W_I4 = *blank
171300000000     C                   If        W_I5 = '0' or W_I5 = ' '
171400000000     C                   Eval      W_I5 = *blank
171500000000     C                   If        W_I6 = '0' or W_I6 = ' '
171600000000     C                   Eval      W_I6 = *blank
171700000000     C                   Endif
171800000000     C                   Endif
171900000000     C                   Endif
172000000000     C                   Endif
172100000000     C                   Endif
172200000000     C                   Endif
172300000000     C                   Eval      A_DDTDER  = %trim(W_Int07) + '.' +  W_Dec08
172400000000     c                   Eval      W_1508  = *blank
172500000000     C                   Endif
172600000000     c                   Eval      A_DDTDER = *blank                                            ???
172700000000      *
172800000000      ** - Exchange rateM/D
172900000000     C                   Eval      A_DDSMDI  = *Blank
173000000000      *
173100000000      ** - Margin
173200000000     C                   Eval      A_DDFXMP  = *Blank
173300000000      *
173400000000      ** - Base currency rate
173500000000     C                   Eval      A_DDBRTE  = *Blank
173600000000      *
173700000000      *  Settlement field are left blank
173800000000     C                   If        O_TDTP    = 'TS'
173900000000     C                   Move      S_SRSM        A_DDSMTH
174000000000     C                   Else
174100000000     C                   Move      S_SPSM        A_DDSMTH
174200000000     C                   endif
174300000000     C                   Eval      A_DDORBR  = *Blank
174400000000     C                   If        O_TDTP    = 'TS'
174500000000     C                   Eval      A_DDPYFM  = *Blank
174600000000     C                   Else
174700000000     C                   Eval      A_DDPYFM  = S_SPAT
174800000000     C                   endif
174900000000     C                   Eval      A_DDPFSN  = *Blank
175000000000     C                   Eval      A_DDPFNM  = *Blank
175100000000     C                   Eval      A_DDPFTN  = *Blank
175200000000     C                   Eval      A_DDPFAN  = *Blank
175300000000     C                   Eval      A_DDPFSW  = *Blank
175400000000     C                   Eval      A_DDPYFB  = *Blank
175500000000     C                   If        O_TDTP    = 'TP'
175600000000     C                   Eval      A_DDPAYT  = *Blank
175700000000     C                   Else
175800000000     C                   Eval      A_DDPAYT  = S_SRAC
175900000000     C                   endif
176000000000     C                   Eval      A_DDPTSN  = *Blank
176100000000     C                   Eval      A_DDPTNM  = *Blank
176200000000     C                   Eval      A_DDPTTN  = *Blank
176300000000     C                   Eval      A_DDPTAN  = *Blank
176400000000     C                   Eval      A_DDPTSI  = *Blank
176500000000     C                   Eval      A_DDPYTB  = *Blank
176600000000     C                   Eval      A_DDTDFA  = *Blank
176700000000     C                   Eval      A_DDFASN  = *Blank
176800000000     C                   Eval      A_DDFANM  = *Blank
176900000000     C                   Eval      A_DDFATN  = *Blank
177000000000     C                   Eval      A_DDFASW  = *Blank
177100000000     C                   Eval      A_DDASNM  = *Blank
177500000000     C                   Eval      A_DDDELF  = S_SDFO
177700000000     C                   Eval      A_DDDFSN  = *Blank
177800000000     C                   Eval      A_DDDFNM  = *Blank
177900000000     C                   Eval      A_DDDFTN  = *Blank
178000000000     C                   Eval      A_DDDFSI  = *Blank
178400000000     C                   Eval      A_DDDELT  = S_SDTO
178600000000     C                   Eval      A_DDDTSN  = *Blank
178700000000     C                   Eval      A_DDDTNM  = *Blank
178800000000     C                   Eval      A_DDDTTN  = *Blank
178900000000     C                   Eval      A_DDDTSI  = *Blank
179000000000     C                   Eval      A_DDDFFA  = *Blank
179100000000     C                   Eval      A_DDD1SN  = *Blank
179200000000     C                   Eval      A_DDD1NM  = *Blank
179300000000     C                   Eval      A_DDD1TN  = *Blank
179400000000     C                   Eval      A_DDD1SI  = *Blank
179500000000     C                   Eval      A_DDDTFA  = *Blank
179600000000     C                   Eval      A_DDD2SN  = *Blank
179700000000     C                   Eval      A_DDD2NM  = *Blank
179800000000     C                   Eval      A_DDD2TN  = *Blank
179900000000     C                   Eval      A_DDD2SI  = *Blank
180000000000     C                   Eval      A_DDTDSI  = *Blank
180100000000      *
180200000000      *
180300000000      ** - In Currency in F72
180400000000     C                   Eval      A_DDICCY  = *blank
180500000000      *
180600000000      ** - Profit Center
180700000000     C                   Eval      A_DDPRFC  = *blank                                         O_PRFC
180800000000      *
180900000000      ** - Priority code
181000000000     C                   Eval      A_DDPRYC  = *blank                                         O_PRYC
181100000000      *
181200000000      ** - Pay Code
181300000000     C                   If        O_TDTP    = 'TS'
181400000000     C                   Eval      A_DDPCOD  = S_SPCS
181500000000     C                   Else
181600000000     C                   Eval      A_DDPCOD  = S_SPCP
181700000000     C                   endif
181800000000      *
181900000000      ** - Auto settle ind
182000000000     C                   Eval      A_DDAUTS  = S_SASI
182100000000      *
182200000000      ** - Brok Comm code
182300000000     C                   Eval      A_DDTBCC  =  O_TBCC
182400000000      *
182500000000      ** - Brok Com Amount
182600000000      * If not nil format with Nominal currncy position
182700000000     C                   If        O_TBCA > 0
182800000000     C                   Move      O_TBCA        W_ChgL
182900000000     C                   If        A6NBDP = 0
183000000000     C                   Eval      A_DDTBCA  = W_ChgL
183100000000     C                   Endif
183200000000     C                   If        A6NBDP = 1
183300000000     C                   Eval      A_DDTBCA  = W_ChgL1 + '.' + W_CDec1
183400000000     C                   Endif
183500000000     C                   If        A6NBDP = 2
183600000000     C                   Eval      A_DDTBCA  = W_ChgL2 + '.' + W_CDec2
183700000000     C                   Endif
183800000000     C                   If        A6NBDP = 3
183900000000     C                   Eval      A_DDTBCA  = W_ChgL3 + '.' + W_CDec3
184000000000     C                   Endif
184100000000     C                   Endif
184200000000     C                   clear                   W_ChgL
184300000000      *
184400000000      ** - Cust com code
184500000000     C                   Eval      A_DDTCCC  = O_TCCC
184600000000      *
184700000000      ** - Cust Comm Amount
184800000000      * If not nil format with Nominal currncy position
184900000000     C                   If        O_TCCA > 0
185000000000     C                   Move      O_TCCA        W_ChgL
185100000000     C                   If        A6NBDP = 0
185200000000     C                   Eval      A_DDTCCA  = W_ChgL
185300000000     C                   Endif
185400000000     C                   If        A6NBDP = 1
185500000000     C                   Eval      A_DDTCCA  = W_ChgL1 + '.' + W_CDec1
185600000000     C                   Endif
185700000000     C                   If        A6NBDP = 2
185800000000     C                   Eval      A_DDTCCA  = W_ChgL2 + '.' + W_CDec2
185900000000     C                   Endif
186000000000     C                   If        A6NBDP = 3
186100000000     C                   Eval      A_DDTCCA  = W_ChgL3 + '.' + W_CDec3
186200000000     C                   Endif
186300000000     C                   Endif
186400000000     C                   clear                   W_ChgL
186500000000      *
186600000000      ** - Chg code 1
186700000000     C                   Eval      A_DDTCC1  = O_TCC1
186800000000      *
186900000000      ** - Chg Amount 1
187000000000      * If not nil format with Nominal currncy position
187100000000     C                   If        O_TCA1 > 0
187200000000     C                   Move      O_TCA1        W_ChgL
187300000000     C                   If        A6NBDP = 0
187400000000     C                   Eval      A_DDTCA1  = W_ChgL
187500000000     C                   Endif
187600000000     C                   If        A6NBDP = 1
187700000000     C                   Eval      A_DDTCA1  = W_ChgL1 + '.' + W_CDec1
187800000000     C                   Endif
187900000000     C                   If        A6NBDP = 2
188000000000     C                   Eval      A_DDTCA1  = W_ChgL2 + '.' + W_CDec2
188100000000     C                   Endif
188200000000     C                   If        A6NBDP = 3
188300000000     C                   Eval      A_DDTCA1  = W_ChgL3 + '.' + W_CDec3
188400000000     C                   Endif
188500000000     C                   Endif
188600000000     C                   clear                   W_ChgL
188700000000      *
188800000000      ** - Chg code 2
188900000000     C                   Eval      A_DDTCC2  = O_TCC2
189000000000      *
189100000000      ** - Chg Amount 2
189200000000      * If not nil format with Nominal currncy position
189300000000     C                   If        O_TCA2 > 0
189400000000     C                   Move      O_TCA2        W_ChgL
189500000000     C                   If        A6NBDP = 0
189600000000     C                   Eval      A_DDTCA2  = W_ChgL
189700000000     C                   Endif
189800000000     C                   If        A6NBDP = 1
189900000000     C                   Eval      A_DDTCA2  = W_ChgL1 + '.' + W_CDec1
190000000000     C                   Endif
190100000000     C                   If        A6NBDP = 2
190200000000     C                   Eval      A_DDTCA2  = W_ChgL2 + '.' + W_CDec2
190300000000     C                   Endif
190400000000     C                   If        A6NBDP = 3
190500000000     C                   Eval      A_DDTCA2  = W_ChgL3 + '.' + W_CDec3
190600000000     C                   Endif
190700000000     C                   Endif
190800000000     C                   clear                   W_ChgL
190900000000      ** - Chg code 3
191000000000      *
191100000000     C                   Eval      A_DDTCC3  = O_TCC3
191200000000      *
191300000000      ** - Chg Amount 3
191400000000      * If not nil format with Nominal currncy position
191500000000     C                   If        O_TCA3 > 0
191600000000     C                   Move      O_TCA3        W_ChgL
191700000000     C                   If        A6NBDP = 0
191800000000     C                   Eval      A_DDTCA3  = W_ChgL
191900000000     C                   Endif
192000000000     C                   If        A6NBDP = 1
192100000000     C                   Eval      A_DDTCA3  = W_ChgL1 + '.' + W_CDec1
192200000000     C                   Endif
192300000000     C                   If        A6NBDP = 2
192400000000     C                   Eval      A_DDTCA3  = W_ChgL2 + '.' + W_CDec2
192500000000     C                   Endif
192600000000     C                   If        A6NBDP = 3
192700000000     C                   Eval      A_DDTCA3  = W_ChgL3 + '.' + W_CDec3
192800000000     C                   Endif
192900000000     C                   Endif
193000000000     C                   clear                   W_ChgL
193100000000      ** - Chg code 4
193200000000      *
193300000000     C                   Eval      A_DDTCC4  = O_TCC4
193400000000      *
193500000000      ** - Chg Amount 4
193600000000      * If not nil format with Nominal currncy position
193700000000     C                   If        O_TCA4 > 0
193800000000     C                   Move      O_TCA4        W_ChgL
193900000000     C                   If        A6NBDP = 0
194000000000     C                   Eval      A_DDTCA4  = W_ChgL
194100000000     C                   Endif
194200000000     C                   If        A6NBDP = 1
194300000000     C                   Eval      A_DDTCA4  = W_ChgL1 + '.' + W_CDec1
194400000000     C                   Endif
194500000000     C                   If        A6NBDP = 2
194600000000     C                   Eval      A_DDTCA4  = W_ChgL2 + '.' + W_CDec2
194700000000     C                   Endif
194800000000     C                   If        A6NBDP = 3
194900000000     C                   Eval      A_DDTCA4  = W_ChgL3 + '.' + W_CDec3
195000000000     C                   Endif
195100000000     C                   Endif
195200000000     C                   clear                   W_ChgL
195300000000      *
195400000000      ** - Chg code 5
195500000000     C                   Eval      A_DDTCC5  = O_TCC5
195600000000      *
195700000000      ** - Chg Amount 5
195800000000      * If not nil format with Nominal currncy position
195900000000     C                   If        O_TCA5 > 0
196000000000     C                   Move      O_TCA5        W_ChgL
196100000000     C                   If        A6NBDP = 0
196200000000     C                   Eval      A_DDTCA5  = W_ChgL
196300000000     C                   Endif
196400000000     C                   If        A6NBDP = 1
196500000000     C                   Eval      A_DDTCA5  = W_ChgL1 + '.' + W_CDec1
196600000000     C                   Endif
196700000000     C                   If        A6NBDP = 2
196800000000     C                   Eval      A_DDTCA5  = W_ChgL2 + '.' + W_CDec2
196900000000     C                   Endif
197000000000     C                   If        A6NBDP = 3
197100000000     C                   Eval      A_DDTCA5  = W_ChgL3 + '.' + W_CDec3
197200000000     C                   Endif
197300000000     C                   Endif
197400000000     C                   clear                   W_ChgL
197500000000      *
197600000000      ** - Chg code 6
197700000000     C                   Eval      A_DDTCC6  = O_TCC6
197800000000      *
197900000000      ** - Chg Amount 6
198000000000      * If not nil format with Nominal currncy position
198100000000     C                   If        O_TCA6 > 0
198200000000     C                   Move      O_TCA6        W_ChgL
198300000000     C                   If        A6NBDP = 0
198400000000     C                   Eval      A_DDTCA6  = W_ChgL
198500000000     C                   Endif
198600000000     C                   If        A6NBDP = 1
198700000000     C                   Eval      A_DDTCA6  = W_ChgL1 + '.' + W_CDec1
198800000000     C                   Endif
198900000000     C                   If        A6NBDP = 2
199000000000     C                   Eval      A_DDTCA6  = W_ChgL2 + '.' + W_CDec2
199100000000     C                   Endif
199200000000     C                   If        A6NBDP = 3
199300000000     C                   Eval      A_DDTCA6  = W_ChgL3 + '.' + W_CDec3
199400000000     C                   Endif
199500000000     C                   Endif
199600000000     C                   clear                   W_ChgL
199700000000      *
199800000000      ** - Chg code 7
199900000000     C                   Eval      A_DDTCC7  = O_TCC7
200000000000      *
200100000000      ** - Chg Amount 7
200200000000      * If not nil format with Nominal currncy position
200300000000     C                   If        O_TCA7 > 0
200400000000     C                   Move      O_TCA7        W_ChgL
200500000000     C                   If        A6NBDP = 0
200600000000     C                   Eval      A_DDTCA7  = W_ChgL
200700000000     C                   Endif
200800000000     C                   If        A6NBDP = 1
200900000000     C                   Eval      A_DDTCA7  = W_ChgL1 + '.' + W_CDec1
201000000000     C                   Endif
201100000000     C                   If        A6NBDP = 2
201200000000     C                   Eval      A_DDTCA7  = W_ChgL2 + '.' + W_CDec2
201300000000     C                   Endif
201400000000     C                   If        A6NBDP = 3
201500000000     C                   Eval      A_DDTCA7  = W_ChgL3 + '.' + W_CDec3
201600000000     C                   Endif
201700000000     C                   Endif
201800000000     C                   clear                   W_ChgL
201900000000      *
202000000000      ** - Tax amount    always blank on replication
202100000000      * If not nil format with Nominal currncy position
202200000000     C                   If        O_TAXA > 0
202300000000     C                   Move      O_TAXA        W_ChgL
202400000000     C                   If        A6NBDP = 0
202500000000     C                   Eval      A_DDTAXA  = W_ChgL
202600000000     C                   Endif
202700000000     C                   If        A6NBDP = 1
202800000000     C                   Eval      A_DDTAXA  = W_ChgL1 + '.' + W_CDec1
202900000000     C                   Endif
203000000000     C                   If        A6NBDP = 2
203100000000     C                   Eval      A_DDTAXA  = W_ChgL2 + '.' + W_CDec2
203200000000     C                   Endif
203300000000     C                   If        A6NBDP = 3
203400000000     C                   Eval      A_DDTAXA  = W_ChgL3 + '.' + W_CDec3
203500000000     C                   Endif
203600000000     C                   Endif
203700000000     C                   Eval      A_DDTAXA  = *blank                                            ???
203800000000     C                   clear                   W_ChgL
203900000000      *
204000000000      ** - EU tax amount in nominall currency always balnk on replication
204100000000      * If not nil format with Nominal currncy position
204200000000     C                   If        O_EUTX > 0
204300000000     C                   Move      O_EUTX        W_ChgL
204400000000     C                   If        A6NBDP = 0
204500000000     C                   Eval      A_DDEUTX  = W_ChgL
204600000000     C                   Endif
204700000000     C                   If        A6NBDP = 1
204800000000     C                   Eval      A_DDEUTX  = W_ChgL1 + '.' + W_CDec1
204900000000     C                   Endif
205000000000     C                   If        A6NBDP = 2
205100000000     C                   Eval      A_DDEUTX  = W_ChgL2 + '.' + W_CDec2
205200000000     C                   Endif
205300000000     C                   If        A6NBDP = 3
205400000000     C                   Eval      A_DDEUTX  = W_ChgL3 + '.' + W_CDec3
205500000000     C                   Endif
205600000000     C                   Endif
205700000000     C                   Eval      A_DDEUTX  = *blank                                            ???
205800000000     C                   clear                   W_ChgL
205900000000      *
206000000000      ** - Brok Comm  Rebate
206100000000      * If not nil format with Nominal currency position
206200000000     C                   If        O_BCMR > 0
206300000000     C                   Move      O_BCMR        W_ChgL
206400000000     C                   If        A6NBDP = 0
206500000000     C                   Eval      A_DDBCMR  = W_ChgL
206600000000     C                   Endif
206700000000     C                   If        A6NBDP = 1
206800000000     C                   Eval      A_DDBCMR  = W_ChgL1 + '.' + W_CDec1
206900000000     C                   Endif
207000000000     C                   If        A6NBDP = 2
207100000000     C                   Eval      A_DDBCMR  = W_ChgL2 + '.' + W_CDec2
207200000000     C                   Endif
207300000000     C                   If        A6NBDP = 3
207400000000     C                   Eval      A_DDBCMR  = W_ChgL3 + '.' + W_CDec3
207500000000     C                   Endif
207600000000     C                   Endif
207700000000     C                   clear                   W_ChgL
207800000000      *
207900000000      ** - Cust Comm rebate
208000000000      * If not nil format with Nominal currency position
208100000000     C                   If        O_CCMR > 0
208200000000     C                   Move      O_CCMR        W_ChgL
208300000000     C                   If        A6NBDP = 0
208400000000     C                   Eval      A_DDCCMR  = W_ChgL
208500000000     C                   Endif
208600000000     C                   If        A6NBDP = 1
208700000000     C                   Eval      A_DDCCMR  = W_ChgL1 + '.' + W_CDec1
208800000000     C                   Endif
208900000000     C                   If        A6NBDP = 2
209000000000     C                   Eval      A_DDCCMR  = W_ChgL2 + '.' + W_CDec2
209100000000     C                   Endif
209200000000     C                   If        A6NBDP = 3
209300000000     C                   Eval      A_DDCCMR  = W_ChgL3 + '.' + W_CDec3
209400000000     C                   Endif
209500000000     C                   Endif
209600000000     C                   clear                   W_ChgL
209700000000      *
209800000000      ** - Tax rebate always blank on replication
209900000000      * If not nil format with Nominal currency position
210000000000     C                   If        O_TXRB > 0
210100000000     C                   Move      O_TXRB        W_ChgL
210200000000     C                   If        A6NBDP = 0
210300000000     C                   Eval      A_DDTXRB  = W_ChgL
210400000000     C                   Endif
210500000000     C                   If        A6NBDP = 1
210600000000     C                   Eval      A_DDTXRB  = W_ChgL1 + '.' + W_CDec1
210700000000     C                   Endif
210800000000     C                   If        A6NBDP = 2
210900000000     C                   Eval      A_DDTXRB  = W_ChgL2 + '.' + W_CDec2
211000000000     C                   Endif
211100000000     C                   If        A6NBDP = 3
211200000000     C                   Eval      A_DDTXRB  = W_ChgL3 + '.' + W_CDec3
211300000000     C                   Endif
211400000000     C                   Endif
211500000000     C                   Eval      A_DDTXRB  = *blank                                            ???
211600000000     C                   clear                   W_ChgL
211700000000      *
211800000000      ** - Portfolio reference Always Blank on replication
211900000000     C                   Eval      A_DDPTFR   = *Blank
212000000000      *  Extension file TRADSDX1  Not sure it needs to be setup
212100000000      *
212200000000      *  Settlement Message Request
212300000000     C                   Eval      A_ADDGMES  = *Blank
212400000000      *
212500000000      *  Time of Trade
212600000000     C                   Eval      A_ADDTRTT  = *Blank
212700000000      *
212800000000      *  Instructions Type
212900000000     C                   Eval      A_ADDINST  = *Blank
213000000000      *
213100000000      *   Instructions sub-type
213200000000     C                   Eval      A_ADDINSS  = *Blank
213300000000      *
213400000000      *   Euroclear/Cedel code
213500000000     C                   Eval      A_ADDEUCL  = *Blank
213600000000      *
213700000000      *  Safekeeping Account (MT580)
213800000000     C                   Eval      A_ADDSAFA  = *Blank
213900000000      *
214000000000      *  Requested Priority
214100000000     C                   Eval      A_ADDRPTY  = *Blank
214200000000      *
214300000000      *  Guaranteed Delivery
214400000000     C                   Eval      A_ADDGDEL  = *Blank
214500000000      *
214600000000      *  Sender's Role
214700000000     C                   Eval      A_ADDSROL  = *Blank
214800000000      *
214900000000      *  Fungibilty Code
215000000000     C                   Eval      A_ADDFCOD  = *Blank
215100000000      *
215200000000      *  Fungible Trade Indicator
215300000000     C                   Eval      A_ADDFTID  = *Blank
215400000000      *
215500000000      *  Confirmation Message Request
215600000000     C                   Eval      A_ADDGMEC  = *Blank
215700000000      *
215800000000      *  Customer/Counterparty Ind.
215900000000     C                   Eval      A_ADDCCID  = *Blank
216000000000      *
216100000000      *  Further Id.
216200000000     C                   Eval      A_ADDFID1  = *Blank
216300000000      *
216400000000      *  Standard Instructions' Overr  ?
216500000000     C                   Eval      A_ADDIORA  = *Blank
216600000000      *
216700000000      *  ISO15022 Messages Ind.
216800000000     C                   Eval      A_ADDSNEW  = *Blank
216900000000      *
217000000000      *  Stamp Status
217100000000     C                   Eval      A_ADDSTMP  = *Blank
217200000000      *
217300000000      *  Charity Identifier
217400000000     C                   Eval      A_ADDCHID  = *Blank
217500000000      *
217600000000      *  Transaction Report Marker
217700000000     C                   Eval      A_ADDTRRM  =  *Blank
217800000000      *
217900000000      * Ignore following block
218000000000     C                   Eval      A_BDDGMES  =  *Blank
218100000000     C                   Eval      A_BDDTRTT  =  *Blank
218200000000     C                   Eval      A_BDDINST   = *Blank
218300000000     C                   Eval      A_BDDINSS   = *Blank
218400000000     C                   Eval      A_BDDEUCL   = *Blank
218500000000     C                   Eval      A_BDDSAFA   = *Blank
218600000000     C                   Eval      A_BDDRPTY   = *Blank
218700000000     C                   Eval      A_BDDGDEL   = *Blank
218800000000     C                   Eval      A_BDDSROL   = *Blank
218900000000     C                   Eval      A_BDDFCOD   = *Blank
219000000000     C                   Eval      A_BDDFTID   = *Blank
219100000000     C                   Eval      A_BDDGMEC   = *Blank
219200000000     C                   Eval      A_BDDCCID   = *Blank
219300000000     C                   Eval      A_BDDFID1   = *Blank
219400000000     C                   Eval      A_BDDIORA   = *Blank
219500000000     C                   Eval      A_BDDSNEW   = *Blank
219600000000     C                   Eval      A_BDDSTMP   = *Blank
219700000000     C                   Eval      A_BDDCHID   = *Blank
219800000000     C                   Eval      A_BDDTRRM   = *Blank
219900000000      *
220000000000      * Ignore following block
220100000000     C                   Eval      A_AESAP1N   = *Blank
220200000000     C                   Eval      A_DDA1SN    = *Blank
220300000000     C                   Eval      A_DDA1NM    = *Blank
220400000000     C                   Eval      A_DDA1TN    = *Blank
220500000000     C                   Eval      A_DDA1SI    = *Blank
220600000000     C                   Eval      A_AESAP1L   = *Blank
220700000000     C                   Eval      A_AESAP2N   = *Blank
220800000000     C                   Eval      A_DDA2SN   =  *Blank
220900000000     C                   Eval      A_DDA2NM   =  *Blank
221000000000     C                   Eval      A_DDA2TN   =  *Blank
221100000000     C                   Eval      A_DDA2SI   =  *Blank
221200000000     C                   Eval      A_AESAP2L  =  *Blank
221300000000     C                   Eval      A_AESAWIN  =  *Blank
221400000000     C                   Eval      A_DDAISN   =  *Blank
221500000000     C                   Eval      A_DDAINM   =  *Blank
221600000000     C                   Eval      A_DDAITN   =  *Blank
221700000000     C                   Eval      A_DDAISI   =  *Blank
221800000000     C                   Eval      A_AESAWIL  =  *Blank
221900000000     C                   Eval      A_AESBOFN  =  *Blank
222000000000     C                   Eval      A_DDBMSN   =  *Blank
222100000000     C                   Eval      A_DDBMNM   =  *Blank
222200000000     C                   Eval      A_DDBMTN   =  *Blank
222300000000     C                   Eval      A_DDBMSI   =  *Blank
222400000000     C                   Eval      A_AESBOF1  =  *Blank
222500000000     C                   Eval      A_AESBOF2  =  *Blank
222600000000     C                   Eval      A_AESACL1  =  *Blank
222700000000     C                   Eval      A_AESACL2  =  *Blank
222800000000     C                   Eval      A_AESSRL1  =  *Blank
222900000000     C                   Eval      A_AESSRL2  =  *Blank
223000000000     C                   Eval      A_AESSRL3  =  *Blank
223100000000     C                   Eval      A_AESFIN1  =  *Blank
223200000000     C                   Eval      A_AESFIN2   = *Blank
223300000000     C                   Eval      A_AESRED1   = *Blank
223400000000     C                   Eval      A_AESRED2   = *Blank
223500000000     C                   Eval      A_AESNAL1   = *Blank
223600000000     C                   Eval      A_AESNAL2   = *Blank
223700000000     C                   Eval      A_AESIPYN   = *Blank
223800000000     C                   Eval      A_DDIPSN    = *Blank
223900000000     C                   Eval      A_DDIPNM    = *Blank
224000000000     C                   Eval      A_DDIPTN    = *Blank
224100000000     C                   Eval      A_DDIPSI    = *Blank
224200000000     C                   Eval      A_AESIPYL   = *Blank
224300000000     C                   Eval      A_AESCTYN   = *Blank
224400000000     C                   Eval      A_AESCTYL   = *Blank
224500000000     C                   Eval      A_AESSA1N   = *Blank
224600000000     C                   Eval      A_DDCZSN    = *Blank
224700000000     C                   Eval      A_DDCSNM    = *Blank
224800000000     C                   Eval      A_DDCSTN    = *Blank
224900000000     C                   Eval      A_DDCSSI    = *Blank
225000000000     C                   Eval      A_AESSA1L   = *Blank
225100000000     C                   Eval      A_AESSKAN   = *Blank
225200000000     C                   Eval      A_DDUSSN    = *Blank
225300000000     C                   Eval      A_DDUSNM    = *Blank
225400000000     C                   Eval      A_DDUSTN    = *Blank
225500000000     C                   Eval      A_DDUSSI    = *Blank
225600000000     C                   Eval      A_AESSKAL   = *Blank
225700000000     C                   Eval      A_AESCCTN   = *Blank
225800000000     C                   Eval      A_DDCCSN    = *Blank
225900000000     C                   Eval      A_DDCCNM    = *Blank
226000000000     C                   Eval      A_DDCCTN    = *Blank
226100000000     C                   Eval      A_DDCCSI    = *Blank
226200000000     C                   Eval      A_AESDCTL   = *Blank
226300000000     C                   Eval      A_AESRSSN   = *Blank
226400000000     C                   Eval      A_DDRSSN    = *Blank
226500000000     C                   Eval      A_DDRSNM    = *Blank
226600000000     C                   Eval      A_DDRSTN    = *Blank
226700000000     C                   Eval      A_DDRSSI    = *Blank
226800000000     C                   Eval      A_AESRSS1   = *Blank
226900000000     C                   Eval      A_AESRSS2   = *Blank
227000000000     C                   Eval      A_AESRSS3   = *Blank
227100000000     C                   Eval      A_AESRSS4   = *Blank
227200000000     C                   Eval      A_AESDSSN   = *Blank
227300000000     C                   Eval      A_AESDSS1   = *Blank
227400000000     C                   Eval      A_AESDSS2   = *Blank
227500000000     C                   Eval      A_AESDSS3   = *Blank
227600000000     C                   Eval      A_AESDSS4   = *Blank
227700000000     C                   Eval      A_AESBSSN   = *Blank
227800000000     C                   Eval      A_AESBSS1   = *Blank
227900000000     C                   Eval      A_AESBSS2   = *Blank
228000000000     C                   Eval      A_AESINVE   = *Blank
228100000000     C                   Eval      A_DDIOSN    = *Blank
228200000000     C                   Eval      A_DDIONM    = *Blank
228300000000     C                   Eval      A_DDIOTN    = *Blank
228400000000     C                   Eval      A_DDIOSI    = *Blank
228500000000     C                   Eval      A_AESIMMD1  = *Blank
228600000000     C                   Eval      A_DDI1SN    = *Blank
228700000000     C                   Eval      A_DDI1NM    = *Blank
228800000000     C                   Eval      A_DDI1TN    = *Blank
228900000000     C                   Eval      A_DDI1SI    = *Blank
229000000000     C                   Eval      A_AESIMSA1  = *Blank
229100000000     C                   Eval      A_AESIMMD2  = *Blank
229200000000     C                   Eval      A_DDI2SN    = *Blank
229300000000     C                   Eval      A_DDI2NM    = *Blank
229400000000     C                   Eval      A_DDI2TN    = *Blank
229500000000     C                   Eval      A_DDI2SI    = *Blank
229600000000     C                   Eval      A_AESIMSA2  = *Blank
229700000000     C                   Eval      A_AESIMMD3  = *Blank
229800000000     C                   Eval      A_AESIMSA3  = *Blank
229900000000     C                   Eval      A_AESIMMD4  = *Blank
230000000000     C                   Eval      A_AESIMSA4  = *Blank
230100000000     C                   Eval      A_AESIMMD5  = *Blank
230200000000     C                   Eval      A_AESIMSA5  = *Blank
230300000000     C                   Eval      A_AESIMMD6  = *Blank
230400000000     C                   Eval      A_AESIMSA6  = *Blank
230500000000     C                   Eval      A_AESIMMD7  = *Blank
230600000000     C                   Eval      A_AESIMSA7  = *Blank
230700000000     C                   Eval      A_AESIMMD8  = *Blank
230800000000     C                   Eval      A_AESIMSA8  = *Blank
230900000000     C                   Eval      A_AESIMMD9  = *Blank
231000000000     C                   Eval      A_AESIMSA9  = *Blank
231100000000     C                   Eval      A_AESPSET   = *Blank
231200000000     C                   Eval      A_DDPSSN    = *Blank
231300000000     C                   Eval      A_DDPSNM    = *Blank
231400000000     C                   Eval      A_DDPSTN    = *Blank
231500000000     C                   Eval      A_DDPSSI    = *Blank
231600000000     C                   Eval      A_AESNAC1   = *Blank
231700000000     C                   Eval      A_AESNAC2   = *Blank
231800000000     C                   Eval      A_AESDIDN   = *Blank
231900000000     C                   Eval      A_AESDAD1   = *Blank
232000000000     C                   Eval      A_AESDAD2   = *Blank
232100000000     C                   Eval      A_AESDAD3   = *Blank
232200000000     C                   Eval      A_AESDAD4   = *Blank
232300000000     C                   Eval      A_AESDLIN   = *Blank
232400000000     C                   Eval      A_AESQFIN   = *Blank
232500000000     C                   Eval      A_AESPCLR   = *Blank
232600000000     C                   Eval      A_BESAP1N   = *Blank
232700000000     C                   Eval      A_BDA1SN    = *Blank
232800000000     C                   Eval      A_BDA1NM   =  *Blank
232900000000     C                   Eval      A_BDA1TN   =  *Blank
233000000000     C                   Eval      A_BDA1SI   =  *Blank
233100000000     C                   Eval      A_BESAP1L  =  *Blank
233200000000     C                   Eval      A_BESAP2N  =  *Blank
233300000000     C                   Eval      A_BDA2SN   =  *Blank
233400000000     C                   Eval      A_BDA2NM   =  *Blank
233500000000     C                   Eval      A_BDA2TN   =  *Blank
233600000000     C                   Eval      A_BDA2SI   =  *Blank
233700000000     C                   Eval      A_BESAP2L  =  *Blank
233800000000     C                   Eval      A_BESAWIN  =  *Blank
233900000000     C                   Eval      A_BDAISN   =  *Blank
234000000000     C                   Eval      A_BDAINM   =  *Blank
234100000000     C                   Eval      A_BDAITN   =  *Blank
234200000000     C                   Eval      A_BDAISI   =  *Blank
234300000000     C                   Eval      A_BESAWIL  =  *Blank
234400000000     C                   Eval      A_BESBOFN  =  *Blank
234500000000     C                   Eval      A_BDBMSN   =  *Blank
234600000000     C                   Eval      A_BDBMNM   =  *Blank
234700000000     C                   Eval      A_BDBMTN   =  *Blank
234800000000     C                   Eval      A_BDBMSI   =  *Blank
234900000000     C                   Eval      A_BESBOF1  =  *Blank
235000000000     C                   Eval      A_BESBOF2  =  *Blank
235100000000     C                   Eval      A_BESACL1  =  *Blank
235200000000     C                   Eval      A_BESACL2   = *Blank
235300000000     C                   Eval      A_BESSRL1   = *Blank
235400000000     C                   Eval      A_BESSRL2   = *Blank
235500000000     C                   Eval      A_BESSRL3   = *Blank
235600000000     C                   Eval      A_BESFIN1   = *Blank
235700000000     C                   Eval      A_BESFIN2   = *Blank
235800000000     C                   Eval      A_BESRED1   = *Blank
235900000000     C                   Eval      A_BESRED2   = *Blank
236000000000     C                   Eval      A_BESNAL1   = *Blank
236100000000     C                   Eval      A_BESNAL2   = *Blank
236200000000     C                   Eval      A_BESIPYN   = *Blank
236300000000     C                   Eval      A_BDIPSN    = *Blank
236400000000     C                   Eval      A_BDIPNM    = *Blank
236500000000     C                   Eval      A_BDIPTN    = *Blank
236600000000     C                   Eval      A_BDIPSI    = *Blank
236700000000     C                   Eval      A_BESIPYL   = *Blank
236800000000     C                   Eval      A_BESCTYN   = *Blank
236900000000     C                   Eval      A_BESCTYL   = *Blank
237000000000     C                   Eval      A_BESSA1N   = *Blank
237100000000     C                   Eval      A_BDCZSN    = *Blank
237200000000     C                   Eval      A_BDCSNM    = *Blank
237300000000     C                   Eval      A_BDCSTN    = *Blank
237400000000     C                   Eval      A_BDCSSI    = *Blank
237500000000     C                   Eval      A_BESSA1L   = *Blank
237600000000     C                   Eval      A_BESSKAN   = *Blank
237700000000     C                   Eval      A_BDUSSN    = *Blank
237800000000     C                   Eval      A_BDUSNM    = *Blank
237900000000     C                   Eval      A_BDUSTN    = *Blank
238000000000     C                   Eval      A_BDUSSI    = *Blank
238100000000     C                   Eval      A_BESSKAL   = *Blank
238200000000     C                   Eval      A_BESCCTN   = *Blank
238300000000     C                   Eval      A_BDCCSN    = *Blank
238400000000     C                   Eval      A_BDCCNM    = *Blank
238500000000     C                   Eval      A_BDCCTN    = *Blank
238600000000     C                   Eval      A_BDCCSI    = *Blank
238700000000     C                   Eval      A_BESDCTL   = *Blank
238800000000     C                   Eval      A_BESRSSN   = *Blank
238900000000     C                   Eval      A_BDRSSN    = *Blank
239000000000     C                   Eval      A_BDRSNM    = *Blank
239100000000     C                   Eval      A_BDRSTN    = *Blank
239200000000     C                   Eval      A_BDRSSI    = *Blank
239300000000     C                   Eval      A_BESRSS1   = *Blank
239400000000     C                   Eval      A_BESRSS2   = *Blank
239500000000     C                   Eval      A_BESRSS3   = *Blank
239600000000     C                   Eval      A_BESRSS4   = *Blank
239700000000     C                   Eval      A_BESDSSN   = *Blank
239800000000     C                   Eval      A_BESDSS1   = *Blank
239900000000     C                   Eval      A_BESDSS2   = *Blank
240000000000     C                   Eval      A_BESDSS3   = *Blank
240100000000     C                   Eval      A_BESDSS4   = *Blank
240200000000     C                   Eval      A_BESBSSN   = *Blank
240300000000     C                   Eval      A_BESBSS1   = *Blank
240400000000     C                   Eval      A_BESBSS2   = *Blank
240500000000     C                   Eval      A_BESINVE   = *Blank
240600000000     C                   Eval      A_BDIOSN    = *Blank
240700000000     C                   Eval      A_BDIONM    = *Blank
240800000000     C                   Eval      A_BDIOTN    = *Blank
240900000000     C                   Eval      A_BDIOSI    = *Blank
241000000000     C                   Eval      A_BESIMMD1  = *Blank
241100000000     C                   Eval      A_BDI1SN    = *Blank
241200000000     C                   Eval      A_BDI1NM    = *Blank
241300000000     C                   Eval      A_BDI1TN    = *Blank
241400000000     C                   Eval      A_BDI1SI    = *Blank
241500000000     C                   Eval      A_BESIMSA1  = *Blank
241600000000     C                   Eval      A_BESIMMD2  = *Blank
241700000000     C                   Eval      A_BDI2SN    = *Blank
241800000000     C                   Eval      A_BDI2NM    = *Blank
241900000000     C                   Eval      A_BDI2TN    = *Blank
242000000000     C                   Eval      A_BDI2SI    = *Blank
242100000000     C                   Eval      A_BESIMSA2  =  *Blank
242200000000     C                   Eval      A_BESIMMD3  =  *Blank
242300000000     C                   Eval      A_BESIMSA3  =  *Blank
242400000000     C                   Eval      A_BESIMMD4   = *Blank
242500000000     C                   Eval      A_BESIMSA4   = *Blank
242600000000     C                   Eval      A_BESIMMD5   = *Blank
242700000000     C                   Eval      A_BESIMSA5   = *Blank
242800000000     C                   Eval      A_BESIMMD6   = *Blank
242900000000     C                   Eval      A_BESIMSA6   = *Blank
243000000000     C                   Eval      A_BESIMMD7   = *Blank
243100000000     C                   Eval      A_BESIMSA7   = *Blank
243200000000     C                   Eval      A_BESIMMD8   = *Blank
243300000000     C                   Eval      A_BESIMSA8   = *Blank
243400000000     C                   Eval      A_BESIMMD9   = *Blank
243500000000     C                   Eval      A_BESIMSA9   = *Blank
243600000000     C                   Eval      A_BESPSET    = *Blank
243700000000     C                   Eval      A_BDPSSN     = *Blank
243800000000     C                   Eval      A_BDPSNM     = *Blank
243900000000     C                   Eval      A_BDPSTN     = *Blank
244000000000     C                   Eval      A_BDPSSI     = *Blank
244100000000     C                   Eval      A_BESNAC1    = *Blank
244200000000     C                   Eval      A_BESNAC2    = *Blank
244300000000     C                   Eval      A_BESDIDN    = *Blank
244400000000     C                   Eval      A_BESDAD1    = *Blank
244500000000     C                   Eval      A_BESDAD2    = *Blank
244600000000     C                   Eval      A_BESDAD3    = *Blank
244700000000     C                   Eval      A_BESDAD4    = *Blank
244800000000     C                   Eval      A_BESDLIN   =  *Blank
244900000000     C                   Eval      A_BESQFIN   =  *Blank
245000000000     C                   Eval      A_BESPCLR   =  *Blank
245100000000     C                   Eval      A_DDCRSK    =  *Blank
245200000000     C                   Eval      A_DDLQPR    =  *Blank
245300000000     C                   Eval      A_DDITRN    =  *Blank
245400000000     C                   Eval      A_TMSP      =  *Blank
245500000000     C                   Eval      A_BDSPBS    =  *Blank
245600000000     C                   Eval      A_STBS      =  *Blank
245700000000     C                   Eval      A_PROT      =  *Blank
245800000000     C                   Eval      A_NMCY      =  *Blank
245900000000     C                   Eval      A_C1DI      =  *Blank
246000000000     C                   Eval      A_BVAUTH    =  *Blank
246100000000     C                   Eval      A_DDCPNR    = *Blank
246200000000     C                   Eval      A_DDTCTR    = *Blank
246300000000     C                   Eval      A_DDCFCT    = *Blank
246400000000     C                   Eval      A_ADDROUS   = *Blank
246500000000     C                   Eval      A_ADDROTS   = *Blank
246600000000     C                   Eval      A_ADDROUC   = *Blank
246700000000     C                   Eval      A_ADDROTC   = *Blank
246800000000     C                   Eval      A_BDDROUS   = *Blank
246900000000     C                   Eval      A_BDDROTS   = *Blank
247000000000     C                   Eval      A_BDDROUC   = *Blank
247100000000     C                   Eval      A_BDDROTC   = *Blank
247200000000     C                   Eval      A_DDSPXR   =  *Blank
247300000000     C                   Eval      A_DDSPMD   =  *Blank
247400000000     C                   Eval      A_DDWTAX   =  *Blank
247500000000     C                   Eval      A_BKEURO   =  *Blank
247600000000     C                   Eval      A_DDSTAT   =  *Blank
247700000000      *
247800000000      * Auto authorise indicator ???
247900000000     C                   Eval      A_DDAUTH   =  FNAUTH
248000000000     C                   Eval      A_SITP     =  *Blank
248100000000     C                   Eval      A_DDPRICN  =  *Blank
248200000000     C                   Eval      A_DDHACR   =  *Blank
248300000000     C                   Eval      A_DDTCSR   =  *Blank
248400000000     C                   Eval      A_DDDAYS   =  *Blank
248500000000     C                   Eval      A_DDFOID   =  *Blank
248600000000     C                   Eval      A_TQTAX    =  *Blank
248700000000     C                   Eval      A_TQSTAF   =  *Blank
248800000000     C                   Eval      A_TQCDTE   =  *Blank
248900000000      *
249000000000      * Auto authorise indicator
249100000000     C                   Eval      A_AUTH     =  FNAUTH
249200000000      *
249300000000      * Tof Fioller
249400000000     C                   Eval      A_TOFfil   =  *Blank
249500000000     C                   Endsr
249600000000      /Eject
249700000000      *****************************************************************
249800210604     C     FNDataD       Begsr
249900210604      *
250000210604     C                   Eval      FNsetup = ' '
250100210604      * ELement 1 for key 'UDFTRAD07'
250200210604      * ELement 2 for key 'UDFTRAD12'
250300210604      * ELement 3 for key 'UDFTRAD15'
250400210604     C                   OPEN      A1CONBL2
250500210604     C     FNudfE1       CHAIN     A1CONBPF                           99
250600210604     C     *IN99         IFEQ      *OFF
250700210604     C                   Eval      FNbrcaA(1) = FNBRCA
250800210604     C                   Eval      FNfoirA(1) = FNFOIR
250900210604     C                   Eval      FNsetup = 'Y'
251000210604     C                   END
251100210604     C     FNudfE2       CHAIN     A1CONBPF                           99
251200210604     C     *IN99         IFEQ      *OFF
251300210604     C                   Eval      FNbrcaA(2) = FNBRCA
251400210604     C                   Eval      FNfoirA(2) = FNFOIR
251500210604     C                   Eval      FNsetup = 'Y'
251600210604     C                   END
251700210604     C     FNudfE3       CHAIN     A1CONBPF                           99
251800210604     C     *IN99         IFEQ      *OFF
251900210604     C                   Eval      FNbrcaA(3) = FNBRCA
252000210604     C                   Eval      FNfoirA(3) = FNFOIR
252100210604     C                   Eval      FNsetup = 'Y'
252200210604     C                   END
252300210604     C                   CLOSE     A1CONBL2
252400210604     C                   Endsr
252500210604      /Eject
252600210604      *****************************************************************
252700000000
252800000000**  CPY@
252900000000(c) Misys International Banking Systems Ltd. 2001
